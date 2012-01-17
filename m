Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752504Ab2AQI3i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 03:29:38 -0500
Received: from mail-ww0-f42.google.com ([74.125.82.42]:47200 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752404Ab2AQI3g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 03:29:36 -0500
Message-ID: <1326788970.2564.52.camel@edumazet-laptop>
Subject: Re: [patch v2, kernel version 3.2.1] net/ipv4/ip_gre: Ethernet
 multipoint GRE over IP
From: Eric Dumazet <eric.dumazet@gmail.com>
To: =?UTF-8?Q?=C5=A0tefan?= Gula <steweg@ynet.sk>
Cc: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        "David S. Miller" <davem@davemloft.net>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Tue, 17 Jan 2012 09:29:30 +0100
In-Reply-To: <CAGsizz+kgBB9APmU9dPExkGQvPUVa3m6qz3NvSguPYNuJQQ_7Q@mail.gmail.com>
References: <CAGsizz+x1GVNR9Pz=b7wO0ELx29=FMosfvhQWL5K26EpkwsUCg@mail.gmail.com>
	 <1326745733.2564.14.camel@edumazet-laptop>
	 <CAGsizz+2nH+Sx+7TjZwEeKBiHbio0BxoN7CgT4Sspp0EzRN6Ug@mail.gmail.com>
	 <1326775643.2564.36.camel@edumazet-laptop>
	 <CAGsizz+kgBB9APmU9dPExkGQvPUVa3m6qz3NvSguPYNuJQQ_7Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 17 janvier 2012 à 09:04 +0100, Štefan Gula a écrit :
> Dňa 17. januára 2012 5:47, Eric Dumazet <eric.dumazet@gmail.com> napísal/a:
> >
> > 2) You call ipgre_tap_bridge_fini() from ipgre_exit_net() and
> > ipgre_init_net(), thats completely bogus if CONFIG_NET_NS=y
> >
> > Just remove the struct kmem_cache *ipgre_tap_bridge_cache
> > and use instead kmalloc(sizeof(...))/kfree(ptr) instead.
> >
> As this is completely the same part of code from net/bridge/br_fdb.c,
> can you give me a hint about how change that as I believe it should be
> changed also there?

Please dont copy code you dont understand :(

bridge code is ok, but not yours, since you destroy the kmem_cache when
a net namespace exits.

Either you fix your code, either you change your memory allocations to
mere kmalloc()/kfree() calls and dont care of a private kmem_cache you
have to create and destroy.

Since you ask a SLAB_HWCACHE_ALIGN, the SLUB allocator will anyway merge
your kmem_cache with the standard one (kmalloc-64 I guess)



