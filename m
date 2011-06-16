Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757408Ab1FPJBF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 05:01:05 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:53386 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752899Ab1FPJBA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 05:01:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=pxtMf6ZdLgWFh1GCEsxOtW6oWpF0syrXphy6OxbEt625uk1tVMXudjBl0alG/IqgUl
         Q6G368SG+JHQaQxbbqqH169xebFwknyQ5oZHvpA/JHQ8AzzhGCDQ7Uvq36zRjqh64LWh
         ENlii9ffZnoMvy4Ss4pjcQRNxsL7NlSF/CDYU=
Date: Thu, 16 Jun 2011 17:00:37 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Vinod Koul <vinod.koul@intel.com>, Dan Williams <dan.j.williams@intel.com>,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [Patch] dma: remove DMA_xxBIT_MASK macros
Message-ID: <20110616090037.GA10326@cr0.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


git grep shows there are no users in tree, so we can
remove them safely.

Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

---
 Documentation/feature-removal-schedule.txt |    7 -------
 include/linux/dma-mapping.h                |   21 ---------------------
 2 files changed, 0 insertions(+), 28 deletions(-)

diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index 72e2384..8e2d816 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -474,13 +474,6 @@ Who:	FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
 
 ----------------------------
 
-What: 	DMA_xxBIT_MASK macros
-When:	Jun 2011
-Why:	DMA_xxBIT_MASK macros were replaced with DMA_BIT_MASK() macros.
-Who:	FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
-
-----------------------------
-
 What:	iwlwifi disable_hw_scan module parameters
 When:	2.6.40
 Why:	Hareware scan is the prefer method for iwlwifi devices for
diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
index ba8319a..dc77808 100644
--- a/include/linux/dma-mapping.h
+++ b/include/linux/dma-mapping.h
@@ -54,27 +54,6 @@ struct dma_map_ops {
 
 #define DMA_BIT_MASK(n)	(((n) == 64) ? ~0ULL : ((1ULL<<(n))-1))
 
-typedef u64 DMA_nnBIT_MASK __deprecated;
-
-/*
- * NOTE: do not use the below macros in new code and do not add new definitions
- * here.
- *
- * Instead, just open-code DMA_BIT_MASK(n) within your driver
- */
-#define DMA_64BIT_MASK	(DMA_nnBIT_MASK)DMA_BIT_MASK(64)
-#define DMA_48BIT_MASK	(DMA_nnBIT_MASK)DMA_BIT_MASK(48)
-#define DMA_47BIT_MASK	(DMA_nnBIT_MASK)DMA_BIT_MASK(47)
-#define DMA_40BIT_MASK	(DMA_nnBIT_MASK)DMA_BIT_MASK(40)
-#define DMA_39BIT_MASK	(DMA_nnBIT_MASK)DMA_BIT_MASK(39)
-#define DMA_35BIT_MASK	(DMA_nnBIT_MASK)DMA_BIT_MASK(35)
-#define DMA_32BIT_MASK	(DMA_nnBIT_MASK)DMA_BIT_MASK(32)
-#define DMA_31BIT_MASK	(DMA_nnBIT_MASK)DMA_BIT_MASK(31)
-#define DMA_30BIT_MASK	(DMA_nnBIT_MASK)DMA_BIT_MASK(30)
-#define DMA_29BIT_MASK	(DMA_nnBIT_MASK)DMA_BIT_MASK(29)
-#define DMA_28BIT_MASK	(DMA_nnBIT_MASK)DMA_BIT_MASK(28)
-#define DMA_24BIT_MASK	(DMA_nnBIT_MASK)DMA_BIT_MASK(24)
-
 #define DMA_MASK_NONE	0x0ULL
 
 static inline int valid_dma_direction(int dma_direction)
