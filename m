Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756864Ab0ENQsA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 12:48:00 -0400
Received: from fifo99.com ([67.223.236.141]:51584 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754081Ab0ENQr7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 12:47:59 -0400
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 6)
From: Daniel Walker <dwalker@fifo99.com>
To: Greg KH <gregkh@suse.de>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Matthew Garrett <mjg@redhat.com>,
       Brian Swetland <swetland@google.com>, Paul Walmsley <paul@pwsan.com>,
       Arve =?ISO-8859-1?Q?Hj=F8nnev=E5g?= <arve@android.com>,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
       Tony Lindgren <tony@atomide.com>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       Alan Stern <stern@rowland.harvard.edu>, magnus.damm@gmail.com,
       "Theodore Ts'o" <tytso@mit.edu>, mark gross <mgross@linux.intel.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Geoff Smith <geoffx.smith@intel.com>,
       =?ISO-8859-1?Q?Beno=EEt?= Cousson <b-cousson@ti.com>,
       linux-omap@vger.kernel.org, Vitaly Wool <vitalywool@gmail.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Liam Girdwood <lrg@slimlogic.co.uk>
In-Reply-To: <20100513214653.GA21120@suse.de>
References: <1272667021-21312-1-git-send-email-arve@android.com>
	 <201005132311.26293.rjw@sisk.pl>
	 <1273785399.19100.98.camel@c-dwalke-linux.qualcomm.com>
	 <201005132327.16163.rjw@sisk.pl>
	 <1273786409.19100.104.camel@c-dwalke-linux.qualcomm.com>
	 <20100513214653.GA21120@suse.de>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 14 May 2010 09:47:39 -0700
Message-ID: <1273855659.25594.29.camel@c-dwalke-linux.qualcomm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-05-13 at 14:46 -0700, Greg KH wrote:
> On Thu, May 13, 2010 at 02:33:29PM -0700, Daniel Walker wrote:
> > On Thu, 2010-05-13 at 23:27 +0200, Rafael J. Wysocki wrote:
> > 
> > > Because someone would have to remove suspend blockers (or rather wakelocks)
> > > from the drivers, test that they work correctly without suspend blockers and
> > > submit the modified versions.  Going forward, every party responsible for such
> > > a driver would have to maintain an out-of-tree version with suspend blockers
> > > (or wakelocks) anyway, so the incentive to do that is zero.
> > 
> > They should work without wakelock since wakelock are optional .. I mean
> > there's nothing in suspend blockers I've seen that indicates it's
> > required for some drivers to work. So it's just a matter of patching out
> > the wakelocks, with no need to re-test anything.
> > 
> > You get the driver mainlined, then maintain a small patch to add
> > wakelocks. Not hard at all , with lots of incentive to do so since you
> > don't have to maintain such a large block of code out of tree.
> 
> Sorry, but it doesn't seem to work that way.  Look at the large number
> of out-of-tree android device drivers that remain sitting there because
> of the lack of this interface being in the kernel.

I don't think that's due to this interface tho. During your CELF
presentation you noted several bits of code that could go in right now
but haven't (and still haven't as far as I've seen). I'm actively
pushing code related to Android (with wakelocks removed).. Putting a
wakelock contingency on everything to me doesn't make much sense.

> Also note that such a driver, without wakelocks, would never get tested,
> and so, things start quickly diverging.

That's not totally true. For example the MMC driver had wakelocks (I
think, or for sure mmc core does), and the MMC driver has been tested
for G1 and works fine so far without them. I have code that is queued
for my tree that will enable MMC on G1. I can merge Nexus one support
through my tree also which would allow all the drivers for that device
to eventually be used.

With that device support in mainline then those drivers become nice
things to have with or with out wakelocks. You don't need wakelocks to
run Debian or anything else except Android.

Daniel

