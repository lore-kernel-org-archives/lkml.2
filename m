Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758027Ab0JSGPt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 02:15:49 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:36401 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754516Ab0JSGPs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 02:15:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=QajKkVavT5klcsfjMB/zBOmQTflFq4G9vu96ptt8D4H573OF1NSQ5JbidkJfFBSQaP
         1nStJpsmhNYIQ3hzR3ye3yFK4Y/Q6hvBgLGhg3Oq+FFPvIl9V8EL+xC0AdnLdS7AX6Wd
         cfYjYFK1HrEzbUZooFE0vpfdwB8iDkq3l/Q80=
MIME-Version: 1.0
In-Reply-To: <04e801cb6f37$1eb23130$5c169390$%kim@samsung.com>
References: <20100929192354.25307.40197.stgit@darius-desktop>
	<20100929193346.25307.75373.stgit@darius-desktop>
	<04a601cb6ec9$db82dee0$92889ca0$%kim@samsung.com>
	<AANLkTinWveichrhruhyphNfMaV05o2FgPJncejdDgfAo@mail.gmail.com>
	<04e801cb6f37$1eb23130$5c169390$%kim@samsung.com>
Date: Tue, 19 Oct 2010 09:15:46 +0300
Message-ID: <AANLkTinvnjpxDeLXQdw7Og-0urC3Ui2p-TEejaqBUZPn@mail.gmail.com>
Subject: Re: [PATCH 4/9] ARM: S3C64XX: add USB host support for mach-real6410
From: Darius Augulis <augulis.darius@gmail.com>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: linux-arm-kernel@lists.infradead.org, paulius.zaleckas@gmail.com,
        linux-kernel@vger.kernel.org, ben-linux@fluff.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 19, 2010 at 5:41 AM, Kukjin Kim <kgene.kim@samsung.com> wrote:
> Darius Augulis wrote:
>>
>> On Mon, Oct 18, 2010 at 4:39 PM, Kukjin Kim <kgene.kim@samsung.com> wrote:
>> > Darius Augulis wrote:
>> >>
>> >> Add USB host device support for mach-real6410
>> >>
>> >> Signed-off-by: Darius Augulis <augulis.darius@gmail.com>
>> >> ---
>> >>  arch/arm/mach-s3c64xx/Kconfig         |    1 +
>> >>  arch/arm/mach-s3c64xx/mach-real6410.c |    1 +
>> >>  2 files changed, 2 insertions(+), 0 deletions(-)
>> >>
>> >> diff --git a/arch/arm/mach-s3c64xx/Kconfig
> b/arch/arm/mach-s3c64xx/Kconfig
>> >> index b706b80..c05ae12 100644
>> >> --- a/arch/arm/mach-s3c64xx/Kconfig
>> >> +++ b/arch/arm/mach-s3c64xx/Kconfig
>> >> @@ -109,6 +109,7 @@ config MACH_REAL6410
>> >>       select S3C_DEV_NAND
>> >>       select SAMSUNG_DEV_ADC
>> >>       select SAMSUNG_DEV_TS
>> >> +     select S3C_DEV_USB_HOST
>> >>       help
>> >>         Machine support for the CoreWind REAL6410
>> >>
>> >> diff --git a/arch/arm/mach-s3c64xx/mach-real6410.c b/arch/arm/mach-
>> >> s3c64xx/mach-real6410.c
>> >> index bad6990..00e7d7e 100644
>> >> --- a/arch/arm/mach-s3c64xx/mach-real6410.c
>> >> +++ b/arch/arm/mach-s3c64xx/mach-real6410.c
>> >> @@ -195,6 +195,7 @@ static struct platform_device *real6410_devices[]
>> >> __initdata = {
>> >>       &s3c_device_nand,
>> >>       &s3c_device_adc,
>> >>       &s3c_device_ts,
>> >> +     &s3c_device_ohci,
>> >>  };
>> >>
>> >>  static struct s3c2410_ts_mach_info s3c_ts_platform __initdata = {
>> >
>> > No need any gpio configuration for it?
>>
>> No, USB is powered by hardware at startup and does not need any other
>> gpio config.
>>
>
> Hmm...firstly see below...
>
> +-----+        +------ UTMI -------- OTG Device
> | PHY |--------|
> +-----+        +--- Serial I/F 1 --- Host 1.1 (1port)
>
> +---------------+
> |USB Transceiver|-- Serial I/F 2 --- Host 1.1 (1port)
> +---------------+
>
> If you want to use only 1port Host 1.1 through Serial I/F2, your code is ok.
> but want to use 2-port Host 1.1, need to set configuration of PHY
> initialization and clock path for Serial I/F1.
> I meant that.

Clear. Both real6410 and mini6410 have only single USB host connector
and it seems it is connected to Serial I/F 2, because it works with no
additional configuration.

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
>
