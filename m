Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756179Ab1FZXLK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jun 2011 19:11:10 -0400
Received: from lucidpixels.com ([72.73.18.11]:44006 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755974Ab1FZXKU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jun 2011 19:10:20 -0400
X-Greylist: delayed 343 seconds by postgrey-1.27 at vger.kernel.org; Sun, 26 Jun 2011 19:10:20 EDT
Date: Sun, 26 Jun 2011 19:04:34 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: linux-kernel@vger.kernel.org
Subject: 2.6.39.2: page allocation failure question
 (__alloc_pages_nodemask+0x626/0x860)
Message-ID: <alpine.DEB.2.02.1106261902050.9133@p34.internal.lan>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

[41624.229468] irq/52-eth0: page allocation failure. order:1, mode:0x20
[41624.229472] Pid: 1980, comm: irq/52-eth0 Not tainted 2.6.39.2 #1
[41624.229474] Call Trace:
[41624.229475]  <IRQ>  [<ffffffff81084916>] ? __alloc_pages_nodemask+0x626/0x860
[41624.229489]  [<ffffffff81601101>] ? cache_alloc_refill+0x25e/0x4c9
[41624.229493]  [<ffffffff810ad3aa>] ? kmem_cache_alloc+0x7a/0xa0
[41624.229496]  [<ffffffff814efd5c>] ? sk_prot_alloc.isra.41+0x3c/0x180
[41624.229499]  [<ffffffff814eff30>] ? sk_clone+0x10/0x2b0
[41624.229502]  [<ffffffff815436db>] ? inet_csk_clone+0xb/0xa0
[41624.229506]  [<ffffffff8155b0a1>] ? tcp_create_openreq_child+0x21/0x4e0
[41624.229509]  [<ffffffff81558233>] ? tcp_v4_syn_recv_sock+0x53/0x250
[41624.229511]  [<ffffffff8155aec4>] ? tcp_check_req+0x2d4/0x490
[41624.229513]  [<ffffffff8155810f>] ? tcp_v4_do_rcv+0x1bf/0x290

I do have enough swap available:

Mem:  16434572k total, 16165796k used,   268776k free,     9068k buffers
Swap: 31246388k total,    18296k used, 31228092k free, 11210636k cached

Perhaps I am just noticing this due to using the threadirq boot option
but is it normal to have page allocation failures on kernel processes if 
physical memory use is high/full and swap is available?

Justin.

