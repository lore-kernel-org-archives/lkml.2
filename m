Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755515Ab2JPB2l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 21:28:41 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:49291 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755452Ab2JPB2k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 21:28:40 -0400
MIME-Version: 1.0
In-Reply-To: <1350141021.21172.14949.camel@edumazet-glaptop>
References: <CALF0-+XGn5=QSE0bpa4RTag9CAJ63MKz1kvaYbpw34qUhViaZA@mail.gmail.com>
	<m27gqwtyu9.fsf@firstfloor.org>
	<alpine.DEB.2.00.1210111558290.6409@chino.kir.corp.google.com>
	<m2391ktxjj.fsf@firstfloor.org>
	<alpine.DEB.2.00.1210130249070.7462@chino.kir.corp.google.com>
	<1350141021.21172.14949.camel@edumazet-glaptop>
Date: Tue, 16 Oct 2012 10:28:39 +0900
Message-ID: <CAAmzW4M8drwRPy_qWxnkG3-GKGPq+m24me+pGOWNtPzA15iVfg@mail.gmail.com>
Subject: Re: [Q] Default SLAB allocator
From: JoonSoo Kim <js1304@gmail.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: David Rientjes <rientjes@google.com>, Andi Kleen <andi@firstfloor.org>,
        Ezequiel Garcia <elezegarcia@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-mm@kvack.org, Tim Bird <tim.bird@am.sony.com>,
        celinux-dev@lists.celinuxforum.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Eric.

2012/10/14 Eric Dumazet <eric.dumazet@gmail.com>:
> SLUB was really bad in the common workload you describe (allocations
> done by one cpu, freeing done by other cpus), because all kfree() hit
> the slow path and cpus contend in __slab_free() in the loop guarded by
> cmpxchg_double_slab(). SLAB has a cache for this, while SLUB directly
> hit the main "struct page" to add the freed object to freelist.

Could you elaborate more on how 'netperf RR' makes kernel "allocations
done by one cpu, freeling done by other cpus", please?
I don't have enough background network subsystem, so I'm just curious.

> I played some months ago adding a percpu associative cache to SLUB, then
> just moved on other strategy.
>
> (Idea for this per cpu cache was to build a temporary free list of
> objects to batch accesses to struct page)

Is this implemented and submitted?
If it is, could you tell me the link for the patches?

Thanks!
