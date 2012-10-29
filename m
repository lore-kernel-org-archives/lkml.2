Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761231Ab2J2VhR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 17:37:17 -0400
Received: from mail.kernel.org ([198.145.19.201]:47379 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932920Ab2J2VhA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 17:37:00 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Oliver Neukum <oneukum@suse.de>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: [ 023/101] xhci: endianness xhci_calculate_intel_u2_timeout
Date: Mon, 29 Oct 2012 14:34:36 -0700
Message-Id: <20121029213242.753462318@linuxfoundation.org>
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

commit 966e7a854177097083683176ced871558b631a12 upstream.

An le16 is accessed without conversion.

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
@@ -4141,7 +4141,7 @@ static u16 xhci_calculate_intel_u2_timeo
 			(xhci_service_interval_to_ns(desc) > timeout_ns))
 		timeout_ns = xhci_service_interval_to_ns(desc);
 
-	u2_del_ns = udev->bos->ss_cap->bU2DevExitLat * 1000;
+	u2_del_ns = le16_to_cpu(udev->bos->ss_cap->bU2DevExitLat) * 1000ULL;
 	if (u2_del_ns > timeout_ns)
 		timeout_ns = u2_del_ns;
 


