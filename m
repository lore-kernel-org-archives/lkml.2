Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751975Ab2E0TuT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2012 15:50:19 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:48866 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752617Ab2E0TuQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2012 15:50:16 -0400
Message-ID: <1338148200.20487.126.camel@deadeye>
Subject: Re: [ 07/91] net/wireless: ipw2200: Fix WARN_ON occurring in
 wiphy_register called by ipw_pci_probe
From: Ben Hutchings <ben@decadent.org.uk>
To: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Stanislav Yakovlev <stas.yakovlev@gmail.com>,
        Stefan Lippers-Hollmann <s.l-h@gmx.de>,
        "John W. Linville" <linville@tuxdriver.com>,
        Cesare Leonardi <celeonar@gmail.com>
Date: Sun, 27 May 2012 20:50:00 +0100
In-Reply-To: <20120527192419.GA2638@herton-Z68MA-D2H-B3>
References: <20120527010903.GA18244@kroah.com>
	 <20120527002508.441168361@linuxfoundation.org>
	 <20120527192419.GA2638@herton-Z68MA-D2H-B3>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-ifxbmJg6hAycMm0Qwg5K"
X-Mailer: Evolution 3.2.2-1+b1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-ifxbmJg6hAycMm0Qwg5K
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 2012-05-27 at 16:24 -0300, Herton Ronaldo Krzesinski wrote:
> On Sun, May 27, 2012 at 09:25:13AM +0900, Greg KH wrote:
> > 3.4-stable review patch.  If anyone has any objections, please let me k=
now.
> >=20
> > ------------------
>=20
> As I see, this is not needed on 3.4.x or 3.3.x, since the commit
> "ipw2200: Fix order of device registration", wasn't included in 3.4 or
> any earlier kernels.
>=20
> This is fixing an issue introduced on that commit ("ipw2200: Fix order of
> device registration"), that moved register_netdev after ipw_wdev_init,
> but ipw_wdev_init needs initialization made on ndo_init callback.
>=20
> Unless there is any plan to include any of the "... Fix order of device
> registration" commits on 3.4 stable, I don't see any reason to include
> the fix for them.
>
> Besides that, I noted that ipw2100 seems to need a similar fix as below
> after the change "ipw2100: Fix order of device registration". ipw2100
> will have the same issue I expect: because ipw2100_wdev_init was moved
> before register_netdev, the ndo_init callback that runs ipw2100_up will
> only execute later with required initialization, after wiphy_register
> inside ipw2100_wdev_init runs.
[...]

Right.

As it happens, ipw2100 also has a comment explaining why .ndo_init is
used now:

	 * If we called ipw2100_up before we registered the device, then the
	 * device name wasn't registered.  So, we instead use the net_dev->init
	 * member to call a function that then just turns and calls ipw2100_up.
	 * net_dev->init is called after name allocation but before the
	 * notifier chain is called */

So this can result in log messages referring to "wlan%d" rather than the
yet-to-be-determined device name.  (That can be avoided by using
netdev_printk, which will log the PCI address.)

If userland depends on the "phy80211" symlinks for wireless net devices
in sysfs then all 4 fixes would be worth applying to stable.  Otherwise,
none of them should be applied.

Ben.

--=20
Ben Hutchings
The obvious mathematical breakthrough [to break modern encryption] would be
development of an easy way to factor large prime numbers. - Bill Gates

--=-ifxbmJg6hAycMm0Qwg5K
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAT8KFaOe/yOyVhhEJAQpAzhAAtMxa0z4N0XhC20a4y/dMCgLPU62fuw5Z
UeoOYOtFAXjgPTQ2DJ13JUOUjCCHR48SYSiNGISujBxt3gAcKQ0NaAykRIiydDfU
GaKg5lfXf/ahJiQfx638xlt4j/mXqIR802krppXLfvYfcVjRPSe1YC1aDWFKPlUl
bqI5kpvN5JfwhYTtdDi2jYFBh/CJ7c+EJwDzAtb0/bDFuVb/eDzfPpT8yeoEVmPj
EewcKmJyJIqR/8TBcVbm9R3nQfSHPWmXsIqoTXZ7gXOK1expUnHl9FUNAT3bVQY+
2zWbTzIsGs3JyFtbUrlxMwAZ6TK/jJPkvwR7lEdADdBAcAZC3e6EA/OqMJYi5Bkb
Xhgpok1VpDYx5KU0ohooErZktmmPaxwaDGmRrlZ6Mp+kgo4ifHBzD87njAp+kSoR
DSYwF0PpOxPvytpJbBc5m2C2s3IGI0G4QIj2VNUeicgJPrmnULX8BMJx1dClUB65
WY0PbopvUCx1I7NlAZXdf65/QoxpOLnU3/3r8xDUvjsSg7yTUi7V6SxqL5HEcIWr
QEBlN4cUlN+Ur4J6L8s+BkKzn+wElTDqd9cR9rogkuPTz2sqnWW5Aog0ESDilTUp
PW2+CcKgHSq06NLbnWCgHUHtq4OELIrmvr4QCdWxED0rXJTfifnppF0EBelXcLk5
vVwRO3oQS7Q=
=FCkq
-----END PGP SIGNATURE-----

--=-ifxbmJg6hAycMm0Qwg5K--
