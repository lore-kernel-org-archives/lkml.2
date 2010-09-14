Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754174Ab0INNW2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 09:22:28 -0400
Received: from mx1.riseup.net ([204.13.164.18]:54581 "EHLO mx1.riseup.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754079Ab0INNWU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 09:22:20 -0400
From: Francisco Jerez <currojerez@riseup.net>
To: Phil Turmel <philip@turmel.org>
Cc: linux-kernel@vger.kernel.org, Ben Skeggs <bskeggs@redhat.com>,
        Matthew Garrett <mjg@redhat.com>, David Airlie <airlied@linux.ie>,
        Marcin =?utf-8?Q?Ko=C5=9Bcielnicki?= <koriakin@0x04.net>,
        Dave Airlie <airlied@redhat.com>, dri-devel@lists.freedesktop.org
Subject: Re: [PATCH] nouveau build regression, undefined reference to `acpi_video_get_edid'
References: <4C89ABC3.8080701@turmel.org>
Date: Tue, 14 Sep 2010 15:21:57 +0200
In-Reply-To: <4C89ABC3.8080701@turmel.org> (Phil Turmel's message of "Thu, 09
	Sep 2010 23:53:39 -0400")
Message-ID: <87hbhslatm.fsf@riseup.net>
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

Phil Turmel <philip@turmel.org> writes:

> Hi all,
>
> I've got a build breakage on my laptop:
>
> drivers/built-in.o: In function `nouveau_acpi_edid':
> (.text+0x13404e): undefined reference to `acpi_video_get_edid'
> make: *** [.tmp_vmlinux1] Error 1
>
> Introduced by:
>
> a6ed76d7ffc62ffa474b41d31b011b6853c5de32 is the first bad commit
> commit a6ed76d7ffc62ffa474b41d31b011b6853c5de32
> Author: Ben Skeggs <bskeggs@redhat.com>
> Date:   Mon Jul 12 15:33:07 2010 +1000
>
>     drm/nouveau: support fetching LVDS EDID from ACPI
>
>     Based on a patch from Matthew Garrett.
>
>     Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
>     Acked-by: Matthew Garrett <mjg@redhat.com>
>
> :040000 040000 2fbe9b4d9778329908107e72c11b100c2f5a460b 97dcf06923bb57629=
8746584c45d17d3be9edcf8 M      drivers
>
> It doesn't seem to revert cleanly, but I believe the problem lies in these
> two config entries:
>
> CONFIG_ACPI=3Dy
> CONFIG_ACPI_VIDEO=3Dm
>
> Having the nouveau ACPI features depend on CONFIG_ACPI_VIDEO instead of
> bare CONFIG_ACPI builds, boots, and works for me.
>
nouveau_acpi_edid() is the only function that depends on ACPI_VIDEO,
ifdef'ing out the rest of the ACPI stuff in that case doesn't make much
sense to me.

> Signed-off-by: Philip J. Turmel <philip@turmel.org>
> ---
>
> Presumably, this could also be solved by adding
> "select ACPI_VIDEO if ACPI" to the nouveau Kconfig.
> I'd be happy to try that, if this approach is flawed.
>
> diff --git a/drivers/gpu/drm/nouveau/Makefile b/drivers/gpu/drm/nouveau/M=
akefile
> index e9b06e4..4e295b5 100644
> --- a/drivers/gpu/drm/nouveau/Makefile
> +++ b/drivers/gpu/drm/nouveau/Makefile
> @@ -28,6 +28,6 @@ nouveau-y :=3D nouveau_drv.o nouveau_state.o nouveau_ch=
annel.o nouveau_mem.o \
>  nouveau-$(CONFIG_DRM_NOUVEAU_DEBUG) +=3D nouveau_debugfs.o
>  nouveau-$(CONFIG_COMPAT) +=3D nouveau_ioc32.o
>  nouveau-$(CONFIG_DRM_NOUVEAU_BACKLIGHT) +=3D nouveau_backlight.o
> -nouveau-$(CONFIG_ACPI) +=3D nouveau_acpi.o
> +nouveau-$(CONFIG_ACPI_VIDEO) +=3D nouveau_acpi.o
>=20=20
>  obj-$(CONFIG_DRM_NOUVEAU)+=3D nouveau.o
> diff --git a/drivers/gpu/drm/nouveau/nouveau_drv.h b/drivers/gpu/drm/nouv=
eau/nouveau_drv.h
> index b1be617..bd995b4 100644
> --- a/drivers/gpu/drm/nouveau/nouveau_drv.h
> +++ b/drivers/gpu/drm/nouveau/nouveau_drv.h
> @@ -842,7 +842,7 @@ extern int  nouveau_dma_wait(struct nouveau_channel *=
, int slots, int size);
>=20=20
>  /* nouveau_acpi.c */
>  #define ROM_BIOS_PAGE 4096
> -#if defined(CONFIG_ACPI)
> +#if defined(CONFIG_ACPI_VIDEO)
>  void nouveau_register_dsm_handler(void);
>  void nouveau_unregister_dsm_handler(void);
>  int nouveau_acpi_get_bios_chunk(uint8_t *bios, int offset, int len);

--=-=-=--

--==-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iF4EAREIAAYFAkyPdvcACgkQg5k4nX1Sv1v9hAD9FljtarkF3pYi8HK2wnUmdEQH
K+f+QWdhc0fvna8z+bAA/0eOPdU8hsIKDzDhsz/1fTnreIsut2xyTgd65S2cqolp
=vTZE
-----END PGP SIGNATURE-----
--==-=-=--
