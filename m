Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755034Ab2FFNil (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 09:38:41 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:54894 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754840Ab2FFNii (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 09:38:38 -0400
From: sjur.brandeland@stericsson.com
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: Loic PALLARDY <loic.pallardy@stericsson.com>,
        Ludovic BARRE <ludovic.barre@stericsson.com>,
        linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjurbren@gmail.com>,
        =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjur.brandeland@stericsson.com>
Subject: [PATCH 2/7] remoteproc: Fix missing fault indication in error-path
Date: Wed,  6 Jun 2012 15:38:22 +0200
Message-Id: <1338989907-25360-3-git-send-email-sjur.brandeland@stericsson.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1338989907-25360-1-git-send-email-sjur.brandeland@stericsson.com>
References: <1338989907-25360-1-git-send-email-sjur.brandeland@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sjur Brændeland <sjur.brandeland@stericsson.com>

If rproc_find_rsc_table() fails, rproc_fw_boot() must set
return-value before jumping to clean_up label. Otherwise no
error value is returned.

Signed-off-by: Sjur Brændeland <sjur.brandeland@stericsson.com>
---
 drivers/remoteproc/remoteproc_core.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/remoteproc/remoteproc_core.c b/drivers/remoteproc/remoteproc_core.c
index 1bba479..9d6343d 100644
--- a/drivers/remoteproc/remoteproc_core.c
+++ b/drivers/remoteproc/remoteproc_core.c
@@ -1041,8 +1041,10 @@ static int rproc_fw_boot(struct rproc *rproc, const struct firmware *fw)
 
 	/* look for the resource table */
 	table = rproc_find_rsc_table(rproc, fw->data, fw->size, &tablesz);
-	if (!table)
+	if (!table) {
+		ret = -EINVAL;
 		goto clean_up;
+	}
 
 	/* handle fw resources which are required to boot rproc */
 	ret = rproc_handle_boot_rsc(rproc, table, tablesz);
-- 
1.7.5.4

