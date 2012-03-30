Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760055Ab2C3BRG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 21:17:06 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:52891 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754443Ab2C3BQ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 21:16:58 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX18ro8pOB8Urb0U2fBUrzXSblIqts6GH/gjoaYJUIY
	lqZMW/tF6cCgdE
Message-ID: <4F750970.6040801@gmx.de>
Date: Fri, 30 Mar 2012 01:16:32 +0000
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20120317 Icedove/3.0.11
MIME-Version: 1.0
To: Chris Wilson <chris@chris-wilson.co.uk>
CC: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] video/console: Clip the right margin clear to the visible
 region
References: <1332793022-29292-1-git-send-email-chris@chris-wilson.co.uk>
In-Reply-To: <1332793022-29292-1-git-send-email-chris@chris-wilson.co.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chris,

On 03/26/2012 08:17 PM, Chris Wilson wrote:
> For some unknown reason, yres_virtual was 2x larger the the size specified
> by i915 and so when blit_clear_margins() tried to clear the full virtual
> right-hand margin it tried to write far beyond the end of the buffer.
> 
> This limits the clear to only the visible portion of the right-hand
> margin, similar to how the bottom margin is treated.
> 
> Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=38138

as you also found the root of the problem and posted a patch to fix i915
(or rather all KMS-based framebuffers) by validating the virtual
resolution in check var, I don't see any reason to apply this one. I'm
not sure about it, but changing the behaviour of this function might
cause some undesired changes in user experience and as there is no
problem with this code as is, I'd prefer to not change it.


Best regards,

Florian Tobias Schandinat

> Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
> Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
> ---
>  drivers/video/console/bitblit.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/video/console/bitblit.c b/drivers/video/console/bitblit.c
> index 28b1a83..9f89e5a 100644
> --- a/drivers/video/console/bitblit.c
> +++ b/drivers/video/console/bitblit.c
> @@ -219,9 +219,9 @@ static void bit_clear_margins(struct vc_data *vc, struct fb_info *info,
>  
>  	if (rw && !bottom_only) {
>  		region.dx = info->var.xoffset + rs;
> -		region.dy = 0;
> +		region.dy = info->var.yoffset;
>  		region.width = rw;
> -		region.height = info->var.yres_virtual;
> +		region.height = info->var.yres;
>  		info->fbops->fb_fillrect(info, &region);
>  	}
>  

