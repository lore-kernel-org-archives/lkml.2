Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932530Ab2E0BBW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2012 21:01:22 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:37624 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932486Ab2E0BBS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2012 21:01:18 -0400
Message-Id: <20120527002622.064246018@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Sun, 27 May 2012 09:27:06 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Dima Zavin <dima@android.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Will Deacon <will.deacon@arm.com>
Subject: [ 53/55] ARM: 7365/1: drop unused parameter from flush_cache_user_range
In-Reply-To: <20120527005203.GA2146@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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
Cc: Will Deacon <will.deacon@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>


---
 arch/arm/include/asm/cacheflush.h |    2 +-
 arch/arm/kernel/traps.c           |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/arch/arm/include/asm/cacheflush.h
+++ b/arch/arm/include/asm/cacheflush.h
@@ -249,7 +249,7 @@ extern void flush_cache_page(struct vm_a
  * Harvard caches are synchronised for the user space address range.
  * This is used for the ARM private sys_cacheflush system call.
  */
-#define flush_cache_user_range(vma,start,end) \
+#define flush_cache_user_range(start,end) \
 	__cpuc_coherent_user_range((start) & PAGE_MASK, PAGE_ALIGN(end))
 
 /*
--- a/arch/arm/kernel/traps.c
+++ b/arch/arm/kernel/traps.c
@@ -451,7 +451,7 @@ do_cache_op(unsigned long start, unsigne
 		if (end > vma->vm_end)
 			end = vma->vm_end;
 
-		flush_cache_user_range(vma, start, end);
+		flush_cache_user_range(start, end);
 	}
 	up_read(&mm->mmap_sem);
 }


