Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751387Ab1LTGg5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 01:36:57 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:39581 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751196Ab1LTGgs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 01:36:48 -0500
Date: Tue, 20 Dec 2011 09:37:16 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Marcos Paulo de Souza <marcos.mage@gmail.com>
Cc: gregkh@suse.de, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] staging: vt6656: Remove useless function
Message-ID: <20111220063716.GH17353@mwanda>
References: <1324343247-28671-1-git-send-email-marcos.mage@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZYOWEO2dMm2Af3e3"
Content-Disposition: inline
In-Reply-To: <1324343247-28671-1-git-send-email-marcos.mage@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4EF02CFB.0096,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ZYOWEO2dMm2Af3e3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 20, 2011 at 01:07:27AM +0000, Marcos Paulo de Souza wrote:
>  /*
>   * Wireless Handler : get protocol name
>   */
> @@ -1936,7 +1921,6 @@ int iwctl_siwmlme(struct net_device *dev,
>  /*
>  static const iw_handler		iwctl_handler[] =3D
>  {
> -	(iw_handler) iwctl_commit,      // SIOCSIWCOMMIT

Nope.  This doesn't work.  It moves everything in the array to the
wrong position.  It should be replaced with NULL or better yet, the
whole array should be rewritten with like:

static const iw_handler iwctl_handler[] =3D {
	[SIOCGIWNAME]  =3D (iw_handler) iwctl_giwname,
	[SIOCGIWRANGE] =3D (iw_handler) iwctl_giwrange,
	...

The NULLs could be left out then.

>  	(iw_handler) iwctl_giwname,     // SIOCGIWNAME
>  	(iw_handler) NULL,				// SIOCSIWNWID
>  	(iw_handler) NULL,				// SIOCGIWNWID
> @@ -1998,7 +1982,7 @@ static const iw_handler		iwctl_handler[] =3D
> =20
>  static const iw_handler		iwctl_handler[] =3D
>  {
> -	(iw_handler) iwctl_commit,      // SIOCSIWCOMMIT
> +	(iw_handler) 0,      /* SIOCSIWCOMMIT */

This should be NULL not zero because it's a pointer.  (Style issue,
not a bug).

regards,
dan carpenter


--ZYOWEO2dMm2Af3e3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJO8C0bAAoJEOnZkXI/YHqRHfAP/ipi+2+wKkgTjs6HNk8CgUiH
705k1XR4S7ywS8OOOQ4Wf5yUULQj6cYE0Od09wFrtsxje4Vkzl7z+/ucQQ1qTRfn
6xhzkYi0D+JXPbtGcMNFBHSm8nI/FtugR3u0WvNTB10sPoP/RLCdu237z1ScThKI
+hBOhM2hfngP/IIg/SGqfxFqp8MPN0f2dSPFdqG2YyZZ5jH1XZYWgMxsRPSOJGIS
8KQDRnsrPBcihztH/n7KlhVkj/TUfo4gLFL1+SN+XZ2Zds/FH79U8c8tlCC87SZO
QVaE0HaiyVeqlh0VBpORVsaZmpZkfxo6M8yNMLHhyGOFw8UXMB7NLVJjl5U8R6sJ
4h9p0VpamW3hnVs9eidD6OzisCKLSB9rWz90tP5KPiuB1LLcafV8CzjujPbe9lrE
h+om6khJfVlmWM1UySmy+v+c9e8iZvVVHtQa5QDHwxEKuqRW9JxfgINYg5cYewOT
1hFYeVfXsbwbhJjACUQ8jK+uQbyvLLPN2u+wIUdn70Atw9MonUOal7Qdq3Gj3NWt
k/pdT+rLxJKol/0Dw4f7gn3C01qvZeUzbEirujLUyB5p349ZAertP2y739U7y2I+
pmqkMwjoWiqh/4GmtZ+RvdHKfpYN+hN2MeUeceA3PGT8IaaLIByALupQJPkIsLNv
PoMrHVz3712td47YoKXq
=3Shw
-----END PGP SIGNATURE-----

--ZYOWEO2dMm2Af3e3--
