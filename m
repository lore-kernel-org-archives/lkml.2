Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756517Ab2EIRf6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 13:35:58 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:49157 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755542Ab2EIRf4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 13:35:56 -0400
Date: Wed, 9 May 2012 18:35:25 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Tejun Heo <tj@kernel.org>
Cc: Sami Liedes <sami.liedes@iki.fi>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Christoph Lameter <cl@linux-foundation.org>
Subject: Re: kmemleak: Cannot insert 0xffff880007fedd28 into the object
 search tree (already existing)
Message-ID: <20120509173525.GO11099@arm.com>
References: <20120506160828.GE13332@sli.dy.fi>
 <20120509155519.GL11099@arm.com>
 <20120509171642.GC24636@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120509171642.GC24636@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 09, 2012 at 06:16:42PM +0100, Tejun Heo wrote:
> git-am doesn't handle patches submitted this way.  Can you please put
> the patch title as $SUBJ and put patch description in the body
> followed by '---' for non-description comments?  Or is there some tool
> that I should be using instead?

I should have used git format-patch. Here it is again (if it still
doesn't work, I'll mail it to you separately).

-----------------------8<--------------------------

>From 631d16e6284ddecd9d261f929582244f6757b678 Mon Sep 17 00:00:00 2001
From: Catalin Marinas <catalin.marinas@arm.com>
Date: Wed, 9 May 2012 16:45:46 +0100
Subject: [PATCH] kmemleak: Fix the kmemleak tracking of the percpu areas with
 !SMP

Kmemleak tracks the percpu allocations via a specific API and the
originally allocated areas must be removed from kmemleak (via
kmemleak_free). The code was already doing this for SMP systems.

Reported-by: Sami Liedes <sami.liedes@iki.fi>
Cc: Tejun Heo <tj@kernel.org>
Cc: Christoph Lameter <cl@linux-foundation.org>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
---
 mm/percpu.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/mm/percpu.c b/mm/percpu.c
index f47af91..2daf6d5 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -1885,6 +1885,8 @@ void __init setup_per_cpu_areas(void)
 	fc = __alloc_bootmem(unit_size, PAGE_SIZE, __pa(MAX_DMA_ADDRESS));
 	if (!ai || !fc)
 		panic("Failed to allocate memory for percpu areas.");
+	/* kmemleak tracks the percpu allocations separately */
+	kmemleak_free(fc);
 
 	ai->dyn_size = unit_size;
 	ai->unit_size = unit_size;
