Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757401Ab2JYGnv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 02:43:51 -0400
Received: from mail1.windriver.com ([147.11.146.13]:36689 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752234Ab2JYGnu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 02:43:50 -0400
From: Tiejun Chen <tiejun.chen@windriver.com>
To: <benh@kernel.crashing.org>
CC: <jason.wessel@windriver.com>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/3] powerpc/book3e: support kgdb for kernel space
Date: Thu, 25 Oct 2012 14:43:29 +0800
Message-ID: <1351147410-17452-2-git-send-email-tiejun.chen@windriver.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1351147410-17452-1-git-send-email-tiejun.chen@windriver.com>
References: <1351147410-17452-1-git-send-email-tiejun.chen@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently we need to skip this for supporting KGDB.

Signed-off-by: Tiejun Chen <tiejun.chen@windriver.com>
---
 arch/powerpc/kernel/exceptions-64e.S |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/kernel/exceptions-64e.S b/arch/powerpc/kernel/exceptions-64e.S
index 43b654a..c5564d4 100644
--- a/arch/powerpc/kernel/exceptions-64e.S
+++ b/arch/powerpc/kernel/exceptions-64e.S
@@ -566,11 +566,14 @@ kernel_dbg_exc:
 	rfdi
 
 	/* Normal debug exception */
+1:
+#ifndef CONFIG_KGDB
 	/* XXX We only handle coming from userspace for now since we can't
 	 *     quite save properly an interrupted kernel state yet
 	 */
-1:	andi.	r14,r11,MSR_PR;		/* check for userspace again */
+	andi.	r14,r11,MSR_PR;		/* check for userspace again */
 	beq	kernel_dbg_exc;		/* if from kernel mode */
+#endif
 
 	/* Now we mash up things to make it look like we are coming on a
 	 * normal exception
-- 
1.7.9.5

