Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756075Ab0JSClE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 22:41:04 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:64194 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754077Ab0JSClD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 22:41:03 -0400
Date: Tue, 19 Oct 2010 11:41:19 +0900
From: Kukjin Kim <kgene.kim@samsung.com>
Subject: RE: [PATCH 4/9] ARM: S3C64XX: add USB host support for mach-real6410
In-reply-to: <AANLkTinWveichrhruhyphNfMaV05o2FgPJncejdDgfAo@mail.gmail.com>
To: "'Darius Augulis'" <augulis.darius@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, paulius.zaleckas@gmail.com,
        linux-kernel@vger.kernel.org, ben-linux@fluff.org
Message-id: <04e801cb6f37$1eb23130$5c169390$%kim@samsung.com>
MIME-version: 1.0
X-Mailer: Microsoft Office Outlook 12.0
Content-type: text/plain; charset=us-ascii
Content-language: ko
Content-transfer-encoding: 7BIT
Thread-index: ActuytSh7lUhk5X2QFu7Mdz5RzCBWAAajKnA
References: <20100929192354.25307.40197.stgit@darius-desktop>
 <20100929193346.25307.75373.stgit@darius-desktop>
 <04a601cb6ec9$db82dee0$92889ca0$%kim@samsung.com>
 <AANLkTinWveichrhruhyphNfMaV05o2FgPJncejdDgfAo@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Darius Augulis wrote:
> 
> On Mon, Oct 18, 2010 at 4:39 PM, Kukjin Kim <kgene.kim@samsung.com> wrote:
> > Darius Augulis wrote:
> >>
> >> Add USB host device support for mach-real6410
> >>
> >> Signed-off-by: Darius Augulis <augulis.darius@gmail.com>
> >> ---
> >>  arch/arm/mach-s3c64xx/Kconfig         |    1 +
> >>  arch/arm/mach-s3c64xx/mach-real6410.c |    1 +
> >>  2 files changed, 2 insertions(+), 0 deletions(-)
> >>
> >> diff --git a/arch/arm/mach-s3c64xx/Kconfig
b/arch/arm/mach-s3c64xx/Kconfig
> >> index b706b80..c05ae12 100644
> >> --- a/arch/arm/mach-s3c64xx/Kconfig
> >> +++ b/arch/arm/mach-s3c64xx/Kconfig
> >> @@ -109,6 +109,7 @@ config MACH_REAL6410
> >>       select S3C_DEV_NAND
> >>       select SAMSUNG_DEV_ADC
> >>       select SAMSUNG_DEV_TS
> >> +     select S3C_DEV_USB_HOST
> >>       help
> >>         Machine support for the CoreWind REAL6410
> >>
> >> diff --git a/arch/arm/mach-s3c64xx/mach-real6410.c b/arch/arm/mach-
> >> s3c64xx/mach-real6410.c
> >> index bad6990..00e7d7e 100644
> >> --- a/arch/arm/mach-s3c64xx/mach-real6410.c
> >> +++ b/arch/arm/mach-s3c64xx/mach-real6410.c
> >> @@ -195,6 +195,7 @@ static struct platform_device *real6410_devices[]
> >> __initdata = {
> >>       &s3c_device_nand,
> >>       &s3c_device_adc,
> >>       &s3c_device_ts,
> >> +     &s3c_device_ohci,
> >>  };
> >>
> >>  static struct s3c2410_ts_mach_info s3c_ts_platform __initdata = {
> >
> > No need any gpio configuration for it?
> 
> No, USB is powered by hardware at startup and does not need any other
> gpio config.
> 

Hmm...firstly see below...

+-----+        +------ UTMI -------- OTG Device
| PHY |--------|
+-----+        +--- Serial I/F 1 --- Host 1.1 (1port)

+---------------+
|USB Transceiver|-- Serial I/F 2 --- Host 1.1 (1port)
+---------------+

If you want to use only 1port Host 1.1 through Serial I/F2, your code is ok.
but want to use 2-port Host 1.1, need to set configuration of PHY
initialization and clock path for Serial I/F1.
I meant that.

Thanks.

Best regards,
Kgene.
--
Kukjin Kim <kgene.kim@samsung.com>, Senior Engineer,
SW Solution Development Team, Samsung Electronics Co., Ltd.


