Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759095Ab0GPTTi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 15:19:38 -0400
Received: from smtp-out.google.com ([74.125.121.35]:31905 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759017Ab0GPTTh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 15:19:37 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=pO/i1P5ROPp8Aa7oQnHDuPb5470KstV4Yjn6VmT0FJJ3W6mu5tVnPYOS20a9ggn/B
	s7p8aZH1LeMDvVyOVzlWQ==
Date: Fri, 16 Jul 2010 12:19:30 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Dave Hansen <dave@linux.vnet.ibm.com>
cc: Eric Dumazet <eric.dumazet@gmail.com>, divya <dipraksh@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, linuxppc-dev@ozlabs.org,
        sachinp@linux.vnet.ibm.com, benh@kernel.crashing.org,
        netdev <netdev@vger.kernel.org>, David Miller <davem@davemloft.net>,
        Jan-Bernd Themann <ossthema@de.ibm.com>
Subject: Re: Badness with the kernel version 2.6.35-rc1-git1 running on P6
 box
In-Reply-To: <1279301731.9207.239.camel@nimitz>
Message-ID: <alpine.DEB.2.00.1007161217220.21287@chino.kir.corp.google.com>
References: <4C401D56.3070108@linux.vnet.ibm.com> <1279274185.2549.14.camel@edumazet-laptop> <1279301731.9207.239.camel@nimitz>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Jul 2010, Dave Hansen wrote:

> > > SLUB: Unable to allocate memory on node -1 (gfp=0x20)
> > >    cache: kmalloc-16384, object size: 16384, buffer size: 16384,
> > default order: 2, min order: 0
> > >    node 0: slabs: 28, objs: 292, free: 0
> > > ip: page allocation failure. order:0, mode:0x8020
> > > Call Trace:
> > > [c000000006a0eb40] [c000000000011c30] .show_stack+0x6c/0x16c (unreliable)
> > > [c000000006a0ebf0] [c00000000012129c] .__alloc_pages_nodemask+0x6a0/0x75c
> > > [c000000006a0ed70] [c0000000001527cc] .alloc_pages_current+0xc4/0x104
> > > [c000000006a0ee10] [c00000000011fca4] .__get_free_pages+0x18/0x90
> > > [c000000006a0ee90] [c0000000004f7058] .ehea_get_stats+0x4c/0x1bc
> > > [c000000006a0ef30] [c0000000005a0a04] .dev_get_stats+0x38/0x64
> > > [c000000006a0efc0] [c0000000005b456c] .rtnl_fill_ifinfo+0x35c/0x85c
> > > [c000000006a0f150] [c0000000005b5920] .rtmsg_ifinfo+0x164/0x204
> > > [c000000006a0f210] [c0000000005a6d6c] .dev_change_flags+0x4c/0x7c
> > > [c000000006a0f2a0] [c0000000005b50b4] .do_setlink+0x31c/0x750
> > > [c000000006a0f3b0] [c0000000005b6724] .rtnl_newlink+0x388/0x618
> > > [c000000006a0f5f0] [c0000000005b6350] .rtnetlink_rcv_msg+0x268/0x2b4
> > > [c000000006a0f6a0] [c0000000005cfdc0] .netlink_rcv_skb+0x74/0x108
> > > [c000000006a0f730] [c0000000005b60c4] .rtnetlink_rcv+0x38/0x5c
> > > [c000000006a0f7c0] [c0000000005cf8c8] .netlink_unicast+0x318/0x3f4
> > > [c000000006a0f890] [c0000000005d05b4] .netlink_sendmsg+0x2d0/0x310
> > > [c000000006a0f970] [c00000000058e1e8] .sock_sendmsg+0xd4/0x110
> > > [c000000006a0fb50] [c00000000058e514] .SyS_sendmsg+0x1f4/0x288
> > > [c000000006a0fd70] [c00000000058c2b8] .SyS_socketcall+0x214/0x280
> > > [c000000006a0fe30] [c0000000000085b4] syscall_exit+0x0/0x40
> > > Mem-Info:
> > > Node 0 DMA per-cpu:
> > > CPU    0: hi:    0, btch:   1 usd:   0
> > > CPU    1: hi:    0, btch:   1 usd:   0
> > > CPU    2: hi:    0, btch:   1 usd:   0
> > > CPU    3: hi:    0, btch:   1 usd:   0
> > > 
> > > The mainline 2.6.35-rc5 worked fine.
> > 
> > Maybe you were lucky with 2.6.35-rc5
> > 
> > Anyway ehea should not use GFP_ATOMIC in its ehea_get_stats() method,
> > called in process context, but GFP_KERNEL.
> > 
> > Another patch is needed for ehea_refill_rq_def() as well.
> 
> You're right that this is abusing GFP_ATOMIC.
> 
> But is, this is just a normal "GFP_ATOMIC" allocation failure?  "SLUB:
> Unable to allocate memory on node -1" seems like a somewhat
> inappropriate error message for that.  
> 

The slub message is seperate and doesn't generate a call trace, even 
though it is a (minimum) order-0 GFP_ATOMIC allocation as well.  The page 
allocation failure is seperate instance that is calling the page 
allocator, not the slab allocator.

> It isn't immediately obvious where the -1 is coming from.  Does it truly
> mean "allocate from any node" here, or is that a buglet in and of
> itself?
> 

Yes, slub uses -1 to indicate that the allocation need not come from a 
specific node.
