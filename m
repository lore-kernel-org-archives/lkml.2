Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759898Ab0HEH36 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 03:29:58 -0400
Received: from mail.perches.com ([173.55.12.10]:2268 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759739Ab0HEH3x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 03:29:53 -0400
From: Joe Perches <joe@perches.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input <linux-input@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/9] drivers/input/gameport: Use pr_fmt and pr_<level>
Date: Thu,  5 Aug 2010 00:29:42 -0700
Message-Id: <4372564dd9aeb4c85e233d31e2997b8643b58e56.1280992117.git.joe@perches.com>
X-Mailer: git-send-email 1.7.2.19.g9a302
In-Reply-To: <20100804043256.GB25256@core.coreip.homeip.net>
References: <20100804043256.GB25256@core.coreip.homeip.net>
In-Reply-To: <cover.1280992116.git.joe@perches.com>
References: <cover.1280992116.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/input/gameport/emu10k1-gp.c |    4 +++-
 drivers/input/gameport/fm801-gp.c   |    8 +++++---
 drivers/input/gameport/lightning.c  |    6 ++++--
 drivers/input/gameport/ns558.c      |    8 +++++---
 4 files changed, 17 insertions(+), 9 deletions(-)

diff --git a/drivers/input/gameport/emu10k1-gp.c b/drivers/input/gameport/emu10k1-gp.c
index 7392992..3b065c7 100644
--- a/drivers/input/gameport/emu10k1-gp.c
+++ b/drivers/input/gameport/emu10k1-gp.c
@@ -26,6 +26,8 @@
  * Vojtech Pavlik, Simunkova 1594, Prague 8, 182 00 Czech Republic
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <asm/io.h>
 
 #include <linux/module.h>
@@ -75,7 +77,7 @@ static int __devinit emu_probe(struct pci_dev *pdev, const struct pci_device_id
 	emu = kzalloc(sizeof(struct emu), GFP_KERNEL);
 	port = gameport_allocate_port();
 	if (!emu || !port) {
-		printk(KERN_ERR "emu10k1-gp: Memory allocation failed\n");
+		pr_err("Memory allocation failed\n");
 		release_region(ioport, iolen);
 		kfree(emu);
 		gameport_free_port(port);
diff --git a/drivers/input/gameport/fm801-gp.c b/drivers/input/gameport/fm801-gp.c
index 14d3f3e..9f8b4fa 100644
--- a/drivers/input/gameport/fm801-gp.c
+++ b/drivers/input/gameport/fm801-gp.c
@@ -20,6 +20,8 @@
  *
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <asm/io.h>
 #include <linux/delay.h>
 #include <linux/errno.h>
@@ -87,7 +89,7 @@ static int __devinit fm801_gp_probe(struct pci_dev *pci, const struct pci_device
 	gp = kzalloc(sizeof(struct fm801_gp), GFP_KERNEL);
 	port = gameport_allocate_port();
 	if (!gp || !port) {
-		printk(KERN_ERR "fm801-gp: Memory allocation failed\n");
+		pr_err("Memory allocation failed\n");
 		error = -ENOMEM;
 		goto err_out_free;
 	}
@@ -108,8 +110,8 @@ static int __devinit fm801_gp_probe(struct pci_dev *pci, const struct pci_device
 	gp->gameport = port;
 	gp->res_port = request_region(port->io, 0x10, "FM801 GP");
 	if (!gp->res_port) {
-		printk(KERN_DEBUG "fm801-gp: unable to grab region 0x%x-0x%x\n",
-			port->io, port->io + 0x0f);
+		printk(KERN_DEBUG pr_fmt("unable to grab region 0x%x-0x%x\n"),
+		       port->io, port->io + 0x0f);
 		error = -EBUSY;
 		goto err_out_disable_dev;
 	}
diff --git a/drivers/input/gameport/lightning.c b/drivers/input/gameport/lightning.c
index 85d6ee0..73ff2a0 100644
--- a/drivers/input/gameport/lightning.c
+++ b/drivers/input/gameport/lightning.c
@@ -26,6 +26,8 @@
  * Vojtech Pavlik, Simunkova 1594, Prague 8, 182 00 Czech Republic
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <asm/io.h>
 #include <linux/delay.h>
 #include <linux/errno.h>
@@ -228,7 +230,7 @@ static int __init l4_create_ports(int card_no)
 		l4 = &l4_ports[idx];
 
 		if (!(l4->gameport = port = gameport_allocate_port())) {
-			printk(KERN_ERR "lightning: Memory allocation failed\n");
+			pr_err("Memory allocation failed\n");
 			while (--i >= 0) {
 				gameport_free_port(l4->gameport);
 				l4->gameport = NULL;
@@ -287,7 +289,7 @@ static int __init l4_add_card(int card_no)
 	if (result)
 		return result;
 
-	printk(KERN_INFO "gameport: PDPI Lightning 4 %s card v%d.%d at %#x\n",
+	pr_info("PDPI Lightning 4 %s card v%d.%d at %#x\n",
 		card_no ? "secondary" : "primary", rev >> 4, rev, L4_PORT);
 
 	for (i = 0; i < 4; i++) {
diff --git a/drivers/input/gameport/ns558.c b/drivers/input/gameport/ns558.c
index 7c21784..11b3309 100644
--- a/drivers/input/gameport/ns558.c
+++ b/drivers/input/gameport/ns558.c
@@ -27,6 +27,8 @@
  * Vojtech Pavlik, Simunkova 1594, Prague 8, 182 00 Czech Republic
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <asm/io.h>
 
 #include <linux/module.h>
@@ -142,7 +144,7 @@ static int ns558_isa_probe(int io)
 	ns558 = kzalloc(sizeof(struct ns558), GFP_KERNEL);
 	port = gameport_allocate_port();
 	if (!ns558 || !port) {
-		printk(KERN_ERR "ns558: Memory allocation failed.\n");
+		pr_err("Memory allocation failed\n");
 		release_region(io & (-1 << i), (1 << i));
 		kfree(ns558);
 		gameport_free_port(port);
@@ -201,7 +203,7 @@ static int ns558_pnp_probe(struct pnp_dev *dev, const struct pnp_device_id *did)
 	struct gameport *port;
 
 	if (!pnp_port_valid(dev, 0)) {
-		printk(KERN_WARNING "ns558: No i/o ports on a gameport? Weird\n");
+		pr_warning("No i/o ports on a gameport? Weird\n");
 		return -ENODEV;
 	}
 
@@ -214,7 +216,7 @@ static int ns558_pnp_probe(struct pnp_dev *dev, const struct pnp_device_id *did)
 	ns558 = kzalloc(sizeof(struct ns558), GFP_KERNEL);
 	port = gameport_allocate_port();
 	if (!ns558 || !port) {
-		printk(KERN_ERR "ns558: Memory allocation failed\n");
+		pr_err("Memory allocation failed\n");
 		kfree(ns558);
 		gameport_free_port(port);
 		return -ENOMEM;
-- 
1.7.2.19.g9a302

