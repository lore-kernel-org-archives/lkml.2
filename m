Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759720Ab1LOXBx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 18:01:53 -0500
Received: from na3sys009aog123.obsmtp.com ([74.125.149.149]:36277 "EHLO
	na3sys009aog123.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759667Ab1LOXBw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 18:01:52 -0500
Date: Fri, 16 Dec 2011 01:01:46 +0200
From: Felipe Balbi <balbi@ti.com>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Felipe Balbi <balbi@ti.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        Jarkko Nikula <jarkko.nikula@bitmer.com>, stable@vger.kernel.org,
        Hema Kalliguddi <hemahk@ti.com>
Subject: Re: [PATCH] usb: musb: fix pm_runtime mismatch
Message-ID: <20111215230143.GA2090@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1323988934-11350-1-git-send-email-felipe.contreras@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="T4sUOijqQbZv57TR"
Content-Disposition: inline
In-Reply-To: <1323988934-11350-1-git-send-email-felipe.contreras@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--T4sUOijqQbZv57TR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Dec 16, 2011 at 12:42:14AM +0200, Felipe Contreras wrote:
> In musb_init_controller() there's a pm_runtime_put(), but there's no
> pm_runtime_get(), which creates a mismatch that causes the driver to
> sleep when it shouldn't.
>=20
> This was introduced in 7acc619, but it wasn't triggered until 18a2689
> was merged to Linus' branch at point 6899608.

you need to add the commit description (whatever was the mail's subject)
here too. And you should put in Cc the author or those commits too,
otherwise we can't poke into their brains to understand what they were
thinking when they originally wrote those patches.

> However, it seems most of the time this is used in a way that keeps the
> counter above 0, so nobody noticed. Also, it seems to depend on the
> configuration used.
>=20
> I found the problem by loading isp1704_charger before any usb gadgets:
> http://article.gmane.org/gmane.linux.kernel/1226122
>=20
> All versions after 2.6.39 are affected.
>=20
> Cc: stable@vger.kernel.org
> Signed-off-by: Felipe Contreras <felipe.contreras@gmail.com>
> ---
>  drivers/usb/musb/musb_core.c |    2 --
>  1 files changed, 0 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/usb/musb/musb_core.c b/drivers/usb/musb/musb_core.c
> index b63ab15..920f04e 100644
> --- a/drivers/usb/musb/musb_core.c
> +++ b/drivers/usb/musb/musb_core.c
> @@ -2012,8 +2012,6 @@ musb_init_controller(struct device *dev, int nIrq, =
void __iomem *ctrl)
>  	if (status < 0)
>  		goto fail3;
> =20
> -	pm_runtime_put(musb->controller);

To me the real fix would be add the missing pm_runtime_get_sync(). On
probe() we're actually accessing MUSB's address space which needs it's
clocks turned on. I guess it's only working now by chance, probably
because glue layer calls pm_runtime_get_sync() to access it's own
address space and that uses the same clocks.

Hema, since this was introduced by a patch of yours, care to check this
patch ? You _do_ say on your original commit that pm_runtime_get_sync()
is called during probe, but you're not doing so. Was that just a mistake
on the original commit ?

--=20
balbi

--T4sUOijqQbZv57TR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJO6nxXAAoJEIaOsuA1yqRERD4P/3WXxrGlFp66QPHeaJVak+pb
aG1KRDXdHvEmzWhJ8ciYHS9pOWsVWOWlPcMqWSFoTYni4vfX+68LwxouQI3QOk4v
bO3ef7e6iyurPfpgvX7vtU08TtJz7+ZrbQmm1f+14id8z4Cir8GopINZn+wfjtf9
uOugCjsinhulYdehjxvrQ7CHXWy5gjObbS59PY0aiRWuEn3LUd7wof43/MItPhfK
f+9sa+w50X8V6j/spFNTpObBqxEj8oWl/gNALajtP3j5Ni+/p6JemGBhwQkTYQQy
jzpRB5hZw7TVbjrkGvt4TIn0wwacJDgPNptUNdhmQzjIvNLvp3NubzBp4NtRFOPK
FANXui03gha+JnRHCxK6BaC0bZOCnS2f7LXIBDjvu3Lj19f5WyuGF7yhTiCJxJPw
XkMpaWLKTy9WyJPmp3PZq32kBur2MOi7f/T/PuTQ/+qUv76VuXB0KDZhm3k+Aqj2
qnNmt+mUAoKWm60bdRXPKmXNktZJlmf0Z03rt/if6XrI4+c2RiiYeW4YWh/npoug
WmAQNRArOSlmj5eM6rlqGrKAaRIdzhJA39h5Kz7+S+9OsbwdtItnXlTEn0xU4Woi
sxqmYJtF6pgCUKfRbZz3LE3PYA15HadHsf6kNJ0CqWowkQpcPJehYMKJG4IAv0zG
FBEKMrj5wQa5D6BqFk8w
=vS/E
-----END PGP SIGNATURE-----

--T4sUOijqQbZv57TR--
