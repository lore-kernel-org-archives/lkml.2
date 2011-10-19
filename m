Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755547Ab1JSIIR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 04:08:17 -0400
Received: from helcar.apana.org.au ([209.40.204.226]:35629 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751425Ab1JSIIP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 04:08:15 -0400
Date: Wed, 19 Oct 2011 10:08:07 +0200
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: David Miller <davem@davemloft.net>
Cc: eric.dumazet@gmail.com, evonlanthen@gmail.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        timo.teras@iki.fi
Subject: Re: PROBLEM: System call 'sendmsg' of process ospfd (quagga)
	causes kernel oops
Message-ID: <20111019080807.GA25099@gondor.apana.org.au>
References: <20111018134537.GA17055@gondor.apana.org.au> <20111019.030914.218521668377472155.davem@davemloft.net> <1319008713.17914.8.camel@edumazet-laptop> <20111019.033052.851679720607111734.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111019.033052.851679720607111734.davem@davemloft.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 19, 2011 at 03:30:52AM -0400, David Miller wrote:
> From: Eric Dumazet <eric.dumazet@gmail.com>
> Date: Wed, 19 Oct 2011 09:18:33 +0200
> 
> > Seems fine (Maybe do the +15 in caller site ?), but we also have other
> > problematic cases, using alloc_skb() only...
> 
> Ok, which ones operate over these problematic GRE tunnels?

Potentially all of them since we now support Ethernet-over-GRE.

I think Eric's initial patch is probably the safest bet for rc10.
We can then work on the proper fix for the next release.

As to the latter, I've just done a grep over net and it seems that
all users of LL_ALLOCATED_SPACE fall into two cases, alloc_skb users
or sock_alloc_send_skb (including pskb) users.

For alloc_skb we could add a new helper.  While for the other
case we could either create a new helper or just add an extra
dev argument that may be NULL for those that don't care about
LL_ALLOCATED_SPACE.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
