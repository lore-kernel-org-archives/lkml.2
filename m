Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754743Ab1C1QS5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 12:18:57 -0400
Received: from oproxy3-pub.bluehost.com ([69.89.21.8]:55360 "HELO
	oproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751750Ab1C1QS4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 12:18:56 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=iK/BLQEyALCF0s69AvaSlC/TvZOz/6MZh+oLdQQ6Mas+AHeg8e0HsB9a7JTpd8BvCuXfOV9VJGfBTvVdOvsl76SxSeTcONx7gCnT5buaBJ77MpwsmYfyRsoD6L2kvPTJ;
Date: Mon, 28 Mar 2011 09:18:46 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Paul Mundt <lethal@linux-sh.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Airlie <airlied@redhat.com>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fbcon: Remove unused 'display *p' variable from
 fb_flashcursor()
Message-ID: <20110328091846.485dfef0@jbarnes-desktop>
In-Reply-To: <20110324205052.GA4238@swordfish>
References: <20110324205052.GA4238@swordfish>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Mar 2011 22:50:52 +0200
Sergey Senozhatsky <sergey.senozhatsky@gmail.com> wrote:

> fbcon: Remove unused 'display *p' variable from fb_flashcursor()
> 
> Signed-of-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
> 
> ---
> 
>  drivers/video/console/fbcon.c |    2 --
>  1 files changed, 0 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/video/console/fbcon.c b/drivers/video/console/fbcon.c
> index c583934..8745637 100644
> --- a/drivers/video/console/fbcon.c
> +++ b/drivers/video/console/fbcon.c
> @@ -370,7 +370,6 @@ static void fb_flashcursor(struct work_struct *work)
>  {
>  	struct fb_info *info = container_of(work, struct fb_info, queue);
>  	struct fbcon_ops *ops = info->fbcon_par;
> -	struct display *p;
>  	struct vc_data *vc = NULL;
>  	int c;
>  	int mode;
> @@ -386,7 +385,6 @@ static void fb_flashcursor(struct work_struct *work)
>  		return;
>  	}
>  
> -	p = &fb_display[vc->vc_num];
>  	c = scr_readw((u16 *) vc->vc_pos);
>  	mode = (!ops->cursor_flash || ops->cursor_state.enable) ?
>  		CM_ERASE : CM_DRAW;

Looks fine to me, is Paul the lucky owner of fbdev now?

-- 
Jesse Barnes, Intel Open Source Technology Center
