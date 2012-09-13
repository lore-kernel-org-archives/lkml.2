Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758041Ab2IMM3M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 08:29:12 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:47171 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758019Ab2IMM3I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 08:29:08 -0400
Date: Thu, 13 Sep 2012 22:29:05 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Shaohua Li <shli@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Rik van Riel <riel@redhat.com>
Subject: Re: linux-next: build failure after merge of the final tree (akpm
 tree related)
Message-Id: <20120913222905.e12e268186f2ba0b1a30c3ed@canb.auug.org.au>
In-Reply-To: <20120913100136.GA12929@kernel.org>
References: <20120913180121.7ef388cab4e6af2b8c52c93e@canb.auug.org.au>
	<20120913100136.GA12929@kernel.org>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__13_Sep_2012_22_29_05_+1000_VWXAcPVuQcpyYY=9"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__13_Sep_2012_22_29_05_+1000_VWXAcPVuQcpyYY=9
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, 13 Sep 2012 18:01:36 +0800 Shaohua Li <shli@kernel.org> wrote:
>
> Index: linux/arch/microblaze/include/asm/atomic.h
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux.orig/arch/microblaze/include/asm/atomic.h	2012-09-13 17:56:54.2=
06807900 +0800
> +++ linux/arch/microblaze/include/asm/atomic.h	2012-09-13 17:57:18.202506=
238 +0800
> @@ -9,7 +9,7 @@
>   * Atomically test *v and decrement if it is greater than 0.
>   * The function returns the old value of *v minus 1.
>   */
> -static inline int atomic_dec_if_positive(atomic_t *v)
> +static inline int __atomic_dec_if_positive(atomic_t *v)
>  {
>  	unsigned long flags;
>  	int res;
> @@ -22,5 +22,6 @@ static inline int atomic_dec_if_positive
> =20
>  	return res;
>  }
> +#define atomic_dec_if_positive __atomic_dec_if_positive

You could just do

#define atomic_dec_if_positive	atomic_dec_if_positive

without renaming the function.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__13_Sep_2012_22_29_05_+1000_VWXAcPVuQcpyYY=9
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQUdGRAAoJEECxmPOUX5FEjxAP/1LMj8gtzWdt/OAzaHIcYnsU
UZST/XCgBdfrRFhHiNzFQaXD3yujMoSh9SGCE31cAepdvqkHum1wBjaONO4rqvro
GjelX7vaT/Ajks8CsSDfmdyNCllOSwuTmu0v7CbyulWe4UPfePgD110cGUvxxdeU
bSDNHDaVfvcFSySSTW/frQfZJxgdBlu+sHcA8koKFrnHMO6UhPMc6x7zU/Np0tHd
7ZDOmxVRu7SpFuXNmAChYUcYRE+M9xEwN2qfjqVcJNwt++JenV4gRsE4yX7LMPfx
A0KH/BA08rM35ZDlg/AEbIku03Qa7lwUGL62grx9fWZpZWgmONf0W6IBCpA1sCPY
9CDPOiZmDdNQ0aKg6dxQ2nO/4xDGEIjHZAKZIhcmf2G5Kr3z+Fjx3fJb4q2AZlGp
k2Gez83ukOYa8w7mi5oURursTRMvhF7OT1234p8fPpSYlmSFHabemTD/VJxurHo8
N+SKWLSqUASKB5Jk94sYRei83yU+TBpE9vE/AZ1og9CLpFchuvurrdluVLU0GlKX
mtdtPCxBOf4jkNn6+gT5CDesaPUOxjlN7mIq8ce3THRPApSyh7A3QeQJEsPSnC1r
qroPimcwWKtUaHBCN1HPkmWS2/b6nqdSpPwupyMy7zYFswKkFH58I0lLvcHVD14k
VUQmCUrupiEGLzoEA2LN
=qJG8
-----END PGP SIGNATURE-----

--Signature=_Thu__13_Sep_2012_22_29_05_+1000_VWXAcPVuQcpyYY=9--
