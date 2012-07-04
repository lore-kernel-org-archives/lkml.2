Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753960Ab2GDOhc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 10:37:32 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:49876 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753615Ab2GDOhb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 10:37:31 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH] fcoe: unsigned long can never be negative
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Date: Wed, 04 Jul 2012 16:36:20 +0100
Message-ID: <20120704153613.4165.52012.stgit@bluebook>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

Coverity id: 703581

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/scsi/fcoe/fcoe_sysfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/fcoe/fcoe_sysfs.c b/drivers/scsi/fcoe/fcoe_sysfs.c
index 2bc1631..5e75168 100644
--- a/drivers/scsi/fcoe/fcoe_sysfs.c
+++ b/drivers/scsi/fcoe/fcoe_sysfs.c
@@ -102,7 +102,7 @@ static int fcoe_str_to_dev_loss(const char *buf, unsigned long *val)
 	int ret;
 
 	ret = kstrtoul(buf, 0, val);
-	if (ret || *val < 0)
+	if (ret)
 		return -EINVAL;
 	/*
 	 * Check for overflow; dev_loss_tmo is u32

