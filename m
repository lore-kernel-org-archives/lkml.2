Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754483Ab2CLB6O (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2012 21:58:14 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:53770 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754136Ab2CLB6G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2012 21:58:06 -0400
Message-ID: <1331517472.3022.150.camel@deadeye>
Subject: Re: [ 08/12] mac80211: zero initialize count field in
 ieee80211_tx_rate
From: Ben Hutchings <ben@decadent.org.uk>
To: Willy Tarreau <w@1wt.eu>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Pavel Roskin <proski@gnu.org>,
        Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>,
        "John W. Linville" <linville@tuxdriver.com>
Date: Mon, 12 Mar 2012 01:57:52 +0000
In-Reply-To: <20120312002046.282831520@1wt.eu>
References: <20120312002046.282831520@1wt.eu>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-XNDgWf37pbXBrhPtOYNE"
X-Mailer: Evolution 3.2.2-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-XNDgWf37pbXBrhPtOYNE
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2012-03-12 at 01:20 +0100, Willy Tarreau wrote:
> 2.6.32-longterm review patch.  If anyone has any objections, please let m=
e know.
>=20
> ------------------
>=20
> From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
>=20
> commit 8617b093d0031837a7be9b32bc674580cfb5f6b5 upstream.
>=20
> rate control algorithms concludes the rate as invalid
> with rate[i].idx < -1 , while they do also check for rate[i].count is
> non-zero. it would be safer to zero initialize the 'count' field.
> recently we had a ath9k rate control crash where the ath9k rate control
> in ath_tx_status assumed to check only for rate[i].count being non-zero
> in one instance and ended up in using invalid rate index for
> 'connection monitoring NULL func frames' which eventually lead to the cra=
sh.
> thanks to Pavel Roskin for fixing it and finding the root cause.
> https://bugzilla.redhat.com/show_bug.cgi?id=3D768639

In 2.6.32, ath_tx_status() checks that rates[i].idx >=3D 0, so it properly
ignores these dummy entries.  Further, there is code further down the
rate_control_get_rate() function that sets .idx only and appears to
depend on the initialisation of .count =3D 1.

So I'm pretty sure this patch is wrong for 2.6.32; it could be
backported but I don't think the change is necessary anyway.

Ben.

> Cc: stable@vger.kernel.org
> Cc: Pavel Roskin <proski@gnu.org>
> Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
> Signed-off-by: John W. Linville <linville@tuxdriver.com>
>=20
> diff --git a/net/mac80211/rate.c b/net/mac80211/rate.c
> index ad64f4d..f9b8e81 100644
> --- a/net/mac80211/rate.c
> +++ b/net/mac80211/rate.c
> @@ -344,7 +344,7 @@ void rate_control_get_rate(struct ieee80211_sub_if_da=
ta *sdata,
>  	for (i =3D 0; i < IEEE80211_TX_MAX_RATES; i++) {
>  		info->control.rates[i].idx =3D -1;
>  		info->control.rates[i].flags =3D 0;
> -		info->control.rates[i].count =3D 1;
> +		info->control.rates[i].count =3D 0;
>  	}
> =20
>  	if (sdata->local->hw.flags & IEEE80211_HW_HAS_RATE_CONTROL)
>=20
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe stable" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20

--=20
Ben Hutchings
Life would be so much easier if we could look at the source code.

--=-XNDgWf37pbXBrhPtOYNE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAT11YIOe/yOyVhhEJAQr+KA//Yz6deJ6Ay+2k128qmIa78+ns8fRx7l7B
/IpLEwEO8SteqwQC66uluMEFwxo4u31V4roaFxtdKXCPZFT5s4tBAm/AfOkb0NJz
pw6k5+F/3XQ8Wo3VMEIGd1QbK3g6KjYc78b6hhCmTzT+it8Oz6DlnB0ENoM+MuWj
ACZkGUGqvhK4Elafh279doFAxHUjFtqK0tsHHWp6UYtzwR8v54DuwLwU3kkgQ2hU
JfChGOHAixWquh1DO63u+QvRzlFV+xWAoRCHDLBz4tIxqGWaT5lGdKYa2J5Qc29D
5MQ4FFxkanvjTa4F0DZaumvTlP0+pVqy4i9T0oRTxD5lsVtNUQKqMOeQhVtLDvZ6
JmwUa8Vu09ZXT2p19je7g6N9h4tCoAmb8J5UY2AptNPVp6YlgDdJEz+N4+doSL2I
W6mexBSHmzKbn8FrPAS/LZPrru2wRbnch9KMmOiWtDJGojE2x2h3JZc8me22+VJk
sgBUwoJD0hFzEmAZfakukFVL+ZqVr8ALyM8F2LHWCH1k6SvZNztDmuXS4rdrkia+
ViaJZAk0QSkKx73s4QNvCNU2GiLkc6b8TKorNfcXp33y8QPJ2NX9NvW2jkeGTExE
VexQgEp732aPid6l+kn50zvAGP50XiGB7gBdRF/yMiqfRkc5aqyobvbT2PYKbi8f
ZyVWMpiO8GU=
=eRBM
-----END PGP SIGNATURE-----

--=-XNDgWf37pbXBrhPtOYNE--
