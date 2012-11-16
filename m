Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751621Ab2KPIxn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 03:53:43 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:22815 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751469Ab2KPIxh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 03:53:37 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>,
        Matt Fleming <matt.fleming@intel.com>
Subject: [PATCH 8/9] x86: ramdisk info print with high bits.
Date: Fri, 16 Nov 2012 00:53:08 -0800
Message-Id: <1353055989-31939-9-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1353055989-31939-1-git-send-email-yinghai@kernel.org>
References: <1353055989-31939-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ramdisk could be loaded high now for 64bit.

So need to print more digits for them.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Matt Fleming <matt.fleming@intel.com>
---
 arch/x86/kernel/setup.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index c2eb535..0e13c6e 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -341,7 +341,7 @@ static void __init relocate_initrd(void)
 	memblock_reserve(ramdisk_here, area_size);
 	initrd_start = ramdisk_here + PAGE_OFFSET;
 	initrd_end   = initrd_start + ramdisk_size;
-	printk(KERN_INFO "Allocated new RAMDISK: [mem %#010llx-%#010llx]\n",
+	printk(KERN_INFO "Allocated new RAMDISK: [mem %#018llx-%#018llx]\n",
 			 ramdisk_here, ramdisk_here + ramdisk_size - 1);
 
 	q = (char *)initrd_start;
@@ -363,8 +363,8 @@ static void __init relocate_initrd(void)
 
 	ramdisk_image = get_ramdisk_image();
 	ramdisk_size  = get_ramdisk_size();
-	printk(KERN_INFO "Move RAMDISK from [mem %#010llx-%#010llx] to"
-		" [mem %#010llx-%#010llx]\n",
+	printk(KERN_INFO "Move RAMDISK from [mem %#018llx-%#018llx] to"
+		" [mem %#018llx-%#018llx]\n",
 		ramdisk_image, ramdisk_image + ramdisk_size - 1,
 		ramdisk_here, ramdisk_here + ramdisk_size - 1);
 }
@@ -416,7 +416,7 @@ static void __init reserve_initrd(void)
 		       "disabling initrd (%lld needed, %lld available)\n",
 		       ramdisk_size, mapped_size>>1);
 
-	printk(KERN_INFO "RAMDISK: [mem %#010llx-%#010llx]\n", ramdisk_image,
+	printk(KERN_INFO "RAMDISK: [mem %#018llx-%#018llx]\n", ramdisk_image,
 			ramdisk_end - 1);
 
 	if (pfn_range_is_mapped(PFN_DOWN(ramdisk_image),
-- 
1.7.7

