Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964958Ab2DLCWP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 22:22:15 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:56823 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757181Ab2DLCWN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 22:22:13 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX18+dh14Q38+6uxuZXr9HXryfRETLSAo5f4BJ16zlW
	Pb+xtOkNzOueqR
Message-ID: <4F863C53.5060205@gmx.de>
Date: Thu, 12 Apr 2012 02:22:11 +0000
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20120317 Icedove/3.0.11
MIME-Version: 1.0
To: Axel Lin <axel.lin@gmail.com>
CC: linux-kernel@vger.kernel.org, Daniel Mack <daniel@caiaq.de>,
        Sven Neumann <s.neumann@raumfeld.com>, Janine Kropp <nin@directfb.org>,
        Denis Oliver Kropp <dok@directfb.org>, linux-fbdev@vger.kernel.org
Subject: Re: [PATCH] video: pxa3xx-gcu: Simplify the logic to exit while loop
 in pxa3xx_gcu_wait_idle
References: <1332818156.21855.4.camel@phoenix>
In-Reply-To: <1332818156.21855.4.camel@phoenix>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/27/2012 03:15 AM, Axel Lin wrote:
> If wait_event_interruptible_timeout returns a positive value, it means
> the condition evaluated is true. Which means priv->shared->hw_running is false.
> And then we will exit the loop.
> 
> This patch simplifies the logic to exit the while loop.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Applied.


Thanks,

Florian Tobias Schandinat

> ---
>  drivers/video/pxa3xx-gcu.c |    5 +----
>  1 files changed, 1 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/video/pxa3xx-gcu.c b/drivers/video/pxa3xx-gcu.c
> index 1d71c08..0b4ae0c 100644
> --- a/drivers/video/pxa3xx-gcu.c
> +++ b/drivers/video/pxa3xx-gcu.c
> @@ -316,12 +316,9 @@ pxa3xx_gcu_wait_idle(struct pxa3xx_gcu_priv *priv)
>  		ret = wait_event_interruptible_timeout(priv->wait_idle,
>  					!priv->shared->hw_running, HZ*4);
>  
> -		if (ret < 0)
> +		if (ret != 0)
>  			break;
>  
> -		if (ret > 0)
> -			continue;
> -
>  		if (gc_readl(priv, REG_GCRBEXHR) == rbexhr &&
>  		    priv->shared->num_interrupts == num) {
>  			QERROR("TIMEOUT");

