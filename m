Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757936Ab1K3Qw4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 11:52:56 -0500
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:47584
	"HELO p3plsmtps2ded01-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757124Ab1K3Qwx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 11:52:53 -0500
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org, ohering@suse.com, joe@perches.com,
        dmitry.torokhov@gmail.com, jkosina@suse.cz
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: [PATCH 1/1] Staging: hv: mousevsc: Properly add the hid device
Date: Wed, 30 Nov 2011 08:52:23 -0800
Message-Id: <1322671943-6788-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need to properly add the hid device to correctly initialize the
sysfs state. While this patch is against the staging tree; Jiri,
please pick up this patch as you merge the Hyper-V mouse driver.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Reported-by: Fuzhou Chen <fuzhouch@microsoft.com>
---
 drivers/staging/hv/hv_mouse.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/hv/hv_mouse.c b/drivers/staging/hv/hv_mouse.c
index a28c549..66da8e3 100644
--- a/drivers/staging/hv/hv_mouse.c
+++ b/drivers/staging/hv/hv_mouse.c
@@ -519,6 +519,10 @@ static int mousevsc_probe(struct hv_device *device,
 
 	sprintf(hid_dev->name, "%s", "Microsoft Vmbus HID-compliant Mouse");
 
+	ret = hid_add_device(hid_dev);
+	if (ret)
+		goto probe_err1;
+
 	ret = hid_parse_report(hid_dev, input_dev->report_desc,
 				input_dev->report_desc_size);
 
-- 
1.7.4.1

