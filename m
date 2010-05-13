Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754844Ab0EMVdo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 17:33:44 -0400
Received: from fifo99.com ([67.223.236.141]:33894 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751590Ab0EMVdm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 17:33:42 -0400
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 6)
From: Daniel Walker <dwalker@fifo99.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Matthew Garrett <mjg@redhat.com>, Brian Swetland <swetland@google.com>,
       Paul Walmsley <paul@pwsan.com>,
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
       Liam Girdwood <lrg@slimlogic.co.uk>, Greg KH <gregkh@suse.de>
In-Reply-To: <201005132327.16163.rjw@sisk.pl>
References: <1272667021-21312-1-git-send-email-arve@android.com>
	 <201005132311.26293.rjw@sisk.pl>
	 <1273785399.19100.98.camel@c-dwalke-linux.qualcomm.com>
	 <201005132327.16163.rjw@sisk.pl>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 13 May 2010 14:33:29 -0700
Message-ID: <1273786409.19100.104.camel@c-dwalke-linux.qualcomm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-05-13 at 23:27 +0200, Rafael J. Wysocki wrote:

> Because someone would have to remove suspend blockers (or rather wakelocks)
> from the drivers, test that they work correctly without suspend blockers and
> submit the modified versions.  Going forward, every party responsible for such
> a driver would have to maintain an out-of-tree version with suspend blockers
> (or wakelocks) anyway, so the incentive to do that is zero.

They should work without wakelock since wakelock are optional .. I mean
there's nothing in suspend blockers I've seen that indicates it's
required for some drivers to work. So it's just a matter of patching out
the wakelocks, with no need to re-test anything.

You get the driver mainlined, then maintain a small patch to add
wakelocks. Not hard at all , with lots of incentive to do so since you
don't have to maintain such a large block of code out of tree.

> Practically, as long as the opportunistic suspend is out of tree, there will be
> a _growing_ number of out-of-tree drivers out there, which is not acceptable
> in the long run.

I don't see why your saying that. These driver should work with out all
of this, which means they can get mainlined right now.

Daniel

