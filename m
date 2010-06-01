Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756944Ab0FAOBL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 10:01:11 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:37600 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756822Ab0FAOBJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 10:01:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=ZI2ugYjMU4Omht1yVLuhbCasSIwYiolne8NLyIa8CwarIQjOe7mRO6aNOvW1A7l0nx
         lJqpahBQjQpn47ycEQ7LKKEK64lMk31BFA19OD7+fmFNNLPQDVgzsAdrF6sRykW/JyNC
         qjU67YBjshVintsIMaqd505td7dow4Vm2SsPc=
Date: Tue, 1 Jun 2010 07:01:20 -0700
From: mark gross <640e9920@gmail.com>
To: Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>
Cc: markgross@thegnar.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       mark.gross@intel.com, Neil Brown <neilb@suse.de>,
       Brian Swetland <swetland@google.com>, linux-kernel@vger.kernel.org,
       Arve@smtp1.linux-foundation.org, Thomas Gleixner <tglx@linutronix.de>,
       linux-pm@lists.linux-foundation.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [linux-pm] [RFC] lp_events: an lternitive to suspend blocker
 user mode and kernel API
Message-ID: <20100601140120.GB1281@gvim.org>
Reply-To: markgross@thegnar.org
References: <20100530200409.GA21632@gvim.org>
 <20100531095753.4c174f2d@notabene.brown>
 <20100531221035.GB31155@gvim.org>
 <201006010045.21382.rjw@sisk.pl>
 <20100601050914.GG31155@gvim.org>
 <AANLkTik4ixmtv5Ki7jds5gEspJAxBRAcJCR1Jv-V6ajR@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTik4ixmtv5Ki7jds5gEspJAxBRAcJCR1Jv-V6ajR@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 31, 2010 at 10:24:30PM -0700, Arve Hjønnevåg wrote:
> On Mon, May 31, 2010 at 10:09 PM, mark gross <640e9920@gmail.com> wrote:
> > On Tue, Jun 01, 2010 at 12:45:21AM +0200, Rafael J. Wysocki wrote:
> >> On Tuesday 01 June 2010, mark gross wrote:
> >> > On Mon, May 31, 2010 at 09:57:53AM +1000, Neil Brown wrote:
> >> ...
> >> > > So I would suggest modifying your proposal to simply create a new 'input'
> >> > > device.  Any driver that supports wake-from-suspend queues an event to that
> >> > > device when a wakeup event occurs.  If the device is open and has any queued
> >> > > events, then a suspend request such as 'echo mem > /sys/power/state' completes
> >> > > without going into full suspend.
> >> >
> >> > /me likes.
> >> >
> >> > > Then you just need to convince us that this mechanism can be used without any
> >> > > race problems.  If it can, then it would certainly be a simple and
> >> > > unobtrusive approach.
> >> >
> >> > Lets find out.
> >>
> >> Simple question: how is that better than the Alan Stern's proposed approach?
> >>
> > I just saw Alan Stern's proposal, and have gotten some input form some
> > others.  I can't say my patch represents a better Idea than what Alan
> > proposed.  However; what Alan (and Thomas) are talking about is
> > effectively the same as the kenrel mode wakelock/suspend blocker thing,
> > and although it reuses existing infrastructure, it doesn't solve the
> > problem of needing overlapping blocking sections of code from ISR to
> > user mode.
> >
> 
> I don't think your solution solves this either.

Why?  my proposal effectively removes the overlapping kernel blocking
sections uppon wake up by forcing the user mode to ack the wake event
and re-issue the suspend request explicitly.  That pretty much solves
that problem.

We can talk about whether or not it can be used effectively with Android
user mode PM or not, which I still think it can, but I need to try the
mods to power.c.

--mgross

 
> -- 
> Arve Hjønnevåg
