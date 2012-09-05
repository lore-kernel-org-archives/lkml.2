Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758030Ab2IEABc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 20:01:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46679 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752899Ab2IEAB3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 20:01:29 -0400
Date: Tue, 4 Sep 2012 21:01:14 -0300
From: Flavio Leitner <fbl@redhat.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: lkml <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        WANG Cong <xiyou.wangcong@gmail.com>, Tejun Heo <tj@kernel.org>,
        ianfang.cn@gmail.com, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: kexec/kdump kernel fails to start
Message-ID: <20120904210114.1a30338a@obelix.rh>
In-Reply-To: <CAE9FiQXCzQ+GCCqx4+=ZSijn+_+ekfGrUABiWNuX2H8BL+j9tg@mail.gmail.com>
References: <20120904143215.5bbbb2a4@obelix.rh>
	<CAE9FiQUEHbDySWHWFj6kW=HGLR0vkbaJWRq+7kMMHGhBm8e08A@mail.gmail.com>
	<20120904161737.358d51ad@obelix.rh>
	<CAE9FiQX7OMdFU6FuTQdz+NdbNt5Hy9zjzSY7y-90G4CbhayfaA@mail.gmail.com>
	<20120904172639.0c2bfd6d@obelix.rh>
	<CAE9FiQWnz-pC3ODOfKo6jumGztd1MdypXB5PG-eDrAfTb1s_xQ@mail.gmail.com>
	<20120904183708.5f10fbde@obelix.rh>
	<CAE9FiQXCzQ+GCCqx4+=ZSijn+_+ekfGrUABiWNuX2H8BL+j9tg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Sep 2012 15:25:45 -0700
Yinghai Lu <yinghai@kernel.org> wrote:

> On Tue, Sep 4, 2012 at 2:37 PM, Flavio Leitner <fbl@redhat.com> wrote:
> > On Tue, 4 Sep 2012 13:45:23 -0700
> > Yinghai Lu <yinghai@kernel.org> wrote:
> >
> >> On Tue, Sep 4, 2012 at 1:26 PM, Flavio Leitner <fbl@redhat.com> wrote:
> >> >
> >> > Sorry, but it didn't work.
> >> > The same problem happened.
> >>
> >> can you send out boot log ?
> >
> > sure, there you go:
> > http://sysclose.org/kdump/dmesg-debug.log
> > http://sysclose.org/kdump/config.log
> 
> looks like you did not use for-x86-mm branch.
> 
> [    0.000000] initial memory mapped: [mem 0x00000000-0x1fffffff]
> [    0.000000] Base memory trampoline at [ffff880000097000] 97000 size 24576
> [    0.000000] init_memory_mapping: [mem 0x00000000-0xbf7fffff]
> [    0.000000]  [mem 0x00000000-0xbf7fffff] page 2M
> [    0.000000] kernel direct mapping tables up to 0xbf7fffff @ [mem
> 0x1fa00000-0x1fffffff]
> [    0.000000] init_memory_mapping: [mem 0x100000000-0x43fffffff]
> [    0.000000]  [mem 0x100000000-0x43fffffff] page 2M
> [    0.000000] kernel direct mapping tables up to 0x43fffffff @ [mem
> 0xbf7ce000-0xbf7dffff]
> [    0.000000] RAMDISK: [mem 0x351d2000-0x368e0fff]
> [    0.000000] Reserving 256MB of memory at 592MB for crashkernel
> (System RAM: 16372MB)
> 
> please try:
> 
> mkdir linux || exit -1
> cd linux
> 
> git init-db
> 
> # Add Linus's tree as a remote
> git remote add linus
> git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
> 
> # Add the -tip tree as a remote
> git remote add tip git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git
> 
> # Add yinghai's tree
> 
> git remote add yinghai
> git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-yinghai.git
> 
> git remote update
> 
> git checkout -b yinghai-for-x86-mm yinghai/for-x86-mm

kdump works when using your branch:

[    0.000000] Linux version 3.6.0-rc4-00012-g9389673 (root@f17i7.rh) (gcc version 4.7.0 20120507 (Red Hat 4.7.0-5) (GCC) ) #1 SMP Tue Sep 4 20:36:43 BRT 2012
...
[    0.000000] initial memory mapped: [mem 0x00000000-0x1fffffff]
[    0.000000] Base memory trampoline at [ffff880000097000] 97000 size 24576
[    0.000000] calculate_table_space_size: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] calculate_table_space_size: [mem 0x00100000-0xbf4bcfff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0xbf3fffff] page 2M
[    0.000000]  [mem 0xbf400000-0xbf4bcfff] page 4k
[    0.000000] calculate_table_space_size: [mem 0xbf4bf000-0xbf4c5fff]
[    0.000000]  [mem 0xbf4bf000-0xbf4c5fff] page 4k
[    0.000000] calculate_table_space_size: [mem 0xbf7bf000-0xbf7dffff]
[    0.000000]  [mem 0xbf7bf000-0xbf7dffff] page 4k
[    0.000000] calculate_table_space_size: [mem 0xbf7ff000-0xbf7fffff]
[    0.000000]  [mem 0xbf7ff000-0xbf7fffff] page 4k
[    0.000000] calculate_table_space_size: [mem 0x100000000-0x43fffffff]
[    0.000000]  [mem 0x100000000-0x43fffffff] page 2M
[    0.000000] kernel direct mapping tables up to 0x43fffffff @ [mem 0x43ffe1000-0x43fffffff] prealloc
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x00100000-0xbf4bcfff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0xbf3fffff] page 2M
[    0.000000]  [mem 0xbf400000-0xbf4bcfff] page 4k
[    0.000000] init_memory_mapping: [mem 0xbf4bf000-0xbf4c5fff]
[    0.000000]  [mem 0xbf4bf000-0xbf4c5fff] page 4k
[    0.000000] init_memory_mapping: [mem 0xbf7bf000-0xbf7dffff]
[    0.000000]  [mem 0xbf7bf000-0xbf7dffff] page 4k
[    0.000000] init_memory_mapping: [mem 0xbf7ff000-0xbf7fffff]
[    0.000000]  [mem 0xbf7ff000-0xbf7fffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x100000000-0x43fffffff]
[    0.000000]  [mem 0x100000000-0x43fffffff] page 2M
[    0.000000] kernel direct mapping tables up to 0x43fffffff @ [mem 0x43ffe1000-0x43fff2fff] final
[    0.000000] RAMDISK: [mem 0x34ffa000-0x367f4fff]
...
http://sysclose.org/kdump/dmesg.log
http://sysclose.org/kdump/config.log

thanks,
fbl
