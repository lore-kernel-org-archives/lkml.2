Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932209Ab0G3Oa2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 10:30:28 -0400
Received: from helcar.apana.org.au ([209.40.204.226]:38812 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751692Ab0G3Oa1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 10:30:27 -0400
Date: Fri, 30 Jul 2010 22:30:16 +0800
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Changli Gao <xiaosuo@gmail.com>
Cc: Jamal Hadi Salim <hadi@cyberus.ca>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] act_nat: the checksum of ICMP doesn't have pseudo
	header
Message-ID: <20100730143016.GA10543@gondor.apana.org.au>
References: <1280448258-1893-1-git-send-email-xiaosuo@gmail.com> <20100730090922.GA7807@gondor.apana.org.au> <AANLkTi=YHvra6DuL7vX=DfQmR6bsw7rNMJ9mRhUzHvj2@mail.gmail.com> <20100730102409.GA8590@gondor.apana.org.au> <AANLkTimKXsgmOSVmw-cP6Zw6UoK5CSshK38Oo5tLuAeA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimKXsgmOSVmw-cP6Zw6UoK5CSshK38Oo5tLuAeA@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 30, 2010 at 10:16:05PM +0800, Changli Gao wrote:
> 
> I know we need to update the ICMP checksum if we alter the payload(the
> inner IP header here) of ICMP. But I doubt if the update is really
> necessary if the checksum is partial, as the   checksum will be done
> later(by ether skb_checksum_help() or NIC hardware). In fact, as there
> isn't any pseudo header, the icmph->checksum should be always ZERO,
> otherwise skb_checksum_help() or NIC will give the wrong checksums,
> when the checksum is partial.

Actually you are right.  I suppose the only reason this has never
shown up is because CHEKSUM_PARTIAL doesn't usually occur with
forwarded packets.

Acked-by: Herbert Xu <herbert@gondor.apana.org.au>

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
