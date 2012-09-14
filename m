Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760019Ab2INVha (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 17:37:30 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:62454 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758703Ab2INVfp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 17:35:45 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Nicolas Pitre <nico@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org
Subject: [PATCH 22/24] scsi: eesox: use __iomem pointers for MMIO
Date: Fri, 14 Sep 2012 23:34:50 +0200
Message-Id: <1347658492-11608-23-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1347658492-11608-1-git-send-email-arnd@arndb.de>
References: <1347658492-11608-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:YQtX/5fpKn71c3/NYeeQQVYNh3572Abjwh/XkDPMT0d
 GtyVflhQz4NLU8QoVe9OPo5wojWtLKpR7alV0M8cyz8oXKGSNV
 hlLnASTiXp65RHgznuGdEIxSCTOetuYPewTWDIULdUwS5Dho1m
 /AFTq/ZwxTVkrKy+szwKhMl+BQMFY7RfUaTqaOztpB2esS71sp
 rX4C1Y27FWlD6S5hiioFlhwa3gkAMbH6cKujYe06vuF6LiLGSL
 IVtYS2/EWqnZ+IU1387nef/1MlCPe2YbwJxmVJkNStJmdSPdql
 80ddarbAuc0l2P7Z6I6JdtyBOvmHSGiyuNcMCqRyqqI3paKKeQ
 /GXeH9ZuTFwt7vGn4j3PWik94NURLVnlu3dCBwZk+djK0LfLwo
 5JdL6rTb0KbFQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ARM is moving to stricter checks on readl/write functions,
so we need to use the correct types everywhere.

Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/scsi/arm/eesox.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/arm/eesox.c b/drivers/scsi/arm/eesox.c
index edfd12b..968d083 100644
--- a/drivers/scsi/arm/eesox.c
+++ b/drivers/scsi/arm/eesox.c
@@ -273,7 +273,7 @@ static void eesoxscsi_buffer_out(void *buf, int length, void __iomem *base)
 {
 	const void __iomem *reg_fas = base + EESOX_FAS216_OFFSET;
 	const void __iomem *reg_dmastat = base + EESOX_DMASTAT;
-	const void __iomem *reg_dmadata = base + EESOX_DMADATA;
+	void __iomem *reg_dmadata = base + EESOX_DMADATA;
 
 	do {
 		unsigned int status;
-- 
1.7.10

