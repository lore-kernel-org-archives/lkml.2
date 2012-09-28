Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030923Ab2I1WNV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 18:13:21 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:59190 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758347Ab2I1WNT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 18:13:19 -0400
Message-ID: <1348870383.6858.5.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [ 056/127] Bluetooth: Fix not removing power_off delayed work
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        alan@lxorguk.ukuu.org.uk,
        Vinicius Costa Gomes <vinicius.gomes@openbossa.org>,
        Gustavo Padovan <gustavo.padovan@collabora.co.uk>
Date: Sat, 29 Sep 2012 00:13:03 +0200
In-Reply-To: <20120928203052.382739768@linuxfoundation.org>
References: <20120928203045.835238916@linuxfoundation.org>
	 <20120928203052.382739768@linuxfoundation.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-9OiiX7S3QgBb5j89DD89"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 77.203.67.142
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-9OiiX7S3QgBb5j89DD89
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2012-09-28 at 13:33 -0700, Greg Kroah-Hartman wrote:
> 3.0-stable review patch.  If anyone has any objections, please let me kno=
w.
>=20
> ------------------
>=20
> From: Vinicius Costa Gomes <vinicius.gomes@openbossa.org>
>=20
> commit 78c04c0bf52360dc2f7185e99c8e9aa05d73ae5a upstream.
>=20
> For example, when a usb reset is received (I could reproduce it
> running something very similar to this[1] in a loop) it could be
> that the device is unregistered while the power_off delayed work
> is still scheduled to run.
[...]
> --- a/net/bluetooth/hci_core.c
> +++ b/net/bluetooth/hci_core.c
> @@ -588,6 +588,8 @@ static int hci_dev_do_close(struct hci_d
>  {
>  	BT_DBG("%s %p", hdev->name, hdev);
> =20
> +	cancel_delayed_work(&hdev->power_off);
[...]

This is not right for 3.0 as the type of hdev->power_off is struct
work_struct, not struct delayed_work.

When I looked at this for 3.2 it appeared that this fix might not be
required at all.

Ben.

--=20
Ben Hutchings
Usenet is essentially a HUGE group of people passing notes in class.
                      - Rachel Kadel, `A Quick Guide to Newsgroup Etiquette=
'

--=-9OiiX7S3QgBb5j89DD89
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUGYg7+e/yOyVhhEJAQqeqw/+MggFVLPpzAu5K3hSgHNTpoLk0FHnDzIz
tHZnSpL5hnFJ2NMDHLFL1zSjkEz21UCDGU5xViE0uDfrbR2ulzhuf25+bmREek24
ZT2pJu3DCQabhTwuPH8/Ei73FdbsP9Rl+0WjZJKrNbt2KAAJu5yWUCYakG0nubch
IoId1DBipHfBFIp/5EWzO6ctG2cw5+jnLSQoLmW00lQJ0M7czuEiLiw/2uKmCu/C
ykhUtjNBSW7KOGgUyQVRndAp4gfHD42kAgesNngkk4B0WbRov8SINJaRy0xQLRUV
PonDY4Qk+T+o1cnCB4jUkTbsk9iKVB9i0sb85zisfvS7+KwLST0IB+h4zCoGg54M
WJmR9vsHGioIn/Q7CXjWiL7BxpKTCuOfXECaH1TzdGVxcnfMEE10ujHMWqaUgyeh
aucjgbRFSjb0vCMZIy+EuKnVoEsqm0czB34h3pb9b2lDM9tR4dUO+e8Q2O2pxcBp
ruAFgcPwSbjfG6RefUprA+KtfB2XY4/nnfKHyizJvGwc5kESgmfW/OA0E8/E8hyb
eT8eWpjtMiHGrLTczG8Y1rsX7R65lqg542EAeHFT+xvZSyO0qJN69ILDHcbD6xCX
BgcuZYVCGE5XxiXBJ1hrswrGvMmCmEyoYWwNSZuT16uBn4sLkmr6GGXjwbj0quQ1
1hOgTzgRyjc=
=S7Y/
-----END PGP SIGNATURE-----

--=-9OiiX7S3QgBb5j89DD89--
