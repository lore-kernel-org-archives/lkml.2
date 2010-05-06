Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759288Ab0EFRkE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 13:40:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29607 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759284Ab0EFRhk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 13:37:40 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: kernel-janitors@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux@arm.linux.org.uk,
       ysato@users.sourceforge.jp, tony.luck@intel.com, dhowells@redhat.com,
       kyle@mcmartin.ca, benh@kernel.crashing.org, schwidefsky@de.ibm.com,
       jgarzik@pobox.com, hare@suse.de, felipe.balbi@nokia.com,
       Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 05/13] s390: removing redundant ifdefs
Date: Thu,  6 May 2010 19:36:09 +0200
Message-Id: <1273167377-14270-6-git-send-email-jolsa@redhat.com>
In-Reply-To: <1273167377-14270-1-git-send-email-jolsa@redhat.com>
References: <1273167377-14270-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

wbr,
jirka


Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 arch/s390/include/asm/processor.h |    5 -----
 arch/s390/kernel/vdso.c           |    4 ----
 2 files changed, 0 insertions(+), 9 deletions(-)

diff --git a/arch/s390/include/asm/processor.h b/arch/s390/include/asm/processor.h
index 73e2598..ced1714 100644
--- a/arch/s390/include/asm/processor.h
+++ b/arch/s390/include/asm/processor.h
@@ -52,8 +52,6 @@ extern int get_cpu_capability(unsigned int *);
 
 #endif /* __s390x__ */
 
-#ifdef __KERNEL__
-
 #ifndef __s390x__
 #define STACK_TOP		(1UL << 31)
 #define STACK_TOP_MAX		(1UL << 31)
@@ -62,9 +60,6 @@ extern int get_cpu_capability(unsigned int *);
 #define STACK_TOP_MAX		(1UL << 42)
 #endif /* __s390x__ */
 
-
-#endif
-
 #define HAVE_ARCH_PICK_MMAP_LAYOUT
 
 typedef struct {
diff --git a/arch/s390/kernel/vdso.c b/arch/s390/kernel/vdso.c
index 6bc9c19..6b83870 100644
--- a/arch/s390/kernel/vdso.c
+++ b/arch/s390/kernel/vdso.c
@@ -102,11 +102,7 @@ static void vdso_init_per_cpu_data(int cpu, struct vdso_per_cpu_data *vpcd)
 /*
  * Allocate/free per cpu vdso data.
  */
-#ifdef CONFIG_64BIT
 #define SEGMENT_ORDER	2
-#else
-#define SEGMENT_ORDER	1
-#endif
 
 int vdso_alloc_per_cpu(int cpu, struct _lowcore *lowcore)
 {
-- 
1.6.6.1

