Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753487Ab2DUL0d (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2012 07:26:33 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:43805 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752988Ab2DUL0a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2012 07:26:30 -0400
Message-ID: <4F92995B.6030805@ahsoftware.de>
Date: Sat, 21 Apr 2012 13:26:19 +0200
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Alexander Holler <holler@ahsoftware.de>
CC: linux-kernel@vger.kernel.org, linux-fbdev@vger.kernel.org
Subject: Re: [PATCH] video/smscufx: fix line counting in fb_write
References: <1334959867-3719-1-git-send-email-holler@ahsoftware.de>
In-Reply-To: <1334959867-3719-1-git-send-email-holler@ahsoftware.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

as for the patch for udlfb, I forgot to mention that this is a candidate 
for all stable trees 3.2 and above.

Btw., the address of the maintainer doesn't seem to be valid anymore.

Regards,

Alexander

Am 21.04.2012 00:11, schrieb Alexander Holler:
> Line 0 and 1 were both written to line 0 (on the display) and all subsequent
> lines had an offset of -1. The result was that the last line on the display
> was never overwritten by writes to /dev/fbN.
>
> The origin of this bug seems to have been udlfb.
>
> Signed-off-by: Alexander Holler<holler@ahsoftware.de>

Cc: stable@vger.kernel.org

> ---
>   drivers/video/smscufx.c |    2 +-
>   1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/video/smscufx.c b/drivers/video/smscufx.c
> index ccbfef5..1e1e2d2 100644
> --- a/drivers/video/smscufx.c
> +++ b/drivers/video/smscufx.c
> @@ -904,7 +904,7 @@ static ssize_t ufx_ops_write(struct fb_info *info, const char __user *buf,
>   	result = fb_sys_write(info, buf, count, ppos);
>
>   	if (result>  0) {
> -		int start = max((int)(offset / info->fix.line_length) - 1, 0);
> +		int start = max((int)(offset / info->fix.line_length), 0);
>   		int lines = min((u32)((result / info->fix.line_length) + 1),
>   				(u32)info->var.yres);
>

