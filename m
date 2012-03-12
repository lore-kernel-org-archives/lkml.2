Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755980Ab2CLPYP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 11:24:15 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:59071 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755862Ab2CLPYN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 11:24:13 -0400
Message-ID: <1331565826.3022.156.camel@deadeye>
Subject: Re: [ 08/12] mac80211: zero initialize count field in
 ieee80211_tx_rate
From: Ben Hutchings <ben@decadent.org.uk>
To: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
Cc: Willy Tarreau <w@1wt.eu>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Pavel Roskin <proski@gnu.org>,
        "John W. Linville" <linville@tuxdriver.com>
Date: Mon, 12 Mar 2012 15:23:46 +0000
In-Reply-To: <4F5D9D3D.6090206@qca.qualcomm.com>
References: <20120312002046.282831520@1wt.eu>
	 <1331517472.3022.150.camel@deadeye> <4F5D7D47.102@qca.qualcomm.com>
	 <20120312063412.GD8971@1wt.eu> <4F5D9D3D.6090206@qca.qualcomm.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-9HVS32+b4cb5ZfNWN9yh"
X-Mailer: Evolution 3.2.2-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-9HVS32+b4cb5ZfNWN9yh
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2012-03-12 at 12:22 +0530, Mohammed Shafi Shajakhan wrote:
> Hi Willy,
>=20
> > On Mon, Mar 12, 2012 at 10:06:23AM +0530, Mohammed Shafi Shajakhan wrot=
e:
> >>> So I'm pretty sure this patch is wrong for 2.6.32; it could be
> >>> backported but I don't think the change is necessary anyway.
> >>
> >> true, but i think its better to initialize the count =3D 0 rather than
> >> count =3D 1, though the older version driver checks for rate[i].idx>=
=3D 0
> >> in ath_rc_tx_status. while the ath_tx_status has no such iteration in
> >> the older driver code.
> >
> > In practice, if the patch brings nothing and not even correctness, I'd
> > rather drop it than make us believe that some issue is fixed. However
> > if you think it does happen to fix a real issue in 2.6.32 (possibly
> > combined with some other missing patch), please tell me so and I will
> > happily undelete it.
> >
>=20
> we can drop it. also as there was no driver code checking for=20
> rate[i].count in the 2.6.32 driver. i am also not sure this fixes=20
> something in 2.6.32 but the patch itself is correct.
[...]

Please read and answer the *whole* of my earlier message.  The later
code in the rate_control_get_rate() function in 2.6.32 does appear to
depend on .count =3D 1, and there may be code elsewhere that does so too.

Ben.

--=20
Ben Hutchings
Life would be so much easier if we could look at the source code.

--=-9HVS32+b4cb5ZfNWN9yh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAT14VAue/yOyVhhEJAQr+kg/+Om27bvY0/qwmmm9cdnjAd0MpS1uriEtF
rKagSpmOmhNHyQ9UrC6tSrQVyQ7ryEXEOdqOGcl/9oQUqNbx5Zbr7LqtISRFsB+R
7uMz3ZeyaDfvrFQLRVfjPJxnGvOPZN360sa8Q9J1KrZcuyqhz8lKsN80oe3dYhxT
a6kaoTv3ssgoVUlJYIFt7D3ZCLsqqACktzn8LobsHD8VKaaM7Rui3rbBLtE81cVN
ntLRBAIwFvp+42xzrs0xQoSUIfHv5Kx0vqVA3qdiO4EXPxyfvEiGNDRZht69Uz2n
95UTT/J3IuurdQfKfTVhweBPgovkk4t9dp/V5UsVrw3VZ6Qs4X237DdlPFw//VBT
y4qoIFRfkIQ36DZPL8mH5kHcugBXeJ5fSlA5bOr+IsWAv/RtHoVu9oeORf7NG56B
c/E3ZUTp1eFK9nGJP+sjfq/ip90IbyGvlHgn/PLcyQLmutNqIN1Vb14JXWctqE7R
LoyONwf1MEqf14TGU4Uv4FUBvOOJdOQ6QMEEW+VegRNWZVj47vtjTwl7vdgxqbCR
aQ/b4o4cWRN02Cw6/IbHo00aTTFY8zX1fj5S797+4+gwi8qbC0z24QpJQCeZ53Cu
vTLE/qTxtVG8h1g3n1xX6hOuEo70eG1hm3lWX275U64txtqwR6ewF3axAY3VjPVE
b4QO1jAIoxY=
=q7vn
-----END PGP SIGNATURE-----

--=-9HVS32+b4cb5ZfNWN9yh--
