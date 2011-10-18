Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757439Ab1JRKFb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 06:05:31 -0400
Received: from helcar.apana.org.au ([209.40.204.226]:43245 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753905Ab1JRKF3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 06:05:29 -0400
Date: Tue, 18 Oct 2011 12:05:27 +0200
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Elmar Vonlanthen <evonlanthen@gmail.com>, linux-kernel@vger.kernel.org,
        netdev <netdev@vger.kernel.org>,
        Timo =?iso-8859-1?Q?Ter=E4s?= <timo.teras@iki.fi>
Subject: Re: PROBLEM: System call 'sendmsg' of process ospfd (quagga)
	causes kernel oops
Message-ID: <20111018100527.GA15383@gondor.apana.org.au>
References: <CA+0Zf5Be5JUSvssH9CrDQq=jtETZr=veAPC7jriM8B-FZKbbpg@mail.gmail.com> <1318604266.2223.29.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC> <CA+0Zf5A-8X5MaXC4+BbLKtMb8S8B-Ln_a3JNfz0jR4O-ruefuw@mail.gmail.com> <1318905032.2571.35.camel@edumazet-laptop> <20111018093411.GA15165@gondor.apana.org.au> <1318932093.2657.26.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1318932093.2657.26.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 18, 2011 at 12:01:33PM +0200, Eric Dumazet wrote:
>
> Adding an RCU protected structure to hold hard_header_len /
> needed_headroom / needed_tailroom should be possible, but this adds yet
> another pointer dereference...

I don't think we need RCU here since the problem is simply that
we're using two different values for skb allocations and skb_reserve.

As long as we use one and the same value it should work.  The value
will rarely be incorrect and when it is, automatic reallocation will
occur.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
