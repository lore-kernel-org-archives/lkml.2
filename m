Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751505Ab1ITO1S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 10:27:18 -0400
Received: from mail-vw0-f52.google.com ([209.85.212.52]:35175 "EHLO
	mail-vw0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750777Ab1ITO1Q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 10:27:16 -0400
MIME-Version: 1.0
In-Reply-To: <1316508629.14514.2.camel@phoenix>
References: <1316508629.14514.2.camel@phoenix>
Date: Tue, 20 Sep 2011 16:27:15 +0200
Message-ID: <CAFULf_xq8E1hvB6sXKfwxo6PS39mN0Xe15nevmNReCtfcJ90tg@mail.gmail.com>
Subject: Re: [PATCH] usb: musb: OMAP4430: Remove a redundant omap4430_phy_init
 call in usb_musb_init
From: Bjarne Steinsbo <bsteinsbo@gmail.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Felipe Balbi <balbi@ti.com>,
        Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ref thread starting at http://marc.info/?l=linux-omap&m=131316289211258&w=2

Bjarne Steinsbo

On Tue, Sep 20, 2011 at 10:50 AM, Axel Lin <axel.lin@gmail.com> wrote:
> Current code calls omap4430_phy_init() twice in usb_musb_init().
> Calling omap4430_phy_init() once is enough.
> This patch removes the first omap4430_phy_init() call, which using an
> uninitialized pointer as parameter.
>
> This patch elimates below build warning:
> arch/arm/mach-omap2/usb-musb.c: In function 'usb_musb_init':
> arch/arm/mach-omap2/usb-musb.c:141: warning: 'dev' may be used uninitialized in this function
>
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  arch/arm/mach-omap2/usb-musb.c |    3 ---
>  1 files changed, 0 insertions(+), 3 deletions(-)
>
> diff --git a/arch/arm/mach-omap2/usb-musb.c b/arch/arm/mach-omap2/usb-musb.c
> index a65145b..19e4dac 100644
> --- a/arch/arm/mach-omap2/usb-musb.c
> +++ b/arch/arm/mach-omap2/usb-musb.c
> @@ -137,9 +137,6 @@ void __init usb_musb_init(struct omap_musb_board_data *musb_board_data)
>        musb_plat.mode = board_data->mode;
>        musb_plat.extvbus = board_data->extvbus;
>
> -       if (cpu_is_omap44xx())
> -               omap4430_phy_init(dev);
> -
>        if (cpu_is_omap3517() || cpu_is_omap3505()) {
>                oh_name = "am35x_otg_hs";
>                name = "musb-am35x";
> --
> 1.7.4.1
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-omap" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
