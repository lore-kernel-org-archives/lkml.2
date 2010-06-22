Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758775Ab0FVBZG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 21:25:06 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:64240 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758711Ab0FVBZD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 21:25:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=OWeAFXnAzJCd5JwISXs06ibgvttdcravy1dwawfefietBUk6FkkC6B8o7+XYo1EplO
         2JG2k3D/KEX0udDV2gDJxOM6MbvVg7fc4j8F6W+aNzSRxjCmFfTUm7hX37pPZ8ioNKcY
         Lso8BrnxMEOhx8NjuC22i2vZAiLv4H+SgXE7A=
Date: Mon, 21 Jun 2010 18:25:19 -0700
From: mark gross <640e9920@gmail.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: markgross@thegnar.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
       Neil Brown <neilb@suse.de>, mark gross <640e9920@gmail.com>
Subject: Re: [RFC][PATCH] PM: Avoid losing wakeup events during suspend
Message-ID: <20100622012519.GB12795@gvim.org>
Reply-To: markgross@thegnar.org
References: <20100621061345.GF9735@gvim.org>
 <Pine.LNX.4.44L0.1006211158200.1687-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1006211158200.1687-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 21, 2010 at 12:01:09PM -0400, Alan Stern wrote:
> On Sun, 20 Jun 2010, mark gross wrote:
> 
> > Your confused about what problem this patch attempts to solve.
> 
> I don't think so.  Rafael's description was pretty clear.

Then how is it you don't understand the fact that Rafael's patch is to
solve the wake event notification suspend race and not block opertunistic
suspends or kernel critical sections where suspending should be disabled?

> 
> >  There is
> > a pm_qos patch in the works to address the suspend blocker
> > functionality.
> > http://lists.linux-foundation.org/pipermail/linux-pm/2010-June/026760.html
> 
> No.  That patch addresses something _similar_ to the suspend blocker
> functionality.  The fact remains, though, that pm_qos is not used
> during system suspend (the /sys/power/state interface), hence changes
> to pm_qos won't solve the system-suspend problems that suspend blockers 
> do solve.

You keep saying they solve something, I keep wondering what you are
talking aobut.
Lets see what problems it solves:
* implements oppertunistic suspending (this is a feature not a problem)
* enables kernel critical sections blocking suspending.
* requiers overlapping application specific critcal sections from ISR
into user mode to make implementation correct.
* exposes a user mode interface to set a critical section.
* reduces races between wake events (or suspend blocking events) but I'm
not convinced it solves them. 

suspend blockers provide a way to block oppertunistic suspending, wich
I'll have you know, is a pain to get working right and the enabling from
device to device is not very portable and *that* doesn't say good things
about the scheme.

--mgross
 
