Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754762Ab2JOXKg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 19:10:36 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:59164 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754533Ab2JOXK2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 19:10:28 -0400
MIME-Version: 1.0
In-Reply-To: <507C955D.8030401@xenotime.net>
References: <507C955D.8030401@xenotime.net>
Date: Mon, 15 Oct 2012 19:10:27 -0400
Message-ID: <CADnq5_P6KLspN9nGuE7_-rd=Q=uAH_NMHtrSQ6TSf2MjJFMvSQ@mail.gmail.com>
Subject: Re: [PATCH resend] drm: radeon: fix printk format warnings
From: Alex Deucher <alexdeucher@gmail.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        dri-devel@lists.freedesktop.org, Dave Airlie <airlied@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Already partially fixed in:
http://cgit.freedesktop.org/~agd5f/linux/commit/?h=drm-fixes-3.7&id=a1871936c0f4f10850a5671c5deb1a92fcca1155
which is in my radeon -fixes pull request. But Luca's patch missed the
one in radeon_atpx_handler.c.  I can fix that one separately or Dave
can drop Luca's patch and pull in yours instead.

Alex

On Mon, Oct 15, 2012 at 6:59 PM, Randy Dunlap <rdunlap@xenotime.net> wrote:
> From: Randy Dunlap <rdunlap@xenotime.net>
>
> Fix printk format warnings in gpu/drm/radeon/:
>
> drivers/gpu/drm/radeon/radeon_atpx_handler.c:151:3: warning: format '%lu' expects type 'long unsigned int', but argument 2 has type 'size_t'
> drivers/gpu/drm/radeon/radeon_acpi.c:204:3: warning: format '%lu' expects type 'long unsigned int', but argument 2 has type 'size_t'
> drivers/gpu/drm/radeon/radeon_acpi.c:488:3: warning: format '%lu' expects type 'long unsigned int', but argument 2 has type 'size_t'
>
> Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
> Cc:     David Airlie <airlied@linux.ie>
> Cc:     dri-devel@lists.freedesktop.org
> ---
> Originally posted for linux-next, but now needed in mainline.
>
>  drivers/gpu/drm/radeon/radeon_acpi.c         |    4 ++--
>  drivers/gpu/drm/radeon/radeon_atpx_handler.c |    2 +-
>  2 files changed, 3 insertions(+), 3 deletions(-)
>
> --- lnx-37-rc1.orig/drivers/gpu/drm/radeon/radeon_atpx_handler.c
> +++ lnx-37-rc1/drivers/gpu/drm/radeon/radeon_atpx_handler.c
> @@ -148,7 +148,7 @@ static int radeon_atpx_verify_interface(
>
>         size = *(u16 *) info->buffer.pointer;
>         if (size < 8) {
> -               printk("ATPX buffer is too small: %lu\n", size);
> +               printk("ATPX buffer is too small: %zu\n", size);
>                 err = -EINVAL;
>                 goto out;
>         }
> --- lnx-37-rc1.orig/drivers/gpu/drm/radeon/radeon_acpi.c
> +++ lnx-37-rc1/drivers/gpu/drm/radeon/radeon_acpi.c
> @@ -201,7 +201,7 @@ static int radeon_atif_verify_interface(
>
>         size = *(u16 *) info->buffer.pointer;
>         if (size < 12) {
> -               DRM_INFO("ATIF buffer is too small: %lu\n", size);
> +               DRM_INFO("ATIF buffer is too small: %zu\n", size);
>                 err = -EINVAL;
>                 goto out;
>         }
> @@ -485,7 +485,7 @@ static int radeon_atcs_verify_interface(
>
>         size = *(u16 *) info->buffer.pointer;
>         if (size < 8) {
> -               DRM_INFO("ATCS buffer is too small: %lu\n", size);
> +               DRM_INFO("ATCS buffer is too small: %zu\n", size);
>                 err = -EINVAL;
>                 goto out;
>         }
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel
