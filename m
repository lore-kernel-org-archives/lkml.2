Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754785Ab0EaNW1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 09:22:27 -0400
Received: from borg.medozas.de ([188.40.89.202]:34078 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754097Ab0EaNW0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 09:22:26 -0400
Date: Mon, 31 May 2010 15:22:24 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
To: Eric Dumazet <eric.dumazet@gmail.com>
cc: Xiaotian Feng <dfeng@redhat.com>, netfilter-devel@vger.kernel.org,
       netfilter@vger.kernel.org, coreteam@netfilter.org,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       Patrick McHardy <kaber@trash.net>,
       "David S. Miller" <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [PATCH] netfilter: xtables: stackptr should be percpu
In-Reply-To: <1275311580.3291.44.camel@edumazet-laptop>
Message-ID: <alpine.LSU.2.01.1005311519340.25402@obet.zrqbmnf.qr>
References: <1275303998-2435-1-git-send-email-dfeng@redhat.com>  <alpine.LSU.2.01.1005311350580.31799@obet.zrqbmnf.qr> <1275311580.3291.44.camel@edumazet-laptop>
User-Agent: Alpine 2.01 (LSU 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Monday 2010-05-31 15:13, Eric Dumazet wrote:
>
>All cpus share a single cache line for their 'stackptr' storage,
>introduced in commit f3c5c1bfd4
>
>This is a stable candidate (2.6.34)

Stackptr was first introduced for 2.6.35-rcX.

>+	i->stackptr = alloc_percpu(unsigned int);
> 	if (i->stackptr == NULL)
> 		return -ENOMEM;
>-	memset(i->stackptr, 0, size);
> 
> 	size = sizeof(void **) * nr_cpu_ids;
> 	if (size > PAGE_SIZE)

Are alloc_percpu areas cleared?

Acked-By: Jan Engelhardt <jengelh@medozas.de>

