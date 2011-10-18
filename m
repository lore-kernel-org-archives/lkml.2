Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932157Ab1JRKpK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 06:45:10 -0400
Received: from helcar.apana.org.au ([209.40.204.226]:58538 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752619Ab1JRKpI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 06:45:08 -0400
Date: Tue, 18 Oct 2011 12:45:04 +0200
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Elmar Vonlanthen <evonlanthen@gmail.com>, linux-kernel@vger.kernel.org,
        netdev <netdev@vger.kernel.org>,
        Timo =?iso-8859-1?Q?Ter=E4s?= <timo.teras@iki.fi>
Subject: Re: PROBLEM: System call 'sendmsg' of process ospfd (quagga)
	causes kernel oops
Message-ID: <20111018104504.GA15913@gondor.apana.org.au>
References: <CA+0Zf5Be5JUSvssH9CrDQq=jtETZr=veAPC7jriM8B-FZKbbpg@mail.gmail.com> <1318604266.2223.29.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC> <CA+0Zf5A-8X5MaXC4+BbLKtMb8S8B-Ln_a3JNfz0jR4O-ruefuw@mail.gmail.com> <1318905032.2571.35.camel@edumazet-laptop> <20111018093411.GA15165@gondor.apana.org.au> <1318932093.2657.26.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC> <20111018100527.GA15383@gondor.apana.org.au> <1318933423.2657.44.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1318933423.2657.44.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 18, 2011 at 12:23:43PM +0200, Eric Dumazet wrote:
> 
> You're right, if reallocations are OK in all paths.

If it wasn't OK then making needed_headroom constant won't work
anyway.

> We'll need to change LL_RESERVED_SPACE() / LL_RESERVED_SPACE_EXTRA() /
> LL_ALLOCATED_SPACE() macros and provide the [read once] values, instead
> of a [read once] pointer to values.

I'm not sure what you mean here.  I don't see any need to change
these macros.  All we need is to save the value in a local variable:

	hh_len = LL_RESERVED_SPACE(dev);

	skb = alloc_skb(hh_len + len);
	skb_reserve(skb, hh_len);

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
