Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964887Ab2I1U3V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 16:29:21 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:56440 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422736Ab2I1U3M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 16:29:12 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Ruchika Kharwar <ruchika@ti.com>, Felipe Balbi <balbi@ti.com>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: [ 134/218] usb: host: xhci-plat: use ioremap_nocache
Date: Fri, 28 Sep 2012 13:15:51 -0700
Message-Id: <20120928201516.822943872@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.1.428.g652398a
In-Reply-To: <20120928201501.208384923@linuxfoundation.org>
References: <20120928201501.208384923@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ruchika Kharwar <ruchika@ti.com>

commit 319acdfc064169023cd9ada5085b434fbcdacec2 upstream.

Use the ioremap_nocache variant of the ioremap API in
order to make sure our memory will be marked uncachable.

This patch should be backported to kernels as old as 3.4, that contain
the commit 3429e91a661e1f383aecc86c6bbcf65afb15c892 "usb: host: xhci:
add platform driver support".

Signed-off-by: Ruchika Kharwar <ruchika@ti.com>
Signed-off-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/host/xhci-plat.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/host/xhci-plat.c
+++ b/drivers/usb/host/xhci-plat.c
@@ -118,7 +118,7 @@ static int xhci_plat_probe(struct platfo
 		goto put_hcd;
 	}
 
-	hcd->regs = ioremap(hcd->rsrc_start, hcd->rsrc_len);
+	hcd->regs = ioremap_nocache(hcd->rsrc_start, hcd->rsrc_len);
 	if (!hcd->regs) {
 		dev_dbg(&pdev->dev, "error mapping memory\n");
 		ret = -EFAULT;


