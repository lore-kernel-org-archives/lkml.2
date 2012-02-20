Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754013Ab2BTXNN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 18:13:13 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:60947 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752512Ab2BTXNL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 18:13:11 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of ccross@google.com designates 10.42.142.7 as permitted sender) smtp.mail=ccross@google.com; dkim=pass header.i=ccross@google.com
MIME-Version: 1.0
In-Reply-To: <1328831277-21002-3-git-send-email-pdeschrijver@nvidia.com>
References: <1328831277-21002-1-git-send-email-pdeschrijver@nvidia.com>
	<1328831277-21002-3-git-send-email-pdeschrijver@nvidia.com>
Date: Mon, 20 Feb 2012 15:13:10 -0800
X-Google-Sender-Auth: nhMeBLNAF07YUAkDK-Nftb-M0pc
Message-ID: <CAMbhsRT-ZTh7WQ1E0NUjX8FOMGAvx5zNnB-VYD=j8sWhM-9j+A@mail.gmail.com>
Subject: Re: [PATCH v3 02/10] ARM: tegra: export Tegra chipid
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
> The powergating and reset handling code needs to differentiate between Tegra
> variants. Therefore we export the chipid here.
>
> Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>
> ---
>  arch/arm/mach-tegra/fuse.c |    2 +-
>  arch/arm/mach-tegra/fuse.h |    1 +
>  2 files changed, 2 insertions(+), 1 deletions(-)
>
> diff --git a/arch/arm/mach-tegra/fuse.c b/arch/arm/mach-tegra/fuse.c
> index 032a936..3298880 100644
> --- a/arch/arm/mach-tegra/fuse.c
> +++ b/arch/arm/mach-tegra/fuse.c
> @@ -34,7 +34,7 @@
>  int tegra_sku_id;
>  int tegra_cpu_process_id;
>  int tegra_core_process_id;
> -static int tegra_chip_id;
> +int tegra_chip_id;
>  enum tegra_revision tegra_revision;
>
>  /* The BCT to use at boot is specified by board straps that can be read
> diff --git a/arch/arm/mach-tegra/fuse.h b/arch/arm/mach-tegra/fuse.h
> index c554572..d2107b2 100644
> --- a/arch/arm/mach-tegra/fuse.h
> +++ b/arch/arm/mach-tegra/fuse.h
> @@ -41,6 +41,7 @@ enum tegra_revision {
>  extern int tegra_sku_id;
>  extern int tegra_cpu_process_id;
>  extern int tegra_core_process_id;
> +extern int tegra_chip_id;
>  extern enum tegra_revision tegra_revision;
>
>  extern int tegra_bct_strapping;

Other platforms use accessors for this (cpu_is_xxx(), although
soc_is_xxx() is probably more appropriate).
