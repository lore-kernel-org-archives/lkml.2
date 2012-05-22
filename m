Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754384Ab2EVN1M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 09:27:12 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:64557 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751748Ab2EVN1I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 09:27:08 -0400
From: sjur.brandeland@stericsson.com
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: Loic PALLARDY <loic.pallardy@stericsson.com>,
        Ludovic BARRE <ludovic.barre@stericsson.com>,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjurbren@gmail.com>,
        =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjur.brandeland@stericsson.com>
Subject: [RFC 1/6] remoteproc: fix print format warnings
Date: Tue, 22 May 2012 15:26:52 +0200
Message-Id: <1337693217-15466-2-git-send-email-sjur.brandeland@stericsson.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1337693217-15466-1-git-send-email-sjur.brandeland@stericsson.com>
References: <1337693217-15466-1-git-send-email-sjur.brandeland@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sjur Brændeland <sjur.brandeland@stericsson.com>

Fix compile warnings when printing values of type size_t

Signed-off-by: Sjur Brændeland <sjur.brandeland@stericsson.com>
---
 drivers/remoteproc/remoteproc_core.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/remoteproc/remoteproc_core.c b/drivers/remoteproc/remoteproc_core.c
index ee15c68..1bba479 100644
--- a/drivers/remoteproc/remoteproc_core.c
+++ b/drivers/remoteproc/remoteproc_core.c
@@ -247,7 +247,7 @@ rproc_load_segments(struct rproc *rproc, const u8 *elf_data, size_t len)
 		}
 
 		if (offset + filesz > len) {
-			dev_err(dev, "truncated fw: need 0x%x avail 0x%x\n",
+			dev_err(dev, "truncated fw: need 0x%x avail 0x%zx\n",
 					offset + filesz, len);
 			ret = -EINVAL;
 			break;
@@ -934,7 +934,7 @@ static void rproc_resource_cleanup(struct rproc *rproc)
 		unmapped = iommu_unmap(rproc->domain, entry->da, entry->len);
 		if (unmapped != entry->len) {
 			/* nothing much to do besides complaining */
-			dev_err(dev, "failed to unmap %u/%u\n", entry->len,
+			dev_err(dev, "failed to unmap %u/%zu\n", entry->len,
 								unmapped);
 		}
 
@@ -1020,7 +1020,7 @@ static int rproc_fw_boot(struct rproc *rproc, const struct firmware *fw)
 
 	ehdr = (struct elf32_hdr *)fw->data;
 
-	dev_info(dev, "Booting fw image %s, size %d\n", name, fw->size);
+	dev_info(dev, "Booting fw image %s, size %zd\n", name, fw->size);
 
 	/*
 	 * if enabling an IOMMU isn't relevant for this rproc, this is
-- 
1.7.9.5

