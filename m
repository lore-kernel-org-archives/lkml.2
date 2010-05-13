Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759465Ab0EMWBi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 18:01:38 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:38492 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753692Ab0EMWBe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 18:01:34 -0400
Date: Thu, 13 May 2010 18:01:33 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Tony Lindgren <tony@atomide.com>
cc: Paul Walmsley <paul@pwsan.com>,
       Arve =?utf-8?B?SGrDuG5uZXbDpWc=?= <arve@android.com>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
       Kevin Hilman <khilman@deeprootsystems.com>, <magnus.damm@gmail.com>,
       "Theodore Ts'o" <tytso@mit.edu>, mark gross <mgross@linux.intel.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Geoff Smith <geoffx.smith@intel.com>,
       Brian Swetland <swetland@google.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Matthew Garrett <mjg@redhat.com>,
       =?utf-8?Q?Beno=C3=AEt?= Cousson <b-cousson@ti.com>,
       <linux-omap@vger.kernel.org>, Vitaly Wool <vitalywool@gmail.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Liam Girdwood <lrg@slimlogic.co.uk>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 6)
In-Reply-To: <20100513214739.GM3428@atomide.com>
Message-ID: <Pine.LNX.4.44L0.1005131756420.1731-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 May 2010, Tony Lindgren wrote:

> > > And that's why 
> > > it should be handled by runtime power management instead.
> > 
> > Runtime PM is not capable of freezing userspace and shutting down CPUs.  
> > More or less by definition -- if it could then it wouldn't be "runtime" 
> > any more, since the processor wouldn't be running.
> 
> Not true. We are already powering off CPUs and rebooting them for
> at least omaps in every idle loop using cpuidle. The memory stays on.

Okay, that's a valid point.  But is that approach usable in general 
(i.e., on non-OMAP systems)?

How do you handle situations where the CPU is currently idle but an 
event (such as I/O completion) is expected to occur in the near future?  
You don't want to power-off and reboot then, do you?

Alan Stern

