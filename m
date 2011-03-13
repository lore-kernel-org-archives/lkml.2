Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932210Ab1CMUaA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Mar 2011 16:30:00 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:50344 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932138Ab1CMU37 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Mar 2011 16:29:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=fyuRxtQtkSqFw6AnW9Lpc0iEoJgiVV1irXdpcVYN3kKaP9kllKZtYfE+COjpE724wl
         aTNFUFh1QypAKy6l0eQWijVqkntmqHEG8U1nb7ywhe7GsprI8BptkXJH88KbCewYg1uf
         /s7UgkSaqalVGbuX7t8OinbVuUtb19mGigU6s=
Subject: Re: [PATCH net-next-2.6] ftmac100: use GFP_ATOMIC allocations
 where needed
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Po-Yu Chuang <ratbert.chuang@gmail.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Po-Yu Chuang <ratbert@faraday-tech.com>
In-Reply-To: <1300048002.2761.53.camel@edumazet-laptop>
References: <1299744517-1896-1-git-send-email-ratbert.chuang@gmail.com>
	 <1300047388.2761.48.camel@edumazet-laptop>
	 <1300048002.2761.53.camel@edumazet-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 13 Mar 2011 21:29:53 +0100
Message-ID: <1300048193.2761.55.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le dimanche 13 mars 2011 à 21:26 +0100, Eric Dumazet a écrit :
> Le dimanche 13 mars 2011 à 21:16 +0100, Eric Dumazet a écrit :
> 
> > BTW, it seems I missed the fact that ftmac100_alloc_rx_page() used a
> > GFP_KERNEL allocation, while its called from softirq context (from
> > ftmac100_rx_packet()) 
> 
> Here is a patch against ftmac100
> 

Oops, one typo in it sorry 

> -static int ftmac100_alloc_rx_page(struct ftmac100 *priv, struct ftmac100_rxdes *rxdes)
> +static int ftmac100_alloc_rx_page(struct ftmac100 *priv,
> +				  struct ftmac100_rxdes *rxdes, gtp_t gfp)

Should be :   gfp_t gfp

Please build and test the patch, I dont have an ARM testbed anyway.

Thanks


