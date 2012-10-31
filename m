Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935185Ab2JaIx0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 04:53:26 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:10522 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935102Ab2JaIxX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 04:53:23 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 31 Oct 2012 01:40:38 -0700
Message-ID: <5090E69C.4080108@nvidia.com>
Date: Wed, 31 Oct 2012 14:21:40 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V3 0/4] ARM: tegra: Enable SLINK controller driver
References: <1351580726-17350-1-git-send-email-ldewangan@nvidia.com> <509038BA.30600@wwwdotorg.org>
In-Reply-To: <509038BA.30600@wwwdotorg.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 31 October 2012 01:59 AM, Stephen Warren wrote:
> On 10/30/2012 01:05 AM, Laxman Dewangan wrote:
>> This series modify the dts file to add the slink addresses,
>> make AUXDATA in board dt files, enable slink4 for tegra30-cardhu and
>> enable slink controller defconfig.
> This series only instantiates the SPI controller, and not any SPI
> devices. I tried to solve this:
>
>> diff --git a/arch/arm/boot/dts/tegra30-cardhu.dtsi b/arch/arm/boot/dts/tegra30-cardhu.dtsi
>> index 700f0a3..3689853 100644
>> --- a/arch/arm/boot/dts/tegra30-cardhu.dtsi
>> +++ b/arch/arm/boot/dts/tegra30-cardhu.dtsi
>> @@ -278,6 +278,11 @@
>>          spi@7000da00 {
>>                  status = "okay";
>>                  spi-max-frequency =<25000000>;
>> +               flash@0 {
>> +                       reg =<0>;
>> +                       compatible = "atmel,at25df321a";
>> +                       spi-max-frequency =<25000000>;
>> +               };
>>          };
>>
>>          ahub {
> However, this didn't work. Has the driver been tested? I'm seeing the
> exact same problems I saw with the old driver, namely that the SPI flash
> chip can't be identified; I think the ID bytes are read back as 0, and
> hence drivers/mtd/devices/m25p80.c falls back to identifying the device
> as mr25h256. Attempting to hexdump -C /dev/mtd0 gives me 32K of zeros,
> whereas the device is 4M and full of non-zero data according to U-Boot.
>
> Do you know what the problem is here? Can you please update the patch
> series so that the SPI flash is instantiated and works correctly?

I will send the new patch series for taking care of the issue.

In Cardhu, there is 2 different type of flash, Winbond and Atmel.
There is hw rework require in Cardhu A02 to enable the serial flash and 
it is already taken care in Cardhu A04. I will forward the hw rework 
details to you in internal mail communication.

Also Serial flash is in CS1, not in CS0. So even if you have hw rework, 
above change will not work.

I had tested on different way earlier (dynamic allocating master for 
serial flash) and also tested on above method.
For this I enable MTD, MTD_CHAR and MTD_M25P80.
Debug prints as:
[    1.279424] m25p_probe
[    1.282536] m25p80 spi32766.1: w25q32 (4096 Kbytes)
[    1.287418] mtd .name = spi32766.1, .size = 0x400000 (4MiB) 
.erasesize = 0x00
001000 (4KiB) .numeraseregions = 0
[    1.298120] m25p_probe() returns 0




