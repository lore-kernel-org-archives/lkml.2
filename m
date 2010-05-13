Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932508Ab0EMVrH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 17:47:07 -0400
Received: from cantor.suse.de ([195.135.220.2]:59646 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754771Ab0EMVrF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 17:47:05 -0400
Date: Thu, 13 May 2010 14:46:53 -0700
From: Greg KH <gregkh@suse.de>
To: Daniel Walker <dwalker@fifo99.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Matthew Garrett <mjg@redhat.com>,
       Brian Swetland <swetland@google.com>, Paul Walmsley <paul@pwsan.com>,
       Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
       Tony Lindgren <tony@atomide.com>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       Alan Stern <stern@rowland.harvard.edu>, magnus.damm@gmail.com,
       "Theodore Ts'o" <tytso@mit.edu>, mark gross <mgross@linux.intel.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Geoff Smith <geoffx.smith@intel.com>,
       =?iso-8859-1?Q?Beno=EEt?= Cousson <b-cousson@ti.com>,
       linux-omap@vger.kernel.org, Vitaly Wool <vitalywool@gmail.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Liam Girdwood <lrg@slimlogic.co.uk>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 6)
Message-ID: <20100513214653.GA21120@suse.de>
References: <1272667021-21312-1-git-send-email-arve@android.com>
 <201005132311.26293.rjw@sisk.pl>
 <1273785399.19100.98.camel@c-dwalke-linux.qualcomm.com>
 <201005132327.16163.rjw@sisk.pl>
 <1273786409.19100.104.camel@c-dwalke-linux.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1273786409.19100.104.camel@c-dwalke-linux.qualcomm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 13, 2010 at 02:33:29PM -0700, Daniel Walker wrote:
> On Thu, 2010-05-13 at 23:27 +0200, Rafael J. Wysocki wrote:
> 
> > Because someone would have to remove suspend blockers (or rather wakelocks)
> > from the drivers, test that they work correctly without suspend blockers and
> > submit the modified versions.  Going forward, every party responsible for such
> > a driver would have to maintain an out-of-tree version with suspend blockers
> > (or wakelocks) anyway, so the incentive to do that is zero.
> 
> They should work without wakelock since wakelock are optional .. I mean
> there's nothing in suspend blockers I've seen that indicates it's
> required for some drivers to work. So it's just a matter of patching out
> the wakelocks, with no need to re-test anything.
> 
> You get the driver mainlined, then maintain a small patch to add
> wakelocks. Not hard at all , with lots of incentive to do so since you
> don't have to maintain such a large block of code out of tree.

Sorry, but it doesn't seem to work that way.  Look at the large number
of out-of-tree android device drivers that remain sitting there because
of the lack of this interface being in the kernel.

Also note that such a driver, without wakelocks, would never get tested,
and so, things start quickly diverging.

thanks,

greg k-h
