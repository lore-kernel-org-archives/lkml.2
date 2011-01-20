Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755904Ab1ATPf4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 10:35:56 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:54275 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755794Ab1ATPfx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 10:35:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=JwqII8nm54TrFgntrOrX//ZTfIgSfrh7l+QgVFKPGoSM3b1zi7guzYC6bSSuklm7un
         XzN3GOBsAKdhFVC5k8R/IlMLgNuOB5+PUkqa9u9jXkyaUdDYUprrfNXf6B1sF/frAxg9
         qmzK5+vnu/u6OJMYwwtmWsGVdq3uKJK+cVNu0=
Subject: Re: [PATCH v3] net: add Faraday FTMAC100 10/100 Ethernet driver
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Po-Yu Chuang <ratbert.chuang@gmail.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bhutchings@solarflare.com, joe@perches.com, dilinger@queued.net,
        Po-Yu Chuang <ratbert@faraday-tech.com>
In-Reply-To: <1295537418-2057-1-git-send-email-ratbert.chuang@gmail.com>
References: <1295256060-2091-1-git-send-email-ratbert.chuang@gmail.com>
	 <1295537418-2057-1-git-send-email-ratbert.chuang@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 20 Jan 2011 16:35:46 +0100
Message-ID: <1295537746.2825.298.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 20 janvier 2011 à 23:30 +0800, Po-Yu Chuang a écrit :

> +	/* push packet to protocol stack */
> +	netif_receive_skb(skb);
> +
> +	netdev->stats.rx_packets++;
> +	netdev->stats.rx_bytes += skb->len;
> +
> +	(*processed)++;
> +
> +	return true;
> +}
> +

Hmm, after call to netif_receive_skb(skb), you are not allowed to access
skb anymore (maybe it was freed)

netdev->stats.rx_packets++;
netdev->stats.rx_bytes += skb->len;
netif_receive_skb(skb);



