Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752656Ab0CTUq1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Mar 2010 16:46:27 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:45779 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752521Ab0CTUqZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Mar 2010 16:46:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=bmx2XQ8p5OeY8fXNdBCY/m95tJ+YLkYkjyt13c+FWSmgJn7iH3OR7XDcVw9aZnrNNY
         Bv3nVDH/MpB6Pub8bXdFiAGTYKeBENYMrv6omfr+seYWexFKkBMlhz+LqzdRuyEJCsxz
         2UbDKixeV+jBvwVKCbwPIGW5F/5nqhEYn/Nyo=
MIME-Version: 1.0
In-Reply-To: <20100320184907.8036.82488.stgit@localhost.localdomain>
References: <20100320184907.8036.82488.stgit@localhost.localdomain>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Sat, 20 Mar 2010 16:46:03 -0400
Message-ID: <8bd0f97a1003201346xc927340r39f33b9a6b599792@mail.gmail.com>
Subject: Re: [PATCH] uImage: Allow to specify MKIMAGE
To: Paulius Zaleckas <paulius.zaleckas@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
       uclinux-dist-devel@blackfin.uclinux.org,
       microblaze-uclinux@itee.uq.edu.au, linux-sh@vger.kernel.org,
       hskinnemoen@atmel.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 20, 2010 at 14:49, Paulius Zaleckas wrote:
> --- a/arch/blackfin/boot/Makefile
> +++ b/arch/blackfin/boot/Makefile
> @@ -6,7 +6,7 @@
>  # for more details.
>  #
>
> -MKIMAGE := $(srctree)/scripts/mkuboot.sh
> +MKIMAGE := $(CONFIG_SHELL) $(srctree)/scripts/mkuboot.sh
>
>  targets := vmImage vmImage.bin vmImage.bz2 vmImage.gz vmImage.lzma vmImage.xip
>  extra-y += vmlinux.bin vmlinux.bin.gz vmlinux.bin.bz2 vmlinux.bin.lzma vmlinux.bin.xip
> @@ -16,7 +16,7 @@ UIMAGE_OPTS-$(CONFIG_RAMKERNEL) += -a $(CONFIG_BOOT_LOAD)
>  UIMAGE_OPTS-$(CONFIG_ROMKERNEL) += -a $(CONFIG_ROM_BASE) -x
>
>  quiet_cmd_uimage = UIMAGE  $@
> -      cmd_uimage = $(CONFIG_SHELL) $(MKIMAGE) -A $(ARCH) -O linux -T kernel \
> +      cmd_uimage = $(MKIMAGE) -A $(ARCH) -O linux -T kernel \
>                    -C $(2) -n '$(MACHINE)-$(KERNELRELEASE)' \
>                    -e $(shell $(NM) vmlinux | awk '$$NF == "__start" {print $$1}') \
>                    $(UIMAGE_OPTS-y) -d $< $@

looks straightforward, and doesnt matter to me, so
Acked-by: Mike Frysinger <vapier@gentoo.org>
-mike
