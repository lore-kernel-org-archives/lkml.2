Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757732Ab0LMNRR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 08:17:17 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:51395 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757699Ab0LMNRP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 08:17:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=knPD9VGL4iCi4Yprnh3iPDXR3Pz8n1FQxd1G/+5cPpQJQ9Qm2E46ySxQtfovJwyHSQ
         iRWtdchF0S0cy58zI1T6Ea2cyhcsr5153Nyrc7AVNzEbEIPQmfkH8l/YiNTFej9PnXDh
         2OSfpN8MUO7lZS0Askd1PXl/59WqgjYX55nYM=
From: Namhyung Kim <namhyung@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>, Martyn Welch <martyn.welch@ge.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/8] Staging: vme_ca91cx42: mark ca91cx42_driver->base as __iomem
Date: Mon, 13 Dec 2010 22:16:31 +0900
Message-Id: <1292246196-2332-3-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.3.3.400.g93cef
In-Reply-To: <1292246196-2332-1-git-send-email-namhyung@gmail.com>
References: <1292246196-2332-1-git-send-email-namhyung@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ca91cx42_driver->base is mapped by ioremap_nocache() thus
should be marked as __iomem.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 drivers/staging/vme/bridges/vme_ca91cx42.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/vme/bridges/vme_ca91cx42.h b/drivers/staging/vme/bridges/vme_ca91cx42.h
index e72c65b193ec..02a7c794db05 100644
--- a/drivers/staging/vme/bridges/vme_ca91cx42.h
+++ b/drivers/staging/vme/bridges/vme_ca91cx42.h
@@ -39,7 +39,7 @@
 
 /* Structure used to hold driver specific information */
 struct ca91cx42_driver {
-	void *base;	/* Base Address of device registers */
+	void __iomem *base;	/* Base Address of device registers */
 	wait_queue_head_t dma_queue;
 	wait_queue_head_t iack_queue;
 	wait_queue_head_t mbox_queue;
-- 
1.7.3.3.400.g93cef

