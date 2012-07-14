Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752845Ab2GNUUD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2012 16:20:03 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:51124
	"HELO p3plsmtps2ded03-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751611Ab2GNUTy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2012 16:19:54 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, virtualization@lists.osdl.org,
        olaf@aepfle.de, apw@canonical.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 01/15] Drivers: hv: Format GUIDS as per MSFT standards
Date: Sat, 14 Jul 2012 13:34:06 -0700
Message-Id: <1342298060-12662-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1342297930-12607-1-git-send-email-kys@microsoft.com>
References: <1342297930-12607-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Format GUIDS as per MSFT standard. This makes interacting with MSFT
tool stack easier.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/hv/vmbus_drv.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/hv/vmbus_drv.c b/drivers/hv/vmbus_drv.c
index a220e57..1f7e54a 100644
--- a/drivers/hv/vmbus_drv.c
+++ b/drivers/hv/vmbus_drv.c
@@ -147,7 +147,7 @@ static ssize_t vmbus_show_device_attr(struct device *dev,
 
 	if (!strcmp(dev_attr->attr.name, "class_id")) {
 		ret = sprintf(buf, "{%02x%02x%02x%02x-%02x%02x-%02x%02x-"
-			       "%02x%02x%02x%02x%02x%02x%02x%02x}\n",
+			       "%02x%02x-%02x%02x%02x%02x%02x%02x}\n",
 			       device_info->chn_type.b[3],
 			       device_info->chn_type.b[2],
 			       device_info->chn_type.b[1],
@@ -166,7 +166,7 @@ static ssize_t vmbus_show_device_attr(struct device *dev,
 			       device_info->chn_type.b[15]);
 	} else if (!strcmp(dev_attr->attr.name, "device_id")) {
 		ret = sprintf(buf, "{%02x%02x%02x%02x-%02x%02x-%02x%02x-"
-			       "%02x%02x%02x%02x%02x%02x%02x%02x}\n",
+			       "%02x%02x-%02x%02x%02x%02x%02x%02x}\n",
 			       device_info->chn_instance.b[3],
 			       device_info->chn_instance.b[2],
 			       device_info->chn_instance.b[1],
-- 
1.7.4.1

