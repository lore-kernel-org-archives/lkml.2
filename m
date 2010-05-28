Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754151Ab0E1AGy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 20:06:54 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:58968 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752715Ab0E1AGw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 20:06:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=FPWyrFiuyPEZld1ZPK4xOllrokYX+qeR3/CeV19J57JGSBjUDF9axatIhkApQR1p1/
         jXr4wVlRpVN/tWtyOrPMo7G9mUTG76dOUB047LLKIx4OfSDv5fPK+AJIW7rUXoZXyOQr
         PQgQ87ePZnzY2QLJp7a6HmrsDW7M/1OvdJ/DA=
Date: Thu, 27 May 2010 17:06:47 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Matthew Garrett <mjg59@srcf.ucam.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Thomas Gleixner <tglx@linutronix.de>, Paul@smtp1.linux-foundation.org,
       LKML <linux-kernel@vger.kernel.org>,
       Florian Mickler <florian@mickler.org>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
Message-ID: <20100528000647.GB8645@core.coreip.homeip.net>
References: <Pine.LNX.4.44L0.1005271344040.3239-100000@iolanthe.rowland.org>
 <20100527181433.GG3543@srcf.ucam.org>
 <20100527200313.5c532f2f@lxorguk.ukuu.org.uk>
 <201005280110.17075.rjw@sisk.pl>
 <20100528005045.6ea5feba@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100528005045.6ea5feba@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 28, 2010 at 12:50:45AM +0100, Alan Cox wrote:
> > That's correct, but to me the Arve's goal is simply to maximize battery life
> > and he found experimentally that the longest battery life is achieved if
> > system suspend is used whenever the system doesn't need to be active (from its
> > user's perspective).  This actually is different from "when the system is
> > idle", because the system isn't idle, for example, when updatedb is running.
> > However, from the user's perspective the updatedb process doesn't really need
> > to run at this particular time, it can very well do it's job in parallel with
> > the user typing or reading news.  So, the system may very well be suspended
> > when updatedb is running.
> 
> This is where the original questions around QoS came in
> 
> > Since I think we've now rejected the feature, do we have a clear picture about
> > what the Android people should do _instead_ and yet keep the battery life they
> > want?  Because I don't think telling "let them do what they want, who cares"
> > is right.
> 
> Today "idle" means "no task running"
> 
> If you are prepared to rephrase that as "no task that matters is running"
> what would need to answer ?
> 
> - How do we define who matters: QoS ?
> 
> - Can you describe "idle" in terms of QoS without then breaking the
>   reliable wakeup for an event (and do you need to ?)
> 
> 	Could this for example look like
> 
> 	Set QoS of 'user apps' to QS_NONE
> 	Button pushed
> 	Button driver sets QoS of app it wakes to QS_ABOVESUSPEND
> 
> 	That would I think solve the reliable wakeup case although
> 	drivers raising a QoS parameter is a bit unusual in the kernel.
> 	That would at least however be specific to a few Android drivers
> 	and maybe a tiny amount of shared driver stuff so probably not
> 	unacceptable. (wake_up_pri(&queue, priority); isn't going to
> 	kill anyone is it - especially if it usually ignores the
> 	priority argument)

That should probably go into higher levels, not in individual drivers,
so we should be able to limit spreading of wake_up_pri() or whatever
throughout the tree.  This particular case should be probably handled by
evdev raising QoS of the user that is opened particular
/dev/input/eventX.

-- 
Dmitry
