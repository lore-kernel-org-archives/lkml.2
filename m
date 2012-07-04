Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755390Ab2GDQZA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 12:25:00 -0400
Received: from mga02.intel.com ([134.134.136.20]:46132 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754794Ab2GDQY7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 12:24:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="166923184"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, alan@linux.intel.com, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 1/6] mei: mei_device can be const for mei register access functions
Date: Wed,  4 Jul 2012 19:24:49 +0300
Message-Id: <1341419094-4204-1-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/mei_dev.h |   13 +++++++------
 1 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/misc/mei/mei_dev.h b/drivers/misc/mei/mei_dev.h
index d60250d..772f74d 100644
--- a/drivers/misc/mei/mei_dev.h
+++ b/drivers/misc/mei/mei_dev.h
@@ -363,7 +363,8 @@ int mei_find_me_client_index(const struct mei_device *dev, uuid_le cuuid);
  *
  * returns register value (u32)
  */
-static inline u32 mei_reg_read(struct mei_device *dev, unsigned long offset)
+static inline u32 mei_reg_read(const struct mei_device *dev,
+			       unsigned long offset)
 {
 	return ioread32(dev->mem_addr + offset);
 }
@@ -375,8 +376,8 @@ static inline u32 mei_reg_read(struct mei_device *dev, unsigned long offset)
  * @offset: offset from which to write the data
  * @value: register value to write (u32)
  */
-static inline void mei_reg_write(struct mei_device *dev,
-				unsigned long offset, u32 value)
+static inline void mei_reg_write(const struct mei_device *dev,
+				 unsigned long offset, u32 value)
 {
 	iowrite32(value, dev->mem_addr + offset);
 }
@@ -388,7 +389,7 @@ static inline void mei_reg_write(struct mei_device *dev,
  *
  * returns the byte read.
  */
-static inline u32 mei_hcsr_read(struct mei_device *dev)
+static inline u32 mei_hcsr_read(const struct mei_device *dev)
 {
 	return mei_reg_read(dev, H_CSR);
 }
@@ -400,7 +401,7 @@ static inline u32 mei_hcsr_read(struct mei_device *dev)
  *
  * returns ME_CSR_HA register value (u32)
  */
-static inline u32 mei_mecsr_read(struct mei_device *dev)
+static inline u32 mei_mecsr_read(const struct mei_device *dev)
 {
 	return mei_reg_read(dev, ME_CSR_HA);
 }
@@ -412,7 +413,7 @@ static inline u32 mei_mecsr_read(struct mei_device *dev)
  *
  * returns ME_CB_RW register value (u32)
  */
-static inline u32 mei_mecbrw_read(struct mei_device *dev)
+static inline u32 mei_mecbrw_read(const struct mei_device *dev)
 {
 	return mei_reg_read(dev, ME_CB_RW);
 }
-- 
1.7.4.4

