Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757422Ab1I2TsM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 15:48:12 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:56978
	"HELO p3plsmtps2ded03-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752423Ab1I2TsJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 15:48:09 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org, ohering@suse.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: [PATCH 13/24] Staging: hv: mousevsc: Get rid of the unused state: num_outstanding_req
Date: Thu, 29 Sep 2011 11:54:53 -0700
Message-Id: <1317322504-9788-13-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1317322504-9788-1-git-send-email-kys@microsoft.com>
References: <1317322456-9747-1-git-send-email-kys@microsoft.com>
 <1317322504-9788-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Get rid of the unused state: num_outstanding_req in struct mousevsc_dev.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/staging/hv/hv_mouse.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/hv/hv_mouse.c b/drivers/staging/hv/hv_mouse.c
index 326d972..092c0ff 100644
--- a/drivers/staging/hv/hv_mouse.c
+++ b/drivers/staging/hv/hv_mouse.c
@@ -157,7 +157,6 @@ struct mousevsc_dev {
 	struct hv_device	*device;
 	/* 0 indicates the device is being destroyed */
 	atomic_t		ref_count;
-	int			num_outstanding_req;
 	unsigned char		init_complete;
 	struct mousevsc_prt_msg	protocol_req;
 	struct mousevsc_prt_msg	protocol_resp;
@@ -729,8 +728,6 @@ static int mousevsc_on_device_remove(struct hv_device *device)
 	 *
 	 * so that outstanding requests can be completed.
 	 */
-	while (input_dev->num_outstanding_req)
-		udelay(100);
 
 	input_dev = final_release_input_device(device);
 
-- 
1.7.4.1

