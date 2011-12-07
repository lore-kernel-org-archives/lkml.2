Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750839Ab1LGFAE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 00:00:04 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:54306 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755776Ab1LGFAA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 00:00:00 -0500
Message-ID: <1323233994.2690.29.camel@edumazet-laptop>
Subject: Re: [PATCH] ppp: fix pptp double release_sock in pptp_bind()
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Djalal Harouni <tixxdz@opendz.org>
Cc: Dmitry Kozlov <xeb@mail.ru>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Wed, 07 Dec 2011 05:59:54 +0100
In-Reply-To: <20111207014712.GB25869@dztty>
References: <20111207014712.GB25869@dztty>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 07 décembre 2011 à 02:47 +0100, Djalal Harouni a écrit :
> Signed-off-by: Djalal Harouni <tixxdz@opendz.org>
> ---
>  drivers/net/ppp/pptp.c |    4 +---
>  1 files changed, 1 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/ppp/pptp.c b/drivers/net/ppp/pptp.c
> index 89f829f..f8a6853 100644
> --- a/drivers/net/ppp/pptp.c
> +++ b/drivers/net/ppp/pptp.c
> @@ -423,10 +423,8 @@ static int pptp_bind(struct socket *sock, struct sockaddr *uservaddr,
>  	lock_sock(sk);
>  
>  	opt->src_addr = sp->sa_addr.pptp;
> -	if (add_chan(po)) {
> -		release_sock(sk);
> +	if (add_chan(po))
>  		error = -EBUSY;
> -	}
>  
>  	release_sock(sk);
>  	return error;

Nice catch !

Acked-by: Eric Dumazet <eric.dumazet@gmail.com>



