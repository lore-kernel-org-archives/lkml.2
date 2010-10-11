Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753809Ab0JKI7q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 04:59:46 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:61330 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753429Ab0JKI7p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 04:59:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=kg1mTw47bS9F0m8zRd9gQ62hvZprPrGKPs2N98K7XLRoJ9hsLst8/JtTTx+eWYTmss
         bPaYcqmbPMOqJrXMoRbZTP2c7yXD3c7wmpYdg3/0NsBIpuTfpbfpgdzF7AEPh3ir/Gew
         H2OHIjDhUanVPyDsvP5BY4ZdV9PvcHOe//xXY=
Subject: Re: [PATCH 1/1] ATM: mpc, fix use after free
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Jiri Slaby <jslaby@suse.cz>
Cc: davem@davemloft.net, netdev@vger.kernel.org,
        linux-atm-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        jirislaby@gmail.com
In-Reply-To: <1286786794-10410-1-git-send-email-jslaby@suse.cz>
References: <1286785081.2737.2.camel@edumazet-laptop>
	 <1286786794-10410-1-git-send-email-jslaby@suse.cz>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 11 Oct 2010 10:59:40 +0200
Message-ID: <1286787580.2737.4.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi 11 octobre 2010 à 10:46 +0200, Jiri Slaby a écrit :
> Stanse found that mpc_push frees skb and then it dereferences it. It
> is a typo, new_skb should be dereferenced there.
> 
> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> Cc: Eric Dumazet <eric.dumazet@gmail.com>
> ---
>  net/atm/mpc.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/net/atm/mpc.c b/net/atm/mpc.c
> index 622b471..74bcc66 100644
> --- a/net/atm/mpc.c
> +++ b/net/atm/mpc.c
> @@ -778,7 +778,7 @@ static void mpc_push(struct atm_vcc *vcc, struct sk_buff *skb)
>  	eg->packets_rcvd++;
>  	mpc->eg_ops->put(eg);
>  
> -	memset(ATM_SKB(skb), 0, sizeof(struct atm_skb_data));
> +	memset(ATM_SKB(new_skb), 0, sizeof(struct atm_skb_data));
>  	netif_rx(new_skb);
>  }
>  

Acked-by: Eric Dumazet <eric.dumazet@gmail.com>


