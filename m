Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933088Ab1JDRGo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 13:06:44 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:46288 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932829Ab1JDRGn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 13:06:43 -0400
Date: Tue, 4 Oct 2011 18:06:29 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Tejun Heo <htejun@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Huajun Li <huajun.li.lee@gmail.com>,
        Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [PATCH 2/4] kmemleak: Handle percpu memory allocation
Message-ID: <20111004170628.GD13865@e102109-lin.cambridge.arm.com>
References: <20110929105940.10660.76130.stgit@e102109-lin.cambridge.arm.com>
 <20110929110228.10660.87600.stgit@e102109-lin.cambridge.arm.com>
 <20110929192818.GB10425@mtj.dyndns.org>
 <20111003152126.GM18195@e102109-lin.cambridge.arm.com>
 <20111004075915.GE15637@dhcp-172-17-108-109.mtv.corp.google.com>
 <20111004090446.GA10071@e102109-lin.cambridge.arm.com>
 <20111004091314.GF15637@dhcp-172-17-108-109.mtv.corp.google.com>
 <20111004092624.GB10071@e102109-lin.cambridge.arm.com>
 <20111004165958.GA18371@dhcp-172-17-108-109.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111004165958.GA18371@dhcp-172-17-108-109.mtv.corp.google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 04, 2011 at 05:59:58PM +0100, Tejun Heo wrote:
> Hello, Catalin.
> 
> On Tue, Oct 04, 2011 at 10:26:24AM +0100, Catalin Marinas wrote:
> > Before kmemleak is initialised we still get memory allocations that
> > kmemleak stores in an early_log buffer (via the log_early() function
> > called from kmemleak_alloc_percpu). Later when kmemleak has all the data
> > structures in place, the kmemleak_init() function goes through the
> > early_log array and replays the previously recorded requests. The
> > early_alloc_percpu() function is used during early_log replaying and it
> > indeed registers every percpu memory block but the early_log is always
> > O(#PCPU_ALLOCS).
> > 
> > The reason we don't call kmemleak_alloc_percpu() directly during
> > replaying is that early_alloc() also copies the previously recorded
> > stack trace into the newly created object (otherwise all early
> > allocations would be shown as done by kmemleak_init).
> 
> Ah, okay, I was misreading the patch.  For some reason, log_early()
> was nested inside for_each_possible_cpu(), but one other thing.
> kmemleak_free_percpu() is calling log_early() w/ KMEMLEAK_FREE.
> Shouldn't it be KMEMLEAK_FREE_PERCPU?

Good point, I updated the patch.

Thanks.

-- 
Catalin
