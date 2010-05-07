Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758524Ab0EGV0N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 17:26:13 -0400
Received: from mho-01-ewr.mailhop.org ([204.13.248.71]:50488 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758436Ab0EGV0L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 17:26:11 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 69.181.193.102
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/cl0BiZu7TiCrAJyKDRJ1V
Date: Fri, 7 May 2010 14:25:56 -0700
From: Tony Lindgren <tony@atomide.com>
To: Matthew Garrett <mjg@redhat.com>
Cc: Daniel Walker <dwalker@fifo99.com>, Brian Swetland <swetland@google.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       mark gross <mgross@linux.intel.com>, markgross@thegnar.org,
       Len Brown <len.brown@intel.com>, linux-doc@vger.kernel.org,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Oleg Nesterov <oleg@redhat.com>, Tejun Heo <tj@kernel.org>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [linux-pm] [PATCH 1/8] PM: Add suspend block api.
Message-ID: <20100507212556.GQ387@atomide.com>
References: <20100507182824.GA25198@srcf.ucam.org>
 <20100507184333.GL387@atomide.com>
 <20100507184621.GA25978@srcf.ucam.org>
 <1273259186.3542.93.camel@c-dwalke-linux.qualcomm.com>
 <20100507192837.GM387@atomide.com>
 <20100507193353.GA27175@srcf.ucam.org>
 <20100507195548.GN387@atomide.com>
 <20100507202859.GA27328@srcf.ucam.org>
 <20100507205329.GP387@atomide.com>
 <20100507210304.GA28701@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100507210304.GA28701@srcf.ucam.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Matthew Garrett <mjg@redhat.com> [100507 13:58]:
> On Fri, May 07, 2010 at 01:53:29PM -0700, Tony Lindgren wrote:
> 
> > So for example, if I leave ping running in a a terminal, do you
> > have some way of preventing that from eating the battery?
> 
> It depends on policy. If all network packets generate wakeup events then 
> no, that will carry on eating battery. If ICMP doesn't generate a wakeup 
> event then the process won't be run.
> 
> > Do you just suspend the whole system anyways at some point,
> > or do you have some other trick?
> 
> If nothing's holding any suspend blocks then the system will enter 
> suspend. If the packet generates a wakeup then the kernel would block 
> suspend until userspace has had the opportunity to do so. Once userspace 
> has handled the packet then it could release the block and the system 
> will immediately transition back into suspend.

OK, then what would I need to do to keep that ping running if I wanted to?

> Here's a different example. A process is waiting for a keypress, but 
> because it's badly written it's also drawing to the screen at 60 frames 
> per second and preventing the system from every going to idle. How do 
> you quiesce the system while still ensuring that the keypress will be 
> delivered to the application?

I guess it depends. If it's a game and I'm waiting to hit the fire
button, then I don't want the system to suspend!

It's starting to sound like you're really using suspend blocks
to "certify" that the app is safe to keep running.

Maybe it could be done with some kind of process flag instead that
would tell "this process is safe to keep running from timer point of view"
and if that flag is not set, then assume it's OK to stop the process
at any point?

Regards,

Tony
