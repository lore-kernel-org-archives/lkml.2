Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758850Ab0LNMgv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 07:36:51 -0500
Received: from am1ehsobe001.messaging.microsoft.com ([213.199.154.204]:32113
	"EHLO AM1EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757562Ab0LNMgt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 07:36:49 -0500
X-SpamScore: -81
X-BigFish: VS-81(zzbb2dK1432N8f9KJ1861R9371P62a3Lzz1202hzz8275bh8275dhz2dh2a8h668h34h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:de01egw02.freescale.net;RD:de01egw02.freescale.net;EFVD:NLI
Content-Type: multipart/mixed;
	boundary="_000_33F32152BE7EC740BC2C838D2836AC8704A9F5039SN1MPN1002039d_"
From: Chen Jie-B02280 <B02280@freescale.com>
To: "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        Zhang Lily-R58066 <R58066@freescale.com>,
        "arnaud.patard@rtp-net.org" <arnaud.patard@rtp-net.org>
Subject: RE: [PATCH 5/9] Add i.MX5 framebuffer driver
Thread-Topic: [PATCH 5/9] Add i.MX5 framebuffer driver
Thread-Index: AQHLm2GAmj0DX+DzxUG/Qxv9KnfRTJOfz4UAgAAKJfA=
Date: Tue, 14 Dec 2010 12:38:08 +0000
Message-ID: <33F32152BE7EC740BC2C838D2836AC8704A9F5@039-SN1MPN1-002.039d.mgd.msft.net>
References: <33F32152BE7EC740BC2C838D2836AC8704A957@039-SN1MPN1-002.039d.mgd.msft.net>
In-Reply-To: <33F32152BE7EC740BC2C838D2836AC8704A957@039-SN1MPN1-002.039d.mgd.msft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: <33F32152BE7EC740BC2C838D2836AC8704A9F5@039-SN1MPN1-002.039d.mgd.msft.net>
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--_000_33F32152BE7EC740BC2C838D2836AC8704A9F5039SN1MPN1002039d_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Hi, Sascha,

Few comments inline with [Jason]

Jason Chen / Chen Jie
NMG / MAD
Freescale Semiconductor (China) Ltd.
2F, Building B, 177#, Bi Bo Rd
Pu Dong New District Shanghai 201203
Tel:     021-28937178
Fax:     021-28937444
E-mail:  Jason.Chen@freescale.com<mailto:Jason.Chen@freescale.com>

From: Jason Chen [mailto:weitway@gmail.com]
Sent: Tuesday, December 14, 2010 3:35 PM
To: Chen Jie-B02280
Subject: Fwd: [PATCH 5/9] Add i.MX5 framebuffer driver


---------- Forwarded message ----------
From: Liu Ying <liu.y.victor@gmail.com<mailto:liu.y.victor@gmail.com>>
Date: 2010/12/12
Subject: Re: [PATCH 5/9] Add i.MX5 framebuffer driver
To: Sascha Hauer <s.hauer@pengutronix.de<mailto:s.hauer@pengutronix.de>>
Cc: linux-arm-kernel@lists.infradead.org<mailto:linux-arm-kernel@lists.infr=
adead.org>, linux-kernel@vger.kernel.org<mailto:linux-kernel@vger.kernel.or=
g>, linux-fbdev@vger.kernel.org<mailto:linux-fbdev@vger.kernel.org>, Zhang =
Lily-R58066 <r58066@freescale.com<mailto:r58066@freescale.com>>, Arnaud Pat=
ard <arnaud.patard@rtp-net.org<mailto:arnaud.patard@rtp-net.org>>


Hello, Sascha,

I have following comments to this patch:
1) Please modify the commit message, as IPUv3 is not embedded in i.MX50 SoC=
.
2) ADC is not supported yet in the framebuffer driver, so please
modify this comment:
  > + * Framebuffer Framebuffer Driver for SDC and ADC.
3) 'ipu_dp_set_window_pos()' is called only once in
imx_ipu_fb_set_par_overlay(). So, the framebuffer driver doesn't
support to change the overlay framebuffer position. Need a
mechanism/interface for users to change the overlay framebuffer
position.
[Jason] DP-FG should be one fb device, sequence ioctl should be added after=
 it, like global alpha , color key etc.

4) Need to make sure the framebuffer on DP-FG is blanked before the
framebuffer on DP-BG is blanked. Meanwhile, the framebuffer on DP-FG
should be unblanked after the framebuffer on DP-BG is unblanked
5) Need to check the framebuffer on DP-FG doesn't run out of the range
of the framebuffer on DP-BG.
6) I prefer to find the video mode in modedb first, and if we cannot
find the video mode in common video mode data base, we can find a
video mode in custom video mode data base which is defined in platform
data. In this way, we don't need to export common modefb.

Best Regards,
Liu Ying


2010/12/9 Sascha Hauer <s.hauer@pengutronix.de<mailto:s.hauer@pengutronix.d=
e>>:
> This patch adds framebuffer support to the Freescale i.MX SoCs
> equipped with an IPU v3, so far these are the i.MX50/51/53.
>
> This driver has been tested on the i.MX51 babbage board with
> both DVI and analog VGA in different resolutions and color depths.
> It has also been tested on a custom i.MX51 board using a fixed
> resolution panel.
>
> Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de<mailto:s.hauer@pengut=
ronix.de>>
> ---
>  drivers/video/Kconfig  |   11 +
>  drivers/video/Makefile |    1 +
>  drivers/video/mx5fb.c  |  846 ++++++++++++++++++++++++++++++++++++++++++=
++++++
>  3 files changed, 858 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/video/mx5fb.c
>
> diff --git a/drivers/video/Kconfig b/drivers/video/Kconfig
> index 27c1fb4..1901915 100644
> --- a/drivers/video/Kconfig
> +++ b/drivers/video/Kconfig
> @@ -2236,6 +2236,17 @@ config FB_MX3
>          far only synchronous displays are supported. If you plan to use
>          an LCD display with your i.MX31 system, say Y here.
>
> +config FB_MX5
> +       tristate "MX5 Framebuffer support"
> +       depends on FB && MFD_IMX_IPU_V3
> +       select FB_CFB_FILLRECT
> +       select FB_CFB_COPYAREA
> +       select FB_CFB_IMAGEBLIT
> +       select FB_MODE_HELPERS
> +       help
> +         This is a framebuffer device for the i.MX51 LCD Controller. If =
you
> +         plan to use an LCD display with your i.MX51 system, say Y here.
> +
>  config FB_BROADSHEET
>        tristate "E-Ink Broadsheet/Epson S1D13521 controller support"
>        depends on FB
> diff --git a/drivers/video/Makefile b/drivers/video/Makefile
> index 485e8ed..ad408d2 100644
> --- a/drivers/video/Makefile
> +++ b/drivers/video/Makefile
> @@ -145,6 +145,7 @@ obj-$(CONFIG_FB_BF54X_LQ043)          +=3D bf54x-lq04=
3fb.o
>  obj-$(CONFIG_FB_BFIN_LQ035Q1)     +=3D bfin-lq035q1-fb.o
>  obj-$(CONFIG_FB_BFIN_T350MCQB)   +=3D bfin-t350mcqb-fb.o
>  obj-$(CONFIG_FB_MX3)             +=3D mx3fb.o
> +obj-$(CONFIG_FB_MX5)             +=3D mx5fb.o
>  obj-$(CONFIG_FB_DA8XX)           +=3D da8xx-fb.o
>
>  # the test framebuffer is last
> diff --git a/drivers/video/mx5fb.c b/drivers/video/mx5fb.c
> new file mode 100644
> index 0000000..fd9baf4
> --- /dev/null
> +++ b/drivers/video/mx5fb.c
> @@ -0,0 +1,846 @@
> +/*
> + * Copyright 2004-2009 Freescale Semiconductor, Inc. All Rights Reserved=
.
> + *
> + * The code contained herein is licensed under the GNU General Public
> + * License. You may obtain a copy of the GNU General Public License
> + * Version 2 or later at the following locations:
> + *
> + * http://www.opensource.org/licenses/gpl-license.html
> + * http://www.gnu.org/copyleft/gpl.html
> + *
> + * Framebuffer Framebuffer Driver for SDC and ADC.
> + */
> +
> +#include <linux/module.h>
> +#include <linux/kernel.h>
> +#include <linux/platform_device.h>
> +#include <linux/errno.h>
> +#include <linux/string.h>
> +#include <linux/interrupt.h>
> +#include <linux/slab.h>
> +#include <linux/fb.h>
> +#include <linux/delay.h>
> +#include <linux/init.h>
> +#include <linux/dma-mapping.h>
> +#include <linux/console.h>
> +#include <linux/mfd/imx-ipu-v3.h>
> +#include <asm/uaccess.h>
> +#include <mach/ipu-v3.h>
> +
> +#define DRIVER_NAME "imx-ipuv3-fb"
> +
> +struct imx_ipu_fb_info {
> +       int                     ipu_channel_num;
> +       struct ipu_channel      *ipu_ch;
> +       int                     dc;
> +       int                     ipu_di;
> +       u32                     ipu_di_pix_fmt;
> +       u32                     ipu_in_pix_fmt;
> +
> +       u32                     pseudo_palette[16];
> +
> +       struct ipu_dp           *dp;
> +       struct dmfc_channel     *dmfc;
> +       struct fb_info          *slave;
> +       struct fb_info          *master;
> +       bool                    enabled;
> +};
> +
> +static int imx_ipu_fb_set_fix(struct fb_info *info)
> +{
> +       struct fb_fix_screeninfo *fix =3D &info->fix;
> +       struct fb_var_screeninfo *var =3D &info->var;
> +
> +       fix->line_length =3D var->xres_virtual * var->bits_per_pixel / 8;
> +
> +       fix->type =3D FB_TYPE_PACKED_PIXELS;
> +       fix->accel =3D FB_ACCEL_NONE;
> +       fix->visual =3D FB_VISUAL_TRUECOLOR;
> +       fix->xpanstep =3D 1;
> +       fix->ypanstep =3D 1;
> +
> +       return 0;
> +}
> +
> +static int imx_ipu_fb_map_video_memory(struct fb_info *fbi)
> +{
> +       int size;
> +
> +       size =3D fbi->var.yres_virtual * fbi->fix.line_length;
> +
> +       if (fbi->screen_base) {
> +               if (fbi->fix.smem_len >=3D size)
> +                       return 0;
> +
> +               dma_free_writecombine(fbi->device, fbi->fix.smem_len,
> +                             fbi->screen_base, fbi->fix.smem_start);
> +       }
> +
> +       fbi->screen_base =3D dma_alloc_writecombine(fbi->device,
> +                               size,
> +                               (dma_addr_t *)&fbi->fix.smem_start,
> +                               GFP_DMA);
> +       if (fbi->screen_base =3D=3D 0) {
> +               dev_err(fbi->device, "Unable to allocate framebuffer memo=
ry (%d)\n",
> +                               fbi->fix.smem_len);
> +               fbi->fix.smem_len =3D 0;
> +               fbi->fix.smem_start =3D 0;
> +               return -ENOMEM;
> +       }
> +
> +       fbi->fix.smem_len =3D size;
> +       fbi->screen_size =3D fbi->fix.smem_len;
> +
> +       dev_dbg(fbi->device, "allocated fb @ paddr=3D0x%08lx, size=3D%d\n=
",
> +               fbi->fix.smem_start, fbi->fix.smem_len);
> +
> +       /* Clear the screen */
> +       memset((char *)fbi->screen_base, 0, fbi->fix.smem_len);
> +
> +       return 0;
> +}
> +
> +static void imx_ipu_fb_enable(struct fb_info *fbi)
> +{
> +       struct imx_ipu_fb_info *mxc_fbi =3D fbi->par;
> +
> +       if (mxc_fbi->enabled)
> +               return;
> +
> +       ipu_di_enable(mxc_fbi->ipu_di);
> +       ipu_dmfc_enable_channel(mxc_fbi->dmfc);
> +       ipu_idmac_enable_channel(mxc_fbi->ipu_ch);
> +       ipu_dc_enable_channel(mxc_fbi->dc);
> +       ipu_dp_enable_channel(mxc_fbi->dp);
> +       mxc_fbi->enabled =3D 1;
> +}
> +
> +static void imx_ipu_fb_disable(struct fb_info *fbi)
> +{
> +       struct imx_ipu_fb_info *mxc_fbi =3D fbi->par;
> +
> +       if (!mxc_fbi->enabled)
> +               return;
> +
> +       ipu_dp_disable_channel(mxc_fbi->dp);
> +       ipu_dc_disable_channel(mxc_fbi->dc);
> +       ipu_idmac_disable_channel(mxc_fbi->ipu_ch);
> +       ipu_dmfc_disable_channel(mxc_fbi->dmfc);
> +       ipu_di_disable(mxc_fbi->ipu_di);
> +
> +       mxc_fbi->enabled =3D 0;
> +}
> +
> +static int calc_vref(struct fb_var_screeninfo *var)
> +{
> +       unsigned long htotal, vtotal;
> +
> +       htotal =3D var->xres + var->right_margin + var->hsync_len + var->=
left_margin;
> +       vtotal =3D var->yres + var->lower_margin + var->vsync_len + var->=
upper_margin;
> +
> +       if (!htotal || !vtotal)
> +               return 60;
> +
> +       return PICOS2KHZ(var->pixclock) * 1000 / vtotal / htotal;
> +}
> +
> +static int calc_bandwidth(struct fb_var_screeninfo *var, unsigned int vr=
ef)
> +{
> +       return var->xres * var->yres * vref;
> +}
> +
> +static int imx_ipu_fb_set_par(struct fb_info *fbi)
> +{
> +       int ret;
> +       struct ipu_di_signal_cfg sig_cfg;
> +       struct imx_ipu_fb_info *mxc_fbi =3D fbi->par;
> +       u32 out_pixel_fmt;
> +       int interlaced =3D 0;
> +       struct fb_var_screeninfo *var =3D &fbi->var;
> +       int enabled =3D mxc_fbi->enabled;
> +
> +       dev_dbg(fbi->device, "Reconfiguring framebuffer %dx%d-%d\n",
> +               fbi->var.xres, fbi->var.yres, fbi->var.bits_per_pixel);
> +
> +       if (enabled)
> +               imx_ipu_fb_disable(fbi);
> +
> +       fbi->fix.line_length =3D var->xres_virtual * var->bits_per_pixel =
/ 8;
> +
> +       var->yres_virtual =3D var->yres;
> +
> +       ret =3D imx_ipu_fb_map_video_memory(fbi);
> +       if (ret)
> +               return ret;
> +
> +       if (var->vmode & FB_VMODE_INTERLACED)
> +               interlaced =3D 1;
> +
> +       memset(&sig_cfg, 0, sizeof(sig_cfg));
> +       out_pixel_fmt =3D mxc_fbi->ipu_di_pix_fmt;
> +
> +       if (var->vmode & FB_VMODE_INTERLACED)
> +               sig_cfg.interlaced =3D 1;
> +       if (var->vmode & FB_VMODE_ODD_FLD_FIRST) /* PAL */
> +               sig_cfg.odd_field_first =3D 1;
> +       if (var->sync & FB_SYNC_EXT)
> +               sig_cfg.ext_clk =3D 1;
[Jason] FB_SYNC_EXT has not be used in FSL kernel mainline, it represent SY=
NC ext, should not be flag of ext clk. Some application for example X-serve=
r could not recognize it.

> +       if (var->sync & FB_SYNC_HOR_HIGH_ACT)
> +               sig_cfg.Hsync_pol =3D 1;
> +       if (var->sync & FB_SYNC_VERT_HIGH_ACT)
> +               sig_cfg.Vsync_pol =3D 1;
> +       if (!(var->sync & FB_SYNC_CLK_LAT_FALL))
> +               sig_cfg.clk_pol =3D 1;
> +       if (var->sync & FB_SYNC_DATA_INVERT)
> +               sig_cfg.data_pol =3D 1;
> +       if (!(var->sync & FB_SYNC_OE_LOW_ACT))
> +               sig_cfg.enable_pol =3D 1;
> +       if (var->sync & FB_SYNC_CLK_IDLE_EN)
> +               sig_cfg.clkidle_en =3D 1;
> +
> +       dev_dbg(fbi->device, "pixclock =3D %lu.%03lu MHz\n",
> +               PICOS2KHZ(var->pixclock) / 1000,
> +               PICOS2KHZ(var->pixclock) % 1000);
> +
> +       sig_cfg.width =3D var->xres;
> +       sig_cfg.height =3D var->yres;
> +       sig_cfg.pixel_fmt =3D out_pixel_fmt;
> +       sig_cfg.h_start_width =3D var->left_margin;
> +       sig_cfg.h_sync_width =3D var->hsync_len;
> +       sig_cfg.h_end_width =3D var->right_margin;
> +       sig_cfg.v_start_width =3D var->upper_margin;
> +       sig_cfg.v_sync_width =3D var->vsync_len;
> +       sig_cfg.v_end_width =3D var->lower_margin;
> +       sig_cfg.v_to_h_sync =3D 0;
> +
> +       if (mxc_fbi->dp) {
> +               ret =3D ipu_dp_setup_channel(mxc_fbi->dp, mxc_fbi->ipu_in=
_pix_fmt,
> +                               out_pixel_fmt, 1);
> +               if (ret) {
> +                       dev_dbg(fbi->device, "initializing display proces=
sor failed with %d\n",
> +                               ret);
> +                       return ret;
> +               }
> +       }
> +
> +       ret =3D ipu_dc_init_sync(mxc_fbi->dc, mxc_fbi->ipu_di, interlaced=
,
> +                       out_pixel_fmt, fbi->var.xres);
> +       if (ret) {
> +               dev_dbg(fbi->device, "initializing display controller fai=
led with %d\n",
> +                               ret);
> +               return ret;
> +       }
> +
> +       ret =3D ipu_di_init_sync_panel(mxc_fbi->ipu_di,
> +                               PICOS2KHZ(var->pixclock) * 1000UL,
> +                               &sig_cfg);
> +       if (ret) {
> +               dev_dbg(fbi->device, "initializing panel failed with %d\n=
",
> +                               ret);
> +               return ret;
> +       }
> +
> +       fbi->mode =3D (struct fb_videomode *)fb_match_mode(var, &fbi->mod=
elist);
> +       var->xoffset =3D var->yoffset =3D 0;
> +
> +       if (fbi->var.vmode & FB_VMODE_INTERLACED)
> +               interlaced =3D 1;
> +
> +       ret =3D ipu_idmac_init_channel_buffer(mxc_fbi->ipu_ch,
> +                                       mxc_fbi->ipu_in_pix_fmt,
> +                                       var->xres, var->yres,
> +                                       fbi->fix.line_length,
> +                                       IPU_ROTATE_NONE,
> +                                       fbi->fix.smem_start,
> +                                       0,
> +                                       0, 0, interlaced);
> +       if (ret) {
> +               dev_dbg(fbi->device, "init channel buffer failed with %d\=
n",
> +                               ret);
> +               return ret;
> +       }
> +
> +       ret =3D ipu_dmfc_init_channel(mxc_fbi->dmfc, var->xres);
> +       if (ret) {
> +               dev_dbg(fbi->device, "initializing dmfc channel failed wi=
th %d\n",
> +                               ret);
> +               return ret;
> +       }
> +
> +       ret =3D ipu_dmfc_alloc_bandwidth(mxc_fbi->dmfc, calc_bandwidth(va=
r, calc_vref(var)));
> +       if (ret) {
> +               dev_dbg(fbi->device, "allocating dmfc bandwidth failed wi=
th %d\n",
> +                               ret);
> +               return ret;
> +       }
> +
> +       if (enabled)
> +               imx_ipu_fb_enable(fbi);
> +
> +       return ret;
> +}
> +
> +/*
> + * These are the bitfields for each
> + * display depth that we support.
> + */
> +struct imxfb_rgb {
> +       struct fb_bitfield      red;
> +       struct fb_bitfield      green;
> +       struct fb_bitfield      blue;
> +       struct fb_bitfield      transp;
> +};
> +
> +static struct imxfb_rgb def_rgb_8 =3D {
> +       .red    =3D { .offset =3D  5, .length =3D 3, },
> +       .green  =3D { .offset =3D  2, .length =3D 3, },
> +       .blue   =3D { .offset =3D  0, .length =3D 2, },
> +       .transp =3D { .offset =3D  0, .length =3D 0, },
> +};
> +
> +static struct imxfb_rgb def_rgb_16 =3D {
> +       .red    =3D { .offset =3D 11, .length =3D 5, },
> +       .green  =3D { .offset =3D  5, .length =3D 6, },
> +       .blue   =3D { .offset =3D  0, .length =3D 5, },
> +       .transp =3D { .offset =3D  0, .length =3D 0, },
> +};
> +
> +static struct imxfb_rgb def_rgb_24 =3D {
> +       .red    =3D { .offset =3D 16, .length =3D 8, },
> +       .green  =3D { .offset =3D  8, .length =3D 8, },
> +       .blue   =3D { .offset =3D  0, .length =3D 8, },
> +       .transp =3D { .offset =3D  0, .length =3D 0, },
> +};
> +
> +static struct imxfb_rgb def_rgb_32 =3D {
> +       .red    =3D { .offset =3D 16, .length =3D 8, },
> +       .green  =3D { .offset =3D  8, .length =3D 8, },
> +       .blue   =3D { .offset =3D  0, .length =3D 8, },
> +       .transp =3D { .offset =3D 24, .length =3D 8, },
> +};
> +
> +/*
> + * Check framebuffer variable parameters and adjust to valid values.
> + *
> + * @param       var      framebuffer variable parameters
> + *
> + * @param       info     framebuffer information pointer
> + */
> +static int imx_ipu_fb_check_var(struct fb_var_screeninfo *var, struct fb=
_info *info)
> +{
> +       struct imx_ipu_fb_info *mxc_fbi =3D info->par;
> +       struct imxfb_rgb *rgb;
> +
> +       /* we don't support xpan, force xres_virtual to be equal to xres =
*/
> +       var->xres_virtual =3D var->xres;
> +
> +       if (var->yres_virtual < var->yres)
> +               var->yres_virtual =3D var->yres;
> +
> +       switch (var->bits_per_pixel) {
> +       case 8:
> +               rgb =3D &def_rgb_8;
> +               break;
> +       case 16:
> +               rgb =3D &def_rgb_16;
> +               mxc_fbi->ipu_in_pix_fmt =3D IPU_PIX_FMT_RGB565;
> +               break;
> +       case 24:
> +               rgb =3D &def_rgb_24;
> +               mxc_fbi->ipu_in_pix_fmt =3D IPU_PIX_FMT_BGR24;
> +               break;
> +       case 32:
> +               rgb =3D &def_rgb_32;
> +               mxc_fbi->ipu_in_pix_fmt =3D IPU_PIX_FMT_BGR32;
> +               break;
> +       default:
> +               var->bits_per_pixel =3D 24;
> +               rgb =3D &def_rgb_24;
> +               mxc_fbi->ipu_in_pix_fmt =3D IPU_PIX_FMT_BGR24;
> +       }
> +
> +       var->red    =3D rgb->red;
> +       var->green  =3D rgb->green;
> +       var->blue   =3D rgb->blue;
> +       var->transp =3D rgb->transp;
> +
> +       return 0;
> +}
> +
> +static inline unsigned int chan_to_field(u_int chan, struct fb_bitfield =
*bf)
> +{
> +       chan &=3D 0xffff;
> +       chan >>=3D 16 - bf->length;
> +       return chan << bf->offset;
> +}
> +
> +static int imx_ipu_fb_setcolreg(u_int regno, u_int red, u_int green, u_i=
nt blue,
> +                          u_int trans, struct fb_info *fbi)
> +{
> +       unsigned int val;
> +       int ret =3D 1;
> +
> +       /*
> +        * If greyscale is true, then we convert the RGB value
> +        * to greyscale no matter what visual we are using.
> +        */
> +       if (fbi->var.grayscale)
> +               red =3D green =3D blue =3D (19595 * red + 38470 * green +
> +                                     7471 * blue) >> 16;
> +       switch (fbi->fix.visual) {
> +       case FB_VISUAL_TRUECOLOR:
> +               /*
> +                * 16-bit True Colour.  We encode the RGB value
> +                * according to the RGB bitfield information.
> +                */
> +               if (regno < 16) {
> +                       u32 *pal =3D fbi->pseudo_palette;
> +
> +                       val =3D chan_to_field(red, &fbi->var.red);
> +                       val |=3D chan_to_field(green, &fbi->var.green);
> +                       val |=3D chan_to_field(blue, &fbi->var.blue);
> +
> +                       pal[regno] =3D val;
> +                       ret =3D 0;
> +               }
> +               break;
> +
> +       case FB_VISUAL_STATIC_PSEUDOCOLOR:
> +       case FB_VISUAL_PSEUDOCOLOR:
> +               break;
> +       }
> +
> +       return ret;
> +}
> +
> +static int imx_ipu_fb_blank(int blank, struct fb_info *info)
> +{
> +       dev_dbg(info->device, "blank =3D %d\n", blank);
> +
> +       switch (blank) {
> +       case FB_BLANK_POWERDOWN:
> +       case FB_BLANK_VSYNC_SUSPEND:
> +       case FB_BLANK_HSYNC_SUSPEND:
> +       case FB_BLANK_NORMAL:
> +               imx_ipu_fb_disable(info);
> +               break;
> +       case FB_BLANK_UNBLANK:
> +               imx_ipu_fb_enable(info);
> +               break;
> +       }
> +
> +       return 0;
> +}
> +
> +static int imx_ipu_fb_pan_display(struct fb_var_screeninfo *var,
> +               struct fb_info *info)
> +{
> +       struct imx_ipu_fb_info *mxc_fbi =3D info->par;
> +       unsigned long base;
> +       int ret;
> +
> +       if (info->var.yoffset =3D=3D var->yoffset)
> +               return 0;       /* No change, do nothing */
> +
> +       base =3D var->yoffset * var->xres_virtual * var->bits_per_pixel /=
 8;
> +       base +=3D info->fix.smem_start;
> +
> +       ret =3D ipu_wait_for_interrupt(IPU_IRQ_EOF(mxc_fbi->ipu_channel_n=
um), 100);
> +       if (ret)
> +               return ret;
> +
> +       if (ipu_idmac_update_channel_buffer(mxc_fbi->ipu_ch, 0, base)) {
> +               dev_err(info->device,
> +                       "Error updating SDC buf to address=3D0x%08lX\n", =
base);
> +       }
[Jason] It's better to enable double -buffer for fb which could avoid teari=
ng issue.

> +
> +       info->var.yoffset =3D var->yoffset;
> +
> +       return 0;
> +}
> +
> +static struct fb_ops imx_ipu_fb_ops =3D {
> +       .owner          =3D THIS_MODULE,
> +       .fb_set_par     =3D imx_ipu_fb_set_par,
> +       .fb_check_var   =3D imx_ipu_fb_check_var,
> +       .fb_setcolreg   =3D imx_ipu_fb_setcolreg,
> +       .fb_pan_display =3D imx_ipu_fb_pan_display,
> +       .fb_fillrect    =3D cfb_fillrect,
> +       .fb_copyarea    =3D cfb_copyarea,
> +       .fb_imageblit   =3D cfb_imageblit,
> +       .fb_blank       =3D imx_ipu_fb_blank,
> +};
> +
> +/*
> + * Overlay functions
> + */
> +static int imx_ipu_fb_enable_overlay(struct fb_info *fbi)
> +{
> +       struct imx_ipu_fb_info *mxc_fbi =3D fbi->par;
> +
> +       ipu_dmfc_enable_channel(mxc_fbi->dmfc);
> +       ipu_idmac_enable_channel(mxc_fbi->ipu_ch);
> +       ipu_dp_enable_fg(mxc_fbi->dp);
> +
> +       return 0;
> +}
> +
> +static int imx_ipu_fb_disable_overlay(struct fb_info *fbi)
> +{
> +       struct imx_ipu_fb_info *mxc_fbi =3D fbi->par;
> +
> +       ipu_dp_disable_fg(mxc_fbi->dp);
> +       ipu_idmac_disable_channel(mxc_fbi->ipu_ch);
> +       ipu_dmfc_disable_channel(mxc_fbi->dmfc);
> +
> +       return 0;
> +}
> +
> +static int imx_ipu_fb_set_par_overlay(struct fb_info *fbi)
> +{
> +       struct imx_ipu_fb_info *mxc_fbi =3D fbi->par;
> +       struct fb_var_screeninfo *var =3D &fbi->var;
> +       struct fb_info *fbi_master =3D mxc_fbi->master;
> +       struct fb_var_screeninfo *var_master =3D &fbi_master->var;
> +       int ret;
> +       int interlaced =3D 0;
> +       int enabled =3D mxc_fbi->enabled;
> +
> +       dev_dbg(fbi->device, "Reconfiguring framebuffer %dx%d-%d\n",
> +               fbi->var.xres, fbi->var.yres, fbi->var.bits_per_pixel);
> +
> +       if (enabled)
> +               imx_ipu_fb_disable_overlay(fbi);
> +
> +       fbi->fix.line_length =3D var->xres_virtual *
> +                                  var->bits_per_pixel / 8;
> +
> +       ret =3D imx_ipu_fb_map_video_memory(fbi);
> +       if (ret)
> +               return ret;
> +
> +       ipu_dp_set_window_pos(mxc_fbi->dp, 64, 64);
> +
> +       var->xoffset =3D var->yoffset =3D 0;
> +
> +       if (var->vmode & FB_VMODE_INTERLACED)
> +               interlaced =3D 1;
> +
> +       ret =3D ipu_idmac_init_channel_buffer(mxc_fbi->ipu_ch,
> +                                       mxc_fbi->ipu_in_pix_fmt,
> +                                       var->xres, var->yres,
> +                                       fbi->fix.line_length,
> +                                       IPU_ROTATE_NONE,
> +                                       fbi->fix.smem_start,
> +                                       0,
> +                                       0, 0, interlaced);
> +       if (ret) {
> +               dev_dbg(fbi->device, "init channel buffer failed with %d\=
n",
> +                               ret);
> +               return ret;
> +       }
> +
> +       ret =3D ipu_dmfc_init_channel(mxc_fbi->dmfc, var->xres);
> +       if (ret) {
> +               dev_dbg(fbi->device, "initializing dmfc channel failed wi=
th %d\n",
> +                               ret);
> +               return ret;
> +       }
> +
> +       ret =3D ipu_dmfc_alloc_bandwidth(mxc_fbi->dmfc, calc_bandwidth(va=
r, calc_vref(var_master)));
> +       if (ret) {
> +               dev_dbg(fbi->device, "allocating dmfc bandwidth failed wi=
th %d\n",
> +                               ret);
> +               return ret;
> +       }
> +
> +       if (enabled)
> +               imx_ipu_fb_enable_overlay(fbi);
> +
> +       return ret;
> +}
> +
> +static int imx_ipu_fb_blank_overlay(int blank, struct fb_info *fbi)
> +{
> +       dev_dbg(fbi->device, "blank =3D %d\n", blank);
> +
> +       switch (blank) {
> +       case FB_BLANK_POWERDOWN:
> +       case FB_BLANK_VSYNC_SUSPEND:
> +       case FB_BLANK_HSYNC_SUSPEND:
> +       case FB_BLANK_NORMAL:
> +               imx_ipu_fb_disable_overlay(fbi);
> +               break;
> +       case FB_BLANK_UNBLANK:
> +               imx_ipu_fb_enable_overlay(fbi);
> +               break;
> +       }
> +
> +       return 0;
> +}
> +
> +static struct fb_ops imx_ipu_fb_overlay_ops =3D {
> +       .owner          =3D THIS_MODULE,
> +       .fb_set_par     =3D imx_ipu_fb_set_par_overlay,
> +       .fb_check_var   =3D imx_ipu_fb_check_var,
> +       .fb_setcolreg   =3D imx_ipu_fb_setcolreg,
> +       .fb_pan_display =3D imx_ipu_fb_pan_display,
> +       .fb_fillrect    =3D cfb_fillrect,
> +       .fb_copyarea    =3D cfb_copyarea,
> +       .fb_imageblit   =3D cfb_imageblit,
> +       .fb_blank       =3D imx_ipu_fb_blank_overlay,
> +};
> +
> +static struct fb_info *imx_ipu_fb_init_fbinfo(struct device *dev, struct=
 fb_ops *ops)
> +{
> +       struct fb_info *fbi;
> +       struct imx_ipu_fb_info *mxc_fbi;
> +
> +       fbi =3D framebuffer_alloc(sizeof(struct imx_ipu_fb_info), dev);
> +       if (!fbi)
> +               return NULL;
> +
> +       BUG_ON(fbi->par =3D=3D NULL);
> +       mxc_fbi =3D fbi->par;
> +
> +       fbi->var.activate =3D FB_ACTIVATE_NOW;
> +
> +       fbi->fbops =3D ops;
> +       fbi->flags =3D FBINFO_FLAG_DEFAULT;
> +       fbi->pseudo_palette =3D mxc_fbi->pseudo_palette;
> +
> +       fb_alloc_cmap(&fbi->cmap, 16, 0);
> +
> +       return fbi;
> +}
> +
> +static int imx_ipu_fb_init_overlay(struct platform_device *pdev,
> +               struct fb_info *fbi_master, int ipu_channel)
> +{
> +       struct imx_ipu_fb_info *mxc_fbi_master =3D fbi_master->par;
> +       struct fb_info *ovlfbi;
> +       struct imx_ipu_fb_info *ovl_mxc_fbi;
> +       int ret;
> +
> +       ovlfbi =3D imx_ipu_fb_init_fbinfo(&pdev->dev, &imx_ipu_fb_overlay=
_ops);
> +       if (!ovlfbi)
> +               return -ENOMEM;
> +
> +       ovl_mxc_fbi =3D ovlfbi->par;
> +       ovl_mxc_fbi->ipu_ch =3D ipu_idmac_get(ipu_channel);
> +       ovl_mxc_fbi->dmfc =3D ipu_dmfc_get(ipu_channel);
> +       ovl_mxc_fbi->ipu_di =3D -1;
> +       ovl_mxc_fbi->dp =3D mxc_fbi_master->dp;
> +       ovl_mxc_fbi->master =3D fbi_master;
> +       mxc_fbi_master->slave =3D ovlfbi;
> +
> +       ovlfbi->var.xres =3D 240;
> +       ovlfbi->var.yres =3D 320;
> +       ovlfbi->var.yres_virtual =3D ovlfbi->var.yres;
> +       ovlfbi->var.xres_virtual =3D ovlfbi->var.xres;
> +       imx_ipu_fb_check_var(&ovlfbi->var, ovlfbi);
> +       imx_ipu_fb_set_fix(ovlfbi);
> +
> +       ret =3D register_framebuffer(ovlfbi);
> +       if (ret) {
> +               framebuffer_release(ovlfbi);
> +               return ret;
> +       }
> +
> +       ipu_dp_set_global_alpha(ovl_mxc_fbi->dp, 1, 0x80, 1);
> +       ipu_dp_set_color_key(ovl_mxc_fbi->dp, 0, 0);
> +
> +       imx_ipu_fb_set_par_overlay(ovlfbi);
> +
> +       return 0;
> +}
> +
> +static void imx_ipu_fb_exit_overlay(struct platform_device *pdev,
> +               struct fb_info *fbi_master, int ipu_channel)
> +{
> +       struct imx_ipu_fb_info *mxc_fbi_master =3D fbi_master->par;
> +       struct fb_info *ovlfbi =3D mxc_fbi_master->slave;
> +       struct imx_ipu_fb_info *ovl_mxc_fbi =3D ovlfbi->par;
> +
> +       imx_ipu_fb_blank_overlay(FB_BLANK_POWERDOWN, ovlfbi);
> +
> +       unregister_framebuffer(ovlfbi);
> +
> +       ipu_idmac_put(ovl_mxc_fbi->ipu_ch);
> +       ipu_dmfc_free_bandwidth(ovl_mxc_fbi->dmfc);
> +       ipu_dmfc_put(ovl_mxc_fbi->dmfc);
> +
> +       framebuffer_release(ovlfbi);
> +}
> +
> +static int imx_ipu_fb_find_mode(struct fb_info *fbi)
> +{
> +       int ret;
> +       struct fb_videomode *mode_array;
> +       struct fb_modelist *modelist;
> +       struct fb_var_screeninfo *var =3D &fbi->var;
> +       int i =3D 0;
> +
> +       list_for_each_entry(modelist, &fbi->modelist, list)
> +               i++;
> +
> +       mode_array =3D kmalloc(sizeof (struct fb_modelist) * i, GFP_KERNE=
L);
> +       if (!mode_array)
> +               return -ENOMEM;
> +
> +       i =3D 0;
> +       list_for_each_entry(modelist, &fbi->modelist, list)
> +               mode_array[i++] =3D modelist->mode;
> +
> +       ret =3D fb_find_mode(&fbi->var, fbi, NULL, mode_array, i, NULL, 1=
6);
> +       if (ret =3D=3D 0)
> +               return -EINVAL;
> +
> +       dev_dbg(fbi->device, "found %dx%d-%d hs:%d:%d:%d vs:%d:%d:%d\n",
> +                       var->xres, var->yres, var->bits_per_pixel,
> +                       var->hsync_len, var->left_margin, var->right_marg=
in,
> +                       var->vsync_len, var->upper_margin, var->lower_mar=
gin);
> +
> +       kfree(mode_array);
> +
> +       return 0;
> +}
> +
> +static int __devinit imx_ipu_fb_probe(struct platform_device *pdev)
> +{
> +       struct fb_info *fbi;
> +       struct imx_ipu_fb_info *mxc_fbi;
> +       struct ipuv3_fb_platform_data *plat_data =3D pdev->dev.platform_d=
ata;
> +       int ret =3D 0, i;
> +
> +       pdev->dev.coherent_dma_mask =3D DMA_BIT_MASK(32);
> +
> +       fbi =3D imx_ipu_fb_init_fbinfo(&pdev->dev, &imx_ipu_fb_ops);
> +       if (!fbi)
> +               return -ENOMEM;
> +
> +       mxc_fbi =3D fbi->par;
> +
> +       mxc_fbi->ipu_channel_num =3D plat_data->ipu_channel_bg;
> +       mxc_fbi->dc =3D plat_data->dc_channel;
> +       mxc_fbi->ipu_di_pix_fmt =3D plat_data->interface_pix_fmt;
> +       mxc_fbi->ipu_di =3D pdev->id;
> +
> +       mxc_fbi->ipu_ch =3D ipu_idmac_get(plat_data->ipu_channel_bg);
> +       if (IS_ERR(mxc_fbi->ipu_ch)) {
> +               ret =3D PTR_ERR(mxc_fbi->ipu_ch);
> +               goto failed_request_ipu;
> +       }
> +
> +       mxc_fbi->dmfc =3D ipu_dmfc_get(plat_data->ipu_channel_bg);
> +       if (IS_ERR(mxc_fbi->ipu_ch)) {
> +               ret =3D PTR_ERR(mxc_fbi->ipu_ch);
> +               goto failed_request_dmfc;
> +       }
> +
> +       if (plat_data->dp_channel >=3D 0) {
> +               mxc_fbi->dp =3D ipu_dp_get(plat_data->dp_channel);
> +               if (IS_ERR(mxc_fbi->dp)) {
> +                       ret =3D PTR_ERR(mxc_fbi->ipu_ch);
> +                       goto failed_request_dp;
> +               }
> +       }
> +
> +       fbi->var.yres_virtual =3D fbi->var.yres;
> +
> +       INIT_LIST_HEAD(&fbi->modelist);
> +       for (i =3D 0; i < plat_data->num_modes; i++)
> +               fb_add_videomode(&plat_data->modes[i], &fbi->modelist);
> +
> +       if (plat_data->flags & IMX_IPU_FB_USE_MODEDB) {
> +               for (i =3D 0; i < num_fb_modes; i++)
> +                       fb_add_videomode(&fb_modes[i], &fbi->modelist);
> +       }
> +
> +       imx_ipu_fb_find_mode(fbi);
> +
> +       imx_ipu_fb_check_var(&fbi->var, fbi);
> +       imx_ipu_fb_set_fix(fbi);
> +       ret =3D register_framebuffer(fbi);
> +       if (ret < 0)
> +               goto failed_register;
> +
> +       imx_ipu_fb_set_par(fbi);
> +       imx_ipu_fb_blank(FB_BLANK_UNBLANK, fbi);
> +
> +       if (plat_data->ipu_channel_fg >=3D 0 && plat_data->flags & IMX_IP=
U_FB_USE_OVERLAY)
> +               imx_ipu_fb_init_overlay(pdev, fbi, plat_data->ipu_channel=
_fg);
> +
> +       platform_set_drvdata(pdev, fbi);
> +
> +       return 0;
> +
> +failed_register:
> +       if (plat_data->dp_channel >=3D 0)
> +               ipu_dp_put(mxc_fbi->dp);
> +failed_request_dp:
> +       ipu_dmfc_put(mxc_fbi->dmfc);
> +failed_request_dmfc:
> +       ipu_idmac_put(mxc_fbi->ipu_ch);
> +failed_request_ipu:
> +       fb_dealloc_cmap(&fbi->cmap);
> +       framebuffer_release(fbi);
> +
> +       return ret;
> +}
> +
> +static int __devexit imx_ipu_fb_remove(struct platform_device *pdev)
> +{
> +       struct fb_info *fbi =3D platform_get_drvdata(pdev);
> +       struct imx_ipu_fb_info *mxc_fbi =3D fbi->par;
> +       struct ipuv3_fb_platform_data *plat_data =3D pdev->dev.platform_d=
ata;
> +
> +       if (plat_data->ipu_channel_fg >=3D 0 && plat_data->flags & IMX_IP=
U_FB_USE_OVERLAY)
> +               imx_ipu_fb_exit_overlay(pdev, fbi, plat_data->ipu_channel=
_fg);
> +
> +       imx_ipu_fb_blank(FB_BLANK_POWERDOWN, fbi);
> +
> +       dma_free_writecombine(fbi->device, fbi->fix.smem_len,
> +                             fbi->screen_base, fbi->fix.smem_start);
> +
> +       if (&fbi->cmap)
> +               fb_dealloc_cmap(&fbi->cmap);
> +
> +       unregister_framebuffer(fbi);
> +
> +       if (plat_data->dp_channel >=3D 0)
> +               ipu_dp_put(mxc_fbi->dp);
> +       ipu_dmfc_free_bandwidth(mxc_fbi->dmfc);
> +       ipu_dmfc_put(mxc_fbi->dmfc);
> +       ipu_idmac_put(mxc_fbi->ipu_ch);
> +
> +       framebuffer_release(fbi);
> +
> +       return 0;
> +}
> +
> +static struct platform_driver imx_ipu_fb_driver =3D {
> +       .driver =3D {
> +               .name =3D DRIVER_NAME,
> +       },
> +       .probe =3D imx_ipu_fb_probe,
> +       .remove =3D __devexit_p(imx_ipu_fb_remove),
> +};
> +
> +static int __init imx_ipu_fb_init(void)
> +{
> +       return platform_driver_register(&imx_ipu_fb_driver);
> +}
> +
> +static void __exit imx_ipu_fb_exit(void)
> +{
> +       platform_driver_unregister(&imx_ipu_fb_driver);
> +}
> +
> +module_init(imx_ipu_fb_init);
> +module_exit(imx_ipu_fb_exit);
> +
> +MODULE_AUTHOR("Freescale Semiconductor, Inc.");
> +MODULE_DESCRIPTION("i.MX framebuffer driver");
> +MODULE_LICENSE("GPL");
> +MODULE_SUPPORTED_DEVICE("fb");
> --
> 1.7.2.3
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" i=
n
> the body of a message to majordomo@vger.kernel.org<mailto:majordomo@vger.=
kernel.org>
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
--
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
the body of a message to majordomo@vger.kernel.org<mailto:majordomo@vger.ke=
rnel.org>
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/


--_000_33F32152BE7EC740BC2C838D2836AC8704A9F5039SN1MPN1002039d_
Content-Disposition: attachment; filename="winmail.dat"
Content-Transfer-Encoding: base64
Content-Type: application/ms-tnef; name="winmail.dat"

eJ8+IvgSAQaQCAAEAAAAAAABAAEAAQeQBgAIAAAA5AQAAAAAAADoAAEJgAEAIQAAAEMyMkM4OURF
OTdEMjEzNENCOUU2NTBEMkMwQTIzNTgxAC0HAQ2ABAACAAAAAgACAAEFgAMADgAAANoHDAAOAAwA
JgAIAAIANwEBIIADAA4AAADaBwwADgAMACQAIQACAE4BAQiABwAYAAAASVBNLk1pY3Jvc29mdCBN
YWlsLk5vdGUAMQgBBIABAC0AAABSRTogW1BBVENIIDUvOV0gQWRkIGkuTVg1IGZyYW1lYnVmZmVy
IGRyaXZlcgDhDQEDkAYA0AkBAIIAAAACAX8AAQAAAEsAAAA8MzNGMzIxNTJCRTdFQzc0MEJDMkM4
MzhEMjgzNkFDODcwNEE5RjVAMDM5LVNOMU1QTjEtMDAyLjAzOWQubWdkLm1zZnQubmV0PgAAAgET
EAEAAABw9AAAPGh0bWwgeG1sbnM6dj0idXJuOnNjaGVtYXMtbWljcm9zb2Z0LWNvbTp2bWwiIHht
bG5zOm89InVybjpzY2hlbWFzLW1pY3Jvc29mdC1jb206b2ZmaWNlOm9mZmljZSIgeG1sbnM6dz0i
dXJuOnNjaGVtYXMtbWljcm9zb2Z0LWNvbTpvZmZpY2U6d29yZCIgeG1sbnM6bT0iaHR0cDovL3Nj
aGVtYXMubWljcm9zb2Z0LmNvbS9vZmZpY2UvMjAwNC8xMi9vbW1sIiB4bWxucz0iaHR0cDovL3d3
dy53My5vcmcvVFIvUkVDLWh0bWw0MCI+PGhlYWQ+PG1ldGEgaHR0cC1lcXVpdj1Db250ZW50LVR5
cGUgY29udGVudD0idGV4dC9odG1sOyBjaGFyc2V0PXVzLWFzY2lpIj48bWV0YSBuYW1lPUdlbmVy
YXRvciBjb250ZW50PSJNaWNyb3NvZnQgV29yZCAxMiAoZmlsdGVyZWQgbWVkaXVtKSI+PHN0eWxl
PjwhLS0NCi8qIEZvbnQgRGVmaW5pdGlvbnMgKi8NCkBmb250LWZhY2UNCgl7Zm9udC1mYW1pbHk6
U2ltU3VuOw0KCXBhbm9zZS0xOjIgMSA2IDAgMyAxIDEgMSAxIDE7fQ0KQGZvbnQtZmFjZQ0KCXtm
b250LWZhbWlseTpTaW1TdW47DQoJcGFub3NlLTE6MiAxIDYgMCAzIDEgMSAxIDEgMTt9DQpAZm9u
dC1mYWNlDQoJe2ZvbnQtZmFtaWx5OkNhbGlicmk7DQoJcGFub3NlLTE6MiAxNSA1IDIgMiAyIDQg
MyAyIDQ7fQ0KQGZvbnQtZmFjZQ0KCXtmb250LWZhbWlseTpUYWhvbWE7DQoJcGFub3NlLTE6MiAx
MSA2IDQgMyA1IDQgNCAyIDQ7fQ0KQGZvbnQtZmFjZQ0KCXtmb250LWZhbWlseToiQ29taWMgU2Fu
cyBNUyI7DQoJcGFub3NlLTE6MyAxNSA3IDIgMyAzIDIgMiAyIDQ7fQ0KQGZvbnQtZmFjZQ0KCXtm
b250LWZhbWlseTpTaW1TdW47DQoJcGFub3NlLTE6MiAxIDYgMCAzIDEgMSAxIDEgMTt9DQovKiBT
dHlsZSBEZWZpbml0aW9ucyAqLw0KcC5Nc29Ob3JtYWwsIGxpLk1zb05vcm1hbCwgZGl2Lk1zb05v
cm1hbA0KCXttYXJnaW46MGluOw0KCW1hcmdpbi1ib3R0b206LjAwMDFwdDsNCglmb250LXNpemU6
MTIuMHB0Ow0KCWZvbnQtZmFtaWx5OiJUaW1lcyBOZXcgUm9tYW4iLCJzZXJpZiI7fQ0KYTpsaW5r
LCBzcGFuLk1zb0h5cGVybGluaw0KCXttc28tc3R5bGUtcHJpb3JpdHk6OTk7DQoJY29sb3I6Ymx1
ZTsNCgl0ZXh0LWRlY29yYXRpb246dW5kZXJsaW5lO30NCmE6dmlzaXRlZCwgc3Bhbi5Nc29IeXBl
cmxpbmtGb2xsb3dlZA0KCXttc28tc3R5bGUtcHJpb3JpdHk6OTk7DQoJY29sb3I6cHVycGxlOw0K
CXRleHQtZGVjb3JhdGlvbjp1bmRlcmxpbmU7fQ0Kc3Bhbi5FbWFpbFN0eWxlMTcNCgl7bXNvLXN0
eWxlLXR5cGU6cGVyc29uYWw7DQoJZm9udC1mYW1pbHk6IkNhbGlicmkiLCJzYW5zLXNlcmlmIjsN
Cgljb2xvcjojMUY0OTdEO30NCnNwYW4uRW1haWxTdHlsZTE4DQoJe21zby1zdHlsZS10eXBlOnBl
cnNvbmFsLXJlcGx5Ow0KCWZvbnQtZmFtaWx5OiJDYWxpYnJpIiwic2Fucy1zZXJpZiI7DQoJY29s
b3I6IzFGNDk3RDt9DQouTXNvQ2hwRGVmYXVsdA0KCXttc28tc3R5bGUtdHlwZTpleHBvcnQtb25s
eTsNCglmb250LXNpemU6MTAuMHB0O30NCkBwYWdlIFdvcmRTZWN0aW9uMQ0KCXtzaXplOjguNWlu
IDExLjBpbjsNCgltYXJnaW46MS4waW4gMS4yNWluIDEuMGluIDEuMjVpbjt9DQpkaXYuV29yZFNl
Y3Rpb24xDQoJe3BhZ2U6V29yZFNlY3Rpb24xO30NCi0tPjwvc3R5bGU+PCEtLVtpZiBndGUgbXNv
IDldPjx4bWw+DQo8bzpzaGFwZWRlZmF1bHRzIHY6ZXh0PSJlZGl0IiBzcGlkbWF4PSIxMDI2IiAv
Pg0KPC94bWw+PCFbZW5kaWZdLS0+PCEtLVtpZiBndGUgbXNvIDldPjx4bWw+DQo8bzpzaGFwZWxh
eW91dCB2OmV4dD0iZWRpdCI+DQo8bzppZG1hcCB2OmV4dD0iZWRpdCIgZGF0YT0iMSIgLz4NCjwv
bzpzaGFwZWxheW91dD48L3htbD48IVtlbmRpZl0tLT48L2hlYWQ+PGJvZHkgbGFuZz1FTi1VUyBs
aW5rPWJsdWUgdmxpbms9cHVycGxlPjxkaXYgY2xhc3M9V29yZFNlY3Rpb24xPjxwIGNsYXNzPU1z
b05vcm1hbD48c3BhbiBzdHlsZT0nZm9udC1zaXplOjExLjBwdDtmb250LWZhbWlseToiQ2FsaWJy
aSIsInNhbnMtc2VyaWYiO2NvbG9yOiMxRjQ5N0QnPkhpLCBTYXNjaGEsPG86cD48L286cD48L3Nw
YW4+PC9wPjxwIGNsYXNzPU1zb05vcm1hbD48c3BhbiBzdHlsZT0nZm9udC1zaXplOjExLjBwdDtm
b250LWZhbWlseToiQ2FsaWJyaSIsInNhbnMtc2VyaWYiO2NvbG9yOiMxRjQ5N0QnPjxvOnA+Jm5i
c3A7PC9vOnA+PC9zcGFuPjwvcD48cCBjbGFzcz1Nc29Ob3JtYWw+PHNwYW4gc3R5bGU9J2ZvbnQt
c2l6ZToxMS4wcHQ7Zm9udC1mYW1pbHk6IkNhbGlicmkiLCJzYW5zLXNlcmlmIjtjb2xvcjojMUY0
OTdEJz5GZXcgY29tbWVudHMgaW5saW5lIHdpdGggW0phc29uXTxvOnA+PC9vOnA+PC9zcGFuPjwv
cD48cCBjbGFzcz1Nc29Ob3JtYWw+PHNwYW4gc3R5bGU9J2ZvbnQtc2l6ZToxMS4wcHQ7Zm9udC1m
YW1pbHk6IkNhbGlicmkiLCJzYW5zLXNlcmlmIjtjb2xvcjojMUY0OTdEJz48bzpwPiZuYnNwOzwv
bzpwPjwvc3Bhbj48L3A+PGRpdj48cCBjbGFzcz1Nc29Ob3JtYWwgc3R5bGU9J21zby1tYXJnaW4t
dG9wLWFsdDphdXRvO21zby1tYXJnaW4tYm90dG9tLWFsdDphdXRvJz48Yj48c3BhbiBzdHlsZT0n
Zm9udC1zaXplOjEwLjBwdDtmb250LWZhbWlseToiQ29taWMgU2FucyBNUyI7Y29sb3I6YmxhY2sn
Pkphc29uIENoZW4gLyBDaGVuIDwvc3Bhbj48L2I+PGI+PHNwYW4gc3R5bGU9J2ZvbnQtc2l6ZTox
MC4wcHQ7Zm9udC1mYW1pbHk6IkNvbWljIFNhbnMgTVMiO2NvbG9yOmJsYWNrJz5KaWU8L3NwYW4+
PC9iPjxzcGFuIHN0eWxlPSdmb250LWZhbWlseToiQXJpYWwiLCJzYW5zLXNlcmlmIjtjb2xvcjoj
MUY0OTdEJz48bzpwPjwvbzpwPjwvc3Bhbj48L3A+PHAgY2xhc3M9TXNvTm9ybWFsIHN0eWxlPSdt
c28tbWFyZ2luLXRvcC1hbHQ6YXV0bzttc28tbWFyZ2luLWJvdHRvbS1hbHQ6YXV0byc+PGI+PHNw
YW4gc3R5bGU9J2ZvbnQtc2l6ZToxMC4wcHQ7Zm9udC1mYW1pbHk6IkNvbWljIFNhbnMgTVMiO2Nv
bG9yOmJsYWNrJz5OTUcgLyBNQUQ8L3NwYW4+PC9iPjxzcGFuIHN0eWxlPSdmb250LWZhbWlseTpT
aW1TdW47Y29sb3I6bmF2eSc+PG86cD48L286cD48L3NwYW4+PC9wPjxwIGNsYXNzPU1zb05vcm1h
bCBzdHlsZT0nbXNvLW1hcmdpbi10b3AtYWx0OmF1dG87bXNvLW1hcmdpbi1ib3R0b20tYWx0OmF1
dG8nPjxiPjxzcGFuIHN0eWxlPSdmb250LXNpemU6MTAuMHB0O2ZvbnQtZmFtaWx5OiJBcmlhbCIs
InNhbnMtc2VyaWYiO2NvbG9yOmJsYWNrJz5GcmVlc2NhbGUgU2VtaWNvbmR1Y3RvciAoQ2hpbmEp
IEx0ZC48L3NwYW4+PC9iPjxiPjxzcGFuIHN0eWxlPSdmb250LXNpemU6MTAuMHB0O2ZvbnQtZmFt
aWx5OiJBcmlhbCIsInNhbnMtc2VyaWYiO2NvbG9yOmJsYWNrJz48bzpwPjwvbzpwPjwvc3Bhbj48
L2I+PC9wPjxwIGNsYXNzPU1zb05vcm1hbCBzdHlsZT0nbXNvLW1hcmdpbi10b3AtYWx0OmF1dG87
bXNvLW1hcmdpbi1ib3R0b20tYWx0OmF1dG8nPjxiPjxzcGFuIHN0eWxlPSdmb250LXNpemU6MTAu
MHB0O2ZvbnQtZmFtaWx5OiJBcmlhbCIsInNhbnMtc2VyaWYiO2NvbG9yOmJsYWNrJz4yRiwgQnVp
bGRpbmcgQiwgMTc3IywgQmkgQm8gUmQ8bzpwPjwvbzpwPjwvc3Bhbj48L2I+PC9wPjxwIGNsYXNz
PU1zb05vcm1hbCBzdHlsZT0nbXNvLW1hcmdpbi10b3AtYWx0OmF1dG87bXNvLW1hcmdpbi1ib3R0
b20tYWx0OmF1dG8nPjxiPjxzcGFuIHN0eWxlPSdmb250LXNpemU6MTAuMHB0O2ZvbnQtZmFtaWx5
OiJBcmlhbCIsInNhbnMtc2VyaWYiO2NvbG9yOmJsYWNrJz5QdTwvc3Bhbj48L2I+PGI+PHNwYW4g
c3R5bGU9J2ZvbnQtc2l6ZToxMC4wcHQ7Zm9udC1mYW1pbHk6IkFyaWFsIiwic2Fucy1zZXJpZiI7
Y29sb3I6YmxhY2snPiBEb25nIE5ldyBEaXN0cmljdCBTaGFuZ2hhaSZuYnNwOzIwMTIwMzxvOnA+
PC9vOnA+PC9zcGFuPjwvYj48L3A+PHAgY2xhc3M9TXNvTm9ybWFsIHN0eWxlPSdtc28tbWFyZ2lu
LXRvcC1hbHQ6YXV0bzttc28tbWFyZ2luLWJvdHRvbS1hbHQ6YXV0byc+PGI+PHNwYW4gc3R5bGU9
J2ZvbnQtc2l6ZToxMC4wcHQ7Zm9udC1mYW1pbHk6IkNvbWljIFNhbnMgTVMiO2NvbG9yOmJsYWNr
Jz5UZWw6Jm5ic3A7Jm5ic3A7Jm5ic3A7Jm5ic3A7IDAyMS0yODkzNzE3OCZuYnNwOzxvOnA+PC9v
OnA+PC9zcGFuPjwvYj48L3A+PHAgY2xhc3M9TXNvTm9ybWFsIHN0eWxlPSdtc28tbWFyZ2luLXRv
cC1hbHQ6YXV0bzttc28tbWFyZ2luLWJvdHRvbS1hbHQ6YXV0byc+PGI+PHNwYW4gc3R5bGU9J2Zv
bnQtc2l6ZToxMC4wcHQ7Zm9udC1mYW1pbHk6IkNvbWljIFNhbnMgTVMiO2NvbG9yOmJsYWNrJz5G
YXg6Jm5ic3A7Jm5ic3A7Jm5ic3A7Jm5ic3A7IDAyMS0yODkzNzQ0NDwvc3Bhbj48L2I+PHNwYW4g
c3R5bGU9J2ZvbnQtZmFtaWx5OlNpbVN1bjtjb2xvcjojMUY0OTdEJz48bzpwPjwvbzpwPjwvc3Bh
bj48L3A+PHAgY2xhc3M9TXNvTm9ybWFsIHN0eWxlPSdtc28tbWFyZ2luLXRvcC1hbHQ6YXV0bztt
c28tbWFyZ2luLWJvdHRvbS1hbHQ6YXV0byc+PGI+PHNwYW4gc3R5bGU9J2ZvbnQtc2l6ZToxMC4w
cHQ7Zm9udC1mYW1pbHk6IkNvbWljIFNhbnMgTVMiO2NvbG9yOmJsYWNrJz5FLW1haWw6Jm5ic3A7
Jm5ic3A7PC9zcGFuPjwvYj48Yj48c3BhbiBzdHlsZT0nZm9udC1zaXplOjEwLjBwdDtmb250LWZh
bWlseToiQ29taWMgU2FucyBNUyI7Y29sb3I6Ymx1ZSc+PGEgaHJlZj0ibWFpbHRvOkphc29uLkNo
ZW5AZnJlZXNjYWxlLmNvbSIgdGl0bGU9Im1haWx0bzpKYXNvbi5DaGVuQGZyZWVzY2FsZS5jb20i
Pkphc29uLkNoZW5AZnJlZXNjYWxlLmNvbTwvYT48L3NwYW4+PC9iPjxiPjxzcGFuIHN0eWxlPSdm
b250LWZhbWlseTpTaW1TdW47Y29sb3I6YmxhY2snPjxvOnA+PC9vOnA+PC9zcGFuPjwvYj48L3A+
PC9kaXY+PHAgY2xhc3M9TXNvTm9ybWFsPjxzcGFuIHN0eWxlPSdmb250LXNpemU6MTEuMHB0O2Zv
bnQtZmFtaWx5OiJDYWxpYnJpIiwic2Fucy1zZXJpZiI7Y29sb3I6IzFGNDk3RCc+PG86cD4mbmJz
cDs8L286cD48L3NwYW4+PC9wPjxkaXYgc3R5bGU9J2JvcmRlcjpub25lO2JvcmRlci10b3A6c29s
aWQgI0I1QzRERiAxLjBwdDtwYWRkaW5nOjMuMHB0IDBpbiAwaW4gMGluJz48cCBjbGFzcz1Nc29O
b3JtYWw+PGI+PHNwYW4gc3R5bGU9J2ZvbnQtc2l6ZToxMC4wcHQ7Zm9udC1mYW1pbHk6IlRhaG9t
YSIsInNhbnMtc2VyaWYiJz5Gcm9tOjwvc3Bhbj48L2I+PHNwYW4gc3R5bGU9J2ZvbnQtc2l6ZTox
MC4wcHQ7Zm9udC1mYW1pbHk6IlRhaG9tYSIsInNhbnMtc2VyaWYiJz4gSmFzb24gQ2hlbiBbbWFp
bHRvOndlaXR3YXlAZ21haWwuY29tXSA8YnI+PGI+U2VudDo8L2I+IFR1ZXNkYXksIERlY2VtYmVy
IDE0LCAyMDEwIDM6MzUgUE08YnI+PGI+VG86PC9iPiBDaGVuIEppZS1CMDIyODA8YnI+PGI+U3Vi
amVjdDo8L2I+IEZ3ZDogW1BBVENIIDUvOV0gQWRkIGkuTVg1IGZyYW1lYnVmZmVyIGRyaXZlcjxv
OnA+PC9vOnA+PC9zcGFuPjwvcD48L2Rpdj48cCBjbGFzcz1Nc29Ob3JtYWw+PG86cD4mbmJzcDs8
L286cD48L3A+PHAgY2xhc3M9TXNvTm9ybWFsIHN0eWxlPSdtYXJnaW4tYm90dG9tOjEyLjBwdCc+
PG86cD4mbmJzcDs8L286cD48L3A+PGRpdj48cCBjbGFzcz1Nc29Ob3JtYWw+LS0tLS0tLS0tLSBG
b3J3YXJkZWQgbWVzc2FnZSAtLS0tLS0tLS0tPGJyPkZyb206IDxiPkxpdSBZaW5nPC9iPiAmbHQ7
PGEgaHJlZj0ibWFpbHRvOmxpdS55LnZpY3RvckBnbWFpbC5jb20iPmxpdS55LnZpY3RvckBnbWFp
bC5jb208L2E+Jmd0Ozxicj5EYXRlOiAyMDEwLzEyLzEyPGJyPlN1YmplY3Q6IFJlOiBbUEFUQ0gg
NS85XSBBZGQgaS5NWDUgZnJhbWVidWZmZXIgZHJpdmVyPGJyPlRvOiBTYXNjaGEgSGF1ZXIgJmx0
OzxhIGhyZWY9Im1haWx0bzpzLmhhdWVyQHBlbmd1dHJvbml4LmRlIj5zLmhhdWVyQHBlbmd1dHJv
bml4LmRlPC9hPiZndDs8YnI+Q2M6IDxhIGhyZWY9Im1haWx0bzpsaW51eC1hcm0ta2VybmVsQGxp
c3RzLmluZnJhZGVhZC5vcmciPmxpbnV4LWFybS1rZXJuZWxAbGlzdHMuaW5mcmFkZWFkLm9yZzwv
YT4sIDxhIGhyZWY9Im1haWx0bzpsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnIj5saW51eC1r
ZXJuZWxAdmdlci5rZXJuZWwub3JnPC9hPiwgPGEgaHJlZj0ibWFpbHRvOmxpbnV4LWZiZGV2QHZn
ZXIua2VybmVsLm9yZyI+bGludXgtZmJkZXZAdmdlci5rZXJuZWwub3JnPC9hPiwgWmhhbmcgTGls
eS1SNTgwNjYgJmx0OzxhIGhyZWY9Im1haWx0bzpyNTgwNjZAZnJlZXNjYWxlLmNvbSI+cjU4MDY2
QGZyZWVzY2FsZS5jb208L2E+Jmd0OywgQXJuYXVkIFBhdGFyZCAmbHQ7PGEgaHJlZj0ibWFpbHRv
OmFybmF1ZC5wYXRhcmRAcnRwLW5ldC5vcmciPmFybmF1ZC5wYXRhcmRAcnRwLW5ldC5vcmc8L2E+
Jmd0Ozxicj48YnI+PGJyPkhlbGxvLCBTYXNjaGEsPGJyPjxicj5JIGhhdmUgZm9sbG93aW5nIGNv
bW1lbnRzIHRvIHRoaXMgcGF0Y2g6PGJyPjEpIFBsZWFzZSBtb2RpZnkgdGhlIGNvbW1pdCBtZXNz
YWdlLCBhcyBJUFV2MyBpcyBub3QgZW1iZWRkZWQgaW4gaS5NWDUwIFNvQy48YnI+MikgQURDIGlz
IG5vdCBzdXBwb3J0ZWQgeWV0IGluIHRoZSBmcmFtZWJ1ZmZlciBkcml2ZXIsIHNvIHBsZWFzZTxi
cj5tb2RpZnkgdGhpcyBjb21tZW50OjxvOnA+PC9vOnA+PC9wPjxkaXY+PHAgY2xhc3M9TXNvTm9y
bWFsPiZuYnNwOyAmZ3Q7ICsgKiBGcmFtZWJ1ZmZlciBGcmFtZWJ1ZmZlciBEcml2ZXIgZm9yIFNE
QyBhbmQgQURDLjxvOnA+PC9vOnA+PC9wPjwvZGl2PjxwIGNsYXNzPU1zb05vcm1hbD4zKSAnaXB1
X2RwX3NldF93aW5kb3dfcG9zKCknIGlzIGNhbGxlZCBvbmx5IG9uY2UgaW48YnI+aW14X2lwdV9m
Yl9zZXRfcGFyX292ZXJsYXkoKS4gU28sIHRoZSBmcmFtZWJ1ZmZlciBkcml2ZXIgZG9lc24ndDxi
cj5zdXBwb3J0IHRvIGNoYW5nZSB0aGUgb3ZlcmxheSBmcmFtZWJ1ZmZlciBwb3NpdGlvbi4gTmVl
ZCBhPGJyPm1lY2hhbmlzbS9pbnRlcmZhY2UgZm9yIHVzZXJzIHRvIGNoYW5nZSB0aGUgb3Zlcmxh
eSBmcmFtZWJ1ZmZlcjxicj5wb3NpdGlvbi48c3BhbiBzdHlsZT0nY29sb3I6IzFGNDk3RCc+PG86
cD48L286cD48L3NwYW4+PC9wPjxwIGNsYXNzPU1zb05vcm1hbD48Yj48aT48c3BhbiBzdHlsZT0n
Zm9udC1zaXplOjExLjBwdDtmb250LWZhbWlseToiQ2FsaWJyaSIsInNhbnMtc2VyaWYiO2NvbG9y
OiMxRjQ5N0QnPltKYXNvbl0gRFAtRkcgc2hvdWxkIGJlIG9uZSBmYiBkZXZpY2UsIHNlcXVlbmNl
IGlvY3RsIHNob3VsZCBiZSBhZGRlZCBhZnRlciBpdCwgbGlrZSBnbG9iYWwgYWxwaGEgLCBjb2xv
ciBrZXkgZXRjLjxvOnA+PC9vOnA+PC9zcGFuPjwvaT48L2I+PC9wPjxwIGNsYXNzPU1zb05vcm1h
bD48YnI+NCkgTmVlZCB0byBtYWtlIHN1cmUgdGhlIGZyYW1lYnVmZmVyIG9uIERQLUZHIGlzIGJs
YW5rZWQgYmVmb3JlIHRoZTxicj5mcmFtZWJ1ZmZlciBvbiBEUC1CRyBpcyBibGFua2VkLiBNZWFu
d2hpbGUsIHRoZSBmcmFtZWJ1ZmZlciBvbiBEUC1GRzxicj5zaG91bGQgYmUgdW5ibGFua2VkIGFm
dGVyIHRoZSBmcmFtZWJ1ZmZlciBvbiBEUC1CRyBpcyB1bmJsYW5rZWQ8YnI+NSkgTmVlZCB0byBj
aGVjayB0aGUgZnJhbWVidWZmZXIgb24gRFAtRkcgZG9lc24ndCBydW4gb3V0IG9mIHRoZSByYW5n
ZTxicj5vZiB0aGUgZnJhbWVidWZmZXIgb24gRFAtQkcuPGJyPjYpIEkgcHJlZmVyIHRvIGZpbmQg
dGhlIHZpZGVvIG1vZGUgaW4gbW9kZWRiIGZpcnN0LCBhbmQgaWYgd2UgY2Fubm90PGJyPmZpbmQg
dGhlIHZpZGVvIG1vZGUgaW4gY29tbW9uIHZpZGVvIG1vZGUgZGF0YSBiYXNlLCB3ZSBjYW4gZmlu
ZCBhPGJyPnZpZGVvIG1vZGUgaW4gY3VzdG9tIHZpZGVvIG1vZGUgZGF0YSBiYXNlIHdoaWNoIGlz
IGRlZmluZWQgaW4gcGxhdGZvcm08YnI+ZGF0YS4gSW4gdGhpcyB3YXksIHdlIGRvbid0IG5lZWQg
dG8gZXhwb3J0IGNvbW1vbiBtb2RlZmIuPGJyPjxicj5CZXN0IFJlZ2FyZHMsPGJyPkxpdSBZaW5n
PGJyPjxicj48YnI+MjAxMC8xMi85IFNhc2NoYSBIYXVlciAmbHQ7PGEgaHJlZj0ibWFpbHRvOnMu
aGF1ZXJAcGVuZ3V0cm9uaXguZGUiPnMuaGF1ZXJAcGVuZ3V0cm9uaXguZGU8L2E+Jmd0Ozo8bzpw
PjwvbzpwPjwvcD48ZGl2PjxkaXY+PHAgY2xhc3M9TXNvTm9ybWFsPiZndDsgVGhpcyBwYXRjaCBh
ZGRzIGZyYW1lYnVmZmVyIHN1cHBvcnQgdG8gdGhlIEZyZWVzY2FsZSBpLk1YIFNvQ3M8YnI+Jmd0
OyBlcXVpcHBlZCB3aXRoIGFuIElQVSB2Mywgc28gZmFyIHRoZXNlIGFyZSB0aGUgaS5NWDUwLzUx
LzUzLjxicj4mZ3Q7PGJyPiZndDsgVGhpcyBkcml2ZXIgaGFzIGJlZW4gdGVzdGVkIG9uIHRoZSBp
Lk1YNTEgYmFiYmFnZSBib2FyZCB3aXRoPGJyPiZndDsgYm90aCBEVkkgYW5kIGFuYWxvZyBWR0Eg
aW4gZGlmZmVyZW50IHJlc29sdXRpb25zIGFuZCBjb2xvciBkZXB0aHMuPGJyPiZndDsgSXQgaGFz
IGFsc28gYmVlbiB0ZXN0ZWQgb24gYSBjdXN0b20gaS5NWDUxIGJvYXJkIHVzaW5nIGEgZml4ZWQ8
YnI+Jmd0OyByZXNvbHV0aW9uIHBhbmVsLjxicj4mZ3Q7PGJyPiZndDsgU2lnbmVkLW9mZi1ieTog
U2FzY2hhIEhhdWVyICZsdDs8YSBocmVmPSJtYWlsdG86cy5oYXVlckBwZW5ndXRyb25peC5kZSI+
cy5oYXVlckBwZW5ndXRyb25peC5kZTwvYT4mZ3Q7PGJyPiZndDsgLS0tPGJyPiZndDsgJm5ic3A7
ZHJpdmVycy92aWRlby9LY29uZmlnICZuYnNwO3wgJm5ic3A7IDExICs8YnI+Jmd0OyAmbmJzcDtk
cml2ZXJzL3ZpZGVvL01ha2VmaWxlIHwgJm5ic3A7ICZuYnNwOzEgKzxicj4mZ3Q7ICZuYnNwO2Ry
aXZlcnMvdmlkZW8vbXg1ZmIuYyAmbmJzcDt8ICZuYnNwOzg0NiArKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKys8YnI+Jmd0OyAmbmJzcDszIGZpbGVzIGNoYW5n
ZWQsIDg1OCBpbnNlcnRpb25zKCspLCAwIGRlbGV0aW9ucygtKTxicj4mZ3Q7ICZuYnNwO2NyZWF0
ZSBtb2RlIDEwMDY0NCBkcml2ZXJzL3ZpZGVvL214NWZiLmM8YnI+Jmd0Ozxicj4mZ3Q7IGRpZmYg
LS1naXQgYS9kcml2ZXJzL3ZpZGVvL0tjb25maWcgYi9kcml2ZXJzL3ZpZGVvL0tjb25maWc8YnI+
Jmd0OyBpbmRleCAyN2MxZmI0Li4xOTAxOTE1IDEwMDY0NDxicj4mZ3Q7IC0tLSBhL2RyaXZlcnMv
dmlkZW8vS2NvbmZpZzxicj4mZ3Q7ICsrKyBiL2RyaXZlcnMvdmlkZW8vS2NvbmZpZzxicj4mZ3Q7
IEBAIC0yMjM2LDYgKzIyMzYsMTcgQEAgY29uZmlnIEZCX01YMzxicj4mZ3Q7ICZuYnNwOyAmbmJz
cDsgJm5ic3A7ICZuYnNwOyAmbmJzcDtmYXIgb25seSBzeW5jaHJvbm91cyBkaXNwbGF5cyBhcmUg
c3VwcG9ydGVkLiBJZiB5b3UgcGxhbiB0byB1c2U8YnI+Jmd0OyAmbmJzcDsgJm5ic3A7ICZuYnNw
OyAmbmJzcDsgJm5ic3A7YW4gTENEIGRpc3BsYXkgd2l0aCB5b3VyIGkuTVgzMSBzeXN0ZW0sIHNh
eSBZIGhlcmUuPGJyPiZndDs8YnI+Jmd0OyArY29uZmlnIEZCX01YNTxicj4mZ3Q7ICsgJm5ic3A7
ICZuYnNwOyAmbmJzcDsgdHJpc3RhdGUgJnF1b3Q7TVg1IEZyYW1lYnVmZmVyIHN1cHBvcnQmcXVv
dDs8YnI+Jmd0OyArICZuYnNwOyAmbmJzcDsgJm5ic3A7IGRlcGVuZHMgb24gRkIgJmFtcDsmYW1w
OyBNRkRfSU1YX0lQVV9WMzxicj4mZ3Q7ICsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgc2VsZWN0IEZC
X0NGQl9GSUxMUkVDVDxicj4mZ3Q7ICsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgc2VsZWN0IEZCX0NG
Ql9DT1BZQVJFQTxicj4mZ3Q7ICsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgc2VsZWN0IEZCX0NGQl9J
TUFHRUJMSVQ8YnI+Jmd0OyArICZuYnNwOyAmbmJzcDsgJm5ic3A7IHNlbGVjdCBGQl9NT0RFX0hF
TFBFUlM8YnI+Jmd0OyArICZuYnNwOyAmbmJzcDsgJm5ic3A7IGhlbHA8YnI+Jmd0OyArICZuYnNw
OyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBUaGlzIGlzIGEgZnJhbWVidWZmZXIgZGV2aWNlIGZvciB0
aGUgaS5NWDUxIExDRCBDb250cm9sbGVyLiBJZiB5b3U8YnI+Jmd0OyArICZuYnNwOyAmbmJzcDsg
Jm5ic3A7ICZuYnNwOyBwbGFuIHRvIHVzZSBhbiBMQ0QgZGlzcGxheSB3aXRoIHlvdXIgaS5NWDUx
IHN5c3RlbSwgc2F5IFkgaGVyZS48YnI+Jmd0OyArPGJyPiZndDsgJm5ic3A7Y29uZmlnIEZCX0JS
T0FEU0hFRVQ8YnI+Jmd0OyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDt0cmlzdGF0ZSAmcXVv
dDtFLUluayBCcm9hZHNoZWV0L0Vwc29uIFMxRDEzNTIxIGNvbnRyb2xsZXIgc3VwcG9ydCZxdW90
Ozxicj4mZ3Q7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwO2RlcGVuZHMgb24gRkI8YnI+Jmd0
OyBkaWZmIC0tZ2l0IGEvZHJpdmVycy92aWRlby9NYWtlZmlsZSBiL2RyaXZlcnMvdmlkZW8vTWFr
ZWZpbGU8YnI+Jmd0OyBpbmRleCA0ODVlOGVkLi5hZDQwOGQyIDEwMDY0NDxicj4mZ3Q7IC0tLSBh
L2RyaXZlcnMvdmlkZW8vTWFrZWZpbGU8YnI+Jmd0OyArKysgYi9kcml2ZXJzL3ZpZGVvL01ha2Vm
aWxlPGJyPiZndDsgQEAgLTE0NSw2ICsxNDUsNyBAQCBvYmotJChDT05GSUdfRkJfQkY1NFhfTFEw
NDMpICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsrPSBiZjU0eC1scTA0M2ZiLm88
YnI+Jmd0OyAmbmJzcDtvYmotJChDT05GSUdfRkJfQkZJTl9MUTAzNVExKSAmbmJzcDsgJm5ic3A7
ICs9IGJmaW4tbHEwMzVxMS1mYi5vPGJyPiZndDsgJm5ic3A7b2JqLSQoQ09ORklHX0ZCX0JGSU5f
VDM1ME1DUUIpICZuYnNwOyArPSBiZmluLXQzNTBtY3FiLWZiLm88YnI+Jmd0OyAmbmJzcDtvYmot
JChDT05GSUdfRkJfTVgzKSAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNw
OyArPSBteDNmYi5vPGJyPiZndDsgK29iai0kKENPTkZJR19GQl9NWDUpICZuYnNwOyAmbmJzcDsg
Jm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICs9IG14NWZiLm88YnI+Jmd0OyAmbmJzcDtvYmot
JChDT05GSUdfRkJfREE4WFgpICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgKz0g
ZGE4eHgtZmIubzxicj4mZ3Q7PGJyPiZndDsgJm5ic3A7IyB0aGUgdGVzdCBmcmFtZWJ1ZmZlciBp
cyBsYXN0PGJyPiZndDsgZGlmZiAtLWdpdCBhL2RyaXZlcnMvdmlkZW8vbXg1ZmIuYyBiL2RyaXZl
cnMvdmlkZW8vbXg1ZmIuYzxicj4mZ3Q7IG5ldyBmaWxlIG1vZGUgMTAwNjQ0PGJyPiZndDsgaW5k
ZXggMDAwMDAwMC4uZmQ5YmFmNDxicj4mZ3Q7IC0tLSAvZGV2L251bGw8YnI+Jmd0OyArKysgYi9k
cml2ZXJzL3ZpZGVvL214NWZiLmM8YnI+Jmd0OyBAQCAtMCwwICsxLDg0NiBAQDxicj4mZ3Q7ICsv
Kjxicj4mZ3Q7ICsgKiBDb3B5cmlnaHQgMjAwNC0yMDA5IEZyZWVzY2FsZSBTZW1pY29uZHVjdG9y
LCBJbmMuIEFsbCBSaWdodHMgUmVzZXJ2ZWQuPGJyPiZndDsgKyAqPGJyPiZndDsgKyAqIFRoZSBj
b2RlIGNvbnRhaW5lZCBoZXJlaW4gaXMgbGljZW5zZWQgdW5kZXIgdGhlIEdOVSBHZW5lcmFsIFB1
YmxpYzxicj4mZ3Q7ICsgKiBMaWNlbnNlLiBZb3UgbWF5IG9idGFpbiBhIGNvcHkgb2YgdGhlIEdO
VSBHZW5lcmFsIFB1YmxpYyBMaWNlbnNlPGJyPiZndDsgKyAqIFZlcnNpb24gMiBvciBsYXRlciBh
dCB0aGUgZm9sbG93aW5nIGxvY2F0aW9uczo8YnI+Jmd0OyArICo8YnI+Jmd0OyArICogPGEgaHJl
Zj0iaHR0cDovL3d3dy5vcGVuc291cmNlLm9yZy9saWNlbnNlcy9ncGwtbGljZW5zZS5odG1sIiB0
YXJnZXQ9Il9ibGFuayI+aHR0cDovL3d3dy5vcGVuc291cmNlLm9yZy9saWNlbnNlcy9ncGwtbGlj
ZW5zZS5odG1sPC9hPjxicj4mZ3Q7ICsgKiA8YSBocmVmPSJodHRwOi8vd3d3LmdudS5vcmcvY29w
eWxlZnQvZ3BsLmh0bWwiIHRhcmdldD0iX2JsYW5rIj5odHRwOi8vd3d3LmdudS5vcmcvY29weWxl
ZnQvZ3BsLmh0bWw8L2E+PGJyPiZndDsgKyAqPGJyPiZndDsgKyAqIEZyYW1lYnVmZmVyIEZyYW1l
YnVmZmVyIERyaXZlciBmb3IgU0RDIGFuZCBBREMuPGJyPiZndDsgKyAqLzxicj4mZ3Q7ICs8YnI+
Jmd0OyArI2luY2x1ZGUgJmx0O2xpbnV4L21vZHVsZS5oJmd0Ozxicj4mZ3Q7ICsjaW5jbHVkZSAm
bHQ7bGludXgva2VybmVsLmgmZ3Q7PGJyPiZndDsgKyNpbmNsdWRlICZsdDtsaW51eC9wbGF0Zm9y
bV9kZXZpY2UuaCZndDs8YnI+Jmd0OyArI2luY2x1ZGUgJmx0O2xpbnV4L2Vycm5vLmgmZ3Q7PGJy
PiZndDsgKyNpbmNsdWRlICZsdDtsaW51eC9zdHJpbmcuaCZndDs8YnI+Jmd0OyArI2luY2x1ZGUg
Jmx0O2xpbnV4L2ludGVycnVwdC5oJmd0Ozxicj4mZ3Q7ICsjaW5jbHVkZSAmbHQ7bGludXgvc2xh
Yi5oJmd0Ozxicj4mZ3Q7ICsjaW5jbHVkZSAmbHQ7bGludXgvZmIuaCZndDs8YnI+Jmd0OyArI2lu
Y2x1ZGUgJmx0O2xpbnV4L2RlbGF5LmgmZ3Q7PGJyPiZndDsgKyNpbmNsdWRlICZsdDtsaW51eC9p
bml0LmgmZ3Q7PGJyPiZndDsgKyNpbmNsdWRlICZsdDtsaW51eC9kbWEtbWFwcGluZy5oJmd0Ozxi
cj4mZ3Q7ICsjaW5jbHVkZSAmbHQ7bGludXgvY29uc29sZS5oJmd0Ozxicj4mZ3Q7ICsjaW5jbHVk
ZSAmbHQ7bGludXgvbWZkL2lteC1pcHUtdjMuaCZndDs8YnI+Jmd0OyArI2luY2x1ZGUgJmx0O2Fz
bS91YWNjZXNzLmgmZ3Q7PGJyPiZndDsgKyNpbmNsdWRlICZsdDttYWNoL2lwdS12My5oJmd0Ozxi
cj4mZ3Q7ICs8YnI+Jmd0OyArI2RlZmluZSBEUklWRVJfTkFNRSAmcXVvdDtpbXgtaXB1djMtZmIm
cXVvdDs8YnI+Jmd0OyArPGJyPiZndDsgK3N0cnVjdCBpbXhfaXB1X2ZiX2luZm8gezxicj4mZ3Q7
ICsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgaW50ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAm
bmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBpcHVfY2hhbm5lbF9udW07
PGJyPiZndDsgKyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBzdHJ1Y3QgaXB1X2NoYW5uZWwgJm5ic3A7
ICZuYnNwOyAmbmJzcDsqaXB1X2NoOzxicj4mZ3Q7ICsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgaW50
ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsg
Jm5ic3A7ICZuYnNwOyBkYzs8YnI+Jmd0OyArICZuYnNwOyAmbmJzcDsgJm5ic3A7IGludCAmbmJz
cDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNw
OyAmbmJzcDsgaXB1X2RpOzxicj4mZ3Q7ICsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgdTMyICZuYnNw
OyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7
ICZuYnNwOyBpcHVfZGlfcGl4X2ZtdDs8YnI+Jmd0OyArICZuYnNwOyAmbmJzcDsgJm5ic3A7IHUz
MiAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7
ICZuYnNwOyAmbmJzcDsgaXB1X2luX3BpeF9mbXQ7PGJyPiZndDsgKzxicj4mZ3Q7ICsgJm5ic3A7
ICZuYnNwOyAmbmJzcDsgdTMyICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5i
c3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBwc2V1ZG9fcGFsZXR0ZVsxNl07PGJyPiZn
dDsgKzxicj4mZ3Q7ICsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgc3RydWN0IGlwdV9kcCAmbmJzcDsg
Jm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICpkcDs8YnI+Jmd0OyArICZuYnNwOyAmbmJzcDsg
Jm5ic3A7IHN0cnVjdCBkbWZjX2NoYW5uZWwgJm5ic3A7ICZuYnNwOyAqZG1mYzs8YnI+Jmd0OyAr
ICZuYnNwOyAmbmJzcDsgJm5ic3A7IHN0cnVjdCBmYl9pbmZvICZuYnNwOyAmbmJzcDsgJm5ic3A7
ICZuYnNwOyAmbmJzcDsqc2xhdmU7PGJyPiZndDsgKyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBzdHJ1
Y3QgZmJfaW5mbyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7Km1hc3Rlcjs8YnI+
Jmd0OyArICZuYnNwOyAmbmJzcDsgJm5ic3A7IGJvb2wgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5i
c3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ZW5hYmxlZDs8YnI+
Jmd0OyArfTs8YnI+Jmd0OyArPGJyPiZndDsgK3N0YXRpYyBpbnQgaW14X2lwdV9mYl9zZXRfZml4
KHN0cnVjdCBmYl9pbmZvICppbmZvKTxicj4mZ3Q7ICt7PGJyPiZndDsgKyAmbmJzcDsgJm5ic3A7
ICZuYnNwOyBzdHJ1Y3QgZmJfZml4X3NjcmVlbmluZm8gKmZpeCA9ICZhbXA7aW5mby0mZ3Q7Zml4
Ozxicj4mZ3Q7ICsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgc3RydWN0IGZiX3Zhcl9zY3JlZW5pbmZv
ICp2YXIgPSAmYW1wO2luZm8tJmd0O3Zhcjs8YnI+Jmd0OyArPGJyPiZndDsgKyAmbmJzcDsgJm5i
c3A7ICZuYnNwOyBmaXgtJmd0O2xpbmVfbGVuZ3RoID0gdmFyLSZndDt4cmVzX3ZpcnR1YWwgKiB2
YXItJmd0O2JpdHNfcGVyX3BpeGVsIC8gODs8YnI+Jmd0OyArPGJyPiZndDsgKyAmbmJzcDsgJm5i
c3A7ICZuYnNwOyBmaXgtJmd0O3R5cGUgPSBGQl9UWVBFX1BBQ0tFRF9QSVhFTFM7PGJyPiZndDsg
KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBmaXgtJmd0O2FjY2VsID0gRkJfQUNDRUxfTk9ORTs8YnI+
Jmd0OyArICZuYnNwOyAmbmJzcDsgJm5ic3A7IGZpeC0mZ3Q7dmlzdWFsID0gRkJfVklTVUFMX1RS
VUVDT0xPUjs8YnI+Jmd0OyArICZuYnNwOyAmbmJzcDsgJm5ic3A7IGZpeC0mZ3Q7eHBhbnN0ZXAg
PSAxOzxicj4mZ3Q7ICsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgZml4LSZndDt5cGFuc3RlcCA9IDE7
PGJyPiZndDsgKzxicj4mZ3Q7ICsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgcmV0dXJuIDA7PGJyPiZn
dDsgK308YnI+Jmd0OyArPGJyPiZndDsgK3N0YXRpYyBpbnQgaW14X2lwdV9mYl9tYXBfdmlkZW9f
bWVtb3J5KHN0cnVjdCBmYl9pbmZvICpmYmkpPGJyPiZndDsgK3s8YnI+Jmd0OyArICZuYnNwOyAm
bmJzcDsgJm5ic3A7IGludCBzaXplOzxicj4mZ3Q7ICs8YnI+Jmd0OyArICZuYnNwOyAmbmJzcDsg
Jm5ic3A7IHNpemUgPSBmYmktJmd0O3Zhci55cmVzX3ZpcnR1YWwgKiBmYmktJmd0O2ZpeC5saW5l
X2xlbmd0aDs8YnI+Jmd0OyArPGJyPiZndDsgKyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBpZiAoZmJp
LSZndDtzY3JlZW5fYmFzZSkgezxicj4mZ3Q7ICsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7
ICZuYnNwOyAmbmJzcDsgJm5ic3A7IGlmIChmYmktJmd0O2ZpeC5zbWVtX2xlbiAmZ3Q7PSBzaXpl
KTxicj4mZ3Q7ICsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5i
c3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyByZXR1cm4gMDs8YnI+Jmd0OyArPGJyPiZn
dDsgKyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgZG1h
X2ZyZWVfd3JpdGVjb21iaW5lKGZiaS0mZ3Q7ZGV2aWNlLCBmYmktJmd0O2ZpeC5zbWVtX2xlbiw8
YnI+Jmd0OyArICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNw
OyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgZmJpLSZn
dDtzY3JlZW5fYmFzZSwgZmJpLSZndDtmaXguc21lbV9zdGFydCk7PGJyPiZndDsgKyAmbmJzcDsg
Jm5ic3A7ICZuYnNwOyB9PGJyPiZndDsgKzxicj4mZ3Q7ICsgJm5ic3A7ICZuYnNwOyAmbmJzcDsg
ZmJpLSZndDtzY3JlZW5fYmFzZSA9IGRtYV9hbGxvY193cml0ZWNvbWJpbmUoZmJpLSZndDtkZXZp
Y2UsPGJyPiZndDsgKyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAm
bmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZu
YnNwOyBzaXplLDxicj4mZ3Q7ICsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAm
bmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZu
YnNwOyAmbmJzcDsgKGRtYV9hZGRyX3QgKikmYW1wO2ZiaS0mZ3Q7Zml4LnNtZW1fc3RhcnQsPGJy
PiZndDsgKyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsg
Jm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBH
RlBfRE1BKTs8YnI+Jmd0OyArICZuYnNwOyAmbmJzcDsgJm5ic3A7IGlmIChmYmktJmd0O3NjcmVl
bl9iYXNlID09IDApIHs8YnI+Jmd0OyArICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJz
cDsgJm5ic3A7ICZuYnNwOyBkZXZfZXJyKGZiaS0mZ3Q7ZGV2aWNlLCAmcXVvdDtVbmFibGUgdG8g
YWxsb2NhdGUgZnJhbWVidWZmZXIgbWVtb3J5ICglZClcbiZxdW90Oyw8YnI+Jmd0OyArICZuYnNw
OyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7
ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7IGZiaS0mZ3Q7Zml4LnNt
ZW1fbGVuKTs8YnI+Jmd0OyArICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5i
c3A7ICZuYnNwOyBmYmktJmd0O2ZpeC5zbWVtX2xlbiA9IDA7PGJyPiZndDsgKyAmbmJzcDsgJm5i
c3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgZmJpLSZndDtmaXguc21lbV9z
dGFydCA9IDA7PGJyPiZndDsgKyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZu
YnNwOyAmbmJzcDsgcmV0dXJuIC1FTk9NRU07PGJyPiZndDsgKyAmbmJzcDsgJm5ic3A7ICZuYnNw
OyB9PGJyPiZndDsgKzxicj4mZ3Q7ICsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgZmJpLSZndDtmaXgu
c21lbV9sZW4gPSBzaXplOzxicj4mZ3Q7ICsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgZmJpLSZndDtz
Y3JlZW5fc2l6ZSA9IGZiaS0mZ3Q7Zml4LnNtZW1fbGVuOzxicj4mZ3Q7ICs8YnI+Jmd0OyArICZu
YnNwOyAmbmJzcDsgJm5ic3A7IGRldl9kYmcoZmJpLSZndDtkZXZpY2UsICZxdW90O2FsbG9jYXRl
ZCBmYiBAIHBhZGRyPTB4JTA4bHgsIHNpemU9JWRcbiZxdW90Oyw8YnI+Jmd0OyArICZuYnNwOyAm
bmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBmYmktJmd0O2ZpeC5zbWVt
X3N0YXJ0LCBmYmktJmd0O2ZpeC5zbWVtX2xlbik7PGJyPiZndDsgKzxicj4mZ3Q7ICsgJm5ic3A7
ICZuYnNwOyAmbmJzcDsgLyogQ2xlYXIgdGhlIHNjcmVlbiAqLzxicj4mZ3Q7ICsgJm5ic3A7ICZu
YnNwOyAmbmJzcDsgbWVtc2V0KChjaGFyICopZmJpLSZndDtzY3JlZW5fYmFzZSwgMCwgZmJpLSZn
dDtmaXguc21lbV9sZW4pOzxicj4mZ3Q7ICs8YnI+Jmd0OyArICZuYnNwOyAmbmJzcDsgJm5ic3A7
IHJldHVybiAwOzxicj4mZ3Q7ICt9PGJyPiZndDsgKzxicj4mZ3Q7ICtzdGF0aWMgdm9pZCBpbXhf
aXB1X2ZiX2VuYWJsZShzdHJ1Y3QgZmJfaW5mbyAqZmJpKTxicj4mZ3Q7ICt7PGJyPiZndDsgKyAm
bmJzcDsgJm5ic3A7ICZuYnNwOyBzdHJ1Y3QgaW14X2lwdV9mYl9pbmZvICpteGNfZmJpID0gZmJp
LSZndDtwYXI7PGJyPiZndDsgKzxicj4mZ3Q7ICsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgaWYgKG14
Y19mYmktJmd0O2VuYWJsZWQpPGJyPiZndDsgKyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsg
Jm5ic3A7ICZuYnNwOyAmbmJzcDsgcmV0dXJuOzxicj4mZ3Q7ICs8YnI+Jmd0OyArICZuYnNwOyAm
bmJzcDsgJm5ic3A7IGlwdV9kaV9lbmFibGUobXhjX2ZiaS0mZ3Q7aXB1X2RpKTs8YnI+Jmd0OyAr
ICZuYnNwOyAmbmJzcDsgJm5ic3A7IGlwdV9kbWZjX2VuYWJsZV9jaGFubmVsKG14Y19mYmktJmd0
O2RtZmMpOzxicj4mZ3Q7ICsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgaXB1X2lkbWFjX2VuYWJsZV9j
aGFubmVsKG14Y19mYmktJmd0O2lwdV9jaCk7PGJyPiZndDsgKyAmbmJzcDsgJm5ic3A7ICZuYnNw
OyBpcHVfZGNfZW5hYmxlX2NoYW5uZWwobXhjX2ZiaS0mZ3Q7ZGMpOzxicj4mZ3Q7ICsgJm5ic3A7
ICZuYnNwOyAmbmJzcDsgaXB1X2RwX2VuYWJsZV9jaGFubmVsKG14Y19mYmktJmd0O2RwKTs8YnI+
Jmd0OyArICZuYnNwOyAmbmJzcDsgJm5ic3A7IG14Y19mYmktJmd0O2VuYWJsZWQgPSAxOzxicj4m
Z3Q7ICt9PGJyPiZndDsgKzxicj4mZ3Q7ICtzdGF0aWMgdm9pZCBpbXhfaXB1X2ZiX2Rpc2FibGUo
c3RydWN0IGZiX2luZm8gKmZiaSk8YnI+Jmd0OyArezxicj4mZ3Q7ICsgJm5ic3A7ICZuYnNwOyAm
bmJzcDsgc3RydWN0IGlteF9pcHVfZmJfaW5mbyAqbXhjX2ZiaSA9IGZiaS0mZ3Q7cGFyOzxicj4m
Z3Q7ICs8YnI+Jmd0OyArICZuYnNwOyAmbmJzcDsgJm5ic3A7IGlmICghbXhjX2ZiaS0mZ3Q7ZW5h
YmxlZCk8YnI+Jmd0OyArICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7
ICZuYnNwOyByZXR1cm47PGJyPiZndDsgKzxicj4mZ3Q7ICsgJm5ic3A7ICZuYnNwOyAmbmJzcDsg
aXB1X2RwX2Rpc2FibGVfY2hhbm5lbChteGNfZmJpLSZndDtkcCk7PGJyPiZndDsgKyAmbmJzcDsg
Jm5ic3A7ICZuYnNwOyBpcHVfZGNfZGlzYWJsZV9jaGFubmVsKG14Y19mYmktJmd0O2RjKTs8YnI+
Jmd0OyArICZuYnNwOyAmbmJzcDsgJm5ic3A7IGlwdV9pZG1hY19kaXNhYmxlX2NoYW5uZWwobXhj
X2ZiaS0mZ3Q7aXB1X2NoKTs8YnI+Jmd0OyArICZuYnNwOyAmbmJzcDsgJm5ic3A7IGlwdV9kbWZj
X2Rpc2FibGVfY2hhbm5lbChteGNfZmJpLSZndDtkbWZjKTs8YnI+Jmd0OyArICZuYnNwOyAmbmJz
cDsgJm5ic3A7IGlwdV9kaV9kaXNhYmxlKG14Y19mYmktJmd0O2lwdV9kaSk7PGJyPiZndDsgKzxi
cj4mZ3Q7ICsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgbXhjX2ZiaS0mZ3Q7ZW5hYmxlZCA9IDA7PGJy
PiZndDsgK308YnI+Jmd0OyArPGJyPiZndDsgK3N0YXRpYyBpbnQgY2FsY192cmVmKHN0cnVjdCBm
Yl92YXJfc2NyZWVuaW5mbyAqdmFyKTxicj4mZ3Q7ICt7PGJyPiZndDsgKyAmbmJzcDsgJm5ic3A7
ICZuYnNwOyB1bnNpZ25lZCBsb25nIGh0b3RhbCwgdnRvdGFsOzxicj4mZ3Q7ICs8YnI+Jmd0OyAr
ICZuYnNwOyAmbmJzcDsgJm5ic3A7IGh0b3RhbCA9IHZhci0mZ3Q7eHJlcyArIHZhci0mZ3Q7cmln
aHRfbWFyZ2luICsgdmFyLSZndDtoc3luY19sZW4gKyB2YXItJmd0O2xlZnRfbWFyZ2luOzxicj4m
Z3Q7ICsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgdnRvdGFsID0gdmFyLSZndDt5cmVzICsgdmFyLSZn
dDtsb3dlcl9tYXJnaW4gKyB2YXItJmd0O3ZzeW5jX2xlbiArIHZhci0mZ3Q7dXBwZXJfbWFyZ2lu
Ozxicj4mZ3Q7ICs8YnI+Jmd0OyArICZuYnNwOyAmbmJzcDsgJm5ic3A7IGlmICghaHRvdGFsIHx8
ICF2dG90YWwpPGJyPiZndDsgKyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZu
YnNwOyAmbmJzcDsgcmV0dXJuIDYwOzxicj4mZ3Q7ICs8YnI+Jmd0OyArICZuYnNwOyAmbmJzcDsg
Jm5ic3A7IHJldHVybiBQSUNPUzJLSFoodmFyLSZndDtwaXhjbG9jaykgKiAxMDAwIC8gdnRvdGFs
IC8gaHRvdGFsOzxicj4mZ3Q7ICt9PGJyPiZndDsgKzxicj4mZ3Q7ICtzdGF0aWMgaW50IGNhbGNf
YmFuZHdpZHRoKHN0cnVjdCBmYl92YXJfc2NyZWVuaW5mbyAqdmFyLCB1bnNpZ25lZCBpbnQgdnJl
Zik8YnI+Jmd0OyArezxicj4mZ3Q7ICsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgcmV0dXJuIHZhci0m
Z3Q7eHJlcyAqIHZhci0mZ3Q7eXJlcyAqIHZyZWY7PGJyPiZndDsgK308YnI+Jmd0OyArPGJyPiZn
dDsgK3N0YXRpYyBpbnQgaW14X2lwdV9mYl9zZXRfcGFyKHN0cnVjdCBmYl9pbmZvICpmYmkpPGJy
PiZndDsgK3s8YnI+Jmd0OyArICZuYnNwOyAmbmJzcDsgJm5ic3A7IGludCByZXQ7PGJyPiZndDsg
KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBzdHJ1Y3QgaXB1X2RpX3NpZ25hbF9jZmcgc2lnX2NmZzs8
YnI+Jmd0OyArICZuYnNwOyAmbmJzcDsgJm5ic3A7IHN0cnVjdCBpbXhfaXB1X2ZiX2luZm8gKm14
Y19mYmkgPSBmYmktJmd0O3Bhcjs8YnI+Jmd0OyArICZuYnNwOyAmbmJzcDsgJm5ic3A7IHUzMiBv
dXRfcGl4ZWxfZm10Ozxicj4mZ3Q7ICsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgaW50IGludGVybGFj
ZWQgPSAwOzxicj4mZ3Q7ICsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgc3RydWN0IGZiX3Zhcl9zY3Jl
ZW5pbmZvICp2YXIgPSAmYW1wO2ZiaS0mZ3Q7dmFyOzxicj4mZ3Q7ICsgJm5ic3A7ICZuYnNwOyAm
bmJzcDsgaW50IGVuYWJsZWQgPSBteGNfZmJpLSZndDtlbmFibGVkOzxicj4mZ3Q7ICs8YnI+Jmd0
OyArICZuYnNwOyAmbmJzcDsgJm5ic3A7IGRldl9kYmcoZmJpLSZndDtkZXZpY2UsICZxdW90O1Jl
Y29uZmlndXJpbmcgZnJhbWVidWZmZXIgJWR4JWQtJWRcbiZxdW90Oyw8YnI+Jmd0OyArICZuYnNw
OyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBmYmktJmd0O3Zhci54
cmVzLCBmYmktJmd0O3Zhci55cmVzLCBmYmktJmd0O3Zhci5iaXRzX3Blcl9waXhlbCk7PGJyPiZn
dDsgKzxicj4mZ3Q7ICsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgaWYgKGVuYWJsZWQpPGJyPiZndDsg
KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgaW14X2lw
dV9mYl9kaXNhYmxlKGZiaSk7PGJyPiZndDsgKzxicj4mZ3Q7ICsgJm5ic3A7ICZuYnNwOyAmbmJz
cDsgZmJpLSZndDtmaXgubGluZV9sZW5ndGggPSB2YXItJmd0O3hyZXNfdmlydHVhbCAqIHZhci0m
Z3Q7Yml0c19wZXJfcGl4ZWwgLyA4Ozxicj4mZ3Q7ICs8YnI+Jmd0OyArICZuYnNwOyAmbmJzcDsg
Jm5ic3A7IHZhci0mZ3Q7eXJlc192aXJ0dWFsID0gdmFyLSZndDt5cmVzOzxicj4mZ3Q7ICs8YnI+
Jmd0OyArICZuYnNwOyAmbmJzcDsgJm5ic3A7IHJldCA9IGlteF9pcHVfZmJfbWFwX3ZpZGVvX21l
bW9yeShmYmkpOzxicj4mZ3Q7ICsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgaWYgKHJldCk8YnI+Jmd0
OyArICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyByZXR1
cm4gcmV0Ozxicj4mZ3Q7ICs8YnI+Jmd0OyArICZuYnNwOyAmbmJzcDsgJm5ic3A7IGlmICh2YXIt
Jmd0O3Ztb2RlICZhbXA7IEZCX1ZNT0RFX0lOVEVSTEFDRUQpPGJyPiZndDsgKyAmbmJzcDsgJm5i
c3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgaW50ZXJsYWNlZCA9IDE7PGJy
PiZndDsgKzxicj4mZ3Q7ICsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgbWVtc2V0KCZhbXA7c2lnX2Nm
ZywgMCwgc2l6ZW9mKHNpZ19jZmcpKTs8YnI+Jmd0OyArICZuYnNwOyAmbmJzcDsgJm5ic3A7IG91
dF9waXhlbF9mbXQgPSBteGNfZmJpLSZndDtpcHVfZGlfcGl4X2ZtdDs8YnI+Jmd0OyArPGJyPiZn
dDsgKyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBpZiAodmFyLSZndDt2bW9kZSAmYW1wOyBGQl9WTU9E
RV9JTlRFUkxBQ0VEKTxicj4mZ3Q7ICsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNw
OyAmbmJzcDsgJm5ic3A7IHNpZ19jZmcuaW50ZXJsYWNlZCA9IDE7PGJyPiZndDsgKyAmbmJzcDsg
Jm5ic3A7ICZuYnNwOyBpZiAodmFyLSZndDt2bW9kZSAmYW1wOyBGQl9WTU9ERV9PRERfRkxEX0ZJ
UlNUKSAvKiBQQUwgKi88YnI+Jmd0OyArICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJz
cDsgJm5ic3A7ICZuYnNwOyBzaWdfY2ZnLm9kZF9maWVsZF9maXJzdCA9IDE7PGJyPiZndDsgKyAm
bmJzcDsgJm5ic3A7ICZuYnNwOyBpZiAodmFyLSZndDtzeW5jICZhbXA7IEZCX1NZTkNfRVhUKTxi
cj4mZ3Q7ICsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7
IHNpZ19jZmcuZXh0X2NsayA9IDE7PHNwYW4gc3R5bGU9J2NvbG9yOiMxRjQ5N0QnPjxvOnA+PC9v
OnA+PC9zcGFuPjwvcD48cCBjbGFzcz1Nc29Ob3JtYWw+PGI+PGk+PHNwYW4gc3R5bGU9J2ZvbnQt
c2l6ZToxMS4wcHQ7Zm9udC1mYW1pbHk6IkNhbGlicmkiLCJzYW5zLXNlcmlmIjtjb2xvcjojMUY0
OTdEJz5bSmFzb25dIEZCX1NZTkNfRVhUIGhhcyBub3QgYmUgdXNlZCBpbiBGU0wga2VybmVsIG1h
aW5saW5lLCBpdCByZXByZXNlbnQgU1lOQyBleHQsIHNob3VsZCBub3QgYmUgZmxhZyBvZiBleHQg
Y2xrLiBTb21lIGFwcGxpY2F0aW9uIGZvciBleGFtcGxlIFgtc2VydmVyIGNvdWxkIG5vdCByZWNv
Z25pemUgaXQuPG86cD48L286cD48L3NwYW4+PC9pPjwvYj48L3A+PHAgY2xhc3M9TXNvTm9ybWFs
Pjxicj4mZ3Q7ICsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgaWYgKHZhci0mZ3Q7c3luYyAmYW1wOyBG
Ql9TWU5DX0hPUl9ISUdIX0FDVCk8YnI+Jmd0OyArICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNw
OyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBzaWdfY2ZnLkhzeW5jX3BvbCA9IDE7PGJyPiZndDsgKyAm
bmJzcDsgJm5ic3A7ICZuYnNwOyBpZiAodmFyLSZndDtzeW5jICZhbXA7IEZCX1NZTkNfVkVSVF9I
SUdIX0FDVCk8YnI+Jmd0OyArICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5i
c3A7ICZuYnNwOyBzaWdfY2ZnLlZzeW5jX3BvbCA9IDE7PGJyPiZndDsgKyAmbmJzcDsgJm5ic3A7
ICZuYnNwOyBpZiAoISh2YXItJmd0O3N5bmMgJmFtcDsgRkJfU1lOQ19DTEtfTEFUX0ZBTEwpKTxi
cj4mZ3Q7ICsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7
IHNpZ19jZmcuY2xrX3BvbCA9IDE7PGJyPiZndDsgKyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBpZiAo
dmFyLSZndDtzeW5jICZhbXA7IEZCX1NZTkNfREFUQV9JTlZFUlQpPGJyPiZndDsgKyAmbmJzcDsg
Jm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgc2lnX2NmZy5kYXRhX3Bv
bCA9IDE7PGJyPiZndDsgKyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBpZiAoISh2YXItJmd0O3N5bmMg
JmFtcDsgRkJfU1lOQ19PRV9MT1dfQUNUKSk8YnI+Jmd0OyArICZuYnNwOyAmbmJzcDsgJm5ic3A7
ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBzaWdfY2ZnLmVuYWJsZV9wb2wgPSAxOzxicj4m
Z3Q7ICsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgaWYgKHZhci0mZ3Q7c3luYyAmYW1wOyBGQl9TWU5D
X0NMS19JRExFX0VOKTxicj4mZ3Q7ICsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNw
OyAmbmJzcDsgJm5ic3A7IHNpZ19jZmcuY2xraWRsZV9lbiA9IDE7PGJyPiZndDsgKzxicj4mZ3Q7
ICsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgZGV2X2RiZyhmYmktJmd0O2RldmljZSwgJnF1b3Q7cGl4
Y2xvY2sgPSAlbHUuJTAzbHUgTUh6XG4mcXVvdDssPGJyPiZndDsgKyAmbmJzcDsgJm5ic3A7ICZu
YnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgUElDT1MyS0haKHZhci0mZ3Q7cGl4Y2xv
Y2spIC8gMTAwMCw8YnI+Jmd0OyArICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsg
Jm5ic3A7ICZuYnNwOyBQSUNPUzJLSFoodmFyLSZndDtwaXhjbG9jaykgJSAxMDAwKTs8YnI+Jmd0
OyArPGJyPiZndDsgKyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBzaWdfY2ZnLndpZHRoID0gdmFyLSZn
dDt4cmVzOzxicj4mZ3Q7ICsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgc2lnX2NmZy5oZWlnaHQgPSB2
YXItJmd0O3lyZXM7PGJyPiZndDsgKyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBzaWdfY2ZnLnBpeGVs
X2ZtdCA9IG91dF9waXhlbF9mbXQ7PGJyPiZndDsgKyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBzaWdf
Y2ZnLmhfc3RhcnRfd2lkdGggPSB2YXItJmd0O2xlZnRfbWFyZ2luOzxicj4mZ3Q7ICsgJm5ic3A7
ICZuYnNwOyAmbmJzcDsgc2lnX2NmZy5oX3N5bmNfd2lkdGggPSB2YXItJmd0O2hzeW5jX2xlbjs8
YnI+Jmd0OyArICZuYnNwOyAmbmJzcDsgJm5ic3A7IHNpZ19jZmcuaF9lbmRfd2lkdGggPSB2YXIt
Jmd0O3JpZ2h0X21hcmdpbjs8YnI+Jmd0OyArICZuYnNwOyAmbmJzcDsgJm5ic3A7IHNpZ19jZmcu
dl9zdGFydF93aWR0aCA9IHZhci0mZ3Q7dXBwZXJfbWFyZ2luOzxicj4mZ3Q7ICsgJm5ic3A7ICZu
YnNwOyAmbmJzcDsgc2lnX2NmZy52X3N5bmNfd2lkdGggPSB2YXItJmd0O3ZzeW5jX2xlbjs8YnI+
Jmd0OyArICZuYnNwOyAmbmJzcDsgJm5ic3A7IHNpZ19jZmcudl9lbmRfd2lkdGggPSB2YXItJmd0
O2xvd2VyX21hcmdpbjs8YnI+Jmd0OyArICZuYnNwOyAmbmJzcDsgJm5ic3A7IHNpZ19jZmcudl90
b19oX3N5bmMgPSAwOzxicj4mZ3Q7ICs8YnI+Jmd0OyArICZuYnNwOyAmbmJzcDsgJm5ic3A7IGlm
IChteGNfZmJpLSZndDtkcCkgezxicj4mZ3Q7ICsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7
ICZuYnNwOyAmbmJzcDsgJm5ic3A7IHJldCA9IGlwdV9kcF9zZXR1cF9jaGFubmVsKG14Y19mYmkt
Jmd0O2RwLCBteGNfZmJpLSZndDtpcHVfaW5fcGl4X2ZtdCw8YnI+Jmd0OyArICZuYnNwOyAmbmJz
cDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNw
OyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7IG91dF9waXhlbF9mbXQsIDEpOzxi
cj4mZ3Q7ICsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7
IGlmIChyZXQpIHs8YnI+Jmd0OyArICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsg
Jm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgZGV2X2RiZyhmYmktJmd0
O2RldmljZSwgJnF1b3Q7aW5pdGlhbGl6aW5nIGRpc3BsYXkgcHJvY2Vzc29yIGZhaWxlZCB3aXRo
ICVkXG4mcXVvdDssPGJyPiZndDsgKyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7
ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsg
Jm5ic3A7ICZuYnNwOyByZXQpOzxicj4mZ3Q7ICsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7
ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyByZXR1cm4g
cmV0Ozxicj4mZ3Q7ICsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsg
Jm5ic3A7IH08YnI+Jmd0OyArICZuYnNwOyAmbmJzcDsgJm5ic3A7IH08YnI+Jmd0OyArPGJyPiZn
dDsgKyAmbmJzcDsgJm5ic3A7ICZuYnNwOyByZXQgPSBpcHVfZGNfaW5pdF9zeW5jKG14Y19mYmkt
Jmd0O2RjLCBteGNfZmJpLSZndDtpcHVfZGksIGludGVybGFjZWQsPGJyPiZndDsgKyAmbmJzcDsg
Jm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAm
bmJzcDsgJm5ic3A7IG91dF9waXhlbF9mbXQsIGZiaS0mZ3Q7dmFyLnhyZXMpOzxicj4mZ3Q7ICsg
Jm5ic3A7ICZuYnNwOyAmbmJzcDsgaWYgKHJldCkgezxicj4mZ3Q7ICsgJm5ic3A7ICZuYnNwOyAm
bmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7IGRldl9kYmcoZmJpLSZndDtkZXZpY2Us
ICZxdW90O2luaXRpYWxpemluZyBkaXNwbGF5IGNvbnRyb2xsZXIgZmFpbGVkIHdpdGggJWRcbiZx
dW90Oyw8YnI+Jmd0OyArICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7
ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsg
Jm5ic3A7IHJldCk7PGJyPiZndDsgKyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7
ICZuYnNwOyAmbmJzcDsgcmV0dXJuIHJldDs8YnI+Jmd0OyArICZuYnNwOyAmbmJzcDsgJm5ic3A7
IH08YnI+Jmd0OyArPGJyPiZndDsgKyAmbmJzcDsgJm5ic3A7ICZuYnNwOyByZXQgPSBpcHVfZGlf
aW5pdF9zeW5jX3BhbmVsKG14Y19mYmktJmd0O2lwdV9kaSw8YnI+Jmd0OyArICZuYnNwOyAmbmJz
cDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNw
OyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7IFBJQ09TMktIWih2YXItJmd0O3Bp
eGNsb2NrKSAqIDEwMDBVTCw8YnI+Jmd0OyArICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAm
bmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZu
YnNwOyAmbmJzcDsgJm5ic3A7ICZhbXA7c2lnX2NmZyk7PGJyPiZndDsgKyAmbmJzcDsgJm5ic3A7
ICZuYnNwOyBpZiAocmV0KSB7PGJyPiZndDsgKyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsg
Jm5ic3A7ICZuYnNwOyAmbmJzcDsgZGV2X2RiZyhmYmktJmd0O2RldmljZSwgJnF1b3Q7aW5pdGlh
bGl6aW5nIHBhbmVsIGZhaWxlZCB3aXRoICVkXG4mcXVvdDssPGJyPiZndDsgKyAmbmJzcDsgJm5i
c3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJz
cDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyByZXQpOzxicj4mZ3Q7ICsgJm5i
c3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7IHJldHVybiByZXQ7
PGJyPiZndDsgKyAmbmJzcDsgJm5ic3A7ICZuYnNwOyB9PGJyPiZndDsgKzxicj4mZ3Q7ICsgJm5i
c3A7ICZuYnNwOyAmbmJzcDsgZmJpLSZndDttb2RlID0gKHN0cnVjdCBmYl92aWRlb21vZGUgKilm
Yl9tYXRjaF9tb2RlKHZhciwgJmFtcDtmYmktJmd0O21vZGVsaXN0KTs8YnI+Jmd0OyArICZuYnNw
OyAmbmJzcDsgJm5ic3A7IHZhci0mZ3Q7eG9mZnNldCA9IHZhci0mZ3Q7eW9mZnNldCA9IDA7PGJy
PiZndDsgKzxicj4mZ3Q7ICsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgaWYgKGZiaS0mZ3Q7dmFyLnZt
b2RlICZhbXA7IEZCX1ZNT0RFX0lOVEVSTEFDRUQpPGJyPiZndDsgKyAmbmJzcDsgJm5ic3A7ICZu
YnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgaW50ZXJsYWNlZCA9IDE7PGJyPiZndDsg
Kzxicj4mZ3Q7ICsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgcmV0ID0gaXB1X2lkbWFjX2luaXRfY2hh
bm5lbF9idWZmZXIobXhjX2ZiaS0mZ3Q7aXB1X2NoLDxicj4mZ3Q7ICsgJm5ic3A7ICZuYnNwOyAm
bmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZu
YnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5i
c3A7IG14Y19mYmktJmd0O2lwdV9pbl9waXhfZm10LDxicj4mZ3Q7ICsgJm5ic3A7ICZuYnNwOyAm
bmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZu
YnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5i
c3A7IHZhci0mZ3Q7eHJlcywgdmFyLSZndDt5cmVzLDxicj4mZ3Q7ICsgJm5ic3A7ICZuYnNwOyAm
bmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZu
YnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5i
c3A7IGZiaS0mZ3Q7Zml4LmxpbmVfbGVuZ3RoLDxicj4mZ3Q7ICsgJm5ic3A7ICZuYnNwOyAmbmJz
cDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNw
OyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7
IElQVV9ST1RBVEVfTk9ORSw8YnI+Jmd0OyArICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAm
bmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZu
YnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBmYmktJmd0O2Zp
eC5zbWVtX3N0YXJ0LDxicj4mZ3Q7ICsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNw
OyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7
ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7IDAsPGJyPiZndDsgKyAm
bmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZu
YnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5i
c3A7ICZuYnNwOyAmbmJzcDsgMCwgMCwgaW50ZXJsYWNlZCk7PGJyPiZndDsgKyAmbmJzcDsgJm5i
c3A7ICZuYnNwOyBpZiAocmV0KSB7PGJyPiZndDsgKyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJz
cDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgZGV2X2RiZyhmYmktJmd0O2RldmljZSwgJnF1b3Q7aW5p
dCBjaGFubmVsIGJ1ZmZlciBmYWlsZWQgd2l0aCAlZFxuJnF1b3Q7LDxicj4mZ3Q7ICsgJm5ic3A7
ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsg
Jm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgcmV0KTs8YnI+Jmd0OyAr
ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyByZXR1cm4g
cmV0Ozxicj4mZ3Q7ICsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgfTxicj4mZ3Q7ICs8YnI+Jmd0OyAr
ICZuYnNwOyAmbmJzcDsgJm5ic3A7IHJldCA9IGlwdV9kbWZjX2luaXRfY2hhbm5lbChteGNfZmJp
LSZndDtkbWZjLCB2YXItJmd0O3hyZXMpOzxicj4mZ3Q7ICsgJm5ic3A7ICZuYnNwOyAmbmJzcDsg
aWYgKHJldCkgezxicj4mZ3Q7ICsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAm
bmJzcDsgJm5ic3A7IGRldl9kYmcoZmJpLSZndDtkZXZpY2UsICZxdW90O2luaXRpYWxpemluZyBk
bWZjIGNoYW5uZWwgZmFpbGVkIHdpdGggJWRcbiZxdW90Oyw8YnI+Jmd0OyArICZuYnNwOyAmbmJz
cDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNw
OyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7IHJldCk7PGJyPiZndDsgKyAmbmJz
cDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgcmV0dXJuIHJldDs8
YnI+Jmd0OyArICZuYnNwOyAmbmJzcDsgJm5ic3A7IH08YnI+Jmd0OyArPGJyPiZndDsgKyAmbmJz
cDsgJm5ic3A7ICZuYnNwOyByZXQgPSBpcHVfZG1mY19hbGxvY19iYW5kd2lkdGgobXhjX2ZiaS0m
Z3Q7ZG1mYywgY2FsY19iYW5kd2lkdGgodmFyLCBjYWxjX3ZyZWYodmFyKSkpOzxicj4mZ3Q7ICsg
Jm5ic3A7ICZuYnNwOyAmbmJzcDsgaWYgKHJldCkgezxicj4mZ3Q7ICsgJm5ic3A7ICZuYnNwOyAm
bmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7IGRldl9kYmcoZmJpLSZndDtkZXZpY2Us
ICZxdW90O2FsbG9jYXRpbmcgZG1mYyBiYW5kd2lkdGggZmFpbGVkIHdpdGggJWRcbiZxdW90Oyw8
YnI+Jmd0OyArICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNw
OyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7
IHJldCk7PGJyPiZndDsgKyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNw
OyAmbmJzcDsgcmV0dXJuIHJldDs8YnI+Jmd0OyArICZuYnNwOyAmbmJzcDsgJm5ic3A7IH08YnI+
Jmd0OyArPGJyPiZndDsgKyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBpZiAoZW5hYmxlZCk8YnI+Jmd0
OyArICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBpbXhf
aXB1X2ZiX2VuYWJsZShmYmkpOzxicj4mZ3Q7ICs8YnI+Jmd0OyArICZuYnNwOyAmbmJzcDsgJm5i
c3A7IHJldHVybiByZXQ7PGJyPiZndDsgK308YnI+Jmd0OyArPGJyPiZndDsgKy8qPGJyPiZndDsg
KyAqIFRoZXNlIGFyZSB0aGUgYml0ZmllbGRzIGZvciBlYWNoPGJyPiZndDsgKyAqIGRpc3BsYXkg
ZGVwdGggdGhhdCB3ZSBzdXBwb3J0Ljxicj4mZ3Q7ICsgKi88YnI+Jmd0OyArc3RydWN0IGlteGZi
X3JnYiB7PGJyPiZndDsgKyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBzdHJ1Y3QgZmJfYml0ZmllbGQg
Jm5ic3A7ICZuYnNwOyAmbmJzcDtyZWQ7PGJyPiZndDsgKyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBz
dHJ1Y3QgZmJfYml0ZmllbGQgJm5ic3A7ICZuYnNwOyAmbmJzcDtncmVlbjs8YnI+Jmd0OyArICZu
YnNwOyAmbmJzcDsgJm5ic3A7IHN0cnVjdCBmYl9iaXRmaWVsZCAmbmJzcDsgJm5ic3A7ICZuYnNw
O2JsdWU7PGJyPiZndDsgKyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBzdHJ1Y3QgZmJfYml0ZmllbGQg
Jm5ic3A7ICZuYnNwOyAmbmJzcDt0cmFuc3A7PGJyPiZndDsgK307PGJyPiZndDsgKzxicj4mZ3Q7
ICtzdGF0aWMgc3RydWN0IGlteGZiX3JnYiBkZWZfcmdiXzggPSB7PGJyPiZndDsgKyAmbmJzcDsg
Jm5ic3A7ICZuYnNwOyAucmVkICZuYnNwOyAmbmJzcDs9IHsgLm9mZnNldCA9ICZuYnNwOzUsIC5s
ZW5ndGggPSAzLCB9LDxicj4mZ3Q7ICsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgLmdyZWVuICZuYnNw
Oz0geyAub2Zmc2V0ID0gJm5ic3A7MiwgLmxlbmd0aCA9IDMsIH0sPGJyPiZndDsgKyAmbmJzcDsg
Jm5ic3A7ICZuYnNwOyAuYmx1ZSAmbmJzcDsgPSB7IC5vZmZzZXQgPSAmbmJzcDswLCAubGVuZ3Ro
ID0gMiwgfSw8YnI+Jmd0OyArICZuYnNwOyAmbmJzcDsgJm5ic3A7IC50cmFuc3AgPSB7IC5vZmZz
ZXQgPSAmbmJzcDswLCAubGVuZ3RoID0gMCwgfSw8YnI+Jmd0OyArfTs8YnI+Jmd0OyArPGJyPiZn
dDsgK3N0YXRpYyBzdHJ1Y3QgaW14ZmJfcmdiIGRlZl9yZ2JfMTYgPSB7PGJyPiZndDsgKyAmbmJz
cDsgJm5ic3A7ICZuYnNwOyAucmVkICZuYnNwOyAmbmJzcDs9IHsgLm9mZnNldCA9IDExLCAubGVu
Z3RoID0gNSwgfSw8YnI+Jmd0OyArICZuYnNwOyAmbmJzcDsgJm5ic3A7IC5ncmVlbiAmbmJzcDs9
IHsgLm9mZnNldCA9ICZuYnNwOzUsIC5sZW5ndGggPSA2LCB9LDxicj4mZ3Q7ICsgJm5ic3A7ICZu
YnNwOyAmbmJzcDsgLmJsdWUgJm5ic3A7ID0geyAub2Zmc2V0ID0gJm5ic3A7MCwgLmxlbmd0aCA9
IDUsIH0sPGJyPiZndDsgKyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAudHJhbnNwID0geyAub2Zmc2V0
ID0gJm5ic3A7MCwgLmxlbmd0aCA9IDAsIH0sPGJyPiZndDsgK307PGJyPiZndDsgKzxicj4mZ3Q7
ICtzdGF0aWMgc3RydWN0IGlteGZiX3JnYiBkZWZfcmdiXzI0ID0gezxicj4mZ3Q7ICsgJm5ic3A7
ICZuYnNwOyAmbmJzcDsgLnJlZCAmbmJzcDsgJm5ic3A7PSB7IC5vZmZzZXQgPSAxNiwgLmxlbmd0
aCA9IDgsIH0sPGJyPiZndDsgKyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAuZ3JlZW4gJm5ic3A7PSB7
IC5vZmZzZXQgPSAmbmJzcDs4LCAubGVuZ3RoID0gOCwgfSw8YnI+Jmd0OyArICZuYnNwOyAmbmJz
cDsgJm5ic3A7IC5ibHVlICZuYnNwOyA9IHsgLm9mZnNldCA9ICZuYnNwOzAsIC5sZW5ndGggPSA4
LCB9LDxicj4mZ3Q7ICsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgLnRyYW5zcCA9IHsgLm9mZnNldCA9
ICZuYnNwOzAsIC5sZW5ndGggPSAwLCB9LDxicj4mZ3Q7ICt9Ozxicj4mZ3Q7ICs8YnI+Jmd0OyAr
c3RhdGljIHN0cnVjdCBpbXhmYl9yZ2IgZGVmX3JnYl8zMiA9IHs8YnI+Jmd0OyArICZuYnNwOyAm
bmJzcDsgJm5ic3A7IC5yZWQgJm5ic3A7ICZuYnNwOz0geyAub2Zmc2V0ID0gMTYsIC5sZW5ndGgg
PSA4LCB9LDxicj4mZ3Q7ICsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgLmdyZWVuICZuYnNwOz0geyAu
b2Zmc2V0ID0gJm5ic3A7OCwgLmxlbmd0aCA9IDgsIH0sPGJyPiZndDsgKyAmbmJzcDsgJm5ic3A7
ICZuYnNwOyAuYmx1ZSAmbmJzcDsgPSB7IC5vZmZzZXQgPSAmbmJzcDswLCAubGVuZ3RoID0gOCwg
fSw8YnI+Jmd0OyArICZuYnNwOyAmbmJzcDsgJm5ic3A7IC50cmFuc3AgPSB7IC5vZmZzZXQgPSAy
NCwgLmxlbmd0aCA9IDgsIH0sPGJyPiZndDsgK307PGJyPiZndDsgKzxicj4mZ3Q7ICsvKjxicj4m
Z3Q7ICsgKiBDaGVjayBmcmFtZWJ1ZmZlciB2YXJpYWJsZSBwYXJhbWV0ZXJzIGFuZCBhZGp1c3Qg
dG8gdmFsaWQgdmFsdWVzLjxicj4mZ3Q7ICsgKjxicj4mZ3Q7ICsgKiBAcGFyYW0gJm5ic3A7ICZu
YnNwOyAmbmJzcDsgdmFyICZuYnNwOyAmbmJzcDsgJm5ic3A7ZnJhbWVidWZmZXIgdmFyaWFibGUg
cGFyYW1ldGVyczxicj4mZ3Q7ICsgKjxicj4mZ3Q7ICsgKiBAcGFyYW0gJm5ic3A7ICZuYnNwOyAm
bmJzcDsgaW5mbyAmbmJzcDsgJm5ic3A7IGZyYW1lYnVmZmVyIGluZm9ybWF0aW9uIHBvaW50ZXI8
YnI+Jmd0OyArICovPGJyPiZndDsgK3N0YXRpYyBpbnQgaW14X2lwdV9mYl9jaGVja192YXIoc3Ry
dWN0IGZiX3Zhcl9zY3JlZW5pbmZvICp2YXIsIHN0cnVjdCBmYl9pbmZvICppbmZvKTxicj4mZ3Q7
ICt7PGJyPiZndDsgKyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBzdHJ1Y3QgaW14X2lwdV9mYl9pbmZv
ICpteGNfZmJpID0gaW5mby0mZ3Q7cGFyOzxicj4mZ3Q7ICsgJm5ic3A7ICZuYnNwOyAmbmJzcDsg
c3RydWN0IGlteGZiX3JnYiAqcmdiOzxicj4mZ3Q7ICs8YnI+Jmd0OyArICZuYnNwOyAmbmJzcDsg
Jm5ic3A7IC8qIHdlIGRvbid0IHN1cHBvcnQgeHBhbiwgZm9yY2UgeHJlc192aXJ0dWFsIHRvIGJl
IGVxdWFsIHRvIHhyZXMgKi88YnI+Jmd0OyArICZuYnNwOyAmbmJzcDsgJm5ic3A7IHZhci0mZ3Q7
eHJlc192aXJ0dWFsID0gdmFyLSZndDt4cmVzOzxicj4mZ3Q7ICs8YnI+Jmd0OyArICZuYnNwOyAm
bmJzcDsgJm5ic3A7IGlmICh2YXItJmd0O3lyZXNfdmlydHVhbCAmbHQ7IHZhci0mZ3Q7eXJlcyk8
YnI+Jmd0OyArICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNw
OyB2YXItJmd0O3lyZXNfdmlydHVhbCA9IHZhci0mZ3Q7eXJlczs8YnI+Jmd0OyArPGJyPiZndDsg
KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBzd2l0Y2ggKHZhci0mZ3Q7Yml0c19wZXJfcGl4ZWwpIHs8
YnI+Jmd0OyArICZuYnNwOyAmbmJzcDsgJm5ic3A7IGNhc2UgODo8YnI+Jmd0OyArICZuYnNwOyAm
bmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyByZ2IgPSAmYW1wO2RlZl9y
Z2JfODs8YnI+Jmd0OyArICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7
ICZuYnNwOyBicmVhazs8YnI+Jmd0OyArICZuYnNwOyAmbmJzcDsgJm5ic3A7IGNhc2UgMTY6PGJy
PiZndDsgKyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsg
cmdiID0gJmFtcDtkZWZfcmdiXzE2Ozxicj4mZ3Q7ICsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5i
c3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7IG14Y19mYmktJmd0O2lwdV9pbl9waXhfZm10ID0gSVBV
X1BJWF9GTVRfUkdCNTY1Ozxicj4mZ3Q7ICsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZu
YnNwOyAmbmJzcDsgJm5ic3A7IGJyZWFrOzxicj4mZ3Q7ICsgJm5ic3A7ICZuYnNwOyAmbmJzcDsg
Y2FzZSAyNDo8YnI+Jmd0OyArICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5i
c3A7ICZuYnNwOyByZ2IgPSAmYW1wO2RlZl9yZ2JfMjQ7PGJyPiZndDsgKyAmbmJzcDsgJm5ic3A7
ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgbXhjX2ZiaS0mZ3Q7aXB1X2luX3Bp
eF9mbXQgPSBJUFVfUElYX0ZNVF9CR1IyNDs8YnI+Jmd0OyArICZuYnNwOyAmbmJzcDsgJm5ic3A7
ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBicmVhazs8YnI+Jmd0OyArICZuYnNwOyAmbmJz
cDsgJm5ic3A7IGNhc2UgMzI6PGJyPiZndDsgKyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsg
Jm5ic3A7ICZuYnNwOyAmbmJzcDsgcmdiID0gJmFtcDtkZWZfcmdiXzMyOzxicj4mZ3Q7ICsgJm5i
c3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7IG14Y19mYmktJmd0
O2lwdV9pbl9waXhfZm10ID0gSVBVX1BJWF9GTVRfQkdSMzI7PGJyPiZndDsgKyAmbmJzcDsgJm5i
c3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgYnJlYWs7PGJyPiZndDsgKyAm
bmJzcDsgJm5ic3A7ICZuYnNwOyBkZWZhdWx0Ojxicj4mZ3Q7ICsgJm5ic3A7ICZuYnNwOyAmbmJz
cDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7IHZhci0mZ3Q7Yml0c19wZXJfcGl4ZWwgPSAy
NDs8YnI+Jmd0OyArICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZu
YnNwOyByZ2IgPSAmYW1wO2RlZl9yZ2JfMjQ7PGJyPiZndDsgKyAmbmJzcDsgJm5ic3A7ICZuYnNw
OyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgbXhjX2ZiaS0mZ3Q7aXB1X2luX3BpeF9mbXQg
PSBJUFVfUElYX0ZNVF9CR1IyNDs8YnI+Jmd0OyArICZuYnNwOyAmbmJzcDsgJm5ic3A7IH08YnI+
Jmd0OyArPGJyPiZndDsgKyAmbmJzcDsgJm5ic3A7ICZuYnNwOyB2YXItJmd0O3JlZCAmbmJzcDsg
Jm5ic3A7PSByZ2ItJmd0O3JlZDs8YnI+Jmd0OyArICZuYnNwOyAmbmJzcDsgJm5ic3A7IHZhci0m
Z3Q7Z3JlZW4gJm5ic3A7PSByZ2ItJmd0O2dyZWVuOzxicj4mZ3Q7ICsgJm5ic3A7ICZuYnNwOyAm
bmJzcDsgdmFyLSZndDtibHVlICZuYnNwOyA9IHJnYi0mZ3Q7Ymx1ZTs8YnI+Jmd0OyArICZuYnNw
OyAmbmJzcDsgJm5ic3A7IHZhci0mZ3Q7dHJhbnNwID0gcmdiLSZndDt0cmFuc3A7PGJyPiZndDsg
Kzxicj4mZ3Q7ICsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgcmV0dXJuIDA7PGJyPiZndDsgK308YnI+
Jmd0OyArPGJyPiZndDsgK3N0YXRpYyBpbmxpbmUgdW5zaWduZWQgaW50IGNoYW5fdG9fZmllbGQo
dV9pbnQgY2hhbiwgc3RydWN0IGZiX2JpdGZpZWxkICpiZik8YnI+Jmd0OyArezxicj4mZ3Q7ICsg
Jm5ic3A7ICZuYnNwOyAmbmJzcDsgY2hhbiAmYW1wOz0gMHhmZmZmOzxicj4mZ3Q7ICsgJm5ic3A7
ICZuYnNwOyAmbmJzcDsgY2hhbiAmZ3Q7Jmd0Oz0gMTYgLSBiZi0mZ3Q7bGVuZ3RoOzxicj4mZ3Q7
ICsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgcmV0dXJuIGNoYW4gJmx0OyZsdDsgYmYtJmd0O29mZnNl
dDs8YnI+Jmd0OyArfTxicj4mZ3Q7ICs8YnI+Jmd0OyArc3RhdGljIGludCBpbXhfaXB1X2ZiX3Nl
dGNvbHJlZyh1X2ludCByZWdubywgdV9pbnQgcmVkLCB1X2ludCBncmVlbiwgdV9pbnQgYmx1ZSw8
YnI+Jmd0OyArICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNw
OyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwO3VfaW50IHRyYW5zLCBz
dHJ1Y3QgZmJfaW5mbyAqZmJpKTxicj4mZ3Q7ICt7PGJyPiZndDsgKyAmbmJzcDsgJm5ic3A7ICZu
YnNwOyB1bnNpZ25lZCBpbnQgdmFsOzxicj4mZ3Q7ICsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgaW50
IHJldCA9IDE7PGJyPiZndDsgKzxicj4mZ3Q7ICsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgLyo8YnI+
Jmd0OyArICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyogSWYgZ3JleXNjYWxlIGlzIHRydWUs
IHRoZW4gd2UgY29udmVydCB0aGUgUkdCIHZhbHVlPGJyPiZndDsgKyAmbmJzcDsgJm5ic3A7ICZu
YnNwOyAmbmJzcDsqIHRvIGdyZXlzY2FsZSBubyBtYXR0ZXIgd2hhdCB2aXN1YWwgd2UgYXJlIHVz
aW5nLjxicj4mZ3Q7ICsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7Ki88YnI+Jmd0OyArICZu
YnNwOyAmbmJzcDsgJm5ic3A7IGlmIChmYmktJmd0O3Zhci5ncmF5c2NhbGUpPGJyPiZndDsgKyAm
bmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgcmVkID0gZ3Jl
ZW4gPSBibHVlID0gKDE5NTk1ICogcmVkICsgMzg0NzAgKiBncmVlbiArPGJyPiZndDsgKyAmbmJz
cDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNw
OyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7
ICZuYnNwOyA3NDcxICogYmx1ZSkgJmd0OyZndDsgMTY7PGJyPiZndDsgKyAmbmJzcDsgJm5ic3A7
ICZuYnNwOyBzd2l0Y2ggKGZiaS0mZ3Q7Zml4LnZpc3VhbCkgezxicj4mZ3Q7ICsgJm5ic3A7ICZu
YnNwOyAmbmJzcDsgY2FzZSBGQl9WSVNVQUxfVFJVRUNPTE9SOjxicj4mZ3Q7ICsgJm5ic3A7ICZu
YnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7IC8qPGJyPiZndDsgKyAmbmJz
cDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7KiAxNi1i
aXQgVHJ1ZSBDb2xvdXIuICZuYnNwO1dlIGVuY29kZSB0aGUgUkdCIHZhbHVlPGJyPiZndDsgKyAm
bmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7KiBh
Y2NvcmRpbmcgdG8gdGhlIFJHQiBiaXRmaWVsZCBpbmZvcm1hdGlvbi48YnI+Jmd0OyArICZuYnNw
OyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsqLzxicj4m
Z3Q7ICsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7IGlm
IChyZWdubyAmbHQ7IDE2KSB7PGJyPiZndDsgKyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsg
Jm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7IHUzMiAqcGFs
ID0gZmJpLSZndDtwc2V1ZG9fcGFsZXR0ZTs8YnI+Jmd0OyArPGJyPiZndDsgKyAmbmJzcDsgJm5i
c3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJz
cDsgJm5ic3A7IHZhbCA9IGNoYW5fdG9fZmllbGQocmVkLCAmYW1wO2ZiaS0mZ3Q7dmFyLnJlZCk7
PGJyPiZndDsgKyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJz
cDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7IHZhbCB8PSBjaGFuX3RvX2ZpZWxkKGdyZWVu
LCAmYW1wO2ZiaS0mZ3Q7dmFyLmdyZWVuKTs8YnI+Jmd0OyArICZuYnNwOyAmbmJzcDsgJm5ic3A7
ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsg
dmFsIHw9IGNoYW5fdG9fZmllbGQoYmx1ZSwgJmFtcDtmYmktJmd0O3Zhci5ibHVlKTs8YnI+Jmd0
OyArPGJyPiZndDsgKyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAm
bmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7IHBhbFtyZWdub10gPSB2YWw7PGJyPiZn
dDsgKyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5i
c3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7IHJldCA9IDA7PGJyPiZndDsgKyAmbmJzcDsgJm5ic3A7
ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgfTxicj4mZ3Q7ICsgJm5ic3A7ICZu
YnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7IGJyZWFrOzxicj4mZ3Q7ICs8
YnI+Jmd0OyArICZuYnNwOyAmbmJzcDsgJm5ic3A7IGNhc2UgRkJfVklTVUFMX1NUQVRJQ19QU0VV
RE9DT0xPUjo8YnI+Jmd0OyArICZuYnNwOyAmbmJzcDsgJm5ic3A7IGNhc2UgRkJfVklTVUFMX1BT
RVVET0NPTE9SOjxicj4mZ3Q7ICsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAm
bmJzcDsgJm5ic3A7IGJyZWFrOzxicj4mZ3Q7ICsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgfTxicj4m
Z3Q7ICs8YnI+Jmd0OyArICZuYnNwOyAmbmJzcDsgJm5ic3A7IHJldHVybiByZXQ7PGJyPiZndDsg
K308YnI+Jmd0OyArPGJyPiZndDsgK3N0YXRpYyBpbnQgaW14X2lwdV9mYl9ibGFuayhpbnQgYmxh
bmssIHN0cnVjdCBmYl9pbmZvICppbmZvKTxicj4mZ3Q7ICt7PGJyPiZndDsgKyAmbmJzcDsgJm5i
c3A7ICZuYnNwOyBkZXZfZGJnKGluZm8tJmd0O2RldmljZSwgJnF1b3Q7YmxhbmsgPSAlZFxuJnF1
b3Q7LCBibGFuayk7PGJyPiZndDsgKzxicj4mZ3Q7ICsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgc3dp
dGNoIChibGFuaykgezxicj4mZ3Q7ICsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgY2FzZSBGQl9CTEFO
S19QT1dFUkRPV046PGJyPiZndDsgKyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBjYXNlIEZCX0JMQU5L
X1ZTWU5DX1NVU1BFTkQ6PGJyPiZndDsgKyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBjYXNlIEZCX0JM
QU5LX0hTWU5DX1NVU1BFTkQ6PGJyPiZndDsgKyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBjYXNlIEZC
X0JMQU5LX05PUk1BTDo8YnI+Jmd0OyArICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJz
cDsgJm5ic3A7ICZuYnNwOyBpbXhfaXB1X2ZiX2Rpc2FibGUoaW5mbyk7PGJyPiZndDsgKyAmbmJz
cDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgYnJlYWs7PGJyPiZn
dDsgKyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBjYXNlIEZCX0JMQU5LX1VOQkxBTks6PGJyPiZndDsg
KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgaW14X2lw
dV9mYl9lbmFibGUoaW5mbyk7PGJyPiZndDsgKyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsg
Jm5ic3A7ICZuYnNwOyAmbmJzcDsgYnJlYWs7PGJyPiZndDsgKyAmbmJzcDsgJm5ic3A7ICZuYnNw
OyB9PGJyPiZndDsgKzxicj4mZ3Q7ICsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgcmV0dXJuIDA7PGJy
PiZndDsgK308YnI+Jmd0OyArPGJyPiZndDsgK3N0YXRpYyBpbnQgaW14X2lwdV9mYl9wYW5fZGlz
cGxheShzdHJ1Y3QgZmJfdmFyX3NjcmVlbmluZm8gKnZhciw8YnI+Jmd0OyArICZuYnNwOyAmbmJz
cDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBzdHJ1Y3QgZmJfaW5mbyAqaW5m
byk8YnI+Jmd0OyArezxicj4mZ3Q7ICsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgc3RydWN0IGlteF9p
cHVfZmJfaW5mbyAqbXhjX2ZiaSA9IGluZm8tJmd0O3Bhcjs8YnI+Jmd0OyArICZuYnNwOyAmbmJz
cDsgJm5ic3A7IHVuc2lnbmVkIGxvbmcgYmFzZTs8YnI+Jmd0OyArICZuYnNwOyAmbmJzcDsgJm5i
c3A7IGludCByZXQ7PGJyPiZndDsgKzxicj4mZ3Q7ICsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgaWYg
KGluZm8tJmd0O3Zhci55b2Zmc2V0ID09IHZhci0mZ3Q7eW9mZnNldCk8YnI+Jmd0OyArICZuYnNw
OyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyByZXR1cm4gMDsgJm5i
c3A7ICZuYnNwOyAmbmJzcDsgLyogTm8gY2hhbmdlLCBkbyBub3RoaW5nICovPGJyPiZndDsgKzxi
cj4mZ3Q7ICsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgYmFzZSA9IHZhci0mZ3Q7eW9mZnNldCAqIHZh
ci0mZ3Q7eHJlc192aXJ0dWFsICogdmFyLSZndDtiaXRzX3Blcl9waXhlbCAvIDg7PGJyPiZndDsg
KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBiYXNlICs9IGluZm8tJmd0O2ZpeC5zbWVtX3N0YXJ0Ozxi
cj4mZ3Q7ICs8YnI+Jmd0OyArICZuYnNwOyAmbmJzcDsgJm5ic3A7IHJldCA9IGlwdV93YWl0X2Zv
cl9pbnRlcnJ1cHQoSVBVX0lSUV9FT0YobXhjX2ZiaS0mZ3Q7aXB1X2NoYW5uZWxfbnVtKSwgMTAw
KTs8YnI+Jmd0OyArICZuYnNwOyAmbmJzcDsgJm5ic3A7IGlmIChyZXQpPGJyPiZndDsgKyAmbmJz
cDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgcmV0dXJuIHJldDs8
YnI+Jmd0OyArPGJyPiZndDsgKyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBpZiAoaXB1X2lkbWFjX3Vw
ZGF0ZV9jaGFubmVsX2J1ZmZlcihteGNfZmJpLSZndDtpcHVfY2gsIDAsIGJhc2UpKSB7PGJyPiZn
dDsgKyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgZGV2
X2VycihpbmZvLSZndDtkZXZpY2UsPGJyPiZndDsgKyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJz
cDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZxdW90
O0Vycm9yIHVwZGF0aW5nIFNEQyBidWYgdG8gYWRkcmVzcz0weCUwOGxYXG4mcXVvdDssIGJhc2Up
Ozxicj4mZ3Q7ICsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgfTxzcGFuIHN0eWxlPSdjb2xvcjojMUY0
OTdEJz48bzpwPjwvbzpwPjwvc3Bhbj48L3A+PHAgY2xhc3M9TXNvTm9ybWFsPjxiPjxpPjxzcGFu
IHN0eWxlPSdmb250LXNpemU6MTEuMHB0O2ZvbnQtZmFtaWx5OiJDYWxpYnJpIiwic2Fucy1zZXJp
ZiI7Y29sb3I6IzFGNDk3RCc+W0phc29uXSBJdCYjODIxNztzIGJldHRlciB0byBlbmFibGUgZG91
YmxlICYjODIxMTtidWZmZXIgZm9yIGZiIHdoaWNoIGNvdWxkIGF2b2lkIHRlYXJpbmcgaXNzdWUu
PG86cD48L286cD48L3NwYW4+PC9pPjwvYj48L3A+PHAgY2xhc3M9TXNvTm9ybWFsPjxicj4mZ3Q7
ICs8YnI+Jmd0OyArICZuYnNwOyAmbmJzcDsgJm5ic3A7IGluZm8tJmd0O3Zhci55b2Zmc2V0ID0g
dmFyLSZndDt5b2Zmc2V0Ozxicj4mZ3Q7ICs8YnI+Jmd0OyArICZuYnNwOyAmbmJzcDsgJm5ic3A7
IHJldHVybiAwOzxicj4mZ3Q7ICt9PGJyPiZndDsgKzxicj4mZ3Q7ICtzdGF0aWMgc3RydWN0IGZi
X29wcyBpbXhfaXB1X2ZiX29wcyA9IHs8YnI+Jmd0OyArICZuYnNwOyAmbmJzcDsgJm5ic3A7IC5v
d25lciAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7PSBUSElTX01PRFVMRSw8YnI+
Jmd0OyArICZuYnNwOyAmbmJzcDsgJm5ic3A7IC5mYl9zZXRfcGFyICZuYnNwOyAmbmJzcDsgPSBp
bXhfaXB1X2ZiX3NldF9wYXIsPGJyPiZndDsgKyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAuZmJfY2hl
Y2tfdmFyICZuYnNwOyA9IGlteF9pcHVfZmJfY2hlY2tfdmFyLDxicj4mZ3Q7ICsgJm5ic3A7ICZu
YnNwOyAmbmJzcDsgLmZiX3NldGNvbHJlZyAmbmJzcDsgPSBpbXhfaXB1X2ZiX3NldGNvbHJlZyw8
YnI+Jmd0OyArICZuYnNwOyAmbmJzcDsgJm5ic3A7IC5mYl9wYW5fZGlzcGxheSA9IGlteF9pcHVf
ZmJfcGFuX2Rpc3BsYXksPGJyPiZndDsgKyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAuZmJfZmlsbHJl
Y3QgJm5ic3A7ICZuYnNwOz0gY2ZiX2ZpbGxyZWN0LDxicj4mZ3Q7ICsgJm5ic3A7ICZuYnNwOyAm
bmJzcDsgLmZiX2NvcHlhcmVhICZuYnNwOyAmbmJzcDs9IGNmYl9jb3B5YXJlYSw8YnI+Jmd0OyAr
ICZuYnNwOyAmbmJzcDsgJm5ic3A7IC5mYl9pbWFnZWJsaXQgJm5ic3A7ID0gY2ZiX2ltYWdlYmxp
dCw8YnI+Jmd0OyArICZuYnNwOyAmbmJzcDsgJm5ic3A7IC5mYl9ibGFuayAmbmJzcDsgJm5ic3A7
ICZuYnNwOyA9IGlteF9pcHVfZmJfYmxhbmssPGJyPiZndDsgK307PGJyPiZndDsgKzxicj4mZ3Q7
ICsvKjxicj4mZ3Q7ICsgKiBPdmVybGF5IGZ1bmN0aW9uczxicj4mZ3Q7ICsgKi88YnI+Jmd0OyAr
c3RhdGljIGludCBpbXhfaXB1X2ZiX2VuYWJsZV9vdmVybGF5KHN0cnVjdCBmYl9pbmZvICpmYmkp
PGJyPiZndDsgK3s8YnI+Jmd0OyArICZuYnNwOyAmbmJzcDsgJm5ic3A7IHN0cnVjdCBpbXhfaXB1
X2ZiX2luZm8gKm14Y19mYmkgPSBmYmktJmd0O3Bhcjs8YnI+Jmd0OyArPGJyPiZndDsgKyAmbmJz
cDsgJm5ic3A7ICZuYnNwOyBpcHVfZG1mY19lbmFibGVfY2hhbm5lbChteGNfZmJpLSZndDtkbWZj
KTs8YnI+Jmd0OyArICZuYnNwOyAmbmJzcDsgJm5ic3A7IGlwdV9pZG1hY19lbmFibGVfY2hhbm5l
bChteGNfZmJpLSZndDtpcHVfY2gpOzxicj4mZ3Q7ICsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgaXB1
X2RwX2VuYWJsZV9mZyhteGNfZmJpLSZndDtkcCk7PGJyPiZndDsgKzxicj4mZ3Q7ICsgJm5ic3A7
ICZuYnNwOyAmbmJzcDsgcmV0dXJuIDA7PGJyPiZndDsgK308YnI+Jmd0OyArPGJyPiZndDsgK3N0
YXRpYyBpbnQgaW14X2lwdV9mYl9kaXNhYmxlX292ZXJsYXkoc3RydWN0IGZiX2luZm8gKmZiaSk8
YnI+Jmd0OyArezxicj4mZ3Q7ICsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgc3RydWN0IGlteF9pcHVf
ZmJfaW5mbyAqbXhjX2ZiaSA9IGZiaS0mZ3Q7cGFyOzxicj4mZ3Q7ICs8YnI+Jmd0OyArICZuYnNw
OyAmbmJzcDsgJm5ic3A7IGlwdV9kcF9kaXNhYmxlX2ZnKG14Y19mYmktJmd0O2RwKTs8YnI+Jmd0
OyArICZuYnNwOyAmbmJzcDsgJm5ic3A7IGlwdV9pZG1hY19kaXNhYmxlX2NoYW5uZWwobXhjX2Zi
aS0mZ3Q7aXB1X2NoKTs8YnI+Jmd0OyArICZuYnNwOyAmbmJzcDsgJm5ic3A7IGlwdV9kbWZjX2Rp
c2FibGVfY2hhbm5lbChteGNfZmJpLSZndDtkbWZjKTs8YnI+Jmd0OyArPGJyPiZndDsgKyAmbmJz
cDsgJm5ic3A7ICZuYnNwOyByZXR1cm4gMDs8YnI+Jmd0OyArfTxicj4mZ3Q7ICs8YnI+Jmd0OyAr
c3RhdGljIGludCBpbXhfaXB1X2ZiX3NldF9wYXJfb3ZlcmxheShzdHJ1Y3QgZmJfaW5mbyAqZmJp
KTxicj4mZ3Q7ICt7PGJyPiZndDsgKyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBzdHJ1Y3QgaW14X2lw
dV9mYl9pbmZvICpteGNfZmJpID0gZmJpLSZndDtwYXI7PGJyPiZndDsgKyAmbmJzcDsgJm5ic3A7
ICZuYnNwOyBzdHJ1Y3QgZmJfdmFyX3NjcmVlbmluZm8gKnZhciA9ICZhbXA7ZmJpLSZndDt2YXI7
PGJyPiZndDsgKyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBzdHJ1Y3QgZmJfaW5mbyAqZmJpX21hc3Rl
ciA9IG14Y19mYmktJmd0O21hc3Rlcjs8YnI+Jmd0OyArICZuYnNwOyAmbmJzcDsgJm5ic3A7IHN0
cnVjdCBmYl92YXJfc2NyZWVuaW5mbyAqdmFyX21hc3RlciA9ICZhbXA7ZmJpX21hc3Rlci0mZ3Q7
dmFyOzxicj4mZ3Q7ICsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgaW50IHJldDs8YnI+Jmd0OyArICZu
YnNwOyAmbmJzcDsgJm5ic3A7IGludCBpbnRlcmxhY2VkID0gMDs8YnI+Jmd0OyArICZuYnNwOyAm
bmJzcDsgJm5ic3A7IGludCBlbmFibGVkID0gbXhjX2ZiaS0mZ3Q7ZW5hYmxlZDs8YnI+Jmd0OyAr
PGJyPiZndDsgKyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBkZXZfZGJnKGZiaS0mZ3Q7ZGV2aWNlLCAm
cXVvdDtSZWNvbmZpZ3VyaW5nIGZyYW1lYnVmZmVyICVkeCVkLSVkXG4mcXVvdDssPGJyPiZndDsg
KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgZmJpLSZn
dDt2YXIueHJlcywgZmJpLSZndDt2YXIueXJlcywgZmJpLSZndDt2YXIuYml0c19wZXJfcGl4ZWwp
Ozxicj4mZ3Q7ICs8YnI+Jmd0OyArICZuYnNwOyAmbmJzcDsgJm5ic3A7IGlmIChlbmFibGVkKTxi
cj4mZ3Q7ICsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7
IGlteF9pcHVfZmJfZGlzYWJsZV9vdmVybGF5KGZiaSk7PGJyPiZndDsgKzxicj4mZ3Q7ICsgJm5i
c3A7ICZuYnNwOyAmbmJzcDsgZmJpLSZndDtmaXgubGluZV9sZW5ndGggPSB2YXItJmd0O3hyZXNf
dmlydHVhbCAqPGJyPiZndDsgKyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZu
YnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5i
c3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7dmFyLSZndDtiaXRzX3Blcl9waXhlbCAvIDg7PGJyPiZn
dDsgKzxicj4mZ3Q7ICsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgcmV0ID0gaW14X2lwdV9mYl9tYXBf
dmlkZW9fbWVtb3J5KGZiaSk7PGJyPiZndDsgKyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBpZiAocmV0
KTxicj4mZ3Q7ICsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5i
c3A7IHJldHVybiByZXQ7PGJyPiZndDsgKzxicj4mZ3Q7ICsgJm5ic3A7ICZuYnNwOyAmbmJzcDsg
aXB1X2RwX3NldF93aW5kb3dfcG9zKG14Y19mYmktJmd0O2RwLCA2NCwgNjQpOzxicj4mZ3Q7ICs8
YnI+Jmd0OyArICZuYnNwOyAmbmJzcDsgJm5ic3A7IHZhci0mZ3Q7eG9mZnNldCA9IHZhci0mZ3Q7
eW9mZnNldCA9IDA7PGJyPiZndDsgKzxicj4mZ3Q7ICsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgaWYg
KHZhci0mZ3Q7dm1vZGUgJmFtcDsgRkJfVk1PREVfSU5URVJMQUNFRCk8YnI+Jmd0OyArICZuYnNw
OyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBpbnRlcmxhY2VkID0g
MTs8YnI+Jmd0OyArPGJyPiZndDsgKyAmbmJzcDsgJm5ic3A7ICZuYnNwOyByZXQgPSBpcHVfaWRt
YWNfaW5pdF9jaGFubmVsX2J1ZmZlcihteGNfZmJpLSZndDtpcHVfY2gsPGJyPiZndDsgKyAmbmJz
cDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNw
OyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7
ICZuYnNwOyAmbmJzcDsgbXhjX2ZiaS0mZ3Q7aXB1X2luX3BpeF9mbXQsPGJyPiZndDsgKyAmbmJz
cDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNw
OyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7
ICZuYnNwOyAmbmJzcDsgdmFyLSZndDt4cmVzLCB2YXItJmd0O3lyZXMsPGJyPiZndDsgKyAmbmJz
cDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNw
OyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7
ICZuYnNwOyAmbmJzcDsgZmJpLSZndDtmaXgubGluZV9sZW5ndGgsPGJyPiZndDsgKyAmbmJzcDsg
Jm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAm
bmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZu
YnNwOyAmbmJzcDsgSVBVX1JPVEFURV9OT05FLDxicj4mZ3Q7ICsgJm5ic3A7ICZuYnNwOyAmbmJz
cDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNw
OyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7
IGZiaS0mZ3Q7Zml4LnNtZW1fc3RhcnQsPGJyPiZndDsgKyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAm
bmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZu
YnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgMCw8
YnI+Jmd0OyArICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNw
OyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7
ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAwLCAwLCBpbnRlcmxhY2VkKTs8YnI+Jmd0OyAr
ICZuYnNwOyAmbmJzcDsgJm5ic3A7IGlmIChyZXQpIHs8YnI+Jmd0OyArICZuYnNwOyAmbmJzcDsg
Jm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBkZXZfZGJnKGZiaS0mZ3Q7ZGV2aWNl
LCAmcXVvdDtpbml0IGNoYW5uZWwgYnVmZmVyIGZhaWxlZCB3aXRoICVkXG4mcXVvdDssPGJyPiZn
dDsgKyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5i
c3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyByZXQp
Ozxicj4mZ3Q7ICsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5i
c3A7IHJldHVybiByZXQ7PGJyPiZndDsgKyAmbmJzcDsgJm5ic3A7ICZuYnNwOyB9PGJyPiZndDsg
Kzxicj4mZ3Q7ICsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgcmV0ID0gaXB1X2RtZmNfaW5pdF9jaGFu
bmVsKG14Y19mYmktJmd0O2RtZmMsIHZhci0mZ3Q7eHJlcyk7PGJyPiZndDsgKyAmbmJzcDsgJm5i
c3A7ICZuYnNwOyBpZiAocmV0KSB7PGJyPiZndDsgKyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJz
cDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgZGV2X2RiZyhmYmktJmd0O2RldmljZSwgJnF1b3Q7aW5p
dGlhbGl6aW5nIGRtZmMgY2hhbm5lbCBmYWlsZWQgd2l0aCAlZFxuJnF1b3Q7LDxicj4mZ3Q7ICsg
Jm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAm
bmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgcmV0KTs8YnI+
Jmd0OyArICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBy
ZXR1cm4gcmV0Ozxicj4mZ3Q7ICsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgfTxicj4mZ3Q7ICs8YnI+
Jmd0OyArICZuYnNwOyAmbmJzcDsgJm5ic3A7IHJldCA9IGlwdV9kbWZjX2FsbG9jX2JhbmR3aWR0
aChteGNfZmJpLSZndDtkbWZjLCBjYWxjX2JhbmR3aWR0aCh2YXIsIGNhbGNfdnJlZih2YXJfbWFz
dGVyKSkpOzxicj4mZ3Q7ICsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgaWYgKHJldCkgezxicj4mZ3Q7
ICsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7IGRldl9k
YmcoZmJpLSZndDtkZXZpY2UsICZxdW90O2FsbG9jYXRpbmcgZG1mYyBiYW5kd2lkdGggZmFpbGVk
IHdpdGggJWRcbiZxdW90Oyw8YnI+Jmd0OyArICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAm
bmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZu
YnNwOyAmbmJzcDsgJm5ic3A7IHJldCk7PGJyPiZndDsgKyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAm
bmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgcmV0dXJuIHJldDs8YnI+Jmd0OyArICZuYnNwOyAm
bmJzcDsgJm5ic3A7IH08YnI+Jmd0OyArPGJyPiZndDsgKyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBp
ZiAoZW5hYmxlZCk8YnI+Jmd0OyArICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsg
Jm5ic3A7ICZuYnNwOyBpbXhfaXB1X2ZiX2VuYWJsZV9vdmVybGF5KGZiaSk7PGJyPiZndDsgKzxi
cj4mZ3Q7ICsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgcmV0dXJuIHJldDs8YnI+Jmd0OyArfTxicj4m
Z3Q7ICs8YnI+Jmd0OyArc3RhdGljIGludCBpbXhfaXB1X2ZiX2JsYW5rX292ZXJsYXkoaW50IGJs
YW5rLCBzdHJ1Y3QgZmJfaW5mbyAqZmJpKTxicj4mZ3Q7ICt7PGJyPiZndDsgKyAmbmJzcDsgJm5i
c3A7ICZuYnNwOyBkZXZfZGJnKGZiaS0mZ3Q7ZGV2aWNlLCAmcXVvdDtibGFuayA9ICVkXG4mcXVv
dDssIGJsYW5rKTs8YnI+Jmd0OyArPGJyPiZndDsgKyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBzd2l0
Y2ggKGJsYW5rKSB7PGJyPiZndDsgKyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBjYXNlIEZCX0JMQU5L
X1BPV0VSRE9XTjo8YnI+Jmd0OyArICZuYnNwOyAmbmJzcDsgJm5ic3A7IGNhc2UgRkJfQkxBTktf
VlNZTkNfU1VTUEVORDo8YnI+Jmd0OyArICZuYnNwOyAmbmJzcDsgJm5ic3A7IGNhc2UgRkJfQkxB
TktfSFNZTkNfU1VTUEVORDo8YnI+Jmd0OyArICZuYnNwOyAmbmJzcDsgJm5ic3A7IGNhc2UgRkJf
QkxBTktfTk9STUFMOjxicj4mZ3Q7ICsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNw
OyAmbmJzcDsgJm5ic3A7IGlteF9pcHVfZmJfZGlzYWJsZV9vdmVybGF5KGZiaSk7PGJyPiZndDsg
KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgYnJlYWs7
PGJyPiZndDsgKyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBjYXNlIEZCX0JMQU5LX1VOQkxBTks6PGJy
PiZndDsgKyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsg
aW14X2lwdV9mYl9lbmFibGVfb3ZlcmxheShmYmkpOzxicj4mZ3Q7ICsgJm5ic3A7ICZuYnNwOyAm
bmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7IGJyZWFrOzxicj4mZ3Q7ICsgJm5ic3A7
ICZuYnNwOyAmbmJzcDsgfTxicj4mZ3Q7ICs8YnI+Jmd0OyArICZuYnNwOyAmbmJzcDsgJm5ic3A7
IHJldHVybiAwOzxicj4mZ3Q7ICt9PGJyPiZndDsgKzxicj4mZ3Q7ICtzdGF0aWMgc3RydWN0IGZi
X29wcyBpbXhfaXB1X2ZiX292ZXJsYXlfb3BzID0gezxicj4mZ3Q7ICsgJm5ic3A7ICZuYnNwOyAm
bmJzcDsgLm93bmVyICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDs9IFRISVNfTU9E
VUxFLDxicj4mZ3Q7ICsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgLmZiX3NldF9wYXIgJm5ic3A7ICZu
YnNwOyA9IGlteF9pcHVfZmJfc2V0X3Bhcl9vdmVybGF5LDxicj4mZ3Q7ICsgJm5ic3A7ICZuYnNw
OyAmbmJzcDsgLmZiX2NoZWNrX3ZhciAmbmJzcDsgPSBpbXhfaXB1X2ZiX2NoZWNrX3Zhciw8YnI+
Jmd0OyArICZuYnNwOyAmbmJzcDsgJm5ic3A7IC5mYl9zZXRjb2xyZWcgJm5ic3A7ID0gaW14X2lw
dV9mYl9zZXRjb2xyZWcsPGJyPiZndDsgKyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAuZmJfcGFuX2Rp
c3BsYXkgPSBpbXhfaXB1X2ZiX3Bhbl9kaXNwbGF5LDxicj4mZ3Q7ICsgJm5ic3A7ICZuYnNwOyAm
bmJzcDsgLmZiX2ZpbGxyZWN0ICZuYnNwOyAmbmJzcDs9IGNmYl9maWxscmVjdCw8YnI+Jmd0OyAr
ICZuYnNwOyAmbmJzcDsgJm5ic3A7IC5mYl9jb3B5YXJlYSAmbmJzcDsgJm5ic3A7PSBjZmJfY29w
eWFyZWEsPGJyPiZndDsgKyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAuZmJfaW1hZ2VibGl0ICZuYnNw
OyA9IGNmYl9pbWFnZWJsaXQsPGJyPiZndDsgKyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAuZmJfYmxh
bmsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgPSBpbXhfaXB1X2ZiX2JsYW5rX292ZXJsYXksPGJyPiZn
dDsgK307PGJyPiZndDsgKzxicj4mZ3Q7ICtzdGF0aWMgc3RydWN0IGZiX2luZm8gKmlteF9pcHVf
ZmJfaW5pdF9mYmluZm8oc3RydWN0IGRldmljZSAqZGV2LCBzdHJ1Y3QgZmJfb3BzICpvcHMpPGJy
PiZndDsgK3s8YnI+Jmd0OyArICZuYnNwOyAmbmJzcDsgJm5ic3A7IHN0cnVjdCBmYl9pbmZvICpm
Ymk7PGJyPiZndDsgKyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBzdHJ1Y3QgaW14X2lwdV9mYl9pbmZv
ICpteGNfZmJpOzxicj4mZ3Q7ICs8YnI+Jmd0OyArICZuYnNwOyAmbmJzcDsgJm5ic3A7IGZiaSA9
IGZyYW1lYnVmZmVyX2FsbG9jKHNpemVvZihzdHJ1Y3QgaW14X2lwdV9mYl9pbmZvKSwgZGV2KTs8
YnI+Jmd0OyArICZuYnNwOyAmbmJzcDsgJm5ic3A7IGlmICghZmJpKTxicj4mZ3Q7ICsgJm5ic3A7
ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7IHJldHVybiBOVUxMOzxi
cj4mZ3Q7ICs8YnI+Jmd0OyArICZuYnNwOyAmbmJzcDsgJm5ic3A7IEJVR19PTihmYmktJmd0O3Bh
ciA9PSBOVUxMKTs8YnI+Jmd0OyArICZuYnNwOyAmbmJzcDsgJm5ic3A7IG14Y19mYmkgPSBmYmkt
Jmd0O3Bhcjs8YnI+Jmd0OyArPGJyPiZndDsgKyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBmYmktJmd0
O3Zhci5hY3RpdmF0ZSA9IEZCX0FDVElWQVRFX05PVzs8YnI+Jmd0OyArPGJyPiZndDsgKyAmbmJz
cDsgJm5ic3A7ICZuYnNwOyBmYmktJmd0O2Zib3BzID0gb3BzOzxicj4mZ3Q7ICsgJm5ic3A7ICZu
YnNwOyAmbmJzcDsgZmJpLSZndDtmbGFncyA9IEZCSU5GT19GTEFHX0RFRkFVTFQ7PGJyPiZndDsg
KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBmYmktJmd0O3BzZXVkb19wYWxldHRlID0gbXhjX2ZiaS0m
Z3Q7cHNldWRvX3BhbGV0dGU7PGJyPiZndDsgKzxicj4mZ3Q7ICsgJm5ic3A7ICZuYnNwOyAmbmJz
cDsgZmJfYWxsb2NfY21hcCgmYW1wO2ZiaS0mZ3Q7Y21hcCwgMTYsIDApOzxicj4mZ3Q7ICs8YnI+
Jmd0OyArICZuYnNwOyAmbmJzcDsgJm5ic3A7IHJldHVybiBmYmk7PGJyPiZndDsgK308YnI+Jmd0
OyArPGJyPiZndDsgK3N0YXRpYyBpbnQgaW14X2lwdV9mYl9pbml0X292ZXJsYXkoc3RydWN0IHBs
YXRmb3JtX2RldmljZSAqcGRldiw8YnI+Jmd0OyArICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNw
OyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBzdHJ1Y3QgZmJfaW5mbyAqZmJpX21hc3RlciwgaW50IGlw
dV9jaGFubmVsKTxicj4mZ3Q7ICt7PGJyPiZndDsgKyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBzdHJ1
Y3QgaW14X2lwdV9mYl9pbmZvICpteGNfZmJpX21hc3RlciA9IGZiaV9tYXN0ZXItJmd0O3Bhcjs8
YnI+Jmd0OyArICZuYnNwOyAmbmJzcDsgJm5ic3A7IHN0cnVjdCBmYl9pbmZvICpvdmxmYmk7PGJy
PiZndDsgKyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBzdHJ1Y3QgaW14X2lwdV9mYl9pbmZvICpvdmxf
bXhjX2ZiaTs8YnI+Jmd0OyArICZuYnNwOyAmbmJzcDsgJm5ic3A7IGludCByZXQ7PGJyPiZndDsg
Kzxicj4mZ3Q7ICsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgb3ZsZmJpID0gaW14X2lwdV9mYl9pbml0
X2ZiaW5mbygmYW1wO3BkZXYtJmd0O2RldiwgJmFtcDtpbXhfaXB1X2ZiX292ZXJsYXlfb3BzKTs8
YnI+Jmd0OyArICZuYnNwOyAmbmJzcDsgJm5ic3A7IGlmICghb3ZsZmJpKTxicj4mZ3Q7ICsgJm5i
c3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7IHJldHVybiAtRU5P
TUVNOzxicj4mZ3Q7ICs8YnI+Jmd0OyArICZuYnNwOyAmbmJzcDsgJm5ic3A7IG92bF9teGNfZmJp
ID0gb3ZsZmJpLSZndDtwYXI7PGJyPiZndDsgKyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBvdmxfbXhj
X2ZiaS0mZ3Q7aXB1X2NoID0gaXB1X2lkbWFjX2dldChpcHVfY2hhbm5lbCk7PGJyPiZndDsgKyAm
bmJzcDsgJm5ic3A7ICZuYnNwOyBvdmxfbXhjX2ZiaS0mZ3Q7ZG1mYyA9IGlwdV9kbWZjX2dldChp
cHVfY2hhbm5lbCk7PGJyPiZndDsgKyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBvdmxfbXhjX2ZiaS0m
Z3Q7aXB1X2RpID0gLTE7PGJyPiZndDsgKyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBvdmxfbXhjX2Zi
aS0mZ3Q7ZHAgPSBteGNfZmJpX21hc3Rlci0mZ3Q7ZHA7PGJyPiZndDsgKyAmbmJzcDsgJm5ic3A7
ICZuYnNwOyBvdmxfbXhjX2ZiaS0mZ3Q7bWFzdGVyID0gZmJpX21hc3Rlcjs8YnI+Jmd0OyArICZu
YnNwOyAmbmJzcDsgJm5ic3A7IG14Y19mYmlfbWFzdGVyLSZndDtzbGF2ZSA9IG92bGZiaTs8YnI+
Jmd0OyArPGJyPiZndDsgKyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBvdmxmYmktJmd0O3Zhci54cmVz
ID0gMjQwOzxicj4mZ3Q7ICsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgb3ZsZmJpLSZndDt2YXIueXJl
cyA9IDMyMDs8YnI+Jmd0OyArICZuYnNwOyAmbmJzcDsgJm5ic3A7IG92bGZiaS0mZ3Q7dmFyLnly
ZXNfdmlydHVhbCA9IG92bGZiaS0mZ3Q7dmFyLnlyZXM7PGJyPiZndDsgKyAmbmJzcDsgJm5ic3A7
ICZuYnNwOyBvdmxmYmktJmd0O3Zhci54cmVzX3ZpcnR1YWwgPSBvdmxmYmktJmd0O3Zhci54cmVz
Ozxicj4mZ3Q7ICsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgaW14X2lwdV9mYl9jaGVja192YXIoJmFt
cDtvdmxmYmktJmd0O3Zhciwgb3ZsZmJpKTs8YnI+Jmd0OyArICZuYnNwOyAmbmJzcDsgJm5ic3A7
IGlteF9pcHVfZmJfc2V0X2ZpeChvdmxmYmkpOzxicj4mZ3Q7ICs8YnI+Jmd0OyArICZuYnNwOyAm
bmJzcDsgJm5ic3A7IHJldCA9IHJlZ2lzdGVyX2ZyYW1lYnVmZmVyKG92bGZiaSk7PGJyPiZndDsg
KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBpZiAocmV0KSB7PGJyPiZndDsgKyAmbmJzcDsgJm5ic3A7
ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgZnJhbWVidWZmZXJfcmVsZWFzZShv
dmxmYmkpOzxicj4mZ3Q7ICsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJz
cDsgJm5ic3A7IHJldHVybiByZXQ7PGJyPiZndDsgKyAmbmJzcDsgJm5ic3A7ICZuYnNwOyB9PGJy
PiZndDsgKzxicj4mZ3Q7ICsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgaXB1X2RwX3NldF9nbG9iYWxf
YWxwaGEob3ZsX214Y19mYmktJmd0O2RwLCAxLCAweDgwLCAxKTs8YnI+Jmd0OyArICZuYnNwOyAm
bmJzcDsgJm5ic3A7IGlwdV9kcF9zZXRfY29sb3Jfa2V5KG92bF9teGNfZmJpLSZndDtkcCwgMCwg
MCk7PGJyPiZndDsgKzxicj4mZ3Q7ICsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgaW14X2lwdV9mYl9z
ZXRfcGFyX292ZXJsYXkob3ZsZmJpKTs8YnI+Jmd0OyArPGJyPiZndDsgKyAmbmJzcDsgJm5ic3A7
ICZuYnNwOyByZXR1cm4gMDs8YnI+Jmd0OyArfTxicj4mZ3Q7ICs8YnI+Jmd0OyArc3RhdGljIHZv
aWQgaW14X2lwdV9mYl9leGl0X292ZXJsYXkoc3RydWN0IHBsYXRmb3JtX2RldmljZSAqcGRldiw8
YnI+Jmd0OyArICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNw
OyBzdHJ1Y3QgZmJfaW5mbyAqZmJpX21hc3RlciwgaW50IGlwdV9jaGFubmVsKTxicj4mZ3Q7ICt7
PGJyPiZndDsgKyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBzdHJ1Y3QgaW14X2lwdV9mYl9pbmZvICpt
eGNfZmJpX21hc3RlciA9IGZiaV9tYXN0ZXItJmd0O3Bhcjs8YnI+Jmd0OyArICZuYnNwOyAmbmJz
cDsgJm5ic3A7IHN0cnVjdCBmYl9pbmZvICpvdmxmYmkgPSBteGNfZmJpX21hc3Rlci0mZ3Q7c2xh
dmU7PGJyPiZndDsgKyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBzdHJ1Y3QgaW14X2lwdV9mYl9pbmZv
ICpvdmxfbXhjX2ZiaSA9IG92bGZiaS0mZ3Q7cGFyOzxicj4mZ3Q7ICs8YnI+Jmd0OyArICZuYnNw
OyAmbmJzcDsgJm5ic3A7IGlteF9pcHVfZmJfYmxhbmtfb3ZlcmxheShGQl9CTEFOS19QT1dFUkRP
V04sIG92bGZiaSk7PGJyPiZndDsgKzxicj4mZ3Q7ICsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgdW5y
ZWdpc3Rlcl9mcmFtZWJ1ZmZlcihvdmxmYmkpOzxicj4mZ3Q7ICs8YnI+Jmd0OyArICZuYnNwOyAm
bmJzcDsgJm5ic3A7IGlwdV9pZG1hY19wdXQob3ZsX214Y19mYmktJmd0O2lwdV9jaCk7PGJyPiZn
dDsgKyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBpcHVfZG1mY19mcmVlX2JhbmR3aWR0aChvdmxfbXhj
X2ZiaS0mZ3Q7ZG1mYyk7PGJyPiZndDsgKyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBpcHVfZG1mY19w
dXQob3ZsX214Y19mYmktJmd0O2RtZmMpOzxicj4mZ3Q7ICs8YnI+Jmd0OyArICZuYnNwOyAmbmJz
cDsgJm5ic3A7IGZyYW1lYnVmZmVyX3JlbGVhc2Uob3ZsZmJpKTs8YnI+Jmd0OyArfTxicj4mZ3Q7
ICs8YnI+Jmd0OyArc3RhdGljIGludCBpbXhfaXB1X2ZiX2ZpbmRfbW9kZShzdHJ1Y3QgZmJfaW5m
byAqZmJpKTxicj4mZ3Q7ICt7PGJyPiZndDsgKyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBpbnQgcmV0
Ozxicj4mZ3Q7ICsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgc3RydWN0IGZiX3ZpZGVvbW9kZSAqbW9k
ZV9hcnJheTs8YnI+Jmd0OyArICZuYnNwOyAmbmJzcDsgJm5ic3A7IHN0cnVjdCBmYl9tb2RlbGlz
dCAqbW9kZWxpc3Q7PGJyPiZndDsgKyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBzdHJ1Y3QgZmJfdmFy
X3NjcmVlbmluZm8gKnZhciA9ICZhbXA7ZmJpLSZndDt2YXI7PGJyPiZndDsgKyAmbmJzcDsgJm5i
c3A7ICZuYnNwOyBpbnQgaSA9IDA7PGJyPiZndDsgKzxicj4mZ3Q7ICsgJm5ic3A7ICZuYnNwOyAm
bmJzcDsgbGlzdF9mb3JfZWFjaF9lbnRyeShtb2RlbGlzdCwgJmFtcDtmYmktJmd0O21vZGVsaXN0
LCBsaXN0KTxicj4mZ3Q7ICsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJz
cDsgJm5ic3A7IGkrKzs8YnI+Jmd0OyArPGJyPiZndDsgKyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBt
b2RlX2FycmF5ID0ga21hbGxvYyhzaXplb2YgKHN0cnVjdCBmYl9tb2RlbGlzdCkgKiBpLCBHRlBf
S0VSTkVMKTs8YnI+Jmd0OyArICZuYnNwOyAmbmJzcDsgJm5ic3A7IGlmICghbW9kZV9hcnJheSk8
YnI+Jmd0OyArICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNw
OyByZXR1cm4gLUVOT01FTTs8YnI+Jmd0OyArPGJyPiZndDsgKyAmbmJzcDsgJm5ic3A7ICZuYnNw
OyBpID0gMDs8YnI+Jmd0OyArICZuYnNwOyAmbmJzcDsgJm5ic3A7IGxpc3RfZm9yX2VhY2hfZW50
cnkobW9kZWxpc3QsICZhbXA7ZmJpLSZndDttb2RlbGlzdCwgbGlzdCk8YnI+Jmd0OyArICZuYnNw
OyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBtb2RlX2FycmF5W2kr
K10gPSBtb2RlbGlzdC0mZ3Q7bW9kZTs8YnI+Jmd0OyArPGJyPiZndDsgKyAmbmJzcDsgJm5ic3A7
ICZuYnNwOyByZXQgPSBmYl9maW5kX21vZGUoJmFtcDtmYmktJmd0O3ZhciwgZmJpLCBOVUxMLCBt
b2RlX2FycmF5LCBpLCBOVUxMLCAxNik7PGJyPiZndDsgKyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBp
ZiAocmV0ID09IDApPGJyPiZndDsgKyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7
ICZuYnNwOyAmbmJzcDsgcmV0dXJuIC1FSU5WQUw7PGJyPiZndDsgKzxicj4mZ3Q7ICsgJm5ic3A7
ICZuYnNwOyAmbmJzcDsgZGV2X2RiZyhmYmktJmd0O2RldmljZSwgJnF1b3Q7Zm91bmQgJWR4JWQt
JWQgaHM6JWQ6JWQ6JWQgdnM6JWQ6JWQ6JWRcbiZxdW90Oyw8YnI+Jmd0OyArICZuYnNwOyAmbmJz
cDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNw
OyAmbmJzcDsgdmFyLSZndDt4cmVzLCB2YXItJmd0O3lyZXMsIHZhci0mZ3Q7Yml0c19wZXJfcGl4
ZWwsPGJyPiZndDsgKyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAm
bmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7IHZhci0mZ3Q7aHN5bmNfbGVuLCB2YXIt
Jmd0O2xlZnRfbWFyZ2luLCB2YXItJmd0O3JpZ2h0X21hcmdpbiw8YnI+Jmd0OyArICZuYnNwOyAm
bmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZu
YnNwOyAmbmJzcDsgdmFyLSZndDt2c3luY19sZW4sIHZhci0mZ3Q7dXBwZXJfbWFyZ2luLCB2YXIt
Jmd0O2xvd2VyX21hcmdpbik7PGJyPiZndDsgKzxicj4mZ3Q7ICsgJm5ic3A7ICZuYnNwOyAmbmJz
cDsga2ZyZWUobW9kZV9hcnJheSk7PGJyPiZndDsgKzxicj4mZ3Q7ICsgJm5ic3A7ICZuYnNwOyAm
bmJzcDsgcmV0dXJuIDA7PGJyPiZndDsgK308YnI+Jmd0OyArPGJyPiZndDsgK3N0YXRpYyBpbnQg
X19kZXZpbml0IGlteF9pcHVfZmJfcHJvYmUoc3RydWN0IHBsYXRmb3JtX2RldmljZSAqcGRldik8
YnI+Jmd0OyArezxicj4mZ3Q7ICsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgc3RydWN0IGZiX2luZm8g
KmZiaTs8YnI+Jmd0OyArICZuYnNwOyAmbmJzcDsgJm5ic3A7IHN0cnVjdCBpbXhfaXB1X2ZiX2lu
Zm8gKm14Y19mYmk7PGJyPiZndDsgKyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBzdHJ1Y3QgaXB1djNf
ZmJfcGxhdGZvcm1fZGF0YSAqcGxhdF9kYXRhID0gcGRldi0mZ3Q7ZGV2LnBsYXRmb3JtX2RhdGE7
PGJyPiZndDsgKyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBpbnQgcmV0ID0gMCwgaTs8YnI+Jmd0OyAr
PGJyPiZndDsgKyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBwZGV2LSZndDtkZXYuY29oZXJlbnRfZG1h
X21hc2sgPSBETUFfQklUX01BU0soMzIpOzxicj4mZ3Q7ICs8YnI+Jmd0OyArICZuYnNwOyAmbmJz
cDsgJm5ic3A7IGZiaSA9IGlteF9pcHVfZmJfaW5pdF9mYmluZm8oJmFtcDtwZGV2LSZndDtkZXYs
ICZhbXA7aW14X2lwdV9mYl9vcHMpOzxicj4mZ3Q7ICsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgaWYg
KCFmYmkpPGJyPiZndDsgKyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNw
OyAmbmJzcDsgcmV0dXJuIC1FTk9NRU07PGJyPiZndDsgKzxicj4mZ3Q7ICsgJm5ic3A7ICZuYnNw
OyAmbmJzcDsgbXhjX2ZiaSA9IGZiaS0mZ3Q7cGFyOzxicj4mZ3Q7ICs8YnI+Jmd0OyArICZuYnNw
OyAmbmJzcDsgJm5ic3A7IG14Y19mYmktJmd0O2lwdV9jaGFubmVsX251bSA9IHBsYXRfZGF0YS0m
Z3Q7aXB1X2NoYW5uZWxfYmc7PGJyPiZndDsgKyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBteGNfZmJp
LSZndDtkYyA9IHBsYXRfZGF0YS0mZ3Q7ZGNfY2hhbm5lbDs8YnI+Jmd0OyArICZuYnNwOyAmbmJz
cDsgJm5ic3A7IG14Y19mYmktJmd0O2lwdV9kaV9waXhfZm10ID0gcGxhdF9kYXRhLSZndDtpbnRl
cmZhY2VfcGl4X2ZtdDs8YnI+Jmd0OyArICZuYnNwOyAmbmJzcDsgJm5ic3A7IG14Y19mYmktJmd0
O2lwdV9kaSA9IHBkZXYtJmd0O2lkOzxicj4mZ3Q7ICs8YnI+Jmd0OyArICZuYnNwOyAmbmJzcDsg
Jm5ic3A7IG14Y19mYmktJmd0O2lwdV9jaCA9IGlwdV9pZG1hY19nZXQocGxhdF9kYXRhLSZndDtp
cHVfY2hhbm5lbF9iZyk7PGJyPiZndDsgKyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBpZiAoSVNfRVJS
KG14Y19mYmktJmd0O2lwdV9jaCkpIHs8YnI+Jmd0OyArICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZu
YnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyByZXQgPSBQVFJfRVJSKG14Y19mYmktJmd0O2lwdV9j
aCk7PGJyPiZndDsgKyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAm
bmJzcDsgZ290byBmYWlsZWRfcmVxdWVzdF9pcHU7PGJyPiZndDsgKyAmbmJzcDsgJm5ic3A7ICZu
YnNwOyB9PGJyPiZndDsgKzxicj4mZ3Q7ICsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgbXhjX2ZiaS0m
Z3Q7ZG1mYyA9IGlwdV9kbWZjX2dldChwbGF0X2RhdGEtJmd0O2lwdV9jaGFubmVsX2JnKTs8YnI+
Jmd0OyArICZuYnNwOyAmbmJzcDsgJm5ic3A7IGlmIChJU19FUlIobXhjX2ZiaS0mZ3Q7aXB1X2No
KSkgezxicj4mZ3Q7ICsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsg
Jm5ic3A7IHJldCA9IFBUUl9FUlIobXhjX2ZiaS0mZ3Q7aXB1X2NoKTs8YnI+Jmd0OyArICZuYnNw
OyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBnb3RvIGZhaWxlZF9y
ZXF1ZXN0X2RtZmM7PGJyPiZndDsgKyAmbmJzcDsgJm5ic3A7ICZuYnNwOyB9PGJyPiZndDsgKzxi
cj4mZ3Q7ICsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgaWYgKHBsYXRfZGF0YS0mZ3Q7ZHBfY2hhbm5l
bCAmZ3Q7PSAwKSB7PGJyPiZndDsgKyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7
ICZuYnNwOyAmbmJzcDsgbXhjX2ZiaS0mZ3Q7ZHAgPSBpcHVfZHBfZ2V0KHBsYXRfZGF0YS0mZ3Q7
ZHBfY2hhbm5lbCk7PGJyPiZndDsgKyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7
ICZuYnNwOyAmbmJzcDsgaWYgKElTX0VSUihteGNfZmJpLSZndDtkcCkpIHs8YnI+Jmd0OyArICZu
YnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5i
c3A7ICZuYnNwOyAmbmJzcDsgcmV0ID0gUFRSX0VSUihteGNfZmJpLSZndDtpcHVfY2gpOzxicj4m
Z3Q7ICsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZu
YnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBnb3RvIGZhaWxlZF9yZXF1ZXN0X2RwOzxicj4mZ3Q7
ICsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7IH08YnI+
Jmd0OyArICZuYnNwOyAmbmJzcDsgJm5ic3A7IH08YnI+Jmd0OyArPGJyPiZndDsgKyAmbmJzcDsg
Jm5ic3A7ICZuYnNwOyBmYmktJmd0O3Zhci55cmVzX3ZpcnR1YWwgPSBmYmktJmd0O3Zhci55cmVz
Ozxicj4mZ3Q7ICs8YnI+Jmd0OyArICZuYnNwOyAmbmJzcDsgJm5ic3A7IElOSVRfTElTVF9IRUFE
KCZhbXA7ZmJpLSZndDttb2RlbGlzdCk7PGJyPiZndDsgKyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBm
b3IgKGkgPSAwOyBpICZsdDsgcGxhdF9kYXRhLSZndDtudW1fbW9kZXM7IGkrKyk8YnI+Jmd0OyAr
ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBmYl9hZGRf
dmlkZW9tb2RlKCZhbXA7cGxhdF9kYXRhLSZndDttb2Rlc1tpXSwgJmFtcDtmYmktJmd0O21vZGVs
aXN0KTs8YnI+Jmd0OyArPGJyPiZndDsgKyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBpZiAocGxhdF9k
YXRhLSZndDtmbGFncyAmYW1wOyBJTVhfSVBVX0ZCX1VTRV9NT0RFREIpIHs8YnI+Jmd0OyArICZu
YnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBmb3IgKGkgPSAw
OyBpICZsdDsgbnVtX2ZiX21vZGVzOyBpKyspPGJyPiZndDsgKyAmbmJzcDsgJm5ic3A7ICZuYnNw
OyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7
IGZiX2FkZF92aWRlb21vZGUoJmFtcDtmYl9tb2Rlc1tpXSwgJmFtcDtmYmktJmd0O21vZGVsaXN0
KTs8YnI+Jmd0OyArICZuYnNwOyAmbmJzcDsgJm5ic3A7IH08YnI+Jmd0OyArPGJyPiZndDsgKyAm
bmJzcDsgJm5ic3A7ICZuYnNwOyBpbXhfaXB1X2ZiX2ZpbmRfbW9kZShmYmkpOzxicj4mZ3Q7ICs8
YnI+Jmd0OyArICZuYnNwOyAmbmJzcDsgJm5ic3A7IGlteF9pcHVfZmJfY2hlY2tfdmFyKCZhbXA7
ZmJpLSZndDt2YXIsIGZiaSk7PGJyPiZndDsgKyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBpbXhfaXB1
X2ZiX3NldF9maXgoZmJpKTs8YnI+Jmd0OyArICZuYnNwOyAmbmJzcDsgJm5ic3A7IHJldCA9IHJl
Z2lzdGVyX2ZyYW1lYnVmZmVyKGZiaSk7PGJyPiZndDsgKyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBp
ZiAocmV0ICZsdDsgMCk8YnI+Jmd0OyArICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJz
cDsgJm5ic3A7ICZuYnNwOyBnb3RvIGZhaWxlZF9yZWdpc3Rlcjs8YnI+Jmd0OyArPGJyPiZndDsg
KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBpbXhfaXB1X2ZiX3NldF9wYXIoZmJpKTs8YnI+Jmd0OyAr
ICZuYnNwOyAmbmJzcDsgJm5ic3A7IGlteF9pcHVfZmJfYmxhbmsoRkJfQkxBTktfVU5CTEFOSywg
ZmJpKTs8YnI+Jmd0OyArPGJyPiZndDsgKyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBpZiAocGxhdF9k
YXRhLSZndDtpcHVfY2hhbm5lbF9mZyAmZ3Q7PSAwICZhbXA7JmFtcDsgcGxhdF9kYXRhLSZndDtm
bGFncyAmYW1wOyBJTVhfSVBVX0ZCX1VTRV9PVkVSTEFZKTxicj4mZ3Q7ICsgJm5ic3A7ICZuYnNw
OyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7IGlteF9pcHVfZmJfaW5pdF9vdmVy
bGF5KHBkZXYsIGZiaSwgcGxhdF9kYXRhLSZndDtpcHVfY2hhbm5lbF9mZyk7PGJyPiZndDsgKzxi
cj4mZ3Q7ICsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgcGxhdGZvcm1fc2V0X2RydmRhdGEocGRldiwg
ZmJpKTs8YnI+Jmd0OyArPGJyPiZndDsgKyAmbmJzcDsgJm5ic3A7ICZuYnNwOyByZXR1cm4gMDs8
YnI+Jmd0OyArPGJyPiZndDsgK2ZhaWxlZF9yZWdpc3Rlcjo8YnI+Jmd0OyArICZuYnNwOyAmbmJz
cDsgJm5ic3A7IGlmIChwbGF0X2RhdGEtJmd0O2RwX2NoYW5uZWwgJmd0Oz0gMCk8YnI+Jmd0OyAr
ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBpcHVfZHBf
cHV0KG14Y19mYmktJmd0O2RwKTs8YnI+Jmd0OyArZmFpbGVkX3JlcXVlc3RfZHA6PGJyPiZndDsg
KyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBpcHVfZG1mY19wdXQobXhjX2ZiaS0mZ3Q7ZG1mYyk7PGJy
PiZndDsgK2ZhaWxlZF9yZXF1ZXN0X2RtZmM6PGJyPiZndDsgKyAmbmJzcDsgJm5ic3A7ICZuYnNw
OyBpcHVfaWRtYWNfcHV0KG14Y19mYmktJmd0O2lwdV9jaCk7PGJyPiZndDsgK2ZhaWxlZF9yZXF1
ZXN0X2lwdTo8YnI+Jmd0OyArICZuYnNwOyAmbmJzcDsgJm5ic3A7IGZiX2RlYWxsb2NfY21hcCgm
YW1wO2ZiaS0mZ3Q7Y21hcCk7PGJyPiZndDsgKyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBmcmFtZWJ1
ZmZlcl9yZWxlYXNlKGZiaSk7PGJyPiZndDsgKzxicj4mZ3Q7ICsgJm5ic3A7ICZuYnNwOyAmbmJz
cDsgcmV0dXJuIHJldDs8YnI+Jmd0OyArfTxicj4mZ3Q7ICs8YnI+Jmd0OyArc3RhdGljIGludCBf
X2RldmV4aXQgaW14X2lwdV9mYl9yZW1vdmUoc3RydWN0IHBsYXRmb3JtX2RldmljZSAqcGRldik8
YnI+Jmd0OyArezxicj4mZ3Q7ICsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgc3RydWN0IGZiX2luZm8g
KmZiaSA9IHBsYXRmb3JtX2dldF9kcnZkYXRhKHBkZXYpOzxicj4mZ3Q7ICsgJm5ic3A7ICZuYnNw
OyAmbmJzcDsgc3RydWN0IGlteF9pcHVfZmJfaW5mbyAqbXhjX2ZiaSA9IGZiaS0mZ3Q7cGFyOzxi
cj4mZ3Q7ICsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgc3RydWN0IGlwdXYzX2ZiX3BsYXRmb3JtX2Rh
dGEgKnBsYXRfZGF0YSA9IHBkZXYtJmd0O2Rldi5wbGF0Zm9ybV9kYXRhOzxicj4mZ3Q7ICs8YnI+
Jmd0OyArICZuYnNwOyAmbmJzcDsgJm5ic3A7IGlmIChwbGF0X2RhdGEtJmd0O2lwdV9jaGFubmVs
X2ZnICZndDs9IDAgJmFtcDsmYW1wOyBwbGF0X2RhdGEtJmd0O2ZsYWdzICZhbXA7IElNWF9JUFVf
RkJfVVNFX09WRVJMQVkpPGJyPiZndDsgKyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5i
c3A7ICZuYnNwOyAmbmJzcDsgaW14X2lwdV9mYl9leGl0X292ZXJsYXkocGRldiwgZmJpLCBwbGF0
X2RhdGEtJmd0O2lwdV9jaGFubmVsX2ZnKTs8YnI+Jmd0OyArPGJyPiZndDsgKyAmbmJzcDsgJm5i
c3A7ICZuYnNwOyBpbXhfaXB1X2ZiX2JsYW5rKEZCX0JMQU5LX1BPV0VSRE9XTiwgZmJpKTs8YnI+
Jmd0OyArPGJyPiZndDsgKyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBkbWFfZnJlZV93cml0ZWNvbWJp
bmUoZmJpLSZndDtkZXZpY2UsIGZiaS0mZ3Q7Zml4LnNtZW1fbGVuLDxicj4mZ3Q7ICsgJm5ic3A7
ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsg
Jm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBmYmktJmd0O3NjcmVlbl9iYXNlLCBm
YmktJmd0O2ZpeC5zbWVtX3N0YXJ0KTs8YnI+Jmd0OyArPGJyPiZndDsgKyAmbmJzcDsgJm5ic3A7
ICZuYnNwOyBpZiAoJmFtcDtmYmktJmd0O2NtYXApPGJyPiZndDsgKyAmbmJzcDsgJm5ic3A7ICZu
YnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgZmJfZGVhbGxvY19jbWFwKCZhbXA7ZmJp
LSZndDtjbWFwKTs8YnI+Jmd0OyArPGJyPiZndDsgKyAmbmJzcDsgJm5ic3A7ICZuYnNwOyB1bnJl
Z2lzdGVyX2ZyYW1lYnVmZmVyKGZiaSk7PGJyPiZndDsgKzxicj4mZ3Q7ICsgJm5ic3A7ICZuYnNw
OyAmbmJzcDsgaWYgKHBsYXRfZGF0YS0mZ3Q7ZHBfY2hhbm5lbCAmZ3Q7PSAwKTxicj4mZ3Q7ICsg
Jm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7IGlwdV9kcF9w
dXQobXhjX2ZiaS0mZ3Q7ZHApOzxicj4mZ3Q7ICsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgaXB1X2Rt
ZmNfZnJlZV9iYW5kd2lkdGgobXhjX2ZiaS0mZ3Q7ZG1mYyk7PGJyPiZndDsgKyAmbmJzcDsgJm5i
c3A7ICZuYnNwOyBpcHVfZG1mY19wdXQobXhjX2ZiaS0mZ3Q7ZG1mYyk7PGJyPiZndDsgKyAmbmJz
cDsgJm5ic3A7ICZuYnNwOyBpcHVfaWRtYWNfcHV0KG14Y19mYmktJmd0O2lwdV9jaCk7PGJyPiZn
dDsgKzxicj4mZ3Q7ICsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgZnJhbWVidWZmZXJfcmVsZWFzZShm
YmkpOzxicj4mZ3Q7ICs8YnI+Jmd0OyArICZuYnNwOyAmbmJzcDsgJm5ic3A7IHJldHVybiAwOzxi
cj4mZ3Q7ICt9PGJyPiZndDsgKzxicj4mZ3Q7ICtzdGF0aWMgc3RydWN0IHBsYXRmb3JtX2RyaXZl
ciBpbXhfaXB1X2ZiX2RyaXZlciA9IHs8YnI+Jmd0OyArICZuYnNwOyAmbmJzcDsgJm5ic3A7IC5k
cml2ZXIgPSB7PGJyPiZndDsgKyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZu
YnNwOyAmbmJzcDsgLm5hbWUgPSBEUklWRVJfTkFNRSw8YnI+Jmd0OyArICZuYnNwOyAmbmJzcDsg
Jm5ic3A7IH0sPGJyPiZndDsgKyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAucHJvYmUgPSBpbXhfaXB1
X2ZiX3Byb2JlLDxicj4mZ3Q7ICsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgLnJlbW92ZSA9IF9fZGV2
ZXhpdF9wKGlteF9pcHVfZmJfcmVtb3ZlKSw8YnI+Jmd0OyArfTs8YnI+Jmd0OyArPGJyPiZndDsg
K3N0YXRpYyBpbnQgX19pbml0IGlteF9pcHVfZmJfaW5pdCh2b2lkKTxicj4mZ3Q7ICt7PGJyPiZn
dDsgKyAmbmJzcDsgJm5ic3A7ICZuYnNwOyByZXR1cm4gcGxhdGZvcm1fZHJpdmVyX3JlZ2lzdGVy
KCZhbXA7aW14X2lwdV9mYl9kcml2ZXIpOzxicj4mZ3Q7ICt9PGJyPiZndDsgKzxicj4mZ3Q7ICtz
dGF0aWMgdm9pZCBfX2V4aXQgaW14X2lwdV9mYl9leGl0KHZvaWQpPGJyPiZndDsgK3s8YnI+Jmd0
OyArICZuYnNwOyAmbmJzcDsgJm5ic3A7IHBsYXRmb3JtX2RyaXZlcl91bnJlZ2lzdGVyKCZhbXA7
aW14X2lwdV9mYl9kcml2ZXIpOzxicj4mZ3Q7ICt9PGJyPiZndDsgKzxicj4mZ3Q7ICttb2R1bGVf
aW5pdChpbXhfaXB1X2ZiX2luaXQpOzxicj4mZ3Q7ICttb2R1bGVfZXhpdChpbXhfaXB1X2ZiX2V4
aXQpOzxicj4mZ3Q7ICs8YnI+Jmd0OyArTU9EVUxFX0FVVEhPUigmcXVvdDtGcmVlc2NhbGUgU2Vt
aWNvbmR1Y3RvciwgSW5jLiZxdW90Oyk7PGJyPiZndDsgK01PRFVMRV9ERVNDUklQVElPTigmcXVv
dDtpLk1YIGZyYW1lYnVmZmVyIGRyaXZlciZxdW90Oyk7PGJyPiZndDsgK01PRFVMRV9MSUNFTlNF
KCZxdW90O0dQTCZxdW90Oyk7PGJyPiZndDsgK01PRFVMRV9TVVBQT1JURURfREVWSUNFKCZxdW90
O2ZiJnF1b3Q7KTs8YnI+Jmd0OyAtLTxicj4mZ3Q7IDEuNy4yLjM8YnI+Jmd0Ozxicj4mZ3Q7IC0t
PGJyPiZndDsgVG8gdW5zdWJzY3JpYmUgZnJvbSB0aGlzIGxpc3Q6IHNlbmQgdGhlIGxpbmUgJnF1
b3Q7dW5zdWJzY3JpYmUgbGludXgta2VybmVsJnF1b3Q7IGluPGJyPiZndDsgdGhlIGJvZHkgb2Yg
YSBtZXNzYWdlIHRvIDxhIGhyZWY9Im1haWx0bzptYWpvcmRvbW9Admdlci5rZXJuZWwub3JnIj5t
YWpvcmRvbW9Admdlci5rZXJuZWwub3JnPC9hPjxicj4mZ3Q7IE1vcmUgbWFqb3Jkb21vIGluZm8g
YXQgJm5ic3A7PGEgaHJlZj0iaHR0cDovL3ZnZXIua2VybmVsLm9yZy9tYWpvcmRvbW8taW5mby5o
dG1sIiB0YXJnZXQ9Il9ibGFuayI+aHR0cDovL3ZnZXIua2VybmVsLm9yZy9tYWpvcmRvbW8taW5m
by5odG1sPC9hPjxicj4mZ3Q7IFBsZWFzZSByZWFkIHRoZSBGQVEgYXQgJm5ic3A7PGEgaHJlZj0i
aHR0cDovL3d3dy50dXgub3JnL2xrbWwvIiB0YXJnZXQ9Il9ibGFuayI+aHR0cDovL3d3dy50dXgu
b3JnL2xrbWwvPC9hPjxicj4mZ3Q7PGJyPi0tPGJyPlRvIHVuc3Vic2NyaWJlIGZyb20gdGhpcyBs
aXN0OiBzZW5kIHRoZSBsaW5lICZxdW90O3Vuc3Vic2NyaWJlIGxpbnV4LWtlcm5lbCZxdW90OyBp
bjxicj50aGUgYm9keSBvZiBhIG1lc3NhZ2UgdG8gPGEgaHJlZj0ibWFpbHRvOm1ham9yZG9tb0B2
Z2VyLmtlcm5lbC5vcmciPm1ham9yZG9tb0B2Z2VyLmtlcm5lbC5vcmc8L2E+PGJyPk1vcmUgbWFq
b3Jkb21vIGluZm8gYXQgJm5ic3A7PGEgaHJlZj0iaHR0cDovL3ZnZXIua2VybmVsLm9yZy9tYWpv
cmRvbW8taW5mby5odG1sIiB0YXJnZXQ9Il9ibGFuayI+aHR0cDovL3ZnZXIua2VybmVsLm9yZy9t
YWpvcmRvbW8taW5mby5odG1sPC9hPjxicj5QbGVhc2UgcmVhZCB0aGUgRkFRIGF0ICZuYnNwOzxh
IGhyZWY9Imh0dHA6Ly93d3cudHV4Lm9yZy9sa21sLyIgdGFyZ2V0PSJfYmxhbmsiPmh0dHA6Ly93
d3cudHV4Lm9yZy9sa21sLzwvYT48bzpwPjwvbzpwPjwvcD48L2Rpdj48L2Rpdj48L2Rpdj48cCBj
bGFzcz1Nc29Ob3JtYWw+PG86cD4mbmJzcDs8L286cD48L3A+PC9kaXY+PC9ib2R5PjwvaHRtbD4f
AEIAAQAAACAAAABDAGgAZQBuACAASgBpAGUALQBCADAAMgAyADgAMAAAAB8AZQABAAAAKgAAAEIA
MAAyADIAOAAwAEAAZgByAGUAZQBzAGMAYQBsAGUALgBjAG8AbQAAAAAAHwBkAAEAAAAKAAAAUwBN
AFQAUAAAAAAAAgFBAAEAAABsAAAAAAAAAIErH6S+oxAZnW4A3QEPVAIAAACAQwBoAGUAbgAgAEoA
aQBlAC0AQgAwADIAMgA4ADAAAABTAE0AVABQAAAAQgAwADIAMgA4ADAAQABmAHIAZQBlAHMAYwBh
AGwAZQAuAGMAbwBtAAAAHwACXQEAAAAqAAAAQgAwADIAMgA4ADAAQABmAHIAZQBlAHMAYwBhAGwA
ZQAuAGMAbwBtAAAAAAAfAOVfAQAAAAQAAAAgAAAAHwAaDAEAAAAgAAAAQwBoAGUAbgAgAEoAaQBl
AC0AQgAwADIAMgA4ADAAAAAfAB8MAQAAACoAAABCADAAMgAyADgAMABAAGYAcgBlAGUAcwBjAGEA
bABlAC4AYwBvAG0AAAAAAB8AHgwBAAAACgAAAFMATQBUAFAAAAAAAAIBGQwBAAAAbAAAAAAAAACB
Kx+kvqMQGZ1uAN0BD1QCAAAAgEMAaABlAG4AIABKAGkAZQAtAEIAMAAyADIAOAAwAAAAUwBNAFQA
UAAAAEIAMAAyADIAOAAwAEAAZgByAGUAZQBzAGMAYQBsAGUALgBjAG8AbQAAAB8AAV0BAAAAKgAA
AEIAMAAyADIAOAAwAEAAZgByAGUAZQBzAGMAYQBsAGUALgBjAG8AbQAAAAAACwBAOgEAAAAfABoA
AQAAABIAAABJAFAATQAuAE4AbwB0AGUAAAAAAB8AGgABAAAAEgAAAEkAUABNAC4ATgBvAHQAZQAA
AAAAAwDxPwkEAAADAPE/CQQAAAsAQDoBAAAACwBAOgEAAAADAP0/qAMAAAMA/T+oAwAAAgELMAEA
AAAQAAAAwiyJ3pfSE0y55lDSwKI1gQIBCzABAAAAEAAAAMIsid6X0hNMueZQ0sCiNYEDABcAAQAA
AAMAFwABAAAAQAA5AAA4u8KLm8sBQAA5AAA4u8KLm8sBQAAIMPYyPYqLm8sBQAAIMPYyPYqLm8sB
CwACAAEAAAALAAIAAQAAAAsAIwAAAAAACwAjAAAAAAADACYAAAAAAAMAJgAAAAAACwApAAAAAAAL
ACkAAAAAAAsAKwAAAAAACwArAAAAAAADAC4AAAAAAAMALgAAAAAAAwA2AAAAAAADADYAAAAAAB8A
cAABAAAAUgAAAFsAUABBAFQAQwBIACAANQAvADkAXQAgAEEAZABkACAAaQAuAE0AWAA1ACAAZgBy
AGEAbQBlAGIAdQBmAGYAZQByACAAZAByAGkAdgBlAHIAAAAAAB8AcAABAAAAUgAAAFsAUABBAFQA
QwBIACAANQAvADkAXQAgAEEAZABkACAAaQAuAE0AWAA1ACAAZgByAGEAbQBlAGIAdQBmAGYAZQBy
ACAAZAByAGkAdgBlAHIAAAAAAAIBcQABAAAAIAAAAAEBy5thgJo9A1/g88VBv0Mb/Sp30UyTn8+F
AIAACiXwAgFxAAEAAAAgAAAAAQHLm2GAmj0DX+DzxUG/Qxv9KnfRTJOfz4UAgAAKJfADABYQAwAA
AAMAFhADAAAAHwA1EAEAAACWAAAAPAAzADMARgAzADIAMQA1ADIAQgBFADcARQBDADcANAAwAEIA
QwAyAEMAOAAzADgARAAyADgAMwA2AEEAQwA4ADcAMAA0AEEAOQBGADUAQAAwADMAOQAtAFMATgAx
AE0AUABOADEALQAwADAAMgAuADAAMwA5AGQALgBtAGcAZAAuAG0AcwBmAHQALgBuAGUAdAA+AAAA
AAAfADUQAQAAAJYAAAA8ADMAMwBGADMAMgAxADUAMgBCAEUANwBFAEMANwA0ADAAQgBDADIAQwA4
ADMAOABEADIAOAAzADYAQQBDADgANwAwADQAQQA5AEYANQBAADAAMwA5AC0AUwBOADEATQBQAE4A
MQAtADAAMAAyAC4AMAAzADkAZAAuAG0AZwBkAC4AbQBzAGYAdAAuAG4AZQB0AD4AAAAAAB8AORAB
AAAAlgAAADwAMwAzAEYAMwAyADEANQAyAEIARQA3AEUAQwA3ADQAMABCAEMAMgBDADgAMwA4AEQA
MgA4ADMANgBBAEMAOAA3ADAANABBADkANQA3AEAAMAAzADkALQBTAE4AMQBNAFAATgAxAC0AMAAw
ADIALgAwADMAOQBkAC4AbQBnAGQALgBtAHMAZgB0AC4AbgBlAHQAPgAAAAAAHwA5EAEAAACWAAAA
PAAzADMARgAzADIAMQA1ADIAQgBFADcARQBDADcANAAwAEIAQwAyAEMAOAAzADgARAAyADgAMwA2
AEEAQwA4ADcAMAA0AEEAOQA1ADcAQAAwADMAOQAtAFMATgAxAE0AUABOADEALQAwADAAMgAuADAA
MwA5AGQALgBtAGcAZAAuAG0AcwBmAHQALgBuAGUAdAA+AAAAAAAfAEIQAQAAAJYAAAA8ADMAMwBG
ADMAMgAxADUAMgBCAEUANwBFAEMANwA0ADAAQgBDADIAQwA4ADMAOABEADIAOAAzADYAQQBDADgA
NwAwADQAQQA5ADUANwBAADAAMwA5AC0AUwBOADEATQBQAE4AMQAtADAAMAAyAC4AMAAzADkAZAAu
AG0AZwBkAC4AbQBzAGYAdAAuAG4AZQB0AD4AAAAAAB8AQhABAAAAlgAAADwAMwAzAEYAMwAyADEA
NQAyAEIARQA3AEUAQwA3ADQAMABCAEMAMgBDADgAMwA4AEQAMgA4ADMANgBBAEMAOAA3ADAANABB
ADkANQA3AEAAMAAzADkALQBTAE4AMQBNAFAATgAxAC0AMAAwADIALgAwADMAOQBkAC4AbQBnAGQA
LgBtAHMAZgB0AC4AbgBlAHQAPgAAAAAAAwCAEP////8DAIAQ/////0AABzCWY3yJi5vLAUAABzCW
Y3yJi5vLAQMA3j+fTgAAAwDeP59OAAAfAPg/AQAAACAAAABDAGgAZQBuACAASgBpAGUALQBCADAA
MgAyADgAMAAAAB8A+D8BAAAAIAAAAEMAaABlAG4AIABKAGkAZQAtAEIAMAAyADIAOAAwAAAAHwD6
PwEAAAAgAAAAQwBoAGUAbgAgAEoAaQBlAC0AQgAwADIAMgA4ADAAAAAfAPo/AQAAACAAAABDAGgA
ZQBuACAASgBpAGUALQBCADAAMgAyADgAMAAAAAMAAlkAABYAAwACWQAAFgADAAlZAgAAAAMACVkC
AAAAAwAAgAggBgAAAAAAwAAAAAAAAEYAAAAAEIUAAAAAAAADAACACCAGAAAAAADAAAAAAAAARgAA
AAAQhQAAAAAAAAsAAIAIIAYAAAAAAMAAAAAAAABGAAAAAAOFAAAAAAAACwAAgAggBgAAAAAAwAAA
AAAAAEYAAAAAA4UAAAAAAAADAACACCAGAAAAAADAAAAAAAAARgAAAAABhQAAAAAAAAMAAIAIIAYA
AAAAAMAAAAAAAABGAAAAAAGFAAAAAAAACwAAgAggBgAAAAAAwAAAAAAAAEYAAAAADoUAAAAAAAAL
AACACCAGAAAAAADAAAAAAAAARgAAAAAOhQAAAAAAAAMAAIAIIAYAAAAAAMAAAAAAAABGAAAAABiF
AAAAAAAAAwAAgAggBgAAAAAAwAAAAAAAAEYAAAAAGIUAAAAAAAALAACACCAGAAAAAADAAAAAAAAA
RgAAAAAGhQAAAAAAAAsAAIAIIAYAAAAAAMAAAAAAAABGAAAAAAaFAAAAAAAACwAAgAggBgAAAAAA
wAAAAAAAAEYAAAAAgoUAAAAAAAALAACACCAGAAAAAADAAAAAAAAARgAAAACChQAAAAAAAEAAAIAI
IAYAAAAAAMAAAAAAAABGAAAAAL+FAAAgx/Nni5vLAUAAAIAIIAYAAAAAAMAAAAAAAABGAAAAAL+F
AAAgx/Nni5vLAQMAAIADIAYAAAAAAMAAAAAAAABGAAAAAAGBAAAAAAAAAwAAgAMgBgAAAAAAwAAA
AAAAAEYAAAAAAYEAAAAAAAAFAACAAyAGAAAAAADAAAAAAAAARgAAAAACgQAAAAAAAAAAAAAFAACA
AyAGAAAAAADAAAAAAAAARgAAAAACgQAAAAAAAAAAAAADAACAAyAGAAAAAADAAAAAAAAARgAAAAAT
gQAAAQAAAAMAAIADIAYAAAAAAMAAAAAAAABGAAAAABOBAAABAAAACwAAgAMgBgAAAAAAwAAAAAAA
AEYAAAAAHIEAAAAAAAALAACAAyAGAAAAAADAAAAAAAAARgAAAAAcgQAAAAAAAAsAAIADIAYAAAAA
AMAAAAAAAABGAAAAACaBAAAAAAAACwAAgAMgBgAAAAAAwAAAAAAAAEYAAAAAJoEAAAAAAAADAACA
AyAGAAAAAADAAAAAAAAARgAAAAAQgQAAAAAAAAMAAIADIAYAAAAAAMAAAAAAAABGAAAAABCBAAAA
AAAAAwAAgAMgBgAAAAAAwAAAAAAAAEYAAAAAEYEAAAAAAAADAACAAyAGAAAAAADAAAAAAAAARgAA
AAARgQAAAAAAAAMAAIADIAYAAAAAAMAAAAAAAABGAAAAACqBAAAAAAAAAwAAgAMgBgAAAAAAwAAA
AAAAAEYAAAAAKoEAAAAAAAADAACAAyAGAAAAAADAAAAAAAAARgAAAAApgQAAAAAAAAMAAIADIAYA
AAAAAMAAAAAAAABGAAAAACmBAAAAAAAACwAAgAMgBgAAAAAAwAAAAAAAAEYAAAAAJIEAAAAAAAAL
AACAAyAGAAAAAADAAAAAAAAARgAAAAAkgQAAAAAAAAsAAIADIAYAAAAAAMAAAAAAAABGAAAAACyB
AAAAAAAACwAAgAMgBgAAAAAAwAAAAAAAAEYAAAAALIEAAAAAAAAfAACAAyAGAAAAAADAAAAAAAAA
RgAAAAAngQAAAQAAAAIAAAAAAAAAHwAAgAMgBgAAAAAAwAAAAAAAAEYAAAAAJ4EAAAEAAAACAAAA
AAAAAAMAAIADIAYAAAAAAMAAAAAAAABGAAAAABKBAAABAAAAAwAAgAMgBgAAAAAAwAAAAAAAAEYA
AAAAEoEAAAEAAAAfAACAAyAGAAAAAADAAAAAAAAARgAAAAAhgQAAAQAAAAIAAAAAAAAAHwAAgAMg
BgAAAAAAwAAAAAAAAEYAAAAAIYEAAAEAAAACAAAAAAAAAAsAAIADIAYAAAAAAMAAAAAAAABGAAAA
AAOBAAAAAAAACwAAgAMgBgAAAAAAwAAAAAAAAEYAAAAAA4EAAAAAAAADAACAAyAGAAAAAADAAAAA
AAAARgAAAAAjgQAA////fwMAAIADIAYAAAAAAMAAAAAAAABGAAAAACOBAAD///9/HwAAgB+k6zOo
ei5Cvnt54amOVLMBAAAAOAAAAEMAbwBuAHYAZQByAHMAYQB0AGkAbwBuAEkAbgBkAGUAeABUAHIA
YQBjAGsAaQBuAGcARQB4AAAAAQAAAP4AAABJAEkAPQAwADEAMAAxAEMAQgA5AEIANgAxADgAMAA5
AEEAMwBEADAAMwA1AEYARQAwAEYAMwBDADUANAAxAEIARgA0ADMAMQBCAEYARAAyAEEANwA3AEQA
MQA0AEMAOQAzADkARgBDAEYAOAA1ADAAMAA4ADAAMAAwADAAQQAyADUARgAwADsAUwBCAE0ASQBE
AD0ANQA7AFMAQgBUAD0AMgA7AFYAZQByAHMAaQBvAG4APQBWAGUAcgBzAGkAbwBuACAAMQA0AC4A
MAAgACgAQgB1AGkAbABkACAANwAwADIALgAwACkALAAgAFMAdABhAGcAZQA9AEgANwAAAAAAHwAA
gB+k6zOoei5Cvnt54amOVLMBAAAAOAAAAEMAbwBuAHYAZQByAHMAYQB0AGkAbwBuAEkAbgBkAGUA
eABUAHIAYQBjAGsAaQBuAGcARQB4AAAAAQAAAP4AAABJAEkAPQAwADEAMAAxAEMAQgA5AEIANgAx
ADgAMAA5AEEAMwBEADAAMwA1AEYARQAwAEYAMwBDADUANAAxAEIARgA0ADMAMQBCAEYARAAyAEEA
NwA3AEQAMQA0AEMAOQAzADkARgBDAEYAOAA1ADAAMAA4ADAAMAAwADAAQQAyADUARgAwADsAUwBC
AE0ASQBEAD0ANQA7AFMAQgBUAD0AMgA7AFYAZQByAHMAaQBvAG4APQBWAGUAcgBzAGkAbwBuACAA
MQA0AC4AMAAgACgAQgB1AGkAbABkACAANwAwADIALgAwACkALAAgAFMAdABhAGcAZQA9AEgANwAA
AAAAAwANNP0/AAADAA00/T8AAB8APQABAAAACgAAAFIARQA6ACAAAAAAAB8APQABAAAACgAAAFIA
RQA6ACAAAAAAAB8ANwABAAAAWgAAAFIARQA6ACAAWwBQAEEAVABDAEgAIAA1AC8AOQBdACAAQQBk
AGQAIABpAC4ATQBYADUAIABmAHIAYQBtAGUAYgB1AGYAZgBlAHIAIABkAHIAaQB2AGUAcgAAAAAA
HwA3AAEAAABaAAAAUgBFADoAIABbAFAAQQBUAEMASAAgADUALwA5AF0AIABBAGQAZAAgAGkALgBN
AFgANQAgAGYAcgBhAG0AZQBiAHUAZgBmAGUAcgAgAGQAcgBpAHYAZQByAAAAAAAfAACAhgMCAAAA
AADAAAAAAAAARgEAAAAeAAAAYQBjAGMAZQBwAHQAbABhAG4AZwB1AGEAZwBlAAAAAAABAAAADAAA
AGUAbgAtAFUAUwAAAB8AAICGAwIAAAAAAMAAAAAAAABGAQAAAB4AAABhAGMAYwBlAHAAdABsAGEA
bgBnAHUAYQBnAGUAAAAAAAEAAAAMAAAAZQBuAC0AVQBTAAAAHwAAgIYDAgAAAAAAwAAAAAAAAEYB
AAAAIAAAAHgALQBtAHMALQBoAGEAcwAtAGEAdAB0AGEAYwBoAAAAAQAAAAIAAAAAAAAAHwAAgIYD
AgAAAAAAwAAAAAAAAEYBAAAAIAAAAHgALQBtAHMALQBoAGEAcwAtAGEAdAB0AGEAYwBoAAAAAQAA
AAIAAAAAAAAAqUc=

--_000_33F32152BE7EC740BC2C838D2836AC8704A9F5039SN1MPN1002039d_--
