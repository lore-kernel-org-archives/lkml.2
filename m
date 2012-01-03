Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753996Ab2ACPyw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 10:54:52 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:48821 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753930Ab2ACPyt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 10:54:49 -0500
MIME-Version: 1.0
In-Reply-To: <1322118279.2839.255.camel@deadeye>
References: <1322118279.2839.255.camel@deadeye>
Date: Tue, 3 Jan 2012 16:54:48 +0100
X-Google-Sender-Auth: pqfqZsI03IPxKokA9_n_nk5T1PM
Message-ID: <CAMuHMdX6rcoyts=o5EEZTDb4CWHY-sYU=3dP4_f6U4o1LNk6vA@mail.gmail.com>
Subject: Re: [PATCH] topology: Provide CPU topology in sysfs in !SMP configurations
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, LKML <linux-kernel@vger.kernel.org>,
        Marcus Osdoba <marcus.osdoba@googlemail.com>, 649216@bugs.debian.org,
        Linux-Arch <linux-arch@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 24, 2011 at 08:04, Ben Hutchings <ben@decadent.org.uk> wrote:
> We should provide topology information to userland even if it's not
> very interesting.  The current code appears to work properly for !SMP
> (tested on i386).
>
> Reference: http://bugs.debian.org/649216
> Reported-by: Marcus Osdoba <marcus.osdoba@googlemail.com>
> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> ---
>  drivers/base/Makefile |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/base/Makefile b/drivers/base/Makefile
> index 99a375a..1334d89 100644
> --- a/drivers/base/Makefile
> +++ b/drivers/base/Makefile
> @@ -3,7 +3,8 @@
>  obj-y                  := core.o sys.o bus.o dd.o syscore.o \
>                           driver.o class.o platform.o \
>                           cpu.o firmware.o init.o map.o devres.o \
> -                          attribute_container.o transport_class.o
> +                          attribute_container.o transport_class.o \
> +                          topology.o
>  obj-$(CONFIG_DEVTMPFS) += devtmpfs.o
>  obj-y                  += power/
>  obj-$(CONFIG_HAS_DMA)  += dma-mapping.o
> @@ -12,7 +13,6 @@ obj-$(CONFIG_ISA)     += isa.o
>  obj-$(CONFIG_FW_LOADER)        += firmware_class.o
>  obj-$(CONFIG_NUMA)     += node.o
>  obj-$(CONFIG_MEMORY_HOTPLUG_SPARSE) += memory.o
> -obj-$(CONFIG_SMP)      += topology.o
>  ifeq ($(CONFIG_SYSFS),y)
>  obj-$(CONFIG_MODULES)  += module.o
>  endif

Taking this to linux-arch with a follow up from Ben due to crashes
reported on the
debian-m68k mailing list:

> > My guess is that on m68k get_cpu_sysdev(0) returns NULL and thus
> > topology_add_dev() passes an invalid pointer into sysfs_create_group().
> > So either m68k (and maybe some other architectures with no SMP support)
> > need to be fixed or the CPU topology code needs to allow for this.
>
> None of these architectures appears to call register_cpu():
>
>    c6x frv h8300 m68k microblaze openrisc score um xtensa
>
> and therefore they will all panic at boot following this change (commit
> ccbc60d3e19a1b6ae66ca0d89b3da02dde62088b).  So either I can try to fix
> them or else it must be reverted for now.

The commit mentioned above is in linux-next (and in Debian's 3.2-rc7).

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
