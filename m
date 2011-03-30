Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932339Ab1C3JlK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 05:41:10 -0400
Received: from mprc.pku.edu.cn ([162.105.203.9]:52758 "EHLO mprc.pku.edu.cn"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932184Ab1C3JlG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 05:41:06 -0400
From: "Guan Xuetao" <gxt@mprc.pku.edu.cn>
To: "Arnd Bergmann" <arnd@arndb.de>, "Tejun Heo" <tj@kernel.org>
Cc: <linux-kernel@vger.kernel.org>, <linux-arch@vger.kernel.org>
Subject: [PATCH] unicore32 ldscript fix: add cacheline parameter to PERCPU() macro
Date: Wed, 30 Mar 2011 16:52:57 +0800
Message-ID: <01ed01cbeeb7$de2e1920$9a8a4b60$@mprc.pku.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: Acvut2f1b9o2AOAdS3ejbX6cg67gLQ==
Content-Language: zh-cn
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Also, adjust cacheline parameter of RW_DATA_SECTION and EXCEPTION_TABLE

Signed-off-by: Guan Xuetao <gxt@mprc.pku.edu.cn>
---
 arch/unicore32/kernel/vmlinux.lds.S |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/unicore32/kernel/vmlinux.lds.S b/arch/unicore32/kernel/vmlinux.lds.S
index 0b4eb89..9bf7f7a 100644
--- a/arch/unicore32/kernel/vmlinux.lds.S
+++ b/arch/unicore32/kernel/vmlinux.lds.S
@@ -14,6 +14,7 @@
 #include <asm/thread_info.h>
 #include <asm/memory.h>
 #include <asm/page.h>
+#include <asm/cache.h>
 
 OUTPUT_ARCH(unicore32)
 ENTRY(stext)
@@ -29,7 +30,7 @@ SECTIONS
 	HEAD_TEXT_SECTION
 	INIT_TEXT_SECTION(PAGE_SIZE)
 	INIT_DATA_SECTION(16)
-	PERCPU(PAGE_SIZE)
+	PERCPU(L1_CACHE_BYTES, PAGE_SIZE)
 	__init_end = .;
 
 	_stext = .;
@@ -45,10 +46,10 @@ SECTIONS
 
 	_sdata = .;
 	RO_DATA_SECTION(PAGE_SIZE)
-	RW_DATA_SECTION(32, PAGE_SIZE, THREAD_SIZE)
+	RW_DATA_SECTION(L1_CACHE_BYTES, PAGE_SIZE, THREAD_SIZE)
 	_edata = .;
 
-	EXCEPTION_TABLE(32)
+	EXCEPTION_TABLE(L1_CACHE_BYTES)
 	NOTES
 
 	BSS_SECTION(0, 0, 0)
-- 
1.6.2.2


