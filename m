Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752822Ab0LWVoM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Dec 2010 16:44:12 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:61993 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752111Ab0LWVoK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Dec 2010 16:44:10 -0500
Date: Thu, 23 Dec 2010 14:44:06 -0700
From: Grant Likely <grant.likely@secretlab.ca>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Michal Marek <mmarek@suse.cz>, linux-arch@vger.kernel.org,
        linux-kbuild@vger.kernel.org, microblaze-uclinux@itee.uq.edu.au,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        dirk.brandewie@gmail.com, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH 1/4] of: Add support for linking device tree blobs into
 vmlinux
Message-ID: <20101223214405.GG20384@angua.secretlab.ca>
References: <1293047849-26078-1-git-send-email-dirk.brandewie@gmail.com>
 <1293047849-26078-2-git-send-email-dirk.brandewie@gmail.com>
 <4D127D72.8050303@suse.cz>
 <AANLkTik-yqs2Dy+MBAcQ5Gpb9Vcvd80BS=C=fuDe7z-A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTik-yqs2Dy+MBAcQ5Gpb9Vcvd80BS=C=fuDe7z-A@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 23, 2010 at 07:14:20AM +0100, Geert Uytterhoeven wrote:
> 2010/12/22 Michal Marek <mmarek@suse.cz>:
> > On 22.12.2010 20:57, dirk.brandewie@gmail.com wrote:
> >>
> >> From: Dirk Brandewie<dirk.brandewie@gmail.com>
> >>
> >> This patch adds support for linking device tree blob(s) into
> >> vmlinux. Modifies asm-generic/vmlinux.lds.h to add linking
> >> .dtb sections into vmlinux. To maintain compatiblity with the of/fdt
> >> driver code platforms MUST copy the blob to a non-init memory location
> >> before the kernel frees the .init.* sections in the image.
> >>
> >> Modifies scripts/Makefile.lib to add a kbuild command to
> >> compile DTS files to device tree blobs and a rule to create objects to
> >> wrap the blobs for linking.
> >>
> >> STRUCT_ALIGNMENT is defined in vmlinux.lds.h for use in the rule to
> >> create wrapper objects for the dtb in Makefile.lib.  The
> >> STRUCT_ALIGN() macro in vmlinux.lds.h is modified to use the
> >> STRUCT_ALIGNMENT definition.
> >>
> >> The DTB's are placed on 32 byte boundries to allow parsing the blob
> >> with driver/of/fdt.c during early boot without having to copy the blob
> >> to get the structure alignment GCC expects.
> >>
> >> A DTB is linked in by adding the DTB object to the list of objects to
> >> be linked into vmlinux in the archtecture specific Makefile using
> >>    obj-y += foo.dtb.o
> >>
> >> Signed-off-by: Dirk Brandewie<dirk.brandewie@gmail.com>
> >
> > Hi,
> >
> > you can add
> > Acked-by: Michal Marek <mmarek@suse.cz>
> > but I thing this series should go through the tip tree, as your primary
> > target seems to be x86 and patch 2/4 depends on the ce4100 code that is only
> > in tip.
> 
> If the two lines
> 
> +# device tree blob
> +obj-$(CONFIG_X86_INTEL_CE) += ce4100.dtb.o
> 
> are removed, patch 2/4 no longer depends on the ce4100 code.
> The summary and description for that patch don't mention anything
> about ce4100 anyway.

I'd like to take this through the dt tree.  I'll drop the ce4100 hunk
when I merge it.

g.

> 
> Gr{oetje,eeting}s,
> 
>                         Geert
> 
> --
> Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org
> 
> In personal conversations with technical people, I call myself a hacker. But
> when I'm talking to journalists I just say "programmer" or something like that.
>                                 -- Linus Torvalds
> _______________________________________________
> Linuxppc-dev mailing list
> Linuxppc-dev@lists.ozlabs.org
> https://lists.ozlabs.org/listinfo/linuxppc-dev
