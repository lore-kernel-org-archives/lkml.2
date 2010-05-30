Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755000Ab0E3VS2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 May 2010 17:18:28 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:56695 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754471Ab0E3VS0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 May 2010 17:18:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=x37oni88isuvOjghRI02teX5vTy8BR45yZ9ega02ON7o5x5N9bXqCZaPi1lTXNU6/K
         vfIZvNhHtJd+fa97G2QkMjuJMBuiIs7IL/sXF1qdS2iDy02QO5O/BXEfKwnsJOJmTUlu
         BaIERYYhdz1RvFYgODh0PoZ9nM3r1Z3SjCBTk=
Subject: Re: Subject: [PATCH] net/ipv6: Use GFP_ATOMIC when a lock is held
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Julia Lawall <julia@diku.dk>
Cc: "David S. Miller" <davem@davemloft.net>,
       Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
       "Pekka Savola (ipv6)" <pekkas@netcore.fi>,
       James Morris <jmorris@namei.org>,
       Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
       Patrick McHardy <kaber@trash.net>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.1005302303180.19253@ask.diku.dk>
References: <Pine.LNX.4.64.1005302147310.19253@ask.diku.dk>
	 <1275250288.2472.21.camel@edumazet-laptop>
	 <Pine.LNX.4.64.1005302248500.19253@ask.diku.dk>
	 <1275252912.2472.23.camel@edumazet-laptop>
	 <Pine.LNX.4.64.1005302303180.19253@ask.diku.dk>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 30 May 2010 23:18:18 +0200
Message-ID: <1275254298.2472.26.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le dimanche 30 mai 2010 à 23:09 +0200, Julia Lawall a écrit :

> could exit with success without the kzalloc ever being called.  If the 
> kzalloc is moved up, it could fail and then it returns immediately without 
> executing the loop.  A solution could be to leave the NULL test on p where 
> it is, and only move up the kzalloc.  Or perhaps the change in behavior 
> doesn't matter?

If a GFP_KERNEL allocation fails, we are in a big trouble anyway :)

GFP_ATOMIC are more problematic in this area :)



