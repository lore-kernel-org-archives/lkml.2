Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755473Ab1GORpW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 13:45:22 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:60120
	"HELO p3plsmtps2ded03-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754084Ab1GORaB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 13:30:01 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: [PATCH 029/117] Staging: hv: netvsc: Get rid of the dev_type guid from netvsc.c
Date: Fri, 15 Jul 2011 10:46:17 -0700
Message-Id: <1310752065-27895-29-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1310752065-27895-1-git-send-email-kys@microsoft.com>
References: <1310752024-27854-1-git-send-email-kys@microsoft.com>
 <1310752065-27895-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Get rid of the dev_type guid from netvsc.c, as it is no longer used.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/staging/hv/netvsc.c |   10 ----------
 1 files changed, 0 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/hv/netvsc.c b/drivers/staging/hv/netvsc.c
index 1506b53..6f4541b 100644
--- a/drivers/staging/hv/netvsc.c
+++ b/drivers/staging/hv/netvsc.c
@@ -35,15 +35,6 @@
 /* Globals */
 static const char *driver_name = "netvsc";
 
-/* {F8615163-DF3E-46c5-913F-F2D2F965ED0E} */
-static const uuid_le netvsc_device_type = {
-	.b = {
-		0x63, 0x51, 0x61, 0xF8, 0x3E, 0xDF, 0xc5, 0x46,
-		0x91, 0x3F, 0xF2, 0xD2, 0xF9, 0x65, 0xED, 0x0E
-	}
-};
-
-
 static struct netvsc_device *alloc_net_device(struct hv_device *device)
 {
 	struct netvsc_device *net_device;
@@ -1009,7 +1000,6 @@ int netvsc_initialize(struct hv_driver *drv)
 {
 
 	drv->name = driver_name;
-	memcpy(&drv->dev_type, &netvsc_device_type, sizeof(uuid_le));
 
 	return 0;
 }
-- 
1.7.4.1

