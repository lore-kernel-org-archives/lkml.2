Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753749Ab2EMPqy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2012 11:46:54 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:34247 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753426Ab2EMPqx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2012 11:46:53 -0400
Message-ID: <1336924011.31383.6.camel@joe2Laptop>
Subject: Re: [PATCH 2/2] fat: use fat_msg_ratelimit in fat__get_entry.
From: Joe Perches <joe@perches.com>
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: hirofumi@mail.parknet.co.jp, linux-kernel@vger.kernel.org,
        Amit Sahrawat <amit.sahrawat83@gmail.com>
Date: Sun, 13 May 2012 08:46:51 -0700
In-Reply-To: <1336907039-18638-1-git-send-email-linkinjeon@gmail.com>
References: <1336907039-18638-1-git-send-email-linkinjeon@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-05-13 at 07:03 -0400, Namjae Jeon wrote:
> So this patch use fat_msg_ratelimit function about this message to decrease this messages.
[]
> diff --git a/fs/fat/dir.c b/fs/fat/dir.c
> index aca191b..b2cdbf4 100644
> --- a/fs/fat/dir.c
> +++ b/fs/fat/dir.c
> @@ -98,8 +98,8 @@ next:
>  
>  	*bh = sb_bread(sb, phys);
>  	if (*bh == NULL) {
> -		fat_msg(sb, KERN_ERR, "Directory bread(block %llu) failed",
> -		       (llu)phys);
> +		fat_msg_ratelimit(sb, KERN_ERR, "Directory bread(block %llu) "
> +				"failed", (llu)phys);

Please don't split format strings.
It's much harder to grep.


