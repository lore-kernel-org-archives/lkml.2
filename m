Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932610Ab0EMVr4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 17:47:56 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:61668 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932298Ab0EMVrw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 17:47:52 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 69.181.193.102
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/4DNZSb+mjc/3spV7wDcbq
Date: Thu, 13 May 2010 14:47:40 -0700
From: Tony Lindgren <tony@atomide.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Paul Walmsley <paul@pwsan.com>,
       Arve =?utf-8?B?SGrDuG5uZXbDpWc=?= <arve@android.com>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
       Kevin Hilman <khilman@deeprootsystems.com>, magnus.damm@gmail.com,
       "Theodore Ts'o" <tytso@mit.edu>, mark gross <mgross@linux.intel.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Geoff Smith <geoffx.smith@intel.com>,
       Brian Swetland <swetland@google.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Matthew Garrett <mjg@redhat.com>,
       =?utf-8?Q?Beno=C3=AEt?= Cousson <b-cousson@ti.com>,
       linux-omap@vger.kernel.org, Vitaly Wool <vitalywool@gmail.com>,
       Linus Walleij <linus.walleij@ericsson.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Liam Girdwood <lrg@slimlogic.co.uk>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 6)
Message-ID: <20100513214739.GM3428@atomide.com>
References: <20100513191717.GA3428@atomide.com>
 <Pine.LNX.4.44L0.1005131729510.1731-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1005131729510.1731-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Alan Stern <stern@rowland.harvard.edu> [100513 14:32]:
> On Thu, 13 May 2010, Tony Lindgren wrote:
> 
> > The difference between echo mem > /sys/power/state and suspend blocks
> > is that with suspend blocks the system keeps running.
> 
> Irrelevant.  Paul wasn't talking about the suspend blockers; he was 
> talking about opportunistic suspend.  So what's the difference between 
> opportunistic suspend and "echo mem >/sys/power/state"?  Especially 
> when suspend blockers aren't being used?

Opportunistic suspend is really trying to do runtime PM, see below.
 
> > And that's why 
> > it should be handled by runtime power management instead.
> 
> Runtime PM is not capable of freezing userspace and shutting down CPUs.  
> More or less by definition -- if it could then it wouldn't be "runtime" 
> any more, since the processor wouldn't be running.

Not true. We are already powering off CPUs and rebooting them for
at least omaps in every idle loop using cpuidle. The memory stays on.
 
> > The suspend blocks seems like a hack to spam filter good and bad
> > apps from timer usage point of view. Applications are categorized
> > as good or bad depending if they grab a susped blocker or not.
> 
> You're referring just to the userspace part of the suspend blocker 
> API.  What about the kernel part?

IMHO some timer flags should be used in the kernel too. Currently
there's no way of knowing which timers are good or bad from suspend
point of view.

Regards,

Tony 
