Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754371Ab0J3OgE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Oct 2010 10:36:04 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:51558 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753661Ab0J3OgA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Oct 2010 10:36:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=dyFCXRAD8uDiEQfeziEDtp/AWzGfj8nOwn35/xnFVqjCuTprQfE77O3qqdnRkXODtm
         ZIe4EdX3R7ZxGLeFO5cv3+Rz0Yx/0+rF7DNcR+9B+/lz3XfPk/wxqk/X3zYyNrl0olfK
         Qv9TEFRSBrooZlKWP5O0LzIEG/KZQonuPTDo0=
Subject: Re: [PATCH] net: core: sock: fix information leak to userland
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Vasiliy Kulikov <segooon@gmail.com>
Cc: kernel-janitors@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <1288448801-6303-1-git-send-email-segooon@gmail.com>
References: <1288448801-6303-1-git-send-email-segooon@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 30 Oct 2010 16:35:50 +0200
Message-ID: <1288449350.2680.970.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le samedi 30 octobre 2010 à 18:26 +0400, Vasiliy Kulikov a écrit :
> "Address" variable might be not fully initialized in sock->ops->get_name().
> The only current implementation is get_name(), it leaves some padding
> fields of sockaddr_tipc uninitialized.  It leads to leaking of contents
> of kernel stack memory.
> 
> Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>
> ---
>  Compile tested.
> 
>  net/core/sock.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/net/core/sock.c b/net/core/sock.c
> index 3eed542..759dd81 100644
> --- a/net/core/sock.c
> +++ b/net/core/sock.c
> @@ -930,6 +930,7 @@ int sock_getsockopt(struct socket *sock, int level, int optname,
>  	{
>  		char address[128];
>  
> +		memset(&address, 0, sizeof(address));
>  		if (sock->ops->getname(sock, (struct sockaddr *)address, &lv, 2))
>  			return -ENOTCONN;
>  		if (lv < len)

???

Please fix the real bug.



