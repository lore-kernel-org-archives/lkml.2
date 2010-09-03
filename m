Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756972Ab0ICOMI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 10:12:08 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:40632 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756714Ab0ICOMF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 10:12:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:organization:to:subject:date:user-agent:cc:references
         :in-reply-to:mime-version:content-type:content-transfer-encoding
         :message-id;
        b=xMZDAiH474Q6DowwWlW/MWc/ImWFqG70sHLST4GINJIyeFo8JQAMhkEAuBJJjeKkZO
         gqvmFn2UvuUmM8Ij71jAxpSfQFvrN3XVtGeqm5sisRM2liuHB0lwcea1FKDNRTQJ7Obv
         CCXK9DJxARlW3wcqU9AYciILeiV7/dponSDFg=
From: Marek Vasut <marek.vasut@gmail.com>
Organization: Hack&Dev
To: "Mark F. Brown" <mark.brown314@gmail.com>
Subject: Re: [PATCH 5/5] ARM: pxa168: aspenite: add board support for keypad
Date: Fri, 3 Sep 2010 16:11:16 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.34-1-amd64; KDE/4.4.4; x86_64; ; )
Cc: Haojian Zhuang <haojian.zhuang@gmail.com>,
        Eric Miao <eric.y.miao@gmail.com>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        "linux-arm-kernel" <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel" <linux-kernel@vger.kernel.org>,
        "linux-input" <linux-input@vger.kernel.org>
References: <1282814339-10934-1-git-send-email-mark.brown314@gmail.com> <AANLkTi=OkRUmBgx_ezWtGHywGJkFAJsdGLR07v8dgzD7@mail.gmail.com> <AANLkTi=2ZJTy=RD_L0g-HnLF=r27bZLm5hTHemyNQFEi@mail.gmail.com>
In-Reply-To: <AANLkTi=2ZJTy=RD_L0g-HnLF=r27bZLm5hTHemyNQFEi@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201009031611.16464.marek.vasut@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dne Pá 3. září 2010 06:50:28 Mark F. Brown napsal(a):
> On Tue, Aug 31, 2010 at 1:00 AM, Haojian Zhuang
> 
> <haojian.zhuang@gmail.com> wrote:
> > On Thu, Aug 26, 2010 at 5:18 PM, Mark F. Brown <mark.brown314@gmail.com> 
wrote:
> >> Signed-off-by: Mark F. Brown <mark.brown314@gmail.com>
> >> ---
> >>  arch/arm/mach-mmp/aspenite.c |   27 +++++++++++++++++++++++++++
> >>  1 files changed, 27 insertions(+), 0 deletions(-)
> >> 
> >> diff --git a/arch/arm/mach-mmp/aspenite.c b/arch/arm/mach-mmp/aspenite.c
> >> index 9e1bd6b..1b788c5 100644
> >> --- a/arch/arm/mach-mmp/aspenite.c
> >> +++ b/arch/arm/mach-mmp/aspenite.c
> >> @@ -24,6 +24,8 @@
> >>  #include <mach/pxa168.h>
> >>  #include <mach/gpio.h>
> >>  #include <video/pxa168fb.h>
> >> +#include <linux/input.h>
> >> +#include <plat/pxa27x_keypad.h>
> >> 
> >>  #include "common.h"
> >> 
> >> @@ -97,6 +99,13 @@ static unsigned long common_pin_config[] __initdata =
> >> { GPIO81_LCD_DD21,
> >>        GPIO82_LCD_DD22,
> >>        GPIO83_LCD_DD23,
> >> +
> >> +       /* Keypad */
> >> +       GPIO109_KP_MKIN1,
> >> +       GPIO110_KP_MKIN0,
> >> +       GPIO111_KP_MKOUT7,
> >> +       GPIO112_KP_MKOUT6,
> >> +       GPIO121_KP_MKIN4,
> >>  };
> >> 
> >>  static struct smc91x_platdata smc91x_info = {
> >> @@ -193,6 +202,23 @@ struct pxa168fb_mach_info aspenite_lcd_info = {
> >>        .invert_pixclock        = 0,
> >>  };
> >> 
> >> +static unsigned int aspenite_matrix_key_map[] = {
> >> +       KEY(0, 6, KEY_UP),      /* SW 4 */
> >> +       KEY(0, 7, KEY_DOWN),    /* SW 5 */
> >> +       KEY(1, 6, KEY_LEFT),    /* SW 6 */
> >> +       KEY(1, 7, KEY_RIGHT),   /* SW 7 */
> >> +       KEY(4, 6, KEY_ENTER),   /* SW 8 */
> >> +       KEY(4, 7, KEY_ESC),     /* SW 9 */
> >> +};
> >> +
> >> +static struct pxa27x_keypad_platform_data aspenite_keypad_info
> >> __initdata = { +       .matrix_key_rows        = 8,
> >> +       .matrix_key_cols        = 8,
> > 
> > It seems that maxium columns is 5, not 8.
> > 
> >> +       .matrix_key_map         = aspenite_matrix_key_map,
> >> +       .matrix_key_map_size    = ARRAY_SIZE(aspenite_matrix_key_map),
> >> +       .debounce_interval      = 30,
> >> +};
> >> +
> >>  static void __init common_init(void)
> >>  {
> >>        mfp_config(ARRAY_AND_SIZE(common_pin_config));
> >> @@ -203,6 +229,7 @@ static void __init common_init(void)
> >>        pxa168_add_ssp(1);
> >>        pxa168_add_nand(&aspenite_nand_info);
> >>        pxa168_add_fb(&aspenite_lcd_info);
> >> +       pxa168_add_keypad(&aspenite_keypad_info);
> >> 
> >>        /* off-chip devices */
> >>        platform_device_register(&smc91x_device);
> >> --
> >> 1.7.0.4
> >> 
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-kernel"
> >> in the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >> Please read the FAQ at  http://www.tux.org/lkml/
> 
> The maximum keypad columns are 8 and the maximum keypad rows are 5 for
> Aspenite. I will correct that in my patch resubmission!

Eric, did you merge this already ? If so, we'll need a separate patch here?

> 
> Regards,
> -- Mark
> --
> To unsubscribe from this list: send the line "unsubscribe linux-input" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
