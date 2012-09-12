Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755114Ab2ILF55 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 01:57:57 -0400
Received: from smtprelay.restena.lu ([158.64.1.62]:52923 "EHLO
	smtprelay.restena.lu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754751Ab2ILF5h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 01:57:37 -0400
Date: Wed, 12 Sep 2012 07:57:34 +0200
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: Axel Lin <axel.lin@gmail.com>
Cc: Tejun Heo <tj@kernel.org>, Jiri Kosina <jkosina@suse.cz>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] HID: picolcd_fb: Use flush_delayed_work instead of
 flush_delayed_work_sync
Message-ID: <20120912075734.0e184a13@pluto.restena.lu>
In-Reply-To: <1347428349.14558.1.camel@phoenix>
References: <1347428349.14558.1.camel@phoenix>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Axel,

On Wed, 12 Sep 2012 13:39:09 Axel Lin <axel.lin@gmail.com> wrote:
> Seems this is a left over of commit 4382973
> "workqueue: deprecate flush[_delayed]_work_sync()"

It is, see https://lkml.org/lkml/2012/9/6/297 for a previous patch.
This should fix itself when Linus merges Tejun's workqueue changes and
picolcd changes.

Bruno


> This fixes below build warning:
> 
>   CC [M]  drivers/hid/hid-picolcd_fb.o
> drivers/hid/hid-picolcd_fb.c: In function 'picolcd_exit_framebuffer':
> drivers/hid/hid-picolcd_fb.c:611:2: warning: 'flush_delayed_work_sync' is deprecated (declared at include/linux/workqueue.h:454) [-Wdeprecated-declarations]
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> Cc: Tejun Heo <tj@kernel.org>
> ---
>  drivers/hid/hid-picolcd_fb.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/hid/hid-picolcd_fb.c b/drivers/hid/hid-picolcd_fb.c
> index 0008a51..eb00357 100644
> --- a/drivers/hid/hid-picolcd_fb.c
> +++ b/drivers/hid/hid-picolcd_fb.c
> @@ -608,7 +608,7 @@ void picolcd_exit_framebuffer(struct picolcd_data *data)
>  	/* make sure there is no running update - thus that fbdata->picolcd
>  	 * once obtained under lock is guaranteed not to get free() under
>  	 * the feet of the deferred work */
> -	flush_delayed_work_sync(&info->deferred_work);
> +	flush_delayed_work(&info->deferred_work);
>  
>  	data->fb_info = NULL;
>  	unregister_framebuffer(info);
