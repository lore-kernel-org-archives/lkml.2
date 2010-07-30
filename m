Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932211Ab0G3OQ2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 10:16:28 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:60125 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752801Ab0G3OQ1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 10:16:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=UneewFH293mpUzHe47hKtFeWVoRcSOgN+Hr8c2DiGk86Xib4bcXGEzdW6SV1CYOLtS
         1fyoXP6/lXMZuZufM9NywMCqNARSbp3ebpsdYsd6oswRQMa4VO1d9KZWI/cIjK1QaTk2
         IcSFoIA/p/XYq/kldyn8fW6IN/IWV5mCW72yY=
MIME-Version: 1.0
In-Reply-To: <20100730102409.GA8590@gondor.apana.org.au>
References: <1280448258-1893-1-git-send-email-xiaosuo@gmail.com> 
	<20100730090922.GA7807@gondor.apana.org.au> <AANLkTi=YHvra6DuL7vX=DfQmR6bsw7rNMJ9mRhUzHvj2@mail.gmail.com> 
	<20100730102409.GA8590@gondor.apana.org.au>
From: Changli Gao <xiaosuo@gmail.com>
Date: Fri, 30 Jul 2010 22:16:05 +0800
Message-ID: <AANLkTimKXsgmOSVmw-cP6Zw6UoK5CSshK38Oo5tLuAeA@mail.gmail.com>
Subject: Re: [PATCH] act_nat: the checksum of ICMP doesn't have pseudo header
To: Herbert Xu <herbert@gondor.hengli.com.au>
Cc: Jamal Hadi Salim <hadi@cyberus.ca>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Patrick McHardy <kaber@trash.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 30, 2010 at 6:24 PM, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> The checksum update is for the inner IP header.  netfilter does
> of course update the checksum, it just doesn't do it here which is
> for the outer IP header.
>

I know we need to update the ICMP checksum if we alter the payload(the
inner IP header here) of ICMP. But I doubt if the update is really
necessary if the checksum is partial, as the   checksum will be done
later(by ether skb_checksum_help() or NIC hardware). In fact, as there
isn't any pseudo header, the icmph->checksum should be always ZERO,
otherwise skb_checksum_help() or NIC will give the wrong checksums,
when the checksum is partial.

-- 
Regards,
Changli Gao(xiaosuo@gmail.com)
