Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756609Ab0I3UAf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 16:00:35 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:34496 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756501Ab0I3UAe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 16:00:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=I47ppdBbjJ9+lGgV0xH5F9H5iraVVvB/My8+5wtAjLlwz+YW2gub04uY05Czy1MIcM
         Rb6egZ6qpocMv/Lmnari6TCYVsT7dZ81LUVvQl7jNYLZZxLYx6RoRUGH30hmVY/c+lFd
         6MmQ6anyzwtzi8wgItQT+0Vq36xCS7GpTTfn4=
MIME-Version: 1.0
In-Reply-To: <1285334543-7074-1-git-send-regression-fweisbec@gmail.com>
References: <1285334543-7074-1-git-send-regression-fweisbec@gmail.com>
Date: Thu, 30 Sep 2010 22:00:33 +0200
X-Google-Sender-Auth: MT8TF619C6-IQS7pYm5OL9JxNi4
Message-ID: <AANLkTinnRB-cpRrxymUQYMx0TjgkDkSbg=Euaq+Y16sE@mail.gmail.com>
Subject: Re: [PATCH 1/2] autofs: Only declare function when CONFIG_COMPAT is defined
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        =?UTF-8?B?TcOhcnRvbiBOw6ltZXRo?= <nm127@freemail.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 24, 2010 at 15:22, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> From: Márton Németh <nm127@freemail.hu>
>
> The patch solves the following warnings message when CONFIG_COMPAT
> is not defined:
>
> fs/autofs/root.c:30: warning: ‘autofs_root_compat_ioctl’ declared ‘static’ but never defined
>
> Signed-off-by: Márton Németh <nm127@freemail.hu>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> ---
>  fs/autofs/root.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
>
> diff --git a/fs/autofs/root.c b/fs/autofs/root.c
> index 11b1ea7..0c4ca81 100644
> --- a/fs/autofs/root.c
> +++ b/fs/autofs/root.c
> @@ -27,7 +27,9 @@ static int autofs_root_unlink(struct inode *,struct dentry *);
>  static int autofs_root_rmdir(struct inode *,struct dentry *);
>  static int autofs_root_mkdir(struct inode *,struct dentry *,int);
>  static long autofs_root_ioctl(struct file *,unsigned int,unsigned long);
> +#ifdef CONFIG_COMPAT
>  static long autofs_root_compat_ioctl(struct file *,unsigned int,unsigned long);
> +#endif
>
>  const struct file_operations autofs_root_operations = {
>        .llseek         = generic_file_llseek,

An alternative (and IMHO better) fix would be to move autofs_root_operations[]
and autofs_root_inode_operations[] to the bottom of the file, and get rid of all
the forward declarations.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
