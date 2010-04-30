Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933224Ab0D3RW5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 13:22:57 -0400
Received: from mail.atmel.fr ([81.80.104.162]:53996 "EHLO atmel-es2.atmel.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933167Ab0D3RWS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 13:22:18 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: haavard.skinnemoen@atmel.com, linux-arm-kernel@lists.infradead.org,
       akpm@linux-foundation.org, linux-mmc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, kernel@avr32linux.org,
       Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH] MMC: atmel-mci: fix in debugfs: response value printing
Date: Fri, 30 Apr 2010 16:32:02 +0200
Message-Id: <1272637922-31418-1-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <12c815b6060bc044238d63a686de517e43e90184.1272378853.git.nicolas.ferre@atmel.com>
References: <12c815b6060bc044238d63a686de517e43e90184.1272378853.git.nicolas.ferre@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In debugfs, printing of command response reports resp[2]
twice: fix it to resp[3].

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 drivers/mmc/host/atmel-mci.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/mmc/host/atmel-mci.c b/drivers/mmc/host/atmel-mci.c
index fd96ab9..1f0f30f 100644
--- a/drivers/mmc/host/atmel-mci.c
+++ b/drivers/mmc/host/atmel-mci.c
@@ -268,7 +268,7 @@ static int atmci_req_show(struct seq_file *s, void *v)
 				"CMD%u(0x%x) flg %x rsp %x %x %x %x err %d\n",
 				cmd->opcode, cmd->arg, cmd->flags,
 				cmd->resp[0], cmd->resp[1], cmd->resp[2],
-				cmd->resp[2], cmd->error);
+				cmd->resp[3], cmd->error);
 		if (data)
 			seq_printf(s, "DATA %u / %u * %u flg %x err %d\n",
 				data->bytes_xfered, data->blocks,
@@ -278,7 +278,7 @@ static int atmci_req_show(struct seq_file *s, void *v)
 				"CMD%u(0x%x) flg %x rsp %x %x %x %x err %d\n",
 				stop->opcode, stop->arg, stop->flags,
 				stop->resp[0], stop->resp[1], stop->resp[2],
-				stop->resp[2], stop->error);
+				stop->resp[3], stop->error);
 	}
 
 	spin_unlock_bh(&slot->host->lock);
-- 
1.5.6.5

