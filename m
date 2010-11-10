Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755489Ab0KJLb7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 06:31:59 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:61749 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752243Ab0KJLb6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 06:31:58 -0500
Subject: [PATCH] Fix implicit declaration of 'in_irq' in linux/highmem.h
To: linux-kernel@vger.kernel.org
From: Catalin Marinas <catalin.marinas@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Wed, 10 Nov 2010 11:31:45 +0000
Message-ID: <20101110113106.11019.13707.stgit@e102109-lin.cambridge.arm.com>
User-Agent: StGit/0.15-103-g0e84
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 10 Nov 2010 11:31:45.0222 (UTC) FILETIME=[DAC40660:01CB80CA]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 3e4d3af introduced the kmap_atomic_idx_push() function which
warns on in_irq() with CONFIG_DEBUG_HIGHMEM enabled. This patch includes
linux/hardirq.h for the in_irq definition.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andrew Morton <akpm@linux-foundation.org>
---

Please ignore if the patch has already been posted.

 include/linux/highmem.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/linux/highmem.h b/include/linux/highmem.h
index e913819..b676c58 100644
--- a/include/linux/highmem.h
+++ b/include/linux/highmem.h
@@ -5,6 +5,7 @@
 #include <linux/kernel.h>
 #include <linux/mm.h>
 #include <linux/uaccess.h>
+#include <linux/hardirq.h>
 
 #include <asm/cacheflush.h>
 

