Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932401Ab0HaPLV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 11:11:21 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:38695 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932359Ab0HaPLT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 11:11:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=OV/TGAUTAvknALwJ5YrXxdxgmb/+6VLGhDgHe1W3u14PgNXasyw8smDZp0Y/bRwvPL
         UNoO91bePTVAkGODJZ2h4QsELqBbW5MMEE8LGt7Q0BYVPTjwPUIoMlcGqMdx2JVCAzbH
         ZbQh6OijHV+FCvnd50gaVjzkhFndg0VPM418k=
MIME-Version: 1.0
In-Reply-To: <4c7cd856.cb71df0a.1986.ffffad0f@mx.google.com>
References: <4c7cd856.cb71df0a.1986.ffffad0f@mx.google.com>
Date: Tue, 31 Aug 2010 23:11:16 +0800
Message-ID: <AANLkTi=k_NdUjFHPD8=s1TaY6YW_EEZKo9ZOyYW1nCKK@mail.gmail.com>
Subject: Re: [PATCH] MIPS: Calculate VMLINUZ_LOAD_ADDRESS based on the length
 of vmlinux.bin
From: wu zhangjin <wuzhangjin@gmail.com>
To: Shmulik Ladkani <shmulik.ladkani@gmail.com>
Cc: ralf@linux-mips.org, linux-mips@linux-mips.org, alex@digriz.org.uk,
        manuel.lauss@googlemail.com, sam@ravnborg.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is a very good fix:

$ ls -sh arch/mips/boot/compressed/vmlinux.bin vmlinux
5.4M arch/mips/boot/compressed/vmlinux.bin  6.9M vmlinux

Thanks very much.

Acked-by: Wu Zhangjin <wuzhangjin@gmail.com>

Regards,
Wu Zhangjin

On 8/31/10, Shmulik Ladkani <shmulik.ladkani@gmail.com> wrote:
> Fix VMLINUZ_LOAD_ADDRESS calculation to be based on the length of
> vmlinux.bin,
> the actual uncompressed kernel binary.
>
> Previously it was based on the length of KBUILD_IMAGE (the unstripped ELF
> vmlinux), which is bigger than vmlinux.bin.
> As a result, vmlinuz was loaded into a memory address higher then actually
> needed - a problem for small memory platforms.
>
> Signed-off-by: Shmulik Ladkani <shmulik.ladkani@gmail.com>
> ---
> diff --git a/arch/mips/boot/compressed/Makefile
> b/arch/mips/boot/compressed/Makefile
> index ed9bb70..5fd7f7a 100644
> --- a/arch/mips/boot/compressed/Makefile
> +++ b/arch/mips/boot/compressed/Makefile
> @@ -59,7 +59,7 @@ $(obj)/piggy.o: $(obj)/dummy.o $(obj)/vmlinux.bin.z FORCE
>  hostprogs-y := calc_vmlinuz_load_addr
>
>  VMLINUZ_LOAD_ADDRESS = $(shell $(obj)/calc_vmlinuz_load_addr \
> -		$(objtree)/$(KBUILD_IMAGE) $(VMLINUX_LOAD_ADDRESS))
> +		$(obj)/vmlinux.bin $(VMLINUX_LOAD_ADDRESS))
>
>  vmlinuzobjs-y += $(obj)/piggy.o
>
> --
> Shmulik Ladkani
>
