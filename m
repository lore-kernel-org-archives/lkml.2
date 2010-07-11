Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752305Ab0GKIbk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jul 2010 04:31:40 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:50893 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751375Ab0GKIbh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jul 2010 04:31:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=Z1Z4zYKPTu4PSvGJa15zQjJAx+iGAc4n6rqwWg/ePdci8XKtfpFqItuPmub6TuBNWj
         qVNg5/bg/lLWnGrw8VF6vnkp33tpmmJOUwgXQ0YunTE/vb7q+t0UC5aj9O49LTHadn4O
         8hdM06rYP41ozVFJJgEgj0GDT7kxMN83bl0tI=
MIME-Version: 1.0
In-Reply-To: <201007111016021569718@gmail.com>
References: <201007111016021569718@gmail.com>
Date: Sun, 11 Jul 2010 16:31:35 +0800
Message-ID: <AANLkTinjdTVM-Xqfszyi8KBe-aD-2I-jcvDFFtz9seD3@mail.gmail.com>
Subject: Re: [PATCH & RESEND] avoid NULL deference in ext2_xattr_get
From: shenghui <crosslonelyover@gmail.com>
To: kernel-janitors <kernel-janitors@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-ext4 <linux-ext4@vger.kernel.org>, error27 <error27@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/7/11 crosslonelyover <crosslonelyover@gmail.com>:
> Hi Dan Carpenter,
>
>     Thanks for your instructions. I regenerated the patch.
> Please check it.
>
> From 3149865e0d118b939c27659a4e4c884eaa6b3a4c Mon Sep 17 00:00:00 2001
> From: Wang Sheng-Hui <crosslonelyover@gmail.com>
> Date: Sat, 10 Jul 2010 22:07:37 -0400
> Subject: [PATCH] avoid NULL deference in ext2_xattr_get
>
>
> Signed-off-by: Wang Sheng-Hui <crosslonelyover@gmail.com>
> ---
>  fs/ext2/xattr.c |    5 +++--
>  1 files changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/fs/ext2/xattr.c b/fs/ext2/xattr.c
> index 7c39157..81ec1c6 100644
> --- a/fs/ext2/xattr.c
> +++ b/fs/ext2/xattr.c
> @@ -156,11 +156,12 @@ ext2_xattr_get(struct inode *inode, int name_index, const char *name,
>        char *end;
>        int error;
>
> +       if (name == NULL)
> +               return -EINVAL;
> +
>        ea_idebug(inode, "name=%d.%s, buffer=%p, buffer_size=%ld",
>                  name_index, name, buffer, (long)buffer_size);
>
> -       if (name == NULL)
> -               return -EINVAL;
>        down_read(&EXT2_I(inode)->xattr_sem);
>        error = -ENODATA;
>        if (!EXT2_I(inode)->i_file_acl)
> --
> 1.7.1.1
>
>
>

Please ignore this patch. Just for gmail format check.
Thanks for David Beal's explanation!

-- 


Thanks and Best Regards,
shenghui
