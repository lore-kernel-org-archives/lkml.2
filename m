Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932538Ab1EYUmJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 16:42:09 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41599 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932417Ab1EYUmH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 16:42:07 -0400
Message-ID: <4DDD69DD.7030601@suse.cz>
Date: Wed, 25 May 2011 22:43:09 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.14) Gecko/20110221 SUSE/3.1.8 Thunderbird/3.1.8
MIME-Version: 1.0
To: linux-kbuild@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        netdev@vger.kernel.org
Subject: Re: [PATCH 18/34] wan/pc300: Drop __TIME__ usage
References: <1302015561-21047-1-git-send-email-mmarek@suse.cz> <1302015561-21047-19-git-send-email-mmarek@suse.cz>
In-Reply-To: <1302015561-21047-19-git-send-email-mmarek@suse.cz>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dne 5.4.2011 16:59, Michal Marek napsal(a):
> The kernel already prints its build timestamp during boot, no need to
> repeat it in random drivers and produce different object files each
> time.
> 
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: netdev@vger.kernel.org
> Signed-off-by: Michal Marek <mmarek@suse.cz>
> ---
>  drivers/net/wan/pc300_drv.c |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)

I don't see the patch in today's linux-next. Does anyone object against
me applying it to kbuild-2.6.git?

Thanks,
Michal


> diff --git a/drivers/net/wan/pc300_drv.c b/drivers/net/wan/pc300_drv.c
> index f875cfa..80ae503 100644
> --- a/drivers/net/wan/pc300_drv.c
> +++ b/drivers/net/wan/pc300_drv.c
> @@ -3242,8 +3242,7 @@ static inline void show_version(void)
>  	rcsdate++;
>  	tmp = strrchr(rcsdate, ' ');
>  	*tmp = '\0';
> -	printk(KERN_INFO "Cyclades-PC300 driver %s %s (built %s %s)\n", 
> -		rcsvers, rcsdate, __DATE__, __TIME__);
> +	printk(KERN_INFO "Cyclades-PC300 driver %s %s\n", rcsvers, rcsdate);
>  }				/* show_version */
>  
>  static const struct net_device_ops cpc_netdev_ops = {

