Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754876Ab2EPUjk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 16:39:40 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:49919
	"HELO p3plsmtps2ded01-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751754Ab2EPUji (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 16:39:38 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, virtualization@lists.osdl.org,
        ohering@suse.com, jkosina@suse.cz
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 1/1] Drivers: hid: hid-hyperv.c: Set the hid drvdata correctly
Date: Wed, 16 May 2012 13:50:13 -0700
Message-Id: <1337201413-9857-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Set the hid drvdata prior to invoking hid_add_device() as hid_add_device()
expects this state to be set. This bug was introduced in the recent hid
changes that were made in:

commit 07d9ab4f0e52cb2a383596e5ebbbd20232501393
HID: hid-hyperv: Do not use hid_parse_report() directly

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/hid/hid-hyperv.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/hid/hid-hyperv.c b/drivers/hid/hid-hyperv.c
index 032e6c0..3d62781 100644
--- a/drivers/hid/hid-hyperv.c
+++ b/drivers/hid/hid-hyperv.c
@@ -516,11 +516,12 @@ static int mousevsc_probe(struct hv_device *device,
 
 	sprintf(hid_dev->name, "%s", "Microsoft Vmbus HID-compliant Mouse");
 
+	hid_set_drvdata(hid_dev, device);
+
 	ret = hid_add_device(hid_dev);
 	if (ret)
 		goto probe_err1;
 
-	hid_set_drvdata(hid_dev, device);
 
 	ret = hid_parse(hid_dev);
 	if (ret) {
-- 
1.7.4.1

