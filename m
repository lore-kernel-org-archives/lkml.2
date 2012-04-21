Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752338Ab2DUL01 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2012 07:26:27 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:43804 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751291Ab2DUL0Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2012 07:26:25 -0400
Message-ID: <4F929948.9010504@ahsoftware.de>
Date: Sat, 21 Apr 2012 13:26:00 +0200
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Alexander Holler <holler@ahsoftware.de>
CC: linux-kernel@vger.kernel.org, Bernie Thompson <bernie@plugable.com>,
        linux-fbdev@vger.kernel.org
Subject: Re: [PATCH] video/udlfb: fix line counting in fb_write
References: <1334959844-3665-1-git-send-email-holler@ahsoftware.de>
In-Reply-To: <1334959844-3665-1-git-send-email-holler@ahsoftware.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

sorry, I forgot to mention that this is a candidate for all stable trees 
2.6.37 and above. Not sure how to announce that, but I think I should 
have added the below Cc: to the patch.

Regards,

Alexander

Am 21.04.2012 00:10, schrieb Alexander Holler:
> Line 0 and 1 were both written to line 0 (on the display) and all subsequent
> lines had an offset of -1. The result was that the last line on the display
> was never overwritten by writes to /dev/fbN.
>
> Signed-off-by: Alexander Holler<holler@ahsoftware.de>

Cc: stable@vger.kernel.org

> ---
>   drivers/video/udlfb.c |    2 +-
>   1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/video/udlfb.c b/drivers/video/udlfb.c
> index a159b63..85d8110 100644
> --- a/drivers/video/udlfb.c
> +++ b/drivers/video/udlfb.c
> @@ -647,7 +647,7 @@ static ssize_t dlfb_ops_write(struct fb_info *info, const char __user *buf,
>   	result = fb_sys_write(info, buf, count, ppos);
>
>   	if (result>  0) {
> -		int start = max((int)(offset / info->fix.line_length) - 1, 0);
> +		int start = max((int)(offset / info->fix.line_length), 0);
>   		int lines = min((u32)((result / info->fix.line_length) + 1),
>   				(u32)info->var.yres);
>

