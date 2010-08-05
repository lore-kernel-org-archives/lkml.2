Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933305Ab0HEO35 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 10:29:57 -0400
Received: from smtp-out.google.com ([216.239.44.51]:27387 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756867Ab0HEO3y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 10:29:54 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:x-system-of-record;
	b=lbVJ3HXjD+8samg6sF9WfJR6eex6vPGx24dJKUx3mPTeK2o5qM2JgWe8cu8o5ckaD
	L009aPir4y+6wg0CaKP+Q==
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1008050717260.25170@asgard.lang.hm>
References: <20100801054816.GI2470@linux.vnet.ibm.com>
	<20100804205654.GA4986@srcf.ucam.org>
	<AANLkTi=fH=XqJ0QgaMwPr5efacWAFo5h0khD7RjL4n8L@mail.gmail.com>
	<201008050220.51805.rjw@sisk.pl>
	<AANLkTikK+OCrg8Jx5SpTbg6iFDX12MKZrTsdOr4mRJN0@mail.gmail.com>
	<20100805134057.GB20565@srcf.ucam.org>
	<alpine.DEB.2.00.1008050717260.25170@asgard.lang.hm>
Date: Thu, 5 Aug 2010 07:29:51 -0700
Message-ID: <AANLkTik2VJewvER0WPwb5vKELq+S8_xqPsAiidc1aRCD@mail.gmail.com>
Subject: Re: Attempted summary of suspend-blockers LKML thread
From: Brian Swetland <swetland@google.com>
To: david@lang.hm
Cc: Matthew Garrett <mjg59@srcf.ucam.org>,
        =?UTF-8?B?QXJ2ZSBIasO4bm5ldsOlZw==?= <arve@android.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Arjan van de Ven <arjan@infradead.org>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        pavel@ucw.cz, florian@mickler.org, stern@rowland.harvard.edu,
        peterz@infradead.org, tglx@linutronix.de, alan@lxorguk.ukuu.org.uk
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 5, 2010 at 7:22 AM,  <david@lang.hm> wrote:
>
> Ok, it is now sounding to me like there are two different (but somewhat
> related) purposes that wakelocks are being used for
>
> 1. deciding if the system should go to sleep now or not (what most of the
> discussion has been about)
>
> 2. narrowing the race between going to sleep and wakeup events.
>
> I'm not sure it's possible to completely eliminate the race, even with
> wakelocks there is some time between the time you last check if the wakelock
> is set and when the hardware finishes responding to your commands to go to
> sleep (Unless you can set a level-based interrupt that will wake you up as
> soon as you finish going to sleep)

The transition into sleep is race-free in the wakelock model -- either
the wakeup event happens during the kernel suspend (and grabs a
wakelock), in which case suspend is aborted (and not attempted again
until there are once again no more wakelocks held), or the system
fully suspends to its lowest power mode until a wakeup event brings it
back out again.  Entry to lowest power mode must abort if a wakeup
event/interrupt occurs while it's in process -- exactly how the
handoff happens here is hardware dependent but in practice this is
doable on just about any modern system.

Brian
