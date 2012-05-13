Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751493Ab2EMJWa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2012 05:22:30 -0400
Received: from gw1.transmode.se ([195.58.98.146]:58034 "EHLO gw1.transmode.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750821Ab2EMJW3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2012 05:22:29 -0400
In-Reply-To: <1336775390-24128-1-git-send-email-herton.krzesinski@canonical.com>
References: <1336775390-24128-1-git-send-email-herton.krzesinski@canonical.com>
Subject: Re: [PATCH] spi/spi-fsl-spi: reference correct pdata in fsl_spi_cs_control
X-KeepSent: DB3A7477:7395BFE4-C12579FD:003346CE;
 type=4; name=$KeepSent
To: "Herton R. Krzesinski" <herton.krzesinski@canonical.com>
Cc: Ben Hutchings <ben@decadent.org.uk>,
        Grant Likely <grant.likely@secretlab.ca>,
        Kenth Eriksson <kenth.eriksson@transmode.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-kernel@vger.kernel.org, spi-devel-general@lists.sourceforge.net
X-Mailer: Lotus Notes Release 8.5.3 September 15, 2011
Message-ID: <OFDB3A7477.7395BFE4-ONC12579FD.003346CE-C12579FD.00337DEA@transmode.se>
From: Joakim Tjernlund <joakim.tjernlund@transmode.se>
Date: Sun, 13 May 2012 11:22:25 +0200
X-MIMETrack: Serialize by Router on mail1/Transmode(Release 8.5.3FP1|March 07, 2012) at
 13/05/2012 11:22:25
MIME-Version: 1.0
Content-type: text/plain; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Herton R. Krzesinski" <herton.krzesinski@canonical.com> wrote on 2012/05/12 00:29:50:
>
> From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
>
> Commit 178db7d3, "spi: Fix device unregistration when unregistering
> the bus master", changed spi device initialization of dev.parent pointer
> to be the master's device pointer instead of his parent.
>
> This introduced a bug in spi-fsl-spi, since its usage of spi device
> pointer was not updated accordingly. This was later fixed by commit
> 5039a86, "spi/mpc83xx: fix NULL pdata dereference bug", but it missed
> another spot on fsl_spi_cs_control function where we also need to update
> usage of spi device pointer. This change address that.
>
> Cc: stable@vger.kernel.org
> Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
> ---
>  drivers/spi/spi-fsl-spi.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/spi/spi-fsl-spi.c b/drivers/spi/spi-fsl-spi.c
> index 5f748c0..6a62934 100644
> --- a/drivers/spi/spi-fsl-spi.c
> +++ b/drivers/spi/spi-fsl-spi.c
> @@ -933,7 +933,7 @@ err:
>
>  static void fsl_spi_cs_control(struct spi_device *spi, bool on)
>  {
> -   struct device *dev = spi->dev.parent;
> +   struct device *dev = spi->dev.parent->parent;
>     struct mpc8xxx_spi_probe_info *pinfo = to_of_pinfo(dev->platform_data);
>     u16 cs = spi->chip_select;
>     int gpio = pinfo->gpios[cs];

So it seems
Acked-by: Joakim Tjernlund <Joakim.Tjernlund@transmode.se>

