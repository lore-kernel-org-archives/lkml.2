Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753969Ab2DBS5h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 14:57:37 -0400
Received: from out07.mta.xmission.com ([166.70.13.237]:56481 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752391Ab2DBS5f convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 14:57:35 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Bruno =?utf-8?Q?Pr=C3=A9mont?= <bonbons@linux-vserver.org>
Cc: linux-kernel@vger.kernel.org, Greg KH <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
References: <20120402162716.4c93bfd3@pluto.restena.lu>
	<20120402165036.2bc987ad@pluto.restena.lu>
Date: Mon, 02 Apr 2012 12:01:17 -0700
In-Reply-To: <20120402165036.2bc987ad@pluto.restena.lu> ("Bruno
 =?utf-8?Q?Pr=C3=A9mont=22's?=
	message of "Mon, 2 Apr 2012 16:50:36 +0200")
Message-ID: <m17gxyklfm.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/EDSmHTi2WDHn9vZjUl95CZmbCz17RZYY=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: *  2.0 XMRefNum Lotto "reference" number
	*  1.5 TR_Symld_Words too many words that have symbols inside
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_XMDrugObfuBody_12 obfuscated drug references
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_TooManySym_03 6+ unique symbols in subject
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: =?ISO-8859-1?Q?*;Bruno Pr=c3=a9mont <bonbons@linux-vserver.org>?=
X-Spam-Relay-Country: **
Subject: Re: [3.4-rc1 crash]: NULL pointer deref in fs/sysfs/group.c:create_files -- sysctl related?
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bruno Prémont <bonbons@linux-vserver.org> writes:

> On Mon, 2 Apr 2012 16:27:16 Bruno Prémont wrote:
>> Trying to boot a freshly built 3.4-rc1 (x86_64) kernel I'm getting the following
>> trace (server is HP Proliant G4):
>> 
>> [    0.986317] BUG: unable to handle kernel NULL pointer dereference at           (null)
>> [    0.990542] IP: [<ffffffff81152673>] internal_create_group+0x83/0x1a0
>> [    0.993693] PGD 0 
>> [    0.994682] Oops: 0000 [#1] SMP 
>> [    0.996198] CPU 0 
>> [    0.996198] Modules linked in:
>> [    0.996198] 
>> [    0.996198] Pid: 1, comm: swapper/0 Not tainted 3.4.0-rc1-x86_64 #3 HP ProLiant DL360 G4
>> [    0.996198] RIP: 0010:[<ffffffff81152673>]  [<ffffffff81152673>] internal_create_group+0x83/0x1a0
>> [    0.996198] RSP: 0018:ffff88019485fd70  EFLAGS: 00010202
>> [    0.996198] RAX: 0000000000000001 RBX: 0000000000000000 RCX: 0000000000000001
>> [    0.996198] RDX: ffff880192e99908 RSI: ffff880192e99630 RDI: ffffffff81a26c60
>> [    0.996198] RBP: ffff88019485fdc0 R08: 0000000000000000 R09: 0000000000000000
>> [    0.996198] R10: ffff880192e99908 R11: 0000000000000000 R12: ffffffff81a16a00
>> [    0.996198] R13: ffff880192e99908 R14: ffffffff81a16900 R15: 0000000000000000
>> [    0.996198] FS:  0000000000000000(0000) GS:ffff88019bc00000(0000) knlGS:0000000000000000
>> [    0.996198] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
>> [    0.996198] CR2: 0000000000000000 CR3: 0000000001a0c000 CR4: 00000000000007f0
>> [    0.996198] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>> [    0.996198] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
>> [    0.996198] Process swapper/0 (pid: 1, threadinfo ffff88019485e000, task ffff880194878000)
>> [    0.996198] Stack:
>> [    0.996198]  ffff88019485fdd0 ffff880192da9d60 0000000000000000 ffff880192e99908
>> [    0.996198]  ffff880192e995d8 0000000000000001 ffffffff81a16a00 ffff880192da9d60
>> [    0.996198]  0000000000000000 0000000000000000 ffff88019485fdd0 ffffffff811527be
>> [    0.996198] Call Trace:
>> [    0.996198]  [<ffffffff811527be>] sysfs_create_group+0xe/0x10
>> [    0.996198]  [<ffffffff81376ca6>] device_add_groups+0x46/0x80
>> [    0.996198]  [<ffffffff81377d3d>] device_add+0x46d/0x6a0
>> [    0.996198]  [<ffffffff81377891>] ? device_private_init+0x51/0x90
>> [    0.996198]  [<ffffffff81a98975>] ? utsname_sysctl_init+0x14/0x14
>> [    0.996198]  [<ffffffff810a7228>] pmu_dev_alloc+0x98/0xe0
>> [    0.996198]  [<ffffffff81a98975>] ? utsname_sysctl_init+0x14/0x14
>> [    0.996198]  [<ffffffff81a989c0>] perf_event_sysfs_init+0x4b/0x9a
>> [    0.996198]  [<ffffffff810002ad>] do_one_initcall+0x3d/0x170
>> [    0.996198]  [<ffffffff81a85cbd>] kernel_init+0x12d/0x1be
>> [    0.996198]  [<ffffffff81a85505>] ? rdinit_setup+0x28/0x28
>> [    0.996198]  [<ffffffff815f3714>] kernel_thread_helper+0x4/0x10
>> [    0.996198]  [<ffffffff81a85b90>] ? start_kernel+0x373/0x373
>> [    0.996198]  [<ffffffff815f3710>] ? gs_change+0xb/0xb
>> [    0.996198] Code: ff 85 c0 0f 85 bc 00 00 00 4c 8b 6d c8 4d 85 ed 74 15 41 8b 45 00 85 c0 0f 84 0b 01 00 00 f0 41 ff 45 00 4c 8b 6d c8 49 8b 5e 10 <48> 8b 03 48 85 c0 74 71 45 31 e4 eb 44 49 8b 46 08 48 85 c0 74 
>> [    0.996198] RIP  [<ffffffff81152673>] internal_create_group+0x83/0x1a0
>> [    0.996198]  RSP <ffff88019485fd70>
>> [    0.996198] CR2: 0000000000000000
>> [    1.131357] ---[ end trace 319c95c486d7d9cd ]---
>> [    1.133676] Kernel panic - not syncing: Attempted to kill init! exitcode=0x00000009
>> [    1.133677] 
>
> The patch below works around it and leaves exactly one trace for WARN_ON() matching
> above BUG.
> With it, system boots to userspace.
>
> Thanks,
> Bruno
>
> ---
> diff --git a/fs/sysfs/group.c b/fs/sysfs/group.c
> index dd1701c..0040ff2 100644
> --- a/fs/sysfs/group.c
> +++ b/fs/sysfs/group.c
> @@ -32,7 +32,8 @@ static int create_files(struct sysfs_dirent *dir_sd, struct kobject *kobj,
>  	struct attribute *const* attr;
>  	int error = 0, i;
>  
> -	for (i = 0, attr = grp->attrs; *attr && !error; i++, attr++) {
> +	WARN_ON(!grp->attrs);
> +	for (i = 0, attr = grp->attrs; attr && *attr && !error; i++, attr++) {
>  		umode_t mode = 0;
>  
>  		/* in update mode, we're changing the permissions or

Sysfs has not changed in this area from 3.3.

The sysctl in your backtrace looks like left over addresses on the stack.

The backtrack indicates this is something perf related going wonky.

I would suggest you try disabling your perf related options one by one
until the broken one shows up.  Or possibly just initially disable perf.

This looks like one of those crazy things where something registers
with the perf subsystem, and then perf later registers it with sysfs,
and whatever was registered did not have set the needed group attrs.



Eric

