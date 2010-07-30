Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758525Ab0G3LwA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 07:52:00 -0400
Received: from mx1.riseup.net ([204.13.164.18]:52605 "EHLO mx1.riseup.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752544Ab0G3Lv7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 07:51:59 -0400
X-Greylist: delayed 1080 seconds by postgrey-1.27 at vger.kernel.org; Fri, 30 Jul 2010 07:51:59 EDT
From: Francisco Jerez <currojerez@riseup.net>
To: Kulikov Vasiliy <segooon@gmail.com>
Cc: kernel-janitors@vger.kernel.org, David Airlie <airlied@linux.ie>,
        Ben Skeggs <bskeggs@redhat.com>, Dave Airlie <airlied@redhat.com>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drm: nouveau: set TASK_(UN)INTERRUPTIBLE before schedule_timeout()
References: <1280132635-7961-1-git-send-email-segooon@gmail.com>
Date: Fri, 30 Jul 2010 13:31:49 +0200
In-Reply-To: <1280132635-7961-1-git-send-email-segooon@gmail.com> (Kulikov
	Vasiliy's message of "Mon, 26 Jul 2010 12:23:54 +0400")
Message-ID: <87pqy5dx3u.fsf@riseup.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="==-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==-=-=
Content-Type: multipart/mixed; boundary="=-=-="

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Kulikov Vasiliy <segooon@gmail.com> writes:

> set_current_state() is called only once before the first iteration.
> After return from schedule_timeout() current state is TASK_RUNNING. If
> we are going to wait again, set_current_state() must be called.
>
> Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
> ---
>  drivers/gpu/drm/nouveau/nouveau_fence.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
>
Thanks, I've pushed this patch to the Nouveau kernel tree.

> diff --git a/drivers/gpu/drm/nouveau/nouveau_fence.c b/drivers/gpu/drm/no=
uveau/nouveau_fence.c
> index 813d853..b7777ae 100644
> --- a/drivers/gpu/drm/nouveau/nouveau_fence.c
> +++ b/drivers/gpu/drm/nouveau/nouveau_fence.c
> @@ -186,7 +186,6 @@ nouveau_fence_wait(void *sync_obj, void *sync_arg, bo=
ol lazy, bool intr)
>  	unsigned long timeout =3D jiffies + (3 * DRM_HZ);
>  	int ret =3D 0;
>=20=20
> -	__set_current_state(intr ? TASK_INTERRUPTIBLE : TASK_UNINTERRUPTIBLE);
>=20=20
>  	while (1) {
>  		if (nouveau_fence_signalled(sync_obj, sync_arg))
> @@ -197,6 +196,8 @@ nouveau_fence_wait(void *sync_obj, void *sync_arg, bo=
ol lazy, bool intr)
>  			break;
>  		}
>=20=20
> +		__set_current_state(intr ? TASK_INTERRUPTIBLE
> +			: TASK_UNINTERRUPTIBLE);
>  		if (lazy)
>  			schedule_timeout(1);

--=-=-=--

--==-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iF4EAREIAAYFAkxSuCYACgkQg5k4nX1Sv1vadwD9FqBG3qG4YT1xRtBLXTV247+B
CBR5DUsiwWuW+liC6rYBAJsea9gomnt1TvoYoHAZm8pKr+WYi0nK8kIsjCx1XxyK
=p9i6
-----END PGP SIGNATURE-----
--==-=-=--
