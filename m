Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755893Ab0JRNqh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 09:46:37 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:35553 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755149Ab0JRNqg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 09:46:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Ke/MXlm6uHBkoZmqW+6uixB2KtkrHJp0OPTZEHopJ+Sp2y3ZyyJinScihyBAaJVSIj
         ncmjis27zwvniTSYaTACU5tTPjpxPdgx8S2MgUglr5f5j18BKe+0dZHezZZX6yKYXwCg
         DJw5N571IIVImWrdMAI4vIIDSfSNFV5ZIyvQw=
MIME-Version: 1.0
In-Reply-To: <04a501cb6ec8$7e719a80$7b54cf80$%kim@samsung.com>
References: <20100929192354.25307.40197.stgit@darius-desktop>
	<20100929193322.25307.67196.stgit@darius-desktop>
	<04a501cb6ec8$7e719a80$7b54cf80$%kim@samsung.com>
Date: Mon, 18 Oct 2010 16:39:47 +0300
Message-ID: <AANLkTin0zOj+PnTe8JKNRmyQ-gVvYZRcJwcA2Pu+P4h7@mail.gmail.com>
Subject: Re: [PATCH 3/9] ARM: S3C64XX: add touchscreen support for mach-real6410
From: Darius Augulis <augulis.darius@gmail.com>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: linux-arm-kernel@lists.infradead.org, paulius.zaleckas@gmail.com,
        linux-kernel@vger.kernel.org, ben-linux@fluff.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 18, 2010 at 4:29 PM, Kukjin Kim <kgene.kim@samsung.com> wrote:
> Darius Augulis wrote:
>>
>> Add touchscreen device support for mach-real6410
>>
>> Signed-off-by: Darius Augulis <augulis.darius@gmail.com>
>> ---
>>  arch/arm/mach-s3c64xx/Kconfig         |    2 ++
>>  arch/arm/mach-s3c64xx/mach-real6410.c |   11 +++++++++++
>>  2 files changed, 13 insertions(+), 0 deletions(-)
>>
>> diff --git a/arch/arm/mach-s3c64xx/Kconfig b/arch/arm/mach-s3c64xx/Kconfig
>> index e4aede1..b706b80 100644
>> --- a/arch/arm/mach-s3c64xx/Kconfig
>> +++ b/arch/arm/mach-s3c64xx/Kconfig
>> @@ -107,6 +107,8 @@ config MACH_REAL6410
>>       select S3C_DEV_FB
>>       select S3C64XX_SETUP_FB_24BPP
>>       select S3C_DEV_NAND
>> +     select SAMSUNG_DEV_ADC
>> +     select SAMSUNG_DEV_TS
>>       help
>>         Machine support for the CoreWind REAL6410
>>
>> diff --git a/arch/arm/mach-s3c64xx/mach-real6410.c b/arch/arm/mach-
>> s3c64xx/mach-real6410.c
>> index 9fd943d..bad6990 100644
>> --- a/arch/arm/mach-s3c64xx/mach-real6410.c
>> +++ b/arch/arm/mach-s3c64xx/mach-real6410.c
>> @@ -36,11 +36,13 @@
>>  #include <mach/regs-srom.h>
>>  #include <mach/s3c6410.h>
>>
>> +#include <plat/adc.h>
>>  #include <plat/cpu.h>
>>  #include <plat/devs.h>
>>  #include <plat/fb.h>
>>  #include <plat/nand.h>
>>  #include <plat/regs-serial.h>
>> +#include <plat/ts.h>
>>
>>  #include <video/platform_lcd.h>
>>
>> @@ -191,6 +193,14 @@ static struct platform_device *real6410_devices[]
>> __initdata = {
>>       &s3c_device_hsmmc1,
>>       &s3c_device_fb,
>>       &s3c_device_nand,
>> +     &s3c_device_adc,
>> +     &s3c_device_ts,
>> +};
>> +
>> +static struct s3c2410_ts_mach_info s3c_ts_platform __initdata = {
>> +     .delay                  = 10000,
>> +     .presc                  = 49,
>> +     .oversampling_shift     = 2,
>>  };
>>
>>  static void __init real6410_map_io(void)
>> @@ -289,6 +299,7 @@ static void __init real6410_machine_init(void)
>>
>>       s3c_fb_set_platdata(&real6410_lcd_pdata);
>>       s3c_nand_set_platdata(&real6410_nand_info);
>> +     s3c24xx_ts_set_platdata(&s3c_ts_platform);
>>
>>       /* configure nCS1 width to 16 bits */
>>
>
> No need to add 's3c_adc_setname("s3c64xx-adc")' in mach-s3c64xx?

IMO no, because it's called from s3c6410_map_io() which is generic for
all s3c64xx boards.
This patch selects  SAMSUNG_DEV_ADC and this is enough.
btw, all patches are tested and all devices work ok.

>
> Thanks.
>
> Best regards,
> Kgene.
> --
> Kukjin Kim <kgene.kim@samsung.com>, Senior Engineer,
> SW Solution Development Team, Samsung Electronics Co., Ltd.
>
>
