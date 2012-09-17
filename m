Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753159Ab2IQQcY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 12:32:24 -0400
Received: from mail.mars-solutions.de ([213.239.212.107]:20860 "EHLO
	mail.mars-solutions.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751603Ab2IQQcX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 12:32:23 -0400
X-Greylist: delayed 875 seconds by postgrey-1.27 at vger.kernel.org; Mon, 17 Sep 2012 12:32:23 EDT
From: Andreas Pretzsch <apr@cn-eng.de>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Axel Lin <axel.lin@gmail.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] mfd: Use devm_* APIs for mc13xxx: remove leftover kfree
Date: Mon, 17 Sep 2012 18:17:21 +0200
Message-Id: <1347898641-17575-1-git-send-email-apr@cn-eng.de>
X-Mailer: git-send-email 1.7.10.4
X-Assp-Version: 1.8.1.3(0.0.06) on ASSP.nospam
X-Assp-Passing: authenticated
X-Assp-ID: ASSP.nospam id-98661-11188
X-Assp-Intended-For: axel.lin@gmail.com
X-Assp-Envelope-From: apr@cn-eng.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit e7c706b1e5ccf28eaaf76c7a4613e80b0ca52863 migrated the allocation
of struct mc13xxx to devm_* functions, but left a kfree(mc13xxx) in the
mc13xxx_common_init error path. Remove it to prevent memory corruption.

Signed-off-by: Andreas Pretzsch <apr@cn-eng.de>
---
 drivers/mfd/mc13xxx-core.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/mfd/mc13xxx-core.c b/drivers/mfd/mc13xxx-core.c
index 1ec79b5..1aba023 100644
--- a/drivers/mfd/mc13xxx-core.c
+++ b/drivers/mfd/mc13xxx-core.c
@@ -676,7 +676,6 @@ int mc13xxx_common_init(struct mc13xxx *mc13xxx,
 err_mask:
 err_revision:
 		mc13xxx_unlock(mc13xxx);
-		kfree(mc13xxx);
 		return ret;
 	}
 
-- 
1.7.10.4

