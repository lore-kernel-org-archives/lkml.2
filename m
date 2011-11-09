Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933077Ab1KIVAO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 16:00:14 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:25375 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932781Ab1KIVAN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 16:00:13 -0500
Date: Thu, 10 Nov 2011 00:00:56 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Tresca Agustin <treskita@gmail.com>
Cc: gregkh@suse.de, wfp5p@virginia.edu, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] I checked with chechpatch.pl the archive in
 drivers/staging/bcm/CmHost.c , and cleanup the Errors and warnings, I didn't
 change any function, only code style.
Message-ID: <20111109210056.GV4751@mwanda>
References: <1320710143-2675-1-git-send-email-a.tresca@hotmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vy3x0i7GCC7mAH4A"
Content-Disposition: inline
In-Reply-To: <1320710143-2675-1-git-send-email-a.tresca@hotmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4EBAE9D4.0034,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--vy3x0i7GCC7mAH4A
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Tresca,

Welcome.  :)

1) This patch combines way too many things into one patch.  Only do
one logical thing per patch.

2) When you're writing the changelog write a one line summary at the
top, leave a blank line, and then write the changelog.  You didn't
have the summary so the Subject of the email was messed up.

3) No signed-off-by line.

On Mon, Nov 07, 2011 at 08:55:43PM -0300, Tresca Agustin wrote:
> From: Tresca Agustin <atresca@atresca-system.(none)>
                        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
The email address is wrong here.

>
> ---
>  drivers/staging/bcm/CmHost.c | 3794 ++++++++++++++++++++++++------------=
-----
>  1 files changed, 2221 insertions(+), 1573 deletions(-)
>=20
> diff --git a/drivers/staging/bcm/CmHost.c b/drivers/staging/bcm/CmHost.c
> index c0ee95a..8819c52 100644
> --- a/drivers/staging/bcm/CmHost.c
> +++ b/drivers/staging/bcm/CmHost.c
> @@ -4,18 +4,17 @@
>  *	Management.
>  ************************************************************/
> =20
> -//#define CONN_MSG
> +/*#define CONN_MSG*/
>  #include "headers.h"
> =20
> -typedef enum _E_CLASSIFIER_ACTION
> -{
> -	eInvalidClassifierAction,
> -	eAddClassifier,
> -	eReplaceClassifier,
> -	eDeleteClassifier
> -}E_CLASSIFIER_ACTION;
> +enum _E_CLASSIFIER_ACTION {
> +	eInvalidClsfrAction,
> +	eAddClsfr,
> +	eRplcClsfr,
> +	eDelClsfr
> +}; /*_E_CLASSIFIER_ACTION*/

These names are even worse than the original.

> =20
> -static ULONG GetNextTargetBufferLocation(PMINI_ADAPTER Adapter,B_UINT16 =
tid);
> +static ULONG GetNextTargetBufferLocation(PMINI_ADAPTER Adapter, B_UINT16=
 tid);
> =20
>  /************************************************************
>  * Function	  -	SearchSfid
> @@ -24,18 +23,18 @@ static ULONG GetNextTargetBufferLocation(PMINI_ADAPTE=
R Adapter,B_UINT16 tid);
>  *				specified SFID as input parameter.
>  *
>  * Parameters  -	Adapter: Pointer to the Adapter structure
> -*			   	uiSfid : Given SFID for matching
> +*				uiSfid : Given SFID for matching
>  *
>  * Returns	  - Queue index for this SFID(If matched)
>  				Else Invalid Queue Index(If Not matched)
>  ************************************************************/
> -INT SearchSfid(PMINI_ADAPTER Adapter,UINT uiSfid)
> +INT SearchSfid(PMINI_ADAPTER Adapter, UINT uiSfid)
>  {
> -	INT 	iIndex=3D0;
> -	for(iIndex=3D(NO_OF_QUEUES-1); iIndex>=3D0; iIndex--)
> -		if(Adapter->PackInfo[iIndex].ulSFID=3D=3DuiSfid)
> +	INT iIndex =3D 0;

blank line goes here.
INT should be changed to "int"
No need to initialize iIndex.

> +	for (iIndex =3D (NO_OF_QUEUES - 1); iIndex >=3D 0; iIndex--)
> +		if (Adapter->PackInfo[iIndex].ulSFID =3D=3D uiSfid)
>  			return iIndex;

But curly braces around multi-line indent blocks for style reasons
even though it's not needed for semantic reasons.

> -	return NO_OF_QUEUES+1;
> +	return NO_OF_QUEUES + 1;

Anyway, this whole thing needs to be broken up into smaller logical
patches and resent.  Like maybe change fix add spaces around the
operators in one patch or something like that.  Fix one class of
checkpatch.pl warning at a time.

Don't worry that your first patch was not accepted.  Everyone's first
patch gets rejected.  :P

regards,
dan carpenter


--vy3x0i7GCC7mAH4A
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJOuuoIAAoJEOnZkXI/YHqRP9kQAIwKttqmF8nm+ZzIMDKztDMO
E0tUQGIJ1oOOjBnRmNyoBovMSlc7hlaGX0HJexUOET1y6BWqz9v4oaoAM2PlYDn5
A1GtcOFjSq0jkAa9wjwokNdOogwmhPGmdFMeyay4lcxgns5ajYMumlPmrM+Q69KD
pxw6IW8xBHkrNWYSKmgoW0NJt1LpXkuwTDQaqO2YuLsNM3dOzEJ9/v+mn8KE/hb8
zDR/PvD8rkgk/bRu4I2W/Zbd/N7w4gmYOyfdKvjdEwRWcFyA0MQ9Pqr3CkwrWWGy
YBKqmSGDz5b1/C3cI7MYyF5Lb5/b+Oe3QTaKU8y9TlQQsEPL9+c7Pwyu6cTDmkEZ
T28p271RwsBg4aX9ECUZ9meru34OvRg/OzB8JSXGM4KLP6GJtywJbptd2YQoPCLP
afGYjC9wiR4fK9ZSgVmM4jgZf9iJpdx6Q7mQO0WJzlRps1rfaPdgKwdDdLnviqGm
8NrtrLIGmzCSlwUXARZNg04+EnZfKpSnEEXeX48fdrljYpA+Owv1i3bETXrcWuSH
wM2WQRuaVt75qem6pme5eZS4ZjGKewCsE40Mc/UqiP7WMfHNFjXE8uAThaP9eK4m
j6OM1quF0ap2cgvBSdTU3WyT6SBoIni6etTrZqazfDsMe9p7k4NLa3OCtY/mYA6N
dAUSeC0bzNbZjiNRWzT6
=ctB3
-----END PGP SIGNATURE-----

--vy3x0i7GCC7mAH4A--
