Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933031Ab1AMQGt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 11:06:49 -0500
Received: from na3sys009aog112.obsmtp.com ([74.125.149.207]:50380 "EHLO
	na3sys009aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932517Ab1AMQGp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 11:06:45 -0500
Message-ID: <4D2F230A.4060401@ti.com>
Date: Thu, 13 Jan 2011 10:06:34 -0600
From: Nishanth Menon <nm@ti.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20101027)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>, Koen Kooi <koen@beagleboard.org>,
        Tomi Valkeinen <tomi.valkeinen@nokia.com>
CC: Paul Mundt <lethal@linux-sh.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Tony Lindgren <tony@atomide.com>,
        Bryan Wu <bryan.wu@canonical.com>
Subject: Re: linux-next: manual merge of the fbdev tree with the omap tree
References: <20110113125811.d651c695.sfr@canb.auug.org.au>
In-Reply-To: <20110113125811.d651c695.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell had written, on 01/12/2011 07:58 PM, the following:
> Hi Paul,
> 
> Today's linux-next merge of the fbdev tree got a conflict in
> arch/arm/mach-omap2/board-omap3beagle.c between commit
> f8362d215549c66066f78e67c033dd370ae50322 ("omap3: beaglexm: fix DVI reset
> GPIO") from the omap tree and commit
> 89747c9141cd750a610974d93f71492922b8cbd7 ("OMAP: use generic DPI panel
> driver in board files") from the fbdev tree.
> 
> Just context changes.  I fixed it up (see below) and can carry the fix as
> necessary.

> diff --cc arch/arm/mach-omap2/board-omap3beagle.c
> index 2ed8040,a4fe8e1..0000000
> --- a/arch/arm/mach-omap2/board-omap3beagle.c
> +++ b/arch/arm/mach-omap2/board-omap3beagle.c
> @@@ -197,11 -204,10 +204,10 @@@ static struct panel_generic_dpi_data dv
>   static struct omap_dss_device beagle_dvi_device = {
>   	.type = OMAP_DISPLAY_TYPE_DPI,
>   	.name = "dvi",
> - 	.driver_name = "generic_panel",
> + 	.driver_name = "generic_dpi_panel",
> + 	.data = &dvi_panel,
>   	.phy.dpi.data_lines = 24,
>  -	.reset_gpio = 170,
>  +	.reset_gpio = -EINVAL,
> - 	.platform_enable = beagle_enable_dvi,
> - 	.platform_disable = beagle_disable_dvi,
Thanks. Looks fine to me.

-- 
Regards,
Nishanth Menon
