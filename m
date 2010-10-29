Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761513Ab0J2Nxy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 09:53:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21403 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757785Ab0J2Nxw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 09:53:52 -0400
Subject: Re: [PATCH] make fanotify_read() restartable across signals
From: Eric Paris <eparis@redhat.com>
To: Lino Sanfilippo <LinoSanfilippo@gmx.de>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
In-Reply-To: <20101029100642.GD26242@lsanfilippo.unix.rd.tt.avira.com>
References: <20101029100642.GD26242@lsanfilippo.unix.rd.tt.avira.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 29 Oct 2010 09:53:48 -0400
Message-ID: <1288360428.3017.16.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-10-29 at 12:06 +0200, Lino Sanfilippo wrote:
> In fanotify_read() return -ERESTARTSYS instead of -EINTR to
>     make read() restartable across signals (BSD semantic).

Looks good, I'll add it today.

Thanks!

-Eric
> ---
> This patch applies against commit 3970d817558a426cc2f53eaa01182eb9452e0cb1
> of branch 'origin/for-next' from git.infradead.org/users/eparis/notify.git
> 
> diff --git a/fs/notify/fanotify/fanotify_user.c b/fs/notify/fanotify/fanotify_user.c
> index 8c9fd35..99a8e60 100644
> --- a/fs/notify/fanotify/fanotify_user.c
> +++ b/fs/notify/fanotify/fanotify_user.c
> @@ -330,7 +330,7 @@ static ssize_t fanotify_read(struct file *file, char __user *buf,
>  		ret = -EAGAIN;
>  		if (file->f_flags & O_NONBLOCK)
>  			break;
> -		ret = -EINTR;
> +		ret = -ERESTARTSYS;
>  		if (signal_pending(current))
>  			break;
>  


