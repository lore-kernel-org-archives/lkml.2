Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754528Ab1GORaO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 13:30:14 -0400
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:37193
	"HELO p3plsmtps2ded02-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754024Ab1GOR37 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 13:29:59 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: [PATCH 028/117] Staging: hv: storvsc: Get rid of the device type guid from storvsc_drv.c
Date: Fri, 15 Jul 2011 10:46:16 -0700
Message-Id: <1310752065-27895-28-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1310752065-27895-1-git-send-email-kys@microsoft.com>
References: <1310752024-27854-1-git-send-email-kys@microsoft.com>
 <1310752065-27895-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Get rid of the device type guid from storvsc_drv.c as it is no longer used.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/staging/hv/storvsc_drv.c |   11 -----------
 1 files changed, 0 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/hv/storvsc_drv.c b/drivers/staging/hv/storvsc_drv.c
index f594ca4..46cb81a 100644
--- a/drivers/staging/hv/storvsc_drv.c
+++ b/drivers/staging/hv/storvsc_drv.c
@@ -43,14 +43,6 @@ MODULE_PARM_DESC(storvsc_ringbuffer_size, "Ring buffer size (bytes)");
 
 static const char *driver_name = "storvsc";
 
-/* {ba6163d9-04a1-4d29-b605-72e2ffb1dc7f} */
-static const uuid_le stor_vsci_device_type = {
-	.b = {
-		0xd9, 0x63, 0x61, 0xba, 0xa1, 0x04, 0x29, 0x4d,
-		0xb6, 0x05, 0x72, 0xe2, 0xff, 0xb1, 0xdc, 0x7f
-	}
-};
-
 struct hv_host_device {
 	struct hv_device *dev;
 	struct kmem_cache *request_pool;
@@ -759,9 +751,6 @@ static int __init storvsc_drv_init(void)
 	sizeof(struct vstor_packet) + sizeof(u64),
 	sizeof(u64)));
 
-	memcpy(&drv->dev_type, &stor_vsci_device_type,
-	       sizeof(uuid_le));
-
 	if (max_outstanding_req_per_channel <
 	    STORVSC_MAX_IO_REQUESTS)
 		return -1;
-- 
1.7.4.1

