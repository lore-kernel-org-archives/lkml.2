Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753811Ab2DAUlk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2012 16:41:40 -0400
Received: from mail.windriver.com ([147.11.1.11]:54107 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752749Ab2DAUjA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2012 16:39:00 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: dhowells@redhat.com
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-next@vger.kernel.org,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [PATCH 02/11] ARM: mach-msm: fix compile fail from system.h fallout
Date: Sun,  1 Apr 2012 16:38:38 -0400
Message-Id: <1333312727-11428-3-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.1
In-Reply-To: <1333312727-11428-1-git-send-email-paul.gortmaker@windriver.com>
References: <1333312727-11428-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To fix:

  In file included from arm/boot/compressed/misc.c:28:0:
  arm/mach-msm/include/mach/uncompress.h: In function 'putc':
  arch/arm/mach-msm/include/mach/uncompress.h:48:3: error: implicit
  declaration of function 'smp_mb' [-Werror=implicit-function-declaration]

The putc does a cpu_relax which for this platform is smp_mb.

Bisect indicates the 1st failing commit as:

    commit 0195c00244dc2e9f522475868fa278c473ba7339
    "Merge tag 'split-asm_system_h-for-linus-20120328' ..."

Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 arch/arm/mach-msm/include/mach/uncompress.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-msm/include/mach/uncompress.h b/arch/arm/mach-msm/include/mach/uncompress.h
index 169a840..c14011f 100644
--- a/arch/arm/mach-msm/include/mach/uncompress.h
+++ b/arch/arm/mach-msm/include/mach/uncompress.h
@@ -16,6 +16,7 @@
 #ifndef __ASM_ARCH_MSM_UNCOMPRESS_H
 #define __ASM_ARCH_MSM_UNCOMPRESS_H
 
+#include <asm/barrier.h>
 #include <asm/processor.h>
 #include <mach/msm_iomap.h>
 
-- 
1.7.9.1

