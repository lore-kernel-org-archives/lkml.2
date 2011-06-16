Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757294Ab1FPNP7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 09:15:59 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:37655 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751304Ab1FPNP6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 09:15:58 -0400
Date: Thu, 16 Jun 2011 07:15:36 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: dirk.brandewie@gmail.com
Cc: linux-kernel@vger.kernel.org, spi-devel-general@lists.sourceforge.net
Subject: Re: [PATCH 4/5] spi/spi-dw: update function naming convention
Message-ID: <20110616131536.GE31534@ponder.secretlab.ca>
References: <1308158588-17249-1-git-send-email-dirk.brandewie@gmail.com>
 <1308158588-17249-5-git-send-email-dirk.brandewie@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1308158588-17249-5-git-send-email-dirk.brandewie@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 15, 2011 at 10:23:07AM -0700, dirk.brandewie@gmail.com wrote:
> From: Dirk Brandewie <dirk.brandewie@gmail.com>
> 
> Update internal maning to match new file names now that the naming
> convention for driver files is being enforced.
> 
> Signed-off-by: Dirk Brandewie <dirk.brandewie@gmail.com>

You should probably move this patch to before patch 2 & 3 when you
repost so that I can pick it up without needing all the
comments/concerns on patch 3 to be address first.

g.

> ---
>  drivers/spi/spi-dw-mid.c   |    8 ++--
>  drivers/spi/spi-dw-mmio.c  |   34 ++++++------
>  drivers/spi/spi-dw-pci.c   |   10 ++--
>  drivers/spi/spi-dw.c       |  116 ++++++++++++++++++++++---------------------
>  drivers/spi/spi-dw.h       |   46 +++++++++---------
>  include/linux/spi/spi-dw.h |    2 +-
>  6 files changed, 109 insertions(+), 107 deletions(-)
> 
> diff --git a/drivers/spi/spi-dw-mid.c b/drivers/spi/spi-dw-mid.c
> index e44e37f..fb41ea4 100644
> --- a/drivers/spi/spi-dw-mid.c
> +++ b/drivers/spi/spi-dw-mid.c
> @@ -118,7 +118,7 @@ static int mid_spi_dma_transfer(struct dw_spi *dws)
>  
>  	/* 1. setup DMA related registers */
>  
> -	dw_spi_disable(dws);
> +	spi_dw_disable(dws);
>  	dw_writew(dws, dmardlr, 0xf);
>  	dw_writew(dws, dmatdlr, 0x10);
>  	if (dws->xfer.tx_dma)
> @@ -126,7 +126,7 @@ static int mid_spi_dma_transfer(struct dw_spi *dws)
>  	if (dws->xfer.rx_dma)
>  		dma_ctrl |= 0x1;
>  	dw_writew(dws, dmacr, dma_ctrl);
> -	dw_spi_enable(dws);
> +	spi_dw_enable(dws);
>  
>  
>  	dws->dma_chan_done = 0;
> @@ -183,7 +183,7 @@ static int mid_spi_dma_transfer(struct dw_spi *dws)
>  	return 0;
>  }
>  
> -static struct dw_spi_dma_ops mid_dma_ops = {
> +static struct spi_dw_dma_ops mid_dma_ops = {
>  	.dma_init	= mid_spi_dma_init,
>  	.dma_exit	= mid_spi_dma_exit,
>  	.dma_transfer	= mid_spi_dma_transfer,
> @@ -200,7 +200,7 @@ static struct dw_spi_dma_ops mid_dma_ops = {
>  #define CLK_SPI_CDIV_MASK	0x00000e00
>  #define CLK_SPI_DISABLE_OFFSET	8
>  
> -int dw_spi_mid_init(struct dw_spi *dws)
> +int spi_dw_mid_init(struct dw_spi *dws)
>  {
>  	u32 *clk_reg, clk_cdiv;
>  
> diff --git a/drivers/spi/spi-dw-mmio.c b/drivers/spi/spi-dw-mmio.c
> index 34eb665..c978d35 100644
> --- a/drivers/spi/spi-dw-mmio.c
> +++ b/drivers/spi/spi-dw-mmio.c
> @@ -18,21 +18,21 @@
>  
>  #include "spi-dw.h"
>  
> -#define DRIVER_NAME "dw_spi_mmio"
> +#define DRIVER_NAME "spi_dw_mmio"
>  
> -struct dw_spi_mmio {
> +struct spi_dw_mmio {
>  	struct dw_spi  dws;
>  	struct clk     *clk;
>  };
>  
> -static int __devinit dw_spi_mmio_probe(struct platform_device *pdev)
> +static int __devinit spi_dw_mmio_probe(struct platform_device *pdev)
>  {
> -	struct dw_spi_mmio *dwsmmio;
> +	struct spi_dw_mmio *dwsmmio;
>  	struct dw_spi *dws;
>  	struct resource *mem, *ioarea;
>  	int ret;
>  
> -	dwsmmio = kzalloc(sizeof(struct dw_spi_mmio), GFP_KERNEL);
> +	dwsmmio = kzalloc(sizeof(struct spi_dw_mmio), GFP_KERNEL);
>  	if (!dwsmmio) {
>  		ret = -ENOMEM;
>  		goto err_end;
> @@ -82,7 +82,7 @@ static int __devinit dw_spi_mmio_probe(struct platform_device *pdev)
>  	dws->num_cs = 4;
>  	dws->max_freq = clk_get_rate(dwsmmio->clk);
>  
> -	ret = dw_spi_add_host(dws);
> +	ret = spi_dw_add_host(dws);
>  	if (ret)
>  		goto err_clk;
>  
> @@ -105,9 +105,9 @@ err_end:
>  	return ret;
>  }
>  
> -static int __devexit dw_spi_mmio_remove(struct platform_device *pdev)
> +static int __devexit spi_dw_mmio_remove(struct platform_device *pdev)
>  {
> -	struct dw_spi_mmio *dwsmmio = platform_get_drvdata(pdev);
> +	struct spi_dw_mmio *dwsmmio = platform_get_drvdata(pdev);
>  	struct resource *mem;
>  
>  	platform_set_drvdata(pdev, NULL);
> @@ -117,7 +117,7 @@ static int __devexit dw_spi_mmio_remove(struct platform_device *pdev)
>  	dwsmmio->clk = NULL;
>  
>  	free_irq(dwsmmio->dws.irq, &dwsmmio->dws);
> -	dw_spi_remove_host(&dwsmmio->dws);
> +	spi_dw_remove_host(&dwsmmio->dws);
>  	iounmap(dwsmmio->dws.regs);
>  	kfree(dwsmmio);
>  
> @@ -126,25 +126,25 @@ static int __devexit dw_spi_mmio_remove(struct platform_device *pdev)
>  	return 0;
>  }
>  
> -static struct platform_driver dw_spi_mmio_driver = {
> -	.remove		= __devexit_p(dw_spi_mmio_remove),
> +static struct platform_driver spi_dw_mmio_driver = {
> +	.remove		= __devexit_p(spi_dw_mmio_remove),
>  	.driver		= {
>  		.name	= DRIVER_NAME,
>  		.owner	= THIS_MODULE,
>  	},
>  };
>  
> -static int __init dw_spi_mmio_init(void)
> +static int __init spi_dw_mmio_init(void)
>  {
> -	return platform_driver_probe(&dw_spi_mmio_driver, dw_spi_mmio_probe);
> +	return platform_driver_probe(&spi_dw_mmio_driver, spi_dw_mmio_probe);
>  }
> -module_init(dw_spi_mmio_init);
> +module_init(spi_dw_mmio_init);
>  
> -static void __exit dw_spi_mmio_exit(void)
> +static void __exit spi_dw_mmio_exit(void)
>  {
> -	platform_driver_unregister(&dw_spi_mmio_driver);
> +	platform_driver_unregister(&spi_dw_mmio_driver);
>  }
> -module_exit(dw_spi_mmio_exit);
> +module_exit(spi_dw_mmio_exit);
>  
>  MODULE_AUTHOR("Jean-Hugues Deschenes <jean-hugues.deschenes@octasic.com>");
>  MODULE_DESCRIPTION("Memory-mapped I/O interface driver for DW SPI Core");
> diff --git a/drivers/spi/spi-dw-pci.c b/drivers/spi/spi-dw-pci.c
> index c5f37f0..eb35fa5 100644
> --- a/drivers/spi/spi-dw-pci.c
> +++ b/drivers/spi/spi-dw-pci.c
> @@ -80,12 +80,12 @@ static int __devinit spi_pci_probe(struct pci_dev *pdev,
>  	 * clock rate, FIFO depth.
>  	 */
>  	if (pdev->device == 0x0800) {
> -		ret = dw_spi_mid_init(dws);
> +		ret = spi_dw_mid_init(dws);
>  		if (ret)
>  			goto err_unmap;
>  	}
>  
> -	ret = dw_spi_add_host(dws);
> +	ret = spi_dw_add_host(dws);
>  	if (ret)
>  		goto err_unmap;
>  
> @@ -109,7 +109,7 @@ static void __devexit spi_pci_remove(struct pci_dev *pdev)
>  	struct dw_spi_pci *dwpci = pci_get_drvdata(pdev);
>  
>  	pci_set_drvdata(pdev, NULL);
> -	dw_spi_remove_host(&dwpci->dws);
> +	spi_dw_remove_host(&dwpci->dws);
>  	iounmap(dwpci->dws.regs);
>  	pci_release_region(pdev, 0);
>  	kfree(dwpci);
> @@ -122,7 +122,7 @@ static int spi_suspend(struct pci_dev *pdev, pm_message_t state)
>  	struct dw_spi_pci *dwpci = pci_get_drvdata(pdev);
>  	int ret;
>  
> -	ret = dw_spi_suspend_host(&dwpci->dws);
> +	ret = spi_dw_suspend_host(&dwpci->dws);
>  	if (ret)
>  		return ret;
>  	pci_save_state(pdev);
> @@ -141,7 +141,7 @@ static int spi_resume(struct pci_dev *pdev)
>  	ret = pci_enable_device(pdev);
>  	if (ret)
>  		return ret;
> -	return dw_spi_resume_host(&dwpci->dws);
> +	return spi_dw_resume_host(&dwpci->dws);
>  }
>  #else
>  #define spi_suspend	NULL
> diff --git a/drivers/spi/spi-dw.c b/drivers/spi/spi-dw.c
> index 2dacb8f..20f94fa 100644
> --- a/drivers/spi/spi-dw.c
> +++ b/drivers/spi/spi-dw.c
> @@ -1,5 +1,5 @@
>  /*
> - * dw_spi.c - Designware SPI core controller driver
> + * spi-dw.c - Designware SPI core controller driver
>   *
>   * Copyright (c) 2009, Intel Corporation.
>   *
> @@ -36,7 +36,7 @@
>  
>  
>  /* Slave spi_dev related */
> -struct chip_data {
> +struct slave_cfg {
>  	struct spi_device *spi_dev;
>  	u32 cr0;
>  	u32 cs;			/* chip select pin */
> @@ -73,7 +73,7 @@ static ssize_t  spi_show_regs(struct file *file, char __user *user_buf,
>  		return 0;
>  
>  	len += snprintf(buf + len, SPI_REGS_BUFSIZE - len,
> -			"MRST SPI0 registers:\n");
> +			"DW SPI0 registers:\n");
>  	len += snprintf(buf + len, SPI_REGS_BUFSIZE - len,
>  			"=================================\n");
>  	len += snprintf(buf + len, SPI_REGS_BUFSIZE - len,
> @@ -114,42 +114,42 @@ static ssize_t  spi_show_regs(struct file *file, char __user *user_buf,
>  	return ret;
>  }
>  
> -static const struct file_operations mrst_spi_regs_ops = {
> +static const struct file_operations spi_dw_regs_ops = {
>  	.owner		= THIS_MODULE,
>  	.open		= spi_show_regs_open,
>  	.read		= spi_show_regs,
>  	.llseek		= default_llseek,
>  };
>  
> -static int mrst_spi_debugfs_init(struct dw_spi *dws)
> +static int spi_dw_debugfs_init(struct dw_spi *dws)
>  {
> -	dws->debugfs = debugfs_create_dir("mrst_spi", NULL);
> +	dws->debugfs = debugfs_create_dir("spi_dw", NULL);
>  	if (!dws->debugfs)
>  		return -ENOMEM;
>  
>  	debugfs_create_file("registers", S_IFREG | S_IRUGO,
> -		dws->debugfs, (void *)dws, &mrst_spi_regs_ops);
> +		dws->debugfs, (void *)dws, &spi_dw_regs_ops);
>  	return 0;
>  }
>  
> -static void mrst_spi_debugfs_remove(struct dw_spi *dws)
> +static void spi_dw_debugfs_remove(struct dw_spi *dws)
>  {
>  	if (dws->debugfs)
>  		debugfs_remove_recursive(dws->debugfs);
>  }
>  
>  #else
> -static inline int mrst_spi_debugfs_init(struct dw_spi *dws)
> +static inline int spi_dw_debugfs_init(struct dw_spi *dws)
>  {
>  	return 0;
>  }
>  
> -static inline void mrst_spi_debugfs_remove(struct dw_spi *dws)
> +static inline void spi_dw_debugfs_remove(struct dw_spi *dws)
>  {
>  }
>  #endif /* CONFIG_DEBUG_FS */
>  
> -static irqreturn_t dw_spi_irq(int irq, void *dev_id)
> +static irqreturn_t spi_dw_irq(int irq, void *dev_id)
>  {
>  	struct dw_spi *dws = dev_id;
>  	u16  irq_mask = 0x3f;
> @@ -164,15 +164,16 @@ static irqreturn_t dw_spi_irq(int irq, void *dev_id)
>  		dw_readw(dws, rxoicr);
>  		dw_readw(dws, rxuicr);
>  		dws->xfer.err = -EIO;
> -		dw_spi_disable(dws);
> +		spi_dw_disable(dws);
>  		complete(&dws->xfer.complete);
>  		return IRQ_HANDLED;
>  	}
>  
>  	/* disable interrupts */
> -	dw_spi_mask_intr(dws, irq_mask);
> +	spi_dw_mask_intr(dws, irq_mask);
>  	return IRQ_WAKE_THREAD;
>  }
> +
>  struct spi_message *get_message(struct dw_spi *dws)
>  {
>  	struct spi_message *message = NULL;
> @@ -187,6 +188,7 @@ struct spi_message *get_message(struct dw_spi *dws)
>  	spin_unlock_irqrestore(&dws->lock, flags);
>  	return message;
>  }
> +
>  static inline u32 tx_max(struct dw_spi *dws)
>  {
>  	u32 tx_left, tx_room;
> @@ -204,7 +206,7 @@ static inline u32 rx_max(struct dw_spi *dws)
>  	return min(rx_left, (u32)dw_readw(dws, rxflr));
>  }
>  
> -static int transfer_setup(struct dw_spi *dws, struct chip_data *controller,
> +static int transfer_setup(struct dw_spi *dws, struct slave_cfg *controller,
>  			struct spi_transfer *transfer, struct spi_message *msg)
>  {
>  	int err = 0;
> @@ -253,7 +255,7 @@ static int transfer_setup(struct dw_spi *dws, struct chip_data *controller,
>  	if (unlikely(!controller->clk_div)) {
>  		controller->clk_div = dws->max_freq / controller->speed_hz;
>  		controller->clk_div = (controller->clk_div + 1) & 0xfffe;
> -		dw_spi_set_clk(dws, controller->clk_div);
> +		spi_dw_set_clk(dws, controller->clk_div);
>  		dev_err(&dws->master->dev, "setting default clk_div");
>  		err = 1;
>  	}
> @@ -292,11 +294,11 @@ static int transfer_setup(struct dw_spi *dws, struct chip_data *controller,
>  	controller->cr0 = cr0;
>  
>  	if (err || dw_readw(dws, ctrl0) != cr0) {
> -		dw_spi_disable(dws);
> -		dw_spi_chip_sel(dws, controller->spi_dev->chip_select);
> +		spi_dw_disable(dws);
> +		spi_dw_chip_sel(dws, controller->spi_dev->chip_select);
>  		dw_writew(dws, ctrl0, cr0);
> -		dw_spi_set_clk(dws, controller->clk_div);
> -		dw_spi_enable(dws);
> +		spi_dw_set_clk(dws, controller->clk_div);
> +		spi_dw_enable(dws);
>  		err = 0;
>  	}
>  out:
> @@ -357,7 +359,7 @@ static inline void do_pio(struct dw_spi *dws)
>  	complete(&dws->xfer.complete);
>  }
>  
> -static irqreturn_t dw_spi_irq_thread_handler(int irq, void *dev_id)
> +static irqreturn_t spi_dw_irq_thread_handler(int irq, void *dev_id)
>  {
>  	struct dw_spi *dws = dev_id;
>  
> @@ -377,17 +379,17 @@ static irqreturn_t dw_spi_irq_thread_handler(int irq, void *dev_id)
>  		goto out;
>  	}
>  
> -	dw_spi_umask_intr(dws, SPI_INT_ALL);
> +	spi_dw_umask_intr(dws, SPI_INT_ALL);
>  out:
>  	return IRQ_HANDLED;
>  }
>  
>  static inline void do_int_xfer(struct dw_spi *dws)
>  {
> -	dw_spi_disable(dws);
> +	spi_dw_disable(dws);
>  	dw_writew(dws, txfltr, dws->xfer.tx_threshold);
>  	dw_writew(dws, rxfltr, dws->xfer.rx_threshold);
> -	dw_spi_enable(dws);
> +	spi_dw_enable(dws);
>  	dw_readw(dws, icr);
>  	tx_fifo_fill(dws);
>  	dw_writew(dws, imr, SPI_INT_ALL);
> @@ -433,7 +435,7 @@ static void pump_messages(struct work_struct *work)
>  		container_of(work, struct dw_spi, pump_messages);
>  	struct spi_transfer *transfer;
>  	struct spi_message *message;
> -	struct chip_data *controller;
> +	struct slave_cfg *controller;
>  	int err = 0;
>  
>  
> @@ -474,7 +476,7 @@ static void pump_messages(struct work_struct *work)
>  }
>  
>  /* spi_device use this to queue in their spi_msg */
> -static int dw_spi_transfer(struct spi_device *spi, struct spi_message *msg)
> +static int spi_dw_transfer(struct spi_device *spi, struct spi_message *msg)
>  {
>  	struct dw_spi *dws = spi_master_get_devdata(spi->master);
>  	unsigned long flags;
> @@ -496,10 +498,10 @@ static int dw_spi_transfer(struct spi_device *spi, struct spi_message *msg)
>  }
>  
>  /* This may be called twice for each spi dev */
> -static int dw_spi_setup(struct spi_device *spi)
> +static int spi_dw_setup(struct spi_device *spi)
>  {
> -	struct dw_spi_chip *chip_info = NULL;
> -	struct chip_data *chip;
> +	struct spi_dw_chip *chip_info = NULL;
> +	struct slave_cfg *chip;
>  
>  	if (spi->bits_per_word != 8 && spi->bits_per_word != 16)
>  		return -EINVAL;
> @@ -512,7 +514,7 @@ static int dw_spi_setup(struct spi_device *spi)
>  	/* Only alloc on first setup */
>  	chip = spi_get_ctldata(spi);
>  	if (!chip) {
> -		chip = kzalloc(sizeof(struct chip_data), GFP_KERNEL);
> +		chip = kzalloc(sizeof(struct slave_cfg), GFP_KERNEL);
>  		if (!chip)
>  			return -ENOMEM;
>  	}
> @@ -545,9 +547,9 @@ static int dw_spi_setup(struct spi_device *spi)
>  	return 0;
>  }
>  
> -static void dw_spi_cleanup(struct spi_device *spi)
> +static void spi_dw_cleanup(struct spi_device *spi)
>  {
> -	struct chip_data *chip = spi_get_ctldata(spi);
> +	struct slave_cfg *chip = spi_get_ctldata(spi);
>  	kfree(chip);
>  }
>  
> @@ -568,7 +570,7 @@ static int __devinit init_queue(struct dw_spi *dws)
>  }
>  
>  
> -int dw_spi_stop_queue(struct dw_spi *dws)
> +int spi_dw_stop_queue(struct dw_spi *dws)
>  {
>  	unsigned long flags;
>  	int status = 0;
> @@ -582,13 +584,13 @@ int dw_spi_stop_queue(struct dw_spi *dws)
>  
>  	return status;
>  }
> -EXPORT_SYMBOL_GPL(dw_spi_stop_queue);
> +EXPORT_SYMBOL_GPL(spi_dw_stop_queue);
>  
>  static int destroy_queue(struct dw_spi *dws)
>  {
>  	int status;
>  
> -	status = dw_spi_stop_queue(dws);
> +	status = spi_dw_stop_queue(dws);
>  	if (status != 0)
>  		return status;
>  	destroy_workqueue(dws->workqueue);
> @@ -598,15 +600,15 @@ static int destroy_queue(struct dw_spi *dws)
>  /* Restart the controller, disable all interrupts, clean rx fifo */
>  static void spi_hw_init(struct dw_spi *dws)
>  {
> -	dw_spi_disable(dws);
> -	dw_spi_mask_intr(dws, 0xff);
> +	spi_dw_disable(dws);
> +	spi_dw_mask_intr(dws, 0xff);
>  	dw_readw(dws, icr);
> -	dw_spi_enable(dws);
> +	spi_dw_enable(dws);
>  
>  	BUG_ON(!dws->fifo_len);
>  }
>  
> -int __devinit dw_spi_add_host(struct dw_spi *dws)
> +int __devinit spi_dw_add_host(struct dw_spi *dws)
>  {
>  	struct spi_master *master;
>  	int ret;
> @@ -627,8 +629,8 @@ int __devinit dw_spi_add_host(struct dw_spi *dws)
>  	/* Change to address of FIFO */
>  	dws->dma_addr = (dma_addr_t)(dws->paddr + 0x60);
>  
> -	ret = request_threaded_irq(dws->irq, dw_spi_irq,
> -				dw_spi_irq_thread_handler,
> +	ret = request_threaded_irq(dws->irq, spi_dw_irq,
> +				spi_dw_irq_thread_handler,
>  				IRQF_SHARED, "dw_spi", dws);
>  	if (ret < 0) {
>  		dev_err(&master->dev, "can not get IRQ\n");
> @@ -638,9 +640,9 @@ int __devinit dw_spi_add_host(struct dw_spi *dws)
>  	master->mode_bits = SPI_CPOL | SPI_CPHA;
>  	master->bus_num = dws->bus_num;
>  	master->num_chipselect = dws->num_cs;
> -	master->cleanup = dw_spi_cleanup;
> -	master->setup = dw_spi_setup;
> -	master->transfer = dw_spi_transfer;
> +	master->cleanup = spi_dw_cleanup;
> +	master->setup = spi_dw_setup;
> +	master->transfer = spi_dw_transfer;
>  
>  	/* Basic HW init */
>  	spi_hw_init(dws);
> @@ -667,7 +669,7 @@ int __devinit dw_spi_add_host(struct dw_spi *dws)
>  		goto err_queue_alloc;
>  	}
>  
> -	mrst_spi_debugfs_init(dws);
> +	spi_dw_debugfs_init(dws);
>  	return 0;
>  
>  err_queue_alloc:
> @@ -675,59 +677,59 @@ err_queue_alloc:
>  	if (dws->dma_ops && dws->dma_ops->dma_exit)
>  		dws->dma_ops->dma_exit(dws);
>  err_diable_hw:
> -	dw_spi_disable(dws);
> +	spi_dw_disable(dws);
>  	free_irq(dws->irq, dws);
>  err_free_master:
>  	spi_master_put(master);
>  exit:
>  	return ret;
>  }
> -EXPORT_SYMBOL_GPL(dw_spi_add_host);
> +EXPORT_SYMBOL_GPL(spi_dw_add_host);
>  
> -void __devexit dw_spi_remove_host(struct dw_spi *dws)
> +void __devexit spi_dw_remove_host(struct dw_spi *dws)
>  {
>  	int status = 0;
>  
>  	if (!dws)
>  		return;
> -	mrst_spi_debugfs_remove(dws);
> +	spi_dw_debugfs_remove(dws);
>  
>  	/* Remove the queue */
>  	status = destroy_queue(dws);
>  	if (status != 0)
> -		dev_err(&dws->master->dev, "dw_spi_remove: workqueue will not "
> +		dev_err(&dws->master->dev, "spi_dw_remove: workqueue will not "
>  			"complete, message memory not freed\n");
>  
>  	if (dws->dma_ops && dws->dma_ops->dma_exit)
>  		dws->dma_ops->dma_exit(dws);
> -	dw_spi_disable(dws);
> +	spi_dw_disable(dws);
>  	dw_readw(dws, icr);
>  	free_irq(dws->irq, dws);
>  
>  	/* Disconnect from the SPI framework */
>  	spi_unregister_master(dws->master);
>  }
> -EXPORT_SYMBOL_GPL(dw_spi_remove_host);
> +EXPORT_SYMBOL_GPL(spi_dw_remove_host);
>  
> -int dw_spi_suspend_host(struct dw_spi *dws)
> +int spi_dw_suspend_host(struct dw_spi *dws)
>  {
>  	int ret = 0;
>  
> -	ret = dw_spi_stop_queue(dws);
> +	ret = spi_dw_stop_queue(dws);
>  	if (ret)
>  		return ret;
> -	dw_spi_disable(dws);
> +	spi_dw_disable(dws);
>  	return ret;
>  }
> -EXPORT_SYMBOL_GPL(dw_spi_suspend_host);
> +EXPORT_SYMBOL_GPL(spi_dw_suspend_host);
>  
> -int dw_spi_resume_host(struct dw_spi *dws)
> +int spi_dw_resume_host(struct dw_spi *dws)
>  {
>  	spi_hw_init(dws);
>  	dws->run = QUEUE_RUNNING;
>  	return 0;
>  }
> -EXPORT_SYMBOL_GPL(dw_spi_resume_host);
> +EXPORT_SYMBOL_GPL(spi_dw_resume_host);
>  
>  MODULE_AUTHOR("Feng Tang <feng.tang@intel.com>");
>  MODULE_DESCRIPTION("Driver for DesignWare SPI controller core");
> diff --git a/drivers/spi/spi-dw.h b/drivers/spi/spi-dw.h
> index b016b85..6acb67c 100644
> --- a/drivers/spi/spi-dw.h
> +++ b/drivers/spi/spi-dw.h
> @@ -3,7 +3,7 @@
>  
>  #include <linux/io.h>
>  #include <linux/scatterlist.h>
> -#include <linux/spi/dw_spi.h>
> +#include <linux/spi/spi-dw.h>
>  
>  /* Bit fields in CTRLR0 */
>  #define SPI_DFS_OFFSET			0
> @@ -53,7 +53,7 @@
>  /* TX RX interrupt level threshold, max can be 256 */
>  #define SPI_INT_THRESHOLD		32
>  
> -struct dw_spi_reg {
> +struct spi_dw_reg {
>  	u32	ctrl0;
>  	u32	ctrl1;
>  	u32	ssienr;
> @@ -83,7 +83,7 @@ struct dw_spi_reg {
>  } __packed;
>  
>  struct dw_spi;
> -struct dw_spi_dma_ops {
> +struct spi_dw_dma_ops {
>  	int (*dma_init)(struct dw_spi *dws);
>  	void (*dma_exit)(struct dw_spi *dws);
>  	int (*dma_transfer)(struct dw_spi *dws);
> @@ -149,7 +149,7 @@ struct dw_spi {
>  	u32			dma_chan_done;
>  	struct device		*dma_dev;
>  	dma_addr_t		dma_addr; /* phy address of the Data register */
> -	struct dw_spi_dma_ops	*dma_ops;
> +	struct spi_dw_dma_ops	*dma_ops;
>  	void			*dma_priv; /* platform relate info */
>  	struct pci_dev		*dmac;
>  
> @@ -161,34 +161,34 @@ struct dw_spi {
>  };
>  
>  #define dw_readl(dw, name) \
> -	__raw_readl(&(((struct dw_spi_reg *)dw->regs)->name))
> +	__raw_readl(&(((struct spi_dw_reg *)dw->regs)->name))
>  #define dw_writel(dw, name, val) \
> -	__raw_writel((val), &(((struct dw_spi_reg *)dw->regs)->name))
> +	__raw_writel((val), &(((struct spi_dw_reg *)dw->regs)->name))
>  #define dw_readw(dw, name) \
> -	__raw_readw(&(((struct dw_spi_reg *)dw->regs)->name))
> +	__raw_readw(&(((struct spi_dw_reg *)dw->regs)->name))
>  #define dw_writew(dw, name, val) \
> -	__raw_writew((val), &(((struct dw_spi_reg *)dw->regs)->name))
> +	__raw_writew((val), &(((struct spi_dw_reg *)dw->regs)->name))
>  #define dw_readb(dw, name) \
> -	__raw_readb(&(((struct dw_spi_reg *)dw->regs)->name))
> +	__raw_readb(&(((struct spi_dw_reg *)dw->regs)->name))
>  #define dw_writeb(dw, name, val) \
> -	__raw_writeb((val), &(((struct dw_spi_reg *)dw->regs)->name))
> +	__raw_writeb((val), &(((struct spi_dw_reg *)dw->regs)->name))
>  
> -static inline void dw_spi_disable(struct dw_spi *dws)
> +static inline void spi_dw_disable(struct dw_spi *dws)
>  {
>  	dw_writel(dws, ssienr, 0);
>  }
>  
> -static inline void dw_spi_enable(struct dw_spi *dws)
> +static inline void spi_dw_enable(struct dw_spi *dws)
>  {
>  	dw_writel(dws, ssienr, 1);
>  }
>  
> -static inline void dw_spi_set_clk(struct dw_spi *dws, u16 div)
> +static inline void spi_dw_set_clk(struct dw_spi *dws, u16 div)
>  {
>  	dw_writel(dws, baudr, div);
>  }
>  
> -static inline void dw_spi_chip_sel(struct dw_spi *dws, u16 cs)
> +static inline void spi_dw_chip_sel(struct dw_spi *dws, u16 cs)
>  {
>  	if (cs > dws->num_cs)
>  		return;
> @@ -197,7 +197,7 @@ static inline void dw_spi_chip_sel(struct dw_spi *dws, u16 cs)
>  }
>  
>  /* Disable IRQ bits */
> -static inline void dw_spi_mask_intr(struct dw_spi *dws, u32 mask)
> +static inline void spi_dw_mask_intr(struct dw_spi *dws, u32 mask)
>  {
>  	u32 new_mask;
>  
> @@ -206,7 +206,7 @@ static inline void dw_spi_mask_intr(struct dw_spi *dws, u32 mask)
>  }
>  
>  /* Enable IRQ bits */
> -static inline void dw_spi_umask_intr(struct dw_spi *dws, u32 mask)
> +static inline void spi_dw_umask_intr(struct dw_spi *dws, u32 mask)
>  {
>  	u32 new_mask;
>  
> @@ -214,13 +214,13 @@ static inline void dw_spi_umask_intr(struct dw_spi *dws, u32 mask)
>  	dw_writel(dws, imr, new_mask);
>  }
>  
> -extern int dw_spi_add_host(struct dw_spi *dws);
> -extern void dw_spi_remove_host(struct dw_spi *dws);
> -extern int dw_spi_suspend_host(struct dw_spi *dws);
> -extern int dw_spi_resume_host(struct dw_spi *dws);
> -extern void dw_spi_xfer_done(struct dw_spi *dws);
> -extern int dw_spi_stop_queue(struct dw_spi *dws);
> +extern int spi_dw_add_host(struct dw_spi *dws);
> +extern void spi_dw_remove_host(struct dw_spi *dws);
> +extern int spi_dw_suspend_host(struct dw_spi *dws);
> +extern int spi_dw_resume_host(struct dw_spi *dws);
> +extern void spi_dw_xfer_done(struct dw_spi *dws);
> +extern int spi_dw_stop_queue(struct dw_spi *dws);
>  
>  /* platform related setup */
> -extern int dw_spi_mid_init(struct dw_spi *dws); /* Intel MID platforms */
> +extern int spi_dw_mid_init(struct dw_spi *dws); /* Intel MID platforms */
>  #endif /* DW_SPI_HEADER_H */
> diff --git a/include/linux/spi/spi-dw.h b/include/linux/spi/spi-dw.h
> index 75dba03..c4a96be 100644
> --- a/include/linux/spi/spi-dw.h
> +++ b/include/linux/spi/spi-dw.h
> @@ -13,7 +13,7 @@ enum dw_ssi_type {
>   * which can be save in the "controller_data" member of the
>   * struct spi_device
>   */
> -struct dw_spi_chip {
> +struct spi_dw_chip {
>  	u8 type;	/* SPI/SSP/Micrwire */
>  	u8 enable_dma;
>  };
> -- 
> 1.7.3.4
> 
> 
> ------------------------------------------------------------------------------
> EditLive Enterprise is the world's most technically advanced content
> authoring tool. Experience the power of Track Changes, Inline Image
> Editing and ensure content is compliant with Accessibility Checking.
> http://p.sf.net/sfu/ephox-dev2dev
> _______________________________________________
> spi-devel-general mailing list
> spi-devel-general@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/spi-devel-general
