Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757326Ab3AIHr2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 02:47:28 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:54507 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755884Ab3AIHr1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 02:47:27 -0500
Date: Wed, 9 Jan 2013 08:47:09 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Tony Prisk <linux@prisktech.co.nz>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        vt8500-wm8505-linux-kernel@googlegroups.com
Subject: Re: [PATCHv2 1/2] pwm: vt8500: Register write busy test performed
 incorrectly
Message-ID: <20130109074709.GC12782@avionic-0098.adnet.avionic-design.de>
References: <1357155856-9552-1-git-send-email-linux@prisktech.co.nz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3siQDZowHQqNOShm"
Content-Disposition: inline
In-Reply-To: <1357155856-9552-1-git-send-email-linux@prisktech.co.nz>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:5VqRfxe7WdsXKYP5A1Hz4hSv7RUMWpiNF4IkXOu+7IO
 RuXbyatS3fFUr1O1OJJIk0tcpDOeamGe6+aDD6bF297as1MbjO
 CYTwHnwXTCoKnQX826JQAESxhWJShrez5hW+Sm0+6nh6BhPd35
 oqSOd8+5Z6SenyCbolMynTHLVwSDPQ+TzO6OIgJDrbuSdeeuMo
 HrxV8LXy31xHsf9xXRnrli9Jg1kdJUz9/MhBOcX+u/XMjAg8qi
 MwlVhX7ozbE893PdfkgbflS7fZGpi7STf/YMMrGIBkO0MlLXuV
 cOzwgQT3a/Jbv0qhUnIXXCDqhKPHaJBLabUa77wjaQTMaQmWLq
 nHhZvPTnLBetaJbKPFREArNaUsZ2KgZiaBBSSEXlrFpwE5r+Pa
 gu2EDpNfEZ3OOabOKh/78MiI9ljunukIeY=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--3siQDZowHQqNOShm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 03, 2013 at 08:44:15AM +1300, Tony Prisk wrote:
> Correct operation for register writes is to perform a busy-wait
> after writing the register. Currently the busy wait it performed
> before, meaning subsequent register writes to bitfields may occur
> before the previous field has been updated.
>=20
> Also, all registers are defined as 32-bit read/write. Change
> pwm_busy_wait() to use readl rather than readb.
>=20
> Improve readability of code with defines for registers and bitfields.
>=20
> Signed-off-by: Tony Prisk <linux@prisktech.co.nz>
> ---
> v2:
> Change parenthesis around defines
> Replace pr_warn with dev_warn in pwm_busy_wait()
>=20
>  drivers/pwm/pwm-vt8500.c |   64 +++++++++++++++++++++++++++++++++++-----=
------
>  1 file changed, 49 insertions(+), 15 deletions(-)

Applied, thanks.

Thierry

--3siQDZowHQqNOShm
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQ7SB9AAoJEN0jrNd/PrOhYVEP/iuGEqL2QFdUqQdbCVKQDsi2
NySR0qLbUXwQhUX52Trk/NTA+7pKGBBbIi0JftcZZc/ir/V5v0s5HaRqizMMirMt
z1evwZf6J5cq5FJAj6hVlihpHbMcJsbdQuO8UwFuIg/AS9uOjdiUQrS2Cat7DW08
wu7tdyEMnWisRGeS49tTvpnDjr7qe+t9hYD+HFoZCqH+BlyeQnImFmSZ/4UR9Rvw
th2xBl/gzdTw17adlqy17G+Re0B9N7EzD6ZFOhF18zkOHrFD+a/z3qMMEiP2Xyg7
ovwtDbeZprIgDMOjARB+wudxvr3BSSGMNyBeRbFsjwnVtz0aPYOmjz0ZlAc433Vb
ZPmZk8X2GdeqjufGp/MJGsGULqweOxW9Q2DdJ9MV9KXBsyI2kVp8fCyefwNbcEMp
Psal61e1PSAapgWflvlik8Puc7/XjA5lYyp16TrcQpInd6dpaHlmW4aDaDOW3jRv
fYR4gN4KFIVEyhje7By0z7hx2au46OMWWoH3toUdIO5TRewJh0k+MYftnwFMmNSs
3OF+cl3VaJeWa6lfy9xj9rbjvyhf8UFgth5kA/Oe6l9bYL6tsEz87qrFWFzJvkx3
84WoJrf4O+8wyt+f8pN4taqhSON4KnmQskcu2pCe99vsGx5oSqW3TXNF6NNDZLzB
ME5xVj8IhMOyBIjsyQUk
=E2n0
-----END PGP SIGNATURE-----

--3siQDZowHQqNOShm--
