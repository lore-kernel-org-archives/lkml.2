Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756918Ab0DUX5z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 19:57:55 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:35412 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752607Ab0DUX5x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 19:57:53 -0400
Date: Thu, 22 Apr 2010 01:57:38 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Farid Hammane <farid.hammane@gmail.com>
Cc: khali@linux-fr.org, ben-linux@fluff.org, Enrik.Berkhan@ge.com,
       linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i2c-algo-pca: fix all coding style issues in
	i2c-algo-pca.c
Message-ID: <20100421235738.GB24384@pengutronix.de>
References: <1271877097-10939-1-git-send-email-farid.hammane@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xgyAXRrhYN0wYx8y"
Content-Disposition: inline
In-Reply-To: <1271877097-10939-1-git-send-email-farid.hammane@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--xgyAXRrhYN0wYx8y
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Farid,

thanks for this approach. Have you checked that the binary is the same
before/after your patch? If so, please mention in your patch description.

Also, always keep in mind that checkpatch helps to make code readable. Some=
 of
your changes should keep readability in mind not just fixing the warnings.

On Wed, Apr 21, 2010 at 09:11:37PM +0200, Farid Hammane wrote:
> This patch fixes all coding style issues found by checkpatch.pl.

>=20
> Signed-off-by: Farid Hammane <farid.hammane@gmail.com>
> ---
>  drivers/i2c/algos/i2c-algo-pca.c |   74 ++++++++++++++++++++++----------=
-----
>  1 files changed, 44 insertions(+), 30 deletions(-)
>=20
> diff --git a/drivers/i2c/algos/i2c-algo-pca.c b/drivers/i2c/algos/i2c-alg=
o-pca.c
> index dcdaf8e..4cb9ece 100644
> --- a/drivers/i2c/algos/i2c-algo-pca.c
> +++ b/drivers/i2c/algos/i2c-algo-pca.c
> @@ -37,15 +37,15 @@
> =20
>  static int i2c_debug;
> =20
> -#define pca_outw(adap, reg, val) adap->write_byte(adap->data, reg, val)
> -#define pca_inw(adap, reg) adap->read_byte(adap->data, reg)
> +#define pca_outw(adap, reg, val) (adap->write_byte(adap->data, reg, val))
> +#define pca_inw(adap, reg) (adap->read_byte(adap->data, reg))
> =20
>  #define pca_status(adap) pca_inw(adap, I2C_PCA_STA)
> -#define pca_clock(adap) adap->i2c_clock
> +#define pca_clock(adap) (adap->i2c_clock)
>  #define pca_set_con(adap, val) pca_outw(adap, I2C_PCA_CON, val)
>  #define pca_get_con(adap) pca_inw(adap, I2C_PCA_CON)
> -#define pca_wait(adap) adap->wait_for_completion(adap->data)
> -#define pca_reset(adap) adap->reset_chip(adap->data)
> +#define pca_wait(adap) (adap->wait_for_completion(adap->data))
> +#define pca_reset(adap) (adap->reset_chip(adap->data))

OK

> =20
>  static void pca9665_reset(void *pd)
>  {
> @@ -114,8 +114,8 @@ static int pca_address(struct i2c_algo_pca_data *adap,
>  	int sta =3D pca_get_con(adap);
>  	int addr;
> =20
> -	addr =3D ( (0x7f & msg->addr) << 1 );
> -	if (msg->flags & I2C_M_RD )
> +	addr =3D ((0x7f & msg->addr) << 1);
> +	if (msg->flags & I2C_M_RD)
>=20

OK

> 		addr |=3D 1;
>  	DEB2("=3D=3D=3D SLAVE ADDRESS %#04x+%c=3D%#04x\n",
>  	     msg->addr, msg->flags & I2C_M_RD ? 'R' : 'W', addr);
> @@ -170,7 +170,7 @@ static int pca_rx_ack(struct i2c_algo_pca_data *adap,
> =20
>  	sta &=3D ~(I2C_PCA_CON_STO|I2C_PCA_CON_STA|I2C_PCA_CON_SI|I2C_PCA_CON_A=
A);
> =20
> -	if ( ack )
> +	if (ack)

OK

>  		sta |=3D I2C_PCA_CON_AA;
> =20
>  	pca_set_con(adap, sta);
> @@ -178,12 +178,12 @@ static int pca_rx_ack(struct i2c_algo_pca_data *ada=
p,
>  }
> =20
>  static int pca_xfer(struct i2c_adapter *i2c_adap,
> -                    struct i2c_msg *msgs,
> -                    int num)
> +		struct i2c_msg *msgs,
> +		int num)

One more tab maybe?

>  {
> -        struct i2c_algo_pca_data *adap =3D i2c_adap->algo_data;
> -        struct i2c_msg *msg =3D NULL;
> -        int curmsg;
> +	struct i2c_algo_pca_data *adap =3D i2c_adap->algo_data;
> +	struct i2c_msg *msg =3D NULL;
> +	int curmsg;

OK

>  	int numbytes =3D 0;
>  	int state;
>  	int ret;
> @@ -202,22 +202,25 @@ static int pca_xfer(struct i2c_adapter *i2c_adap,
> =20
>  	DEB1("{{{ XFER %d messages\n", num);
> =20
> -	if (i2c_debug>=3D2) {
> +	if (i2c_debug >=3D 2) {

OK

>  		for (curmsg =3D 0; curmsg < num; curmsg++) {
>  			int addr, i;
>  			msg =3D &msgs[curmsg];
> =20
>  			addr =3D (0x7f & msg->addr) ;
> =20
> -			if (msg->flags & I2C_M_RD )
> +			if (msg->flags & I2C_M_RD)

OK

>  				printk(KERN_INFO "    [%02d] RD %d bytes from %#02x [%#02x, ...]\n",
>  				       curmsg, msg->len, addr, (addr<<1) | 1);
>  			else {
>  				printk(KERN_INFO "    [%02d] WR %d bytes to %#02x [%#02x%s",
>  				       curmsg, msg->len, addr, addr<<1,
>  				       msg->len =3D=3D 0 ? "" : ", ");

You missed some spaces areound operators here. Please check for more.

> -				for(i=3D0; i < msg->len; i++)
> -					printk("%#04x%s", msg->buf[i], i =3D=3D msg->len - 1 ? "" : ", ");
> +				for (i =3D 0; i < msg->len; i++)
> +					printk("%#04x%s",
> +							msg->buf[i],
> +							i =3D=3D msg->len - 1 ?
> +							"" : ", ");

NACK. This is not readable. Two lines should do.

>  				printk("]\n");
>  			}
>  		}
> @@ -241,8 +244,10 @@ static int pca_xfer(struct i2c_adapter *i2c_adap,
>  			completed =3D pca_address(adap, msg);
>  			break;
> =20
> -		case 0x18: /* SLA+W has been transmitted; ACK has been received */
> -		case 0x28: /* Data byte in I2CDAT has been transmitted; ACK has been r=
eceived */
> +		case 0x18: /* SLA+W has been transmitted;
> +			      ACK has been received */
> +		case 0x28: /* Data byte in I2CDAT has been transmitted;
> +			      ACK has been received */

First, check CodingStyle for how multiline comments should look like. For
readability, I'd like to keep them single line, though. I think this could
be done by rewording. Same for all following comments.

>  			if (numbytes < msg->len) {
>  				completed =3D pca_tx_byte(adap,
>  							msg->buf[numbytes]);
> @@ -256,16 +261,19 @@ static int pca_xfer(struct i2c_adapter *i2c_adap,
>  				completed =3D pca_repeated_start(adap);
>  			break;
> =20
> -		case 0x20: /* SLA+W has been transmitted; NOT ACK has been received */
> +		case 0x20: /* SLA+W has been transmitted;
> +			      NOT ACK has been received */
>  			DEB2("NOT ACK received after SLA+W\n");
>  			pca_stop(adap);
>  			goto out;
> =20
> -		case 0x40: /* SLA+R has been transmitted; ACK has been received */
> +		case 0x40: /* SLA+R has been transmitted;
> +			      ACK has been received */
>  			completed =3D pca_rx_ack(adap, msg->len > 1);
>  			break;
> =20
> -		case 0x50: /* Data bytes has been received; ACK has been returned */
> +		case 0x50: /* Data bytes has been received;
> +			      ACK has been returned */
>  			if (numbytes < msg->len) {
>  				pca_rx_byte(adap, &msg->buf[numbytes], 1);
>  				numbytes++;
> @@ -280,17 +288,20 @@ static int pca_xfer(struct i2c_adapter *i2c_adap,
>  				completed =3D pca_repeated_start(adap);
>  			break;
> =20
> -		case 0x48: /* SLA+R has been transmitted; NOT ACK has been received */
> +		case 0x48: /* SLA+R has been transmitted;
> +			      NOT ACK has been received */
>  			DEB2("NOT ACK received after SLA+R\n");
>  			pca_stop(adap);
>  			goto out;
> =20
> -		case 0x30: /* Data byte in I2CDAT has been transmitted; NOT ACK has be=
en received */
> +		case 0x30: /* Data byte in I2CDAT has been transmitted;
> +			      NOT ACK has been received */
>  			DEB2("NOT ACK received after data byte\n");
>  			pca_stop(adap);
>  			goto out;
> =20
> -		case 0x38: /* Arbitration lost during SLA+W, SLA+R or data bytes */
> +		case 0x38: /* Arbitration lost during SLA+W, SLA+R or
> +			      data bytes */
>  			DEB2("Arbitration lost\n");
>  			/*
>  			 * The PCA9564 data sheet (2006-09-01) says "A
> @@ -304,8 +315,9 @@ static int pca_xfer(struct i2c_adapter *i2c_adap,
>  			pca_start(adap);
>  			goto out;
> =20
> -		case 0x58: /* Data byte has been received; NOT ACK has been returned */
> -			if ( numbytes =3D=3D msg->len - 1 ) {
> +		case 0x58: /* Data byte has been received;
> +			      NOT ACK has been returned */
> +			if (numbytes =3D=3D msg->len - 1) {
>  				pca_rx_byte(adap, &msg->buf[numbytes], 0);
>  				curmsg++; numbytes =3D 0;
>  				if (curmsg =3D=3D num)
> @@ -328,12 +340,14 @@ static int pca_xfer(struct i2c_adapter *i2c_adap,
>  			DEB2("BUS ERROR - SCL Stuck low\n");
>  			pca_reset(adap);
>  			goto out;
> -		case 0x00: /* Bus error during master or slave mode due to illegal STA=
RT or STOP condition */
> +		case 0x00: /* Bus error during master or slave mode
> +			      due to illegal START or STOP condition */
>  			DEB2("BUS ERROR - Illegal START or STOP\n");
>  			pca_reset(adap);
>  			goto out;
>  		default:
> -			dev_err(&i2c_adap->dev, "unhandled SIO state 0x%02x\n", state);
> +			dev_err(&i2c_adap->dev, "unhandled SIO state 0x%02x\n",
> +					state);

Oh well, so be it.

>  			break;
>  		}
> =20
> @@ -352,7 +366,7 @@ static int pca_xfer(struct i2c_adapter *i2c_adap,
> =20
>  static u32 pca_func(struct i2c_adapter *adap)
>  {
> -        return I2C_FUNC_I2C | I2C_FUNC_SMBUS_EMUL;
> +	return I2C_FUNC_I2C | I2C_FUNC_SMBUS_EMUL;

OK

>  }
> =20
>  static const struct i2c_algorithm pca_algo =3D {
> --=20
> 1.7.0
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-i2c" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--xgyAXRrhYN0wYx8y
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkvPkPIACgkQD27XaX1/VRuqVgCeLZz5LPSFo1uMyOsdFaT2WVbq
bFUAoMlBKohMyCTWHVtDohfHdi40hq9n
=kBRG
-----END PGP SIGNATURE-----

--xgyAXRrhYN0wYx8y--
