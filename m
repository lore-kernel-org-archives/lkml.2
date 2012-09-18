Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756718Ab2IRGIO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 02:08:14 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:51427 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755817Ab2IRGIM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 02:08:12 -0400
Date: Tue, 18 Sep 2012 08:08:06 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Tushar Behera <tushar.behera@linaro.org>
Cc: linux-kernel@vger.kernel.org, sachin.kamat@linaro.org, patches@linaro.org
Subject: Re: [PATCH v4] pwm: Fix compilation error when CONFIG_PWM is not
 defined
Message-ID: <20120918060806.GA1459@avionic-0098.mockup.avionic-design.de>
References: <1347444106-30509-1-git-send-email-tushar.behera@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="y0ulUmNC+osPPQO6"
Content-Disposition: inline
In-Reply-To: <1347444106-30509-1-git-send-email-tushar.behera@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:N64CBy3aTG0T/enLc2NizFSkkXSuHj76eP5TjK0/Mey
 zQqTBwsNpq8trmXNaNB3LkyfSrYekqC+fNGfVFooyLpXLRu0St
 8kdfdSt1CM3e+xtOIyigj6/u1oCNX8rkdFqisdYvVx71XX4mv1
 IvXN0ZQfTkWdFB+CkmEd+hApS7G0d2Bi8ze50dX0bkGk9MK5YT
 tKJrCKMOR1CY0GRnrrjnBRPxAFlr9mlFGu5hf9TVH9CnNi3Wax
 6YB+NteBSFKIHmTRvMBn7ow9lMuOdjnY/bFrr91On5cBRAGHt9
 VmTses8VVGXBIHqvtdKC+Vpd3RrA5XXYfkQ8Mm9z/92V4om69U
 wFTAls6XpaYlHA8CfHemJauImudY2rNxc1YYN+aBNNZpn6HyBn
 SI7xTiTLSqOEMxgOHCS8fs7AO0Lj96qH0M=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--y0ulUmNC+osPPQO6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 12, 2012 at 03:31:46PM +0530, Tushar Behera wrote:
> Add dummy implemention of public symbols for compilation-safe inclusion
> of include/linux/pwm.h file when CONFIG_PWM is not defined.
>=20
> Reported-by: Sachin Kamat <sachin.kamat@linaro.org>
> Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
> ---
> Changes since v3:
> * Nitpicks
>=20
> Changes since v2:
> * #if condition for legacy functions modified
> * Reverted layout changes, can be taken up when HAVE_PWM is no longer
> required.
>=20
> Changes since v1:
> * Incorporated Thierry's suggestions regarding adding dummy function
> implemention for all global functions
> * Reorganized header file to have structure definitions first and then the
> function definitions.
>=20
>  include/linux/pwm.h |   71 +++++++++++++++++++++++++++++++++++++++++++++=
++++-
>  1 files changed, 69 insertions(+), 2 deletions(-)

Okay, I've applied this to my for-next branch, with some minor changes.
For one I had to merge it with Alex's managed functions patch. Second I
changed all dummy functions that return a struct pwm_device * to return
ERR_PTR(-ENODEV) instead of NULL because PWM users typically check for
IS_ERR(pwm) and not for NULL.

Thierry

--y0ulUmNC+osPPQO6
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQWA/GAAoJEN0jrNd/PrOh97kP/0JhYhBH8YxqnEv6a/tBeCI/
LgEX6J7iMqMNzIlxvrDu7RwatBKl/cVHctbpQXbXwKwNsMqNhngwzHNNL+DJYlzA
hcNm5IbOp83/rmH9y8/TpQU5w/jdHOVGg+VBNJEpx6ALElKw0q2iRmVDloVFT9hM
EwPuf5fhNqEETmNV2l01ZjhzsdaHTeplerV+qc1WpzS7lASscvzurDz1DwcusE6D
8hGnSTihSY57oy2c3NRyfHAnvo6x7Ly8F5IUXczlsp1lFA7BBxthBWsZRG3nYsv0
k6e8rfUiErFDBZZn4dWFinrGH5ISg3TAS1/luy3+FlzbqpdaqRikiibwMDkDLy2X
Kho5cpimbcNdr407TEhI0OnWruDlymfvj9cYBtI3lDrB0QPRDrcV42r4TTOnrYZf
d8acnZj03jlkmfGUOITwwRVBROlAOnuOvSSxuGZTd7mZzoSJV7VzdqapCnv4+UEQ
zZ+1fIvYMYbv/1gcuA7hjApbYrv+YjUZY4JWkCguN7xw70LET8yqJlaU0w7VDkc7
T8kG1ne57PETwrkFdv3/3t8csW1kK/9fyO7ZrM+wm1nJZldOnjklQSRHZRZRHVQi
eO3IDOaICLV+h75maZqy2CsxzTkZwyXlOWllrmaOXy5WMWXZbbVbmAkHrBEMiydA
G5oGh9MBqubm0VRurE12
=r0wi
-----END PGP SIGNATURE-----

--y0ulUmNC+osPPQO6--
