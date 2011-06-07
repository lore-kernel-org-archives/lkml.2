Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755703Ab1FGXqh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 19:46:37 -0400
Received: from mga11.intel.com ([192.55.52.93]:43545 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752456Ab1FGXqg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 19:46:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,335,1304319600"; 
   d="scan'208";a="15246483"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: Andi Kleen <ak@linux.intel.com>, x86@kernel.org
Subject: [PATCH] x86: Fix sys_call_table type in asm/syscall.h
Date: Tue,  7 Jun 2011 16:45:07 -0700
Message-Id: <1307490307-27443-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Make the sys_call_table type defined in asm/syscall.h match
the definition in syscall_64.c

Cc: x86@kernel.org
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/include/asm/syscall.h |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/syscall.h b/arch/x86/include/asm/syscall.h
index c4a348f..32295b7 100644
--- a/arch/x86/include/asm/syscall.h
+++ b/arch/x86/include/asm/syscall.h
@@ -16,7 +16,8 @@
 #include <linux/sched.h>
 #include <linux/err.h>
 
-extern const unsigned long sys_call_table[];
+typedef void (*sys_call_ptr_t)(void);
+extern const sys_call_ptr_t sys_call_table[];
 
 /*
  * Only the low 32 bits of orig_ax are meaningful, so we return int.
-- 
1.7.4.4

