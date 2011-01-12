Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753351Ab1ALOmS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 09:42:18 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:60529 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750915Ab1ALOmQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 09:42:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Z4xwu6/SkjJq8Ol0TG37zHXamko/RKqnaTqHYIEUCbNqsg3ifuAV4FFPeRRH3seglD
         PNrS5HSdquYL2RAABLst0UE8R/f15GBOJwiInI5wZPd4oaHy74Z6y0AGWGrDR+FAok1J
         VD/RXpi1CBkWYGYMwHz0Xjm0pBKrA9CiMtYLw=
MIME-Version: 1.0
In-Reply-To: <1294829896-3210-1-git-send-email-namhyung@gmail.com>
References: <1294829896-3210-1-git-send-email-namhyung@gmail.com>
Date: Wed, 12 Jan 2011 15:42:15 +0100
Message-ID: <AANLkTikgBBEznAh1CRwJk5MgorNFpXvRuVLyhYT6sQvw@mail.gmail.com>
Subject: Re: [PATCH] epoll: remove unnecessary bit operation in epoll_create1 syscall
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: Namhyung Kim <namhyung@gmail.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
        Davide Libenzi <davidel@xmailserver.org>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 12, 2011 at 11:58 AM, Namhyung Kim <namhyung@gmail.com> wrote:
> @flags can have O_CLOEXEC only so bitwise AND is not necessary.
>
> Signed-off-by: Namhyung Kim <namhyung@gmail.com>
> ---
>  fs/eventpoll.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/fs/eventpoll.c b/fs/eventpoll.c
> index 8cf07242067d..2e21fb85b8b6 100644
> --- a/fs/eventpoll.c
> +++ b/fs/eventpoll.c
> @@ -1209,7 +1209,7 @@ SYSCALL_DEFINE1(epoll_create1, int, flags)
>         * a file structure and a free file descriptor.
>         */
>        error = anon_inode_getfd("[eventpoll]", &eventpoll_fops, ep,
> -                                O_RDWR | (flags & O_CLOEXEC));
> +                                O_RDWR | flags);

I'm strong against this.
Whenever a new flag is allowed this will explode...

>        if (error < 0)
>                ep_free(ep);
>
> --
> 1.7.3.4.600.g982838b0
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>



-- 
Thanks,
//richard
