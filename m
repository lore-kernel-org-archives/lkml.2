Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751706Ab0LZIsl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Dec 2010 03:48:41 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:38388 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751338Ab0LZIsk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Dec 2010 03:48:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=RY1SlXMlEshRQTBE9SZi4rrfGRwT7bOo89SBsanXBSwkXvFDGzWUYKweOwEGO8gDcW
         9Yd+hofwbNFGx6kmlBfEZ9r5pp4Ho4IREU4ZyHfmhfmUr+7EJxfSipllMilIpm3tD0jW
         noUjNawYz3+sAeXYBu5olfkWl/sK2duNL6Z0s=
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1012252020000.10759@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1012252020000.10759@swampdragon.chaosbits.net>
Date: Sun, 26 Dec 2010 09:48:39 +0100
X-Google-Sender-Auth: 0wT8QbXl-63rPX2k8TTa8LOjKW8
Message-ID: <AANLkTinOD=ovyk5CdBeJf7e0cPeGP_WUE=ZFArWrvBe2@mail.gmail.com>
Subject: Re: [PATCH] befs: Don't pass huge structs by value.
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Jesper Juhl <jj@chaosbits.net>
Cc: linux-kernel@vger.kernel.org, Will Dyson <will_dyson@pobox.com>,
        Makoto Kato <m_kato@ga2.so-net.ne.jp>,
        "Sergey S. Kostyliov" <rathamahata@php4.ru>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 25, 2010 at 20:27, Jesper Juhl <jj@chaosbits.net> wrote:
> 'struct befs_disk_data_stream' is huge (~144 bytes) and it's being passed
> by value in fs/befs/endian.h::cpu_to_fsrun().
>
> It seems to me that it would be better to pass a pointer, no?
> This patch changes the function to take a pointer to the large struct.
>
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> ---
>  endian.h   |   16 ++++++++--------
>  linuxvfs.c |    2 +-
>  2 files changed, 9 insertions(+), 9 deletions(-)
>
>  Compile tested only. I have no way to test this.
>
> diff --git a/fs/befs/endian.h b/fs/befs/endian.h
> index 6cb84d8..a99caa0 100644
> --- a/fs/befs/endian.h
> +++ b/fs/befs/endian.h
> @@ -102,22 +102,22 @@ cpu_to_fsrun(const struct super_block *sb, befs_block_run n)
>  }
>
>  static inline befs_data_stream
> -fsds_to_cpu(const struct super_block *sb, befs_disk_data_stream n)
> +fsds_to_cpu(const struct super_block *sb, befs_disk_data_stream *n)

Please make befs_disk_data_stream const, so people don't accidentally modify it.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
