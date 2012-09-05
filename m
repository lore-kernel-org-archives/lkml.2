Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758086Ab2IEBP1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 21:15:27 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:37489 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753553Ab2IEBPZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 21:15:25 -0400
MIME-Version: 1.0
In-Reply-To: <20120904210114.1a30338a@obelix.rh>
References: <20120904143215.5bbbb2a4@obelix.rh>
	<CAE9FiQUEHbDySWHWFj6kW=HGLR0vkbaJWRq+7kMMHGhBm8e08A@mail.gmail.com>
	<20120904161737.358d51ad@obelix.rh>
	<CAE9FiQX7OMdFU6FuTQdz+NdbNt5Hy9zjzSY7y-90G4CbhayfaA@mail.gmail.com>
	<20120904172639.0c2bfd6d@obelix.rh>
	<CAE9FiQWnz-pC3ODOfKo6jumGztd1MdypXB5PG-eDrAfTb1s_xQ@mail.gmail.com>
	<20120904183708.5f10fbde@obelix.rh>
	<CAE9FiQXCzQ+GCCqx4+=ZSijn+_+ekfGrUABiWNuX2H8BL+j9tg@mail.gmail.com>
	<20120904210114.1a30338a@obelix.rh>
Date: Tue, 4 Sep 2012 18:15:25 -0700
X-Google-Sender-Auth: IBWDqw05daHbo013d9JRDkDIPsA
Message-ID: <CAE9FiQWhkPG1AuwW-_REYiBxBtMo+5gpfpgx3Yy2wXZY2JX2kg@mail.gmail.com>
Subject: Re: kexec/kdump kernel fails to start
From: Yinghai Lu <yinghai@kernel.org>
To: Flavio Leitner <fbl@redhat.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        WANG Cong <xiyou.wangcong@gmail.com>, Tejun Heo <tj@kernel.org>,
        ianfang.cn@gmail.com, Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 4, 2012 at 5:01 PM, Flavio Leitner <fbl@redhat.com> wrote:
> On Tue, 4 Sep 2012 15:25:45 -0700
> kdump works when using your branch:
>
> [    0.000000] Linux version 3.6.0-rc4-00012-g9389673 (root@f17i7.rh) (gcc version 4.7.0 20120507 (Red Hat 4.7.0-5) (GCC) ) #1 SMP Tue Sep 4 20:36:43 BRT 2012
> ...
> [    0.000000] initial memory mapped: [mem 0x00000000-0x1fffffff]
> [    0.000000] Base memory trampoline at [ffff880000097000] 97000 size 24576
> [    0.000000] calculate_table_space_size: [mem 0x00000000-0x000fffff]
> [    0.000000]  [mem 0x00000000-0x000fffff] page 4k
> [    0.000000] calculate_table_space_size: [mem 0x00100000-0xbf4bcfff]
> [    0.000000]  [mem 0x00100000-0x001fffff] page 4k
> [    0.000000]  [mem 0x00200000-0xbf3fffff] page 2M
> [    0.000000]  [mem 0xbf400000-0xbf4bcfff] page 4k
> [    0.000000] calculate_table_space_size: [mem 0xbf4bf000-0xbf4c5fff]
> [    0.000000]  [mem 0xbf4bf000-0xbf4c5fff] page 4k
> [    0.000000] calculate_table_space_size: [mem 0xbf7bf000-0xbf7dffff]
> [    0.000000]  [mem 0xbf7bf000-0xbf7dffff] page 4k
> [    0.000000] calculate_table_space_size: [mem 0xbf7ff000-0xbf7fffff]
> [    0.000000]  [mem 0xbf7ff000-0xbf7fffff] page 4k
> [    0.000000] calculate_table_space_size: [mem 0x100000000-0x43fffffff]
> [    0.000000]  [mem 0x100000000-0x43fffffff] page 2M
> [    0.000000] kernel direct mapping tables up to 0x43fffffff @ [mem 0x43ffe1000-0x43fffffff] prealloc
> [    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
> [    0.000000]  [mem 0x00000000-0x000fffff] page 4k
> [    0.000000] init_memory_mapping: [mem 0x00100000-0xbf4bcfff]
> [    0.000000]  [mem 0x00100000-0x001fffff] page 4k
> [    0.000000]  [mem 0x00200000-0xbf3fffff] page 2M
> [    0.000000]  [mem 0xbf400000-0xbf4bcfff] page 4k
> [    0.000000] init_memory_mapping: [mem 0xbf4bf000-0xbf4c5fff]
> [    0.000000]  [mem 0xbf4bf000-0xbf4c5fff] page 4k
> [    0.000000] init_memory_mapping: [mem 0xbf7bf000-0xbf7dffff]
> [    0.000000]  [mem 0xbf7bf000-0xbf7dffff] page 4k
> [    0.000000] init_memory_mapping: [mem 0xbf7ff000-0xbf7fffff]
> [    0.000000]  [mem 0xbf7ff000-0xbf7fffff] page 4k
> [    0.000000] init_memory_mapping: [mem 0x100000000-0x43fffffff]
> [    0.000000]  [mem 0x100000000-0x43fffffff] page 2M
> [    0.000000] kernel direct mapping tables up to 0x43fffffff @ [mem 0x43ffe1000-0x43fff2fff] final
> [    0.000000] RAMDISK: [mem 0x34ffa000-0x367f4fff]

thanks.

assume when we have good_end setting for 64 bit, page table for [4g,
TOMH) will be just under 512M, and later when first
first 2M lines changes, will push that page table range a little low,
and will make kdump not happy.

BTW the first 2M change commit is useless should be reverted. because
even it is in 2M page mapping at first, later
kernel will change to 4k page.

and with other change in this patchset, init_memory_mapping(0,
ISA_END_ADDR) will always make sure first 2M use 4K page.

Thanks

Yinghai
