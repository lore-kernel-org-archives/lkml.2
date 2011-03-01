Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755470Ab1CAF7y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 00:59:54 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:54224 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755146Ab1CAF7x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 00:59:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=JI6NwMWIc39Gr8dA4pl7e4Lvakil5cTT59EpIgmaf4IS66BSLRb5pcrodpffTi9NJK
         Gme1bQiYTwG/GLjj8mXZ9UYZaRulI0LLETAvdvixvjidTANesjDoBUGCA1WgMddlLrp1
         ZxDsS71F5f3NktfQlJ9SwdR6UtMVq5KW+nzxY=
Subject: Re: [PATCH v6] net: add Faraday FTMAC100 10/100 Ethernet driver
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Po-Yu Chuang <ratbert.chuang@gmail.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bhutchings@solarflare.com, joe@perches.com, dilinger@queued.net,
        mirqus@gmail.com, davem@davemloft.net,
        Po-Yu Chuang <ratbert@faraday-tech.com>
In-Reply-To: <AANLkTi=Sp-mAV1556pZvCvHzQ=MQNHUzjo0ap2DhKwWe@mail.gmail.com>
References: <1298539762-2242-1-git-send-email-ratbert.chuang@gmail.com>
	 <1298627845-1583-1-git-send-email-ratbert.chuang@gmail.com>
	 <1298634040.2659.32.camel@edumazet-laptop>
	 <AANLkTimeDR27Q7fcBmB0ix7Q_pRT_GDpc7S3LO21-fh-@mail.gmail.com>
	 <1298958336.2676.21.camel@edumazet-laptop>
	 <AANLkTi=Sp-mAV1556pZvCvHzQ=MQNHUzjo0ap2DhKwWe@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 01 Mar 2011 06:59:48 +0100
Message-ID: <1298959188.2676.32.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 01 mars 2011 à 13:51 +0800, Po-Yu Chuang a écrit :
> On Tue, Mar 1, 2011 at 1:45 PM, Eric Dumazet <eric.dumazet@gmail.com> wrote:

> > I am only wondering then if not using fragments would be faster then
> > (eventually doing copybreaks for small frames like tg3)
> 
> Although not many circumstances are tested.
> iperf shows that it is a little faster to use fragments than memcpy, so...

This might be a side effect of skb->truesize being smaller with
fragments than "regular packets" and socket backlog congestion.

If a full page was really accounted for in skb->truesize, instead of
used length, performance might be the same or lower :(

-	skb->truesize += length;
+	skb->truesize += PAGE_SIZE;

This has nothing to do with your driver, but a core implementation
detail.



