Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758108Ab0EMV0N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 17:26:13 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:54493 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751424Ab0EMV0J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 17:26:09 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Daniel Walker <dwalker@fifo99.com>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 6)
Date: Thu, 13 May 2010 23:27:16 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34-rc7-rjw; KDE/4.3.5; x86_64; ; )
Cc: Matthew Garrett <mjg@redhat.com>, Brian Swetland <swetland@google.com>,
       Paul Walmsley <paul@pwsan.com>,
       Arve =?utf-8?q?Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
       Tony Lindgren <tony@atomide.com>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       Alan Stern <stern@rowland.harvard.edu>, magnus.damm@gmail.com,
       "Theodore Ts'o" <tytso@mit.edu>, mark gross <mgross@linux.intel.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Geoff Smith <geoffx.smith@intel.com>,
       =?utf-8?q?Beno=C3=AEt_Cousson?= <b-cousson@ti.com>,
       linux-omap@vger.kernel.org, Vitaly Wool <vitalywool@gmail.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Liam Girdwood <lrg@slimlogic.co.uk>, Greg KH <gregkh@suse.de>
References: <1272667021-21312-1-git-send-email-arve@android.com> <201005132311.26293.rjw@sisk.pl> <1273785399.19100.98.camel@c-dwalke-linux.qualcomm.com>
In-Reply-To: <1273785399.19100.98.camel@c-dwalke-linux.qualcomm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201005132327.16163.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 13 May 2010, Daniel Walker wrote:
> On Thu, 2010-05-13 at 23:11 +0200, Rafael J. Wysocki wrote:
> > On Thursday 13 May 2010, Matthew Garrett wrote:
> > > On Thu, May 13, 2010 at 12:36:34PM -0700, Daniel Walker wrote:
> > > > On Thu, 2010-05-13 at 20:11 +0100, Matthew Garrett wrote:
> > > > > See feature-removal-schedule.txt. So far we have no indication that it's 
> > > > > going to be replaced, because nobody has actually suggested a working 
> > > > > way to do this better. If we had a concrete implementation proposal for 
> > > > > that then we'd be in a pretty different position right now.
> > > > 
> > > > Ok, feature-removal-schedule.txt applies to everything tho. What your
> > > > saying is that if this interface only last a short time it might take 6
> > > > months, if it last for a long time it would take longer. There's no easy
> > > > way to know that Google is the only user after some amount of time
> > > > passes.
> > > 
> > > If the interface is there for a long time, it's because we haven't come 
> > > up with anything better. And if we haven't come up with anything better, 
> > > the interface deserves to be there.
> > 
> > Moreover, the interface is already in use out-of-tree and that usage is
> > actually _growing_, so we have a growing number of out-of-tree drivers that
> > aren't megrgeable for this very reason.
> 
> Why can't we merge the drivers? Drivers are just drivers, they don't
> need this to get merged. (They need it to work with Android)

Because someone would have to remove suspend blockers (or rather wakelocks)
from the drivers, test that they work correctly without suspend blockers and
submit the modified versions.  Going forward, every party responsible for such
a driver would have to maintain an out-of-tree version with suspend blockers
(or wakelocks) anyway, so the incentive to do that is zero.

Practically, as long as the opportunistic suspend is out of tree, there will be
a _growing_ number of out-of-tree drivers out there, which is not acceptable
in the long run.

Rafael
