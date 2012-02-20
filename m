Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753974Ab2BTXE7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 18:04:59 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:35419 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752902Ab2BTXE5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 18:04:57 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of ccross@google.com designates 10.42.179.73 as permitted sender) smtp.mail=ccross@google.com; dkim=pass header.i=ccross@google.com
MIME-Version: 1.0
In-Reply-To: <1328831277-21002-6-git-send-email-pdeschrijver@nvidia.com>
References: <1328831277-21002-1-git-send-email-pdeschrijver@nvidia.com>
	<1328831277-21002-6-git-send-email-pdeschrijver@nvidia.com>
Date: Mon, 20 Feb 2012 15:04:57 -0800
X-Google-Sender-Auth: QGW07qhuNwh2vkWTsWUOYBFlTSQ
Message-ID: <CAMbhsRRkkjfymL=uDt+phM2sLunbypQRUhjZ=DHSO4y9Ko4NJA@mail.gmail.com>
Subject: Re: [PATCH v3 05/10] ARM: tegra: rework Tegra secondary CPU core bringup
From: Colin Cross <ccross@android.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
Cc: Olof Johansson <olof@lixom.net>, Stephen Warren <swarren@nvidia.com>,
        Russell King <linux@arm.linux.org.uk>, Gary King <gking@nvidia.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 9, 2012 at 3:47 PM, Peter De Schrijver
<pdeschrijver@nvidia.com> wrote:
> Prepare the Tegra secondary CPU core bringup code for other Tegra variants.
> The reset handler is also generalized to allow for future introduction of
> powersaving modes which turn off the CPU cores.
>
> Based on work by:
>
> Scott Williams <scwilliams@nvidia.com>
> Chris Johnson <cwj@nvidia.com>
> Colin Cross <ccross@android.com>
>
> Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>
> ---
<snip>

> diff --git a/arch/arm/mach-tegra/headsmp.S b/arch/arm/mach-tegra/headsmp.S
> index b5349b2..7973f1c 100644
> --- a/arch/arm/mach-tegra/headsmp.S
> +++ b/arch/arm/mach-tegra/headsmp.S

<snip>

> @@ -47,15 +64,116 @@ ENTRY(v7_invalidate_l1)
>         mov     pc, lr
>  ENDPROC(v7_invalidate_l1)
>
> +
>  ENTRY(tegra_secondary_startup)
> -       msr     cpsr_fsxc, #0xd3
>         bl      v7_invalidate_l1
> -       mrc     p15, 0, r0, c0, c0, 5
> -        and    r0, r0, #15
> -        ldr     r1, =0x6000f100
> -        str     r0, [r1]
> -1:      ldr     r2, [r1]
> -        cmp     r0, r2
> -        beq     1b
> +       mov32   r0, 0xC5ACCE55
> +       mcr     p14, 0, r0, c7, c12, 6

One minor nit, you should comment that this is enabling coresight.
