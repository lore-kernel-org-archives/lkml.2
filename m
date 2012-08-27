Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753571Ab2H0JRo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 05:17:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51202 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753474Ab2H0JRn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 05:17:43 -0400
Subject: Re: [PATCH] decnet: fix shutdown parameter checking
From: Steven Whitehouse <swhiteho@redhat.com>
To: Xi Wang <xi.wang@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <1346035027-2347-1-git-send-email-xi.wang@gmail.com>
References: <1346035027-2347-1-git-send-email-xi.wang@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat UK Ltd
Date: Mon, 27 Aug 2012 10:16:41 +0100
Message-ID: <1346059001.2703.7.camel@menhir>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sun, 2012-08-26 at 22:37 -0400, Xi Wang wrote:
> The allowed value of "how" is SHUT_RD/SHUT_WR/SHUT_RDWR (0/1/2),
> rather than SHUTDOWN_MASK (3).
> 
> Signed-off-by: Xi Wang <xi.wang@gmail.com>
Acked-by: Steven Whitehouse <swhiteho@redhat.com>

Although it could be argued that we should also continue to accept the
value 3 just in case there is any userland software out there which
sends that value,

Steve.

> ---
>  net/decnet/af_decnet.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/net/decnet/af_decnet.c b/net/decnet/af_decnet.c
> index 2ba1a28..307c322 100644
> --- a/net/decnet/af_decnet.c
> +++ b/net/decnet/af_decnet.c
> @@ -1313,10 +1313,10 @@ static int dn_shutdown(struct socket *sock, int how)
>  	if (scp->state == DN_O)
>  		goto out;
>  
> -	if (how != SHUTDOWN_MASK)
> +	if (how != SHUT_RDWR)
>  		goto out;
>  
> -	sk->sk_shutdown = how;
> +	sk->sk_shutdown = SHUTDOWN_MASK;
>  	dn_destroy_sock(sk);
>  	err = 0;
>  


