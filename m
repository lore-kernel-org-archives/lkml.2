Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754822Ab1DTCCN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 22:02:13 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34612 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751340Ab1DTCCK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 22:02:10 -0400
From: Ben Hutchings <ben@decadent.org.uk>
To: Dmitry Torokhov <dtor@vmware.com>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable-review@kernel.org,
        alan@lxorguk.ukuu.org.uk, Greg KH <gregkh@suse.de>
In-Reply-To: <20110419204119.285492847@clark.kroah.org>
References: <20110419204119.285492847@clark.kroah.org>
Content-Type: multipart/signed; micalg="pgp-sha512"; protocol="application/pgp-signature"; boundary="=-uKT3Rpzypt7lhkRI0LqD"
Date: Wed, 20 Apr 2011 03:02:04 +0100
Message-ID: <1303264924.3464.69.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: Re: [Stable-review] [24/28] USB: xhci - fix unsafe macro
 definitions
X-SA-Exim-Version: 4.2.1 (built Mon, 22 Mar 2010 06:51:10 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.i.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-uKT3Rpzypt7lhkRI0LqD
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2011-04-19 at 13:31 -0700, Greg KH wrote:
> 2.6.32-longterm review patch.  If anyone has any objections, please let u=
s know.
>=20
> ------------------
>=20
> From: Dmitry Torokhov <dtor@vmware.com>
>=20
> commit 5a6c2f3ff039154872ce597952f8b8900ea0d732 upstream.
>=20
> Macro arguments used in expressions need to be enclosed in parenthesis
> to avoid unpleasant surprises.

Do you know of any specific uses of these macros where the missing
parentheses caused 'unpleasant surprises'?

Ben.

> This should be queued for kernels back to 2.6.31
>=20
> Signed-off-by: Dmitry Torokhov <dtor@vmware.com>
> Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
>=20
> ---
>  drivers/usb/host/xhci.h |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>=20
> --- a/drivers/usb/host/xhci.h
> +++ b/drivers/usb/host/xhci.h
> @@ -232,7 +232,7 @@ struct xhci_op_regs {
>   * notification type that matches a bit set in this bit field.
>   */
>  #define	DEV_NOTE_MASK		(0xffff)
> -#define ENABLE_DEV_NOTE(x)	(1 << x)
> +#define ENABLE_DEV_NOTE(x)	(1 << (x))
>  /* Most of the device notification types should only be used for debug.
>   * SW does need to pay attention to function wake notifications.
>   */
> @@ -579,11 +579,11 @@ struct xhci_ep_ctx {
>  #define EP_STATE_STOPPED	3
>  #define EP_STATE_ERROR		4
>  /* Mult - Max number of burtst within an interval, in EP companion desc.=
 */
> -#define EP_MULT(p)		((p & 0x3) << 8)
> +#define EP_MULT(p)		(((p) & 0x3) << 8)
>  /* bits 10:14 are Max Primary Streams */
>  /* bit 15 is Linear Stream Array */
>  /* Interval - period between requests to an endpoint - 125u increments. =
*/
> -#define EP_INTERVAL(p)		((p & 0xff) << 16)
> +#define EP_INTERVAL(p)		(((p) & 0xff) << 16)
>  #define EP_INTERVAL_TO_UFRAMES(p)		(1 << (((p) >> 16) & 0xff))
> =20
>  /* ep_info2 bitmasks */
>=20
>=20
> _______________________________________________
> Stable-review mailing list
> Stable-review@linux.kernel.org
> http://linux.kernel.org/mailman/listinfo/stable-review
>=20

--=20
Ben Hutchings
Once a job is fouled up, anything done to improve it makes it worse.

--=-uKT3Rpzypt7lhkRI0LqD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUATa4+nOe/yOyVhhEJAQrZMBAApuooEGCR+mxxWMRIh7+frx1dJJTMCGuA
QEPCbU328pf7hWh6hDTMLn53IaMc5jgDTspWPAkH2ZcNNTz83Jqpd9JxTE1tfOB1
2VplFwfdFxoh6HXNax1AbOHAX6l2gE2TPEQ3AUKq1qJVFJQOPFfvnYdBaEjaTAKz
d+ajiC070jjBPykHO+oBG6rA3LecBZc78+M3ErezJvr0ifIFLJ4c4debrZIsyw3N
6JlOVCIywKAiu5ZYN8tR7EjhmsFot+RYz1cyZYb9WnTADmHNu7GwAw+ujqrKi7W+
EbX0lhTYLqpXSiVy0QcLCgA7eMQEgWZKd31EPZWP90BJw02XKL3x8mMx8Hm/DUoO
OpxToyDkdXe2u4nX4z2GDztGBEbzkPCNNhV+aMt3+FbHfkDIMjyuW/Z6/WM6R9BI
wjw1PI1D3cpaKMN4bTJ0fIeE+eHNuo723lxYVmMkAGgEW1OfZ7a6NbL0kgjPhXkn
NfG6+nm2BU/lT4aWLsncGXr1F/SXKYbrVAuVk2Ky0wsCWC9FdnEWHrnazOcyCFRw
kWV/7Lh92qeR2llze3y+ySRx4JTmrh9+ychqgHZ37YKV8mu5qk6IS8iRuPMyGqSF
z5AqjQCC1oCZdRD0g+VUd4LD1zN6lRdzB+Z1Ss55ufe45VCUdPljDHBwkcODTl7m
OTg2IgmhnrE=
=iQvT
-----END PGP SIGNATURE-----

--=-uKT3Rpzypt7lhkRI0LqD--
