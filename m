Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756654Ab1ELL41 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 07:56:27 -0400
Received: from 64.mail-out.ovh.net ([91.121.185.65]:39968 "HELO
	64.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756534Ab1ELL4Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 07:56:25 -0400
Date: Thu, 12 May 2011 13:45:30 +0200
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Josh Wu <josh.wu@atmel.com>
Cc: mchehab@redhat.com, linux-media@vger.kernel.org, lars.haring@atmel.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        g.liakhovetski@gmx.de
Subject: Re: [PATCH] [media] at91: add Atmel Image Sensor Interface (ISI)
 support
Message-ID: <20110512114530.GE18952@game.jcrosoft.org>
References: <1305186138-5656-1-git-send-email-josh.wu@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1305186138-5656-1-git-send-email-josh.wu@atmel.com>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 14619810291152562959
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|U 0.5/N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +struct atmel_isi;
do we really this here?
> +
> +enum atmel_isi_pixfmt {
> +	ATMEL_ISI_PIXFMT_GREY,		/* Greyscale */
> +	ATMEL_ISI_PIXFMT_CbYCrY,
> +	ATMEL_ISI_PIXFMT_CrYCbY,
> +	ATMEL_ISI_PIXFMT_YCbYCr,
> +	ATMEL_ISI_PIXFMT_YCrYCb,
> +	ATMEL_ISI_PIXFMT_RGB24,
> +	ATMEL_ISI_PIXFMT_BGR24,
> +	ATMEL_ISI_PIXFMT_RGB16,
> +	ATMEL_ISI_PIXFMT_BGR16,
> +	ATMEL_ISI_PIXFMT_GRB16,		/* G[2:0] R[4:0]/B[4:0] G[5:3] */
> +	ATMEL_ISI_PIXFMT_GBR16,		/* G[2:0] B[4:0]/R[4:0] G[5:3] */
> +	ATMEL_ISI_PIXFMT_RGB24_REV,
> +	ATMEL_ISI_PIXFMT_BGR24_REV,
> +	ATMEL_ISI_PIXFMT_RGB16_REV,
> +	ATMEL_ISI_PIXFMT_BGR16_REV,
> +	ATMEL_ISI_PIXFMT_GRB16_REV,	/* G[2:0] R[4:0]/B[4:0] G[5:3] */
> +	ATMEL_ISI_PIXFMT_GBR16_REV,	/* G[2:0] B[4:0]/R[4:0] G[5:3] */
> +};
> +
> +struct isi_platform_data {
> +	u8 has_emb_sync;
> +	u8 emb_crc_sync;
> +	u8 hsync_act_low;
> +	u8 vsync_act_low;
> +	u8 pclk_act_falling;
> +	u8 isi_full_mode;
> +#define ISI_HSYNC_ACT_LOW	0x01
> +#define ISI_VSYNC_ACT_LOW	0x02
> +#define ISI_PXCLK_ACT_FALLING	0x04
> +#define ISI_EMB_SYNC		0x08
> +#define ISI_CRC_SYNC		0x10
> +#define ISI_FULL		0x20
> +#define ISI_DATAWIDTH_8		0x40
> +#define ISI_DATAWIDTH_10	0x80
> +	u32 flags;
> +	u8 gs_mode;
> +#define ISI_GS_2PIX_PER_WORD	0x00
> +#define ISI_GS_1PIX_PER_WORD	0x01
> +	u8 pixfmt;
> +	u8 sfd;
> +	u8 sld;
> +	u8 thmask;
> +#define ISI_BURST_4_8_16	0x00
> +#define ISI_BURST_8_16		0x01
> +#define ISI_BURST_16		0x02
> +	u8 frate;
> +#define ISI_FRATE_DIV_2		0x01
> +#define ISI_FRATE_DIV_3		0x02
> +#define ISI_FRATE_DIV_4		0x03
> +#define ISI_FRATE_DIV_5		0x04
> +#define ISI_FRATE_DIV_6		0x05
> +#define ISI_FRATE_DIV_7		0x06
> +#define ISI_FRATE_DIV_8		0x07
> +};
> +
> +#endif /* __AT91_ISI_H__ */
> diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
> index d61414e..eae6005 100644
> --- a/drivers/media/video/Kconfig
> +++ b/drivers/media/video/Kconfig
> @@ -80,6 +80,16 @@ menuconfig VIDEO_CAPTURE_DRIVERS
>  	  Some of those devices also supports FM radio.
>  
>  if VIDEO_CAPTURE_DRIVERS && VIDEO_V4L2
> +config VIDEO_ATMEL_ISI
> +	tristate "ATMEL Image Sensor Interface (ISI) support"
> +	depends on VIDEO_DEV && SOC_CAMERA
depends on AT91 if the drivers is at91 specific or avr32 otherwise
> +	select VIDEOBUF2_DMA_CONTIG
> +	default n
it's n by default  please remove
> +	---help---
> +	  This module makes the ATMEL Image Sensor Interface available
> +	  as a v4l2 device.
> +	  Say Y here to enable selecting the Image Sensor Interface.
> +	  When in doubt, say N.
>  
>  config VIDEO_ADV_DEBUG
>  	bool "Enable advanced debug functionality"
> diff --git a/drivers/media/video/Makefile b/drivers/media/video/Makefile
> index a10e4c3..f734a65 100644
> --- a/drivers/media/video/Makefile
> +++ b/drivers/media/video/Makefile
> @@ -166,6 +166,7 @@ obj-$(CONFIG_VIDEO_SH_MOBILE_CSI2)	+= sh_mobile_csi2.o
>  obj-$(CONFIG_VIDEO_SH_MOBILE_CEU)	+= sh_mobile_ceu_camera.o
>  obj-$(CONFIG_VIDEO_OMAP1)		+= omap1_camera.o
>  obj-$(CONFIG_VIDEO_SAMSUNG_S5P_FIMC) 	+= s5p-fimc/
> +obj-$(CONFIG_VIDEO_ATMEL_ISI)		+= atmel-isi.o
>  
>  obj-$(CONFIG_ARCH_DAVINCI)		+= davinci/
>  
> diff --git a/drivers/media/video/atmel-isi.c b/drivers/media/video/atmel-isi.c
> new file mode 100644
> index 0000000..33d0b83
> --- /dev/null
> +++ b/drivers/media/video/atmel-isi.c
> @@ -0,0 +1,1089 @@
> +/*
> + * Copyright (c) 2011 Atmel Corporation
> + *
> + * Based on previous work by Lars Haring and Sedji Gaouaou
> + *
> + * Based on the bttv driver for Bt848 with respective copyright holders
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#include <linux/clk.h>
> +#include <linux/completion.h>
> +#include <linux/fs.h>
> +#include <linux/init.h>
> +#include <linux/interrupt.h>
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/moduleparam.h>
> +#include <linux/platform_device.h>
> +#include <linux/slab.h>
> +#include <linux/version.h>
> +#include <linux/kfifo.h>
> +
> +#include <mach/board.h>
> +#include <mach/cpu.h>
> +#include <mach/at91_isi.h>
> +
> +#include <media/videobuf2-dma-contig.h>
> +#include <media/soc_camera.h>
> +#include <media/soc_mediabus.h>
> +
> +#define ATMEL_ISI_VERSION	KERNEL_VERSION(1, 0, 0)
> +#define MAX_BUFFER_NUMS		32
> +#define MAX_SUPPORT_WIDTH	2048
> +#define MAX_SUPPORT_HEIGHT	2048
> +
> +static unsigned int vid_limit = 16;
> +
> +enum isi_buffer_state {
> +	ISI_BUF_NEEDS_INIT,
> +	ISI_BUF_PREPARED,
> +};
> +
> +/* Single frame capturing states */
> +enum {
> +	STATE_IDLE = 0,
> +	STATE_CAPTURE_READY,
> +	STATE_CAPTURE_WAIT_SOF,
> +	STATE_CAPTURE_IN_PROGRESS,
> +	STATE_CAPTURE_DONE,
> +	STATE_CAPTURE_ERROR,
> +};
> +
> +/* Frame buffer descriptor
> + *  Used by the ISI module as a linked list for the DMA controller.
> + */
> +struct fbd {
> +	/* Physical address of the frame buffer */
> +	u32 fb_address;
> +#if defined(CONFIG_ARCH_AT91SAM9G45) ||\
> +	defined(CONFIG_ARCH_AT91SAM9X5)
> +	/* DMA Control Register(only in HISI2) */
> +	u32 dma_ctrl;
> +#endif
no ifdef in the struct
> +	/* Physical address of the next fbd */
> +	u32 next_fbd_address;
> +};
> +
> +#if defined(CONFIG_ARCH_AT91SAM9G45) ||\
> +	defined(CONFIG_ARCH_AT91SAM9X5)
> +static void set_dma_ctrl(struct fbd *fb_desc, u32 ctrl)
> +{
> +	fb_desc->dma_ctrl = ctrl;
> +}
> +#else
> +static void set_dma_ctrl(struct fbd *fb_desc, u32 ctrl) { }
> +#endif
no ifdef here also as we want to have multi soc support
> +
> +/* Frame buffer data
> + */
> +struct frame_buffer {
> +	struct vb2_buffer vb;
> +	struct fbd fb_desc;
> +	/* Frame number of the frame  */
> +	unsigned long sequence;
> +
> +	enum isi_buffer_state dma_desc_status;
> +	struct list_head list;
> +};
> +
> +struct atmel_isi {
> +	/* ISI module spin lock. Protects against concurrent access of variables
> +	 * that are shared with the ISR */
> +	spinlock_t			lock;
> +	void __iomem			*regs;
> +
> +	/*  If set ISI is in still capture mode */
> +	int				still_capture;
> +	int				sequence;
> +	/* State of the ISI module in capturing mode */
> +	int				state;
> +
> +	/* Capture/streaming wait queue for waiting for SOF */
> +	wait_queue_head_t		capture_wq;
> +
> +	struct v4l2_device		v4l2_dev;
> +
> +	struct vb2_alloc_ctx		*alloc_ctx;
> +
> +	struct clk			*pclk;
> +	struct platform_device		*pdev;
do you really need to store the pdev?
> +	unsigned int			irq;
> +
> +	struct isi_platform_data	*pdata;
> +	unsigned long			platform_flags;
> +
> +	struct list_head		video_buffer_list;
> +	struct frame_buffer		*active;
> +
> +	struct soc_camera_device	*icd;
> +	struct soc_camera_host		soc_host;
> +};
> +
> +static int configure_geometry(struct atmel_isi *isi, u32 width,
> +			u32 height, enum v4l2_mbus_pixelcode code)
> +{
> +	u32 cfg2, cr, ctrl;
> +
> +	cr = 0;
please move this in default
> +	switch (code) {
> +	/* YUV, including grey */
> +	case V4L2_MBUS_FMT_Y8_1X8:
> +		cr = ISI_BIT(GRAYSCALE);
> +		break;
> +	case V4L2_MBUS_FMT_UYVY8_2X8:
> +		cr = ISI_BF(V2_YCC_SWAP, 3);
> +		break;
> +	case V4L2_MBUS_FMT_VYUY8_2X8:
> +		cr = ISI_BF(V2_YCC_SWAP, 2);
> +		break;
> +	case V4L2_MBUS_FMT_YUYV8_2X8:
> +		cr = ISI_BF(V2_YCC_SWAP, 1);
> +		break;
> +	case V4L2_MBUS_FMT_YVYU8_2X8:
> +		cr = ISI_BF(V2_YCC_SWAP, 0);
> +		break;
> +	/* RGB, TODO */
> +	default:
> +		return -EINVAL;
> +	}
> +
> +	ctrl = ISI_BIT(DIS);
> +	isi_writel(isi, V2_CTRL, ctrl);
> +	/* Check if module properly disable */
> +	while (isi_readl(isi, V2_STATUS) & ISI_BIT(V2_DIS_DONE))
> +		cpu_relax();
> +
> +	cfg2 = isi_readl(isi, V2_CFG2);
> +	cfg2 |= cr;
> +	cfg2 = ISI_BFINS(V2_IM_VSIZE, height - 1, cfg2);
> +	cfg2 = ISI_BFINS(V2_IM_HSIZE, width - 1, cfg2);
> +	isi_writel(isi, V2_CFG2, cfg2);
> +
> +	return 0;
> +}
> +

> +
> +	size = bytes_per_line * icd->user_height;
> +
> +	if (0 == *nbuffers)
please invert the test
> +		*nbuffers = MAX_BUFFER_NUMS;
> +	if (*nbuffers > MAX_BUFFER_NUMS)
> +		*nbuffers = MAX_BUFFER_NUMS;
> +
> +	while (size * *nbuffers > vid_limit * 1024 * 1024)
> +		(*nbuffers)--;
> +
> +	*nplanes = 1;
> +	sizes[0] = size;
> +	alloc_ctxs[0] = dev->alloc_ctx;
> +
> +	dev->sequence = 0;
> +	dev->active = NULL;
> +
> +	dev_dbg(icd->dev.parent, "%s, count=%d, size=%ld\n", __func__,
> +		*nbuffers, size);
> +
> +	return 0;
> +}
> +
> +
> +static void start_dma(struct atmel_isi *isi, struct frame_buffer *buffer)
> +{
> +	u32 ctrl, cfg1;
please add ine ligne here
> +	ctrl = isi_readl(isi, V2_CTRL);
> +	cfg1 = isi_readl(isi, V2_CFG1);
> +	/* Enable irq: cxfr for the codec path, pxfr for the preview path */
> +	isi_writel(isi, V2_INTEN,
> +			ISI_BIT(V2_CXFR_DONE) | ISI_BIT(V2_PXFR_DONE));
> +
> +	/* Enable codec path */
> +	ctrl |= ISI_BIT(V2_CDC);
> +	/* Check if already in a frame */
> +	while (isi_readl(isi, V2_STATUS) & ISI_BIT(V2_CDC))
> +		cpu_relax();
no timeout?
> +
> +	/* Write the address of the first frame buffer in the C_ADDR reg
> +	* write the address of the first descriptor(link list of buffer)
> +	* in the C_DSCR reg, and enable dma channel.
> +	*/
> +	isi_writel(isi, V2_DMA_C_DSCR, (__pa(&(buffer->fb_desc))));
> +	isi_writel(isi, V2_DMA_C_CTRL,
> +			ISI_BIT(V2_DMA_FETCH) | ISI_BIT(V2_DMA_DONE));
> +	isi_writel(isi, V2_DMA_CHER, ISI_BIT(V2_DMA_C_CH_EN));
> +
> +	/* Enable linked list */
> +	cfg1 |= ISI_BF(V2_FRATE, isi->pdata->frate) | ISI_BIT(V2_DISCR);
> +
> +	/* Enable ISI module*/
> +	ctrl |= ISI_BIT(V2_ENABLE);
> +	isi_writel(isi, V2_CTRL, ctrl);
> +	isi_writel(isi, V2_CFG1, cfg1);
> +}
> +
> +
> +/* abort streaming and wait for last buffer */
> +static int stop_streaming(struct vb2_queue *vq)
> +{
> +	struct soc_camera_device *icd = soc_camera_from_vb2q(vq);
> +	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
> +	struct atmel_isi *isi = ici->priv;
> +
> +	spin_lock_irq(&isi->lock);
> +	isi->still_capture = 0;
> +	isi->active = NULL;
> +
> +	while (isi_readl(isi, V2_STATUS) & ISI_BIT(V2_CDC))
> +		cpu_relax();
ditto
> +
> +	/* Disble codec path */
> +	isi_writel(isi, V2_CTRL, isi_readl(isi, V2_CTRL) & (~ISI_BIT(V2_CDC)));
> +	/* Disable interrupts */
> +	isi_writel(isi, V2_INTDIS,
> +			ISI_BIT(V2_CXFR_DONE) | ISI_BIT(V2_PXFR_DONE));
> +	/* Disable ISI module*/
> +	isi_writel(isi, V2_CTRL, isi_readl(isi, V2_CTRL) | ISI_BIT(V2_DIS));
> +

> +
> +static int __init atmel_isi_probe(struct platform_device *pdev)
> +{
> +	unsigned int irq;
> +	struct atmel_isi *isi;
> +	struct clk *pclk;
> +	struct resource *regs;
> +	int ret;
> +	struct device *dev = &pdev->dev;
> +	struct isi_platform_data *pdata;
> +	struct soc_camera_host *soc_host;
> +
> +	regs = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	if (!regs)
> +		return -ENXIO;
> +
> +	pclk = clk_get(&pdev->dev, "isi_clk");
> +	if (IS_ERR(pclk))
> +		return PTR_ERR(pclk);
> +
> +	clk_enable(pclk);
do we really need to always enable the clock?
normally we need to enable it just when we use the device and disable asap


do you plane toadd the pm?

Best Regards,
J.
