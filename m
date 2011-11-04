Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752781Ab1KDVGL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 17:06:11 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:55049 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751016Ab1KDVGJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 17:06:09 -0400
Date: Fri, 4 Nov 2011 14:06:29 -0700
From: Olof Johansson <olof@lixom.net>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
Cc: Russell King <linux@arm.linux.org.uk>, Colin Cross <ccross@android.com>,
        Stephen Warren <swarren@nvidia.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: Re: [PATCH v2 5/8] arm/tegra: add new fields to struct
 tegra_pingroup_desc
Message-ID: <20111104210629.GA4685@quad.lixom.net>
References: <1320242948-21061-1-git-send-email-pdeschrijver@nvidia.com>
 <1320242948-21061-6-git-send-email-pdeschrijver@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1320242948-21061-6-git-send-email-pdeschrijver@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 02, 2011 at 04:09:04PM +0200, Peter De Schrijver wrote:
> Add new fields to struct tegra_pingroup_desc to support new hardware features
> introduced in the tegra30 SoC. The pinmux driver won't use those fields yet,
> but the tegra30 pinmux tables will already provide the necessary data.
> 
> Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>

Just a nit below.

> ---
>  arch/arm/mach-tegra/include/mach/pinmux.h   |   10 ++++++++++
>  arch/arm/mach-tegra/pinmux-tegra20-tables.c |    4 ++++
>  2 files changed, 14 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/arm/mach-tegra/include/mach/pinmux.h b/arch/arm/mach-tegra/include/mach/pinmux.h
> index fb101f5..1ea2018 100644
> --- a/arch/arm/mach-tegra/include/mach/pinmux.h
> +++ b/arch/arm/mach-tegra/include/mach/pinmux.h
> @@ -2,6 +2,7 @@
>   * linux/arch/arm/mach-tegra/include/mach/pinmux.h
>   *
>   * Copyright (C) 2010 Google, Inc.
> + * Copyright (C) 2010,2011 Nvidia, Inc.
>   *
>   * This software is licensed under the terms of the GNU General Public
>   * License version 2, as published by the Free Software Foundation, and
> @@ -99,6 +100,11 @@ enum tegra_tristate {
>  	TEGRA_TRI_TRISTATE = 1,
>  };
>  
> +enum tegra_pin_io {
> +	TEGRA_PIN_OUTPUT = 0,
> +	TEGRA_PIN_INPUT = 1,
> +};
> +
>  enum tegra_vddio {
>  	TEGRA_VDDIO_BB = 0,
>  	TEGRA_VDDIO_LCD,
> @@ -211,6 +217,10 @@ struct tegra_pingroup_desc {
>  	s8 tri_bit; 	/* offset into the TRISTATE_REG_* register bit */
>  	s8 mux_bit;	/* offset into the PIN_MUX_CTL_* register bit */
>  	s8 pupd_bit;	/* offset into the PULL_UPDOWN_REG_* register bit */
> +	s8 lock_bit;	/* offset of the LOCK bit into mux register bit */
> +	s8 od_bit;	/* offset of the OD bit into mux register bit */
> +	s8 ioreset_bit;	/* offset of the IO_RESET bit into mux register bit */
> +	s8 io_default;

Shouldn't this be an enum tegra_pin_io? Also, feel free to move it up above the
s16/s8 members.


-Olof

