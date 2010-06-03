Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932869Ab0FCGEd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 02:04:33 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:43111 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932819Ab0FCGEb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 02:04:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=kwpTbeP576su9VTdm27rHVfC7w1hopwk7M1GWFdiZ2tNp5zx05XSxl2fyRolku2zyF
         jd8DMvB3cNmlGnUOTkJE+GJI67JBzODoGGGGIibdJrFGeIUg3pKNtcYUQURs/tX34keS
         QBNcFOR4TU4tTYw65wBpNQaO8SnVXfrhzjweQ=
Date: Wed, 2 Jun 2010 23:04:44 -0700
From: mark gross <640e9920@gmail.com>
To: Brian Swetland <swetland@google.com>
Cc: Neil Brown <neilb@suse.de>, Peter Zijlstra <peterz@infradead.org>,
       "Paul@smtp1.linux-foundation.org" <Paul@smtp1.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Florian Mickler <florian@mickler.org>,
       James Bottomley <James.Bottomley@suse.de>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Felipe Balbi <felipe.balbi@nokia.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [linux-pm] [PATCH] - race-free suspend. Was: Re: [PATCH 0/8]
 Suspend block api (version 8)
Message-ID: <20100603060444.GF11311@gvim.org>
Reply-To: markgross@thegnar.org
References: <20100601090023.788cabf4@notabene.brown>
 <201006010232.20263.rjw@sisk.pl>
 <20100601113309.609349fd@notabene.brown>
 <alpine.LFD.2.00.1006010340160.2933@localhost.localdomain>
 <20100601122012.1edeaf48@notabene.brown>
 <alpine.LFD.2.00.1006011243350.2933@localhost.localdomain>
 <20100602153235.340a7852@notabene.brown>
 <AANLkTikVjAf5nHdMx2bcHRAUSkq99s-b5YZCECXIJJLy@mail.gmail.com>
 <20100602180614.729246ea@notabene.brown>
 <AANLkTikXy__71nBNW0EFbyL_qNf0nQ68pW9KymWlTk7L@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTikXy__71nBNW0EFbyL_qNf0nQ68pW9KymWlTk7L@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 02, 2010 at 11:05:18AM -0700, Brian Swetland wrote:
> On Wed, Jun 2, 2010 at 1:06 AM, Neil Brown <neilb@suse.de> wrote:
> > On Wed, 2 Jun 2010 00:05:14 -0700
> > Arve Hjønnevåg <arve@android.com> wrote:
> >> > The user-space suspend daemon avoids losing wake-events by using
> >> > fcntl(F_OWNER) to ensure it gets a signal whenever any important wake-event
> >> > is ready to be read by user-space.  This may involve:
> >> >  - the one daemon processing all wake events
> >>
> >> Wake up events are not all processed by one daemon.
> >
> > Not with your current user-space code, no.  Are you saying that you are not
> > open to any significant change in the Android user-space code?  That would
> > make the situation a lot harder to resolve.
> 
> There are many wakeup events possible in a typical system --
> keypresses or other input events, network traffic, telephony events,
> media events (fill audio buffer, fill video decoder buffer, etc), and
> I think requiring that all wakeup event processing bottleneck through
> a single userspace process is non-optimal here.

Um doesn't the android framework bottleneck the user mode lock
processing through the powermanager and any wake up event processing
eventually has to grab a lock through this bottleneck anyway?

> 
> The current suspend-blocker proposal already involves userspace
> changes (it's different than our existing wakelock interface), and
> we're certainly not opposed to any/all userspace changes on principle,
> but on the other hand we're not interested in significant reworks of
> userspace unless they actually improve the situation somehow.  I think
> bottlenecking events through a central daemon would represent a step
> backwards.

I'm not sure its a step in any direction, but I do understand the
avoidance of having to rework a lot of code.

--mgross

