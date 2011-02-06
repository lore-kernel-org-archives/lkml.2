Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751923Ab1BFKQg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 05:16:36 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:63906 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751334Ab1BFKQf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 05:16:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=qRa9fewnAxfhBpLsQSfY1DnbiZr5Xq7VR4HQvmvd3S2cf7DeC60wJynzrI7Rv5IAYj
         2aczkAeVijf+QHQsIIwOrq+ZBtYoaItiHCGq0niA4tYxsyn1gXf0ssRc0jId4ss9rP9k
         EVsZHEKD+0tzZ5ePlwo6Gd8LIqTocEtYueFSc=
MIME-Version: 1.0
In-Reply-To: <AANLkTikj+FU8OF_-KFr2hmTSWqTHMK5JnrnTVyn-XtxQ@mail.gmail.com>
References: <AANLkTikj+FU8OF_-KFr2hmTSWqTHMK5JnrnTVyn-XtxQ@mail.gmail.com>
Date: Sun, 6 Feb 2011 11:16:31 +0100
X-Google-Sender-Auth: IZ8GFRF6Jb-wce_fiOlYWFyoiLc
Message-ID: <AANLkTimcFvq-cSpain--STuVVg3dUJeTCDrykQ=24egg@mail.gmail.com>
Subject: Re: [PATCH] printk-formats.txt documentation update
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Andrew Murray <amurray@mpcdata.com>
Cc: linux-embedded@vger.kernel.org,
        linux kernel <linux-kernel@vger.kernel.org>, trivial@kernel.org,
        rdunlap@xenotime.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 6, 2011 at 01:15, Andrew Murray <amurray@mpcdata.com> wrote:
> From: Andrew Murray <amurray@mpc-data.co.uk>
>
> This patch updates the incomplete documentation concerning the printk
> extended format specifiers.
>
> Signed-off-by: Andrew Murray <amurray@mpc-data.co.uk>
> ---
> diff --git a/Documentation/printk-formats.txt b/Documentation/printk-formats.txt
> index 1b5a5dd..df14336 100644
> --- a/Documentation/printk-formats.txt
> +++ b/Documentation/printk-formats.txt
> @@ -9,7 +9,42 @@ If variable is of Type,                use printk format specifier:
>                size_t                  %zu or %zx
>                ssize_t                 %zd or %zx
>
> -Raw pointer value SHOULD be printed with %p.
> +Raw pointer value SHOULD be printed with %p. The kernel supports
> +the following extended format specifiers for pointer types:
> +
> +       General:
> +
> +       %pF     function pointer with offset, e.g. module_start
> +       %pf     function pointer without offset, e.g. module_start+0x0/0x62 [hello]
> +       %pS     text symbol with offset
> +       %ps     text symbol without offset
> +       %pR     struct resource with decoded flags, e.g. [mem 0x0-0x1f 64 bit pref]
> +       %pr     struct resource with raw flags, e.g. [mem 0x0-0x1f flags 0x201]
> +
> +       MAC/FDDI addresses:
> +
> +       %pM     colon-seperated 6-byte MAC address in hex notation, e.g. 00:01:02:03:04:05
> +       %pm     non-colon-seperated 6-byte MAC address is hex notation, e.g. 000102030405
> +       %pMF    6-byte dash-separated FDDI hex notation
> +
> +       IPv4 addresses:
> +
> +       %pI4    IPv4 dot-seperated decimal without leading 0's, e.g. 1.2.3.4
> +       %pi4    IPv4 dot-seperated decimal with leading 0's, 001.002.003.004
> +       %p[Ii]4[hl] IPv4 dot-seperated decimal with/without leading 0's for
> +               host (h), little (l) or network/big (default) endian order
> +
> +       IPv6 addresses:
> +       %pI6    IPv6 colon-seperated network-order 16 bit hex with leading 0's,
> +               e.g. 0001:0203:...:0708
> +       %pi6    IPv6 non-colon-seperated network-order 16 bit hex with leading 0's,
> +               e.g. 000102...0f
> +       %pI6c   IPv6 address as described by
> +               http://tools.ietf.org/html/draft-ietf-6man-text-addr-representation-00,
> +               e.g. 1::708
> +
> +       %pU[bBlL] 16 byte UUID/GUID in big or little endian using lower or upper case
> +

In the mean time, we also got %pV and %pK. Can you please add them as well? Thx!

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
