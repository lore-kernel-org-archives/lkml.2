Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758527Ab0EMVVJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 17:21:09 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:54460 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753389Ab0EMVVC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 17:21:02 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Matthew Garrett <mjg@redhat.com>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 6)
Date: Thu, 13 May 2010 23:21:59 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34-rc7-rjw; KDE/4.3.5; x86_64; ; )
Cc: Tony Lindgren <tony@atomide.com>, Alan Stern <stern@rowland.harvard.edu>,
       Paul Walmsley <paul@pwsan.com>,
       Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>,
       "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
       Kevin Hilman <khilman@deeprootsystems.com>, magnus.damm@gmail.com,
       "Theodore Ts'o" <tytso@mit.edu>, mark gross <mgross@linux.intel.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Geoff Smith <geoffx.smith@intel.com>,
       Brian Swetland <swetland@google.com>,
       =?iso-8859-1?q?Beno=EEt_Cousson?= <b-cousson@ti.com>,
       linux-omap@vger.kernel.org, Vitaly Wool <vitalywool@gmail.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Liam Girdwood <lrg@slimlogic.co.uk>
References: <alpine.DEB.2.00.1005122118530.7624@utopia.booyaka.com> <20100513202320.GF3428@atomide.com> <20100513203412.GA21244@srcf.ucam.org>
In-Reply-To: <20100513203412.GA21244@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201005132321.59245.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 13 May 2010, Matthew Garrett wrote:
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

I agree and I don't understand the problem that people have with the
opportunistic suspend feature.

It solves a practical issue that _at_ _the_ _moment_ cannot be solved
differently, while there's a growing number of out-of-tree drivers depending
on this framework.  We need those drivers in and because we don't have any
viable alternative at hand, we have no good reason to reject it.

Rafael
