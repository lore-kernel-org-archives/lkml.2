Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757282Ab1JRKX0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 06:23:26 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:35729 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750823Ab1JRKXY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 06:23:24 -0400
Message-ID: <1318933423.2657.44.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Subject: Re: PROBLEM: System call 'sendmsg' of process ospfd (quagga) causes
 kernel oops
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Herbert Xu <herbert@gondor.hengli.com.au>
Cc: Elmar Vonlanthen <evonlanthen@gmail.com>, linux-kernel@vger.kernel.org,
        netdev <netdev@vger.kernel.org>,
        Timo =?ISO-8859-1?Q?Ter=E4s?= <timo.teras@iki.fi>
Date: Tue, 18 Oct 2011 12:23:43 +0200
In-Reply-To: <20111018100527.GA15383@gondor.apana.org.au>
References: <CA+0Zf5Be5JUSvssH9CrDQq=jtETZr=veAPC7jriM8B-FZKbbpg@mail.gmail.com>
	 <1318604266.2223.29.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	 <CA+0Zf5A-8X5MaXC4+BbLKtMb8S8B-Ln_a3JNfz0jR4O-ruefuw@mail.gmail.com>
	 <1318905032.2571.35.camel@edumazet-laptop>
	 <20111018093411.GA15165@gondor.apana.org.au>
	 <1318932093.2657.26.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	 <20111018100527.GA15383@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.0- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 18 octobre 2011 à 12:05 +0200, Herbert Xu a écrit :
> On Tue, Oct 18, 2011 at 12:01:33PM +0200, Eric Dumazet wrote:
> >
> > Adding an RCU protected structure to hold hard_header_len /
> > needed_headroom / needed_tailroom should be possible, but this adds yet
> > another pointer dereference...
> 
> I don't think we need RCU here since the problem is simply that
> we're using two different values for skb allocations and skb_reserve.
> 
> As long as we use one and the same value it should work.  The value
> will rarely be incorrect and when it is, automatic reallocation will
> occur.
> 

You're right, if reallocations are OK in all paths.

We'll need to change LL_RESERVED_SPACE() / LL_RESERVED_SPACE_EXTRA() /
LL_ALLOCATED_SPACE() macros and provide the [read once] values, instead
of a [read once] pointer to values.

Thats a bit complex change, but doable.


