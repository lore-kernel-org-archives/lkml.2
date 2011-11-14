Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756583Ab1KNWnX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 17:43:23 -0500
Received: from mx1.redhat.com ([209.132.183.28]:22837 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751654Ab1KNWnW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 17:43:22 -0500
Message-ID: <1321310590.16847.3.camel@dcbw.foobar.com>
Subject: Re: [PATCH] Net, libertas: Resolve memory leak in
 if_spi_host_to_card()
From: Dan Williams <dcbw@redhat.com>
To: Jesper Juhl <jj@chaosbits.net>
Cc: libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Andrey Yurovsky <andrey@cozybit.com>, Colin McCabe <colin@cozybit.com>,
        "John W. Linville" <linville@tuxdriver.com>
Date: Mon, 14 Nov 2011 16:43:10 -0600
In-Reply-To: <alpine.LNX.2.00.1111132211580.3368@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1111132211580.3368@swampdragon.chaosbits.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-11-13 at 22:14 +0100, Jesper Juhl wrote:
> If we hit the default case in the switch in if_spi_host_to_card() we'll leak
> the memory we allocated for 'packet'. This patch resolves the leak by freeing
> the allocated memory in that case.
> 
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>

Acked-by: Dan Williams <dcbw@redhat.com>

> ---
>  drivers/net/wireless/libertas/if_spi.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
>  Compile tested only due to lack of hardware.
> 
> diff --git a/drivers/net/wireless/libertas/if_spi.c b/drivers/net/wireless/libertas/if_spi.c
> index 11b69b3..728baa4 100644
> --- a/drivers/net/wireless/libertas/if_spi.c
> +++ b/drivers/net/wireless/libertas/if_spi.c
> @@ -995,6 +995,7 @@ static int if_spi_host_to_card(struct lbs_private *priv,
>  		spin_unlock_irqrestore(&card->buffer_lock, flags);
>  		break;
>  	default:
> +		kfree(packet);
>  		netdev_err(priv->dev, "can't transfer buffer of type %d\n",
>  			   type);
>  		err = -EINVAL;
> -- 
> 1.7.7.3
> 
> 


