Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759441Ab0EMWCo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 18:02:44 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:54712 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756189Ab0EMWCm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 18:02:42 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Tony Lindgren <tony@atomide.com>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 6)
Date: Fri, 14 May 2010 00:04:02 +0200
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
       Linus Walleij <linus.walleij@ericsson.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Liam Girdwood <lrg@slimlogic.co.uk>
References: <20100513191717.GA3428@atomide.com> <Pine.LNX.4.44L0.1005131729510.1731-100000@iolanthe.rowland.org> <20100513214739.GM3428@atomide.com>
In-Reply-To: <20100513214739.GM3428@atomide.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201005140004.02456.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 13 May 2010, Tony Lindgren wrote:
> * Alan Stern <stern@rowland.harvard.edu> [100513 14:32]:
> > On Thu, 13 May 2010, Tony Lindgren wrote:
> > 
> > > The difference between echo mem > /sys/power/state and suspend blocks
> > > is that with suspend blocks the system keeps running.
> > 
> > Irrelevant.  Paul wasn't talking about the suspend blockers; he was 
> > talking about opportunistic suspend.  So what's the difference between 
> > opportunistic suspend and "echo mem >/sys/power/state"?  Especially 
> > when suspend blockers aren't being used?
> 
> Opportunistic suspend is really trying to do runtime PM, see below.

NO, IT IS NOT!  What it does is to detect situations in which it is desirable
to put the _entire_ _system_ to sleep, while runtime PM works on a per-device
basis.

> > > And that's why 
> > > it should be handled by runtime power management instead.
> > 
> > Runtime PM is not capable of freezing userspace and shutting down CPUs.  
> > More or less by definition -- if it could then it wouldn't be "runtime" 
> > any more, since the processor wouldn't be running.
> 
> Not true. We are already powering off CPUs and rebooting them for
> at least omaps in every idle loop using cpuidle. The memory stays on.

What about user space, though?  Do you freeze it?

> > > The suspend blocks seems like a hack to spam filter good and bad
> > > apps from timer usage point of view. Applications are categorized
> > > as good or bad depending if they grab a susped blocker or not.
> > 
> > You're referring just to the userspace part of the suspend blocker 
> > API.  What about the kernel part?
> 
> IMHO some timer flags should be used in the kernel too. Currently
> there's no way of knowing which timers are good or bad from suspend
> point of view.

How is that answering the Alan's question?

Rafael
