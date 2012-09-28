Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031237Ab2I1T3b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 15:29:31 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:33476 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030226Ab2I1TCK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 15:02:10 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Ruchika Kharwar <ruchika@ti.com>, Felipe Balbi <balbi@ti.com>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: [ 166/262] usb: host: xhci-plat: use ioremap_nocache
Date: Fri, 28 Sep 2012 11:51:35 -0700
Message-Id: <20120928183017.578228340@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120928182957.993484211@linuxfoundation.org>
References: <20120928182957.993484211@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

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


