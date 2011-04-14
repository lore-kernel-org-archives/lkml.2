Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758688Ab1DNDJv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 23:09:51 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56213 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758639Ab1DNDJu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 23:09:50 -0400
From: Ben Hutchings <ben@decadent.org.uk>
To: Jan Kara <jack@suse.cz>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable-review@kernel.org,
        alan@lxorguk.ukuu.org.uk, Greg KH <gregkh@suse.de>
In-Reply-To: <20110413155146.240695445@clark.kroah.org>
References: <20110413155146.240695445@clark.kroah.org>
Content-Type: multipart/signed; micalg="pgp-sha512"; protocol="application/pgp-signature"; boundary="=-CRizTHfNZ2yS+OWqcxP3"
Date: Thu, 14 Apr 2011 04:09:45 +0100
Message-ID: <1302750585.5282.663.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: Re: [Stable-review] [31/74] quota: Dont write quota info in
 dquot_commit()
X-SA-Exim-Version: 4.2.1 (built Mon, 22 Mar 2010 06:51:10 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.i.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-CRizTHfNZ2yS+OWqcxP3
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2011-04-13 at 08:50 -0700, Greg KH wrote:
> 2.6.32-longterm review patch.  If anyone has any objections, please let u=
s know.
>=20
> ------------------
>=20
> From: Jan Kara <jack@suse.cz>
>=20
> commit b03f24567ce7caf2420b8be4c6eb74c191d59a91 upstream.
>=20
> There's no reason to write quota info in dquot_commit(). The writing is a
> relict from the old days when we didn't have dquot_acquire() and
> dquot_release() and thus dquot_commit() could have created / removed quot=
a
> structures from the file. These days dquot_commit() only updates usage co=
unters
> / limits in quota structure and thus there's no need to write quota info.
>=20
> This also fixes an issue with journaling filesystem which didn't reserve
> enough space in the transaction for write of quota info (it could have be=
en
> dirty at the time of dquot_commit() because of a race with other operatio=
n
> changing it).
[...]
> @@ -400,15 +400,10 @@ int dquot_commit(struct dquot *dquot)
>  	spin_unlock(&dq_list_lock);
>  	/* Inactive dquot can be only if there was error during read/init
>  	 * =3D> we have better not writing it */
> -	if (test_bit(DQ_ACTIVE_B, &dquot->dq_flags)) {
> +	if (test_bit(DQ_ACTIVE_B, &dquot->dq_flags))
>  		ret =3D dqopt->ops[dquot->dq_type]->commit_dqblk(dquot);
> -		if (info_dirty(&dqopt->info[dquot->dq_type])) {
> -			ret2 =3D dqopt->ops[dquot->dq_type]->write_file_info(
> -						dquot->dq_sb, dquot->dq_type);
> -		}
> -		if (ret >=3D 0)
> -			ret =3D ret2;
> -	}
> +	else
> +		ret =3D -EIO;
[...]

Why is the return value for the flag-not-set case changed from 0 to
-EIO?  Is this really part of the same bug fix?

Ben.

--=20
Ben Hutchings
Once a job is fouled up, anything done to improve it makes it worse.

--=-CRizTHfNZ2yS+OWqcxP3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUATaZldOe/yOyVhhEJAQpByg/+OeCu1OlnE7JBr6PpPVueBRLAEn6RmTqX
mJGhFCNI/CFwjdIQIXInYWku5FU0pk5pA7byxlgR1N7lu+ri8I3k/hy6wqNT5d7e
vHFHaLhRcsVv+d87UBAeeAHyaLVhqSOp5XIX+T5XbLKsOZCb5tddNt5l7uSB/acw
kdvNAbUM3SU+P9trXymcNeRlE3PvgBDv2BAuMOCp1uwCY7o3+4sazl3mbSZbzl8O
BrsNV191DO9RnGj3FBscn3uCzF56GzWQmppfP53oGdTonolQ47g0uJeDTfuORJpH
omRXrKm/baAgsupXhpp2rzJrnPG3ztAH8dq2sAss3iVoPeruwVfhUj8zvX1mKTn3
J11rGoAlUm2Hq5HuBxrMNxSP3Hgow2NQpFdSwdQyC3VmNQVlVSuj7lH6K0yYmSSG
OakMoBjhLf/EBovQFc+UHQQXwyQOiZjHUmDE8xXOxIv3TL8xFY5CcfZ64c5SXZH8
JlyiyOACI2ZBOzjxOd3mWmYWbHnuSTh0mmDtUiPFyt7ll54qvD4N1aK8zGkvm2WA
kjaasnByqvvUr8mWYhRWzyF9EwVed+n/GGMMe1kRgTWSUxs05/bt8O4X4pj9NGJi
hyl6GRU9NHq14Uks9Br5Er72Z0w8ncP/wah/s6GNFaRmpgb65hhYLdwz5Pfsj5SP
Gl/j6ZkUGNo=
=E1Re
-----END PGP SIGNATURE-----

--=-CRizTHfNZ2yS+OWqcxP3--
