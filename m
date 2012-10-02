Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755406Ab2JBU2x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 16:28:53 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:60592 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755103Ab2JBU2v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 16:28:51 -0400
Date: Tue, 2 Oct 2012 22:28:35 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, Kukjin Kim <kgene.kim@samsung.com>,
        Stephen Warren <swarren@nvidia.com>,
        Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        arm@kernel.org, Thomas Abraham <thomas.abraham@linaro.org>
Subject: Re: [PATCH 11/12] pinctrl: samsung: use __devinit section for init
 code
Message-ID: <20121002202835.GA31446@avionic-0098.mockup.avionic-design.de>
References: <1348868177-21205-1-git-send-email-arnd@arndb.de>
 <1348868177-21205-12-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="d6Gm4EdcadzBjdND"
Content-Disposition: inline
In-Reply-To: <1348868177-21205-12-git-send-email-arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:hFcoWe28i9o1swcaD+XeAwWKHB63v1gECBMMpl6y12W
 KLne3oj6bgyVuzbYLgf2E65O9o+RjU6by4KCK0ScPZeUrKT8in
 TrdA0snKOUuKOV4CgMeY2eWwHn74K9fnvTgxwNvVdgIaGGQ4Id
 0o/+ACgH/bhBWTnEhxmNm1NXQ7sjKqhpgmgY9fRL4MexTtZb68
 DqyxMuuzEANm4Bxw2VP4ujUwPzuALZc3Rf/bYEoRLctSz9sMcp
 ztul3nEKJ8mnQi4GBy8DtUaiLd/oG8+Tyuw6dDDmXI/GuwmaWV
 OvhUyIrrC2x6XEiNvO7xSJR2SDnwbXEX91GtEed34EuTzgXCPu
 ktqcrDNm1yItaUrsecswQdeFU2zwO7nNdO6AzzuHaqweCIYA2M
 QdQbTAxSmn5ZTHShU6MQnrdHW/OMhSM+CnTdf8Z97bay29fdoI
 sCzN7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--d6Gm4EdcadzBjdND
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 28, 2012 at 11:36:16PM +0200, Arnd Bergmann wrote:
> The samsung pinctrl driver has a probe function that is
> __devinit and that calls a lot of other functions that are
> marked __init, which kbuild complains about.
>=20
> Marking everything __devinit means that the code does not
> discarded when CONFIG_HOTPLUG is set, which is a little
> more wasteful, but also more consistent
>=20
> Without this patch, building exynos_defconfig results in:
>=20
> WARNING: drivers/pinctrl/built-in.o(.devinit.text+0x124): Section mismatc=
h in reference from the function samsung_pinctrl_probe() to the function .i=
nit.text:samsung_gpiolib_register()
> The function __devinit samsung_pinctrl_probe() references
> a function __init samsung_gpiolib_register().
> If samsung_gpiolib_register is only used by samsung_pinctrl_probe then
> annotate samsung_gpiolib_register with a matching annotation.

Note that work is underway to remove HOTPLUG altogether (see commit
45f035a, "CONFIG_HOTPLUG should be always on" in linux-next), so it
may make more sense to just drop the __init markings.

Thierry

--d6Gm4EdcadzBjdND
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQa05zAAoJEN0jrNd/PrOhZ5gP/3hgMjNUEIC6ptBiKdblR5r4
qg9mggjtL+F/3oDi/UwirbyYHE9fEog9BJS92aY+VpOOVvUmOXkjaz6ien6kdvSC
i/ke7CxCQS1CSDZf5Dgi9WyU7pt6tyOWaBL2AlGmnKcAnKIPKSjVuU/V5BnqSDax
Gy/v9uVvtxGqAsAaO6naij6m6FSL/kzQ2Ic3z7eJ/PRJTu/G4PO6DgsiGu1X3xzy
VZjt7XH3FRzZMzwRC19hFN5EFkU0ti43Kt+dwY1+Efv4EwsOeWMYmDcdxYOE1Cuq
RkUWMwOhdpDlRS1wSF/p5Z/jFQl3GzBH22yxwoWLvVzcNGSjGj3ySPuzk1KWKkir
WnSCdnrlAgx6zIanU0UaVwn44PsuGzmsoqqEdHtNwTaHiC1lSPhRAcP05PkcaTsp
ccwWLkQ7tguLifni+6xi9vRCQMdSswLBdpbNLPLXng+BkfMgM1jcA+12rq23jyCK
5rRAY/DXCH0n91RePpu5/Uw2OvRsiLPJg3FeGsFXuuSCSzMUa6WBZJ+06IguBjOW
ldYBYTAkgKaJzKhu7kdfvdHF8HrwIbQjz7Vz4UVLzmwpoF3G5/GsQDTvkhC/Xmk2
qw6pDcrJGbVIaUW/uaEHec93HUdH5R5BTNbcCHi9/43GgPdIW1//zR+l/3ldgVZR
O5avLD/jL5Um4ihuOKYU
=bXKI
-----END PGP SIGNATURE-----

--d6Gm4EdcadzBjdND--
