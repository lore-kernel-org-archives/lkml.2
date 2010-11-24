Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754587Ab0KXNII (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 08:08:08 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:45218 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754012Ab0KXNIG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 08:08:06 -0500
Message-ID: <4CED0E2A.40401@pengutronix.de>
Date: Wed, 24 Nov 2010 14:07:54 +0100
From: Marc Kleine-Budde <mkl@pengutronix.de>
Organization: Pengutronix
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Thunderbird/3.0.10
MIME-Version: 1.0
To: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
CC: Wolfgang Grandegger <wg@grandegger.com>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Christian Pellegrin <chripell@fsfe.org>,
        Barry Song <21cnbao@gmail.com>, Samuel Ortiz <sameo@linux.intel.com>,
        socketcan-core@lists.berlios.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        andrew.chih.howe.khor@intel.com, qi.wang@intel.com,
        margie.foster@intel.com, yong.y.wang@intel.com, kok.howg.ewe@intel.com,
        joel.clark@intel.com
Subject: Re: [PATCH net-next-2.6 3/17 v3] can: EG20T PCH: Enumerate some macros
References: <4CED00A9.50006@dsn.okisemi.com>
In-Reply-To: <4CED00A9.50006@dsn.okisemi.com>
X-Enigmail-Version: 1.0.1
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig6D3E95D6674F307EB919684C"
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig6D3E95D6674F307EB919684C
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 11/24/2010 01:10 PM, Tomoya MORINAGA wrote:
> For easy to readable, LEC and interface register number macros are
> replaced to enums.

Your patch description is a bit misleading. You're not only replacing
defines by enums, you also add rx and tx error counters. Please change
the patch description or split into two patches. (see comments inline)

Wolfgang, can you say something to the generation of the error frames.

cheers, Marc

> Signed-off-by: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
> ---
>  drivers/net/can/pch_can.c |   90
> +++++++++++++++++++++++++--------------------
>  1 files changed, 50 insertions(+), 40 deletions(-)
>=20
> diff --git a/drivers/net/can/pch_can.c b/drivers/net/can/pch_can.c
> index b028ae4..5c21f5c 100644
> --- a/drivers/net/can/pch_can.c
> +++ b/drivers/net/can/pch_can.c
> @@ -69,21 +69,12 @@
>  #define PCH_REC			0x00007f00
>  #define PCH_TEC			0x000000ff
>=20
> +
>  #define PCH_TX_OK		BIT(3)
>  #define PCH_RX_OK		BIT(4)
>  #define PCH_EPASSIV		BIT(5)
>  #define PCH_EWARN		BIT(6)
>  #define PCH_BUS_OFF		BIT(7)
> -#define PCH_LEC0		BIT(0)
> -#define PCH_LEC1		BIT(1)
> -#define PCH_LEC2		BIT(2)
> -#define PCH_LEC_ALL		(PCH_LEC0 | PCH_LEC1 | PCH_LEC2)
> -#define PCH_STUF_ERR		PCH_LEC0
> -#define PCH_FORM_ERR		PCH_LEC1
> -#define PCH_ACK_ERR		(PCH_LEC0 | PCH_LEC1)
> -#define PCH_BIT1_ERR		PCH_LEC2
> -#define PCH_BIT0_ERR		(PCH_LEC0 | PCH_LEC2)
> -#define PCH_CRC_ERR		(PCH_LEC1 | PCH_LEC2)
>=20
>  /* bit position of certain controller bits. */
>  #define PCH_BIT_BRP		0
> @@ -96,9 +87,6 @@
>  #define PCH_MSK_CTRL_IE_SIE_EIE	0x07
>  #define PCH_COUNTER_LIMIT	10
>=20
> -#define PCH_RX_IFREG			0
> -#define PCH_TX_IFREG			1
> -
>  #define PCH_CAN_CLK		50000000	/* 50MHz */
>=20
>  /* Define the number of message object.
> @@ -113,6 +101,21 @@
>=20
>  #define PCH_FIFO_THRESH		16
>=20
> +enum pch_ifreg {
> +	PCH_RX_IFREG,
> +	PCH_TX_IFREG,
> +};

please fold the "enum pch_ifreg" related changes into patch 1.

> +
> +enum pch_can_err {
> +	PCH_STUF_ERR =3D 1,
> +	PCH_FORM_ERR,
> +	PCH_ACK_ERR,
> +	PCH_BIT1_ERR,
> +	PCH_BIT0_ERR,
> +	PCH_CRC_ERR,
> +	PCH_LEC_ALL,
> +};
> +
>  enum pch_can_mode {
>  	PCH_CAN_ENABLE,
>  	PCH_CAN_DISABLE,
> @@ -302,7 +305,7 @@ static void pch_can_check_if_busy(u32 __iomem
> *creq_addr, u32 num)
>  }
>=20
>  static void pch_can_set_rxtx(struct pch_can_priv *priv, u32 buff_num,
> -				  int set, u32 dir)
> +			     int set, enum pch_ifreg dir)

this should go into patch 1.

>  {
>  	unsigned long flags;
>  	u32 ie;
> @@ -616,7 +619,7 @@ static void pch_can_error(struct net_device *ndev,
> u32 status)
>  	struct sk_buff *skb;
>  	struct pch_can_priv *priv =3D netdev_priv(ndev);
>  	struct can_frame *cf;
> -	u32 errc;
> +	u32 errc, lec;
>  	struct net_device_stats *stats =3D &(priv->ndev->stats);
>  	enum can_state state =3D priv->can.state;
>=20
> @@ -661,35 +664,42 @@ static void pch_can_error(struct net_device *ndev=
,
> u32 status)
>  			"%s -> CAN controller is ERROR PASSIVE .\n", __func__);
>  	}
>=20
> -	if (status & PCH_LEC_ALL) {
> +	lec =3D status & PCH_LEC_ALL;
> +	switch (lec) {
> +	case PCH_STUF_ERR:
> +		cf->data[2] |=3D CAN_ERR_PROT_STUFF;
>  		priv->can.can_stats.bus_error++;
>  		stats->rx_errors++;
> -		switch (status & PCH_LEC_ALL) {
> -		case PCH_STUF_ERR:
> -			cf->data[2] |=3D CAN_ERR_PROT_STUFF;
> -			break;
> -		case PCH_FORM_ERR:
> -			cf->data[2] |=3D CAN_ERR_PROT_FORM;
> -			break;
> -		case PCH_ACK_ERR:
> -			cf->data[2] |=3D CAN_ERR_PROT_LOC_ACK |
> -				       CAN_ERR_PROT_LOC_ACK_DEL;
> -			break;
> -		case PCH_BIT1_ERR:
> -		case PCH_BIT0_ERR:
> -			cf->data[2] |=3D CAN_ERR_PROT_BIT;
> -			break;
> -		case PCH_CRC_ERR:
> -			cf->data[2] |=3D CAN_ERR_PROT_LOC_CRC_SEQ |
> -				       CAN_ERR_PROT_LOC_CRC_DEL;
> -			break;
> -		default:
> -			iowrite32(status | PCH_LEC_ALL, &priv->regs->stat);
> -			break;
> -		}
> -
> +		break;
> +	case PCH_FORM_ERR:
> +		cf->data[2] |=3D CAN_ERR_PROT_FORM;
> +		priv->can.can_stats.bus_error++;
> +		stats->rx_errors++;
> +		break;
> +	case PCH_ACK_ERR:
> +		cf->can_id |=3D CAN_ERR_ACK;
> +		priv->can.can_stats.bus_error++;
> +		stats->rx_errors++;
> +		break;
> +	case PCH_BIT1_ERR:
> +	case PCH_BIT0_ERR:
> +		cf->data[2] |=3D CAN_ERR_PROT_BIT;
> +		priv->can.can_stats.bus_error++;
> +		stats->rx_errors++;
> +		break;
> +	case PCH_CRC_ERR:
> +		cf->data[2] |=3D CAN_ERR_PROT_LOC_CRC_SEQ |
> +			       CAN_ERR_PROT_LOC_CRC_DEL;
> +		priv->can.can_stats.bus_error++;
> +		stats->rx_errors++;
> +		break;
> +	case PCH_LEC_ALL: /* Written by CPU. No error status */
> +		break;
>  	}
>=20
> +	cf->data[6] =3D errc & PCH_TEC;
> +	cf->data[7] =3D (errc & PCH_REC) >> 8;
> +

You patch description doesn't say anything about this

>  	priv->can.state =3D state;
>  	netif_rx(skb);
>=20

--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


--------------enig6D3E95D6674F307EB919684C
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAkztDi0ACgkQjTAFq1RaXHOM+gCghLaMDh9fmDV5qMlbd1uC3GLK
LnwAniD4G7/t/48hEoClXS6TebSHqS4D
=7pk/
-----END PGP SIGNATURE-----

--------------enig6D3E95D6674F307EB919684C--
