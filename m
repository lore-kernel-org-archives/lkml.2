Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753950Ab1LACbJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 21:31:09 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:57338 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753289Ab1LACbI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 21:31:08 -0500
From: Haogang Chen <haogangchen@gmail.com>
To: aacraid@adaptec.com
Cc: JBottomley@parallels.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, haogangchen@gmail.com
Subject: [PATCH] SCSI: aacraid: potential integer overflow in aac_get_containers()
Date: Wed, 30 Nov 2011 21:30:01 -0500
Message-Id: <1322706601-26181-1-git-send-email-haogangchen@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a potential integer overflow in aac_get_containers(). When
maximum_num_containers is large, the subsequent call to kzalloc() will
allocate a buffer smaller than expected, which leads to memory
corruption in the for loop.

The patch replaces kzalloc with kcalloc.

Signed-off-by: Haogang Chen <haogangchen@gmail.com>
---
 drivers/scsi/aacraid/aachba.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/aacraid/aachba.c b/drivers/scsi/aacraid/aachba.c
index 409f580..440b84d 100644
--- a/drivers/scsi/aacraid/aachba.c
+++ b/drivers/scsi/aacraid/aachba.c
@@ -381,7 +381,7 @@ int aac_get_containers(struct aac_dev *dev)
 
 	if (maximum_num_containers < MAXIMUM_NUM_CONTAINERS)
 		maximum_num_containers = MAXIMUM_NUM_CONTAINERS;
-	fsa_dev_ptr = kzalloc(sizeof(*fsa_dev_ptr) * maximum_num_containers,
+	fsa_dev_ptr = kcalloc(maximum_num_containers, sizeof(*fsa_dev_ptr), 
 			GFP_KERNEL);
 	if (!fsa_dev_ptr)
 		return -ENOMEM;
-- 
1.7.5.4

