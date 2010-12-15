Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754789Ab0LOPuD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 10:50:03 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:50665 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754746Ab0LOPuA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 10:50:00 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 6/9] ARM i.MX51: Add IPU device support
Date: Wed, 15 Dec 2010 16:49:45 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Sascha Hauer <s.hauer@pengutronix.de>,
        Arnaud Patard <arnaud.patard@rtp-net.org>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Zhang Lily-R58066" <r58066@freescale.com>
References: <1291902441-24712-1-git-send-email-s.hauer@pengutronix.de> <1291902441-24712-7-git-send-email-s.hauer@pengutronix.de>
In-Reply-To: <1291902441-24712-7-git-send-email-s.hauer@pengutronix.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201012151649.45199.arnd@arndb.de>
X-Provags-ID: V02:K0:tw4Lgd98QDQ/c/pRX/etPPI6NstKlp+m3hDl6V8AJlT
 tIfw5jyWlMK99DOR4q0AJAkbMz/30dBKajHFkibed8v0I5G0Le
 9zmIQLDVnu/UceHXSny6Zs+d47Vmhpn1InBrw2N6YmBU4V33Qg
 yuDUZLKgQTiW9M7LJuNzUe+lR8183ZuIvJouoIdcaWSeXO37ta
 2r/7Q2so1axGgoDYO7VNQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 09 December 2010, Sascha Hauer wrote:
> +#define imx51_add_ipuv3(pdata) \
> +       imx_add_ipuv3(&imx51_ipuv3_data, pdata)

This looks  like a pointless abstraction, it does not make
the code smaller or easier to read. I know it's sometimes
tempting to use macros, but in most cases, you should try
not to.

> +#define imx51_ipuv3_data_entry_single(soc)				\
> +	{								\
> +		.iobase = soc ## _IPU_CTRL_BASE_ADDR,			\
> +		.irq_err = soc ## _INT_IPU_ERR,				\
> +		.irq = soc ## _INT_IPU_SYN,				\
> +	}
> +
> +#ifdef CONFIG_SOC_IMX51
> +const struct imx_ipuv3_data imx51_ipuv3_data __initconst =
> +	imx51_ipuv3_data_entry_single(MX51);
> +#endif /* ifdef CONFIG_SOC_IMX35 */

This looks really strange: You define a macro that is used
in only a single place, and the only user is a data structure
that references data from other files and is used elsewhere
as well.

Avoiding the macro would make it easier to grep for the use
of the identifiers.

If you put the data structure in the place where it is used,
you can avoid the #ifdef and make it static.

Also, the comment on the #endif does not match the #if.

	Arnd
