Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758778Ab0EMVle (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 17:41:34 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:34337 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751326Ab0EMVlc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 17:41:32 -0400
Date: Thu, 13 May 2010 17:41:31 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Tony Lindgren <tony@atomide.com>
cc: Matthew Garrett <mjg@redhat.com>, Paul Walmsley <paul@pwsan.com>,
       Arve =?utf-8?B?SGrDuG5uZXbDpWc=?= <arve@android.com>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
       Kevin Hilman <khilman@deeprootsystems.com>, <magnus.damm@gmail.com>,
       "Theodore Ts'o" <tytso@mit.edu>, mark gross <mgross@linux.intel.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Geoff Smith <geoffx.smith@intel.com>,
       Brian Swetland <swetland@google.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       =?utf-8?Q?Beno=C3=AEt?= Cousson <b-cousson@ti.com>,
       <linux-omap@vger.kernel.org>, Vitaly Wool <vitalywool@gmail.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Liam Girdwood <lrg@slimlogic.co.uk>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 6)
In-Reply-To: <20100513194205.GC3428@atomide.com>
Message-ID: <Pine.LNX.4.44L0.1005131740370.1731-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 May 2010, Tony Lindgren wrote:

> Well this is an interesting problem, and once solved will be handy
> for all kind of things. My worry is that if it's integrated in it's
> current form it will be totally out of control all over the place :(
> 
> Still hoping we can come up with some clean way that avoid the patching
> all over the place part.. How about the following, can you please check
> if it would help with your example of guaranteed handling of event:
> 
> 1. In the kernel, we add one more timer queue for critical timers.
>    The current timer queue(s) stay as it is.
> 
> 2. We allow selecting the timer based on some flag, the default
>    behaviour being the current default timer queue.
> 
> 3. Then we add next_timer_interupt_critical() to only query the
>    critical timers along the lines of the current next_timer_interrupt().
> 
> 4. We implement a custom pm_idle that suspends the system based on
>    some logic and checking if next_timer_interrupt_critical() is
>    empty. If the next_timer_interrupt_critical() does not return
>    anything, we assume it's OK to suspend the system.
> 
> Now to me it sounds if your the input layer and userspace handle
> both grab the timers with the critical flags, it should be guaranteed
> that the events get handled before the system is suspended.

Why do you want this to be tied to timers?  Many of the events in 
question are asynchronous with no specific timing relations.

Alan Stern

