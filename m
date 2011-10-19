Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752900Ab1JSHSl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 03:18:41 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:38599 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751099Ab1JSHSj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 03:18:39 -0400
Message-ID: <1319008713.17914.8.camel@edumazet-laptop>
Subject: Re: PROBLEM: System call 'sendmsg' of process ospfd (quagga) causes
 kernel oops
From: Eric Dumazet <eric.dumazet@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: herbert@gondor.hengli.com.au, evonlanthen@gmail.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        timo.teras@iki.fi
Date: Wed, 19 Oct 2011 09:18:33 +0200
In-Reply-To: <20111019.030914.218521668377472155.davem@davemloft.net>
References: <20111018114945.GA16359@gondor.apana.org.au>
	 <1318942560.2657.69.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	 <20111018134537.GA17055@gondor.apana.org.au>
	 <20111019.030914.218521668377472155.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.0- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 19 octobre 2011 à 03:09 -0400, David Miller a écrit :
> From: Herbert Xu <herbert@gondor.hengli.com.au>
> Date: Tue, 18 Oct 2011 15:45:37 +0200
> 
> > On Tue, Oct 18, 2011 at 02:56:00PM +0200, Eric Dumazet wrote:
> >>
> >> I am ok by this way, but we might hit another similar problem elsewhere.
> >> 
> >> (igmp.c ip6_output, ...)
> >> 
> >> We effectively want to remove LL_ALLOCATED_SPACE() usage and obfuscate
> >> code...
> > 
> > Here's another idea, provide a helper to do the skb allocation
> > and the skb_reserve in one go.  That way this ugliness would only
> > need to be done once.
> 
> Someone please test this:
> 
> --------------------
> net: Fix crashes on devices which dynamically change needed headroom.
> 
> One such device is IP_GRE.
> 
> The problem is that we evaluate the device characteristics twice, once
> to determine the allocation size, and once to do the skb_reserve().
> 
> Combine these into one operation using a helper function.
> 
> With help from Eric Dumazet and Herbert Xu.
> 
> Reported-by: Reported-by: Elmar Vonlanthen <evonlanthen@gmail.com>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> 



Seems fine (Maybe do the +15 in caller site ?), but we also have other
problematic cases, using alloc_skb() only...



