Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751967Ab1ARPjW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 10:39:22 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:44287 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751229Ab1ARPjV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 10:39:21 -0500
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Haiyang Zhang <haiyangz@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging/hv/osd: don't reimplement ALIGN macro
Date: Tue, 18 Jan 2011 16:39:11 +0100
Message-Id: <1295365151-9527-1-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.7.2.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 drivers/staging/hv/osd.h |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/hv/osd.h b/drivers/staging/hv/osd.h
index ce064e8..61ae54c 100644
--- a/drivers/staging/hv/osd.h
+++ b/drivers/staging/hv/osd.h
@@ -28,10 +28,9 @@
 #include <linux/workqueue.h>
 
 /* Defines */
-#define ALIGN_UP(value, align)	(((value) & (align-1)) ?		\
-				 (((value) + (align-1)) & ~(align-1)) :	\
-				 (value))
+#define ALIGN_UP(value, align)		ALIGN((value), (align))
 #define ALIGN_DOWN(value, align)	((value) & ~(align-1))
+
 #define NUM_PAGES_SPANNED(addr, len)	((ALIGN_UP(addr+len, PAGE_SIZE) - \
 					 ALIGN_DOWN(addr, PAGE_SIZE)) >>  \
 					 PAGE_SHIFT)
-- 
1.7.2.3

