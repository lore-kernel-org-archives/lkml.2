Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752406Ab1KSIG5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Nov 2011 03:06:57 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:58667 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751478Ab1KSIG4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Nov 2011 03:06:56 -0500
MIME-Version: 1.0
In-Reply-To: <1321688059-3844-1-git-send-email-levinsasha928@gmail.com>
References: <1321688059-3844-1-git-send-email-levinsasha928@gmail.com>
Date: Sat, 19 Nov 2011 10:06:55 +0200
X-Google-Sender-Auth: zmpEgGiIG2Gc7TI4cT28P2LpdBo
Message-ID: <CAOJsxLFvVUbnHrCKGL-kuN_JYQ6qwtU_kzvncrAmWAdjP2RvQw@mail.gmail.com>
Subject: Re: [PATCH v2] pipe: Fail cleanly when root tries F_SETPIPE_SZ with
 big size
From: Pekka Enberg <penberg@kernel.org>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: linux-kernel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 19, 2011 at 9:34 AM, Sasha Levin <levinsasha928@gmail.com> wrote:
> When a user with the CAP_SYS_RESOURCE cap tries to F_SETPIPE_SZ a pipe with
> size bigger than what kmalloc() can alloc it spits out an ugly warning:

[snip]

> Instead, make kcalloc() handle the overflow case and fail quietly.
>
> Cc: Alexander Viro <viro@zeniv.linux.org.uk>
> Cc: Pekka Enberg <penberg@kernel.org>
> Cc: linux-fsdevel@vger.kernel.org
> Signed-off-by: Sasha Levin <levinsasha928@gmail.com>

Acked-by: Pekka Enberg <penberg@kernel.org>

> ---
>  fs/pipe.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/fs/pipe.c b/fs/pipe.c
> index 4065f07..3e38dc6 100644
> --- a/fs/pipe.c
> +++ b/fs/pipe.c
> @@ -1137,7 +1137,7 @@ static long pipe_set_size(struct pipe_inode_info *pipe, unsigned long nr_pages)
>        if (nr_pages < pipe->nrbufs)
>                return -EBUSY;
>
> -       bufs = kcalloc(nr_pages, sizeof(struct pipe_buffer), GFP_KERNEL);
> +       bufs = kcalloc(nr_pages, sizeof(struct pipe_buffer), GFP_KERNEL | __GFP_NOWARN);
>        if (unlikely(!bufs))
>                return -ENOMEM;
>
> --
> 1.7.8.rc1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
