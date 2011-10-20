Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753146Ab1JTVKV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 17:10:21 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:41360 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752853Ab1JTVKR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 17:10:17 -0400
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: Kyle Moffett <Kyle.D.Moffett@boeing.com>
Subject: Re: [RFC PATCH 05/17] phy_driver: Make .read_status()/.config_aneg() optional
Date: Thu, 20 Oct 2011 17:10:12 -0400
User-Agent: KMail/1.13.7 (Linux/3.1.0-rc4; KDE/4.6.5; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Randy Dunlap <rdunlap@xenotime.net>,
        Stephen Hemminger <shemminger@vyatta.com>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Dietsche <Gregory.Dietsche@cuw.edu>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        David Daney <ddaney@caviumnetworks.com>,
        Arnaud Patard <arnaud.patard@rtp-net.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Baruch Siach <baruch@tkos.co.il>, Thorsten Schubert <tshu@msc-ge.com>,
        David Decotigny <decot@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        "Marc Kleine-Budde" <mkl@pengutronix.de>, linux-doc@vger.kernel.org
References: <1319144425-15547-1-git-send-email-Kyle.D.Moffett@boeing.com> <1319144425-15547-6-git-send-email-Kyle.D.Moffett@boeing.com>
In-Reply-To: <1319144425-15547-6-git-send-email-Kyle.D.Moffett@boeing.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart4139168.jSIH2nFamg";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201110201710.17519.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart4139168.jSIH2nFamg
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Thursday 20 October 2011 17:00:12 Kyle Moffett wrote:
> Approximately 90% of the PHY drivers follow the PHY layer docs and
> simply use &genphy_read_status and &genphy_config_aneg.  There would
> seem to be little point in requiring them all to manually specify those
> functions.

well, it does make sense if you think about the compile vs build time=20
overhead.  yes, your patch does make things much nicer to read, and a littl=
e=20
easier to maintain the source.  however, it adds runtime overhead (checking=
=20
the func pointers) while the func pointer storage is unchanged (it's now a=
=20
NULL pointer instead of pointing to the genphy funcs).  personally, i think=
=20
the savings in runtime and smaller compiled code is more important.  so i'm=
=20
going to NAK this.  sorry.

> This patch makes it much easier for subsequent patches to split and
> refactor the functionality of the .config_aneg() method.
>=20
> Signed-off-by: Kyle Moffett <Kyle.D.Moffett@boeing.com>
> ---
>  Documentation/networking/phy.txt |   13 +++++--------
>  drivers/net/phy/bcm63xx.c        |    4 ----

hrm, what tree are you using ?  this driver is not in mainline.
=2Dmike

--nextPart4139168.jSIH2nFamg
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iQIcBAABAgAGBQJOoI45AAoJEEFjO5/oN/WBjQcQAL6r7VaOrVz2I7/QtN3p2Cug
7w+venc/AF5LDUpDmVQ+rC+p4Bp7ybfRgls/as+VE09+dbqtF2hAVHz5XPrk+dRq
I5OslQMjIO2mDpxF+KYyA3HfPzWHZCqewYWg2UAG8S4w/XAahuv3QCkxUkGH1bJp
/nsUV5f5ZrfA5askXLNLadpSTi6bSWce07p5EyGSzYb10hsIibXKEg6Od6p02LJW
Nh5Sss9T1QseF6DXKMGzALIpAd2XpSjnQJvawGFu3/TQXbBKuBzr949Wv9/nMFxo
f+2fg/FVqWiiJJxhbuWt/hU1cbO+n8gUtACWw8WQDhjFSz+g+KZ8RH7uA0AW9Dyl
J2+Wt+BAgc2yBnn+kYANZQfmfeC5YhjkoC9kHuXKxc5TvoVH1V0Hf5q9LWV8lbDL
m8o1wKx4SEYhU4C6/CFzSd1/minDfp60gUCfZyifzu2wg9ywBF/pAYcXQlNm+68t
y0S61U9UhdQ3bg9EDtsKTWtdQBBR9VGNNmb1F0BLfJO4lnFSwMIl7rl4xmPCZ+gM
N08phA5mERetqU+3tFG6HwywnxsJBoILg60iFPTXQ8or6WPyqm8IEsCJInZMfzqL
HfSwwXFesyuK3DwdBnzIt4pMfR8pyCkIsJtwU0b5mtZcNkif8kT4KBkjfwMO4vAV
uVr6SaV+TCv20MtWDz+f
=we3g
-----END PGP SIGNATURE-----

--nextPart4139168.jSIH2nFamg--
