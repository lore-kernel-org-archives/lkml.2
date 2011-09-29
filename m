Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757341Ab1I2Sew (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 14:34:52 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:35769
	"HELO p3plsmtps2ded01-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754482Ab1I2ScS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 14:32:18 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org, ohering@suse.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: [PATCH 12/24] Staging: hv: mousevsc: Free allocated memory in free_input_device()
Date: Thu, 29 Sep 2011 11:54:52 -0700
Message-Id: <1317322504-9788-12-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1317322504-9788-1-git-send-email-kys@microsoft.com>
References: <1317322456-9747-1-git-send-email-kys@microsoft.com>
 <1317322504-9788-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Free all allocated memory in free_input_device().

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/staging/hv/hv_mouse.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/hv/hv_mouse.c b/drivers/staging/hv/hv_mouse.c
index 57bc4a3..326d972 100644
--- a/drivers/staging/hv/hv_mouse.c
+++ b/drivers/staging/hv/hv_mouse.c
@@ -199,6 +199,8 @@ static struct mousevsc_dev *alloc_input_device(struct hv_device *device)
 static void free_input_device(struct mousevsc_dev *device)
 {
 	WARN_ON(atomic_read(&device->ref_count) != 0);
+	kfree(device->hid_desc);
+	kfree(device->report_desc);
 	kfree(device);
 }
 
-- 
1.7.4.1

