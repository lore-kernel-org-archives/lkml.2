Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751124Ab3AFGy3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2013 01:54:29 -0500
Received: from ozlabs.org ([203.10.76.45]:40927 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750854Ab3AFGy0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2013 01:54:26 -0500
Date: Sun, 6 Jan 2013 14:58:09 +1100
From: David Gibson <david@gibson.dropbear.id.au>
To: Pantelis Antoniou <panto@antoniou-consulting.com>
Cc: Jon Loeliger <jdl@jdl.com>, Matt Porter <mporter@ti.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>, Russ Dill <Russ.Dill@ti.com>
Subject: Re: Fix test relying in wrong behavior of is_printable
Message-ID: <20130106035809.GG4674@truffula.fritz.box>
References: <1357326968-13124-1-git-send-email-panto@antoniou-consulting.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="uc35eWnScqDcQrv5"
Content-Disposition: inline
In-Reply-To: <1357326968-13124-1-git-send-email-panto@antoniou-consulting.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--uc35eWnScqDcQrv5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 04, 2013 at 09:16:08PM +0200, Pantelis Antoniou wrote:
> After fixing the is_printable bug the test suite fails.
> Fix it with this patch
>=20
> Signed-off-by: Pantelis Antoniou <panto@antoniou-consulting.com>

Rather than just removing the test, it would be better to still run it
using an explicit -t bi to force the byte output.

> ---
>  tests/run_tests.sh | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
>=20
> diff --git a/tests/run_tests.sh b/tests/run_tests.sh
> index dd7f217..43279c9 100755
> --- a/tests/run_tests.sh
> +++ b/tests/run_tests.sh
> @@ -498,9 +498,8 @@ fdtget_tests () {
> =20
>      # run_fdtget_test <expected-result> [<flags>] <file> <node> <propert=
y>
>      run_fdtget_test "MyBoardName" $dtb / model
> -    run_fdtget_test "77 121 66 111 \
> -97 114 100 78 97 109 101 0 77 121 66 111 97 114 100 70 97 109 105 \
> -108 121 78 97 109 101 0" $dtb / compatible
> +    # run_fdtget_test "77 121 66 111 97 114 100 78 97 109 101 0 77 121 6=
6 111 97 114 100 70 97 109 105 108 121 78 97 109 101 0" $dtb / compatible
> +    run_fdtget_test "MyBoardName MyBoardFamilyName" $dtb / compatible
>      run_fdtget_test "MyBoardName MyBoardFamilyName" -t s $dtb / compatib=
le
>      run_fdtget_test 32768 $dtb /cpus/PowerPC,970@1 d-cache-size
>      run_fdtget_test 8000 -tx $dtb /cpus/PowerPC,970@1 d-cache-size

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--uc35eWnScqDcQrv5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlDo9lEACgkQaILKxv3ab8ZmUgCeP/8Qz1gsx65ab1jcBo5j3otO
Uc4Anio37VIVkH4oI4FfX2QBAtKWHH1f
=342s
-----END PGP SIGNATURE-----

--uc35eWnScqDcQrv5--
