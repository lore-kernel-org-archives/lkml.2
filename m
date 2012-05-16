Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760245Ab2EPSau (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 14:30:50 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:61500 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760170Ab2EPSar (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 14:30:47 -0400
Date: Wed, 16 May 2012 11:30:39 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: sonic.zhang@analog.com
Cc: linux-input@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        uclinux-dist-devel@blackfin.uclinux.org
Subject: Re: [PATCH] input: rotary: Init wake according to platform pm_wakeup
 flag.
Message-ID: <20120516183038.GA14471@core.coreip.homeip.net>
References: <1337157383-13631-1-git-send-email-sonic.zhang@analog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1337157383-13631-1-git-send-email-sonic.zhang@analog.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sonic,

On Wed, May 16, 2012 at 04:36:23PM +0800, sonic.zhang@analog.com wrote:
> From: Sonic Zhang <sonic.zhang@analog.com>
> 
> Rotary can't be used as a wakeup source in all Blackfin processors.
> 
> Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
> ---
>  drivers/input/misc/bfin_rotary.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/input/misc/bfin_rotary.c b/drivers/input/misc/bfin_rotary.c
> index 1c4146f..bb1971c 100644
> --- a/drivers/input/misc/bfin_rotary.c
> +++ b/drivers/input/misc/bfin_rotary.c
> @@ -182,7 +182,7 @@ static int __devinit bfin_rotary_probe(struct platform_device *pdev)
>  	bfin_write_CNT_CONFIG(bfin_read_CNT_CONFIG() | CNTE);
>  
>  	platform_set_drvdata(pdev, rotary);
> -	device_init_wakeup(&pdev->dev, 1);
> +	device_init_wakeup(&pdev->dev, pdata->pm_wakeup);

I do not see pm_wakeup in bfin_rotary_platform_data.

Thanks.

-- 
Dmitry
