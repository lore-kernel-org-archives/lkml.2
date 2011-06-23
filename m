Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758854Ab1FWCAw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 22:00:52 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:35252 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758815Ab1FWCAt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 22:00:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=ga4YM9ftfYSJdSVsspU/rUmviJdgaeowzXAKwMSPeIfnR2VZmUeZkEai00gl3tcGEc
         23uQELWx5cZuf2xBZ2GV0hCc6VjI6ywUrlVEXqiW8dtM/GXL6CDAOdx0ugN4LlPR/pxI
         6ZZxDH1MuvgP54IrZ28UrrVmSnkICr7kE9fFQ=
From: dirk.brandewie@gmail.com
To: linux-kernel@vger.kernel.org, spi-devel-general@lists.sourceforge.net
Cc: Dirk Brandewie <dirk.brandewie@gmail.com>
Subject: [PATCH 02/11] spi-dw: update function naming convention to match file naming
Date: Wed, 22 Jun 2011 19:00:04 -0700
Message-Id: <1308794413-11069-3-git-send-email-dirk.brandewie@gmail.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1308794413-11069-1-git-send-email-dirk.brandewie@gmail.com>
References: <1308794413-11069-1-git-send-email-dirk.brandewie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dirk Brandewie <dirk.brandewie@gmail.com>

The file naming convention for drivers in the SPI subsystem is now
being enforced update internal naming convention to match file naming.

Signed-off-by: Dirk Brandewie <dirk.brandewie@gmail.com>
---
 drivers/spi/spi-dw-mid.c  |   26 +++---
 drivers/spi/spi-dw-mmio.c |   38 +++++-----
 drivers/spi/spi-dw-pci.c  |   34 ++++----
 drivers/spi/spi-dw.c      |  196 ++++++++++++++++++++++----------------------
 drivers/spi/spi-dw.h      |   48 ++++++------
 5 files changed, 171 insertions(+), 171 deletions(-)

diff --git a/drivers/spi/spi-dw-mid.c b/drivers/spi/spi-dw-mid.c
index 130e555..7659cef 100644
--- a/drivers/spi/spi-dw-mid.c
+++ b/drivers/spi/spi-dw-mid.c
@@ -36,12 +36,12 @@ struct mid_dma {
 
 static bool mid_spi_dma_chan_filter(struct dma_chan *chan, void *param)
 {
-	struct dw_spi *dws = param;
+	struct spi_dw *dws = param;
 
 	return dws->dmac && (&dws->dmac->dev == chan->device->dev);
 }
 
-static int mid_spi_dma_init(struct dw_spi *dws)
+static int mid_spi_dma_init(struct spi_dw *dws)
 {
 	struct mid_dma *dw_dma = dws->dma_priv;
 	struct intel_mid_dma_slave *rxs, *txs;
@@ -86,7 +86,7 @@ err_exit:
 
 }
 
-static void mid_spi_dma_exit(struct dw_spi *dws)
+static void mid_spi_dma_exit(struct spi_dw *dws)
 {
 	dma_release_channel(dws->txchan);
 	dma_release_channel(dws->rxchan);
@@ -97,16 +97,16 @@ static void mid_spi_dma_exit(struct dw_spi *dws)
  * callback for rx/tx channel will each increment it by 1.
  * Reaching 2 means the whole spi transaction is done.
  */
-static void dw_spi_dma_done(void *arg)
+static void spi_dw_dma_done(void *arg)
 {
-	struct dw_spi *dws = arg;
+	struct spi_dw *dws = arg;
 
 	if (++dws->dma_chan_done != 2)
 		return;
-	dw_spi_xfer_done(dws);
+	spi_dw_xfer_done(dws);
 }
 
-static int mid_spi_dma_transfer(struct dw_spi *dws, int cs_change)
+static int mid_spi_dma_transfer(struct spi_dw *dws, int cs_change)
 {
 	struct dma_async_tx_descriptor *txdesc = NULL, *rxdesc = NULL;
 	struct dma_chan *txchan, *rxchan;
@@ -115,7 +115,7 @@ static int mid_spi_dma_transfer(struct dw_spi *dws, int cs_change)
 
 	/* 1. setup DMA related registers */
 	if (cs_change) {
-		spi_enable_chip(dws, 0);
+		spi_dw_enable_chip(dws, 0);
 		dw_writew(dws, dmardlr, 0xf);
 		dw_writew(dws, dmatdlr, 0x10);
 		if (dws->tx_dma)
@@ -123,7 +123,7 @@ static int mid_spi_dma_transfer(struct dw_spi *dws, int cs_change)
 		if (dws->rx_dma)
 			dma_ctrl |= 0x1;
 		dw_writew(dws, dmacr, dma_ctrl);
-		spi_enable_chip(dws, 1);
+		spi_dw_enable_chip(dws, 1);
 	}
 
 	dws->dma_chan_done = 0;
@@ -149,7 +149,7 @@ static int mid_spi_dma_transfer(struct dw_spi *dws, int cs_change)
 				1,
 				DMA_TO_DEVICE,
 				DMA_PREP_INTERRUPT | DMA_COMPL_SKIP_DEST_UNMAP);
-	txdesc->callback = dw_spi_dma_done;
+	txdesc->callback = spi_dw_dma_done;
 	txdesc->callback_param = dws;
 
 	/* 3. Prepare the RX dma transfer */
@@ -171,7 +171,7 @@ static int mid_spi_dma_transfer(struct dw_spi *dws, int cs_change)
 				1,
 				DMA_FROM_DEVICE,
 				DMA_PREP_INTERRUPT | DMA_COMPL_SKIP_DEST_UNMAP);
-	rxdesc->callback = dw_spi_dma_done;
+	rxdesc->callback = spi_dw_dma_done;
 	rxdesc->callback_param = dws;
 
 	/* rx must be started before tx due to spi instinct */
@@ -180,7 +180,7 @@ static int mid_spi_dma_transfer(struct dw_spi *dws, int cs_change)
 	return 0;
 }
 
-static struct dw_spi_dma_ops mid_dma_ops = {
+static struct spi_dw_dma_ops mid_dma_ops = {
 	.dma_init	= mid_spi_dma_init,
 	.dma_exit	= mid_spi_dma_exit,
 	.dma_transfer	= mid_spi_dma_transfer,
@@ -198,7 +198,7 @@ static struct dw_spi_dma_ops mid_dma_ops = {
 #define CLK_SPI_CDIV_MASK	0x00000e00
 #define CLK_SPI_DISABLE_OFFSET	8
 
-int dw_spi_mid_init(struct dw_spi *dws)
+int spi_dw_mid_init(struct spi_dw *dws)
 {
 	u32 *clk_reg, clk_cdiv;
 
diff --git a/drivers/spi/spi-dw-mmio.c b/drivers/spi/spi-dw-mmio.c
index 34eb665..d98d28d 100644
--- a/drivers/spi/spi-dw-mmio.c
+++ b/drivers/spi/spi-dw-mmio.c
@@ -18,21 +18,21 @@
 
 #include "spi-dw.h"
 
-#define DRIVER_NAME "dw_spi_mmio"
+#define DRIVER_NAME "spi_dw_mmio"
 
-struct dw_spi_mmio {
-	struct dw_spi  dws;
+struct spi_dw_mmio {
+	struct spi_dw  dws;
 	struct clk     *clk;
 };
 
-static int __devinit dw_spi_mmio_probe(struct platform_device *pdev)
+static int __devinit spi_dw_mmio_probe(struct platform_device *pdev)
 {
-	struct dw_spi_mmio *dwsmmio;
-	struct dw_spi *dws;
+	struct spi_dw_mmio *dwsmmio;
+	struct spi_dw *dws;
 	struct resource *mem, *ioarea;
 	int ret;
 
-	dwsmmio = kzalloc(sizeof(struct dw_spi_mmio), GFP_KERNEL);
+	dwsmmio = kzalloc(sizeof(struct spi_dw_mmio), GFP_KERNEL);
 	if (!dwsmmio) {
 		ret = -ENOMEM;
 		goto err_end;
@@ -82,7 +82,7 @@ static int __devinit dw_spi_mmio_probe(struct platform_device *pdev)
 	dws->num_cs = 4;
 	dws->max_freq = clk_get_rate(dwsmmio->clk);
 
-	ret = dw_spi_add_host(dws);
+	ret = spi_dw_add_host(dws);
 	if (ret)
 		goto err_clk;
 
@@ -105,9 +105,9 @@ err_end:
 	return ret;
 }
 
-static int __devexit dw_spi_mmio_remove(struct platform_device *pdev)
+static int __devexit spi_dw_mmio_remove(struct platform_device *pdev)
 {
-	struct dw_spi_mmio *dwsmmio = platform_get_drvdata(pdev);
+	struct spi_dw_mmio *dwsmmio = platform_get_drvdata(pdev);
 	struct resource *mem;
 
 	platform_set_drvdata(pdev, NULL);
@@ -117,7 +117,7 @@ static int __devexit dw_spi_mmio_remove(struct platform_device *pdev)
 	dwsmmio->clk = NULL;
 
 	free_irq(dwsmmio->dws.irq, &dwsmmio->dws);
-	dw_spi_remove_host(&dwsmmio->dws);
+	spi_dw_remove_host(&dwsmmio->dws);
 	iounmap(dwsmmio->dws.regs);
 	kfree(dwsmmio);
 
@@ -126,25 +126,25 @@ static int __devexit dw_spi_mmio_remove(struct platform_device *pdev)
 	return 0;
 }
 
-static struct platform_driver dw_spi_mmio_driver = {
-	.remove		= __devexit_p(dw_spi_mmio_remove),
+static struct platform_driver spi_dw_mmio_driver = {
+	.remove		= __devexit_p(spi_dw_mmio_remove),
 	.driver		= {
 		.name	= DRIVER_NAME,
 		.owner	= THIS_MODULE,
 	},
 };
 
-static int __init dw_spi_mmio_init(void)
+static int __init spi_dw_mmio_init(void)
 {
-	return platform_driver_probe(&dw_spi_mmio_driver, dw_spi_mmio_probe);
+	return platform_driver_probe(&spi_dw_mmio_driver, spi_dw_mmio_probe);
 }
-module_init(dw_spi_mmio_init);
+module_init(spi_dw_mmio_init);
 
-static void __exit dw_spi_mmio_exit(void)
+static void __exit spi_dw_mmio_exit(void)
 {
-	platform_driver_unregister(&dw_spi_mmio_driver);
+	platform_driver_unregister(&spi_dw_mmio_driver);
 }
-module_exit(dw_spi_mmio_exit);
+module_exit(spi_dw_mmio_exit);
 
 MODULE_AUTHOR("Jean-Hugues Deschenes <jean-hugues.deschenes@octasic.com>");
 MODULE_DESCRIPTION("Memory-mapped I/O interface driver for DW SPI Core");
diff --git a/drivers/spi/spi-dw-pci.c b/drivers/spi/spi-dw-pci.c
index c5f37f0..af9db5c 100644
--- a/drivers/spi/spi-dw-pci.c
+++ b/drivers/spi/spi-dw-pci.c
@@ -24,18 +24,18 @@
 
 #include "spi-dw.h"
 
-#define DRIVER_NAME "dw_spi_pci"
+#define DRIVER_NAME "spi_dw_pci"
 
-struct dw_spi_pci {
+struct spi_dw_pci {
 	struct pci_dev	*pdev;
-	struct dw_spi	dws;
+	struct spi_dw	dws;
 };
 
 static int __devinit spi_pci_probe(struct pci_dev *pdev,
 	const struct pci_device_id *ent)
 {
-	struct dw_spi_pci *dwpci;
-	struct dw_spi *dws;
+	struct spi_dw_pci *dwpci;
+	struct spi_dw *dws;
 	int pci_bar = 0;
 	int ret;
 
@@ -46,7 +46,7 @@ static int __devinit spi_pci_probe(struct pci_dev *pdev,
 	if (ret)
 		return ret;
 
-	dwpci = kzalloc(sizeof(struct dw_spi_pci), GFP_KERNEL);
+	dwpci = kzalloc(sizeof(struct spi_dw_pci), GFP_KERNEL);
 	if (!dwpci) {
 		ret = -ENOMEM;
 		goto err_disable;
@@ -80,12 +80,12 @@ static int __devinit spi_pci_probe(struct pci_dev *pdev,
 	 * clock rate, FIFO depth.
 	 */
 	if (pdev->device == 0x0800) {
-		ret = dw_spi_mid_init(dws);
+		ret = spi_dw_mid_init(dws);
 		if (ret)
 			goto err_unmap;
 	}
 
-	ret = dw_spi_add_host(dws);
+	ret = spi_dw_add_host(dws);
 	if (ret)
 		goto err_unmap;
 
@@ -106,10 +106,10 @@ err_disable:
 
 static void __devexit spi_pci_remove(struct pci_dev *pdev)
 {
-	struct dw_spi_pci *dwpci = pci_get_drvdata(pdev);
+	struct spi_dw_pci *dwpci = pci_get_drvdata(pdev);
 
 	pci_set_drvdata(pdev, NULL);
-	dw_spi_remove_host(&dwpci->dws);
+	spi_dw_remove_host(&dwpci->dws);
 	iounmap(dwpci->dws.regs);
 	pci_release_region(pdev, 0);
 	kfree(dwpci);
@@ -119,10 +119,10 @@ static void __devexit spi_pci_remove(struct pci_dev *pdev)
 #ifdef CONFIG_PM
 static int spi_suspend(struct pci_dev *pdev, pm_message_t state)
 {
-	struct dw_spi_pci *dwpci = pci_get_drvdata(pdev);
+	struct spi_dw_pci *dwpci = pci_get_drvdata(pdev);
 	int ret;
 
-	ret = dw_spi_suspend_host(&dwpci->dws);
+	ret = spi_dw_suspend_host(&dwpci->dws);
 	if (ret)
 		return ret;
 	pci_save_state(pdev);
@@ -133,7 +133,7 @@ static int spi_suspend(struct pci_dev *pdev, pm_message_t state)
 
 static int spi_resume(struct pci_dev *pdev)
 {
-	struct dw_spi_pci *dwpci = pci_get_drvdata(pdev);
+	struct spi_dw_pci *dwpci = pci_get_drvdata(pdev);
 	int ret;
 
 	pci_set_power_state(pdev, PCI_D0);
@@ -141,7 +141,7 @@ static int spi_resume(struct pci_dev *pdev)
 	ret = pci_enable_device(pdev);
 	if (ret)
 		return ret;
-	return dw_spi_resume_host(&dwpci->dws);
+	return spi_dw_resume_host(&dwpci->dws);
 }
 #else
 #define spi_suspend	NULL
@@ -154,7 +154,7 @@ static const struct pci_device_id pci_ids[] __devinitdata = {
 	{},
 };
 
-static struct pci_driver dw_spi_driver = {
+static struct pci_driver spi_dw_driver = {
 	.name =		DRIVER_NAME,
 	.id_table =	pci_ids,
 	.probe =	spi_pci_probe,
@@ -165,12 +165,12 @@ static struct pci_driver dw_spi_driver = {
 
 static int __init mrst_spi_init(void)
 {
-	return pci_register_driver(&dw_spi_driver);
+	return pci_register_driver(&spi_dw_driver);
 }
 
 static void __exit mrst_spi_exit(void)
 {
-	pci_unregister_driver(&dw_spi_driver);
+	pci_unregister_driver(&spi_dw_driver);
 }
 
 module_init(mrst_spi_init);
diff --git a/drivers/spi/spi-dw.c b/drivers/spi/spi-dw.c
index 61f7ed8..fb09a9d 100644
--- a/drivers/spi/spi-dw.c
+++ b/drivers/spi/spi-dw.c
@@ -59,17 +59,17 @@ struct chip_data {
 };
 
 #ifdef CONFIG_DEBUG_FS
-static int spi_show_regs_open(struct inode *inode, struct file *file)
+static int spi_dw_show_regs_open(struct inode *inode, struct file *file)
 {
 	file->private_data = inode->i_private;
 	return 0;
 }
 
 #define SPI_REGS_BUFSIZE	1024
-static ssize_t  spi_show_regs(struct file *file, char __user *user_buf,
+static ssize_t  spi_dw_show_regs(struct file *file, char __user *user_buf,
 				size_t count, loff_t *ppos)
 {
-	struct dw_spi *dws;
+	struct spi_dw *dws;
 	char *buf;
 	u32 len = 0;
 	ssize_t ret;
@@ -81,7 +81,7 @@ static ssize_t  spi_show_regs(struct file *file, char __user *user_buf,
 		return 0;
 
 	len += snprintf(buf + len, SPI_REGS_BUFSIZE - len,
-			"MRST SPI0 registers:\n");
+			"DW SPI0 registers:\n");
 	len += snprintf(buf + len, SPI_REGS_BUFSIZE - len,
 			"=================================\n");
 	len += snprintf(buf + len, SPI_REGS_BUFSIZE - len,
@@ -122,43 +122,43 @@ static ssize_t  spi_show_regs(struct file *file, char __user *user_buf,
 	return ret;
 }
 
-static const struct file_operations mrst_spi_regs_ops = {
+static const struct file_operations spi_dw_regs_ops = {
 	.owner		= THIS_MODULE,
-	.open		= spi_show_regs_open,
-	.read		= spi_show_regs,
+	.open		= spi_dw_show_regs_open,
+	.read		= spi_dw_show_regs,
 	.llseek		= default_llseek,
 };
 
-static int mrst_spi_debugfs_init(struct dw_spi *dws)
+static int spi_dw_debugfs_init(struct spi_dw *dws)
 {
 	dws->debugfs = debugfs_create_dir("mrst_spi", NULL);
 	if (!dws->debugfs)
 		return -ENOMEM;
 
 	debugfs_create_file("registers", S_IFREG | S_IRUGO,
-		dws->debugfs, (void *)dws, &mrst_spi_regs_ops);
+		dws->debugfs, (void *)dws, &spi_dw_regs_ops);
 	return 0;
 }
 
-static void mrst_spi_debugfs_remove(struct dw_spi *dws)
+static void spi_dw_debugfs_remove(struct spi_dw *dws)
 {
 	if (dws->debugfs)
 		debugfs_remove_recursive(dws->debugfs);
 }
 
 #else
-static inline int mrst_spi_debugfs_init(struct dw_spi *dws)
+static inline int spi_dw_debugfs_init(struct spi_dw *dws)
 {
 	return 0;
 }
 
-static inline void mrst_spi_debugfs_remove(struct dw_spi *dws)
+static inline void spi_dw_debugfs_remove(struct spi_dw *dws)
 {
 }
 #endif /* CONFIG_DEBUG_FS */
 
 /* Return the max entries we can fill into tx fifo */
-static inline u32 tx_max(struct dw_spi *dws)
+static inline u32 tx_max(struct spi_dw *dws)
 {
 	u32 tx_left, tx_room, rxtx_gap;
 
@@ -180,14 +180,14 @@ static inline u32 tx_max(struct dw_spi *dws)
 }
 
 /* Return the max entries we should read out of rx fifo */
-static inline u32 rx_max(struct dw_spi *dws)
+static inline u32 rx_max(struct spi_dw *dws)
 {
 	u32 rx_left = (dws->rx_end - dws->rx) / dws->n_bytes;
 
 	return min(rx_left, (u32)dw_readw(dws, rxflr));
 }
 
-static void dw_writer(struct dw_spi *dws)
+static void spi_dw_writer(struct spi_dw *dws)
 {
 	u32 max = tx_max(dws);
 	u16 txw = 0;
@@ -205,7 +205,7 @@ static void dw_writer(struct dw_spi *dws)
 	}
 }
 
-static void dw_reader(struct dw_spi *dws)
+static void spi_dw_reader(struct spi_dw *dws)
 {
 	u32 max = rx_max(dws);
 	u16 rxw;
@@ -223,7 +223,7 @@ static void dw_reader(struct dw_spi *dws)
 	}
 }
 
-static void *next_transfer(struct dw_spi *dws)
+static void *spi_dw_next_transfer(struct spi_dw *dws)
 {
 	struct spi_message *msg = dws->cur_msg;
 	struct spi_transfer *trans = dws->cur_transfer;
@@ -244,7 +244,7 @@ static void *next_transfer(struct dw_spi *dws)
  * a dma-capable memory, and this func just need translate
  * the virt addr to physical
  */
-static int map_dma_buffers(struct dw_spi *dws)
+static int spi_dw_map_dma_buffers(struct spi_dw *dws)
 {
 	if (!dws->cur_msg->is_dma_mapped
 		|| !dws->dma_inited
@@ -262,7 +262,7 @@ static int map_dma_buffers(struct dw_spi *dws)
 }
 
 /* Caller already set message->status; dma and pio irqs are blocked */
-static void giveback(struct dw_spi *dws)
+static void spi_dw_giveback(struct spi_dw *dws)
 {
 	struct spi_transfer *last_transfer;
 	unsigned long flags;
@@ -290,34 +290,34 @@ static void giveback(struct dw_spi *dws)
 		msg->complete(msg->context);
 }
 
-static void int_error_stop(struct dw_spi *dws, const char *msg)
+static void spi_dw_int_error_stop(struct spi_dw *dws, const char *msg)
 {
 	/* Stop the hw */
-	spi_enable_chip(dws, 0);
+	spi_dw_enable_chip(dws, 0);
 
 	dev_err(&dws->master->dev, "%s\n", msg);
 	dws->cur_msg->state = ERROR_STATE;
 	tasklet_schedule(&dws->pump_transfers);
 }
 
-void dw_spi_xfer_done(struct dw_spi *dws)
+void spi_dw_xfer_done(struct spi_dw *dws)
 {
 	/* Update total byte transferred return count actual bytes read */
 	dws->cur_msg->actual_length += dws->len;
 
 	/* Move to next transfer */
-	dws->cur_msg->state = next_transfer(dws);
+	dws->cur_msg->state = spi_dw_next_transfer(dws);
 
 	/* Handle end of message */
 	if (dws->cur_msg->state == DONE_STATE) {
 		dws->cur_msg->status = 0;
-		giveback(dws);
+		spi_dw_giveback(dws);
 	} else
 		tasklet_schedule(&dws->pump_transfers);
 }
-EXPORT_SYMBOL_GPL(dw_spi_xfer_done);
+EXPORT_SYMBOL_GPL(spi_dw_xfer_done);
 
-static irqreturn_t interrupt_transfer(struct dw_spi *dws)
+static irqreturn_t spi_dw_interrupt_transfer(struct spi_dw *dws)
 {
 	u16 irq_status = dw_readw(dws, isr);
 
@@ -326,36 +326,36 @@ static irqreturn_t interrupt_transfer(struct dw_spi *dws)
 		dw_readw(dws, txoicr);
 		dw_readw(dws, rxoicr);
 		dw_readw(dws, rxuicr);
-		int_error_stop(dws, "interrupt_transfer: fifo overrun/underrun");
+		spi_dw_int_error_stop(dws, "spi-dw: fifo overrun/underrun");
 		return IRQ_HANDLED;
 	}
 
-	dw_reader(dws);
+	spi_dw_reader(dws);
 	if (dws->rx_end == dws->rx) {
-		spi_mask_intr(dws, SPI_INT_TXEI);
-		dw_spi_xfer_done(dws);
+		spi_dw_mask_intr(dws, SPI_INT_TXEI);
+		spi_dw_xfer_done(dws);
 		return IRQ_HANDLED;
 	}
 	if (irq_status & SPI_INT_TXEI) {
-		spi_mask_intr(dws, SPI_INT_TXEI);
-		dw_writer(dws);
+		spi_dw_mask_intr(dws, SPI_INT_TXEI);
+		spi_dw_writer(dws);
 		/* Enable TX irq always, it will be disabled when RX finished */
-		spi_umask_intr(dws, SPI_INT_TXEI);
+		spi_dw_umask_intr(dws, SPI_INT_TXEI);
 	}
 
 	return IRQ_HANDLED;
 }
 
-static irqreturn_t dw_spi_irq(int irq, void *dev_id)
+static irqreturn_t spi_dw_irq(int irq, void *dev_id)
 {
-	struct dw_spi *dws = dev_id;
+	struct spi_dw *dws = dev_id;
 	u16 irq_status = dw_readw(dws, isr) & 0x3f;
 
 	if (!irq_status)
 		return IRQ_NONE;
 
 	if (!dws->cur_msg) {
-		spi_mask_intr(dws, SPI_INT_TXEI);
+		spi_dw_mask_intr(dws, SPI_INT_TXEI);
 		return IRQ_HANDLED;
 	}
 
@@ -363,20 +363,20 @@ static irqreturn_t dw_spi_irq(int irq, void *dev_id)
 }
 
 /* Must be called inside pump_transfers() */
-static void poll_transfer(struct dw_spi *dws)
+static void spi_dw_poll_transfer(struct spi_dw *dws)
 {
 	do {
-		dw_writer(dws);
-		dw_reader(dws);
+		spi_dw_writer(dws);
+		spi_dw_reader(dws);
 		cpu_relax();
 	} while (dws->rx_end > dws->rx);
 
-	dw_spi_xfer_done(dws);
+	spi_dw_xfer_done(dws);
 }
 
-static void pump_transfers(unsigned long data)
+static void spi_dw_pump_transfers(unsigned long data)
 {
-	struct dw_spi *dws = (struct dw_spi *)data;
+	struct spi_dw *dws = (struct spi_dw *)data;
 	struct spi_message *message = NULL;
 	struct spi_transfer *transfer = NULL;
 	struct spi_transfer *previous = NULL;
@@ -496,7 +496,7 @@ static void pump_transfers(unsigned long data)
 	}
 
 	/* Check if current transfer is a DMA transaction */
-	dws->dma_mapped = map_dma_buffers(dws);
+	dws->dma_mapped = spi_dw_map_dma_buffers(dws);
 
 	/*
 	 * Interrupt mode
@@ -508,7 +508,7 @@ static void pump_transfers(unsigned long data)
 		txint_level = (templen > txint_level) ? txint_level : templen;
 
 		imask |= SPI_INT_TXEI | SPI_INT_TXOI | SPI_INT_RXUI | SPI_INT_RXOI;
-		dws->transfer_handler = interrupt_transfer;
+		dws->transfer_handler = spi_dw_interrupt_transfer;
 	}
 
 	/*
@@ -518,22 +518,22 @@ static void pump_transfers(unsigned long data)
 	 *	3. control value changes
 	 */
 	if (dw_readw(dws, ctrl0) != cr0 || cs_change || clk_div || imask) {
-		spi_enable_chip(dws, 0);
+		spi_dw_enable_chip(dws, 0);
 
 		if (dw_readw(dws, ctrl0) != cr0)
 			dw_writew(dws, ctrl0, cr0);
 
-		spi_set_clk(dws, clk_div ? clk_div : chip->clk_div);
-		spi_chip_sel(dws, spi->chip_select);
+		spi_dw_set_clk(dws, clk_div ? clk_div : chip->clk_div);
+		spi_dw_chip_sel(dws, spi->chip_select);
 
 		/* Set the interrupt mask, for poll mode just disable all int */
-		spi_mask_intr(dws, 0xff);
+		spi_dw_mask_intr(dws, 0xff);
 		if (imask)
-			spi_umask_intr(dws, imask);
+			spi_dw_umask_intr(dws, imask);
 		if (txint_level)
 			dw_writew(dws, txfltr, txint_level);
 
-		spi_enable_chip(dws, 1);
+		spi_dw_enable_chip(dws, 1);
 		if (cs_change)
 			dws->prev_chip = chip;
 	}
@@ -542,19 +542,19 @@ static void pump_transfers(unsigned long data)
 		dws->dma_ops->dma_transfer(dws, cs_change);
 
 	if (chip->poll_mode)
-		poll_transfer(dws);
+		spi_dw_poll_transfer(dws);
 
 	return;
 
 early_exit:
-	giveback(dws);
+	spi_dw_giveback(dws);
 	return;
 }
 
-static void pump_messages(struct work_struct *work)
+static void spi_dw_pump_messages(struct work_struct *work)
 {
-	struct dw_spi *dws =
-		container_of(work, struct dw_spi, pump_messages);
+	struct spi_dw *dws =
+		container_of(work, struct spi_dw, pump_messages);
 	unsigned long flags;
 
 	/* Lock queue and check for queue work */
@@ -590,9 +590,9 @@ static void pump_messages(struct work_struct *work)
 }
 
 /* spi_device use this to queue in their spi_msg */
-static int dw_spi_transfer(struct spi_device *spi, struct spi_message *msg)
+static int spi_dw_transfer(struct spi_device *spi, struct spi_message *msg)
 {
-	struct dw_spi *dws = spi_master_get_devdata(spi->master);
+	struct spi_dw *dws = spi_master_get_devdata(spi->master);
 	unsigned long flags;
 
 	spin_lock_irqsave(&dws->lock, flags);
@@ -616,7 +616,7 @@ static int dw_spi_transfer(struct spi_device *spi, struct spi_message *msg)
 		else {
 			/* If no other data transaction in air, just go */
 			spin_unlock_irqrestore(&dws->lock, flags);
-			pump_messages(&dws->pump_messages);
+			spi_dw_pump_messages(&dws->pump_messages);
 			return 0;
 		}
 	}
@@ -626,7 +626,7 @@ static int dw_spi_transfer(struct spi_device *spi, struct spi_message *msg)
 }
 
 /* This may be called twice for each spi dev */
-static int dw_spi_setup(struct spi_device *spi)
+static int spi_dw_setup(struct spi_device *spi)
 {
 	struct dw_spi_chip *chip_info = NULL;
 	struct chip_data *chip;
@@ -692,13 +692,13 @@ static int dw_spi_setup(struct spi_device *spi)
 	return 0;
 }
 
-static void dw_spi_cleanup(struct spi_device *spi)
+static void spi_dw_cleanup(struct spi_device *spi)
 {
 	struct chip_data *chip = spi_get_ctldata(spi);
 	kfree(chip);
 }
 
-static int __devinit init_queue(struct dw_spi *dws)
+static int __devinit spi_dw_init_queue(struct spi_dw *dws)
 {
 	INIT_LIST_HEAD(&dws->queue);
 	spin_lock_init(&dws->lock);
@@ -707,9 +707,9 @@ static int __devinit init_queue(struct dw_spi *dws)
 	dws->busy = 0;
 
 	tasklet_init(&dws->pump_transfers,
-			pump_transfers,	(unsigned long)dws);
+			spi_dw_pump_transfers,	(unsigned long)dws);
 
-	INIT_WORK(&dws->pump_messages, pump_messages);
+	INIT_WORK(&dws->pump_messages, spi_dw_pump_messages);
 	dws->workqueue = create_singlethread_workqueue(
 					dev_name(dws->master->dev.parent));
 	if (dws->workqueue == NULL)
@@ -718,7 +718,7 @@ static int __devinit init_queue(struct dw_spi *dws)
 	return 0;
 }
 
-static int start_queue(struct dw_spi *dws)
+static int spi_dw_start_queue(struct spi_dw *dws)
 {
 	unsigned long flags;
 
@@ -741,7 +741,7 @@ static int start_queue(struct dw_spi *dws)
 	return 0;
 }
 
-static int stop_queue(struct dw_spi *dws)
+static int spi_dw_stop_queue(struct spi_dw *dws)
 {
 	unsigned long flags;
 	unsigned limit = 50;
@@ -762,11 +762,11 @@ static int stop_queue(struct dw_spi *dws)
 	return status;
 }
 
-static int destroy_queue(struct dw_spi *dws)
+static int destroy_queue(struct spi_dw *dws)
 {
 	int status;
 
-	status = stop_queue(dws);
+	status = spi_dw_stop_queue(dws);
 	if (status != 0)
 		return status;
 	destroy_workqueue(dws->workqueue);
@@ -774,11 +774,11 @@ static int destroy_queue(struct dw_spi *dws)
 }
 
 /* Restart the controller, disable all interrupts, clean rx fifo */
-static void spi_hw_init(struct dw_spi *dws)
+static void spi_dw_hw_init(struct spi_dw *dws)
 {
-	spi_enable_chip(dws, 0);
-	spi_mask_intr(dws, 0xff);
-	spi_enable_chip(dws, 1);
+	spi_dw_enable_chip(dws, 0);
+	spi_dw_mask_intr(dws, 0xff);
+	spi_dw_enable_chip(dws, 1);
 
 	/*
 	 * Try to detect the FIFO depth if not set by interface driver,
@@ -797,7 +797,7 @@ static void spi_hw_init(struct dw_spi *dws)
 	}
 }
 
-int __devinit dw_spi_add_host(struct dw_spi *dws)
+int __devinit spi_dw_add_host(struct spi_dw *dws)
 {
 	struct spi_master *master;
 	int ret;
@@ -816,8 +816,8 @@ int __devinit dw_spi_add_host(struct dw_spi *dws)
 	dws->dma_inited = 0;
 	dws->dma_addr = (dma_addr_t)(dws->paddr + 0x60);
 
-	ret = request_irq(dws->irq, dw_spi_irq, IRQF_SHARED,
-			"dw_spi", dws);
+	ret = request_irq(dws->irq, spi_dw_irq, IRQF_SHARED,
+			"spi_dw", dws);
 	if (ret < 0) {
 		dev_err(&master->dev, "can not get IRQ\n");
 		goto err_free_master;
@@ -826,12 +826,12 @@ int __devinit dw_spi_add_host(struct dw_spi *dws)
 	master->mode_bits = SPI_CPOL | SPI_CPHA;
 	master->bus_num = dws->bus_num;
 	master->num_chipselect = dws->num_cs;
-	master->cleanup = dw_spi_cleanup;
-	master->setup = dw_spi_setup;
-	master->transfer = dw_spi_transfer;
+	master->cleanup = spi_dw_cleanup;
+	master->setup = spi_dw_setup;
+	master->transfer = spi_dw_transfer;
 
 	/* Basic HW init */
-	spi_hw_init(dws);
+	spi_dw_hw_init(dws);
 
 	if (dws->dma_ops && dws->dma_ops->dma_init) {
 		ret = dws->dma_ops->dma_init(dws);
@@ -842,12 +842,12 @@ int __devinit dw_spi_add_host(struct dw_spi *dws)
 	}
 
 	/* Initial and start queue */
-	ret = init_queue(dws);
+	ret = spi_dw_init_queue(dws);
 	if (ret) {
 		dev_err(&master->dev, "problem initializing queue\n");
 		goto err_diable_hw;
 	}
-	ret = start_queue(dws);
+	ret = spi_dw_start_queue(dws);
 	if (ret) {
 		dev_err(&master->dev, "problem starting queue\n");
 		goto err_diable_hw;
@@ -860,7 +860,7 @@ int __devinit dw_spi_add_host(struct dw_spi *dws)
 		goto err_queue_alloc;
 	}
 
-	mrst_spi_debugfs_init(dws);
+	spi_dw_debugfs_init(dws);
 	return 0;
 
 err_queue_alloc:
@@ -868,65 +868,65 @@ err_queue_alloc:
 	if (dws->dma_ops && dws->dma_ops->dma_exit)
 		dws->dma_ops->dma_exit(dws);
 err_diable_hw:
-	spi_enable_chip(dws, 0);
+	spi_dw_enable_chip(dws, 0);
 	free_irq(dws->irq, dws);
 err_free_master:
 	spi_master_put(master);
 exit:
 	return ret;
 }
-EXPORT_SYMBOL_GPL(dw_spi_add_host);
+EXPORT_SYMBOL_GPL(spi_dw_add_host);
 
-void __devexit dw_spi_remove_host(struct dw_spi *dws)
+void __devexit spi_dw_remove_host(struct spi_dw *dws)
 {
 	int status = 0;
 
 	if (!dws)
 		return;
-	mrst_spi_debugfs_remove(dws);
+	spi_dw_debugfs_remove(dws);
 
 	/* Remove the queue */
 	status = destroy_queue(dws);
 	if (status != 0)
-		dev_err(&dws->master->dev, "dw_spi_remove: workqueue will not "
+		dev_err(&dws->master->dev, "spi_dw_remove: workqueue will not "
 			"complete, message memory not freed\n");
 
 	if (dws->dma_ops && dws->dma_ops->dma_exit)
 		dws->dma_ops->dma_exit(dws);
-	spi_enable_chip(dws, 0);
+	spi_dw_enable_chip(dws, 0);
 	/* Disable clk */
-	spi_set_clk(dws, 0);
+	spi_dw_set_clk(dws, 0);
 	free_irq(dws->irq, dws);
 
 	/* Disconnect from the SPI framework */
 	spi_unregister_master(dws->master);
 }
-EXPORT_SYMBOL_GPL(dw_spi_remove_host);
+EXPORT_SYMBOL_GPL(spi_dw_remove_host);
 
-int dw_spi_suspend_host(struct dw_spi *dws)
+int spi_dw_suspend_host(struct spi_dw *dws)
 {
 	int ret = 0;
 
-	ret = stop_queue(dws);
+	ret = spi_dw_stop_queue(dws);
 	if (ret)
 		return ret;
-	spi_enable_chip(dws, 0);
-	spi_set_clk(dws, 0);
+	spi_dw_enable_chip(dws, 0);
+	spi_dw_set_clk(dws, 0);
 	return ret;
 }
-EXPORT_SYMBOL_GPL(dw_spi_suspend_host);
+EXPORT_SYMBOL_GPL(spi_dw_suspend_host);
 
-int dw_spi_resume_host(struct dw_spi *dws)
+int spi_dw_resume_host(struct spi_dw *dws)
 {
 	int ret;
 
-	spi_hw_init(dws);
-	ret = start_queue(dws);
+	spi_dw_hw_init(dws);
+	ret = spi_dw_start_queue(dws);
 	if (ret)
 		dev_err(&dws->master->dev, "fail to start queue (%d)\n", ret);
 	return ret;
 }
-EXPORT_SYMBOL_GPL(dw_spi_resume_host);
+EXPORT_SYMBOL_GPL(spi_dw_resume_host);
 
 MODULE_AUTHOR("Feng Tang <feng.tang@intel.com>");
 MODULE_DESCRIPTION("Driver for DesignWare SPI controller core");
diff --git a/drivers/spi/spi-dw.h b/drivers/spi/spi-dw.h
index 92bee30..83b9a59 100644
--- a/drivers/spi/spi-dw.h
+++ b/drivers/spi/spi-dw.h
@@ -51,7 +51,7 @@
 #define SPI_INT_THRESHOLD		32
 
 
-struct dw_spi_reg {
+struct spi_dw_reg {
 	u32	ctrl0;
 	u32	ctrl1;
 	u32	ssienr;
@@ -80,14 +80,14 @@ struct dw_spi_reg {
 				though only low 16 bits matters */
 } __packed;
 
-struct dw_spi;
-struct dw_spi_dma_ops {
-	int (*dma_init)(struct dw_spi *dws);
-	void (*dma_exit)(struct dw_spi *dws);
-	int (*dma_transfer)(struct dw_spi *dws, int cs_change);
+struct spi_dw;
+struct spi_dw_dma_ops {
+	int (*dma_init)(struct spi_dw *dws);
+	void (*dma_exit)(struct spi_dw *dws);
+	int (*dma_transfer)(struct spi_dw *dws, int cs_change);
 };
 
-struct dw_spi {
+struct spi_dw {
 	struct spi_master	*master;
 	struct spi_device	*cur_dev;
 	struct device		*parent_dev;
@@ -133,7 +133,7 @@ struct dw_spi {
 	u8			max_bits_per_word;	/* maxim is 16b */
 	u32			dma_width;
 	int			cs_change;
-	irqreturn_t		(*transfer_handler)(struct dw_spi *dws);
+	irqreturn_t		(*transfer_handler)(struct spi_dw *dws);
 	void			(*cs_control)(u32 command);
 
 	/* Dma info */
@@ -145,7 +145,7 @@ struct dw_spi {
 	int			dma_chan_done;
 	struct device		*dma_dev;
 	dma_addr_t		dma_addr; /* phy address of the Data register */
-	struct dw_spi_dma_ops	*dma_ops;
+	struct spi_dw_dma_ops	*dma_ops;
 	void			*dma_priv; /* platform relate info */
 	struct pci_dev		*dmac;
 
@@ -157,25 +157,25 @@ struct dw_spi {
 };
 
 #define dw_readl(dw, name) \
-	__raw_readl(&(((struct dw_spi_reg *)dw->regs)->name))
+	__raw_readl(&(((struct spi_dw_reg *)dw->regs)->name))
 #define dw_writel(dw, name, val) \
-	__raw_writel((val), &(((struct dw_spi_reg *)dw->regs)->name))
+	__raw_writel((val), &(((struct spi_dw_reg *)dw->regs)->name))
 #define dw_readw(dw, name) \
-	__raw_readw(&(((struct dw_spi_reg *)dw->regs)->name))
+	__raw_readw(&(((struct spi_dw_reg *)dw->regs)->name))
 #define dw_writew(dw, name, val) \
-	__raw_writew((val), &(((struct dw_spi_reg *)dw->regs)->name))
+	__raw_writew((val), &(((struct spi_dw_reg *)dw->regs)->name))
 
-static inline void spi_enable_chip(struct dw_spi *dws, int enable)
+static inline void spi_dw_enable_chip(struct spi_dw *dws, int enable)
 {
 	dw_writel(dws, ssienr, (enable ? 1 : 0));
 }
 
-static inline void spi_set_clk(struct dw_spi *dws, u16 div)
+static inline void spi_dw_set_clk(struct spi_dw *dws, u16 div)
 {
 	dw_writel(dws, baudr, div);
 }
 
-static inline void spi_chip_sel(struct dw_spi *dws, u16 cs)
+static inline void spi_dw_chip_sel(struct spi_dw *dws, u16 cs)
 {
 	if (cs > dws->num_cs)
 		return;
@@ -187,7 +187,7 @@ static inline void spi_chip_sel(struct dw_spi *dws, u16 cs)
 }
 
 /* Disable IRQ bits */
-static inline void spi_mask_intr(struct dw_spi *dws, u32 mask)
+static inline void spi_dw_mask_intr(struct spi_dw *dws, u32 mask)
 {
 	u32 new_mask;
 
@@ -196,7 +196,7 @@ static inline void spi_mask_intr(struct dw_spi *dws, u32 mask)
 }
 
 /* Enable IRQ bits */
-static inline void spi_umask_intr(struct dw_spi *dws, u32 mask)
+static inline void spi_dw_umask_intr(struct spi_dw *dws, u32 mask)
 {
 	u32 new_mask;
 
@@ -205,12 +205,12 @@ static inline void spi_umask_intr(struct dw_spi *dws, u32 mask)
 }
 
 
-extern int dw_spi_add_host(struct dw_spi *dws);
-extern void dw_spi_remove_host(struct dw_spi *dws);
-extern int dw_spi_suspend_host(struct dw_spi *dws);
-extern int dw_spi_resume_host(struct dw_spi *dws);
-extern void dw_spi_xfer_done(struct dw_spi *dws);
+extern int spi_dw_add_host(struct spi_dw *dws);
+extern void spi_dw_remove_host(struct spi_dw *dws);
+extern int spi_dw_suspend_host(struct spi_dw *dws);
+extern int spi_dw_resume_host(struct spi_dw *dws);
+extern void spi_dw_xfer_done(struct spi_dw *dws);
 
 /* platform related setup */
-extern int dw_spi_mid_init(struct dw_spi *dws); /* Intel MID platforms */
+extern int spi_dw_mid_init(struct spi_dw *dws); /* Intel MID platforms */
 #endif /* DW_SPI_HEADER_H */
-- 
1.7.3.4

