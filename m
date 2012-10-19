Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757387Ab2JSAEA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 20:04:00 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:35275 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751305Ab2JSAD7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 20:03:59 -0400
MIME-Version: 1.0
In-Reply-To: <1350141021.21172.14949.camel@edumazet-glaptop>
References: <CALF0-+XGn5=QSE0bpa4RTag9CAJ63MKz1kvaYbpw34qUhViaZA@mail.gmail.com>
	<m27gqwtyu9.fsf@firstfloor.org>
	<alpine.DEB.2.00.1210111558290.6409@chino.kir.corp.google.com>
	<m2391ktxjj.fsf@firstfloor.org>
	<alpine.DEB.2.00.1210130249070.7462@chino.kir.corp.google.com>
	<1350141021.21172.14949.camel@edumazet-glaptop>
Date: Fri, 19 Oct 2012 09:03:58 +0900
Message-ID: <CAAmzW4N1rAQLOE3QmeeTfsNH-7v-9RD8wT990RbZtYon3YfrLA@mail.gmail.com>
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
Thank you very much for a kind comment about my question.
I have one more question related to network subsystem.
Please let me know what I misunderstand.

2012/10/14 Eric Dumazet <eric.dumazet@gmail.com>:
> In latest kernels, skb->head no longer use kmalloc()/kfree(), so SLAB vs
> SLUB is less a concern for network loads.
>
> In 3.7, (commit 69b08f62e17) we use fragments of order-3 pages to
> populate skb->head.

You mentioned that in latest kernel skb->head no longer use kmalloc()/kfree().
But, why result of David's "netperf RR" test on v3.6 is differentiated
by choosing the allocator?
As far as I know, __netdev_alloc_frag may be introduced in v3.5, so
I'm just confused.
Does this test use __netdev_alloc_skb with "__GFP_WAIT | GFP_DMA"?

Does normal workload for network use __netdev_alloc_skb with
"__GFP_WAIT | GFP_DMA"?

Thanks!
