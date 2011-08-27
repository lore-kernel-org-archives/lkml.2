Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752595Ab1H0SMt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Aug 2011 14:12:49 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:55027
	"HELO p3plsmtps2ded03-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751637Ab1H0SLS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Aug 2011 14:11:18 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: [PATCH 02/46] Staging: hv: storvsc: Do not aquire an unnecessary reference on stor_device
Date: Sat, 27 Aug 2011 11:31:01 -0700
Message-Id: <1314469905-7058-2-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314469905-7058-1-git-send-email-kys@microsoft.com>
References: <1314469874-7017-1-git-send-email-kys@microsoft.com>
 <1314469905-7058-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On entry into storvsc_on_io_completion() we have already acquired a reference
on the stor_device; there is no need to acquire an additional reference here.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/staging/hv/storvsc.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/hv/storvsc.c b/drivers/staging/hv/storvsc.c
index 8c62829..cd38cd6 100644
--- a/drivers/staging/hv/storvsc.c
+++ b/drivers/staging/hv/storvsc.c
@@ -232,9 +232,7 @@ static void storvsc_on_io_completion(struct hv_device *device,
 	struct storvsc_device *stor_device;
 	struct vstor_packet *stor_pkt;
 
-	stor_device = must_get_stor_device(device);
-	if (!stor_device)
-		return;
+	stor_device = (struct storvsc_device *)device->ext;
 
 	stor_pkt = &request->vstor_packet;
 
@@ -279,7 +277,6 @@ static void storvsc_on_io_completion(struct hv_device *device,
 		wake_up(&stor_device->waiting_to_drain);
 
 
-	put_stor_device(device);
 }
 
 static void storvsc_on_receive(struct hv_device *device,
-- 
1.7.4.1

