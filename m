Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756663Ab3AHP2j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 10:28:39 -0500
Received: from mga01.intel.com ([192.55.52.88]:39804 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756613Ab3AHP2i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 10:28:38 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,432,1355126400"; 
   d="scan'208";a="271323668"
Date: Tue, 8 Jan 2013 23:29:18 +0800
From: Yuanhan Liu <yuanhan.liu@linux.intel.com>
To: Ulrich Windl <Ulrich.Windl@rz.uni-regensburg.de>
Cc: linux-kernel@vger.kernel.org, Mike Christie <michaelc@cs.wisc.edu>,
        iscsi list <open-iscsi@googlegroups.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        Stefani Seibold <stefani@seibold.net>
Subject: Re: Antw: [PATCH 0/5] kfifo cleanup and log based kfifo API
Message-ID: <20130108152918.GA304@yliu-dev.sh.intel.com>
References: <1357657073-27352-1-git-send-email-yuanhan.liu@linux.intel.com>
 <50EC4345020000A10000E5D1@gwsmtp1.uni-regensburg.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50EC4345020000A10000E5D1@gwsmtp1.uni-regensburg.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 08, 2013 at 04:03:17PM +0100, Ulrich Windl wrote:
> >>> Yuanhan Liu <yuanhan.liu@linux.intel.com> schrieb am 08.01.2013 um 15:57 in
> Nachricht <1357657073-27352-1-git-send-email-yuanhan.liu@linux.intel.com>:
> 
> [...]
> > My proposal is to replace kfifo_init with kfifo_alloc, where it
> > allocate buffer and maintain fifo size inside kfifo. Then we can
> > remove buggy kfifo_init.
> [...]
> 
> Spontaneously I feel that emitting a critical message if the requested size is not a power of two would be a good idea,

Hi Ulrich,

If we can emit all such critical message at compile time, it would
be good then. But we can't, as fifo size is runtime determinated in
quite many cases.

> as well as (in that case) rounding up to the next power of two instead of rounding down seems not too stupid ;-)

There are 2 issues, first, you just can't round the fifo size up to
power of 2 for kfifo_init as fifo buffer is allocated outside. And if
you do, you may access memory outside the buffer.

Second, round up to power of 2 inside kfifo_alloc and DECLARE_KFIFO is
simple and should work. But it wastes memory(by allocating more memory)
without notifing caller.

So, per discussed with Stefani, we better to change the API be log aware
to root fix this kind of potential issue.


Thanks.

	--yliu
