Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756321Ab1KQJp2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 04:45:28 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:62811 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756239Ab1KQJp0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 04:45:26 -0500
MIME-Version: 1.0
In-Reply-To: <1321023744-16249-1-git-send-email-linkinjeon@gmail.com>
References: <1321023744-16249-1-git-send-email-linkinjeon@gmail.com>
Date: Thu, 17 Nov 2011 15:15:25 +0530
Message-ID: <CADDb1s21Px4vP5S48O770vCT6FNAw4CDR9uDRcBn=rPqfKnzQA@mail.gmail.com>
Subject: Re: [PATCH] ext4: remove unneeded variable.
From: Amit Sahrawat <amit.sahrawat83@gmail.com>
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: tytso@mit.edu, linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Any feedback for this patch? We surely don't need 'ret2' variable in this code.

Thanks & Regards,
Amit Sahrawat

On Fri, Nov 11, 2011 at 8:32 PM, Namjae Jeon <linkinjeon@gmail.com> wrote:
> ret2 is not needed in ext4_flush_completed_IO().
>
> Signed-off-by: Namjae Jeon <linkinjeon@gmail.com>
> Signed-off-by: Amit Sahrawat <amit.sahrawat83@gmail.com>
> ---
>  fs/ext4/fsync.c |    5 +----
>  1 files changed, 1 insertions(+), 4 deletions(-)
>
> diff --git a/fs/ext4/fsync.c b/fs/ext4/fsync.c
> index 00a2cb7..40397ac 100644
> --- a/fs/ext4/fsync.c
> +++ b/fs/ext4/fsync.c
> @@ -81,7 +81,6 @@ int ext4_flush_completed_IO(struct inode *inode)
>        struct ext4_inode_info *ei = EXT4_I(inode);
>        unsigned long flags;
>        int ret = 0;
> -       int ret2 = 0;
>
>        dump_completed_IO(inode);
>        spin_lock_irqsave(&ei->i_completed_io_lock, flags);
> @@ -105,12 +104,10 @@ int ext4_flush_completed_IO(struct inode *inode)
>                 */
>                spin_unlock_irqrestore(&ei->i_completed_io_lock, flags);
>                ret = ext4_end_io_nolock(io);
> -               if (ret < 0)
> -                       ret2 = ret;
>                spin_lock_irqsave(&ei->i_completed_io_lock, flags);
>        }
>        spin_unlock_irqrestore(&ei->i_completed_io_lock, flags);
> -       return (ret2 < 0) ? ret2 : 0;
> +       return (ret < 0) ? ret : 0;
>  }
>
>  /*
> --
> 1.7.4.4
>
>
