Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932729Ab1EJIto (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 04:49:44 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:42660
	"HELO p3plsmtps2ded03-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755991Ab1EJIau (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 04:30:50 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 143/206] Staging: hv: Make storvsc_drv an instance of hv_driver
Date: Mon,  9 May 2011 14:57:05 -0700
Message-Id: <1304978288-22999-143-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1304978288-22999-1-git-send-email-kys@microsoft.com>
References: <1304978242-22958-1-git-send-email-kys@microsoft.com>
 <1304978288-22999-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In preparation for eliminating struct storvsc_driver,
make the variable storvsc_drv an instance of struct hv_driver.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/storvsc_drv.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/hv/storvsc_drv.c b/drivers/staging/hv/storvsc_drv.c
index de6984f..907d855 100644
--- a/drivers/staging/hv/storvsc_drv.c
+++ b/drivers/staging/hv/storvsc_drv.c
@@ -751,9 +751,9 @@ static int storvsc_probe(struct hv_device *device)
 
 /* The one and only one */
 
-static struct storvsc_driver storvsc_drv = {
-	.base.probe = storvsc_probe,
-	.base.remove = storvsc_remove,
+static struct hv_driver storvsc_drv = {
+	.probe = storvsc_probe,
+	.remove = storvsc_remove,
 };
 
 
@@ -763,7 +763,7 @@ static struct storvsc_driver storvsc_drv = {
 static int storvsc_drv_init(void)
 {
 	int ret;
-	struct hv_driver *drv = &storvsc_drv.base;
+	struct hv_driver *drv = &storvsc_drv;
 	u32 max_outstanding_req_per_channel;
 
 	/*
@@ -805,7 +805,7 @@ static int storvsc_drv_exit_cb(struct device *dev, void *data)
 
 static void storvsc_drv_exit(void)
 {
-	struct hv_driver *drv = &storvsc_drv.base;
+	struct hv_driver *drv = &storvsc_drv;
 	struct device *current_dev = NULL;
 	int ret;
 
-- 
1.7.4.1

