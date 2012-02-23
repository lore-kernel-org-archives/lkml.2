Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755777Ab2BWMbA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 07:31:00 -0500
Received: from na3sys009aog113.obsmtp.com ([74.125.149.209]:46134 "EHLO
	na3sys009aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755170Ab2BWMa7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 07:30:59 -0500
Date: Thu, 23 Feb 2012 14:30:55 +0200
From: Felipe Balbi <balbi@ti.com>
To: Tarun Kanti DebBarma <tarun.kanti@ti.com>
Cc: linux-omap@vger.kernel.org, grant.likely@secretlab.ca, khilman@ti.com,
        tony@atomide.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 5/6] gpio/omap: fix trigger type to unsigned
Message-ID: <20120223123052.GI18463@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1329999031-6914-1-git-send-email-tarun.kanti@ti.com>
 <1329999031-6914-6-git-send-email-tarun.kanti@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="8BaRf9C5c8wiXWYy"
Content-Disposition: inline
In-Reply-To: <1329999031-6914-6-git-send-email-tarun.kanti@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--8BaRf9C5c8wiXWYy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 23, 2012 at 05:40:30PM +0530, Tarun Kanti DebBarma wrote:
> The GPIO trigger parameter is of type unsigned.
> enum {
>         IRQ_TYPE_NONE           =3D 0x00000000,
>         IRQ_TYPE_EDGE_RISING    =3D 0x00000001,
>         IRQ_TYPE_EDGE_FALLING   =3D 0x00000002,
>         IRQ_TYPE_EDGE_BOTH      =3D (IRQ_TYPE_EDGE_FALLING | IRQ_TYPE_EDG=
E_RISING),
>         IRQ_TYPE_LEVEL_HIGH     =3D 0x00000004,
>         IRQ_TYPE_LEVEL_LOW      =3D 0x00000008,
>         IRQ_TYPE_LEVEL_MASK     =3D (IRQ_TYPE_LEVEL_LOW | IRQ_TYPE_LEVEL_=
HIGH),
>         IRQ_TYPE_SENSE_MASK     =3D 0x0000000f,
>=20
>         IRQ_TYPE_PROBE          =3D 0x00000010,
> ...
> };
> Even though gpio_irq_type(struct irq_data *d, unsigned type) has the righ=
t type
> of parameter, the subsequent called functions set_gpio_triggering() and
> set_gpio_trigger() wrongly makes it signed integer. Fix this.
>=20
> Signed-off-by: Tarun Kanti DebBarma <tarun.kanti@ti.com>

Cool, I guess sparse would also have caught that error :-)

Acked-by: Felipe Balbi <balbi@ti.com>

--=20
balbi

--8BaRf9C5c8wiXWYy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPRjF8AAoJEIaOsuA1yqREy9wP/RvhoJ8REH7NA+PhG/LndStF
dqG3bNI6GBE4POZ8yTDw3OUh5Pc2OMSj8hfNz/sHp9OH3TLz+XUKeVJWtiJG2hJI
dfV/bn2PpV+azJo34PBcOKDLQRhzq5AvSHCs4QHqBztISKBCR7C0qfKEJ26lluok
BURbRhEkOSgM+DCsA48G7JjNjePi4rbZemxzwuZTydn2P+1+18zoaRDYu2nqeVY9
wgQvRq7duupEEoeujvQfJSIUR6jhbJvsjRmXjlPgYBchkAJ76rd6g/PR3ezeQ/4g
vtR+Rcu35vAuV5OmnYbGX/FqclhoS4LCBP5lcHskNBsypmCmaSv/n8dE6JHM1tjv
QYHAWbHpfS+NE8266QI5LdKhwvDF/tGd9QWQvTzds5xAbhdBodsRtDVnPlcaxUeV
9+CROE8YdNAMdS6HctShinQPmYmuBm241fGcDjeLbnPB2Na2+7+xI6011a2KscVA
xEhEQr0Z5IhfHqB3IrtsayniazgDPZpQNc7g1qPGknnuSIFl0ocXI61XLy77H/42
fVDLA+fK4C9oU7lmdpSZkBHFZMxOa2/EyBsi9RaceW4KreHSRas4YRiht00PbavU
O736ilPKd2qQUUfJRWbSlvKHtg9FCL1obkuAtRpk0O58c4JbOm0TbcUNEPZN93EA
suQJtAIGLkkaG/u6xwn7
=4KZE
-----END PGP SIGNATURE-----

--8BaRf9C5c8wiXWYy--
