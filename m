Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757729Ab2I2TBg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Sep 2012 15:01:36 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38988 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757325Ab2I2TBf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Sep 2012 15:01:35 -0400
Message-ID: <1348945275.18878.32.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [ 080/262] usb: gadget: dummy_hcd: fixup error probe path
From: Ben Hutchings <ben@decadent.org.uk>
To: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>,
        Felipe Balbi <balbi@ti.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        alan@lxorguk.ukuu.org.uk,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date: Sat, 29 Sep 2012 21:01:15 +0200
In-Reply-To: <20120928183007.576522849@linuxfoundation.org>
References: <20120928182957.993484211@linuxfoundation.org>
	 <20120928183007.576522849@linuxfoundation.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-OLusqufoesxTUxACxf0B"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 77.203.67.142
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-OLusqufoesxTUxACxf0B
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2012-09-28 at 11:50 -0700, Greg Kroah-Hartman wrote:
> From: Greg KH <gregkh@linuxfoundation.org>
>=20
> 3.5-stable review patch.  If anyone has any objections, please let me kno=
w.
>=20
> ------------------
>=20
> From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
>=20
> commit 1b68a4ca2d038addb7314211d122fb6d7002b38b upstream.
>=20
> If USB2 host controller probes fine but USB3 does not then we don't
> remove the USB controller properly and lock up the system while the HUB
> code will try to enumerate the USB2 controller and access memory which
> is no longer available in case the dummy_hcd was compiled as a module.
>=20
> This is a problem since 448b6eb1 ("USB: Make sure to fetch the BOS desc
> for roothubs.) if used in USB3 mode because dummy does not provide this
> descriptor and explodes later.
[...]

i.e. for 3.5 (as noted in the cc: stable line).  But I don't see why
this isn't needed for earlier kernel versions.  The same broken error
handling is present.

Ben.

--=20
Ben Hutchings
Usenet is essentially a HUGE group of people passing notes in class.
                      - Rachel Kadel, `A Quick Guide to Newsgroup Etiquette=
'

--=-OLusqufoesxTUxACxf0B
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUGdFe+e/yOyVhhEJAQqmqA/+L/xPCFTqIKxbANwfgqXvYU30x+HgojFz
MYPnZn93reKgv0Ke+MZ/DIuq+h6363EtT6OeK/ngtfwZbf8BG1jvAV2ecGa3iDzA
Hnz1+jXgNT+p2dWrdH2mQWcJ019y0ZPXM84v9V4qJpc8cadKsyX/PDe2lSKwoaDb
JouoN6CZP5Vga3h3ETK3G9y8sd7YJZI9gE9YaZ3386iK/qkq3UwrJllwCWpKKthD
2zPlzP7H9Bq4Rl4uUaJ0Y+NCT+flWAG/KikVB3RgGsUNg73UMPaOvtiyZdHAMIUF
sWB08RRZ/xWWi1eG1aWiQiAO9L2ifwsTgGpO5OW85fxoQCBIu+CM/e79jHXyi6s2
VsUmE3Vzd43iVhEsh0tZKDvXRWj4wl7FeJuvrDwcasuk2eRzwBS/7nLf1/+pV28g
tq1yRzHe2IqAhPzV6GMQ7ck+P5a3AIIWai4qyJKWOdG/x6/1rJMpo2HkzNB/gGue
JsFpivvDFpKJxfXMHNY4luBxMGeF5WmLR28kXr9XgVWALinstBa2ELhFGFKrbMKN
CwT2vZg+LBJXhq6I5316DKg3TmgTLx8FyqYEZLj1+NIgNqW+4m8gNwTAtJH8V9L0
w602eRHx5vMgcE1C+cmZN/X/VaGg7VZQQXe1HbGMu7CGjM53ljyHPtQxwYFwPx0D
PXANcs0nKxY=
=qlJk
-----END PGP SIGNATURE-----

--=-OLusqufoesxTUxACxf0B--
