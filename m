Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932748Ab0EMUAc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 16:00:32 -0400
Received: from mho-01-ewr.mailhop.org ([204.13.248.71]:60532 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932121Ab0EMUA0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 16:00:26 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 69.181.193.102
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18dnVf0ylQ8KyPuI9s+hGuD
Date: Thu, 13 May 2010 13:00:04 -0700
From: Tony Lindgren <tony@atomide.com>
To: Matthew Garrett <mjg@redhat.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Paul Walmsley <paul@pwsan.com>,
       Arve =?utf-8?B?SGrDuG5uZXbDpWc=?= <arve@android.com>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
       Kevin Hilman <khilman@deeprootsystems.com>, magnus.damm@gmail.com,
       "Theodore Ts'o" <tytso@mit.edu>, mark gross <mgross@linux.intel.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Geoff Smith <geoffx.smith@intel.com>,
       Brian Swetland <swetland@google.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       =?utf-8?Q?Beno=C3=AEt?= Cousson <b-cousson@ti.com>,
       linux-omap@vger.kernel.org, Vitaly Wool <vitalywool@gmail.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Liam Girdwood <lrg@slimlogic.co.uk>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 6)
Message-ID: <20100513200003.GE3428@atomide.com>
References: <alpine.DEB.2.00.1005122118530.7624@utopia.booyaka.com>
 <Pine.LNX.4.44L0.1005131002380.1695-100000@iolanthe.rowland.org>
 <20100513191717.GA3428@atomide.com>
 <20100513192522.GA19256@srcf.ucam.org>
 <20100513194205.GC3428@atomide.com>
 <20100513195349.GB19722@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100513195349.GB19722@srcf.ucam.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Matthew Garrett <mjg@redhat.com> [100513 12:49]:
> On Thu, May 13, 2010 at 12:42:05PM -0700, Tony Lindgren wrote:
> 
> > 1. In the kernel, we add one more timer queue for critical timers.
> >    The current timer queue(s) stay as it is.
> > 
> > 2. We allow selecting the timer based on some flag, the default
> >    behaviour being the current default timer queue.
> > 
> > 3. Then we add next_timer_interupt_critical() to only query the
> >    critical timers along the lines of the current next_timer_interrupt().
> > 
> > 4. We implement a custom pm_idle that suspends the system based on
> >    some logic and checking if next_timer_interrupt_critical() is
> >    empty. If the next_timer_interrupt_critical() does not return
> >    anything, we assume it's OK to suspend the system.
> 
> Ok. So we stick the untrusted bits of userspace on the critical timer 
> list.

I guess you mean the trusted instead of untrusted apps in the userspace
above, the ones that are critical to keep running.

> Now we get a network packet that generates a wakeup event and gets 
> read by an application. What happens if that application can't fully 
> process the packet in a single timeslice?

The system stays running because there's something to do. The system
won't suspend until all the processors hit the kernel idle loop and
the next_timer_interrupt_critical() returns nothing.

Regards,

Tony
