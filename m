Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757188Ab1I2RGL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 13:06:11 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:8373 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753982Ab1I2RGH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 13:06:07 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 29 Sep 2011 10:04:17 -0700
From: Stephen Warren <swarren@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Russell King <linux@arm.linux.org.uk>, Colin Cross <ccross@android.com>,
        Erik Gilling <konkers@android.com>, Olof Johansson <olof@lixom.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Date: Thu, 29 Sep 2011 10:04:15 -0700
Subject: RE: [PATCH v5 3/3] arm/tegra: device tree support for ventana board
Thread-Topic: [PATCH v5 3/3] arm/tegra: device tree support for ventana board
Thread-Index: Acx+LjzDR2sWE8OiSg2h1DfkaGg8UgAmjYdg
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF173A2C6717@HQMAIL01.nvidia.com>
References: <1317248978-10829-1-git-send-email-pdeschrijver@nvidia.com>
 <1317248978-10829-4-git-send-email-pdeschrijver@nvidia.com>
In-Reply-To: <1317248978-10829-4-git-send-email-pdeschrijver@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter De Schrijver wrote at Wednesday, September 28, 2011 4:30 PM:
...
> diff --git a/arch/arm/mach-tegra/board-dt.c b/arch/arm/mach-tegra/board-dt.c
...
> @@ -80,9 +80,19 @@ static struct of_device_id tegra_dt_gic_match[] __initdata = {
>  	{}
>  };
> 
> +static struct {
> +	char *machine;
> +	void (*init)(void);
> +} pinmux_configs[] = {
> +	{ "nvidia,harmony", harmony_pinmux_init() },
> +	{ "nvidia,seaboard", seaboard_pinmux_init() },
> +	{ "nvidia,ventana", ventana_pinmux_init() },
> +};

Do you want the brackets after the function names there? Locally, they
cause the following syntax errors during compilation:

arch/arm/mach-tegra/board-dt.c:85: error: initializer element is not constant
arch/arm/mach-tegra/board-dt.c:85: error: (near initialization for 'pinmux_configs[0].init')
arch/arm/mach-tegra/board-dt.c:86: error: initializer element is not constant
arch/arm/mach-tegra/board-dt.c:86: error: (near initialization for 'pinmux_configs[1].init')
arch/arm/mach-tegra/board-dt.c:87: error: initializer element is not constant
arch/arm/mach-tegra/board-dt.c:87: error: (near initialization for 'pinmux_configs[2].init')

(using gcc version 4.4.3 (gcc-4.4.3_cos_gg_51096))

-- 
nvpublic

