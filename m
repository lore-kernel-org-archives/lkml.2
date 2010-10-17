Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932175Ab0JQIUS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Oct 2010 04:20:18 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:64723 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755203Ab0JQIUQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Oct 2010 04:20:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=cHFnT3Cx57dDsBfSa+u4a19y9RJJZxs8inMfDYqRp1AP7Dx5FSYMaGkiu9kWQwwirN
         JFQBxwOTxylUNLXqSh4dSxIxmVF/fPhPGMnx+3ZJswsApG7VKJ8Y8LzxZTWHA/d2ZHKl
         qX6QMEHA2aH7IXURWduibO9LhW1omXN3VhbaE=
MIME-Version: 1.0
In-Reply-To: <1276399981-27524-1-git-send-email-vapier@gentoo.org>
References: <1276399981-27524-1-git-send-email-vapier@gentoo.org>
From: Mike Frysinger <vapier@gentoo.org>
Date: Sun, 17 Oct 2010 04:19:54 -0400
X-Google-Sender-Auth: QXY4eOHhGVIg39XlvwIoiEmRokE
Message-ID: <AANLkTinyFNi5xtLrOSTDtAUvJG8xJ5-QaHrmL1iWPwEw@mail.gmail.com>
Subject: Re: [PATCH] vmlinux.lds.h: lower init ramfs alignment to 4
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Tim Abbott <tabbott@ksplice.com>,
        Milton Miller <miltonm@bga.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew: could you pick this up ?  no feedback after this last version
was posted ...
-mike

On Sat, Jun 12, 2010 at 23:33, Mike Frysinger wrote:
> The new init ramfs format (cpio based) requires an alignment of 4 (per the
> documentation and per the source files themselves).  As for compressed
> sources, the decompressors can all deal with unaligned buffers.
>
> The cpio source is also found in the __init sections of the kernel, so
> once they are read and expanded into a tmpfs, the source is freed.  That
> means there is no need to force page alignment here either.
>
> This has been used on Blackfin systems for many releases without issue.
>
> Signed-off-by: Mike Frysinger <vapier@gentoo.org>
> ---
>  include/asm-generic/vmlinux.lds.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
> index 48c5299..14a01b6 100644
> --- a/include/asm-generic/vmlinux.lds.h
> +++ b/include/asm-generic/vmlinux.lds.h
> @@ -620,7 +620,7 @@
>
>  #ifdef CONFIG_BLK_DEV_INITRD
>  #define INIT_RAM_FS                                                    \
> -       . = ALIGN(PAGE_SIZE);                                           \
> +       . = ALIGN(4);                                                   \
>        VMLINUX_SYMBOL(__initramfs_start) = .;                          \
>        *(.init.ramfs)                                                  \
>        VMLINUX_SYMBOL(__initramfs_end) = .;
> --
> 1.7.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
