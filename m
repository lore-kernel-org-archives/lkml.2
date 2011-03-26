Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752951Ab1CZQQj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Mar 2011 12:16:39 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:61408 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752661Ab1CZQQf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Mar 2011 12:16:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=FQRqb+ZVRCSzfG6t3zypq3FX+2QCAdoFRy98ontJ+9F5xFEI+kx8yN4yhNgQNOP2nK
         0YRvUmZeakogkW6fs0A+5wZE1mk2/GqpRkfbCONeDcYIpUKlBaNkE/yw8Pz+PAV9+zub
         oRM2DyuWdCQYdp9a038kEJa0GTZOaDa8nIYJg=
From: Ralf Thielow <ralf.thielow@googlemail.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ralf Thielow <ralf.thielow@googlemail.com>
Subject: [PATCH 2/4] staging: keucr: smscsi: Includes missing KERN_ facility level to printk().
Date: Sat, 26 Mar 2011 17:16:18 +0100
Message-Id: <1301156180-12192-2-git-send-email-ralf.thielow@googlemail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1301156180-12192-1-git-send-email-ralf.thielow@googlemail.com>
References: <1301156180-12192-1-git-send-email-ralf.thielow@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Includes missing KERN_ facility level to printk().

Signed-off-by: Ralf Thielow <ralf.thielow@googlemail.com>
---
 drivers/staging/keucr/smscsi.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/keucr/smscsi.c b/drivers/staging/keucr/smscsi.c
index c3db085..20386ce 100644
--- a/drivers/staging/keucr/smscsi.c
+++ b/drivers/staging/keucr/smscsi.c
@@ -97,7 +97,7 @@ int SM_SCSI_Read_Capacity(struct us_data *us, struct scsi_cmnd *srb)
 	WORD bl_len;
 	BYTE buf[8];
 
-	printk("SM_SCSI_Read_Capacity\n");
+	printk(KERN_DEBUG, "SM_SCSI_Read_Capacity\n");
 
 	bl_len = 0x200;
 	bl_num = Ssfdc.MaxLogBlocks * Ssfdc.MaxSectors * Ssfdc.MaxZones - 1;
@@ -110,8 +110,8 @@ int SM_SCSI_Read_Capacity(struct us_data *us, struct scsi_cmnd *srb)
 	 */
 
 	us->bl_num = bl_num;
-	printk("bl_len = %x\n", bl_len);
-	printk("bl_num = %x\n", bl_num);
+	printk(KERN_DEBUG, "bl_len = %x\n", bl_len);
+	printk(KERN_DEBUG, "bl_num = %x\n", bl_num);
 
 	buf[0] = (bl_num >> 24) & 0xff;
 	buf[1] = (bl_num >> 16) & 0xff;
-- 
1.7.4.1

