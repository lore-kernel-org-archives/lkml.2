Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754709Ab1L1XzR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Dec 2011 18:55:17 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:9628 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752979Ab1L1XzO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Dec 2011 18:55:14 -0500
X-AuditID: cbfee61b-b7b95ae00000198b-9a-4efbac608713
From: Jingoo Han <jg1.han@samsung.com>
To: "'Mark Brown'" <broonie@opensource.wolfsonmicro.com>,
        "'Florian Tobias Schandinat'" <FlorianSchandinat@gmx.de>
Cc: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20111227141550.GA3331@opensource.wolfsonmicro.com>
 <1324995372-3410-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <1324995372-3410-6-git-send-email-broonie@opensource.wolfsonmicro.com>
In-reply-to: <1324995372-3410-6-git-send-email-broonie@opensource.wolfsonmicro.com>
Subject: RE: [PATCH 6/6] video: s3c-fb: Don't keep device runtime active when
 open
Date: Thu, 29 Dec 2011 08:55:12 +0900
Message-id: <000b01ccc5bc$235c0b20$6a142160$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: AczEoh0qPU7zdmlKQ7CJIRWhWjUt8gBGgFVg
Content-language: ko
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Mark Brown [mailto:broonie@opensource.wolfsonmicro.com]
> Sent: Tuesday, December 27, 2011 11:16 PM
> To: Jingoo Han; Florian Tobias Schandinat
> Cc: linux-fbdev@vger.kernel.org; linux-kernel@vger.kernel.org; Mark Brown
> Subject: [PATCH 6/6] video: s3c-fb: Don't keep device runtime active when open
> 
> Allow the controller to be runtime suspended when the screen is blanked
> by not taking a runtime reference while the device is open. This allows
> greater system wide power savings when used with a standard application
> layer and ensures that the screen does not blank unless requested.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

		Acked-by: Jingoo Han <jg1.han@samsung.com>

> ---
>  drivers/video/s3c-fb.c |   22 ----------------------
>  1 files changed, 0 insertions(+), 22 deletions(-)
> 
> diff --git a/drivers/video/s3c-fb.c b/drivers/video/s3c-fb.c
> index 84cf631..0c63b69 100644
> --- a/drivers/video/s3c-fb.c
> +++ b/drivers/video/s3c-fb.c
> @@ -1070,30 +1070,8 @@ static int s3c_fb_ioctl(struct fb_info *info, unsigned int cmd,
>  	return ret;
>  }
> 
> -static int s3c_fb_open(struct fb_info *info, int user)
> -{
> -	struct s3c_fb_win *win = info->par;
> -	struct s3c_fb *sfb = win->parent;
> -
> -	pm_runtime_get_sync(sfb->dev);
> -
> -	return 0;
> -}
> -
> -static int s3c_fb_release(struct fb_info *info, int user)
> -{
> -	struct s3c_fb_win *win = info->par;
> -	struct s3c_fb *sfb = win->parent;
> -
> -	pm_runtime_put_sync(sfb->dev);
> -
> -	return 0;
> -}
> -
>  static struct fb_ops s3c_fb_ops = {
>  	.owner		= THIS_MODULE,
> -	.fb_open	= s3c_fb_open,
> -	.fb_release	= s3c_fb_release,
>  	.fb_check_var	= s3c_fb_check_var,
>  	.fb_set_par	= s3c_fb_set_par,
>  	.fb_blank	= s3c_fb_blank,
> --
> 1.7.7.3

