Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759574Ab0EMW1b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 18:27:31 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:54863 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753228Ab0EMW13 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 18:27:29 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Tony Lindgren <tony@atomide.com>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 6)
Date: Fri, 14 May 2010 00:28:49 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34-rc7-rjw; KDE/4.3.5; x86_64; ; )
Cc: Alan Stern <stern@rowland.harvard.edu>, Paul Walmsley <paul@pwsan.com>,
       Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>,
       "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
       Kevin Hilman <khilman@deeprootsystems.com>, magnus.damm@gmail.com,
       "Theodore Ts'o" <tytso@mit.edu>, mark gross <mgross@linux.intel.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Geoff Smith <geoffx.smith@intel.com>,
       Brian Swetland <swetland@google.com>, Matthew Garrett <mjg@redhat.com>,
       =?iso-8859-1?q?Beno=EEt_Cousson?= <b-cousson@ti.com>,
       linux-omap@vger.kernel.org, Vitaly Wool <vitalywool@gmail.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Liam Girdwood <lrg@slimlogic.co.uk>
References: <20100513214739.GM3428@atomide.com> <Pine.LNX.4.44L0.1005131756420.1731-100000@iolanthe.rowland.org> <20100513220814.GP3428@atomide.com>
In-Reply-To: <20100513220814.GP3428@atomide.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201005140028.49443.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 14 May 2010, Tony Lindgren wrote:
> * Alan Stern <stern@rowland.harvard.edu> [100513 14:56]:
> > On Thu, 13 May 2010, Tony Lindgren wrote:
> > 
> > > > > And that's why 
> > > > > it should be handled by runtime power management instead.
> > > > 
> > > > Runtime PM is not capable of freezing userspace and shutting down CPUs.  
> > > > More or less by definition -- if it could then it wouldn't be "runtime" 
> > > > any more, since the processor wouldn't be running.
> > > 
> > > Not true. We are already powering off CPUs and rebooting them for
> > > at least omaps in every idle loop using cpuidle. The memory stays on.
> > 
> > Okay, that's a valid point.  But is that approach usable in general 
> > (i.e., on non-OMAP systems)?
> 
> Yes if your system wakes to interrupts at least. If your system does
> not wake to timer events, then you'll get missed timers. So it should
> work on PC too with CONFIG_NO_HZ and if RTC was used for the timer
> wake event.
>  
> > How do you handle situations where the CPU is currently idle but an 
> > event (such as I/O completion) is expected to occur in the near future?  
> > You don't want to power-off and reboot then, do you?
> 
> The idle code looks at next_timer_interrupt() value, then if the
> next timer event if far enough ahead, the system powers down and
> wakes to the timer interrupt. It also wakes to device interrupts.

For the record, waking to interrupts doesn't work on quite some systems
(like ACPI-based PCs for one example).

Rafael
