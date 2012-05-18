Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946910Ab2ERXOA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 19:14:00 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:58844 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946701Ab2ERXGp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 19:06:45 -0400
Message-Id: <20120518212650.913914766@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 18 May 2012 14:27:08 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Sami Liedes <sami.liedes@iki.fi>,
        Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@linux-foundation.org>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: [ 19/47] kmemleak: Fix the kmemleak tracking of the percpu areas with !SMP
In-Reply-To: <20120518212701.GA5023@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Catalin Marinas <catalin.marinas@arm.com>

commit 100d13c3b5b9410f604b86f5e0a34da64b8cf659 upstream.

Kmemleak tracks the percpu allocations via a specific API and the
originally allocated areas must be removed from kmemleak (via
kmemleak_free). The code was already doing this for SMP systems.

Reported-by: Sami Liedes <sami.liedes@iki.fi>
Cc: Tejun Heo <tj@kernel.org>
Cc: Christoph Lameter <cl@linux-foundation.org>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/percpu.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -1895,6 +1895,8 @@ void __init setup_per_cpu_areas(void)
 	fc = __alloc_bootmem(unit_size, PAGE_SIZE, __pa(MAX_DMA_ADDRESS));
 	if (!ai || !fc)
 		panic("Failed to allocate memory for percpu areas.");
+	/* kmemleak tracks the percpu allocations separately */
+	kmemleak_free(fc);
 
 	ai->dyn_size = unit_size;
 	ai->unit_size = unit_size;


