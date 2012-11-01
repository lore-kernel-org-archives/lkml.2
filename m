Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751932Ab2KAFIu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 01:08:50 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:56380 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750972Ab2KAFIs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 01:08:48 -0400
MIME-Version: 1.0
Date: Thu, 1 Nov 2012 13:08:45 +0800
Message-ID: <CAPgLHd928Pn4GvgcRAHic6pGU2T1gLrWRpGsqjxsGk0=nDg9rw@mail.gmail.com>
Subject: [PATCH] mtip32xx: remove unused variables from mtip32xx.c
From: Wei Yongjun <weiyj.lk@gmail.com>
To: axboe@kernel.dk
Cc: yongjun_wei@trendmicro.com.cn, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

The variables fis, reply are initialized but never used
otherwise, so remove the unused variables.

dpatch engine is used to auto generate this patch.
(https://github.com/weiyj/dpatch)

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/block/mtip32xx/mtip32xx.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/block/mtip32xx/mtip32xx.c b/drivers/block/mtip32xx/mtip32xx.c
index adc6f36..d1e0273 100644
--- a/drivers/block/mtip32xx/mtip32xx.c
+++ b/drivers/block/mtip32xx/mtip32xx.c
@@ -555,7 +555,6 @@ static void print_tags(struct driver_data *dd,
 static void mtip_timeout_function(unsigned long int data)
 {
 	struct mtip_port *port = (struct mtip_port *) data;
-	struct host_to_dev_fis *fis;
 	struct mtip_cmd *command;
 	int tag, cmdto_cnt = 0;
 	unsigned int bit, group;
@@ -587,7 +586,6 @@ static void mtip_timeout_function(unsigned long int data)
 			bit = tag & 0x1F;
 
 			command = &port->commands[tag];
-			fis = (struct host_to_dev_fis *) command->command;
 
 			set_bit(tag, tagaccum);
 			cmdto_cnt++;
@@ -1142,10 +1140,8 @@ static void mtip_issue_non_ncq_command(struct mtip_port *port, int tag)
 static bool mtip_pause_ncq(struct mtip_port *port,
 				struct host_to_dev_fis *fis)
 {
-	struct host_to_dev_fis *reply;
 	unsigned long task_file_data;
 
-	reply = port->rxfis + RX_FIS_D2H_REG;
 	task_file_data = readl(port->mmio+PORT_TFDATA);
 
 	if (fis->command == ATA_CMD_SEC_ERASE_UNIT)


