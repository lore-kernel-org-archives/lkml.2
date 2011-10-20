Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756240Ab1JTJbG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 05:31:06 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:44306 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751960Ab1JTJbE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 05:31:04 -0400
Date: Thu, 20 Oct 2011 05:30:50 -0400 (EDT)
Message-Id: <20111020.053050.383972361986316046.davem@davemloft.net>
To: herbert@gondor.hengli.com.au
Cc: eric.dumazet@gmail.com, evonlanthen@gmail.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        timo.teras@iki.fi
Subject: Re: PROBLEM: System call 'sendmsg' of process ospfd (quagga)
 causes kernel oops
From: David Miller <davem@davemloft.net>
In-Reply-To: <20111019080807.GA25099@gondor.apana.org.au>
References: <1319008713.17914.8.camel@edumazet-laptop>
	<20111019.033052.851679720607111734.davem@davemloft.net>
	<20111019080807.GA25099@gondor.apana.org.au>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 20 Oct 2011 02:30:52 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Herbert Xu <herbert@gondor.hengli.com.au>
Date: Wed, 19 Oct 2011 10:08:07 +0200

> I think Eric's initial patch is probably the safest bet for rc10.
> We can then work on the proper fix for the next release.

There are two "initial patch", I wonder which one you mean.

There's his really first patch, which remoevs the lines in IP_GRE
which change dev->needed_headroom.  I was under the impression we
were against doing that.

The other patch he posted duplicates the device attribute variable
caching in two functions.

My patch is just a tweak so that we only do this sequence in one
place, the new sock_alloc_send_skb_reserve() helper, instead of
in both the ipv4 and ipv6 RAW code.

So I'm a little confused what your suggestion for rc10 really
is :-)
