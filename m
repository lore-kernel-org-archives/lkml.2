Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752233Ab1JPVeT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Oct 2011 17:34:19 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:52946 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751848Ab1JPVeS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Oct 2011 17:34:18 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX190SoRul9F0Spwmm675JHA3eVh8rw0lxm57fCpSM9
	xxoGXFf9U2qJnb
Message-ID: <4E9B4DD5.8050108@gmx.de>
Date: Sun, 16 Oct 2011 21:34:13 +0000
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20110818 Icedove/3.0.11
MIME-Version: 1.0
To: Axel Lin <axel.lin@gmail.com>
CC: linux-kernel@vger.kernel.org, linux-fbdev@vger.kernel.org
Subject: Re: [PATCH] video: platinumfb: Add __devexit_p at necessary place
References: <1317801698.12133.1.camel@phoenix>
In-Reply-To: <1317801698.12133.1.camel@phoenix>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/05/2011 08:01 AM, Axel Lin wrote:
> According to the comments in include/linux/init.h:
> 
> "Pointers to __devexit functions must use __devexit_p(function_name), the
> wrapper will insert either the function_name or NULL, depending on the config
> options."
> 
> We have __devexit annotation for platinumfb_remove(), thus add __devexit_p at
> necessary place.

Applied.


Thanks,

Florian Tobias Schandinat

> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  drivers/video/platinumfb.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/video/platinumfb.c b/drivers/video/platinumfb.c
> index 6694923..ae3caa6 100644
> --- a/drivers/video/platinumfb.c
> +++ b/drivers/video/platinumfb.c
> @@ -683,7 +683,7 @@ static struct platform_driver platinum_driver =
>  		.of_match_table = platinumfb_match,
>  	},
>  	.probe		= platinumfb_probe,
> -	.remove		= platinumfb_remove,
> +	.remove		= __devexit_p(platinumfb_remove),
>  };
>  
>  static int __init platinumfb_init(void)

