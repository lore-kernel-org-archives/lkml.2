Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751994Ab2ETFyl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2012 01:54:41 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:57645 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751276Ab2ETFyi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2012 01:54:38 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 1/3] of: Add prefix parameter to of_modalias_node().
To: David Daney <ddaney.cavm@gmail.com>, devicetree-discuss@lists.ozlabs.org,
        Rob Herring <rob.herring@calxeda.com>,
        spi-devel-general@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, linux-mips@linux-mips.org,
        linux-doc@vger.kernel.org, David Daney <david.daney@cavium.com>,
        Liam Girdwood <lrg@ti.com>, Timur Tabi <timur@freescale.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        alsa-devel@alsa-project.org, linuxppc-dev@lists.ozlabs.org
In-Reply-To: <1336773923-17866-2-git-send-email-ddaney.cavm@gmail.com>
References: <1336773923-17866-1-git-send-email-ddaney.cavm@gmail.com> <1336773923-17866-2-git-send-email-ddaney.cavm@gmail.com>
Date: Sat, 19 May 2012 23:54:36 -0600
Message-Id: <20120520055436.13AF03E03B8@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 May 2012 15:05:21 -0700, David Daney <ddaney.cavm@gmail.com> wrote:
> From: David Daney <david.daney@cavium.com>
> 
> When generating MODALIASes, it is convenient to add things like "spi:"
> or "i2c:" to the front of the strings.  This allows the standard
> modprobe to find the right driver when automatically populating bus
> children from the device tree structure.
> 
> Add a prefix parameter, and adjust callers.  For
> of_register_spi_devices() use the "spi:" prefix.
> 
> Signed-off-by: David Daney <david.daney@cavium.com>

Applied, thanks.  Some notes below...

> Cc: Liam Girdwood <lrg@ti.com>
> Cc: Timur Tabi <timur@freescale.com>
> Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
> Cc: Jaroslav Kysela <perex@perex.cz>
> Cc: Takashi Iwai <tiwai@suse.de>
> Cc: alsa-devel@alsa-project.org
> Cc: linuxppc-dev@lists.ozlabs.org
> ---
>  drivers/of/base.c            |   22 ++++++++++++++++------
>  drivers/of/of_i2c.c          |    2 +-
>  drivers/of/of_spi.c          |    2 +-
>  include/linux/of.h           |    3 ++-
>  sound/soc/fsl/mpc8610_hpcd.c |    2 +-
>  sound/soc/fsl/p1022_ds.c     |    2 +-
>  6 files changed, 22 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/of/base.c b/drivers/of/base.c
> index 5806449..f05a520 100644
> --- a/drivers/of/base.c
> +++ b/drivers/of/base.c
> @@ -575,26 +575,36 @@ EXPORT_SYMBOL(of_find_matching_node);
>  /**
>   * of_modalias_node - Lookup appropriate modalias for a device node
>   * @node:	pointer to a device tree node
> + * @prefix:	prefix to be added to the compatible property, may be NULL
>   * @modalias:	Pointer to buffer that modalias value will be copied into
>   * @len:	Length of modalias value
>   *
> - * Based on the value of the compatible property, this routine will attempt
> - * to choose an appropriate modalias value for a particular device tree node.
> - * It does this by stripping the manufacturer prefix (as delimited by a ',')
> - * from the first entry in the compatible list property.
> + * Based on the value of the compatible property, this routine will
> + * attempt to choose an appropriate modalias value for a particular
> + * device tree node.  It does this by stripping the manufacturer
> + * prefix (as delimited by a ',') from the first entry in the
> + * compatible list property, and appending it to the prefix.

Not sure why this text block was reformatted.  I've formatted it back
to the way it was so the diff shows specifically what has changed in
the content.

I don't want to discourage cleanups, but I need to be careful that
cleanups don't obscure important changes when looking at the diff.

g.

