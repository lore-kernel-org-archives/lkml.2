Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932377Ab1FVSND (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 14:13:03 -0400
Received: from home.keithp.com ([63.227.221.253]:37013 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932243Ab1FVSNC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 14:13:02 -0400
From: Keith Packard <keithp@keithp.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>,
        Alan Stern <stern@rowland.harvard.edu>
Cc: Kernel development list <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: Re: Oops in i915 intel_init_clock_gating
In-Reply-To: <20110615133256.113293a0@jbarnes-desktop>
References: <Pine.LNX.4.44L0.1106151555400.1650-100000@iolanthe.rowland.org> <20110615133256.113293a0@jbarnes-desktop>
User-Agent: Notmuch/0.5-202-g6ae4e7d (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Wed, 22 Jun 2011 11:12:51 -0700
Message-ID: <yun4o3h68gs.fsf@aiko.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Wed, 15 Jun 2011 13:32:56 -0700, Jesse Barnes <jbarnes@virtuousgeek.org>=
 wrote:

> diff --git a/drivers/gpu/drm/i915/i915_drv.c b/drivers/gpu/drm/i915/i915_=
drv.c
> index 0defd42..a1a28fb 100644
> --- a/drivers/gpu/drm/i915/i915_drv.c
> +++ b/drivers/gpu/drm/i915/i915_drv.c
> @@ -429,6 +429,9 @@ static int i915_drm_thaw(struct drm_device *dev)
>  	/* KMS EnterVT equivalent */
>  	if (drm_core_check_feature(dev, DRIVER_MODESET)) {
>  		mutex_lock(&dev->struct_mutex);
> +
> +		intel_init_clock_gating(dev);
> +
>  		dev_priv->mm.suspended =3D 0;
>=20=20
>  		error =3D i915_gem_init_ringbuffer(dev);
> diff --git a/drivers/gpu/drm/i915/i915_suspend.c b/drivers/gpu/drm/i915/i=
915_suspend.c
> index 60a94d2..b478d16 100644
> --- a/drivers/gpu/drm/i915/i915_suspend.c
> +++ b/drivers/gpu/drm/i915/i915_suspend.c
> @@ -863,8 +863,6 @@ int i915_restore_state(struct drm_device *dev)
>  		I915_WRITE(IMR, dev_priv->saveIMR);
>  	}
>=20=20
> -	intel_init_clock_gating(dev);
> -
>  	if (IS_IRONLAKE_M(dev)) {
>  		ironlake_enable_drps(dev);
>  		intel_init_emon(dev);
>=20

I haven't seen any comments as to whether this patch needs to be merged
into the kernel. Has anyone tested this?

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFOAjCjQp8BWwlsTdMRAtSrAJ9gPxv1FoxrUZY3M9dYDQDn3eqOBwCgok8E
Rtx2ZIlvbXsSqfwS87k7P44=
=Rj5S
-----END PGP SIGNATURE-----
--=-=-=--
