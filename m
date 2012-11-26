Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933892Ab2KZRaX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 12:30:23 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:48046 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933861Ab2KZRNV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:13:21 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Oliver Neukum <oneukum@suse.de>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 215/270] xhci: fix integer overflow
Date: Mon, 26 Nov 2012 14:58:25 -0200
Message-Id: <1353949160-26803-216-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/usb/host/xhci.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index 1f9b8a4..5f831c2 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -4020,7 +4020,7 @@ int xhci_update_device(struct usb_hcd *hcd, struct usb_device *udev)
 static unsigned long long xhci_service_interval_to_ns(
 		struct usb_endpoint_descriptor *desc)
 {
-	return (1 << (desc->bInterval - 1)) * 125 * 1000;
+	return (1ULL << (desc->bInterval - 1)) * 125 * 1000;
 }
 
 static u16 xhci_get_timeout_no_hub_lpm(struct usb_device *udev,
-- 
1.7.9.5

