Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752213Ab2K1Hv1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 02:51:27 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:40367 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751126Ab2K1HvZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 02:51:25 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>, Matt Fleming <matt.fleming@intel.com>
Subject: [PATCH v5 01/13] x86, boot: move verify_cpu.S after 0x200
Date: Tue, 27 Nov 2012 23:50:30 -0800
Message-Id: <1354089042-10023-2-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1354089042-10023-1-git-send-email-yinghai@kernel.org>
References: <1354089042-10023-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We are short of space before 0x200 that is entry for startup_64.

According to hpa, we can not change startup_64 to other offset and
that become ABI now.

We could move function verify_cpu down, and that could avoid extra
code of jmp back and forth if we would move other lines.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Matt Fleming <matt.fleming@intel.com>
---
 arch/x86/boot/compressed/head_64.S |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/boot/compressed/head_64.S b/arch/x86/boot/compressed/head_64.S
index 2c4b171..2c3cee4 100644
--- a/arch/x86/boot/compressed/head_64.S
+++ b/arch/x86/boot/compressed/head_64.S
@@ -182,8 +182,6 @@ no_longmode:
 	hlt
 	jmp     1b
 
-#include "../../kernel/verify_cpu.S"
-
 	/*
 	 * Be careful here startup_64 needs to be at a predictable
 	 * address so I can export it in an ELF header.  Bootloaders
@@ -349,6 +347,9 @@ relocated:
  */
 	jmp	*%rbp
 
+	.code32
+#include "../../kernel/verify_cpu.S"
+
 	.data
 gdt:
 	.word	gdt_end - gdt
-- 
1.7.7

