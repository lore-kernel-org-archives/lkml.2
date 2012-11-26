Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933874Ab2KZRNY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 12:13:24 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:48040 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933856Ab2KZRNP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:13:15 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Oliver Neukum <oneukum@suse.de>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 214/270] xhci: endianness xhci_calculate_intel_u2_timeout
Date: Mon, 26 Nov 2012 14:58:24 -0200
Message-Id: <1353949160-26803-215-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oliver Neukum <oliver@neukum.org>

commit 966e7a854177097083683176ced871558b631a12 upstream.

An le16 is accessed without conversion.

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
index ad29888..1f9b8a4 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -4141,7 +4141,7 @@ static u16 xhci_calculate_intel_u2_timeout(struct usb_device *udev,
 			(xhci_service_interval_to_ns(desc) > timeout_ns))
 		timeout_ns = xhci_service_interval_to_ns(desc);
 
-	u2_del_ns = udev->bos->ss_cap->bU2DevExitLat * 1000;
+	u2_del_ns = le16_to_cpu(udev->bos->ss_cap->bU2DevExitLat) * 1000ULL;
 	if (u2_del_ns > timeout_ns)
 		timeout_ns = u2_del_ns;
 
-- 
1.7.9.5

