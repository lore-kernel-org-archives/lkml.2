Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751349Ab1KEHZy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Nov 2011 03:25:54 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:48119 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750938Ab1KEHZx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Nov 2011 03:25:53 -0400
MIME-Version: 1.0
In-Reply-To: <1320472196-1987-1-git-send-email-linkinjeon@gmail.com>
References: <1320472196-1987-1-git-send-email-linkinjeon@gmail.com>
Date: Sat, 5 Nov 2011 16:25:52 +0900
X-Google-Sender-Auth: 8XEQF3l-1v5LYcRUeHV52cVEa1Q
Message-ID: <CAH9JG2UW0fOQD0V04QsQf7zLEn_v2ScNArajA7YrbXUmN2RXYg@mail.gmail.com>
Subject: Re: [PATCH] ext4: add blk_finish_plug in error case of writepages.
From: Kyungmin Park <kmpark@infradead.org>
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: tytso@mit.edu, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's already fixed after finding the bug by original author.

Thank you,
Kyungmin Park

On Sat, Nov 5, 2011 at 2:49 PM, Namjae Jeon <linkinjeon@gmail.com> wrote:
> blk_finish_plug is needed in error case of writepages.
>
> Signed-off-by: Namjae Jeon <linkinjeon@gmail.com>
> ---
>  fs/ext4/inode.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
>
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index cc5a6da..18b262b 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -2270,6 +2270,7 @@ retry:
>                        ext4_msg(inode->i_sb, KERN_CRIT, "%s: jbd2_start: "
>                               "%ld pages, ino %lu; err %d", __func__,
>                                wbc->nr_to_write, inode->i_ino, ret);
> +                       blk_finish_plug(&plug);
>                        goto out_writepages;
>                }
>
> --
> 1.7.4.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
