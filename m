Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751609Ab1GXRWw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jul 2011 13:22:52 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:24697 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751787Ab1GXRWp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jul 2011 13:22:45 -0400
Date: Sun, 24 Jul 2011 19:22:44 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: Mihai Moldovan <ionic@ionic.de>
cc: LKML <linux-kernel@vger.kernel.org>,
        OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Subject: Re: [PATCH] fix fat utf8 iocharset warning message
In-Reply-To: <4E2C2015.6090200@ionic.de>
Message-ID: <alpine.LNX.2.00.1107241921350.5758@swampdragon.chaosbits.net>
References: <4E2C2015.6090200@ionic.de>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 24 Jul 2011, Mihai Moldovan wrote:

> The fat_msg function already formats the given message and appends
> a newline to it - we don't need to do this in the passed message
> string as well, or will end up with a blank line printed in the
> kernel log ring buffer.
> 
> Signed-off-by: Mihai Moldovan <ionic@ionic.de>
> Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
> ---
>  fs/fat/inode.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/fat/inode.c b/fs/fat/inode.c
> index 5942fec..46530a1 100644
> --- a/fs/fat/inode.c
> +++ b/fs/fat/inode.c
> @@ -1190,7 +1190,7 @@ out:
>      if (!strcmp(opts->iocharset, "utf8")) {
>          fat_msg(sb, KERN_ERR, "utf8 is not a recommended IO charset"

Is KERN_ERR really the right thing to use here? 
Sounds more like a warning to me..


>                 " for FAT filesystems, filesystem will be "
> -               "case sensitive!\n");
> +               "case sensitive!");
>      }
>  
>      /* If user doesn't specify allow_utime, it's initialized from dmask. */
> 

-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

