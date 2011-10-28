Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933202Ab1J1UfM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 16:35:12 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:59005 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751128Ab1J1UfK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 16:35:10 -0400
MIME-Version: 1.0
In-Reply-To: <CAMuHMdW6hC1JchxVL9-4f58a8Vg7cF+97BbKePxjEDHY3H8wNw@mail.gmail.com>
References: <CAMuHMdW6hC1JchxVL9-4f58a8Vg7cF+97BbKePxjEDHY3H8wNw@mail.gmail.com>
Date: Fri, 28 Oct 2011 22:35:09 +0200
X-Google-Sender-Auth: tqpGsAthygMp9vnrwqa2zkDoc18
Message-ID: <CAMuHMdU3H63vx8436fdm_WBuPBwqNxHtPiAO9j6RhMn0VCAy2w@mail.gmail.com>
Subject: Re: -next: NET_VENDOR_8390 dependencies
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 23, 2011 at 23:21, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> drivers/net/ethernet/8390/Kconfig:
>
> config NET_VENDOR_8390
>        depends on NET_VENDOR_NATSEMI && (AMIGA_PCMCIA || PCI || SUPERH || \
>                   ISA || MCA || EISA || MAC || M32R || MACH_TX49XX || \
>                   MCA_LEGACY || H8300 || ARM || MIPS || ZORRO || PCMCIA || \
>                   EXPERIMENTAL)

> So NET_VENDOR_8390 depends on NET_VENDOR_NATSEMI.

> config NET_VENDOR_NATSEMI
>        depends on MCA || MAC || MACH_JAZZ || PCI || XTENSA_PLATFORM_XT2000

> But NET_VENDOR_NATSEMI will never be true for several of the other
> dependencies of NET_VENDOR_8390 (e.g. AMIGA_PCMCIA, EISA, H8300, ARM,
> ZORRO, PCMCIA)?

There's a similar issue with:

config NET_VENDOR_I825XX
        depends on NET_VENDOR_INTEL && (ISA || ISA_DMA_API || ARM || \
                   ARCH_ACORN || MCA || MCA_LEGACY || SNI_RM || SUN3 || \
                   GSC || BVME6000 || MVME16x || EXPERIMENTAL)

But:

config NET_VENDOR_INTEL
        depends on PCI || PCI_MSI

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
