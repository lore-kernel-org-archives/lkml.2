Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757393Ab2GMMv6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 08:51:58 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:41174 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756252Ab2GMMv4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 08:51:56 -0400
MIME-Version: 1.0
In-Reply-To: <1342095778-13403-1-git-send-email-stigge@antcom.de>
References: <1342095778-13403-1-git-send-email-stigge@antcom.de>
Date: Fri, 13 Jul 2012 09:51:55 -0300
Message-ID: <CAAAP30GNd_0tx9tbX=ZtOzN_zziaTAM1RffiUxZ8R+2HCmUAEg@mail.gmail.com>
Subject: Re: [PATCH] ARM: LPC32xx: Adjust to pl08x DMA interface changes
From: Alexandre Pereira da Silva <aletes.xgr@gmail.com>
To: Roland Stigge <stigge@antcom.de>
Cc: linux-arm-kernel@lists.infradead.org, arnd@arndb.de,
        linux@arm.linux.org.uk, linux-kernel@vger.kernel.org,
        kevin.wells@nxp.com, srinivas.bakki@nxp.com, dwmw2@infradead.org,
        artem.bityutskiy@linux.intel.com, linux-mtd@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 12, 2012 at 9:22 AM, Roland Stigge <stigge@antcom.de> wrote:
> This patch adjusts the LPC32xx platform support to the new pl08x DMA interface,
> fixing the compile error resulting from changed pl08x structures.
>
> Signed-off-by: Roland Stigge <stigge@antcom.de>

Acked-By: Alexandre Pereira da Silva <aletes.xgr@gmail.com>

> ---
>
> Applies to today's linux-next (integrated lpc32xx-next and dma branches which collide)
>
>  arch/arm/mach-lpc32xx/phy3250.c |    7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
>
> diff --git a/arch/arm/mach-lpc32xx/phy3250.c b/arch/arm/mach-lpc32xx/phy3250.c
> index 8625237..b07dcc9 100644
> --- a/arch/arm/mach-lpc32xx/phy3250.c
> +++ b/arch/arm/mach-lpc32xx/phy3250.c
> @@ -186,13 +186,12 @@ static struct pl08x_channel_data pl08x_slave_channels[] = {
>         },
>  };
>
> -/* NOTE: These will change, according to RMK */
> -static int pl08x_get_signal(struct pl08x_dma_chan *ch)
> +static int pl08x_get_signal(const struct pl08x_channel_data *cd)
>  {
> -       return ch->cd->min_signal;
> +       return cd->min_signal;
>  }
>
> -static void pl08x_put_signal(struct pl08x_dma_chan *ch)
> +static void pl08x_put_signal(const struct pl08x_channel_data *cd, int ch)
>  {
>  }
>
> --
> 1.7.10.4
>
