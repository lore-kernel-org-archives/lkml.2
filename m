Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758596Ab0EYBFS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 21:05:18 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:42566 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758310Ab0EYBFP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 21:05:15 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1005212226180.20028-100000@netrider.rowland.org>
References: <1274482015-30899-2-git-send-email-arve@android.com>
	 <Pine.LNX.4.44L0.1005212226180.20028-100000@netrider.rowland.org>
Date: Mon, 24 May 2010 18:05:14 -0700
Message-ID: <AANLkTikz2UcDv6BZQ9Hq2MdowuAK1y_PBBPPXMEkDmNa@mail.gmail.com>
Subject: Re: [PATCH 1/8] PM: Opportunistic suspend support.
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <len.brown@intel.com>,
       Pavel Machek <pavel@ucw.cz>, Randy Dunlap <rdunlap@xenotime.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <ak@linux.intel.com>,
       Cornelia Huck <cornelia.huck@de.ibm.com>, Tejun Heo <tj@kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Nigel Cunningham <nigel@tuxonice.net>, Ming Lei <tom.leiming@gmail.com>,
       Wu Fengguang <fengguang.wu@intel.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>, linux-doc@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/5/21 Alan Stern <stern@rowland.harvard.edu>:
> On Fri, 21 May 2010, [UTF-8] Arve Hjønnevåg wrote:
>
>> The first goal can be achieved either by using device runtime PM and
>> cpuidle to put all hardware into low-power states, transparently from
>> the user space point of view, or by suspending the whole system.
>> However, system suspend, in its current form, does not guarantee that
>> the events of interest will always be responded to, since wakeup
>> events (events that wake the CPU from idle and the system from
>> suspend) that occur right after initiating suspend will not be
>> processed until another possibly unrelated event wakes the system up
>> again.
>
> Minor point of clarification here.  I'm not requesting that the patch
> description be rewritten.  But this issue of lost wakeup events is more
> subtle than it appears.
>
> Wakeup events can be lost in at least three different ways:
>
>     1. A hardware signal (such as an IRQ) gets ignored.
>
>     2. The hardware event occurs, but without effect since the
>        kernel thread that would handle the event has been frozen.
>        The event just ends up sitting in a queue somewhere until
>        something else wakes up the system.
>
>     3. The hardware event occurs and the kernel handles it fully,
>        but the event propagates to userspace for further handling
>        and the user program is already frozen.
>
> 1 is a hardware configuration failure (for example, it might happen as
> a result of using edge-triggered IRQs instead of level-triggered) and
> is outside the scope of this discussion.
>
> 2 generally represents a failure of the core PM subsystem, or a failure
> of some other part of the kernel to use the PM core correctly.  In
> theory we should be able to fix such mistakes.  Right now I'm aware of
> at least one possible failure scenario that could be fixed fairly
> easily.
>
> 3 is the type of failure that suspend blockers were really meant to
> handle, particularly the userspace suspend-blocker API.
>
> IMO, we should strive to fix the existing type-2 failure modes.
> However it is worth pointing out that they are basically separate from
> the suspend-blocker mechanism.
>
> And it might be a good idea to point out somewhere in the patch
> descriptions that suspend blockers are really meant to handle type-3
> wakeup losses.
>

I don't see a big difference between 2 and 3. You can use suspend
blockers to handle either.

-- 
Arve Hjønnevåg
