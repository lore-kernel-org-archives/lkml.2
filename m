Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754430Ab1HFCiX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 22:38:23 -0400
Received: from wondertoys-mx.wondertoys.net ([206.117.179.246]:58257 "EHLO
	labridge.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752378Ab1HFCiW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 22:38:22 -0400
From: Joe Perches <joe@perches.com>
To: Jeff Garzik <jgarzik@pobox.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] sata_sil24: Use const
Date: Fri,  5 Aug 2011 19:38:17 -0700
Message-Id: <a73ac1acade5eafb50c9768647fc51040719e8be.1312598278.git.joe@perches.com>
X-Mailer: git-send-email 1.7.6.405.gc1be0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reduce data by using const.

$ size drivers/ata/sata_sil24.o*
   text	   data	    bss	    dec	    hex	filename
  12764	    614	   2688	  16066	   3ec2	drivers/ata/sata_sil24.o.new
  12320	   1058	   2688	  16066	   3ec2	drivers/ata/sata_sil24.o.old

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/ata/sata_sil24.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/ata/sata_sil24.c b/drivers/ata/sata_sil24.c
index 55470f3..1e91406 100644
--- a/drivers/ata/sata_sil24.c
+++ b/drivers/ata/sata_sil24.c
@@ -268,7 +268,7 @@ union sil24_cmd_block {
 	struct sil24_atapi_block atapi;
 };
 
-static struct sil24_cerr_info {
+static const struct sil24_cerr_info {
 	unsigned int err_mask, action;
 	const char *desc;
 } sil24_cerr_db[] = {
@@ -1019,7 +1019,7 @@ static void sil24_error_intr(struct ata_port *ap)
 
 	/* deal with command error */
 	if (irq_stat & PORT_IRQ_ERROR) {
-		struct sil24_cerr_info *ci = NULL;
+		const struct sil24_cerr_info *ci = NULL;
 		unsigned int err_mask = 0, action = 0;
 		u32 context, cerr;
 		int pmp;
-- 
1.7.6.405.gc1be0

