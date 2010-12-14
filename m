Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932131Ab0LNMA6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 07:00:58 -0500
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:35224 "EHLO
	TX2EHSOBE009.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757819Ab0LNMAy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 07:00:54 -0500
X-SpamScore: -64
X-BigFish: VS-64(zzbb2dK8f9KJ1861R62a3Lc8kzz1202hzz8275bh8275dh84d07hz2dh2a8h668h34h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);(null);(null)
Content-Type: multipart/mixed;
	boundary="_000_33F32152BE7EC740BC2C838D2836AC8704A9A0039SN1MPN1002039d_"
From: Chen Jie-B02280 <B02280@freescale.com>
To: "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        Zhang Lily-R58066 <R58066@freescale.com>,
        "arnaud.patard@rtp-net.org" <arnaud.patard@rtp-net.org>
Subject: RE: [PATCH 3/9] Add a mfd IPUv3 driver
Thread-Topic: [PATCH 3/9] Add a mfd IPUv3 driver
Thread-Index: AQHLmzdInrcC4fwP7Eq2EojtS3YW3pOfQEnwgACVv4A=
Date: Tue, 14 Dec 2010 12:02:12 +0000
Message-ID: <33F32152BE7EC740BC2C838D2836AC8704A9A0@039-SN1MPN1-002.039d.mgd.msft.net>
References: <33F32152BE7EC740BC2C838D2836AC8704A4FD@039-SN1MPN1-002.039d.mgd.msft.net>
In-Reply-To: <33F32152BE7EC740BC2C838D2836AC8704A4FD@039-SN1MPN1-002.039d.mgd.msft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: <33F32152BE7EC740BC2C838D2836AC8704A9A0@039-SN1MPN1-002.039d.mgd.msft.net>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--_000_33F32152BE7EC740BC2C838D2836AC8704A9A0039SN1MPN1002039d_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Hi, Sascha,

My colleague Ying has give you many valuable comments, I have few new comme=
nts in-line below with [Jason]:

Jason Chen / Chen Jie
NMG / MAD
Freescale Semiconductor (China) Ltd.
2F, Building B, 177#, Bi Bo Rd
Pu Dong New District Shanghai 201203
Tel:     021-28937178
Fax:     021-28937444
E-mail:  Jason.Chen@freescale.com<mailto:Jason.Chen@freescale.com>
---------- Forwarded message ----------
From: Sascha Hauer <s.hauer@pengutronix.de<mailto:s.hauer@pengutronix.de>>
Date: 2010/12/9
Subject: [PATCH 3/9] Add a mfd IPUv3 driver
To: linux-arm-kernel@lists.infradead.org<mailto:linux-arm-kernel@lists.infr=
adead.org>
Cc: linux-kernel@vger.kernel.org<mailto:linux-kernel@vger.kernel.org>, linu=
x-fbdev@vger.kernel.org<mailto:linux-fbdev@vger.kernel.org>, Zhang Lily-R58=
066 <r58066@freescale.com<mailto:r58066@freescale.com>>, Arnaud Patard <arn=
aud.patard@rtp-net.org<mailto:arnaud.patard@rtp-net.org>>, Sascha Hauer <s.=
hauer@pengutronix.de<mailto:s.hauer@pengutronix.de>>


The IPU is the Image Processing Unit found on i.MX50/51/53 SoCs. It
features several units for image processing, this patch adds support
for the units needed for Framebuffer support, namely:

- Display Controller (dc)
- Display Interface (di)
- Display Multi Fifo Controller (dmfc)
- Display Processor (dp)
- Image DMA Controller (idmac)

This patch is based on the Freescale driver, but follows a different
approach. The Freescale code implements logical idmac channels and
the handling of the subunits is hidden in common idmac code pathes
in big switch/case statements. This patch instead just provides code
and resource management for the different subunits. The user, in this
case the framebuffer driver, decides how the different units play
together.

The IPU has other units missing in this patch:

- CMOS Sensor Interface (csi)
- Video Deinterlacer (vdi)
- Sensor Multi FIFO Controler (smfc)
- Image Converter (ic)
- Image Rotator (irt)

So expect more files to come in this directory.

Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de<mailto:s.hauer@pengutro=
nix.de>>
---
 arch/arm/plat-mxc/include/mach/ipu-v3.h |   48 +++
 drivers/mfd/Kconfig                     |    7 +
 drivers/mfd/Makefile                    |    1 +
 drivers/mfd/imx-ipu-v3/Makefile         |    3 +
 drivers/mfd/imx-ipu-v3/ipu-common.c     |  661 +++++++++++++++++++++++++++=
++++
 drivers/mfd/imx-ipu-v3/ipu-cpmem.c      |  608 +++++++++++++++++++++++++++=
+
 drivers/mfd/imx-ipu-v3/ipu-dc.c         |  362 +++++++++++++++++
 drivers/mfd/imx-ipu-v3/ipu-di.c         |  507 ++++++++++++++++++++++++
 drivers/mfd/imx-ipu-v3/ipu-dmfc.c       |  343 ++++++++++++++++
 drivers/mfd/imx-ipu-v3/ipu-dp.c         |  468 ++++++++++++++++++++++
 drivers/mfd/imx-ipu-v3/ipu-prv.h        |  214 ++++++++++
 include/linux/mfd/imx-ipu-v3.h          |  218 ++++++++++
 12 files changed, 3440 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/plat-mxc/include/mach/ipu-v3.h
 create mode 100644 drivers/mfd/imx-ipu-v3/Makefile
 create mode 100644 drivers/mfd/imx-ipu-v3/ipu-common.c
 create mode 100644 drivers/mfd/imx-ipu-v3/ipu-cpmem.c
 create mode 100644 drivers/mfd/imx-ipu-v3/ipu-dc.c
 create mode 100644 drivers/mfd/imx-ipu-v3/ipu-di.c
 create mode 100644 drivers/mfd/imx-ipu-v3/ipu-dmfc.c
 create mode 100644 drivers/mfd/imx-ipu-v3/ipu-dp.c
 create mode 100644 drivers/mfd/imx-ipu-v3/ipu-prv.h
 create mode 100644 include/linux/mfd/imx-ipu-v3.h

diff --git a/arch/arm/plat-mxc/include/mach/ipu-v3.h b/arch/arm/plat-mxc/in=
clude/mach/ipu-v3.h
new file mode 100644
index 0000000..0a6c3e8
--- /dev/null
+++ b/arch/arm/plat-mxc/include/mach/ipu-v3.h
@@ -0,0 +1,48 @@
+/*
+ * Copyright (c) 2010 Sascha Hauer <s.hauer@pengutronix.de<mailto:s.hauer@=
pengutronix.de>>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the
+ * Free Software Foundation; either version 2 of the License, or (at your
+ * option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABIL=
ITY
+ * or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public Licens=
e
+ * for more details.
+ */
+
+#ifndef __MACH_IPU_V3_H_
+#define __MACH_IPU_V3_H_
+
+/* IPU specific extensions to struct fb_videomode flag field */
+#define FB_SYNC_OE_LOW_ACT     (1 << 8)
+#define FB_SYNC_CLK_LAT_FALL   (1 << 9)
+#define FB_SYNC_DATA_INVERT    (1 << 10)
+#define FB_SYNC_CLK_IDLE_EN    (1 << 11)
+#define FB_SYNC_SHARP_MODE     (1 << 12)
+#define FB_SYNC_SWAP_RGB       (1 << 13)
+
+struct ipuv3_fb_platform_data {
+       const struct fb_videomode       *modes;
+       int                             num_modes;
+       char                            *mode_str;
+       u32                             interface_pix_fmt;
+
+#define IMX_IPU_FB_USE_MODEDB  (1 << 0)
+#define IMX_IPU_FB_USE_OVERLAY (1 << 1)
+       unsigned long                   flags;
+
+       int                             ipu_channel_bg;
+       int                             ipu_channel_fg;
+       int                             dc_channel;
+       int                             dp_channel;
+};
+
+struct imx_ipuv3_platform_data {
+       int rev;
+       struct ipuv3_fb_platform_data   *fb0_platform_data;
+       struct ipuv3_fb_platform_data   *fb1_platform_data;
+};
+
+#endif /* __MACH_IPU_V3_H_ */
diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 3a1493b..3c81879 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -606,6 +606,13 @@ config MFD_VX855
         VIA VX855/VX875 south bridge. You will need to enable the vx855_sp=
i
         and/or vx855_gpio drivers for this to do anything useful.

+config MFD_IMX_IPU_V3
+       tristate "Support the Image Processing Unit (IPU) found on the i.MX=
51"
+       depends on ARCH_MX51
+       select MFD_CORE
+       help
+         Say yes here to support the IPU on i.MX51.
+
 endif # MFD_SUPPORT

 menu "Multimedia Capabilities Port drivers"
diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
index f54b365..7873b13 100644
--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@ -81,3 +81,4 @@ obj-$(CONFIG_MFD_JANZ_CMODIO) +=3D janz-cmodio.o
 obj-$(CONFIG_MFD_JZ4740_ADC)   +=3D jz4740-adc.o
 obj-$(CONFIG_MFD_TPS6586X)     +=3D tps6586x.o
 obj-$(CONFIG_MFD_VX855)                +=3D vx855.o
+obj-$(CONFIG_MFD_IMX_IPU_V3)   +=3D imx-ipu-v3/
diff --git a/drivers/mfd/imx-ipu-v3/Makefile b/drivers/mfd/imx-ipu-v3/Makef=
ile
new file mode 100644
index 0000000..ff70fe8
--- /dev/null
+++ b/drivers/mfd/imx-ipu-v3/Makefile
@@ -0,0 +1,3 @@
+obj-$(CONFIG_MFD_IMX_IPU_V3) +=3D imx-ipu-v3.o
+
+imx-ipu-v3-objs :=3D ipu-common.o ipu-dc.o ipu-di.o ipu-dp.o ipu-dmfc.o ip=
u-cpmem.o
diff --git a/drivers/mfd/imx-ipu-v3/ipu-common.c b/drivers/mfd/imx-ipu-v3/i=
pu-common.c
new file mode 100644
index 0000000..e6edb88
--- /dev/null
+++ b/drivers/mfd/imx-ipu-v3/ipu-common.c
@@ -0,0 +1,661 @@
+/*
+ * Copyright (c) 2010 Sascha Hauer <s.hauer@pengutronix.de<mailto:s.hauer@=
pengutronix.de>>
+ * Copyright (C) 2005-2009 Freescale Semiconductor, Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the
+ * Free Software Foundation; either version 2 of the License, or (at your
+ * option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABIL=
ITY
+ * or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public Licens=
e
+ * for more details.
+ */
+
+#include <linux/types.h>
+#include <linux/init.h>
+#include <linux/platform_device.h>
+#include <linux/err.h>
+#include <linux/spinlock.h>
+#include <linux/delay.h>
+#include <linux/interrupt.h>
+#include <linux/io.h>
+#include <linux/mfd/imx-ipu-v3.h>
+#include <linux/clk.h>
+#include <linux/list.h>
+#include <mach/common.h>
+#include <linux/mfd/core.h>
+#include <mach/ipu-v3.h>
+
+#include "ipu-prv.h"
+
+static struct clk *ipu_clk;
+static struct device *ipu_dev;
+
+static DEFINE_SPINLOCK(ipu_lock);
+void __iomem *ipu_cm_reg;
+void __iomem *ipu_idmac_reg;
+
+static struct ipu_channel channels[64];
+
+struct ipu_channel *ipu_idmac_get(unsigned num)
+{
+       struct ipu_channel *channel;
+
+       dev_dbg(ipu_dev, "%s %d\n", __func__, num);
+
+       if (num > 63)
+               return ERR_PTR(-ENODEV);
+
+       channel =3D &channels[num];
+
+       if (channel->busy)
+               return ERR_PTR(-EBUSY);
+
+       channel->busy =3D 1;
+       channel->num =3D num;
+
+       clk_enable(ipu_clk);
+
+       return channel;
+}
+EXPORT_SYMBOL(ipu_idmac_get);
+
+void ipu_idmac_put(struct ipu_channel *channel)
+{
+       dev_dbg(ipu_dev, "%s %d\n", __func__, channel->num);
+
+       clk_disable(ipu_clk);
+       channel->busy =3D 0;
+}
+EXPORT_SYMBOL(ipu_idmac_put);
+
+void ipu_idmac_set_double_buffer(struct ipu_channel *channel, bool doubleb=
uffer)
+{
+       unsigned long flags;
+       u32 reg;
+
+       spin_lock_irqsave(&ipu_lock, flags);
+
+       reg =3D ipu_cm_read(IPU_CHA_DB_MODE_SEL(channel->num));
+       if (doublebuffer)
+               reg |=3D idma_mask(channel->num);
+       else
+               reg &=3D ~idma_mask(channel->num);
+       ipu_cm_write(reg, IPU_CHA_DB_MODE_SEL(channel->num));
+
+       spin_unlock_irqrestore(&ipu_lock, flags);
+}
+EXPORT_SYMBOL(ipu_idmac_set_double_buffer);
+
+void ipu_uninit_channel(struct ipu_channel *channel)
+{
+       unsigned long lock_flags;
+       u32 val;
+
+       /* Make sure channel is disabled */
+
+       if (idmac_idma_is_set(IDMAC_CHA_EN, channel->num)) {
+               dev_err(ipu_dev,
+                       "Channel %d is not disabled, disable first\n",
+                       channel->num);
+               return;
+       }
+
+       spin_lock_irqsave(&ipu_lock, lock_flags);
+
+       /* Reset the double buffer */
+       val =3D ipu_cm_read(IPU_CHA_DB_MODE_SEL(channel->num));
+       val &=3D ~idma_mask(channel->num);
+       ipu_cm_write(val, IPU_CHA_DB_MODE_SEL(channel->num));
+
+       spin_unlock_irqrestore(&ipu_lock, lock_flags);
+}
+EXPORT_SYMBOL(ipu_uninit_channel);
+
+int ipu_module_enable(u32 mask)
+{
+       unsigned long lock_flags;
+       u32 ipu_conf;
+
+       spin_lock_irqsave(&ipu_lock, lock_flags);
+
+       ipu_conf =3D ipu_cm_read(IPU_CONF);
+       ipu_conf |=3D mask;
+       ipu_cm_write(ipu_conf, IPU_CONF);
+
+       spin_unlock_irqrestore(&ipu_lock, lock_flags);
+
+       return 0;
+}
+
+int ipu_module_disable(u32 mask)
+{
+       unsigned long lock_flags;
+       u32 ipu_conf;
+
+       spin_lock_irqsave(&ipu_lock, lock_flags);
+
+       ipu_conf =3D ipu_cm_read(IPU_CONF);
+       ipu_conf &=3D ~mask;
+       ipu_cm_write(ipu_conf, IPU_CONF);
+
+       spin_unlock_irqrestore(&ipu_lock, lock_flags);
+
+       return 0;
+}
+
+void ipu_idmac_select_buffer(struct ipu_channel *channel, u32 buf_num)
+{
+       unsigned int chno =3D channel->num;
+
+       /* Mark buffer as ready. */
+       if (buf_num =3D=3D 0)
+               ipu_cm_write(idma_mask(chno), IPU_CHA_BUF0_RDY(chno));
+       else
+               ipu_cm_write(idma_mask(chno), IPU_CHA_BUF1_RDY(chno));
+}
+EXPORT_SYMBOL(ipu_idmac_select_buffer);
+
+int ipu_idmac_enable_channel(struct ipu_channel *channel)
+{
+       u32 val;
+       unsigned long flags;
+
+       spin_lock_irqsave(&ipu_lock, flags);
+
+       val =3D ipu_idmac_read(IDMAC_CHA_EN(channel->num));
+       val |=3D idma_mask(channel->num);
+       ipu_idmac_write(val, IDMAC_CHA_EN(channel->num));
+
+       spin_unlock_irqrestore(&ipu_lock, flags);
+
+       return 0;
+}
+EXPORT_SYMBOL(ipu_idmac_enable_channel);
+
+int ipu_idmac_disable_channel(struct ipu_channel *channel)
+{
+       u32 val;
+       unsigned long flags;
+
+       spin_lock_irqsave(&ipu_lock, flags);
+
+       /* Disable DMA channel(s) */
+       val =3D ipu_idmac_read(IDMAC_CHA_EN(channel->num));
+       val &=3D ~idma_mask(channel->num);
+       ipu_idmac_write(val, IDMAC_CHA_EN(channel->num));
+
+       /* Set channel buffers NOT to be ready */
+       ipu_cm_write(0xf0000000, IPU_GPR); /* write one to clear */
+
+       if (ipu_idma_is_set(IPU_CHA_BUF0_RDY, channel->num)) {
+               ipu_cm_write(idma_mask(channel->num),
+                            IPU_CHA_BUF0_RDY(channel->num));
+       }
+       if (ipu_idma_is_set(IPU_CHA_BUF1_RDY, channel->num)) {
+               ipu_cm_write(idma_mask(channel->num),
+                            IPU_CHA_BUF1_RDY(channel->num));
+       }
+
+       ipu_cm_write(0x0, IPU_GPR); /* write one to set */
+
+       spin_unlock_irqrestore(&ipu_lock, flags);
+
+       return 0;
+}
+EXPORT_SYMBOL(ipu_idmac_disable_channel);
+
+static LIST_HEAD(ipu_irq_handlers);
+
+static void ipu_irq_update_irq_mask(void)
+{
+       struct ipu_irq_handler *handler;
+       int i;
+
+       DECLARE_IPU_IRQ_BITMAP(irqs);
+
+       bitmap_zero(irqs, IPU_IRQ_COUNT);
+
+       list_for_each_entry(handler, &ipu_irq_handlers, list)
+               bitmap_or(irqs, irqs, handler->ipu_irqs, IPU_IRQ_COUNT);
+
+       for (i =3D 0; i < BITS_TO_LONGS(IPU_IRQ_COUNT); i++)
+               ipu_cm_write(irqs[i], IPU_INT_CTRL(i + 1));
+}
+
+int ipu_irq_add_handler(struct ipu_irq_handler *ipuirq)
+{
+       unsigned long flags;
+
+       spin_lock_irqsave(&ipu_lock, flags);
+
+       list_add_tail(&ipuirq->list, &ipu_irq_handlers);
+       ipu_irq_update_irq_mask();
+
+       spin_unlock_irqrestore(&ipu_lock, flags);
+       return 0;
+}
+EXPORT_SYMBOL(ipu_irq_add_handler);
+
+void ipu_irq_remove_handler(struct ipu_irq_handler *handler)
+{
+       unsigned long flags;
+
+       spin_lock_irqsave(&ipu_lock, flags);
+
+       list_del(&handler->list);
+       ipu_irq_update_irq_mask();
+
+       spin_unlock_irqrestore(&ipu_lock, flags);
+}
+EXPORT_SYMBOL(ipu_irq_remove_handler);
+
+int ipu_irq_update_handler(struct ipu_irq_handler *handler,
+               unsigned long *bitmap)
+{
+       unsigned long flags;
+
+       spin_lock_irqsave(&ipu_lock, flags);
+
+       bitmap_copy(handler->ipu_irqs, bitmap, IPU_IRQ_COUNT);
+       ipu_irq_update_irq_mask();
+
+       spin_unlock_irqrestore(&ipu_lock, flags);
+
+       return 0;
+}
+EXPORT_SYMBOL(ipu_irq_update_handler);
+
+static void ipu_completion_handler(unsigned long *bitmask, void *context)
+{
+       struct completion *completion =3D context;
+
+       complete(completion);
+}
+
+int ipu_wait_for_interrupt(int interrupt, int timeout_ms)
+{
+       struct ipu_irq_handler handler;
+       DECLARE_COMPLETION_ONSTACK(completion);
+       int ret;
+
+       bitmap_zero(handler.ipu_irqs, IPU_IRQ_COUNT);
+       bitmap_set(handler.ipu_irqs, interrupt, 1);
+
+       handler.handler =3D ipu_completion_handler;
+       handler.context =3D &completion;
+       ipu_irq_add_handler(&handler);
+
+       ret =3D wait_for_completion_timeout(&completion,
+                       msecs_to_jiffies(timeout_ms));
+
+       ipu_irq_remove_handler(&handler);
+
+       if (ret > 0)
+               ret =3D 0;
+
+       return ret;
+}
+EXPORT_SYMBOL(ipu_wait_for_interrupt);
+
+static irqreturn_t ipu_irq_handler(int irq, void *desc)
+{
+       DECLARE_IPU_IRQ_BITMAP(status);
+       struct ipu_irq_handler *handler;
+       int i;
+
+       for (i =3D 0; i < BITS_TO_LONGS(IPU_IRQ_COUNT); i++) {
+               status[i] =3D ipu_cm_read(IPU_INT_STAT(i + 1));
+               ipu_cm_write(status[i], IPU_INT_STAT(i + 1));
+       }
+
+       list_for_each_entry(handler, &ipu_irq_handlers, list) {
+               DECLARE_IPU_IRQ_BITMAP(tmp);
+               if (bitmap_and(tmp, status, handler->ipu_irqs, IPU_IRQ_COUN=
T))
+                       handler->handler(tmp, handler->context);
+       }
+
+       return IRQ_HANDLED;
+}
+
+ipu_color_space_t format_to_colorspace(u32 fmt)
+{
+       switch (fmt) {
+       case IPU_PIX_FMT_RGB666:
+       case IPU_PIX_FMT_RGB565:
+       case IPU_PIX_FMT_BGR24:
+       case IPU_PIX_FMT_RGB24:
+       case IPU_PIX_FMT_BGR32:
+       case IPU_PIX_FMT_BGRA32:
+       case IPU_PIX_FMT_RGB32:
+       case IPU_PIX_FMT_RGBA32:
+       case IPU_PIX_FMT_ABGR32:
+       case IPU_PIX_FMT_LVDS666:
+       case IPU_PIX_FMT_LVDS888:
+               return RGB;
+
+       default:
+               return YCbCr;
+       }
+}
+
+static int ipu_reset(void)
+{
+       int timeout =3D 10000;
+       u32 val;
+
+       /* hard reset the IPU */
+       val =3D readl(MX51_IO_ADDRESS(MX51_SRC_BASE_ADDR));
+       val |=3D 1 << 3;
+       writel(val, MX51_IO_ADDRESS(MX51_SRC_BASE_ADDR));
+
+       ipu_cm_write(0x807FFFFF, IPU_MEM_RST);
+
+       while (ipu_cm_read(IPU_MEM_RST) & 0x80000000) {
+               if (!timeout--)
+                       return -ETIME;
+               udelay(100);
+       }
+
+       return 0;
+}
+
+/*
+ * The MIPI HSC unit has been removed from the i.MX51 Reference Manual by
+ * the Freescale marketing division. However this did not remove the
+ * hardware from the chip which still needs to be configured...
+ */
+static int __devinit ipu_mipi_setup(void)
+{
+       struct clk *hsc_clk;
+       void __iomem *hsc_addr;
+       int ret =3D 0;
+
+       hsc_addr =3D ioremap(MX51_MIPI_HSC_BASE_ADDR, PAGE_SIZE);
+       if (!hsc_addr)
+               return -ENOMEM;
+
+       hsc_clk =3D clk_get_sys(NULL, "mipi_hsp");
+       if (IS_ERR(hsc_clk)) {
+               ret =3D PTR_ERR(hsc_clk);
+               goto unmap;
+       }
+       clk_enable(hsc_clk);
+
+       /* setup MIPI module to legacy mode */
+       __raw_writel(0xF00, hsc_addr);
+
+       /* CSI mode: reserved; DI control mode: legacy (from Freescale BSP)=
 */
+       __raw_writel(__raw_readl(hsc_addr + 0x800) | 0x30ff,
+               hsc_addr + 0x800);
+
+       clk_disable(hsc_clk);
+       clk_put(hsc_clk);
+unmap:
+       iounmap(hsc_addr);
+
+       return ret;
+}
+
+static int ipu_submodules_init(struct platform_device *pdev,
+               unsigned long ipu_base, struct clk *ipu_clk)
+{
+       char *unit;
+       int ret;
+
+       ret =3D ipu_di_init(pdev, 0, ipu_base + IPU_DI0_REG_BASE,
+                       IPU_CONF_DI0_EN, ipu_clk);
+       if (ret) {
+               unit =3D "di0";
+               goto err_di_0;
+       }
+
+       ret =3D ipu_di_init(pdev, 1, ipu_base + IPU_DI1_REG_BASE,
+                       IPU_CONF_DI1_EN, ipu_clk);
+       if (ret) {
+               unit =3D "di1";
+               goto err_di_1;
+       }
+
+       ret =3D ipu_dc_init(pdev, ipu_base + IPU_DC_REG_BASE,
+                       ipu_base + IPU_DC_TMPL_REG_BASE);
+       if (ret) {
+               unit =3D "dc_template";
+               goto err_dc;
+       }
+
+       ret =3D ipu_dmfc_init(pdev, ipu_base + IPU_DMFC_REG_BASE, ipu_clk);
+       if (ret) {
+               unit =3D "dmfc";
+               goto err_dmfc;
+       }
+
+       ret =3D ipu_dp_init(pdev, ipu_base + IPU_SRM_REG_BASE);
+       if (ret) {
+               unit =3D "dp";
+               goto err_dp;
+       }
+
+       ret =3D ipu_cpmem_init(pdev, ipu_base + IPU_CPMEM_REG_BASE);
+       if (ret) {
+               unit =3D "cpmem";
+               goto err_cpmem;
+       }
+
+       return 0;
+
+err_cpmem:
+       ipu_dp_exit(pdev);
+err_dp:
+       ipu_dmfc_exit(pdev);
+err_dmfc:
+       ipu_dc_exit(pdev);
+err_dc:
+       ipu_di_exit(pdev, 1);
+err_di_1:
+       ipu_di_exit(pdev, 0);
+err_di_0:
+       dev_err(&pdev->dev, "init %s failed with %d\n", unit, ret);
+       return ret;
+}
+
+static void ipu_submodules_exit(struct platform_device *pdev,
+               unsigned long ipu_base)
+{
+       ipu_cpmem_exit(pdev);
+       ipu_dp_exit(pdev);
+       ipu_dmfc_exit(pdev);
+       ipu_dc_exit(pdev);
+       ipu_di_exit(pdev, 1);
+       ipu_di_exit(pdev, 0);
+}
+
+static int ipu_add_subdevice_pdata(struct platform_device *pdev,
+               const char *name, int id, void *pdata, size_t pdata_size)
+{
+       struct mfd_cell cell =3D {
+               .platform_data =3D pdata,
+               .data_size =3D pdata_size,
+       };
+
+       cell.name<http://cell.name> =3D name;
+
+       return mfd_add_devices(&pdev->dev, id, &cell, 1, NULL, 0);
+}
+
+static int ipu_add_client_devices(struct platform_device *pdev)
+{
+       struct imx_ipuv3_platform_data *plat_data =3D pdev->dev.platform_da=
ta;
+
+       if (plat_data->fb0_platform_data) {
+               plat_data->fb0_platform_data->ipu_channel_bg =3D
+                       MX51_IPU_CHANNEL_MEM_BG_SYNC;
+               plat_data->fb0_platform_data->ipu_channel_fg =3D
+                       MX51_IPU_CHANNEL_MEM_FG_SYNC;
+               plat_data->fb0_platform_data->dc_channel =3D 5;
+               plat_data->fb0_platform_data->dp_channel =3D IPU_DP_FLOW_SY=
NC;
+
+               ipu_add_subdevice_pdata(pdev, "imx-ipuv3-fb", 0,
+                               plat_data->fb0_platform_data,
+                               sizeof(struct ipuv3_fb_platform_data));
+       }
+
+       if (plat_data->fb1_platform_data) {
+               plat_data->fb1_platform_data->ipu_channel_bg =3D
+                       MX51_IPU_CHANNEL_MEM_DC_SYNC;
+               plat_data->fb1_platform_data->ipu_channel_fg =3D -1;
+               plat_data->fb1_platform_data->dc_channel =3D 1;
+               plat_data->fb1_platform_data->dp_channel =3D -1;
+
+               ipu_add_subdevice_pdata(pdev, "imx-ipuv3-fb", 1,
+                               plat_data->fb1_platform_data,
+                               sizeof(struct ipuv3_fb_platform_data));
+       }
+
+       return 0;
+}
+
+static int __devinit ipu_probe(struct platform_device *pdev)
+{
+       struct resource *res;
+       unsigned long ipu_base;
+       int ret, irq1, irq2;
+
+       spin_lock_init(&ipu_lock);
+
+       ipu_dev =3D &pdev->dev;
+
+       irq1 =3D platform_get_irq(pdev, 0);
+       irq2 =3D platform_get_irq(pdev, 1);
+       res =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
+
+       if (!res || irq1 < 0 || irq2 < 0)
+               return -ENODEV;
+
+       ipu_base =3D res->start;
+
+       ipu_cm_reg =3D ioremap(ipu_base + IPU_CM_REG_BASE, PAGE_SIZE);
+       if (!ipu_cm_reg) {
+               ret =3D -ENOMEM;
+               goto failed_ioremap1;
+       }
+
+       ipu_idmac_reg =3D ioremap(ipu_base + IPU_IDMAC_REG_BASE, PAGE_SIZE)=
;
+       if (!ipu_idmac_reg) {
+               ret =3D -ENOMEM;
+               goto failed_ioremap2;
+       }
+
+       ret =3D ipu_mipi_setup();
+       if (ret)
+               goto failed_mipi_setup;
+
+       ipu_clk =3D clk_get(&pdev->dev, "ipu");
+       if (IS_ERR(ipu_clk)) {
+               ret =3D PTR_ERR(ipu_clk);
+               dev_err(&pdev->dev, "clk_get failed with %d", ret);
+               goto failed_clk_get;
+       }
+
+       clk_enable(ipu_clk);
+
+       ret =3D request_irq(irq1, ipu_irq_handler, IRQF_DISABLED, pdev->nam=
e,
+                       &pdev->dev);
+       if (ret) {
+               dev_err(&pdev->dev, "request irq %d failed with: %d\n", irq=
1, ret);
+               goto failed_request_irq1;
+       }
+
+       ret =3D request_irq(irq2, ipu_irq_handler, IRQF_DISABLED, pdev->nam=
e,
+                       &pdev->dev);
+       if (ret) {
+               dev_err(&pdev->dev, "request irq %d failed with: %d\n", irq=
2, ret);
+               goto failed_request_irq2;
+       }
+
+       ipu_reset();
+
+       ret =3D ipu_submodules_init(pdev, ipu_base, ipu_clk);
+       if (ret)
+               goto failed_submodules_init;
+
+       /* Set sync refresh channels as high priority */
+       ipu_idmac_write(0x18800000, IDMAC_CHA_PRI(0));
+
+       ret =3D ipu_add_client_devices(pdev);
+        if (ret) {
+                dev_err(&pdev->dev, "adding client devices failed with %d\=
n", ret);
+               goto failed_add_clients;
+        }
+
[Jason] add clk_disable(ipu_clk)

+       return 0;
+
+failed_add_clients:
+       ipu_submodules_exit(pdev, ipu_base);
+failed_submodules_init:
+       free_irq(irq2, &pdev->dev);
+failed_request_irq2:
+       free_irq(irq1, &pdev->dev);
+failed_request_irq1:
+       clk_put(ipu_clk);
+failed_clk_get:
+failed_mipi_setup:
+       iounmap(ipu_idmac_reg);
+failed_ioremap2:
+       iounmap(ipu_cm_reg);
+failed_ioremap1:
+
+       return ret;
+}
+
+static int __devexit ipu_remove(struct platform_device *pdev)
+{
+       struct resource *res;
+       unsigned long ipu_base;
+       int irq1, irq2;
+
+       irq1 =3D platform_get_irq(pdev, 0);
+       irq2 =3D platform_get_irq(pdev, 1);
+       res =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
+       ipu_base =3D res->start;
+
+       mfd_remove_devices(&pdev->dev);
+       ipu_submodules_exit(pdev, ipu_base);
+       free_irq(irq2, &pdev->dev);
+       free_irq(irq1, &pdev->dev);
+       clk_disable(ipu_clk);
+       clk_put(ipu_clk);
+       iounmap(ipu_idmac_reg);
+       iounmap(ipu_cm_reg);
+
+       return 0;
+}
+
+static struct platform_driver mxcipu_driver =3D {
+       .driver =3D {
+               .name =3D "imx-ipuv3",
+       },
+       .probe =3D ipu_probe,
+       .remove =3D __devexit_p(ipu_remove),
+};
+
+static int __init ipu_gen_init(void)
+{
+       int32_t ret;
+
+       ret =3D platform_driver_register(&mxcipu_driver);
+       return 0;
+}
+subsys_initcall(ipu_gen_init);
+
+static void __exit ipu_gen_uninit(void)
+{
+       platform_driver_unregister(&mxcipu_driver);
+}
+module_exit(ipu_gen_uninit);
+
+MODULE_DESCRIPTION("i.MX IPU v3 driver");
+MODULE_AUTHOR("Sascha Hauer <s.hauer@pengutronix.de<mailto:s.hauer@pengutr=
onix.de>>");
+MODULE_LICENSE("GPL");
diff --git a/drivers/mfd/imx-ipu-v3/ipu-cpmem.c b/drivers/mfd/imx-ipu-v3/ip=
u-cpmem.c
new file mode 100644
index 0000000..587b487
--- /dev/null
+++ b/drivers/mfd/imx-ipu-v3/ipu-cpmem.c
@@ -0,0 +1,608 @@
+/*
+ * Copyright (c) 2010 Sascha Hauer <s.hauer@pengutronix.de<mailto:s.hauer@=
pengutronix.de>>
+ * Copyright (C) 2005-2009 Freescale Semiconductor, Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the
+ * Free Software Foundation; either version 2 of the License, or (at your
+ * option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABIL=
ITY
+ * or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public Licens=
e
+ * for more details.
+ */
+
+#include <linux/kernel.h>
+#include <linux/device.h>
+#include <linux/mfd/imx-ipu-v3.h>
+#include <linux/types.h>
+#include <linux/bitrev.h>
+#include <linux/io.h>
+
+#include "ipu-prv.h"
+
+#define __F(word, ofs, size) ((((word) * 160 + (ofs)) << 8) | (size))
+
+#define IPU_FIELD_XV           __F(0, 0, 10)
+#define IPU_FIELD_YV           __F(0, 10, 9)
+#define IPU_FIELD_XB           __F(0, 19, 13)
+#define IPU_FIELD_YB           __F(0, 32, 12)
+#define IPU_FIELD_NSB_B                __F(0, 44, 1)
+#define IPU_FIELD_CF           __F(0, 45, 1)
+#define IPU_FIELD_UBO          __F(0, 46, 22)
+#define IPU_FIELD_VBO          __F(0, 68, 22)
+#define IPU_FIELD_IOX          __F(0, 90, 4)
+#define IPU_FIELD_RDRW         __F(0, 94, 1)
+#define IPU_FIELD_SO           __F(0, 113, 1)
+#define IPU_FIELD_BNDM         __F(0, 114, 3)
+#define IPU_FIELD_BM           __F(0, 117, 2)
+#define IPU_FIELD_ROT          __F(0, 119, 1)
+#define IPU_FIELD_HF           __F(0, 120, 1)
+#define IPU_FIELD_VF           __F(0, 121, 1)
+#define IPU_FIELD_THE          __F(0, 122, 1)
+#define IPU_FIELD_CAP          __F(0, 123, 1)
+#define IPU_FIELD_CAE          __F(0, 124, 1)
+#define IPU_FIELD_FW           __F(0, 125, 13)
+#define IPU_FIELD_FH           __F(0, 138, 12)
+#define IPU_FIELD_EBA0         __F(1, 0, 29)
+#define IPU_FIELD_EBA1         __F(1, 29, 29)
+#define IPU_FIELD_ILO          __F(1, 58, 20)
+#define IPU_FIELD_NPB          __F(1, 78, 7)
+#define IPU_FIELD_PFS          __F(1, 85, 4)
+#define IPU_FIELD_ALU          __F(1, 89, 1)
+#define IPU_FIELD_ALBM         __F(1, 90, 3)
+#define IPU_FIELD_ID           __F(1, 93, 2)
+#define IPU_FIELD_TH           __F(1, 95, 7)
+#define IPU_FIELD_SLY          __F(1, 102, 14)
+#define IPU_FIELD_WID3         __F(1, 125, 3)
+#define IPU_FIELD_SLUV         __F(1, 128, 14)
+#define IPU_FIELD_CRE          __F(1, 149, 1)
+
+#define IPU_FIELD_XV           __F(0, 0, 10)
+#define IPU_FIELD_YV           __F(0, 10, 9)
+#define IPU_FIELD_XB           __F(0, 19, 13)
+#define IPU_FIELD_YB           __F(0, 32, 12)
+#define IPU_FIELD_NSB_B                __F(0, 44, 1)
+#define IPU_FIELD_CF           __F(0, 45, 1)
+#define IPU_FIELD_SX           __F(0, 46, 12)
+#define IPU_FIELD_SY           __F(0, 58, 11)
+#define IPU_FIELD_NS           __F(0, 69, 10)
+#define IPU_FIELD_SDX          __F(0, 79, 7)
+#define IPU_FIELD_SM           __F(0, 86, 10)
+#define IPU_FIELD_SCC          __F(0, 96, 1)
+#define IPU_FIELD_SCE          __F(0, 97, 1)
+#define IPU_FIELD_SDY          __F(0, 98, 7)
+#define IPU_FIELD_SDRX         __F(0, 105, 1)
+#define IPU_FIELD_SDRY         __F(0, 106, 1)
+#define IPU_FIELD_BPP          __F(0, 107, 3)
+#define IPU_FIELD_DEC_SEL      __F(0, 110, 2)
+#define IPU_FIELD_DIM          __F(0, 112, 1)
+#define IPU_FIELD_SO           __F(0, 113, 1)
+#define IPU_FIELD_BNDM         __F(0, 114, 3)
+#define IPU_FIELD_BM           __F(0, 117, 2)
+#define IPU_FIELD_ROT          __F(0, 119, 1)
+#define IPU_FIELD_HF           __F(0, 120, 1)
+#define IPU_FIELD_VF           __F(0, 121, 1)
+#define IPU_FIELD_THE          __F(0, 122, 1)
+#define IPU_FIELD_CAP          __F(0, 123, 1)
+#define IPU_FIELD_CAE          __F(0, 124, 1)
+#define IPU_FIELD_FW           __F(0, 125, 13)
+#define IPU_FIELD_FH           __F(0, 138, 12)
+#define IPU_FIELD_EBA0         __F(1, 0, 29)
+#define IPU_FIELD_EBA1         __F(1, 29, 29)
+#define IPU_FIELD_ILO          __F(1, 58, 20)
+#define IPU_FIELD_NPB          __F(1, 78, 7)
+#define IPU_FIELD_PFS          __F(1, 85, 4)
+#define IPU_FIELD_ALU          __F(1, 89, 1)
+#define IPU_FIELD_ALBM         __F(1, 90, 3)
+#define IPU_FIELD_ID           __F(1, 93, 2)
+#define IPU_FIELD_TH           __F(1, 95, 7)
+#define IPU_FIELD_SL           __F(1, 102, 14)
+#define IPU_FIELD_WID0         __F(1, 116, 3)
+#define IPU_FIELD_WID1         __F(1, 119, 3)
+#define IPU_FIELD_WID2         __F(1, 122, 3)
+#define IPU_FIELD_WID3         __F(1, 125, 3)
+#define IPU_FIELD_OFS0         __F(1, 128, 5)
+#define IPU_FIELD_OFS1         __F(1, 133, 5)
+#define IPU_FIELD_OFS2         __F(1, 138, 5)
+#define IPU_FIELD_OFS3         __F(1, 143, 5)
+#define IPU_FIELD_SXYS         __F(1, 148, 1)
+#define IPU_FIELD_CRE          __F(1, 149, 1)
+#define IPU_FIELD_DEC_SEL2     __F(1, 150, 1)
+
+static u32 *ipu_cpmem_base;
+static struct device *ipu_dev;
+
+struct ipu_ch_param_word {
+       u32 data[5];
+       u32 res[3];
+};
+
+struct ipu_ch_param {
+       struct ipu_ch_param_word word[2];
+};
+
+static u32 ipu_bytes_per_pixel(u32 fmt)
+{
+       switch (fmt) {
+       case IPU_PIX_FMT_GENERIC:       /* generic data */
+       case IPU_PIX_FMT_RGB332:
+       case IPU_PIX_FMT_YUV420P:
+       case IPU_PIX_FMT_YUV422P:
+               return 1;
+
+       case IPU_PIX_FMT_RGB565:
+       case IPU_PIX_FMT_YUYV:
+       case IPU_PIX_FMT_UYVY:
+               return 2;
+
+       case IPU_PIX_FMT_BGR24:
+       case IPU_PIX_FMT_RGB24:
+               return 3;
+
+       case IPU_PIX_FMT_GENERIC_32:    /* generic data */
+       case IPU_PIX_FMT_BGR32:
+       case IPU_PIX_FMT_BGRA32:
+       case IPU_PIX_FMT_RGB32:
+       case IPU_PIX_FMT_RGBA32:
+       case IPU_PIX_FMT_ABGR32:
+               return 4;
+
+       default:
+               return 1;
+       }
+}
+
+bool ipu_pixel_format_has_alpha(u32 fmt)
+{
+       switch (fmt) {
+       case IPU_PIX_FMT_RGBA32:
+       case IPU_PIX_FMT_BGRA32:
+       case IPU_PIX_FMT_ABGR32:
+               return true;
+
+       default:
+               return false;
+       }
+}
+
+#define ipu_ch_param_addr(ch) (((struct ipu_ch_param *)ipu_cpmem_base) + (=
ch))
+
+static inline void ipu_ch_param_set_field(struct ipu_ch_param *base, u32 w=
bs, u32 v)
+{
+       u32 bit =3D (wbs >> 8) % 160;
+       u32 size =3D wbs & 0xff;
+       u32 word =3D (wbs >> 8) / 160;
+       u32 i =3D bit / 32;
+       u32 ofs =3D bit % 32;
+       u32 mask =3D (1 << size) - 1;
+
+       pr_debug("%s %d %d %d\n", __func__, word, bit , size);
+
+       base->word[word].data[i] &=3D ~(mask << ofs);
+       base->word[word].data[i] |=3D v << ofs;
+
+       if ((bit + size - 1) / 32 > i) {
+               base->word[word].data[i + 1] &=3D ~(v >> (mask ? (32 - ofs)=
 : 0));
+               base->word[word].data[i + 1] |=3D v >> (ofs ? (32 - ofs) : =
0);
+       }
+}
+
+static inline u32 ipu_ch_param_read_field(struct ipu_ch_param *base, u32 w=
bs)
+{
+       u32 bit =3D (wbs >> 8) % 160;
+       u32 size =3D wbs & 0xff;
+       u32 word =3D (wbs >> 8) / 160;
+       u32 i =3D bit / 32;
+       u32 ofs =3D bit % 32;
+       u32 mask =3D (1 << size) - 1;
+       u32 val =3D 0;
+
+       pr_debug("%s %d %d %d\n", __func__, word, bit , size);
+
+       val =3D (base->word[word].data[i] >> ofs) & mask;
+
+       if ((bit + size - 1) / 32 > i) {
+               u32 tmp;
+               tmp =3D base->word[word].data[i + 1];
+               tmp &=3D mask >> (ofs ? (32 - ofs) : 0);
+               val |=3D tmp << (ofs ? (32 - ofs) : 0);
+       }
+
+       return val;
+}
+
+static inline void ipu_ch_params_set_packing(struct ipu_ch_param *p,
+                                             int red_width, int red_offset=
,
+                                             int green_width, int green_of=
fset,
+                                             int blue_width, int blue_offs=
et,
+                                             int alpha_width, int alpha_of=
fset)
+{
+       /* Setup red width and offset */
+       ipu_ch_param_set_field(p, IPU_FIELD_WID0, red_width - 1);
+       ipu_ch_param_set_field(p, IPU_FIELD_OFS0, red_offset);
+       /* Setup green width and offset */
+       ipu_ch_param_set_field(p, IPU_FIELD_WID1, green_width - 1);
+       ipu_ch_param_set_field(p, IPU_FIELD_OFS1, green_offset);
+       /* Setup blue width and offset */
+       ipu_ch_param_set_field(p, IPU_FIELD_WID2, blue_width - 1);
+       ipu_ch_param_set_field(p, IPU_FIELD_OFS2, blue_offset);
+       /* Setup alpha width and offset */
+       ipu_ch_param_set_field(p, IPU_FIELD_WID3, alpha_width - 1);
+       ipu_ch_param_set_field(p, IPU_FIELD_OFS3, alpha_offset);
+}
+
+static inline void ipu_ch_param_dump(int ch)
+{
+       struct ipu_ch_param *p =3D ipu_ch_param_addr(ch);
+       pr_debug("ch %d word 0 - %08X %08X %08X %08X %08X\n", ch,
+                p->word[0].data[0], p->word[0].data[1], p->word[0].data[2]=
,
+                p->word[0].data[3], p->word[0].data[4]);
+       pr_debug("ch %d word 1 - %08X %08X %08X %08X %08X\n", ch,
+                p->word[1].data[0], p->word[1].data[1], p->word[1].data[2]=
,
+                p->word[1].data[3], p->word[1].data[4]);
+       pr_debug("PFS 0x%x\n", ipu_ch_param_read_field(p, IPU_FIELD_PFS));
+       pr_debug("BPP 0x%x\n", ipu_ch_param_read_field(p, IPU_FIELD_BPP));
+       pr_debug("NPB 0x%x\n", ipu_ch_param_read_field(p, IPU_FIELD_NPB));
+
+       pr_debug("FW %d\n", ipu_ch_param_read_field(p, IPU_FIELD_FW));
+       pr_debug("FH %d\n", ipu_ch_param_read_field(p, IPU_FIELD_FH));
+       pr_debug("Stride %d\n", ipu_ch_param_read_field(p, IPU_FIELD_SL));
+
+       pr_debug("Width0 %d+1\n", ipu_ch_param_read_field(p, IPU_FIELD_WID0=
));
+       pr_debug("Width1 %d+1\n", ipu_ch_param_read_field(p, IPU_FIELD_WID1=
));
+       pr_debug("Width2 %d+1\n", ipu_ch_param_read_field(p, IPU_FIELD_WID2=
));
+       pr_debug("Width3 %d+1\n", ipu_ch_param_read_field(p, IPU_FIELD_WID3=
));
+       pr_debug("Offset0 %d\n", ipu_ch_param_read_field(p, IPU_FIELD_OFS0)=
);
+       pr_debug("Offset1 %d\n", ipu_ch_param_read_field(p, IPU_FIELD_OFS1)=
);
+       pr_debug("Offset2 %d\n", ipu_ch_param_read_field(p, IPU_FIELD_OFS2)=
);
+       pr_debug("Offset3 %d\n", ipu_ch_param_read_field(p, IPU_FIELD_OFS3)=
);
+}
+
+static inline void ipu_ch_param_set_burst_size(u32 ch,
+                                               u16 burst_pixels)
+{
+       ipu_ch_param_set_field(ipu_ch_param_addr(ch), IPU_FIELD_NPB,
+                              burst_pixels - 1);
+};
+
+static inline int ipu_ch_param_get_burst_size(u32 ch)
+{
+       return ipu_ch_param_read_field(ipu_ch_param_addr(ch), IPU_FIELD_NPB=
) + 1;
+};
+
+static inline int ipu_ch_param_get_bpp(u32 ch)
+{
+       return ipu_ch_param_read_field(ipu_ch_param_addr(ch), IPU_FIELD_BPP=
);
+};
+
+static inline void ipu_ch_param_set_buffer(u32 ch, int bufNum,
+                                           dma_addr_t phyaddr)
+{
+       ipu_ch_param_set_field(ipu_ch_param_addr(ch),
+                       bufNum ? IPU_FIELD_EBA1 : IPU_FIELD_EBA0,
+                       phyaddr / 8);
+};
+
+#define IPU_FIELD_ROT_HF_VF            __F(0, 119, 3)
+
+static inline void ipu_ch_param_set_rotation(u32 ch,
+                                             ipu_rotate_mode_t rot)
+{
+       u32 temp_rot =3D bitrev8(rot) >> 5;
+       ipu_ch_param_set_field(ipu_ch_param_addr(ch), IPU_FIELD_ROT_HF_VF, =
temp_rot);
+};
+
+static inline void ipu_ch_param_set_block_mode(u32 ch)
+{
+       ipu_ch_param_set_field(ipu_ch_param_addr(ch), IPU_FIELD_BM, 1);
+};
+
+static inline void ipu_ch_param_set_alpha_use_separate_channel(u32 ch,
+               bool option)
+{
+       if (option)
+               ipu_ch_param_set_field(ipu_ch_param_addr(ch), IPU_FIELD_ALU=
, 1);
+       else
+               ipu_ch_param_set_field(ipu_ch_param_addr(ch), IPU_FIELD_ALU=
, 0);
+};
+
+static inline void ipu_ch_param_set_alpha_condition_read(u32 ch)
+{
+       ipu_ch_param_set_field(ipu_ch_param_addr(ch), IPU_FIELD_CRE, 1);
+};
+
+static inline void ipu_ch_param_set_alpha_buffer_memory(u32 ch)
+{
+       int alp_mem_idx;
+
+       switch (ch) {
+       case 14: /* PRP graphic */
+               alp_mem_idx =3D 0;
+               break;
+       case 15: /* PP graphic */
+               alp_mem_idx =3D 1;
+               break;
+       case 23: /* DP BG SYNC graphic */
+               alp_mem_idx =3D 4;
+               break;
+       case 27: /* DP FG SYNC graphic */
+               alp_mem_idx =3D 2;
+               break;
+       default:
+               dev_err(ipu_dev, "unsupported correlated channel of local a=
lpha channel\n");
+               return;
+       }
+
+       ipu_ch_param_set_field(ipu_ch_param_addr(ch), IPU_FIELD_ALBM, alp_m=
em_idx);
+};
+
+static inline void ipu_ch_param_set_interlaced_scan(u32 ch)
+{
+       u32 stride;
+       ipu_ch_param_set_field(ipu_ch_param_addr(ch), IPU_FIELD_SO, 1);
+       stride =3D ipu_ch_param_read_field(ipu_ch_param_addr(ch), IPU_FIELD=
_SL) + 1;
+       ipu_ch_param_set_field(ipu_ch_param_addr(ch), IPU_FIELD_ILO, stride=
 / 8);
+       stride *=3D 2;
+       ipu_ch_param_set_field(ipu_ch_param_addr(ch), IPU_FIELD_SLY, stride=
 - 1);
+};
+
+static inline void ipu_ch_param_set_high_priority(u32 ch)
+{
+       ipu_ch_param_set_field(ipu_ch_param_addr(ch), IPU_FIELD_ID, 1);
+};
+
+static inline void ipu_ch_params_set_alpha_width(u32 ch, int alpha_width)
+{
+       ipu_ch_param_set_field(ipu_ch_param_addr(ch), IPU_FIELD_WID3,
+                       alpha_width - 1);
+}
+
+static int ipu_ch_param_init(int ch,
+                       u32 pixel_fmt, u32 width,
+                       u32 height, u32 stride,
+                       u32 u, u32 v,
+                       u32 uv_stride, dma_addr_t addr0,
+                       dma_addr_t addr1)
+{
+       u32 u_offset =3D 0;
+       u32 v_offset =3D 0;
+       struct ipu_ch_param params;
+
+       memset(&params, 0, sizeof(params));
+
+       ipu_ch_param_set_field(&params, IPU_FIELD_FW, width - 1);
+       ipu_ch_param_set_field(&params, IPU_FIELD_FH, height - 1);
+       ipu_ch_param_set_field(&params, IPU_FIELD_SLY, stride - 1);
+       ipu_ch_param_set_field(&params, IPU_FIELD_EBA0, addr0 >> 3);
+       ipu_ch_param_set_field(&params, IPU_FIELD_EBA1, addr1 >> 3);
+
+       switch (pixel_fmt) {
+       case IPU_PIX_FMT_GENERIC:
+               /* Represents 8-bit Generic data */
+               ipu_ch_param_set_field(&params, IPU_FIELD_BPP, 5);      /* =
bits/pixel */
+               ipu_ch_param_set_field(&params, IPU_FIELD_PFS, 6);      /* =
pix format */
+               ipu_ch_param_set_field(&params, IPU_FIELD_NPB, 63);     /* =
burst size */
+
+               break;
+       case IPU_PIX_FMT_GENERIC_32:
+               /* Represents 32-bit Generic data */
+               break;
+       case IPU_PIX_FMT_RGB565:
+               ipu_ch_param_set_field(&params, IPU_FIELD_BPP, 3);      /* =
bits/pixel */
+               ipu_ch_param_set_field(&params, IPU_FIELD_PFS, 7);      /* =
pix format */
+               ipu_ch_param_set_field(&params, IPU_FIELD_NPB, 15);     /* =
burst size */
+
+               ipu_ch_params_set_packing(&params, 5, 0, 6, 5, 5, 11, 8, 16=
);
+               break;
+       case IPU_PIX_FMT_BGR24:
+               ipu_ch_param_set_field(&params, IPU_FIELD_BPP, 1);      /* =
bits/pixel */
+               ipu_ch_param_set_field(&params, IPU_FIELD_PFS, 7);      /* =
pix format */
+               ipu_ch_param_set_field(&params, IPU_FIELD_NPB, 19);     /* =
burst size */
+
+               ipu_ch_params_set_packing(&params, 8, 0, 8, 8, 8, 16, 8, 24=
);
+               break;
+       case IPU_PIX_FMT_RGB24:
+       case IPU_PIX_FMT_YUV444:
+               ipu_ch_param_set_field(&params, IPU_FIELD_BPP, 1);      /* =
bits/pixel */
+               ipu_ch_param_set_field(&params, IPU_FIELD_PFS, 7);      /* =
pix format */
+               ipu_ch_param_set_field(&params, IPU_FIELD_NPB, 19);     /* =
burst size */
+
+               ipu_ch_params_set_packing(&params, 8, 16, 8, 8, 8, 0, 8, 24=
);
+               break;
+       case IPU_PIX_FMT_BGRA32:
+       case IPU_PIX_FMT_BGR32:
+               ipu_ch_param_set_field(&params, IPU_FIELD_BPP, 0);      /* =
bits/pixel */
+               ipu_ch_param_set_field(&params, IPU_FIELD_PFS, 7);      /* =
pix format */
+               ipu_ch_param_set_field(&params, IPU_FIELD_NPB, 15);     /* =
burst size */
+
+               ipu_ch_params_set_packing(&params, 8, 8, 8, 16, 8, 24, 8, 0=
);
+               break;
+       case IPU_PIX_FMT_RGBA32:
+       case IPU_PIX_FMT_RGB32:
+               ipu_ch_param_set_field(&params, IPU_FIELD_BPP, 0);      /* =
bits/pixel */
+               ipu_ch_param_set_field(&params, IPU_FIELD_PFS, 7);      /* =
pix format */
+               ipu_ch_param_set_field(&params, IPU_FIELD_NPB, 15);     /* =
burst size */
+
+               ipu_ch_params_set_packing(&params, 8, 24, 8, 16, 8, 8, 8, 0=
);
+               break;
+       case IPU_PIX_FMT_ABGR32:
+               ipu_ch_param_set_field(&params, IPU_FIELD_BPP, 0);      /* =
bits/pixel */
+               ipu_ch_param_set_field(&params, IPU_FIELD_PFS, 7);      /* =
pix format */
+
+               ipu_ch_params_set_packing(&params, 8, 0, 8, 8, 8, 16, 8, 24=
);
+               break;
+       case IPU_PIX_FMT_UYVY:
+               ipu_ch_param_set_field(&params, IPU_FIELD_BPP, 3);      /* =
bits/pixel */
+               ipu_ch_param_set_field(&params, IPU_FIELD_PFS, 0xA);    /* =
pix format */
+               ipu_ch_param_set_field(&params, IPU_FIELD_NPB, 15);     /* =
burst size */
+               break;
+       case IPU_PIX_FMT_YUYV:
+               ipu_ch_param_set_field(&params, IPU_FIELD_BPP, 3);      /* =
bits/pixel */
+               ipu_ch_param_set_field(&params, IPU_FIELD_PFS, 0x8);    /* =
pix format */
+               ipu_ch_param_set_field(&params, IPU_FIELD_NPB, 31);     /* =
burst size */
+               break;
+       case IPU_PIX_FMT_YUV420P2:
+       case IPU_PIX_FMT_YUV420P:
+               ipu_ch_param_set_field(&params, IPU_FIELD_PFS, 2);      /* =
pix format */
+
+               if (uv_stride < stride / 2)
+                       uv_stride =3D stride / 2;
+
+               u_offset =3D stride * height;
+               v_offset =3D u_offset + (uv_stride * height / 2);
+               ipu_ch_param_set_field(&params, IPU_FIELD_NPB, 31);  /* bur=
st size */
+               break;
+       case IPU_PIX_FMT_YVU422P:
+               /* BPP & pixel format */
+               ipu_ch_param_set_field(&params, IPU_FIELD_PFS, 1);      /* =
pix format */
+               ipu_ch_param_set_field(&params, IPU_FIELD_NPB, 31);     /* =
burst size */
+
+               if (uv_stride < stride / 2)
+                       uv_stride =3D stride / 2;
+
+               v_offset =3D (v =3D=3D 0) ? stride * height : v;
+               u_offset =3D (u =3D=3D 0) ? v_offset + v_offset / 2 : u;
+               break;
+       case IPU_PIX_FMT_YUV422P:
+               /* BPP & pixel format */
+               ipu_ch_param_set_field(&params, IPU_FIELD_PFS, 1);      /* =
pix format */
+               ipu_ch_param_set_field(&params, IPU_FIELD_NPB, 31);     /* =
burst size */
+
+               if (uv_stride < stride / 2)
+                       uv_stride =3D stride / 2;
+
+               u_offset =3D (u =3D=3D 0) ? stride * height : u;
+               v_offset =3D (v =3D=3D 0) ? u_offset + u_offset / 2 : v;
+               break;
+       case IPU_PIX_FMT_NV12:
+               /* BPP & pixel format */
+               ipu_ch_param_set_field(&params, IPU_FIELD_PFS, 4);      /* =
pix format */
+               ipu_ch_param_set_field(&params, IPU_FIELD_NPB, 31);     /* =
burst size */
+               uv_stride =3D stride;
+               u_offset =3D (u =3D=3D 0) ? stride * height : u;
+               break;
+       default:
+               dev_err(ipu_dev, "mxc ipu: unimplemented pixel format: %d\n=
",
+                       pixel_fmt);
+               return -EINVAL;
+       }
+       /* set burst size to 16 */
+       if (uv_stride)
+               ipu_ch_param_set_field(&params, IPU_FIELD_SLUV, uv_stride -=
 1);
+
+       if (u > u_offset)
+               u_offset =3D u;
+
+       if (v > v_offset)
+               v_offset =3D v;
+
+       ipu_ch_param_set_field(&params, IPU_FIELD_UBO, u_offset / 8);
+       ipu_ch_param_set_field(&params, IPU_FIELD_VBO, v_offset / 8);
+
+       pr_debug("initializing idma ch %d @ %p\n", ch, ipu_ch_param_addr(ch=
));
+       memcpy(ipu_ch_param_addr(ch), &params, sizeof(params));
+       return 0;
+}
+
+/*
+ * This function is called to initialize a buffer for a IPU channel.
+ *
+ * @param       channel         The IPU channel.
+ *
+ * @param       pixel_fmt       Input parameter for pixel format of buffer=
.
+ *                              Pixel format is a FOURCC ASCII code.
+ *
+ * @param       width           Input parameter for width of buffer in pix=
els.
+ *
+ * @param       height          Input parameter for height of buffer in pi=
xels.
+ *
+ * @param       stride          Input parameter for stride length of buffe=
r
+ *                              in pixels.
+ *
+ * @param       rot_mode        Input parameter for rotation setting of bu=
ffer.
+ *                              A rotation setting other than
+ *                              IPU_ROTATE_VERT_FLIP
+ *                              should only be used for input buffers of
+ *                              rotation channels.
+ *
+ * @param       phyaddr_0       Input parameter buffer 0 physical address.
+ *
+ * @param       phyaddr_1       Input parameter buffer 1 physical address.
+ *                              Setting this to a value other than NULL en=
ables
+ *                              double buffering mode.
+ *
+ * @param       u              private u offset for additional cropping,
+ *                             zero if not used.
+ *
+ * @param       v              private v offset for additional cropping,
+ *                             zero if not used.
+ *
+ * @return      Returns 0 on success or negative error code on fail
+ */
+int ipu_idmac_init_channel_buffer(struct ipu_channel *channel,
+                               u32 pixel_fmt,
+                               u16 width, u16 height,
+                               u32 stride,
+                               ipu_rotate_mode_t rot_mode,
+                               dma_addr_t phyaddr_0, dma_addr_t phyaddr_1,
+                               u32 u, u32 v, bool interlaced)
+{
+       int ret;
+       u32 dma_chan =3D channel->num;
+
+       if (stride < width * ipu_bytes_per_pixel(pixel_fmt))
+               stride =3D width * ipu_bytes_per_pixel(pixel_fmt);
+
+       if (stride % 4) {
+               dev_err(ipu_dev,
+                       "Stride not 32-bit aligned, stride =3D %d\n", strid=
e);
+               return -EINVAL;
+       }
+
+       /* Build parameter memory data for DMA channel */
+       ret =3D ipu_ch_param_init(dma_chan, pixel_fmt, width, height, strid=
e, u, v, 0,
+                          phyaddr_0, phyaddr_1);
+       if (ret)
+               return ret;
+
+       if (rot_mode)
+               ipu_ch_param_set_rotation(dma_chan, rot_mode);
+
+       if (interlaced)
+               ipu_ch_param_set_interlaced_scan(dma_chan);
+
+       if (idmac_idma_is_set(IDMAC_CHA_PRI, dma_chan))
+               ipu_ch_param_set_high_priority(dma_chan);
+
+       ipu_ch_param_dump(dma_chan);
+
+       return 0;
+}
+EXPORT_SYMBOL(ipu_idmac_init_channel_buffer);
+
+int ipu_idmac_update_channel_buffer(struct ipu_channel *channel,
+                                 u32 buf_num, dma_addr_t phyaddr)
+{
+       u32 dma_chan =3D channel->num;
+
+       ipu_ch_param_set_buffer(dma_chan, buf_num, phyaddr);
+
+       return 0;
+}
+EXPORT_SYMBOL(ipu_idmac_update_channel_buffer);
+
+int ipu_cpmem_init(struct platform_device *pdev, unsigned long base)
+{
+       ipu_cpmem_base =3D ioremap(base, PAGE_SIZE);
+       if (!ipu_cpmem_base)
+               return -ENOMEM;
+       ipu_dev =3D &pdev->dev;
+       return 0;
+}
+
+void ipu_cpmem_exit(struct platform_device *pdev)
+{
+       iounmap(ipu_cpmem_base);
+}
diff --git a/drivers/mfd/imx-ipu-v3/ipu-dc.c b/drivers/mfd/imx-ipu-v3/ipu-d=
c.c
new file mode 100644
index 0000000..23ba5d7
--- /dev/null
+++ b/drivers/mfd/imx-ipu-v3/ipu-dc.c
@@ -0,0 +1,362 @@
+/*
+ * Copyright (c) 2010 Sascha Hauer <s.hauer@pengutronix.de<mailto:s.hauer@=
pengutronix.de>>
+ * Copyright (C) 2005-2009 Freescale Semiconductor, Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the
+ * Free Software Foundation; either version 2 of the License, or (at your
+ * option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABIL=
ITY
+ * or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public Licens=
e
+ * for more details.
+ */
+
+#include <linux/types.h>
+#include <linux/errno.h>
+#include <linux/delay.h>
+#include <linux/spinlock.h>
+#include <linux/io.h>
+#include <linux/mfd/imx-ipu-v3.h>
+#include <asm/atomic.h>
+
+#include "ipu-prv.h"
+
+#define ASYNC_SER_WAVE 6
+
+#define DC_DISP_ID_SERIAL      2
+#define DC_DISP_ID_ASYNC       3
+
+#define DC_MAP_CONF_PTR(n)     (ipu_dc_reg + 0x0108 + ((n) & ~0x1) * 2)
+#define DC_MAP_CONF_VAL(n)     (ipu_dc_reg + 0x0144 + ((n) & ~0x1) * 2)
+
+#define DC_EVT_NF              0
+#define DC_EVT_NL              1
+#define DC_EVT_EOF             2
+#define DC_EVT_NFIELD          3
+#define DC_EVT_EOL             4
+#define DC_EVT_EOFIELD         5
+#define DC_EVT_NEW_ADDR                6
+#define DC_EVT_NEW_CHAN                7
+#define DC_EVT_NEW_DATA                8
+
+#define DC_EVT_NEW_ADDR_W_0    0
+#define DC_EVT_NEW_ADDR_W_1    1
+#define DC_EVT_NEW_CHAN_W_0    2
+#define DC_EVT_NEW_CHAN_W_1    3
+#define DC_EVT_NEW_DATA_W_0    4
+#define DC_EVT_NEW_DATA_W_1    5
+#define DC_EVT_NEW_ADDR_R_0    6
+#define DC_EVT_NEW_ADDR_R_1    7
+#define DC_EVT_NEW_CHAN_R_0    8
+#define DC_EVT_NEW_CHAN_R_1    9
+#define DC_EVT_NEW_DATA_R_0    10
+#define DC_EVT_NEW_DATA_R_1    11
+
+#define DC_WR_CH_CONF(ch)      (ipu_dc_reg + dc_channels[ch].channel_offse=
t)
+#define DC_WR_CH_ADDR(ch)      (ipu_dc_reg + dc_channels[ch].channel_offse=
t + 4)
+#define DC_RL_CH(ch, evt)      (ipu_dc_reg + dc_channels[ch].channel_offse=
t + 8 + ((evt) & ~0x1) * 2)
+
+#define DC_GEN                 (ipu_dc_reg + 0x00D4)
+#define DC_DISP_CONF1(disp)    (ipu_dc_reg + 0x00D8 + disp * 4)
+#define DC_DISP_CONF2(disp)    (ipu_dc_reg + 0x00E8 + disp * 4)
+#define DC_STAT                        (ipu_dc_reg + 0x01C8)
+
+#define WROD(lf)               (0x18 | (lf << 1))
+
+#define DC_WR_CH_CONF_FIELD_MODE               (1 << 9)
+#define DC_WR_CH_CONF_PROG_TYPE_OFFSET         5
+#define DC_WR_CH_CONF_PROG_TYPE_MASK           (7 << 5)
+#define DC_WR_CH_CONF_PROG_DI_ID               (1 << 2)
+#define DC_WR_CH_CONF_PROG_DISP_ID_OFFSET      3
+#define DC_WR_CH_CONF_PROG_DISP_ID_MASK                (3 << 3)
+
+static void __iomem *ipu_dc_reg;
+static void __iomem *ipu_dc_tmpl_reg;
+static struct device *ipu_dev;
+
+struct ipu_dc {
+       unsigned int di; /* The display interface number assigned to this d=
c channel */
+       unsigned int channel_offset;
+};
+
+static struct ipu_dc dc_channels[10];
+
+static void ipu_dc_link_event(int chan, int event, int addr, int priority)
+{
+       u32 reg;
+
+       reg =3D __raw_readl(DC_RL_CH(chan, event));
+       reg &=3D ~(0xFFFF << (16 * (event & 0x1)));
+       reg |=3D ((addr << 8) | priority) << (16 * (event & 0x1));
+       __raw_writel(reg, DC_RL_CH(chan, event));
+}
+
+static void ipu_dc_write_tmpl(int word, u32 opcode, u32 operand, int map,
+                              int wave, int glue, int sync)
+{
+       u32 reg;
+       int stop =3D 1;
+
+       reg =3D sync;
+       reg |=3D (glue << 4);
+       reg |=3D (++wave << 11);
+       reg |=3D (++map << 15);
+       reg |=3D (operand << 20) & 0xFFF00000;
+       __raw_writel(reg, ipu_dc_tmpl_reg + word * 8);
+
+       reg =3D (operand >> 12);
+       reg |=3D opcode << 4;
+       reg |=3D (stop << 9);
+       __raw_writel(reg, ipu_dc_tmpl_reg + word * 8 + 4);
+}
+
+static int ipu_pixfmt_to_map(u32 fmt)
+{
+       switch (fmt) {
+       case IPU_PIX_FMT_GENERIC:
+       case IPU_PIX_FMT_RGB24:
+               return 0;
+       case IPU_PIX_FMT_RGB666:
+               return 1;
+       case IPU_PIX_FMT_YUV444:
+               return 2;
+       case IPU_PIX_FMT_RGB565:
+               return 3;
+       case IPU_PIX_FMT_LVDS666:
+               return 4;
+       }
+
+       return -EINVAL;
+}
+
+#define SYNC_WAVE 0
+
+int ipu_dc_init_sync(int dc_chan, int di, bool interlaced, u32 pixel_fmt, =
u32 width)
+{
+       u32 reg =3D 0, map;
+
+       dc_channels[dc_chan].di =3D di;
+
+       map =3D ipu_pixfmt_to_map(pixel_fmt);
+       if (map < 0) {
+               dev_dbg(ipu_dev, "IPU_DISP: No MAP\n");
+               return -EINVAL;
+       }
+
+       if (interlaced) {
+               ipu_dc_link_event(dc_chan, DC_EVT_NL, 0, 3);
+               ipu_dc_link_event(dc_chan, DC_EVT_EOL, 0, 2);
+               ipu_dc_link_event(dc_chan, DC_EVT_NEW_DATA, 0, 1);
+
+               /* Init template microcode */
+               ipu_dc_write_tmpl(0, WROD(0), 0, map, SYNC_WAVE, 0, 8);
+       } else {
+               if (di) {
+                       ipu_dc_link_event(dc_chan, DC_EVT_NL, 2, 3);
+                       ipu_dc_link_event(dc_chan, DC_EVT_EOL, 3, 2);
+                       ipu_dc_link_event(dc_chan, DC_EVT_NEW_DATA, 4, 1);
+                       /* Init template microcode */
+                       ipu_dc_write_tmpl(2, WROD(0), 0, map, SYNC_WAVE, 8,=
 5);
+                       ipu_dc_write_tmpl(3, WROD(0), 0, map, SYNC_WAVE, 4,=
 5);
+                       ipu_dc_write_tmpl(4, WROD(0), 0, map, SYNC_WAVE, 0,=
 5);
+               } else {
+                       ipu_dc_link_event(dc_chan, DC_EVT_NL, 5, 3);
+                       ipu_dc_link_event(dc_chan, DC_EVT_EOL, 6, 2);
+                       ipu_dc_link_event(dc_chan, DC_EVT_NEW_DATA, 7, 1);
+                       /* Init template microcode */
+                       ipu_dc_write_tmpl(5, WROD(0), 0, map, SYNC_WAVE, 8,=
 5);
+                       ipu_dc_write_tmpl(6, WROD(0), 0, map, SYNC_WAVE, 4,=
 5);
+                       ipu_dc_write_tmpl(7, WROD(0), 0, map, SYNC_WAVE, 0,=
 5);
+               }
+       }
+       ipu_dc_link_event(dc_chan, DC_EVT_NF, 0, 0);
+       ipu_dc_link_event(dc_chan, DC_EVT_NFIELD, 0, 0);
+       ipu_dc_link_event(dc_chan, DC_EVT_EOF, 0, 0);
+       ipu_dc_link_event(dc_chan, DC_EVT_EOFIELD, 0, 0);
+       ipu_dc_link_event(dc_chan, DC_EVT_NEW_CHAN, 0, 0);
+       ipu_dc_link_event(dc_chan, DC_EVT_NEW_ADDR, 0, 0);
+
+       reg =3D 0x2;
+       reg |=3D di << DC_WR_CH_CONF_PROG_DISP_ID_OFFSET;
+       reg |=3D di << 2;
+       if (interlaced)
+               reg |=3D DC_WR_CH_CONF_FIELD_MODE;
+
+       __raw_writel(reg, DC_WR_CH_CONF(dc_chan));
+
+       __raw_writel(0x00000000, DC_WR_CH_ADDR(dc_chan));
+
+       __raw_writel(0x00000084, DC_GEN);
+
+       __raw_writel(width, DC_DISP_CONF2(di));
+
+       ipu_module_enable(IPU_CONF_DC_EN);
+
+       return 0;
+}
+EXPORT_SYMBOL(ipu_dc_init_sync);
+
+void ipu_dc_init_async(int dc_chan, int di, bool interlaced)
+{
+       u32 reg =3D 0;
+       dc_channels[dc_chan].di =3D di;
+       ipu_dc_link_event(dc_chan, DC_EVT_NEW_DATA_W_0, 0x64, 1);
+       ipu_dc_link_event(dc_chan, DC_EVT_NEW_DATA_W_1, 0x64, 1);
+
+       reg =3D 0x3;
+       reg |=3D DC_DISP_ID_SERIAL << DC_WR_CH_CONF_PROG_DISP_ID_OFFSET;
+       __raw_writel(reg, DC_WR_CH_CONF(dc_chan));
+
+       __raw_writel(0x00000000, DC_WR_CH_ADDR(dc_chan));
+
+       __raw_writel(0x00000084, DC_GEN);
+
+       ipu_module_enable(IPU_CONF_DC_EN);
+}
+EXPORT_SYMBOL(ipu_dc_init_async);
+
+void ipu_dc_enable_channel(u32 dc_chan)
+{
+       int di;
+       u32 reg;
+
+       di =3D dc_channels[dc_chan].di;
+
+       /* Make sure other DC sync channel is not assigned same DI */
+       reg =3D __raw_readl(DC_WR_CH_CONF(6 - dc_chan));
+       if ((di << 2) =3D=3D (reg & DC_WR_CH_CONF_PROG_DI_ID)) {
+               reg &=3D ~DC_WR_CH_CONF_PROG_DI_ID;
+               reg |=3D di ? 0 : DC_WR_CH_CONF_PROG_DI_ID;
+               __raw_writel(reg, DC_WR_CH_CONF(6 - dc_chan));
+       }
+
+       reg =3D __raw_readl(DC_WR_CH_CONF(dc_chan));
+       reg |=3D 4 << DC_WR_CH_CONF_PROG_TYPE_OFFSET;
+       __raw_writel(reg, DC_WR_CH_CONF(dc_chan));
+}
+EXPORT_SYMBOL(ipu_dc_enable_channel);
+
+void ipu_dc_disable_channel(u32 dc_chan)
+{
+       u32 reg;
+       int irq =3D 0, ret, timeout =3D 50;
+
+       if (dc_chan =3D=3D 1) {
+               irq =3D IPU_IRQ_DC_FC_1;
+       } else if (dc_chan =3D=3D 5) {
+               irq =3D IPU_IRQ_DP_SF_END;
+       } else {
+               return;
+       }
+
+       ret =3D ipu_wait_for_interrupt(irq, 50);
+       if (ret)
+               return;
+
+       /* Wait for DC triple buffer to empty */
+       if (dc_channels[dc_chan].di =3D=3D 0)
+               while ((__raw_readl(DC_STAT) & 0x00000002)
+                       !=3D 0x00000002) {
+                       msleep(2);
+                       timeout -=3D 2;
+                       if (timeout <=3D 0)
+                               break;
+               }
+       else if (dc_channels[dc_chan].di =3D=3D 1)
+               while ((__raw_readl(DC_STAT) & 0x00000020)
+                       !=3D 0x00000020) {
+                       msleep(2);
+                       timeout -=3D 2;
+                       if (timeout <=3D 0)
+                               break;
+       }
+
+       reg =3D __raw_readl(DC_WR_CH_CONF(dc_chan));
+       reg &=3D ~DC_WR_CH_CONF_PROG_TYPE_MASK;
+       __raw_writel(reg, DC_WR_CH_CONF(dc_chan));
+}
+EXPORT_SYMBOL(ipu_dc_disable_channel);
+
+static void ipu_dc_map_config(int map, int byte_num, int offset, int mask)
+{
+       int ptr =3D map * 3 + byte_num;
+       u32 reg;
+
+       reg =3D __raw_readl(DC_MAP_CONF_VAL(ptr));
+       reg &=3D ~(0xffff << (16 * (ptr & 0x1)));
+       reg |=3D ((offset << 8) | mask) << (16 * (ptr & 0x1));
+       __raw_writel(reg, DC_MAP_CONF_VAL(ptr));
+
+       reg =3D __raw_readl(DC_MAP_CONF_PTR(map));
+       reg &=3D ~(0x1f << ((16 * (map & 0x1)) + (5 * byte_num)));
+       reg |=3D ptr << ((16 * (map & 0x1)) + (5 * byte_num));
+       __raw_writel(reg, DC_MAP_CONF_PTR(map));
+}
+
+static void ipu_dc_map_clear(int map)
+{
+       u32 reg =3D __raw_readl(DC_MAP_CONF_PTR(map));
+       __raw_writel(reg & ~(0xffff << (16 * (map & 0x1))),
+                    DC_MAP_CONF_PTR(map));
+}
+
+int ipu_dc_init(struct platform_device *pdev, unsigned long base, unsigned=
 long template_base)
+{
+       static int channel_offsets[] =3D { 0, 0x1c, 0x38, 0x54, 0x58, 0x5c,=
 0x78, 0, 0x94, 0xb4};
+       int i;
+
+       ipu_dc_reg =3D ioremap(base, PAGE_SIZE);
+       if (!ipu_dc_reg)
+               return -ENOMEM;
+
+       ipu_dev =3D &pdev->dev;
+
+       ipu_dc_tmpl_reg =3D ioremap(template_base, PAGE_SIZE);
+       if (!ipu_dc_tmpl_reg) {
+               iounmap(ipu_dc_reg);
+               return -ENOMEM;
+       }
+
+       for (i =3D 0; i < 10; i++)
+               dc_channels[i].channel_offset =3D channel_offsets[i];
+
+       /* IPU_PIX_FMT_RGB24 */
+       ipu_dc_map_clear(0);
+       ipu_dc_map_config(0, 0, 7, 0xff);
+       ipu_dc_map_config(0, 1, 15, 0xff);
+       ipu_dc_map_config(0, 2, 23, 0xff);
+
+       /* IPU_PIX_FMT_RGB666 */
+       ipu_dc_map_clear(1);
+       ipu_dc_map_config(1, 0, 5, 0xfc);
+       ipu_dc_map_config(1, 1, 11, 0xfc);
+       ipu_dc_map_config(1, 2, 17, 0xfc);
+
+       /* IPU_PIX_FMT_YUV444 */
+       ipu_dc_map_clear(2);
+       ipu_dc_map_config(2, 0, 15, 0xff);
+       ipu_dc_map_config(2, 1, 23, 0xff);
+       ipu_dc_map_config(2, 2, 7, 0xff);
+
+       /* IPU_PIX_FMT_RGB565 */
+       ipu_dc_map_clear(3);
+       ipu_dc_map_config(3, 0, 4, 0xf8);
+       ipu_dc_map_config(3, 1, 10, 0xfc);
+       ipu_dc_map_config(3, 2, 15, 0xf8);
+
+       /* IPU_PIX_FMT_LVDS666 */
+       ipu_dc_map_clear(4);
+       ipu_dc_map_config(4, 0, 5, 0xfc);
+       ipu_dc_map_config(4, 1, 13, 0xfc);
+       ipu_dc_map_config(4, 2, 21, 0xfc);
+
+       return 0;
+}
+
+void ipu_dc_exit(struct platform_device *pdev)
+{
+       iounmap(ipu_dc_reg);
+       iounmap(ipu_dc_tmpl_reg);
+}
diff --git a/drivers/mfd/imx-ipu-v3/ipu-di.c b/drivers/mfd/imx-ipu-v3/ipu-d=
i.c
new file mode 100644
index 0000000..73ebd51
--- /dev/null
+++ b/drivers/mfd/imx-ipu-v3/ipu-di.c
@@ -0,0 +1,507 @@
+/*
+ * Copyright (c) 2010 Sascha Hauer <s.hauer@pengutronix.de<mailto:s.hauer@=
pengutronix.de>>
+ * Copyright (C) 2005-2009 Freescale Semiconductor, Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the
+ * Free Software Foundation; either version 2 of the License, or (at your
+ * option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABIL=
ITY
+ * or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public Licens=
e
+ * for more details.
+ */
+
+#include <linux/types.h>
+#include <linux/errno.h>
+#include <linux/delay.h>
+#include <linux/io.h>
+#include <linux/mfd/imx-ipu-v3.h>
+#include <linux/platform_device.h>
+#include <asm/atomic.h>
+
+#include "ipu-prv.h"
+
+#define SYNC_WAVE 0
+
+#define DC_DISP_ID_SYNC(di)    (di)
+
+struct ipu_di {
+       void __iomem *base;
+       int id;
+       u32 module;
+       struct clk *clk;
+       struct clk *ipu_clk;
+       bool external_clk;
+};
+
+static struct ipu_di dis[2];
+
+static DEFINE_MUTEX(di_mutex);
+static struct device *ipu_dev;
+
+struct di_sync_config {
+       int run_count;
+       int run_src;
+       int offset_count;
+       int offset_src;
+       int repeat_count;
+       int cnt_clr_src;
+       int cnt_polarity_gen_en;
+       int cnt_polarity_clr_src;
+       int cnt_polarity_trigger_src;
+       int cnt_up;
+       int cnt_down;
+};
+
+enum di_pins {
+       DI_PIN11 =3D 0,
+       DI_PIN12 =3D 1,
+       DI_PIN13 =3D 2,
+       DI_PIN14 =3D 3,
+       DI_PIN15 =3D 4,
+       DI_PIN16 =3D 5,
+       DI_PIN17 =3D 6,
+       DI_PIN_CS =3D 7,
+
+       DI_PIN_SER_CLK =3D 0,
+       DI_PIN_SER_RS =3D 1,
+};
+
+enum di_sync_wave {
+       DI_SYNC_NONE =3D 0,
+       DI_SYNC_CLK =3D 1,
+       DI_SYNC_INT_HSYNC =3D 2,
+       DI_SYNC_HSYNC =3D 3,
+       DI_SYNC_VSYNC =3D 4,
+       DI_SYNC_DE =3D 6,
+};
+
+#define DI_GENERAL             0x0000
+#define DI_BS_CLKGEN0          0x0004
+#define DI_BS_CLKGEN1          0x0008
+#define DI_SW_GEN0(gen)                (0x000c + 4 * ((gen) - 1))
+#define DI_SW_GEN1(gen)                (0x0030 + 4 * ((gen) - 1))
+#define DI_STP_REP(gen)                (0x0148 + 4 * (((gen) - 1)/2))
+#define DI_SYNC_AS_GEN         0x0054
+#define DI_DW_GEN(gen)         (0x0058 + 4 * (gen))
+#define DI_DW_SET(gen, set)    (0x0088 + 4 * ((gen) + 0xc * (set)))
+#define DI_SER_CONF            0x015c
+#define DI_SSC                 0x0160
+#define DI_POL                 0x0164
+#define DI_AW0                 0x0168
+#define DI_AW1                 0x016c
+#define DI_SCR_CONF            0x0170
+#define DI_STAT                        0x0174
+
+#define DI_SW_GEN0_RUN_COUNT(x)                        ((x) << 19)
+#define DI_SW_GEN0_RUN_SRC(x)                  ((x) << 16)
+#define DI_SW_GEN0_OFFSET_COUNT(x)             ((x) << 3)
+#define DI_SW_GEN0_OFFSET_SRC(x)               ((x) << 0)
+
+#define DI_SW_GEN1_CNT_POL_GEN_EN(x)           ((x) << 29)
+#define DI_SW_GEN1_CNT_CLR_SRC(x)              ((x) << 25)
+#define DI_SW_GEN1_CNT_POL_TRIGGER_SRC(x)      ((x) << 12)
+#define DI_SW_GEN1_CNT_POL_CLR_SRC(x)          ((x) << 9)
+#define DI_SW_GEN1_CNT_DOWN(x)                 ((x) << 16)
+#define DI_SW_GEN1_CNT_UP(x)                   (x)
+#define DI_SW_GEN1_AUTO_RELOAD                 (0x10000000)
+
+#define DI_DW_GEN_ACCESS_SIZE_OFFSET           24
+#define DI_DW_GEN_COMPONENT_SIZE_OFFSET                16
+
+#define DI_GEN_DI_CLK_EXT                      (1 << 20)
+#define DI_GEN_POLARITY_1                      (1 << 0)
+#define DI_GEN_POLARITY_2                      (1 << 1)
+#define DI_GEN_POLARITY_3                      (1 << 2)
+#define DI_GEN_POLARITY_4                      (1 << 3)
+#define DI_GEN_POLARITY_5                      (1 << 4)
+#define DI_GEN_POLARITY_6                      (1 << 5)
+#define DI_GEN_POLARITY_7                      (1 << 6)
+#define DI_GEN_POLARITY_8                      (1 << 7)
+
+#define DI_POL_DRDY_DATA_POLARITY              (1 << 7)
+#define DI_POL_DRDY_POLARITY_15                        (1 << 4)
+
+#define DI_VSYNC_SEL_OFFSET                    13
+
+#define DI0_COUNTER_RELEASE                    (1 << 24)
+#define DI1_COUNTER_RELEASE                    (1 << 25)
+
+static inline u32 ipu_di_read(struct ipu_di *di, unsigned offset)
+{
+       return __raw_readl(di->base + offset);
+}
+
+static inline void ipu_di_write(struct ipu_di *di, u32 value, unsigned off=
set)
+{
+       __raw_writel(value, di->base + offset);
+}
+
+static void ipu_di_data_wave_config(struct ipu_di *di,
+                                    int wave_gen,
+                                    int access_size, int component_size)
+{
+       u32 reg;
+       reg =3D (access_size << DI_DW_GEN_ACCESS_SIZE_OFFSET) |
+           (component_size << DI_DW_GEN_COMPONENT_SIZE_OFFSET);
+       ipu_di_write(di, reg, DI_DW_GEN(wave_gen));
+}
+
+static void ipu_di_data_pin_config(struct ipu_di *di, int wave_gen, int di=
_pin, int set,
+                                   int up, int down)
+{
+       u32 reg;
+
+       reg =3D ipu_di_read(di, DI_DW_GEN(wave_gen));
+       reg &=3D ~(0x3 << (di_pin * 2));
+       reg |=3D set << (di_pin * 2);
+       ipu_di_write(di, reg, DI_DW_GEN(wave_gen));
+
+       ipu_di_write(di, (down << 16) | up, DI_DW_SET(wave_gen, set));
+}
+
+static void ipu_di_sync_config(struct ipu_di *di, struct di_sync_config *c=
onfig, int count)
+{
+       u32 reg;
+       int i;
+
+       for (i =3D 0; i < count; i++) {
+               struct di_sync_config *c =3D &config[i];
+               int wave_gen =3D i + 1;
+
+               pr_debug("%s %d\n", __func__, wave_gen);
+               if ((c->run_count >=3D 0x1000) || (c->offset_count >=3D 0x1=
000) || (c->repeat_count >=3D 0x1000) ||
+                       (c->cnt_up >=3D 0x400) || (c->cnt_down >=3D 0x400))=
 {
+                       dev_err(ipu_dev, "DI%d counters out of range.\n", d=
i->id);
+                       return;
+               }
+
+               reg =3D DI_SW_GEN0_RUN_COUNT(c->run_count) |
+                       DI_SW_GEN0_RUN_SRC(c->run_src) |
+                       DI_SW_GEN0_OFFSET_COUNT(c->offset_count) |
+                       DI_SW_GEN0_OFFSET_SRC(c->offset_src);
+               ipu_di_write(di, reg, DI_SW_GEN0(wave_gen));
+
+               reg =3D DI_SW_GEN1_CNT_POL_GEN_EN(c->cnt_polarity_gen_en) |
+                       DI_SW_GEN1_CNT_CLR_SRC(c->cnt_clr_src) |
+                       DI_SW_GEN1_CNT_POL_TRIGGER_SRC(c->cnt_polarity_trig=
ger_src) |
+                       DI_SW_GEN1_CNT_POL_CLR_SRC(c->cnt_polarity_clr_src)=
 |
+                       DI_SW_GEN1_CNT_DOWN(c->cnt_down) |
+                       DI_SW_GEN1_CNT_UP(c->cnt_up);
+
+               if (c->repeat_count =3D=3D 0) {
+                       /* Enable auto reload */
+                       reg |=3D DI_SW_GEN1_AUTO_RELOAD;
+               }
+
+               ipu_di_write(di, reg, DI_SW_GEN1(wave_gen));
+
+               reg =3D ipu_di_read(di, DI_STP_REP(wave_gen));
+               reg &=3D ~(0xffff << (16 * ((wave_gen - 1) & 0x1)));
+               reg |=3D c->repeat_count << (16 * ((wave_gen - 1) & 0x1));
+               ipu_di_write(di, reg, DI_STP_REP(wave_gen));
+       }
+}
+
+static void ipu_di_sync_config_interlaced(struct ipu_di *di, struct ipu_di=
_signal_cfg *sig)
+{
+       u32 h_total =3D sig->width + sig->h_sync_width + sig->h_start_width=
 + sig->h_end_width;
+       u32 v_total =3D sig->height + sig->v_sync_width + sig->v_start_widt=
h + sig->v_end_width;
+       u32 reg;
+       struct di_sync_config cfg[] =3D {
+               {
+                       .run_count =3D h_total / 2 - 1,
+                       .run_src =3D DI_SYNC_CLK,
+               }, {
+                       .run_count =3D h_total - 11,
+                       .run_src =3D DI_SYNC_CLK,
+                       .cnt_down =3D 4,
+               }, {
+                       .run_count =3D v_total * 2 - 1,
+                       .run_src =3D DI_SYNC_INT_HSYNC,
+                       .offset_count =3D 1,
+                       .offset_src =3D DI_SYNC_INT_HSYNC,
+                       .cnt_down =3D 4,
+               }, {
+                       .run_count =3D v_total / 2 - 1,
+                       .run_src =3D DI_SYNC_HSYNC,
+                       .offset_count =3D sig->v_start_width,
+                       .offset_src =3D DI_SYNC_HSYNC,
+                       .repeat_count =3D 2,
+                       .cnt_clr_src =3D DI_SYNC_VSYNC,
+               }, {
+                       .run_src =3D DI_SYNC_HSYNC,
+                       .repeat_count =3D sig->height / 2,
+                       .cnt_clr_src =3D 4,
+               }, {
+                       .run_count =3D v_total - 1,
+                       .run_src =3D DI_SYNC_HSYNC,
+               }, {
+                       .run_count =3D v_total / 2 - 1,
+                       .run_src =3D DI_SYNC_HSYNC,
+                       .offset_count =3D 9,
+                       .offset_src =3D DI_SYNC_HSYNC,
+                       .repeat_count =3D 2,
+                       .cnt_clr_src =3D DI_SYNC_VSYNC,
+               }, {
+                       .run_src =3D DI_SYNC_CLK,
+                       .offset_count =3D sig->h_start_width,
+                       .offset_src =3D DI_SYNC_CLK,
+                       .repeat_count =3D sig->width,
+                       .cnt_clr_src =3D 5,
+               }, {
+                       .run_count =3D v_total - 1,
+                       .run_src =3D DI_SYNC_INT_HSYNC,
+                       .offset_count =3D v_total / 2,
+                       .offset_src =3D DI_SYNC_INT_HSYNC,
+                       .cnt_clr_src =3D DI_SYNC_HSYNC,
+                       .cnt_down =3D 4,
+               }
+       };
+
+       ipu_di_sync_config(di, cfg, ARRAY_SIZE(cfg));
+
+       /* set gentime select and tag sel */
+       reg =3D ipu_di_read(di, DI_SW_GEN1(9));
+       reg &=3D 0x1FFFFFFF;
+       reg |=3D (3 - 1) << 29 | 0x00008000;
+       ipu_di_write(di, reg, DI_SW_GEN1(9));
+
+       ipu_di_write(di, v_total / 2 - 1, DI_SCR_CONF);
+}
+
+static void ipu_di_sync_config_noninterlaced(struct ipu_di *di,
+               struct ipu_di_signal_cfg *sig, int div)
+{
+       u32 h_total =3D sig->width + sig->h_sync_width + sig->h_start_width=
 +
+               sig->h_end_width;
+       u32 v_total =3D sig->height + sig->v_sync_width + sig->v_start_widt=
h +
+               sig->v_end_width + (sig->v_end_width < 2 ? 1 : 0);
+       struct di_sync_config cfg[] =3D {
+               {
+                       .run_count =3D h_total - 1,
+                       .run_src =3D DI_SYNC_CLK,
+               } , {
+                       .run_count =3D h_total - 1,
+                       .run_src =3D DI_SYNC_CLK,
+                       .offset_count =3D div * sig->v_to_h_sync,
+                       .offset_src =3D DI_SYNC_CLK,
+                       .cnt_polarity_gen_en =3D 1,
+                       .cnt_polarity_trigger_src =3D DI_SYNC_CLK,
+                       .cnt_down =3D sig->h_sync_width * 2,
+               } , {
+                       .run_count =3D v_total - 1,
+                       .run_src =3D DI_SYNC_INT_HSYNC,
+                       .cnt_polarity_gen_en =3D 1,
+                       .cnt_polarity_trigger_src =3D DI_SYNC_INT_HSYNC,
+                       .cnt_down =3D sig->v_sync_width * 2,
+               } , {
+                       .run_src =3D DI_SYNC_HSYNC,
+                       .offset_count =3D sig->v_sync_width + sig->v_start_=
width,
+                       .offset_src =3D DI_SYNC_HSYNC,
+                       .repeat_count =3D sig->height,
+                       .cnt_clr_src =3D DI_SYNC_VSYNC,
+               } , {
+                       .run_src =3D DI_SYNC_CLK,
+                       .offset_count =3D sig->h_sync_width + sig->h_start_=
width,
+                       .offset_src =3D DI_SYNC_CLK,
+                       .repeat_count =3D sig->width,
+                       .cnt_clr_src =3D 5,
+               } , {
+                       /* unused */
+               } , {
+                       /* unused */
+               } , {
+                       /* unused */
+               } , {
+                       /* unused */
+               },
+       };
+
+       ipu_di_write(di, v_total - 1, DI_SCR_CONF);
+       ipu_di_sync_config(di, cfg, ARRAY_SIZE(cfg));
+}
+
+int ipu_di_init_sync_panel(int disp, u32 pixel_clk, struct ipu_di_signal_c=
fg *sig)
+{
+       struct ipu_di *di =3D &dis[disp];
+       u32 reg;
+       u32 disp_gen, di_gen, vsync_cnt;
+       u32 div;
+       u32 h_total, v_total;
+       struct clk *di_clk;
+
+       dev_dbg(ipu_dev, "disp %d: panel size =3D %d x %d\n",
+               disp, sig->width, sig->height);
+
+       if (disp > 1)
+               return -EINVAL;
+
+       if ((sig->v_sync_width =3D=3D 0) || (sig->h_sync_width =3D=3D 0))
+               return -EINVAL;
+
+       h_total =3D sig->width + sig->h_sync_width + sig->h_start_width + s=
ig->h_end_width;
+       v_total =3D sig->height + sig->v_sync_width + sig->v_start_width + =
sig->v_end_width;
+
+       mutex_lock(&di_mutex);
+
+       /* Init clocking */
+       if (sig->ext_clk) {
+               di->external_clk =3D true;
+               di_clk =3D di->clk;
+       } else {
+               di->external_clk =3D false;
+               di_clk =3D di->ipu_clk;
+       }
+
+       /*
+        * Calculate divider
+        * Fractional part is 4 bits,
+        * so simply multiply by 2^4 to get fractional part.
+        */
+       div =3D (clk_get_rate(di_clk) * 16) / pixel_clk;
+       if (div < 0x10) /* Min DI disp clock divider is 1 */
+               div =3D 0x10;
+
+       disp_gen =3D ipu_cm_read(IPU_DISP_GEN);
+       disp_gen &=3D disp ? ~DI1_COUNTER_RELEASE : ~DI0_COUNTER_RELEASE;
+       ipu_cm_write(disp_gen, IPU_DISP_GEN);
+
+       ipu_di_write(di, div, DI_BS_CLKGEN0);
+
+       /* Setup pixel clock timing */
+       /* Down time is half of period */
+       ipu_di_write(di, (div / 16) << 16, DI_BS_CLKGEN1);
+
+       ipu_di_data_wave_config(di, SYNC_WAVE, div / 16 - 1, div / 16 - 1);
+       ipu_di_data_pin_config(di, SYNC_WAVE, DI_PIN15, 3, 0, div / 16 * 2)=
;
+
+       div =3D div / 16;         /* Now divider is integer portion */
+
+       di_gen =3D 0;
+       if (sig->ext_clk)
+               di_gen |=3D DI_GEN_DI_CLK_EXT;
+
+       if (sig->interlaced) {
+               ipu_di_sync_config_interlaced(di, sig);
+
+               /* set y_sel =3D 1 */
+               di_gen |=3D 0x10000000;
+               di_gen |=3D DI_GEN_POLARITY_5;
+               di_gen |=3D DI_GEN_POLARITY_8;
+
+               vsync_cnt =3D 7;
+
+               if (sig->Hsync_pol)
+                       di_gen |=3D DI_GEN_POLARITY_3;
+               if (sig->Vsync_pol)
+                       di_gen |=3D DI_GEN_POLARITY_2;
+       } else {
+               ipu_di_sync_config_noninterlaced(di, sig, div);
+
+               vsync_cnt =3D 3;
+
+               if (sig->Hsync_pol)
+                       di_gen |=3D DI_GEN_POLARITY_2;
+               if (sig->Vsync_pol)
+                       di_gen |=3D DI_GEN_POLARITY_3;
+       }
+
+       ipu_di_write(di, di_gen, DI_GENERAL);
+       ipu_di_write(di, (--vsync_cnt << DI_VSYNC_SEL_OFFSET) | 0x00000002,
+                    DI_SYNC_AS_GEN);
+
+       reg =3D ipu_di_read(di, DI_POL);
+       reg &=3D ~(DI_POL_DRDY_DATA_POLARITY | DI_POL_DRDY_POLARITY_15);
+
+       if (sig->enable_pol)
+               reg |=3D DI_POL_DRDY_POLARITY_15;
+       if (sig->data_pol)
+               reg |=3D DI_POL_DRDY_DATA_POLARITY;
+
+       ipu_di_write(di, reg, DI_POL);
+
+       mutex_unlock(&di_mutex);
+
+       return 0;
+}
+EXPORT_SYMBOL(ipu_di_init_sync_panel);
+
+int ipu_di_enable(int disp)
+{
+       struct ipu_di *di =3D &dis[disp];
+       u32 reg;
+
+       reg =3D ipu_cm_read(IPU_DISP_GEN);
+       if (disp)
+               reg |=3D DI1_COUNTER_RELEASE;
+       else
+               reg |=3D DI0_COUNTER_RELEASE;
+       ipu_cm_write(reg, IPU_DISP_GEN);
+
+       if (di->external_clk)
+               clk_enable(di->clk);
+
+       ipu_module_enable(di->module);
+
+       return 0;
+}
+EXPORT_SYMBOL(ipu_di_enable);
+
+int ipu_di_disable(int disp)
+{
+       struct ipu_di *di =3D &dis[disp];
+       u32 reg;
+
+       ipu_module_disable(di->module);
+
+       if (di->external_clk)
+               clk_disable(di->clk);
+
+       reg =3D ipu_cm_read(IPU_DISP_GEN);
+       if (disp)
+               reg &=3D ~DI1_COUNTER_RELEASE;
+       else
+               reg &=3D ~DI0_COUNTER_RELEASE;
+       ipu_cm_write(reg, IPU_DISP_GEN);
+
+       return 0;
+}
+EXPORT_SYMBOL(ipu_di_disable);
+
+int ipu_di_init(struct platform_device *pdev, int id, unsigned long base,
+               u32 module, struct clk *ipu_clk)
+{
+       char *clkid;
+
+       if (id > 1)
+               return -EINVAL;
+
+       if (id)
+               clkid =3D "di1";
+       else
+               clkid =3D "di0";
+
+       ipu_dev =3D &pdev->dev;
+
+       dis[id].clk =3D clk_get(&pdev->dev, clkid);
+       dis[id].module =3D module;
+       dis[id].id =3D id;
+       dis[id].ipu_clk =3D ipu_clk;
+       dis[id].base =3D ioremap(base, PAGE_SIZE);
+       if (!dis[id].base)
+               return -ENOMEM;
+
+       /* Set MCU_T to divide MCU access window into 2 */
+       ipu_cm_write(0x00400000L | (IPU_MCU_T_DEFAULT << 18), IPU_DISP_GEN)=
;
+
+       return 0;
+}
+
+void ipu_di_exit(struct platform_device *pdev, int id)
+{
+       clk_put(dis[id].clk);
+       iounmap(dis[id].base);
+}
diff --git a/drivers/mfd/imx-ipu-v3/ipu-dmfc.c b/drivers/mfd/imx-ipu-v3/ipu=
-dmfc.c
new file mode 100644
index 0000000..25782a7
--- /dev/null
+++ b/drivers/mfd/imx-ipu-v3/ipu-dmfc.c
@@ -0,0 +1,343 @@
+/*
+ * Copyright (c) 2010 Sascha Hauer <s.hauer@pengutronix.de<mailto:s.hauer@=
pengutronix.de>>
+ * Copyright (C) 2005-2009 Freescale Semiconductor, Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the
+ * Free Software Foundation; either version 2 of the License, or (at your
+ * option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABIL=
ITY
+ * or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public Licens=
e
+ * for more details.
+ */
+
+#include <linux/types.h>
+#include <linux/errno.h>
+#include <linux/delay.h>
+#include <linux/io.h>
+#include <linux/mfd/imx-ipu-v3.h>
+
+#include "ipu-prv.h"
+
+#define DMFC_RD_CHAN           0x0000
+#define DMFC_WR_CHAN           0x0004
+#define DMFC_WR_CHAN_DEF       0x0008
+#define DMFC_DP_CHAN           0x000c
+#define DMFC_DP_CHAN_DEF       0x0010
+#define DMFC_GENERAL1          0x0014
+#define DMFC_GENERAL2          0x0018
+#define DMFC_IC_CTRL           0x001c
+#define DMFC_STAT              0x0020
+
+#define DMFC_WR_CHAN_1_28              0
+#define DMFC_WR_CHAN_2_41              8
+#define DMFC_WR_CHAN_1C_42             16
+#define DMFC_WR_CHAN_2C_43             24
+
+#define DMFC_DP_CHAN_5B_23             0
+#define DMFC_DP_CHAN_5F_27             8
+#define DMFC_DP_CHAN_6B_24             16
+#define DMFC_DP_CHAN_6F_29             24
+
+#define DMFC_FIFO_SIZE_64              (3 << 3)
+#define DMFC_FIFO_SIZE_128             (2 << 3)
+#define DMFC_FIFO_SIZE_256             (1 << 3)
+#define DMFC_FIFO_SIZE_512             (0 << 3)
+
+#define DMFC_SEGMENT(x)                        ((x & 0x7) << 0)
+#define DMFC_BURSTSIZE_32              (0 << 6)
+#define DMFC_BURSTSIZE_16              (1 << 6)
+#define DMFC_BURSTSIZE_8               (2 << 6)
+#define DMFC_BURSTSIZE_4               (3 << 6)
+
+static struct device *ipu_dev;
+
+struct dmfc_channel {
+       int             ipu_channel;
+       unsigned long   channel_reg;
+       unsigned long   shift;
+       unsigned        eot_shift;
+       unsigned        slots;
+       unsigned        max_fifo_lines;
+       unsigned        slotmask;
+       unsigned        segment;
+};
+
+static struct dmfc_channel dmfcs[] =3D {
+       {
+               .ipu_channel    =3D 23,
+               .channel_reg    =3D DMFC_DP_CHAN,
+               .shift          =3D DMFC_DP_CHAN_5B_23,
+               .eot_shift      =3D 20,
+               .max_fifo_lines =3D 3,
+       }, {
+               .ipu_channel    =3D 24,
+               .channel_reg    =3D DMFC_DP_CHAN,
+               .shift          =3D DMFC_DP_CHAN_6B_24,
+               .eot_shift      =3D 22,
+               .max_fifo_lines =3D 1,
+       }, {
+               .ipu_channel    =3D 27,
+               .channel_reg    =3D DMFC_DP_CHAN,
+               .shift          =3D DMFC_DP_CHAN_5F_27,
+               .eot_shift      =3D 21,
+               .max_fifo_lines =3D 2,
+       }, {
+               .ipu_channel    =3D 28,
+               .channel_reg    =3D DMFC_WR_CHAN,
+               .shift          =3D DMFC_WR_CHAN_1_28,
+               .eot_shift      =3D 16,
+               .max_fifo_lines =3D 2,
+       }, {
+               .ipu_channel    =3D 29,
+               .channel_reg    =3D DMFC_DP_CHAN,
+               .shift          =3D DMFC_DP_CHAN_6F_29,
+               .eot_shift      =3D 23,
+               .max_fifo_lines =3D 1,
+       },
+};
+
+#define DMFC_NUM_CHANNELS      ARRAY_SIZE(dmfcs)
+
+static int dmfc_use_count;
+static void __iomem *dmfc_regs;
+static unsigned long dmfc_bandwidth_per_slot;
+static DEFINE_MUTEX(dmfc_mutex);
+
+int ipu_dmfc_enable_channel(struct dmfc_channel *dmfc)
+{
+       mutex_lock(&dmfc_mutex);
+
+       if (!dmfc_use_count)
+               ipu_module_enable(IPU_CONF_DMFC_EN);
+
+       dmfc_use_count++;
+
+       mutex_unlock(&dmfc_mutex);
+
+       return 0;
+}
+EXPORT_SYMBOL(ipu_dmfc_enable_channel);
+
+void ipu_dmfc_disable_channel(struct dmfc_channel *dmfc)
+{
+       mutex_lock(&dmfc_mutex);
+
+       dmfc_use_count--;
+
+       if (!dmfc_use_count)
+               ipu_module_disable(IPU_CONF_DMFC_EN);
+
+       if (dmfc_use_count < 0)
+               dmfc_use_count =3D 0;
+
+       mutex_unlock(&dmfc_mutex);
+}
+EXPORT_SYMBOL(ipu_dmfc_disable_channel);
+
+static int ipu_dmfc_setup_channel(struct dmfc_channel *dmfc, int slots, in=
t segment)
+{
+       u32 val, field;
+
+       dev_dbg(ipu_dev, "dmfc: using %d slots starting from segment %d for=
 IPU channel %d\n",
+                       slots, segment, dmfc->ipu_channel);
+
+       if (!dmfc)
+               return -EINVAL;
+
+       switch (slots) {
+       case 1:
+               field =3D DMFC_FIFO_SIZE_64;
+               break;
+       case 2:
+               field =3D DMFC_FIFO_SIZE_128;
+               break;
+       case 4:
+               field =3D DMFC_FIFO_SIZE_256;
+               break;
+       case 8:
+               field =3D DMFC_FIFO_SIZE_512;
+               break;
+       default:
+               return -EINVAL;
+       }
+
+       field |=3D DMFC_SEGMENT(segment) | DMFC_BURSTSIZE_8;
+
+       val =3D readl(dmfc_regs + dmfc->channel_reg);
+
+       val &=3D ~(0xff << dmfc->shift);
+       val |=3D field << dmfc->shift;
+
+       writel(val, dmfc_regs + dmfc->channel_reg);
+
+       dmfc->slots =3D slots;
+       dmfc->segment =3D segment;
+       dmfc->slotmask =3D ((1 << slots) - 1) << segment;
+
+       return 0;
+}
+
+static int dmfc_bandwidth_to_slots(unsigned long bandwidth)
+{
+       int slots =3D 1;
+
+       while (slots * dmfc_bandwidth_per_slot < bandwidth)
+               slots *=3D 2;
+
+       return slots;
+}
+
+static int dmfc_find_slots(int slots)
+{
+       unsigned slotmask_need, slotmask_used =3D 0;
+       int i, segment =3D 0;
+
+       slotmask_need =3D (1 << slots) - 1;
+
+       for (i =3D 0; i < DMFC_NUM_CHANNELS; i++)
+               slotmask_used |=3D dmfcs[i].slotmask;
+
+       while (slotmask_need <=3D 0xff) {
+               if (!(slotmask_used & slotmask_need))
+                       return segment;
+
+               slotmask_need <<=3D 1;
+               segment++;
+       }
+
+       return -EBUSY;
+}
+
+void ipu_dmfc_free_bandwidth(struct dmfc_channel *dmfc)
+{
+       int i;
+
+       dev_dbg(ipu_dev, "dmfc: freeing %d slots starting from segment %d\n=
",
+                       dmfc->slots, dmfc->segment);
+
+       mutex_lock(&dmfc_mutex);
+
+       if (!dmfc->slots)
+               goto out;
+
+       dmfc->slotmask =3D 0;
+       dmfc->slots =3D 0;
+       dmfc->segment =3D 0;
+
+       for (i =3D 0; i < ARRAY_SIZE(dmfcs); i++)
+               dmfcs[i].slotmask =3D 0;
+
+       for (i =3D 0; i < ARRAY_SIZE(dmfcs); i++) {
+               if (dmfcs[i].slots > 0) {
+                       dmfcs[i].segment =3D dmfc_find_slots(dmfcs[i].slots=
);
+                       dmfcs[i].slotmask =3D ((1 << dmfcs[i].slots) - 1) <=
< dmfcs[i].segment;
+               }
+       }
+
+       for (i =3D 0; i < ARRAY_SIZE(dmfcs); i++) {
+               if (dmfcs[i].slots > 0)
+                       ipu_dmfc_setup_channel(&dmfcs[i], dmfcs[i].slots, d=
mfcs[i].segment);
+       }
+out:
+       mutex_unlock(&dmfc_mutex);
+}
+EXPORT_SYMBOL(ipu_dmfc_free_bandwidth);
+
+int ipu_dmfc_alloc_bandwidth(struct dmfc_channel *dmfc,
+               unsigned long bandwidth_pixel_per_second)
+{
+       int slots =3D dmfc_bandwidth_to_slots(bandwidth_pixel_per_second);
+       int segment =3D 0;
+
+       dev_dbg(ipu_dev, "dmfc: trying to allocate %ldMpixel/s for IPU chan=
nel %d\n",
+                       bandwidth_pixel_per_second / 1000000, dmfc->ipu_cha=
nnel);
+
+       ipu_dmfc_free_bandwidth(dmfc);
+
+       mutex_lock(&dmfc_mutex);
+
+       if (slots > 8)
+               return -EBUSY;
[Jason] mutex_unlock before return

+
+       segment =3D dmfc_find_slots(slots);
+       if (segment < 0)
+               return -EBUSY;
[Jason] mutex_unlock before return

+
+       ipu_dmfc_setup_channel(dmfc, slots, segment);
+
+       mutex_unlock(&dmfc_mutex);
+
+       return 0;
+}
+EXPORT_SYMBOL(ipu_dmfc_alloc_bandwidth);
+
+int ipu_dmfc_init_channel(struct dmfc_channel *dmfc, int width)
+{
+       u32 dmfc_gen1;
+
+       dmfc_gen1 =3D readl(dmfc_regs + DMFC_GENERAL1);
+
+       if ((dmfc->slots * 64 * 4) / width > dmfc->max_fifo_lines)
+               dmfc_gen1 |=3D 1 << dmfc->eot_shift;
+       else
+               dmfc_gen1 &=3D ~(1 << dmfc->eot_shift);
+
+       writel(dmfc_gen1, dmfc_regs + DMFC_GENERAL1);
+
+       return 0;
+}
+EXPORT_SYMBOL(ipu_dmfc_init_channel);
+
+struct dmfc_channel *ipu_dmfc_get(int ipu_channel)
+{
+       int i;
+
+       for (i =3D 0; i < DMFC_NUM_CHANNELS; i++)
+               if (dmfcs[i].ipu_channel =3D=3D ipu_channel)
+                       return &dmfcs[i];
+       return NULL;
+}
+EXPORT_SYMBOL(ipu_dmfc_get);
+
+void ipu_dmfc_put(struct dmfc_channel *dmfc)
+{
+       ipu_dmfc_free_bandwidth(dmfc);
+}
+EXPORT_SYMBOL(ipu_dmfc_put);
+
+int ipu_dmfc_init(struct platform_device *pdev, unsigned long base,
+               struct clk *ipu_clk)
+{
+       dmfc_regs =3D ioremap(base, PAGE_SIZE);
+
+       if (!dmfc_regs)
+               return -ENOMEM;
+
+       ipu_dev =3D &pdev->dev;
+
+       writel(0x0, dmfc_regs + DMFC_WR_CHAN);
+       writel(0x0, dmfc_regs + DMFC_DP_CHAN);
+
+       /*
+        * We have a total bandwidth of clkrate * 4pixel divided
+        * into 8 slots.
+        */
+       dmfc_bandwidth_per_slot =3D clk_get_rate(ipu_clk) / 4;
+
+       dev_dbg(ipu_dev, "dmfc: 8 slots with %ldMpixel/s bandwidth each\n",
+                       dmfc_bandwidth_per_slot / 1000000);
+
+       writel(0x202020f6, dmfc_regs + DMFC_WR_CHAN_DEF);
+       writel(0x2020f6f6, dmfc_regs + DMFC_DP_CHAN_DEF);
+       writel(0x00000003, dmfc_regs + DMFC_GENERAL1);
+
+       return 0;
+}
+
+void ipu_dmfc_exit(struct platform_device *pdev)
+{
+       iounmap(dmfc_regs);
+}
diff --git a/drivers/mfd/imx-ipu-v3/ipu-dp.c b/drivers/mfd/imx-ipu-v3/ipu-d=
p.c
new file mode 100644
index 0000000..505107d
--- /dev/null
+++ b/drivers/mfd/imx-ipu-v3/ipu-dp.c
@@ -0,0 +1,468 @@
+/*
+ * Copyright (c) 2010 Sascha Hauer <s.hauer@pengutronix.de<mailto:s.hauer@=
pengutronix.de>>
+ * Copyright (C) 2005-2009 Freescale Semiconductor, Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the
+ * Free Software Foundation; either version 2 of the License, or (at your
+ * option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABIL=
ITY
+ * or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public Licens=
e
+ * for more details.
+ */
+
+#include <linux/types.h>
+#include <linux/errno.h>
+#include <linux/delay.h>
+#include <linux/io.h>
+#include <linux/mfd/imx-ipu-v3.h>
+#include <linux/err.h>
+#include <asm/atomic.h>
+
+#include "ipu-prv.h"
+
+#define DP_SYNC 0
+#define DP_ASYNC0 0x60
+#define DP_ASYNC1 0xBC
+
+#define DP_COM_CONF(flow)              (ipu_dp_base + flow)
+#define DP_GRAPH_WIND_CTRL(flow)       (ipu_dp_base + 0x0004 + flow)
+#define DP_FG_POS(flow)                        (ipu_dp_base + 0x0008 + flo=
w)
+#define DP_CSC_A_0(flow)               (ipu_dp_base + 0x0044 + flow)
+#define DP_CSC_A_1(flow)               (ipu_dp_base + 0x0048 + flow)
+#define DP_CSC_A_2(flow)               (ipu_dp_base + 0x004C + flow)
+#define DP_CSC_A_3(flow)               (ipu_dp_base + 0x0050 + flow)
+#define DP_CSC_0(flow)                 (ipu_dp_base + 0x0054 + flow)
+#define DP_CSC_1(flow)                 (ipu_dp_base + 0x0058 + flow)
+
+#define DP_COM_CONF_FG_EN              (1 << 0)
+#define DP_COM_CONF_GWSEL              (1 << 1)
+#define DP_COM_CONF_GWAM               (1 << 2)
+#define DP_COM_CONF_GWCKE              (1 << 3)
+#define DP_COM_CONF_CSC_DEF_MASK       (3 << 8)
+#define DP_COM_CONF_CSC_DEF_OFFSET     8
+#define DP_COM_CONF_CSC_DEF_FG         (3 << 8)
+#define DP_COM_CONF_CSC_DEF_BG         (2 << 8)
+#define DP_COM_CONF_CSC_DEF_BOTH       (1 << 8)
+
+struct ipu_dp {
+       u32 flow;
+       bool in_use;
+};
+
+static struct ipu_dp ipu_dp[3];
+static struct device *ipu_dev;
+
+static u32 ipu_flows[] =3D {DP_SYNC, DP_ASYNC0, DP_ASYNC1};
+
+enum csc_type_t {
+       RGB2YUV =3D 0,
+       YUV2RGB,
+       RGB2RGB,
+       YUV2YUV,
+       CSC_NONE,
+       CSC_NUM
+};
+
+static void __iomem *ipu_dp_base;
+static int dp_use_count;
+static DEFINE_MUTEX(dp_mutex);
+
+/*     Y =3D R *  .299 + G *  .587 + B *  .114;
+       U =3D R * -.169 + G * -.332 + B *  .500 + 128.;
+       V =3D R *  .500 + G * -.419 + B * -.0813 + 128.;*/
+static const int rgb2ycbcr_coeff[5][3] =3D {
+       { 153, 301, 58, },
+       { -87, -170, 0x0100, },
+       { 0x100, -215, -42, },
+       { 0x0000, 0x0200, 0x0200, },    /* B0, B1, B2 */
+       { 0x2, 0x2, 0x2, },     /* S0, S1, S2 */
+};
+
+/*     R =3D (1.164 * (Y - 16)) + (1.596 * (Cr - 128));
+       G =3D (1.164 * (Y - 16)) - (0.392 * (Cb - 128)) - (0.813 * (Cr - 12=
8));
+       B =3D (1.164 * (Y - 16)) + (2.017 * (Cb - 128); */
+static const int ycbcr2rgb_coeff[5][3] =3D {
+       { 0x095, 0x000, 0x0CC, },
+       { 0x095, 0x3CE, 0x398, },
+       { 0x095, 0x0FF, 0x000, },
+       { 0x3E42, 0x010A, 0x3DD6, },    /*B0,B1,B2 */
+       { 0x1, 0x1, 0x1, },     /*S0,S1,S2 */
+};
+
+/* Please keep S0, S1 and S2 as 0x2 by using this conversion */
+static int _rgb_to_yuv(int n, int red, int green, int blue)
+{
+       int c;
+
+       c =3D red * rgb2ycbcr_coeff[n][0];
+       c +=3D green * rgb2ycbcr_coeff[n][1];
+       c +=3D blue * rgb2ycbcr_coeff[n][2];
+       c /=3D 16;
+       c +=3D rgb2ycbcr_coeff[3][n] * 4;
+       c +=3D 8;
+       c /=3D 16;
+       if (c < 0)
+               c =3D 0;
+       if (c > 255)
+               c =3D 255;
+       return c;
+}
+
+struct dp_csc_param_t {
+       int mode;
+       void *coeff;
+};
+
+/*
+ * Row is for BG:      RGB2YUV YUV2RGB RGB2RGB YUV2YUV CSC_NONE
+ * Column is for FG:   RGB2YUV YUV2RGB RGB2RGB YUV2YUV CSC_NONE
+ */
+static struct dp_csc_param_t dp_csc_array[CSC_NUM][CSC_NUM] =3D {
+       {
+               { DP_COM_CONF_CSC_DEF_BOTH, &rgb2ycbcr_coeff, },
+               { 0, 0, },
+               { 0, 0, },
+               { DP_COM_CONF_CSC_DEF_BG, &rgb2ycbcr_coeff, },
+               { DP_COM_CONF_CSC_DEF_BG, &rgb2ycbcr_coeff, },
+       }, {
+               { 0, 0, },
+               { DP_COM_CONF_CSC_DEF_BOTH, &ycbcr2rgb_coeff, },
+               { DP_COM_CONF_CSC_DEF_BG, &ycbcr2rgb_coeff, },
+               { 0, 0, },
+               { DP_COM_CONF_CSC_DEF_BG, &ycbcr2rgb_coeff, },
+       }, {
+               { 0, 0, },
+               { DP_COM_CONF_CSC_DEF_FG, &ycbcr2rgb_coeff, },
+               { 0, 0, },
+               { 0, 0, },
+               { 0, 0, },
+       }, {
+               { DP_COM_CONF_CSC_DEF_FG, &rgb2ycbcr_coeff, },
+               { 0, 0, },
+               { 0, 0, },
+               { 0, 0, },
+               { 0, 0, },
+       }, {
+               { DP_COM_CONF_CSC_DEF_FG, &rgb2ycbcr_coeff, },
+               { DP_COM_CONF_CSC_DEF_FG, &ycbcr2rgb_coeff, },
+               { 0, 0, },
+               { 0, 0, },
+               { 0, 0, },
+       }
+};
+
+static enum csc_type_t fg_csc_type =3D CSC_NONE, bg_csc_type =3D CSC_NONE;
+
+static int color_key_4rgb =3D 1;
+
+int ipu_dp_set_color_key(struct ipu_dp *dp, bool enable, u32 color_key)
+{
+       u32 reg;
+       int y, u, v;
+       int red, green, blue;
+
+       mutex_lock(&dp_mutex);
+
+       color_key_4rgb =3D 1;
+       /* Transform color key from rgb to yuv if CSC is enabled */
+       if (((fg_csc_type =3D=3D RGB2YUV) && (bg_csc_type =3D=3D YUV2YUV)) =
||
+                       ((fg_csc_type =3D=3D YUV2YUV) && (bg_csc_type =3D=
=3D RGB2YUV)) ||
+                       ((fg_csc_type =3D=3D YUV2YUV) && (bg_csc_type =3D=
=3D YUV2YUV)) ||
+                       ((fg_csc_type =3D=3D YUV2RGB) && (bg_csc_type =3D=
=3D YUV2RGB))) {
+
+               dev_dbg(ipu_dev, "color key 0x%x need change to yuv fmt\n",=
 color_key);
+
+               red =3D (color_key >> 16) & 0xFF;
+               green =3D (color_key >> 8) & 0xFF;
+               blue =3D color_key & 0xFF;
+
+               y =3D _rgb_to_yuv(0, red, green, blue);
+               u =3D _rgb_to_yuv(1, red, green, blue);
+               v =3D _rgb_to_yuv(2, red, green, blue);
+               color_key =3D (y << 16) | (u << 8) | v;
+
+               color_key_4rgb =3D 0;
+
+               dev_dbg(ipu_dev, "color key change to yuv fmt 0x%x\n", colo=
r_key);
+       }
+
+       if (enable) {
+               reg =3D __raw_readl(DP_GRAPH_WIND_CTRL(dp->flow)) & 0xFF000=
000L;
+               __raw_writel(reg | color_key, DP_GRAPH_WIND_CTRL(dp->flow))=
;
+
+               reg =3D __raw_readl(DP_COM_CONF(dp->flow));
+               __raw_writel(reg | DP_COM_CONF_GWCKE, DP_COM_CONF(dp->flow)=
);
+       } else {
+               reg =3D __raw_readl(DP_COM_CONF(dp->flow));
+               __raw_writel(reg & ~DP_COM_CONF_GWCKE, DP_COM_CONF(dp->flow=
));
+       }
+
+       reg =3D ipu_cm_read(IPU_SRM_PRI2) | 0x8;
+       ipu_cm_write(reg, IPU_SRM_PRI2);
+
+       mutex_unlock(&dp_mutex);
+
+       return 0;
+}
+EXPORT_SYMBOL(ipu_dp_set_color_key);
+
+int ipu_dp_set_global_alpha(struct ipu_dp *dp, bool enable, u8 alpha, bool=
 bg_chan)
+{
+       u32 reg;
+
+       mutex_lock(&dp_mutex);
+
+       reg =3D __raw_readl(DP_COM_CONF(dp->flow));
+       if (bg_chan)
+               reg &=3D ~DP_COM_CONF_GWSEL;
+       else
+               reg |=3D DP_COM_CONF_GWSEL;
+       __raw_writel(reg, DP_COM_CONF(dp->flow));
+
+       if (enable) {
+               reg =3D __raw_readl(DP_GRAPH_WIND_CTRL(dp->flow)) & 0x00FFF=
FFFL;
+               __raw_writel(reg | ((u32) alpha << 24),
+                            DP_GRAPH_WIND_CTRL(dp->flow));
+
+               reg =3D __raw_readl(DP_COM_CONF(dp->flow));
+               __raw_writel(reg | DP_COM_CONF_GWAM, DP_COM_CONF(dp->flow))=
;
+       } else {
+               reg =3D __raw_readl(DP_COM_CONF(dp->flow));
+               __raw_writel(reg & ~DP_COM_CONF_GWAM, DP_COM_CONF(dp->flow)=
);
+       }
+
+       reg =3D ipu_cm_read(IPU_SRM_PRI2) | 0x8;
+       ipu_cm_write(reg, IPU_SRM_PRI2);
+
+       mutex_unlock(&dp_mutex);
+
+       return 0;
+}
+EXPORT_SYMBOL(ipu_dp_set_global_alpha);
+
+int ipu_dp_set_window_pos(struct ipu_dp *dp, u16 x_pos, u16 y_pos)
+{
+       u32 reg;
+
+       mutex_lock(&dp_mutex);
+
+       __raw_writel((x_pos << 16) | y_pos, DP_FG_POS(dp->flow));
+
+       reg =3D ipu_cm_read(IPU_SRM_PRI2);
+       reg |=3D 0x8;
+       ipu_cm_write(reg, IPU_SRM_PRI2);
+
+       mutex_unlock(&dp_mutex);
+
+       return 0;
+}
+EXPORT_SYMBOL(ipu_dp_set_window_pos);
+
+#define mask_a(a) ((u32)(a) & 0x3FF)
+#define mask_b(b) ((u32)(b) & 0x3FFF)
+
+void __ipu_dp_csc_setup(int dp, struct dp_csc_param_t dp_csc_param,
+                       bool srm_mode_update)
+{
+       u32 reg;
+       const int (*coeff)[5][3];
+
+       if (dp_csc_param.mode >=3D 0) {
+               reg =3D __raw_readl(DP_COM_CONF(dp));
+               reg &=3D ~DP_COM_CONF_CSC_DEF_MASK;
+               reg |=3D dp_csc_param.mode;
+               __raw_writel(reg, DP_COM_CONF(dp));
+       }
+
+       coeff =3D dp_csc_param.coeff;
+
+       if (coeff) {
+               __raw_writel(mask_a((*coeff)[0][0]) |
+                               (mask_a((*coeff)[0][1]) << 16), DP_CSC_A_0(=
dp));
+               __raw_writel(mask_a((*coeff)[0][2]) |
+                               (mask_a((*coeff)[1][0]) << 16), DP_CSC_A_1(=
dp));
+               __raw_writel(mask_a((*coeff)[1][1]) |
+                               (mask_a((*coeff)[1][2]) << 16), DP_CSC_A_2(=
dp));
+               __raw_writel(mask_a((*coeff)[2][0]) |
+                               (mask_a((*coeff)[2][1]) << 16), DP_CSC_A_3(=
dp));
+               __raw_writel(mask_a((*coeff)[2][2]) |
+                               (mask_b((*coeff)[3][0]) << 16) |
+                               ((*coeff)[4][0] << 30), DP_CSC_0(dp));
+               __raw_writel(mask_b((*coeff)[3][1]) | ((*coeff)[4][1] << 14=
) |
+                               (mask_b((*coeff)[3][2]) << 16) |
+                               ((*coeff)[4][2] << 30), DP_CSC_1(dp));
+       }
+
+       if (srm_mode_update) {
+               reg =3D ipu_cm_read(IPU_SRM_PRI2) | 0x8;
+               ipu_cm_write(reg, IPU_SRM_PRI2);
+       }
+}
+
+int ipu_dp_setup_channel(struct ipu_dp *dp, u32 in_pixel_fmt,
+                u32 out_pixel_fmt, int bg)
+{
+       int in_fmt, out_fmt;
+       enum csc_type_t *csc_type;
+       u32 reg;
+
+       if (bg)
+               csc_type =3D &bg_csc_type;
+       else
+               csc_type =3D &fg_csc_type;
+
+       in_fmt =3D format_to_colorspace(in_pixel_fmt);
+       out_fmt =3D format_to_colorspace(out_pixel_fmt);
+
+       if (in_fmt =3D=3D RGB) {
+               if (out_fmt =3D=3D RGB)
+                       *csc_type =3D RGB2RGB;
+               else
+                       *csc_type =3D RGB2YUV;
+       } else {
+               if (out_fmt =3D=3D RGB)
+                       *csc_type =3D YUV2RGB;
+               else
+                       *csc_type =3D YUV2YUV;
+       }
+
+       /* Transform color key from rgb to yuv if CSC is enabled */
+       reg =3D __raw_readl(DP_COM_CONF(dp->flow));
+       if (color_key_4rgb && (reg & DP_COM_CONF_GWCKE) &&
+                       (((fg_csc_type =3D=3D RGB2YUV) && (bg_csc_type =3D=
=3D YUV2YUV)) ||
+                        ((fg_csc_type =3D=3D YUV2YUV) && (bg_csc_type =3D=
=3D RGB2YUV)) ||
+                        ((fg_csc_type =3D=3D YUV2YUV) && (bg_csc_type =3D=
=3D YUV2YUV)) ||
+                        ((fg_csc_type =3D=3D YUV2RGB) && (bg_csc_type =3D=
=3D YUV2RGB)))) {
+               int red, green, blue;
+               int y, u, v;
+               u32 color_key =3D __raw_readl(DP_GRAPH_WIND_CTRL(dp->flow))=
 & 0xFFFFFFL;
+
+               dev_dbg(ipu_dev, "_ipu_dp_init color key 0x%x need change t=
o yuv fmt!\n", color_key);
+
+               red =3D (color_key >> 16) & 0xFF;
+               green =3D (color_key >> 8) & 0xFF;
+               blue =3D color_key & 0xFF;
+
+               y =3D _rgb_to_yuv(0, red, green, blue);
+               u =3D _rgb_to_yuv(1, red, green, blue);
+               v =3D _rgb_to_yuv(2, red, green, blue);
+               color_key =3D (y << 16) | (u << 8) | v;
+
+               reg =3D __raw_readl(DP_GRAPH_WIND_CTRL(dp->flow)) & 0xFF000=
000L;
+               __raw_writel(reg | color_key, DP_GRAPH_WIND_CTRL(dp->flow))=
;
+               color_key_4rgb =3D 0;
+
+               dev_dbg(ipu_dev, "_ipu_dp_init color key change to yuv fmt =
0x%x!\n", color_key);
+       }
+
+       __ipu_dp_csc_setup(dp->flow, dp_csc_array[bg_csc_type][fg_csc_type]=
, true);
+
+       return 0;
+}
+EXPORT_SYMBOL(ipu_dp_setup_channel);
+
+int ipu_dp_enable_channel(struct ipu_dp *dp)
+{
+       mutex_lock(&dp_mutex);
+
+       if (!dp_use_count)
+               ipu_module_enable(IPU_CONF_DP_EN);
+
+       dp_use_count++;
+
+       mutex_unlock(&dp_mutex);
+
+       return 0;
+}
+EXPORT_SYMBOL(ipu_dp_enable_channel);
+
+void ipu_dp_disable_channel(struct ipu_dp *dp)
+{
+       mutex_lock(&dp_mutex);
+
+       dp_use_count--;
+
+       if (!dp_use_count)
+               ipu_module_disable(IPU_CONF_DP_EN);
+
+       if (dp_use_count < 0)
+               dp_use_count =3D 0;
+
+       mutex_unlock(&dp_mutex);
+}
+EXPORT_SYMBOL(ipu_dp_disable_channel);
+
+void ipu_dp_enable_fg(struct ipu_dp *dp)
+{
+       u32 reg;
+
+       /* Enable FG channel */
+       reg =3D __raw_readl(DP_COM_CONF(DP_SYNC));
+       __raw_writel(reg | DP_COM_CONF_FG_EN, DP_COM_CONF(DP_SYNC));
+
+       reg =3D ipu_cm_read(IPU_SRM_PRI2);
+       reg |=3D 0x8;
+       ipu_cm_write(reg, IPU_SRM_PRI2);
+}
+EXPORT_SYMBOL(ipu_dp_enable_fg);
+
+void ipu_dp_disable_fg(struct ipu_dp *dp)
+{
+       u32 reg, csc;
+
+       reg =3D __raw_readl(DP_COM_CONF(DP_SYNC));
+       csc =3D reg & DP_COM_CONF_CSC_DEF_MASK;
+       if (csc =3D=3D DP_COM_CONF_CSC_DEF_FG)
+               reg &=3D ~DP_COM_CONF_CSC_DEF_MASK;
+
+       reg &=3D ~DP_COM_CONF_FG_EN;
+       __raw_writel(reg, DP_COM_CONF(DP_SYNC));
+
+       reg =3D ipu_cm_read(IPU_SRM_PRI2) | 0x8;
+       ipu_cm_write(reg, IPU_SRM_PRI2);
+}
+EXPORT_SYMBOL(ipu_dp_disable_fg);
+
+struct ipu_dp *ipu_dp_get(unsigned int flow)
+{
+       struct ipu_dp *dp;
+
+       if (flow > 2)
+               return ERR_PTR(-EINVAL);
+
+       dp =3D &ipu_dp[flow];
+
+       if (dp->in_use)
+               return ERR_PTR(-EBUSY);
+
+       dp->in_use =3D true;
+       dp->flow =3D ipu_flows[flow];
+
+       return dp;
+}
+EXPORT_SYMBOL(ipu_dp_get);
+
+void ipu_dp_put(struct ipu_dp *dp)
+{
+       dp->in_use =3D false;
+}
+EXPORT_SYMBOL(ipu_dp_put);
+
+int ipu_dp_init(struct platform_device *pdev, unsigned long base)
+{
+       ipu_dp_base =3D ioremap(base, PAGE_SIZE);
+       if (!ipu_dp_base)
+               return -ENOMEM;
+
+       ipu_dev =3D &pdev->dev;
+
+       return 0;
+}
+
+void ipu_dp_exit(struct platform_device *pdev)
+{
+        iounmap(ipu_dp_base);
+}
diff --git a/drivers/mfd/imx-ipu-v3/ipu-prv.h b/drivers/mfd/imx-ipu-v3/ipu-=
prv.h
new file mode 100644
index 0000000..9d54ad0
--- /dev/null
+++ b/drivers/mfd/imx-ipu-v3/ipu-prv.h
@@ -0,0 +1,214 @@
+/*
+ * Copyright (c) 2010 Sascha Hauer <s.hauer@pengutronix.de<mailto:s.hauer@=
pengutronix.de>>
+ * Copyright (C) 2005-2009 Freescale Semiconductor, Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the
+ * Free Software Foundation; either version 2 of the License, or (at your
+ * option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABIL=
ITY
+ * or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public Licens=
e
+ * for more details.
+ */
+#ifndef __IPU_PRV_H__
+#define __IPU_PRV_H__
+
+#include <linux/types.h>
+#include <linux/device.h>
+#include <linux/clk.h>
+#include <linux/interrupt.h>
+#include <linux/platform_device.h>
+#include <mach/hardware.h>
+
+#define MX51_IPU_CHANNEL_CSI0                   0
+#define MX51_IPU_CHANNEL_CSI1                   1
+#define MX51_IPU_CHANNEL_CSI2                   2
+#define MX51_IPU_CHANNEL_CSI3                   3
+#define MX51_IPU_CHANNEL_MEM_BG_SYNC           23
+#define MX51_IPU_CHANNEL_MEM_FG_SYNC           27
+#define MX51_IPU_CHANNEL_MEM_DC_SYNC           28
+#define MX51_IPU_CHANNEL_MEM_FG_SYNC_ALPHA     31
+#define MX51_IPU_CHANNEL_MEM_DC_ASYNC          41
+#define MX51_IPU_CHANNEL_ROT_ENC_MEM           45
+#define MX51_IPU_CHANNEL_ROT_VF_MEM            46
+#define MX51_IPU_CHANNEL_ROT_PP_MEM            47
+#define MX51_IPU_CHANNEL_ROT_ENC_MEM_OUT       48
+#define MX51_IPU_CHANNEL_ROT_VF_MEM_OUT                49
+#define MX51_IPU_CHANNEL_ROT_PP_MEM_OUT                50
+#define MX51_IPU_CHANNEL_MEM_BG_SYNC_ALPHA     51
+
+#define IPU_DISP0_BASE         0x00000000
+#define IPU_MCU_T_DEFAULT      8
+#define IPU_DISP1_BASE         (IPU_MCU_T_DEFAULT << 25)
+#define IPU_CM_REG_BASE                0x1e000000
+#define IPU_IDMAC_REG_BASE     0x1e008000
+#define IPU_ISP_REG_BASE       0x1e010000
+#define IPU_DP_REG_BASE                0x1e018000
+#define IPU_IC_REG_BASE                0x1e020000
+#define IPU_IRT_REG_BASE       0x1e028000
+#define IPU_CSI0_REG_BASE      0x1e030000
+#define IPU_CSI1_REG_BASE      0x1e038000
+#define IPU_DI0_REG_BASE       0x1e040000
+#define IPU_DI1_REG_BASE       0x1e048000
+#define IPU_SMFC_REG_BASE      0x1e050000
+#define IPU_DC_REG_BASE                0x1e058000
+#define IPU_DMFC_REG_BASE      0x1e060000
+#define IPU_CPMEM_REG_BASE     0x1f000000
+#define IPU_LUT_REG_BASE       0x1f020000
+#define IPU_SRM_REG_BASE       0x1f040000
+#define IPU_TPM_REG_BASE       0x1f060000
+#define IPU_DC_TMPL_REG_BASE   0x1f080000
+#define IPU_ISP_TBPR_REG_BASE  0x1f0c0000
+#define IPU_VDI_REG_BASE       0x1e068000
+
+/* Register addresses */
+/* IPU Common registers */
+#define IPU_CM_REG(offset)     (offset)
+
+#define IPU_CONF                       IPU_CM_REG(0)
+
+#define IPU_SRM_PRI1                   IPU_CM_REG(0x00a0)
+#define IPU_SRM_PRI2                   IPU_CM_REG(0x00a4)
+#define IPU_FS_PROC_FLOW1              IPU_CM_REG(0x00a8)
+#define IPU_FS_PROC_FLOW2              IPU_CM_REG(0x00ac)
+#define IPU_FS_PROC_FLOW3              IPU_CM_REG(0x00b0)
+#define IPU_FS_DISP_FLOW1              IPU_CM_REG(0x00b4)
+#define IPU_FS_DISP_FLOW2              IPU_CM_REG(0x00b8)
+#define IPU_SKIP                       IPU_CM_REG(0x00bc)
+#define IPU_DISP_ALT_CONF              IPU_CM_REG(0x00c0)
+#define IPU_DISP_GEN                   IPU_CM_REG(0x00c4)
+#define IPU_DISP_ALT1                  IPU_CM_REG(0x00c8)
+#define IPU_DISP_ALT2                  IPU_CM_REG(0x00cc)
+#define IPU_DISP_ALT3                  IPU_CM_REG(0x00d0)
+#define IPU_DISP_ALT4                  IPU_CM_REG(0x00d4)
+#define IPU_SNOOP                      IPU_CM_REG(0x00d8)
+#define IPU_MEM_RST                    IPU_CM_REG(0x00dc)
+#define IPU_PM                         IPU_CM_REG(0x00e0)
+#define IPU_GPR                                IPU_CM_REG(0x00e4)
+#define IPU_CHA_DB_MODE_SEL(ch)                IPU_CM_REG(0x0150 + 4 * ((c=
h) / 32))
+#define IPU_ALT_CHA_DB_MODE_SEL(ch)    IPU_CM_REG(0x0168 + 4 * ((ch) / 32)=
)
+#define IPU_CHA_CUR_BUF(ch)            IPU_CM_REG(0x023C + 4 * ((ch) / 32)=
)
+#define IPU_ALT_CUR_BUF0               IPU_CM_REG(0x0244)
+#define IPU_ALT_CUR_BUF1               IPU_CM_REG(0x0248)
+#define IPU_SRM_STAT                   IPU_CM_REG(0x024C)
+#define IPU_PROC_TASK_STAT             IPU_CM_REG(0x0250)
+#define IPU_DISP_TASK_STAT             IPU_CM_REG(0x0254)
+#define IPU_CHA_BUF0_RDY(ch)           IPU_CM_REG(0x0268 + 4 * ((ch) / 32)=
)
+#define IPU_CHA_BUF1_RDY(ch)           IPU_CM_REG(0x0270 + 4 * ((ch) / 32)=
)
+#define IPU_ALT_CHA_BUF0_RDY(ch)       IPU_CM_REG(0x0278 + 4 * ((ch) / 32)=
)
+#define IPU_ALT_CHA_BUF1_RDY(ch)       IPU_CM_REG(0x0280 + 4 * ((ch) / 32)=
)
+
+#define IPU_INT_CTRL(n)                IPU_CM_REG(0x003C + 4 * ((n) - 1))
+#define IPU_INT_CTRL_IRQ(irq)  IPU_INT_CTRL(((irq) / 32))
+#define IPU_INT_STAT_IRQ(irq)  IPU_INT_STAT(((irq) / 32))
+#define IPU_INT_STAT(n)                IPU_CM_REG(0x0200 + 4 * ((n) - 1))
+
+extern void __iomem *ipu_cm_reg;
+
+static inline u32 ipu_cm_read(unsigned offset)
+{
+       return __raw_readl(ipu_cm_reg + offset);
+}
+
+static inline void ipu_cm_write(u32 value, unsigned offset)
+{
+       __raw_writel(value, ipu_cm_reg + offset);
+}
+
+#define IPU_IDMAC_REG(offset)  (offset)
+
+#define IDMAC_CONF                     IPU_IDMAC_REG(0x0000)
+#define IDMAC_CHA_EN(ch)               IPU_IDMAC_REG(0x0004 + 4 * ((ch) / =
32))
+#define IDMAC_SEP_ALPHA                        IPU_IDMAC_REG(0x000c)
+#define IDMAC_ALT_SEP_ALPHA            IPU_IDMAC_REG(0x0010)
+#define IDMAC_CHA_PRI(ch)              IPU_IDMAC_REG(0x0014 + 4 * ((ch) / =
32))
+#define IDMAC_WM_EN(ch)                        IPU_IDMAC_REG(0x001c + 4 * =
((ch) / 32))
+#define IDMAC_CH_LOCK_EN_1             IPU_IDMAC_REG(0x0024)
+#define IDMAC_CH_LOCK_EN_2             IPU_IDMAC_REG(0x0028)
+#define IDMAC_SUB_ADDR_0               IPU_IDMAC_REG(0x002c)
+#define IDMAC_SUB_ADDR_1               IPU_IDMAC_REG(0x0030)
+#define IDMAC_SUB_ADDR_2               IPU_IDMAC_REG(0x0034)
+#define IDMAC_BAND_EN(ch)              IPU_IDMAC_REG(0x0040 + 4 * ((ch) / =
32))
+#define IDMAC_CHA_BUSY(ch)             IPU_IDMAC_REG(0x0100 + 4 * ((ch) / =
32))
+
+extern void __iomem *ipu_idmac_reg;
+
+static inline u32 ipu_idmac_read(unsigned offset)
+{
+       return __raw_readl(ipu_idmac_reg + offset);
+}
+
+static inline void ipu_idmac_write(u32 value, unsigned offset)
+{
+       __raw_writel(value, ipu_idmac_reg + offset);
+}
+
+#define idmac_idma_is_set(reg, dma)    (ipu_idmac_read(reg(dma)) & idma_ma=
sk(dma))
+#define idma_mask(ch)                  (1 << (ch & 0x1f))
+#define ipu_idma_is_set(reg, dma)      (ipu_cm_read(reg(dma)) & idma_mask(=
dma))
+
+enum ipu_modules {
+       IPU_CONF_CSI0_EN                =3D (1 << 0),
+       IPU_CONF_CSI1_EN                =3D (1 << 1),
+       IPU_CONF_IC_EN                  =3D (1 << 2),
+       IPU_CONF_ROT_EN                 =3D (1 << 3),
+       IPU_CONF_ISP_EN                 =3D (1 << 4),
+       IPU_CONF_DP_EN                  =3D (1 << 5),
+       IPU_CONF_DI0_EN                 =3D (1 << 6),
+       IPU_CONF_DI1_EN                 =3D (1 << 7),
+       IPU_CONF_SMFC_EN                =3D (1 << 8),
+       IPU_CONF_DC_EN                  =3D (1 << 9),
+       IPU_CONF_DMFC_EN                =3D (1 << 10),
+
+       IPU_CONF_VDI_EN                 =3D (1 << 12),
+
+       IPU_CONF_IDMAC_DIS              =3D (1 << 22),
+
+       IPU_CONF_IC_DMFC_SEL            =3D (1 << 25),
+       IPU_CONF_IC_DMFC_SYNC           =3D (1 << 26),
+       IPU_CONF_VDI_DMFC_SYNC          =3D (1 << 27),
+
+       IPU_CONF_CSI0_DATA_SOURCE       =3D (1 << 28),
+       IPU_CONF_CSI1_DATA_SOURCE       =3D (1 << 29),
+       IPU_CONF_IC_INPUT               =3D (1 << 30),
+       IPU_CONF_CSI_SEL                =3D (1 << 31),
+};
+
+struct ipu_channel {
+       unsigned int num;
+
+       bool enabled;
+       bool busy;
+};
+
+ipu_color_space_t format_to_colorspace(u32 fmt);
+bool ipu_pixel_format_has_alpha(u32 fmt);
+
+u32 _ipu_channel_status(struct ipu_channel *channel);
+
+int _ipu_chan_is_interlaced(struct ipu_channel *channel);
+
+int ipu_module_enable(u32 mask);
+int ipu_module_disable(u32 mask);
+
+int ipu_di_init(struct platform_device *pdev, int id, unsigned long base,
+               u32 module, struct clk *ipu_clk);
+void ipu_di_exit(struct platform_device *pdev, int id);
+
+int ipu_dmfc_init(struct platform_device *pdev, unsigned long base,
+               struct clk *ipu_clk);
+void ipu_dmfc_exit(struct platform_device *pdev);
+
+int ipu_dp_init(struct platform_device *pdev, unsigned long base);
+void ipu_dp_exit(struct platform_device *pdev);
+
+int ipu_dc_init(struct platform_device *pdev, unsigned long base,
+               unsigned long template_base);
+void ipu_dc_exit(struct platform_device *pdev);
+
+int ipu_cpmem_init(struct platform_device *pdev, unsigned long base);
+void ipu_cpmem_exit(struct platform_device *pdev);
+
+#endif                         /* __IPU_PRV_H__ */
diff --git a/include/linux/mfd/imx-ipu-v3.h b/include/linux/mfd/imx-ipu-v3.=
h
new file mode 100644
index 0000000..0288c51
--- /dev/null
+++ b/include/linux/mfd/imx-ipu-v3.h
@@ -0,0 +1,218 @@
+/*
+ * Copyright 2005-2009 Freescale Semiconductor, Inc.
+ *
+ * The code contained herein is licensed under the GNU Lesser General
+ * Public License.  You may obtain a copy of the GNU Lesser General
+ * Public License Version 2.1 or later at the following locations:
+ *
+ * http://www.opensource.org/licenses/lgpl-license.html
+ * http://www.gnu.org/copyleft/lgpl.html
+ */
+
+#ifndef __ASM_ARCH_IPU_H__
+#define __ASM_ARCH_IPU_H__
+
+#include <linux/slab.h>
+#include <linux/types.h>
+#include <linux/videodev2.h>
+#include <linux/interrupt.h>
+#include <linux/bitmap.h>
+
+/*
+ * Enumeration of IPU rotation modes
+ */
+typedef enum {
+       /* Note the enum values correspond to BAM value */
+       IPU_ROTATE_NONE =3D 0,
+       IPU_ROTATE_VERT_FLIP =3D 1,
+       IPU_ROTATE_HORIZ_FLIP =3D 2,
+       IPU_ROTATE_180 =3D 3,
+       IPU_ROTATE_90_RIGHT =3D 4,
+       IPU_ROTATE_90_RIGHT_VFLIP =3D 5,
+       IPU_ROTATE_90_RIGHT_HFLIP =3D 6,
+       IPU_ROTATE_90_LEFT =3D 7,
+} ipu_rotate_mode_t;
+
+/*
+ * IPU Pixel Formats
+ *
+ * Pixel formats are defined with ASCII FOURCC code. The pixel format code=
s are
+ * the same used by V4L2 API.
+ */
+
+/* Generic or Raw Data Formats */
+#define IPU_PIX_FMT_GENERIC v4l2_fourcc('I', 'P', 'U', '0')    /* IPU Gene=
ric Data */
+#define IPU_PIX_FMT_GENERIC_32 v4l2_fourcc('I', 'P', 'U', '1') /* IPU Gene=
ric Data */
+#define IPU_PIX_FMT_LVDS666 v4l2_fourcc('L', 'V', 'D', '6')    /* IPU Gene=
ric Data */
+#define IPU_PIX_FMT_LVDS888 v4l2_fourcc('L', 'V', 'D', '8')    /* IPU Gene=
ric Data */
+/* RGB Formats */
+#define IPU_PIX_FMT_RGB332  V4L2_PIX_FMT_RGB332                        /* =
 8  RGB-3-3-2    */
+#define IPU_PIX_FMT_RGB555  V4L2_PIX_FMT_RGB555                        /* =
16  RGB-5-5-5    */
+#define IPU_PIX_FMT_RGB565  V4L2_PIX_FMT_RGB565                        /* =
1 6  RGB-5-6-5   */
+#define IPU_PIX_FMT_RGB666  v4l2_fourcc('R', 'G', 'B', '6')    /* 18  RGB-=
6-6-6    */
+#define IPU_PIX_FMT_BGR666  v4l2_fourcc('B', 'G', 'R', '6')    /* 18  BGR-=
6-6-6    */
+#define IPU_PIX_FMT_BGR24   V4L2_PIX_FMT_BGR24                 /* 24  BGR-=
8-8-8    */
+#define IPU_PIX_FMT_RGB24   V4L2_PIX_FMT_RGB24                 /* 24  RGB-=
8-8-8    */
+#define IPU_PIX_FMT_BGR32   V4L2_PIX_FMT_BGR32                 /* 32  BGR-=
8-8-8-8  */
+#define IPU_PIX_FMT_BGRA32  v4l2_fourcc('B', 'G', 'R', 'A')    /* 32  BGR-=
8-8-8-8  */
+#define IPU_PIX_FMT_RGB32   V4L2_PIX_FMT_RGB32                 /* 32  RGB-=
8-8-8-8  */
+#define IPU_PIX_FMT_RGBA32  v4l2_fourcc('R', 'G', 'B', 'A')    /* 32  RGB-=
8-8-8-8  */
+#define IPU_PIX_FMT_ABGR32  v4l2_fourcc('A', 'B', 'G', 'R')    /* 32  ABGR=
-8-8-8-8 */
+/* YUV Interleaved Formats */
+#define IPU_PIX_FMT_YUYV    V4L2_PIX_FMT_YUYV                  /* 16 YUV 4=
:2:2 */
+#define IPU_PIX_FMT_UYVY    V4L2_PIX_FMT_UYVY                  /* 16 YUV 4=
:2:2 */
+#define IPU_PIX_FMT_Y41P    V4L2_PIX_FMT_Y41P                  /* 12 YUV 4=
:1:1 */
+#define IPU_PIX_FMT_YUV444  V4L2_PIX_FMT_YUV444                        /* =
24 YUV 4:4:4 */
+/* two planes -- one Y, one Cb + Cr interleaved  */
+#define IPU_PIX_FMT_NV12    V4L2_PIX_FMT_NV12                  /* 12  Y/Cb=
Cr 4:2:0  */
+/* YUV Planar Formats */
+#define IPU_PIX_FMT_GREY    V4L2_PIX_FMT_GREY                  /* 8  Greys=
cale */
+#define IPU_PIX_FMT_YVU410P V4L2_PIX_FMT_YVU410P               /* 9  YVU 4=
:1:0 */
+#define IPU_PIX_FMT_YUV410P V4L2_PIX_FMT_YUV410P               /* 9  YUV 4=
:1:0 */
+#define IPU_PIX_FMT_YVU420P v4l2_fourcc('Y', 'V', '1', '2')    /* 12 YVU 4=
:2:0 */
+#define IPU_PIX_FMT_YUV420P v4l2_fourcc('I', '4', '2', '0')    /* 12 YUV 4=
:2:0 */
+#define IPU_PIX_FMT_YUV420P2 v4l2_fourcc('Y', 'U', '1', '2')   /* 12 YUV 4=
:2:0 */
+#define IPU_PIX_FMT_YVU422P v4l2_fourcc('Y', 'V', '1', '6')    /* 16 YVU 4=
:2:2 */
+#define IPU_PIX_FMT_YUV422P V4L2_PIX_FMT_YUV422P               /* 16 YUV 4=
:2:2 */
+
+/*
+ * Bitfield of Display Interface signal polarities.
+ */
+struct ipu_di_signal_cfg {
+       unsigned datamask_en:1;
+       unsigned ext_clk:1;
+       unsigned interlaced:1;
+       unsigned odd_field_first:1;
+       unsigned clksel_en:1;
+       unsigned clkidle_en:1;
+       unsigned data_pol:1;    /* true =3D inverted */
+       unsigned clk_pol:1;     /* true =3D rising edge */
+       unsigned enable_pol:1;
+       unsigned Hsync_pol:1;   /* true =3D active high */
+       unsigned Vsync_pol:1;
+
+       u16 width;
+       u16 height;
+       u32 pixel_fmt;
+       u16 h_start_width;
+       u16 h_sync_width;
+       u16 h_end_width;
+       u16 v_start_width;
+       u16 v_sync_width;
+       u16 v_end_width;
+       u32 v_to_h_sync;
+};
+
+typedef enum {
+       RGB,
+       YCbCr,
+       YUV
+} ipu_color_space_t;
+
+#define IPU_IRQ_EOF(channel)           (channel)               /* 0 .. 63 =
*/
+#define IPU_IRQ_NFACK(channel)         ((channel) + 64)        /* 64 .. 12=
7 */
+#define IPU_IRQ_NFB4EOF(channel)       ((channel) + 128)       /* 128 .. 1=
91 */
+#define IPU_IRQ_EOS(channel)           ((channel) + 192)       /* 192 .. 2=
55 */
+
+#define IPU_IRQ_DP_SF_START            (448 + 2)
+#define IPU_IRQ_DP_SF_END              (448 + 3)
+#define IPU_IRQ_BG_SF_END              IPU_IRQ_DP_SF_END,
+#define IPU_IRQ_DC_FC_0                        (448 + 8)
+#define IPU_IRQ_DC_FC_1                        (448 + 9)
+#define IPU_IRQ_DC_FC_2                        (448 + 10)
+#define IPU_IRQ_DC_FC_3                        (448 + 11)
+#define IPU_IRQ_DC_FC_4                        (448 + 12)
+#define IPU_IRQ_DC_FC_6                        (448 + 13)
+#define IPU_IRQ_VSYNC_PRE_0            (448 + 14)
+#define IPU_IRQ_VSYNC_PRE_1            (448 + 15)
+
+#define IPU_IRQ_COUNT  (15 * 32)
+
+#define DECLARE_IPU_IRQ_BITMAP(name)   DECLARE_BITMAP(name, IPU_IRQ_COUNT)
+
+struct ipu_irq_handler {
+       struct list_head        list;
+       void                    (*handler)(unsigned long *, void *);
+       void                    *context;
+       DECLARE_IPU_IRQ_BITMAP(ipu_irqs);
+};
+
+int ipu_irq_add_handler(struct ipu_irq_handler *ipuirq);
+void ipu_irq_remove_handler(struct ipu_irq_handler *handler);
+int ipu_irq_update_handler(struct ipu_irq_handler *handler,
+               unsigned long *bitmap);
+int ipu_wait_for_interrupt(int interrupt, int timeout_ms);
+
+struct ipu_channel;
+
+/*
+ * IPU Image DMA Controller (idmac) functions
+ */
+struct ipu_channel *ipu_idmac_get(unsigned channel);
+void ipu_idmac_put(struct ipu_channel *);
+int ipu_idmac_init_channel_buffer(struct ipu_channel *channel,
+                               u32 pixel_fmt,
+                               u16 width, u16 height,
+                               u32 stride,
+                               ipu_rotate_mode_t rot_mode,
+                               dma_addr_t phyaddr_0, dma_addr_t phyaddr_1,
+                               u32 u_offset, u32 v_offset, bool interlaced=
);
+
+int ipu_idmac_update_channel_buffer(struct ipu_channel *channel,
+                                 u32 bufNum, dma_addr_t phyaddr);
+
+int ipu_idmac_enable_channel(struct ipu_channel *channel);
+int ipu_idmac_disable_channel(struct ipu_channel *channel);
+
+void ipu_idmac_set_double_buffer(struct ipu_channel *channel, bool doubleb=
uffer);
+void ipu_idmac_select_buffer(struct ipu_channel *channel, u32 buf_num);
+
+/*
+ * IPU Display Controller (dc) functions
+ */
+int ipu_dc_init_sync(int dc_chan, int di, bool interlaced, u32 pixel_fmt, =
u32 width);
+void ipu_dc_init_async(int dc_chan, int di, bool interlaced);
+void ipu_dc_enable_channel(u32 dc_chan);
+void ipu_dc_disable_channel(u32 dc_chan);
+
+/*
+ * IPU Display Interface (di) functions
+ */
+int ipu_di_disable(int disp);
+int ipu_di_enable(int disp);
+int ipu_di_init_sync_panel(int disp, u32 pixel_clk,
+               struct ipu_di_signal_cfg *sig);
+
+/*
+ * IPU Display Multi FIFO Controller (dmfc) functions
+ */
+struct dmfc_channel;
+int ipu_dmfc_enable_channel(struct dmfc_channel *dmfc);
+void ipu_dmfc_disable_channel(struct dmfc_channel *dmfc);
+int ipu_dmfc_alloc_bandwidth(struct dmfc_channel *dmfc, unsigned long band=
width_mbs);
+void ipu_dmfc_free_bandwidth(struct dmfc_channel *dmfc);
+int ipu_dmfc_init_channel(struct dmfc_channel *dmfc, int width);
+struct dmfc_channel *ipu_dmfc_get(int ipu_channel);
+void ipu_dmfc_put(struct dmfc_channel *dmfc);
+
+/*
+ * IPU Display Processor (dp) functions
+ */
+#define IPU_DP_FLOW_SYNC       0
+#define IPU_DP_FLOW_ASYNC0     1
+#define IPU_DP_FLOW_ASYNC1     2
+
+struct ipu_dp *ipu_dp_get(unsigned int flow);
+void ipu_dp_put(struct ipu_dp *);
+int ipu_dp_enable_channel(struct ipu_dp *dp);
+void ipu_dp_disable_channel(struct ipu_dp *dp);
+void ipu_dp_enable_fg(struct ipu_dp *dp);
+void ipu_dp_disable_fg(struct ipu_dp *dp);
+int ipu_dp_setup_channel(struct ipu_dp *dp, u32 in_pixel_fmt,
+                u32 out_pixel_fmt, int bg);
+int ipu_dp_set_window_pos(struct ipu_dp *, u16 x_pos, u16 y_pos);
+int ipu_dp_set_color_key(struct ipu_dp *dp, bool enable, u32 colorKey);
+int ipu_dp_set_global_alpha(struct ipu_dp *dp, bool enable, u8 alpha,
+               bool bg_chan);
+
+#endif
--
1.7.2.3

--
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
the body of a message to majordomo@vger.kernel.org<mailto:majordomo@vger.ke=
rnel.org>
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/


--_000_33F32152BE7EC740BC2C838D2836AC8704A9A0039SN1MPN1002039d_
Content-Disposition: attachment; filename="winmail.dat"
Content-Transfer-Encoding: base64
Content-Type: application/ms-tnef; name="winmail.dat"

eJ8+IqIEAQaQCAAEAAAAAAABAAEAAQeQBgAIAAAA5AQAAAAAAADoAAEJgAEAIQAAADcxQTFBNzhD
RkI1QUM3NDRBNzZCQ0IyRjQ2OUFBOUNEAH8HAQ2ABAACAAAAAgACAAEFgAMADgAAANoHDAAOAAwA
AgAMAAIAFwEBIIADAA4AAADaBwwADgAMAAAAJgACAC8BAQiABwAYAAAASVBNLk1pY3Jvc29mdCBN
YWlsLk5vdGUAMQgBBIABACcAAABSRTogW1BBVENIIDMvOV0gQWRkIGEgbWZkIElQVXYzIGRyaXZl
cgA4CwEDkAYAYCkDAIAAAAACAX8AAQAAAEsAAAA8MzNGMzIxNTJCRTdFQzc0MEJDMkM4MzhEMjgz
NkFDODcwNEE5QTBAMDM5LVNOMU1QTjEtMDAyLjAzOWQubWdkLm1zZnQubmV0PgAAAgETEAEAAAB2
FAMAPGh0bWwgeG1sbnM6dj0idXJuOnNjaGVtYXMtbWljcm9zb2Z0LWNvbTp2bWwiIHhtbG5zOm89
InVybjpzY2hlbWFzLW1pY3Jvc29mdC1jb206b2ZmaWNlOm9mZmljZSIgeG1sbnM6dz0idXJuOnNj
aGVtYXMtbWljcm9zb2Z0LWNvbTpvZmZpY2U6d29yZCIgeG1sbnM6bT0iaHR0cDovL3NjaGVtYXMu
bWljcm9zb2Z0LmNvbS9vZmZpY2UvMjAwNC8xMi9vbW1sIiB4bWxucz0iaHR0cDovL3d3dy53My5v
cmcvVFIvUkVDLWh0bWw0MCI+PGhlYWQ+PE1FVEEgSFRUUC1FUVVJVj0iQ29udGVudC1UeXBlIiBD
T05URU5UPSJ0ZXh0L2h0bWw7IGNoYXJzZXQ9dXMtYXNjaWkiPjxtZXRhIG5hbWU9R2VuZXJhdG9y
IGNvbnRlbnQ9Ik1pY3Jvc29mdCBXb3JkIDEyIChmaWx0ZXJlZCBtZWRpdW0pIj48c3R5bGU+PCEt
LQ0KLyogRm9udCBEZWZpbml0aW9ucyAqLw0KQGZvbnQtZmFjZQ0KCXtmb250LWZhbWlseTpTaW1T
dW47DQoJcGFub3NlLTE6MiAxIDYgMCAzIDEgMSAxIDEgMTt9DQpAZm9udC1mYWNlDQoJe2ZvbnQt
ZmFtaWx5OlNpbVN1bjsNCglwYW5vc2UtMToyIDEgNiAwIDMgMSAxIDEgMSAxO30NCkBmb250LWZh
Y2UNCgl7Zm9udC1mYW1pbHk6Q2FsaWJyaTsNCglwYW5vc2UtMToyIDE1IDUgMiAyIDIgNCAzIDIg
NDt9DQpAZm9udC1mYWNlDQoJe2ZvbnQtZmFtaWx5OiJDb21pYyBTYW5zIE1TIjsNCglwYW5vc2Ut
MTozIDE1IDcgMiAzIDMgMiAyIDIgNDt9DQpAZm9udC1mYWNlDQoJe2ZvbnQtZmFtaWx5OlNpbVN1
bjsNCglwYW5vc2UtMToyIDEgNiAwIDMgMSAxIDEgMSAxO30NCi8qIFN0eWxlIERlZmluaXRpb25z
ICovDQpwLk1zb05vcm1hbCwgbGkuTXNvTm9ybWFsLCBkaXYuTXNvTm9ybWFsDQoJe21hcmdpbjow
aW47DQoJbWFyZ2luLWJvdHRvbTouMDAwMXB0Ow0KCWZvbnQtc2l6ZToxMi4wcHQ7DQoJZm9udC1m
YW1pbHk6IlRpbWVzIE5ldyBSb21hbiIsInNlcmlmIjt9DQphOmxpbmssIHNwYW4uTXNvSHlwZXJs
aW5rDQoJe21zby1zdHlsZS1wcmlvcml0eTo5OTsNCgljb2xvcjpibHVlOw0KCXRleHQtZGVjb3Jh
dGlvbjp1bmRlcmxpbmU7fQ0KYTp2aXNpdGVkLCBzcGFuLk1zb0h5cGVybGlua0ZvbGxvd2VkDQoJ
e21zby1zdHlsZS1wcmlvcml0eTo5OTsNCgljb2xvcjpwdXJwbGU7DQoJdGV4dC1kZWNvcmF0aW9u
OnVuZGVybGluZTt9DQpzcGFuLkVtYWlsU3R5bGUxNw0KCXttc28tc3R5bGUtdHlwZTpwZXJzb25h
bDsNCglmb250LWZhbWlseToiQ2FsaWJyaSIsInNhbnMtc2VyaWYiOw0KCWNvbG9yOiMxRjQ5N0Q7
fQ0Kc3Bhbi5FbWFpbFN0eWxlMTgNCgl7bXNvLXN0eWxlLXR5cGU6cGVyc29uYWwtcmVwbHk7DQoJ
Zm9udC1mYW1pbHk6IkNhbGlicmkiLCJzYW5zLXNlcmlmIjsNCgljb2xvcjojMUY0OTdEO30NCi5N
c29DaHBEZWZhdWx0DQoJe21zby1zdHlsZS10eXBlOmV4cG9ydC1vbmx5Ow0KCWZvbnQtc2l6ZTox
MC4wcHQ7fQ0KQHBhZ2UgV29yZFNlY3Rpb24xDQoJe3NpemU6OC41aW4gMTEuMGluOw0KCW1hcmdp
bjoxLjBpbiAxLjI1aW4gMS4waW4gMS4yNWluO30NCmRpdi5Xb3JkU2VjdGlvbjENCgl7cGFnZTpX
b3JkU2VjdGlvbjE7fQ0KLS0+PC9zdHlsZT48IS0tW2lmIGd0ZSBtc28gOV0+PHhtbD4NCjxvOnNo
YXBlZGVmYXVsdHMgdjpleHQ9ImVkaXQiIHNwaWRtYXg9IjEwMjYiIC8+DQo8L3htbD48IVtlbmRp
Zl0tLT48IS0tW2lmIGd0ZSBtc28gOV0+PHhtbD4NCjxvOnNoYXBlbGF5b3V0IHY6ZXh0PSJlZGl0
Ij4NCjxvOmlkbWFwIHY6ZXh0PSJlZGl0IiBkYXRhPSIxIiAvPg0KPC9vOnNoYXBlbGF5b3V0Pjwv
eG1sPjwhW2VuZGlmXS0tPjwvaGVhZD48Ym9keSBsYW5nPUVOLVVTIGxpbms9Ymx1ZSB2bGluaz1w
dXJwbGU+PGRpdiBjbGFzcz1Xb3JkU2VjdGlvbjE+PHAgY2xhc3M9TXNvTm9ybWFsPjxzcGFuIHN0
eWxlPSdmb250LXNpemU6MTEuMHB0O2ZvbnQtZmFtaWx5OiJDYWxpYnJpIiwic2Fucy1zZXJpZiI7
Y29sb3I6IzFGNDk3RCc+SGksIFNhc2NoYSw8bzpwPjwvbzpwPjwvc3Bhbj48L3A+PHAgY2xhc3M9
TXNvTm9ybWFsPjxzcGFuIHN0eWxlPSdmb250LXNpemU6MTEuMHB0O2ZvbnQtZmFtaWx5OiJDYWxp
YnJpIiwic2Fucy1zZXJpZiI7Y29sb3I6IzFGNDk3RCc+PG86cD4mbmJzcDs8L286cD48L3NwYW4+
PC9wPjxwIGNsYXNzPU1zb05vcm1hbD48c3BhbiBzdHlsZT0nZm9udC1zaXplOjExLjBwdDtmb250
LWZhbWlseToiQ2FsaWJyaSIsInNhbnMtc2VyaWYiO2NvbG9yOiMxRjQ5N0QnPk15IGNvbGxlYWd1
ZSBZaW5nIGhhcyBnaXZlIHlvdSBtYW55IHZhbHVhYmxlIGNvbW1lbnRzLCBJIGhhdmUgZmV3IG5l
dyBjb21tZW50cyBpbi1saW5lIGJlbG93IHdpdGggW0phc29uXTo8bzpwPjwvbzpwPjwvc3Bhbj48
L3A+PHAgY2xhc3M9TXNvTm9ybWFsPjxzcGFuIHN0eWxlPSdmb250LXNpemU6MTEuMHB0O2ZvbnQt
ZmFtaWx5OiJDYWxpYnJpIiwic2Fucy1zZXJpZiI7Y29sb3I6IzFGNDk3RCc+PG86cD4mbmJzcDs8
L286cD48L3NwYW4+PC9wPjxkaXY+PHAgY2xhc3M9TXNvTm9ybWFsIHN0eWxlPSdtc28tbWFyZ2lu
LXRvcC1hbHQ6YXV0bzttc28tbWFyZ2luLWJvdHRvbS1hbHQ6YXV0byc+PGI+PHNwYW4gc3R5bGU9
J2ZvbnQtc2l6ZToxMC4wcHQ7Zm9udC1mYW1pbHk6IkNvbWljIFNhbnMgTVMiO2NvbG9yOmJsYWNr
Jz5KYXNvbiBDaGVuIC8gQ2hlbiA8L3NwYW4+PC9iPjxiPjxzcGFuIHN0eWxlPSdmb250LXNpemU6
MTAuMHB0O2ZvbnQtZmFtaWx5OiJDb21pYyBTYW5zIE1TIjtjb2xvcjpibGFjayc+SmllPC9zcGFu
PjwvYj48c3BhbiBzdHlsZT0nZm9udC1mYW1pbHk6IkFyaWFsIiwic2Fucy1zZXJpZiI7Y29sb3I6
IzFGNDk3RCc+PG86cD48L286cD48L3NwYW4+PC9wPjxwIGNsYXNzPU1zb05vcm1hbCBzdHlsZT0n
bXNvLW1hcmdpbi10b3AtYWx0OmF1dG87bXNvLW1hcmdpbi1ib3R0b20tYWx0OmF1dG8nPjxiPjxz
cGFuIHN0eWxlPSdmb250LXNpemU6MTAuMHB0O2ZvbnQtZmFtaWx5OiJDb21pYyBTYW5zIE1TIjtj
b2xvcjpibGFjayc+Tk1HIC8gTUFEPC9zcGFuPjwvYj48c3BhbiBzdHlsZT0nZm9udC1mYW1pbHk6
U2ltU3VuO2NvbG9yOm5hdnknPjxvOnA+PC9vOnA+PC9zcGFuPjwvcD48cCBjbGFzcz1Nc29Ob3Jt
YWwgc3R5bGU9J21zby1tYXJnaW4tdG9wLWFsdDphdXRvO21zby1tYXJnaW4tYm90dG9tLWFsdDph
dXRvJz48Yj48c3BhbiBzdHlsZT0nZm9udC1zaXplOjEwLjBwdDtmb250LWZhbWlseToiQXJpYWwi
LCJzYW5zLXNlcmlmIjtjb2xvcjpibGFjayc+RnJlZXNjYWxlIFNlbWljb25kdWN0b3IgKENoaW5h
KSBMdGQuPC9zcGFuPjwvYj48Yj48c3BhbiBzdHlsZT0nZm9udC1zaXplOjEwLjBwdDtmb250LWZh
bWlseToiQXJpYWwiLCJzYW5zLXNlcmlmIjtjb2xvcjpibGFjayc+PG86cD48L286cD48L3NwYW4+
PC9iPjwvcD48cCBjbGFzcz1Nc29Ob3JtYWwgc3R5bGU9J21zby1tYXJnaW4tdG9wLWFsdDphdXRv
O21zby1tYXJnaW4tYm90dG9tLWFsdDphdXRvJz48Yj48c3BhbiBzdHlsZT0nZm9udC1zaXplOjEw
LjBwdDtmb250LWZhbWlseToiQXJpYWwiLCJzYW5zLXNlcmlmIjtjb2xvcjpibGFjayc+MkYsIEJ1
aWxkaW5nIEIsIDE3NyMsIEJpIEJvIFJkPG86cD48L286cD48L3NwYW4+PC9iPjwvcD48cCBjbGFz
cz1Nc29Ob3JtYWwgc3R5bGU9J21zby1tYXJnaW4tdG9wLWFsdDphdXRvO21zby1tYXJnaW4tYm90
dG9tLWFsdDphdXRvJz48Yj48c3BhbiBzdHlsZT0nZm9udC1zaXplOjEwLjBwdDtmb250LWZhbWls
eToiQXJpYWwiLCJzYW5zLXNlcmlmIjtjb2xvcjpibGFjayc+UHU8L3NwYW4+PC9iPjxiPjxzcGFu
IHN0eWxlPSdmb250LXNpemU6MTAuMHB0O2ZvbnQtZmFtaWx5OiJBcmlhbCIsInNhbnMtc2VyaWYi
O2NvbG9yOmJsYWNrJz4gRG9uZyBOZXcgRGlzdHJpY3QgU2hhbmdoYWkmbmJzcDsyMDEyMDM8bzpw
PjwvbzpwPjwvc3Bhbj48L2I+PC9wPjxwIGNsYXNzPU1zb05vcm1hbCBzdHlsZT0nbXNvLW1hcmdp
bi10b3AtYWx0OmF1dG87bXNvLW1hcmdpbi1ib3R0b20tYWx0OmF1dG8nPjxiPjxzcGFuIHN0eWxl
PSdmb250LXNpemU6MTAuMHB0O2ZvbnQtZmFtaWx5OiJDb21pYyBTYW5zIE1TIjtjb2xvcjpibGFj
ayc+VGVsOiZuYnNwOyZuYnNwOyZuYnNwOyZuYnNwOyAwMjEtMjg5MzcxNzgmbmJzcDs8bzpwPjwv
bzpwPjwvc3Bhbj48L2I+PC9wPjxwIGNsYXNzPU1zb05vcm1hbCBzdHlsZT0nbXNvLW1hcmdpbi10
b3AtYWx0OmF1dG87bXNvLW1hcmdpbi1ib3R0b20tYWx0OmF1dG8nPjxiPjxzcGFuIHN0eWxlPSdm
b250LXNpemU6MTAuMHB0O2ZvbnQtZmFtaWx5OiJDb21pYyBTYW5zIE1TIjtjb2xvcjpibGFjayc+
RmF4OiZuYnNwOyZuYnNwOyZuYnNwOyZuYnNwOyAwMjEtMjg5Mzc0NDQ8L3NwYW4+PC9iPjxzcGFu
IHN0eWxlPSdmb250LWZhbWlseTpTaW1TdW47Y29sb3I6IzFGNDk3RCc+PG86cD48L286cD48L3Nw
YW4+PC9wPjxwIGNsYXNzPU1zb05vcm1hbCBzdHlsZT0nbXNvLW1hcmdpbi10b3AtYWx0OmF1dG87
bXNvLW1hcmdpbi1ib3R0b20tYWx0OmF1dG8nPjxiPjxzcGFuIHN0eWxlPSdmb250LXNpemU6MTAu
MHB0O2ZvbnQtZmFtaWx5OiJDb21pYyBTYW5zIE1TIjtjb2xvcjpibGFjayc+RS1tYWlsOiZuYnNw
OyZuYnNwOzwvc3Bhbj48L2I+PGI+PHNwYW4gc3R5bGU9J2ZvbnQtc2l6ZToxMC4wcHQ7Zm9udC1m
YW1pbHk6IkNvbWljIFNhbnMgTVMiO2NvbG9yOmJsdWUnPjxhIGhyZWY9Im1haWx0bzpKYXNvbi5D
aGVuQGZyZWVzY2FsZS5jb20iIHRpdGxlPSJtYWlsdG86SmFzb24uQ2hlbkBmcmVlc2NhbGUuY29t
Ij5KYXNvbi5DaGVuQGZyZWVzY2FsZS5jb208L2E+PC9zcGFuPjwvYj48Yj48c3BhbiBzdHlsZT0n
Zm9udC1mYW1pbHk6U2ltU3VuO2NvbG9yOmJsYWNrJz48bzpwPjwvbzpwPjwvc3Bhbj48L2I+PC9w
PjwvZGl2PjxkaXY+PHAgY2xhc3M9TXNvTm9ybWFsPi0tLS0tLS0tLS0gRm9yd2FyZGVkIG1lc3Nh
Z2UgLS0tLS0tLS0tLTxicj5Gcm9tOiA8Yj5TYXNjaGEgSGF1ZXI8L2I+ICZsdDs8YSBocmVmPSJt
YWlsdG86cy5oYXVlckBwZW5ndXRyb25peC5kZSI+cy5oYXVlckBwZW5ndXRyb25peC5kZTwvYT4m
Z3Q7PGJyPkRhdGU6IDIwMTAvMTIvOTxicj5TdWJqZWN0OiBbUEFUQ0ggMy85XSBBZGQgYSBtZmQg
SVBVdjMgZHJpdmVyPGJyPlRvOiA8YSBocmVmPSJtYWlsdG86bGludXgtYXJtLWtlcm5lbEBsaXN0
cy5pbmZyYWRlYWQub3JnIj5saW51eC1hcm0ta2VybmVsQGxpc3RzLmluZnJhZGVhZC5vcmc8L2E+
PGJyPkNjOiA8YSBocmVmPSJtYWlsdG86bGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZyI+bGlu
dXgta2VybmVsQHZnZXIua2VybmVsLm9yZzwvYT4sIDxhIGhyZWY9Im1haWx0bzpsaW51eC1mYmRl
dkB2Z2VyLmtlcm5lbC5vcmciPmxpbnV4LWZiZGV2QHZnZXIua2VybmVsLm9yZzwvYT4sIFpoYW5n
IExpbHktUjU4MDY2ICZsdDs8YSBocmVmPSJtYWlsdG86cjU4MDY2QGZyZWVzY2FsZS5jb20iPnI1
ODA2NkBmcmVlc2NhbGUuY29tPC9hPiZndDssIEFybmF1ZCBQYXRhcmQgJmx0OzxhIGhyZWY9Im1h
aWx0bzphcm5hdWQucGF0YXJkQHJ0cC1uZXQub3JnIj5hcm5hdWQucGF0YXJkQHJ0cC1uZXQub3Jn
PC9hPiZndDssIFNhc2NoYSBIYXVlciAmbHQ7PGEgaHJlZj0ibWFpbHRvOnMuaGF1ZXJAcGVuZ3V0
cm9uaXguZGUiPnMuaGF1ZXJAcGVuZ3V0cm9uaXguZGU8L2E+Jmd0Ozxicj48YnI+PGJyPlRoZSBJ
UFUgaXMgdGhlIEltYWdlIFByb2Nlc3NpbmcgVW5pdCBmb3VuZCBvbiBpLk1YNTAvNTEvNTMgU29D
cy4gSXQ8YnI+ZmVhdHVyZXMgc2V2ZXJhbCB1bml0cyBmb3IgaW1hZ2UgcHJvY2Vzc2luZywgdGhp
cyBwYXRjaCBhZGRzIHN1cHBvcnQ8YnI+Zm9yIHRoZSB1bml0cyBuZWVkZWQgZm9yIEZyYW1lYnVm
ZmVyIHN1cHBvcnQsIG5hbWVseTo8YnI+PGJyPi0gRGlzcGxheSBDb250cm9sbGVyIChkYyk8YnI+
LSBEaXNwbGF5IEludGVyZmFjZSAoZGkpPGJyPi0gRGlzcGxheSBNdWx0aSBGaWZvIENvbnRyb2xs
ZXIgKGRtZmMpPGJyPi0gRGlzcGxheSBQcm9jZXNzb3IgKGRwKTxicj4tIEltYWdlIERNQSBDb250
cm9sbGVyIChpZG1hYyk8YnI+PGJyPlRoaXMgcGF0Y2ggaXMgYmFzZWQgb24gdGhlIEZyZWVzY2Fs
ZSBkcml2ZXIsIGJ1dCBmb2xsb3dzIGEgZGlmZmVyZW50PGJyPmFwcHJvYWNoLiBUaGUgRnJlZXNj
YWxlIGNvZGUgaW1wbGVtZW50cyBsb2dpY2FsIGlkbWFjIGNoYW5uZWxzIGFuZDxicj50aGUgaGFu
ZGxpbmcgb2YgdGhlIHN1YnVuaXRzIGlzIGhpZGRlbiBpbiBjb21tb24gaWRtYWMgY29kZSBwYXRo
ZXM8YnI+aW4gYmlnIHN3aXRjaC9jYXNlIHN0YXRlbWVudHMuIFRoaXMgcGF0Y2ggaW5zdGVhZCBq
dXN0IHByb3ZpZGVzIGNvZGU8YnI+YW5kIHJlc291cmNlIG1hbmFnZW1lbnQgZm9yIHRoZSBkaWZm
ZXJlbnQgc3VidW5pdHMuIFRoZSB1c2VyLCBpbiB0aGlzPGJyPmNhc2UgdGhlIGZyYW1lYnVmZmVy
IGRyaXZlciwgZGVjaWRlcyBob3cgdGhlIGRpZmZlcmVudCB1bml0cyBwbGF5PGJyPnRvZ2V0aGVy
Ljxicj48YnI+VGhlIElQVSBoYXMgb3RoZXIgdW5pdHMgbWlzc2luZyBpbiB0aGlzIHBhdGNoOjxi
cj48YnI+LSBDTU9TIFNlbnNvciBJbnRlcmZhY2UgKGNzaSk8YnI+LSBWaWRlbyBEZWludGVybGFj
ZXIgKHZkaSk8YnI+LSBTZW5zb3IgTXVsdGkgRklGTyBDb250cm9sZXIgKHNtZmMpPGJyPi0gSW1h
Z2UgQ29udmVydGVyIChpYyk8YnI+LSBJbWFnZSBSb3RhdG9yIChpcnQpPGJyPjxicj5TbyBleHBl
Y3QgbW9yZSBmaWxlcyB0byBjb21lIGluIHRoaXMgZGlyZWN0b3J5Ljxicj48YnI+U2lnbmVkLW9m
Zi1ieTogU2FzY2hhIEhhdWVyICZsdDs8YSBocmVmPSJtYWlsdG86cy5oYXVlckBwZW5ndXRyb25p
eC5kZSI+cy5oYXVlckBwZW5ndXRyb25peC5kZTwvYT4mZ3Q7PGJyPi0tLTxicj4mbmJzcDthcmNo
L2FybS9wbGF0LW14Yy9pbmNsdWRlL21hY2gvaXB1LXYzLmggfCAmbmJzcDsgNDggKysrPGJyPiZu
YnNwO2RyaXZlcnMvbWZkL0tjb25maWcgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNw
OyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7IHwgJm5ic3A7ICZuYnNwOzcgKzxi
cj4mbmJzcDtkcml2ZXJzL21mZC9NYWtlZmlsZSAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsg
Jm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDt8ICZuYnNwOyAmbmJzcDsx
ICs8YnI+Jm5ic3A7ZHJpdmVycy9tZmQvaW14LWlwdS12My9NYWtlZmlsZSAmbmJzcDsgJm5ic3A7
ICZuYnNwOyAmbmJzcDsgfCAmbmJzcDsgJm5ic3A7MyArPGJyPiZuYnNwO2RyaXZlcnMvbWZkL2lt
eC1pcHUtdjMvaXB1LWNvbW1vbi5jICZuYnNwOyAmbmJzcDsgfCAmbmJzcDs2NjEgKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKzxicj4mbmJzcDtkcml2ZXJzL21mZC9pbXgtaXB1LXYzL2lw
dS1jcG1lbS5jICZuYnNwOyAmbmJzcDsgJm5ic3A7fCAmbmJzcDs2MDggKysrKysrKysrKysrKysr
KysrKysrKysrKysrKzxicj4mbmJzcDtkcml2ZXJzL21mZC9pbXgtaXB1LXYzL2lwdS1kYy5jICZu
YnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyB8ICZuYnNwOzM2MiArKysrKysrKysrKysrKysrKzxi
cj4mbmJzcDtkcml2ZXJzL21mZC9pbXgtaXB1LXYzL2lwdS1kaS5jICZuYnNwOyAmbmJzcDsgJm5i
c3A7ICZuYnNwOyB8ICZuYnNwOzUwNyArKysrKysrKysrKysrKysrKysrKysrKys8YnI+Jm5ic3A7
ZHJpdmVycy9tZmQvaW14LWlwdS12My9pcHUtZG1mYy5jICZuYnNwOyAmbmJzcDsgJm5ic3A7IHwg
Jm5ic3A7MzQzICsrKysrKysrKysrKysrKys8YnI+Jm5ic3A7ZHJpdmVycy9tZmQvaW14LWlwdS12
My9pcHUtZHAuYyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgfCAmbmJzcDs0NjggKysrKysr
KysrKysrKysrKysrKysrKzxicj4mbmJzcDtkcml2ZXJzL21mZC9pbXgtaXB1LXYzL2lwdS1wcnYu
aCAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDt8ICZuYnNwOzIxNCArKysrKysrKysrPGJyPiZu
YnNwO2luY2x1ZGUvbGludXgvbWZkL2lteC1pcHUtdjMuaCAmbmJzcDsgJm5ic3A7ICZuYnNwOyAm
bmJzcDsgJm5ic3A7fCAmbmJzcDsyMTggKysrKysrKysrKzxicj4mbmJzcDsxMiBmaWxlcyBjaGFu
Z2VkLCAzNDQwIGluc2VydGlvbnMoKyksIDAgZGVsZXRpb25zKC0pPGJyPiZuYnNwO2NyZWF0ZSBt
b2RlIDEwMDY0NCBhcmNoL2FybS9wbGF0LW14Yy9pbmNsdWRlL21hY2gvaXB1LXYzLmg8YnI+Jm5i
c3A7Y3JlYXRlIG1vZGUgMTAwNjQ0IGRyaXZlcnMvbWZkL2lteC1pcHUtdjMvTWFrZWZpbGU8YnI+
Jm5ic3A7Y3JlYXRlIG1vZGUgMTAwNjQ0IGRyaXZlcnMvbWZkL2lteC1pcHUtdjMvaXB1LWNvbW1v
bi5jPGJyPiZuYnNwO2NyZWF0ZSBtb2RlIDEwMDY0NCBkcml2ZXJzL21mZC9pbXgtaXB1LXYzL2lw
dS1jcG1lbS5jPGJyPiZuYnNwO2NyZWF0ZSBtb2RlIDEwMDY0NCBkcml2ZXJzL21mZC9pbXgtaXB1
LXYzL2lwdS1kYy5jPGJyPiZuYnNwO2NyZWF0ZSBtb2RlIDEwMDY0NCBkcml2ZXJzL21mZC9pbXgt
aXB1LXYzL2lwdS1kaS5jPGJyPiZuYnNwO2NyZWF0ZSBtb2RlIDEwMDY0NCBkcml2ZXJzL21mZC9p
bXgtaXB1LXYzL2lwdS1kbWZjLmM8YnI+Jm5ic3A7Y3JlYXRlIG1vZGUgMTAwNjQ0IGRyaXZlcnMv
bWZkL2lteC1pcHUtdjMvaXB1LWRwLmM8YnI+Jm5ic3A7Y3JlYXRlIG1vZGUgMTAwNjQ0IGRyaXZl
cnMvbWZkL2lteC1pcHUtdjMvaXB1LXBydi5oPGJyPiZuYnNwO2NyZWF0ZSBtb2RlIDEwMDY0NCBp
bmNsdWRlL2xpbnV4L21mZC9pbXgtaXB1LXYzLmg8YnI+PGJyPmRpZmYgLS1naXQgYS9hcmNoL2Fy
bS9wbGF0LW14Yy9pbmNsdWRlL21hY2gvaXB1LXYzLmggYi9hcmNoL2FybS9wbGF0LW14Yy9pbmNs
dWRlL21hY2gvaXB1LXYzLmg8YnI+bmV3IGZpbGUgbW9kZSAxMDA2NDQ8YnI+aW5kZXggMDAwMDAw
MC4uMGE2YzNlODxicj4tLS0gL2Rldi9udWxsPGJyPisrKyBiL2FyY2gvYXJtL3BsYXQtbXhjL2lu
Y2x1ZGUvbWFjaC9pcHUtdjMuaDxicj5AQCAtMCwwICsxLDQ4IEBAPGJyPisvKjxicj4rICogQ29w
eXJpZ2h0IChjKSAyMDEwIFNhc2NoYSBIYXVlciAmbHQ7PGEgaHJlZj0ibWFpbHRvOnMuaGF1ZXJA
cGVuZ3V0cm9uaXguZGUiPnMuaGF1ZXJAcGVuZ3V0cm9uaXguZGU8L2E+Jmd0Ozxicj4rICo8YnI+
KyAqIFRoaXMgcHJvZ3JhbSBpcyBmcmVlIHNvZnR3YXJlOyB5b3UgY2FuIHJlZGlzdHJpYnV0ZSBp
dCBhbmQvb3IgbW9kaWZ5IGl0PGJyPisgKiB1bmRlciB0aGUgdGVybXMgb2YgdGhlIEdOVSBHZW5l
cmFsIFB1YmxpYyBMaWNlbnNlIGFzIHB1Ymxpc2hlZCBieSB0aGU8YnI+KyAqIEZyZWUgU29mdHdh
cmUgRm91bmRhdGlvbjsgZWl0aGVyIHZlcnNpb24gMiBvZiB0aGUgTGljZW5zZSwgb3IgKGF0IHlv
dXI8YnI+KyAqIG9wdGlvbikgYW55IGxhdGVyIHZlcnNpb24uPGJyPisgKjxicj4rICogVGhpcyBw
cm9ncmFtIGlzIGRpc3RyaWJ1dGVkIGluIHRoZSBob3BlIHRoYXQgaXQgd2lsbCBiZSB1c2VmdWws
IGJ1dDxicj4rICogV0lUSE9VVCBBTlkgV0FSUkFOVFk7IHdpdGhvdXQgZXZlbiB0aGUgaW1wbGll
ZCB3YXJyYW50eSBvZiBNRVJDSEFOVEFCSUxJVFk8YnI+KyAqIG9yIEZJVE5FU1MgRk9SIEEgUEFS
VElDVUxBUiBQVVJQT1NFLiAmbmJzcDtTZWUgdGhlIEdOVSBHZW5lcmFsIFB1YmxpYyBMaWNlbnNl
PGJyPisgKiBmb3IgbW9yZSBkZXRhaWxzLjxicj4rICovPGJyPis8YnI+KyNpZm5kZWYgX19NQUNI
X0lQVV9WM19IXzxicj4rI2RlZmluZSBfX01BQ0hfSVBVX1YzX0hfPGJyPis8YnI+Ky8qIElQVSBz
cGVjaWZpYyBleHRlbnNpb25zIHRvIHN0cnVjdCBmYl92aWRlb21vZGUgZmxhZyBmaWVsZCAqLzxi
cj4rI2RlZmluZSBGQl9TWU5DX09FX0xPV19BQ1QgJm5ic3A7ICZuYnNwOyAoMSAmbHQ7Jmx0OyA4
KTxicj4rI2RlZmluZSBGQl9TWU5DX0NMS19MQVRfRkFMTCAmbmJzcDsgKDEgJmx0OyZsdDsgOSk8
YnI+KyNkZWZpbmUgRkJfU1lOQ19EQVRBX0lOVkVSVCAmbmJzcDsgJm5ic3A7KDEgJmx0OyZsdDsg
MTApPGJyPisjZGVmaW5lIEZCX1NZTkNfQ0xLX0lETEVfRU4gJm5ic3A7ICZuYnNwOygxICZsdDsm
bHQ7IDExKTxicj4rI2RlZmluZSBGQl9TWU5DX1NIQVJQX01PREUgJm5ic3A7ICZuYnNwOyAoMSAm
bHQ7Jmx0OyAxMik8YnI+KyNkZWZpbmUgRkJfU1lOQ19TV0FQX1JHQiAmbmJzcDsgJm5ic3A7ICZu
YnNwOyAoMSAmbHQ7Jmx0OyAxMyk8YnI+Kzxicj4rc3RydWN0IGlwdXYzX2ZiX3BsYXRmb3JtX2Rh
dGEgezxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7IGNvbnN0IHN0cnVjdCBmYl92aWRlb21vZGUg
Jm5ic3A7ICZuYnNwOyAmbmJzcDsgKm1vZGVzOzxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7IGlu
dCAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7
ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7IG51bV9tb2Rlczs8YnI+
KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBjaGFyICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAm
bmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZu
YnNwOyAmbmJzcDsqbW9kZV9zdHI7PGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgdTMyICZuYnNw
OyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7
ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgaW50ZXJmYWNlX3BpeF9mbXQ7PGJy
Pis8YnI+KyNkZWZpbmUgSU1YX0lQVV9GQl9VU0VfTU9ERURCICZuYnNwOygxICZsdDsmbHQ7IDAp
PGJyPisjZGVmaW5lIElNWF9JUFVfRkJfVVNFX09WRVJMQVkgKDEgJmx0OyZsdDsgMSk8YnI+KyAm
bmJzcDsgJm5ic3A7ICZuYnNwOyB1bnNpZ25lZCBsb25nICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZu
YnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7IGZsYWdzOzxicj4rPGJyPisg
Jm5ic3A7ICZuYnNwOyAmbmJzcDsgaW50ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJz
cDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNw
OyAmbmJzcDsgaXB1X2NoYW5uZWxfYmc7PGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgaW50ICZu
YnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5i
c3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgaXB1X2NoYW5uZWxfZmc7PGJy
PisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgaW50ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAm
bmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZu
YnNwOyAmbmJzcDsgZGNfY2hhbm5lbDs8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBpbnQgJm5i
c3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJz
cDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBkcF9jaGFubmVsOzxicj4rfTs8
YnI+Kzxicj4rc3RydWN0IGlteF9pcHV2M19wbGF0Zm9ybV9kYXRhIHs8YnI+KyAmbmJzcDsgJm5i
c3A7ICZuYnNwOyBpbnQgcmV2Ozxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7IHN0cnVjdCBpcHV2
M19mYl9wbGF0Zm9ybV9kYXRhICZuYnNwOyAqZmIwX3BsYXRmb3JtX2RhdGE7PGJyPisgJm5ic3A7
ICZuYnNwOyAmbmJzcDsgc3RydWN0IGlwdXYzX2ZiX3BsYXRmb3JtX2RhdGEgJm5ic3A7ICpmYjFf
cGxhdGZvcm1fZGF0YTs8YnI+K307PGJyPis8YnI+KyNlbmRpZiAvKiBfX01BQ0hfSVBVX1YzX0hf
ICovPGJyPmRpZmYgLS1naXQgYS9kcml2ZXJzL21mZC9LY29uZmlnIGIvZHJpdmVycy9tZmQvS2Nv
bmZpZzxicj5pbmRleCAzYTE0OTNiLi4zYzgxODc5IDEwMDY0NDxicj4tLS0gYS9kcml2ZXJzL21m
ZC9LY29uZmlnPGJyPisrKyBiL2RyaXZlcnMvbWZkL0tjb25maWc8YnI+QEAgLTYwNiw2ICs2MDYs
MTMgQEAgY29uZmlnIE1GRF9WWDg1NTxicj4mbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5i
c3A7VklBIFZYODU1L1ZYODc1IHNvdXRoIGJyaWRnZS4gWW91IHdpbGwgbmVlZCB0byBlbmFibGUg
dGhlIHZ4ODU1X3NwaTxicj4mbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7YW5kL29y
IHZ4ODU1X2dwaW8gZHJpdmVycyBmb3IgdGhpcyB0byBkbyBhbnl0aGluZyB1c2VmdWwuPGJyPjxi
cj4rY29uZmlnIE1GRF9JTVhfSVBVX1YzPGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgdHJpc3Rh
dGUgJnF1b3Q7U3VwcG9ydCB0aGUgSW1hZ2UgUHJvY2Vzc2luZyBVbml0IChJUFUpIGZvdW5kIG9u
IHRoZSBpLk1YNTEmcXVvdDs8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBkZXBlbmRzIG9uIEFS
Q0hfTVg1MTxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7IHNlbGVjdCBNRkRfQ09SRTxicj4rICZu
YnNwOyAmbmJzcDsgJm5ic3A7IGhlbHA8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsg
U2F5IHllcyBoZXJlIHRvIHN1cHBvcnQgdGhlIElQVSBvbiBpLk1YNTEuPGJyPis8YnI+Jm5ic3A7
ZW5kaWYgIyBNRkRfU1VQUE9SVDxicj48YnI+Jm5ic3A7bWVudSAmcXVvdDtNdWx0aW1lZGlhIENh
cGFiaWxpdGllcyBQb3J0IGRyaXZlcnMmcXVvdDs8YnI+ZGlmZiAtLWdpdCBhL2RyaXZlcnMvbWZk
L01ha2VmaWxlIGIvZHJpdmVycy9tZmQvTWFrZWZpbGU8YnI+aW5kZXggZjU0YjM2NS4uNzg3M2Ix
MyAxMDA2NDQ8YnI+LS0tIGEvZHJpdmVycy9tZmQvTWFrZWZpbGU8YnI+KysrIGIvZHJpdmVycy9t
ZmQvTWFrZWZpbGU8YnI+QEAgLTgxLDMgKzgxLDQgQEAgb2JqLSQoQ09ORklHX01GRF9KQU5aX0NN
T0RJTykgKz0gamFuei1jbW9kaW8ubzxicj4mbmJzcDtvYmotJChDT05GSUdfTUZEX0paNDc0MF9B
REMpICZuYnNwOyArPSBqejQ3NDAtYWRjLm88YnI+Jm5ic3A7b2JqLSQoQ09ORklHX01GRF9UUFM2
NTg2WCkgJm5ic3A7ICZuYnNwOyArPSB0cHM2NTg2eC5vPGJyPiZuYnNwO29iai0kKENPTkZJR19N
RkRfVlg4NTUpICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNw
OyAmbmJzcDsrPSB2eDg1NS5vPGJyPitvYmotJChDT05GSUdfTUZEX0lNWF9JUFVfVjMpICZuYnNw
OyArPSBpbXgtaXB1LXYzLzxicj5kaWZmIC0tZ2l0IGEvZHJpdmVycy9tZmQvaW14LWlwdS12My9N
YWtlZmlsZSBiL2RyaXZlcnMvbWZkL2lteC1pcHUtdjMvTWFrZWZpbGU8YnI+bmV3IGZpbGUgbW9k
ZSAxMDA2NDQ8YnI+aW5kZXggMDAwMDAwMC4uZmY3MGZlODxicj4tLS0gL2Rldi9udWxsPGJyPisr
KyBiL2RyaXZlcnMvbWZkL2lteC1pcHUtdjMvTWFrZWZpbGU8YnI+QEAgLTAsMCArMSwzIEBAPGJy
PitvYmotJChDT05GSUdfTUZEX0lNWF9JUFVfVjMpICs9IGlteC1pcHUtdjMubzxicj4rPGJyPitp
bXgtaXB1LXYzLW9ianMgOj0gaXB1LWNvbW1vbi5vIGlwdS1kYy5vIGlwdS1kaS5vIGlwdS1kcC5v
IGlwdS1kbWZjLm8gaXB1LWNwbWVtLm88YnI+ZGlmZiAtLWdpdCBhL2RyaXZlcnMvbWZkL2lteC1p
cHUtdjMvaXB1LWNvbW1vbi5jIGIvZHJpdmVycy9tZmQvaW14LWlwdS12My9pcHUtY29tbW9uLmM8
YnI+bmV3IGZpbGUgbW9kZSAxMDA2NDQ8YnI+aW5kZXggMDAwMDAwMC4uZTZlZGI4ODxicj4tLS0g
L2Rldi9udWxsPGJyPisrKyBiL2RyaXZlcnMvbWZkL2lteC1pcHUtdjMvaXB1LWNvbW1vbi5jPGJy
PkBAIC0wLDAgKzEsNjYxIEBAPGJyPisvKjxicj4rICogQ29weXJpZ2h0IChjKSAyMDEwIFNhc2No
YSBIYXVlciAmbHQ7PGEgaHJlZj0ibWFpbHRvOnMuaGF1ZXJAcGVuZ3V0cm9uaXguZGUiPnMuaGF1
ZXJAcGVuZ3V0cm9uaXguZGU8L2E+Jmd0Ozxicj4rICogQ29weXJpZ2h0IChDKSAyMDA1LTIwMDkg
RnJlZXNjYWxlIFNlbWljb25kdWN0b3IsIEluYy48YnI+KyAqPGJyPisgKiBUaGlzIHByb2dyYW0g
aXMgZnJlZSBzb2Z0d2FyZTsgeW91IGNhbiByZWRpc3RyaWJ1dGUgaXQgYW5kL29yIG1vZGlmeSBp
dDxicj4rICogdW5kZXIgdGhlIHRlcm1zIG9mIHRoZSBHTlUgR2VuZXJhbCBQdWJsaWMgTGljZW5z
ZSBhcyBwdWJsaXNoZWQgYnkgdGhlPGJyPisgKiBGcmVlIFNvZnR3YXJlIEZvdW5kYXRpb247IGVp
dGhlciB2ZXJzaW9uIDIgb2YgdGhlIExpY2Vuc2UsIG9yIChhdCB5b3VyPGJyPisgKiBvcHRpb24p
IGFueSBsYXRlciB2ZXJzaW9uLjxicj4rICo8YnI+KyAqIFRoaXMgcHJvZ3JhbSBpcyBkaXN0cmli
dXRlZCBpbiB0aGUgaG9wZSB0aGF0IGl0IHdpbGwgYmUgdXNlZnVsLCBidXQ8YnI+KyAqIFdJVEhP
VVQgQU5ZIFdBUlJBTlRZOyB3aXRob3V0IGV2ZW4gdGhlIGltcGxpZWQgd2FycmFudHkgb2YgTUVS
Q0hBTlRBQklMSVRZPGJyPisgKiBvciBGSVRORVNTIEZPUiBBIFBBUlRJQ1VMQVIgUFVSUE9TRS4g
Jm5ic3A7U2VlIHRoZSBHTlUgR2VuZXJhbCBQdWJsaWMgTGljZW5zZTxicj4rICogZm9yIG1vcmUg
ZGV0YWlscy48YnI+KyAqLzxicj4rPGJyPisjaW5jbHVkZSAmbHQ7bGludXgvdHlwZXMuaCZndDs8
YnI+KyNpbmNsdWRlICZsdDtsaW51eC9pbml0LmgmZ3Q7PGJyPisjaW5jbHVkZSAmbHQ7bGludXgv
cGxhdGZvcm1fZGV2aWNlLmgmZ3Q7PGJyPisjaW5jbHVkZSAmbHQ7bGludXgvZXJyLmgmZ3Q7PGJy
PisjaW5jbHVkZSAmbHQ7bGludXgvc3BpbmxvY2suaCZndDs8YnI+KyNpbmNsdWRlICZsdDtsaW51
eC9kZWxheS5oJmd0Ozxicj4rI2luY2x1ZGUgJmx0O2xpbnV4L2ludGVycnVwdC5oJmd0Ozxicj4r
I2luY2x1ZGUgJmx0O2xpbnV4L2lvLmgmZ3Q7PGJyPisjaW5jbHVkZSAmbHQ7bGludXgvbWZkL2lt
eC1pcHUtdjMuaCZndDs8YnI+KyNpbmNsdWRlICZsdDtsaW51eC9jbGsuaCZndDs8YnI+KyNpbmNs
dWRlICZsdDtsaW51eC9saXN0LmgmZ3Q7PGJyPisjaW5jbHVkZSAmbHQ7bWFjaC9jb21tb24uaCZn
dDs8YnI+KyNpbmNsdWRlICZsdDtsaW51eC9tZmQvY29yZS5oJmd0Ozxicj4rI2luY2x1ZGUgJmx0
O21hY2gvaXB1LXYzLmgmZ3Q7PGJyPis8YnI+KyNpbmNsdWRlICZxdW90O2lwdS1wcnYuaCZxdW90
Ozxicj4rPGJyPitzdGF0aWMgc3RydWN0IGNsayAqaXB1X2Nsazs8YnI+K3N0YXRpYyBzdHJ1Y3Qg
ZGV2aWNlICppcHVfZGV2Ozxicj4rPGJyPitzdGF0aWMgREVGSU5FX1NQSU5MT0NLKGlwdV9sb2Nr
KTs8YnI+K3ZvaWQgX19pb21lbSAqaXB1X2NtX3JlZzs8YnI+K3ZvaWQgX19pb21lbSAqaXB1X2lk
bWFjX3JlZzs8YnI+Kzxicj4rc3RhdGljIHN0cnVjdCBpcHVfY2hhbm5lbCBjaGFubmVsc1s2NF07
PGJyPis8YnI+K3N0cnVjdCBpcHVfY2hhbm5lbCAqaXB1X2lkbWFjX2dldCh1bnNpZ25lZCBudW0p
PGJyPit7PGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgc3RydWN0IGlwdV9jaGFubmVsICpjaGFu
bmVsOzxicj4rPGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgZGV2X2RiZyhpcHVfZGV2LCAmcXVv
dDslcyAlZFxuJnF1b3Q7LCBfX2Z1bmNfXywgbnVtKTs8YnI+Kzxicj4rICZuYnNwOyAmbmJzcDsg
Jm5ic3A7IGlmIChudW0gJmd0OyA2Myk8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsg
Jm5ic3A7ICZuYnNwOyAmbmJzcDsgcmV0dXJuIEVSUl9QVFIoLUVOT0RFVik7PGJyPis8YnI+KyAm
bmJzcDsgJm5ic3A7ICZuYnNwOyBjaGFubmVsID0gJmFtcDtjaGFubmVsc1tudW1dOzxicj4rPGJy
PisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgaWYgKGNoYW5uZWwtJmd0O2J1c3kpPGJyPisgJm5ic3A7
ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7IHJldHVybiBFUlJfUFRS
KC1FQlVTWSk7PGJyPis8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBjaGFubmVsLSZndDtidXN5
ID0gMTs8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBjaGFubmVsLSZndDtudW0gPSBudW07PGJy
Pis8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBjbGtfZW5hYmxlKGlwdV9jbGspOzxicj4rPGJy
PisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgcmV0dXJuIGNoYW5uZWw7PGJyPit9PGJyPitFWFBPUlRf
U1lNQk9MKGlwdV9pZG1hY19nZXQpOzxicj4rPGJyPit2b2lkIGlwdV9pZG1hY19wdXQoc3RydWN0
IGlwdV9jaGFubmVsICpjaGFubmVsKTxicj4rezxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7IGRl
dl9kYmcoaXB1X2RldiwgJnF1b3Q7JXMgJWRcbiZxdW90OywgX19mdW5jX18sIGNoYW5uZWwtJmd0
O251bSk7PGJyPis8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBjbGtfZGlzYWJsZShpcHVfY2xr
KTs8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBjaGFubmVsLSZndDtidXN5ID0gMDs8YnI+K308
YnI+K0VYUE9SVF9TWU1CT0woaXB1X2lkbWFjX3B1dCk7PGJyPis8YnI+K3ZvaWQgaXB1X2lkbWFj
X3NldF9kb3VibGVfYnVmZmVyKHN0cnVjdCBpcHVfY2hhbm5lbCAqY2hhbm5lbCwgYm9vbCBkb3Vi
bGVidWZmZXIpPGJyPit7PGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgdW5zaWduZWQgbG9uZyBm
bGFnczs8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyB1MzIgcmVnOzxicj4rPGJyPisgJm5ic3A7
ICZuYnNwOyAmbmJzcDsgc3Bpbl9sb2NrX2lycXNhdmUoJmFtcDtpcHVfbG9jaywgZmxhZ3MpOzxi
cj4rPGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgcmVnID0gaXB1X2NtX3JlYWQoSVBVX0NIQV9E
Ql9NT0RFX1NFTChjaGFubmVsLSZndDtudW0pKTs8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBp
ZiAoZG91YmxlYnVmZmVyKTxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsg
Jm5ic3A7ICZuYnNwOyByZWcgfD0gaWRtYV9tYXNrKGNoYW5uZWwtJmd0O251bSk7PGJyPisgJm5i
c3A7ICZuYnNwOyAmbmJzcDsgZWxzZTxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAm
bmJzcDsgJm5ic3A7ICZuYnNwOyByZWcgJmFtcDs9IH5pZG1hX21hc2soY2hhbm5lbC0mZ3Q7bnVt
KTs8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBpcHVfY21fd3JpdGUocmVnLCBJUFVfQ0hBX0RC
X01PREVfU0VMKGNoYW5uZWwtJmd0O251bSkpOzxicj4rPGJyPisgJm5ic3A7ICZuYnNwOyAmbmJz
cDsgc3Bpbl91bmxvY2tfaXJxcmVzdG9yZSgmYW1wO2lwdV9sb2NrLCBmbGFncyk7PGJyPit9PGJy
PitFWFBPUlRfU1lNQk9MKGlwdV9pZG1hY19zZXRfZG91YmxlX2J1ZmZlcik7PGJyPis8YnI+K3Zv
aWQgaXB1X3VuaW5pdF9jaGFubmVsKHN0cnVjdCBpcHVfY2hhbm5lbCAqY2hhbm5lbCk8YnI+K3s8
YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyB1bnNpZ25lZCBsb25nIGxvY2tfZmxhZ3M7PGJyPisg
Jm5ic3A7ICZuYnNwOyAmbmJzcDsgdTMyIHZhbDs8YnI+Kzxicj4rICZuYnNwOyAmbmJzcDsgJm5i
c3A7IC8qIE1ha2Ugc3VyZSBjaGFubmVsIGlzIGRpc2FibGVkICovPGJyPis8YnI+KyAmbmJzcDsg
Jm5ic3A7ICZuYnNwOyBpZiAoaWRtYWNfaWRtYV9pc19zZXQoSURNQUNfQ0hBX0VOLCBjaGFubmVs
LSZndDtudW0pKSB7PGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJz
cDsgJm5ic3A7IGRldl9lcnIoaXB1X2Rldiw8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJz
cDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZxdW90
O0NoYW5uZWwgJWQgaXMgbm90IGRpc2FibGVkLCBkaXNhYmxlIGZpcnN0XG4mcXVvdDssPGJyPisg
Jm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAm
bmJzcDsgJm5ic3A7ICZuYnNwOyBjaGFubmVsLSZndDtudW0pOzxicj4rICZuYnNwOyAmbmJzcDsg
Jm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyByZXR1cm47PGJyPisgJm5ic3A7ICZu
YnNwOyAmbmJzcDsgfTxicj4rPGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgc3Bpbl9sb2NrX2ly
cXNhdmUoJmFtcDtpcHVfbG9jaywgbG9ja19mbGFncyk7PGJyPis8YnI+KyAmbmJzcDsgJm5ic3A7
ICZuYnNwOyAvKiBSZXNldCB0aGUgZG91YmxlIGJ1ZmZlciAqLzxicj4rICZuYnNwOyAmbmJzcDsg
Jm5ic3A7IHZhbCA9IGlwdV9jbV9yZWFkKElQVV9DSEFfREJfTU9ERV9TRUwoY2hhbm5lbC0mZ3Q7
bnVtKSk7PGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgdmFsICZhbXA7PSB+aWRtYV9tYXNrKGNo
YW5uZWwtJmd0O251bSk7PGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgaXB1X2NtX3dyaXRlKHZh
bCwgSVBVX0NIQV9EQl9NT0RFX1NFTChjaGFubmVsLSZndDtudW0pKTs8YnI+Kzxicj4rICZuYnNw
OyAmbmJzcDsgJm5ic3A7IHNwaW5fdW5sb2NrX2lycXJlc3RvcmUoJmFtcDtpcHVfbG9jaywgbG9j
a19mbGFncyk7PGJyPit9PGJyPitFWFBPUlRfU1lNQk9MKGlwdV91bmluaXRfY2hhbm5lbCk7PGJy
Pis8YnI+K2ludCBpcHVfbW9kdWxlX2VuYWJsZSh1MzIgbWFzayk8YnI+K3s8YnI+KyAmbmJzcDsg
Jm5ic3A7ICZuYnNwOyB1bnNpZ25lZCBsb25nIGxvY2tfZmxhZ3M7PGJyPisgJm5ic3A7ICZuYnNw
OyAmbmJzcDsgdTMyIGlwdV9jb25mOzxicj4rPGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgc3Bp
bl9sb2NrX2lycXNhdmUoJmFtcDtpcHVfbG9jaywgbG9ja19mbGFncyk7PGJyPis8YnI+KyAmbmJz
cDsgJm5ic3A7ICZuYnNwOyBpcHVfY29uZiA9IGlwdV9jbV9yZWFkKElQVV9DT05GKTs8YnI+KyAm
bmJzcDsgJm5ic3A7ICZuYnNwOyBpcHVfY29uZiB8PSBtYXNrOzxicj4rICZuYnNwOyAmbmJzcDsg
Jm5ic3A7IGlwdV9jbV93cml0ZShpcHVfY29uZiwgSVBVX0NPTkYpOzxicj4rPGJyPisgJm5ic3A7
ICZuYnNwOyAmbmJzcDsgc3Bpbl91bmxvY2tfaXJxcmVzdG9yZSgmYW1wO2lwdV9sb2NrLCBsb2Nr
X2ZsYWdzKTs8YnI+Kzxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7IHJldHVybiAwOzxicj4rfTxi
cj4rPGJyPitpbnQgaXB1X21vZHVsZV9kaXNhYmxlKHUzMiBtYXNrKTxicj4rezxicj4rICZuYnNw
OyAmbmJzcDsgJm5ic3A7IHVuc2lnbmVkIGxvbmcgbG9ja19mbGFnczs8YnI+KyAmbmJzcDsgJm5i
c3A7ICZuYnNwOyB1MzIgaXB1X2NvbmY7PGJyPis8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBz
cGluX2xvY2tfaXJxc2F2ZSgmYW1wO2lwdV9sb2NrLCBsb2NrX2ZsYWdzKTs8YnI+Kzxicj4rICZu
YnNwOyAmbmJzcDsgJm5ic3A7IGlwdV9jb25mID0gaXB1X2NtX3JlYWQoSVBVX0NPTkYpOzxicj4r
ICZuYnNwOyAmbmJzcDsgJm5ic3A7IGlwdV9jb25mICZhbXA7PSB+bWFzazs8YnI+KyAmbmJzcDsg
Jm5ic3A7ICZuYnNwOyBpcHVfY21fd3JpdGUoaXB1X2NvbmYsIElQVV9DT05GKTs8YnI+Kzxicj4r
ICZuYnNwOyAmbmJzcDsgJm5ic3A7IHNwaW5fdW5sb2NrX2lycXJlc3RvcmUoJmFtcDtpcHVfbG9j
aywgbG9ja19mbGFncyk7PGJyPis8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyByZXR1cm4gMDs8
YnI+K308YnI+Kzxicj4rdm9pZCBpcHVfaWRtYWNfc2VsZWN0X2J1ZmZlcihzdHJ1Y3QgaXB1X2No
YW5uZWwgKmNoYW5uZWwsIHUzMiBidWZfbnVtKTxicj4rezxicj4rICZuYnNwOyAmbmJzcDsgJm5i
c3A7IHVuc2lnbmVkIGludCBjaG5vID0gY2hhbm5lbC0mZ3Q7bnVtOzxicj4rPGJyPisgJm5ic3A7
ICZuYnNwOyAmbmJzcDsgLyogTWFyayBidWZmZXIgYXMgcmVhZHkuICovPGJyPisgJm5ic3A7ICZu
YnNwOyAmbmJzcDsgaWYgKGJ1Zl9udW0gPT0gMCk8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAm
bmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgaXB1X2NtX3dyaXRlKGlkbWFfbWFzayhjaG5vKSwg
SVBVX0NIQV9CVUYwX1JEWShjaG5vKSk7PGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgZWxzZTxi
cj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBpcHVf
Y21fd3JpdGUoaWRtYV9tYXNrKGNobm8pLCBJUFVfQ0hBX0JVRjFfUkRZKGNobm8pKTs8YnI+K308
YnI+K0VYUE9SVF9TWU1CT0woaXB1X2lkbWFjX3NlbGVjdF9idWZmZXIpOzxicj4rPGJyPitpbnQg
aXB1X2lkbWFjX2VuYWJsZV9jaGFubmVsKHN0cnVjdCBpcHVfY2hhbm5lbCAqY2hhbm5lbCk8YnI+
K3s8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyB1MzIgdmFsOzxicj4rICZuYnNwOyAmbmJzcDsg
Jm5ic3A7IHVuc2lnbmVkIGxvbmcgZmxhZ3M7PGJyPis8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNw
OyBzcGluX2xvY2tfaXJxc2F2ZSgmYW1wO2lwdV9sb2NrLCBmbGFncyk7PGJyPis8YnI+KyAmbmJz
cDsgJm5ic3A7ICZuYnNwOyB2YWwgPSBpcHVfaWRtYWNfcmVhZChJRE1BQ19DSEFfRU4oY2hhbm5l
bC0mZ3Q7bnVtKSk7PGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgdmFsIHw9IGlkbWFfbWFzayhj
aGFubmVsLSZndDtudW0pOzxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7IGlwdV9pZG1hY193cml0
ZSh2YWwsIElETUFDX0NIQV9FTihjaGFubmVsLSZndDtudW0pKTs8YnI+Kzxicj4rICZuYnNwOyAm
bmJzcDsgJm5ic3A7IHNwaW5fdW5sb2NrX2lycXJlc3RvcmUoJmFtcDtpcHVfbG9jaywgZmxhZ3Mp
Ozxicj4rPGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgcmV0dXJuIDA7PGJyPit9PGJyPitFWFBP
UlRfU1lNQk9MKGlwdV9pZG1hY19lbmFibGVfY2hhbm5lbCk7PGJyPis8YnI+K2ludCBpcHVfaWRt
YWNfZGlzYWJsZV9jaGFubmVsKHN0cnVjdCBpcHVfY2hhbm5lbCAqY2hhbm5lbCk8YnI+K3s8YnI+
KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyB1MzIgdmFsOzxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7
IHVuc2lnbmVkIGxvbmcgZmxhZ3M7PGJyPis8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBzcGlu
X2xvY2tfaXJxc2F2ZSgmYW1wO2lwdV9sb2NrLCBmbGFncyk7PGJyPis8YnI+KyAmbmJzcDsgJm5i
c3A7ICZuYnNwOyAvKiBEaXNhYmxlIERNQSBjaGFubmVsKHMpICovPGJyPisgJm5ic3A7ICZuYnNw
OyAmbmJzcDsgdmFsID0gaXB1X2lkbWFjX3JlYWQoSURNQUNfQ0hBX0VOKGNoYW5uZWwtJmd0O251
bSkpOzxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7IHZhbCAmYW1wOz0gfmlkbWFfbWFzayhjaGFu
bmVsLSZndDtudW0pOzxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7IGlwdV9pZG1hY193cml0ZSh2
YWwsIElETUFDX0NIQV9FTihjaGFubmVsLSZndDtudW0pKTs8YnI+Kzxicj4rICZuYnNwOyAmbmJz
cDsgJm5ic3A7IC8qIFNldCBjaGFubmVsIGJ1ZmZlcnMgTk9UIHRvIGJlIHJlYWR5ICovPGJyPisg
Jm5ic3A7ICZuYnNwOyAmbmJzcDsgaXB1X2NtX3dyaXRlKDB4ZjAwMDAwMDAsIElQVV9HUFIpOyAv
KiB3cml0ZSBvbmUgdG8gY2xlYXIgKi88YnI+Kzxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7IGlm
IChpcHVfaWRtYV9pc19zZXQoSVBVX0NIQV9CVUYwX1JEWSwgY2hhbm5lbC0mZ3Q7bnVtKSkgezxi
cj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBpcHVf
Y21fd3JpdGUoaWRtYV9tYXNrKGNoYW5uZWwtJmd0O251bSksPGJyPisgJm5ic3A7ICZuYnNwOyAm
bmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZu
YnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwO0lQVV9DSEFfQlVGMF9SRFkoY2hhbm5lbC0mZ3Q7bnVt
KSk7PGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgfTxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7
IGlmIChpcHVfaWRtYV9pc19zZXQoSVBVX0NIQV9CVUYxX1JEWSwgY2hhbm5lbC0mZ3Q7bnVtKSkg
ezxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBp
cHVfY21fd3JpdGUoaWRtYV9tYXNrKGNoYW5uZWwtJmd0O251bSksPGJyPisgJm5ic3A7ICZuYnNw
OyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7
ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwO0lQVV9DSEFfQlVGMV9SRFkoY2hhbm5lbC0mZ3Q7
bnVtKSk7PGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgfTxicj4rPGJyPisgJm5ic3A7ICZuYnNw
OyAmbmJzcDsgaXB1X2NtX3dyaXRlKDB4MCwgSVBVX0dQUik7IC8qIHdyaXRlIG9uZSB0byBzZXQg
Ki88YnI+Kzxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7IHNwaW5fdW5sb2NrX2lycXJlc3RvcmUo
JmFtcDtpcHVfbG9jaywgZmxhZ3MpOzxicj4rPGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgcmV0
dXJuIDA7PGJyPit9PGJyPitFWFBPUlRfU1lNQk9MKGlwdV9pZG1hY19kaXNhYmxlX2NoYW5uZWwp
Ozxicj4rPGJyPitzdGF0aWMgTElTVF9IRUFEKGlwdV9pcnFfaGFuZGxlcnMpOzxicj4rPGJyPitz
dGF0aWMgdm9pZCBpcHVfaXJxX3VwZGF0ZV9pcnFfbWFzayh2b2lkKTxicj4rezxicj4rICZuYnNw
OyAmbmJzcDsgJm5ic3A7IHN0cnVjdCBpcHVfaXJxX2hhbmRsZXIgKmhhbmRsZXI7PGJyPisgJm5i
c3A7ICZuYnNwOyAmbmJzcDsgaW50IGk7PGJyPis8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBE
RUNMQVJFX0lQVV9JUlFfQklUTUFQKGlycXMpOzxicj4rPGJyPisgJm5ic3A7ICZuYnNwOyAmbmJz
cDsgYml0bWFwX3plcm8oaXJxcywgSVBVX0lSUV9DT1VOVCk7PGJyPis8YnI+KyAmbmJzcDsgJm5i
c3A7ICZuYnNwOyBsaXN0X2Zvcl9lYWNoX2VudHJ5KGhhbmRsZXIsICZhbXA7aXB1X2lycV9oYW5k
bGVycywgbGlzdCk8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNw
OyAmbmJzcDsgYml0bWFwX29yKGlycXMsIGlycXMsIGhhbmRsZXItJmd0O2lwdV9pcnFzLCBJUFVf
SVJRX0NPVU5UKTs8YnI+Kzxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7IGZvciAoaSA9IDA7IGkg
Jmx0OyBCSVRTX1RPX0xPTkdTKElQVV9JUlFfQ09VTlQpOyBpKyspPGJyPisgJm5ic3A7ICZuYnNw
OyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7IGlwdV9jbV93cml0ZShpcnFzW2ld
LCBJUFVfSU5UX0NUUkwoaSArIDEpKTs8YnI+K308YnI+Kzxicj4raW50IGlwdV9pcnFfYWRkX2hh
bmRsZXIoc3RydWN0IGlwdV9pcnFfaGFuZGxlciAqaXB1aXJxKTxicj4rezxicj4rICZuYnNwOyAm
bmJzcDsgJm5ic3A7IHVuc2lnbmVkIGxvbmcgZmxhZ3M7PGJyPis8YnI+KyAmbmJzcDsgJm5ic3A7
ICZuYnNwOyBzcGluX2xvY2tfaXJxc2F2ZSgmYW1wO2lwdV9sb2NrLCBmbGFncyk7PGJyPis8YnI+
KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBsaXN0X2FkZF90YWlsKCZhbXA7aXB1aXJxLSZndDtsaXN0
LCAmYW1wO2lwdV9pcnFfaGFuZGxlcnMpOzxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7IGlwdV9p
cnFfdXBkYXRlX2lycV9tYXNrKCk7PGJyPis8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBzcGlu
X3VubG9ja19pcnFyZXN0b3JlKCZhbXA7aXB1X2xvY2ssIGZsYWdzKTs8YnI+KyAmbmJzcDsgJm5i
c3A7ICZuYnNwOyByZXR1cm4gMDs8YnI+K308YnI+K0VYUE9SVF9TWU1CT0woaXB1X2lycV9hZGRf
aGFuZGxlcik7PGJyPis8YnI+K3ZvaWQgaXB1X2lycV9yZW1vdmVfaGFuZGxlcihzdHJ1Y3QgaXB1
X2lycV9oYW5kbGVyICpoYW5kbGVyKTxicj4rezxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7IHVu
c2lnbmVkIGxvbmcgZmxhZ3M7PGJyPis8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBzcGluX2xv
Y2tfaXJxc2F2ZSgmYW1wO2lwdV9sb2NrLCBmbGFncyk7PGJyPis8YnI+KyAmbmJzcDsgJm5ic3A7
ICZuYnNwOyBsaXN0X2RlbCgmYW1wO2hhbmRsZXItJmd0O2xpc3QpOzxicj4rICZuYnNwOyAmbmJz
cDsgJm5ic3A7IGlwdV9pcnFfdXBkYXRlX2lycV9tYXNrKCk7PGJyPis8YnI+KyAmbmJzcDsgJm5i
c3A7ICZuYnNwOyBzcGluX3VubG9ja19pcnFyZXN0b3JlKCZhbXA7aXB1X2xvY2ssIGZsYWdzKTs8
YnI+K308YnI+K0VYUE9SVF9TWU1CT0woaXB1X2lycV9yZW1vdmVfaGFuZGxlcik7PGJyPis8YnI+
K2ludCBpcHVfaXJxX3VwZGF0ZV9oYW5kbGVyKHN0cnVjdCBpcHVfaXJxX2hhbmRsZXIgKmhhbmRs
ZXIsPGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7
IHVuc2lnbmVkIGxvbmcgKmJpdG1hcCk8YnI+K3s8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyB1
bnNpZ25lZCBsb25nIGZsYWdzOzxicj4rPGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgc3Bpbl9s
b2NrX2lycXNhdmUoJmFtcDtpcHVfbG9jaywgZmxhZ3MpOzxicj4rPGJyPisgJm5ic3A7ICZuYnNw
OyAmbmJzcDsgYml0bWFwX2NvcHkoaGFuZGxlci0mZ3Q7aXB1X2lycXMsIGJpdG1hcCwgSVBVX0lS
UV9DT1VOVCk7PGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgaXB1X2lycV91cGRhdGVfaXJxX21h
c2soKTs8YnI+Kzxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7IHNwaW5fdW5sb2NrX2lycXJlc3Rv
cmUoJmFtcDtpcHVfbG9jaywgZmxhZ3MpOzxicj4rPGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsg
cmV0dXJuIDA7PGJyPit9PGJyPitFWFBPUlRfU1lNQk9MKGlwdV9pcnFfdXBkYXRlX2hhbmRsZXIp
Ozxicj4rPGJyPitzdGF0aWMgdm9pZCBpcHVfY29tcGxldGlvbl9oYW5kbGVyKHVuc2lnbmVkIGxv
bmcgKmJpdG1hc2ssIHZvaWQgKmNvbnRleHQpPGJyPit7PGJyPisgJm5ic3A7ICZuYnNwOyAmbmJz
cDsgc3RydWN0IGNvbXBsZXRpb24gKmNvbXBsZXRpb24gPSBjb250ZXh0Ozxicj4rPGJyPisgJm5i
c3A7ICZuYnNwOyAmbmJzcDsgY29tcGxldGUoY29tcGxldGlvbik7PGJyPit9PGJyPis8YnI+K2lu
dCBpcHVfd2FpdF9mb3JfaW50ZXJydXB0KGludCBpbnRlcnJ1cHQsIGludCB0aW1lb3V0X21zKTxi
cj4rezxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7IHN0cnVjdCBpcHVfaXJxX2hhbmRsZXIgaGFu
ZGxlcjs8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBERUNMQVJFX0NPTVBMRVRJT05fT05TVEFD
Syhjb21wbGV0aW9uKTs8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBpbnQgcmV0Ozxicj4rPGJy
PisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgYml0bWFwX3plcm8oaGFuZGxlci5pcHVfaXJxcywgSVBV
X0lSUV9DT1VOVCk7PGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgYml0bWFwX3NldChoYW5kbGVy
LmlwdV9pcnFzLCBpbnRlcnJ1cHQsIDEpOzxicj4rPGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsg
aGFuZGxlci5oYW5kbGVyID0gaXB1X2NvbXBsZXRpb25faGFuZGxlcjs8YnI+KyAmbmJzcDsgJm5i
c3A7ICZuYnNwOyBoYW5kbGVyLmNvbnRleHQgPSAmYW1wO2NvbXBsZXRpb247PGJyPisgJm5ic3A7
ICZuYnNwOyAmbmJzcDsgaXB1X2lycV9hZGRfaGFuZGxlcigmYW1wO2hhbmRsZXIpOzxicj4rPGJy
PisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgcmV0ID0gd2FpdF9mb3JfY29tcGxldGlvbl90aW1lb3V0
KCZhbXA7Y29tcGxldGlvbiw8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7
ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7IG1zZWNzX3RvX2ppZmZp
ZXModGltZW91dF9tcykpOzxicj4rPGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgaXB1X2lycV9y
ZW1vdmVfaGFuZGxlcigmYW1wO2hhbmRsZXIpOzxicj4rPGJyPisgJm5ic3A7ICZuYnNwOyAmbmJz
cDsgaWYgKHJldCAmZ3Q7IDApPGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNw
OyAmbmJzcDsgJm5ic3A7IHJldCA9IDA7PGJyPis8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBy
ZXR1cm4gcmV0Ozxicj4rfTxicj4rRVhQT1JUX1NZTUJPTChpcHVfd2FpdF9mb3JfaW50ZXJydXB0
KTs8YnI+Kzxicj4rc3RhdGljIGlycXJldHVybl90IGlwdV9pcnFfaGFuZGxlcihpbnQgaXJxLCB2
b2lkICpkZXNjKTxicj4rezxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7IERFQ0xBUkVfSVBVX0lS
UV9CSVRNQVAoc3RhdHVzKTs8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBzdHJ1Y3QgaXB1X2ly
cV9oYW5kbGVyICpoYW5kbGVyOzxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7IGludCBpOzxicj4r
PGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgZm9yIChpID0gMDsgaSAmbHQ7IEJJVFNfVE9fTE9O
R1MoSVBVX0lSUV9DT1VOVCk7IGkrKykgezxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNw
OyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBzdGF0dXNbaV0gPSBpcHVfY21fcmVhZChJUFVfSU5UX1NU
QVQoaSArIDEpKTs8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNw
OyAmbmJzcDsgaXB1X2NtX3dyaXRlKHN0YXR1c1tpXSwgSVBVX0lOVF9TVEFUKGkgKyAxKSk7PGJy
PisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgfTxicj4rPGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsg
bGlzdF9mb3JfZWFjaF9lbnRyeShoYW5kbGVyLCAmYW1wO2lwdV9pcnFfaGFuZGxlcnMsIGxpc3Qp
IHs8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsg
REVDTEFSRV9JUFVfSVJRX0JJVE1BUCh0bXApOzxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZu
YnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBpZiAoYml0bWFwX2FuZCh0bXAsIHN0YXR1cywgaGFu
ZGxlci0mZ3Q7aXB1X2lycXMsIElQVV9JUlFfQ09VTlQpKTxicj4rICZuYnNwOyAmbmJzcDsgJm5i
c3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJz
cDsgaGFuZGxlci0mZ3Q7aGFuZGxlcih0bXAsIGhhbmRsZXItJmd0O2NvbnRleHQpOzxicj4rICZu
YnNwOyAmbmJzcDsgJm5ic3A7IH08YnI+Kzxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7IHJldHVy
biBJUlFfSEFORExFRDs8YnI+K308YnI+Kzxicj4raXB1X2NvbG9yX3NwYWNlX3QgZm9ybWF0X3Rv
X2NvbG9yc3BhY2UodTMyIGZtdCk8YnI+K3s8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBzd2l0
Y2ggKGZtdCkgezxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7IGNhc2UgSVBVX1BJWF9GTVRfUkdC
NjY2Ojxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7IGNhc2UgSVBVX1BJWF9GTVRfUkdCNTY1Ojxi
cj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7IGNhc2UgSVBVX1BJWF9GTVRfQkdSMjQ6PGJyPisgJm5i
c3A7ICZuYnNwOyAmbmJzcDsgY2FzZSBJUFVfUElYX0ZNVF9SR0IyNDo8YnI+KyAmbmJzcDsgJm5i
c3A7ICZuYnNwOyBjYXNlIElQVV9QSVhfRk1UX0JHUjMyOjxicj4rICZuYnNwOyAmbmJzcDsgJm5i
c3A7IGNhc2UgSVBVX1BJWF9GTVRfQkdSQTMyOjxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7IGNh
c2UgSVBVX1BJWF9GTVRfUkdCMzI6PGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgY2FzZSBJUFVf
UElYX0ZNVF9SR0JBMzI6PGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgY2FzZSBJUFVfUElYX0ZN
VF9BQkdSMzI6PGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgY2FzZSBJUFVfUElYX0ZNVF9MVkRT
NjY2Ojxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7IGNhc2UgSVBVX1BJWF9GTVRfTFZEUzg4ODo8
YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgcmV0
dXJuIFJHQjs8YnI+Kzxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7IGRlZmF1bHQ6PGJyPisgJm5i
c3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7IHJldHVybiBZQ2JD
cjs8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyB9PGJyPit9PGJyPis8YnI+K3N0YXRpYyBpbnQg
aXB1X3Jlc2V0KHZvaWQpPGJyPit7PGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgaW50IHRpbWVv
dXQgPSAxMDAwMDs8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyB1MzIgdmFsOzxicj4rPGJyPisg
Jm5ic3A7ICZuYnNwOyAmbmJzcDsgLyogaGFyZCByZXNldCB0aGUgSVBVICovPGJyPisgJm5ic3A7
ICZuYnNwOyAmbmJzcDsgdmFsID0gcmVhZGwoTVg1MV9JT19BRERSRVNTKE1YNTFfU1JDX0JBU0Vf
QUREUikpOzxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7IHZhbCB8PSAxICZsdDsmbHQ7IDM7PGJy
PisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgd3JpdGVsKHZhbCwgTVg1MV9JT19BRERSRVNTKE1YNTFf
U1JDX0JBU0VfQUREUikpOzxicj4rPGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgaXB1X2NtX3dy
aXRlKDB4ODA3RkZGRkYsIElQVV9NRU1fUlNUKTs8YnI+Kzxicj4rICZuYnNwOyAmbmJzcDsgJm5i
c3A7IHdoaWxlIChpcHVfY21fcmVhZChJUFVfTUVNX1JTVCkgJmFtcDsgMHg4MDAwMDAwMCkgezxi
cj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBpZiAo
IXRpbWVvdXQtLSk8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNw
OyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7IHJldHVybiAtRVRJTUU7PGJyPisg
Jm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7IHVkZWxheSgx
MDApOzxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7IH08YnI+Kzxicj4rICZuYnNwOyAmbmJzcDsg
Jm5ic3A7IHJldHVybiAwOzxicj4rfTxicj4rPGJyPisvKjxicj4rICogVGhlIE1JUEkgSFNDIHVu
aXQgaGFzIGJlZW4gcmVtb3ZlZCBmcm9tIHRoZSBpLk1YNTEgUmVmZXJlbmNlIE1hbnVhbCBieTxi
cj4rICogdGhlIEZyZWVzY2FsZSBtYXJrZXRpbmcgZGl2aXNpb24uIEhvd2V2ZXIgdGhpcyBkaWQg
bm90IHJlbW92ZSB0aGU8YnI+KyAqIGhhcmR3YXJlIGZyb20gdGhlIGNoaXAgd2hpY2ggc3RpbGwg
bmVlZHMgdG8gYmUgY29uZmlndXJlZC4uLjxicj4rICovPGJyPitzdGF0aWMgaW50IF9fZGV2aW5p
dCBpcHVfbWlwaV9zZXR1cCh2b2lkKTxicj4rezxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7IHN0
cnVjdCBjbGsgKmhzY19jbGs7PGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgdm9pZCBfX2lvbWVt
ICpoc2NfYWRkcjs8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBpbnQgcmV0ID0gMDs8YnI+Kzxi
cj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7IGhzY19hZGRyID0gaW9yZW1hcChNWDUxX01JUElfSFND
X0JBU0VfQUREUiwgUEFHRV9TSVpFKTs8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBpZiAoIWhz
Y19hZGRyKTxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZu
YnNwOyByZXR1cm4gLUVOT01FTTs8YnI+Kzxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7IGhzY19j
bGsgPSBjbGtfZ2V0X3N5cyhOVUxMLCAmcXVvdDttaXBpX2hzcCZxdW90Oyk7PGJyPisgJm5ic3A7
ICZuYnNwOyAmbmJzcDsgaWYgKElTX0VSUihoc2NfY2xrKSkgezxicj4rICZuYnNwOyAmbmJzcDsg
Jm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyByZXQgPSBQVFJfRVJSKGhzY19jbGsp
Ozxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBn
b3RvIHVubWFwOzxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7IH08YnI+KyAmbmJzcDsgJm5ic3A7
ICZuYnNwOyBjbGtfZW5hYmxlKGhzY19jbGspOzxicj4rPGJyPisgJm5ic3A7ICZuYnNwOyAmbmJz
cDsgLyogc2V0dXAgTUlQSSBtb2R1bGUgdG8gbGVnYWN5IG1vZGUgKi88YnI+KyAmbmJzcDsgJm5i
c3A7ICZuYnNwOyBfX3Jhd193cml0ZWwoMHhGMDAsIGhzY19hZGRyKTs8YnI+Kzxicj4rICZuYnNw
OyAmbmJzcDsgJm5ic3A7IC8qIENTSSBtb2RlOiByZXNlcnZlZDsgREkgY29udHJvbCBtb2RlOiBs
ZWdhY3kgKGZyb20gRnJlZXNjYWxlIEJTUCkgKi88YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBf
X3Jhd193cml0ZWwoX19yYXdfcmVhZGwoaHNjX2FkZHIgKyAweDgwMCkgfCAweDMwZmYsPGJyPisg
Jm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7IGhzY19hZGRy
ICsgMHg4MDApOzxicj4rPGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgY2xrX2Rpc2FibGUoaHNj
X2Nsayk7PGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgY2xrX3B1dChoc2NfY2xrKTs8YnI+K3Vu
bWFwOjxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7IGlvdW5tYXAoaHNjX2FkZHIpOzxicj4rPGJy
PisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgcmV0dXJuIHJldDs8YnI+K308YnI+Kzxicj4rc3RhdGlj
IGludCBpcHVfc3VibW9kdWxlc19pbml0KHN0cnVjdCBwbGF0Zm9ybV9kZXZpY2UgKnBkZXYsPGJy
PisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7IHVuc2ln
bmVkIGxvbmcgaXB1X2Jhc2UsIHN0cnVjdCBjbGsgKmlwdV9jbGspPGJyPit7PGJyPisgJm5ic3A7
ICZuYnNwOyAmbmJzcDsgY2hhciAqdW5pdDs8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBpbnQg
cmV0Ozxicj4rPGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgcmV0ID0gaXB1X2RpX2luaXQocGRl
diwgMCwgaXB1X2Jhc2UgKyBJUFVfREkwX1JFR19CQVNFLDxicj4rICZuYnNwOyAmbmJzcDsgJm5i
c3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJz
cDsgSVBVX0NPTkZfREkwX0VOLCBpcHVfY2xrKTs8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBp
ZiAocmV0KSB7PGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsg
Jm5ic3A7IHVuaXQgPSAmcXVvdDtkaTAmcXVvdDs7PGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsg
Jm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7IGdvdG8gZXJyX2RpXzA7PGJyPisgJm5ic3A7ICZu
YnNwOyAmbmJzcDsgfTxicj4rPGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgcmV0ID0gaXB1X2Rp
X2luaXQocGRldiwgMSwgaXB1X2Jhc2UgKyBJUFVfREkxX1JFR19CQVNFLDxicj4rICZuYnNwOyAm
bmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZu
YnNwOyAmbmJzcDsgSVBVX0NPTkZfREkxX0VOLCBpcHVfY2xrKTs8YnI+KyAmbmJzcDsgJm5ic3A7
ICZuYnNwOyBpZiAocmV0KSB7PGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNw
OyAmbmJzcDsgJm5ic3A7IHVuaXQgPSAmcXVvdDtkaTEmcXVvdDs7PGJyPisgJm5ic3A7ICZuYnNw
OyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7IGdvdG8gZXJyX2RpXzE7PGJyPisg
Jm5ic3A7ICZuYnNwOyAmbmJzcDsgfTxicj4rPGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgcmV0
ID0gaXB1X2RjX2luaXQocGRldiwgaXB1X2Jhc2UgKyBJUFVfRENfUkVHX0JBU0UsPGJyPisgJm5i
c3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJz
cDsgJm5ic3A7ICZuYnNwOyBpcHVfYmFzZSArIElQVV9EQ19UTVBMX1JFR19CQVNFKTs8YnI+KyAm
bmJzcDsgJm5ic3A7ICZuYnNwOyBpZiAocmV0KSB7PGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsg
Jm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7IHVuaXQgPSAmcXVvdDtkY190ZW1wbGF0ZSZxdW90
Ozs8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsg
Z290byBlcnJfZGM7PGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgfTxicj4rPGJyPisgJm5ic3A7
ICZuYnNwOyAmbmJzcDsgcmV0ID0gaXB1X2RtZmNfaW5pdChwZGV2LCBpcHVfYmFzZSArIElQVV9E
TUZDX1JFR19CQVNFLCBpcHVfY2xrKTs8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBpZiAocmV0
KSB7PGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7
IHVuaXQgPSAmcXVvdDtkbWZjJnF1b3Q7Ozxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNw
OyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBnb3RvIGVycl9kbWZjOzxicj4rICZuYnNwOyAmbmJzcDsg
Jm5ic3A7IH08YnI+Kzxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7IHJldCA9IGlwdV9kcF9pbml0
KHBkZXYsIGlwdV9iYXNlICsgSVBVX1NSTV9SRUdfQkFTRSk7PGJyPisgJm5ic3A7ICZuYnNwOyAm
bmJzcDsgaWYgKHJldCkgezxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsg
Jm5ic3A7ICZuYnNwOyB1bml0ID0gJnF1b3Q7ZHAmcXVvdDs7PGJyPisgJm5ic3A7ICZuYnNwOyAm
bmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7IGdvdG8gZXJyX2RwOzxicj4rICZuYnNw
OyAmbmJzcDsgJm5ic3A7IH08YnI+Kzxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7IHJldCA9IGlw
dV9jcG1lbV9pbml0KHBkZXYsIGlwdV9iYXNlICsgSVBVX0NQTUVNX1JFR19CQVNFKTs8YnI+KyAm
bmJzcDsgJm5ic3A7ICZuYnNwOyBpZiAocmV0KSB7PGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsg
Jm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7IHVuaXQgPSAmcXVvdDtjcG1lbSZxdW90Ozs8YnI+
KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgZ290byBl
cnJfY3BtZW07PGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgfTxicj4rPGJyPisgJm5ic3A7ICZu
YnNwOyAmbmJzcDsgcmV0dXJuIDA7PGJyPis8YnI+K2Vycl9jcG1lbTo8YnI+KyAmbmJzcDsgJm5i
c3A7ICZuYnNwOyBpcHVfZHBfZXhpdChwZGV2KTs8YnI+K2Vycl9kcDo8YnI+KyAmbmJzcDsgJm5i
c3A7ICZuYnNwOyBpcHVfZG1mY19leGl0KHBkZXYpOzxicj4rZXJyX2RtZmM6PGJyPisgJm5ic3A7
ICZuYnNwOyAmbmJzcDsgaXB1X2RjX2V4aXQocGRldik7PGJyPitlcnJfZGM6PGJyPisgJm5ic3A7
ICZuYnNwOyAmbmJzcDsgaXB1X2RpX2V4aXQocGRldiwgMSk7PGJyPitlcnJfZGlfMTo8YnI+KyAm
bmJzcDsgJm5ic3A7ICZuYnNwOyBpcHVfZGlfZXhpdChwZGV2LCAwKTs8YnI+K2Vycl9kaV8wOjxi
cj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7IGRldl9lcnIoJmFtcDtwZGV2LSZndDtkZXYsICZxdW90
O2luaXQgJXMgZmFpbGVkIHdpdGggJWRcbiZxdW90OywgdW5pdCwgcmV0KTs8YnI+KyAmbmJzcDsg
Jm5ic3A7ICZuYnNwOyByZXR1cm4gcmV0Ozxicj4rfTxicj4rPGJyPitzdGF0aWMgdm9pZCBpcHVf
c3VibW9kdWxlc19leGl0KHN0cnVjdCBwbGF0Zm9ybV9kZXZpY2UgKnBkZXYsPGJyPisgJm5ic3A7
ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7IHVuc2lnbmVkIGxvbmcg
aXB1X2Jhc2UpPGJyPit7PGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgaXB1X2NwbWVtX2V4aXQo
cGRldik7PGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgaXB1X2RwX2V4aXQocGRldik7PGJyPisg
Jm5ic3A7ICZuYnNwOyAmbmJzcDsgaXB1X2RtZmNfZXhpdChwZGV2KTs8YnI+KyAmbmJzcDsgJm5i
c3A7ICZuYnNwOyBpcHVfZGNfZXhpdChwZGV2KTs8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBp
cHVfZGlfZXhpdChwZGV2LCAxKTs8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBpcHVfZGlfZXhp
dChwZGV2LCAwKTs8YnI+K308YnI+Kzxicj4rc3RhdGljIGludCBpcHVfYWRkX3N1YmRldmljZV9w
ZGF0YShzdHJ1Y3QgcGxhdGZvcm1fZGV2aWNlICpwZGV2LDxicj4rICZuYnNwOyAmbmJzcDsgJm5i
c3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBjb25zdCBjaGFyICpuYW1lLCBpbnQgaWQs
IHZvaWQgKnBkYXRhLCBzaXplX3QgcGRhdGFfc2l6ZSk8YnI+K3s8YnI+KyAmbmJzcDsgJm5ic3A7
ICZuYnNwOyBzdHJ1Y3QgbWZkX2NlbGwgY2VsbCA9IHs8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNw
OyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgLnBsYXRmb3JtX2RhdGEgPSBwZGF0YSw8YnI+
KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgLmRhdGFf
c2l6ZSA9IHBkYXRhX3NpemUsPGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgfTs8YnI+Kzxicj4r
ICZuYnNwOyAmbmJzcDsgJm5ic3A7IDxhIGhyZWY9Imh0dHA6Ly9jZWxsLm5hbWUiIHRhcmdldD0i
X2JsYW5rIj5jZWxsLm5hbWU8L2E+ID0gbmFtZTs8YnI+Kzxicj4rICZuYnNwOyAmbmJzcDsgJm5i
c3A7IHJldHVybiBtZmRfYWRkX2RldmljZXMoJmFtcDtwZGV2LSZndDtkZXYsIGlkLCAmYW1wO2Nl
bGwsIDEsIE5VTEwsIDApOzxicj4rfTxicj4rPGJyPitzdGF0aWMgaW50IGlwdV9hZGRfY2xpZW50
X2RldmljZXMoc3RydWN0IHBsYXRmb3JtX2RldmljZSAqcGRldik8YnI+K3s8YnI+KyAmbmJzcDsg
Jm5ic3A7ICZuYnNwOyBzdHJ1Y3QgaW14X2lwdXYzX3BsYXRmb3JtX2RhdGEgKnBsYXRfZGF0YSA9
IHBkZXYtJmd0O2Rldi5wbGF0Zm9ybV9kYXRhOzxicj4rPGJyPisgJm5ic3A7ICZuYnNwOyAmbmJz
cDsgaWYgKHBsYXRfZGF0YS0mZ3Q7ZmIwX3BsYXRmb3JtX2RhdGEpIHs8YnI+KyAmbmJzcDsgJm5i
c3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgcGxhdF9kYXRhLSZndDtmYjBf
cGxhdGZvcm1fZGF0YS0mZ3Q7aXB1X2NoYW5uZWxfYmcgPTxicj4rICZuYnNwOyAmbmJzcDsgJm5i
c3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJz
cDsgTVg1MV9JUFVfQ0hBTk5FTF9NRU1fQkdfU1lOQzs8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNw
OyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgcGxhdF9kYXRhLSZndDtmYjBfcGxhdGZvcm1f
ZGF0YS0mZ3Q7aXB1X2NoYW5uZWxfZmcgPTxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNw
OyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgTVg1MV9J
UFVfQ0hBTk5FTF9NRU1fRkdfU1lOQzs8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsg
Jm5ic3A7ICZuYnNwOyAmbmJzcDsgcGxhdF9kYXRhLSZndDtmYjBfcGxhdGZvcm1fZGF0YS0mZ3Q7
ZGNfY2hhbm5lbCA9IDU7PGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAm
bmJzcDsgJm5ic3A7IHBsYXRfZGF0YS0mZ3Q7ZmIwX3BsYXRmb3JtX2RhdGEtJmd0O2RwX2NoYW5u
ZWwgPSBJUFVfRFBfRkxPV19TWU5DOzxicj4rPGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5i
c3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7IGlwdV9hZGRfc3ViZGV2aWNlX3BkYXRhKHBkZXYsICZx
dW90O2lteC1pcHV2My1mYiZxdW90OywgMCw8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJz
cDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNw
OyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBwbGF0X2RhdGEtJmd0O2ZiMF9wbGF0Zm9ybV9kYXRhLDxi
cj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJz
cDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7IHNpemVv
ZihzdHJ1Y3QgaXB1djNfZmJfcGxhdGZvcm1fZGF0YSkpOzxicj4rICZuYnNwOyAmbmJzcDsgJm5i
c3A7IH08YnI+Kzxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7IGlmIChwbGF0X2RhdGEtJmd0O2Zi
MV9wbGF0Zm9ybV9kYXRhKSB7PGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNw
OyAmbmJzcDsgJm5ic3A7IHBsYXRfZGF0YS0mZ3Q7ZmIxX3BsYXRmb3JtX2RhdGEtJmd0O2lwdV9j
aGFubmVsX2JnID08YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNw
OyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7IE1YNTFfSVBVX0NIQU5ORUxfTUVN
X0RDX1NZTkM7PGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsg
Jm5ic3A7IHBsYXRfZGF0YS0mZ3Q7ZmIxX3BsYXRmb3JtX2RhdGEtJmd0O2lwdV9jaGFubmVsX2Zn
ID0gLTE7PGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5i
c3A7IHBsYXRfZGF0YS0mZ3Q7ZmIxX3BsYXRmb3JtX2RhdGEtJmd0O2RjX2NoYW5uZWwgPSAxOzxi
cj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBwbGF0
X2RhdGEtJmd0O2ZiMV9wbGF0Zm9ybV9kYXRhLSZndDtkcF9jaGFubmVsID0gLTE7PGJyPis8YnI+
KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgaXB1X2Fk
ZF9zdWJkZXZpY2VfcGRhdGEocGRldiwgJnF1b3Q7aW14LWlwdXYzLWZiJnF1b3Q7LCAxLDxicj4r
ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsg
Jm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7IHBsYXRfZGF0
YS0mZ3Q7ZmIxX3BsYXRmb3JtX2RhdGEsPGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7
ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsg
Jm5ic3A7ICZuYnNwOyAmbmJzcDsgc2l6ZW9mKHN0cnVjdCBpcHV2M19mYl9wbGF0Zm9ybV9kYXRh
KSk7PGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgfTxicj4rPGJyPisgJm5ic3A7ICZuYnNwOyAm
bmJzcDsgcmV0dXJuIDA7PGJyPit9PGJyPis8YnI+K3N0YXRpYyBpbnQgX19kZXZpbml0IGlwdV9w
cm9iZShzdHJ1Y3QgcGxhdGZvcm1fZGV2aWNlICpwZGV2KTxicj4rezxicj4rICZuYnNwOyAmbmJz
cDsgJm5ic3A7IHN0cnVjdCByZXNvdXJjZSAqcmVzOzxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7
IHVuc2lnbmVkIGxvbmcgaXB1X2Jhc2U7PGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgaW50IHJl
dCwgaXJxMSwgaXJxMjs8YnI+Kzxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7IHNwaW5fbG9ja19p
bml0KCZhbXA7aXB1X2xvY2spOzxicj4rPGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgaXB1X2Rl
diA9ICZhbXA7cGRldi0mZ3Q7ZGV2Ozxicj4rPGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgaXJx
MSA9IHBsYXRmb3JtX2dldF9pcnEocGRldiwgMCk7PGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsg
aXJxMiA9IHBsYXRmb3JtX2dldF9pcnEocGRldiwgMSk7PGJyPisgJm5ic3A7ICZuYnNwOyAmbmJz
cDsgcmVzID0gcGxhdGZvcm1fZ2V0X3Jlc291cmNlKHBkZXYsIElPUkVTT1VSQ0VfTUVNLCAwKTs8
YnI+Kzxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7IGlmICghcmVzIHx8IGlycTEgJmx0OyAwIHx8
IGlycTIgJmx0OyAwKTxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5i
c3A7ICZuYnNwOyByZXR1cm4gLUVOT0RFVjs8YnI+Kzxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7
IGlwdV9iYXNlID0gcmVzLSZndDtzdGFydDs8YnI+Kzxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7
IGlwdV9jbV9yZWcgPSBpb3JlbWFwKGlwdV9iYXNlICsgSVBVX0NNX1JFR19CQVNFLCBQQUdFX1NJ
WkUpOzxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7IGlmICghaXB1X2NtX3JlZykgezxicj4rICZu
YnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyByZXQgPSAtRU5P
TUVNOzxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNw
OyBnb3RvIGZhaWxlZF9pb3JlbWFwMTs8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyB9PGJyPis8
YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBpcHVfaWRtYWNfcmVnID0gaW9yZW1hcChpcHVfYmFz
ZSArIElQVV9JRE1BQ19SRUdfQkFTRSwgUEFHRV9TSVpFKTs8YnI+KyAmbmJzcDsgJm5ic3A7ICZu
YnNwOyBpZiAoIWlwdV9pZG1hY19yZWcpIHs8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJz
cDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgcmV0ID0gLUVOT01FTTs8YnI+KyAmbmJzcDsgJm5ic3A7
ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgZ290byBmYWlsZWRfaW9yZW1hcDI7
PGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgfTxicj4rPGJyPisgJm5ic3A7ICZuYnNwOyAmbmJz
cDsgcmV0ID0gaXB1X21pcGlfc2V0dXAoKTs8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBpZiAo
cmV0KTxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNw
OyBnb3RvIGZhaWxlZF9taXBpX3NldHVwOzxicj4rPGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsg
aXB1X2NsayA9IGNsa19nZXQoJmFtcDtwZGV2LSZndDtkZXYsICZxdW90O2lwdSZxdW90Oyk7PGJy
PisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgaWYgKElTX0VSUihpcHVfY2xrKSkgezxicj4rICZuYnNw
OyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyByZXQgPSBQVFJfRVJS
KGlwdV9jbGspOzxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7
ICZuYnNwOyBkZXZfZXJyKCZhbXA7cGRldi0mZ3Q7ZGV2LCAmcXVvdDtjbGtfZ2V0IGZhaWxlZCB3
aXRoICVkJnF1b3Q7LCByZXQpOzxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJz
cDsgJm5ic3A7ICZuYnNwOyBnb3RvIGZhaWxlZF9jbGtfZ2V0Ozxicj4rICZuYnNwOyAmbmJzcDsg
Jm5ic3A7IH08YnI+Kzxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7IGNsa19lbmFibGUoaXB1X2Ns
ayk7PGJyPis8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyByZXQgPSByZXF1ZXN0X2lycShpcnEx
LCBpcHVfaXJxX2hhbmRsZXIsIElSUUZfRElTQUJMRUQsIHBkZXYtJmd0O25hbWUsPGJyPisgJm5i
c3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJz
cDsgJm5ic3A7ICZuYnNwOyAmYW1wO3BkZXYtJmd0O2Rldik7PGJyPisgJm5ic3A7ICZuYnNwOyAm
bmJzcDsgaWYgKHJldCkgezxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsg
Jm5ic3A7ICZuYnNwOyBkZXZfZXJyKCZhbXA7cGRldi0mZ3Q7ZGV2LCAmcXVvdDtyZXF1ZXN0IGly
cSAlZCBmYWlsZWQgd2l0aDogJWRcbiZxdW90OywgaXJxMSwgcmV0KTs8YnI+KyAmbmJzcDsgJm5i
c3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgZ290byBmYWlsZWRfcmVxdWVz
dF9pcnExOzxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7IH08YnI+Kzxicj4rICZuYnNwOyAmbmJz
cDsgJm5ic3A7IHJldCA9IHJlcXVlc3RfaXJxKGlycTIsIGlwdV9pcnFfaGFuZGxlciwgSVJRRl9E
SVNBQkxFRCwgcGRldi0mZ3Q7bmFtZSw8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsg
Jm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZhbXA7cGRl
di0mZ3Q7ZGV2KTs8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBpZiAocmV0KSB7PGJyPisgJm5i
c3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7IGRldl9lcnIoJmFt
cDtwZGV2LSZndDtkZXYsICZxdW90O3JlcXVlc3QgaXJxICVkIGZhaWxlZCB3aXRoOiAlZFxuJnF1
b3Q7LCBpcnEyLCByZXQpOzxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsg
Jm5ic3A7ICZuYnNwOyBnb3RvIGZhaWxlZF9yZXF1ZXN0X2lycTI7PGJyPisgJm5ic3A7ICZuYnNw
OyAmbmJzcDsgfTxicj4rPGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgaXB1X3Jlc2V0KCk7PGJy
Pis8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyByZXQgPSBpcHVfc3VibW9kdWxlc19pbml0KHBk
ZXYsIGlwdV9iYXNlLCBpcHVfY2xrKTs8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBpZiAocmV0
KTxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBn
b3RvIGZhaWxlZF9zdWJtb2R1bGVzX2luaXQ7PGJyPis8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNw
OyAvKiBTZXQgc3luYyByZWZyZXNoIGNoYW5uZWxzIGFzIGhpZ2ggcHJpb3JpdHkgKi88YnI+KyAm
bmJzcDsgJm5ic3A7ICZuYnNwOyBpcHVfaWRtYWNfd3JpdGUoMHgxODgwMDAwMCwgSURNQUNfQ0hB
X1BSSSgwKSk7PGJyPis8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyByZXQgPSBpcHVfYWRkX2Ns
aWVudF9kZXZpY2VzKHBkZXYpOzxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwO2lmIChy
ZXQpIHs8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJz
cDsgJm5ic3A7ZGV2X2VycigmYW1wO3BkZXYtJmd0O2RldiwgJnF1b3Q7YWRkaW5nIGNsaWVudCBk
ZXZpY2VzIGZhaWxlZCB3aXRoICVkXG4mcXVvdDssIHJldCk7PGJyPisgJm5ic3A7ICZuYnNwOyAm
bmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7IGdvdG8gZmFpbGVkX2FkZF9jbGllbnRz
Ozxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwO308YnI+KzxzcGFuIHN0eWxlPSdjb2xv
cjojMUY0OTdEJz48bzpwPjwvbzpwPjwvc3Bhbj48L3A+PHAgY2xhc3M9TXNvTm9ybWFsPjxiPjxp
PjxzcGFuIHN0eWxlPSdmb250LXNpemU6MTEuMHB0O2ZvbnQtZmFtaWx5OiJDYWxpYnJpIiwic2Fu
cy1zZXJpZiI7Y29sb3I6IzFGNDk3RCc+W0phc29uXSBhZGQgY2xrX2Rpc2FibGUoaXB1X2Nsayk8
bzpwPjwvbzpwPjwvc3Bhbj48L2k+PC9iPjwvcD48cCBjbGFzcz1Nc29Ob3JtYWw+PGJyPisgJm5i
c3A7ICZuYnNwOyAmbmJzcDsgcmV0dXJuIDA7PGJyPis8YnI+K2ZhaWxlZF9hZGRfY2xpZW50czo8
YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBpcHVfc3VibW9kdWxlc19leGl0KHBkZXYsIGlwdV9i
YXNlKTs8YnI+K2ZhaWxlZF9zdWJtb2R1bGVzX2luaXQ6PGJyPisgJm5ic3A7ICZuYnNwOyAmbmJz
cDsgZnJlZV9pcnEoaXJxMiwgJmFtcDtwZGV2LSZndDtkZXYpOzxicj4rZmFpbGVkX3JlcXVlc3Rf
aXJxMjo8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBmcmVlX2lycShpcnExLCAmYW1wO3BkZXYt
Jmd0O2Rldik7PGJyPitmYWlsZWRfcmVxdWVzdF9pcnExOjxicj4rICZuYnNwOyAmbmJzcDsgJm5i
c3A7IGNsa19wdXQoaXB1X2Nsayk7PGJyPitmYWlsZWRfY2xrX2dldDo8YnI+K2ZhaWxlZF9taXBp
X3NldHVwOjxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7IGlvdW5tYXAoaXB1X2lkbWFjX3JlZyk7
PGJyPitmYWlsZWRfaW9yZW1hcDI6PGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgaW91bm1hcChp
cHVfY21fcmVnKTs8YnI+K2ZhaWxlZF9pb3JlbWFwMTo8YnI+Kzxicj4rICZuYnNwOyAmbmJzcDsg
Jm5ic3A7IHJldHVybiByZXQ7PGJyPit9PGJyPis8YnI+K3N0YXRpYyBpbnQgX19kZXZleGl0IGlw
dV9yZW1vdmUoc3RydWN0IHBsYXRmb3JtX2RldmljZSAqcGRldik8YnI+K3s8YnI+KyAmbmJzcDsg
Jm5ic3A7ICZuYnNwOyBzdHJ1Y3QgcmVzb3VyY2UgKnJlczs8YnI+KyAmbmJzcDsgJm5ic3A7ICZu
YnNwOyB1bnNpZ25lZCBsb25nIGlwdV9iYXNlOzxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7IGlu
dCBpcnExLCBpcnEyOzxicj4rPGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgaXJxMSA9IHBsYXRm
b3JtX2dldF9pcnEocGRldiwgMCk7PGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgaXJxMiA9IHBs
YXRmb3JtX2dldF9pcnEocGRldiwgMSk7PGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgcmVzID0g
cGxhdGZvcm1fZ2V0X3Jlc291cmNlKHBkZXYsIElPUkVTT1VSQ0VfTUVNLCAwKTs8YnI+KyAmbmJz
cDsgJm5ic3A7ICZuYnNwOyBpcHVfYmFzZSA9IHJlcy0mZ3Q7c3RhcnQ7PGJyPis8YnI+KyAmbmJz
cDsgJm5ic3A7ICZuYnNwOyBtZmRfcmVtb3ZlX2RldmljZXMoJmFtcDtwZGV2LSZndDtkZXYpOzxi
cj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7IGlwdV9zdWJtb2R1bGVzX2V4aXQocGRldiwgaXB1X2Jh
c2UpOzxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7IGZyZWVfaXJxKGlycTIsICZhbXA7cGRldi0m
Z3Q7ZGV2KTs8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBmcmVlX2lycShpcnExLCAmYW1wO3Bk
ZXYtJmd0O2Rldik7PGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgY2xrX2Rpc2FibGUoaXB1X2Ns
ayk7PGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgY2xrX3B1dChpcHVfY2xrKTs8YnI+KyAmbmJz
cDsgJm5ic3A7ICZuYnNwOyBpb3VubWFwKGlwdV9pZG1hY19yZWcpOzxicj4rICZuYnNwOyAmbmJz
cDsgJm5ic3A7IGlvdW5tYXAoaXB1X2NtX3JlZyk7PGJyPis8YnI+KyAmbmJzcDsgJm5ic3A7ICZu
YnNwOyByZXR1cm4gMDs8YnI+K308YnI+Kzxicj4rc3RhdGljIHN0cnVjdCBwbGF0Zm9ybV9kcml2
ZXIgbXhjaXB1X2RyaXZlciA9IHs8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAuZHJpdmVyID0g
ezxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAu
bmFtZSA9ICZxdW90O2lteC1pcHV2MyZxdW90Oyw8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyB9
LDxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7IC5wcm9iZSA9IGlwdV9wcm9iZSw8YnI+KyAmbmJz
cDsgJm5ic3A7ICZuYnNwOyAucmVtb3ZlID0gX19kZXZleGl0X3AoaXB1X3JlbW92ZSksPGJyPit9
Ozxicj4rPGJyPitzdGF0aWMgaW50IF9faW5pdCBpcHVfZ2VuX2luaXQodm9pZCk8YnI+K3s8YnI+
KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBpbnQzMl90IHJldDs8YnI+Kzxicj4rICZuYnNwOyAmbmJz
cDsgJm5ic3A7IHJldCA9IHBsYXRmb3JtX2RyaXZlcl9yZWdpc3RlcigmYW1wO214Y2lwdV9kcml2
ZXIpOzxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7IHJldHVybiAwOzxicj4rfTxicj4rc3Vic3lz
X2luaXRjYWxsKGlwdV9nZW5faW5pdCk7PGJyPis8YnI+K3N0YXRpYyB2b2lkIF9fZXhpdCBpcHVf
Z2VuX3VuaW5pdCh2b2lkKTxicj4rezxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7IHBsYXRmb3Jt
X2RyaXZlcl91bnJlZ2lzdGVyKCZhbXA7bXhjaXB1X2RyaXZlcik7PGJyPit9PGJyPittb2R1bGVf
ZXhpdChpcHVfZ2VuX3VuaW5pdCk7PGJyPis8YnI+K01PRFVMRV9ERVNDUklQVElPTigmcXVvdDtp
Lk1YIElQVSB2MyBkcml2ZXImcXVvdDspOzxicj4rTU9EVUxFX0FVVEhPUigmcXVvdDtTYXNjaGEg
SGF1ZXIgJmx0OzxhIGhyZWY9Im1haWx0bzpzLmhhdWVyQHBlbmd1dHJvbml4LmRlIj5zLmhhdWVy
QHBlbmd1dHJvbml4LmRlPC9hPiZndDsmcXVvdDspOzxicj4rTU9EVUxFX0xJQ0VOU0UoJnF1b3Q7
R1BMJnF1b3Q7KTs8YnI+ZGlmZiAtLWdpdCBhL2RyaXZlcnMvbWZkL2lteC1pcHUtdjMvaXB1LWNw
bWVtLmMgYi9kcml2ZXJzL21mZC9pbXgtaXB1LXYzL2lwdS1jcG1lbS5jPGJyPm5ldyBmaWxlIG1v
ZGUgMTAwNjQ0PGJyPmluZGV4IDAwMDAwMDAuLjU4N2I0ODc8YnI+LS0tIC9kZXYvbnVsbDxicj4r
KysgYi9kcml2ZXJzL21mZC9pbXgtaXB1LXYzL2lwdS1jcG1lbS5jPGJyPkBAIC0wLDAgKzEsNjA4
IEBAPGJyPisvKjxicj4rICogQ29weXJpZ2h0IChjKSAyMDEwIFNhc2NoYSBIYXVlciAmbHQ7PGEg
aHJlZj0ibWFpbHRvOnMuaGF1ZXJAcGVuZ3V0cm9uaXguZGUiPnMuaGF1ZXJAcGVuZ3V0cm9uaXgu
ZGU8L2E+Jmd0Ozxicj4rICogQ29weXJpZ2h0IChDKSAyMDA1LTIwMDkgRnJlZXNjYWxlIFNlbWlj
b25kdWN0b3IsIEluYy48YnI+KyAqPGJyPisgKiBUaGlzIHByb2dyYW0gaXMgZnJlZSBzb2Z0d2Fy
ZTsgeW91IGNhbiByZWRpc3RyaWJ1dGUgaXQgYW5kL29yIG1vZGlmeSBpdDxicj4rICogdW5kZXIg
dGhlIHRlcm1zIG9mIHRoZSBHTlUgR2VuZXJhbCBQdWJsaWMgTGljZW5zZSBhcyBwdWJsaXNoZWQg
YnkgdGhlPGJyPisgKiBGcmVlIFNvZnR3YXJlIEZvdW5kYXRpb247IGVpdGhlciB2ZXJzaW9uIDIg
b2YgdGhlIExpY2Vuc2UsIG9yIChhdCB5b3VyPGJyPisgKiBvcHRpb24pIGFueSBsYXRlciB2ZXJz
aW9uLjxicj4rICo8YnI+KyAqIFRoaXMgcHJvZ3JhbSBpcyBkaXN0cmlidXRlZCBpbiB0aGUgaG9w
ZSB0aGF0IGl0IHdpbGwgYmUgdXNlZnVsLCBidXQ8YnI+KyAqIFdJVEhPVVQgQU5ZIFdBUlJBTlRZ
OyB3aXRob3V0IGV2ZW4gdGhlIGltcGxpZWQgd2FycmFudHkgb2YgTUVSQ0hBTlRBQklMSVRZPGJy
PisgKiBvciBGSVRORVNTIEZPUiBBIFBBUlRJQ1VMQVIgUFVSUE9TRS4gJm5ic3A7U2VlIHRoZSBH
TlUgR2VuZXJhbCBQdWJsaWMgTGljZW5zZTxicj4rICogZm9yIG1vcmUgZGV0YWlscy48YnI+KyAq
Lzxicj4rPGJyPisjaW5jbHVkZSAmbHQ7bGludXgva2VybmVsLmgmZ3Q7PGJyPisjaW5jbHVkZSAm
bHQ7bGludXgvZGV2aWNlLmgmZ3Q7PGJyPisjaW5jbHVkZSAmbHQ7bGludXgvbWZkL2lteC1pcHUt
djMuaCZndDs8YnI+KyNpbmNsdWRlICZsdDtsaW51eC90eXBlcy5oJmd0Ozxicj4rI2luY2x1ZGUg
Jmx0O2xpbnV4L2JpdHJldi5oJmd0Ozxicj4rI2luY2x1ZGUgJmx0O2xpbnV4L2lvLmgmZ3Q7PGJy
Pis8YnI+KyNpbmNsdWRlICZxdW90O2lwdS1wcnYuaCZxdW90Ozxicj4rPGJyPisjZGVmaW5lIF9f
Rih3b3JkLCBvZnMsIHNpemUpICgoKCh3b3JkKSAqIDE2MCArIChvZnMpKSAmbHQ7Jmx0OyA4KSB8
IChzaXplKSk8YnI+Kzxicj4rI2RlZmluZSBJUFVfRklFTERfWFYgJm5ic3A7ICZuYnNwOyAmbmJz
cDsgJm5ic3A7ICZuYnNwOyBfX0YoMCwgMCwgMTApPGJyPisjZGVmaW5lIElQVV9GSUVMRF9ZViAm
bmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7IF9fRigwLCAxMCwgOSk8YnI+KyNkZWZp
bmUgSVBVX0ZJRUxEX1hCICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgX19GKDAs
IDE5LCAxMyk8YnI+KyNkZWZpbmUgSVBVX0ZJRUxEX1lCICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZu
YnNwOyAmbmJzcDsgX19GKDAsIDMyLCAxMik8YnI+KyNkZWZpbmUgSVBVX0ZJRUxEX05TQl9CICZu
YnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDtfX0Yo
MCwgNDQsIDEpPGJyPisjZGVmaW5lIElQVV9GSUVMRF9DRiAmbmJzcDsgJm5ic3A7ICZuYnNwOyAm
bmJzcDsgJm5ic3A7IF9fRigwLCA0NSwgMSk8YnI+KyNkZWZpbmUgSVBVX0ZJRUxEX1VCTyAmbmJz
cDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7X19GKDAsIDQ2LCAyMik8YnI+KyNkZWZpbmUg
SVBVX0ZJRUxEX1ZCTyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7X19GKDAsIDY4
LCAyMik8YnI+KyNkZWZpbmUgSVBVX0ZJRUxEX0lPWCAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJz
cDsgJm5ic3A7X19GKDAsIDkwLCA0KTxicj4rI2RlZmluZSBJUFVfRklFTERfUkRSVyAmbmJzcDsg
Jm5ic3A7ICZuYnNwOyAmbmJzcDsgX19GKDAsIDk0LCAxKTxicj4rI2RlZmluZSBJUFVfRklFTERf
U08gJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBfX0YoMCwgMTEzLCAxKTxicj4r
I2RlZmluZSBJUFVfRklFTERfQk5ETSAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgX19GKDAs
IDExNCwgMyk8YnI+KyNkZWZpbmUgSVBVX0ZJRUxEX0JNICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZu
YnNwOyAmbmJzcDsgX19GKDAsIDExNywgMik8YnI+KyNkZWZpbmUgSVBVX0ZJRUxEX1JPVCAmbmJz
cDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7X19GKDAsIDExOSwgMSk8YnI+KyNkZWZpbmUg
SVBVX0ZJRUxEX0hGICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgX19GKDAsIDEy
MCwgMSk8YnI+KyNkZWZpbmUgSVBVX0ZJRUxEX1ZGICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNw
OyAmbmJzcDsgX19GKDAsIDEyMSwgMSk8YnI+KyNkZWZpbmUgSVBVX0ZJRUxEX1RIRSAmbmJzcDsg
Jm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7X19GKDAsIDEyMiwgMSk8YnI+KyNkZWZpbmUgSVBV
X0ZJRUxEX0NBUCAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7X19GKDAsIDEyMywg
MSk8YnI+KyNkZWZpbmUgSVBVX0ZJRUxEX0NBRSAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsg
Jm5ic3A7X19GKDAsIDEyNCwgMSk8YnI+KyNkZWZpbmUgSVBVX0ZJRUxEX0ZXICZuYnNwOyAmbmJz
cDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgX19GKDAsIDEyNSwgMTMpPGJyPisjZGVmaW5lIElQVV9G
SUVMRF9GSCAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7IF9fRigwLCAxMzgsIDEy
KTxicj4rI2RlZmluZSBJUFVfRklFTERfRUJBMCAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsg
X19GKDEsIDAsIDI5KTxicj4rI2RlZmluZSBJUFVfRklFTERfRUJBMSAmbmJzcDsgJm5ic3A7ICZu
YnNwOyAmbmJzcDsgX19GKDEsIDI5LCAyOSk8YnI+KyNkZWZpbmUgSVBVX0ZJRUxEX0lMTyAmbmJz
cDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7X19GKDEsIDU4LCAyMCk8YnI+KyNkZWZpbmUg
SVBVX0ZJRUxEX05QQiAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7X19GKDEsIDc4
LCA3KTxicj4rI2RlZmluZSBJUFVfRklFTERfUEZTICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNw
OyAmbmJzcDtfX0YoMSwgODUsIDQpPGJyPisjZGVmaW5lIElQVV9GSUVMRF9BTFUgJm5ic3A7ICZu
YnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwO19fRigxLCA4OSwgMSk8YnI+KyNkZWZpbmUgSVBVX0ZJ
RUxEX0FMQk0gJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7IF9fRigxLCA5MCwgMyk8YnI+KyNk
ZWZpbmUgSVBVX0ZJRUxEX0lEICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgX19G
KDEsIDkzLCAyKTxicj4rI2RlZmluZSBJUFVfRklFTERfVEggJm5ic3A7ICZuYnNwOyAmbmJzcDsg
Jm5ic3A7ICZuYnNwOyBfX0YoMSwgOTUsIDcpPGJyPisjZGVmaW5lIElQVV9GSUVMRF9TTFkgJm5i
c3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwO19fRigxLCAxMDIsIDE0KTxicj4rI2RlZmlu
ZSBJUFVfRklFTERfV0lEMyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgX19GKDEsIDEyNSwg
Myk8YnI+KyNkZWZpbmUgSVBVX0ZJRUxEX1NMVVYgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7
IF9fRigxLCAxMjgsIDE0KTxicj4rI2RlZmluZSBJUFVfRklFTERfQ1JFICZuYnNwOyAmbmJzcDsg
Jm5ic3A7ICZuYnNwOyAmbmJzcDtfX0YoMSwgMTQ5LCAxKTxicj4rPGJyPisjZGVmaW5lIElQVV9G
SUVMRF9YViAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7IF9fRigwLCAwLCAxMCk8
YnI+KyNkZWZpbmUgSVBVX0ZJRUxEX1lWICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJz
cDsgX19GKDAsIDEwLCA5KTxicj4rI2RlZmluZSBJUFVfRklFTERfWEIgJm5ic3A7ICZuYnNwOyAm
bmJzcDsgJm5ic3A7ICZuYnNwOyBfX0YoMCwgMTksIDEzKTxicj4rI2RlZmluZSBJUFVfRklFTERf
WUIgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBfX0YoMCwgMzIsIDEyKTxicj4r
I2RlZmluZSBJUFVfRklFTERfTlNCX0IgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNw
OyAmbmJzcDsgJm5ic3A7ICZuYnNwO19fRigwLCA0NCwgMSk8YnI+KyNkZWZpbmUgSVBVX0ZJRUxE
X0NGICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgX19GKDAsIDQ1LCAxKTxicj4r
I2RlZmluZSBJUFVfRklFTERfU1ggJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBf
X0YoMCwgNDYsIDEyKTxicj4rI2RlZmluZSBJUFVfRklFTERfU1kgJm5ic3A7ICZuYnNwOyAmbmJz
cDsgJm5ic3A7ICZuYnNwOyBfX0YoMCwgNTgsIDExKTxicj4rI2RlZmluZSBJUFVfRklFTERfTlMg
Jm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBfX0YoMCwgNjksIDEwKTxicj4rI2Rl
ZmluZSBJUFVfRklFTERfU0RYICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDtfX0Yo
MCwgNzksIDcpPGJyPisjZGVmaW5lIElQVV9GSUVMRF9TTSAmbmJzcDsgJm5ic3A7ICZuYnNwOyAm
bmJzcDsgJm5ic3A7IF9fRigwLCA4NiwgMTApPGJyPisjZGVmaW5lIElQVV9GSUVMRF9TQ0MgJm5i
c3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwO19fRigwLCA5NiwgMSk8YnI+KyNkZWZpbmUg
SVBVX0ZJRUxEX1NDRSAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7X19GKDAsIDk3
LCAxKTxicj4rI2RlZmluZSBJUFVfRklFTERfU0RZICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNw
OyAmbmJzcDtfX0YoMCwgOTgsIDcpPGJyPisjZGVmaW5lIElQVV9GSUVMRF9TRFJYICZuYnNwOyAm
bmJzcDsgJm5ic3A7ICZuYnNwOyBfX0YoMCwgMTA1LCAxKTxicj4rI2RlZmluZSBJUFVfRklFTERf
U0RSWSAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgX19GKDAsIDEwNiwgMSk8YnI+KyNkZWZp
bmUgSVBVX0ZJRUxEX0JQUCAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7X19GKDAs
IDEwNywgMyk8YnI+KyNkZWZpbmUgSVBVX0ZJRUxEX0RFQ19TRUwgJm5ic3A7ICZuYnNwOyAmbmJz
cDtfX0YoMCwgMTEwLCAyKTxicj4rI2RlZmluZSBJUFVfRklFTERfRElNICZuYnNwOyAmbmJzcDsg
Jm5ic3A7ICZuYnNwOyAmbmJzcDtfX0YoMCwgMTEyLCAxKTxicj4rI2RlZmluZSBJUFVfRklFTERf
U08gJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBfX0YoMCwgMTEzLCAxKTxicj4r
I2RlZmluZSBJUFVfRklFTERfQk5ETSAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgX19GKDAs
IDExNCwgMyk8YnI+KyNkZWZpbmUgSVBVX0ZJRUxEX0JNICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZu
YnNwOyAmbmJzcDsgX19GKDAsIDExNywgMik8YnI+KyNkZWZpbmUgSVBVX0ZJRUxEX1JPVCAmbmJz
cDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7X19GKDAsIDExOSwgMSk8YnI+KyNkZWZpbmUg
SVBVX0ZJRUxEX0hGICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgX19GKDAsIDEy
MCwgMSk8YnI+KyNkZWZpbmUgSVBVX0ZJRUxEX1ZGICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNw
OyAmbmJzcDsgX19GKDAsIDEyMSwgMSk8YnI+KyNkZWZpbmUgSVBVX0ZJRUxEX1RIRSAmbmJzcDsg
Jm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7X19GKDAsIDEyMiwgMSk8YnI+KyNkZWZpbmUgSVBV
X0ZJRUxEX0NBUCAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7X19GKDAsIDEyMywg
MSk8YnI+KyNkZWZpbmUgSVBVX0ZJRUxEX0NBRSAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsg
Jm5ic3A7X19GKDAsIDEyNCwgMSk8YnI+KyNkZWZpbmUgSVBVX0ZJRUxEX0ZXICZuYnNwOyAmbmJz
cDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgX19GKDAsIDEyNSwgMTMpPGJyPisjZGVmaW5lIElQVV9G
SUVMRF9GSCAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7IF9fRigwLCAxMzgsIDEy
KTxicj4rI2RlZmluZSBJUFVfRklFTERfRUJBMCAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsg
X19GKDEsIDAsIDI5KTxicj4rI2RlZmluZSBJUFVfRklFTERfRUJBMSAmbmJzcDsgJm5ic3A7ICZu
YnNwOyAmbmJzcDsgX19GKDEsIDI5LCAyOSk8YnI+KyNkZWZpbmUgSVBVX0ZJRUxEX0lMTyAmbmJz
cDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7X19GKDEsIDU4LCAyMCk8YnI+KyNkZWZpbmUg
SVBVX0ZJRUxEX05QQiAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7X19GKDEsIDc4
LCA3KTxicj4rI2RlZmluZSBJUFVfRklFTERfUEZTICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNw
OyAmbmJzcDtfX0YoMSwgODUsIDQpPGJyPisjZGVmaW5lIElQVV9GSUVMRF9BTFUgJm5ic3A7ICZu
YnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwO19fRigxLCA4OSwgMSk8YnI+KyNkZWZpbmUgSVBVX0ZJ
RUxEX0FMQk0gJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7IF9fRigxLCA5MCwgMyk8YnI+KyNk
ZWZpbmUgSVBVX0ZJRUxEX0lEICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgX19G
KDEsIDkzLCAyKTxicj4rI2RlZmluZSBJUFVfRklFTERfVEggJm5ic3A7ICZuYnNwOyAmbmJzcDsg
Jm5ic3A7ICZuYnNwOyBfX0YoMSwgOTUsIDcpPGJyPisjZGVmaW5lIElQVV9GSUVMRF9TTCAmbmJz
cDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7IF9fRigxLCAxMDIsIDE0KTxicj4rI2RlZmlu
ZSBJUFVfRklFTERfV0lEMCAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgX19GKDEsIDExNiwg
Myk8YnI+KyNkZWZpbmUgSVBVX0ZJRUxEX1dJRDEgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7
IF9fRigxLCAxMTksIDMpPGJyPisjZGVmaW5lIElQVV9GSUVMRF9XSUQyICZuYnNwOyAmbmJzcDsg
Jm5ic3A7ICZuYnNwOyBfX0YoMSwgMTIyLCAzKTxicj4rI2RlZmluZSBJUFVfRklFTERfV0lEMyAm
bmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgX19GKDEsIDEyNSwgMyk8YnI+KyNkZWZpbmUgSVBV
X0ZJRUxEX09GUzAgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7IF9fRigxLCAxMjgsIDUpPGJy
PisjZGVmaW5lIElQVV9GSUVMRF9PRlMxICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBfX0Yo
MSwgMTMzLCA1KTxicj4rI2RlZmluZSBJUFVfRklFTERfT0ZTMiAmbmJzcDsgJm5ic3A7ICZuYnNw
OyAmbmJzcDsgX19GKDEsIDEzOCwgNSk8YnI+KyNkZWZpbmUgSVBVX0ZJRUxEX09GUzMgJm5ic3A7
ICZuYnNwOyAmbmJzcDsgJm5ic3A7IF9fRigxLCAxNDMsIDUpPGJyPisjZGVmaW5lIElQVV9GSUVM
RF9TWFlTICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBfX0YoMSwgMTQ4LCAxKTxicj4rI2Rl
ZmluZSBJUFVfRklFTERfQ1JFICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDtfX0Yo
MSwgMTQ5LCAxKTxicj4rI2RlZmluZSBJUFVfRklFTERfREVDX1NFTDIgJm5ic3A7ICZuYnNwOyBf
X0YoMSwgMTUwLCAxKTxicj4rPGJyPitzdGF0aWMgdTMyICppcHVfY3BtZW1fYmFzZTs8YnI+K3N0
YXRpYyBzdHJ1Y3QgZGV2aWNlICppcHVfZGV2Ozxicj4rPGJyPitzdHJ1Y3QgaXB1X2NoX3BhcmFt
X3dvcmQgezxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7IHUzMiBkYXRhWzVdOzxicj4rICZuYnNw
OyAmbmJzcDsgJm5ic3A7IHUzMiByZXNbM107PGJyPit9Ozxicj4rPGJyPitzdHJ1Y3QgaXB1X2No
X3BhcmFtIHs8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBzdHJ1Y3QgaXB1X2NoX3BhcmFtX3dv
cmQgd29yZFsyXTs8YnI+K307PGJyPis8YnI+K3N0YXRpYyB1MzIgaXB1X2J5dGVzX3Blcl9waXhl
bCh1MzIgZm10KTxicj4rezxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7IHN3aXRjaCAoZm10KSB7
PGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgY2FzZSBJUFVfUElYX0ZNVF9HRU5FUklDOiAmbmJz
cDsgJm5ic3A7ICZuYnNwOyAvKiBnZW5lcmljIGRhdGEgKi88YnI+KyAmbmJzcDsgJm5ic3A7ICZu
YnNwOyBjYXNlIElQVV9QSVhfRk1UX1JHQjMzMjo8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBj
YXNlIElQVV9QSVhfRk1UX1lVVjQyMFA6PGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgY2FzZSBJ
UFVfUElYX0ZNVF9ZVVY0MjJQOjxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJz
cDsgJm5ic3A7ICZuYnNwOyByZXR1cm4gMTs8YnI+Kzxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7
IGNhc2UgSVBVX1BJWF9GTVRfUkdCNTY1Ojxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7IGNhc2Ug
SVBVX1BJWF9GTVRfWVVZVjo8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBjYXNlIElQVV9QSVhf
Rk1UX1VZVlk6PGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsg
Jm5ic3A7IHJldHVybiAyOzxicj4rPGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgY2FzZSBJUFVf
UElYX0ZNVF9CR1IyNDo8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBjYXNlIElQVV9QSVhfRk1U
X1JHQjI0Ojxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZu
YnNwOyByZXR1cm4gMzs8YnI+Kzxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7IGNhc2UgSVBVX1BJ
WF9GTVRfR0VORVJJQ18zMjogJm5ic3A7ICZuYnNwOy8qIGdlbmVyaWMgZGF0YSAqLzxicj4rICZu
YnNwOyAmbmJzcDsgJm5ic3A7IGNhc2UgSVBVX1BJWF9GTVRfQkdSMzI6PGJyPisgJm5ic3A7ICZu
YnNwOyAmbmJzcDsgY2FzZSBJUFVfUElYX0ZNVF9CR1JBMzI6PGJyPisgJm5ic3A7ICZuYnNwOyAm
bmJzcDsgY2FzZSBJUFVfUElYX0ZNVF9SR0IzMjo8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBj
YXNlIElQVV9QSVhfRk1UX1JHQkEzMjo8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBjYXNlIElQ
VV9QSVhfRk1UX0FCR1IzMjo8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7
ICZuYnNwOyAmbmJzcDsgcmV0dXJuIDQ7PGJyPis8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBk
ZWZhdWx0Ojxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZu
YnNwOyByZXR1cm4gMTs8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyB9PGJyPit9PGJyPis8YnI+
K2Jvb2wgaXB1X3BpeGVsX2Zvcm1hdF9oYXNfYWxwaGEodTMyIGZtdCk8YnI+K3s8YnI+KyAmbmJz
cDsgJm5ic3A7ICZuYnNwOyBzd2l0Y2ggKGZtdCkgezxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7
IGNhc2UgSVBVX1BJWF9GTVRfUkdCQTMyOjxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7IGNhc2Ug
SVBVX1BJWF9GTVRfQkdSQTMyOjxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7IGNhc2UgSVBVX1BJ
WF9GTVRfQUJHUjMyOjxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5i
c3A7ICZuYnNwOyByZXR1cm4gdHJ1ZTs8YnI+Kzxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7IGRl
ZmF1bHQ6PGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5i
c3A7IHJldHVybiBmYWxzZTs8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyB9PGJyPit9PGJyPis8
YnI+KyNkZWZpbmUgaXB1X2NoX3BhcmFtX2FkZHIoY2gpICgoKHN0cnVjdCBpcHVfY2hfcGFyYW0g
KilpcHVfY3BtZW1fYmFzZSkgKyAoY2gpKTxicj4rPGJyPitzdGF0aWMgaW5saW5lIHZvaWQgaXB1
X2NoX3BhcmFtX3NldF9maWVsZChzdHJ1Y3QgaXB1X2NoX3BhcmFtICpiYXNlLCB1MzIgd2JzLCB1
MzIgdik8YnI+K3s8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyB1MzIgYml0ID0gKHdicyAmZ3Q7
Jmd0OyA4KSAlIDE2MDs8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyB1MzIgc2l6ZSA9IHdicyAm
YW1wOyAweGZmOzxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7IHUzMiB3b3JkID0gKHdicyAmZ3Q7
Jmd0OyA4KSAvIDE2MDs8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyB1MzIgaSA9IGJpdCAvIDMy
Ozxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7IHUzMiBvZnMgPSBiaXQgJSAzMjs8YnI+KyAmbmJz
cDsgJm5ic3A7ICZuYnNwOyB1MzIgbWFzayA9ICgxICZsdDsmbHQ7IHNpemUpIC0gMTs8YnI+Kzxi
cj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7IHByX2RlYnVnKCZxdW90OyVzICVkICVkICVkXG4mcXVv
dDssIF9fZnVuY19fLCB3b3JkLCBiaXQgLCBzaXplKTs8YnI+Kzxicj4rICZuYnNwOyAmbmJzcDsg
Jm5ic3A7IGJhc2UtJmd0O3dvcmRbd29yZF0uZGF0YVtpXSAmYW1wOz0gfihtYXNrICZsdDsmbHQ7
IG9mcyk7PGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgYmFzZS0mZ3Q7d29yZFt3b3JkXS5kYXRh
W2ldIHw9IHYgJmx0OyZsdDsgb2ZzOzxicj4rPGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgaWYg
KChiaXQgKyBzaXplIC0gMSkgLyAzMiAmZ3Q7IGkpIHs8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNw
OyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgYmFzZS0mZ3Q7d29yZFt3b3JkXS5kYXRhW2kg
KyAxXSAmYW1wOz0gfih2ICZndDsmZ3Q7IChtYXNrID8gKDMyIC0gb2ZzKSA6IDApKTs8YnI+KyAm
bmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgYmFzZS0mZ3Q7
d29yZFt3b3JkXS5kYXRhW2kgKyAxXSB8PSB2ICZndDsmZ3Q7IChvZnMgPyAoMzIgLSBvZnMpIDog
MCk7PGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgfTxicj4rfTxicj4rPGJyPitzdGF0aWMgaW5s
aW5lIHUzMiBpcHVfY2hfcGFyYW1fcmVhZF9maWVsZChzdHJ1Y3QgaXB1X2NoX3BhcmFtICpiYXNl
LCB1MzIgd2JzKTxicj4rezxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7IHUzMiBiaXQgPSAod2Jz
ICZndDsmZ3Q7IDgpICUgMTYwOzxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7IHUzMiBzaXplID0g
d2JzICZhbXA7IDB4ZmY7PGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgdTMyIHdvcmQgPSAod2Jz
ICZndDsmZ3Q7IDgpIC8gMTYwOzxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7IHUzMiBpID0gYml0
IC8gMzI7PGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgdTMyIG9mcyA9IGJpdCAlIDMyOzxicj4r
ICZuYnNwOyAmbmJzcDsgJm5ic3A7IHUzMiBtYXNrID0gKDEgJmx0OyZsdDsgc2l6ZSkgLSAxOzxi
cj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7IHUzMiB2YWwgPSAwOzxicj4rPGJyPisgJm5ic3A7ICZu
YnNwOyAmbmJzcDsgcHJfZGVidWcoJnF1b3Q7JXMgJWQgJWQgJWRcbiZxdW90OywgX19mdW5jX18s
IHdvcmQsIGJpdCAsIHNpemUpOzxicj4rPGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgdmFsID0g
KGJhc2UtJmd0O3dvcmRbd29yZF0uZGF0YVtpXSAmZ3Q7Jmd0OyBvZnMpICZhbXA7IG1hc2s7PGJy
Pis8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBpZiAoKGJpdCArIHNpemUgLSAxKSAvIDMyICZn
dDsgaSkgezxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZu
YnNwOyB1MzIgdG1wOzxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5i
c3A7ICZuYnNwOyB0bXAgPSBiYXNlLSZndDt3b3JkW3dvcmRdLmRhdGFbaSArIDFdOzxicj4rICZu
YnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyB0bXAgJmFtcDs9
IG1hc2sgJmd0OyZndDsgKG9mcyA/ICgzMiAtIG9mcykgOiAwKTs8YnI+KyAmbmJzcDsgJm5ic3A7
ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgdmFsIHw9IHRtcCAmbHQ7Jmx0OyAo
b2ZzID8gKDMyIC0gb2ZzKSA6IDApOzxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7IH08YnI+Kzxi
cj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7IHJldHVybiB2YWw7PGJyPit9PGJyPis8YnI+K3N0YXRp
YyBpbmxpbmUgdm9pZCBpcHVfY2hfcGFyYW1zX3NldF9wYWNraW5nKHN0cnVjdCBpcHVfY2hfcGFy
YW0gKnAsPGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5i
c3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJz
cDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7IGludCBy
ZWRfd2lkdGgsIGludCByZWRfb2Zmc2V0LDxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNw
OyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7
ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsg
Jm5ic3A7ICZuYnNwOyBpbnQgZ3JlZW5fd2lkdGgsIGludCBncmVlbl9vZmZzZXQsPGJyPisgJm5i
c3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJz
cDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNw
OyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7IGludCBibHVlX3dpZHRoLCBpbnQg
Ymx1ZV9vZmZzZXQsPGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJz
cDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNw
OyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7
IGludCBhbHBoYV93aWR0aCwgaW50IGFscGhhX29mZnNldCk8YnI+K3s8YnI+KyAmbmJzcDsgJm5i
c3A7ICZuYnNwOyAvKiBTZXR1cCByZWQgd2lkdGggYW5kIG9mZnNldCAqLzxicj4rICZuYnNwOyAm
bmJzcDsgJm5ic3A7IGlwdV9jaF9wYXJhbV9zZXRfZmllbGQocCwgSVBVX0ZJRUxEX1dJRDAsIHJl
ZF93aWR0aCAtIDEpOzxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7IGlwdV9jaF9wYXJhbV9zZXRf
ZmllbGQocCwgSVBVX0ZJRUxEX09GUzAsIHJlZF9vZmZzZXQpOzxicj4rICZuYnNwOyAmbmJzcDsg
Jm5ic3A7IC8qIFNldHVwIGdyZWVuIHdpZHRoIGFuZCBvZmZzZXQgKi88YnI+KyAmbmJzcDsgJm5i
c3A7ICZuYnNwOyBpcHVfY2hfcGFyYW1fc2V0X2ZpZWxkKHAsIElQVV9GSUVMRF9XSUQxLCBncmVl
bl93aWR0aCAtIDEpOzxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7IGlwdV9jaF9wYXJhbV9zZXRf
ZmllbGQocCwgSVBVX0ZJRUxEX09GUzEsIGdyZWVuX29mZnNldCk7PGJyPisgJm5ic3A7ICZuYnNw
OyAmbmJzcDsgLyogU2V0dXAgYmx1ZSB3aWR0aCBhbmQgb2Zmc2V0ICovPGJyPisgJm5ic3A7ICZu
YnNwOyAmbmJzcDsgaXB1X2NoX3BhcmFtX3NldF9maWVsZChwLCBJUFVfRklFTERfV0lEMiwgYmx1
ZV93aWR0aCAtIDEpOzxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7IGlwdV9jaF9wYXJhbV9zZXRf
ZmllbGQocCwgSVBVX0ZJRUxEX09GUzIsIGJsdWVfb2Zmc2V0KTs8YnI+KyAmbmJzcDsgJm5ic3A7
ICZuYnNwOyAvKiBTZXR1cCBhbHBoYSB3aWR0aCBhbmQgb2Zmc2V0ICovPGJyPisgJm5ic3A7ICZu
YnNwOyAmbmJzcDsgaXB1X2NoX3BhcmFtX3NldF9maWVsZChwLCBJUFVfRklFTERfV0lEMywgYWxw
aGFfd2lkdGggLSAxKTs8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBpcHVfY2hfcGFyYW1fc2V0
X2ZpZWxkKHAsIElQVV9GSUVMRF9PRlMzLCBhbHBoYV9vZmZzZXQpOzxicj4rfTxicj4rPGJyPitz
dGF0aWMgaW5saW5lIHZvaWQgaXB1X2NoX3BhcmFtX2R1bXAoaW50IGNoKTxicj4rezxicj4rICZu
YnNwOyAmbmJzcDsgJm5ic3A7IHN0cnVjdCBpcHVfY2hfcGFyYW0gKnAgPSBpcHVfY2hfcGFyYW1f
YWRkcihjaCk7PGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgcHJfZGVidWcoJnF1b3Q7Y2ggJWQg
d29yZCAwIC0gJTA4WCAlMDhYICUwOFggJTA4WCAlMDhYXG4mcXVvdDssIGNoLDxicj4rICZuYnNw
OyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDtwLSZndDt3
b3JkWzBdLmRhdGFbMF0sIHAtJmd0O3dvcmRbMF0uZGF0YVsxXSwgcC0mZ3Q7d29yZFswXS5kYXRh
WzJdLDxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNw
OyAmbmJzcDtwLSZndDt3b3JkWzBdLmRhdGFbM10sIHAtJmd0O3dvcmRbMF0uZGF0YVs0XSk7PGJy
PisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgcHJfZGVidWcoJnF1b3Q7Y2ggJWQgd29yZCAxIC0gJTA4
WCAlMDhYICUwOFggJTA4WCAlMDhYXG4mcXVvdDssIGNoLDxicj4rICZuYnNwOyAmbmJzcDsgJm5i
c3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDtwLSZndDt3b3JkWzFdLmRhdGFb
MF0sIHAtJmd0O3dvcmRbMV0uZGF0YVsxXSwgcC0mZ3Q7d29yZFsxXS5kYXRhWzJdLDxicj4rICZu
YnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDtwLSZn
dDt3b3JkWzFdLmRhdGFbM10sIHAtJmd0O3dvcmRbMV0uZGF0YVs0XSk7PGJyPisgJm5ic3A7ICZu
YnNwOyAmbmJzcDsgcHJfZGVidWcoJnF1b3Q7UEZTIDB4JXhcbiZxdW90OywgaXB1X2NoX3BhcmFt
X3JlYWRfZmllbGQocCwgSVBVX0ZJRUxEX1BGUykpOzxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7
IHByX2RlYnVnKCZxdW90O0JQUCAweCV4XG4mcXVvdDssIGlwdV9jaF9wYXJhbV9yZWFkX2ZpZWxk
KHAsIElQVV9GSUVMRF9CUFApKTs8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBwcl9kZWJ1Zygm
cXVvdDtOUEIgMHgleFxuJnF1b3Q7LCBpcHVfY2hfcGFyYW1fcmVhZF9maWVsZChwLCBJUFVfRklF
TERfTlBCKSk7PGJyPis8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBwcl9kZWJ1ZygmcXVvdDtG
VyAlZFxuJnF1b3Q7LCBpcHVfY2hfcGFyYW1fcmVhZF9maWVsZChwLCBJUFVfRklFTERfRlcpKTs8
YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBwcl9kZWJ1ZygmcXVvdDtGSCAlZFxuJnF1b3Q7LCBp
cHVfY2hfcGFyYW1fcmVhZF9maWVsZChwLCBJUFVfRklFTERfRkgpKTs8YnI+KyAmbmJzcDsgJm5i
c3A7ICZuYnNwOyBwcl9kZWJ1ZygmcXVvdDtTdHJpZGUgJWRcbiZxdW90OywgaXB1X2NoX3BhcmFt
X3JlYWRfZmllbGQocCwgSVBVX0ZJRUxEX1NMKSk7PGJyPis8YnI+KyAmbmJzcDsgJm5ic3A7ICZu
YnNwOyBwcl9kZWJ1ZygmcXVvdDtXaWR0aDAgJWQrMVxuJnF1b3Q7LCBpcHVfY2hfcGFyYW1fcmVh
ZF9maWVsZChwLCBJUFVfRklFTERfV0lEMCkpOzxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7IHBy
X2RlYnVnKCZxdW90O1dpZHRoMSAlZCsxXG4mcXVvdDssIGlwdV9jaF9wYXJhbV9yZWFkX2ZpZWxk
KHAsIElQVV9GSUVMRF9XSUQxKSk7PGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgcHJfZGVidWco
JnF1b3Q7V2lkdGgyICVkKzFcbiZxdW90OywgaXB1X2NoX3BhcmFtX3JlYWRfZmllbGQocCwgSVBV
X0ZJRUxEX1dJRDIpKTs8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBwcl9kZWJ1ZygmcXVvdDtX
aWR0aDMgJWQrMVxuJnF1b3Q7LCBpcHVfY2hfcGFyYW1fcmVhZF9maWVsZChwLCBJUFVfRklFTERf
V0lEMykpOzxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7IHByX2RlYnVnKCZxdW90O09mZnNldDAg
JWRcbiZxdW90OywgaXB1X2NoX3BhcmFtX3JlYWRfZmllbGQocCwgSVBVX0ZJRUxEX09GUzApKTs8
YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBwcl9kZWJ1ZygmcXVvdDtPZmZzZXQxICVkXG4mcXVv
dDssIGlwdV9jaF9wYXJhbV9yZWFkX2ZpZWxkKHAsIElQVV9GSUVMRF9PRlMxKSk7PGJyPisgJm5i
c3A7ICZuYnNwOyAmbmJzcDsgcHJfZGVidWcoJnF1b3Q7T2Zmc2V0MiAlZFxuJnF1b3Q7LCBpcHVf
Y2hfcGFyYW1fcmVhZF9maWVsZChwLCBJUFVfRklFTERfT0ZTMikpOzxicj4rICZuYnNwOyAmbmJz
cDsgJm5ic3A7IHByX2RlYnVnKCZxdW90O09mZnNldDMgJWRcbiZxdW90OywgaXB1X2NoX3BhcmFt
X3JlYWRfZmllbGQocCwgSVBVX0ZJRUxEX09GUzMpKTs8YnI+K308YnI+Kzxicj4rc3RhdGljIGlu
bGluZSB2b2lkIGlwdV9jaF9wYXJhbV9zZXRfYnVyc3Rfc2l6ZSh1MzIgY2gsPGJyPisgJm5ic3A7
ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsg
Jm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAm
bmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyB1MTYgYnVyc3RfcGl4ZWxz
KTxicj4rezxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7IGlwdV9jaF9wYXJhbV9zZXRfZmllbGQo
aXB1X2NoX3BhcmFtX2FkZHIoY2gpLCBJUFVfRklFTERfTlBCLDxicj4rICZuYnNwOyAmbmJzcDsg
Jm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAm
bmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7YnVyc3RfcGl4ZWxzIC0gMSk7PGJyPit9
Ozxicj4rPGJyPitzdGF0aWMgaW5saW5lIGludCBpcHVfY2hfcGFyYW1fZ2V0X2J1cnN0X3NpemUo
dTMyIGNoKTxicj4rezxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7IHJldHVybiBpcHVfY2hfcGFy
YW1fcmVhZF9maWVsZChpcHVfY2hfcGFyYW1fYWRkcihjaCksIElQVV9GSUVMRF9OUEIpICsgMTs8
YnI+K307PGJyPis8YnI+K3N0YXRpYyBpbmxpbmUgaW50IGlwdV9jaF9wYXJhbV9nZXRfYnBwKHUz
MiBjaCk8YnI+K3s8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyByZXR1cm4gaXB1X2NoX3BhcmFt
X3JlYWRfZmllbGQoaXB1X2NoX3BhcmFtX2FkZHIoY2gpLCBJUFVfRklFTERfQlBQKTs8YnI+K307
PGJyPis8YnI+K3N0YXRpYyBpbmxpbmUgdm9pZCBpcHVfY2hfcGFyYW1fc2V0X2J1ZmZlcih1MzIg
Y2gsIGludCBidWZOdW0sPGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAm
bmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZu
YnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgZG1h
X2FkZHJfdCBwaHlhZGRyKTxicj4rezxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7IGlwdV9jaF9w
YXJhbV9zZXRfZmllbGQoaXB1X2NoX3BhcmFtX2FkZHIoY2gpLDxicj4rICZuYnNwOyAmbmJzcDsg
Jm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAm
bmJzcDsgYnVmTnVtID8gSVBVX0ZJRUxEX0VCQTEgOiBJUFVfRklFTERfRUJBMCw8YnI+KyAmbmJz
cDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNw
OyAmbmJzcDsgJm5ic3A7IHBoeWFkZHIgLyA4KTs8YnI+K307PGJyPis8YnI+KyNkZWZpbmUgSVBV
X0ZJRUxEX1JPVF9IRl9WRiAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNw
O19fRigwLCAxMTksIDMpPGJyPis8YnI+K3N0YXRpYyBpbmxpbmUgdm9pZCBpcHVfY2hfcGFyYW1f
c2V0X3JvdGF0aW9uKHUzMiBjaCw8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5i
c3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJz
cDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNw
OyAmbmJzcDsgaXB1X3JvdGF0ZV9tb2RlX3Qgcm90KTxicj4rezxicj4rICZuYnNwOyAmbmJzcDsg
Jm5ic3A7IHUzMiB0ZW1wX3JvdCA9IGJpdHJldjgocm90KSAmZ3Q7Jmd0OyA1Ozxicj4rICZuYnNw
OyAmbmJzcDsgJm5ic3A7IGlwdV9jaF9wYXJhbV9zZXRfZmllbGQoaXB1X2NoX3BhcmFtX2FkZHIo
Y2gpLCBJUFVfRklFTERfUk9UX0hGX1ZGLCB0ZW1wX3JvdCk7PGJyPit9Ozxicj4rPGJyPitzdGF0
aWMgaW5saW5lIHZvaWQgaXB1X2NoX3BhcmFtX3NldF9ibG9ja19tb2RlKHUzMiBjaCk8YnI+K3s8
YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBpcHVfY2hfcGFyYW1fc2V0X2ZpZWxkKGlwdV9jaF9w
YXJhbV9hZGRyKGNoKSwgSVBVX0ZJRUxEX0JNLCAxKTs8YnI+K307PGJyPis8YnI+K3N0YXRpYyBp
bmxpbmUgdm9pZCBpcHVfY2hfcGFyYW1fc2V0X2FscGhhX3VzZV9zZXBhcmF0ZV9jaGFubmVsKHUz
MiBjaCw8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJz
cDsgYm9vbCBvcHRpb24pPGJyPit7PGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgaWYgKG9wdGlv
bik8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsg
aXB1X2NoX3BhcmFtX3NldF9maWVsZChpcHVfY2hfcGFyYW1fYWRkcihjaCksIElQVV9GSUVMRF9B
TFUsIDEpOzxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7IGVsc2U8YnI+KyAmbmJzcDsgJm5ic3A7
ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgaXB1X2NoX3BhcmFtX3NldF9maWVs
ZChpcHVfY2hfcGFyYW1fYWRkcihjaCksIElQVV9GSUVMRF9BTFUsIDApOzxicj4rfTs8YnI+Kzxi
cj4rc3RhdGljIGlubGluZSB2b2lkIGlwdV9jaF9wYXJhbV9zZXRfYWxwaGFfY29uZGl0aW9uX3Jl
YWQodTMyIGNoKTxicj4rezxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7IGlwdV9jaF9wYXJhbV9z
ZXRfZmllbGQoaXB1X2NoX3BhcmFtX2FkZHIoY2gpLCBJUFVfRklFTERfQ1JFLCAxKTs8YnI+K307
PGJyPis8YnI+K3N0YXRpYyBpbmxpbmUgdm9pZCBpcHVfY2hfcGFyYW1fc2V0X2FscGhhX2J1ZmZl
cl9tZW1vcnkodTMyIGNoKTxicj4rezxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7IGludCBhbHBf
bWVtX2lkeDs8YnI+Kzxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7IHN3aXRjaCAoY2gpIHs8YnI+
KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBjYXNlIDE0OiAvKiBQUlAgZ3JhcGhpYyAqLzxicj4rICZu
YnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBhbHBfbWVtX2lk
eCA9IDA7PGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5i
c3A7IGJyZWFrOzxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7IGNhc2UgMTU6IC8qIFBQIGdyYXBo
aWMgKi88YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJz
cDsgYWxwX21lbV9pZHggPSAxOzxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJz
cDsgJm5ic3A7ICZuYnNwOyBicmVhazs8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBjYXNlIDIz
OiAvKiBEUCBCRyBTWU5DIGdyYXBoaWMgKi88YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJz
cDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgYWxwX21lbV9pZHggPSA0Ozxicj4rICZuYnNwOyAmbmJz
cDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBicmVhazs8YnI+KyAmbmJzcDsg
Jm5ic3A7ICZuYnNwOyBjYXNlIDI3OiAvKiBEUCBGRyBTWU5DIGdyYXBoaWMgKi88YnI+KyAmbmJz
cDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgYWxwX21lbV9pZHgg
PSAyOzxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNw
OyBicmVhazs8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBkZWZhdWx0Ojxicj4rICZuYnNwOyAm
bmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBkZXZfZXJyKGlwdV9kZXYs
ICZxdW90O3Vuc3VwcG9ydGVkIGNvcnJlbGF0ZWQgY2hhbm5lbCBvZiBsb2NhbCBhbHBoYSBjaGFu
bmVsXG4mcXVvdDspOzxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5i
c3A7ICZuYnNwOyByZXR1cm47PGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgfTxicj4rPGJyPisg
Jm5ic3A7ICZuYnNwOyAmbmJzcDsgaXB1X2NoX3BhcmFtX3NldF9maWVsZChpcHVfY2hfcGFyYW1f
YWRkcihjaCksIElQVV9GSUVMRF9BTEJNLCBhbHBfbWVtX2lkeCk7PGJyPit9Ozxicj4rPGJyPitz
dGF0aWMgaW5saW5lIHZvaWQgaXB1X2NoX3BhcmFtX3NldF9pbnRlcmxhY2VkX3NjYW4odTMyIGNo
KTxicj4rezxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7IHUzMiBzdHJpZGU7PGJyPisgJm5ic3A7
ICZuYnNwOyAmbmJzcDsgaXB1X2NoX3BhcmFtX3NldF9maWVsZChpcHVfY2hfcGFyYW1fYWRkcihj
aCksIElQVV9GSUVMRF9TTywgMSk7PGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgc3RyaWRlID0g
aXB1X2NoX3BhcmFtX3JlYWRfZmllbGQoaXB1X2NoX3BhcmFtX2FkZHIoY2gpLCBJUFVfRklFTERf
U0wpICsgMTs8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBpcHVfY2hfcGFyYW1fc2V0X2ZpZWxk
KGlwdV9jaF9wYXJhbV9hZGRyKGNoKSwgSVBVX0ZJRUxEX0lMTywgc3RyaWRlIC8gOCk7PGJyPisg
Jm5ic3A7ICZuYnNwOyAmbmJzcDsgc3RyaWRlICo9IDI7PGJyPisgJm5ic3A7ICZuYnNwOyAmbmJz
cDsgaXB1X2NoX3BhcmFtX3NldF9maWVsZChpcHVfY2hfcGFyYW1fYWRkcihjaCksIElQVV9GSUVM
RF9TTFksIHN0cmlkZSAtIDEpOzxicj4rfTs8YnI+Kzxicj4rc3RhdGljIGlubGluZSB2b2lkIGlw
dV9jaF9wYXJhbV9zZXRfaGlnaF9wcmlvcml0eSh1MzIgY2gpPGJyPit7PGJyPisgJm5ic3A7ICZu
YnNwOyAmbmJzcDsgaXB1X2NoX3BhcmFtX3NldF9maWVsZChpcHVfY2hfcGFyYW1fYWRkcihjaCks
IElQVV9GSUVMRF9JRCwgMSk7PGJyPit9Ozxicj4rPGJyPitzdGF0aWMgaW5saW5lIHZvaWQgaXB1
X2NoX3BhcmFtc19zZXRfYWxwaGFfd2lkdGgodTMyIGNoLCBpbnQgYWxwaGFfd2lkdGgpPGJyPit7
PGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgaXB1X2NoX3BhcmFtX3NldF9maWVsZChpcHVfY2hf
cGFyYW1fYWRkcihjaCksIElQVV9GSUVMRF9XSUQzLDxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7
ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsg
YWxwaGFfd2lkdGggLSAxKTs8YnI+K308YnI+Kzxicj4rc3RhdGljIGludCBpcHVfY2hfcGFyYW1f
aW5pdChpbnQgY2gsPGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJz
cDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyB1MzIgcGl4ZWxfZm10LCB1MzIg
d2lkdGgsPGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5i
c3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyB1MzIgaGVpZ2h0LCB1MzIgc3RyaWRlLDxi
cj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJz
cDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgdTMyIHUsIHUzMiB2LDxicj4rICZuYnNwOyAmbmJzcDsg
Jm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAm
bmJzcDsgdTMyIHV2X3N0cmlkZSwgZG1hX2FkZHJfdCBhZGRyMCw8YnI+KyAmbmJzcDsgJm5ic3A7
ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsg
Jm5ic3A7IGRtYV9hZGRyX3QgYWRkcjEpPGJyPit7PGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsg
dTMyIHVfb2Zmc2V0ID0gMDs8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyB1MzIgdl9vZmZzZXQg
PSAwOzxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7IHN0cnVjdCBpcHVfY2hfcGFyYW0gcGFyYW1z
Ozxicj4rPGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgbWVtc2V0KCZhbXA7cGFyYW1zLCAwLCBz
aXplb2YocGFyYW1zKSk7PGJyPis8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBpcHVfY2hfcGFy
YW1fc2V0X2ZpZWxkKCZhbXA7cGFyYW1zLCBJUFVfRklFTERfRlcsIHdpZHRoIC0gMSk7PGJyPisg
Jm5ic3A7ICZuYnNwOyAmbmJzcDsgaXB1X2NoX3BhcmFtX3NldF9maWVsZCgmYW1wO3BhcmFtcywg
SVBVX0ZJRUxEX0ZILCBoZWlnaHQgLSAxKTs8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBpcHVf
Y2hfcGFyYW1fc2V0X2ZpZWxkKCZhbXA7cGFyYW1zLCBJUFVfRklFTERfU0xZLCBzdHJpZGUgLSAx
KTs8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBpcHVfY2hfcGFyYW1fc2V0X2ZpZWxkKCZhbXA7
cGFyYW1zLCBJUFVfRklFTERfRUJBMCwgYWRkcjAgJmd0OyZndDsgMyk7PGJyPisgJm5ic3A7ICZu
YnNwOyAmbmJzcDsgaXB1X2NoX3BhcmFtX3NldF9maWVsZCgmYW1wO3BhcmFtcywgSVBVX0ZJRUxE
X0VCQTEsIGFkZHIxICZndDsmZ3Q7IDMpOzxicj4rPGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsg
c3dpdGNoIChwaXhlbF9mbXQpIHs8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBjYXNlIElQVV9Q
SVhfRk1UX0dFTkVSSUM6PGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAm
bmJzcDsgJm5ic3A7IC8qIFJlcHJlc2VudHMgOC1iaXQgR2VuZXJpYyBkYXRhICovPGJyPisgJm5i
c3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7IGlwdV9jaF9wYXJh
bV9zZXRfZmllbGQoJmFtcDtwYXJhbXMsIElQVV9GSUVMRF9CUFAsIDUpOyAmbmJzcDsgJm5ic3A7
ICZuYnNwOy8qIGJpdHMvcGl4ZWwgKi88YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsg
Jm5ic3A7ICZuYnNwOyAmbmJzcDsgaXB1X2NoX3BhcmFtX3NldF9maWVsZCgmYW1wO3BhcmFtcywg
SVBVX0ZJRUxEX1BGUywgNik7ICZuYnNwOyAmbmJzcDsgJm5ic3A7LyogcGl4IGZvcm1hdCAqLzxi
cj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBpcHVf
Y2hfcGFyYW1fc2V0X2ZpZWxkKCZhbXA7cGFyYW1zLCBJUFVfRklFTERfTlBCLCA2Myk7ICZuYnNw
OyAmbmJzcDsgLyogYnVyc3Qgc2l6ZSAqLzxicj4rPGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsg
Jm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7IGJyZWFrOzxicj4rICZuYnNwOyAmbmJzcDsgJm5i
c3A7IGNhc2UgSVBVX1BJWF9GTVRfR0VORVJJQ18zMjo8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNw
OyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgLyogUmVwcmVzZW50cyAzMi1iaXQgR2VuZXJp
YyBkYXRhICovPGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsg
Jm5ic3A7IGJyZWFrOzxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7IGNhc2UgSVBVX1BJWF9GTVRf
UkdCNTY1Ojxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZu
YnNwOyBpcHVfY2hfcGFyYW1fc2V0X2ZpZWxkKCZhbXA7cGFyYW1zLCBJUFVfRklFTERfQlBQLCAz
KTsgJm5ic3A7ICZuYnNwOyAmbmJzcDsvKiBiaXRzL3BpeGVsICovPGJyPisgJm5ic3A7ICZuYnNw
OyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7IGlwdV9jaF9wYXJhbV9zZXRfZmll
bGQoJmFtcDtwYXJhbXMsIElQVV9GSUVMRF9QRlMsIDcpOyAmbmJzcDsgJm5ic3A7ICZuYnNwOy8q
IHBpeCBmb3JtYXQgKi88YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZu
YnNwOyAmbmJzcDsgaXB1X2NoX3BhcmFtX3NldF9maWVsZCgmYW1wO3BhcmFtcywgSVBVX0ZJRUxE
X05QQiwgMTUpOyAmbmJzcDsgJm5ic3A7IC8qIGJ1cnN0IHNpemUgKi88YnI+Kzxicj4rICZuYnNw
OyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBpcHVfY2hfcGFyYW1z
X3NldF9wYWNraW5nKCZhbXA7cGFyYW1zLCA1LCAwLCA2LCA1LCA1LCAxMSwgOCwgMTYpOzxicj4r
ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBicmVhazs8
YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBjYXNlIElQVV9QSVhfRk1UX0JHUjI0Ojxicj4rICZu
YnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBpcHVfY2hfcGFy
YW1fc2V0X2ZpZWxkKCZhbXA7cGFyYW1zLCBJUFVfRklFTERfQlBQLCAxKTsgJm5ic3A7ICZuYnNw
OyAmbmJzcDsvKiBiaXRzL3BpeGVsICovPGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7
ICZuYnNwOyAmbmJzcDsgJm5ic3A7IGlwdV9jaF9wYXJhbV9zZXRfZmllbGQoJmFtcDtwYXJhbXMs
IElQVV9GSUVMRF9QRlMsIDcpOyAmbmJzcDsgJm5ic3A7ICZuYnNwOy8qIHBpeCBmb3JtYXQgKi88
YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgaXB1
X2NoX3BhcmFtX3NldF9maWVsZCgmYW1wO3BhcmFtcywgSVBVX0ZJRUxEX05QQiwgMTkpOyAmbmJz
cDsgJm5ic3A7IC8qIGJ1cnN0IHNpemUgKi88YnI+Kzxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7
ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBpcHVfY2hfcGFyYW1zX3NldF9wYWNraW5nKCZh
bXA7cGFyYW1zLCA4LCAwLCA4LCA4LCA4LCAxNiwgOCwgMjQpOzxicj4rICZuYnNwOyAmbmJzcDsg
Jm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBicmVhazs8YnI+KyAmbmJzcDsgJm5i
c3A7ICZuYnNwOyBjYXNlIElQVV9QSVhfRk1UX1JHQjI0Ojxicj4rICZuYnNwOyAmbmJzcDsgJm5i
c3A7IGNhc2UgSVBVX1BJWF9GTVRfWVVWNDQ0Ojxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZu
YnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBpcHVfY2hfcGFyYW1fc2V0X2ZpZWxkKCZhbXA7cGFy
YW1zLCBJUFVfRklFTERfQlBQLCAxKTsgJm5ic3A7ICZuYnNwOyAmbmJzcDsvKiBiaXRzL3BpeGVs
ICovPGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7
IGlwdV9jaF9wYXJhbV9zZXRfZmllbGQoJmFtcDtwYXJhbXMsIElQVV9GSUVMRF9QRlMsIDcpOyAm
bmJzcDsgJm5ic3A7ICZuYnNwOy8qIHBpeCBmb3JtYXQgKi88YnI+KyAmbmJzcDsgJm5ic3A7ICZu
YnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgaXB1X2NoX3BhcmFtX3NldF9maWVsZCgm
YW1wO3BhcmFtcywgSVBVX0ZJRUxEX05QQiwgMTkpOyAmbmJzcDsgJm5ic3A7IC8qIGJ1cnN0IHNp
emUgKi88YnI+Kzxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7
ICZuYnNwOyBpcHVfY2hfcGFyYW1zX3NldF9wYWNraW5nKCZhbXA7cGFyYW1zLCA4LCAxNiwgOCwg
OCwgOCwgMCwgOCwgMjQpOzxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsg
Jm5ic3A7ICZuYnNwOyBicmVhazs8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBjYXNlIElQVV9Q
SVhfRk1UX0JHUkEzMjo8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBjYXNlIElQVV9QSVhfRk1U
X0JHUjMyOjxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZu
YnNwOyBpcHVfY2hfcGFyYW1fc2V0X2ZpZWxkKCZhbXA7cGFyYW1zLCBJUFVfRklFTERfQlBQLCAw
KTsgJm5ic3A7ICZuYnNwOyAmbmJzcDsvKiBiaXRzL3BpeGVsICovPGJyPisgJm5ic3A7ICZuYnNw
OyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7IGlwdV9jaF9wYXJhbV9zZXRfZmll
bGQoJmFtcDtwYXJhbXMsIElQVV9GSUVMRF9QRlMsIDcpOyAmbmJzcDsgJm5ic3A7ICZuYnNwOy8q
IHBpeCBmb3JtYXQgKi88YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZu
YnNwOyAmbmJzcDsgaXB1X2NoX3BhcmFtX3NldF9maWVsZCgmYW1wO3BhcmFtcywgSVBVX0ZJRUxE
X05QQiwgMTUpOyAmbmJzcDsgJm5ic3A7IC8qIGJ1cnN0IHNpemUgKi88YnI+Kzxicj4rICZuYnNw
OyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBpcHVfY2hfcGFyYW1z
X3NldF9wYWNraW5nKCZhbXA7cGFyYW1zLCA4LCA4LCA4LCAxNiwgOCwgMjQsIDgsIDApOzxicj4r
ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBicmVhazs8
YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBjYXNlIElQVV9QSVhfRk1UX1JHQkEzMjo8YnI+KyAm
bmJzcDsgJm5ic3A7ICZuYnNwOyBjYXNlIElQVV9QSVhfRk1UX1JHQjMyOjxicj4rICZuYnNwOyAm
bmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBpcHVfY2hfcGFyYW1fc2V0
X2ZpZWxkKCZhbXA7cGFyYW1zLCBJUFVfRklFTERfQlBQLCAwKTsgJm5ic3A7ICZuYnNwOyAmbmJz
cDsvKiBiaXRzL3BpeGVsICovPGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNw
OyAmbmJzcDsgJm5ic3A7IGlwdV9jaF9wYXJhbV9zZXRfZmllbGQoJmFtcDtwYXJhbXMsIElQVV9G
SUVMRF9QRlMsIDcpOyAmbmJzcDsgJm5ic3A7ICZuYnNwOy8qIHBpeCBmb3JtYXQgKi88YnI+KyAm
bmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgaXB1X2NoX3Bh
cmFtX3NldF9maWVsZCgmYW1wO3BhcmFtcywgSVBVX0ZJRUxEX05QQiwgMTUpOyAmbmJzcDsgJm5i
c3A7IC8qIGJ1cnN0IHNpemUgKi88YnI+Kzxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNw
OyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBpcHVfY2hfcGFyYW1zX3NldF9wYWNraW5nKCZhbXA7cGFy
YW1zLCA4LCAyNCwgOCwgMTYsIDgsIDgsIDgsIDApOzxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7
ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBicmVhazs8YnI+KyAmbmJzcDsgJm5ic3A7ICZu
YnNwOyBjYXNlIElQVV9QSVhfRk1UX0FCR1IzMjo8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAm
bmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgaXB1X2NoX3BhcmFtX3NldF9maWVsZCgmYW1wO3Bh
cmFtcywgSVBVX0ZJRUxEX0JQUCwgMCk7ICZuYnNwOyAmbmJzcDsgJm5ic3A7LyogYml0cy9waXhl
bCAqLzxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNw
OyBpcHVfY2hfcGFyYW1fc2V0X2ZpZWxkKCZhbXA7cGFyYW1zLCBJUFVfRklFTERfUEZTLCA3KTsg
Jm5ic3A7ICZuYnNwOyAmbmJzcDsvKiBwaXggZm9ybWF0ICovPGJyPis8YnI+KyAmbmJzcDsgJm5i
c3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgaXB1X2NoX3BhcmFtc19zZXRf
cGFja2luZygmYW1wO3BhcmFtcywgOCwgMCwgOCwgOCwgOCwgMTYsIDgsIDI0KTs8YnI+KyAmbmJz
cDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgYnJlYWs7PGJyPisg
Jm5ic3A7ICZuYnNwOyAmbmJzcDsgY2FzZSBJUFVfUElYX0ZNVF9VWVZZOjxicj4rICZuYnNwOyAm
bmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBpcHVfY2hfcGFyYW1fc2V0
X2ZpZWxkKCZhbXA7cGFyYW1zLCBJUFVfRklFTERfQlBQLCAzKTsgJm5ic3A7ICZuYnNwOyAmbmJz
cDsvKiBiaXRzL3BpeGVsICovPGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNw
OyAmbmJzcDsgJm5ic3A7IGlwdV9jaF9wYXJhbV9zZXRfZmllbGQoJmFtcDtwYXJhbXMsIElQVV9G
SUVMRF9QRlMsIDB4QSk7ICZuYnNwOyAmbmJzcDsvKiBwaXggZm9ybWF0ICovPGJyPisgJm5ic3A7
ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7IGlwdV9jaF9wYXJhbV9z
ZXRfZmllbGQoJmFtcDtwYXJhbXMsIElQVV9GSUVMRF9OUEIsIDE1KTsgJm5ic3A7ICZuYnNwOyAv
KiBidXJzdCBzaXplICovPGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAm
bmJzcDsgJm5ic3A7IGJyZWFrOzxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7IGNhc2UgSVBVX1BJ
WF9GTVRfWVVZVjo8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNw
OyAmbmJzcDsgaXB1X2NoX3BhcmFtX3NldF9maWVsZCgmYW1wO3BhcmFtcywgSVBVX0ZJRUxEX0JQ
UCwgMyk7ICZuYnNwOyAmbmJzcDsgJm5ic3A7LyogYml0cy9waXhlbCAqLzxicj4rICZuYnNwOyAm
bmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBpcHVfY2hfcGFyYW1fc2V0
X2ZpZWxkKCZhbXA7cGFyYW1zLCBJUFVfRklFTERfUEZTLCAweDgpOyAmbmJzcDsgJm5ic3A7Lyog
cGl4IGZvcm1hdCAqLzxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5i
c3A7ICZuYnNwOyBpcHVfY2hfcGFyYW1fc2V0X2ZpZWxkKCZhbXA7cGFyYW1zLCBJUFVfRklFTERf
TlBCLCAzMSk7ICZuYnNwOyAmbmJzcDsgLyogYnVyc3Qgc2l6ZSAqLzxicj4rICZuYnNwOyAmbmJz
cDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBicmVhazs8YnI+KyAmbmJzcDsg
Jm5ic3A7ICZuYnNwOyBjYXNlIElQVV9QSVhfRk1UX1lVVjQyMFAyOjxicj4rICZuYnNwOyAmbmJz
cDsgJm5ic3A7IGNhc2UgSVBVX1BJWF9GTVRfWVVWNDIwUDo8YnI+KyAmbmJzcDsgJm5ic3A7ICZu
YnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgaXB1X2NoX3BhcmFtX3NldF9maWVsZCgm
YW1wO3BhcmFtcywgSVBVX0ZJRUxEX1BGUywgMik7ICZuYnNwOyAmbmJzcDsgJm5ic3A7LyogcGl4
IGZvcm1hdCAqLzxicj4rPGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAm
bmJzcDsgJm5ic3A7IGlmICh1dl9zdHJpZGUgJmx0OyBzdHJpZGUgLyAyKTxicj4rICZuYnNwOyAm
bmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZu
YnNwOyAmbmJzcDsgdXZfc3RyaWRlID0gc3RyaWRlIC8gMjs8YnI+Kzxicj4rICZuYnNwOyAmbmJz
cDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyB1X29mZnNldCA9IHN0cmlkZSAq
IGhlaWdodDs8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAm
bmJzcDsgdl9vZmZzZXQgPSB1X29mZnNldCArICh1dl9zdHJpZGUgKiBoZWlnaHQgLyAyKTs8YnI+
KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgaXB1X2No
X3BhcmFtX3NldF9maWVsZCgmYW1wO3BhcmFtcywgSVBVX0ZJRUxEX05QQiwgMzEpOyAmbmJzcDsv
KiBidXJzdCBzaXplICovPGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAm
bmJzcDsgJm5ic3A7IGJyZWFrOzxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7IGNhc2UgSVBVX1BJ
WF9GTVRfWVZVNDIyUDo8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZu
YnNwOyAmbmJzcDsgLyogQlBQICZhbXA7IHBpeGVsIGZvcm1hdCAqLzxicj4rICZuYnNwOyAmbmJz
cDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBpcHVfY2hfcGFyYW1fc2V0X2Zp
ZWxkKCZhbXA7cGFyYW1zLCBJUFVfRklFTERfUEZTLCAxKTsgJm5ic3A7ICZuYnNwOyAmbmJzcDsv
KiBwaXggZm9ybWF0ICovPGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAm
bmJzcDsgJm5ic3A7IGlwdV9jaF9wYXJhbV9zZXRfZmllbGQoJmFtcDtwYXJhbXMsIElQVV9GSUVM
RF9OUEIsIDMxKTsgJm5ic3A7ICZuYnNwOyAvKiBidXJzdCBzaXplICovPGJyPis8YnI+KyAmbmJz
cDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgaWYgKHV2X3N0cmlk
ZSAmbHQ7IHN0cmlkZSAvIDIpPGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNw
OyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyB1dl9zdHJpZGUgPSBz
dHJpZGUgLyAyOzxicj4rPGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAm
bmJzcDsgJm5ic3A7IHZfb2Zmc2V0ID0gKHYgPT0gMCkgPyBzdHJpZGUgKiBoZWlnaHQgOiB2Ozxi
cj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyB1X29m
ZnNldCA9ICh1ID09IDApID8gdl9vZmZzZXQgKyB2X29mZnNldCAvIDIgOiB1Ozxicj4rICZuYnNw
OyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBicmVhazs8YnI+KyAm
bmJzcDsgJm5ic3A7ICZuYnNwOyBjYXNlIElQVV9QSVhfRk1UX1lVVjQyMlA6PGJyPisgJm5ic3A7
ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7IC8qIEJQUCAmYW1wOyBw
aXhlbCBmb3JtYXQgKi88YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZu
YnNwOyAmbmJzcDsgaXB1X2NoX3BhcmFtX3NldF9maWVsZCgmYW1wO3BhcmFtcywgSVBVX0ZJRUxE
X1BGUywgMSk7ICZuYnNwOyAmbmJzcDsgJm5ic3A7LyogcGl4IGZvcm1hdCAqLzxicj4rICZuYnNw
OyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBpcHVfY2hfcGFyYW1f
c2V0X2ZpZWxkKCZhbXA7cGFyYW1zLCBJUFVfRklFTERfTlBCLCAzMSk7ICZuYnNwOyAmbmJzcDsg
LyogYnVyc3Qgc2l6ZSAqLzxicj4rPGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZu
YnNwOyAmbmJzcDsgJm5ic3A7IGlmICh1dl9zdHJpZGUgJmx0OyBzdHJpZGUgLyAyKTxicj4rICZu
YnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5i
c3A7ICZuYnNwOyAmbmJzcDsgdXZfc3RyaWRlID0gc3RyaWRlIC8gMjs8YnI+Kzxicj4rICZuYnNw
OyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyB1X29mZnNldCA9ICh1
ID09IDApID8gc3RyaWRlICogaGVpZ2h0IDogdTs8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAm
bmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgdl9vZmZzZXQgPSAodiA9PSAwKSA/IHVfb2Zmc2V0
ICsgdV9vZmZzZXQgLyAyIDogdjs8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5i
c3A7ICZuYnNwOyAmbmJzcDsgYnJlYWs7PGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgY2FzZSBJ
UFVfUElYX0ZNVF9OVjEyOjxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsg
Jm5ic3A7ICZuYnNwOyAvKiBCUFAgJmFtcDsgcGl4ZWwgZm9ybWF0ICovPGJyPisgJm5ic3A7ICZu
YnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7IGlwdV9jaF9wYXJhbV9zZXRf
ZmllbGQoJmFtcDtwYXJhbXMsIElQVV9GSUVMRF9QRlMsIDQpOyAmbmJzcDsgJm5ic3A7ICZuYnNw
Oy8qIHBpeCBmb3JtYXQgKi88YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7
ICZuYnNwOyAmbmJzcDsgaXB1X2NoX3BhcmFtX3NldF9maWVsZCgmYW1wO3BhcmFtcywgSVBVX0ZJ
RUxEX05QQiwgMzEpOyAmbmJzcDsgJm5ic3A7IC8qIGJ1cnN0IHNpemUgKi88YnI+KyAmbmJzcDsg
Jm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgdXZfc3RyaWRlID0gc3Ry
aWRlOzxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNw
OyB1X29mZnNldCA9ICh1ID09IDApID8gc3RyaWRlICogaGVpZ2h0IDogdTs8YnI+KyAmbmJzcDsg
Jm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgYnJlYWs7PGJyPisgJm5i
c3A7ICZuYnNwOyAmbmJzcDsgZGVmYXVsdDo8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJz
cDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgZGV2X2VycihpcHVfZGV2LCAmcXVvdDtteGMgaXB1OiB1
bmltcGxlbWVudGVkIHBpeGVsIGZvcm1hdDogJWRcbiZxdW90Oyw8YnI+KyAmbmJzcDsgJm5ic3A7
ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsg
Jm5ic3A7IHBpeGVsX2ZtdCk7PGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNw
OyAmbmJzcDsgJm5ic3A7IHJldHVybiAtRUlOVkFMOzxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7
IH08YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAvKiBzZXQgYnVyc3Qgc2l6ZSB0byAxNiAqLzxi
cj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7IGlmICh1dl9zdHJpZGUpPGJyPisgJm5ic3A7ICZuYnNw
OyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7IGlwdV9jaF9wYXJhbV9zZXRfZmll
bGQoJmFtcDtwYXJhbXMsIElQVV9GSUVMRF9TTFVWLCB1dl9zdHJpZGUgLSAxKTs8YnI+Kzxicj4r
ICZuYnNwOyAmbmJzcDsgJm5ic3A7IGlmICh1ICZndDsgdV9vZmZzZXQpPGJyPisgJm5ic3A7ICZu
YnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7IHVfb2Zmc2V0ID0gdTs8YnI+
Kzxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7IGlmICh2ICZndDsgdl9vZmZzZXQpPGJyPisgJm5i
c3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7IHZfb2Zmc2V0ID0g
djs8YnI+Kzxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7IGlwdV9jaF9wYXJhbV9zZXRfZmllbGQo
JmFtcDtwYXJhbXMsIElQVV9GSUVMRF9VQk8sIHVfb2Zmc2V0IC8gOCk7PGJyPisgJm5ic3A7ICZu
YnNwOyAmbmJzcDsgaXB1X2NoX3BhcmFtX3NldF9maWVsZCgmYW1wO3BhcmFtcywgSVBVX0ZJRUxE
X1ZCTywgdl9vZmZzZXQgLyA4KTs8YnI+Kzxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7IHByX2Rl
YnVnKCZxdW90O2luaXRpYWxpemluZyBpZG1hIGNoICVkIEAgJXBcbiZxdW90OywgY2gsIGlwdV9j
aF9wYXJhbV9hZGRyKGNoKSk7PGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgbWVtY3B5KGlwdV9j
aF9wYXJhbV9hZGRyKGNoKSwgJmFtcDtwYXJhbXMsIHNpemVvZihwYXJhbXMpKTs8YnI+KyAmbmJz
cDsgJm5ic3A7ICZuYnNwOyByZXR1cm4gMDs8YnI+K308YnI+Kzxicj4rLyo8YnI+KyAqIFRoaXMg
ZnVuY3Rpb24gaXMgY2FsbGVkIHRvIGluaXRpYWxpemUgYSBidWZmZXIgZm9yIGEgSVBVIGNoYW5u
ZWwuPGJyPisgKjxicj4rICogQHBhcmFtICZuYnNwOyAmbmJzcDsgJm5ic3A7IGNoYW5uZWwgJm5i
c3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7IFRoZSBJUFUgY2hhbm5lbC48YnI+KyAqPGJyPisgKiBA
cGFyYW0gJm5ic3A7ICZuYnNwOyAmbmJzcDsgcGl4ZWxfZm10ICZuYnNwOyAmbmJzcDsgJm5ic3A7
IElucHV0IHBhcmFtZXRlciBmb3IgcGl4ZWwgZm9ybWF0IG9mIGJ1ZmZlci48YnI+KyAqICZuYnNw
OyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7
ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7UGl4ZWwgZm9ybWF0IGlz
IGEgRk9VUkNDIEFTQ0lJIGNvZGUuPGJyPisgKjxicj4rICogQHBhcmFtICZuYnNwOyAmbmJzcDsg
Jm5ic3A7IHdpZHRoICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgSW5wdXQgcGFy
YW1ldGVyIGZvciB3aWR0aCBvZiBidWZmZXIgaW4gcGl4ZWxzLjxicj4rICo8YnI+KyAqIEBwYXJh
bSAmbmJzcDsgJm5ic3A7ICZuYnNwOyBoZWlnaHQgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7
ICZuYnNwO0lucHV0IHBhcmFtZXRlciBmb3IgaGVpZ2h0IG9mIGJ1ZmZlciBpbiBwaXhlbHMuPGJy
PisgKjxicj4rICogQHBhcmFtICZuYnNwOyAmbmJzcDsgJm5ic3A7IHN0cmlkZSAmbmJzcDsgJm5i
c3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7SW5wdXQgcGFyYW1ldGVyIGZvciBzdHJpZGUgbGVuZ3Ro
IG9mIGJ1ZmZlcjxicj4rICogJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJz
cDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNw
OyAmbmJzcDtpbiBwaXhlbHMuPGJyPisgKjxicj4rICogQHBhcmFtICZuYnNwOyAmbmJzcDsgJm5i
c3A7IHJvdF9tb2RlICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwO0lucHV0IHBhcmFtZXRlciBm
b3Igcm90YXRpb24gc2V0dGluZyBvZiBidWZmZXIuPGJyPisgKiAmbmJzcDsgJm5ic3A7ICZuYnNw
OyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7
ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwO0Egcm90YXRpb24gc2V0dGluZyBvdGhlciB0aGFu
PGJyPisgKiAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsg
Jm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwO0lQ
VV9ST1RBVEVfVkVSVF9GTElQPGJyPisgKiAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5i
c3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJz
cDsgJm5ic3A7ICZuYnNwO3Nob3VsZCBvbmx5IGJlIHVzZWQgZm9yIGlucHV0IGJ1ZmZlcnMgb2Y8
YnI+KyAqICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAm
bmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7cm90
YXRpb24gY2hhbm5lbHMuPGJyPisgKjxicj4rICogQHBhcmFtICZuYnNwOyAmbmJzcDsgJm5ic3A7
IHBoeWFkZHJfMCAmbmJzcDsgJm5ic3A7ICZuYnNwOyBJbnB1dCBwYXJhbWV0ZXIgYnVmZmVyIDAg
cGh5c2ljYWwgYWRkcmVzcy48YnI+KyAqPGJyPisgKiBAcGFyYW0gJm5ic3A7ICZuYnNwOyAmbmJz
cDsgcGh5YWRkcl8xICZuYnNwOyAmbmJzcDsgJm5ic3A7IElucHV0IHBhcmFtZXRlciBidWZmZXIg
MSBwaHlzaWNhbCBhZGRyZXNzLjxicj4rICogJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZu
YnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5i
c3A7ICZuYnNwOyAmbmJzcDtTZXR0aW5nIHRoaXMgdG8gYSB2YWx1ZSBvdGhlciB0aGFuIE5VTEwg
ZW5hYmxlczxicj4rICogJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsg
Jm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAm
bmJzcDtkb3VibGUgYnVmZmVyaW5nIG1vZGUuPGJyPisgKjxicj4rICogQHBhcmFtICZuYnNwOyAm
bmJzcDsgJm5ic3A7IHUgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsg
Jm5ic3A7cHJpdmF0ZSB1IG9mZnNldCBmb3IgYWRkaXRpb25hbCBjcm9wcGluZyw8YnI+KyAqICZu
YnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5i
c3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgemVybyBpZiBub3QgdXNlZC48
YnI+KyAqPGJyPisgKiBAcGFyYW0gJm5ic3A7ICZuYnNwOyAmbmJzcDsgdiAmbmJzcDsgJm5ic3A7
ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDtwcml2YXRlIHYgb2Zmc2V0IGZvciBh
ZGRpdGlvbmFsIGNyb3BwaW5nLDxicj4rICogJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZu
YnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5i
c3A7ICZuYnNwOyB6ZXJvIGlmIG5vdCB1c2VkLjxicj4rICo8YnI+KyAqIEByZXR1cm4gJm5ic3A7
ICZuYnNwOyAmbmJzcDtSZXR1cm5zIDAgb24gc3VjY2VzcyBvciBuZWdhdGl2ZSBlcnJvciBjb2Rl
IG9uIGZhaWw8YnI+KyAqLzxicj4raW50IGlwdV9pZG1hY19pbml0X2NoYW5uZWxfYnVmZmVyKHN0
cnVjdCBpcHVfY2hhbm5lbCAqY2hhbm5lbCw8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJz
cDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNw
OyAmbmJzcDsgJm5ic3A7ICZuYnNwOyB1MzIgcGl4ZWxfZm10LDxicj4rICZuYnNwOyAmbmJzcDsg
Jm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAm
bmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7IHUxNiB3aWR0aCwgdTE2IGhlaWdodCw8
YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5i
c3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyB1MzIg
c3RyaWRlLDxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZu
YnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5i
c3A7IGlwdV9yb3RhdGVfbW9kZV90IHJvdF9tb2RlLDxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7
ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsg
Jm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7IGRtYV9hZGRyX3QgcGh5YWRkcl8wLCBkbWFfYWRk
cl90IHBoeWFkZHJfMSw8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZu
YnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5i
c3A7ICZuYnNwOyB1MzIgdSwgdTMyIHYsIGJvb2wgaW50ZXJsYWNlZCk8YnI+K3s8YnI+KyAmbmJz
cDsgJm5ic3A7ICZuYnNwOyBpbnQgcmV0Ozxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7IHUzMiBk
bWFfY2hhbiA9IGNoYW5uZWwtJmd0O251bTs8YnI+Kzxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7
IGlmIChzdHJpZGUgJmx0OyB3aWR0aCAqIGlwdV9ieXRlc19wZXJfcGl4ZWwocGl4ZWxfZm10KSk8
YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgc3Ry
aWRlID0gd2lkdGggKiBpcHVfYnl0ZXNfcGVyX3BpeGVsKHBpeGVsX2ZtdCk7PGJyPis8YnI+KyAm
bmJzcDsgJm5ic3A7ICZuYnNwOyBpZiAoc3RyaWRlICUgNCkgezxicj4rICZuYnNwOyAmbmJzcDsg
Jm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBkZXZfZXJyKGlwdV9kZXYsPGJyPisg
Jm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAm
bmJzcDsgJm5ic3A7ICZuYnNwOyAmcXVvdDtTdHJpZGUgbm90IDMyLWJpdCBhbGlnbmVkLCBzdHJp
ZGUgPSAlZFxuJnF1b3Q7LCBzdHJpZGUpOzxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNw
OyAmbmJzcDsgJm5ic3A7ICZuYnNwOyByZXR1cm4gLUVJTlZBTDs8YnI+KyAmbmJzcDsgJm5ic3A7
ICZuYnNwOyB9PGJyPis8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAvKiBCdWlsZCBwYXJhbWV0
ZXIgbWVtb3J5IGRhdGEgZm9yIERNQSBjaGFubmVsICovPGJyPisgJm5ic3A7ICZuYnNwOyAmbmJz
cDsgcmV0ID0gaXB1X2NoX3BhcmFtX2luaXQoZG1hX2NoYW4sIHBpeGVsX2ZtdCwgd2lkdGgsIGhl
aWdodCwgc3RyaWRlLCB1LCB2LCAwLDxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAm
bmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZu
YnNwO3BoeWFkZHJfMCwgcGh5YWRkcl8xKTs8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBpZiAo
cmV0KTxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNw
OyByZXR1cm4gcmV0Ozxicj4rPGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgaWYgKHJvdF9tb2Rl
KTxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBp
cHVfY2hfcGFyYW1fc2V0X3JvdGF0aW9uKGRtYV9jaGFuLCByb3RfbW9kZSk7PGJyPis8YnI+KyAm
bmJzcDsgJm5ic3A7ICZuYnNwOyBpZiAoaW50ZXJsYWNlZCk8YnI+KyAmbmJzcDsgJm5ic3A7ICZu
YnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgaXB1X2NoX3BhcmFtX3NldF9pbnRlcmxh
Y2VkX3NjYW4oZG1hX2NoYW4pOzxicj4rPGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgaWYgKGlk
bWFjX2lkbWFfaXNfc2V0KElETUFDX0NIQV9QUkksIGRtYV9jaGFuKSk8YnI+KyAmbmJzcDsgJm5i
c3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgaXB1X2NoX3BhcmFtX3NldF9o
aWdoX3ByaW9yaXR5KGRtYV9jaGFuKTs8YnI+Kzxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7IGlw
dV9jaF9wYXJhbV9kdW1wKGRtYV9jaGFuKTs8YnI+Kzxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7
IHJldHVybiAwOzxicj4rfTxicj4rRVhQT1JUX1NZTUJPTChpcHVfaWRtYWNfaW5pdF9jaGFubmVs
X2J1ZmZlcik7PGJyPis8YnI+K2ludCBpcHVfaWRtYWNfdXBkYXRlX2NoYW5uZWxfYnVmZmVyKHN0
cnVjdCBpcHVfY2hhbm5lbCAqY2hhbm5lbCw8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJz
cDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNw
OyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgdTMyIGJ1Zl9udW0sIGRtYV9hZGRyX3QgcGh5
YWRkcik8YnI+K3s8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyB1MzIgZG1hX2NoYW4gPSBjaGFu
bmVsLSZndDtudW07PGJyPis8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBpcHVfY2hfcGFyYW1f
c2V0X2J1ZmZlcihkbWFfY2hhbiwgYnVmX251bSwgcGh5YWRkcik7PGJyPis8YnI+KyAmbmJzcDsg
Jm5ic3A7ICZuYnNwOyByZXR1cm4gMDs8YnI+K308YnI+K0VYUE9SVF9TWU1CT0woaXB1X2lkbWFj
X3VwZGF0ZV9jaGFubmVsX2J1ZmZlcik7PGJyPis8YnI+K2ludCBpcHVfY3BtZW1faW5pdChzdHJ1
Y3QgcGxhdGZvcm1fZGV2aWNlICpwZGV2LCB1bnNpZ25lZCBsb25nIGJhc2UpPGJyPit7PGJyPisg
Jm5ic3A7ICZuYnNwOyAmbmJzcDsgaXB1X2NwbWVtX2Jhc2UgPSBpb3JlbWFwKGJhc2UsIFBBR0Vf
U0laRSk7PGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgaWYgKCFpcHVfY3BtZW1fYmFzZSk8YnI+
KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgcmV0dXJu
IC1FTk9NRU07PGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgaXB1X2RldiA9ICZhbXA7cGRldi0m
Z3Q7ZGV2Ozxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7IHJldHVybiAwOzxicj4rfTxicj4rPGJy
Pit2b2lkIGlwdV9jcG1lbV9leGl0KHN0cnVjdCBwbGF0Zm9ybV9kZXZpY2UgKnBkZXYpPGJyPit7
PGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgaW91bm1hcChpcHVfY3BtZW1fYmFzZSk7PGJyPit9
PGJyPmRpZmYgLS1naXQgYS9kcml2ZXJzL21mZC9pbXgtaXB1LXYzL2lwdS1kYy5jIGIvZHJpdmVy
cy9tZmQvaW14LWlwdS12My9pcHUtZGMuYzxicj5uZXcgZmlsZSBtb2RlIDEwMDY0NDxicj5pbmRl
eCAwMDAwMDAwLi4yM2JhNWQ3PGJyPi0tLSAvZGV2L251bGw8YnI+KysrIGIvZHJpdmVycy9tZmQv
aW14LWlwdS12My9pcHUtZGMuYzxicj5AQCAtMCwwICsxLDM2MiBAQDxicj4rLyo8YnI+KyAqIENv
cHlyaWdodCAoYykgMjAxMCBTYXNjaGEgSGF1ZXIgJmx0OzxhIGhyZWY9Im1haWx0bzpzLmhhdWVy
QHBlbmd1dHJvbml4LmRlIj5zLmhhdWVyQHBlbmd1dHJvbml4LmRlPC9hPiZndDs8YnI+KyAqIENv
cHlyaWdodCAoQykgMjAwNS0yMDA5IEZyZWVzY2FsZSBTZW1pY29uZHVjdG9yLCBJbmMuPGJyPisg
Kjxicj4rICogVGhpcyBwcm9ncmFtIGlzIGZyZWUgc29mdHdhcmU7IHlvdSBjYW4gcmVkaXN0cmli
dXRlIGl0IGFuZC9vciBtb2RpZnkgaXQ8YnI+KyAqIHVuZGVyIHRoZSB0ZXJtcyBvZiB0aGUgR05V
IEdlbmVyYWwgUHVibGljIExpY2Vuc2UgYXMgcHVibGlzaGVkIGJ5IHRoZTxicj4rICogRnJlZSBT
b2Z0d2FyZSBGb3VuZGF0aW9uOyBlaXRoZXIgdmVyc2lvbiAyIG9mIHRoZSBMaWNlbnNlLCBvciAo
YXQgeW91cjxicj4rICogb3B0aW9uKSBhbnkgbGF0ZXIgdmVyc2lvbi48YnI+KyAqPGJyPisgKiBU
aGlzIHByb2dyYW0gaXMgZGlzdHJpYnV0ZWQgaW4gdGhlIGhvcGUgdGhhdCBpdCB3aWxsIGJlIHVz
ZWZ1bCwgYnV0PGJyPisgKiBXSVRIT1VUIEFOWSBXQVJSQU5UWTsgd2l0aG91dCBldmVuIHRoZSBp
bXBsaWVkIHdhcnJhbnR5IG9mIE1FUkNIQU5UQUJJTElUWTxicj4rICogb3IgRklUTkVTUyBGT1Ig
QSBQQVJUSUNVTEFSIFBVUlBPU0UuICZuYnNwO1NlZSB0aGUgR05VIEdlbmVyYWwgUHVibGljIExp
Y2Vuc2U8YnI+KyAqIGZvciBtb3JlIGRldGFpbHMuPGJyPisgKi88YnI+Kzxicj4rI2luY2x1ZGUg
Jmx0O2xpbnV4L3R5cGVzLmgmZ3Q7PGJyPisjaW5jbHVkZSAmbHQ7bGludXgvZXJybm8uaCZndDs8
YnI+KyNpbmNsdWRlICZsdDtsaW51eC9kZWxheS5oJmd0Ozxicj4rI2luY2x1ZGUgJmx0O2xpbnV4
L3NwaW5sb2NrLmgmZ3Q7PGJyPisjaW5jbHVkZSAmbHQ7bGludXgvaW8uaCZndDs8YnI+KyNpbmNs
dWRlICZsdDtsaW51eC9tZmQvaW14LWlwdS12My5oJmd0Ozxicj4rI2luY2x1ZGUgJmx0O2FzbS9h
dG9taWMuaCZndDs8YnI+Kzxicj4rI2luY2x1ZGUgJnF1b3Q7aXB1LXBydi5oJnF1b3Q7PGJyPis8
YnI+KyNkZWZpbmUgQVNZTkNfU0VSX1dBVkUgNjxicj4rPGJyPisjZGVmaW5lIERDX0RJU1BfSURf
U0VSSUFMICZuYnNwOyAmbmJzcDsgJm5ic3A7Mjxicj4rI2RlZmluZSBEQ19ESVNQX0lEX0FTWU5D
ICZuYnNwOyAmbmJzcDsgJm5ic3A7IDM8YnI+Kzxicj4rI2RlZmluZSBEQ19NQVBfQ09ORl9QVFIo
bikgJm5ic3A7ICZuYnNwOyAoaXB1X2RjX3JlZyArIDB4MDEwOCArICgobikgJmFtcDsgfjB4MSkg
KiAyKTxicj4rI2RlZmluZSBEQ19NQVBfQ09ORl9WQUwobikgJm5ic3A7ICZuYnNwOyAoaXB1X2Rj
X3JlZyArIDB4MDE0NCArICgobikgJmFtcDsgfjB4MSkgKiAyKTxicj4rPGJyPisjZGVmaW5lIERD
X0VWVF9ORiAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsw
PGJyPisjZGVmaW5lIERDX0VWVF9OTCAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7
ICZuYnNwOyAmbmJzcDsxPGJyPisjZGVmaW5lIERDX0VWVF9FT0YgJm5ic3A7ICZuYnNwOyAmbmJz
cDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgMjxicj4rI2RlZmluZSBEQ19FVlRfTkZJRUxEICZuYnNw
OyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDszPGJyPisjZGVmaW5lIERDX0VWVF9FT0wgJm5i
c3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgNDxicj4rI2RlZmluZSBEQ19F
VlRfRU9GSUVMRCAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgNTxicj4rI2RlZmluZSBEQ19F
VlRfTkVXX0FERFIgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5i
c3A7ICZuYnNwOzY8YnI+KyNkZWZpbmUgRENfRVZUX05FV19DSEFOICZuYnNwOyAmbmJzcDsgJm5i
c3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDs3PGJyPisjZGVmaW5lIERDX0VW
VF9ORVdfREFUQSAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJz
cDsgJm5ic3A7ODxicj4rPGJyPisjZGVmaW5lIERDX0VWVF9ORVdfQUREUl9XXzAgJm5ic3A7ICZu
YnNwOzA8YnI+KyNkZWZpbmUgRENfRVZUX05FV19BRERSX1dfMSAmbmJzcDsgJm5ic3A7MTxicj4r
I2RlZmluZSBEQ19FVlRfTkVXX0NIQU5fV18wICZuYnNwOyAmbmJzcDsyPGJyPisjZGVmaW5lIERD
X0VWVF9ORVdfQ0hBTl9XXzEgJm5ic3A7ICZuYnNwOzM8YnI+KyNkZWZpbmUgRENfRVZUX05FV19E
QVRBX1dfMCAmbmJzcDsgJm5ic3A7NDxicj4rI2RlZmluZSBEQ19FVlRfTkVXX0RBVEFfV18xICZu
YnNwOyAmbmJzcDs1PGJyPisjZGVmaW5lIERDX0VWVF9ORVdfQUREUl9SXzAgJm5ic3A7ICZuYnNw
OzY8YnI+KyNkZWZpbmUgRENfRVZUX05FV19BRERSX1JfMSAmbmJzcDsgJm5ic3A7Nzxicj4rI2Rl
ZmluZSBEQ19FVlRfTkVXX0NIQU5fUl8wICZuYnNwOyAmbmJzcDs4PGJyPisjZGVmaW5lIERDX0VW
VF9ORVdfQ0hBTl9SXzEgJm5ic3A7ICZuYnNwOzk8YnI+KyNkZWZpbmUgRENfRVZUX05FV19EQVRB
X1JfMCAmbmJzcDsgJm5ic3A7MTA8YnI+KyNkZWZpbmUgRENfRVZUX05FV19EQVRBX1JfMSAmbmJz
cDsgJm5ic3A7MTE8YnI+Kzxicj4rI2RlZmluZSBEQ19XUl9DSF9DT05GKGNoKSAmbmJzcDsgJm5i
c3A7ICZuYnNwOyhpcHVfZGNfcmVnICsgZGNfY2hhbm5lbHNbY2hdLmNoYW5uZWxfb2Zmc2V0KTxi
cj4rI2RlZmluZSBEQ19XUl9DSF9BRERSKGNoKSAmbmJzcDsgJm5ic3A7ICZuYnNwOyhpcHVfZGNf
cmVnICsgZGNfY2hhbm5lbHNbY2hdLmNoYW5uZWxfb2Zmc2V0ICsgNCk8YnI+KyNkZWZpbmUgRENf
UkxfQ0goY2gsIGV2dCkgJm5ic3A7ICZuYnNwOyAmbmJzcDsoaXB1X2RjX3JlZyArIGRjX2NoYW5u
ZWxzW2NoXS5jaGFubmVsX29mZnNldCArIDggKyAoKGV2dCkgJmFtcDsgfjB4MSkgKiAyKTxicj4r
PGJyPisjZGVmaW5lIERDX0dFTiAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZu
YnNwOyAmbmJzcDsgJm5ic3A7IChpcHVfZGNfcmVnICsgMHgwMEQ0KTxicj4rI2RlZmluZSBEQ19E
SVNQX0NPTkYxKGRpc3ApICZuYnNwOyAmbmJzcDsoaXB1X2RjX3JlZyArIDB4MDBEOCArIGRpc3Ag
KiA0KTxicj4rI2RlZmluZSBEQ19ESVNQX0NPTkYyKGRpc3ApICZuYnNwOyAmbmJzcDsoaXB1X2Rj
X3JlZyArIDB4MDBFOCArIGRpc3AgKiA0KTxicj4rI2RlZmluZSBEQ19TVEFUICZuYnNwOyAmbmJz
cDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNw
OyAmbmJzcDsgJm5ic3A7KGlwdV9kY19yZWcgKyAweDAxQzgpPGJyPis8YnI+KyNkZWZpbmUgV1JP
RChsZikgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICgw
eDE4IHwgKGxmICZsdDsmbHQ7IDEpKTxicj4rPGJyPisjZGVmaW5lIERDX1dSX0NIX0NPTkZfRklF
TERfTU9ERSAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsg
KDEgJmx0OyZsdDsgOSk8YnI+KyNkZWZpbmUgRENfV1JfQ0hfQ09ORl9QUk9HX1RZUEVfT0ZGU0VU
ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyA1PGJyPisjZGVmaW5lIERDX1dSX0NIX0NPTkZf
UFJPR19UWVBFX01BU0sgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAoNyAmbHQ7
Jmx0OyA1KTxicj4rI2RlZmluZSBEQ19XUl9DSF9DT05GX1BST0dfRElfSUQgJm5ic3A7ICZuYnNw
OyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICgxICZsdDsmbHQ7IDIpPGJyPisj
ZGVmaW5lIERDX1dSX0NIX0NPTkZfUFJPR19ESVNQX0lEX09GRlNFVCAmbmJzcDsgJm5ic3A7ICZu
YnNwOzM8YnI+KyNkZWZpbmUgRENfV1JfQ0hfQ09ORl9QUk9HX0RJU1BfSURfTUFTSyAmbmJzcDsg
Jm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7KDMgJmx0OyZs
dDsgMyk8YnI+Kzxicj4rc3RhdGljIHZvaWQgX19pb21lbSAqaXB1X2RjX3JlZzs8YnI+K3N0YXRp
YyB2b2lkIF9faW9tZW0gKmlwdV9kY190bXBsX3JlZzs8YnI+K3N0YXRpYyBzdHJ1Y3QgZGV2aWNl
ICppcHVfZGV2Ozxicj4rPGJyPitzdHJ1Y3QgaXB1X2RjIHs8YnI+KyAmbmJzcDsgJm5ic3A7ICZu
YnNwOyB1bnNpZ25lZCBpbnQgZGk7IC8qIFRoZSBkaXNwbGF5IGludGVyZmFjZSBudW1iZXIgYXNz
aWduZWQgdG8gdGhpcyBkYyBjaGFubmVsICovPGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgdW5z
aWduZWQgaW50IGNoYW5uZWxfb2Zmc2V0Ozxicj4rfTs8YnI+Kzxicj4rc3RhdGljIHN0cnVjdCBp
cHVfZGMgZGNfY2hhbm5lbHNbMTBdOzxicj4rPGJyPitzdGF0aWMgdm9pZCBpcHVfZGNfbGlua19l
dmVudChpbnQgY2hhbiwgaW50IGV2ZW50LCBpbnQgYWRkciwgaW50IHByaW9yaXR5KTxicj4rezxi
cj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7IHUzMiByZWc7PGJyPis8YnI+KyAmbmJzcDsgJm5ic3A7
ICZuYnNwOyByZWcgPSBfX3Jhd19yZWFkbChEQ19STF9DSChjaGFuLCBldmVudCkpOzxicj4rICZu
YnNwOyAmbmJzcDsgJm5ic3A7IHJlZyAmYW1wOz0gfigweEZGRkYgJmx0OyZsdDsgKDE2ICogKGV2
ZW50ICZhbXA7IDB4MSkpKTs8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyByZWcgfD0gKChhZGRy
ICZsdDsmbHQ7IDgpIHwgcHJpb3JpdHkpICZsdDsmbHQ7ICgxNiAqIChldmVudCAmYW1wOyAweDEp
KTs8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBfX3Jhd193cml0ZWwocmVnLCBEQ19STF9DSChj
aGFuLCBldmVudCkpOzxicj4rfTxicj4rPGJyPitzdGF0aWMgdm9pZCBpcHVfZGNfd3JpdGVfdG1w
bChpbnQgd29yZCwgdTMyIG9wY29kZSwgdTMyIG9wZXJhbmQsIGludCBtYXAsPGJyPisgJm5ic3A7
ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsg
Jm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDtpbnQgd2F2ZSwgaW50IGds
dWUsIGludCBzeW5jKTxicj4rezxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7IHUzMiByZWc7PGJy
PisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgaW50IHN0b3AgPSAxOzxicj4rPGJyPisgJm5ic3A7ICZu
YnNwOyAmbmJzcDsgcmVnID0gc3luYzs8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyByZWcgfD0g
KGdsdWUgJmx0OyZsdDsgNCk7PGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgcmVnIHw9ICgrK3dh
dmUgJmx0OyZsdDsgMTEpOzxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7IHJlZyB8PSAoKyttYXAg
Jmx0OyZsdDsgMTUpOzxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7IHJlZyB8PSAob3BlcmFuZCAm
bHQ7Jmx0OyAyMCkgJmFtcDsgMHhGRkYwMDAwMDs8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBf
X3Jhd193cml0ZWwocmVnLCBpcHVfZGNfdG1wbF9yZWcgKyB3b3JkICogOCk7PGJyPis8YnI+KyAm
bmJzcDsgJm5ic3A7ICZuYnNwOyByZWcgPSAob3BlcmFuZCAmZ3Q7Jmd0OyAxMik7PGJyPisgJm5i
c3A7ICZuYnNwOyAmbmJzcDsgcmVnIHw9IG9wY29kZSAmbHQ7Jmx0OyA0Ozxicj4rICZuYnNwOyAm
bmJzcDsgJm5ic3A7IHJlZyB8PSAoc3RvcCAmbHQ7Jmx0OyA5KTs8YnI+KyAmbmJzcDsgJm5ic3A7
ICZuYnNwOyBfX3Jhd193cml0ZWwocmVnLCBpcHVfZGNfdG1wbF9yZWcgKyB3b3JkICogOCArIDQp
Ozxicj4rfTxicj4rPGJyPitzdGF0aWMgaW50IGlwdV9waXhmbXRfdG9fbWFwKHUzMiBmbXQpPGJy
Pit7PGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgc3dpdGNoIChmbXQpIHs8YnI+KyAmbmJzcDsg
Jm5ic3A7ICZuYnNwOyBjYXNlIElQVV9QSVhfRk1UX0dFTkVSSUM6PGJyPisgJm5ic3A7ICZuYnNw
OyAmbmJzcDsgY2FzZSBJUFVfUElYX0ZNVF9SR0IyNDo8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNw
OyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgcmV0dXJuIDA7PGJyPisgJm5ic3A7ICZuYnNw
OyAmbmJzcDsgY2FzZSBJUFVfUElYX0ZNVF9SR0I2NjY6PGJyPisgJm5ic3A7ICZuYnNwOyAmbmJz
cDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7IHJldHVybiAxOzxicj4rICZuYnNwOyAmbmJz
cDsgJm5ic3A7IGNhc2UgSVBVX1BJWF9GTVRfWVVWNDQ0Ojxicj4rICZuYnNwOyAmbmJzcDsgJm5i
c3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyByZXR1cm4gMjs8YnI+KyAmbmJzcDsgJm5i
c3A7ICZuYnNwOyBjYXNlIElQVV9QSVhfRk1UX1JHQjU2NTo8YnI+KyAmbmJzcDsgJm5ic3A7ICZu
YnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgcmV0dXJuIDM7PGJyPisgJm5ic3A7ICZu
YnNwOyAmbmJzcDsgY2FzZSBJUFVfUElYX0ZNVF9MVkRTNjY2Ojxicj4rICZuYnNwOyAmbmJzcDsg
Jm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyByZXR1cm4gNDs8YnI+KyAmbmJzcDsg
Jm5ic3A7ICZuYnNwOyB9PGJyPis8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyByZXR1cm4gLUVJ
TlZBTDs8YnI+K308YnI+Kzxicj4rI2RlZmluZSBTWU5DX1dBVkUgMDxicj4rPGJyPitpbnQgaXB1
X2RjX2luaXRfc3luYyhpbnQgZGNfY2hhbiwgaW50IGRpLCBib29sIGludGVybGFjZWQsIHUzMiBw
aXhlbF9mbXQsIHUzMiB3aWR0aCk8YnI+K3s8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyB1MzIg
cmVnID0gMCwgbWFwOzxicj4rPGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgZGNfY2hhbm5lbHNb
ZGNfY2hhbl0uZGkgPSBkaTs8YnI+Kzxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7IG1hcCA9IGlw
dV9waXhmbXRfdG9fbWFwKHBpeGVsX2ZtdCk7PGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgaWYg
KG1hcCAmbHQ7IDApIHs8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZu
YnNwOyAmbmJzcDsgZGV2X2RiZyhpcHVfZGV2LCAmcXVvdDtJUFVfRElTUDogTm8gTUFQXG4mcXVv
dDspOzxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNw
OyByZXR1cm4gLUVJTlZBTDs8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyB9PGJyPis8YnI+KyAm
bmJzcDsgJm5ic3A7ICZuYnNwOyBpZiAoaW50ZXJsYWNlZCkgezxicj4rICZuYnNwOyAmbmJzcDsg
Jm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBpcHVfZGNfbGlua19ldmVudChkY19j
aGFuLCBEQ19FVlRfTkwsIDAsIDMpOzxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAm
bmJzcDsgJm5ic3A7ICZuYnNwOyBpcHVfZGNfbGlua19ldmVudChkY19jaGFuLCBEQ19FVlRfRU9M
LCAwLCAyKTs8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAm
bmJzcDsgaXB1X2RjX2xpbmtfZXZlbnQoZGNfY2hhbiwgRENfRVZUX05FV19EQVRBLCAwLCAxKTs8
YnI+Kzxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNw
OyAvKiBJbml0IHRlbXBsYXRlIG1pY3JvY29kZSAqLzxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7
ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBpcHVfZGNfd3JpdGVfdG1wbCgwLCBXUk9EKDAp
LCAwLCBtYXAsIFNZTkNfV0FWRSwgMCwgOCk7PGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgfSBl
bHNlIHs8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJz
cDsgaWYgKGRpKSB7PGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJz
cDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBpcHVfZGNfbGlua19ldmVudChk
Y19jaGFuLCBEQ19FVlRfTkwsIDIsIDMpOzxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNw
OyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgaXB1X2Rj
X2xpbmtfZXZlbnQoZGNfY2hhbiwgRENfRVZUX0VPTCwgMywgMik7PGJyPisgJm5ic3A7ICZuYnNw
OyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7
ICZuYnNwOyBpcHVfZGNfbGlua19ldmVudChkY19jaGFuLCBEQ19FVlRfTkVXX0RBVEEsIDQsIDEp
Ozxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAm
bmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgLyogSW5pdCB0ZW1wbGF0ZSBtaWNyb2NvZGUgKi88
YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5i
c3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7IGlwdV9kY193cml0ZV90bXBsKDIsIFdST0QoMCksIDAs
IG1hcCwgU1lOQ19XQVZFLCA4LCA1KTs8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsg
Jm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7IGlwdV9kY193
cml0ZV90bXBsKDMsIFdST0QoMCksIDAsIG1hcCwgU1lOQ19XQVZFLCA0LCA1KTs8YnI+KyAmbmJz
cDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNw
OyAmbmJzcDsgJm5ic3A7IGlwdV9kY193cml0ZV90bXBsKDQsIFdST0QoMCksIDAsIG1hcCwgU1lO
Q19XQVZFLCAwLCA1KTs8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZu
YnNwOyAmbmJzcDsgfSBlbHNlIHs8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5i
c3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7IGlwdV9kY19saW5r
X2V2ZW50KGRjX2NoYW4sIERDX0VWVF9OTCwgNSwgMyk7PGJyPisgJm5ic3A7ICZuYnNwOyAmbmJz
cDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNw
OyBpcHVfZGNfbGlua19ldmVudChkY19jaGFuLCBEQ19FVlRfRU9MLCA2LCAyKTs8YnI+KyAmbmJz
cDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNw
OyAmbmJzcDsgJm5ic3A7IGlwdV9kY19saW5rX2V2ZW50KGRjX2NoYW4sIERDX0VWVF9ORVdfREFU
QSwgNywgMSk7PGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsg
Jm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAvKiBJbml0IHRlbXBsYXRlIG1pY3Jv
Y29kZSAqLzxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZu
YnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgaXB1X2RjX3dyaXRlX3RtcGwoNSwgV1JP
RCgwKSwgMCwgbWFwLCBTWU5DX1dBVkUsIDgsIDUpOzxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7
ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsg
aXB1X2RjX3dyaXRlX3RtcGwoNiwgV1JPRCgwKSwgMCwgbWFwLCBTWU5DX1dBVkUsIDQsIDUpOzxi
cj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJz
cDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgaXB1X2RjX3dyaXRlX3RtcGwoNywgV1JPRCgwKSwgMCwg
bWFwLCBTWU5DX1dBVkUsIDAsIDUpOzxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAm
bmJzcDsgJm5ic3A7ICZuYnNwOyB9PGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgfTxicj4rICZu
YnNwOyAmbmJzcDsgJm5ic3A7IGlwdV9kY19saW5rX2V2ZW50KGRjX2NoYW4sIERDX0VWVF9ORiwg
MCwgMCk7PGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgaXB1X2RjX2xpbmtfZXZlbnQoZGNfY2hh
biwgRENfRVZUX05GSUVMRCwgMCwgMCk7PGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgaXB1X2Rj
X2xpbmtfZXZlbnQoZGNfY2hhbiwgRENfRVZUX0VPRiwgMCwgMCk7PGJyPisgJm5ic3A7ICZuYnNw
OyAmbmJzcDsgaXB1X2RjX2xpbmtfZXZlbnQoZGNfY2hhbiwgRENfRVZUX0VPRklFTEQsIDAsIDAp
Ozxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7IGlwdV9kY19saW5rX2V2ZW50KGRjX2NoYW4sIERD
X0VWVF9ORVdfQ0hBTiwgMCwgMCk7PGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgaXB1X2RjX2xp
bmtfZXZlbnQoZGNfY2hhbiwgRENfRVZUX05FV19BRERSLCAwLCAwKTs8YnI+Kzxicj4rICZuYnNw
OyAmbmJzcDsgJm5ic3A7IHJlZyA9IDB4Mjs8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyByZWcg
fD0gZGkgJmx0OyZsdDsgRENfV1JfQ0hfQ09ORl9QUk9HX0RJU1BfSURfT0ZGU0VUOzxicj4rICZu
YnNwOyAmbmJzcDsgJm5ic3A7IHJlZyB8PSBkaSAmbHQ7Jmx0OyAyOzxicj4rICZuYnNwOyAmbmJz
cDsgJm5ic3A7IGlmIChpbnRlcmxhY2VkKTxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNw
OyAmbmJzcDsgJm5ic3A7ICZuYnNwOyByZWcgfD0gRENfV1JfQ0hfQ09ORl9GSUVMRF9NT0RFOzxi
cj4rPGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgX19yYXdfd3JpdGVsKHJlZywgRENfV1JfQ0hf
Q09ORihkY19jaGFuKSk7PGJyPis8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBfX3Jhd193cml0
ZWwoMHgwMDAwMDAwMCwgRENfV1JfQ0hfQUREUihkY19jaGFuKSk7PGJyPis8YnI+KyAmbmJzcDsg
Jm5ic3A7ICZuYnNwOyBfX3Jhd193cml0ZWwoMHgwMDAwMDA4NCwgRENfR0VOKTs8YnI+Kzxicj4r
ICZuYnNwOyAmbmJzcDsgJm5ic3A7IF9fcmF3X3dyaXRlbCh3aWR0aCwgRENfRElTUF9DT05GMihk
aSkpOzxicj4rPGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgaXB1X21vZHVsZV9lbmFibGUoSVBV
X0NPTkZfRENfRU4pOzxicj4rPGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgcmV0dXJuIDA7PGJy
Pit9PGJyPitFWFBPUlRfU1lNQk9MKGlwdV9kY19pbml0X3N5bmMpOzxicj4rPGJyPit2b2lkIGlw
dV9kY19pbml0X2FzeW5jKGludCBkY19jaGFuLCBpbnQgZGksIGJvb2wgaW50ZXJsYWNlZCk8YnI+
K3s8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyB1MzIgcmVnID0gMDs8YnI+KyAmbmJzcDsgJm5i
c3A7ICZuYnNwOyBkY19jaGFubmVsc1tkY19jaGFuXS5kaSA9IGRpOzxicj4rICZuYnNwOyAmbmJz
cDsgJm5ic3A7IGlwdV9kY19saW5rX2V2ZW50KGRjX2NoYW4sIERDX0VWVF9ORVdfREFUQV9XXzAs
IDB4NjQsIDEpOzxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7IGlwdV9kY19saW5rX2V2ZW50KGRj
X2NoYW4sIERDX0VWVF9ORVdfREFUQV9XXzEsIDB4NjQsIDEpOzxicj4rPGJyPisgJm5ic3A7ICZu
YnNwOyAmbmJzcDsgcmVnID0gMHgzOzxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7IHJlZyB8PSBE
Q19ESVNQX0lEX1NFUklBTCAmbHQ7Jmx0OyBEQ19XUl9DSF9DT05GX1BST0dfRElTUF9JRF9PRkZT
RVQ7PGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgX19yYXdfd3JpdGVsKHJlZywgRENfV1JfQ0hf
Q09ORihkY19jaGFuKSk7PGJyPis8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBfX3Jhd193cml0
ZWwoMHgwMDAwMDAwMCwgRENfV1JfQ0hfQUREUihkY19jaGFuKSk7PGJyPis8YnI+KyAmbmJzcDsg
Jm5ic3A7ICZuYnNwOyBfX3Jhd193cml0ZWwoMHgwMDAwMDA4NCwgRENfR0VOKTs8YnI+Kzxicj4r
ICZuYnNwOyAmbmJzcDsgJm5ic3A7IGlwdV9tb2R1bGVfZW5hYmxlKElQVV9DT05GX0RDX0VOKTs8
YnI+K308YnI+K0VYUE9SVF9TWU1CT0woaXB1X2RjX2luaXRfYXN5bmMpOzxicj4rPGJyPit2b2lk
IGlwdV9kY19lbmFibGVfY2hhbm5lbCh1MzIgZGNfY2hhbik8YnI+K3s8YnI+KyAmbmJzcDsgJm5i
c3A7ICZuYnNwOyBpbnQgZGk7PGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgdTMyIHJlZzs8YnI+
Kzxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7IGRpID0gZGNfY2hhbm5lbHNbZGNfY2hhbl0uZGk7
PGJyPis8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAvKiBNYWtlIHN1cmUgb3RoZXIgREMgc3lu
YyBjaGFubmVsIGlzIG5vdCBhc3NpZ25lZCBzYW1lIERJICovPGJyPisgJm5ic3A7ICZuYnNwOyAm
bmJzcDsgcmVnID0gX19yYXdfcmVhZGwoRENfV1JfQ0hfQ09ORig2IC0gZGNfY2hhbikpOzxicj4r
ICZuYnNwOyAmbmJzcDsgJm5ic3A7IGlmICgoZGkgJmx0OyZsdDsgMikgPT0gKHJlZyAmYW1wOyBE
Q19XUl9DSF9DT05GX1BST0dfRElfSUQpKSB7PGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5i
c3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7IHJlZyAmYW1wOz0gfkRDX1dSX0NIX0NPTkZfUFJPR19E
SV9JRDs8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJz
cDsgcmVnIHw9IGRpID8gMCA6IERDX1dSX0NIX0NPTkZfUFJPR19ESV9JRDs8YnI+KyAmbmJzcDsg
Jm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgX19yYXdfd3JpdGVsKHJl
ZywgRENfV1JfQ0hfQ09ORig2IC0gZGNfY2hhbikpOzxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7
IH08YnI+Kzxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7IHJlZyA9IF9fcmF3X3JlYWRsKERDX1dS
X0NIX0NPTkYoZGNfY2hhbikpOzxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7IHJlZyB8PSA0ICZs
dDsmbHQ7IERDX1dSX0NIX0NPTkZfUFJPR19UWVBFX09GRlNFVDs8YnI+KyAmbmJzcDsgJm5ic3A7
ICZuYnNwOyBfX3Jhd193cml0ZWwocmVnLCBEQ19XUl9DSF9DT05GKGRjX2NoYW4pKTs8YnI+K308
YnI+K0VYUE9SVF9TWU1CT0woaXB1X2RjX2VuYWJsZV9jaGFubmVsKTs8YnI+Kzxicj4rdm9pZCBp
cHVfZGNfZGlzYWJsZV9jaGFubmVsKHUzMiBkY19jaGFuKTxicj4rezxicj4rICZuYnNwOyAmbmJz
cDsgJm5ic3A7IHUzMiByZWc7PGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgaW50IGlycSA9IDAs
IHJldCwgdGltZW91dCA9IDUwOzxicj4rPGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgaWYgKGRj
X2NoYW4gPT0gMSkgezxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5i
c3A7ICZuYnNwOyBpcnEgPSBJUFVfSVJRX0RDX0ZDXzE7PGJyPisgJm5ic3A7ICZuYnNwOyAmbmJz
cDsgfSBlbHNlIGlmIChkY19jaGFuID09IDUpIHs8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAm
bmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgaXJxID0gSVBVX0lSUV9EUF9TRl9FTkQ7PGJyPisg
Jm5ic3A7ICZuYnNwOyAmbmJzcDsgfSBlbHNlIHs8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAm
bmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgcmV0dXJuOzxicj4rICZuYnNwOyAmbmJzcDsgJm5i
c3A7IH08YnI+Kzxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7IHJldCA9IGlwdV93YWl0X2Zvcl9p
bnRlcnJ1cHQoaXJxLCA1MCk7PGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgaWYgKHJldCk8YnI+
KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgcmV0dXJu
Ozxicj4rPGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgLyogV2FpdCBmb3IgREMgdHJpcGxlIGJ1
ZmZlciB0byBlbXB0eSAqLzxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7IGlmIChkY19jaGFubmVs
c1tkY19jaGFuXS5kaSA9PSAwKTxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJz
cDsgJm5ic3A7ICZuYnNwOyB3aGlsZSAoKF9fcmF3X3JlYWRsKERDX1NUQVQpICZhbXA7IDB4MDAw
MDAwMDIpPGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5i
c3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAhPSAweDAwMDAwMDAyKSB7PGJyPisgJm5i
c3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJz
cDsgJm5ic3A7ICZuYnNwOyBtc2xlZXAoMik7PGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5i
c3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyB0aW1l
b3V0IC09IDI7PGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsg
Jm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBpZiAodGltZW91dCAmbHQ7PSAwKTxi
cj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJz
cDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7IGJyZWFr
Ozxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyB9
PGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgZWxzZSBpZiAoZGNfY2hhbm5lbHNbZGNfY2hhbl0u
ZGkgPT0gMSk8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAm
bmJzcDsgd2hpbGUgKChfX3Jhd19yZWFkbChEQ19TVEFUKSAmYW1wOyAweDAwMDAwMDIwKTxicj4r
ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsg
Jm5ic3A7ICZuYnNwOyAmbmJzcDsgIT0gMHgwMDAwMDAyMCkgezxicj4rICZuYnNwOyAmbmJzcDsg
Jm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAm
bmJzcDsgbXNsZWVwKDIpOzxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsg
Jm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgdGltZW91dCAtPSAyOzxi
cj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJz
cDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgaWYgKHRpbWVvdXQgJmx0Oz0gMCk8YnI+KyAmbmJzcDsg
Jm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAm
bmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBicmVhazs8YnI+KyAmbmJz
cDsgJm5ic3A7ICZuYnNwOyB9PGJyPis8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyByZWcgPSBf
X3Jhd19yZWFkbChEQ19XUl9DSF9DT05GKGRjX2NoYW4pKTs8YnI+KyAmbmJzcDsgJm5ic3A7ICZu
YnNwOyByZWcgJmFtcDs9IH5EQ19XUl9DSF9DT05GX1BST0dfVFlQRV9NQVNLOzxicj4rICZuYnNw
OyAmbmJzcDsgJm5ic3A7IF9fcmF3X3dyaXRlbChyZWcsIERDX1dSX0NIX0NPTkYoZGNfY2hhbikp
Ozxicj4rfTxicj4rRVhQT1JUX1NZTUJPTChpcHVfZGNfZGlzYWJsZV9jaGFubmVsKTs8YnI+Kzxi
cj4rc3RhdGljIHZvaWQgaXB1X2RjX21hcF9jb25maWcoaW50IG1hcCwgaW50IGJ5dGVfbnVtLCBp
bnQgb2Zmc2V0LCBpbnQgbWFzayk8YnI+K3s8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBpbnQg
cHRyID0gbWFwICogMyArIGJ5dGVfbnVtOzxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7IHUzMiBy
ZWc7PGJyPis8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyByZWcgPSBfX3Jhd19yZWFkbChEQ19N
QVBfQ09ORl9WQUwocHRyKSk7PGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgcmVnICZhbXA7PSB+
KDB4ZmZmZiAmbHQ7Jmx0OyAoMTYgKiAocHRyICZhbXA7IDB4MSkpKTs8YnI+KyAmbmJzcDsgJm5i
c3A7ICZuYnNwOyByZWcgfD0gKChvZmZzZXQgJmx0OyZsdDsgOCkgfCBtYXNrKSAmbHQ7Jmx0OyAo
MTYgKiAocHRyICZhbXA7IDB4MSkpOzxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7IF9fcmF3X3dy
aXRlbChyZWcsIERDX01BUF9DT05GX1ZBTChwdHIpKTs8YnI+Kzxicj4rICZuYnNwOyAmbmJzcDsg
Jm5ic3A7IHJlZyA9IF9fcmF3X3JlYWRsKERDX01BUF9DT05GX1BUUihtYXApKTs8YnI+KyAmbmJz
cDsgJm5ic3A7ICZuYnNwOyByZWcgJmFtcDs9IH4oMHgxZiAmbHQ7Jmx0OyAoKDE2ICogKG1hcCAm
YW1wOyAweDEpKSArICg1ICogYnl0ZV9udW0pKSk7PGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsg
cmVnIHw9IHB0ciAmbHQ7Jmx0OyAoKDE2ICogKG1hcCAmYW1wOyAweDEpKSArICg1ICogYnl0ZV9u
dW0pKTs8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBfX3Jhd193cml0ZWwocmVnLCBEQ19NQVBf
Q09ORl9QVFIobWFwKSk7PGJyPit9PGJyPis8YnI+K3N0YXRpYyB2b2lkIGlwdV9kY19tYXBfY2xl
YXIoaW50IG1hcCk8YnI+K3s8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyB1MzIgcmVnID0gX19y
YXdfcmVhZGwoRENfTUFQX0NPTkZfUFRSKG1hcCkpOzxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7
IF9fcmF3X3dyaXRlbChyZWcgJmFtcDsgfigweGZmZmYgJmx0OyZsdDsgKDE2ICogKG1hcCAmYW1w
OyAweDEpKSksPGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsg
Jm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7RENfTUFQX0NPTkZfUFRSKG1hcCkpOzxicj4rfTxi
cj4rPGJyPitpbnQgaXB1X2RjX2luaXQoc3RydWN0IHBsYXRmb3JtX2RldmljZSAqcGRldiwgdW5z
aWduZWQgbG9uZyBiYXNlLCB1bnNpZ25lZCBsb25nIHRlbXBsYXRlX2Jhc2UpPGJyPit7PGJyPisg
Jm5ic3A7ICZuYnNwOyAmbmJzcDsgc3RhdGljIGludCBjaGFubmVsX29mZnNldHNbXSA9IHsgMCwg
MHgxYywgMHgzOCwgMHg1NCwgMHg1OCwgMHg1YywgMHg3OCwgMCwgMHg5NCwgMHhiNH07PGJyPisg
Jm5ic3A7ICZuYnNwOyAmbmJzcDsgaW50IGk7PGJyPis8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNw
OyBpcHVfZGNfcmVnID0gaW9yZW1hcChiYXNlLCBQQUdFX1NJWkUpOzxicj4rICZuYnNwOyAmbmJz
cDsgJm5ic3A7IGlmICghaXB1X2RjX3JlZyk8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJz
cDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgcmV0dXJuIC1FTk9NRU07PGJyPis8YnI+KyAmbmJzcDsg
Jm5ic3A7ICZuYnNwOyBpcHVfZGV2ID0gJmFtcDtwZGV2LSZndDtkZXY7PGJyPis8YnI+KyAmbmJz
cDsgJm5ic3A7ICZuYnNwOyBpcHVfZGNfdG1wbF9yZWcgPSBpb3JlbWFwKHRlbXBsYXRlX2Jhc2Us
IFBBR0VfU0laRSk7PGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgaWYgKCFpcHVfZGNfdG1wbF9y
ZWcpIHs8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJz
cDsgaW91bm1hcChpcHVfZGNfcmVnKTs8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsg
Jm5ic3A7ICZuYnNwOyAmbmJzcDsgcmV0dXJuIC1FTk9NRU07PGJyPisgJm5ic3A7ICZuYnNwOyAm
bmJzcDsgfTxicj4rPGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgZm9yIChpID0gMDsgaSAmbHQ7
IDEwOyBpKyspPGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsg
Jm5ic3A7IGRjX2NoYW5uZWxzW2ldLmNoYW5uZWxfb2Zmc2V0ID0gY2hhbm5lbF9vZmZzZXRzW2ld
Ozxicj4rPGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgLyogSVBVX1BJWF9GTVRfUkdCMjQgKi88
YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBpcHVfZGNfbWFwX2NsZWFyKDApOzxicj4rICZuYnNw
OyAmbmJzcDsgJm5ic3A7IGlwdV9kY19tYXBfY29uZmlnKDAsIDAsIDcsIDB4ZmYpOzxicj4rICZu
YnNwOyAmbmJzcDsgJm5ic3A7IGlwdV9kY19tYXBfY29uZmlnKDAsIDEsIDE1LCAweGZmKTs8YnI+
KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBpcHVfZGNfbWFwX2NvbmZpZygwLCAyLCAyMywgMHhmZik7
PGJyPis8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAvKiBJUFVfUElYX0ZNVF9SR0I2NjYgKi88
YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBpcHVfZGNfbWFwX2NsZWFyKDEpOzxicj4rICZuYnNw
OyAmbmJzcDsgJm5ic3A7IGlwdV9kY19tYXBfY29uZmlnKDEsIDAsIDUsIDB4ZmMpOzxicj4rICZu
YnNwOyAmbmJzcDsgJm5ic3A7IGlwdV9kY19tYXBfY29uZmlnKDEsIDEsIDExLCAweGZjKTs8YnI+
KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBpcHVfZGNfbWFwX2NvbmZpZygxLCAyLCAxNywgMHhmYyk7
PGJyPis8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAvKiBJUFVfUElYX0ZNVF9ZVVY0NDQgKi88
YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBpcHVfZGNfbWFwX2NsZWFyKDIpOzxicj4rICZuYnNw
OyAmbmJzcDsgJm5ic3A7IGlwdV9kY19tYXBfY29uZmlnKDIsIDAsIDE1LCAweGZmKTs8YnI+KyAm
bmJzcDsgJm5ic3A7ICZuYnNwOyBpcHVfZGNfbWFwX2NvbmZpZygyLCAxLCAyMywgMHhmZik7PGJy
PisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgaXB1X2RjX21hcF9jb25maWcoMiwgMiwgNywgMHhmZik7
PGJyPis8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAvKiBJUFVfUElYX0ZNVF9SR0I1NjUgKi88
YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBpcHVfZGNfbWFwX2NsZWFyKDMpOzxicj4rICZuYnNw
OyAmbmJzcDsgJm5ic3A7IGlwdV9kY19tYXBfY29uZmlnKDMsIDAsIDQsIDB4ZjgpOzxicj4rICZu
YnNwOyAmbmJzcDsgJm5ic3A7IGlwdV9kY19tYXBfY29uZmlnKDMsIDEsIDEwLCAweGZjKTs8YnI+
KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBpcHVfZGNfbWFwX2NvbmZpZygzLCAyLCAxNSwgMHhmOCk7
PGJyPis8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAvKiBJUFVfUElYX0ZNVF9MVkRTNjY2ICov
PGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgaXB1X2RjX21hcF9jbGVhcig0KTs8YnI+KyAmbmJz
cDsgJm5ic3A7ICZuYnNwOyBpcHVfZGNfbWFwX2NvbmZpZyg0LCAwLCA1LCAweGZjKTs8YnI+KyAm
bmJzcDsgJm5ic3A7ICZuYnNwOyBpcHVfZGNfbWFwX2NvbmZpZyg0LCAxLCAxMywgMHhmYyk7PGJy
PisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgaXB1X2RjX21hcF9jb25maWcoNCwgMiwgMjEsIDB4ZmMp
Ozxicj4rPGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgcmV0dXJuIDA7PGJyPit9PGJyPis8YnI+
K3ZvaWQgaXB1X2RjX2V4aXQoc3RydWN0IHBsYXRmb3JtX2RldmljZSAqcGRldik8YnI+K3s8YnI+
KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBpb3VubWFwKGlwdV9kY19yZWcpOzxicj4rICZuYnNwOyAm
bmJzcDsgJm5ic3A7IGlvdW5tYXAoaXB1X2RjX3RtcGxfcmVnKTs8YnI+K308YnI+ZGlmZiAtLWdp
dCBhL2RyaXZlcnMvbWZkL2lteC1pcHUtdjMvaXB1LWRpLmMgYi9kcml2ZXJzL21mZC9pbXgtaXB1
LXYzL2lwdS1kaS5jPGJyPm5ldyBmaWxlIG1vZGUgMTAwNjQ0PGJyPmluZGV4IDAwMDAwMDAuLjcz
ZWJkNTE8YnI+LS0tIC9kZXYvbnVsbDxicj4rKysgYi9kcml2ZXJzL21mZC9pbXgtaXB1LXYzL2lw
dS1kaS5jPGJyPkBAIC0wLDAgKzEsNTA3IEBAPGJyPisvKjxicj4rICogQ29weXJpZ2h0IChjKSAy
MDEwIFNhc2NoYSBIYXVlciAmbHQ7PGEgaHJlZj0ibWFpbHRvOnMuaGF1ZXJAcGVuZ3V0cm9uaXgu
ZGUiPnMuaGF1ZXJAcGVuZ3V0cm9uaXguZGU8L2E+Jmd0Ozxicj4rICogQ29weXJpZ2h0IChDKSAy
MDA1LTIwMDkgRnJlZXNjYWxlIFNlbWljb25kdWN0b3IsIEluYy48YnI+KyAqPGJyPisgKiBUaGlz
IHByb2dyYW0gaXMgZnJlZSBzb2Z0d2FyZTsgeW91IGNhbiByZWRpc3RyaWJ1dGUgaXQgYW5kL29y
IG1vZGlmeSBpdDxicj4rICogdW5kZXIgdGhlIHRlcm1zIG9mIHRoZSBHTlUgR2VuZXJhbCBQdWJs
aWMgTGljZW5zZSBhcyBwdWJsaXNoZWQgYnkgdGhlPGJyPisgKiBGcmVlIFNvZnR3YXJlIEZvdW5k
YXRpb247IGVpdGhlciB2ZXJzaW9uIDIgb2YgdGhlIExpY2Vuc2UsIG9yIChhdCB5b3VyPGJyPisg
KiBvcHRpb24pIGFueSBsYXRlciB2ZXJzaW9uLjxicj4rICo8YnI+KyAqIFRoaXMgcHJvZ3JhbSBp
cyBkaXN0cmlidXRlZCBpbiB0aGUgaG9wZSB0aGF0IGl0IHdpbGwgYmUgdXNlZnVsLCBidXQ8YnI+
KyAqIFdJVEhPVVQgQU5ZIFdBUlJBTlRZOyB3aXRob3V0IGV2ZW4gdGhlIGltcGxpZWQgd2FycmFu
dHkgb2YgTUVSQ0hBTlRBQklMSVRZPGJyPisgKiBvciBGSVRORVNTIEZPUiBBIFBBUlRJQ1VMQVIg
UFVSUE9TRS4gJm5ic3A7U2VlIHRoZSBHTlUgR2VuZXJhbCBQdWJsaWMgTGljZW5zZTxicj4rICog
Zm9yIG1vcmUgZGV0YWlscy48YnI+KyAqLzxicj4rPGJyPisjaW5jbHVkZSAmbHQ7bGludXgvdHlw
ZXMuaCZndDs8YnI+KyNpbmNsdWRlICZsdDtsaW51eC9lcnJuby5oJmd0Ozxicj4rI2luY2x1ZGUg
Jmx0O2xpbnV4L2RlbGF5LmgmZ3Q7PGJyPisjaW5jbHVkZSAmbHQ7bGludXgvaW8uaCZndDs8YnI+
KyNpbmNsdWRlICZsdDtsaW51eC9tZmQvaW14LWlwdS12My5oJmd0Ozxicj4rI2luY2x1ZGUgJmx0
O2xpbnV4L3BsYXRmb3JtX2RldmljZS5oJmd0Ozxicj4rI2luY2x1ZGUgJmx0O2FzbS9hdG9taWMu
aCZndDs8YnI+Kzxicj4rI2luY2x1ZGUgJnF1b3Q7aXB1LXBydi5oJnF1b3Q7PGJyPis8YnI+KyNk
ZWZpbmUgU1lOQ19XQVZFIDA8YnI+Kzxicj4rI2RlZmluZSBEQ19ESVNQX0lEX1NZTkMoZGkpICZu
YnNwOyAmbmJzcDsoZGkpPGJyPis8YnI+K3N0cnVjdCBpcHVfZGkgezxicj4rICZuYnNwOyAmbmJz
cDsgJm5ic3A7IHZvaWQgX19pb21lbSAqYmFzZTs8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBp
bnQgaWQ7PGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgdTMyIG1vZHVsZTs8YnI+KyAmbmJzcDsg
Jm5ic3A7ICZuYnNwOyBzdHJ1Y3QgY2xrICpjbGs7PGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsg
c3RydWN0IGNsayAqaXB1X2Nsazs8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBib29sIGV4dGVy
bmFsX2Nsazs8YnI+K307PGJyPis8YnI+K3N0YXRpYyBzdHJ1Y3QgaXB1X2RpIGRpc1syXTs8YnI+
Kzxicj4rc3RhdGljIERFRklORV9NVVRFWChkaV9tdXRleCk7PGJyPitzdGF0aWMgc3RydWN0IGRl
dmljZSAqaXB1X2Rldjs8YnI+Kzxicj4rc3RydWN0IGRpX3N5bmNfY29uZmlnIHs8YnI+KyAmbmJz
cDsgJm5ic3A7ICZuYnNwOyBpbnQgcnVuX2NvdW50Ozxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7
IGludCBydW5fc3JjOzxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7IGludCBvZmZzZXRfY291bnQ7
PGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgaW50IG9mZnNldF9zcmM7PGJyPisgJm5ic3A7ICZu
YnNwOyAmbmJzcDsgaW50IHJlcGVhdF9jb3VudDs8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBp
bnQgY250X2Nscl9zcmM7PGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgaW50IGNudF9wb2xhcml0
eV9nZW5fZW47PGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgaW50IGNudF9wb2xhcml0eV9jbHJf
c3JjOzxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7IGludCBjbnRfcG9sYXJpdHlfdHJpZ2dlcl9z
cmM7PGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgaW50IGNudF91cDs8YnI+KyAmbmJzcDsgJm5i
c3A7ICZuYnNwOyBpbnQgY250X2Rvd247PGJyPit9Ozxicj4rPGJyPitlbnVtIGRpX3BpbnMgezxi
cj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7IERJX1BJTjExID0gMCw8YnI+KyAmbmJzcDsgJm5ic3A7
ICZuYnNwOyBESV9QSU4xMiA9IDEsPGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgRElfUElOMTMg
PSAyLDxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7IERJX1BJTjE0ID0gMyw8YnI+KyAmbmJzcDsg
Jm5ic3A7ICZuYnNwOyBESV9QSU4xNSA9IDQsPGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgRElf
UElOMTYgPSA1LDxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7IERJX1BJTjE3ID0gNiw8YnI+KyAm
bmJzcDsgJm5ic3A7ICZuYnNwOyBESV9QSU5fQ1MgPSA3LDxicj4rPGJyPisgJm5ic3A7ICZuYnNw
OyAmbmJzcDsgRElfUElOX1NFUl9DTEsgPSAwLDxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7IERJ
X1BJTl9TRVJfUlMgPSAxLDxicj4rfTs8YnI+Kzxicj4rZW51bSBkaV9zeW5jX3dhdmUgezxicj4r
ICZuYnNwOyAmbmJzcDsgJm5ic3A7IERJX1NZTkNfTk9ORSA9IDAsPGJyPisgJm5ic3A7ICZuYnNw
OyAmbmJzcDsgRElfU1lOQ19DTEsgPSAxLDxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7IERJX1NZ
TkNfSU5UX0hTWU5DID0gMiw8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBESV9TWU5DX0hTWU5D
ID0gMyw8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBESV9TWU5DX1ZTWU5DID0gNCw8YnI+KyAm
bmJzcDsgJm5ic3A7ICZuYnNwOyBESV9TWU5DX0RFID0gNiw8YnI+K307PGJyPis8YnI+KyNkZWZp
bmUgRElfR0VORVJBTCAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAw
eDAwMDA8YnI+KyNkZWZpbmUgRElfQlNfQ0xLR0VOMCAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJz
cDsgJm5ic3A7MHgwMDA0PGJyPisjZGVmaW5lIERJX0JTX0NMS0dFTjEgJm5ic3A7ICZuYnNwOyAm
bmJzcDsgJm5ic3A7ICZuYnNwOzB4MDAwODxicj4rI2RlZmluZSBESV9TV19HRU4wKGdlbikgJm5i
c3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOygweDAw
MGMgKyA0ICogKChnZW4pIC0gMSkpPGJyPisjZGVmaW5lIERJX1NXX0dFTjEoZ2VuKSAmbmJzcDsg
Jm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7KDB4MDAzMCAr
IDQgKiAoKGdlbikgLSAxKSk8YnI+KyNkZWZpbmUgRElfU1RQX1JFUChnZW4pICZuYnNwOyAmbmJz
cDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsoMHgwMTQ4ICsgNCAq
ICgoKGdlbikgLSAxKS8yKSk8YnI+KyNkZWZpbmUgRElfU1lOQ19BU19HRU4gJm5ic3A7ICZuYnNw
OyAmbmJzcDsgJm5ic3A7IDB4MDA1NDxicj4rI2RlZmluZSBESV9EV19HRU4oZ2VuKSAmbmJzcDsg
Jm5ic3A7ICZuYnNwOyAmbmJzcDsgKDB4MDA1OCArIDQgKiAoZ2VuKSk8YnI+KyNkZWZpbmUgRElf
RFdfU0VUKGdlbiwgc2V0KSAmbmJzcDsgJm5ic3A7KDB4MDA4OCArIDQgKiAoKGdlbikgKyAweGMg
KiAoc2V0KSkpPGJyPisjZGVmaW5lIERJX1NFUl9DT05GICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZu
YnNwOyAmbmJzcDsgJm5ic3A7MHgwMTVjPGJyPisjZGVmaW5lIERJX1NTQyAmbmJzcDsgJm5ic3A7
ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7IDB4MDE2MDxicj4rI2Rl
ZmluZSBESV9QT0wgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5i
c3A7ICZuYnNwOyAweDAxNjQ8YnI+KyNkZWZpbmUgRElfQVcwICZuYnNwOyAmbmJzcDsgJm5ic3A7
ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgMHgwMTY4PGJyPisjZGVmaW5lIERJ
X0FXMSAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5i
c3A7IDB4MDE2Yzxicj4rI2RlZmluZSBESV9TQ1JfQ09ORiAmbmJzcDsgJm5ic3A7ICZuYnNwOyAm
bmJzcDsgJm5ic3A7ICZuYnNwOzB4MDE3MDxicj4rI2RlZmluZSBESV9TVEFUICZuYnNwOyAmbmJz
cDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNw
OyAmbmJzcDsgJm5ic3A7MHgwMTc0PGJyPis8YnI+KyNkZWZpbmUgRElfU1dfR0VOMF9SVU5fQ09V
TlQoeCkgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZu
YnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsoKHgpICZsdDsmbHQ7IDE5KTxicj4rI2Rl
ZmluZSBESV9TV19HRU4wX1JVTl9TUkMoeCkgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZu
YnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsoKHgpICZsdDsmbHQ7IDE2KTxicj4rI2Rl
ZmluZSBESV9TV19HRU4wX09GRlNFVF9DT1VOVCh4KSAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJz
cDsgJm5ic3A7ICZuYnNwOyAoKHgpICZsdDsmbHQ7IDMpPGJyPisjZGVmaW5lIERJX1NXX0dFTjBf
T0ZGU0VUX1NSQyh4KSAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAm
bmJzcDsgKCh4KSAmbHQ7Jmx0OyAwKTxicj4rPGJyPisjZGVmaW5lIERJX1NXX0dFTjFfQ05UX1BP
TF9HRU5fRU4oeCkgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAoKHgpICZsdDsm
bHQ7IDI5KTxicj4rI2RlZmluZSBESV9TV19HRU4xX0NOVF9DTFJfU1JDKHgpICZuYnNwOyAmbmJz
cDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOygoeCkgJmx0OyZsdDsgMjUpPGJy
PisjZGVmaW5lIERJX1NXX0dFTjFfQ05UX1BPTF9UUklHR0VSX1NSQyh4KSAmbmJzcDsgJm5ic3A7
ICZuYnNwOygoeCkgJmx0OyZsdDsgMTIpPGJyPisjZGVmaW5lIERJX1NXX0dFTjFfQ05UX1BPTF9D
TFJfU1JDKHgpICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsoKHgpICZsdDsmbHQ7
IDkpPGJyPisjZGVmaW5lIERJX1NXX0dFTjFfQ05UX0RPV04oeCkgJm5ic3A7ICZuYnNwOyAmbmJz
cDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAoKHgpICZsdDsmbHQ7IDE2KTxi
cj4rI2RlZmluZSBESV9TV19HRU4xX0NOVF9VUCh4KSAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJz
cDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAoeCk8YnI+KyNkZWZpbmUgRElf
U1dfR0VOMV9BVVRPX1JFTE9BRCAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZu
YnNwOyAmbmJzcDsgJm5ic3A7ICgweDEwMDAwMDAwKTxicj4rPGJyPisjZGVmaW5lIERJX0RXX0dF
Tl9BQ0NFU1NfU0laRV9PRkZTRVQgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAy
NDxicj4rI2RlZmluZSBESV9EV19HRU5fQ09NUE9ORU5UX1NJWkVfT0ZGU0VUICZuYnNwOyAmbmJz
cDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsxNjxicj4rPGJyPisj
ZGVmaW5lIERJX0dFTl9ESV9DTEtfRVhUICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJz
cDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsoMSAmbHQ7Jmx0OyAy
MCk8YnI+KyNkZWZpbmUgRElfR0VOX1BPTEFSSVRZXzEgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5i
c3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOygxICZs
dDsmbHQ7IDApPGJyPisjZGVmaW5lIERJX0dFTl9QT0xBUklUWV8yICZuYnNwOyAmbmJzcDsgJm5i
c3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJz
cDsoMSAmbHQ7Jmx0OyAxKTxicj4rI2RlZmluZSBESV9HRU5fUE9MQVJJVFlfMyAmbmJzcDsgJm5i
c3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJz
cDsgJm5ic3A7KDEgJmx0OyZsdDsgMik8YnI+KyNkZWZpbmUgRElfR0VOX1BPTEFSSVRZXzQgJm5i
c3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJz
cDsgJm5ic3A7ICZuYnNwOygxICZsdDsmbHQ7IDMpPGJyPisjZGVmaW5lIERJX0dFTl9QT0xBUklU
WV81ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJz
cDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsoMSAmbHQ7Jmx0OyA0KTxicj4rI2RlZmluZSBESV9HRU5f
UE9MQVJJVFlfNiAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJz
cDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7KDEgJmx0OyZsdDsgNSk8YnI+KyNkZWZpbmUg
RElfR0VOX1BPTEFSSVRZXzcgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJz
cDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOygxICZsdDsmbHQ7IDYpPGJyPisj
ZGVmaW5lIERJX0dFTl9QT0xBUklUWV84ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJz
cDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsoMSAmbHQ7Jmx0OyA3
KTxicj4rPGJyPisjZGVmaW5lIERJX1BPTF9EUkRZX0RBVEFfUE9MQVJJVFkgJm5ic3A7ICZuYnNw
OyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7KDEgJmx0OyZsdDsgNyk8YnI+KyNk
ZWZpbmUgRElfUE9MX0RSRFlfUE9MQVJJVFlfMTUgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7
ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDso
MSAmbHQ7Jmx0OyA0KTxicj4rPGJyPisjZGVmaW5lIERJX1ZTWU5DX1NFTF9PRkZTRVQgJm5ic3A7
ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsg
Jm5ic3A7MTM8YnI+Kzxicj4rI2RlZmluZSBESTBfQ09VTlRFUl9SRUxFQVNFICZuYnNwOyAmbmJz
cDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNw
OygxICZsdDsmbHQ7IDI0KTxicj4rI2RlZmluZSBESTFfQ09VTlRFUl9SRUxFQVNFICZuYnNwOyAm
bmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZu
YnNwOygxICZsdDsmbHQ7IDI1KTxicj4rPGJyPitzdGF0aWMgaW5saW5lIHUzMiBpcHVfZGlfcmVh
ZChzdHJ1Y3QgaXB1X2RpICpkaSwgdW5zaWduZWQgb2Zmc2V0KTxicj4rezxicj4rICZuYnNwOyAm
bmJzcDsgJm5ic3A7IHJldHVybiBfX3Jhd19yZWFkbChkaS0mZ3Q7YmFzZSArIG9mZnNldCk7PGJy
Pit9PGJyPis8YnI+K3N0YXRpYyBpbmxpbmUgdm9pZCBpcHVfZGlfd3JpdGUoc3RydWN0IGlwdV9k
aSAqZGksIHUzMiB2YWx1ZSwgdW5zaWduZWQgb2Zmc2V0KTxicj4rezxicj4rICZuYnNwOyAmbmJz
cDsgJm5ic3A7IF9fcmF3X3dyaXRlbCh2YWx1ZSwgZGktJmd0O2Jhc2UgKyBvZmZzZXQpOzxicj4r
fTxicj4rPGJyPitzdGF0aWMgdm9pZCBpcHVfZGlfZGF0YV93YXZlX2NvbmZpZyhzdHJ1Y3QgaXB1
X2RpICpkaSw8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAm
bmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZu
YnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwO2ludCB3YXZlX2dlbiw8YnI+KyAmbmJzcDsgJm5ic3A7
ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsg
Jm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwO2lu
dCBhY2Nlc3Nfc2l6ZSwgaW50IGNvbXBvbmVudF9zaXplKTxicj4rezxicj4rICZuYnNwOyAmbmJz
cDsgJm5ic3A7IHUzMiByZWc7PGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgcmVnID0gKGFjY2Vz
c19zaXplICZsdDsmbHQ7IERJX0RXX0dFTl9BQ0NFU1NfU0laRV9PRkZTRVQpIHw8YnI+KyAmbmJz
cDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7IChjb21wb25lbnRfc2l6ZSAmbHQ7Jmx0OyBE
SV9EV19HRU5fQ09NUE9ORU5UX1NJWkVfT0ZGU0VUKTs8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNw
OyBpcHVfZGlfd3JpdGUoZGksIHJlZywgRElfRFdfR0VOKHdhdmVfZ2VuKSk7PGJyPit9PGJyPis8
YnI+K3N0YXRpYyB2b2lkIGlwdV9kaV9kYXRhX3Bpbl9jb25maWcoc3RydWN0IGlwdV9kaSAqZGks
IGludCB3YXZlX2dlbiwgaW50IGRpX3BpbiwgaW50IHNldCw8YnI+KyAmbmJzcDsgJm5ic3A7ICZu
YnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5i
c3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7IGludCB1cCwgaW50
IGRvd24pPGJyPit7PGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgdTMyIHJlZzs8YnI+Kzxicj4r
ICZuYnNwOyAmbmJzcDsgJm5ic3A7IHJlZyA9IGlwdV9kaV9yZWFkKGRpLCBESV9EV19HRU4od2F2
ZV9nZW4pKTs8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyByZWcgJmFtcDs9IH4oMHgzICZsdDsm
bHQ7IChkaV9waW4gKiAyKSk7PGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgcmVnIHw9IHNldCAm
bHQ7Jmx0OyAoZGlfcGluICogMik7PGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgaXB1X2RpX3dy
aXRlKGRpLCByZWcsIERJX0RXX0dFTih3YXZlX2dlbikpOzxicj4rPGJyPisgJm5ic3A7ICZuYnNw
OyAmbmJzcDsgaXB1X2RpX3dyaXRlKGRpLCAoZG93biAmbHQ7Jmx0OyAxNikgfCB1cCwgRElfRFdf
U0VUKHdhdmVfZ2VuLCBzZXQpKTs8YnI+K308YnI+Kzxicj4rc3RhdGljIHZvaWQgaXB1X2RpX3N5
bmNfY29uZmlnKHN0cnVjdCBpcHVfZGkgKmRpLCBzdHJ1Y3QgZGlfc3luY19jb25maWcgKmNvbmZp
ZywgaW50IGNvdW50KTxicj4rezxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7IHUzMiByZWc7PGJy
PisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgaW50IGk7PGJyPis8YnI+KyAmbmJzcDsgJm5ic3A7ICZu
YnNwOyBmb3IgKGkgPSAwOyBpICZsdDsgY291bnQ7IGkrKykgezxicj4rICZuYnNwOyAmbmJzcDsg
Jm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBzdHJ1Y3QgZGlfc3luY19jb25maWcg
KmMgPSAmYW1wO2NvbmZpZ1tpXTs8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5i
c3A7ICZuYnNwOyAmbmJzcDsgaW50IHdhdmVfZ2VuID0gaSArIDE7PGJyPis8YnI+KyAmbmJzcDsg
Jm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgcHJfZGVidWcoJnF1b3Q7
JXMgJWRcbiZxdW90OywgX19mdW5jX18sIHdhdmVfZ2VuKTs8YnI+KyAmbmJzcDsgJm5ic3A7ICZu
YnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgaWYgKChjLSZndDtydW5fY291bnQgJmd0
Oz0gMHgxMDAwKSB8fCAoYy0mZ3Q7b2Zmc2V0X2NvdW50ICZndDs9IDB4MTAwMCkgfHwgKGMtJmd0
O3JlcGVhdF9jb3VudCAmZ3Q7PSAweDEwMDApIHx8PGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsg
Jm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAo
Yy0mZ3Q7Y250X3VwICZndDs9IDB4NDAwKSB8fCAoYy0mZ3Q7Y250X2Rvd24gJmd0Oz0gMHg0MDAp
KSB7PGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7
ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBkZXZfZXJyKGlwdV9kZXYsICZxdW90O0RJJWQg
Y291bnRlcnMgb3V0IG9mIHJhbmdlLlxuJnF1b3Q7LCBkaS0mZ3Q7aWQpOzxicj4rICZuYnNwOyAm
bmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZu
YnNwOyAmbmJzcDsgcmV0dXJuOzxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJz
cDsgJm5ic3A7ICZuYnNwOyB9PGJyPis8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsg
Jm5ic3A7ICZuYnNwOyAmbmJzcDsgcmVnID0gRElfU1dfR0VOMF9SVU5fQ09VTlQoYy0mZ3Q7cnVu
X2NvdW50KSB8PGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsg
Jm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBESV9TV19HRU4wX1JVTl9TUkMoYy0m
Z3Q7cnVuX3NyYykgfDxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5i
c3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgRElfU1dfR0VOMF9PRkZTRVRf
Q09VTlQoYy0mZ3Q7b2Zmc2V0X2NvdW50KSB8PGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5i
c3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBESV9T
V19HRU4wX09GRlNFVF9TUkMoYy0mZ3Q7b2Zmc2V0X3NyYyk7PGJyPisgJm5ic3A7ICZuYnNwOyAm
bmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7IGlwdV9kaV93cml0ZShkaSwgcmVnLCBE
SV9TV19HRU4wKHdhdmVfZ2VuKSk7PGJyPis8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJz
cDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgcmVnID0gRElfU1dfR0VOMV9DTlRfUE9MX0dFTl9FTihj
LSZndDtjbnRfcG9sYXJpdHlfZ2VuX2VuKSB8PGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5i
c3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBESV9T
V19HRU4xX0NOVF9DTFJfU1JDKGMtJmd0O2NudF9jbHJfc3JjKSB8PGJyPisgJm5ic3A7ICZuYnNw
OyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7
ICZuYnNwOyBESV9TV19HRU4xX0NOVF9QT0xfVFJJR0dFUl9TUkMoYy0mZ3Q7Y250X3BvbGFyaXR5
X3RyaWdnZXJfc3JjKSB8PGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAm
bmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBESV9TV19HRU4xX0NOVF9Q
T0xfQ0xSX1NSQyhjLSZndDtjbnRfcG9sYXJpdHlfY2xyX3NyYykgfDxicj4rICZuYnNwOyAmbmJz
cDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNw
OyAmbmJzcDsgRElfU1dfR0VOMV9DTlRfRE9XTihjLSZndDtjbnRfZG93bikgfDxicj4rICZuYnNw
OyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7
ICZuYnNwOyAmbmJzcDsgRElfU1dfR0VOMV9DTlRfVVAoYy0mZ3Q7Y250X3VwKTs8YnI+Kzxicj4r
ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBpZiAoYy0m
Z3Q7cmVwZWF0X2NvdW50ID09IDApIHs8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsg
Jm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7IC8qIEVuYWJs
ZSBhdXRvIHJlbG9hZCAqLzxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsg
Jm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgcmVnIHw9IERJX1NXX0dF
TjFfQVVUT19SRUxPQUQ7PGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAm
bmJzcDsgJm5ic3A7IH08YnI+Kzxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJz
cDsgJm5ic3A7ICZuYnNwOyBpcHVfZGlfd3JpdGUoZGksIHJlZywgRElfU1dfR0VOMSh3YXZlX2dl
bikpOzxicj4rPGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsg
Jm5ic3A7IHJlZyA9IGlwdV9kaV9yZWFkKGRpLCBESV9TVFBfUkVQKHdhdmVfZ2VuKSk7PGJyPisg
Jm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7IHJlZyAmYW1w
Oz0gfigweGZmZmYgJmx0OyZsdDsgKDE2ICogKCh3YXZlX2dlbiAtIDEpICZhbXA7IDB4MSkpKTs8
YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgcmVn
IHw9IGMtJmd0O3JlcGVhdF9jb3VudCAmbHQ7Jmx0OyAoMTYgKiAoKHdhdmVfZ2VuIC0gMSkgJmFt
cDsgMHgxKSk7PGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsg
Jm5ic3A7IGlwdV9kaV93cml0ZShkaSwgcmVnLCBESV9TVFBfUkVQKHdhdmVfZ2VuKSk7PGJyPisg
Jm5ic3A7ICZuYnNwOyAmbmJzcDsgfTxicj4rfTxicj4rPGJyPitzdGF0aWMgdm9pZCBpcHVfZGlf
c3luY19jb25maWdfaW50ZXJsYWNlZChzdHJ1Y3QgaXB1X2RpICpkaSwgc3RydWN0IGlwdV9kaV9z
aWduYWxfY2ZnICpzaWcpPGJyPit7PGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgdTMyIGhfdG90
YWwgPSBzaWctJmd0O3dpZHRoICsgc2lnLSZndDtoX3N5bmNfd2lkdGggKyBzaWctJmd0O2hfc3Rh
cnRfd2lkdGggKyBzaWctJmd0O2hfZW5kX3dpZHRoOzxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7
IHUzMiB2X3RvdGFsID0gc2lnLSZndDtoZWlnaHQgKyBzaWctJmd0O3Zfc3luY193aWR0aCArIHNp
Zy0mZ3Q7dl9zdGFydF93aWR0aCArIHNpZy0mZ3Q7dl9lbmRfd2lkdGg7PGJyPisgJm5ic3A7ICZu
YnNwOyAmbmJzcDsgdTMyIHJlZzs8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBzdHJ1Y3QgZGlf
c3luY19jb25maWcgY2ZnW10gPSB7PGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZu
YnNwOyAmbmJzcDsgJm5ic3A7IHs8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5i
c3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7IC5ydW5fY291bnQg
PSBoX3RvdGFsIC8gMiAtIDEsPGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNw
OyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAucnVuX3NyYyA9IERJ
X1NZTkNfQ0xLLDxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7
ICZuYnNwOyB9LCB7PGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJz
cDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAucnVuX2NvdW50ID0gaF90b3Rh
bCAtIDExLDxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZu
YnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgLnJ1bl9zcmMgPSBESV9TWU5DX0NMSyw8
YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5i
c3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7IC5jbnRfZG93biA9IDQsPGJyPisgJm5ic3A7ICZuYnNw
OyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7IH0sIHs8YnI+KyAmbmJzcDsgJm5i
c3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJz
cDsgJm5ic3A7IC5ydW5fY291bnQgPSB2X3RvdGFsICogMiAtIDEsPGJyPisgJm5ic3A7ICZuYnNw
OyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7
ICZuYnNwOyAucnVuX3NyYyA9IERJX1NZTkNfSU5UX0hTWU5DLDxicj4rICZuYnNwOyAmbmJzcDsg
Jm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAm
bmJzcDsgLm9mZnNldF9jb3VudCA9IDEsPGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7
ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAub2Zmc2V0
X3NyYyA9IERJX1NZTkNfSU5UX0hTWU5DLDxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNw
OyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgLmNudF9k
b3duID0gNCw8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAm
bmJzcDsgfSwgezxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7
ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgLnJ1bl9jb3VudCA9IHZfdG90YWwg
LyAyIC0gMSw8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAm
bmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7IC5ydW5fc3JjID0gRElfU1lOQ19IU1lO
Qyw8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsg
Jm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7IC5vZmZzZXRfY291bnQgPSBzaWctJmd0O3Zfc3Rh
cnRfd2lkdGgsPGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsg
Jm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAub2Zmc2V0X3NyYyA9IERJX1NZTkNf
SFNZTkMsPGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5i
c3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAucmVwZWF0X2NvdW50ID0gMiw8YnI+KyAm
bmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZu
YnNwOyAmbmJzcDsgJm5ic3A7IC5jbnRfY2xyX3NyYyA9IERJX1NZTkNfVlNZTkMsPGJyPisgJm5i
c3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7IH0sIHs8YnI+KyAm
bmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZu
YnNwOyAmbmJzcDsgJm5ic3A7IC5ydW5fc3JjID0gRElfU1lOQ19IU1lOQyw8YnI+KyAmbmJzcDsg
Jm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAm
bmJzcDsgJm5ic3A7IC5yZXBlYXRfY291bnQgPSBzaWctJmd0O2hlaWdodCAvIDIsPGJyPisgJm5i
c3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJz
cDsgJm5ic3A7ICZuYnNwOyAuY250X2Nscl9zcmMgPSA0LDxicj4rICZuYnNwOyAmbmJzcDsgJm5i
c3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyB9LCB7PGJyPisgJm5ic3A7ICZuYnNwOyAm
bmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZu
YnNwOyAucnVuX2NvdW50ID0gdl90b3RhbCAtIDEsPGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsg
Jm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAu
cnVuX3NyYyA9IERJX1NZTkNfSFNZTkMsPGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7
ICZuYnNwOyAmbmJzcDsgJm5ic3A7IH0sIHs8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJz
cDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7IC5ydW5f
Y291bnQgPSB2X3RvdGFsIC8gMiAtIDEsPGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7
ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAucnVuX3Ny
YyA9IERJX1NZTkNfSFNZTkMsPGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNw
OyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAub2Zmc2V0X2NvdW50
ID0gOSw8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJz
cDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7IC5vZmZzZXRfc3JjID0gRElfU1lOQ19IU1lO
Qyw8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsg
Jm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7IC5yZXBlYXRfY291bnQgPSAyLDxicj4rICZuYnNw
OyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7
ICZuYnNwOyAmbmJzcDsgLmNudF9jbHJfc3JjID0gRElfU1lOQ19WU1lOQyw8YnI+KyAmbmJzcDsg
Jm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgfSwgezxicj4rICZuYnNw
OyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7
ICZuYnNwOyAmbmJzcDsgLnJ1bl9zcmMgPSBESV9TWU5DX0NMSyw8YnI+KyAmbmJzcDsgJm5ic3A7
ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsg
Jm5ic3A7IC5vZmZzZXRfY291bnQgPSBzaWctJmd0O2hfc3RhcnRfd2lkdGgsPGJyPisgJm5ic3A7
ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsg
Jm5ic3A7ICZuYnNwOyAub2Zmc2V0X3NyYyA9IERJX1NZTkNfQ0xLLDxicj4rICZuYnNwOyAmbmJz
cDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNw
OyAmbmJzcDsgLnJlcGVhdF9jb3VudCA9IHNpZy0mZ3Q7d2lkdGgsPGJyPisgJm5ic3A7ICZuYnNw
OyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7
ICZuYnNwOyAuY250X2Nscl9zcmMgPSA1LDxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNw
OyAmbmJzcDsgJm5ic3A7ICZuYnNwOyB9LCB7PGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5i
c3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAucnVu
X2NvdW50ID0gdl90b3RhbCAtIDEsPGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZu
YnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAucnVuX3NyYyA9
IERJX1NZTkNfSU5UX0hTWU5DLDxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJz
cDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgLm9mZnNldF9jb3Vu
dCA9IHZfdG90YWwgLyAyLDxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsg
Jm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgLm9mZnNldF9zcmMgPSBE
SV9TWU5DX0lOVF9IU1lOQyw8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7
ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7IC5jbnRfY2xyX3NyYyA9
IERJX1NZTkNfSFNZTkMsPGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAm
bmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAuY250X2Rvd24gPSA0LDxi
cj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyB9PGJy
PisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgfTs8YnI+Kzxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7
IGlwdV9kaV9zeW5jX2NvbmZpZyhkaSwgY2ZnLCBBUlJBWV9TSVpFKGNmZykpOzxicj4rPGJyPisg
Jm5ic3A7ICZuYnNwOyAmbmJzcDsgLyogc2V0IGdlbnRpbWUgc2VsZWN0IGFuZCB0YWcgc2VsICov
PGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgcmVnID0gaXB1X2RpX3JlYWQoZGksIERJX1NXX0dF
TjEoOSkpOzxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7IHJlZyAmYW1wOz0gMHgxRkZGRkZGRjs8
YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyByZWcgfD0gKDMgLSAxKSAmbHQ7Jmx0OyAyOSB8IDB4
MDAwMDgwMDA7PGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgaXB1X2RpX3dyaXRlKGRpLCByZWcs
IERJX1NXX0dFTjEoOSkpOzxicj4rPGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgaXB1X2RpX3dy
aXRlKGRpLCB2X3RvdGFsIC8gMiAtIDEsIERJX1NDUl9DT05GKTs8YnI+K308YnI+Kzxicj4rc3Rh
dGljIHZvaWQgaXB1X2RpX3N5bmNfY29uZmlnX25vbmludGVybGFjZWQoc3RydWN0IGlwdV9kaSAq
ZGksPGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7
IHN0cnVjdCBpcHVfZGlfc2lnbmFsX2NmZyAqc2lnLCBpbnQgZGl2KTxicj4rezxicj4rICZuYnNw
OyAmbmJzcDsgJm5ic3A7IHUzMiBoX3RvdGFsID0gc2lnLSZndDt3aWR0aCArIHNpZy0mZ3Q7aF9z
eW5jX3dpZHRoICsgc2lnLSZndDtoX3N0YXJ0X3dpZHRoICs8YnI+KyAmbmJzcDsgJm5ic3A7ICZu
YnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgc2lnLSZndDtoX2VuZF93aWR0aDs8YnI+
KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyB1MzIgdl90b3RhbCA9IHNpZy0mZ3Q7aGVpZ2h0ICsgc2ln
LSZndDt2X3N5bmNfd2lkdGggKyBzaWctJmd0O3Zfc3RhcnRfd2lkdGggKzxicj4rICZuYnNwOyAm
bmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBzaWctJmd0O3ZfZW5kX3dp
ZHRoICsgKHNpZy0mZ3Q7dl9lbmRfd2lkdGggJmx0OyAyID8gMSA6IDApOzxicj4rICZuYnNwOyAm
bmJzcDsgJm5ic3A7IHN0cnVjdCBkaV9zeW5jX2NvbmZpZyBjZmdbXSA9IHs8YnI+KyAmbmJzcDsg
Jm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgezxicj4rICZuYnNwOyAm
bmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZu
YnNwOyAmbmJzcDsgLnJ1bl9jb3VudCA9IGhfdG90YWwgLSAxLDxicj4rICZuYnNwOyAmbmJzcDsg
Jm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAm
bmJzcDsgLnJ1bl9zcmMgPSBESV9TWU5DX0NMSyw8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAm
bmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgfSAsIHs8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNw
OyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7
IC5ydW5fY291bnQgPSBoX3RvdGFsIC0gMSw8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJz
cDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7IC5ydW5f
c3JjID0gRElfU1lOQ19DTEssPGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNw
OyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAub2Zmc2V0X2NvdW50
ID0gZGl2ICogc2lnLSZndDt2X3RvX2hfc3luYyw8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAm
bmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7IC5v
ZmZzZXRfc3JjID0gRElfU1lOQ19DTEssPGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7
ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAuY250X3Bv
bGFyaXR5X2dlbl9lbiA9IDEsPGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNw
OyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAuY250X3BvbGFyaXR5
X3RyaWdnZXJfc3JjID0gRElfU1lOQ19DTEssPGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5i
c3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAuY250
X2Rvd24gPSBzaWctJmd0O2hfc3luY193aWR0aCAqIDIsPGJyPisgJm5ic3A7ICZuYnNwOyAmbmJz
cDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7IH0gLCB7PGJyPisgJm5ic3A7ICZuYnNwOyAm
bmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZu
YnNwOyAucnVuX2NvdW50ID0gdl90b3RhbCAtIDEsPGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsg
Jm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAu
cnVuX3NyYyA9IERJX1NZTkNfSU5UX0hTWU5DLDxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZu
YnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgLmNu
dF9wb2xhcml0eV9nZW5fZW4gPSAxLDxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAm
bmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgLmNudF9wb2xh
cml0eV90cmlnZ2VyX3NyYyA9IERJX1NZTkNfSU5UX0hTWU5DLDxicj4rICZuYnNwOyAmbmJzcDsg
Jm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAm
bmJzcDsgLmNudF9kb3duID0gc2lnLSZndDt2X3N5bmNfd2lkdGggKiAyLDxicj4rICZuYnNwOyAm
bmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyB9ICwgezxicj4rICZuYnNw
OyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7
ICZuYnNwOyAmbmJzcDsgLnJ1bl9zcmMgPSBESV9TWU5DX0hTWU5DLDxicj4rICZuYnNwOyAmbmJz
cDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNw
OyAmbmJzcDsgLm9mZnNldF9jb3VudCA9IHNpZy0mZ3Q7dl9zeW5jX3dpZHRoICsgc2lnLSZndDt2
X3N0YXJ0X3dpZHRoLDxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5i
c3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgLm9mZnNldF9zcmMgPSBESV9T
WU5DX0hTWU5DLDxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7
ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgLnJlcGVhdF9jb3VudCA9IHNpZy0m
Z3Q7aGVpZ2h0LDxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7
ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgLmNudF9jbHJfc3JjID0gRElfU1lO
Q19WU1lOQyw8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAm
bmJzcDsgfSAsIHs8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNw
OyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7IC5ydW5fc3JjID0gRElfU1lOQ19D
TEssPGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7
ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAub2Zmc2V0X2NvdW50ID0gc2lnLSZndDtoX3N5
bmNfd2lkdGggKyBzaWctJmd0O2hfc3RhcnRfd2lkdGgsPGJyPisgJm5ic3A7ICZuYnNwOyAmbmJz
cDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNw
OyAub2Zmc2V0X3NyYyA9IERJX1NZTkNfQ0xLLDxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZu
YnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgLnJl
cGVhdF9jb3VudCA9IHNpZy0mZ3Q7d2lkdGgsPGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5i
c3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAuY250
X2Nscl9zcmMgPSA1LDxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5i
c3A7ICZuYnNwOyB9ICwgezxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsg
Jm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgLyogdW51c2VkICovPGJy
PisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7IH0gLCB7
PGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZu
YnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAvKiB1bnVzZWQgKi88YnI+KyAmbmJzcDsgJm5ic3A7
ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgfSAsIHs8YnI+KyAmbmJzcDsgJm5i
c3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJz
cDsgJm5ic3A7IC8qIHVudXNlZCAqLzxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAm
bmJzcDsgJm5ic3A7ICZuYnNwOyB9ICwgezxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNw
OyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgLyogdW51
c2VkICovPGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5i
c3A7IH0sPGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgfTs8YnI+Kzxicj4rICZuYnNwOyAmbmJz
cDsgJm5ic3A7IGlwdV9kaV93cml0ZShkaSwgdl90b3RhbCAtIDEsIERJX1NDUl9DT05GKTs8YnI+
KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBpcHVfZGlfc3luY19jb25maWcoZGksIGNmZywgQVJSQVlf
U0laRShjZmcpKTs8YnI+K308YnI+Kzxicj4raW50IGlwdV9kaV9pbml0X3N5bmNfcGFuZWwoaW50
IGRpc3AsIHUzMiBwaXhlbF9jbGssIHN0cnVjdCBpcHVfZGlfc2lnbmFsX2NmZyAqc2lnKTxicj4r
ezxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7IHN0cnVjdCBpcHVfZGkgKmRpID0gJmFtcDtkaXNb
ZGlzcF07PGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgdTMyIHJlZzs8YnI+KyAmbmJzcDsgJm5i
c3A7ICZuYnNwOyB1MzIgZGlzcF9nZW4sIGRpX2dlbiwgdnN5bmNfY250Ozxicj4rICZuYnNwOyAm
bmJzcDsgJm5ic3A7IHUzMiBkaXY7PGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgdTMyIGhfdG90
YWwsIHZfdG90YWw7PGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgc3RydWN0IGNsayAqZGlfY2xr
Ozxicj4rPGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgZGV2X2RiZyhpcHVfZGV2LCAmcXVvdDtk
aXNwICVkOiBwYW5lbCBzaXplID0gJWQgeCAlZFxuJnF1b3Q7LDxicj4rICZuYnNwOyAmbmJzcDsg
Jm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBkaXNwLCBzaWctJmd0O3dpZHRoLCBz
aWctJmd0O2hlaWdodCk7PGJyPis8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBpZiAoZGlzcCAm
Z3Q7IDEpPGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5i
c3A7IHJldHVybiAtRUlOVkFMOzxicj4rPGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgaWYgKChz
aWctJmd0O3Zfc3luY193aWR0aCA9PSAwKSB8fCAoc2lnLSZndDtoX3N5bmNfd2lkdGggPT0gMCkp
PGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7IHJl
dHVybiAtRUlOVkFMOzxicj4rPGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgaF90b3RhbCA9IHNp
Zy0mZ3Q7d2lkdGggKyBzaWctJmd0O2hfc3luY193aWR0aCArIHNpZy0mZ3Q7aF9zdGFydF93aWR0
aCArIHNpZy0mZ3Q7aF9lbmRfd2lkdGg7PGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgdl90b3Rh
bCA9IHNpZy0mZ3Q7aGVpZ2h0ICsgc2lnLSZndDt2X3N5bmNfd2lkdGggKyBzaWctJmd0O3Zfc3Rh
cnRfd2lkdGggKyBzaWctJmd0O3ZfZW5kX3dpZHRoOzxicj4rPGJyPisgJm5ic3A7ICZuYnNwOyAm
bmJzcDsgbXV0ZXhfbG9jaygmYW1wO2RpX211dGV4KTs8YnI+Kzxicj4rICZuYnNwOyAmbmJzcDsg
Jm5ic3A7IC8qIEluaXQgY2xvY2tpbmcgKi88YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBpZiAo
c2lnLSZndDtleHRfY2xrKSB7PGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNw
OyAmbmJzcDsgJm5ic3A7IGRpLSZndDtleHRlcm5hbF9jbGsgPSB0cnVlOzxicj4rICZuYnNwOyAm
bmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBkaV9jbGsgPSBkaS0mZ3Q7
Y2xrOzxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7IH0gZWxzZSB7PGJyPisgJm5ic3A7ICZuYnNw
OyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7IGRpLSZndDtleHRlcm5hbF9jbGsg
PSBmYWxzZTs8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAm
bmJzcDsgZGlfY2xrID0gZGktJmd0O2lwdV9jbGs7PGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsg
fTxicj4rPGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgLyo8YnI+KyAmbmJzcDsgJm5ic3A7ICZu
YnNwOyAmbmJzcDsqIENhbGN1bGF0ZSBkaXZpZGVyPGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsg
Jm5ic3A7KiBGcmFjdGlvbmFsIHBhcnQgaXMgNCBiaXRzLDxicj4rICZuYnNwOyAmbmJzcDsgJm5i
c3A7ICZuYnNwOyogc28gc2ltcGx5IG11bHRpcGx5IGJ5IDJeNCB0byBnZXQgZnJhY3Rpb25hbCBw
YXJ0Ljxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyovPGJyPisgJm5ic3A7ICZuYnNw
OyAmbmJzcDsgZGl2ID0gKGNsa19nZXRfcmF0ZShkaV9jbGspICogMTYpIC8gcGl4ZWxfY2xrOzxi
cj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7IGlmIChkaXYgJmx0OyAweDEwKSAvKiBNaW4gREkgZGlz
cCBjbG9jayBkaXZpZGVyIGlzIDEgKi88YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsg
Jm5ic3A7ICZuYnNwOyAmbmJzcDsgZGl2ID0gMHgxMDs8YnI+Kzxicj4rICZuYnNwOyAmbmJzcDsg
Jm5ic3A7IGRpc3BfZ2VuID0gaXB1X2NtX3JlYWQoSVBVX0RJU1BfR0VOKTs8YnI+KyAmbmJzcDsg
Jm5ic3A7ICZuYnNwOyBkaXNwX2dlbiAmYW1wOz0gZGlzcCA/IH5ESTFfQ09VTlRFUl9SRUxFQVNF
IDogfkRJMF9DT1VOVEVSX1JFTEVBU0U7PGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgaXB1X2Nt
X3dyaXRlKGRpc3BfZ2VuLCBJUFVfRElTUF9HRU4pOzxicj4rPGJyPisgJm5ic3A7ICZuYnNwOyAm
bmJzcDsgaXB1X2RpX3dyaXRlKGRpLCBkaXYsIERJX0JTX0NMS0dFTjApOzxicj4rPGJyPisgJm5i
c3A7ICZuYnNwOyAmbmJzcDsgLyogU2V0dXAgcGl4ZWwgY2xvY2sgdGltaW5nICovPGJyPisgJm5i
c3A7ICZuYnNwOyAmbmJzcDsgLyogRG93biB0aW1lIGlzIGhhbGYgb2YgcGVyaW9kICovPGJyPisg
Jm5ic3A7ICZuYnNwOyAmbmJzcDsgaXB1X2RpX3dyaXRlKGRpLCAoZGl2IC8gMTYpICZsdDsmbHQ7
IDE2LCBESV9CU19DTEtHRU4xKTs8YnI+Kzxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7IGlwdV9k
aV9kYXRhX3dhdmVfY29uZmlnKGRpLCBTWU5DX1dBVkUsIGRpdiAvIDE2IC0gMSwgZGl2IC8gMTYg
LSAxKTs8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBpcHVfZGlfZGF0YV9waW5fY29uZmlnKGRp
LCBTWU5DX1dBVkUsIERJX1BJTjE1LCAzLCAwLCBkaXYgLyAxNiAqIDIpOzxicj4rPGJyPisgJm5i
c3A7ICZuYnNwOyAmbmJzcDsgZGl2ID0gZGl2IC8gMTY7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZu
YnNwOyAvKiBOb3cgZGl2aWRlciBpcyBpbnRlZ2VyIHBvcnRpb24gKi88YnI+Kzxicj4rICZuYnNw
OyAmbmJzcDsgJm5ic3A7IGRpX2dlbiA9IDA7PGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgaWYg
KHNpZy0mZ3Q7ZXh0X2Nsayk8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7
ICZuYnNwOyAmbmJzcDsgZGlfZ2VuIHw9IERJX0dFTl9ESV9DTEtfRVhUOzxicj4rPGJyPisgJm5i
c3A7ICZuYnNwOyAmbmJzcDsgaWYgKHNpZy0mZ3Q7aW50ZXJsYWNlZCkgezxicj4rICZuYnNwOyAm
bmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBpcHVfZGlfc3luY19jb25m
aWdfaW50ZXJsYWNlZChkaSwgc2lnKTs8YnI+Kzxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZu
YnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAvKiBzZXQgeV9zZWwgPSAxICovPGJyPisgJm5ic3A7
ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7IGRpX2dlbiB8PSAweDEw
MDAwMDAwOzxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZu
YnNwOyBkaV9nZW4gfD0gRElfR0VOX1BPTEFSSVRZXzU7PGJyPisgJm5ic3A7ICZuYnNwOyAmbmJz
cDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7IGRpX2dlbiB8PSBESV9HRU5fUE9MQVJJVFlf
ODs8YnI+Kzxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZu
YnNwOyB2c3luY19jbnQgPSA3Ozxicj4rPGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7
ICZuYnNwOyAmbmJzcDsgJm5ic3A7IGlmIChzaWctJmd0O0hzeW5jX3BvbCk8YnI+KyAmbmJzcDsg
Jm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAm
bmJzcDsgJm5ic3A7IGRpX2dlbiB8PSBESV9HRU5fUE9MQVJJVFlfMzs8YnI+KyAmbmJzcDsgJm5i
c3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgaWYgKHNpZy0mZ3Q7VnN5bmNf
cG9sKTxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNw
OyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgZGlfZ2VuIHw9IERJX0dFTl9QT0xBUklUWV8y
Ozxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7IH0gZWxzZSB7PGJyPisgJm5ic3A7ICZuYnNwOyAm
bmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7IGlwdV9kaV9zeW5jX2NvbmZpZ19ub25p
bnRlcmxhY2VkKGRpLCBzaWcsIGRpdik7PGJyPis8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAm
bmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgdnN5bmNfY250ID0gMzs8YnI+Kzxicj4rICZuYnNw
OyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBpZiAoc2lnLSZndDtI
c3luY19wb2wpPGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsg
Jm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBkaV9nZW4gfD0gRElfR0VOX1BPTEFS
SVRZXzI7PGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5i
c3A7IGlmIChzaWctJmd0O1ZzeW5jX3BvbCk8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJz
cDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7IGRpX2dl
biB8PSBESV9HRU5fUE9MQVJJVFlfMzs8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyB9PGJyPis8
YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBpcHVfZGlfd3JpdGUoZGksIGRpX2dlbiwgRElfR0VO
RVJBTCk7PGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgaXB1X2RpX3dyaXRlKGRpLCAoLS12c3lu
Y19jbnQgJmx0OyZsdDsgRElfVlNZTkNfU0VMX09GRlNFVCkgfCAweDAwMDAwMDAyLDxicj4rICZu
YnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5i
c3A7ICZuYnNwO0RJX1NZTkNfQVNfR0VOKTs8YnI+Kzxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7
IHJlZyA9IGlwdV9kaV9yZWFkKGRpLCBESV9QT0wpOzxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7
IHJlZyAmYW1wOz0gfihESV9QT0xfRFJEWV9EQVRBX1BPTEFSSVRZIHwgRElfUE9MX0RSRFlfUE9M
QVJJVFlfMTUpOzxicj4rPGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgaWYgKHNpZy0mZ3Q7ZW5h
YmxlX3BvbCk8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAm
bmJzcDsgcmVnIHw9IERJX1BPTF9EUkRZX1BPTEFSSVRZXzE1Ozxicj4rICZuYnNwOyAmbmJzcDsg
Jm5ic3A7IGlmIChzaWctJmd0O2RhdGFfcG9sKTxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZu
YnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyByZWcgfD0gRElfUE9MX0RSRFlfREFUQV9QT0xBUklU
WTs8YnI+Kzxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7IGlwdV9kaV93cml0ZShkaSwgcmVnLCBE
SV9QT0wpOzxicj4rPGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgbXV0ZXhfdW5sb2NrKCZhbXA7
ZGlfbXV0ZXgpOzxicj4rPGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgcmV0dXJuIDA7PGJyPit9
PGJyPitFWFBPUlRfU1lNQk9MKGlwdV9kaV9pbml0X3N5bmNfcGFuZWwpOzxicj4rPGJyPitpbnQg
aXB1X2RpX2VuYWJsZShpbnQgZGlzcCk8YnI+K3s8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBz
dHJ1Y3QgaXB1X2RpICpkaSA9ICZhbXA7ZGlzW2Rpc3BdOzxicj4rICZuYnNwOyAmbmJzcDsgJm5i
c3A7IHUzMiByZWc7PGJyPis8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyByZWcgPSBpcHVfY21f
cmVhZChJUFVfRElTUF9HRU4pOzxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7IGlmIChkaXNwKTxi
cj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyByZWcg
fD0gREkxX0NPVU5URVJfUkVMRUFTRTs8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBlbHNlPGJy
PisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7IHJlZyB8
PSBESTBfQ09VTlRFUl9SRUxFQVNFOzxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7IGlwdV9jbV93
cml0ZShyZWcsIElQVV9ESVNQX0dFTik7PGJyPis8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBp
ZiAoZGktJmd0O2V4dGVybmFsX2Nsayk8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsg
Jm5ic3A7ICZuYnNwOyAmbmJzcDsgY2xrX2VuYWJsZShkaS0mZ3Q7Y2xrKTs8YnI+Kzxicj4rICZu
YnNwOyAmbmJzcDsgJm5ic3A7IGlwdV9tb2R1bGVfZW5hYmxlKGRpLSZndDttb2R1bGUpOzxicj4r
PGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgcmV0dXJuIDA7PGJyPit9PGJyPitFWFBPUlRfU1lN
Qk9MKGlwdV9kaV9lbmFibGUpOzxicj4rPGJyPitpbnQgaXB1X2RpX2Rpc2FibGUoaW50IGRpc3Ap
PGJyPit7PGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgc3RydWN0IGlwdV9kaSAqZGkgPSAmYW1w
O2Rpc1tkaXNwXTs8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyB1MzIgcmVnOzxicj4rPGJyPisg
Jm5ic3A7ICZuYnNwOyAmbmJzcDsgaXB1X21vZHVsZV9kaXNhYmxlKGRpLSZndDttb2R1bGUpOzxi
cj4rPGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgaWYgKGRpLSZndDtleHRlcm5hbF9jbGspPGJy
PisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7IGNsa19k
aXNhYmxlKGRpLSZndDtjbGspOzxicj4rPGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgcmVnID0g
aXB1X2NtX3JlYWQoSVBVX0RJU1BfR0VOKTs8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBpZiAo
ZGlzcCk8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJz
cDsgcmVnICZhbXA7PSB+REkxX0NPVU5URVJfUkVMRUFTRTs8YnI+KyAmbmJzcDsgJm5ic3A7ICZu
YnNwOyBlbHNlPGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsg
Jm5ic3A7IHJlZyAmYW1wOz0gfkRJMF9DT1VOVEVSX1JFTEVBU0U7PGJyPisgJm5ic3A7ICZuYnNw
OyAmbmJzcDsgaXB1X2NtX3dyaXRlKHJlZywgSVBVX0RJU1BfR0VOKTs8YnI+Kzxicj4rICZuYnNw
OyAmbmJzcDsgJm5ic3A7IHJldHVybiAwOzxicj4rfTxicj4rRVhQT1JUX1NZTUJPTChpcHVfZGlf
ZGlzYWJsZSk7PGJyPis8YnI+K2ludCBpcHVfZGlfaW5pdChzdHJ1Y3QgcGxhdGZvcm1fZGV2aWNl
ICpwZGV2LCBpbnQgaWQsIHVuc2lnbmVkIGxvbmcgYmFzZSw8YnI+KyAmbmJzcDsgJm5ic3A7ICZu
YnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgdTMyIG1vZHVsZSwgc3RydWN0IGNsayAq
aXB1X2Nsayk8YnI+K3s8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBjaGFyICpjbGtpZDs8YnI+
Kzxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7IGlmIChpZCAmZ3Q7IDEpPGJyPisgJm5ic3A7ICZu
YnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7IHJldHVybiAtRUlOVkFMOzxi
cj4rPGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgaWYgKGlkKTxicj4rICZuYnNwOyAmbmJzcDsg
Jm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBjbGtpZCA9ICZxdW90O2RpMSZxdW90
Ozs8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBlbHNlPGJyPisgJm5ic3A7ICZuYnNwOyAmbmJz
cDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7IGNsa2lkID0gJnF1b3Q7ZGkwJnF1b3Q7Ozxi
cj4rPGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgaXB1X2RldiA9ICZhbXA7cGRldi0mZ3Q7ZGV2
Ozxicj4rPGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgZGlzW2lkXS5jbGsgPSBjbGtfZ2V0KCZh
bXA7cGRldi0mZ3Q7ZGV2LCBjbGtpZCk7PGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgZGlzW2lk
XS5tb2R1bGUgPSBtb2R1bGU7PGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgZGlzW2lkXS5pZCA9
IGlkOzxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7IGRpc1tpZF0uaXB1X2NsayA9IGlwdV9jbGs7
PGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgZGlzW2lkXS5iYXNlID0gaW9yZW1hcChiYXNlLCBQ
QUdFX1NJWkUpOzxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7IGlmICghZGlzW2lkXS5iYXNlKTxi
cj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyByZXR1
cm4gLUVOT01FTTs8YnI+Kzxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7IC8qIFNldCBNQ1VfVCB0
byBkaXZpZGUgTUNVIGFjY2VzcyB3aW5kb3cgaW50byAyICovPGJyPisgJm5ic3A7ICZuYnNwOyAm
bmJzcDsgaXB1X2NtX3dyaXRlKDB4MDA0MDAwMDBMIHwgKElQVV9NQ1VfVF9ERUZBVUxUICZsdDsm
bHQ7IDE4KSwgSVBVX0RJU1BfR0VOKTs8YnI+Kzxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7IHJl
dHVybiAwOzxicj4rfTxicj4rPGJyPit2b2lkIGlwdV9kaV9leGl0KHN0cnVjdCBwbGF0Zm9ybV9k
ZXZpY2UgKnBkZXYsIGludCBpZCk8YnI+K3s8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBjbGtf
cHV0KGRpc1tpZF0uY2xrKTs8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBpb3VubWFwKGRpc1tp
ZF0uYmFzZSk7PGJyPit9PGJyPmRpZmYgLS1naXQgYS9kcml2ZXJzL21mZC9pbXgtaXB1LXYzL2lw
dS1kbWZjLmMgYi9kcml2ZXJzL21mZC9pbXgtaXB1LXYzL2lwdS1kbWZjLmM8YnI+bmV3IGZpbGUg
bW9kZSAxMDA2NDQ8YnI+aW5kZXggMDAwMDAwMC4uMjU3ODJhNzxicj4tLS0gL2Rldi9udWxsPGJy
PisrKyBiL2RyaXZlcnMvbWZkL2lteC1pcHUtdjMvaXB1LWRtZmMuYzxicj5AQCAtMCwwICsxLDM0
MyBAQDxicj4rLyo8YnI+KyAqIENvcHlyaWdodCAoYykgMjAxMCBTYXNjaGEgSGF1ZXIgJmx0Ozxh
IGhyZWY9Im1haWx0bzpzLmhhdWVyQHBlbmd1dHJvbml4LmRlIj5zLmhhdWVyQHBlbmd1dHJvbml4
LmRlPC9hPiZndDs8YnI+KyAqIENvcHlyaWdodCAoQykgMjAwNS0yMDA5IEZyZWVzY2FsZSBTZW1p
Y29uZHVjdG9yLCBJbmMuPGJyPisgKjxicj4rICogVGhpcyBwcm9ncmFtIGlzIGZyZWUgc29mdHdh
cmU7IHlvdSBjYW4gcmVkaXN0cmlidXRlIGl0IGFuZC9vciBtb2RpZnkgaXQ8YnI+KyAqIHVuZGVy
IHRoZSB0ZXJtcyBvZiB0aGUgR05VIEdlbmVyYWwgUHVibGljIExpY2Vuc2UgYXMgcHVibGlzaGVk
IGJ5IHRoZTxicj4rICogRnJlZSBTb2Z0d2FyZSBGb3VuZGF0aW9uOyBlaXRoZXIgdmVyc2lvbiAy
IG9mIHRoZSBMaWNlbnNlLCBvciAoYXQgeW91cjxicj4rICogb3B0aW9uKSBhbnkgbGF0ZXIgdmVy
c2lvbi48YnI+KyAqPGJyPisgKiBUaGlzIHByb2dyYW0gaXMgZGlzdHJpYnV0ZWQgaW4gdGhlIGhv
cGUgdGhhdCBpdCB3aWxsIGJlIHVzZWZ1bCwgYnV0PGJyPisgKiBXSVRIT1VUIEFOWSBXQVJSQU5U
WTsgd2l0aG91dCBldmVuIHRoZSBpbXBsaWVkIHdhcnJhbnR5IG9mIE1FUkNIQU5UQUJJTElUWTxi
cj4rICogb3IgRklUTkVTUyBGT1IgQSBQQVJUSUNVTEFSIFBVUlBPU0UuICZuYnNwO1NlZSB0aGUg
R05VIEdlbmVyYWwgUHVibGljIExpY2Vuc2U8YnI+KyAqIGZvciBtb3JlIGRldGFpbHMuPGJyPisg
Ki88YnI+Kzxicj4rI2luY2x1ZGUgJmx0O2xpbnV4L3R5cGVzLmgmZ3Q7PGJyPisjaW5jbHVkZSAm
bHQ7bGludXgvZXJybm8uaCZndDs8YnI+KyNpbmNsdWRlICZsdDtsaW51eC9kZWxheS5oJmd0Ozxi
cj4rI2luY2x1ZGUgJmx0O2xpbnV4L2lvLmgmZ3Q7PGJyPisjaW5jbHVkZSAmbHQ7bGludXgvbWZk
L2lteC1pcHUtdjMuaCZndDs8YnI+Kzxicj4rI2luY2x1ZGUgJnF1b3Q7aXB1LXBydi5oJnF1b3Q7
PGJyPis8YnI+KyNkZWZpbmUgRE1GQ19SRF9DSEFOICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNw
OyAmbmJzcDsgMHgwMDAwPGJyPisjZGVmaW5lIERNRkNfV1JfQ0hBTiAmbmJzcDsgJm5ic3A7ICZu
YnNwOyAmbmJzcDsgJm5ic3A7IDB4MDAwNDxicj4rI2RlZmluZSBETUZDX1dSX0NIQU5fREVGICZu
YnNwOyAmbmJzcDsgJm5ic3A7IDB4MDAwODxicj4rI2RlZmluZSBETUZDX0RQX0NIQU4gJm5ic3A7
ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAweDAwMGM8YnI+KyNkZWZpbmUgRE1GQ19EUF9D
SEFOX0RFRiAmbmJzcDsgJm5ic3A7ICZuYnNwOyAweDAwMTA8YnI+KyNkZWZpbmUgRE1GQ19HRU5F
UkFMMSAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7MHgwMDE0PGJyPisjZGVmaW5l
IERNRkNfR0VORVJBTDIgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOzB4MDAxODxi
cj4rI2RlZmluZSBETUZDX0lDX0NUUkwgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNw
OyAweDAwMWM8YnI+KyNkZWZpbmUgRE1GQ19TVEFUICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNw
OyAmbmJzcDsgJm5ic3A7ICZuYnNwOzB4MDAyMDxicj4rPGJyPisjZGVmaW5lIERNRkNfV1JfQ0hB
Tl8xXzI4ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOzA8
YnI+KyNkZWZpbmUgRE1GQ19XUl9DSEFOXzJfNDEgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7
ICZuYnNwOyAmbmJzcDsgJm5ic3A7ODxicj4rI2RlZmluZSBETUZDX1dSX0NIQU5fMUNfNDIgJm5i
c3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgMTY8YnI+KyNkZWZpbmUgRE1G
Q19XUl9DSEFOXzJDXzQzICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7
IDI0PGJyPis8YnI+KyNkZWZpbmUgRE1GQ19EUF9DSEFOXzVCXzIzICZuYnNwOyAmbmJzcDsgJm5i
c3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7IDA8YnI+KyNkZWZpbmUgRE1GQ19EUF9DSEFOXzVGXzI3
ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7IDg8YnI+KyNkZWZpbmUg
RE1GQ19EUF9DSEFOXzZCXzI0ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5i
c3A7IDE2PGJyPisjZGVmaW5lIERNRkNfRFBfQ0hBTl82Rl8yOSAmbmJzcDsgJm5ic3A7ICZuYnNw
OyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAyNDxicj4rPGJyPisjZGVmaW5lIERNRkNfRklGT19TSVpF
XzY0ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOygzICZs
dDsmbHQ7IDMpPGJyPisjZGVmaW5lIERNRkNfRklGT19TSVpFXzEyOCAmbmJzcDsgJm5ic3A7ICZu
YnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAoMiAmbHQ7Jmx0OyAzKTxicj4rI2RlZmluZSBETUZD
X0ZJRk9fU0laRV8yNTYgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsg
KDEgJmx0OyZsdDsgMyk8YnI+KyNkZWZpbmUgRE1GQ19GSUZPX1NJWkVfNTEyICZuYnNwOyAmbmJz
cDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICgwICZsdDsmbHQ7IDMpPGJyPis8YnI+KyNk
ZWZpbmUgRE1GQ19TRUdNRU5UKHgpICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsg
Jm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7KCh4ICZhbXA7
IDB4NykgJmx0OyZsdDsgMCk8YnI+KyNkZWZpbmUgRE1GQ19CVVJTVFNJWkVfMzIgJm5ic3A7ICZu
YnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7KDAgJmx0OyZsdDsgNik8YnI+
KyNkZWZpbmUgRE1GQ19CVVJTVFNJWkVfMTYgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZu
YnNwOyAmbmJzcDsgJm5ic3A7KDEgJmx0OyZsdDsgNik8YnI+KyNkZWZpbmUgRE1GQ19CVVJTVFNJ
WkVfOCAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgKDIg
Jmx0OyZsdDsgNik8YnI+KyNkZWZpbmUgRE1GQ19CVVJTVFNJWkVfNCAmbmJzcDsgJm5ic3A7ICZu
YnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgKDMgJmx0OyZsdDsgNik8YnI+Kzxicj4r
c3RhdGljIHN0cnVjdCBkZXZpY2UgKmlwdV9kZXY7PGJyPis8YnI+K3N0cnVjdCBkbWZjX2NoYW5u
ZWwgezxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7IGludCAmbmJzcDsgJm5ic3A7ICZuYnNwOyAm
bmJzcDsgJm5ic3A7ICZuYnNwOyBpcHVfY2hhbm5lbDs8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNw
OyB1bnNpZ25lZCBsb25nICZuYnNwOyBjaGFubmVsX3JlZzs8YnI+KyAmbmJzcDsgJm5ic3A7ICZu
YnNwOyB1bnNpZ25lZCBsb25nICZuYnNwOyBzaGlmdDs8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNw
OyB1bnNpZ25lZCAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDtlb3Rfc2hpZnQ7PGJyPisgJm5i
c3A7ICZuYnNwOyAmbmJzcDsgdW5zaWduZWQgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7c2xv
dHM7PGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgdW5zaWduZWQgJm5ic3A7ICZuYnNwOyAmbmJz
cDsgJm5ic3A7bWF4X2ZpZm9fbGluZXM7PGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgdW5zaWdu
ZWQgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7c2xvdG1hc2s7PGJyPisgJm5ic3A7ICZuYnNw
OyAmbmJzcDsgdW5zaWduZWQgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7c2VnbWVudDs8YnI+
K307PGJyPis8YnI+K3N0YXRpYyBzdHJ1Y3QgZG1mY19jaGFubmVsIGRtZmNzW10gPSB7PGJyPisg
Jm5ic3A7ICZuYnNwOyAmbmJzcDsgezxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAm
bmJzcDsgJm5ic3A7ICZuYnNwOyAuaXB1X2NoYW5uZWwgJm5ic3A7ICZuYnNwOz0gMjMsPGJyPisg
Jm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7IC5jaGFubmVs
X3JlZyAmbmJzcDsgJm5ic3A7PSBETUZDX0RQX0NIQU4sPGJyPisgJm5ic3A7ICZuYnNwOyAmbmJz
cDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7IC5zaGlmdCAmbmJzcDsgJm5ic3A7ICZuYnNw
OyAmbmJzcDsgJm5ic3A7PSBETUZDX0RQX0NIQU5fNUJfMjMsPGJyPisgJm5ic3A7ICZuYnNwOyAm
bmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7IC5lb3Rfc2hpZnQgJm5ic3A7ICZuYnNw
OyAmbmJzcDs9IDIwLDxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5i
c3A7ICZuYnNwOyAubWF4X2ZpZm9fbGluZXMgPSAzLDxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7
IH0sIHs8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJz
cDsgLmlwdV9jaGFubmVsICZuYnNwOyAmbmJzcDs9IDI0LDxicj4rICZuYnNwOyAmbmJzcDsgJm5i
c3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAuY2hhbm5lbF9yZWcgJm5ic3A7ICZuYnNw
Oz0gRE1GQ19EUF9DSEFOLDxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsg
Jm5ic3A7ICZuYnNwOyAuc2hpZnQgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOz0g
RE1GQ19EUF9DSEFOXzZCXzI0LDxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJz
cDsgJm5ic3A7ICZuYnNwOyAuZW90X3NoaWZ0ICZuYnNwOyAmbmJzcDsgJm5ic3A7PSAyMiw8YnI+
KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgLm1heF9m
aWZvX2xpbmVzID0gMSw8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyB9LCB7PGJyPisgJm5ic3A7
ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7IC5pcHVfY2hhbm5lbCAm
bmJzcDsgJm5ic3A7PSAyNyw8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7
ICZuYnNwOyAmbmJzcDsgLmNoYW5uZWxfcmVnICZuYnNwOyAmbmJzcDs9IERNRkNfRFBfQ0hBTiw8
YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgLnNo
aWZ0ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDs9IERNRkNfRFBfQ0hBTl81Rl8y
Nyw8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsg
LmVvdF9zaGlmdCAmbmJzcDsgJm5ic3A7ICZuYnNwOz0gMjEsPGJyPisgJm5ic3A7ICZuYnNwOyAm
bmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7IC5tYXhfZmlmb19saW5lcyA9IDIsPGJy
PisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgfSwgezxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZu
YnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAuaXB1X2NoYW5uZWwgJm5ic3A7ICZuYnNwOz0gMjgs
PGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7IC5j
aGFubmVsX3JlZyAmbmJzcDsgJm5ic3A7PSBETUZDX1dSX0NIQU4sPGJyPisgJm5ic3A7ICZuYnNw
OyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7IC5zaGlmdCAmbmJzcDsgJm5ic3A7
ICZuYnNwOyAmbmJzcDsgJm5ic3A7PSBETUZDX1dSX0NIQU5fMV8yOCw8YnI+KyAmbmJzcDsgJm5i
c3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgLmVvdF9zaGlmdCAmbmJzcDsg
Jm5ic3A7ICZuYnNwOz0gMTYsPGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNw
OyAmbmJzcDsgJm5ic3A7IC5tYXhfZmlmb19saW5lcyA9IDIsPGJyPisgJm5ic3A7ICZuYnNwOyAm
bmJzcDsgfSwgezxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7
ICZuYnNwOyAuaXB1X2NoYW5uZWwgJm5ic3A7ICZuYnNwOz0gMjksPGJyPisgJm5ic3A7ICZuYnNw
OyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7IC5jaGFubmVsX3JlZyAmbmJzcDsg
Jm5ic3A7PSBETUZDX0RQX0NIQU4sPGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZu
YnNwOyAmbmJzcDsgJm5ic3A7IC5zaGlmdCAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5i
c3A7PSBETUZDX0RQX0NIQU5fNkZfMjksPGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7
ICZuYnNwOyAmbmJzcDsgJm5ic3A7IC5lb3Rfc2hpZnQgJm5ic3A7ICZuYnNwOyAmbmJzcDs9IDIz
LDxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAu
bWF4X2ZpZm9fbGluZXMgPSAxLDxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7IH0sPGJyPit9Ozxi
cj4rPGJyPisjZGVmaW5lIERNRkNfTlVNX0NIQU5ORUxTICZuYnNwOyAmbmJzcDsgJm5ic3A7QVJS
QVlfU0laRShkbWZjcyk8YnI+Kzxicj4rc3RhdGljIGludCBkbWZjX3VzZV9jb3VudDs8YnI+K3N0
YXRpYyB2b2lkIF9faW9tZW0gKmRtZmNfcmVnczs8YnI+K3N0YXRpYyB1bnNpZ25lZCBsb25nIGRt
ZmNfYmFuZHdpZHRoX3Blcl9zbG90Ozxicj4rc3RhdGljIERFRklORV9NVVRFWChkbWZjX211dGV4
KTs8YnI+Kzxicj4raW50IGlwdV9kbWZjX2VuYWJsZV9jaGFubmVsKHN0cnVjdCBkbWZjX2NoYW5u
ZWwgKmRtZmMpPGJyPit7PGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgbXV0ZXhfbG9jaygmYW1w
O2RtZmNfbXV0ZXgpOzxicj4rPGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgaWYgKCFkbWZjX3Vz
ZV9jb3VudCk8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAm
bmJzcDsgaXB1X21vZHVsZV9lbmFibGUoSVBVX0NPTkZfRE1GQ19FTik7PGJyPis8YnI+KyAmbmJz
cDsgJm5ic3A7ICZuYnNwOyBkbWZjX3VzZV9jb3VudCsrOzxicj4rPGJyPisgJm5ic3A7ICZuYnNw
OyAmbmJzcDsgbXV0ZXhfdW5sb2NrKCZhbXA7ZG1mY19tdXRleCk7PGJyPis8YnI+KyAmbmJzcDsg
Jm5ic3A7ICZuYnNwOyByZXR1cm4gMDs8YnI+K308YnI+K0VYUE9SVF9TWU1CT0woaXB1X2RtZmNf
ZW5hYmxlX2NoYW5uZWwpOzxicj4rPGJyPit2b2lkIGlwdV9kbWZjX2Rpc2FibGVfY2hhbm5lbChz
dHJ1Y3QgZG1mY19jaGFubmVsICpkbWZjKTxicj4rezxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7
IG11dGV4X2xvY2soJmFtcDtkbWZjX211dGV4KTs8YnI+Kzxicj4rICZuYnNwOyAmbmJzcDsgJm5i
c3A7IGRtZmNfdXNlX2NvdW50LS07PGJyPis8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBpZiAo
IWRtZmNfdXNlX2NvdW50KTxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsg
Jm5ic3A7ICZuYnNwOyBpcHVfbW9kdWxlX2Rpc2FibGUoSVBVX0NPTkZfRE1GQ19FTik7PGJyPis8
YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBpZiAoZG1mY191c2VfY291bnQgJmx0OyAwKTxicj4r
ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBkbWZjX3Vz
ZV9jb3VudCA9IDA7PGJyPis8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBtdXRleF91bmxvY2so
JmFtcDtkbWZjX211dGV4KTs8YnI+K308YnI+K0VYUE9SVF9TWU1CT0woaXB1X2RtZmNfZGlzYWJs
ZV9jaGFubmVsKTs8YnI+Kzxicj4rc3RhdGljIGludCBpcHVfZG1mY19zZXR1cF9jaGFubmVsKHN0
cnVjdCBkbWZjX2NoYW5uZWwgKmRtZmMsIGludCBzbG90cywgaW50IHNlZ21lbnQpPGJyPit7PGJy
PisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgdTMyIHZhbCwgZmllbGQ7PGJyPis8YnI+KyAmbmJzcDsg
Jm5ic3A7ICZuYnNwOyBkZXZfZGJnKGlwdV9kZXYsICZxdW90O2RtZmM6IHVzaW5nICVkIHNsb3Rz
IHN0YXJ0aW5nIGZyb20gc2VnbWVudCAlZCBmb3IgSVBVIGNoYW5uZWwgJWRcbiZxdW90Oyw8YnI+
KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7
ICZuYnNwOyAmbmJzcDsgJm5ic3A7IHNsb3RzLCBzZWdtZW50LCBkbWZjLSZndDtpcHVfY2hhbm5l
bCk7PGJyPis8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBpZiAoIWRtZmMpPGJyPisgJm5ic3A7
ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7IHJldHVybiAtRUlOVkFM
Ozxicj4rPGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgc3dpdGNoIChzbG90cykgezxicj4rICZu
YnNwOyAmbmJzcDsgJm5ic3A7IGNhc2UgMTo8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJz
cDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgZmllbGQgPSBETUZDX0ZJRk9fU0laRV82NDs8YnI+KyAm
bmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgYnJlYWs7PGJy
PisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgY2FzZSAyOjxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7
ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBmaWVsZCA9IERNRkNfRklGT19TSVpFXzEyODs8
YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgYnJl
YWs7PGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgY2FzZSA0Ojxicj4rICZuYnNwOyAmbmJzcDsg
Jm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBmaWVsZCA9IERNRkNfRklGT19TSVpF
XzI1Njs8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJz
cDsgYnJlYWs7PGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgY2FzZSA4Ojxicj4rICZuYnNwOyAm
bmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBmaWVsZCA9IERNRkNfRklG
T19TSVpFXzUxMjs8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNw
OyAmbmJzcDsgYnJlYWs7PGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgZGVmYXVsdDo8YnI+KyAm
bmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgcmV0dXJuIC1F
SU5WQUw7PGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgfTxicj4rPGJyPisgJm5ic3A7ICZuYnNw
OyAmbmJzcDsgZmllbGQgfD0gRE1GQ19TRUdNRU5UKHNlZ21lbnQpIHwgRE1GQ19CVVJTVFNJWkVf
ODs8YnI+Kzxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7IHZhbCA9IHJlYWRsKGRtZmNfcmVncyAr
IGRtZmMtJmd0O2NoYW5uZWxfcmVnKTs8YnI+Kzxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7IHZh
bCAmYW1wOz0gfigweGZmICZsdDsmbHQ7IGRtZmMtJmd0O3NoaWZ0KTs8YnI+KyAmbmJzcDsgJm5i
c3A7ICZuYnNwOyB2YWwgfD0gZmllbGQgJmx0OyZsdDsgZG1mYy0mZ3Q7c2hpZnQ7PGJyPis8YnI+
KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyB3cml0ZWwodmFsLCBkbWZjX3JlZ3MgKyBkbWZjLSZndDtj
aGFubmVsX3JlZyk7PGJyPis8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBkbWZjLSZndDtzbG90
cyA9IHNsb3RzOzxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7IGRtZmMtJmd0O3NlZ21lbnQgPSBz
ZWdtZW50Ozxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7IGRtZmMtJmd0O3Nsb3RtYXNrID0gKCgx
ICZsdDsmbHQ7IHNsb3RzKSAtIDEpICZsdDsmbHQ7IHNlZ21lbnQ7PGJyPis8YnI+KyAmbmJzcDsg
Jm5ic3A7ICZuYnNwOyByZXR1cm4gMDs8YnI+K308YnI+Kzxicj4rc3RhdGljIGludCBkbWZjX2Jh
bmR3aWR0aF90b19zbG90cyh1bnNpZ25lZCBsb25nIGJhbmR3aWR0aCk8YnI+K3s8YnI+KyAmbmJz
cDsgJm5ic3A7ICZuYnNwOyBpbnQgc2xvdHMgPSAxOzxicj4rPGJyPisgJm5ic3A7ICZuYnNwOyAm
bmJzcDsgd2hpbGUgKHNsb3RzICogZG1mY19iYW5kd2lkdGhfcGVyX3Nsb3QgJmx0OyBiYW5kd2lk
dGgpPGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7
IHNsb3RzICo9IDI7PGJyPis8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyByZXR1cm4gc2xvdHM7
PGJyPit9PGJyPis8YnI+K3N0YXRpYyBpbnQgZG1mY19maW5kX3Nsb3RzKGludCBzbG90cyk8YnI+
K3s8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyB1bnNpZ25lZCBzbG90bWFza19uZWVkLCBzbG90
bWFza191c2VkID0gMDs8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBpbnQgaSwgc2VnbWVudCA9
IDA7PGJyPis8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBzbG90bWFza19uZWVkID0gKDEgJmx0
OyZsdDsgc2xvdHMpIC0gMTs8YnI+Kzxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7IGZvciAoaSA9
IDA7IGkgJmx0OyBETUZDX05VTV9DSEFOTkVMUzsgaSsrKTxicj4rICZuYnNwOyAmbmJzcDsgJm5i
c3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBzbG90bWFza191c2VkIHw9IGRtZmNzW2ld
LnNsb3RtYXNrOzxicj4rPGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgd2hpbGUgKHNsb3RtYXNr
X25lZWQgJmx0Oz0gMHhmZikgezxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJz
cDsgJm5ic3A7ICZuYnNwOyBpZiAoIShzbG90bWFza191c2VkICZhbXA7IHNsb3RtYXNrX25lZWQp
KTxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAm
bmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgcmV0dXJuIHNlZ21lbnQ7PGJyPis8YnI+KyAmbmJz
cDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgc2xvdG1hc2tfbmVl
ZCAmbHQ7Jmx0Oz0gMTs8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZu
YnNwOyAmbmJzcDsgc2VnbWVudCsrOzxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7IH08YnI+Kzxi
cj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7IHJldHVybiAtRUJVU1k7PGJyPit9PGJyPis8YnI+K3Zv
aWQgaXB1X2RtZmNfZnJlZV9iYW5kd2lkdGgoc3RydWN0IGRtZmNfY2hhbm5lbCAqZG1mYyk8YnI+
K3s8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBpbnQgaTs8YnI+Kzxicj4rICZuYnNwOyAmbmJz
cDsgJm5ic3A7IGRldl9kYmcoaXB1X2RldiwgJnF1b3Q7ZG1mYzogZnJlZWluZyAlZCBzbG90cyBz
dGFydGluZyBmcm9tIHNlZ21lbnQgJWRcbiZxdW90Oyw8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNw
OyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7
IGRtZmMtJmd0O3Nsb3RzLCBkbWZjLSZndDtzZWdtZW50KTs8YnI+Kzxicj4rICZuYnNwOyAmbmJz
cDsgJm5ic3A7IG11dGV4X2xvY2soJmFtcDtkbWZjX211dGV4KTs8YnI+Kzxicj4rICZuYnNwOyAm
bmJzcDsgJm5ic3A7IGlmICghZG1mYy0mZ3Q7c2xvdHMpPGJyPisgJm5ic3A7ICZuYnNwOyAmbmJz
cDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7IGdvdG8gb3V0Ozxicj4rPGJyPisgJm5ic3A7
ICZuYnNwOyAmbmJzcDsgZG1mYy0mZ3Q7c2xvdG1hc2sgPSAwOzxicj4rICZuYnNwOyAmbmJzcDsg
Jm5ic3A7IGRtZmMtJmd0O3Nsb3RzID0gMDs8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBkbWZj
LSZndDtzZWdtZW50ID0gMDs8YnI+Kzxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7IGZvciAoaSA9
IDA7IGkgJmx0OyBBUlJBWV9TSVpFKGRtZmNzKTsgaSsrKTxicj4rICZuYnNwOyAmbmJzcDsgJm5i
c3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBkbWZjc1tpXS5zbG90bWFzayA9IDA7PGJy
Pis8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBmb3IgKGkgPSAwOyBpICZsdDsgQVJSQVlfU0la
RShkbWZjcyk7IGkrKykgezxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsg
Jm5ic3A7ICZuYnNwOyBpZiAoZG1mY3NbaV0uc2xvdHMgJmd0OyAwKSB7PGJyPisgJm5ic3A7ICZu
YnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5i
c3A7ICZuYnNwOyBkbWZjc1tpXS5zZWdtZW50ID0gZG1mY19maW5kX3Nsb3RzKGRtZmNzW2ldLnNs
b3RzKTs8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJz
cDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7IGRtZmNzW2ldLnNsb3RtYXNrID0gKCgxICZs
dDsmbHQ7IGRtZmNzW2ldLnNsb3RzKSAtIDEpICZsdDsmbHQ7IGRtZmNzW2ldLnNlZ21lbnQ7PGJy
PisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7IH08YnI+
KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyB9PGJyPis8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBm
b3IgKGkgPSAwOyBpICZsdDsgQVJSQVlfU0laRShkbWZjcyk7IGkrKykgezxicj4rICZuYnNwOyAm
bmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBpZiAoZG1mY3NbaV0uc2xv
dHMgJmd0OyAwKTxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7
ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgaXB1X2RtZmNfc2V0dXBfY2hhbm5l
bCgmYW1wO2RtZmNzW2ldLCBkbWZjc1tpXS5zbG90cywgZG1mY3NbaV0uc2VnbWVudCk7PGJyPisg
Jm5ic3A7ICZuYnNwOyAmbmJzcDsgfTxicj4rb3V0Ojxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7
IG11dGV4X3VubG9jaygmYW1wO2RtZmNfbXV0ZXgpOzxicj4rfTxicj4rRVhQT1JUX1NZTUJPTChp
cHVfZG1mY19mcmVlX2JhbmR3aWR0aCk7PGJyPis8YnI+K2ludCBpcHVfZG1mY19hbGxvY19iYW5k
d2lkdGgoc3RydWN0IGRtZmNfY2hhbm5lbCAqZG1mYyw8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNw
OyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgdW5zaWduZWQgbG9uZyBiYW5kd2lkdGhfcGl4
ZWxfcGVyX3NlY29uZCk8YnI+K3s8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBpbnQgc2xvdHMg
PSBkbWZjX2JhbmR3aWR0aF90b19zbG90cyhiYW5kd2lkdGhfcGl4ZWxfcGVyX3NlY29uZCk7PGJy
PisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgaW50IHNlZ21lbnQgPSAwOzxicj4rPGJyPisgJm5ic3A7
ICZuYnNwOyAmbmJzcDsgZGV2X2RiZyhpcHVfZGV2LCAmcXVvdDtkbWZjOiB0cnlpbmcgdG8gYWxs
b2NhdGUgJWxkTXBpeGVsL3MgZm9yIElQVSBjaGFubmVsICVkXG4mcXVvdDssPGJyPisgJm5ic3A7
ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsg
Jm5ic3A7ICZuYnNwOyBiYW5kd2lkdGhfcGl4ZWxfcGVyX3NlY29uZCAvIDEwMDAwMDAsIGRtZmMt
Jmd0O2lwdV9jaGFubmVsKTs8YnI+Kzxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7IGlwdV9kbWZj
X2ZyZWVfYmFuZHdpZHRoKGRtZmMpOzxicj4rPGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgbXV0
ZXhfbG9jaygmYW1wO2RtZmNfbXV0ZXgpOzxicj4rPGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsg
aWYgKHNsb3RzICZndDsgOCk8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7
ICZuYnNwOyAmbmJzcDsgcmV0dXJuIC1FQlVTWTs8c3BhbiBzdHlsZT0nY29sb3I6IzFGNDk3RCc+
PG86cD48L286cD48L3NwYW4+PC9wPjxwIGNsYXNzPU1zb05vcm1hbD48Yj48aT48c3BhbiBzdHls
ZT0nZm9udC1zaXplOjExLjBwdDtmb250LWZhbWlseToiQ2FsaWJyaSIsInNhbnMtc2VyaWYiO2Nv
bG9yOiMxRjQ5N0QnPltKYXNvbl0gbXV0ZXhfdW5sb2NrIGJlZm9yZSByZXR1cm48bzpwPjwvbzpw
Pjwvc3Bhbj48L2k+PC9iPjwvcD48cCBjbGFzcz1Nc29Ob3JtYWw+PGJyPis8YnI+KyAmbmJzcDsg
Jm5ic3A7ICZuYnNwOyBzZWdtZW50ID0gZG1mY19maW5kX3Nsb3RzKHNsb3RzKTs8YnI+KyAmbmJz
cDsgJm5ic3A7ICZuYnNwOyBpZiAoc2VnbWVudCAmbHQ7IDApPGJyPisgJm5ic3A7ICZuYnNwOyAm
bmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7IHJldHVybiAtRUJVU1k7PHNwYW4gc3R5
bGU9J2NvbG9yOiMxRjQ5N0QnPjxvOnA+PC9vOnA+PC9zcGFuPjwvcD48cCBjbGFzcz1Nc29Ob3Jt
YWw+PGI+PGk+PHNwYW4gc3R5bGU9J2ZvbnQtc2l6ZToxMS4wcHQ7Zm9udC1mYW1pbHk6IkNhbGli
cmkiLCJzYW5zLXNlcmlmIjtjb2xvcjojMUY0OTdEJz4gW0phc29uXSBtdXRleF91bmxvY2sgYmVm
b3JlIHJldHVybjxvOnA+PC9vOnA+PC9zcGFuPjwvaT48L2I+PC9wPjxwIGNsYXNzPU1zb05vcm1h
bD48YnI+Kzxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7IGlwdV9kbWZjX3NldHVwX2NoYW5uZWwo
ZG1mYywgc2xvdHMsIHNlZ21lbnQpOzxicj4rPGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgbXV0
ZXhfdW5sb2NrKCZhbXA7ZG1mY19tdXRleCk7PGJyPis8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNw
OyByZXR1cm4gMDs8YnI+K308YnI+K0VYUE9SVF9TWU1CT0woaXB1X2RtZmNfYWxsb2NfYmFuZHdp
ZHRoKTs8YnI+Kzxicj4raW50IGlwdV9kbWZjX2luaXRfY2hhbm5lbChzdHJ1Y3QgZG1mY19jaGFu
bmVsICpkbWZjLCBpbnQgd2lkdGgpPGJyPit7PGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgdTMy
IGRtZmNfZ2VuMTs8YnI+Kzxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7IGRtZmNfZ2VuMSA9IHJl
YWRsKGRtZmNfcmVncyArIERNRkNfR0VORVJBTDEpOzxicj4rPGJyPisgJm5ic3A7ICZuYnNwOyAm
bmJzcDsgaWYgKChkbWZjLSZndDtzbG90cyAqIDY0ICogNCkgLyB3aWR0aCAmZ3Q7IGRtZmMtJmd0
O21heF9maWZvX2xpbmVzKTxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsg
Jm5ic3A7ICZuYnNwOyBkbWZjX2dlbjEgfD0gMSAmbHQ7Jmx0OyBkbWZjLSZndDtlb3Rfc2hpZnQ7
PGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgZWxzZTxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7
ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBkbWZjX2dlbjEgJmFtcDs9IH4oMSAmbHQ7Jmx0
OyBkbWZjLSZndDtlb3Rfc2hpZnQpOzxicj4rPGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgd3Jp
dGVsKGRtZmNfZ2VuMSwgZG1mY19yZWdzICsgRE1GQ19HRU5FUkFMMSk7PGJyPis8YnI+KyAmbmJz
cDsgJm5ic3A7ICZuYnNwOyByZXR1cm4gMDs8YnI+K308YnI+K0VYUE9SVF9TWU1CT0woaXB1X2Rt
ZmNfaW5pdF9jaGFubmVsKTs8YnI+Kzxicj4rc3RydWN0IGRtZmNfY2hhbm5lbCAqaXB1X2RtZmNf
Z2V0KGludCBpcHVfY2hhbm5lbCk8YnI+K3s8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBpbnQg
aTs8YnI+Kzxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7IGZvciAoaSA9IDA7IGkgJmx0OyBETUZD
X05VTV9DSEFOTkVMUzsgaSsrKTxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJz
cDsgJm5ic3A7ICZuYnNwOyBpZiAoZG1mY3NbaV0uaXB1X2NoYW5uZWwgPT0gaXB1X2NoYW5uZWwp
PGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZu
YnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyByZXR1cm4gJmFtcDtkbWZjc1tpXTs8YnI+KyAmbmJz
cDsgJm5ic3A7ICZuYnNwOyByZXR1cm4gTlVMTDs8YnI+K308YnI+K0VYUE9SVF9TWU1CT0woaXB1
X2RtZmNfZ2V0KTs8YnI+Kzxicj4rdm9pZCBpcHVfZG1mY19wdXQoc3RydWN0IGRtZmNfY2hhbm5l
bCAqZG1mYyk8YnI+K3s8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBpcHVfZG1mY19mcmVlX2Jh
bmR3aWR0aChkbWZjKTs8YnI+K308YnI+K0VYUE9SVF9TWU1CT0woaXB1X2RtZmNfcHV0KTs8YnI+
Kzxicj4raW50IGlwdV9kbWZjX2luaXQoc3RydWN0IHBsYXRmb3JtX2RldmljZSAqcGRldiwgdW5z
aWduZWQgbG9uZyBiYXNlLDxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsg
Jm5ic3A7ICZuYnNwOyBzdHJ1Y3QgY2xrICppcHVfY2xrKTxicj4rezxicj4rICZuYnNwOyAmbmJz
cDsgJm5ic3A7IGRtZmNfcmVncyA9IGlvcmVtYXAoYmFzZSwgUEFHRV9TSVpFKTs8YnI+Kzxicj4r
ICZuYnNwOyAmbmJzcDsgJm5ic3A7IGlmICghZG1mY19yZWdzKTxicj4rICZuYnNwOyAmbmJzcDsg
Jm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyByZXR1cm4gLUVOT01FTTs8YnI+Kzxi
cj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7IGlwdV9kZXYgPSAmYW1wO3BkZXYtJmd0O2Rldjs8YnI+
Kzxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7IHdyaXRlbCgweDAsIGRtZmNfcmVncyArIERNRkNf
V1JfQ0hBTik7PGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgd3JpdGVsKDB4MCwgZG1mY19yZWdz
ICsgRE1GQ19EUF9DSEFOKTs8YnI+Kzxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7IC8qPGJyPisg
Jm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7KiBXZSBoYXZlIGEgdG90YWwgYmFuZHdpZHRoIG9m
IGNsa3JhdGUgKiA0cGl4ZWwgZGl2aWRlZDxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNw
OyogaW50byA4IHNsb3RzLjxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyovPGJyPisg
Jm5ic3A7ICZuYnNwOyAmbmJzcDsgZG1mY19iYW5kd2lkdGhfcGVyX3Nsb3QgPSBjbGtfZ2V0X3Jh
dGUoaXB1X2NsaykgLyA0Ozxicj4rPGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgZGV2X2RiZyhp
cHVfZGV2LCAmcXVvdDtkbWZjOiA4IHNsb3RzIHdpdGggJWxkTXBpeGVsL3MgYmFuZHdpZHRoIGVh
Y2hcbiZxdW90Oyw8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNw
OyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7IGRtZmNfYmFuZHdpZHRoX3Blcl9z
bG90IC8gMTAwMDAwMCk7PGJyPis8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyB3cml0ZWwoMHgy
MDIwMjBmNiwgZG1mY19yZWdzICsgRE1GQ19XUl9DSEFOX0RFRik7PGJyPisgJm5ic3A7ICZuYnNw
OyAmbmJzcDsgd3JpdGVsKDB4MjAyMGY2ZjYsIGRtZmNfcmVncyArIERNRkNfRFBfQ0hBTl9ERUYp
Ozxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7IHdyaXRlbCgweDAwMDAwMDAzLCBkbWZjX3JlZ3Mg
KyBETUZDX0dFTkVSQUwxKTs8YnI+Kzxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7IHJldHVybiAw
Ozxicj4rfTxicj4rPGJyPit2b2lkIGlwdV9kbWZjX2V4aXQoc3RydWN0IHBsYXRmb3JtX2Rldmlj
ZSAqcGRldik8YnI+K3s8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBpb3VubWFwKGRtZmNfcmVn
cyk7PGJyPit9PGJyPmRpZmYgLS1naXQgYS9kcml2ZXJzL21mZC9pbXgtaXB1LXYzL2lwdS1kcC5j
IGIvZHJpdmVycy9tZmQvaW14LWlwdS12My9pcHUtZHAuYzxicj5uZXcgZmlsZSBtb2RlIDEwMDY0
NDxicj5pbmRleCAwMDAwMDAwLi41MDUxMDdkPGJyPi0tLSAvZGV2L251bGw8YnI+KysrIGIvZHJp
dmVycy9tZmQvaW14LWlwdS12My9pcHUtZHAuYzxicj5AQCAtMCwwICsxLDQ2OCBAQDxicj4rLyo8
YnI+KyAqIENvcHlyaWdodCAoYykgMjAxMCBTYXNjaGEgSGF1ZXIgJmx0OzxhIGhyZWY9Im1haWx0
bzpzLmhhdWVyQHBlbmd1dHJvbml4LmRlIj5zLmhhdWVyQHBlbmd1dHJvbml4LmRlPC9hPiZndDs8
YnI+KyAqIENvcHlyaWdodCAoQykgMjAwNS0yMDA5IEZyZWVzY2FsZSBTZW1pY29uZHVjdG9yLCBJ
bmMuPGJyPisgKjxicj4rICogVGhpcyBwcm9ncmFtIGlzIGZyZWUgc29mdHdhcmU7IHlvdSBjYW4g
cmVkaXN0cmlidXRlIGl0IGFuZC9vciBtb2RpZnkgaXQ8YnI+KyAqIHVuZGVyIHRoZSB0ZXJtcyBv
ZiB0aGUgR05VIEdlbmVyYWwgUHVibGljIExpY2Vuc2UgYXMgcHVibGlzaGVkIGJ5IHRoZTxicj4r
ICogRnJlZSBTb2Z0d2FyZSBGb3VuZGF0aW9uOyBlaXRoZXIgdmVyc2lvbiAyIG9mIHRoZSBMaWNl
bnNlLCBvciAoYXQgeW91cjxicj4rICogb3B0aW9uKSBhbnkgbGF0ZXIgdmVyc2lvbi48YnI+KyAq
PGJyPisgKiBUaGlzIHByb2dyYW0gaXMgZGlzdHJpYnV0ZWQgaW4gdGhlIGhvcGUgdGhhdCBpdCB3
aWxsIGJlIHVzZWZ1bCwgYnV0PGJyPisgKiBXSVRIT1VUIEFOWSBXQVJSQU5UWTsgd2l0aG91dCBl
dmVuIHRoZSBpbXBsaWVkIHdhcnJhbnR5IG9mIE1FUkNIQU5UQUJJTElUWTxicj4rICogb3IgRklU
TkVTUyBGT1IgQSBQQVJUSUNVTEFSIFBVUlBPU0UuICZuYnNwO1NlZSB0aGUgR05VIEdlbmVyYWwg
UHVibGljIExpY2Vuc2U8YnI+KyAqIGZvciBtb3JlIGRldGFpbHMuPGJyPisgKi88YnI+Kzxicj4r
I2luY2x1ZGUgJmx0O2xpbnV4L3R5cGVzLmgmZ3Q7PGJyPisjaW5jbHVkZSAmbHQ7bGludXgvZXJy
bm8uaCZndDs8YnI+KyNpbmNsdWRlICZsdDtsaW51eC9kZWxheS5oJmd0Ozxicj4rI2luY2x1ZGUg
Jmx0O2xpbnV4L2lvLmgmZ3Q7PGJyPisjaW5jbHVkZSAmbHQ7bGludXgvbWZkL2lteC1pcHUtdjMu
aCZndDs8YnI+KyNpbmNsdWRlICZsdDtsaW51eC9lcnIuaCZndDs8YnI+KyNpbmNsdWRlICZsdDth
c20vYXRvbWljLmgmZ3Q7PGJyPis8YnI+KyNpbmNsdWRlICZxdW90O2lwdS1wcnYuaCZxdW90Ozxi
cj4rPGJyPisjZGVmaW5lIERQX1NZTkMgMDxicj4rI2RlZmluZSBEUF9BU1lOQzAgMHg2MDxicj4r
I2RlZmluZSBEUF9BU1lOQzEgMHhCQzxicj4rPGJyPisjZGVmaW5lIERQX0NPTV9DT05GKGZsb3cp
ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyhpcHVfZHBf
YmFzZSArIGZsb3cpPGJyPisjZGVmaW5lIERQX0dSQVBIX1dJTkRfQ1RSTChmbG93KSAmbmJzcDsg
Jm5ic3A7ICZuYnNwOyAoaXB1X2RwX2Jhc2UgKyAweDAwMDQgKyBmbG93KTxicj4rI2RlZmluZSBE
UF9GR19QT1MoZmxvdykgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsg
Jm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsoaXB1X2RwX2Jhc2UgKyAw
eDAwMDggKyBmbG93KTxicj4rI2RlZmluZSBEUF9DU0NfQV8wKGZsb3cpICZuYnNwOyAmbmJzcDsg
Jm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAoaXB1X2RwX2Jhc2UgKyAweDAwNDQg
KyBmbG93KTxicj4rI2RlZmluZSBEUF9DU0NfQV8xKGZsb3cpICZuYnNwOyAmbmJzcDsgJm5ic3A7
ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAoaXB1X2RwX2Jhc2UgKyAweDAwNDggKyBmbG93
KTxicj4rI2RlZmluZSBEUF9DU0NfQV8yKGZsb3cpICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNw
OyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAoaXB1X2RwX2Jhc2UgKyAweDAwNEMgKyBmbG93KTxicj4r
I2RlZmluZSBEUF9DU0NfQV8zKGZsb3cpICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJz
cDsgJm5ic3A7ICZuYnNwOyAoaXB1X2RwX2Jhc2UgKyAweDAwNTAgKyBmbG93KTxicj4rI2RlZmlu
ZSBEUF9DU0NfMChmbG93KSAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNw
OyAmbmJzcDsgJm5ic3A7IChpcHVfZHBfYmFzZSArIDB4MDA1NCArIGZsb3cpPGJyPisjZGVmaW5l
IERQX0NTQ18xKGZsb3cpICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7
ICZuYnNwOyAmbmJzcDsgKGlwdV9kcF9iYXNlICsgMHgwMDU4ICsgZmxvdyk8YnI+Kzxicj4rI2Rl
ZmluZSBEUF9DT01fQ09ORl9GR19FTiAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7
ICZuYnNwOyAmbmJzcDsoMSAmbHQ7Jmx0OyAwKTxicj4rI2RlZmluZSBEUF9DT01fQ09ORl9HV1NF
TCAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsoMSAmbHQ7
Jmx0OyAxKTxicj4rI2RlZmluZSBEUF9DT01fQ09ORl9HV0FNICZuYnNwOyAmbmJzcDsgJm5ic3A7
ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAoMSAmbHQ7Jmx0OyAyKTxicj4rI2RlZmluZSBE
UF9DT01fQ09ORl9HV0NLRSAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNw
OyAmbmJzcDsoMSAmbHQ7Jmx0OyAzKTxicj4rI2RlZmluZSBEUF9DT01fQ09ORl9DU0NfREVGX01B
U0sgJm5ic3A7ICZuYnNwOyAmbmJzcDsgKDMgJmx0OyZsdDsgOCk8YnI+KyNkZWZpbmUgRFBfQ09N
X0NPTkZfQ1NDX0RFRl9PRkZTRVQgJm5ic3A7ICZuYnNwOyA4PGJyPisjZGVmaW5lIERQX0NPTV9D
T05GX0NTQ19ERUZfRkcgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICgzICZsdDsmbHQ7IDgp
PGJyPisjZGVmaW5lIERQX0NPTV9DT05GX0NTQ19ERUZfQkcgJm5ic3A7ICZuYnNwOyAmbmJzcDsg
Jm5ic3A7ICgyICZsdDsmbHQ7IDgpPGJyPisjZGVmaW5lIERQX0NPTV9DT05GX0NTQ19ERUZfQk9U
SCAmbmJzcDsgJm5ic3A7ICZuYnNwOyAoMSAmbHQ7Jmx0OyA4KTxicj4rPGJyPitzdHJ1Y3QgaXB1
X2RwIHs8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyB1MzIgZmxvdzs8YnI+KyAmbmJzcDsgJm5i
c3A7ICZuYnNwOyBib29sIGluX3VzZTs8YnI+K307PGJyPis8YnI+K3N0YXRpYyBzdHJ1Y3QgaXB1
X2RwIGlwdV9kcFszXTs8YnI+K3N0YXRpYyBzdHJ1Y3QgZGV2aWNlICppcHVfZGV2Ozxicj4rPGJy
PitzdGF0aWMgdTMyIGlwdV9mbG93c1tdID0ge0RQX1NZTkMsIERQX0FTWU5DMCwgRFBfQVNZTkMx
fTs8YnI+Kzxicj4rZW51bSBjc2NfdHlwZV90IHs8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBS
R0IyWVVWID0gMCw8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBZVVYyUkdCLDxicj4rICZuYnNw
OyAmbmJzcDsgJm5ic3A7IFJHQjJSR0IsPGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgWVVWMllV
Viw8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBDU0NfTk9ORSw8YnI+KyAmbmJzcDsgJm5ic3A7
ICZuYnNwOyBDU0NfTlVNPGJyPit9Ozxicj4rPGJyPitzdGF0aWMgdm9pZCBfX2lvbWVtICppcHVf
ZHBfYmFzZTs8YnI+K3N0YXRpYyBpbnQgZHBfdXNlX2NvdW50Ozxicj4rc3RhdGljIERFRklORV9N
VVRFWChkcF9tdXRleCk7PGJyPis8YnI+Ky8qICZuYnNwOyAmbmJzcDsgWSA9IFIgKiAmbmJzcDsu
Mjk5ICsgRyAqICZuYnNwOy41ODcgKyBCICogJm5ic3A7LjExNDs8YnI+KyAmbmJzcDsgJm5ic3A7
ICZuYnNwOyBVID0gUiAqIC0uMTY5ICsgRyAqIC0uMzMyICsgQiAqICZuYnNwOy41MDAgKyAxMjgu
Ozxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7IFYgPSBSICogJm5ic3A7LjUwMCArIEcgKiAtLjQx
OSArIEIgKiAtLjA4MTMgKyAxMjguOyovPGJyPitzdGF0aWMgY29uc3QgaW50IHJnYjJ5Y2Jjcl9j
b2VmZls1XVszXSA9IHs8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyB7IDE1MywgMzAxLCA1OCwg
fSw8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyB7IC04NywgLTE3MCwgMHgwMTAwLCB9LDxicj4r
ICZuYnNwOyAmbmJzcDsgJm5ic3A7IHsgMHgxMDAsIC0yMTUsIC00MiwgfSw8YnI+KyAmbmJzcDsg
Jm5ic3A7ICZuYnNwOyB7IDB4MDAwMCwgMHgwMjAwLCAweDAyMDAsIH0sICZuYnNwOyAmbmJzcDsv
KiBCMCwgQjEsIEIyICovPGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgeyAweDIsIDB4MiwgMHgy
LCB9LCAmbmJzcDsgJm5ic3A7IC8qIFMwLCBTMSwgUzIgKi88YnI+K307PGJyPis8YnI+Ky8qICZu
YnNwOyAmbmJzcDsgUiA9ICgxLjE2NCAqIChZIC0gMTYpKSArICgxLjU5NiAqIChDciAtIDEyOCkp
Ozxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7IEcgPSAoMS4xNjQgKiAoWSAtIDE2KSkgLSAoMC4z
OTIgKiAoQ2IgLSAxMjgpKSAtICgwLjgxMyAqIChDciAtIDEyOCkpOzxicj4rICZuYnNwOyAmbmJz
cDsgJm5ic3A7IEIgPSAoMS4xNjQgKiAoWSAtIDE2KSkgKyAoMi4wMTcgKiAoQ2IgLSAxMjgpOyAq
Lzxicj4rc3RhdGljIGNvbnN0IGludCB5Y2JjcjJyZ2JfY29lZmZbNV1bM10gPSB7PGJyPisgJm5i
c3A7ICZuYnNwOyAmbmJzcDsgeyAweDA5NSwgMHgwMDAsIDB4MENDLCB9LDxicj4rICZuYnNwOyAm
bmJzcDsgJm5ic3A7IHsgMHgwOTUsIDB4M0NFLCAweDM5OCwgfSw8YnI+KyAmbmJzcDsgJm5ic3A7
ICZuYnNwOyB7IDB4MDk1LCAweDBGRiwgMHgwMDAsIH0sPGJyPisgJm5ic3A7ICZuYnNwOyAmbmJz
cDsgeyAweDNFNDIsIDB4MDEwQSwgMHgzREQ2LCB9LCAmbmJzcDsgJm5ic3A7LypCMCxCMSxCMiAq
Lzxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7IHsgMHgxLCAweDEsIDB4MSwgfSwgJm5ic3A7ICZu
YnNwOyAvKlMwLFMxLFMyICovPGJyPit9Ozxicj4rPGJyPisvKiBQbGVhc2Uga2VlcCBTMCwgUzEg
YW5kIFMyIGFzIDB4MiBieSB1c2luZyB0aGlzIGNvbnZlcnNpb24gKi88YnI+K3N0YXRpYyBpbnQg
X3JnYl90b195dXYoaW50IG4sIGludCByZWQsIGludCBncmVlbiwgaW50IGJsdWUpPGJyPit7PGJy
PisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgaW50IGM7PGJyPis8YnI+KyAmbmJzcDsgJm5ic3A7ICZu
YnNwOyBjID0gcmVkICogcmdiMnljYmNyX2NvZWZmW25dWzBdOzxicj4rICZuYnNwOyAmbmJzcDsg
Jm5ic3A7IGMgKz0gZ3JlZW4gKiByZ2IyeWNiY3JfY29lZmZbbl1bMV07PGJyPisgJm5ic3A7ICZu
YnNwOyAmbmJzcDsgYyArPSBibHVlICogcmdiMnljYmNyX2NvZWZmW25dWzJdOzxicj4rICZuYnNw
OyAmbmJzcDsgJm5ic3A7IGMgLz0gMTY7PGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgYyArPSBy
Z2IyeWNiY3JfY29lZmZbM11bbl0gKiA0Ozxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7IGMgKz0g
ODs8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBjIC89IDE2Ozxicj4rICZuYnNwOyAmbmJzcDsg
Jm5ic3A7IGlmIChjICZsdDsgMCk8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5i
c3A7ICZuYnNwOyAmbmJzcDsgYyA9IDA7PGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgaWYgKGMg
Jmd0OyAyNTUpPGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsg
Jm5ic3A7IGMgPSAyNTU7PGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgcmV0dXJuIGM7PGJyPit9
PGJyPis8YnI+K3N0cnVjdCBkcF9jc2NfcGFyYW1fdCB7PGJyPisgJm5ic3A7ICZuYnNwOyAmbmJz
cDsgaW50IG1vZGU7PGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgdm9pZCAqY29lZmY7PGJyPit9
Ozxicj4rPGJyPisvKjxicj4rICogUm93IGlzIGZvciBCRzogJm5ic3A7ICZuYnNwOyAmbmJzcDtS
R0IyWVVWIFlVVjJSR0IgUkdCMlJHQiBZVVYyWVVWIENTQ19OT05FPGJyPisgKiBDb2x1bW4gaXMg
Zm9yIEZHOiAmbmJzcDsgUkdCMllVViBZVVYyUkdCIFJHQjJSR0IgWVVWMllVViBDU0NfTk9ORTxi
cj4rICovPGJyPitzdGF0aWMgc3RydWN0IGRwX2NzY19wYXJhbV90IGRwX2NzY19hcnJheVtDU0Nf
TlVNXVtDU0NfTlVNXSA9IHs8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyB7PGJyPisgJm5ic3A7
ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7IHsgRFBfQ09NX0NPTkZf
Q1NDX0RFRl9CT1RILCAmYW1wO3JnYjJ5Y2Jjcl9jb2VmZiwgfSw8YnI+KyAmbmJzcDsgJm5ic3A7
ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgeyAwLCAwLCB9LDxicj4rICZuYnNw
OyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyB7IDAsIDAsIH0sPGJy
PisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7IHsgRFBf
Q09NX0NPTkZfQ1NDX0RFRl9CRywgJmFtcDtyZ2IyeWNiY3JfY29lZmYsIH0sPGJyPisgJm5ic3A7
ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7IHsgRFBfQ09NX0NPTkZf
Q1NDX0RFRl9CRywgJmFtcDtyZ2IyeWNiY3JfY29lZmYsIH0sPGJyPisgJm5ic3A7ICZuYnNwOyAm
bmJzcDsgfSwgezxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7
ICZuYnNwOyB7IDAsIDAsIH0sPGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNw
OyAmbmJzcDsgJm5ic3A7IHsgRFBfQ09NX0NPTkZfQ1NDX0RFRl9CT1RILCAmYW1wO3ljYmNyMnJn
Yl9jb2VmZiwgfSw8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNw
OyAmbmJzcDsgeyBEUF9DT01fQ09ORl9DU0NfREVGX0JHLCAmYW1wO3ljYmNyMnJnYl9jb2VmZiwg
fSw8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsg
eyAwLCAwLCB9LDxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7
ICZuYnNwOyB7IERQX0NPTV9DT05GX0NTQ19ERUZfQkcsICZhbXA7eWNiY3IycmdiX2NvZWZmLCB9
LDxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7IH0sIHs8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNw
OyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgeyAwLCAwLCB9LDxicj4rICZuYnNwOyAmbmJz
cDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyB7IERQX0NPTV9DT05GX0NTQ19E
RUZfRkcsICZhbXA7eWNiY3IycmdiX2NvZWZmLCB9LDxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7
ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyB7IDAsIDAsIH0sPGJyPisgJm5ic3A7ICZuYnNw
OyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7IHsgMCwgMCwgfSw8YnI+KyAmbmJz
cDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgeyAwLCAwLCB9LDxi
cj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7IH0sIHs8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAm
bmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgeyBEUF9DT01fQ09ORl9DU0NfREVGX0ZHLCAmYW1w
O3JnYjJ5Y2Jjcl9jb2VmZiwgfSw8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5i
c3A7ICZuYnNwOyAmbmJzcDsgeyAwLCAwLCB9LDxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZu
YnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyB7IDAsIDAsIH0sPGJyPisgJm5ic3A7ICZuYnNwOyAm
bmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7IHsgMCwgMCwgfSw8YnI+KyAmbmJzcDsg
Jm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgeyAwLCAwLCB9LDxicj4r
ICZuYnNwOyAmbmJzcDsgJm5ic3A7IH0sIHs8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJz
cDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgeyBEUF9DT01fQ09ORl9DU0NfREVGX0ZHLCAmYW1wO3Jn
YjJ5Y2Jjcl9jb2VmZiwgfSw8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7
ICZuYnNwOyAmbmJzcDsgeyBEUF9DT01fQ09ORl9DU0NfREVGX0ZHLCAmYW1wO3ljYmNyMnJnYl9j
b2VmZiwgfSw8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAm
bmJzcDsgeyAwLCAwLCB9LDxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsg
Jm5ic3A7ICZuYnNwOyB7IDAsIDAsIH0sPGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7
ICZuYnNwOyAmbmJzcDsgJm5ic3A7IHsgMCwgMCwgfSw8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNw
OyB9PGJyPit9Ozxicj4rPGJyPitzdGF0aWMgZW51bSBjc2NfdHlwZV90IGZnX2NzY190eXBlID0g
Q1NDX05PTkUsIGJnX2NzY190eXBlID0gQ1NDX05PTkU7PGJyPis8YnI+K3N0YXRpYyBpbnQgY29s
b3Jfa2V5XzRyZ2IgPSAxOzxicj4rPGJyPitpbnQgaXB1X2RwX3NldF9jb2xvcl9rZXkoc3RydWN0
IGlwdV9kcCAqZHAsIGJvb2wgZW5hYmxlLCB1MzIgY29sb3Jfa2V5KTxicj4rezxicj4rICZuYnNw
OyAmbmJzcDsgJm5ic3A7IHUzMiByZWc7PGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgaW50IHks
IHUsIHY7PGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgaW50IHJlZCwgZ3JlZW4sIGJsdWU7PGJy
Pis8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBtdXRleF9sb2NrKCZhbXA7ZHBfbXV0ZXgpOzxi
cj4rPGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgY29sb3Jfa2V5XzRyZ2IgPSAxOzxicj4rICZu
YnNwOyAmbmJzcDsgJm5ic3A7IC8qIFRyYW5zZm9ybSBjb2xvciBrZXkgZnJvbSByZ2IgdG8geXV2
IGlmIENTQyBpcyBlbmFibGVkICovPGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgaWYgKCgoZmdf
Y3NjX3R5cGUgPT0gUkdCMllVVikgJmFtcDsmYW1wOyAoYmdfY3NjX3R5cGUgPT0gWVVWMllVVikp
IHx8PGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7
ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAoKGZnX2NzY190eXBlID09IFlVVjJZVVYpICZh
bXA7JmFtcDsgKGJnX2NzY190eXBlID09IFJHQjJZVVYpKSB8fDxicj4rICZuYnNwOyAmbmJzcDsg
Jm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAm
bmJzcDsgKChmZ19jc2NfdHlwZSA9PSBZVVYyWVVWKSAmYW1wOyZhbXA7IChiZ19jc2NfdHlwZSA9
PSBZVVYyWVVWKSkgfHw8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZu
YnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICgoZmdfY3NjX3R5cGUgPT0g
WVVWMlJHQikgJmFtcDsmYW1wOyAoYmdfY3NjX3R5cGUgPT0gWVVWMlJHQikpKSB7PGJyPis8YnI+
KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgZGV2X2Ri
ZyhpcHVfZGV2LCAmcXVvdDtjb2xvciBrZXkgMHgleCBuZWVkIGNoYW5nZSB0byB5dXYgZm10XG4m
cXVvdDssIGNvbG9yX2tleSk7PGJyPis8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsg
Jm5ic3A7ICZuYnNwOyAmbmJzcDsgcmVkID0gKGNvbG9yX2tleSAmZ3Q7Jmd0OyAxNikgJmFtcDsg
MHhGRjs8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJz
cDsgZ3JlZW4gPSAoY29sb3Jfa2V5ICZndDsmZ3Q7IDgpICZhbXA7IDB4RkY7PGJyPisgJm5ic3A7
ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7IGJsdWUgPSBjb2xvcl9r
ZXkgJmFtcDsgMHhGRjs8YnI+Kzxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJz
cDsgJm5ic3A7ICZuYnNwOyB5ID0gX3JnYl90b195dXYoMCwgcmVkLCBncmVlbiwgYmx1ZSk7PGJy
PisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7IHUgPSBf
cmdiX3RvX3l1digxLCByZWQsIGdyZWVuLCBibHVlKTs8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNw
OyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgdiA9IF9yZ2JfdG9feXV2KDIsIHJlZCwgZ3Jl
ZW4sIGJsdWUpOzxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7
ICZuYnNwOyBjb2xvcl9rZXkgPSAoeSAmbHQ7Jmx0OyAxNikgfCAodSAmbHQ7Jmx0OyA4KSB8IHY7
PGJyPis8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJz
cDsgY29sb3Jfa2V5XzRyZ2IgPSAwOzxicj4rPGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5i
c3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7IGRldl9kYmcoaXB1X2RldiwgJnF1b3Q7Y29sb3Iga2V5
IGNoYW5nZSB0byB5dXYgZm10IDB4JXhcbiZxdW90OywgY29sb3Jfa2V5KTs8YnI+KyAmbmJzcDsg
Jm5ic3A7ICZuYnNwOyB9PGJyPis8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBpZiAoZW5hYmxl
KSB7PGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7
IHJlZyA9IF9fcmF3X3JlYWRsKERQX0dSQVBIX1dJTkRfQ1RSTChkcC0mZ3Q7ZmxvdykpICZhbXA7
IDB4RkYwMDAwMDBMOzxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5i
c3A7ICZuYnNwOyBfX3Jhd193cml0ZWwocmVnIHwgY29sb3Jfa2V5LCBEUF9HUkFQSF9XSU5EX0NU
UkwoZHAtJmd0O2Zsb3cpKTs8YnI+Kzxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAm
bmJzcDsgJm5ic3A7ICZuYnNwOyByZWcgPSBfX3Jhd19yZWFkbChEUF9DT01fQ09ORihkcC0mZ3Q7
ZmxvdykpOzxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZu
YnNwOyBfX3Jhd193cml0ZWwocmVnIHwgRFBfQ09NX0NPTkZfR1dDS0UsIERQX0NPTV9DT05GKGRw
LSZndDtmbG93KSk7PGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgfSBlbHNlIHs8YnI+KyAmbmJz
cDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgcmVnID0gX19yYXdf
cmVhZGwoRFBfQ09NX0NPTkYoZHAtJmd0O2Zsb3cpKTs8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNw
OyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgX19yYXdfd3JpdGVsKHJlZyAmYW1wOyB+RFBf
Q09NX0NPTkZfR1dDS0UsIERQX0NPTV9DT05GKGRwLSZndDtmbG93KSk7PGJyPisgJm5ic3A7ICZu
YnNwOyAmbmJzcDsgfTxicj4rPGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgcmVnID0gaXB1X2Nt
X3JlYWQoSVBVX1NSTV9QUkkyKSB8IDB4ODs8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBpcHVf
Y21fd3JpdGUocmVnLCBJUFVfU1JNX1BSSTIpOzxicj4rPGJyPisgJm5ic3A7ICZuYnNwOyAmbmJz
cDsgbXV0ZXhfdW5sb2NrKCZhbXA7ZHBfbXV0ZXgpOzxicj4rPGJyPisgJm5ic3A7ICZuYnNwOyAm
bmJzcDsgcmV0dXJuIDA7PGJyPit9PGJyPitFWFBPUlRfU1lNQk9MKGlwdV9kcF9zZXRfY29sb3Jf
a2V5KTs8YnI+Kzxicj4raW50IGlwdV9kcF9zZXRfZ2xvYmFsX2FscGhhKHN0cnVjdCBpcHVfZHAg
KmRwLCBib29sIGVuYWJsZSwgdTggYWxwaGEsIGJvb2wgYmdfY2hhbik8YnI+K3s8YnI+KyAmbmJz
cDsgJm5ic3A7ICZuYnNwOyB1MzIgcmVnOzxicj4rPGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsg
bXV0ZXhfbG9jaygmYW1wO2RwX211dGV4KTs8YnI+Kzxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7
IHJlZyA9IF9fcmF3X3JlYWRsKERQX0NPTV9DT05GKGRwLSZndDtmbG93KSk7PGJyPisgJm5ic3A7
ICZuYnNwOyAmbmJzcDsgaWYgKGJnX2NoYW4pPGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5i
c3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7IHJlZyAmYW1wOz0gfkRQX0NPTV9DT05GX0dXU0VMOzxi
cj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7IGVsc2U8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAm
bmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgcmVnIHw9IERQX0NPTV9DT05GX0dXU0VMOzxicj4r
ICZuYnNwOyAmbmJzcDsgJm5ic3A7IF9fcmF3X3dyaXRlbChyZWcsIERQX0NPTV9DT05GKGRwLSZn
dDtmbG93KSk7PGJyPis8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBpZiAoZW5hYmxlKSB7PGJy
PisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7IHJlZyA9
IF9fcmF3X3JlYWRsKERQX0dSQVBIX1dJTkRfQ1RSTChkcC0mZ3Q7ZmxvdykpICZhbXA7IDB4MDBG
RkZGRkZMOzxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZu
YnNwOyBfX3Jhd193cml0ZWwocmVnIHwgKCh1MzIpIGFscGhhICZsdDsmbHQ7IDI0KSw8YnI+KyAm
bmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZu
YnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7RFBfR1JBUEhfV0lORF9DVFJM
KGRwLSZndDtmbG93KSk7PGJyPis8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5i
c3A7ICZuYnNwOyAmbmJzcDsgcmVnID0gX19yYXdfcmVhZGwoRFBfQ09NX0NPTkYoZHAtJmd0O2Zs
b3cpKTs8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJz
cDsgX19yYXdfd3JpdGVsKHJlZyB8IERQX0NPTV9DT05GX0dXQU0sIERQX0NPTV9DT05GKGRwLSZn
dDtmbG93KSk7PGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgfSBlbHNlIHs8YnI+KyAmbmJzcDsg
Jm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgcmVnID0gX19yYXdfcmVh
ZGwoRFBfQ09NX0NPTkYoZHAtJmd0O2Zsb3cpKTs8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAm
bmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgX19yYXdfd3JpdGVsKHJlZyAmYW1wOyB+RFBfQ09N
X0NPTkZfR1dBTSwgRFBfQ09NX0NPTkYoZHAtJmd0O2Zsb3cpKTs8YnI+KyAmbmJzcDsgJm5ic3A7
ICZuYnNwOyB9PGJyPis8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyByZWcgPSBpcHVfY21fcmVh
ZChJUFVfU1JNX1BSSTIpIHwgMHg4Ozxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7IGlwdV9jbV93
cml0ZShyZWcsIElQVV9TUk1fUFJJMik7PGJyPis8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBt
dXRleF91bmxvY2soJmFtcDtkcF9tdXRleCk7PGJyPis8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNw
OyByZXR1cm4gMDs8YnI+K308YnI+K0VYUE9SVF9TWU1CT0woaXB1X2RwX3NldF9nbG9iYWxfYWxw
aGEpOzxicj4rPGJyPitpbnQgaXB1X2RwX3NldF93aW5kb3dfcG9zKHN0cnVjdCBpcHVfZHAgKmRw
LCB1MTYgeF9wb3MsIHUxNiB5X3Bvcyk8YnI+K3s8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyB1
MzIgcmVnOzxicj4rPGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgbXV0ZXhfbG9jaygmYW1wO2Rw
X211dGV4KTs8YnI+Kzxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7IF9fcmF3X3dyaXRlbCgoeF9w
b3MgJmx0OyZsdDsgMTYpIHwgeV9wb3MsIERQX0ZHX1BPUyhkcC0mZ3Q7ZmxvdykpOzxicj4rPGJy
PisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgcmVnID0gaXB1X2NtX3JlYWQoSVBVX1NSTV9QUkkyKTs8
YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyByZWcgfD0gMHg4Ozxicj4rICZuYnNwOyAmbmJzcDsg
Jm5ic3A7IGlwdV9jbV93cml0ZShyZWcsIElQVV9TUk1fUFJJMik7PGJyPis8YnI+KyAmbmJzcDsg
Jm5ic3A7ICZuYnNwOyBtdXRleF91bmxvY2soJmFtcDtkcF9tdXRleCk7PGJyPis8YnI+KyAmbmJz
cDsgJm5ic3A7ICZuYnNwOyByZXR1cm4gMDs8YnI+K308YnI+K0VYUE9SVF9TWU1CT0woaXB1X2Rw
X3NldF93aW5kb3dfcG9zKTs8YnI+Kzxicj4rI2RlZmluZSBtYXNrX2EoYSkgKCh1MzIpKGEpICZh
bXA7IDB4M0ZGKTxicj4rI2RlZmluZSBtYXNrX2IoYikgKCh1MzIpKGIpICZhbXA7IDB4M0ZGRik8
YnI+Kzxicj4rdm9pZCBfX2lwdV9kcF9jc2Nfc2V0dXAoaW50IGRwLCBzdHJ1Y3QgZHBfY3NjX3Bh
cmFtX3QgZHBfY3NjX3BhcmFtLDxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJz
cDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgYm9vbCBzcm1fbW9k
ZV91cGRhdGUpPGJyPit7PGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgdTMyIHJlZzs8YnI+KyAm
bmJzcDsgJm5ic3A7ICZuYnNwOyBjb25zdCBpbnQgKCpjb2VmZilbNV1bM107PGJyPis8YnI+KyAm
bmJzcDsgJm5ic3A7ICZuYnNwOyBpZiAoZHBfY3NjX3BhcmFtLm1vZGUgJmd0Oz0gMCkgezxicj4r
ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyByZWcgPSBf
X3Jhd19yZWFkbChEUF9DT01fQ09ORihkcCkpOzxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZu
YnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyByZWcgJmFtcDs9IH5EUF9DT01fQ09ORl9DU0NfREVG
X01BU0s7PGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5i
c3A7IHJlZyB8PSBkcF9jc2NfcGFyYW0ubW9kZTs8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAm
bmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgX19yYXdfd3JpdGVsKHJlZywgRFBfQ09NX0NPTkYo
ZHApKTs8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyB9PGJyPis8YnI+KyAmbmJzcDsgJm5ic3A7
ICZuYnNwOyBjb2VmZiA9IGRwX2NzY19wYXJhbS5jb2VmZjs8YnI+Kzxicj4rICZuYnNwOyAmbmJz
cDsgJm5ic3A7IGlmIChjb2VmZikgezxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAm
bmJzcDsgJm5ic3A7ICZuYnNwOyBfX3Jhd193cml0ZWwobWFza19hKCgqY29lZmYpWzBdWzBdKSB8
PGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZu
YnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgKG1h
c2tfYSgoKmNvZWZmKVswXVsxXSkgJmx0OyZsdDsgMTYpLCBEUF9DU0NfQV8wKGRwKSk7PGJyPisg
Jm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7IF9fcmF3X3dy
aXRlbChtYXNrX2EoKCpjb2VmZilbMF1bMl0pIHw8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAm
bmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZu
YnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAobWFza19hKCgqY29lZmYpWzFdWzBdKSAmbHQ7Jmx0
OyAxNiksIERQX0NTQ19BXzEoZHApKTs8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsg
Jm5ic3A7ICZuYnNwOyAmbmJzcDsgX19yYXdfd3JpdGVsKG1hc2tfYSgoKmNvZWZmKVsxXVsxXSkg
fDxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAm
bmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICht
YXNrX2EoKCpjb2VmZilbMV1bMl0pICZsdDsmbHQ7IDE2KSwgRFBfQ1NDX0FfMihkcCkpOzxicj4r
ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBfX3Jhd193
cml0ZWwobWFza19hKCgqY29lZmYpWzJdWzBdKSB8PGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsg
Jm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAm
bmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgKG1hc2tfYSgoKmNvZWZmKVsyXVsxXSkgJmx0OyZs
dDsgMTYpLCBEUF9DU0NfQV8zKGRwKSk7PGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7
ICZuYnNwOyAmbmJzcDsgJm5ic3A7IF9fcmF3X3dyaXRlbChtYXNrX2EoKCpjb2VmZilbMl1bMl0p
IHw8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsg
Jm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAo
bWFza19iKCgqY29lZmYpWzNdWzBdKSAmbHQ7Jmx0OyAxNikgfDxicj4rICZuYnNwOyAmbmJzcDsg
Jm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAm
bmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICgoKmNvZWZmKVs0XVswXSAmbHQ7Jmx0
OyAzMCksIERQX0NTQ18wKGRwKSk7PGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZu
YnNwOyAmbmJzcDsgJm5ic3A7IF9fcmF3X3dyaXRlbChtYXNrX2IoKCpjb2VmZilbM11bMV0pIHwg
KCgqY29lZmYpWzRdWzFdICZsdDsmbHQ7IDE0KSB8PGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsg
Jm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAm
bmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgKG1hc2tfYigoKmNvZWZmKVszXVsyXSkgJmx0OyZs
dDsgMTYpIHw8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAm
bmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZu
YnNwOyAoKCpjb2VmZilbNF1bMl0gJmx0OyZsdDsgMzApLCBEUF9DU0NfMShkcCkpOzxicj4rICZu
YnNwOyAmbmJzcDsgJm5ic3A7IH08YnI+Kzxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7IGlmIChz
cm1fbW9kZV91cGRhdGUpIHs8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7
ICZuYnNwOyAmbmJzcDsgcmVnID0gaXB1X2NtX3JlYWQoSVBVX1NSTV9QUkkyKSB8IDB4ODs8YnI+
KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgaXB1X2Nt
X3dyaXRlKHJlZywgSVBVX1NSTV9QUkkyKTs8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyB9PGJy
Pit9PGJyPis8YnI+K2ludCBpcHVfZHBfc2V0dXBfY2hhbm5lbChzdHJ1Y3QgaXB1X2RwICpkcCwg
dTMyIGluX3BpeGVsX2ZtdCw8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7
ICZuYnNwOyAmbmJzcDsgJm5ic3A7dTMyIG91dF9waXhlbF9mbXQsIGludCBiZyk8YnI+K3s8YnI+
KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBpbnQgaW5fZm10LCBvdXRfZm10Ozxicj4rICZuYnNwOyAm
bmJzcDsgJm5ic3A7IGVudW0gY3NjX3R5cGVfdCAqY3NjX3R5cGU7PGJyPisgJm5ic3A7ICZuYnNw
OyAmbmJzcDsgdTMyIHJlZzs8YnI+Kzxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7IGlmIChiZyk8
YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgY3Nj
X3R5cGUgPSAmYW1wO2JnX2NzY190eXBlOzxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7IGVsc2U8
YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgY3Nj
X3R5cGUgPSAmYW1wO2ZnX2NzY190eXBlOzxicj4rPGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsg
aW5fZm10ID0gZm9ybWF0X3RvX2NvbG9yc3BhY2UoaW5fcGl4ZWxfZm10KTs8YnI+KyAmbmJzcDsg
Jm5ic3A7ICZuYnNwOyBvdXRfZm10ID0gZm9ybWF0X3RvX2NvbG9yc3BhY2Uob3V0X3BpeGVsX2Zt
dCk7PGJyPis8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBpZiAoaW5fZm10ID09IFJHQikgezxi
cj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBpZiAo
b3V0X2ZtdCA9PSBSR0IpPGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAm
bmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAqY3NjX3R5cGUgPSBSR0Iy
UkdCOzxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNw
OyBlbHNlPGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5i
c3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAqY3NjX3R5cGUgPSBSR0IyWVVWOzxicj4r
ICZuYnNwOyAmbmJzcDsgJm5ic3A7IH0gZWxzZSB7PGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsg
Jm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7IGlmIChvdXRfZm10ID09IFJHQik8YnI+KyAmbmJz
cDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNw
OyAmbmJzcDsgJm5ic3A7ICpjc2NfdHlwZSA9IFlVVjJSR0I7PGJyPisgJm5ic3A7ICZuYnNwOyAm
bmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7IGVsc2U8YnI+KyAmbmJzcDsgJm5ic3A7
ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsg
Jm5ic3A7ICpjc2NfdHlwZSA9IFlVVjJZVVY7PGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgfTxi
cj4rPGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgLyogVHJhbnNmb3JtIGNvbG9yIGtleSBmcm9t
IHJnYiB0byB5dXYgaWYgQ1NDIGlzIGVuYWJsZWQgKi88YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNw
OyByZWcgPSBfX3Jhd19yZWFkbChEUF9DT01fQ09ORihkcC0mZ3Q7ZmxvdykpOzxicj4rICZuYnNw
OyAmbmJzcDsgJm5ic3A7IGlmIChjb2xvcl9rZXlfNHJnYiAmYW1wOyZhbXA7IChyZWcgJmFtcDsg
RFBfQ09NX0NPTkZfR1dDS0UpICZhbXA7JmFtcDs8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAm
bmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICgo
KGZnX2NzY190eXBlID09IFJHQjJZVVYpICZhbXA7JmFtcDsgKGJnX2NzY190eXBlID09IFlVVjJZ
VVYpKSB8fDxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZu
YnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7KChmZ19jc2NfdHlwZSA9PSBZ
VVYyWVVWKSAmYW1wOyZhbXA7IChiZ19jc2NfdHlwZSA9PSBSR0IyWVVWKSkgfHw8YnI+KyAmbmJz
cDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNw
OyAmbmJzcDsgJm5ic3A7ICZuYnNwOygoZmdfY3NjX3R5cGUgPT0gWVVWMllVVikgJmFtcDsmYW1w
OyAoYmdfY3NjX3R5cGUgPT0gWVVWMllVVikpIHx8PGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsg
Jm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAm
bmJzcDsoKGZnX2NzY190eXBlID09IFlVVjJSR0IpICZhbXA7JmFtcDsgKGJnX2NzY190eXBlID09
IFlVVjJSR0IpKSkpIHs8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZu
YnNwOyAmbmJzcDsgaW50IHJlZCwgZ3JlZW4sIGJsdWU7PGJyPisgJm5ic3A7ICZuYnNwOyAmbmJz
cDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7IGludCB5LCB1LCB2Ozxicj4rICZuYnNwOyAm
bmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyB1MzIgY29sb3Jfa2V5ID0g
X19yYXdfcmVhZGwoRFBfR1JBUEhfV0lORF9DVFJMKGRwLSZndDtmbG93KSkgJmFtcDsgMHhGRkZG
RkZMOzxicj4rPGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsg
Jm5ic3A7IGRldl9kYmcoaXB1X2RldiwgJnF1b3Q7X2lwdV9kcF9pbml0IGNvbG9yIGtleSAweCV4
IG5lZWQgY2hhbmdlIHRvIHl1diBmbXQhXG4mcXVvdDssIGNvbG9yX2tleSk7PGJyPis8YnI+KyAm
bmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgcmVkID0gKGNv
bG9yX2tleSAmZ3Q7Jmd0OyAxNikgJmFtcDsgMHhGRjs8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNw
OyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgZ3JlZW4gPSAoY29sb3Jfa2V5ICZndDsmZ3Q7
IDgpICZhbXA7IDB4RkY7PGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAm
bmJzcDsgJm5ic3A7IGJsdWUgPSBjb2xvcl9rZXkgJmFtcDsgMHhGRjs8YnI+Kzxicj4rICZuYnNw
OyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyB5ID0gX3JnYl90b195
dXYoMCwgcmVkLCBncmVlbiwgYmx1ZSk7PGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7
ICZuYnNwOyAmbmJzcDsgJm5ic3A7IHUgPSBfcmdiX3RvX3l1digxLCByZWQsIGdyZWVuLCBibHVl
KTs8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsg
diA9IF9yZ2JfdG9feXV2KDIsIHJlZCwgZ3JlZW4sIGJsdWUpOzxicj4rICZuYnNwOyAmbmJzcDsg
Jm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBjb2xvcl9rZXkgPSAoeSAmbHQ7Jmx0
OyAxNikgfCAodSAmbHQ7Jmx0OyA4KSB8IHY7PGJyPis8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNw
OyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgcmVnID0gX19yYXdfcmVhZGwoRFBfR1JBUEhf
V0lORF9DVFJMKGRwLSZndDtmbG93KSkgJmFtcDsgMHhGRjAwMDAwMEw7PGJyPisgJm5ic3A7ICZu
YnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7IF9fcmF3X3dyaXRlbChyZWcg
fCBjb2xvcl9rZXksIERQX0dSQVBIX1dJTkRfQ1RSTChkcC0mZ3Q7ZmxvdykpOzxicj4rICZuYnNw
OyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBjb2xvcl9rZXlfNHJn
YiA9IDA7PGJyPis8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNw
OyAmbmJzcDsgZGV2X2RiZyhpcHVfZGV2LCAmcXVvdDtfaXB1X2RwX2luaXQgY29sb3Iga2V5IGNo
YW5nZSB0byB5dXYgZm10IDB4JXghXG4mcXVvdDssIGNvbG9yX2tleSk7PGJyPisgJm5ic3A7ICZu
YnNwOyAmbmJzcDsgfTxicj4rPGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgX19pcHVfZHBfY3Nj
X3NldHVwKGRwLSZndDtmbG93LCBkcF9jc2NfYXJyYXlbYmdfY3NjX3R5cGVdW2ZnX2NzY190eXBl
XSwgdHJ1ZSk7PGJyPis8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyByZXR1cm4gMDs8YnI+K308
YnI+K0VYUE9SVF9TWU1CT0woaXB1X2RwX3NldHVwX2NoYW5uZWwpOzxicj4rPGJyPitpbnQgaXB1
X2RwX2VuYWJsZV9jaGFubmVsKHN0cnVjdCBpcHVfZHAgKmRwKTxicj4rezxicj4rICZuYnNwOyAm
bmJzcDsgJm5ic3A7IG11dGV4X2xvY2soJmFtcDtkcF9tdXRleCk7PGJyPis8YnI+KyAmbmJzcDsg
Jm5ic3A7ICZuYnNwOyBpZiAoIWRwX3VzZV9jb3VudCk8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNw
OyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgaXB1X21vZHVsZV9lbmFibGUoSVBVX0NPTkZf
RFBfRU4pOzxicj4rPGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgZHBfdXNlX2NvdW50Kys7PGJy
Pis8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBtdXRleF91bmxvY2soJmFtcDtkcF9tdXRleCk7
PGJyPis8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyByZXR1cm4gMDs8YnI+K308YnI+K0VYUE9S
VF9TWU1CT0woaXB1X2RwX2VuYWJsZV9jaGFubmVsKTs8YnI+Kzxicj4rdm9pZCBpcHVfZHBfZGlz
YWJsZV9jaGFubmVsKHN0cnVjdCBpcHVfZHAgKmRwKTxicj4rezxicj4rICZuYnNwOyAmbmJzcDsg
Jm5ic3A7IG11dGV4X2xvY2soJmFtcDtkcF9tdXRleCk7PGJyPis8YnI+KyAmbmJzcDsgJm5ic3A7
ICZuYnNwOyBkcF91c2VfY291bnQtLTs8YnI+Kzxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7IGlm
ICghZHBfdXNlX2NvdW50KTxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsg
Jm5ic3A7ICZuYnNwOyBpcHVfbW9kdWxlX2Rpc2FibGUoSVBVX0NPTkZfRFBfRU4pOzxicj4rPGJy
PisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgaWYgKGRwX3VzZV9jb3VudCAmbHQ7IDApPGJyPisgJm5i
c3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7IGRwX3VzZV9jb3Vu
dCA9IDA7PGJyPis8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBtdXRleF91bmxvY2soJmFtcDtk
cF9tdXRleCk7PGJyPit9PGJyPitFWFBPUlRfU1lNQk9MKGlwdV9kcF9kaXNhYmxlX2NoYW5uZWwp
Ozxicj4rPGJyPit2b2lkIGlwdV9kcF9lbmFibGVfZmcoc3RydWN0IGlwdV9kcCAqZHApPGJyPit7
PGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgdTMyIHJlZzs8YnI+Kzxicj4rICZuYnNwOyAmbmJz
cDsgJm5ic3A7IC8qIEVuYWJsZSBGRyBjaGFubmVsICovPGJyPisgJm5ic3A7ICZuYnNwOyAmbmJz
cDsgcmVnID0gX19yYXdfcmVhZGwoRFBfQ09NX0NPTkYoRFBfU1lOQykpOzxicj4rICZuYnNwOyAm
bmJzcDsgJm5ic3A7IF9fcmF3X3dyaXRlbChyZWcgfCBEUF9DT01fQ09ORl9GR19FTiwgRFBfQ09N
X0NPTkYoRFBfU1lOQykpOzxicj4rPGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgcmVnID0gaXB1
X2NtX3JlYWQoSVBVX1NSTV9QUkkyKTs8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyByZWcgfD0g
MHg4Ozxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7IGlwdV9jbV93cml0ZShyZWcsIElQVV9TUk1f
UFJJMik7PGJyPit9PGJyPitFWFBPUlRfU1lNQk9MKGlwdV9kcF9lbmFibGVfZmcpOzxicj4rPGJy
Pit2b2lkIGlwdV9kcF9kaXNhYmxlX2ZnKHN0cnVjdCBpcHVfZHAgKmRwKTxicj4rezxicj4rICZu
YnNwOyAmbmJzcDsgJm5ic3A7IHUzMiByZWcsIGNzYzs8YnI+Kzxicj4rICZuYnNwOyAmbmJzcDsg
Jm5ic3A7IHJlZyA9IF9fcmF3X3JlYWRsKERQX0NPTV9DT05GKERQX1NZTkMpKTs8YnI+KyAmbmJz
cDsgJm5ic3A7ICZuYnNwOyBjc2MgPSByZWcgJmFtcDsgRFBfQ09NX0NPTkZfQ1NDX0RFRl9NQVNL
Ozxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7IGlmIChjc2MgPT0gRFBfQ09NX0NPTkZfQ1NDX0RF
Rl9GRyk8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJz
cDsgcmVnICZhbXA7PSB+RFBfQ09NX0NPTkZfQ1NDX0RFRl9NQVNLOzxicj4rPGJyPisgJm5ic3A7
ICZuYnNwOyAmbmJzcDsgcmVnICZhbXA7PSB+RFBfQ09NX0NPTkZfRkdfRU47PGJyPisgJm5ic3A7
ICZuYnNwOyAmbmJzcDsgX19yYXdfd3JpdGVsKHJlZywgRFBfQ09NX0NPTkYoRFBfU1lOQykpOzxi
cj4rPGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgcmVnID0gaXB1X2NtX3JlYWQoSVBVX1NSTV9Q
UkkyKSB8IDB4ODs8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBpcHVfY21fd3JpdGUocmVnLCBJ
UFVfU1JNX1BSSTIpOzxicj4rfTxicj4rRVhQT1JUX1NZTUJPTChpcHVfZHBfZGlzYWJsZV9mZyk7
PGJyPis8YnI+K3N0cnVjdCBpcHVfZHAgKmlwdV9kcF9nZXQodW5zaWduZWQgaW50IGZsb3cpPGJy
Pit7PGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgc3RydWN0IGlwdV9kcCAqZHA7PGJyPis8YnI+
KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBpZiAoZmxvdyAmZ3Q7IDIpPGJyPisgJm5ic3A7ICZuYnNw
OyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7IHJldHVybiBFUlJfUFRSKC1FSU5W
QUwpOzxicj4rPGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgZHAgPSAmYW1wO2lwdV9kcFtmbG93
XTs8YnI+Kzxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7IGlmIChkcC0mZ3Q7aW5fdXNlKTxicj4r
ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyByZXR1cm4g
RVJSX1BUUigtRUJVU1kpOzxicj4rPGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgZHAtJmd0O2lu
X3VzZSA9IHRydWU7PGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgZHAtJmd0O2Zsb3cgPSBpcHVf
Zmxvd3NbZmxvd107PGJyPis8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyByZXR1cm4gZHA7PGJy
Pit9PGJyPitFWFBPUlRfU1lNQk9MKGlwdV9kcF9nZXQpOzxicj4rPGJyPit2b2lkIGlwdV9kcF9w
dXQoc3RydWN0IGlwdV9kcCAqZHApPGJyPit7PGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgZHAt
Jmd0O2luX3VzZSA9IGZhbHNlOzxicj4rfTxicj4rRVhQT1JUX1NZTUJPTChpcHVfZHBfcHV0KTs8
YnI+Kzxicj4raW50IGlwdV9kcF9pbml0KHN0cnVjdCBwbGF0Zm9ybV9kZXZpY2UgKnBkZXYsIHVu
c2lnbmVkIGxvbmcgYmFzZSk8YnI+K3s8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBpcHVfZHBf
YmFzZSA9IGlvcmVtYXAoYmFzZSwgUEFHRV9TSVpFKTs8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNw
OyBpZiAoIWlwdV9kcF9iYXNlKTxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJz
cDsgJm5ic3A7ICZuYnNwOyByZXR1cm4gLUVOT01FTTs8YnI+Kzxicj4rICZuYnNwOyAmbmJzcDsg
Jm5ic3A7IGlwdV9kZXYgPSAmYW1wO3BkZXYtJmd0O2Rldjs8YnI+Kzxicj4rICZuYnNwOyAmbmJz
cDsgJm5ic3A7IHJldHVybiAwOzxicj4rfTxicj4rPGJyPit2b2lkIGlwdV9kcF9leGl0KHN0cnVj
dCBwbGF0Zm9ybV9kZXZpY2UgKnBkZXYpPGJyPit7PGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsg
Jm5ic3A7aW91bm1hcChpcHVfZHBfYmFzZSk7PGJyPit9PGJyPmRpZmYgLS1naXQgYS9kcml2ZXJz
L21mZC9pbXgtaXB1LXYzL2lwdS1wcnYuaCBiL2RyaXZlcnMvbWZkL2lteC1pcHUtdjMvaXB1LXBy
di5oPGJyPm5ldyBmaWxlIG1vZGUgMTAwNjQ0PGJyPmluZGV4IDAwMDAwMDAuLjlkNTRhZDA8YnI+
LS0tIC9kZXYvbnVsbDxicj4rKysgYi9kcml2ZXJzL21mZC9pbXgtaXB1LXYzL2lwdS1wcnYuaDxi
cj5AQCAtMCwwICsxLDIxNCBAQDxicj4rLyo8YnI+KyAqIENvcHlyaWdodCAoYykgMjAxMCBTYXNj
aGEgSGF1ZXIgJmx0OzxhIGhyZWY9Im1haWx0bzpzLmhhdWVyQHBlbmd1dHJvbml4LmRlIj5zLmhh
dWVyQHBlbmd1dHJvbml4LmRlPC9hPiZndDs8YnI+KyAqIENvcHlyaWdodCAoQykgMjAwNS0yMDA5
IEZyZWVzY2FsZSBTZW1pY29uZHVjdG9yLCBJbmMuPGJyPisgKjxicj4rICogVGhpcyBwcm9ncmFt
IGlzIGZyZWUgc29mdHdhcmU7IHlvdSBjYW4gcmVkaXN0cmlidXRlIGl0IGFuZC9vciBtb2RpZnkg
aXQ8YnI+KyAqIHVuZGVyIHRoZSB0ZXJtcyBvZiB0aGUgR05VIEdlbmVyYWwgUHVibGljIExpY2Vu
c2UgYXMgcHVibGlzaGVkIGJ5IHRoZTxicj4rICogRnJlZSBTb2Z0d2FyZSBGb3VuZGF0aW9uOyBl
aXRoZXIgdmVyc2lvbiAyIG9mIHRoZSBMaWNlbnNlLCBvciAoYXQgeW91cjxicj4rICogb3B0aW9u
KSBhbnkgbGF0ZXIgdmVyc2lvbi48YnI+KyAqPGJyPisgKiBUaGlzIHByb2dyYW0gaXMgZGlzdHJp
YnV0ZWQgaW4gdGhlIGhvcGUgdGhhdCBpdCB3aWxsIGJlIHVzZWZ1bCwgYnV0PGJyPisgKiBXSVRI
T1VUIEFOWSBXQVJSQU5UWTsgd2l0aG91dCBldmVuIHRoZSBpbXBsaWVkIHdhcnJhbnR5IG9mIE1F
UkNIQU5UQUJJTElUWTxicj4rICogb3IgRklUTkVTUyBGT1IgQSBQQVJUSUNVTEFSIFBVUlBPU0Uu
ICZuYnNwO1NlZSB0aGUgR05VIEdlbmVyYWwgUHVibGljIExpY2Vuc2U8YnI+KyAqIGZvciBtb3Jl
IGRldGFpbHMuPGJyPisgKi88YnI+KyNpZm5kZWYgX19JUFVfUFJWX0hfXzxicj4rI2RlZmluZSBf
X0lQVV9QUlZfSF9fPGJyPis8YnI+KyNpbmNsdWRlICZsdDtsaW51eC90eXBlcy5oJmd0Ozxicj4r
I2luY2x1ZGUgJmx0O2xpbnV4L2RldmljZS5oJmd0Ozxicj4rI2luY2x1ZGUgJmx0O2xpbnV4L2Ns
ay5oJmd0Ozxicj4rI2luY2x1ZGUgJmx0O2xpbnV4L2ludGVycnVwdC5oJmd0Ozxicj4rI2luY2x1
ZGUgJmx0O2xpbnV4L3BsYXRmb3JtX2RldmljZS5oJmd0Ozxicj4rI2luY2x1ZGUgJmx0O21hY2gv
aGFyZHdhcmUuaCZndDs8YnI+Kzxicj4rI2RlZmluZSBNWDUxX0lQVV9DSEFOTkVMX0NTSTAgJm5i
c3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJz
cDsgMDxicj4rI2RlZmluZSBNWDUxX0lQVV9DSEFOTkVMX0NTSTEgJm5ic3A7ICZuYnNwOyAmbmJz
cDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgMTxicj4rI2RlZmlu
ZSBNWDUxX0lQVV9DSEFOTkVMX0NTSTIgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNw
OyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgMjxicj4rI2RlZmluZSBNWDUxX0lQVV9DSEFO
TkVMX0NTSTMgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7
ICZuYnNwOyAmbmJzcDsgMzxicj4rI2RlZmluZSBNWDUxX0lQVV9DSEFOTkVMX01FTV9CR19TWU5D
ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgMjM8YnI+KyNkZWZpbmUgTVg1MV9J
UFVfQ0hBTk5FTF9NRU1fRkdfU1lOQyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7
IDI3PGJyPisjZGVmaW5lIE1YNTFfSVBVX0NIQU5ORUxfTUVNX0RDX1NZTkMgJm5ic3A7ICZuYnNw
OyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAyODxicj4rI2RlZmluZSBNWDUxX0lQVV9DSEFOTkVMX01F
TV9GR19TWU5DX0FMUEhBICZuYnNwOyAmbmJzcDsgMzE8YnI+KyNkZWZpbmUgTVg1MV9JUFVfQ0hB
Tk5FTF9NRU1fRENfQVNZTkMgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOzQxPGJy
PisjZGVmaW5lIE1YNTFfSVBVX0NIQU5ORUxfUk9UX0VOQ19NRU0gJm5ic3A7ICZuYnNwOyAmbmJz
cDsgJm5ic3A7ICZuYnNwOyA0NTxicj4rI2RlZmluZSBNWDUxX0lQVV9DSEFOTkVMX1JPVF9WRl9N
RU0gJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDs0Njxicj4rI2RlZmlu
ZSBNWDUxX0lQVV9DSEFOTkVMX1JPVF9QUF9NRU0gJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7
ICZuYnNwOyAmbmJzcDs0Nzxicj4rI2RlZmluZSBNWDUxX0lQVV9DSEFOTkVMX1JPVF9FTkNfTUVN
X09VVCAmbmJzcDsgJm5ic3A7ICZuYnNwOyA0ODxicj4rI2RlZmluZSBNWDUxX0lQVV9DSEFOTkVM
X1JPVF9WRl9NRU1fT1VUICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7
ICZuYnNwOyAmbmJzcDs0OTxicj4rI2RlZmluZSBNWDUxX0lQVV9DSEFOTkVMX1JPVF9QUF9NRU1f
T1VUICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJz
cDs1MDxicj4rI2RlZmluZSBNWDUxX0lQVV9DSEFOTkVMX01FTV9CR19TWU5DX0FMUEhBICZuYnNw
OyAmbmJzcDsgNTE8YnI+Kzxicj4rI2RlZmluZSBJUFVfRElTUDBfQkFTRSAmbmJzcDsgJm5ic3A7
ICZuYnNwOyAmbmJzcDsgMHgwMDAwMDAwMDxicj4rI2RlZmluZSBJUFVfTUNVX1RfREVGQVVMVCAm
bmJzcDsgJm5ic3A7ICZuYnNwOzg8YnI+KyNkZWZpbmUgSVBVX0RJU1AxX0JBU0UgJm5ic3A7ICZu
YnNwOyAmbmJzcDsgJm5ic3A7IChJUFVfTUNVX1RfREVGQVVMVCAmbHQ7Jmx0OyAyNSk8YnI+KyNk
ZWZpbmUgSVBVX0NNX1JFR19CQVNFICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsg
Jm5ic3A7ICZuYnNwOyAmbmJzcDsweDFlMDAwMDAwPGJyPisjZGVmaW5lIElQVV9JRE1BQ19SRUdf
QkFTRSAmbmJzcDsgJm5ic3A7IDB4MWUwMDgwMDA8YnI+KyNkZWZpbmUgSVBVX0lTUF9SRUdfQkFT
RSAmbmJzcDsgJm5ic3A7ICZuYnNwOyAweDFlMDEwMDAwPGJyPisjZGVmaW5lIElQVV9EUF9SRUdf
QkFTRSAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5i
c3A7MHgxZTAxODAwMDxicj4rI2RlZmluZSBJUFVfSUNfUkVHX0JBU0UgJm5ic3A7ICZuYnNwOyAm
bmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOzB4MWUwMjAwMDA8YnI+KyNk
ZWZpbmUgSVBVX0lSVF9SRUdfQkFTRSAmbmJzcDsgJm5ic3A7ICZuYnNwOyAweDFlMDI4MDAwPGJy
PisjZGVmaW5lIElQVV9DU0kwX1JFR19CQVNFICZuYnNwOyAmbmJzcDsgJm5ic3A7MHgxZTAzMDAw
MDxicj4rI2RlZmluZSBJUFVfQ1NJMV9SRUdfQkFTRSAmbmJzcDsgJm5ic3A7ICZuYnNwOzB4MWUw
MzgwMDA8YnI+KyNkZWZpbmUgSVBVX0RJMF9SRUdfQkFTRSAmbmJzcDsgJm5ic3A7ICZuYnNwOyAw
eDFlMDQwMDAwPGJyPisjZGVmaW5lIElQVV9ESTFfUkVHX0JBU0UgJm5ic3A7ICZuYnNwOyAmbmJz
cDsgMHgxZTA0ODAwMDxicj4rI2RlZmluZSBJUFVfU01GQ19SRUdfQkFTRSAmbmJzcDsgJm5ic3A7
ICZuYnNwOzB4MWUwNTAwMDA8YnI+KyNkZWZpbmUgSVBVX0RDX1JFR19CQVNFICZuYnNwOyAmbmJz
cDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsweDFlMDU4MDAwPGJy
PisjZGVmaW5lIElQVV9ETUZDX1JFR19CQVNFICZuYnNwOyAmbmJzcDsgJm5ic3A7MHgxZTA2MDAw
MDxicj4rI2RlZmluZSBJUFVfQ1BNRU1fUkVHX0JBU0UgJm5ic3A7ICZuYnNwOyAweDFmMDAwMDAw
PGJyPisjZGVmaW5lIElQVV9MVVRfUkVHX0JBU0UgJm5ic3A7ICZuYnNwOyAmbmJzcDsgMHgxZjAy
MDAwMDxicj4rI2RlZmluZSBJUFVfU1JNX1JFR19CQVNFICZuYnNwOyAmbmJzcDsgJm5ic3A7IDB4
MWYwNDAwMDA8YnI+KyNkZWZpbmUgSVBVX1RQTV9SRUdfQkFTRSAmbmJzcDsgJm5ic3A7ICZuYnNw
OyAweDFmMDYwMDAwPGJyPisjZGVmaW5lIElQVV9EQ19UTVBMX1JFR19CQVNFICZuYnNwOyAweDFm
MDgwMDAwPGJyPisjZGVmaW5lIElQVV9JU1BfVEJQUl9SRUdfQkFTRSAmbmJzcDsweDFmMGMwMDAw
PGJyPisjZGVmaW5lIElQVV9WRElfUkVHX0JBU0UgJm5ic3A7ICZuYnNwOyAmbmJzcDsgMHgxZTA2
ODAwMDxicj4rPGJyPisvKiBSZWdpc3RlciBhZGRyZXNzZXMgKi88YnI+Ky8qIElQVSBDb21tb24g
cmVnaXN0ZXJzICovPGJyPisjZGVmaW5lIElQVV9DTV9SRUcob2Zmc2V0KSAmbmJzcDsgJm5ic3A7
IChvZmZzZXQpPGJyPis8YnI+KyNkZWZpbmUgSVBVX0NPTkYgJm5ic3A7ICZuYnNwOyAmbmJzcDsg
Jm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBJ
UFVfQ01fUkVHKDApPGJyPis8YnI+KyNkZWZpbmUgSVBVX1NSTV9QUkkxICZuYnNwOyAmbmJzcDsg
Jm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7IElQVV9DTV9S
RUcoMHgwMGEwKTxicj4rI2RlZmluZSBJUFVfU1JNX1BSSTIgJm5ic3A7ICZuYnNwOyAmbmJzcDsg
Jm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgSVBVX0NNX1JFRygweDAw
YTQpPGJyPisjZGVmaW5lIElQVV9GU19QUk9DX0ZMT1cxICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZu
YnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwO0lQVV9DTV9SRUcoMHgwMGE4KTxicj4rI2RlZmluZSBJ
UFVfRlNfUFJPQ19GTE9XMiAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNw
OyAmbmJzcDtJUFVfQ01fUkVHKDB4MDBhYyk8YnI+KyNkZWZpbmUgSVBVX0ZTX1BST0NfRkxPVzMg
Jm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7SVBVX0NNX1JF
RygweDAwYjApPGJyPisjZGVmaW5lIElQVV9GU19ESVNQX0ZMT1cxICZuYnNwOyAmbmJzcDsgJm5i
c3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwO0lQVV9DTV9SRUcoMHgwMGI0KTxicj4rI2Rl
ZmluZSBJUFVfRlNfRElTUF9GTE9XMiAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7
ICZuYnNwOyAmbmJzcDtJUFVfQ01fUkVHKDB4MDBiOCk8YnI+KyNkZWZpbmUgSVBVX1NLSVAgJm5i
c3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJz
cDsgJm5ic3A7ICZuYnNwOyBJUFVfQ01fUkVHKDB4MDBiYyk8YnI+KyNkZWZpbmUgSVBVX0RJU1Bf
QUxUX0NPTkYgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7
SVBVX0NNX1JFRygweDAwYzApPGJyPisjZGVmaW5lIElQVV9ESVNQX0dFTiAmbmJzcDsgJm5ic3A7
ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBJUFVfQ01f
UkVHKDB4MDBjNCk8YnI+KyNkZWZpbmUgSVBVX0RJU1BfQUxUMSAmbmJzcDsgJm5ic3A7ICZuYnNw
OyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwO0lQVV9DTV9SRUcoMHgw
MGM4KTxicj4rI2RlZmluZSBJUFVfRElTUF9BTFQyICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNw
OyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7SVBVX0NNX1JFRygweDAwY2MpPGJy
PisjZGVmaW5lIElQVV9ESVNQX0FMVDMgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNw
OyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDtJUFVfQ01fUkVHKDB4MDBkMCk8YnI+KyNkZWZp
bmUgSVBVX0RJU1BfQUxUNCAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNw
OyAmbmJzcDsgJm5ic3A7ICZuYnNwO0lQVV9DTV9SRUcoMHgwMGQ0KTxicj4rI2RlZmluZSBJUFVf
U05PT1AgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZu
YnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwO0lQVV9DTV9SRUcoMHgwMGQ4KTxicj4rI2RlZmluZSBJ
UFVfTUVNX1JTVCAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJz
cDsgJm5ic3A7ICZuYnNwOyAmbmJzcDtJUFVfQ01fUkVHKDB4MDBkYyk8YnI+KyNkZWZpbmUgSVBV
X1BNICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJz
cDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7IElQVV9DTV9SRUcoMHgwMGUwKTxicj4rI2Rl
ZmluZSBJUFVfR1BSICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZu
YnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5i
c3A7ICZuYnNwO0lQVV9DTV9SRUcoMHgwMGU0KTxicj4rI2RlZmluZSBJUFVfQ0hBX0RCX01PREVf
U0VMKGNoKSAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsg
Jm5ic3A7SVBVX0NNX1JFRygweDAxNTAgKyA0ICogKChjaCkgLyAzMikpPGJyPisjZGVmaW5lIElQ
VV9BTFRfQ0hBX0RCX01PREVfU0VMKGNoKSAmbmJzcDsgJm5ic3A7SVBVX0NNX1JFRygweDAxNjgg
KyA0ICogKChjaCkgLyAzMikpPGJyPisjZGVmaW5lIElQVV9DSEFfQ1VSX0JVRihjaCkgJm5ic3A7
ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDtJUFVfQ01fUkVHKDB4MDIzQyArIDQg
KiAoKGNoKSAvIDMyKSk8YnI+KyNkZWZpbmUgSVBVX0FMVF9DVVJfQlVGMCAmbmJzcDsgJm5ic3A7
ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgSVBVX0NNX1JFRygweDAyNDQpPGJy
PisjZGVmaW5lIElQVV9BTFRfQ1VSX0JVRjEgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZu
YnNwOyAmbmJzcDsgJm5ic3A7IElQVV9DTV9SRUcoMHgwMjQ4KTxicj4rI2RlZmluZSBJUFVfU1JN
X1NUQVQgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZu
YnNwOyAmbmJzcDsgSVBVX0NNX1JFRygweDAyNEMpPGJyPisjZGVmaW5lIElQVV9QUk9DX1RBU0tf
U1RBVCAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBJUFVfQ01fUkVH
KDB4MDI1MCk8YnI+KyNkZWZpbmUgSVBVX0RJU1BfVEFTS19TVEFUICZuYnNwOyAmbmJzcDsgJm5i
c3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7IElQVV9DTV9SRUcoMHgwMjU0KTxicj4rI2RlZmluZSBJ
UFVfQ0hBX0JVRjBfUkRZKGNoKSAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7IElQ
VV9DTV9SRUcoMHgwMjY4ICsgNCAqICgoY2gpIC8gMzIpKTxicj4rI2RlZmluZSBJUFVfQ0hBX0JV
RjFfUkRZKGNoKSAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7IElQVV9DTV9SRUco
MHgwMjcwICsgNCAqICgoY2gpIC8gMzIpKTxicj4rI2RlZmluZSBJUFVfQUxUX0NIQV9CVUYwX1JE
WShjaCkgJm5ic3A7ICZuYnNwOyAmbmJzcDsgSVBVX0NNX1JFRygweDAyNzggKyA0ICogKChjaCkg
LyAzMikpPGJyPisjZGVmaW5lIElQVV9BTFRfQ0hBX0JVRjFfUkRZKGNoKSAmbmJzcDsgJm5ic3A7
ICZuYnNwOyBJUFVfQ01fUkVHKDB4MDI4MCArIDQgKiAoKGNoKSAvIDMyKSk8YnI+Kzxicj4rI2Rl
ZmluZSBJUFVfSU5UX0NUUkwobikgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAm
bmJzcDsgJm5ic3A7ICZuYnNwO0lQVV9DTV9SRUcoMHgwMDNDICsgNCAqICgobikgLSAxKSk8YnI+
KyNkZWZpbmUgSVBVX0lOVF9DVFJMX0lSUShpcnEpICZuYnNwO0lQVV9JTlRfQ1RSTCgoKGlycSkg
LyAzMikpPGJyPisjZGVmaW5lIElQVV9JTlRfU1RBVF9JUlEoaXJxKSAmbmJzcDtJUFVfSU5UX1NU
QVQoKChpcnEpIC8gMzIpKTxicj4rI2RlZmluZSBJUFVfSU5UX1NUQVQobikgJm5ic3A7ICZuYnNw
OyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwO0lQVV9DTV9SRUcoMHgw
MjAwICsgNCAqICgobikgLSAxKSk8YnI+Kzxicj4rZXh0ZXJuIHZvaWQgX19pb21lbSAqaXB1X2Nt
X3JlZzs8YnI+Kzxicj4rc3RhdGljIGlubGluZSB1MzIgaXB1X2NtX3JlYWQodW5zaWduZWQgb2Zm
c2V0KTxicj4rezxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7IHJldHVybiBfX3Jhd19yZWFkbChp
cHVfY21fcmVnICsgb2Zmc2V0KTs8YnI+K308YnI+Kzxicj4rc3RhdGljIGlubGluZSB2b2lkIGlw
dV9jbV93cml0ZSh1MzIgdmFsdWUsIHVuc2lnbmVkIG9mZnNldCk8YnI+K3s8YnI+KyAmbmJzcDsg
Jm5ic3A7ICZuYnNwOyBfX3Jhd193cml0ZWwodmFsdWUsIGlwdV9jbV9yZWcgKyBvZmZzZXQpOzxi
cj4rfTxicj4rPGJyPisjZGVmaW5lIElQVV9JRE1BQ19SRUcob2Zmc2V0KSAmbmJzcDsob2Zmc2V0
KTxicj4rPGJyPisjZGVmaW5lIElETUFDX0NPTkYgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7
ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7IElQVV9JRE1BQ19SRUco
MHgwMDAwKTxicj4rI2RlZmluZSBJRE1BQ19DSEFfRU4oY2gpICZuYnNwOyAmbmJzcDsgJm5ic3A7
ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBJUFVfSURNQUNfUkVHKDB4MDAwNCArIDQgKiAo
KGNoKSAvIDMyKSk8YnI+KyNkZWZpbmUgSURNQUNfU0VQX0FMUEhBICZuYnNwOyAmbmJzcDsgJm5i
c3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJz
cDsgJm5ic3A7SVBVX0lETUFDX1JFRygweDAwMGMpPGJyPisjZGVmaW5lIElETUFDX0FMVF9TRVBf
QUxQSEEgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDtJUFVfSURNQUNf
UkVHKDB4MDAxMCk8YnI+KyNkZWZpbmUgSURNQUNfQ0hBX1BSSShjaCkgJm5ic3A7ICZuYnNwOyAm
bmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7SVBVX0lETUFDX1JFRygweDAwMTQgKyA0
ICogKChjaCkgLyAzMikpPGJyPisjZGVmaW5lIElETUFDX1dNX0VOKGNoKSAmbmJzcDsgJm5ic3A7
ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsg
Jm5ic3A7ICZuYnNwO0lQVV9JRE1BQ19SRUcoMHgwMDFjICsgNCAqICgoY2gpIC8gMzIpKTxicj4r
I2RlZmluZSBJRE1BQ19DSF9MT0NLX0VOXzEgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZu
YnNwOyAmbmJzcDsgSVBVX0lETUFDX1JFRygweDAwMjQpPGJyPisjZGVmaW5lIElETUFDX0NIX0xP
Q0tfRU5fMiAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBJUFVfSURN
QUNfUkVHKDB4MDAyOCk8YnI+KyNkZWZpbmUgSURNQUNfU1VCX0FERFJfMCAmbmJzcDsgJm5ic3A7
ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgSVBVX0lETUFDX1JFRygweDAwMmMp
PGJyPisjZGVmaW5lIElETUFDX1NVQl9BRERSXzEgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7
ICZuYnNwOyAmbmJzcDsgJm5ic3A7IElQVV9JRE1BQ19SRUcoMHgwMDMwKTxicj4rI2RlZmluZSBJ
RE1BQ19TVUJfQUREUl8yICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7
ICZuYnNwOyBJUFVfSURNQUNfUkVHKDB4MDAzNCk8YnI+KyNkZWZpbmUgSURNQUNfQkFORF9FTihj
aCkgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7SVBVX0lE
TUFDX1JFRygweDAwNDAgKyA0ICogKChjaCkgLyAzMikpPGJyPisjZGVmaW5lIElETUFDX0NIQV9C
VVNZKGNoKSAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBJUFVfSURN
QUNfUkVHKDB4MDEwMCArIDQgKiAoKGNoKSAvIDMyKSk8YnI+Kzxicj4rZXh0ZXJuIHZvaWQgX19p
b21lbSAqaXB1X2lkbWFjX3JlZzs8YnI+Kzxicj4rc3RhdGljIGlubGluZSB1MzIgaXB1X2lkbWFj
X3JlYWQodW5zaWduZWQgb2Zmc2V0KTxicj4rezxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7IHJl
dHVybiBfX3Jhd19yZWFkbChpcHVfaWRtYWNfcmVnICsgb2Zmc2V0KTs8YnI+K308YnI+Kzxicj4r
c3RhdGljIGlubGluZSB2b2lkIGlwdV9pZG1hY193cml0ZSh1MzIgdmFsdWUsIHVuc2lnbmVkIG9m
ZnNldCk8YnI+K3s8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBfX3Jhd193cml0ZWwodmFsdWUs
IGlwdV9pZG1hY19yZWcgKyBvZmZzZXQpOzxicj4rfTxicj4rPGJyPisjZGVmaW5lIGlkbWFjX2lk
bWFfaXNfc2V0KHJlZywgZG1hKSAmbmJzcDsgJm5ic3A7KGlwdV9pZG1hY19yZWFkKHJlZyhkbWEp
KSAmYW1wOyBpZG1hX21hc2soZG1hKSk8YnI+KyNkZWZpbmUgaWRtYV9tYXNrKGNoKSAmbmJzcDsg
Jm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOygx
ICZsdDsmbHQ7IChjaCAmYW1wOyAweDFmKSk8YnI+KyNkZWZpbmUgaXB1X2lkbWFfaXNfc2V0KHJl
ZywgZG1hKSAmbmJzcDsgJm5ic3A7ICZuYnNwOyhpcHVfY21fcmVhZChyZWcoZG1hKSkgJmFtcDsg
aWRtYV9tYXNrKGRtYSkpPGJyPis8YnI+K2VudW0gaXB1X21vZHVsZXMgezxicj4rICZuYnNwOyAm
bmJzcDsgJm5ic3A7IElQVV9DT05GX0NTSTBfRU4gJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7
ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOz0gKDEgJmx0OyZsdDsgMCksPGJyPisgJm5ic3A7
ICZuYnNwOyAmbmJzcDsgSVBVX0NPTkZfQ1NJMV9FTiAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJz
cDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7PSAoMSAmbHQ7Jmx0OyAxKSw8YnI+KyAmbmJz
cDsgJm5ic3A7ICZuYnNwOyBJUFVfQ09ORl9JQ19FTiAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJz
cDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOz0gKDEgJmx0OyZsdDsgMiksPGJy
PisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgSVBVX0NPTkZfUk9UX0VOICZuYnNwOyAmbmJzcDsgJm5i
c3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgPSAoMSAmbHQ7Jmx0OyAzKSw8
YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBJUFVfQ09ORl9JU1BfRU4gJm5ic3A7ICZuYnNwOyAm
bmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyA9ICgxICZsdDsmbHQ7IDQp
LDxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7IElQVV9DT05GX0RQX0VOICZuYnNwOyAmbmJzcDsg
Jm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7PSAoMSAmbHQ7
Jmx0OyA1KSw8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBJUFVfQ09ORl9ESTBfRU4gJm5ic3A7
ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyA9ICgxICZs
dDsmbHQ7IDYpLDxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7IElQVV9DT05GX0RJMV9FTiAmbmJz
cDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ID0gKDEg
Jmx0OyZsdDsgNyksPGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgSVBVX0NPTkZfU01GQ19FTiAm
bmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7PSAo
MSAmbHQ7Jmx0OyA4KSw8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBJUFVfQ09ORl9EQ19FTiAm
bmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZu
YnNwOz0gKDEgJmx0OyZsdDsgOSksPGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgSVBVX0NPTkZf
RE1GQ19FTiAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsg
Jm5ic3A7PSAoMSAmbHQ7Jmx0OyAxMCksPGJyPis8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBJ
UFVfQ09ORl9WRElfRU4gJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsg
Jm5ic3A7ICZuYnNwOyA9ICgxICZsdDsmbHQ7IDEyKSw8YnI+Kzxicj4rICZuYnNwOyAmbmJzcDsg
Jm5ic3A7IElQVV9DT05GX0lETUFDX0RJUyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5i
c3A7ICZuYnNwOyAmbmJzcDs9ICgxICZsdDsmbHQ7IDIyKSw8YnI+Kzxicj4rICZuYnNwOyAmbmJz
cDsgJm5ic3A7IElQVV9DT05GX0lDX0RNRkNfU0VMICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNw
OyAmbmJzcDsgJm5ic3A7PSAoMSAmbHQ7Jmx0OyAyNSksPGJyPisgJm5ic3A7ICZuYnNwOyAmbmJz
cDsgSVBVX0NPTkZfSUNfRE1GQ19TWU5DICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJz
cDsgPSAoMSAmbHQ7Jmx0OyAyNiksPGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgSVBVX0NPTkZf
VkRJX0RNRkNfU1lOQyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7PSAoMSAmbHQ7
Jmx0OyAyNyksPGJyPis8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBJUFVfQ09ORl9DU0kwX0RB
VEFfU09VUkNFICZuYnNwOyAmbmJzcDsgJm5ic3A7ID0gKDEgJmx0OyZsdDsgMjgpLDxicj4rICZu
YnNwOyAmbmJzcDsgJm5ic3A7IElQVV9DT05GX0NTSTFfREFUQV9TT1VSQ0UgJm5ic3A7ICZuYnNw
OyAmbmJzcDsgPSAoMSAmbHQ7Jmx0OyAyOSksPGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgSVBV
X0NPTkZfSUNfSU5QVVQgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsg
Jm5ic3A7ID0gKDEgJmx0OyZsdDsgMzApLDxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7IElQVV9D
T05GX0NTSV9TRUwgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5i
c3A7ICZuYnNwOz0gKDEgJmx0OyZsdDsgMzEpLDxicj4rfTs8YnI+Kzxicj4rc3RydWN0IGlwdV9j
aGFubmVsIHs8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyB1bnNpZ25lZCBpbnQgbnVtOzxicj4r
PGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgYm9vbCBlbmFibGVkOzxicj4rICZuYnNwOyAmbmJz
cDsgJm5ic3A7IGJvb2wgYnVzeTs8YnI+K307PGJyPis8YnI+K2lwdV9jb2xvcl9zcGFjZV90IGZv
cm1hdF90b19jb2xvcnNwYWNlKHUzMiBmbXQpOzxicj4rYm9vbCBpcHVfcGl4ZWxfZm9ybWF0X2hh
c19hbHBoYSh1MzIgZm10KTs8YnI+Kzxicj4rdTMyIF9pcHVfY2hhbm5lbF9zdGF0dXMoc3RydWN0
IGlwdV9jaGFubmVsICpjaGFubmVsKTs8YnI+Kzxicj4raW50IF9pcHVfY2hhbl9pc19pbnRlcmxh
Y2VkKHN0cnVjdCBpcHVfY2hhbm5lbCAqY2hhbm5lbCk7PGJyPis8YnI+K2ludCBpcHVfbW9kdWxl
X2VuYWJsZSh1MzIgbWFzayk7PGJyPitpbnQgaXB1X21vZHVsZV9kaXNhYmxlKHUzMiBtYXNrKTs8
YnI+Kzxicj4raW50IGlwdV9kaV9pbml0KHN0cnVjdCBwbGF0Zm9ybV9kZXZpY2UgKnBkZXYsIGlu
dCBpZCwgdW5zaWduZWQgbG9uZyBiYXNlLDxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNw
OyAmbmJzcDsgJm5ic3A7ICZuYnNwOyB1MzIgbW9kdWxlLCBzdHJ1Y3QgY2xrICppcHVfY2xrKTs8
YnI+K3ZvaWQgaXB1X2RpX2V4aXQoc3RydWN0IHBsYXRmb3JtX2RldmljZSAqcGRldiwgaW50IGlk
KTs8YnI+Kzxicj4raW50IGlwdV9kbWZjX2luaXQoc3RydWN0IHBsYXRmb3JtX2RldmljZSAqcGRl
diwgdW5zaWduZWQgbG9uZyBiYXNlLDxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAm
bmJzcDsgJm5ic3A7ICZuYnNwOyBzdHJ1Y3QgY2xrICppcHVfY2xrKTs8YnI+K3ZvaWQgaXB1X2Rt
ZmNfZXhpdChzdHJ1Y3QgcGxhdGZvcm1fZGV2aWNlICpwZGV2KTs8YnI+Kzxicj4raW50IGlwdV9k
cF9pbml0KHN0cnVjdCBwbGF0Zm9ybV9kZXZpY2UgKnBkZXYsIHVuc2lnbmVkIGxvbmcgYmFzZSk7
PGJyPit2b2lkIGlwdV9kcF9leGl0KHN0cnVjdCBwbGF0Zm9ybV9kZXZpY2UgKnBkZXYpOzxicj4r
PGJyPitpbnQgaXB1X2RjX2luaXQoc3RydWN0IHBsYXRmb3JtX2RldmljZSAqcGRldiwgdW5zaWdu
ZWQgbG9uZyBiYXNlLDxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5i
c3A7ICZuYnNwOyB1bnNpZ25lZCBsb25nIHRlbXBsYXRlX2Jhc2UpOzxicj4rdm9pZCBpcHVfZGNf
ZXhpdChzdHJ1Y3QgcGxhdGZvcm1fZGV2aWNlICpwZGV2KTs8YnI+Kzxicj4raW50IGlwdV9jcG1l
bV9pbml0KHN0cnVjdCBwbGF0Zm9ybV9kZXZpY2UgKnBkZXYsIHVuc2lnbmVkIGxvbmcgYmFzZSk7
PGJyPit2b2lkIGlwdV9jcG1lbV9leGl0KHN0cnVjdCBwbGF0Zm9ybV9kZXZpY2UgKnBkZXYpOzxi
cj4rPGJyPisjZW5kaWYgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsg
Jm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgLyogX19JUFVfUFJWX0hf
XyAqLzxicj5kaWZmIC0tZ2l0IGEvaW5jbHVkZS9saW51eC9tZmQvaW14LWlwdS12My5oIGIvaW5j
bHVkZS9saW51eC9tZmQvaW14LWlwdS12My5oPGJyPm5ldyBmaWxlIG1vZGUgMTAwNjQ0PGJyPmlu
ZGV4IDAwMDAwMDAuLjAyODhjNTE8YnI+LS0tIC9kZXYvbnVsbDxicj4rKysgYi9pbmNsdWRlL2xp
bnV4L21mZC9pbXgtaXB1LXYzLmg8YnI+QEAgLTAsMCArMSwyMTggQEA8YnI+Ky8qPGJyPisgKiBD
b3B5cmlnaHQgMjAwNS0yMDA5IEZyZWVzY2FsZSBTZW1pY29uZHVjdG9yLCBJbmMuPGJyPisgKjxi
cj4rICogVGhlIGNvZGUgY29udGFpbmVkIGhlcmVpbiBpcyBsaWNlbnNlZCB1bmRlciB0aGUgR05V
IExlc3NlciBHZW5lcmFsPGJyPisgKiBQdWJsaWMgTGljZW5zZS4gJm5ic3A7WW91IG1heSBvYnRh
aW4gYSBjb3B5IG9mIHRoZSBHTlUgTGVzc2VyIEdlbmVyYWw8YnI+KyAqIFB1YmxpYyBMaWNlbnNl
IFZlcnNpb24gMi4xIG9yIGxhdGVyIGF0IHRoZSBmb2xsb3dpbmcgbG9jYXRpb25zOjxicj4rICo8
YnI+KyAqIDxhIGhyZWY9Imh0dHA6Ly93d3cub3BlbnNvdXJjZS5vcmcvbGljZW5zZXMvbGdwbC1s
aWNlbnNlLmh0bWwiIHRhcmdldD0iX2JsYW5rIj5odHRwOi8vd3d3Lm9wZW5zb3VyY2Uub3JnL2xp
Y2Vuc2VzL2xncGwtbGljZW5zZS5odG1sPC9hPjxicj4rICogPGEgaHJlZj0iaHR0cDovL3d3dy5n
bnUub3JnL2NvcHlsZWZ0L2xncGwuaHRtbCIgdGFyZ2V0PSJfYmxhbmsiPmh0dHA6Ly93d3cuZ251
Lm9yZy9jb3B5bGVmdC9sZ3BsLmh0bWw8L2E+PGJyPisgKi88YnI+Kzxicj4rI2lmbmRlZiBfX0FT
TV9BUkNIX0lQVV9IX188YnI+KyNkZWZpbmUgX19BU01fQVJDSF9JUFVfSF9fPGJyPis8YnI+KyNp
bmNsdWRlICZsdDtsaW51eC9zbGFiLmgmZ3Q7PGJyPisjaW5jbHVkZSAmbHQ7bGludXgvdHlwZXMu
aCZndDs8YnI+KyNpbmNsdWRlICZsdDtsaW51eC92aWRlb2RldjIuaCZndDs8YnI+KyNpbmNsdWRl
ICZsdDtsaW51eC9pbnRlcnJ1cHQuaCZndDs8YnI+KyNpbmNsdWRlICZsdDtsaW51eC9iaXRtYXAu
aCZndDs8YnI+Kzxicj4rLyo8YnI+KyAqIEVudW1lcmF0aW9uIG9mIElQVSByb3RhdGlvbiBtb2Rl
czxicj4rICovPGJyPit0eXBlZGVmIGVudW0gezxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7IC8q
IE5vdGUgdGhlIGVudW0gdmFsdWVzIGNvcnJlc3BvbmQgdG8gQkFNIHZhbHVlICovPGJyPisgJm5i
c3A7ICZuYnNwOyAmbmJzcDsgSVBVX1JPVEFURV9OT05FID0gMCw8YnI+KyAmbmJzcDsgJm5ic3A7
ICZuYnNwOyBJUFVfUk9UQVRFX1ZFUlRfRkxJUCA9IDEsPGJyPisgJm5ic3A7ICZuYnNwOyAmbmJz
cDsgSVBVX1JPVEFURV9IT1JJWl9GTElQID0gMiw8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBJ
UFVfUk9UQVRFXzE4MCA9IDMsPGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgSVBVX1JPVEFURV85
MF9SSUdIVCA9IDQsPGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgSVBVX1JPVEFURV85MF9SSUdI
VF9WRkxJUCA9IDUsPGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgSVBVX1JPVEFURV85MF9SSUdI
VF9IRkxJUCA9IDYsPGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgSVBVX1JPVEFURV85MF9MRUZU
ID0gNyw8YnI+K30gaXB1X3JvdGF0ZV9tb2RlX3Q7PGJyPis8YnI+Ky8qPGJyPisgKiBJUFUgUGl4
ZWwgRm9ybWF0czxicj4rICo8YnI+KyAqIFBpeGVsIGZvcm1hdHMgYXJlIGRlZmluZWQgd2l0aCBB
U0NJSSBGT1VSQ0MgY29kZS4gVGhlIHBpeGVsIGZvcm1hdCBjb2RlcyBhcmU8YnI+KyAqIHRoZSBz
YW1lIHVzZWQgYnkgVjRMMiBBUEkuPGJyPisgKi88YnI+Kzxicj4rLyogR2VuZXJpYyBvciBSYXcg
RGF0YSBGb3JtYXRzICovPGJyPisjZGVmaW5lIElQVV9QSVhfRk1UX0dFTkVSSUMgdjRsMl9mb3Vy
Y2MoJ0knLCAnUCcsICdVJywgJzAnKSAmbmJzcDsgJm5ic3A7LyogSVBVIEdlbmVyaWMgRGF0YSAq
Lzxicj4rI2RlZmluZSBJUFVfUElYX0ZNVF9HRU5FUklDXzMyIHY0bDJfZm91cmNjKCdJJywgJ1An
LCAnVScsICcxJykgLyogSVBVIEdlbmVyaWMgRGF0YSAqLzxicj4rI2RlZmluZSBJUFVfUElYX0ZN
VF9MVkRTNjY2IHY0bDJfZm91cmNjKCdMJywgJ1YnLCAnRCcsICc2JykgJm5ic3A7ICZuYnNwOy8q
IElQVSBHZW5lcmljIERhdGEgKi88YnI+KyNkZWZpbmUgSVBVX1BJWF9GTVRfTFZEUzg4OCB2NGwy
X2ZvdXJjYygnTCcsICdWJywgJ0QnLCAnOCcpICZuYnNwOyAmbmJzcDsvKiBJUFUgR2VuZXJpYyBE
YXRhICovPGJyPisvKiBSR0IgRm9ybWF0cyAqLzxicj4rI2RlZmluZSBJUFVfUElYX0ZNVF9SR0Iz
MzIgJm5ic3A7VjRMMl9QSVhfRk1UX1JHQjMzMiAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsg
Jm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOy8q
ICZuYnNwOzggJm5ic3A7UkdCLTMtMy0yICZuYnNwOyAmbmJzcDsqLzxicj4rI2RlZmluZSBJUFVf
UElYX0ZNVF9SR0I1NTUgJm5ic3A7VjRMMl9QSVhfRk1UX1JHQjU1NSAmbmJzcDsgJm5ic3A7ICZu
YnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5i
c3A7ICZuYnNwOy8qIDE2ICZuYnNwO1JHQi01LTUtNSAmbmJzcDsgJm5ic3A7Ki88YnI+KyNkZWZp
bmUgSVBVX1BJWF9GTVRfUkdCNTY1ICZuYnNwO1Y0TDJfUElYX0ZNVF9SR0I1NjUgJm5ic3A7ICZu
YnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5i
c3A7ICZuYnNwOyAmbmJzcDsvKiAxIDYgJm5ic3A7UkdCLTUtNi01ICZuYnNwOyAqLzxicj4rI2Rl
ZmluZSBJUFVfUElYX0ZNVF9SR0I2NjYgJm5ic3A7djRsMl9mb3VyY2MoJ1InLCAnRycsICdCJywg
JzYnKSAmbmJzcDsgJm5ic3A7LyogMTggJm5ic3A7UkdCLTYtNi02ICZuYnNwOyAmbmJzcDsqLzxi
cj4rI2RlZmluZSBJUFVfUElYX0ZNVF9CR1I2NjYgJm5ic3A7djRsMl9mb3VyY2MoJ0InLCAnRycs
ICdSJywgJzYnKSAmbmJzcDsgJm5ic3A7LyogMTggJm5ic3A7QkdSLTYtNi02ICZuYnNwOyAmbmJz
cDsqLzxicj4rI2RlZmluZSBJUFVfUElYX0ZNVF9CR1IyNCAmbmJzcDsgVjRMMl9QSVhfRk1UX0JH
UjI0ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJz
cDsgLyogMjQgJm5ic3A7QkdSLTgtOC04ICZuYnNwOyAmbmJzcDsqLzxicj4rI2RlZmluZSBJUFVf
UElYX0ZNVF9SR0IyNCAmbmJzcDsgVjRMMl9QSVhfRk1UX1JHQjI0ICZuYnNwOyAmbmJzcDsgJm5i
c3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgLyogMjQgJm5ic3A7UkdCLTgt
OC04ICZuYnNwOyAmbmJzcDsqLzxicj4rI2RlZmluZSBJUFVfUElYX0ZNVF9CR1IzMiAmbmJzcDsg
VjRMMl9QSVhfRk1UX0JHUjMyICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5i
c3A7ICZuYnNwOyAmbmJzcDsgLyogMzIgJm5ic3A7QkdSLTgtOC04LTggJm5ic3A7Ki88YnI+KyNk
ZWZpbmUgSVBVX1BJWF9GTVRfQkdSQTMyICZuYnNwO3Y0bDJfZm91cmNjKCdCJywgJ0cnLCAnUics
ICdBJykgJm5ic3A7ICZuYnNwOy8qIDMyICZuYnNwO0JHUi04LTgtOC04ICZuYnNwOyovPGJyPisj
ZGVmaW5lIElQVV9QSVhfRk1UX1JHQjMyICZuYnNwOyBWNEwyX1BJWF9GTVRfUkdCMzIgJm5ic3A7
ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAvKiAzMiAm
bmJzcDtSR0ItOC04LTgtOCAmbmJzcDsqLzxicj4rI2RlZmluZSBJUFVfUElYX0ZNVF9SR0JBMzIg
Jm5ic3A7djRsMl9mb3VyY2MoJ1InLCAnRycsICdCJywgJ0EnKSAmbmJzcDsgJm5ic3A7LyogMzIg
Jm5ic3A7UkdCLTgtOC04LTggJm5ic3A7Ki88YnI+KyNkZWZpbmUgSVBVX1BJWF9GTVRfQUJHUjMy
ICZuYnNwO3Y0bDJfZm91cmNjKCdBJywgJ0InLCAnRycsICdSJykgJm5ic3A7ICZuYnNwOy8qIDMy
ICZuYnNwO0FCR1ItOC04LTgtOCAqLzxicj4rLyogWVVWIEludGVybGVhdmVkIEZvcm1hdHMgKi88
YnI+KyNkZWZpbmUgSVBVX1BJWF9GTVRfWVVZViAmbmJzcDsgJm5ic3A7VjRMMl9QSVhfRk1UX1lV
WVYgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNw
OyAmbmJzcDsvKiAxNiBZVVYgNDoyOjIgKi88YnI+KyNkZWZpbmUgSVBVX1BJWF9GTVRfVVlWWSAm
bmJzcDsgJm5ic3A7VjRMMl9QSVhfRk1UX1VZVlkgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7
ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsvKiAxNiBZVVYgNDoyOjIgKi88YnI+
KyNkZWZpbmUgSVBVX1BJWF9GTVRfWTQxUCAmbmJzcDsgJm5ic3A7VjRMMl9QSVhfRk1UX1k0MVAg
Jm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAm
bmJzcDsvKiAxMiBZVVYgNDoxOjEgKi88YnI+KyNkZWZpbmUgSVBVX1BJWF9GTVRfWVVWNDQ0ICZu
YnNwO1Y0TDJfUElYX0ZNVF9ZVVY0NDQgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNw
OyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsvKiAyNCBZ
VVYgNDo0OjQgKi88YnI+Ky8qIHR3byBwbGFuZXMgLS0gb25lIFksIG9uZSBDYiArIENyIGludGVy
bGVhdmVkICZuYnNwOyovPGJyPisjZGVmaW5lIElQVV9QSVhfRk1UX05WMTIgJm5ic3A7ICZuYnNw
O1Y0TDJfUElYX0ZNVF9OVjEyICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5i
c3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7LyogMTIgJm5ic3A7WS9DYkNyIDQ6MjowICZuYnNwOyov
PGJyPisvKiBZVVYgUGxhbmFyIEZvcm1hdHMgKi88YnI+KyNkZWZpbmUgSVBVX1BJWF9GTVRfR1JF
WSAmbmJzcDsgJm5ic3A7VjRMMl9QSVhfRk1UX0dSRVkgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5i
c3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsvKiA4ICZuYnNwO0dyZXlzY2Fs
ZSAqLzxicj4rI2RlZmluZSBJUFVfUElYX0ZNVF9ZVlU0MTBQIFY0TDJfUElYX0ZNVF9ZVlU0MTBQ
ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAvKiA5ICZu
YnNwO1lWVSA0OjE6MCAqLzxicj4rI2RlZmluZSBJUFVfUElYX0ZNVF9ZVVY0MTBQIFY0TDJfUElY
X0ZNVF9ZVVY0MTBQICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZu
YnNwOyAvKiA5ICZuYnNwO1lVViA0OjE6MCAqLzxicj4rI2RlZmluZSBJUFVfUElYX0ZNVF9ZVlU0
MjBQIHY0bDJfZm91cmNjKCdZJywgJ1YnLCAnMScsICcyJykgJm5ic3A7ICZuYnNwOy8qIDEyIFlW
VSA0OjI6MCAqLzxicj4rI2RlZmluZSBJUFVfUElYX0ZNVF9ZVVY0MjBQIHY0bDJfZm91cmNjKCdJ
JywgJzQnLCAnMicsICcwJykgJm5ic3A7ICZuYnNwOy8qIDEyIFlVViA0OjI6MCAqLzxicj4rI2Rl
ZmluZSBJUFVfUElYX0ZNVF9ZVVY0MjBQMiB2NGwyX2ZvdXJjYygnWScsICdVJywgJzEnLCAnMicp
ICZuYnNwOyAvKiAxMiBZVVYgNDoyOjAgKi88YnI+KyNkZWZpbmUgSVBVX1BJWF9GTVRfWVZVNDIy
UCB2NGwyX2ZvdXJjYygnWScsICdWJywgJzEnLCAnNicpICZuYnNwOyAmbmJzcDsvKiAxNiBZVlUg
NDoyOjIgKi88YnI+KyNkZWZpbmUgSVBVX1BJWF9GTVRfWVVWNDIyUCBWNEwyX1BJWF9GTVRfWVVW
NDIyUCAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgLyog
MTYgWVVWIDQ6MjoyICovPGJyPis8YnI+Ky8qPGJyPisgKiBCaXRmaWVsZCBvZiBEaXNwbGF5IElu
dGVyZmFjZSBzaWduYWwgcG9sYXJpdGllcy48YnI+KyAqLzxicj4rc3RydWN0IGlwdV9kaV9zaWdu
YWxfY2ZnIHs8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyB1bnNpZ25lZCBkYXRhbWFza19lbjox
Ozxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7IHVuc2lnbmVkIGV4dF9jbGs6MTs8YnI+KyAmbmJz
cDsgJm5ic3A7ICZuYnNwOyB1bnNpZ25lZCBpbnRlcmxhY2VkOjE7PGJyPisgJm5ic3A7ICZuYnNw
OyAmbmJzcDsgdW5zaWduZWQgb2RkX2ZpZWxkX2ZpcnN0OjE7PGJyPisgJm5ic3A7ICZuYnNwOyAm
bmJzcDsgdW5zaWduZWQgY2xrc2VsX2VuOjE7PGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgdW5z
aWduZWQgY2xraWRsZV9lbjoxOzxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7IHVuc2lnbmVkIGRh
dGFfcG9sOjE7ICZuYnNwOyAmbmJzcDsvKiB0cnVlID0gaW52ZXJ0ZWQgKi88YnI+KyAmbmJzcDsg
Jm5ic3A7ICZuYnNwOyB1bnNpZ25lZCBjbGtfcG9sOjE7ICZuYnNwOyAmbmJzcDsgLyogdHJ1ZSA9
IHJpc2luZyBlZGdlICovPGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgdW5zaWduZWQgZW5hYmxl
X3BvbDoxOzxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7IHVuc2lnbmVkIEhzeW5jX3BvbDoxOyAm
bmJzcDsgLyogdHJ1ZSA9IGFjdGl2ZSBoaWdoICovPGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsg
dW5zaWduZWQgVnN5bmNfcG9sOjE7PGJyPis8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyB1MTYg
d2lkdGg7PGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgdTE2IGhlaWdodDs8YnI+KyAmbmJzcDsg
Jm5ic3A7ICZuYnNwOyB1MzIgcGl4ZWxfZm10Ozxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7IHUx
NiBoX3N0YXJ0X3dpZHRoOzxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7IHUxNiBoX3N5bmNfd2lk
dGg7PGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgdTE2IGhfZW5kX3dpZHRoOzxicj4rICZuYnNw
OyAmbmJzcDsgJm5ic3A7IHUxNiB2X3N0YXJ0X3dpZHRoOzxicj4rICZuYnNwOyAmbmJzcDsgJm5i
c3A7IHUxNiB2X3N5bmNfd2lkdGg7PGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgdTE2IHZfZW5k
X3dpZHRoOzxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7IHUzMiB2X3RvX2hfc3luYzs8YnI+K307
PGJyPis8YnI+K3R5cGVkZWYgZW51bSB7PGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgUkdCLDxi
cj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7IFlDYkNyLDxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7
IFlVVjxicj4rfSBpcHVfY29sb3Jfc3BhY2VfdDs8YnI+Kzxicj4rI2RlZmluZSBJUFVfSVJRX0VP
RihjaGFubmVsKSAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7IChjaGFubmVsKSAm
bmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgLyogMCAuLiA2
MyAqLzxicj4rI2RlZmluZSBJUFVfSVJRX05GQUNLKGNoYW5uZWwpICZuYnNwOyAmbmJzcDsgJm5i
c3A7ICZuYnNwOyAoKGNoYW5uZWwpICsgNjQpICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOy8q
IDY0IC4uIDEyNyAqLzxicj4rI2RlZmluZSBJUFVfSVJRX05GQjRFT0YoY2hhbm5lbCkgJm5ic3A7
ICZuYnNwOyAmbmJzcDsgKChjaGFubmVsKSArIDEyOCkgJm5ic3A7ICZuYnNwOyAmbmJzcDsgLyog
MTI4IC4uIDE5MSAqLzxicj4rI2RlZmluZSBJUFVfSVJRX0VPUyhjaGFubmVsKSAmbmJzcDsgJm5i
c3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICgoY2hhbm5lbCkgKyAxOTIpICZuYnNwOyAmbmJzcDsg
Jm5ic3A7IC8qIDE5MiAuLiAyNTUgKi88YnI+Kzxicj4rI2RlZmluZSBJUFVfSVJRX0RQX1NGX1NU
QVJUICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7KDQ0OCArIDIpPGJy
PisjZGVmaW5lIElQVV9JUlFfRFBfU0ZfRU5EICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAm
bmJzcDsgJm5ic3A7ICZuYnNwOyg0NDggKyAzKTxicj4rI2RlZmluZSBJUFVfSVJRX0JHX1NGX0VO
RCAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDtJUFVfSVJR
X0RQX1NGX0VORCw8YnI+KyNkZWZpbmUgSVBVX0lSUV9EQ19GQ18wICZuYnNwOyAmbmJzcDsgJm5i
c3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJz
cDsgJm5ic3A7KDQ0OCArIDgpPGJyPisjZGVmaW5lIElQVV9JUlFfRENfRkNfMSAmbmJzcDsgJm5i
c3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJz
cDsgJm5ic3A7ICZuYnNwOyg0NDggKyA5KTxicj4rI2RlZmluZSBJUFVfSVJRX0RDX0ZDXzIgJm5i
c3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJz
cDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsoNDQ4ICsgMTApPGJyPisjZGVmaW5lIElQVV9JUlFfRENf
RkNfMyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5i
c3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyg0NDggKyAxMSk8YnI+KyNkZWZpbmUgSVBV
X0lSUV9EQ19GQ180ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZu
YnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7KDQ0OCArIDEyKTxicj4rI2Rl
ZmluZSBJUFVfSVJRX0RDX0ZDXzYgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAm
bmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsoNDQ4ICsgMTMp
PGJyPisjZGVmaW5lIElQVV9JUlFfVlNZTkNfUFJFXzAgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5i
c3A7ICZuYnNwOyAmbmJzcDsoNDQ4ICsgMTQpPGJyPisjZGVmaW5lIElQVV9JUlFfVlNZTkNfUFJF
XzEgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsoNDQ4ICsgMTUpPGJy
Pis8YnI+KyNkZWZpbmUgSVBVX0lSUV9DT1VOVCAmbmJzcDsoMTUgKiAzMik8YnI+Kzxicj4rI2Rl
ZmluZSBERUNMQVJFX0lQVV9JUlFfQklUTUFQKG5hbWUpICZuYnNwOyBERUNMQVJFX0JJVE1BUChu
YW1lLCBJUFVfSVJRX0NPVU5UKTxicj4rPGJyPitzdHJ1Y3QgaXB1X2lycV9oYW5kbGVyIHs8YnI+
KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBzdHJ1Y3QgbGlzdF9oZWFkICZuYnNwOyAmbmJzcDsgJm5i
c3A7ICZuYnNwO2xpc3Q7PGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgdm9pZCAmbmJzcDsgJm5i
c3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJz
cDsoKmhhbmRsZXIpKHVuc2lnbmVkIGxvbmcgKiwgdm9pZCAqKTs8YnI+KyAmbmJzcDsgJm5ic3A7
ICZuYnNwOyB2b2lkICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZu
YnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOypjb250ZXh0Ozxicj4rICZuYnNwOyAmbmJzcDsgJm5i
c3A7IERFQ0xBUkVfSVBVX0lSUV9CSVRNQVAoaXB1X2lycXMpOzxicj4rfTs8YnI+Kzxicj4raW50
IGlwdV9pcnFfYWRkX2hhbmRsZXIoc3RydWN0IGlwdV9pcnFfaGFuZGxlciAqaXB1aXJxKTs8YnI+
K3ZvaWQgaXB1X2lycV9yZW1vdmVfaGFuZGxlcihzdHJ1Y3QgaXB1X2lycV9oYW5kbGVyICpoYW5k
bGVyKTs8YnI+K2ludCBpcHVfaXJxX3VwZGF0ZV9oYW5kbGVyKHN0cnVjdCBpcHVfaXJxX2hhbmRs
ZXIgKmhhbmRsZXIsPGJyPisgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJz
cDsgJm5ic3A7IHVuc2lnbmVkIGxvbmcgKmJpdG1hcCk7PGJyPitpbnQgaXB1X3dhaXRfZm9yX2lu
dGVycnVwdChpbnQgaW50ZXJydXB0LCBpbnQgdGltZW91dF9tcyk7PGJyPis8YnI+K3N0cnVjdCBp
cHVfY2hhbm5lbDs8YnI+Kzxicj4rLyo8YnI+KyAqIElQVSBJbWFnZSBETUEgQ29udHJvbGxlciAo
aWRtYWMpIGZ1bmN0aW9uczxicj4rICovPGJyPitzdHJ1Y3QgaXB1X2NoYW5uZWwgKmlwdV9pZG1h
Y19nZXQodW5zaWduZWQgY2hhbm5lbCk7PGJyPit2b2lkIGlwdV9pZG1hY19wdXQoc3RydWN0IGlw
dV9jaGFubmVsICopOzxicj4raW50IGlwdV9pZG1hY19pbml0X2NoYW5uZWxfYnVmZmVyKHN0cnVj
dCBpcHVfY2hhbm5lbCAqY2hhbm5lbCw8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsg
Jm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAm
bmJzcDsgJm5ic3A7ICZuYnNwOyB1MzIgcGl4ZWxfZm10LDxicj4rICZuYnNwOyAmbmJzcDsgJm5i
c3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJz
cDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7IHUxNiB3aWR0aCwgdTE2IGhlaWdodCw8YnI+
KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7
ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyB1MzIgc3Ry
aWRlLDxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNw
OyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7
IGlwdV9yb3RhdGVfbW9kZV90IHJvdF9tb2RlLDxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZu
YnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5i
c3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7IGRtYV9hZGRyX3QgcGh5YWRkcl8wLCBkbWFfYWRkcl90
IHBoeWFkZHJfMSw8YnI+KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNw
OyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7
ICZuYnNwOyB1MzIgdV9vZmZzZXQsIHUzMiB2X29mZnNldCwgYm9vbCBpbnRlcmxhY2VkKTs8YnI+
Kzxicj4raW50IGlwdV9pZG1hY191cGRhdGVfY2hhbm5lbF9idWZmZXIoc3RydWN0IGlwdV9jaGFu
bmVsICpjaGFubmVsLDxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5i
c3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJz
cDsgJm5ic3A7ICZuYnNwOyB1MzIgYnVmTnVtLCBkbWFfYWRkcl90IHBoeWFkZHIpOzxicj4rPGJy
PitpbnQgaXB1X2lkbWFjX2VuYWJsZV9jaGFubmVsKHN0cnVjdCBpcHVfY2hhbm5lbCAqY2hhbm5l
bCk7PGJyPitpbnQgaXB1X2lkbWFjX2Rpc2FibGVfY2hhbm5lbChzdHJ1Y3QgaXB1X2NoYW5uZWwg
KmNoYW5uZWwpOzxicj4rPGJyPit2b2lkIGlwdV9pZG1hY19zZXRfZG91YmxlX2J1ZmZlcihzdHJ1
Y3QgaXB1X2NoYW5uZWwgKmNoYW5uZWwsIGJvb2wgZG91YmxlYnVmZmVyKTs8YnI+K3ZvaWQgaXB1
X2lkbWFjX3NlbGVjdF9idWZmZXIoc3RydWN0IGlwdV9jaGFubmVsICpjaGFubmVsLCB1MzIgYnVm
X251bSk7PGJyPis8YnI+Ky8qPGJyPisgKiBJUFUgRGlzcGxheSBDb250cm9sbGVyIChkYykgZnVu
Y3Rpb25zPGJyPisgKi88YnI+K2ludCBpcHVfZGNfaW5pdF9zeW5jKGludCBkY19jaGFuLCBpbnQg
ZGksIGJvb2wgaW50ZXJsYWNlZCwgdTMyIHBpeGVsX2ZtdCwgdTMyIHdpZHRoKTs8YnI+K3ZvaWQg
aXB1X2RjX2luaXRfYXN5bmMoaW50IGRjX2NoYW4sIGludCBkaSwgYm9vbCBpbnRlcmxhY2VkKTs8
YnI+K3ZvaWQgaXB1X2RjX2VuYWJsZV9jaGFubmVsKHUzMiBkY19jaGFuKTs8YnI+K3ZvaWQgaXB1
X2RjX2Rpc2FibGVfY2hhbm5lbCh1MzIgZGNfY2hhbik7PGJyPis8YnI+Ky8qPGJyPisgKiBJUFUg
RGlzcGxheSBJbnRlcmZhY2UgKGRpKSBmdW5jdGlvbnM8YnI+KyAqLzxicj4raW50IGlwdV9kaV9k
aXNhYmxlKGludCBkaXNwKTs8YnI+K2ludCBpcHVfZGlfZW5hYmxlKGludCBkaXNwKTs8YnI+K2lu
dCBpcHVfZGlfaW5pdF9zeW5jX3BhbmVsKGludCBkaXNwLCB1MzIgcGl4ZWxfY2xrLDxicj4rICZu
YnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBzdHJ1Y3QgaXB1
X2RpX3NpZ25hbF9jZmcgKnNpZyk7PGJyPis8YnI+Ky8qPGJyPisgKiBJUFUgRGlzcGxheSBNdWx0
aSBGSUZPIENvbnRyb2xsZXIgKGRtZmMpIGZ1bmN0aW9uczxicj4rICovPGJyPitzdHJ1Y3QgZG1m
Y19jaGFubmVsOzxicj4raW50IGlwdV9kbWZjX2VuYWJsZV9jaGFubmVsKHN0cnVjdCBkbWZjX2No
YW5uZWwgKmRtZmMpOzxicj4rdm9pZCBpcHVfZG1mY19kaXNhYmxlX2NoYW5uZWwoc3RydWN0IGRt
ZmNfY2hhbm5lbCAqZG1mYyk7PGJyPitpbnQgaXB1X2RtZmNfYWxsb2NfYmFuZHdpZHRoKHN0cnVj
dCBkbWZjX2NoYW5uZWwgKmRtZmMsIHVuc2lnbmVkIGxvbmcgYmFuZHdpZHRoX21icyk7PGJyPit2
b2lkIGlwdV9kbWZjX2ZyZWVfYmFuZHdpZHRoKHN0cnVjdCBkbWZjX2NoYW5uZWwgKmRtZmMpOzxi
cj4raW50IGlwdV9kbWZjX2luaXRfY2hhbm5lbChzdHJ1Y3QgZG1mY19jaGFubmVsICpkbWZjLCBp
bnQgd2lkdGgpOzxicj4rc3RydWN0IGRtZmNfY2hhbm5lbCAqaXB1X2RtZmNfZ2V0KGludCBpcHVf
Y2hhbm5lbCk7PGJyPit2b2lkIGlwdV9kbWZjX3B1dChzdHJ1Y3QgZG1mY19jaGFubmVsICpkbWZj
KTs8YnI+Kzxicj4rLyo8YnI+KyAqIElQVSBEaXNwbGF5IFByb2Nlc3NvciAoZHApIGZ1bmN0aW9u
czxicj4rICovPGJyPisjZGVmaW5lIElQVV9EUF9GTE9XX1NZTkMgJm5ic3A7ICZuYnNwOyAmbmJz
cDsgMDxicj4rI2RlZmluZSBJUFVfRFBfRkxPV19BU1lOQzAgJm5ic3A7ICZuYnNwOyAxPGJyPisj
ZGVmaW5lIElQVV9EUF9GTE9XX0FTWU5DMSAmbmJzcDsgJm5ic3A7IDI8YnI+Kzxicj4rc3RydWN0
IGlwdV9kcCAqaXB1X2RwX2dldCh1bnNpZ25lZCBpbnQgZmxvdyk7PGJyPit2b2lkIGlwdV9kcF9w
dXQoc3RydWN0IGlwdV9kcCAqKTs8YnI+K2ludCBpcHVfZHBfZW5hYmxlX2NoYW5uZWwoc3RydWN0
IGlwdV9kcCAqZHApOzxicj4rdm9pZCBpcHVfZHBfZGlzYWJsZV9jaGFubmVsKHN0cnVjdCBpcHVf
ZHAgKmRwKTs8YnI+K3ZvaWQgaXB1X2RwX2VuYWJsZV9mZyhzdHJ1Y3QgaXB1X2RwICpkcCk7PGJy
Pit2b2lkIGlwdV9kcF9kaXNhYmxlX2ZnKHN0cnVjdCBpcHVfZHAgKmRwKTs8YnI+K2ludCBpcHVf
ZHBfc2V0dXBfY2hhbm5lbChzdHJ1Y3QgaXB1X2RwICpkcCwgdTMyIGluX3BpeGVsX2ZtdCw8YnI+
KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7
dTMyIG91dF9waXhlbF9mbXQsIGludCBiZyk7PGJyPitpbnQgaXB1X2RwX3NldF93aW5kb3dfcG9z
KHN0cnVjdCBpcHVfZHAgKiwgdTE2IHhfcG9zLCB1MTYgeV9wb3MpOzxicj4raW50IGlwdV9kcF9z
ZXRfY29sb3Jfa2V5KHN0cnVjdCBpcHVfZHAgKmRwLCBib29sIGVuYWJsZSwgdTMyIGNvbG9yS2V5
KTs8YnI+K2ludCBpcHVfZHBfc2V0X2dsb2JhbF9hbHBoYShzdHJ1Y3QgaXB1X2RwICpkcCwgYm9v
bCBlbmFibGUsIHU4IGFscGhhLDxicj4rICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJz
cDsgJm5ic3A7ICZuYnNwOyBib29sIGJnX2NoYW4pOzxicj4rPGJyPisjZW5kaWY8YnI+LS08YnI+
MS43LjIuMzxicj48c3BhbiBzdHlsZT0nY29sb3I6Izg4ODg4OCc+PGJyPi0tPGJyPlRvIHVuc3Vi
c2NyaWJlIGZyb20gdGhpcyBsaXN0OiBzZW5kIHRoZSBsaW5lICZxdW90O3Vuc3Vic2NyaWJlIGxp
bnV4LWtlcm5lbCZxdW90OyBpbjxicj50aGUgYm9keSBvZiBhIG1lc3NhZ2UgdG8gPGEgaHJlZj0i
bWFpbHRvOm1ham9yZG9tb0B2Z2VyLmtlcm5lbC5vcmciPm1ham9yZG9tb0B2Z2VyLmtlcm5lbC5v
cmc8L2E+PGJyPk1vcmUgbWFqb3Jkb21vIGluZm8gYXQgJm5ic3A7PGEgaHJlZj0iaHR0cDovL3Zn
ZXIua2VybmVsLm9yZy9tYWpvcmRvbW8taW5mby5odG1sIiB0YXJnZXQ9Il9ibGFuayI+aHR0cDov
L3ZnZXIua2VybmVsLm9yZy9tYWpvcmRvbW8taW5mby5odG1sPC9hPjxicj5QbGVhc2UgcmVhZCB0
aGUgRkFRIGF0ICZuYnNwOzxhIGhyZWY9Imh0dHA6Ly93d3cudHV4Lm9yZy9sa21sLyIgdGFyZ2V0
PSJfYmxhbmsiPmh0dHA6Ly93d3cudHV4Lm9yZy9sa21sLzwvYT48L3NwYW4+PG86cD48L286cD48
L3A+PC9kaXY+PHAgY2xhc3M9TXNvTm9ybWFsPjxvOnA+Jm5ic3A7PC9vOnA+PC9wPjwvZGl2Pjwv
Ym9keT48L2h0bWw+AAAfAEIAAQAAACAAAABDAGgAZQBuACAASgBpAGUALQBCADAAMgAyADgAMAAA
AB8AZQABAAAAKgAAAEIAMAAyADIAOAAwAEAAZgByAGUAZQBzAGMAYQBsAGUALgBjAG8AbQAAAAAA
HwBkAAEAAAAKAAAAUwBNAFQAUAAAAAAAAgFBAAEAAABsAAAAAAAAAIErH6S+oxAZnW4A3QEPVAIA
AACAQwBoAGUAbgAgAEoAaQBlAC0AQgAwADIAMgA4ADAAAABTAE0AVABQAAAAQgAwADIAMgA4ADAA
QABmAHIAZQBlAHMAYwBhAGwAZQAuAGMAbwBtAAAAHwACXQEAAAAqAAAAQgAwADIAMgA4ADAAQABm
AHIAZQBlAHMAYwBhAGwAZQAuAGMAbwBtAAAAAAAfAOVfAQAAAAQAAAAgAAAAHwAaDAEAAAAgAAAA
QwBoAGUAbgAgAEoAaQBlAC0AQgAwADIAMgA4ADAAAAAfAB8MAQAAACoAAABCADAAMgAyADgAMABA
AGYAcgBlAGUAcwBjAGEAbABlAC4AYwBvAG0AAAAAAB8AHgwBAAAACgAAAFMATQBUAFAAAAAAAAIB
GQwBAAAAbAAAAAAAAACBKx+kvqMQGZ1uAN0BD1QCAAAAgEMAaABlAG4AIABKAGkAZQAtAEIAMAAy
ADIAOAAwAAAAUwBNAFQAUAAAAEIAMAAyADIAOAAwAEAAZgByAGUAZQBzAGMAYQBsAGUALgBjAG8A
bQAAAB8AAV0BAAAAKgAAAEIAMAAyADIAOAAwAEAAZgByAGUAZQBzAGMAYQBsAGUALgBjAG8AbQAA
AAAACwBAOgEAAAAfABoAAQAAABIAAABJAFAATQAuAE4AbwB0AGUAAAAAAB8AGgABAAAAEgAAAEkA
UABNAC4ATgBvAHQAZQAAAAAAAwDxPwkEAAADAPE/CQQAAAsAQDoBAAAACwBAOgEAAAADAP0/qAMA
AAMA/T+oAwAAAgELMAEAAAAQAAAAcaGnjPtax0Sna8svRpqpzQIBCzABAAAAEAAAAHGhp4z7WsdE
p2vLL0aaqc0DABcAAQAAAAMAFwABAAAAQAA5AAC6p72Gm8sBQAA5AAC6p72Gm8sBQAAIMPZBzoWG
m8sBQAAIMPZBzoWGm8sBCwACAAEAAAALAAIAAQAAAAsAIwAAAAAACwAjAAAAAAADACYAAAAAAAMA
JgAAAAAACwApAAAAAAALACkAAAAAAAsAKwAAAAAACwArAAAAAAADAC4AAAAAAAMALgAAAAAAAwA2
AAAAAAADADYAAAAAAB8AcAABAAAARgAAAFsAUABBAFQAQwBIACAAMwAvADkAXQAgAEEAZABkACAA
YQAgAG0AZgBkACAASQBQAFUAdgAzACAAZAByAGkAdgBlAHIAAAAAAB8AcAABAAAARgAAAFsAUABB
AFQAQwBIACAAMwAvADkAXQAgAEEAZABkACAAYQAgAG0AZgBkACAASQBQAFUAdgAzACAAZAByAGkA
dgBlAHIAAAAAAAIBcQABAAAAIAAAAAEBy5s3SJ63AuH8D+xKthKI7Ut2Ft6Tn0BJ8IAAlb+AAgFx
AAEAAAAgAAAAAQHLmzdInrcC4fwP7Eq2EojtS3YW3pOfQEnwgACVv4ADABYQAwAAAAMAFhADAAAA
HwA1EAEAAACWAAAAPAAzADMARgAzADIAMQA1ADIAQgBFADcARQBDADcANAAwAEIAQwAyAEMAOAAz
ADgARAAyADgAMwA2AEEAQwA4ADcAMAA0AEEAOQBBADAAQAAwADMAOQAtAFMATgAxAE0AUABOADEA
LQAwADAAMgAuADAAMwA5AGQALgBtAGcAZAAuAG0AcwBmAHQALgBuAGUAdAA+AAAAAAAfADUQAQAA
AJYAAAA8ADMAMwBGADMAMgAxADUAMgBCAEUANwBFAEMANwA0ADAAQgBDADIAQwA4ADMAOABEADIA
OAAzADYAQQBDADgANwAwADQAQQA5AEEAMABAADAAMwA5AC0AUwBOADEATQBQAE4AMQAtADAAMAAy
AC4AMAAzADkAZAAuAG0AZwBkAC4AbQBzAGYAdAAuAG4AZQB0AD4AAAAAAB8AORABAAAAlgAAADwA
MwAzAEYAMwAyADEANQAyAEIARQA3AEUAQwA3ADQAMABCAEMAMgBDADgAMwA4AEQAMgA4ADMANgBB
AEMAOAA3ADAANABBADQARgBEAEAAMAAzADkALQBTAE4AMQBNAFAATgAxAC0AMAAwADIALgAwADMA
OQBkAC4AbQBnAGQALgBtAHMAZgB0AC4AbgBlAHQAPgAAAAAAHwA5EAEAAACWAAAAPAAzADMARgAz
ADIAMQA1ADIAQgBFADcARQBDADcANAAwAEIAQwAyAEMAOAAzADgARAAyADgAMwA2AEEAQwA4ADcA
MAA0AEEANABGAEQAQAAwADMAOQAtAFMATgAxAE0AUABOADEALQAwADAAMgAuADAAMwA5AGQALgBt
AGcAZAAuAG0AcwBmAHQALgBuAGUAdAA+AAAAAAAfAEIQAQAAAJYAAAA8ADMAMwBGADMAMgAxADUA
MgBCAEUANwBFAEMANwA0ADAAQgBDADIAQwA4ADMAOABEADIAOAAzADYAQQBDADgANwAwADQAQQA0
AEYARABAADAAMwA5AC0AUwBOADEATQBQAE4AMQAtADAAMAAyAC4AMAAzADkAZAAuAG0AZwBkAC4A
bQBzAGYAdAAuAG4AZQB0AD4AAAAAAB8AQhABAAAAlgAAADwAMwAzAEYAMwAyADEANQAyAEIARQA3
AEUAQwA3ADQAMABCAEMAMgBDADgAMwA4AEQAMgA4ADMANgBBAEMAOAA3ADAANABBADQARgBEAEAA
MAAzADkALQBTAE4AMQBNAFAATgAxAC0AMAAwADIALgAwADMAOQBkAC4AbQBnAGQALgBtAHMAZgB0
AC4AbgBlAHQAPgAAAAAAAwCAEP////8DAIAQ/////0AABzA2uXKEhpvLAUAABzA2uXKEhpvLAQMA
3j+fTgAAAwDeP59OAAAfAPg/AQAAACAAAABDAGgAZQBuACAASgBpAGUALQBCADAAMgAyADgAMAAA
AB8A+D8BAAAAIAAAAEMAaABlAG4AIABKAGkAZQAtAEIAMAAyADIAOAAwAAAAHwD6PwEAAAAgAAAA
QwBoAGUAbgAgAEoAaQBlAC0AQgAwADIAMgA4ADAAAAAfAPo/AQAAACAAAABDAGgAZQBuACAASgBp
AGUALQBCADAAMgAyADgAMAAAAAMAAlkAABYAAwACWQAAFgADAAlZAgAAAAMACVkCAAAAAwAAgAgg
BgAAAAAAwAAAAAAAAEYAAAAAEIUAAAAAAAADAACACCAGAAAAAADAAAAAAAAARgAAAAAQhQAAAAAA
AAsAAIAIIAYAAAAAAMAAAAAAAABGAAAAAAOFAAAAAAAACwAAgAggBgAAAAAAwAAAAAAAAEYAAAAA
A4UAAAAAAAADAACACCAGAAAAAADAAAAAAAAARgAAAAABhQAAAAAAAAMAAIAIIAYAAAAAAMAAAAAA
AABGAAAAAAGFAAAAAAAACwAAgAggBgAAAAAAwAAAAAAAAEYAAAAADoUAAAAAAAALAACACCAGAAAA
AADAAAAAAAAARgAAAAAOhQAAAAAAAAMAAIAIIAYAAAAAAMAAAAAAAABGAAAAABiFAAAAAAAAAwAA
gAggBgAAAAAAwAAAAAAAAEYAAAAAGIUAAAAAAAALAACACCAGAAAAAADAAAAAAAAARgAAAAAGhQAA
AAAAAAsAAIAIIAYAAAAAAMAAAAAAAABGAAAAAAaFAAAAAAAACwAAgAggBgAAAAAAwAAAAAAAAEYA
AAAAgoUAAAAAAAALAACACCAGAAAAAADAAAAAAAAARgAAAACChQAAAAAAAAMAAIADIAYAAAAAAMAA
AAAAAABGAAAAAAGBAAAAAAAAAwAAgAMgBgAAAAAAwAAAAAAAAEYAAAAAAYEAAAAAAAAFAACAAyAG
AAAAAADAAAAAAAAARgAAAAACgQAAAAAAAAAAAAAFAACAAyAGAAAAAADAAAAAAAAARgAAAAACgQAA
AAAAAAAAAAADAACAAyAGAAAAAADAAAAAAAAARgAAAAATgQAAAQAAAAMAAIADIAYAAAAAAMAAAAAA
AABGAAAAABOBAAABAAAACwAAgAMgBgAAAAAAwAAAAAAAAEYAAAAAHIEAAAAAAAALAACAAyAGAAAA
AADAAAAAAAAARgAAAAAcgQAAAAAAAAsAAIADIAYAAAAAAMAAAAAAAABGAAAAACaBAAAAAAAACwAA
gAMgBgAAAAAAwAAAAAAAAEYAAAAAJoEAAAAAAAADAACAAyAGAAAAAADAAAAAAAAARgAAAAAQgQAA
AAAAAAMAAIADIAYAAAAAAMAAAAAAAABGAAAAABCBAAAAAAAAAwAAgAMgBgAAAAAAwAAAAAAAAEYA
AAAAEYEAAAAAAAADAACAAyAGAAAAAADAAAAAAAAARgAAAAARgQAAAAAAAAMAAIADIAYAAAAAAMAA
AAAAAABGAAAAACqBAAAAAAAAAwAAgAMgBgAAAAAAwAAAAAAAAEYAAAAAKoEAAAAAAAADAACAAyAG
AAAAAADAAAAAAAAARgAAAAApgQAAAAAAAAMAAIADIAYAAAAAAMAAAAAAAABGAAAAACmBAAAAAAAA
CwAAgAMgBgAAAAAAwAAAAAAAAEYAAAAAJIEAAAAAAAALAACAAyAGAAAAAADAAAAAAAAARgAAAAAk
gQAAAAAAAAsAAIADIAYAAAAAAMAAAAAAAABGAAAAACyBAAAAAAAACwAAgAMgBgAAAAAAwAAAAAAA
AEYAAAAALIEAAAAAAAAfAACAAyAGAAAAAADAAAAAAAAARgAAAAAngQAAAQAAAAIAAAAAAAAAHwAA
gAMgBgAAAAAAwAAAAAAAAEYAAAAAJ4EAAAEAAAACAAAAAAAAAAMAAIADIAYAAAAAAMAAAAAAAABG
AAAAABKBAAABAAAAAwAAgAMgBgAAAAAAwAAAAAAAAEYAAAAAEoEAAAEAAAAfAACAAyAGAAAAAADA
AAAAAAAARgAAAAAhgQAAAQAAAAIAAAAAAAAAHwAAgAMgBgAAAAAAwAAAAAAAAEYAAAAAIYEAAAEA
AAACAAAAAAAAAAsAAIADIAYAAAAAAMAAAAAAAABGAAAAAAOBAAAAAAAACwAAgAMgBgAAAAAAwAAA
AAAAAEYAAAAAA4EAAAAAAAADAACAAyAGAAAAAADAAAAAAAAARgAAAAAjgQAA////fwMAAIADIAYA
AAAAAMAAAAAAAABGAAAAACOBAAD///9/HwAAgB+k6zOoei5Cvnt54amOVLMBAAAAOAAAAEMAbwBu
AHYAZQByAHMAYQB0AGkAbwBuAEkAbgBkAGUAeABUAHIAYQBjAGsAaQBuAGcARQB4AAAAAQAAAP4A
AABJAEkAPQAwADEAMAAxAEMAQgA5AEIAMwA3ADQAOAA5AEUAQgA3ADAAMgBFADEARgBDADAARgBF
AEMANABBAEIANgAxADIAOAA4AEUARAA0AEIANwA2ADEANgBEAEUAOQAzADkARgA0ADAANAA5AEYA
MAA4ADAAMAAwADkANQBCAEYAOAAwADsAUwBCAE0ASQBEAD0AOQA7AFMAQgBUAD0AMwA7AFYAZQBy
AHMAaQBvAG4APQBWAGUAcgBzAGkAbwBuACAAMQA0AC4AMAAgACgAQgB1AGkAbABkACAANwAwADIA
LgAwACkALAAgAFMAdABhAGcAZQA9AEgANwAAAAAAHwAAgB+k6zOoei5Cvnt54amOVLMBAAAAOAAA
AEMAbwBuAHYAZQByAHMAYQB0AGkAbwBuAEkAbgBkAGUAeABUAHIAYQBjAGsAaQBuAGcARQB4AAAA
AQAAAP4AAABJAEkAPQAwADEAMAAxAEMAQgA5AEIAMwA3ADQAOAA5AEUAQgA3ADAAMgBFADEARgBD
ADAARgBFAEMANABBAEIANgAxADIAOAA4AEUARAA0AEIANwA2ADEANgBEAEUAOQAzADkARgA0ADAA
NAA5AEYAMAA4ADAAMAAwADkANQBCAEYAOAAwADsAUwBCAE0ASQBEAD0AOQA7AFMAQgBUAD0AMwA7
AFYAZQByAHMAaQBvAG4APQBWAGUAcgBzAGkAbwBuACAAMQA0AC4AMAAgACgAQgB1AGkAbABkACAA
NwAwADIALgAwACkALAAgAFMAdABhAGcAZQA9AEgANwAAAAAAAwANNP0/AAADAA00/T8AAB8APQAB
AAAACgAAAFIARQA6ACAAAAAAAB8APQABAAAACgAAAFIARQA6ACAAAAAAAB8ANwABAAAATgAAAFIA
RQA6ACAAWwBQAEEAVABDAEgAIAAzAC8AOQBdACAAQQBkAGQAIABhACAAbQBmAGQAIABJAFAAVQB2
ADMAIABkAHIAaQB2AGUAcgAAAAAAHwA3AAEAAABOAAAAUgBFADoAIABbAFAAQQBUAEMASAAgADMA
LwA5AF0AIABBAGQAZAAgAGEAIABtAGYAZAAgAEkAUABVAHYAMwAgAGQAcgBpAHYAZQByAAAAAAAf
AACAhgMCAAAAAADAAAAAAAAARgEAAAAeAAAAYQBjAGMAZQBwAHQAbABhAG4AZwB1AGEAZwBlAAAA
AAABAAAADAAAAGUAbgAtAFUAUwAAAB8AAICGAwIAAAAAAMAAAAAAAABGAQAAAB4AAABhAGMAYwBl
AHAAdABsAGEAbgBnAHUAYQBnAGUAAAAAAAEAAAAMAAAAZQBuAC0AVQBTAAAAHwAAgIYDAgAAAAAA
wAAAAAAAAEYBAAAAIAAAAHgALQBtAHMALQBoAGEAcwAtAGEAdAB0AGEAYwBoAAAAAQAAAAIAAAAA
AAAAHwAAgIYDAgAAAAAAwAAAAAAAAEYBAAAAIAAAAHgALQBtAHMALQBoAGEAcwAtAGEAdAB0AGEA
YwBoAAAAAQAAAAIAAAAAAAAADn0=

--_000_33F32152BE7EC740BC2C838D2836AC8704A9A0039SN1MPN1002039d_--
