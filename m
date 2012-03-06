Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758946Ab2CFK2e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 05:28:34 -0500
Received: from mail-yw0-f74.google.com ([209.85.213.74]:64118 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758906Ab2CFK2U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 05:28:20 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of torne@google.com designates 10.236.115.136 as permitted sender) smtp.mail=torne@google.com; dkim=pass header.i=torne@google.com
MIME-Version: 1.0
From: "Torne (Richard Coles)" <torne@google.com>
To: cjb@laptop.org
Cc: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Torne (Richard Coles)" <torne@google.com>
Subject: [PATCH] MMC: sdhci: remove too large timeout warning
Date: Tue,  6 Mar 2012 10:27:28 +0000
Message-Id: <1331029648-29175-1-git-send-email-torne@google.com>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Torne (Richard Coles)" <torne@google.com>

Some MMC cards specify timeouts that are larger than the highest
possible timeout in the host controller. sdhci is the only host
controller driver which complains about this; remove the warning to
match the behaviour of the other drivers.

Signed-off-by: Torne (Richard Coles) <torne@google.com>
---
 drivers/mmc/host/sdhci.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
index 8d66706..85d4d05 100644
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -680,8 +680,6 @@ static u8 sdhci_calc_timeout(struct sdhci_host *host, struct mmc_command *cmd)
 	}
 
 	if (count >= 0xF) {
-		pr_warning("%s: Too large timeout requested for CMD%d!\n",
-		       mmc_hostname(host->mmc), cmd->opcode);
 		count = 0xE;
 	}
 
-- 
1.7.7.3

