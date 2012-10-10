Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755346Ab2JJM3p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 08:29:45 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:42287 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753841Ab2JJM3l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 08:29:41 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX194AMxeZQJ4nMETc3xIbDJz3mQlD8ltah6IhSpxpk
	z4ItfOBGxkhVkY
Message-ID: <50756A21.1020700@gmx.de>
Date: Wed, 10 Oct 2012 12:29:21 +0000
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20120724 Icedove/3.0.11
MIME-Version: 1.0
To: Alexander Holler <holler@ahsoftware.de>
CC: linux-kernel@vger.kernel.org, Bernie Thompson <bernie@plugable.com>,
        linux-fbdev@vger.kernel.org
Subject: Re: [PATCH RESEND] video/udlfb: fix line counting in fb_write
References: <5029FA0D.1090107@ahsoftware.de>
In-Reply-To: <5029FA0D.1090107@ahsoftware.de>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/14/2012 07:11 AM, Alexander Holler wrote:
> Line 0 and 1 were both written to line 0 (on the display) and all
> subsequent
> lines had an offset of -1. The result was that the last line on the display
> was never overwritten by writes to /dev/fbN.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Alexander Holler <holler@ahsoftware.de>

As Bernie agreed but didn't send me a pull request, I applied this one.
Though the formatting was screwed up and I had to fix it...


Best regards,

Florian Tobias Schandinat


> ---
>  drivers/video/udlfb.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/video/udlfb.c b/drivers/video/udlfb.c
> index a159b63..85d8110 100644
> --- a/drivers/video/udlfb.c
> +++ b/drivers/video/udlfb.c
> @@ -647,7 +647,7 @@ static ssize_t dlfb_ops_write(struct fb_info *info,
> const char __user *buf,
>      result = fb_sys_write(info, buf, count, ppos);
>       if (result > 0) {
> -        int start = max((int)(offset / info->fix.line_length) - 1, 0);
> +        int start = max((int)(offset / info->fix.line_length), 0);
>          int lines = min((u32)((result / info->fix.line_length) + 1),
>                  (u32)info->var.yres);
>  -- 1.7.6.5
> 
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-fbdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

