Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933573Ab2J2WSf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 18:18:35 -0400
Received: from mail.kernel.org ([198.145.19.201]:47255 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761172Ab2J2Vgu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 17:36:50 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Oliver Neukum <oneukum@suse.de>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: [ 022/101] xhci: fix integer overflow
Date: Mon, 29 Oct 2012 14:34:35 -0700
Message-Id: <20121029213242.646328502@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.2.421.g261b511
In-Reply-To: <20121029213240.128426598@linuxfoundation.org>
References: <20121029213240.128426598@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oliver Neukum <oliver@neukum.org>

commit 16b45fdf9c4e82f5d3bc53aa70737650e7c8d5ed upstream.

xhci_service_interval_to_ns() returns long long
to avoid an overflow. However, the type cast happens
too late. The fix is to force ULL from the beginning.

This patch should be backported to kernels as old as 3.5, that contain
the commit e3567d2c15a7a8e2f992a5f7c7683453ca406d82 "xhci: Add Intel
U1/U2 timeout policy."

Signed-off-by: Oliver Neukum <oneukum@suse.de>
Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/host/xhci.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -4020,7 +4020,7 @@ int xhci_update_device(struct usb_hcd *h
 static unsigned long long xhci_service_interval_to_ns(
 		struct usb_endpoint_descriptor *desc)
 {
-	return (1 << (desc->bInterval - 1)) * 125 * 1000;
+	return (1ULL << (desc->bInterval - 1)) * 125 * 1000;
 }
 
 static u16 xhci_get_timeout_no_hub_lpm(struct usb_device *udev,


