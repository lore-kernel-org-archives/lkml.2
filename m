Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752338Ab2DBUE6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 16:04:58 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:53089 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751768Ab2DBUE4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 16:04:56 -0400
Message-ID: <4F7A065F.4050409@gmail.com>
Date: Mon, 02 Apr 2012 14:04:47 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: =?UTF-8?B?QnJ1bm8gUHLDqW1vbnQ=?= <bonbons@linux-vserver.org>,
        Jiri Olsa <jolsa@redhat.com>
CC: "Eric W. Biederman" <ebiederm@xmission.com>, linux-kernel@vger.kernel.org,
        Greg KH <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [3.4-rc1 crash]: NULL pointer deref in fs/sysfs/group.c:create_files
 -- sysctl related?
References: <20120402162716.4c93bfd3@pluto.restena.lu> <20120402165036.2bc987ad@pluto.restena.lu> <m17gxyklfm.fsf@fess.ebiederm.org> <20120402213440.49e9de74@neptune>
In-Reply-To: <20120402213440.49e9de74@neptune>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/2/12 1:34 PM, Bruno Prémont wrote:
> [adding a few perf people to CC as might originate from perf]
>
> On Mon, 02 April 2012 Eric W. Biederman wrote:
>> Bruno Prémont writes:
>>> On Mon, 2 Apr 2012 16:27:16 Bruno Prémont wrote:
>>>> Trying to boot a freshly built 3.4-rc1 (x86_64) kernel I'm getting the following
>>>> trace (server is HP Proliant G4):
>>>>
>>>> [    0.986317] BUG: unable to handle kernel NULL pointer dereference at           (null)
>>>> [    0.990542] IP: [<ffffffff81152673>] internal_create_group+0x83/0x1a0
>>>> [    0.993693] PGD 0
>>>> [    0.994682] Oops: 0000 [#1] SMP
>>>> [    0.996198] CPU 0
>>>> [    0.996198] Modules linked in:
>>>> [    0.996198]
>>>> [    0.996198] Pid: 1, comm: swapper/0 Not tainted 3.4.0-rc1-x86_64 #3 HP ProLiant DL360 G4
>>>> [    0.996198] RIP: 0010:[<ffffffff81152673>]  [<ffffffff81152673>] internal_create_group+0x83/0x1a0
>>>> [    0.996198] RSP: 0018:ffff88019485fd70  EFLAGS: 00010202
>>>> [    0.996198] RAX: 0000000000000001 RBX: 0000000000000000 RCX: 0000000000000001
>>>> [    0.996198] RDX: ffff880192e99908 RSI: ffff880192e99630 RDI: ffffffff81a26c60
>>>> [    0.996198] RBP: ffff88019485fdc0 R08: 0000000000000000 R09: 0000000000000000
>>>> [    0.996198] R10: ffff880192e99908 R11: 0000000000000000 R12: ffffffff81a16a00
>>>> [    0.996198] R13: ffff880192e99908 R14: ffffffff81a16900 R15: 0000000000000000
>>>> [    0.996198] FS:  0000000000000000(0000) GS:ffff88019bc00000(0000) knlGS:0000000000000000
>>>> [    0.996198] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
>>>> [    0.996198] CR2: 0000000000000000 CR3: 0000000001a0c000 CR4: 00000000000007f0
>>>> [    0.996198] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>>>> [    0.996198] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
>>>> [    0.996198] Process swapper/0 (pid: 1, threadinfo ffff88019485e000, task ffff880194878000)
>>>> [    0.996198] Stack:
>>>> [    0.996198]  ffff88019485fdd0 ffff880192da9d60 0000000000000000 ffff880192e99908
>>>> [    0.996198]  ffff880192e995d8 0000000000000001 ffffffff81a16a00 ffff880192da9d60
>>>> [    0.996198]  0000000000000000 0000000000000000 ffff88019485fdd0 ffffffff811527be
>>>> [    0.996198] Call Trace:
>>>> [    0.996198]  [<ffffffff811527be>] sysfs_create_group+0xe/0x10
>>>> [    0.996198]  [<ffffffff81376ca6>] device_add_groups+0x46/0x80
>>>> [    0.996198]  [<ffffffff81377d3d>] device_add+0x46d/0x6a0
>>>> [    0.996198]  [<ffffffff81377891>] ? device_private_init+0x51/0x90
>>>> [    0.996198]  [<ffffffff81a98975>] ? utsname_sysctl_init+0x14/0x14
>>>> [    0.996198]  [<ffffffff810a7228>] pmu_dev_alloc+0x98/0xe0
>>>> [    0.996198]  [<ffffffff81a98975>] ? utsname_sysctl_init+0x14/0x14
>>>> [    0.996198]  [<ffffffff81a989c0>] perf_event_sysfs_init+0x4b/0x9a
>>>> [    0.996198]  [<ffffffff810002ad>] do_one_initcall+0x3d/0x170
>>>> [    0.996198]  [<ffffffff81a85cbd>] kernel_init+0x12d/0x1be
>>>> [    0.996198]  [<ffffffff81a85505>] ? rdinit_setup+0x28/0x28
>>>> [    0.996198]  [<ffffffff815f3714>] kernel_thread_helper+0x4/0x10
>>>> [    0.996198]  [<ffffffff81a85b90>] ? start_kernel+0x373/0x373
>>>> [    0.996198]  [<ffffffff815f3710>] ? gs_change+0xb/0xb
>>>> [    0.996198] Code: ff 85 c0 0f 85 bc 00 00 00 4c 8b 6d c8 4d 85 ed 74 15 41 8b 45 00 85 c0 0f 84 0b 01 00 00 f0 41 ff 45 00 4c 8b 6d c8 49 8b 5e 10<48>  8b 03 48 85 c0 74 71 45 31 e4 eb 44 49 8b 46 08 48 85 c0 74
>>>> [    0.996198] RIP  [<ffffffff81152673>] internal_create_group+0x83/0x1a0
>>>> [    0.996198]  RSP<ffff88019485fd70>
>>>> [    0.996198] CR2: 0000000000000000
>>>> [    1.131357] ---[ end trace 319c95c486d7d9cd ]---
>>>> [    1.133676] Kernel panic - not syncing: Attempted to kill init! exitcode=0x00000009
>>>> [    1.133677]
>>>
>>> The patch below works around it and leaves exactly one trace for WARN_ON() matching
>>> above BUG.
>>> With it, system boots to userspace.
>>>
>>> Thanks,
>>> Bruno
>>>
>>> ---
>>> diff --git a/fs/sysfs/group.c b/fs/sysfs/group.c
>>> index dd1701c..0040ff2 100644
>>> --- a/fs/sysfs/group.c
>>> +++ b/fs/sysfs/group.c
>>> @@ -32,7 +32,8 @@ static int create_files(struct sysfs_dirent *dir_sd, struct kobject *kobj,
>>>   	struct attribute *const* attr;
>>>   	int error = 0, i;
>>>
>>> -	for (i = 0, attr = grp->attrs; *attr&&  !error; i++, attr++) {
>>> +	WARN_ON(!grp->attrs);
>>> +	for (i = 0, attr = grp->attrs; attr&&  *attr&&  !error; i++, attr++) {
>>>   		umode_t mode = 0;
>>>
>>>   		/* in update mode, we're changing the permissions or
>>
>> Sysfs has not changed in this area from 3.3.
>>
>> The sysctl in your backtrace looks like left over addresses on the stack.
>>
>> The backtrack indicates this is something perf related going wonky.
>>
>> I would suggest you try disabling your perf related options one by one
>> until the broken one shows up.  Or possibly just initially disable perf.
>
> Well, I didn't enable perf, all perf-related options that are enabled
> are selected by X86!
>
> Symbol: HAVE_PERF_EVENTS [=y]
>    Type  : boolean
>    Selected by: X86 [=y]
>
> Symbol: PERF_EVENTS [=y]
>    Type  : boolean
>    Prompt: Kernel performance events and counters
>            Defined at init/Kconfig:1157
>    Depends on: HAVE_PERF_EVENTS [=y]
>    Location:
>      ->  General setup
>        ->  Kernel Performance Events And Counters
>    Selects: ANON_INODES [=y]&&  IRQ_WORK [=y]
>    Selected by: X86 [=y] || KVM [=n]&&  VIRTUALIZATION [=n]&&  HAVE_KVM [=y]&&  PCI [=y]&&  NET [=y]
>
> Symbol: HAVE_PERF_EVENTS_NMI [=y]
>    Type  : boolean
>    Selected by: X86 [=y]
>
>> This looks like one of those crazy things where something registers
>> with the perf subsystem, and then perf later registers it with sysfs,
>> and whatever was registered did not have set the needed group attrs.
>
>
>  From quick-reading kernel/events/core.c which contains perf_event_sysfs_init()
> and pmu_dev_alloc() and commits from v3.3..v3.4 for that file
> commit 0c9d42ed4cee2aa1dfc3a260b741baae8615744f (perf, x86: Provide means
> for disabling userspace RDPMC) by Peter looks like a possible
> candidate or at least startpoint:
>
> diff --git a/kernel/events/core.c b/kernel/events/core.c
> index 05affc3..dcd4049 100644
> --- a/kernel/events/core.c
> +++ b/kernel/events/core.c
> @@ -5505,6 +5505,7 @@ static int pmu_dev_alloc(struct pmu *pmu)
>          if (!pmu->dev)
>                  goto out;
>
> +       pmu->dev->groups = pmu->attr_groups;
>          device_initialize(pmu->dev);
>          ret = dev_set_name(pmu->dev, "%s", pmu->name);
>          if (ret)
>
> Will try bisecting corresponding merge tomorrow when I have full access to affected
> system.

Perhaps:
641cc93 perf: Adding sysfs group format attribute for pmu device

David
