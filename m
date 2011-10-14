Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755096Ab1JNQ3z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 12:29:55 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:63449 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754785Ab1JNQ3x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 12:29:53 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Olof Johansson <olof@lixom.net>
Subject: Re: [PATCH] ARM: mutually exclude ZBOOT_ROM and AUTO_ZRELADDR
Date: Fri, 14 Oct 2011 18:29:48 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, ccross@android.com, swarren@nvidia.com,
        pdeschrijver@nvidia.com
References: <20111014071500.GP21648@n2100.arm.linux.org.uk> <1318607945-6807-1-git-send-email-olof@lixom.net>
In-Reply-To: <1318607945-6807-1-git-send-email-olof@lixom.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201110141829.48634.arnd@arndb.de>
X-Provags-ID: V02:K0:xyC/N84ZX5qmTnS+b2ExQbdmNqf3N2LWFuNAysTIzg4
 6gVVmwINjB7CezyXQHz/NnnJfesU5RXjWnd2Ni+ki1+WO2JdMM
 aqiAcN+uiI0KyQ06xOskz6xVHZK/cO6Y8EhlUE67PPf7ww01j7
 mNTxrVcBYUIPCH7C069GYk6j1boEkAdxOAq4Pk4qSwWrI1bxSB
 8199FRnRAFAtIOtjhMfrjEMfljvQP4Lekm0/IMlNs0o+Nprupg
 fhHJFMhAz7YMxKXw1ek6JmKPgjQVKG8dWtPrOEpI8vo+F+MfvS
 MvkV1VIlllNGFI2YVagXTX52ZuR4fB673AyOqGOyWO1DaJjCxY
 dTUMwX4YRGjaOVPhNBcY=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 14 October 2011, Olof Johansson wrote:
> This way platforms that want it can select AUTO_ZRELADDR without issues caused by
> someone manually also enabling ZBOOT_ROM.
> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> index 82973b2..2ad58e8 100644
> --- a/arch/arm/Kconfig
> +++ b/arch/arm/Kconfig
> @@ -1814,6 +1814,7 @@ config ZBOOT_ROM_BSS
>  config ZBOOT_ROM
>  	bool "Compressed boot loader in ROM/flash"
>  	depends on ZBOOT_ROM_TEXT != ZBOOT_ROM_BSS
> +	depends on !AUTO_ZRELADDR
>  	help
>  	  Say Y here if you intend to execute your compressed kernel image
>  	  (zImage) directly from ROM or flash.  If unsure, say N.

Unfortunately, you cannot have it both ways:

arnd@ocdc-kvm:~/linux-arm$ make O=obj-tmp CROSS_COMPILE=arm-linux-gnueabi- ARCH=arm  -sj20  menuconfig
arch/arm/Kconfig:1761:error: recursive dependency detected!
arch/arm/Kconfig:1761:  symbol ZBOOT_ROM depends on AUTO_ZRELADDR
arch/arm/Kconfig:1899:  symbol AUTO_ZRELADDR depends on ZBOOT_ROM

	Arnd
