Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755543Ab1BXIWt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 03:22:49 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:62150 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754636Ab1BXIWs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 03:22:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Fslo6TPIrAAm+HOwWzZ3iS/TdLh+HtheQGjy69PEtyyL+eZvY9fhN1/AceWhiXwlQm
         vZD1mB7sfuRloCpSCOw5r1GXtrSHC9q5vRYWjt65y7oqLkQMp4tctUA70RxRrFf57b5N
         Ay6aiSgvvF3DdS9NR6K+vaA6W/PxBxePAygds=
Subject: Re: [PATCH v4] net: add Faraday FTMAC100 10/100 Ethernet driver
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Po-Yu Chuang <ratbert.chuang@gmail.com>
Cc: David Miller <davem@davemloft.net>, mirqus@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bhutchings@solarflare.com, joe@perches.com, dilinger@queued.net,
        ratbert@faraday-tech.com
In-Reply-To: <AANLkTikE_OU_qiBUdiDP39js8jQzGqqo1FYW2uHmw3He@mail.gmail.com>
References: <AANLkTikgDsM15DO7u2SP15xx=Y_pg6JdCLrie8ACobJP@mail.gmail.com>
	 <20110131.203556.193730771.davem@davemloft.net>
	 <AANLkTimorcNAEbSpuE_dUXKuOBZDcDcGSJ2cGefniThc@mail.gmail.com>
	 <20110223.235129.02262510.davem@davemloft.net>
	 <AANLkTikE_OU_qiBUdiDP39js8jQzGqqo1FYW2uHmw3He@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 24 Feb 2011 09:22:41 +0100
Message-ID: <1298535761.2814.1.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 24 février 2011 à 16:07 +0800, Po-Yu Chuang a écrit :
> Hi David,
> 
> On Thu, Feb 24, 2011 at 3:51 PM, David Miller <davem@davemloft.net> wrote:
> > From: Po-Yu Chuang <ratbert.chuang@gmail.com>
> > Date: Thu, 24 Feb 2011 15:27:55 +0800
> >
> >> I guess the problem is because a HW restriction that the rx buffer must be
> >> 64 bits aligned. Since I cannot make rx buffer starts at offset 2 bytes, the
> >> IP header, TCP header and data are not 4 bytes aligned. The performance
> >> drops drastically.
> >
> > I cannot believe that after 20 years of commodity ethernet networking
> > chips were first designed, people are still designing hardware that
> > doesn't do this right.
> 
> Ha ha...
> Well, this restriction was removed in the later IPs of our company. :-p
> 
> >
> > Just emit garbage bytes into the sub-word alignment padding if the chip
> > wants to word align it's DMA writes.
> 
> Not sure what do you mean. The problem is that HW does not accept a
> base address of RX buffer which is not 8 bytes aligned.

I still dont understand the problem, maybe you should post your work as
RFC

Why not using for the first part the skb buffer (eventually copy the
first 128 bytes to get aligned IP/TCP header), and add frags for
following parts ?



