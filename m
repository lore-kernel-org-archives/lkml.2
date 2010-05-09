Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751535Ab0EIVJs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 May 2010 17:09:48 -0400
Received: from mga10.intel.com ([192.55.52.92]:41882 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751228Ab0EIVJr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 May 2010 17:09:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.52,358,1270450800"; 
   d="scan'208";a="565558690"
Date: Sun, 9 May 2010 23:10:30 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Rabin Vincent <rabin@rab.in>
Cc: broonie@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: WM8350: remove incorrect kfree
Message-ID: <20100509211029.GB3269@sortiz.org>
References: <1271864165-8096-1-git-send-email-rabin@rab.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1271864165-8096-1-git-send-email-rabin@rab.in>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vincent,

On Wed, Apr 21, 2010 at 09:06:05PM +0530, Rabin Vincent wrote:
> The i2c_client received in probe() should not be kfree()'d.
Patch applied, many thanks.

Cheers,
Samuel.


> Signed-off-by: Rabin Vincent <rabin@rab.in>
> ---
>  drivers/mfd/wm8350-i2c.c |    4 +---
>  1 files changed, 1 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/mfd/wm8350-i2c.c b/drivers/mfd/wm8350-i2c.c
> index 65830f5..5fe5de1 100644
> --- a/drivers/mfd/wm8350-i2c.c
> +++ b/drivers/mfd/wm8350-i2c.c
> @@ -64,10 +64,8 @@ static int wm8350_i2c_probe(struct i2c_client *i2c,
>  	int ret = 0;
>  
>  	wm8350 = kzalloc(sizeof(struct wm8350), GFP_KERNEL);
> -	if (wm8350 == NULL) {
> -		kfree(i2c);
> +	if (wm8350 == NULL)
>  		return -ENOMEM;
> -	}
>  
>  	i2c_set_clientdata(i2c, wm8350);
>  	wm8350->dev = &i2c->dev;
> -- 
> 1.7.0.4
> 

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
