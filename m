Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758293Ab1KVJZV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 04:25:21 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:46606 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758222Ab1KVJZR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 04:25:17 -0500
Message-ID: <1321953911.2474.1.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Subject: Re: WARNING: at mm/slub.c:3357, kernel BUG at mm/slub.c:3413
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: Christoph Lameter <cl@linux.com>, Christian Kujau <lists@nerdbynature.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "Alex,Shi" <alex.shi@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>
Date: Tue, 22 Nov 2011 10:25:11 +0100
In-Reply-To: <20111122084513.GA1688@x4.trippels.de>
References: <20111121161036.GA1679@x4.trippels.de>
	 <1321894353.10470.19.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	 <1321895706.10470.21.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	 <20111121173556.GA1673@x4.trippels.de>
	 <1321900743.10470.31.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	 <20111121185215.GA1673@x4.trippels.de>
	 <20111121195113.GA1678@x4.trippels.de> <1321907275.13860.12.camel@pasglop>
	 <alpine.DEB.2.01.1111211617220.8000@trent.utfs.org>
	 <alpine.DEB.2.00.1111212105330.19606@router.home>
	 <20111122084513.GA1688@x4.trippels.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 22 novembre 2011 à 09:45 +0100, Markus Trippelsdorf a écrit :
> On 2011.11.21 at 21:18 -0600, Christoph Lameter wrote:
> > On Mon, 21 Nov 2011, Christian Kujau wrote:
> > 
> > > On Tue, 22 Nov 2011 at 07:27, Benjamin Herrenschmidt wrote:
> > > > Note that I hit a similar looking crash (sorry, I couldn't capture a
> > > > backtrace back then) on a PowerMac G5 (ppc64) while doing a large rsync
> > > > transfer yesterday with -rc2-something (cfcfc9ec) and
> > > > Christian Kujau (CC) seems to be able to reproduce something similar on
> > > > some other ppc platform (Christian, what is your setup ?)
> > >
> > > I seem to hit it with heavy disk & cpu IO is in progress on this PowerBook
> > > G4. Full dmesg & .config: http://nerdbynature.de/bits/3.2.0-rc1/oops/
> > >
> > > I've enabled some debug options and now it really points to slub.c:2166
> > 
> 
> I sometimes see the following pattern. Is this a false positive?
> 
> 
> =============================================================================
> BUG anon_vma: Redzone overwritten
> -----------------------------------------------------------------------------
> 
> INFO: 0xffff88020f347c80-0xffff88020f347c87. First byte 0xbb instead of 0xcc
> INFO: Allocated in anon_vma_fork+0x51/0x140 age=1 cpu=2 pid=1826
> 	__slab_alloc.constprop.70+0x1ac/0x1e8
> 	kmem_cache_alloc+0x12e/0x160
> 	anon_vma_fork+0x51/0x140
> 	dup_mm+0x1f2/0x4a0
> 	copy_process+0xd10/0xf70
> 	do_fork+0x100/0x2b0
> 	sys_clone+0x23/0x30
> 	stub_clone+0x13/0x20
> INFO: Freed in __put_anon_vma+0x54/0xa0 age=0 cpu=1 pid=1827
> 	__slab_free+0x33/0x2d0
> 	kmem_cache_free+0x10e/0x120
> 	__put_anon_vma+0x54/0xa0
> 	unlink_anon_vmas+0x12f/0x1c0
> 	free_pgtables+0x83/0xe0
> 	exit_mmap+0xee/0x140
> 	mmput+0x43/0xf0
> 	flush_old_exec+0x33f/0x630
> 	load_elf_binary+0x340/0x1960
> 	search_binary_handler+0x8f/0x180
> 	do_execve+0x2d3/0x370
> 	sys_execve+0x42/0x70
> 	stub_execve+0x6c/0xc0
> INFO: Slab 0xffffea00083cd1c0 objects=10 used=9 fp=0xffff88020f347ab8 flags=0x4000000000000081
> INFO: Object 0xffff88020f347c40 @offset=3136 fp=0xffff88020f347ab8

One thing you could do is to disable slub merge, with following
additional boot param : "slub_nomerge=1"



