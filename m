Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757553Ab0HCSWr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 14:22:47 -0400
Received: from mail3.caviumnetworks.com ([12.108.191.235]:19458 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757529Ab0HCSWp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 14:22:45 -0400
From: David Daney <ddaney@caviumnetworks.com>
To: linux-mips@linux-mips.org, ralf@linux-mips.org, ananth@in.ibm.com,
        anil.s.keshavamurthy@intel.com, davem@davemloft.net,
        masami.hiramatsu.pt@hitachi.com
Cc: linux-kernel@vger.kernel.org, hschauhan@nulltrace.org,
        David Daney <ddaney@caviumnetworks.com>
Subject: [PATCH 2/5] MIPS: Add instrunction format for BREAK and SYSCALL
Date: Tue,  3 Aug 2010 11:22:19 -0700
Message-Id: <1280859742-26364-3-git-send-email-ddaney@caviumnetworks.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1280859742-26364-1-git-send-email-ddaney@caviumnetworks.com>
References: <1280859742-26364-1-git-send-email-ddaney@caviumnetworks.com>
X-OriginalArrivalTime: 03 Aug 2010 18:22:44.0688 (UTC) FILETIME=[DE0EAD00:01CB3338]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: David Daney <ddaney@caviumnetworks.com>
---
 arch/mips/include/asm/inst.h |   15 ++++++++++++++-
 1 files changed, 14 insertions(+), 1 deletions(-)

diff --git a/arch/mips/include/asm/inst.h b/arch/mips/include/asm/inst.h
index 6489f00..444ff71 100644
--- a/arch/mips/include/asm/inst.h
+++ b/arch/mips/include/asm/inst.h
@@ -247,6 +247,12 @@ struct ma_format {	/* FPU multipy and add format (MIPS IV) */
 	unsigned int fmt : 2;
 };
 
+struct b_format { /* BREAK and SYSCALL */
+	unsigned int opcode:6;
+	unsigned int code:20;
+	unsigned int func:6;
+};
+
 #elif defined(__MIPSEL__)
 
 struct j_format {	/* Jump format */
@@ -314,6 +320,12 @@ struct ma_format {	/* FPU multipy and add format (MIPS IV) */
 	unsigned int opcode : 6;
 };
 
+struct b_format { /* BREAK and SYSCALL */
+	unsigned int func:6;
+	unsigned int code:20;
+	unsigned int opcode:6;
+};
+
 #else /* !defined (__MIPSEB__) && !defined (__MIPSEL__) */
 #error "MIPS but neither __MIPSEL__ nor __MIPSEB__?"
 #endif
@@ -328,7 +340,8 @@ union mips_instruction {
 	struct c_format c_format;
 	struct r_format r_format;
 	struct f_format f_format;
-        struct ma_format ma_format;
+	struct ma_format ma_format;
+	struct b_format b_format;
 };
 
 /* HACHACHAHCAHC ...  */
-- 
1.7.1.1

