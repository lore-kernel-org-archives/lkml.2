Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753864Ab2LBDRs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2012 22:17:48 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:57950 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751702Ab2LBDRr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2012 22:17:47 -0500
Message-ID: <1354418247.7995.49.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [ 05/56] drivers/leds/leds-lp5521.c: fix lp5521_read() error
 handling
From: Ben Hutchings <ben@decadent.org.uk>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        alan@lxorguk.ukuu.org.uk, Milo <Milo.Kim@ti.com>,
        Richard Purdie <rpurdie@rpsys.net>, Bryan Wu <bryan.wu@canonical.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date: Sun, 02 Dec 2012 03:17:27 +0000
In-Reply-To: <20121130185118.896569929@linuxfoundation.org>
References: <20121130185118.302752929@linuxfoundation.org>
	 <20121130185118.896569929@linuxfoundation.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-3ZGg3dHkDTFcc8vBWprU"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-3ZGg3dHkDTFcc8vBWprU
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2012-11-30 at 10:54 -0800, Greg Kroah-Hartman wrote:
> 3.4-stable review patch.  If anyone has any objections, please let me kno=
w.
>=20
> ------------------
>=20
> From: Dan Carpenter <dan.carpenter@oracle.com>
>=20
> commit 5bc9ad774c063f6b41965e7314f2c26aa5e465a0 upstream.
>=20
> Gcc 4.6.2 complains that:
>=20
>   drivers/leds/leds-lp5521.c: In function `lp5521_load_program':
>   drivers/leds/leds-lp5521.c:214:21: warning: `mode' may be used uninitia=
lized in this function [-Wuninitialized]
>   drivers/leds/leds-lp5521.c: In function `lp5521_probe':
>   drivers/leds/leds-lp5521.c:788:5: warning: `buf' may be used uninitiali=
zed in this function [-Wuninitialized]
>   drivers/leds/leds-lp5521.c:740:6: warning: `ret' may be used uninitiali=
zed in this function [-Wuninitialized]
>=20
> These are real problems if lp5521_read() returns an error.  When that
> happens we should handle it, instead of ignoring it or doing a bitwise
> OR with all the other error codes and continuing.
[...]
> --- a/drivers/leds/leds-lp5521.c
> +++ b/drivers/leds/leds-lp5521.c
[...]
> @@ -785,7 +789,7 @@ static int __devinit lp5521_probe(struct
>  	 * LP5521_REG_ENABLE register will not have any effect - strange!
>  	 */
>  	ret =3D lp5521_read(client, LP5521_REG_R_CURRENT, &buf);
> -	if (buf !=3D LP5521_REG_R_CURR_DEFAULT) {
> +	if (ret || buf !=3D LP5521_REG_R_CURR_DEFAULT) {
>  		dev_err(&client->dev, "error in resetting chip\n");
>  		goto fail2;
>  	}

lp5521_probe() is going to return 0 if ret =3D=3D 0 &&
buf !=3D LP5521_REG_R_CURR_DEFAULT here.  It needs to set an error code.

Ben.

--=20
Ben Hutchings
It is easier to change the specification to fit the program than vice versa=
.

--=-3ZGg3dHkDTFcc8vBWprU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAULrIR+e/yOyVhhEJAQocfA/6AwauKUawh0pxSHVkZuLpoO5YVRFRHdIH
VpZCP5gq4i0MSTUCcPuWWcuIDkZs4T/EdJmM7nLySmTqC5QifeJ+PmakvFFI+3yL
LMOakmNSlFyFaej8Kn7XbmyNaKtzivBY1dvKbSBSKbnIKGM3sOTtLIMQAtjQmJim
8G40y4jPAY50G9M6Q6fi6hp5n6QoQXWXrUNPJM6elC0kEzJ5hKFiP6UQxkiW244V
iQwN3HkgP8IhTMMx+4X2lYjQ/ropIft8b1Fa/zWgZzfhtDRHgTyeMiWh2t6hoz7Q
EjD+V5TBysW9r1eLMtBYTXNsl0D9beuvVpgJZYovspk6Moj0qFEfXf1wl9l8aEpJ
6kfCd486gPS1D/xPqS8oF/Yy0+VCNp7H/pOPI2+AWvqP/WJVDuehvXZJJAzk+HwM
VBXr2LNHE43DYWneyzvRUeIKs6FsgUUAQkpN6pjMxoHmL++lQtL8Jiry4kBxcJmV
S6JCgnDv4tPOiyEbKZWvr4O09iMWB91PZwquDA9NWAselvpVX3CKuuMZOToy9skc
NncVm+igsiKrWiVGTln9J4FEQmUSvJqvZMQ28mqAHUIcZk+Kjyy+CbSPGVa/cK3m
YWSIajhyud5k94tBQLPT9AXCl5Fg2yhctf5R2oY0ya2Jrsnhu850cS/ShtC6GCkj
+csqGmlITwo=
=c9eO
-----END PGP SIGNATURE-----

--=-3ZGg3dHkDTFcc8vBWprU--
