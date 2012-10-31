Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933301Ab2JaQob (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 12:44:31 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:50735 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755969Ab2JaQo3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 12:44:29 -0400
Message-ID: <50915563.40904@wwwdotorg.org>
Date: Wed, 31 Oct 2012 10:44:19 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: linux@arm.linux.org.uk, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V4 3/4] ARM: tegra: dts: cardhu: enable SLINK4
References: <1351674176-20603-1-git-send-email-ldewangan@nvidia.com> <1351674176-20603-3-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1351674176-20603-3-git-send-email-ldewangan@nvidia.com>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/31/2012 03:02 AM, Laxman Dewangan wrote:
> Enable SLINK4 and connected device in Tegra30 based
> platform Cardhu.
> Setting maximum spi frequency to 25MHz.
> 
> Spi serial flash is connected on CS1 of SLINK4 on
> cardhu platform.

> diff --git a/Documentation/devicetree/bindings/vendor-prefixes.txt b/Documentation/devicetree/bindings/vendor-prefixes.txt

> +winbond Winbond Electronics corp.

That should really be a separate patch that goes through the devicetree
branch. But I guess it's fairly trivial, so it's not a big deal.

> diff --git a/arch/arm/boot/dts/tegra30-cardhu.dtsi b/arch/arm/boot/dts/tegra30-cardhu.dtsi

> +		spi-flash@1 {
> +			compatible = "winbond,w25q32";
> +			spi-max-frequency = <20000000>;
> +			reg = <1>;
> +		};

Since I have an Atmel flash on my board, I see:

[    1.282958] m25p80 spi32766.1: found at25df321a, expected w25q32
[    1.289103] m25p80 spi32766.1: at25df321a (4096 Kbytes)

Is there any way around that (the first log line above)?

I suppose the answer is that the DT should reflect the exact flash
device that's on the board, and perhaps the bootloader should be
adjusting the DT to reflect the correct value. That's probably complex.

Do you have any idea whether Atmel or Winbond flash is more common, so
we can at least minimize the number of times this message appears?
