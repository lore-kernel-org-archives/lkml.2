Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756809Ab2LNQIY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 11:08:24 -0500
Received: from mail-lb0-f174.google.com ([209.85.217.174]:52687 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756761Ab2LNQHw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 11:07:52 -0500
From: =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjur.brandeland@stericsson.com>
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjur@brendeland.net>,
        =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjur.brandeland@stericsson.com>
Subject: [RFCv2 10/11] remoteproc: Find resource table in device memory
Date: Fri, 14 Dec 2012 17:06:59 +0100
Message-Id: <1355501220-4572-11-git-send-email-sjur.brandeland@stericsson.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355501220-4572-1-git-send-email-sjur.brandeland@stericsson.com>
References: <1355501220-4572-1-git-send-email-sjur.brandeland@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Call rproc_get_rsctab_addr() to get the address
of the resource table in shared memory.

Signed-off-by: Sjur Brændeland <sjur.brandeland@stericsson.com>
---
 drivers/remoteproc/remoteproc_core.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/remoteproc/remoteproc_core.c b/drivers/remoteproc/remoteproc_core.c
index 8a7de5c..f95c08c 100644
--- a/drivers/remoteproc/remoteproc_core.c
+++ b/drivers/remoteproc/remoteproc_core.c
@@ -854,6 +854,13 @@ static void rproc_fw_load(const struct firmware *fw, void *context)
 		goto clean_up;
 	}
 
+	/* Find the new location of the resource table in device memory */
+	table  = rproc_get_rsctab_addr(rproc, fw);
+	if (!table) {
+		ret = -EINVAL;
+		goto clean_up;
+	}
+
 	ret = rproc_handle_resource(rproc, table, tablesz, rproc_handle_reg);
 	if (ret) {
 		dev_err(dev, "Failed to process resources: %d\n", ret);
-- 
1.7.5.4

