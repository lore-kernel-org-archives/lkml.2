Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752690Ab2LTTTS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 14:19:18 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:21491 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752465Ab2LTTNu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 14:13:50 -0500
From: Sasha Levin <sasha.levin@oracle.com>
To: Venkatraman S <svenkatr@ti.com>, Chris Ball <cjb@laptop.org>,
        linux-mmc@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Sasha Levin <sasha.levin@oracle.com>
Subject: [PATCH] mmc: omap_hsmmc: correct precedence of operators
Date: Thu, 20 Dec 2012 14:11:26 -0500
Message-Id: <1356030701-16284-18-git-send-email-sasha.levin@oracle.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1356030701-16284-1-git-send-email-sasha.levin@oracle.com>
References: <1356030701-16284-1-git-send-email-sasha.levin@oracle.com>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the current code, the condition in the if() doesn't make much sense due to
precedence of operators.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
---
 drivers/mmc/host/omap_hsmmc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mmc/host/omap_hsmmc.c b/drivers/mmc/host/omap_hsmmc.c
index bc58078..3ee2664 100644
--- a/drivers/mmc/host/omap_hsmmc.c
+++ b/drivers/mmc/host/omap_hsmmc.c
@@ -611,7 +611,7 @@ static int omap_hsmmc_context_restore(struct omap_hsmmc_host *host)
 	if (host->context_loss == context_loss)
 		return 1;
 
-	if (!OMAP_HSMMC_READ(host->base, SYSSTATUS) & RESETDONE)
+	if (!(OMAP_HSMMC_READ(host->base, SYSSTATUS) & RESETDONE))
 		return 1;
 
 	if (host->pdata->controller_flags & OMAP_HSMMC_SUPPORTS_DUAL_VOLT) {
-- 
1.8.0

