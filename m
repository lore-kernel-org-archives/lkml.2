Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753281Ab0HZD5P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 23:57:15 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:51808 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752967Ab0HZD5M convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 23:57:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=tGQEwj6FJ1BQhPjeKDq4IGiqJUa4ZtDz1g6XyeezJzT1HBQeNQLCdHjseI2/brg1Te
         Y3jHJYdRZ2IIYQZ0FbQpmge7RIPH4x0wnB8TNytpxZUusiGFVfcHCQMEw/v1aOqWHmc0
         94suhzdZm5qi01KZdyQwFFqMCSZAm/xHxtuvo=
MIME-Version: 1.0
In-Reply-To: <AANLkTin9Yq3v1HO0PH9t2XjqLtxn8_+0keG=1JLQ0=OA@mail.gmail.com>
References: <1282788292-5484-1-git-send-email-mark.brown314@gmail.com>
	<201008260426.39963.marek.vasut@gmail.com>
	<AANLkTin9Yq3v1HO0PH9t2XjqLtxn8_+0keG=1JLQ0=OA@mail.gmail.com>
Date: Thu, 26 Aug 2010 11:57:11 +0800
Message-ID: <AANLkTi=BXKPyxVDSsdyMtn_qaANa+bUzFkOGg8FFs1Ks@mail.gmail.com>
Subject: Re: [PATCH v2 1/1] pxa168: added initial support for TPO TD043MTEA1
 LCD display on Aspenite
From: Haojian Zhuang <haojian.zhuang@gmail.com>
To: "Mark F. Brown" <mark.brown314@gmail.com>
Cc: Marek Vasut <marek.vasut@gmail.com>, linux-arm-kernel@lists.infradead.org,
        eric.y.miao@gmail.com, linux-kernel@vger.kernel.org,
        Haojian Zhuang <hzhuang1@marvell.com>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/8/26 Mark F. Brown <mark.brown314@gmail.com>:
> On Wed, Aug 25, 2010 at 10:26 PM, Marek Vasut <marek.vasut@gmail.com> wrote:
>> Dne Èt 26. srpna 2010 04:04:52 Mark F. Brown napsal(a):
>>> Signed-off-by: Mark F. Brown <mark.brown314@gmail.com>
>>> ---
>>>  arch/arm/mach-mmp/aspenite.c            |   60
>>> +++++++++++++++++++++++++++++++ arch/arm/mach-mmp/include/mach/pxa168.h |
>>>   8 ++++
>>>  arch/arm/mach-mmp/pxa168.c              |    4 ++
>>>  drivers/video/pxa168fb.c                |    4 +-
>>>  4 files changed, 74 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/arch/arm/mach-mmp/aspenite.c b/arch/arm/mach-mmp/aspenite.c
>>> index 0629394..9e1bd6b 100644
>>> --- a/arch/arm/mach-mmp/aspenite.c
>>> +++ b/arch/arm/mach-mmp/aspenite.c
>>> @@ -23,6 +23,7 @@
>>>  #include <mach/mfp-pxa168.h>
>>>  #include <mach/pxa168.h>
>>>  #include <mach/gpio.h>
>>> +#include <video/pxa168fb.h>
>>>
>>>  #include "common.h"
>>>
>>> @@ -66,6 +67,36 @@ static unsigned long common_pin_config[] __initdata = {
>>>       GPIO115_I2S_BCLK,
>>>       GPIO116_I2S_RXD,
>>>       GPIO117_I2S_TXD,
>>> +
>>> +     /* LCD */
>>> +     GPIO56_LCD_FCLK_RD,
>>> +     GPIO57_LCD_LCLK_A0,
>>> +     GPIO58_LCD_PCLK_WR,
>>> +     GPIO59_LCD_DENA_BIAS,
>>> +     GPIO60_LCD_DD0,
>>> +     GPIO61_LCD_DD1,
>>> +     GPIO62_LCD_DD2,
>>> +     GPIO63_LCD_DD3,
>>> +     GPIO64_LCD_DD4,
>>> +     GPIO65_LCD_DD5,
>>> +     GPIO66_LCD_DD6,
>>> +     GPIO67_LCD_DD7,
>>> +     GPIO68_LCD_DD8,
>>> +     GPIO69_LCD_DD9,
>>> +     GPIO70_LCD_DD10,
>>> +     GPIO71_LCD_DD11,
>>> +     GPIO72_LCD_DD12,
>>> +     GPIO73_LCD_DD13,
>>> +     GPIO74_LCD_DD14,
>>> +     GPIO75_LCD_DD15,
>>> +     GPIO76_LCD_DD16,
>>> +     GPIO77_LCD_DD17,
>>> +     GPIO78_LCD_DD18,
>>> +     GPIO79_LCD_DD19,
>>> +     GPIO80_LCD_DD20,
>>> +     GPIO81_LCD_DD21,
>>> +     GPIO82_LCD_DD22,
>>> +     GPIO83_LCD_DD23,
>>>  };
>>>
>>>  static struct smc91x_platdata smc91x_info = {
>>> @@ -134,6 +165,34 @@ static struct i2c_board_info aspenite_i2c_info[]
>>> __initdata = { { I2C_BOARD_INFO("wm8753", 0x1b), },
>>>  };
>>>
>>> +static struct fb_videomode video_modes[] = {
>>> +     [0] = {
>>> +             .pixclock       = 30120,
>>> +             .refresh        = 60,
>>> +             .xres           = 800,
>>> +             .yres           = 480,
>>> +             .hsync_len      = 1,
>>> +             .left_margin    = 215,
>>> +             .right_margin   = 40,
>>> +             .vsync_len      = 1,
>>> +             .upper_margin   = 34,
>>> +             .lower_margin   = 10,
>>> +             .sync           = FB_SYNC_VERT_HIGH_ACT | FB_SYNC_HOR_HIGH_ACT,
>>> +     },
>>> +};
>>> +
>>> +struct pxa168fb_mach_info aspenite_lcd_info = {
>>> +     .id                     = "Graphic Frame",
>>> +     .modes                  = video_modes,
>>> +     .num_modes              = ARRAY_SIZE(video_modes),
>>> +     .pix_fmt                = PIX_FMT_RGB565,
>>> +     .io_pin_allocation_mode = PIN_MODE_DUMB_24,
>>> +     .dumb_mode              = DUMB_MODE_RGB888,
>>> +     .active                 = 1,
>>> +     .panel_rbswap           = 0,
>>> +     .invert_pixclock        = 0,
>>> +};
>>> +
>>>  static void __init common_init(void)
>>>  {
>>>       mfp_config(ARRAY_AND_SIZE(common_pin_config));
>>> @@ -143,6 +202,7 @@ static void __init common_init(void)
>>>       pxa168_add_twsi(1, NULL, ARRAY_AND_SIZE(aspenite_i2c_info));
>>>       pxa168_add_ssp(1);
>>>       pxa168_add_nand(&aspenite_nand_info);
>>> +     pxa168_add_fb(&aspenite_lcd_info);
>>>
>>>       /* off-chip devices */
>>>       platform_device_register(&smc91x_device);
>>
>>
>>
>> ----------------------------------------------
>> ^--- one patch above
>> SNIP, please split into two patches
>> v--- another patch below
>> ----------------------------------------------
>>
>>
>>
>>
>>> diff --git a/arch/arm/mach-mmp/include/mach/pxa168.h
>>> b/arch/arm/mach-mmp/include/mach/pxa168.h index 27e1bc7..220738f 100644
>>> --- a/arch/arm/mach-mmp/include/mach/pxa168.h
>>> +++ b/arch/arm/mach-mmp/include/mach/pxa168.h
>>> @@ -10,6 +10,7 @@ extern void __init pxa168_init_irq(void);
>>>  #include <mach/devices.h>
>>>  #include <plat/i2c.h>
>>>  #include <plat/pxa3xx_nand.h>
>>> +#include <video/pxa168fb.h>
>>>
>>>  extern struct pxa_device_desc pxa168_device_uart1;
>>>  extern struct pxa_device_desc pxa168_device_uart2;
>>> @@ -25,6 +26,7 @@ extern struct pxa_device_desc pxa168_device_ssp3;
>>>  extern struct pxa_device_desc pxa168_device_ssp4;
>>>  extern struct pxa_device_desc pxa168_device_ssp5;
>>>  extern struct pxa_device_desc pxa168_device_nand;
>>> +extern struct pxa_device_desc pxa168_device_fb;
>>>
>>>  static inline int pxa168_add_uart(int id)
>>>  {
>>> @@ -97,4 +99,10 @@ static inline int pxa168_add_nand(struct
>>> pxa3xx_nand_platform_data *info) {
>>>       return pxa_register_device(&pxa168_device_nand, info, sizeof(*info));
>>>  }
>>> +
>>> +static inline int pxa168_add_fb(struct pxa168fb_mach_info *mi)
>>> +{
>>> +     return pxa_register_device(&pxa168_device_fb, mi, sizeof(*mi));
>>> +}
>>> +
>>>  #endif /* __ASM_MACH_PXA168_H */
>>> diff --git a/arch/arm/mach-mmp/pxa168.c b/arch/arm/mach-mmp/pxa168.c
>>> index 652ae66..886eadb 100644
>>> --- a/arch/arm/mach-mmp/pxa168.c
>>> +++ b/arch/arm/mach-mmp/pxa168.c
>>> @@ -25,6 +25,7 @@
>>>  #include <mach/dma.h>
>>>  #include <mach/devices.h>
>>>  #include <mach/mfp.h>
>>> +#include <video/pxa168fb.h>
>>>
>>>  #include "common.h"
>>>  #include "clock.h"
>>> @@ -79,6 +80,7 @@ static APBC_CLK(ssp4, PXA168_SSP4, 4, 0);
>>>  static APBC_CLK(ssp5, PXA168_SSP5, 4, 0);
>>>
>>>  static APMU_CLK(nand, NAND, 0x01db, 208000000);
>>> +static APMU_CLK(lcd, LCD, 0x7f, 312000000);
>>>
>>>  /* device and clock bindings */
>>>  static struct clk_lookup pxa168_clkregs[] = {
>>> @@ -96,6 +98,7 @@ static struct clk_lookup pxa168_clkregs[] = {
>>>       INIT_CLKREG(&clk_ssp4, "pxa168-ssp.3", NULL),
>>>       INIT_CLKREG(&clk_ssp5, "pxa168-ssp.4", NULL),
>>>       INIT_CLKREG(&clk_nand, "pxa3xx-nand", NULL),
>>> +     INIT_CLKREG(&clk_lcd, "pxa168-fb", NULL),
>>>  };
>>>
>>>  static int __init pxa168_init(void)
>>> @@ -147,3 +150,4 @@ PXA168_DEVICE(ssp2, "pxa168-ssp", 1, SSP2, 0xd401c000,
>>> 0x40, 54, 55); PXA168_DEVICE(ssp3, "pxa168-ssp", 2, SSP3, 0xd401f000,
>>> 0x40, 56, 57); PXA168_DEVICE(ssp4, "pxa168-ssp", 3, SSP4, 0xd4020000,
>>> 0x40, 58, 59); PXA168_DEVICE(ssp5, "pxa168-ssp", 4, SSP5, 0xd4021000,
>>> 0x40, 60, 61); +PXA168_DEVICE(fb, "pxa168-fb", -1, LCD, 0xd420b000,
>>> 0x1c8);
>>> diff --git a/drivers/video/pxa168fb.c b/drivers/video/pxa168fb.c
>>> index c91a7f7..d3e597e 100644
>>> --- a/drivers/video/pxa168fb.c
>>> +++ b/drivers/video/pxa168fb.c
>>> @@ -559,7 +559,7 @@ static struct fb_ops pxa168fb_ops = {
>>>       .fb_imageblit   = cfb_imageblit,
>>>  };
>>>
>>> -static int __init pxa168fb_init_mode(struct fb_info *info,
>>> +static int pxa168fb_init_mode(struct fb_info *info,
>>>                             struct pxa168fb_mach_info *mi)
>>
>> Why do you remove __init from it ?
>>>  {
>>>       struct pxa168fb_info *fbi = info->par;
>>> @@ -599,7 +599,7 @@ static int __init pxa168fb_init_mode(struct fb_info
>>> *info, return ret;
>>>  }
>>>
>>> -static int __init pxa168fb_probe(struct platform_device *pdev)
>>> +static int pxa168fb_probe(struct platform_device *pdev)
>>
>> Why do you remove __init from it ? (DTTO)
>>>  {
>>>       struct pxa168fb_mach_info *mi;
>>>       struct fb_info *info = 0;
>>
>> Cheers
>>
>
> Hi Marek,
>
> 1) I removed the __init because it was causing a section mismatch
> warning wth this kernel. Since pxa168fb_probe() is calling
> pxa168fb_init_mode(), I cannot declare pxa168fb_init_mode() as an
> __init function. If pxa168fb_probe gets called after the __init
> section is wiped then it will attempt to run the deleted
> pxa168fb_init_mode() code.
>
> WARNING: vmlinux.o(.data+0x17984): Section mismatch in reference from
> the variable pxa168fb_driver to the function
> .init.text:pxa168fb_probe()
> The variable pxa168fb_driver references
> the function __init pxa168fb_probe()
> If the reference is valid then annotate the
> variable with __init* or __refdata (see linux/init.h) or name the variable:
> *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console,
>
>
> 2) What is the logic behind the delineation between patch files? I
> cannot build patch #1 without patch #2 based on how you defined the
> split. I need all of it in order to function.
>
Patch #2 should be the first one since it's related to framebuffer
driver. The next one should be platform file.
