Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759640Ab2EKXmY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 19:42:24 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38175 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754526Ab2EKXmW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 19:42:22 -0400
Message-ID: <1336779723.8274.473.camel@deadeye>
Subject: Re: [ 018/167] [PATCH] brcm80211: smac: resume transmit fifo upon
 receiving frames
From: Ben Hutchings <ben@decadent.org.uk>
To: Arend van Spriel <arend@broadcom.com>
Cc: stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Francesco Saverio Schiavarelli <fschiava@libero.it>,
        Pieter-Paul Giesberts <pieterpg@broadcom.com>,
        Brett Rudley <brudley@broadcom.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        LKML <linux-kernel@vger.kernel.org>
Date: Sat, 12 May 2012 00:42:03 +0100
In-Reply-To: <20120509055032.096457048@decadent.org.uk>
References: <20120509055032.096457048@decadent.org.uk>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-VgmYg0mfdFxjgyRuuyQr"
X-Mailer: Evolution 3.2.2-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 91.103.132.49
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-VgmYg0mfdFxjgyRuuyQr
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2012-05-09 at 06:50 +0100, Ben Hutchings wrote:
> 3.2-stable review patch.  If anyone has any objections, please let me kno=
w.
>=20
> ------------------
>=20
> From: Arend van Spriel <arend@broadcom.com>
>=20
> commit badc4f07622f0f7093a201638f45e85765f1b5e4 upstream.
>=20
> There have been reports about not being able to use access-points
> on channel 12 and 13 or having connectivity issues when these channels
> were part of the selected regulatory domain. Upon switching to these
> channels the brcmsmac driver suspends the transmit dma fifos. This
> patch resumes them upon handing over the first received beacon to
> mac80211.
>=20
> This patch is to be applied to the stable tree for kernel versions
> 3.2 and 3.3.

It looks like my earlier build test didn't include this driver, due to
'depends on BCMA=3Dn'.  Unfortunately:

[...]
> +	/* unmute transmit */
> +	if (wlc->hw->suspended_fifos) {
> +		hdr =3D (struct ieee80211_hdr *)p->data;
> +		if (ieee80211_is_beacon(hdr->frame_control))
> +			brcms_b_mute(wlc->hw, false);
> +	}
[...]

brcms_b_mute() takes three arguments in 3.2.  Can you send me a patch to
fix this up in 3.2.y, or should I revert the change?

Ben.

--=20
Ben Hutchings
Experience is directly proportional to the value of equipment destroyed.
                                                         - Carolyn Scheppne=
r

--=-VgmYg0mfdFxjgyRuuyQr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAT62jy+e/yOyVhhEJAQqc4A//aWk2+w8NqqV5ZQ0mum5HQqQytJzgjugv
GPFhYyLEaIpqZVGF8/AVMzuk84EYZo8MPfuE7XBT/9hzBF9EoPFropTyf1Sg2hXv
8pHi2AHTEoVVr+ee7nKK30OZE1gwvnhySLrhLYeBuPH1ceCyUqW5PEGU7vgmps6z
0GMARQprOQyBUP1Dyw7gmcl8V0r8ZJyLLqsESsYhdxefrxXfiGJqorQHLBmg+Uvn
kv4oOhajJmJfy5G0TCYJkfkKLqvwpR2Tc+lE6GL1IXgT1vx/RZV5nPQIXiK0AXbZ
TOij/dOKiq/b6CxeY7qZ7ScW0shjtp/mGF3KREfertTMdGsw1StXwtOW9RKxWis0
BFVxmrI8xmZLk8jBGKXCqg1AiXialwQjIcAMTI/PzjbUqTnCIFnQsd1mRhMswmq4
ZzzLml2diGHMlShrugJ7FLJoK3GZfmdVCQ/aZA60eP4DbJFOKwyAtzkxbMNWyn+W
kxRaOebEGCgMYtL/ElHjmbH/hslcKnMb3+i7681DappJBnL3t5LB1lYEhMIFnT2a
b37bFiZY3XJCECFXgr+POyXQ7/JF443aEKBUW00Okf3FO4AlQv8d9rvT37nKtsYG
YTrFaO+zL3VlUk7DjoawwhEZeIC2pTqyqLD9V9c/o21ngu/qLCh22BmJ+kAtCf57
4CGJw7sgbyQ=
=wYIP
-----END PGP SIGNATURE-----

--=-VgmYg0mfdFxjgyRuuyQr--
