Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757375Ab0GNSEm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 14:04:42 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:47318 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756680Ab0GNSEk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 14:04:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=nFqfC3I6azxYirTJy8ZWEqr9H4AZjDWXcxKyc6GLnp+bNePGUj1SpPSDNGWZT3Ou9Z
         HEBl/+ZYbU0idNlMh7db9Zxs0witw3j0ldCzIN13Alf9yJCNgJ6Up1572lRIwlVqpzYV
         YQ27j00DxT3y8AmJNFD0i0X+mchWquZDAnfh8=
From: Kulikov Vasiliy <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: "James E.J. Bottomley" <James.Bottomley@suse.de>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 07/11] scsi: ultrastor: formatting of pointers in printk()
Date: Wed, 14 Jul 2010 22:03:59 +0400
Message-Id: <1279130640-11228-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use %p instead of %08x in printk().

Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
---
 drivers/scsi/ultrastor.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/ultrastor.c b/drivers/scsi/ultrastor.c
index 27aa40f..4715b7c 100644
--- a/drivers/scsi/ultrastor.c
+++ b/drivers/scsi/ultrastor.c
@@ -1061,7 +1061,7 @@ static void ultrastor_interrupt(void *dev_id)
     mscp = (struct mscp *)isa_bus_to_virt(inl(config.icm_address));
     mscp_index = mscp - config.mscp;
     if (mscp_index >= ULTRASTOR_MAX_CMDS) {
-	printk("Ux4F interrupt: bad MSCP address %x\n", (unsigned int) mscp);
+	printk("Ux4F interrupt: bad MSCP address %p\n", mscp);
 	/* A command has been lost.  Reset and report an error
 	   for all commands.  */
 	ultrastor_host_reset(dev_id);
@@ -1074,8 +1074,8 @@ static void ultrastor_interrupt(void *dev_id)
 	unsigned char icm_status = inb(config.icm_address - 1);
 #if ULTRASTOR_DEBUG & (UD_INTERRUPT|UD_ERROR|UD_ABORT)
 	if (icm_status != 1 && icm_status != 2)
-	    printk("US24F: ICM status %x for MSCP %d (%x)\n", icm_status,
-		   mscp_index, (unsigned int) mscp);
+		printk("US24F: ICM status %x for MSCP %d (%p)\n", icm_status,
+					mscp_index, mscp);
 #endif
 	/* The manual says clear interrupt then write 0 to ICM status.
 	   This seems backwards, but I'll do it anyway.  --jfc */
@@ -1104,7 +1104,7 @@ static void ultrastor_interrupt(void *dev_id)
     if (!SCtmp)
       {
 #if ULTRASTOR_DEBUG & (UD_ABORT|UD_INTERRUPT)
-	printk("MSCP %d (%x): no command\n", mscp_index, (unsigned int) mscp);
+	printk("MSCP %d (%p): no command\n", mscp_index, mscp);
 #endif	
 #if ULTRASTOR_MAX_CMDS == 1
 	config.mscp_busy = FALSE;
@@ -1154,8 +1154,8 @@ static void ultrastor_interrupt(void *dev_id)
 
 #if ULTRASTOR_DEBUG & (UD_ABORT|UD_INTERRUPT)
     if (config.aborted[mscp_index])
-	printk("Ux4 interrupt: MSCP %d (%x) aborted = %d\n",
-	       mscp_index, (unsigned int) mscp, config.aborted[mscp_index]);
+	printk("Ux4 interrupt: MSCP %d (%p) aborted = %d\n",
+	       mscp_index, mscp, config.aborted[mscp_index]);
 #endif
     config.aborted[mscp_index] = 0;
 
-- 
1.7.0.4

