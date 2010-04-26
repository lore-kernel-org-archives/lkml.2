Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755401Ab0DZWex (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 18:34:53 -0400
Received: from mail.gmx.net ([213.165.64.20]:54827 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754907Ab0DZWev (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 18:34:51 -0400
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX184ElQoPKM4Qq5BMbcClcdkERvVSo/CJX9Nabl9yw
	s3QHT9pSQnPdO7
From: Peter Huewe <PeterHuewe@gmx.de>
To: "Greg Kroah-Hartman" <gregkh@suse.de>
Subject: [PATCH] staging/otus: Add null check and fix coding style issue
Date: Tue, 27 Apr 2010 00:34:49 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.33.2; KDE/4.3.5; x86_64; ; )
Cc: David Binderman <dcb314@hotmail.com>,
       D Pranith Kumar <bobby.prani@gmail.com>,
       Alexander Beregalov <a.beregalov@gmail.com>,
       Simon Horman <horms@verge.net.au>, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201004270034.49340.PeterHuewe@gmx.de>
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.52000000000000002
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Huewe <peterhuewe@gmx.de>

This patch removes mixing of declarations and code and adds a null-test
after a kmalloc.

Patch against linux-next as of 20100427

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/staging/otus/ioctl.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/otus/ioctl.c b/drivers/staging/otus/ioctl.c
index 84be4b2..cface46 100644
--- a/drivers/staging/otus/ioctl.c
+++ b/drivers/staging/otus/ioctl.c
@@ -867,6 +867,7 @@ int usbdrvwext_giwscan(struct net_device *dev,
 	char *current_ev = extra;
 	char *end_buf;
 	int i;
+	struct zsBssListV1 *pBssList;
 	/* BssList = wd->sta.pBssList; */
 	/* zmw_get_wlan_dev(dev); */
 
@@ -874,8 +875,10 @@ int usbdrvwext_giwscan(struct net_device *dev,
 		return 0;
 
 	/* struct zsBssList BssList; */
-	struct zsBssListV1 *pBssList = kmalloc(sizeof(struct zsBssListV1),
-								GFP_KERNEL);
+	pBssList = kmalloc(sizeof(struct zsBssListV1), GFP_KERNEL);
+	if (pBssList == NULL)
+		return -ENOMEM;
+
 	if (data->length == 0)
 		end_buf = extra + IW_SCAN_MAX_DATA;
 	else
-- 
1.6.4.4

