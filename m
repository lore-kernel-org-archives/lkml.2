Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755855Ab0LLXsF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 18:48:05 -0500
Received: from one.firstfloor.org ([213.235.205.2]:36619 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755757Ab0LLXsC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 18:48:02 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <201012131244.547034648@firstfloor.org>
In-Reply-To: <201012131244.547034648@firstfloor.org>
To: steve@digidescorp.com, gerg@snapgear.com, ak@linux.intel.com,
        kosaki.motohiro@jp.fujitsu.com, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, gregkh@suse.de,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [176/223] nommu: yield CPU while disposing VM
Message-Id: <20101212234801.1ED2AB27BF@basil.firstfloor.org>
Date: Mon, 13 Dec 2010 00:48:01 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Steven J. Magnani <steve@digidescorp.com>

commit 04c3496152394d17e3bc2316f9731ee3e8a026bc upstream.

Depending on processor speed, page size, and the amount of memory a
process is allowed to amass, cleanup of a large VM may freeze the system
for many seconds.  This can result in a watchdog timeout.

Make sure other tasks receive some service when cleaning up large VMs.

Signed-off-by: Steven J. Magnani <steve@digidescorp.com>
Cc: Greg Ungerer <gerg@snapgear.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 mm/nommu.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux/mm/nommu.c
===================================================================
--- linux.orig/mm/nommu.c
+++ linux/mm/nommu.c
@@ -1673,6 +1673,7 @@ void exit_mmap(struct mm_struct *mm)
 		mm->mmap = vma->vm_next;
 		delete_vma_from_mm(vma);
 		delete_vma(mm, vma);
+		cond_resched();
 	}
 
 	kleave("");
