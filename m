Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754847Ab1L2XTf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Dec 2011 18:19:35 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:49358 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754794Ab1L2XTe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Dec 2011 18:19:34 -0500
MIME-Version: 1.0
In-Reply-To: <20111229.170514.1766899380937848638.davem@davemloft.net>
References: <CACPM=kXOddA+T6vQPijR6sh8x5cMO=4baKGeKxEmMKG896Lz4g@mail.gmail.com>
	<20111229153902.GB21946@electric-eye.fr.zoreil.com>
	<20111229183902.GC21946@electric-eye.fr.zoreil.com>
	<20111229.170514.1766899380937848638.davem@davemloft.net>
Date: Fri, 30 Dec 2011 00:19:33 +0100
X-Google-Sender-Auth: rpKu080QoY4FxZkcXp7gWRKynXU
Message-ID: <CACPM=kV8NwYLAdODQHxYmJ21X0RmZ8KJT9szKdY2xa-DsesvQg@mail.gmail.com>
Subject: Re: [PATCH 1/1] via-rhine: Fix hanging with high CPU load on low-end broads.
From: Bjarke Istrup Pedersen <gurligebis@gentoo.org>
To: David Miller <davem@davemloft.net>
Cc: romieu@fr.zoreil.com, shemminger@vyatta.com, bhutchings@solarflare.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org, rl@hellgate.ch
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/12/29 David Miller <davem@davemloft.net>:
> From: Francois Romieu <romieu@fr.zoreil.com>
> Date: Thu, 29 Dec 2011 19:39:02 +0100
>
>> Francois Romieu <romieu@fr.zoreil.com> :
>> [...]
>>> Feel free to try the extra "new year's eve week end is getting closer"
>>> patch below (against net-next).
>>>
>>> You have been warned.
>>
>> The one below could be a bit better.
>
> Obviously you'll need to resolve the use of rp->lock as an IRQ safe lock
> in {get,src}_wol() so that this lock is consistently used as a BH safe
> lock.  Your "Huh?" comments make it clear you are aware of this TODO. :-)
>
> But other than that this patch looks good to me, just some testing and
> debugging are needed.

I got it to boot, had to revert another patch introduced in 3.1.5
that's causing alot of people problems, but thats another talk :)

It boots fine, untill it tries to bring up an interface, which causes
it to fails with a kernel panic.
Here is the output of the panic:
http://dev.gentoo.org/~gurligebis/kernel/panic.txt

/Bjarke

> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
