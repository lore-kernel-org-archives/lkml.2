Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752668Ab1KKGTL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Nov 2011 01:19:11 -0500
Received: from cobra.newdream.net ([66.33.216.30]:46341 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750945Ab1KKGTJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Nov 2011 01:19:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws; d=newdream.net; h=date:from:to:cc
	:subject:in-reply-to:message-id:references:mime-version:
	content-type; q=dns; s=newdream.net; b=C7tMB9XbVeGQqPbMFswbTOTu/
	B6UxuLjLS2fzhJ/e+3zcV9+T+q0eoTJBzlM8xGYRM6K16v2/mT3M+QwslZ02Zw0U
	Zeve+AOr0X/DMXomfY5hSWlAM7xIdVevjfPTjpI6rdOKdmtBDvGKDe3Itv5QaOfD
	dLrOJU1WpPbNFxKNK8=
Date: Thu, 10 Nov 2011 22:19:09 -0800 (PST)
From: Sage Weil <sage@newdream.net>
To: Thomas Meyer <thomas@m3y3r.de>
cc: "David S. Miller" <davem@davemloft.net>, ceph-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ceph: Use kmemdup rather than duplicating its implementation
In-Reply-To: <1320950721.20155.111.camel@localhost.localdomain>
Message-ID: <Pine.LNX.4.64.1111102219050.27241@cobra.newdream.net>
References: <1320950721.20155.111.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Applied, thanks!

On Thu, 10 Nov 2011, Thomas Meyer wrote:

> Use kmemdup rather than duplicating its implementation
> 
> The semantic patch that makes this change is available
> in scripts/coccinelle/api/memdup.cocci.
> 
> Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
> ---
> 
> diff -u -p a/net/ceph/crypto.c b/net/ceph/crypto.c
> --- a/net/ceph/crypto.c 2011-11-07 19:38:30.130592543 +0100
> +++ b/net/ceph/crypto.c 2011-11-08 10:58:06.915274800 +0100
> @@ -15,10 +15,9 @@ int ceph_crypto_key_clone(struct ceph_cr
>  			  const struct ceph_crypto_key *src)
>  {
>  	memcpy(dst, src, sizeof(struct ceph_crypto_key));
> -	dst->key = kmalloc(src->len, GFP_NOFS);
> +	dst->key = kmemdup(src->key, src->len, GFP_NOFS);
>  	if (!dst->key)
>  		return -ENOMEM;
> -	memcpy(dst->key, src->key, src->len);
>  	return 0;
>  }
>  
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe ceph-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
