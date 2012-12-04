Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753428Ab2LDOFN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 09:05:13 -0500
Received: from mga03.intel.com ([143.182.124.21]:14163 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752886Ab2LDOFK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 09:05:10 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,215,1355126400"; 
   d="scan'208";a="175975374"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, alan@linux.intel.com, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 07/15] mei: use wrietl/readl instead of io wrappers
Date: Tue,  4 Dec 2012 16:04:36 +0200
Message-Id: <1354629884-3202-7-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1354629884-3202-1-git-send-email-tomas.winkler@intel.com>
References: <1354629884-3202-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

on intel registers are alwasy memory mapped so drop
the overhead of iowrite32 and ioread32

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/mei_dev.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/misc/mei/mei_dev.h b/drivers/misc/mei/mei_dev.h
index 92a5d9a..37eb041 100644
--- a/drivers/misc/mei/mei_dev.h
+++ b/drivers/misc/mei/mei_dev.h
@@ -438,7 +438,7 @@ int mei_amthif_irq_read(struct mei_device *dev, s32 *slots);
 static inline u32 mei_reg_read(const struct mei_device *dev,
 			       unsigned long offset)
 {
-	return ioread32(dev->mem_addr + offset);
+	return readl(dev->mem_addr + offset);
 }
 
 /**
@@ -451,7 +451,7 @@ static inline u32 mei_reg_read(const struct mei_device *dev,
 static inline void mei_reg_write(const struct mei_device *dev,
 				 unsigned long offset, u32 value)
 {
-	iowrite32(value, dev->mem_addr + offset);
+	writel(value, dev->mem_addr + offset);
 }
 
 /**
-- 
1.7.4.4

