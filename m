Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754702Ab2AaQgZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 11:36:25 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:64085 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754013Ab2AaQgX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 11:36:23 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Samuel Thibault <samuel.thibault@ens-lyon.org>
Subject: Re: [PATCH] Fix KDFONTOP 32bit compatibility layer
Date: Tue, 31 Jan 2012 16:35:36 +0000
User-Agent: KMail/1.12.2 (Linux/3.3.0-rc1; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, "Greg Kroah-Hartman" <gregkh@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arthur Taylor <art@ified.ca>, Jiri Slaby <jslaby@suse.cz>,
        Jiri Olsa <jolsa@redhat.com>
References: <20120128232858.GA18484@type.famille.thibault.fr>
In-Reply-To: <20120128232858.GA18484@type.famille.thibault.fr>
MIME-Version: 1.0
Content-Type: Text/Plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-Id: <201201311635.36367.arnd@arndb.de>
X-Provags-ID: V02:K0:jFJd5KTVAiGk308LTO6UjhRODEL4lMOEoGZUpcA7HRE
 RGyphc0BZMmvgb0SoNUq2W26KEwu0JZPiZQfWUPerKIp4ksT+W
 Aw9qktUyxQVfms+HsU0SGYBuiPBwvji9ZqAEilvrC+JFkevl3A
 0hGbfMIZyoRkH/MwQHCo5KNmGRuYJ+MXrqgpECM5DZjh3Bgv9L
 2OOjziMD4AtDftCDIkkJV82IHrFulam/vMD6j9QDhxVw1FsRkb
 +l3eFOEE4lgRPJxAGGQbBDDfsrD+E+ruHuZA9wj5IZvh1M9p/1
 XO2yQ2SPE9/vopGq/5E3L/kdHvEFgSxr8S/UUocty+dmTPl2Uh
 Ql7llWd+y0PGBZ7p5Mi8=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 28 January 2012, Samuel Thibault wrote:
> KDFONTOP(GET) currently fails with EIO when being run in a 32bit
> userland with a 64bit kernel if the font width is not 8. This is because
> the compatibility layer introduced by e9216651 forces the addition of
> the KD_FONT_FLAG_OLD flag, which makes con_font_get return EIO in such
> case.  This flag should not be set for KDFONTOP, since it's actually
> the whole point of this flag (see comment in con_font_set for instance).
> 
> Signed-off-by: Samuel Thibault <samuel.thibault@ens-lyon.org>

Hmm, this flag was not introduced in the patch you cite, it used to
live in fs/compat_ioctl.c before that, since before the start of the
git history. It seems to date back on the original sparc64 implementation
of do_kdfontop_ioctl that was written by Eddie Dost in 1998.

> diff --git a/drivers/tty/vt/vt_ioctl.c b/drivers/tty/vt/vt_ioctl.c
> index 5e096f4..65447c5 100644
> --- a/drivers/tty/vt/vt_ioctl.c
> +++ b/drivers/tty/vt/vt_ioctl.c
> @@ -1463,7 +1463,6 @@ compat_kdfontop_ioctl(struct compat_console_font_op __user *fontop,
>         if (!perm && op->op != KD_FONT_OP_GET)
>                 return -EPERM;
>         op->data = compat_ptr(((struct compat_console_font_op *)op)->data);
> -       op->flags |= KD_FONT_FLAG_OLD;
>         i = con_font_op(vc, op);
>         if (i)
>                 return i;

>From all I can tell, the patch looks correct, but please update the
description so you don't blame my innocent patch ;-)

Reviewed-by: Arnd Bergmann <arnd@arndb.de>
