Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755596Ab1E3J5A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 05:57:00 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:58058 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754721Ab1E3J46 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 05:56:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=d9NywqbwzE+PirzmFQ5Oi6+/hZ83i91VC7I48DsknR7FCDLVb3utO9QkfUdNOAFihD
         J5U3KrV1es1M0qkveeUp6/q42F4eeZRv8/8Yk3vLlMz067UWLWbNgy/Dr8M9L0pa0GwO
         gXcBLTuvTsu2nLopSfz7Jnm3sSOakP7bDAeOw=
From: Maarten Lankhorst <m.b.lankhorst@gmail.com>
To: linux-usb@vger.kernel.org
Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>, linux-kernel@vger.kernel.org,
        Maarten Lankhorst <m.b.lankhorst@gmail.com>
Subject: [PATCH] [RFC] usb: Broaden range of vendor codes for xhci
Date: Mon, 30 May 2011 11:56:46 +0200
Message-Id: <1306749406-21124-1-git-send-email-m.b.lankhorst@gmail.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

My asrock P67 chipset sends code 192 on device reset. Allowing >= 192 to be treated as success fixes it, and allows me to use my USB3 port.

Signed-off-by: Maarten Lankhorst <m.b.lankhorst@gmail.com>

---
There still appears to be a possible regression though. I can't currently use my usb headset, but since my xhci port never worked, I can't tell for sure if it ever worked.

Resending, forgot to add relevant maintainers.
---
 drivers/usb/host/xhci-ring.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
index 7437386..f8b9f79 100644
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -1464,7 +1464,7 @@ static int xhci_requires_manual_halt_cleanup(struct xhci_hcd *xhci,
 
 int xhci_is_vendor_info_code(struct xhci_hcd *xhci, unsigned int trb_comp_code)
 {
-	if (trb_comp_code >= 224 && trb_comp_code <= 255) {
+	if (trb_comp_code >= 192 && trb_comp_code <= 255) {
 		/* Vendor defined "informational" completion code,
 		 * treat as not-an-error.
 		 */
-- 
1.7.4.1

