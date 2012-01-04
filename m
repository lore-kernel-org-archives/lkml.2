Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756581Ab2ADRT6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 12:19:58 -0500
Received: from oproxy4-pub.bluehost.com ([69.89.21.11]:47350 "HELO
	oproxy4-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756483Ab2ADRT4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 12:19:56 -0500
Date: Wed, 4 Jan 2012 09:19:52 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Neil Horman <nhorman@tuxdriver.com>
Cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        bhelgaas@google.com, gregkh@suse.de, linux-pci@vger.kernel.org
Subject: Re: [PATCH] msi: fix imbalanced refcount of msi irq sysfs objects
Message-ID: <20120104091952.7cc5316d@jbarnes-desktop>
In-Reply-To: <20120103185304.GA25184@hmsreliant.think-freely.org>
References: <1325604594-7184-1-git-send-email-nhorman@tuxdriver.com>
	<20120103.130526.2034128205205666131.davem@davemloft.net>
	<20120103185304.GA25184@hmsreliant.think-freely.org>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/1Vqa4dJz8UxEG_iHcKX_iUV"; protocol="application/pgp-signature"
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/1Vqa4dJz8UxEG_iHcKX_iUV
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 3 Jan 2012 13:53:05 -0500
Neil Horman <nhorman@tuxdriver.com> wrote:

> On Tue, Jan 03, 2012 at 01:05:26PM -0500, David Miller wrote:
> > From: Neil Horman <nhorman@tuxdriver.com>
> > Date: Tue,  3 Jan 2012 10:29:54 -0500
> >=20
> > > This warning was recently reported to me:
> >=20
> > I've hit this too, see:
> >=20
> > http://marc.info/?l=3Dlinux-kernel&m=3D132458146927890&w=3D2
> >=20
> > and my analysis at:
> >=20
> > http://marc.info/?l=3Dlinux-arch&m=3D132458391128660&w=3D2
> >=20
> Yup, your analysis is correct. Regardless of the why behind msi enablement
> failing, we need to gate the kobject_del/put in free_msi_irqs on successf=
ul
> completion of kobject_init_and_add in populate_msi_sysfs.  This patch doe=
s that,
> using the parent pointer as a flag.

I applied this to my -next branch; doesn't seem critical to land
immediately.  If you disagree let me know and I'll pull it over to my
for-linus branch instead.

Thanks,
--=20
Jesse Barnes, Intel Open Source Technology Center

--Sig_/1Vqa4dJz8UxEG_iHcKX_iUV
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAEBAgAGBQJPBIo4AAoJEIEoDkX4Qk9hQ18P/3i5bDiYE+/yGMQ1Zxhj3kRn
l4926/3uvUUGiJ5U2viOwDLtcSEhqYLnOMpVc0pFFt+BmjzxKpdmvLFFDjBim1dn
crBxQej0DGdd3s5lSepBYfzXoqK4ALhWSo3j1gRtp3ToJyhOaNGJVDK9SvjoBY1t
1xGwfY/SkXblDVC2/4dP+UpCbKZh+H+hM97vinMM9iyHwYFLM7yCMU25/+KRlVpQ
q2D7CMHqDg2Aw/cJo6PVUOSItJtYZ3h64Z/jykyJFxvU/93WOZ10dmN5nB1HU/Zq
Qr6N+fqi9krZ0rA53aRxaGDutfXD20KgskQRBusoVVdKw2EvKtJ0aMCwg1SVvVtg
CuQbqg/4DsvFoyBLQOpfiXf62cZlk3nlD98EL9sOVJDa+bVg2Pas2Y64GfGyQvdu
nKm6gi2+LIsJQgCENFCZbyxMEG/5GclOQdJBwiJA2MAiUXKl8xxfOSKJ9Sy57W9I
3PQGn3GXDKBF/oUIY+cD3lUEL72tFQiKttaizfpPfB1Z/PJ6yiJgTMRoUHVB7RUE
xW7u+5SGkl/QnUe+Z/EjxF3Qwx1x/Pd66ggUhHJeWOxyLzqLRIgkWvYv+ZHzTjmJ
OoQm1Lbhtm0Pj/YoQZ6R0iM2FEDDtynbYnFirJI2b3leZWE8j2qhUxGNZsWUCKh0
7YwBxo9JBn6h3+h4U5++
=tyuR
-----END PGP SIGNATURE-----

--Sig_/1Vqa4dJz8UxEG_iHcKX_iUV--
