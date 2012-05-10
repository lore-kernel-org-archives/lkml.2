Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761434Ab2EJAM0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 20:12:26 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:37862 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1759025Ab2EJAMY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 20:12:24 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX1+JxEc+MmKJ8Cq6e2rXJo2E/RyMC1IZN+ysNHvrjm
	nCv4OUn5WWIPcF
Message-ID: <4FAB07E0.5070209@gmx.de>
Date: Thu, 10 May 2012 00:12:16 +0000
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20120428 Icedove/3.0.11
MIME-Version: 1.0
To: H Hartley Sweeten <hartleys@visionengravers.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>, linux-fbdev@vger.kernel.org,
        agust@denx.de
Subject: Re: [PATCH] video: mb862xx-i2c: local functions should not be exposed
 globally
References: <201205021734.16988.hartleys@visionengravers.com>
In-Reply-To: <201205021734.16988.hartleys@visionengravers.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/03/2012 12:34 AM, H Hartley Sweeten wrote:
> Functions not referenced outside of a source file should be marked
> static to prevent them from being exposed globally.
> 
> Quiets the sparse warnings:
> 
> warning: symbol 'mb862xx_i2c_stop' was not declared. Should it be static?
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
> diff --git a/drivers/video/mb862xx/mb862xx-i2c.c b/drivers/video/mb862xx/mb862xx-i2c.c
> index 273769b..c87e17a 100644
> --- a/drivers/video/mb862xx/mb862xx-i2c.c
> +++ b/drivers/video/mb862xx/mb862xx-i2c.c
> @@ -68,7 +68,7 @@ static int mb862xx_i2c_read_byte(struct i2c_adapter *adap, u8 *byte, int last)
>  	return 1;
>  }
>  
> -void mb862xx_i2c_stop(struct i2c_adapter *adap)
> +static void mb862xx_i2c_stop(struct i2c_adapter *adap)
>  {
>  	struct mb862xxfb_par *par = adap->algo_data;
>  
> 

