Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934295Ab1CXWoU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 18:44:20 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:55076 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933724Ab1CXWoR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 18:44:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=HzwPPPyh8wS/6vDF9AiKnEWgMArMvuxsHDubX2lqL3N5072LhyHeevQPjxCKd8y03i
         V1YGgXqaE80VVYTmFxQBWSSJnNYKUWwFiMJi8wX4SVuA8JQUVuQfo5aKnoFONhzmCIIB
         rNrPeyGhP0vweRTXSXboepVcdQd6Mn5hK+4bI=
Subject: Re: [PATCH] ipv4: fix fib metrics
From: Eric Dumazet <eric.dumazet@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: alessandro.suardi@gmail.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
In-Reply-To: <20110324.153623.45921344.davem@davemloft.net>
References: <1301005107.2714.113.camel@edumazet-laptop>
	 <AANLkTinv+XGBjbFoK6vpyiDW6gBEBKFjUef+mCAMJU9i@mail.gmail.com>
	 <1301005946.2714.130.camel@edumazet-laptop>
	 <20110324.153623.45921344.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 24 Mar 2011 23:44:12 +0100
Message-ID: <1301006652.2714.145.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 24 mars 2011 à 15:36 -0700, David Miller a écrit :
> From: Eric Dumazet <eric.dumazet@gmail.com>
> Date: Thu, 24 Mar 2011 23:32:26 +0100
> 
> > Then it doesnt work anymore because it parses an ipip field from
> > ip route get ...
> > 
> > $ ip ro get 192.168.1.1
> > 192.168.1.1 dev wlan0  src 192.168.1.21 
> >     cache  ipid 0x784c mtu 1500 advmss 1460 hoplimit 64
> > 
> > 
> > Maybe you upgraded iproute2
> 
> I'm leaning towards app bug too.
> 
> These default metrics wouldn't get printed before, but now because of
> how metrics are handled, they will.
> 
> Userland needs to cope properly with this.


BTW, ipip is not always printed (even on old kernels) : One needs to
actually need ipip generation .

edumazet@edumazet-laptop:~$ ping 4.4.4.4
PING 4.4.4.4 (4.4.4.4) 56(84) bytes of data.
^C

edumazet@edumazet-laptop:~$ ip ro get 4.4.4.4
4.4.4.4 dev ppp0  src 10.150.51.210 
    cache  mtu 1500 advmss 1460 hoplimit 64

edumazet@edumazet-laptop:~$ ping -s 2000 4.4.4.4
PING 4.4.4.4 (4.4.4.4) 2000(2028) bytes of data.
^C

edumazet@edumazet-laptop:~$ ip ro get 4.4.4.4
4.4.4.4 dev ppp0  src 10.150.51.210 
    cache  ipid 0xf99a mtu 1500 advmss 1460 hoplimit 64


This on a 2.6.35 kernel

I suspect Alessandro tool had a bug anyway.



