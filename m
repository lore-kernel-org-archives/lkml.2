Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756885Ab1FPQZq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 12:25:46 -0400
Received: from na3sys009aog108.obsmtp.com ([74.125.149.199]:33045 "EHLO
	na3sys009aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756086Ab1FPQZm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 12:25:42 -0400
Date: Thu, 16 Jun 2011 19:25:36 +0300
From: Felipe Balbi <balbi@ti.com>
To: Tatyana Brokhman <tlinder@codeaurora.org>
Cc: greg@kroah.com, linux-usb@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        balbi@ti.com, ablay@codeaurora.org,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH/RFC 3/5] usb:g_zero: bulk in/out unittest support
Message-ID: <20110616162534.GX12230@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1308231068-24038-2-git-send-email-tlinder@codeaurora.org>
 <1308231068-24038-4-git-send-email-tlinder@codeaurora.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="fBT78PV5vI5fyuAn"
Content-Disposition: inline
In-Reply-To: <1308231068-24038-4-git-send-email-tlinder@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--fBT78PV5vI5fyuAn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Jun 16, 2011 at 04:31:05PM +0300, Tatyana Brokhman wrote:
> This commit adds a new vendor specific request to be handled by the
> g_zero module in it's sourcesink configuration. The purpose if this
> request is to update the length of the BULK transfer to a given value.
> The bRequest value of the new control request is 0x5e.
> It is used by the user-space Unit testing application for bulk in/out
> tests.
>=20
> Signed-off-by: Tatyana Brokhman <tlinder@codeaurora.org>
>=20
> ---
>  drivers/usb/gadget/f_sourcesink.c |   12 ++++++++++++
>  1 files changed, 12 insertions(+), 0 deletions(-)
>=20
> diff --git a/drivers/usb/gadget/f_sourcesink.c b/drivers/usb/gadget/f_sou=
rcesink.c
> index caf2f95..d417b8a 100644
> --- a/drivers/usb/gadget/f_sourcesink.c
> +++ b/drivers/usb/gadget/f_sourcesink.c
> @@ -70,6 +70,7 @@ static unsigned pattern;
>  module_param(pattern, uint, 0);
>  MODULE_PARM_DESC(pattern, "0 =3D all zeroes, 1 =3D mod63 ");
> =20
> +static struct f_sourcesink	*the_sourcesink;

this is a big no-no. f_*.c should always be able to be instantiated as
many times as we need.

>  /*----------------------------------------------------------------------=
---*/
> =20
>  static struct usb_interface_descriptor source_sink_intf =3D {
> @@ -197,6 +198,7 @@ static void
>  sourcesink_unbind(struct usb_configuration *c, struct usb_function *f)
>  {
>  	kfree(func_to_ss(f));
> +	the_sourcesink =3D NULL;
>  }
> =20
>  /* optionally require specific source/sink data patterns  */
> @@ -425,6 +427,7 @@ static int __init sourcesink_bind_config(struct usb_c=
onfiguration *c)
>  	status =3D usb_add_function(c, &ss->function);
>  	if (status)
>  		kfree(ss);
> +	the_sourcesink =3D ss;
>  	return status;
>  }
> =20
> @@ -472,6 +475,15 @@ static int sourcesink_setup(struct usb_configuration=
 *c,
>  		value =3D w_length;
>  		break;
> =20
> +	case 0x5e:
> +		/*
> +		 * Change bulk ep buffer size. buflen is the length of
> +		 * the BULK transfer (req->length=3Dbuflen). Defined in g_zero.h
> +		 */
> +		disable_source_sink(the_sourcesink);
> +		buflen =3D w_value;
> +		value =3D enable_source_sink(c->cdev, the_sourcesink);
> +		break;
>  	default:

I think this request, should be handled by the f_sourcesink interface.
Meaning you'd need to introduce another f_sourcesink_setup(); to be
added to the function, rather then the configuration.

Please change that.

--=20
balbi

--fBT78PV5vI5fyuAn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJN+i5+AAoJEAv8Txj19kN1HxwH/0+jG8MFnr9Q0rBR++ULlflX
RPnl+FLyNeeOFrHYJN+wMrRy+ZjBe7aGvIf1m8s2IeX2dcnhTrTO4bXYqaCM6sng
VJ1zFtUsoXwEgonvOnpLKckaedaqLmZ3cxjhrkVKQjw6ctH1J77FtSrdX1XU6HAk
0VXpolWfexoKX2p+bH60hACzQLjDud2gfyZ3RmWBQXytOkJQjoZ74YXCG2M16Nm0
dgTXVmbJ231/eAQ/YRoEcBj7NXhtOyIRkzE90WQhk0/HnK9BU/j5ugeBRODJvnMg
/CLWeW3quA/loX279ZvoGvTh4RxuU7CaG0ds9e2RL6/tUYlQRoiOs/a1ZmgHrrY=
=7sJU
-----END PGP SIGNATURE-----

--fBT78PV5vI5fyuAn--
