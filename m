Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964929Ab2DXWmc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 18:42:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28125 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964793Ab2DXWm3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 18:42:29 -0400
From: Matthew Garrett <mjg@redhat.com>
To: airlied@redhat.com
Cc: linux-kernel@vger.kernel.org, Matthew Garrett <mjg@redhat.com>
Subject: [PATCH] vgaarb: Fix build failure with modular fbcon
Date: Tue, 24 Apr 2012 18:41:48 -0400
Message-Id: <1335307308-22317-1-git-send-email-mjg@redhat.com>
X-cavan-blacklisted-at: zen.spamhaus.org
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 208.54.36.162
X-SA-Exim-Mail-From: mjg@redhat.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need to export vga_default_device in case fbcon is modular.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
---
 drivers/gpu/vga/vgaarb.c |    2 ++
 drivers/video/efifb.c    |    2 ++
 2 files changed, 4 insertions(+)

diff --git a/drivers/gpu/vga/vgaarb.c b/drivers/gpu/vga/vgaarb.c
index e223b96..3df8fc0 100644
--- a/drivers/gpu/vga/vgaarb.c
+++ b/drivers/gpu/vga/vgaarb.c
@@ -137,6 +137,8 @@ struct pci_dev *vga_default_device(void)
 	return vga_default;
 }
 
+EXPORT_SYMBOL_GPL(vga_default_device);
+
 void vga_set_default_device(struct pci_dev *pdev)
 {
 	vga_default = pdev;
diff --git a/drivers/video/efifb.c b/drivers/video/efifb.c
index 66ed991..b4a632a 100644
--- a/drivers/video/efifb.c
+++ b/drivers/video/efifb.c
@@ -305,6 +305,8 @@ struct pci_dev *vga_default_device(void)
 	return default_vga;
 }
 
+EXPORT_SYMBOL_GPL(vga_default_device);
+
 void vga_set_default_device(struct pci_dev *pdev)
 {
 	default_vga = pdev;
-- 
1.7.10

