Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755590Ab1GORws (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 13:52:48 -0400
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:37151
	"HELO p3plsmtps2ded02-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753972Ab1GOR36 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 13:29:58 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: [PATCH 017/117] Staging: hv: mouse: Do not auto-load the mouse driver
Date: Fri, 15 Jul 2011 10:46:05 -0700
Message-Id: <1310752065-27895-17-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1310752065-27895-1-git-send-email-kys@microsoft.com>
References: <1310752024-27854-1-git-send-email-kys@microsoft.com>
 <1310752065-27895-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The mouse driver is not functional and so, prevent auto-loading
of this driver. Earlier we added the MODULE_DEVICE_TABLE() line
to verify that the appropriate module alias was generated.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/staging/hv/hv_mouse.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/hv/hv_mouse.c b/drivers/staging/hv/hv_mouse.c
index d6441d6..95986fb 100644
--- a/drivers/staging/hv/hv_mouse.c
+++ b/drivers/staging/hv/hv_mouse.c
@@ -931,7 +931,10 @@ static const struct hv_vmbus_device_id id_table[] = {
 	},
 };
 
-MODULE_DEVICE_TABLE(vmbus, id_table);
+/*
+ * The mouse driver is not functional; do not auto-load it.
+ */
+/* MODULE_DEVICE_TABLE(vmbus, id_table); */
 
 static struct  hv_driver mousevsc_drv = {
 	.id_table = id_table,
-- 
1.7.4.1

