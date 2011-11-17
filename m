Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756155Ab1KQIwz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 03:52:55 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:59263 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751709Ab1KQIwx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 03:52:53 -0500
MIME-Version: 1.0
In-Reply-To: <1321026853-16388-1-git-send-email-linkinjeon@gmail.com>
References: <1321026853-16388-1-git-send-email-linkinjeon@gmail.com>
Date: Thu, 17 Nov 2011 14:22:52 +0530
Message-ID: <CADDb1s3fNxeXOvGZOUUK5Vjr5TLRTLn8mHezA8tc0u_JX7+ErQ@mail.gmail.com>
Subject: Re: [PATCH] fs : remove unneeded plug in mpage_readpages.
From: Amit Sahrawat <amit.sahrawat83@gmail.com>
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Any feedback for this patch?

Thanks & Regards,
Amit Sahrawat

On Fri, Nov 11, 2011 at 9:24 PM, Namjae Jeon <linkinjeon@gmail.com> wrote:
> block plug in mpage_readpages is duplicated with plug of read_pages. So block plug is not needed in mpage_readpages.
>
> Signed-off-by: Namjae Jeon <linkinjeon@gmail.com>
> Signed-off-by: Amit Sahrawat <amit.sahrawat83@gmail.com>
> ---
>  fs/mpage.c |    4 ----
>  1 files changed, 0 insertions(+), 4 deletions(-)
>
> diff --git a/fs/mpage.c b/fs/mpage.c
> index fdfae9f..643e9f5 100644
> --- a/fs/mpage.c
> +++ b/fs/mpage.c
> @@ -371,9 +371,6 @@ mpage_readpages(struct address_space *mapping, struct list_head *pages,
>        sector_t last_block_in_bio = 0;
>        struct buffer_head map_bh;
>        unsigned long first_logical_block = 0;
> -       struct blk_plug plug;
> -
> -       blk_start_plug(&plug);
>
>        map_bh.b_state = 0;
>        map_bh.b_size = 0;
> @@ -395,7 +392,6 @@ mpage_readpages(struct address_space *mapping, struct list_head *pages,
>        BUG_ON(!list_empty(pages));
>        if (bio)
>                mpage_bio_submit(READ, bio);
> -       blk_finish_plug(&plug);
>        return 0;
>  }
>  EXPORT_SYMBOL(mpage_readpages);
> --
> 1.7.4.4
>
>
