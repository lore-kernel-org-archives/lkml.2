Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756446Ab1JYLyi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 07:54:38 -0400
Received: from helcar.apana.org.au ([209.40.204.226]:34610 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756155Ab1JYLyg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 07:54:36 -0400
Date: Tue, 25 Oct 2011 13:54:25 +0200
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: David Miller <davem@davemloft.net>
Cc: eric.dumazet@gmail.com, evonlanthen@gmail.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        timo.teras@iki.fi
Subject: Re: PROBLEM: System call 'sendmsg' of process ospfd (quagga)
	causes kernel oops
Message-ID: <20111025115425.GA1530@gondor.apana.org.au>
References: <1319008713.17914.8.camel@edumazet-laptop> <20111019.033052.851679720607111734.davem@davemloft.net> <20111019080807.GA25099@gondor.apana.org.au> <20111020.053050.383972361986316046.davem@davemloft.net> <20111020093541.GA3024@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111020093541.GA3024@gondor.apana.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 20, 2011 at 11:35:41AM +0200, Herbert Xu wrote:
>
> In the time being I'll look more closely at all the users of
> needed_headroom to see if there's anything we've missed.

OK I've reviewed all the users of needed_headroom and I haven't
found anything other than the cases that we have enumerated.

One thing I noticed is that the macro LL_ALLOCATED_SPACE is
completely bogus and buggy.  It applies the alignment to the
sum of headroom and tailroom.  However, the alignment is then
applied separately to the headroom when reserving, meaning that
we may end up with insufficient tailroom.

So I'm going to get rid of LL_ALLOCATED_SPACE completely and
replace it with explicit references to the tailroom as it doesn't
need the alignment anyway (The headroom needs alignment since
we use it to ensure the head is aligned).

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
