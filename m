Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754795Ab0EUGo7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 02:44:59 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:37038 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752985Ab0EUGo5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 02:44:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Xe3cE2K/t9MKEV9JuPM6cBgywdK8cay2qaYf+uUzbxgCmU4De5vzB5mQiuWmVH3qMs
         +cJ1jr3BLAopDNknFW2z2pAbT4brZ/aaBUxf9NRFjC0JKrQswvbrXB+kAWN/GXyCe0ii
         o2IBO4mcXX1OOskkdlf2+aYkUqdxWIgR3ng5I=
Subject: Re: [PATCH 2/2]: atomic_t: Remove volatile from atomic_t definition
From: Eric Dumazet <eric.dumazet@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: npiggin@suse.de, paulmck@linux.vnet.ibm.com, torvalds@linux-foundation.org,
       anton@samba.org, akpm@linux-foundation.org, willy@linux.intel.com,
       benh@kernel.crashing.org, paulus@samba.org, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20100520.231037.200798708.davem@davemloft.net>
References: <20100521052746.GL2516@laptop>
	 <20100520.225454.37197037.davem@davemloft.net>
	 <20100521060600.GM2516@laptop>
	 <20100520.231037.200798708.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 21 May 2010 08:44:52 +0200
Message-ID: <1274424292.2439.6.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 20 mai 2010 à 23:10 -0700, David Miller a écrit :
> From: Nick Piggin <npiggin@suse.de>
> Date: Fri, 21 May 2010 16:06:00 +1000
> 
> > Actually, I bet we have a lot of bugs there with loading integers and
> > pointers atomically, where the code assumes the loaded value will not
> > be reloaded by the compiler, because it is an easy thing to assume.
> 
> Alexey Kuznetsov was aware of this problem 8+ years ago when we were
> first adding fine-grained locking the the networking.
> 
> > atomic_read_light could be useful though, for sure.
> 
> I definitely think so. And every usage of it should have a big fat
> comment right next to it explaining how it's usage is valid in that
> spot :-)
> -

I really doubt a valid (and dully commented) usage of
atomic_read_light() will bring anything, but added complexity to API.

Generated code will be the same than atomic_read() in these cases,
unless some real factorization can be done inside a loop.

We still have some uneeded RMW atomic ops to remove, before even
thinking to optimise reads ;)



