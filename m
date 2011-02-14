Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752639Ab1BNTmp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 14:42:45 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:60317
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750934Ab1BNTmm convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 14:42:42 -0500
Date: Mon, 14 Feb 2011 11:43:18 -0800 (PST)
Message-Id: <20110214.114318.112601812.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: penberg@kernel.org, akpm@linux-foundation.org, netdev@vger.kernel.org,
        bugzilla-daemon@bugzilla.kernel.org, bugme-daemon@bugzilla.kernel.org,
        casteyde.christian@free.fr, xiaosuo@gmail.com, vegardno@ifi.uio.no,
        linux-kernel@vger.kernel.org
Subject: Re: [Bugme-new] [Bug 27212] New: Warning kmemcheck: Caught 64-bit
 read from uninitialized memory in netlink_broadcast_filtered
From: David Miller <davem@davemloft.net>
In-Reply-To: <1297704922.2996.60.camel@edumazet-laptop>
References: <1295556085.2613.22.camel@edumazet-laptop>
	<4D393A99.9060104@kernel.org>
	<1297704922.2996.60.camel@edumazet-laptop>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Mon, 14 Feb 2011 18:35:22 +0100

> Le vendredi 21 janvier 2011 à 09:49 +0200, Pekka Enberg a écrit :
> 
>> It actually looks like a bug in SLUB+kmemcheck. The 
>> kmemcheck_slab_alloc() call in slab_post_alloc_hook() should use ksize() 
>> instead of s->objsize. SLAB seems to do the right thing already. Anyone 
>> care to send a patch my way?
>> 
> 
> Hmm, what do you think of following patch ?
> 
> Thanks, and sorry for the delay.
> 
> [PATCH] slub: fix kmemcheck calls to match ksize() hints
> 
> Recent use of ksize() in network stack (commit ca44ac38 : net: don't
> reallocate skb->head unless the current one hasn't the needed extra size
> or is shared) triggers kmemcheck warnings, because ksize() can return
> more space than kmemcheck is aware of.
> 
> Pekka Enberg noticed SLAB+kmemcheck is doing the right thing, while SLUB
> +kmemcheck doesnt.
> 
> Bugzilla reference #27212
> 
> Reported-by: Christian Casteyde <casteyde.christian@free.fr>
> Suggested-by: Pekka Enberg <penberg@kernel.org>
> Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>

Acked-by: David S. Miller <davem@davemloft.net>
