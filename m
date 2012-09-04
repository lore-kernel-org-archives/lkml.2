Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932803Ab2IDWZr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 18:25:47 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:42484 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932565Ab2IDWZq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 18:25:46 -0400
MIME-Version: 1.0
In-Reply-To: <20120904183708.5f10fbde@obelix.rh>
References: <20120904143215.5bbbb2a4@obelix.rh>
	<CAE9FiQUEHbDySWHWFj6kW=HGLR0vkbaJWRq+7kMMHGhBm8e08A@mail.gmail.com>
	<20120904161737.358d51ad@obelix.rh>
	<CAE9FiQX7OMdFU6FuTQdz+NdbNt5Hy9zjzSY7y-90G4CbhayfaA@mail.gmail.com>
	<20120904172639.0c2bfd6d@obelix.rh>
	<CAE9FiQWnz-pC3ODOfKo6jumGztd1MdypXB5PG-eDrAfTb1s_xQ@mail.gmail.com>
	<20120904183708.5f10fbde@obelix.rh>
Date: Tue, 4 Sep 2012 15:25:45 -0700
X-Google-Sender-Auth: Md7zsEGY5UVOYMjbzLbHT6w_fRU
Message-ID: <CAE9FiQXCzQ+GCCqx4+=ZSijn+_+ekfGrUABiWNuX2H8BL+j9tg@mail.gmail.com>
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

On Tue, Sep 4, 2012 at 2:37 PM, Flavio Leitner <fbl@redhat.com> wrote:
> On Tue, 4 Sep 2012 13:45:23 -0700
> Yinghai Lu <yinghai@kernel.org> wrote:
>
>> On Tue, Sep 4, 2012 at 1:26 PM, Flavio Leitner <fbl@redhat.com> wrote:
>> >
>> > Sorry, but it didn't work.
>> > The same problem happened.
>>
>> can you send out boot log ?
>
> sure, there you go:
> http://sysclose.org/kdump/dmesg-debug.log
> http://sysclose.org/kdump/config.log

looks like you did not use for-x86-mm branch.

[    0.000000] initial memory mapped: [mem 0x00000000-0x1fffffff]
[    0.000000] Base memory trampoline at [ffff880000097000] 97000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0xbf7fffff]
[    0.000000]  [mem 0x00000000-0xbf7fffff] page 2M
[    0.000000] kernel direct mapping tables up to 0xbf7fffff @ [mem
0x1fa00000-0x1fffffff]
[    0.000000] init_memory_mapping: [mem 0x100000000-0x43fffffff]
[    0.000000]  [mem 0x100000000-0x43fffffff] page 2M
[    0.000000] kernel direct mapping tables up to 0x43fffffff @ [mem
0xbf7ce000-0xbf7dffff]
[    0.000000] RAMDISK: [mem 0x351d2000-0x368e0fff]
[    0.000000] Reserving 256MB of memory at 592MB for crashkernel
(System RAM: 16372MB)

please try:

mkdir linux || exit -1
cd linux

git init-db

# Add Linus's tree as a remote
git remote add linus
git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git

# Add the -tip tree as a remote
git remote add tip git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git

# Add yinghai's tree

git remote add yinghai
git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-yinghai.git

git remote update

git checkout -b yinghai-for-x86-mm yinghai/for-x86-mm
