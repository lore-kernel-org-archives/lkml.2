Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755275Ab0KWPJE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 10:09:04 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:37775 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753036Ab0KWPJD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 10:09:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=rnRZBkRYezbpBlCQG5uSyChAPagMlRZwYizUaTcVI96U2nalRzcF3Z9h/ZPCeG3p/1
         GfN6jvw1/Bt2feyZv8YH+MzG+d1uo0DzvfYDNL5G//zAw8D030iTmjwmy04tKRD+Jl5p
         W/R5zC2OTShYCKb216LN65x1nLDqbzzi7pBtI=
Subject: Re: addrconf: refcnt with  IPV6_PRIVACY enabled
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Pekka Savola (ipv6)" <pekkas@netcore.fi>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
In-Reply-To: <20101123145331.GA4102@swordfish.minsk.epam.com>
References: <20101123134003.GB4142@swordfish.minsk.epam.com>
	 <1290522803.3046.11.camel@edumazet-laptop>
	 <20101123145331.GA4102@swordfish.minsk.epam.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 23 Nov 2010 16:08:57 +0100
Message-ID: <1290524937.3046.33.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 23 novembre 2010 à 16:53 +0200, Sergey Senozhatsky a écrit :
>  
> > ipv6_regen_rndid() is the timer handler function, it must call
> > in6_dev_put() at the end, unless we rearm the timer.
> > 
> > So this code is correct.
> > 
> > 
> > if (!mod_timer(&idev->regen_timer, expires))
> > 	in6_dev_hold(idev);
> > ...
> > in6_dev_put(idev);
> >
> 
> Even if in6_dev_hold hasn't been called from ipv6_regen_rndid?
> 


Yes.

Rules are :

in6_dev_hold() when arming timer, so that device doesnt disappear while
timer handler might run and need it.

in6_dev_put() when timer handler finishes




