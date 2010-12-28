Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753137Ab0L1Atb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Dec 2010 19:49:31 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:32458 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753082Ab0L1Ata (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Dec 2010 19:49:30 -0500
Message-ID: <4D1933BA.8000508@kernel.org>
Date: Mon, 27 Dec 2010 16:47:54 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/6] x86: Change get_max_mapped() to inline
References: <4D0C072D.1040201@kernel.org> <4D19320B.7030007@kernel.org>
In-Reply-To: <4D19320B.7030007@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Move it into head file. to prepare use it in other files.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/include/asm/page_types.h |    5 +++++
 arch/x86/kernel/setup.c           |    9 ---------
 2 files changed, 5 insertions(+), 9 deletions(-)

Index: linux-2.6/arch/x86/include/asm/page_types.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/page_types.h
+++ linux-2.6/arch/x86/include/asm/page_types.h
@@ -45,6 +45,11 @@ extern int devmem_is_allowed(unsigned lo
 extern unsigned long max_low_pfn_mapped;
 extern unsigned long max_pfn_mapped;
 
+static inline u64 get_max_mapped(void)
+{
+	return (u64)max_pfn_mapped<<PAGE_SHIFT;
+}
+
 extern unsigned long init_memory_mapping(unsigned long start,
 					 unsigned long end);
 
Index: linux-2.6/arch/x86/kernel/setup.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/setup.c
+++ linux-2.6/arch/x86/kernel/setup.c
@@ -680,15 +680,6 @@ static int __init parse_reservelow(char
 
 early_param("reservelow", parse_reservelow);
 
-static u64 __init get_max_mapped(void)
-{
-	u64 end = max_pfn_mapped;
-
-	end <<= PAGE_SHIFT;
-
-	return end;
-}
-
 /*
  * Determine if we were loaded by an EFI loader.  If so, then we have also been
  * passed the efi memmap, systab, etc., so we should use these data structures
