Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932404Ab2L1TTc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 14:19:32 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55529 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932357Ab2L1TTV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 14:19:21 -0500
Message-Id: <20121228190342.079170874@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 28 Dec 2012 20:04:27 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "Alexis R. Cortes" <alexis.cortes@ti.com>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: [ 057/173] usb: host: xhci: Stricter conditional for Z1 system models for
 Compliance Mode Patch
In-Reply-To: <20121228190330.025298996@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.217.219.220
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Alexis R. Cortes" <alexis.cortes@ti.com>

commit b0e4e606ff6ff26da0f60826e75577b56ba4e463 upstream.

This minor patch creates a more stricter conditional for the Z1 sytems for applying
the Compliance Mode Patch, this to avoid the quirk to be applied to models that
contain a "Z1" in their dmi product string but are different from Z1 systems.

This patch should be backported to stable kernels as old as 3.2, that
contain the commit 71c731a296f1b08a3724bd1b514b64f1bda87a23 "usb: host:
xhci: Fix Compliance Mode on SN65LVPE502CP Hardware"

Signed-off-by: Alexis R. Cortes <alexis.cortes@ti.com>
Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/host/xhci.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index 2e29f2f..09987d5 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -480,7 +480,7 @@ static bool compliance_mode_recovery_timer_quirk_check(void)
 	if (strstr(dmi_product_name, "Z420") ||
 			strstr(dmi_product_name, "Z620") ||
 			strstr(dmi_product_name, "Z820") ||
-			strstr(dmi_product_name, "Z1"))
+			strstr(dmi_product_name, "Z1 Workstation"))
 		return true;
 
 	return false;


