Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754893Ab2EBMEc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 08:04:32 -0400
Received: from mga09.intel.com ([134.134.136.24]:46208 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753932Ab2EBMEa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 08:04:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="asc'?scan'208";a="136115112"
Message-ID: <1335960469.10293.49.camel@sauron.fi.intel.com>
Subject: Re: question about fs/jffs2/readinode.c
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Julia Lawall <julia.lawall@lip6.fr>
Cc: dwmw2@infradead.org, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date: Wed, 02 May 2012 15:07:49 +0300
In-Reply-To: <alpine.DEB.2.02.1204280701210.1917@hadrien>
References: <alpine.DEB.2.02.1204280701210.1917@hadrien>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-x8GaPyOvM2bU9Ys4p6yg"
X-Mailer: Evolution 3.2.3 (3.2.3-2.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-x8GaPyOvM2bU9Ys4p6yg
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2012-04-28 at 07:06 +0200, Julia Lawall wrote:
> The function read_direntry in fs/jffs2/readinode.c contains the following=
=20
> code:
>=20
>          err =3D jffs2_flash_read(c, (ref_offset(ref)) + read,
>                                 rd->nsize - already, &read, &fd->name[alr=
eady]);
>  	if (unlikely(read !=3D rd->nsize - already) && likely(!err))
>                        return -EIO;
>=20
>          if (unlikely(err)) {
>                  JFFS2_ERROR("read remainder of name: error %d\n", err);
>                  jffs2_free_full_dirent(fd);
>                  return -EIO;
>          }
>=20
> Is it intentional that the first if doesn't free fd?  At first I thought=
=20
> that that might be the case, because what would be the point of having tw=
o=20
> conditionals if they are going to do the same thing.  But I can't see why=
=20
> fd should not be freed either, so maybe the two conditionals are just=20
> there to give different error messages?

Hi Julia,

I think this is a bug and thes conditionals can be joined into one.

--=20
Best Regards,
Artem Bityutskiy

--=-x8GaPyOvM2bU9Ys4p6yg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJPoSOVAAoJECmIfjd9wqK08S0P/3+XCWsE7k/UWhRgVKntvz/W
0s0NKdJ999OS6aRVBbd2dBR+atmYTxkUIFVLthaEnOLibyn7Q61aaeW+ii1089jQ
KkhkZGtOSUxW2T/eQ4nSdPp3v9jx7bvkwjn936QwxiXiV22Dn8I0DunJ+VludUNP
ShXso1H636qZCrXlWi/zhAOvPSGOwjPb2U9nGbp9MzKP6Vgf0IHwswAUw88DhZkb
XtoM6KMRCFGCoHfSaP53npvUrTGaUKrgnzSPoBHEhpfbIPTIoCAY8rurqkETdh7O
zn1kYYIprYXgceHxN+CjFnmNINZxUaP2ol4zydBrtNffbyR30s9eJ/Wz616D1jWm
mm1ko4nXlDj69lMseLwPDYJLLvvFn9KDQICEvp2jEtQIAfv1KQkzbTG4PbasPh6J
WYMlMWJTmwEZwFFObif2L6oVCMqP1lVfPmx0OM1LVW9/YKw8QU55jFgvs3rKZppZ
7deuYa8k23Xf7tUWH25k8dW6MZ81BGU1KuoQH9Ll0szDlb33bBNwftO4CjDtpmyq
Z8bXuOfKEO3A4WnjNBUIUQDN8FK8QrT49s02BymFiAcTGm+MQutH5NA6/hWwOgiJ
xhg1U9zK2qIvfxXUaEDWOEXYkj01BzDbuLKAJYMfghpsJIhrUAg/u5w3WXPzJufs
bsnQQJ0zPdwPKEQVB/AN
=wxgR
-----END PGP SIGNATURE-----

--=-x8GaPyOvM2bU9Ys4p6yg--

