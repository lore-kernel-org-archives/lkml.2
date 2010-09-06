Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753919Ab0IFOg0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 10:36:26 -0400
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:33533 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753338Ab0IFOgP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 10:36:15 -0400
Date: Mon, 6 Sep 2010 16:36:12 +0200
From: Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, Alexander Graf <agraf@suse.de>,
        "K.Prasad" <prasad@linux.vnet.ibm.com>,
        Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>, linux390@de.ibm.com,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org
Cc: vamos-dev@i4.informatik.uni-erlangen.de
Subject: [PATCH 04/14] arch/{s390,powerpc}: Removing undead ifdef __KERNEL__
Message-ID: <816d0f12ef97b609b367cfb7319792b95e0ad943.1283782701.git.qy03fugy@stud.informatik.uni-erlangen.de>
References: <cover.1283782698.git.qy03fugy@stud.informatik.uni-erlangen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1283782698.git.qy03fugy@stud.informatik.uni-erlangen.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The __KERNEL__ ifdef isn't necessary at this point, because it is
checked in an outer ifdef level already and has no effect here.

Signed-off-by: Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>
---
 arch/powerpc/include/asm/processor.h     |    2 --
 arch/powerpc/include/asm/vdso_datapage.h |    2 --
 arch/s390/include/asm/processor.h        |    4 ----
 3 files changed, 0 insertions(+), 8 deletions(-)

diff --git a/arch/powerpc/include/asm/processor.h b/arch/powerpc/include/asm/processor.h
index 19c05b0..3defd7a 100644
--- a/arch/powerpc/include/asm/processor.h
+++ b/arch/powerpc/include/asm/processor.h
@@ -122,7 +122,6 @@ extern struct task_struct *last_task_used_spe;
 		TASK_UNMAPPED_BASE_USER32 : TASK_UNMAPPED_BASE_USER64 )
 #endif
 
-#ifdef __KERNEL__
 #ifdef __powerpc64__
 
 #define STACK_TOP_USER64 TASK_SIZE_USER64
@@ -139,7 +138,6 @@ extern struct task_struct *last_task_used_spe;
 #define STACK_TOP_MAX	STACK_TOP
 
 #endif /* __powerpc64__ */
-#endif /* __KERNEL__ */
 
 typedef struct {
 	unsigned long seg;
diff --git a/arch/powerpc/include/asm/vdso_datapage.h b/arch/powerpc/include/asm/vdso_datapage.h
index 08679c5..25e3922 100644
--- a/arch/powerpc/include/asm/vdso_datapage.h
+++ b/arch/powerpc/include/asm/vdso_datapage.h
@@ -116,9 +116,7 @@ struct vdso_data {
 
 #endif /* CONFIG_PPC64 */
 
-#ifdef __KERNEL__
 extern struct vdso_data *vdso_data;
-#endif
 
 #endif /* __ASSEMBLY__ */
 
diff --git a/arch/s390/include/asm/processor.h b/arch/s390/include/asm/processor.h
index 73e2598..0e2a436 100644
--- a/arch/s390/include/asm/processor.h
+++ b/arch/s390/include/asm/processor.h
@@ -52,8 +52,6 @@ extern int get_cpu_capability(unsigned int *);
 
 #endif /* __s390x__ */
 
-#ifdef __KERNEL__
-
 #ifndef __s390x__
 #define STACK_TOP		(1UL << 31)
 #define STACK_TOP_MAX		(1UL << 31)
@@ -63,8 +61,6 @@ extern int get_cpu_capability(unsigned int *);
 #endif /* __s390x__ */
 
 
-#endif
-
 #define HAVE_ARCH_PICK_MMAP_LAYOUT
 
 typedef struct {
-- 
1.7.0.4

