Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753331Ab2EZNy3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2012 09:54:29 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:62370 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751593Ab2EZNy2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2012 09:54:28 -0400
Message-ID: <1338040464.2525.38.camel@koala>
Subject: Re: [PATCH] mtd: dc21285.c: handle nw_gpio_lock correctly
From: Artem Bityutskiy <dedekind1@gmail.com>
To: Christian Dietrich <christian.dietrich@informatik.uni-erlangen.de>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        vamos-dev@lists.cs.fau.de
Date: Sat, 26 May 2012 16:54:24 +0300
In-Reply-To: <20120525082812.GA12238@faui49q.informatik.uni-erlangen.de>
References: <20120525082812.GA12238@faui49q.informatik.uni-erlangen.de>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-gFP5b7tVR8t/h+tIbSOf"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-gFP5b7tVR8t/h+tIbSOf
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2012-05-25 at 10:28 +0200, Christian Dietrich wrote:
> nw_gpio_lock is a raw_spinlock_t, therefore raw_spin_lock_irqsave should =
be
> used. it doesn't make a difference, while rlock is the first element of
> spinlock_t.
>=20
> Also the check for machine_is_netwinder() is a double check of
> CONFIG_ARCH_NETWINDER.
>=20
> Signed-off-by: Christian Dietrich <christian.dietrich@informatik.uni-erla=
ngen.de>

I do not understand this commit message. Please, split your patch on 2
patches and put a better to each one. Thanks!

> ---
>  drivers/mtd/maps/dc21285.c |   13 +++++--------
>  1 files changed, 5 insertions(+), 8 deletions(-)
>=20
> diff --git a/drivers/mtd/maps/dc21285.c b/drivers/mtd/maps/dc21285.c
> index 080f060..38fbf23 100644
> --- a/drivers/mtd/maps/dc21285.c
> +++ b/drivers/mtd/maps/dc21285.c
> @@ -38,9 +38,9 @@ static void nw_en_write(void)
>  	 * we want to write a bit pattern XXX1 to Xilinx to enable
>  	 * the write gate, which will be open for about the next 2ms.
>  	 */
> -	spin_lock_irqsave(&nw_gpio_lock, flags);
> +	raw_spin_lock_irqsave(&nw_gpio_lock, flags);

Please, make this to be a separate patch.

And surely there are many other places in the kernel which need this
conversion?

>  static void dc21285_write8(struct map_info *map, const map_word d, unsig=
ned long adr)
>  {
> -	if (machine_is_netwinder())
> -		nw_en_write();
> +	nw_en_write();
>  	*CSR_ROMWRITEREG =3D adr & 3;

I do not understand why this "if" statement is not needed? Why it was
there in the first place and why you remove it? Please, describe this in
the commit message.

--=20
Best Regards,
Artem Bityutskiy

--=-gFP5b7tVR8t/h+tIbSOf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJPwOCQAAoJECmIfjd9wqK0DdAP/R5armRIrJ40XiESi68SUCgK
IjZxX5/JtUG8ux0zElinfYAgyfjjd/8/BpJkDY0337q0fvDq4tr5DHbvWR4yEqso
e2nIzB5u106f1wVPwCB5xOASEEOVcWmNSMRoJ7/Go5K+HVRGbWrO+QXaklHTZI+C
q5H4mlOuDXiQQsLyS8Z2ADTzI6lD40090tL7HDlD2a6bv0sVaAFwUmfLRrR0nWEN
C0nQv0R4TsNnlJ73KjTvo+sbPXqzXYx7OLmsW39QSemeIIdlciEfJ2DQGO0GbYEo
I9pfIO7fL4AoTb5ZZejVf13TuQwGoe7J0GEkuAKYVX71tuaCLdh5OKq3pPNKKFHT
9UFXiZ6eTEyEXm7/BybsHTSH7NcoQkPrqGOWMhZNcuTY9m+PNlDYYUHSxYKh4WBf
G5281nu7pMpcdVrCxVgFI+UmAOWdEeEj1VFKQxgt3Ns5ribX5/20bd5qghUKiSJB
7nBr9ZjkRU+kNa1Y9rBwE7Cz4jXsio5z+UDQa7kEb+4bTynRN+zd28tXRVDXT1Eg
Z1Bj65ckw7EMqoLhgGcz0KSf4HGPA87kwPjYtVIY5qC5Ksrm0EYM/mDBgUGLW1Wa
pYjUnDEJdf1ZQIZ/IAGcT/5bblsUfioyFC/TaRG+TD0BlyBl/TLMcacodmc3+Nsn
G8cGKDzxb4EFbN8ftoLc
=oL7u
-----END PGP SIGNATURE-----

--=-gFP5b7tVR8t/h+tIbSOf--

