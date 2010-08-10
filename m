Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757922Ab0HJUfe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 16:35:34 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:35485 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757843Ab0HJUfb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 16:35:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:date:x-google-sender-auth:message-id:subject
         :from:to:cc:content-type:content-transfer-encoding;
        b=G+jx3Un/WM2KJY9FZ3fdHC3OqewYVLzKlE8bQ2mK4n+sOEbtolS+eTyaFymF7q8y+N
         09wEzlsxvLkVRGGnJx08Z1wMOzK7fUsyThink/d+B/Hrk1o6MGRcEfH2C/8ipJ4FRXot
         ghRe48mSmHF2thyznMz4/srLU/CsHa61hz1aE=
MIME-Version: 1.0
Date: Tue, 10 Aug 2010 22:35:27 +0200
X-Google-Sender-Auth: bGFK_J5vsx-zVXAyhkVGidx3LGg
Message-ID: <AANLkTik44qbia+7w9=83cboTMLbvQDcH-60dHuAnd9ax@mail.gmail.com>
Subject: asm/vga.h (was: Re: drm: Add support for platform devices to register 
	as DRM devices)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: dri-devel@lists.freedesktop.org
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arch@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 6, 2010 at 01:59, Linux Kernel Mailing List
<linux-kernel@vger.kernel.org> wrote:
> Gitweb:     http://git.kernel.org/linus/dcdb167402cbdca1d021bdfa5f63995ee0a79317
> Commit:     dcdb167402cbdca1d021bdfa5f63995ee0a79317
> Parent:     01d73a6967f12fe6c4bbde1834a9fe662264a2eb
> Author:     Jordan Crouse <jcrouse@codeaurora.org>
> AuthorDate: Thu May 27 13:40:25 2010 -0600
> Committer:  Dave Airlie <airlied@redhat.com>
> CommitDate: Tue Jun 1 10:07:39 2010 +1000
>
>    drm: Add support for platform devices to register as DRM devices

> --- a/drivers/gpu/drm/Kconfig
> +++ b/drivers/gpu/drm/Kconfig
> @@ -6,7 +6,7 @@
>  #
>  menuconfig DRM
>        tristate "Direct Rendering Manager (XFree86 4.1.0 and higher DRI support)"
> -       depends on (AGP || AGP=n) && PCI && !EMULATED_CMPXCHG && MMU
> +       depends on (AGP || AGP=n) && !EMULATED_CMPXCHG && MMU

Since this change, I can enable DRM on m68k, but it fails with:

| In file included from drivers/gpu/drm/drm_irq.c:42:
| include/linux/vgaarb.h:34:21: error: asm/vga.h: No such file or directory

Now, do we really need <asm/vga.h>? It seems I can make it build and boot using:

--- a/include/linux/vgaarb.h
+++ b/include/linux/vgaarb.h
@@ -31,7 +31,9 @@
 #ifndef LINUX_VGA_H
 #define LINUX_VGA_H

+#ifdef CONFIG_VGA_ARB
 #include <asm/vga.h>
+#endif

 /* Legacy VGA regions */
 #define VGA_RSRC_NONE         0x00

Alternatively, I can provide an empty <asm/vga.h> (cfr. frv, mn10300,
parisc, sh)
or a simple (probably incorrect) one that includes <asm-generic/vga.h>
(cfr. microblaze).
But so far we never needed <asm/vga.h> on m68k.

For the record, this "problem" has been visible in linux-next (see
m68k/allmodconfig)
since July 9...

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
