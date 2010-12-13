Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757803Ab0LMNRc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 08:17:32 -0500
Received: from mail-gx0-f180.google.com ([209.85.161.180]:50112 "EHLO
	mail-gx0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757764Ab0LMNR1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 08:17:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=BznqmLzVcLEYfHjwNjgMCMlq3mHdm5E/SNtHzlto79b9BGzcm3TukmP6QdS732m1PJ
         JucArPaqSOK/Zm9dfugZJqTyzrzmkH84JI6fQT5kEWxD73tlTO00ofjk16FvGmRyQz5Y
         pZvbZxuSa4yqkHgUxAJnpU3ntmfl5ZI0HWJKw=
From: Namhyung Kim <namhyung@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>, Martyn Welch <martyn.welch@ge.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 6/8] Staging: vme_tsi148: mark tsi148_driver->base as __iomem
Date: Mon, 13 Dec 2010 22:16:34 +0900
Message-Id: <1292246196-2332-6-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.3.3.400.g93cef
In-Reply-To: <1292246196-2332-1-git-send-email-namhyung@gmail.com>
References: <1292246196-2332-1-git-send-email-namhyung@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tsi148_driver->base is mapped by ioremap_nocache() thus
should be marked as __iomem.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 drivers/staging/vme/bridges/vme_tsi148.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/vme/bridges/vme_tsi148.h b/drivers/staging/vme/bridges/vme_tsi148.h
index bda64ef85754..9f97fa8084e8 100644
--- a/drivers/staging/vme/bridges/vme_tsi148.h
+++ b/drivers/staging/vme/bridges/vme_tsi148.h
@@ -35,7 +35,7 @@
 
 /* Structure used to hold driver specific information */
 struct tsi148_driver {
-	void *base;	/* Base Address of device registers */
+	void __iomem *base;	/* Base Address of device registers */
 	wait_queue_head_t dma_queue[2];
 	wait_queue_head_t iack_queue;
 	void (*lm_callback[4])(int);	/* Called in interrupt handler */
-- 
1.7.3.3.400.g93cef

