Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758292Ab1DMKh0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 06:37:26 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:58440 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758202Ab1DMKhZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 06:37:25 -0400
Date: Wed, 13 Apr 2011 12:37:55 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Alan Cox <alan@linux.jf.intel.com>
Cc: greg@kroah.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] gma500: Add a gtt allocator
Message-ID: <20110413103755.GA14017@avionic-0098.adnet.avionic-design.de>
References: <20110413093519.28527.36552.stgit@localhost.localdomain>
 <20110413093624.28527.33558.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="AqsLC8rIMeq19msA"
Content-Disposition: inline
In-Reply-To: <20110413093624.28527.33558.stgit@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:n91OCLwKJYGcAZzYvSsDqTqvsXjTCPcH8nHkNK2+HBP
 9CzjZ+vWydGZy7JaNtu61T6Z9yfYqJnPllraFd+NpuMCtuVIDm
 YHow0zIV5XTTr5DVweu7GXiRCUtw/+kNAjtGDmOPnk02EKwa6f
 pT+5X8nP8Ahr1/oIookyXKuFOqNwu3+RAvYQknSdUDKEt5If94
 HcGlzsHTH1c6hnXBp3UhdwvPqmOg722xizf57OsDktXzKSv4d6
 zUzl79PQY2yOz
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--AqsLC8rIMeq19msA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

* Alan Cox wrote:
> At the moment we don't do any page backing for the GTT so only the stolen
> area pages will actually work. That is fine for our initial framebuffer a=
nd
> a bit of testing but will need resolution (including alternate mmap metho=
ds
> and the like for s/g areas) eventually.
>=20
> Rather than use some of the overcomplex stuff in the DRM we use the exist=
ing
> Linux resource allocators to hand out framebuffers and the like. This als=
o has
> the nice result that /proc/iomem shows the allocations.
>=20
> Signed-off-by: Alan Cox <alan@linux.intel.com>
> ---
>=20
>  drivers/staging/gma500/psb_drv.h |   16 +++-
>  drivers/staging/gma500/psb_fb.c  |   32 +++++---
>  drivers/staging/gma500/psb_fb.h  |   13 +--
>  drivers/staging/gma500/psb_gtt.c |  155 ++++++++++++++++++++++++++++++++=
++++++
>  drivers/staging/gma500/psb_gtt.h |   30 ++++++-
>  5 files changed, 217 insertions(+), 29 deletions(-)
>=20
> diff --git a/drivers/staging/gma500/psb_drv.h b/drivers/staging/gma500/ps=
b_drv.h
> index c3609e0..7a0506a 100644
> --- a/drivers/staging/gma500/psb_drv.h
> +++ b/drivers/staging/gma500/psb_drv.h
> @@ -21,6 +21,7 @@
>  #define _PSB_DRV_H_
> =20
>  #include <linux/version.h>
> +#include <linux/kref.h>
> =20
>  #include <drm/drmP.h>
>  #include "drm_global.h"
> @@ -228,6 +229,7 @@ struct psb_intel_opregion {
>  	int enabled;
>  };
> =20
> +

Gratuitous newline?

Thierry

--AqsLC8rIMeq19msA
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk2lfQMACgkQZ+BJyKLjJp/77ACeIDz9wrzxzFAjO2HHBlFnzrQz
DRsAn17i3qBvDi+f2yJunfA95U+0YD9i
=cgzP
-----END PGP SIGNATURE-----

--AqsLC8rIMeq19msA--
