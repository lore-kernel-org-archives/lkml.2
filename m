Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758804Ab0EMV0Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 17:26:24 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:57122 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758673Ab0EMV0U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 17:26:20 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 69.181.193.102
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+H8pflgl0fXpLxbm5Vi4Io
Date: Thu, 13 May 2010 14:25:56 -0700
From: Tony Lindgren <tony@atomide.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Matthew Garrett <mjg@redhat.com>, Alan Stern <stern@rowland.harvard.edu>,
       Paul Walmsley <paul@pwsan.com>,
       Arve =?utf-8?B?SGrDuG5uZXbDpWc=?= <arve@android.com>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
       Kevin Hilman <khilman@deeprootsystems.com>, magnus.damm@gmail.com,
       "Theodore Ts'o" <tytso@mit.edu>, mark gross <mgross@linux.intel.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Geoff Smith <geoffx.smith@intel.com>,
       Brian Swetland <swetland@google.com>,
       =?utf-8?Q?Beno=C3=AEt?= Cousson <b-cousson@ti.com>,
       linux-omap@vger.kernel.org, Vitaly Wool <vitalywool@gmail.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Liam Girdwood <lrg@slimlogic.co.uk>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 6)
Message-ID: <20100513212556.GI3428@atomide.com>
References: <alpine.DEB.2.00.1005122118530.7624@utopia.booyaka.com>
 <20100513202320.GF3428@atomide.com>
 <20100513203412.GA21244@srcf.ucam.org>
 <201005132321.59245.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201005132321.59245.rjw@sisk.pl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Rafael J. Wysocki <rjw@sisk.pl> [100513 14:16]:
> On Thursday 13 May 2010, Matthew Garrett wrote:
> > On Thu, May 13, 2010 at 01:23:20PM -0700, Tony Lindgren wrote:
> > > * Matthew Garrett <mjg@redhat.com> [100513 13:03]:
> > > > On Thu, May 13, 2010 at 01:00:04PM -0700, Tony Lindgren wrote:
> > > > 
> > > > > The system stays running because there's something to do. The system
> > > > > won't suspend until all the processors hit the kernel idle loop and
> > > > > the next_timer_interrupt_critical() returns nothing.
> > > > 
> > > > At which point an application in a busy loop cripples you.
> > > 
> > > Maybe you could deal with the misbehaving untrusted apps in the userspace
> > > by sending kill -STOP to them when the screen blanks? Then continue
> > > when some event wakes up the system again.
> > 
> > And if that's the application that's listening to the network socket 
> > that you want to get a wakeup event from? This problem is hard. I'd love 
> > there to be an elegant solution based on using the scheduler, but I 
> > really don't know what it is.
> 
> I agree and I don't understand the problem that people have with the
> opportunistic suspend feature.

It seems to be picking quite a few comments for one.
 
> It solves a practical issue that _at_ _the_ _moment_ cannot be solved
> differently, while there's a growing number of out-of-tree drivers depending
> on this framework.  We need those drivers in and because we don't have any
> viable alternative at hand, we have no good reason to reject it.

Nothing is preventing merging the drivers can be merged without
these calls.

Regards,

Tony
