Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756837Ab1INPg0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 11:36:26 -0400
Received: from smp.if.uj.edu.pl ([149.156.82.206]:35986 "EHLO smp.if.uj.edu.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755509Ab1INPgZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 11:36:25 -0400
Date: Wed, 14 Sep 2011 17:36:19 +0200
From: Witold Baryluk <baryluk@smp.if.uj.edu.pl>
To: Michel =?iso-8859-1?Q?D=E4nzer?= <michel@daenzer.net>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: Re: [BUG] drm/radeon: locking problems with page_flip
Message-ID: <20110914153619.GN23706@smp.if.uj.edu.pl>
References: <20110913034955.GJ23706@smp.if.uj.edu.pl>
 <1315906152.17617.24.camel@thor.local>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=_smp.if.uj.edu.pl-24004-1316014581-0001-2"
Content-Disposition: inline
In-Reply-To: <1315906152.17617.24.camel@thor.local>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_smp.if.uj.edu.pl-24004-1316014581-0001-2
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 09-13 11:29, Michel D=E4nzer wrote:
> On Die, 2011-09-13 at 05:49 +0200, Witold Baryluk wrote:=20
> >=20
> > I yeasterday discovered pretty nasty issue in radeon / drm code,
> > and page_flip locking code on my ThinkPad T43.
>=20
> Does the patch below fix the problem?
>=20
>=20
> From ed7cf809c4fb737fa486b24004ee47056bf0e797 Mon Sep 17 00:00:00 2001
> From: =3D?UTF-8?q?Michel=3D20D=3DC3=3DA4nzer?=3D <michel.daenzer@amd.com>
> Date: Thu, 8 Sep 2011 17:36:22 +0200
> Subject: [PATCH] drm/radeon: Unreference GEM object outside of spinlock
>  in page flip error path.
> MIME-Version: 1.0
> Content-Type: text/plain; charset=3DUTF-8
> Content-Transfer-Encoding: 8bit
>=20
> Should fix https://bugzilla.redhat.com/show_bug.cgi?id=3D726277 .
>=20
> Signed-off-by: Michel D=E4nzer <michel.daenzer@amd.com>
> ---
>  drivers/gpu/drm/radeon/radeon_display.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>=20
> diff --git a/drivers/gpu/drm/radeon/radeon_display.c b/drivers/gpu/drm/ra=
deon/radeon_display.c
> index 6cc17fb..6adb3e5 100644
> --- a/drivers/gpu/drm/radeon/radeon_display.c
> +++ b/drivers/gpu/drm/radeon/radeon_display.c
> @@ -473,8 +473,8 @@ pflip_cleanup:
>  	spin_lock_irqsave(&dev->event_lock, flags);
>  	radeon_crtc->unpin_work =3D NULL;
>  unlock_free:
> -	drm_gem_object_unreference_unlocked(old_radeon_fb->obj);
>  	spin_unlock_irqrestore(&dev->event_lock, flags);
> +	drm_gem_object_unreference_unlocked(old_radeon_fb->obj);
>  	radeon_fence_unref(&work->fence);
>  	kfree(work);
> =20
> --=20
> 1.7.5.4

Hi,

unfortunetly I cannot reproduce problem with or without patch.
Will do more stress testing and wait until something happens.


--=20
Witold Baryluk
JID: witold.baryluk // jabster.pl

--=_smp.if.uj.edu.pl-24004-1316014581-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk5wyfIACgkQ7ZLFFOttZ4J8JQCcDRYKqEcByeBJxyuDDIEO+JDh
7zkAoMumBN1LR5DPK4wTlJCBN+sD3UqE
=qN2a
-----END PGP SIGNATURE-----

--=_smp.if.uj.edu.pl-24004-1316014581-0001-2--
