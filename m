Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751348Ab1LTLii (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 06:38:38 -0500
Received: from na3sys009aog102.obsmtp.com ([74.125.149.69]:33051 "EHLO
	na3sys009aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750755Ab1LTLid (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 06:38:33 -0500
Date: Tue, 20 Dec 2011 13:38:25 +0200
From: Felipe Balbi <balbi@ti.com>
To: Felipe Contreras <felipe.contreras@nokia.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap <linux-omap@vger.kernel.org>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Jarkko Nikula <jarkko.nikula@bitmer.com>,
        Felipe Contreras <felipe.contreras@gmail.com>, stable@vger.kernel.org,
        Hema HK <hemahk@ti.com>
Subject: Re: [PATCH v2] usb: musb: fix pm_runtime mismatch
Message-ID: <20111220113823.GJ31842@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1324324914-14584-1-git-send-email-felipe.contreras@nokia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9aCKuHbn5v2q3RVc"
Content-Disposition: inline
In-Reply-To: <1324324914-14584-1-git-send-email-felipe.contreras@nokia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--9aCKuHbn5v2q3RVc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 19, 2011 at 10:01:54PM +0200, Felipe Contreras wrote:
> From: Felipe Contreras <felipe.contreras@gmail.com>
>=20
> In musb_init_controller() there's a pm_runtime_put(), but there's no
> pm_runtime_get(), which creates a mismatch that causes the driver to
> sleep when it shouldn't.
>=20
> This was introduced in 7acc619[1], but it wasn't triggered in my setup
> until 18a2689[2] was merged to Linus' branch at point df0914[3]. IOW;
> when PM is working as it was supposed to.
>=20
> However, it seems most of the time this is used in a way that keeps the
> counter above 0, so nobody noticed. Also, it seems to depend on the
> configuration used in versions before 3.1, but not later (or in it).
>=20
> I found the problem by loading isp1704_charger before any usb gadgets:
> http://article.gmane.org/gmane.linux.kernel/1226122
>=20
> All versions after 2.6.39 are affected.
>=20
> [1] usb: musb: Idle path retention and offmode support for OMAP3
> [2] OMAP2+: musb: hwmod adaptation for musb registration
> [3] Merge branch 'omap-for-linus' of git://git.kernel.org/pub/scm/linux/k=
ernel/git/tmlind/linux-omap-2.6
>=20
> Cc: stable@vger.kernel.org
> Cc: Hema HK <hemahk@ti.com>
> Signed-off-by: Felipe Contreras <felipe.contreras@gmail.com>

applied, thanks

--=20
balbi

--9aCKuHbn5v2q3RVc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJO8HOvAAoJEIaOsuA1yqRERB4P/08Mx+ZByh3INWPzHPztXiLM
3FSz3inIRYde+VZqB0DUDp50JxpgT1hvvpl1kuxHBXHv9glfsUX9G2cdHXXSl9VM
KlOwcb/7dFo6Xq18PK5+ff5Vwy5eIXSxRg4DnK/iWpHVo/KT2S4zeEpma3dwxlmI
I39ANSwvJUGwhQA6uoEEtJsG4TJFOPf5fYvyw9FCOnV2M8m+tKh5kcJBEnYB/yhG
FQo6ZMFitvqXD7xAjpa633KvHFoTqhG8jAyMo7iV7owcs5VA2hhmwB8P+cowbT5K
8qIOhE3z7dT20DYRdIB1Bf9v/zgEc8jr53Po5PJ4Dl04aOOfGXr3QTZRBOULPTWt
Wjc5uEHLxg58rJyJ73SQMsAS0643iRaE1CVanirT80PQOV05y1VNKMvuKzjzVMyN
VpfnAxkyxpBj93C7/A3SUpm5PQ93BKIukmO0SoZFSFQJIJ/1off2ZjmfMyDCdpRo
PmAWe+8NV+k3LnNw+8f1jK2Jk6iMer7Sw8XmZIRaB9c/zp2PIupF+S3MNN2F5EbH
eUU4xgSpPj39xh/BJMf7a04MMZf4w/K01KtH8a6ufdBHlcY98bdCxqKUuKuyDF3K
Ih6o9lZxZ5UCZWAWGeYT/B/rg/Ovogo3/7UVv+YyhXG7gzD016UrX3jr7UwLadVg
FRSN89jmHYKWW8JEhAF9
=X3Ra
-----END PGP SIGNATURE-----

--9aCKuHbn5v2q3RVc--
