Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753872Ab1ABQeN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 11:34:13 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:48587 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751348Ab1ABQeL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 11:34:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=iOiHTGiYhjUXoIQnmwDJYO8iKlYO0jKM4W95gXbfY3tpVkglfbrHM1Ew5YILr0KdtL
         6k7DPicrx6DTJr5HvNsp/MulZ+OCE/1hCHEoOfAFkG5bK6cfBtbv3TCAgu1DlMw2xKzG
         OeXdnrtT6xTK+q4h9Vv0pwCkjLmf0PiX04P4w=
Subject: Re: [PATCH] new UDPCP Communication Protocol
From: Eric Dumazet <eric.dumazet@gmail.com>
To: stefani@seibold.net
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        davem@davemloft.net, netdev@vger.kernel.org, shemminger@vyatta.com
In-Reply-To: <1293982286-15389-1-git-send-email-stefani@seibold.net>
References: <1293982286-15389-1-git-send-email-stefani@seibold.net>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 02 Jan 2011 17:34:04 +0100
Message-ID: <1293986044.2535.104.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le dimanche 02 janvier 2011 à 16:31 +0100, stefani@seibold.net a écrit :
> From: Stefani Seibold <stefani@seibold.net>
> 
> Changelog:
> 31.12.2010 first proposal
> 01.01.2011 code cleanup and fixes suggest by Eric Dumazet
> 02.01.2011 kick away UDP-Lite support
>            change spin_lock_irq into spin_lock_bh
> 	   faster udpcp_release_sock
> 	   base is now linux-next
...

> +/*
> + * Create a new destination descriptor for the given IPV4 address and port
> + */
> +static struct udpcp_dest *new_dest(struct sock *sk, __be32 addr, __be16 port)
> +{
> +	struct udpcp_dest *dest;
> +	struct udpcp_sock *usk = udpcp_sk(sk);
> +
> +	dest = kzalloc(sizeof(*dest), sk->sk_allocation);
> +
> +	if (dest) {
> +		skb_queue_head_init(&dest->xmit);
> +		dest->addr = addr;
> +		dest->port = port;
> +		dest->ackmode = UDPCP_ACK;
> +		list_add_tail(&dest->list, &usk->destlist);
> +	}
> +
> +	return dest;
> +}
> +

I have not found what prevents a malicious user to make destlist grow
and consume all memory ?



