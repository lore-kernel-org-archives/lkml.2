Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754848Ab2E1DkR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2012 23:40:17 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52186 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754041Ab2E1D3l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2012 23:29:41 -0400
Message-Id: <20120528031212.950319912@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 28 May 2012 04:13:15 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Dima Zavin <dima@android.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        =?ISO-8859-15?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [ 073/117] ARM: 7365/1: drop unused parameter from flush_cache_user_range
In-Reply-To: <20120528031202.829379252@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dima Zavin <dima@android.com>

commit 4542b6a0fa6b48d9ae6b41c1efeb618b7a221b2a upstream.

vma isn't used and flush_cache_user_range isn't a standard macro that
is used on several archs with the same prototype. In fact only unicore32
has a macro with the same name (with an identical implementation and no
in-tree users).

This is a part of a patch proposed by Dima Zavin (with Message-id:
1272439931-12795-1-git-send-email-dima@android.com) that didn't get
accepted.

Cc: Dima Zavin <dima@android.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/arm/include/asm/cacheflush.h |    2 +-
 arch/arm/kernel/traps.c           |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/include/asm/cacheflush.h b/arch/arm/include/asm/cacheflush.h
index d5d8d5c..1252a26 100644
--- a/arch/arm/include/asm/cacheflush.h
+++ b/arch/arm/include/asm/cacheflush.h
@@ -249,7 +249,7 @@ extern void flush_cache_page(struct vm_area_struct *vma, unsigned long user_addr
  * Harvard caches are synchronised for the user space address range.
  * This is used for the ARM private sys_cacheflush system call.
  */
-#define flush_cache_user_range(vma,start,end) \
+#define flush_cache_user_range(start,end) \
 	__cpuc_coherent_user_range((start) & PAGE_MASK, PAGE_ALIGN(end))
 
 /*
diff --git a/arch/arm/kernel/traps.c b/arch/arm/kernel/traps.c
index 7784547..55b2f3d 100644
--- a/arch/arm/kernel/traps.c
+++ b/arch/arm/kernel/traps.c
@@ -496,7 +496,7 @@ do_cache_op(unsigned long start, unsigned long end, int flags)
 		if (end > vma->vm_end)
 			end = vma->vm_end;
 
-		flush_cache_user_range(vma, start, end);
+		flush_cache_user_range(start, end);
 	}
 	up_read(&mm->mmap_sem);
 }


