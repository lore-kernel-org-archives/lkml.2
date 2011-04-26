Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932165Ab1DZVOK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 17:14:10 -0400
Received: from mga02.intel.com ([134.134.136.20]:57987 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758710Ab1DZVOD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 17:14:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,270,1301900400"; 
   d="scan'208";a="634483504"
From: Andi Kleen <andi@firstfloor.org>
References: <20110426212.641772347@firstfloor.org>
In-Reply-To: <20110426212.641772347@firstfloor.org>
To: segoon@openwall.com, ak@linux.intel.com, andy.sharp@onstor.com,
        a.zummo@towertech.it, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, gregkh@suse.de,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [35/106] drivers/rtc/rtc-ds1511.c: world-writable sysfs nvram file
Message-Id: <20110426211314.941AD3E1886@tassilo.jf.intel.com>
Date: Tue, 26 Apr 2011 14:13:14 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Vasiliy Kulikov <segoon@openwall.com>

commit 49d50fb1c28738ef6bad0c2b87d5355a1653fed5 upstream.

Don't allow everybogy to write to NVRAM.

Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: Andy Sharp <andy.sharp@onstor.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/rtc/rtc-ds1511.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.35.y/drivers/rtc/rtc-ds1511.c
===================================================================
--- linux-2.6.35.y.orig/drivers/rtc/rtc-ds1511.c
+++ linux-2.6.35.y/drivers/rtc/rtc-ds1511.c
@@ -485,7 +485,7 @@ ds1511_nvram_write(struct file *filp, st
 static struct bin_attribute ds1511_nvram_attr = {
 	.attr = {
 		.name = "nvram",
-		.mode = S_IRUGO | S_IWUGO,
+		.mode = S_IRUGO | S_IWUSR,
 	},
 	.size = DS1511_RAM_MAX,
 	.read = ds1511_nvram_read,
