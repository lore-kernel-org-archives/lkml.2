Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756066Ab0D1RpG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 13:45:06 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:42572 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755448Ab0D1RpD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 13:45:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=oGL7z8366cu2llAzVre5lKZmko50BRuYDk9TU/PrKul5G8+Yxhcb/sHU9unCnGPme3
         Q0lWe7d/pwtudzrZvyos/r2pFtSUgYJfY8QyI31RGxFHmFD3chLUzvTl/tk3MYVBtiHg
         H6EXABLKTOsHKbydOhoD2aburf3Smv50j+BmY=
Subject: Re: Problem with "tcp: bind() fix when many ports are bound" commit
From: Eric Dumazet <eric.dumazet@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: grzegorz.chwesewicz@retis.net.pl, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, Evgeniy Polyakov <zbr@ioremap.net>
In-Reply-To: <1272476040.2267.87.camel@edumazet-laptop>
References: <4BD82B29.3000105@retis.net.pl>
	 <20100428.095032.32709294.davem@davemloft.net>
	 <1272476040.2267.87.camel@edumazet-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 28 Apr 2010 19:44:57 +0200
Message-ID: <1272476697.2267.95.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 28 avril 2010 à 19:34 +0200, Eric Dumazet a écrit :
> L
> I am going to test following patch in a couple of hours (I have to
> run ...)
> 
> Always allowing a reuse LISTEN if no other listener is already active on
> same IP.
> 
> diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
> index 78cbc39..e2076dd 100644
> --- a/net/ipv4/inet_connection_sock.c
> +++ b/net/ipv4/inet_connection_sock.c
> @@ -78,6 +78,7 @@ int inet_csk_bind_conflict(const struct sock *sk,
>  				    sk2_rcv_saddr == sk_rcv_saddr)
>  					break;
>  			} else if (reuse && sk2->sk_reuse &&
> +				   sk->sk_state != TCP_LISTEN &&
>  				   sk2_rcv_saddr &&
>  				   sk2_rcv_saddr == sk_rcv_saddr)
>  				break;
> 
> 
> --

Hmm, this wont work because we dont know this sk socket will serve as a
listener.

bind(... port=80);

listen(...) or connect(...)

David, I think we should revert patches for linux-2.6, and work on this
problem more closely on net-next-2.6

Thanks


