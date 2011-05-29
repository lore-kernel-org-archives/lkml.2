Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755605Ab1E2Vvc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 May 2011 17:51:32 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:37821 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752564Ab1E2Vvb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 May 2011 17:51:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=M5SpqGy4fWq12heNCZRfPpdBGH3OUjP1WTB1TnlhXnqvdYKfrecszBCj1nRdyvL98Q
         HYcEeEZZpXekkApdD5unESupayu4wjylO2Q3YHF5wWhF3FKeRuEaKgQ0GnLyD2Dqy6sM
         HyQJJhftbal4DIvyHHA6iQSzdVXOXi2xUtflI=
From: Maarten Lankhorst <m.b.lankhorst@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Maarten Lankhorst <m.b.lankhorst@gmail.com>
Subject: [PATCH] [RFC] usb: Broaden range of vendor codes for xhci
Date: Sun, 29 May 2011 23:51:13 +0200
Message-Id: <1306705873-19681-1-git-send-email-m.b.lankhorst@gmail.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

My asrock P67 chipset sends code 192 on device reset. Allowing >= 192 to be treated as success fixes it, and allows me to use my USB3 port.

Signed-off-by: Maarten Lankhorst <m.b.lankhorst@gmail.com>

---
There still appears to be a possible regression though. I can't currently use my usb headset, but since my xhci port never worked, I can't tell for sure if it ever worked.
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

