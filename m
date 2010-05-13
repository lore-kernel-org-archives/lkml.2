Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755980Ab0EMVKc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 17:10:32 -0400
Received: from mho-01-ewr.mailhop.org ([204.13.248.71]:50949 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755074Ab0EMVKa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 17:10:30 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 69.181.193.102
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/YnQLvg+MVmAufIfxhUDvk
Date: Thu, 13 May 2010 14:10:06 -0700
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
Message-ID: <20100513211006.GG3428@atomide.com>
References: <alpine.DEB.2.00.1005122118530.7624@utopia.booyaka.com>
 <Pine.LNX.4.44L0.1005131002380.1695-100000@iolanthe.rowland.org>
 <20100513191717.GA3428@atomide.com>
 <20100513192522.GA19256@srcf.ucam.org>
 <20100513194205.GC3428@atomide.com>
 <20100513195349.GB19722@srcf.ucam.org>
 <20100513200003.GE3428@atomide.com>
 <20100513200814.GA20254@srcf.ucam.org>
 <20100513202320.GF3428@atomide.com>
 <20100513203412.GA21244@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100513203412.GA21244@srcf.ucam.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Matthew Garrett <mjg@redhat.com> [100513 13:29]:
> On Thu, May 13, 2010 at 01:23:20PM -0700, Tony Lindgren wrote:
> > * Matthew Garrett <mjg@redhat.com> [100513 13:03]:
> > > On Thu, May 13, 2010 at 01:00:04PM -0700, Tony Lindgren wrote:
> > > 
> > > > The system stays running because there's something to do. The system
> > > > won't suspend until all the processors hit the kernel idle loop and
> > > > the next_timer_interrupt_critical() returns nothing.
> > > 
> > > At which point an application in a busy loop cripples you.
> > 
> > Maybe you could deal with the misbehaving untrusted apps in the userspace
> > by sending kill -STOP to them when the screen blanks? Then continue
> > when some event wakes up the system again.
> 
> And if that's the application that's listening to the network socket 
> that you want to get a wakeup event from? This problem is hard. I'd love 
> there to be an elegant solution based on using the scheduler, but I 
> really don't know what it is.

Your system should wake up to an interrupt in that case. Then you have
the trusted apps running that can decide if the untrusted apps should
be continued or not.

The key would be to have the basic apps behave and use the critical
timers as needed. The advantage is that then you can do all the
policy in the userspace and in a custom pm_idle function.

Regards,

Tony
