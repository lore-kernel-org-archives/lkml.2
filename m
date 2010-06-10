Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759936Ab0FJXn3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 19:43:29 -0400
Received: from hera.kernel.org ([140.211.167.34]:37064 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759918Ab0FJXn0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 19:43:26 -0400
Date: Thu, 10 Jun 2010 23:43:04 GMT
From: tip-bot for Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tglx@linutronix.de, hpa@linux.intel.com, bp@alien8.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, bp@alien8.de, hpa@linux.intel.com
In-Reply-To: <4C0F4B00.4090307@panasas.com>
References: <201005271944.09541.toralf.foerster@gmx.de>
	<4C0F4B00.4090307@panasas.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] um, hweight: Fix UML boot crash due to x86 optimized hweight
Message-ID: <tip-055c47272b8f5679d08ccc57efea3cb4aaeb5fc6@git.kernel.org>
Git-Commit-ID: 055c47272b8f5679d08ccc57efea3cb4aaeb5fc6
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 10 Jun 2010 23:43:05 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  055c47272b8f5679d08ccc57efea3cb4aaeb5fc6
Gitweb:     http://git.kernel.org/tip/055c47272b8f5679d08ccc57efea3cb4aaeb5fc6
Author:     Borislav Petkov <bp@alien8.de>
AuthorDate: Wed, 9 Jun 2010 11:04:16 +0300
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 10 Jun 2010 15:24:30 -0700

um, hweight: Fix UML boot crash due to x86 optimized hweight

Apparently UML cannot stomach callee reg-saving trickery
introduced with d61931d89be506372d01a90d1755f6d0a9fafe2d
(x86: Add optimized popcnt variants) and oopses during boot:
http://marc.info/?l=linux-kernel&m=127522065202435&w=2

Redirect arch_hweight.h include from the x86 portion to the generic
arch_hweight.h which is a fallback to the software hweight routines.

LKML-Reference: <201005271944.09541.toralf.foerster@gmx.de>
Signed-off-by: Borislav Petkov <bp@alien8.de>
LKML-Reference: <4C0F4B00.4090307@panasas.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/um/include/asm/arch_hweight.h |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/arch/um/include/asm/arch_hweight.h b/arch/um/include/asm/arch_hweight.h
new file mode 100644
index 0000000..c656cf4
--- /dev/null
+++ b/arch/um/include/asm/arch_hweight.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_UM_HWEIGHT_H
+#define _ASM_UM_HWEIGHT_H
+
+#include <asm-generic/bitops/arch_hweight.h>
+
+#endif
