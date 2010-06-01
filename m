Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756593Ab0FANqo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 09:46:44 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:45803 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756093Ab0FANqn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 09:46:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=QhqIItkCAreG0d17QvcuR9DXkTS8HKQItvGK8Ljer9njP07JDjtL4ZfD0WOgfgGQ6c
         pdhupa0S/0mGGpYZMukZELOW3R3fjDKbmfybZ5eFVPYRjJk5zy2j6ucL599FcaDB88nu
         9QvtPApJPV70RDqib8yGEGIh2c2cGxqw1k5CA=
Date: Tue, 1 Jun 2010 06:46:55 -0700
From: mark gross <640e9920@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Florian Mickler <florian@mickler.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Brian Swetland <swetland@google.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       markgross@thegnar.org
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
Message-ID: <20100601134655.GA1281@gvim.org>
Reply-To: markgross@thegnar.org
References: <AANLkTik_4ezDAQoAQjkpEgwD9SLKeOjDzy2H7T2v6uCP@mail.gmail.com>
 <Pine.LNX.4.44L0.1005292026080.6300-100000@netrider.rowland.org>
 <AANLkTikxws5kmFhnBO1MLzE65ETka3Jy0R5ayAKTS1Lc@mail.gmail.com>
 <201005312338.55109.rjw@sisk.pl>
 <20100531232617.GF31155@gvim.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100531232617.GF31155@gvim.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 31, 2010 at 04:26:17PM -0700, mark gross wrote:
> On Mon, May 31, 2010 at 11:38:55PM +0200, Rafael J. Wysocki wrote:
> > On Monday 31 May 2010, Arve Hjønnevåg wrote:
> > > 2010/5/29 Alan Stern <stern@rowland.harvard.edu>:
> > > > On Sat, 29 May 2010, Arve Hjønnevåg wrote:
> > > >
> > > >> > In place of in-kernel suspend blockers, there will be a new type of QoS
> > > >> > constraint -- call it QOS_EVENTUALLY.  It's a very weak constraint,
> > > >> > compatible with all cpuidle modes in which runnable threads are allowed
> > > >> > to run (which is all of them), but not compatible with suspend.
> > > >> >
> > > >> This sound just like another API rename. It will work, but given that
> > > >> suspend blockers was the name least objectionable last time around,
> > > >> I'm not sure what this would solve.
> > > >
> > > > It's not just a rename.  By changing this into a QoS constraint, we
> > > > make it more generally useful.  Instead of standing on its own, it
> > > > becomes part of the PM-QOS framework.
> > > >
> > > 
> > > We cannot use the existing pm-qos framework. It is not safe to call
> > > from atomic context.
> > 
> > We've just merged a patch that fixed that if I'm not mistaken.  Mark, did your
> > PM QoS update fix that?
> >
> 
> I'm pretty sure it can be called in atomic context, and if its not I'm
> sure we can fix that.  It can be called in atomic context.  I don't
> think it was ever a problem to call it in atomic context.  The problem it
> had was that crappy list of string compares.  Thats been fixed.
> 

um, the notifiers that are currently used may not be cool in atomic
context :(

--mgross



> --mgross
>  
> > > Also, it does not have any state constraints, so it iterates over every
> > > registered constraint each time one of them changes.
> > 
> > That's fixable IMO.
> > 
> > > Nor does is currently provide any stats for debugging.
> > 
> > That's why Alan is proposing to add that.
> > 
> > > The original wakelock patchset supported a wakelock type so it could
> > > be used to block more then suspend, but I had to remove this because
> > > it "overlapped" with pm-qos. So, yes I do consider this just another
> > > rename.
> > 
> > It's an extension of an existing framework rather than an addition of a new
> > one, with entirely new API and so on.  Extending existing APIs is much
> > preferred to adding new ones, in general.
> > 
> > Rafael
