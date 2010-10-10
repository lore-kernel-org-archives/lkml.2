Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757992Ab0JJR2w (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Oct 2010 13:28:52 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:38797 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757931Ab0JJR2u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Oct 2010 13:28:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=IETE3JSbsA5uosbmHAyNFKaYFuGm3tm2naih6TXIkd4p3sC76Hu6lWmkYrJXbXWWcz
         ZGVD066Dz2Zx6e4oxGargfkqMLQ5rdJ+FdEwAfOVyRHPa5Lbtm0YXO4WG03wkVwEC553
         NXCiYswQxeMyX6F6naxF0rFYWlkxogK9ebQ2E=
From: Vasiliy Kulikov <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Harsha Priya <priya.harsha@intel.com>,
        Vinod Koul <vinod.koul@intel.com>, Alan Cox <alan@linux.intel.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: intel_sst: use signed int for error codes
Date: Sun, 10 Oct 2010 21:28:43 +0400
Message-Id: <1286731724-17996-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As retval stores error code, it should be signed int.

Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>
---
 Compile tested.

 .../staging/intel_sst/intel_sst_app_interface.c    |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/intel_sst/intel_sst_app_interface.c b/drivers/staging/intel_sst/intel_sst_app_interface.c
index 9f31dc5..baf0ddc 100644
--- a/drivers/staging/intel_sst/intel_sst_app_interface.c
+++ b/drivers/staging/intel_sst/intel_sst_app_interface.c
@@ -98,7 +98,7 @@ static int intel_sst_check_device(void)
  */
 int intel_sst_open(struct inode *i_node, struct file *file_ptr)
 {
-	unsigned int retval = intel_sst_check_device();
+	int retval = intel_sst_check_device();
 	if (retval)
 		return retval;
 
@@ -137,7 +137,7 @@ int intel_sst_open(struct inode *i_node, struct file *file_ptr)
  */
 int intel_sst_open_cntrl(struct inode *i_node, struct file *file_ptr)
 {
-	unsigned int retval = intel_sst_check_device();
+	int retval = intel_sst_check_device();
 	if (retval)
 		return retval;
 
-- 
1.7.0.4

