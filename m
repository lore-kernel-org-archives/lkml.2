Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756651Ab0CaHHF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 03:07:05 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:58790 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755801Ab0CaHHB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 03:07:01 -0400
Date: Wed, 31 Mar 2010 09:06:48 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Marcelo Roberto Jimenez <mroberto@cpti.cetuc.puc-rio.br>
Cc: Russell King <linux@arm.linux.org.uk>, Ralf Baechle <ralf@linux-mips.org>,
       Eric Miao <eric.y.miao@gmail.com>,
       Dominik Brodowski <linux@dominikbrodowski.net>,
       Manuel Lauss <manuel.lauss@gmail.com>,
       Dmitry Artamonow <mad_soft@inbox.ru>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-pcmcia@lists.infradead.org, linux-kernel@vger.kernel.org,
       linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ARM: pcmcia: Adds nanoEngine PCMCIA support.
Message-ID: <20100331070648.GA23391@pengutronix.de>
References: <1269972879-27400-1-git-send-email-mroberto@cpti.cetuc.puc-rio.br>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UlVJffcvxoiEqYs2"
Content-Disposition: inline
In-Reply-To: <1269972879-27400-1-git-send-email-mroberto@cpti.cetuc.puc-rio.br>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--UlVJffcvxoiEqYs2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Marcelo,

On Tue, Mar 30, 2010 at 03:14:39PM -0300, Marcelo Roberto Jimenez wrote:
> This patch adds nanoEngine PCMCIA support, with support for two sockets.
>=20
> In order to have a fully functional pcmcia subsystem in a BSE nanoEngine =
board
> you should carefully read this:
>=20
> http://cambuca.ldhs.cetuc.puc-rio.br/nanoengine/
>=20
> Signed-off-by: Marcelo Roberto Jimenez <mroberto@cpti.cetuc.puc-rio.br>
> ---
>  arch/arm/mach-sa1100/include/mach/nanoengine.h |   30 ++++
>  arch/arm/mach-sa1100/nanoengine.c              |    2 +-
>  drivers/pcmcia/Makefile                        |    1 +
>  drivers/pcmcia/sa1100_generic.c                |    3 +
>  drivers/pcmcia/sa1100_generic.h                |    1 +
>  drivers/pcmcia/sa1100_nanoengine.c             |  218 ++++++++++++++++++=
++++++
>  6 files changed, 254 insertions(+), 1 deletions(-)
>  create mode 100644 arch/arm/mach-sa1100/include/mach/nanoengine.h
>  create mode 100644 drivers/pcmcia/sa1100_nanoengine.c
>=20
> diff --git a/arch/arm/mach-sa1100/include/mach/nanoengine.h b/arch/arm/ma=
ch-sa1100/include/mach/nanoengine.h
> new file mode 100644
> index 0000000..0537766
> --- /dev/null
> +++ b/arch/arm/mach-sa1100/include/mach/nanoengine.h
> @@ -0,0 +1,30 @@
> +/*
> + * arch/arm/mach-sa1100/include/mach/nanoengine.h
> + *
> + * This file contains the hardware specific definitions for nanoEngine.
> + * Only include this file from SA1100-specific files.
> + *
> + * Copyright (C) 2010 Marcelo Roberto Jimenez <mroberto@cpti.cetuc.puc-r=
io.br>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + */
> +#ifndef __ASM_ARCH_NANOENGINE_H
> +#define __ASM_ARCH_NANOENGINE_H
> +
> +#define GPIO_PC_READY0	GPIO_GPIO(11) /* ready for socket 0 (active high)=
*/
> +#define GPIO_PC_READY1	GPIO_GPIO(12) /* ready for socket 1 (active high)=
 */
> +#define GPIO_PC_CD0	GPIO_GPIO(13) /* detect for socket 0 (active low) */
> +#define GPIO_PC_CD1	GPIO_GPIO(14) /* detect for socket 1 (active low) */
> +#define GPIO_PC_RESET0	GPIO_GPIO(15) /* reset socket 0 */
> +#define GPIO_PC_RESET1	GPIO_GPIO(16) /* reset socket 1 */
> +
> +#define NANOENGINE_IRQ_GPIO_PC_READY0	IRQ_GPIO11
> +#define NANOENGINE_IRQ_GPIO_PC_READY1	IRQ_GPIO12
> +#define NANOENGINE_IRQ_GPIO_PC_CD0	IRQ_GPIO13
> +#define NANOENGINE_IRQ_GPIO_PC_CD1	IRQ_GPIO14
> +
> +#endif
> +
> diff --git a/arch/arm/mach-sa1100/nanoengine.c b/arch/arm/mach-sa1100/nan=
oengine.c
> index 73a7922..36cdc8a 100644
> --- a/arch/arm/mach-sa1100/nanoengine.c
> +++ b/arch/arm/mach-sa1100/nanoengine.c
> @@ -3,7 +3,7 @@
>   *
>   * Bright Star Engineering's nanoEngine board init code.
>   *
> - * Copyright (C) 2009 Marcelo Roberto Jimenez <mroberto@cpti.cetuc.puc-r=
io.br>
> + * Copyright (C) 2010 Marcelo Roberto Jimenez <mroberto@cpti.cetuc.puc-r=
io.br>
>   *
>   * This program is free software; you can redistribute it and/or modify
>   * it under the terms of the GNU General Public License version 2 as
> diff --git a/drivers/pcmcia/Makefile b/drivers/pcmcia/Makefile
> index 381b031..bb9fa64 100644
> --- a/drivers/pcmcia/Makefile
> +++ b/drivers/pcmcia/Makefile
> @@ -50,6 +50,7 @@ sa1100_cs-$(CONFIG_SA1100_ASSABET)		+=3D sa1100_assabet=
=2Eo
>  sa1100_cs-$(CONFIG_SA1100_CERF)			+=3D sa1100_cerf.o
>  sa1100_cs-$(CONFIG_SA1100_COLLIE)              +=3D pxa2xx_sharpsl.o
>  sa1100_cs-$(CONFIG_SA1100_H3600)		+=3D sa1100_h3600.o
> +sa1100_cs-$(CONFIG_SA1100_NANOENGINE)		+=3D sa1100_nanoengine.o
>  sa1100_cs-$(CONFIG_SA1100_SHANNON)		+=3D sa1100_shannon.o
>  sa1100_cs-$(CONFIG_SA1100_SIMPAD)		+=3D sa1100_simpad.o
> =20
> diff --git a/drivers/pcmcia/sa1100_generic.c b/drivers/pcmcia/sa1100_gene=
ric.c
> index 5188962..a1fce5d 100644
> --- a/drivers/pcmcia/sa1100_generic.c
> +++ b/drivers/pcmcia/sa1100_generic.c
> @@ -54,6 +54,9 @@ static int (*sa11x0_pcmcia_hw_init[])(struct device *de=
v) =3D {
>  #if defined(CONFIG_SA1100_H3100) || defined(CONFIG_SA1100_H3600)
>  	pcmcia_h3600_init,
>  #endif
> +#ifdef CONFIG_SA1100_NANOENGINE
> +	pcmcia_nanoengine_init,
> +#endif
>  #ifdef CONFIG_SA1100_SHANNON
>  	pcmcia_shannon_init,
>  #endif
> diff --git a/drivers/pcmcia/sa1100_generic.h b/drivers/pcmcia/sa1100_gene=
ric.h
> index 794f96a..adb08db 100644
> --- a/drivers/pcmcia/sa1100_generic.h
> +++ b/drivers/pcmcia/sa1100_generic.h
> @@ -13,6 +13,7 @@ extern int pcmcia_freebird_init(struct device *);
>  extern int pcmcia_gcplus_init(struct device *);
>  extern int pcmcia_graphicsmaster_init(struct device *);
>  extern int pcmcia_h3600_init(struct device *);
> +extern int pcmcia_nanoengine_init(struct device *);
>  extern int pcmcia_pangolin_init(struct device *);
>  extern int pcmcia_pfs168_init(struct device *);
>  extern int pcmcia_shannon_init(struct device *);
> diff --git a/drivers/pcmcia/sa1100_nanoengine.c b/drivers/pcmcia/sa1100_n=
anoengine.c
> new file mode 100644
> index 0000000..2f164e6
> --- /dev/null
> +++ b/drivers/pcmcia/sa1100_nanoengine.c
> @@ -0,0 +1,218 @@
> +/*
> + * drivers/pcmcia/sa1100_nanoengine.c
> + *
> + * PCMCIA implementation routines for BSI nanoEngine.
> + *
> + * In order to have a fully functional pcmcia subsystem in a BSE nanoEng=
ine
> + * board you should carefully read this:
> + * http://cambuca.ldhs.cetuc.puc-rio.br/nanoengine/
> + *
> + * Copyright (C) 2010 Marcelo Roberto Jimenez <mroberto@cpti.cetuc.puc-r=
io.br>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + */
> +#include <linux/device.h>
> +#include <linux/errno.h>
> +#include <linux/interrupt.h>
> +#include <linux/irq.h>
> +#include <linux/init.h>
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/signal.h>
> +
> +#include <asm/mach-types.h>
> +#include <asm/irq.h>
> +
> +#include <mach/hardware.h>
> +#include <mach/nanoengine.h>
> +
> +#include "sa1100_generic.h"
> +
> +static struct pcmcia_irqs irqs_skt0[] =3D {
> +	/* socket, IRQ, name */
> +	{ 0, NANOENGINE_IRQ_GPIO_PC_CD0, "PC CD0" },
> +};
> +
> +static struct pcmcia_irqs irqs_skt1[] =3D {
> +	/* socket, IRQ, name */
> +	{ 1, NANOENGINE_IRQ_GPIO_PC_CD1, "PC CD1" },
> +};
> +
> +struct nanoengine_pins {
> +	unsigned input_pins;
> +	unsigned output_pins;
> +	unsigned clear_outputs;
> +	unsigned transition_pins;
> +	unsigned pci_irq;
> +	struct pcmcia_irqs *pcmcia_irqs;
> +	unsigned pcmcia_irqs_size;
> +};
> +
> +static struct nanoengine_pins nano_skts[] =3D {
> +	{
> +		.input_pins		=3D GPIO_PC_READY0 | GPIO_PC_CD0,
> +		.output_pins		=3D GPIO_PC_RESET0,
> +		.clear_outputs		=3D GPIO_PC_RESET0,
> +		.transition_pins	=3D NANOENGINE_IRQ_GPIO_PC_CD0,
> +		.pci_irq		=3D NANOENGINE_IRQ_GPIO_PC_READY0,
> +		.pcmcia_irqs		=3D irqs_skt0,
> +		.pcmcia_irqs_size	=3D ARRAY_SIZE(irqs_skt0)
> +	}, {
> +		.input_pins		=3D GPIO_PC_READY1 | GPIO_PC_CD1,
> +		.output_pins		=3D GPIO_PC_RESET1,
> +		.clear_outputs		=3D GPIO_PC_RESET1,
> +		.transition_pins	=3D NANOENGINE_IRQ_GPIO_PC_CD1,
> +		.pci_irq		=3D NANOENGINE_IRQ_GPIO_PC_READY1,
> +		.pcmcia_irqs		=3D irqs_skt1,
> +		.pcmcia_irqs_size	=3D ARRAY_SIZE(irqs_skt1)
> +	}
> +};
> +
> +unsigned num_nano_pcmcia_sockets =3D ARRAY_SIZE(nano_skts);
> +
> +static int nanoengine_pcmcia_hw_init(struct soc_pcmcia_socket *skt)
> +{
> +	unsigned i =3D skt->nr;
> +
> +	if (i >=3D num_nano_pcmcia_sockets)
> +		return -ENXIO;
> +
> +	GPDR &=3D ~nano_skts[i].input_pins;
> +	GPDR |=3D  nano_skts[i].output_pins;
> +	GPCR =3D   nano_skts[i].clear_outputs;
> +	set_irq_type(nano_skts[i].transition_pins, IRQ_TYPE_EDGE_BOTH);
> +	skt->socket.pci_irq =3D nano_skts[i].pci_irq;
> +
> +	return soc_pcmcia_request_irqs(skt,
> +		nano_skts[i].pcmcia_irqs, nano_skts[i].pcmcia_irqs_size);
> +}
> +
> +/*
> + * Release all resources.
> + */
> +static void nanoengine_pcmcia_hw_shutdown(struct soc_pcmcia_socket *skt)
> +{
> +	unsigned i =3D skt->nr;
> +
> +	if (i >=3D num_nano_pcmcia_sockets)
> +		return;
> +
> +	soc_pcmcia_free_irqs(skt,
> +		nano_skts[i].pcmcia_irqs, nano_skts[i].pcmcia_irqs_size);
> +}
> +
> +static int nanoengine_pcmcia_configure_socket(
> +	struct soc_pcmcia_socket *skt, const socket_state_t *state)
> +{
> +	unsigned reset;
> +	unsigned i =3D skt->nr;
> +
> +	if (i >=3D num_nano_pcmcia_sockets)
> +		return -ENXIO;
> +
> +	switch (i) {
> +	case 0:
> +		reset =3D GPIO_PC_RESET0;
> +		break;
> +	case 1:
> +		reset =3D GPIO_PC_RESET1;
> +		break;
> +	default:
> +		return -ENXIO;
> +	}
> +
> +	if (state->flags & SS_RESET)
> +		GPSR =3D reset;
> +	else
> +		GPCR =3D reset;
> +
> +	return 0;
> +}
> +
> +static void nanoengine_pcmcia_socket_state(
> +	struct soc_pcmcia_socket *skt, struct pcmcia_state *state)
> +{
> +	unsigned long levels =3D GPLR;
> +	unsigned i =3D skt->nr;
> +
> +	if (i >=3D num_nano_pcmcia_sockets)
> +		return;
> +
> +	memset(state, 0, sizeof(struct pcmcia_state));
> +	switch (i) {
> +	case 0:
> +		state->ready	=3D  (levels & GPIO_PC_READY0)	? 1 : 0;
> +		state->detect	=3D !(levels & GPIO_PC_CD0)	? 1 : 0;

If lines are added at a later stage, all this indentation might have to be
redone. This breaks 'git blame'. Please just one space around operators as
suggested in CodingStyle, chapter 3.1.

> +		break;
> +	case 1:
> +		state->ready	=3D  (levels & GPIO_PC_READY1)	? 1 : 0;
> +		state->detect	=3D !(levels & GPIO_PC_CD1)	? 1 : 0;
> +		break;
> +	default:
> +		return;
> +	}
> +	state->bvd1	=3D 1;
> +	state->bvd2	=3D 1;
> +	state->wrprot	=3D 0; /* Not available */
> +	state->vs_3v	=3D 1; /* Can only apply 3.3V */
> +	state->vs_Xv	=3D 0;
> +}
> +
> +/*
> + * Enable card status IRQs on (re-)initialisation.  This can
> + * be called at initialisation, power management event, or
> + * pcmcia event.
> + */
> +static void nanoengine_pcmcia_socket_init(struct soc_pcmcia_socket *skt)
> +{
> +	unsigned i =3D skt->nr;
> +
> +	if (i >=3D num_nano_pcmcia_sockets)
> +		return;
> +
> +	soc_pcmcia_enable_irqs(skt,
> +		nano_skts[i].pcmcia_irqs, nano_skts[i].pcmcia_irqs_size);
> +}
> +
> +/*
> + * Disable card status IRQs on suspend.
> + */
> +static void nanoengine_pcmcia_socket_suspend(struct soc_pcmcia_socket *s=
kt)
> +{
> +	unsigned i =3D skt->nr;
> +
> +	if (i >=3D num_nano_pcmcia_sockets)
> +		return;
> +
> +	soc_pcmcia_disable_irqs(skt,
> +		nano_skts[i].pcmcia_irqs, nano_skts[i].pcmcia_irqs_size);
> +}
> +
> +static struct pcmcia_low_level nanoengine_pcmcia_ops =3D {
> +	.owner			=3D THIS_MODULE,
> +
> +	.hw_init		=3D nanoengine_pcmcia_hw_init,
> +	.hw_shutdown		=3D nanoengine_pcmcia_hw_shutdown,
> +
> +	.configure_socket	=3D nanoengine_pcmcia_configure_socket,
> +	.socket_state		=3D nanoengine_pcmcia_socket_state,
> +	.socket_init		=3D nanoengine_pcmcia_socket_init,
> +	.socket_suspend		=3D nanoengine_pcmcia_socket_suspend,
> +};
> +
> +int pcmcia_nanoengine_init(struct device *dev)
> +{
> +	int ret =3D -ENODEV;
> +
> +	printk(KERN_INFO "BSE nanoEngine pcmcia support by "
> +		"Miguel Freitas & Marcelo Jimenez.\n");

Is this really necessary? Log would get quite messy if all drivers do this.
I haven't checked, can't you just use MODULE_AUTHOR here?

> +	if (machine_is_nanoengine())
> +		ret =3D sa11xx_drv_pcmcia_probe(
> +			dev, &nanoengine_pcmcia_ops, 0, 2);
> +
> +	return ret;
> +}
> +
> --=20
> 1.7.0.3
>=20
>=20
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--UlVJffcvxoiEqYs2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkuy9IgACgkQD27XaX1/VRuBaQCdGv2/ihtQjGUt78CEjHKSWjGP
tXUAn0ax1P893VetSavLvjHP1Nb5pZix
=cd+5
-----END PGP SIGNATURE-----

--UlVJffcvxoiEqYs2--
