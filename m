Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752967Ab2LAOYW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2012 09:24:22 -0500
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:39248
	"EHLO p3plsmtps2ded03.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752266Ab2LAOXk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2012 09:23:40 -0500
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 25/28] Drivers: hv: Enable protocol negotiation with win8 hosts
Date: Sat,  1 Dec 2012 06:46:56 -0800
Message-Id: <1354373219-31374-25-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1354373219-31374-1-git-send-email-kys@microsoft.com>
References: <1354373160-31332-1-git-send-email-kys@microsoft.com>
 <1354373219-31374-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that we have implemented all of the Win8 (WS2012) functionality, negotiate
Win8 protocol with the host.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/hv/connection.c |    2 +-
 include/linux/hyperv.h  |    1 +
 2 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/hv/connection.c b/drivers/hv/connection.c
index ac71653..3965537 100644
--- a/drivers/hv/connection.c
+++ b/drivers/hv/connection.c
@@ -194,7 +194,7 @@ int vmbus_connect(void)
 	 * version.
 	 */
 
-	version = VERSION_WS2008;
+	version = VERSION_CURRENT;
 
 	do {
 		ret = vmbus_negotiate_version(msginfo, version);
diff --git a/include/linux/hyperv.h b/include/linux/hyperv.h
index 8c3cb1f..5095b06 100644
--- a/include/linux/hyperv.h
+++ b/include/linux/hyperv.h
@@ -434,6 +434,7 @@ hv_get_ringbuffer_availbytes(struct hv_ring_buffer_info *rbi,
 
 #define VERSION_INVAL -1
 
+#define VERSION_CURRENT VERSION_WIN8
 
 /* Make maximum size of pipe payload of 16K */
 #define MAX_PIPE_DATA_PAYLOAD		(sizeof(u8) * 16384)
-- 
1.7.4.1

