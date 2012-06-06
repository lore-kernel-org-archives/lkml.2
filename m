Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755906Ab2FFO0e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 10:26:34 -0400
Received: from mga09.intel.com ([134.134.136.24]:7652 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751981Ab2FFO0d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 10:26:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="asc'?scan'208";a="153721461"
Message-ID: <1338993020.6875.62.camel@sauron.fi.intel.com>
Subject: Re: [PATCH v3] UBIFS: compute KSA size and store in superblock
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Joel Reardon <joel@clambassador.com>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Wed, 06 Jun 2012 17:30:20 +0300
In-Reply-To: <alpine.DEB.2.00.1206061202370.28118@eristoteles.iwoars.net>
References: <alpine.DEB.2.00.1205251509220.2989@eristoteles.iwoars.net>
	  <1337952271.30969.37.camel@sauron.fi.intel.com>
	  <alpine.DEB.2.00.1205301531220.6465@eristoteles.iwoars.net>
	  <1338391121.2536.94.camel@sauron.fi.intel.com>
	  <alpine.DEB.2.00.1205311211340.15137@eristoteles.iwoars.net>
	  <1338459575.2536.120.camel@sauron.fi.intel.com>
	 <1338460565.2536.126.camel@sauron.fi.intel.com>
	 <alpine.DEB.2.00.1206061202370.28118@eristoteles.iwoars.net>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-Bk4NmklmXIiL7tYOgXgh"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Bk4NmklmXIiL7tYOgXgh
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Joel,

still a couple of small requests.

On Wed, 2012-06-06 at 12:03 +0200, Joel Reardon wrote:
> +	if (c->use_ubifsec && c->ksa_lebs <
> +	    ((c->leb_cnt * UBIFS_CRYPTO_KEYSIZE) >> UBIFS_BLOCK_SHIFT) +

Please, do something like this:

min_leb_cnt =3D (c->leb_cnt * UBIFS_CRYPTO_KEYSIZE) >> UBIFS_BLOCK_SHIFT;
if (c->use_ubifsec && c->ksa_lebs < min_leb_cnt)
	bah;
min_leb_cnt +=3D UBIFS_KSA_ADD_LEBS;
if ()
	bah;

That would be more readable.

>  struct ubifs_sb_node {
>  	struct ubifs_ch ch;
> @@ -649,7 +652,9 @@ struct ubifs_sb_node {
>  	__le32 time_gran;
>  	__u8 uuid[16];
>  	__le32 ro_compat_version;
> -	__u8 padding2[3968];
> +	__le32 ksa_lebs;
> +	__u8 use_ubifsec;
> +	__u8 padding2[3963];
>  } __packed;

I've just noticed that we have the 'flags' field ane a set of flags like
"UBIFS_FLG_SPACE_FIXUP". For UBIFSEC, could you please add
"UBIFS_FLG_UBFSEC =3D 0x8" or you name it. This would be more consistent
way.

--=20
Best Regards,
Artem Bityutskiy

--=-Bk4NmklmXIiL7tYOgXgh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJPz2l8AAoJECmIfjd9wqK0VYgP/0r2MKXeNU+ZD8EbGkdll9ba
vUEPEFXnvBFwHmX37Lt2cvOvCmRy+6Xq79r4Ghz7aGkVepiHEnC3bGXC+o2vMUF7
R2t4WE+yp19N+Gpl6b3LMGKDRq6SZ8+oPmOJv454CwnVOcFfXYtey6SxleEhfaxz
0WQNIw1SJUI8z6I7zWojyr+5uYePP9eAr5wcSD/jSwskj6E7ZkPqX/Tyg/r8bQIp
zDKw+6Mj1yWKWNg096/egvK51MusRFl60FzBXBR/aWv95cZD/IPqieNdy0G2nUZX
MIPa/65yl9+mlTacryjz8l0GZaVNd3FP8LrYTSTmWPyY/PripjH+u9VRUBaEyOE7
SEVFRPiGUzb9EjsQCGIeBfBlzcua/KvxcqvehJZFrADrE2lvBDCMcXmtbX82NGvx
BFsKKV8HAHNUI8jAfH0u7PuzoajM9B/I/0N3HKoMgH/UIKaE9jLMyofadHMiJyWL
qbTdmEtQNrvwz6zoeqsT5r4VxlLCm7J1XTvLXFoDDyz3jmUU4Pjehfm5EsknY3Xu
EuuaaEsO2iE65+rF5UzY8eHRxe44bMbpKlWMzmnD0R55EVFnD/dxvpXmV9G4A6/g
YICu1hfszFk3uKag+bP/Bcvej1RhILjXZiTy5RZwGBxXU/5OgR1hBBI6RkB9npt4
WyZqEnkYmj1A6t8GoX7A
=V2z9
-----END PGP SIGNATURE-----

--=-Bk4NmklmXIiL7tYOgXgh--

