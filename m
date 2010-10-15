Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755638Ab0JOFYy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 01:24:54 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:56611 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753526Ab0JOFYw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 01:24:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=e6mRSHKKe+at0vf4sBzF+LI6+z9tBSVq/VwhYvldv9ETkGhiaDIoFbRyZfG3yKc/3e
         ELtr5R4YJe7w5/Y92PzuGloLlO8zMkkGFsp+UuDbXkH2ZGoW4uhjXWe/EGLA9oH+Tmja
         g6SzKC4KlK8EVqcwvY2s4FsZuKWEN4yvF/BIg=
Subject: [PATCH 1/3] USB: isp116x-hcd - use resource_size instead of
	defining its own resource_len macro
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Olav Kongas <ok@artecdesign.ee>, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-usb@vger.kernel.org
Content-Type: text/plain
Date: Fri, 15 Oct 2010 13:26:21 +0800
Message-Id: <1287120381.20429.1.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/usb/host/isp116x-hcd.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/host/isp116x-hcd.c b/drivers/usb/host/isp116x-hcd.c
index d9e8212..0da7fc0 100644
--- a/drivers/usb/host/isp116x-hcd.c
+++ b/drivers/usb/host/isp116x-hcd.c
@@ -1557,8 +1557,6 @@ static int isp116x_remove(struct platform_device *pdev)
 	return 0;
 }
 
-#define resource_len(r) (((r)->end - (r)->start) + 1)
-
 static int __devinit isp116x_probe(struct platform_device *pdev)
 {
 	struct usb_hcd *hcd;
@@ -1597,7 +1595,7 @@ static int __devinit isp116x_probe(struct platform_device *pdev)
 		ret = -EBUSY;
 		goto err1;
 	}
-	addr_reg = ioremap(addr->start, resource_len(addr));
+	addr_reg = ioremap(addr->start, resource_size(addr));
 	if (addr_reg == NULL) {
 		ret = -ENOMEM;
 		goto err2;
@@ -1606,7 +1604,7 @@ static int __devinit isp116x_probe(struct platform_device *pdev)
 		ret = -EBUSY;
 		goto err3;
 	}
-	data_reg = ioremap(data->start, resource_len(data));
+	data_reg = ioremap(data->start, resource_size(data));
 	if (data_reg == NULL) {
 		ret = -ENOMEM;
 		goto err4;
-- 
1.7.2



