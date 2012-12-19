Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755422Ab2LSNut (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 08:50:49 -0500
Received: from mail-lb0-f179.google.com ([209.85.217.179]:44516 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753532Ab2LSNum (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 08:50:42 -0500
MIME-Version: 1.0
In-Reply-To: <20121215072312.EBCAA3E0C06@localhost>
References: <1355416562-25539-1-git-send-email-gautam.vivek@samsung.com>
	<1355416562-25539-2-git-send-email-gautam.vivek@samsung.com>
	<20121215072312.EBCAA3E0C06@localhost>
Date: Wed, 19 Dec 2012 19:20:40 +0530
Message-ID: <CAFp+6iHoS4XJWHNrsyVsQS4bYZs1PUNEGsRr=EqAS7kpm2XGMQ@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] ARM: Exynos5250: Enabling ehci-s5p driver
From: Vivek Gautam <gautamvivek1987@gmail.com>
To: linux-samsung-soc@vger.kernel.org
Cc: dianders@chromium.org, linux-arm-kernel@lists.infradead.org,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, kgene.kim@samsung.com,
        Grant Likely <grant.likely@secretlab.ca>,
        Vivek Gautam <gautam.vivek@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CC: Doug Anderson


On Sat, Dec 15, 2012 at 12:53 PM, Grant Likely
<grant.likely@secretlab.ca> wrote:
> On Thu, 13 Dec 2012 22:06:01 +0530, Vivek Gautam <gautam.vivek@samsung.com> wrote:
>> Adding EHCI device tree node for Exynos5250 along with
>> the device base adress and gpio line for vbus.
>>
>> Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
>> Acked-by: Jingoo Han <jg1.han@samsung.com>
>> ---
>>  .../devicetree/bindings/usb/exynos-usb.txt         |   25 ++++++++++++++++++++
>>  arch/arm/boot/dts/exynos5250-smdk5250.dts          |    4 +++
>>  arch/arm/boot/dts/exynos5250.dtsi                  |    6 ++++
>>  arch/arm/mach-exynos/include/mach/map.h            |    1 +
>>  arch/arm/mach-exynos/mach-exynos5-dt.c             |    2 +
>>  5 files changed, 38 insertions(+), 0 deletions(-)
>>  create mode 100644 Documentation/devicetree/bindings/usb/exynos-usb.txt
>>
>> diff --git a/Documentation/devicetree/bindings/usb/exynos-usb.txt b/Documentation/devicetree/bindings/usb/exynos-usb.txt
>> new file mode 100644
>> index 0000000..e8bbb47
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/usb/exynos-usb.txt
>> @@ -0,0 +1,25 @@
>> +Samsung Exynos SoC USB controller
>> +
>> +The USB devices interface with USB controllers on Exynos SOCs.
>> +The device node has following properties.
>> +
>> +EHCI
>> +Required properties:
>> + - compatible: should be "samsung,exynos4210-ehci" for USB 2.0
>> +   EHCI controller in host mode.
>> + - reg: physical base address of the controller and length of memory mapped
>> +   region.
>> + - interrupts: interrupt number to the cpu.
>> +
>> +Optional properties:
>> + - samsung,vbus-gpio:  if present, specifies the GPIO that
>> +   needs to be pulled up for the bus to be powered.
>> +
>> +Example:
>> +
>> +     usb@12110000 {
>> +             compatible = "samsung,exynos4210-ehci";
>> +             reg = <0x12110000 0x100>;
>> +             interrupts = <0 71 0>;
>> +             samsung,vbus-gpio = <&gpx2 6 1 3 3>;
>> +     };
>> diff --git a/arch/arm/boot/dts/exynos5250-smdk5250.dts b/arch/arm/boot/dts/exynos5250-smdk5250.dts
>> index 711b55f..f990086 100644
>> --- a/arch/arm/boot/dts/exynos5250-smdk5250.dts
>> +++ b/arch/arm/boot/dts/exynos5250-smdk5250.dts
>> @@ -218,4 +218,8 @@
>>       i2s_2: i2s@12D70000 {
>>               status = "disabled";
>>       };
>> +
>> +     usb@12110000 {
>> +             samsung,vbus-gpio = <&gpx2 6 1 3 3>;
>> +     };
>>  };
>> diff --git a/arch/arm/boot/dts/exynos5250.dtsi b/arch/arm/boot/dts/exynos5250.dtsi
>> index 581e57a..584bb9a 100644
>> --- a/arch/arm/boot/dts/exynos5250.dtsi
>> +++ b/arch/arm/boot/dts/exynos5250.dtsi
>> @@ -299,6 +299,12 @@
>>               rx-dma-channel = <&pdma0 11>; /* preliminary */
>>       };
>>
>> +     usb@12110000 {
>> +             compatible = "samsung,exynos4210-ehci";
>> +             reg = <0x12110000 0x100>;
>> +             interrupts = <0 71 0>;
>> +     };
>> +
>>       amba {
>>               #address-cells = <1>;
>>               #size-cells = <1>;
>> diff --git a/arch/arm/mach-exynos/include/mach/map.h b/arch/arm/mach-exynos/include/mach/map.h
>> index cbb2852..b2c662f 100644
>> --- a/arch/arm/mach-exynos/include/mach/map.h
>> +++ b/arch/arm/mach-exynos/include/mach/map.h
>> @@ -201,6 +201,7 @@
>>  #define EXYNOS4_PA_EHCI                      0x12580000
>>  #define EXYNOS4_PA_OHCI                      0x12590000
>>  #define EXYNOS4_PA_HSPHY             0x125B0000
>> +#define EXYNOS5_PA_EHCI                      0x12110000
>>  #define EXYNOS4_PA_MFC                       0x13400000
>>
>>  #define EXYNOS4_PA_UART                      0x13800000
>> diff --git a/arch/arm/mach-exynos/mach-exynos5-dt.c b/arch/arm/mach-exynos/mach-exynos5-dt.c
>> index 462e5ac..b3b9af1 100644
>> --- a/arch/arm/mach-exynos/mach-exynos5-dt.c
>> +++ b/arch/arm/mach-exynos/mach-exynos5-dt.c
>> @@ -110,6 +110,8 @@ static const struct of_dev_auxdata exynos5250_auxdata_lookup[] __initconst = {
>>                               "samsung-i2s.1", NULL),
>>       OF_DEV_AUXDATA("samsung,samsung-i2s", 0x12D70000,
>>                               "samsung-i2s.2", NULL),
>> +     OF_DEV_AUXDATA("samsung,exynos4210-ehci", EXYNOS5_PA_EHCI,
>> +                             "s5p-ehci", NULL),
>
> I'm assuming the above change is temporary. What is left to be done to
> drop the auxdata in theses two patches?
>
> Otherwise the patch looks fine.
>
> Acked-by: Grant Likely <grant.likely@secretlab.ca>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



-- 
Thanks & Regards
Vivek
