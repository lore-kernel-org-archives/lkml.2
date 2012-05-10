Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761443Ab2EJAMp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 20:12:45 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:60938 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1759025Ab2EJAMm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 20:12:42 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX1/i9AohN+riePIDtS03PDlkfCG1GQJvbtwl3kcZYl
	u/zsI8UoayLjJT
Message-ID: <4FAB07F1.4010900@gmx.de>
Date: Thu, 10 May 2012 00:12:33 +0000
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20120428 Icedove/3.0.11
MIME-Version: 1.0
To: H Hartley Sweeten <hartleys@visionengravers.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>, linux-fbdev@vger.kernel.org,
        agust@denx.de
Subject: Re: [PATCH] video: mb862xxfbdrv.c: local functions should not be
 exposed globally
References: <201205021737.35719.hartleys@visionengravers.com>
In-Reply-To: <201205021737.35719.hartleys@visionengravers.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/03/2012 12:37 AM, H Hartley Sweeten wrote:
> Functions not referenced outside of a source file should be marked
> static to prevent them from being exposed globally.
> 
> Quiets the sparse warnings:
> 
> warning: symbol 'mb862xx_intr' was not declared. Should it be static?
> 
> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
> Cc: Anatolij Gustschin <agust@denx.de>

Applied.


Thanks,

Florian Tobias Schandinat

> 
> ---
> 
> diff --git a/drivers/video/mb862xx/mb862xxfbdrv.c b/drivers/video/mb862xx/mb862xxfbdrv.c
> index 11a7a33..00ce1f3 100644
> --- a/drivers/video/mb862xx/mb862xxfbdrv.c
> +++ b/drivers/video/mb862xx/mb862xxfbdrv.c
> @@ -579,7 +579,7 @@ static ssize_t mb862xxfb_show_dispregs(struct device *dev,
>  
>  static DEVICE_ATTR(dispregs, 0444, mb862xxfb_show_dispregs, NULL);
>  
> -irqreturn_t mb862xx_intr(int irq, void *dev_id)
> +static irqreturn_t mb862xx_intr(int irq, void *dev_id)
>  {
>  	struct mb862xxfb_par *par = (struct mb862xxfb_par *) dev_id;
>  	unsigned long reg_ist, mask;
> 

