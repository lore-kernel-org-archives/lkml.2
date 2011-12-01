Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754906Ab1LAPKO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 10:10:14 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:57497 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754817Ab1LAPKM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 10:10:12 -0500
Date: Thu, 1 Dec 2011 18:10:26 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Marcos Paulo de Souza <marcos.mage@gmail.com>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Forest Bond <forest@alittletooquiet.net>
Subject: Re: [PATCH 3/4] staging: vt6656: datarate.c: Remove unneeded comments
Message-ID: <20111201151026.GX3195@mwanda>
References: <1322699517-19721-1-git-send-email-marcos.mage@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="nSY6dmU9u4MMxp1o"
Content-Disposition: inline
In-Reply-To: <1322699517-19721-1-git-send-email-marcos.mage@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090205.4ED798C5.0028,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nSY6dmU9u4MMxp1o
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 01, 2011 at 12:31:57AM +0000, Marcos Paulo de Souza wrote:
> -    // clear statistic counter for auto_rate
> -    for (ii =3D 0; ii <=3D MAX_RATE; ii++) {
> -        psNodeDBTable->uTxOk[ii] =3D 0;
> -        psNodeDBTable->uTxFail[ii] =3D 0;
> -    }
> +	/* clear statistic counter for auto_rate */
> +	for (ii =3D 0; ii <=3D MAX_RATE; ii++)
> +		psNodeDBTable->uTxOk[ii] =3D psNodeDBTable->uTxFail[ii] =3D 0;
>  }
> =20

Don't do that...  Better to have the assignments on separate lines.

If you wanted, you could use memset and get rid of the loop.

void s_vResetCounter(PKnownNodeDB psNodeDBTable)
{
	memset(psNodeDBTable->uTxOk, 0, sizeof(psNodeDBTable->uTxOk));
	memset(psNodeDBTable->uTxFail, 0, sizeof(psNodeDBTable->uTxFail));
}

regards,
dan carpenter

--nSY6dmU9u4MMxp1o
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJO15jiAAoJEOnZkXI/YHqRTBoQAILIyVu+yNjb7+/NLnUqkLmv
OfQqp0XlyDFzyGybcgvVpGPSweM43Jza9WSA+20sdpbD/xEVbkxNkqAGHhb1qkGC
HSjxeNZK8bLoTLMBDmgflb7Qkf0XzFjxK5B2GxhBvuPrK542BRmWJfd6z9Xz21Sa
qg89eqlhEGeQWPfZpPXsgaNyPSP03SHiWy3M3xTdEg1ldxWbAgs1Gp9MhCGbAbKS
euBg+E3oSmvBECG9BlewjRRCJikgNTwdVvK+/NgSeXD2IhK/F6U1WnQcDOXa902o
BHhTnNd7W9XPQx1v4FEwlQQZU7c2v+1UXu9Lk2HUpQ/0hy71iPeEjJgvMJn4B8jh
cxPNa/2HF0mDHn33yevrBKl8wpWvdS0wrcnsXANGtfaOljawPTK7HgpD48YStwva
hePBwWji7VJYbAJhE64vdLjAMRFjwH3IBmhi8uDBuZshNC1oJ762eemR7yQ9NkDY
JRND/F7mvZ6axO/mRKU6A6n+cH+jssM9iK2JywHl1gKX6IJkBnnQIl5fKHxsgucd
h/W6wpmk4hx4NK0PHRQbBgaGEsFA0CCc79xYbyQfNQm894H337ZkCB9btAOFmibe
Ql6wJj5s318e+m0o8DlE315LBEtIC7ERu+kjiGTL5iY5HoJrQlfyXgOLtNt+c5Z3
oDdIhP7QyDmqWEmihYiN
=Avjl
-----END PGP SIGNATURE-----

--nSY6dmU9u4MMxp1o--
