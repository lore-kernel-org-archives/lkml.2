Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753040Ab1BUTOG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 14:14:06 -0500
Received: from miraculix-out.informatik.uni-kiel.de ([134.245.248.209]:46957
	"EHLO miraculix.informatik.uni-kiel.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751649Ab1BUTOF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 14:14:05 -0500
From: Timo von Holtz <tvh@informatik.uni-kiel.de>
To: gregkh@suse.de
Cc: dilinger@queued.net, akpm@linux-foundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        Timo von Holtz <tvh@informatik.uni-kiel.de>
Subject: [PATCH] Staging: olpc_dcon: fixed some coding style issues
Date: Mon, 21 Feb 2011 20:13:11 +0100
Message-Id: <1298315591-11875-1-git-send-email-tvh@informatik.uni-kiel.de>
X-Mailer: git-send-email 1.7.4.1
X-Null-Tag: 2935c14586916ee2c3adf08e6de34a21
X-Authenticated-Sender: user tvh from 86.103.145.155
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed all coding style issues in the files
drivers/staging/olpc_dcon/olpc_dcon_xo_1.c
drivers/staging/olpc_dcon/olpc_dcon_xo_1_5.c

Signed-off-by: Timo von Holtz <tvh@informatik.uni-kiel.de>
---
 drivers/staging/olpc_dcon/olpc_dcon_xo_1.c   |    2 +-
 drivers/staging/olpc_dcon/olpc_dcon_xo_1_5.c |   84 ++++++++++++++++----------
 2 files changed, 53 insertions(+), 33 deletions(-)

diff --git a/drivers/staging/olpc_dcon/olpc_dcon_xo_1.c b/drivers/staging/olpc_dcon/olpc_dcon_xo_1.c
index b154be7..ccde215 100644
--- a/drivers/staging/olpc_dcon/olpc_dcon_xo_1.c
+++ b/drivers/staging/olpc_dcon/olpc_dcon_xo_1.c
@@ -152,7 +152,7 @@ static void dcon_wiggle_xo_1(void)
 	 * According to the cs5536 spec, to set GPIO14 to SMB_CLK we must
 	 * simultaneously set AUX1 IN/OUT to GPIO14; ditto for SMB_DATA and
 	 * GPIO15.
- 	 */
+	 */
 	cs5535_gpio_set(OLPC_GPIO_SMB_CLK, GPIO_OUTPUT_VAL);
 	cs5535_gpio_set(OLPC_GPIO_SMB_DATA, GPIO_OUTPUT_VAL);
 	cs5535_gpio_set(OLPC_GPIO_SMB_CLK, GPIO_OUTPUT_ENABLE);
diff --git a/drivers/staging/olpc_dcon/olpc_dcon_xo_1_5.c b/drivers/staging/olpc_dcon/olpc_dcon_xo_1_5.c
index e213b63..6381119 100644
--- a/drivers/staging/olpc_dcon/olpc_dcon_xo_1_5.c
+++ b/drivers/staging/olpc_dcon/olpc_dcon_xo_1_5.c
@@ -23,9 +23,10 @@
 #include "olpc_dcon.h"
 
 /* Hardware setup on the XO 1.5:
- * 	DCONLOAD connects to
- *		VX855_GPIO1 (not SMBCK2)
- * 	DCONBLANK connects to VX855_GPIO8 (not SSPICLK)  unused in driver
+ *	DCONLOAD connects to
+ *		VX855_GPO12 (not nCR_PWOFF)   (rev A)
+ *		VX855_GPIO1 (not SMBCK2)      (rev B)
+ *	DCONBLANK connects to VX855_GPIO8 (not SSPICLK)  unused in driver
  *	DCONSTAT0 connects to VX855_GPI10 (not SSPISDI)
  *	DCONSTAT1 connects to VX855_GPI11 (not nSSPISS)
  *	DCONIRQ connects to VX855_GPIO12
@@ -33,26 +34,32 @@
  *	DCONSMBCLK connects to VX855 graphics CRTSPCLK
  */
 
-#define VX855_GENL_PURPOSE_OUTPUT 0x44c // PMIO_Rx4c-4f
-#define VX855_GPI_STATUS_CHG 0x450  // PMIO_Rx50
-#define VX855_GPI_SCI_SMI 0x452  // PMIO_Rx52
+#define TEST_B2 0   /* define to test B3 paths on a modded B2 board */
+
+#define VX855_GENL_PURPOSE_OUTPUT 0x44c /* PMIO_Rx4c-4f */
+#define VX855_GPI_STATUS_CHG 0x450  /* PMIO_Rx50 */
+#define VX855_GPI_SCI_SMI 0x452  /* PMIO_Rx52 */
 #define BIT_GPIO12 0x40
 
 #define PREFIX "OLPC DCON:"
 
 static void dcon_clear_irq(void)
 {
-	/* irq status will appear in PMIO_Rx50[6] (RW1C) on gpio12 */
-	outb(BIT_GPIO12, VX855_GPI_STATUS_CHG);
+	if (TEST_B2 || olpc_board_at_least(olpc_board(BOARD_XO_1_5_B3))) {
+		/* irq status will appear in PMIO_Rx50[6] (RW1C) on gpio12 */
+		outb(BIT_GPIO12, VX855_GPI_STATUS_CHG);
+	}
 }
 
 static int dcon_was_irq(void)
 {
 	u_int8_t tmp;
 
-	/* irq status will appear in PMIO_Rx50[6] on gpio12 */
-	tmp = inb(VX855_GPI_STATUS_CHG);
-	return !!(tmp & BIT_GPIO12);
+	if (TEST_B2 || olpc_board_at_least(olpc_board(BOARD_XO_1_5_B3))) {
+		/* irq status will appear in PMIO_Rx50[6] on gpio12 */
+		tmp = inb(VX855_GPI_STATUS_CHG);
+		return !!(tmp & BIT_GPIO12);
+	}
 
 	return 0;
 }
@@ -62,8 +69,8 @@ static int dcon_init_xo_1_5(struct dcon_priv *dcon)
 	unsigned int irq;
 	u_int8_t tmp;
 	struct pci_dev *pdev;
-	
-	
+
+
 	pdev = pci_get_device(PCI_VENDOR_ID_VIA,
 			      PCI_DEVICE_ID_VIA_VX855, NULL);
 	if (!pdev) {
@@ -82,21 +89,29 @@ static int dcon_init_xo_1_5(struct dcon_priv *dcon)
 	pci_read_config_byte(pdev, 0xe4, &tmp);
 	pci_write_config_byte(pdev, 0xe4, tmp|0x08);
 
-	/* clear PMU_RxE1[6] to select SCI on GPIO12 */
-	/* clear PMU_RxE0[6] to choose falling edge */
-	pci_read_config_byte(pdev, 0xe1, &tmp);
-	pci_write_config_byte(pdev, 0xe1, tmp & ~BIT_GPIO12);
-	pci_read_config_byte(pdev, 0xe0, &tmp);
-	pci_write_config_byte(pdev, 0xe0, tmp & ~BIT_GPIO12);
+	if (TEST_B2 || olpc_board_at_least(olpc_board(BOARD_XO_1_5_B3))) {
+		/* clear PMU_RxE1[6] to select SCI on GPIO12 */
+		/* clear PMU_RxE0[6] to choose falling edge */
+		pci_read_config_byte(pdev, 0xe1, &tmp);
+		pci_write_config_byte(pdev, 0xe1, tmp & ~BIT_GPIO12);
+		pci_read_config_byte(pdev, 0xe0, &tmp);
+		pci_write_config_byte(pdev, 0xe0, tmp & ~BIT_GPIO12);
 
-	dcon_clear_irq();
+		dcon_clear_irq();
 
-	/* set   PMIO_Rx52[6] to enable SCI/SMI on gpio12 */
-	outb(inb(VX855_GPI_SCI_SMI)|BIT_GPIO12, VX855_GPI_SCI_SMI);
+		/* set   PMIO_Rx52[6] to enable SCI/SMI on gpio12 */
+		outb(inb(VX855_GPI_SCI_SMI)|BIT_GPIO12, VX855_GPI_SCI_SMI);
+
+	}
 
 	/* Determine the current state of DCONLOAD, likely set by firmware */
-	/* GPIO1 */
-	dcon->curr_src = (inl(VX855_GENL_PURPOSE_OUTPUT) & 0x1000) ?
+	if (olpc_board_at_least(olpc_board(BOARD_XO_1_5_B1))) {
+		/* GPIO1 */
+		dcon_source = (inl(VX855_GENL_PURPOSE_OUTPUT) & 0x1000) ?
+			DCON_SOURCE_CPU : DCON_SOURCE_DCON;
+	} else {
+		/* GPO12 */
+		dcon_source = (inl(VX855_GENL_PURPOSE_OUTPUT) & 0x04000000) ?
 			DCON_SOURCE_CPU : DCON_SOURCE_DCON;
 	dcon->pending_src = dcon->curr_src;
 
@@ -104,7 +119,8 @@ static int dcon_init_xo_1_5(struct dcon_priv *dcon)
 
 	/* we're sharing the IRQ with ACPI */
 	irq = acpi_gbl_FADT.sci_interrupt;
-	if (request_irq(irq, &dcon_interrupt, IRQF_SHARED, "DCON", dcon)) {
+	if (request_irq(irq, &dcon_interrupt, IRQF_SHARED,
+				"DCON", &dcon_driver)) {
 		printk(KERN_ERR PREFIX "DCON (IRQ%d) allocation failed\n", irq);
 		return 1;
 	}
@@ -148,7 +164,7 @@ static void dcon_wiggle_xo_1_5(void)
 	 * state machine to reset to a (sane) initial state.  Mitch Bradley
 	 * did some testing and discovered that holding for 16 SMB_CLK cycles
 	 * worked a lot more reliably, so that's what we do here.
- 	 */
+	 */
 	set_i2c_line(1, 1);
 
 	for (x = 0; x < 16; x++) {
@@ -159,25 +175,29 @@ static void dcon_wiggle_xo_1_5(void)
 	}
 	udelay(5);
 
-	/* set   PMIO_Rx52[6] to enable SCI/SMI on gpio12 */
-	outb(inb(VX855_GPI_SCI_SMI)|BIT_GPIO12, VX855_GPI_SCI_SMI);
+	if (TEST_B2 || olpc_board_at_least(olpc_board(BOARD_XO_1_5_B3)))
+		/* set   PMIO_Rx52[6] to enable SCI/SMI on gpio12 */
+		outb(inb(VX855_GPI_SCI_SMI)|BIT_GPIO12, VX855_GPI_SCI_SMI);
 }
 
 static void dcon_set_dconload_xo_1_5(int val)
 {
-	gpio_set_value(VX855_GPIO(1), val);
+	if (olpc_board_at_least(olpc_board(BOARD_XO_1_5_B1)))
+		gpio_set_value(VX855_GPIO(1), val);
+	else
+		gpio_set_value(VX855_GPO(12), val);
 }
 
 static u8 dcon_read_status_xo_1_5(void)
 {
 	u8 status;
-	
+
 	if (!dcon_was_irq())
 		return -1;
 
-	// i believe this is the same as "inb(0x44b) & 3"
+	/* i believe this is the same as "inb(0x44b) & 3" */
 	status = gpio_get_value(VX855_GPI(10));
-	status |= gpio_get_value(VX855_GPI(11)) << 1; 
+	status |= gpio_get_value(VX855_GPI(11)) << 1;
 
 	dcon_clear_irq();
 
-- 
1.7.4.1

