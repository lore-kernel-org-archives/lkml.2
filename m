Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751957Ab0HAFFD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Aug 2010 01:05:03 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54544
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751135Ab0HAFFA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Aug 2010 01:05:00 -0400
Date: Sat, 31 Jul 2010 22:05:18 -0700 (PDT)
Message-Id: <20100731.220518.212680999.davem@davemloft.net>
To: herbert@gondor.hengli.com.au
Cc: xiaosuo@gmail.com, hadi@cyberus.ca, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kaber@trash.net
Subject: Re: [PATCH] act_nat: the checksum of ICMP doesn't have pseudo
 header
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100730143016.GA10543@gondor.apana.org.au>
References: <20100730102409.GA8590@gondor.apana.org.au>
	<AANLkTimKXsgmOSVmw-cP6Zw6UoK5CSshK38Oo5tLuAeA@mail.gmail.com>
	<20100730143016.GA10543@gondor.apana.org.au>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Herbert Xu <herbert@gondor.apana.org.au>
Date: Fri, 30 Jul 2010 22:30:16 +0800

> On Fri, Jul 30, 2010 at 10:16:05PM +0800, Changli Gao wrote:
>> 
>> I know we need to update the ICMP checksum if we alter the payload(the
>> inner IP header here) of ICMP. But I doubt if the update is really
>> necessary if the checksum is partial, as the   checksum will be done
>> later(by ether skb_checksum_help() or NIC hardware). In fact, as there
>> isn't any pseudo header, the icmph->checksum should be always ZERO,
>> otherwise skb_checksum_help() or NIC will give the wrong checksums,
>> when the checksum is partial.
> 
> Actually you are right.  I suppose the only reason this has never
> shown up is because CHEKSUM_PARTIAL doesn't usually occur with
> forwarded packets.
> 
> Acked-by: Herbert Xu <herbert@gondor.apana.org.au>

Also applied, thanks.

