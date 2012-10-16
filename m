Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755982Ab2JPTQQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 15:16:16 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:51660 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755838Ab2JPTQM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 15:16:12 -0400
Subject: Re: [Q] Default SLAB allocator
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Ezequiel Garcia <elezegarcia@gmail.com>
Cc: Tim Bird <tim.bird@am.sony.com>, David Rientjes <rientjes@google.com>,
        Andi Kleen <andi@firstfloor.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "celinux-dev@lists.celinuxforum.org" 
	<celinux-dev@lists.celinuxforum.org>
In-Reply-To: <CALF0-+VLVqy_uE63_jL83qh8MqBQAE3vYLRX1mRQURZ4a1M20g@mail.gmail.com>
References: <CALF0-+XGn5=QSE0bpa4RTag9CAJ63MKz1kvaYbpw34qUhViaZA@mail.gmail.com>
	 <m27gqwtyu9.fsf@firstfloor.org>
	 <alpine.DEB.2.00.1210111558290.6409@chino.kir.corp.google.com>
	 <m2391ktxjj.fsf@firstfloor.org>
	 <CALF0-+WLZWtwYY4taYW9D7j-abCJeY90JzcTQ2hGK64ftWsdxw@mail.gmail.com>
	 <alpine.DEB.2.00.1210130252030.7462@chino.kir.corp.google.com>
	 <CALF0-+Xp_P_NjZpifzDSWxz=aBzy_fwaTB3poGLEJA8yBPQb_Q@mail.gmail.com>
	 <alpine.DEB.2.00.1210151745400.31712@chino.kir.corp.google.com>
	 <CALF0-+WgfnNOOZwj+WLB397cgGX7YhNuoPXAK5E0DZ5v_BxxEA@mail.gmail.com>
	 <1350392160.3954.986.camel@edumazet-glaptop> <507DA245.9050709@am.sony.com>
	 <CALF0-+VLVqy_uE63_jL83qh8MqBQAE3vYLRX1mRQURZ4a1M20g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 16 Oct 2012 21:16:08 +0200
Message-ID: <1350414968.3954.1427.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-10-16 at 15:27 -0300, Ezequiel Garcia wrote:

> Yes, we have some numbers:
> 
> http://elinux.org/Kernel_dynamic_memory_analysis#Kmalloc_objects
> 
> Are they too informal? I can add some details...
> 
> They've been measured on a **very** minimal setup, almost every option
> is stripped out, except from initramfs, sysfs, and trace.
> 
> On this scenario, strings allocated for file names and directories
> created by sysfs
> are quite noticeable, being 4-16 bytes, and produce a lot of fragmentation from
> that 32 byte cache at SLAB.
> 
> Is an option to enable small caches on SLUB and SLAB worth it?

Random small web server :

# free
             total       used       free     shared    buffers     cached
Mem:       7884536    5412572    2471964          0     155440    1803340
-/+ buffers/cache:    3453792    4430744
Swap:      2438140      51164    2386976

# grep Slab /proc/meminfo
Slab:             351592 kB

# egrep "kmalloc-32|kmalloc-16|kmalloc-8" /proc/slabinfo 
kmalloc-32         11332  12544     32  128    1 : tunables    0    0    0 : slabdata     98     98      0
kmalloc-16          5888   5888     16  256    1 : tunables    0    0    0 : slabdata     23     23      0
kmalloc-8          76563  82432      8  512    1 : tunables    0    0    0 : slabdata    161    161      0

Really, some waste on these small objects is pure noise on SMP hosts.

(Waste on bigger objects is probably more important by orders of magnitude)




