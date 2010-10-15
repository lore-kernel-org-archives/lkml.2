Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755760Ab0JOF00 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 01:26:26 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:34806 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754146Ab0JOF0Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 01:26:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=EAZADLB40yjPz14oFOBq3ZC2gzwHiArkam3AuBwZeZ6H9Ej9ti72OyCNtS+kogQHmC
         ZWvI2k9bwNg+rU4eKy/DGyWcIN4FQsOTCvK/8V2nxtSieDIzLzCEbzoIHtZPwdqT6b66
         MbfGGDUsy6vy9CjmfFIpdA0yTpw61qt1P9gJ8=
Subject: [PATCH 2/3] USB: isp1362-hcd - use resource_size instead of
	defining its own resource_len macro
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Mike Frysinger <vapier@gentoo.org>,
        Lothar Wassmann <LW@KARO-electronics.de>, linux-usb@vger.kernel.org
In-Reply-To: <1287120381.20429.1.camel@mola>
References: <1287120381.20429.1.camel@mola>
Content-Type: text/plain
Date: Fri, 15 Oct 2010 13:27:57 +0800
Message-Id: <1287120477.20429.3.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/usb/host/isp1362-hcd.c |   18 ++++++++----------
 1 files changed, 8 insertions(+), 10 deletions(-)

diff --git a/drivers/usb/host/isp1362-hcd.c b/drivers/usb/host/isp1362-hcd.c
index ae30440..8196fa1 100644
--- a/drivers/usb/host/isp1362-hcd.c
+++ b/drivers/usb/host/isp1362-hcd.c
@@ -2649,8 +2649,6 @@ static struct hc_driver isp1362_hc_driver = {
 
 /*-------------------------------------------------------------------------*/
 
-#define resource_len(r) (((r)->end - (r)->start) + 1)
-
 static int __devexit isp1362_remove(struct platform_device *pdev)
 {
 	struct usb_hcd *hcd = platform_get_drvdata(pdev);
@@ -2672,12 +2670,12 @@ static int __devexit isp1362_remove(struct platform_device *pdev)
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
 	DBG(0, "%s: release mem_region: %08lx\n", __func__, (long unsigned int)res->start);
 	if (res)
-		release_mem_region(res->start, resource_len(res));
+		release_mem_region(res->start, resource_size(res));
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	DBG(0, "%s: release mem_region: %08lx\n", __func__, (long unsigned int)res->start);
 	if (res)
-		release_mem_region(res->start, resource_len(res));
+		release_mem_region(res->start, resource_size(res));
 
 	DBG(0, "%s: put_hcd\n", __func__);
 	usb_put_hcd(hcd);
@@ -2723,21 +2721,21 @@ static int __init isp1362_probe(struct platform_device *pdev)
 		goto err1;
 	}
 
-	if (!request_mem_region(addr->start, resource_len(addr), hcd_name)) {
+	if (!request_mem_region(addr->start, resource_size(addr), hcd_name)) {
 		retval = -EBUSY;
 		goto err1;
 	}
-	addr_reg = ioremap(addr->start, resource_len(addr));
+	addr_reg = ioremap(addr->start, resource_size(addr));
 	if (addr_reg == NULL) {
 		retval = -ENOMEM;
 		goto err2;
 	}
 
-	if (!request_mem_region(data->start, resource_len(data), hcd_name)) {
+	if (!request_mem_region(data->start, resource_size(data), hcd_name)) {
 		retval = -EBUSY;
 		goto err3;
 	}
-	data_reg = ioremap(data->start, resource_len(data));
+	data_reg = ioremap(data->start, resource_size(data));
 	if (data_reg == NULL) {
 		retval = -ENOMEM;
 		goto err4;
@@ -2795,13 +2793,13 @@ static int __init isp1362_probe(struct platform_device *pdev)
 	iounmap(data_reg);
  err4:
 	DBG(0, "%s: Releasing mem region %08lx\n", __func__, (long unsigned int)data->start);
-	release_mem_region(data->start, resource_len(data));
+	release_mem_region(data->start, resource_size(data));
  err3:
 	DBG(0, "%s: Unmapping addr_reg @ %p\n", __func__, addr_reg);
 	iounmap(addr_reg);
  err2:
 	DBG(0, "%s: Releasing mem region %08lx\n", __func__, (long unsigned int)addr->start);
-	release_mem_region(addr->start, resource_len(addr));
+	release_mem_region(addr->start, resource_size(addr));
  err1:
 	pr_err("%s: init error, %d\n", __func__, retval);
 
-- 
1.7.2



