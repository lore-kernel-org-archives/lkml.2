Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753719Ab0C2PWR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 11:22:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31903 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753673Ab0C2PWN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 11:22:13 -0400
Message-ID: <4BB0C568.1070803@redhat.com>
Date: Mon, 29 Mar 2010 11:21:12 -0400
From: Peter Jones <pjones@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc14 Thunderbird/3.0.3
MIME-Version: 1.0
To: Henrik Kretzschmar <henne@nachtwindheim.de>
CC: linux-fbdev@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Alex Zhavnerchik <alex.vizor@gmail.com>,
       Huang Ying <ying.huang@intel.com>,
       Arnaud Patard <arnaud.patard@rtp-net.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/7] fbdev: section cleanup in efifb
References: <1269671353-22041-1-git-send-email-henne@nachtwindheim.de>
In-Reply-To: <1269671353-22041-1-git-send-email-henne@nachtwindheim.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/27/2010 02:29 AM, Henrik Kretzschmar wrote:
> This patch fixes the sections on the efifb driver.
> 
> WARNING: drivers/video/built-in.o(.devinit.text+0x19f8c): Section mismatch in re
> ference from the function efifb_probe() to the (unknown reference) .init.data:(u
> nknown)
> The function __devinit efifb_probe() references
> a (unknown reference) __initdata (unknown).
> If (unknown) is only used by efifb_probe then
> annotate (unknown) with a matching annotation.
> 
> WARNING: drivers/video/built-in.o(.devinit.text+0x19f9a): Section mismatch in reference from the function efifb_probe() to the (unknown reference) .init.data:(unknown)
> The function __devinit efifb_probe() references
> a (unknown reference) __initdata (unknown).
> If (unknown) is only used by efifb_probe then
> annotate (unknown) with a matching annotation.
> 
> WARNING: drivers/video/built-in.o(.devinit.text+0x19fa1): Section mismatch in reference from the function efifb_probe() to the variable .init.data:efifb_fix
> The function __devinit efifb_probe() references
> a variable __initdata efifb_fix.
> If efifb_fix is only used by efifb_probe then
> annotate efifb_fix with a matching annotation.
> 
> WARNING: drivers/video/built-in.o(.devinit.text+0x19fa7): Section mismatch in reference from the function efifb_probe() to the variable .init.data:efifb_defined
> The function __devinit efifb_probe() references
> a variable __initdata efifb_defined.
> If efifb_defined is only used by efifb_probe then
> annotate efifb_defined with a matching annotation.
> 
> Signed-off-by: Henrik Kretzschmar <henne@nachtwindheim.de>

Acked-by: Peter Jones <pjones@redhat.com>

> ---
>  drivers/video/efifb.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/video/efifb.c b/drivers/video/efifb.c
> index 581d2db..6aea0d3 100644
> --- a/drivers/video/efifb.c
> +++ b/drivers/video/efifb.c
> @@ -16,7 +16,7 @@
>  
>  #include <video/vga.h>
>  
> -static struct fb_var_screeninfo efifb_defined __initdata = {
> +static struct fb_var_screeninfo efifb_defined __devinitdata = {
>  	.activate		= FB_ACTIVATE_NOW,
>  	.height			= -1,
>  	.width			= -1,
> @@ -27,7 +27,7 @@ static struct fb_var_screeninfo efifb_defined __initdata = {
>  	.vmode			= FB_VMODE_NONINTERLACED,
>  };
>  
> -static struct fb_fix_screeninfo efifb_fix __initdata = {
> +static struct fb_fix_screeninfo efifb_fix __devinitdata = {
>  	.id			= "EFI VGA",
>  	.type			= FB_TYPE_PACKED_PIXELS,
>  	.accel			= FB_ACCEL_NONE,


-- 
        Peter

Sanity's just a one trick pony anyway.  You only get one trick -- rational
thinking -- but when you're good and crazy, the sky's the limit!
		-- The Tick
