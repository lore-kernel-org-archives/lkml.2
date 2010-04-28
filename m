Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754939Ab0D1PV3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 11:21:29 -0400
Received: from mail-yw0-f194.google.com ([209.85.211.194]:49690 "EHLO
	mail-yw0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751690Ab0D1PVY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 11:21:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=YV8SbdhKPAnhWr/acQLuvQHCteZyeMj/fQqoPGOGjq9s3yEd2Gfiij4Cp3ivSBho/X
         F0Cgr+DP6jfr1ffx/EtItBR110X4rfvFbK/ljegAirm6k5ifYgENwzwFGTmWpf+7bv7B
         lbosoQZhhJAf/EXo26xF4FwhUptUywrhnITeg=
MIME-Version: 1.0
In-Reply-To: <1272434481.1974.101.camel@work-vm>
References: <l2ye6bf505b1004271144ta6817962vec8167d813658648@mail.gmail.com>
	 <alpine.LFD.2.00.1004272053130.2951@localhost.localdomain>
	 <1272399798.2255.2.camel@localhost>
	 <1272400246.2255.5.camel@localhost>
	 <s2me6bf505b1004271354v128e0e89q6b506ce99af6d7fd@mail.gmail.com>
	 <1272434481.1974.101.camel@work-vm>
Date: Wed, 28 Apr 2010 10:21:23 -0500
Message-ID: <w2ge6bf505b1004280821g70610cb7lc3821ee890345273@mail.gmail.com>
Subject: Re: 2.6.33.3-rt16 Oops caused by umount
From: Xianghua Xiao <xiaoxianghua@gmail.com>
To: john stultz <johnstul@us.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 28, 2010 at 1:01 AM, john stultz <johnstul@us.ibm.com> wrote:
> On Tue, 2010-04-27 at 15:54 -0500, Xianghua Xiao wrote:
>> On Tue, Apr 27, 2010 at 3:30 PM, john stultz <johnstul@us.ibm.com> wrote:
>> > On Tue, 2010-04-27 at 13:23 -0700, john stultz wrote:
>> >> On Tue, 2010-04-27 at 20:56 +0200, Thomas Gleixner wrote:
>> >> > On Tue, 27 Apr 2010, Xianghua Xiao wrote:
>> >> > > 2.6.33.2-rt13 worked fine, however on 2.6.33.3-rt16, when I do reboot, it oops:
>> >> > >
>> >> > > # reboot
>> >> > > # Oops: Kernel access of bad area, sig: 11 [#1]
>> >> > > PREEMPT 83xx Sys
>> >> > > Modules linked in:
>> >> > > NIP: c00efc68 LR: c00efc38 CTR: 00000000
>> >> > > REGS: ce6e3dc0 TRAP: 0300   Not tainted  (2.6.33.3-rt16)
>> >> > > MSR: 00009032 <EE,ME,IR,DR>  CR: 24000448  XER: 00000000
>> >> > > DAR: 00000038, DSISR: 20000000
>> >> > > TASK = cd89ccc0[1613] 'umount' THREAD: ce6e2000
>> >> > > GPR00: 00000000 ce6e3e70 cd89ccc0 ce6e3ddc 22222222 00000000 ce6e3e24 ce6e3e04
>> >> > > GPR08: 00008000 00000010 cdfa2130 cdfa26e0 44000442 100bbc1c 0fffd000 ffffffff
>> >> > > GPR16: 00000001 00000000 007fff00 00000000 00000000 00000001 ce6e3eb8 00000021
>> >> > > GPR24: 00000060 00000000 00000000 ceb94c40 00000000 ceb94cc0 c065781c ce6e3e70
>> >> > > NIP [c00efc68] fs_may_remount_ro+0x6c/0xd8
>> >> > > LR [c00efc38] fs_may_remount_ro+0x3c/0xd8
>> >> > > Call Trace:
>> >> > > [ce6e3e70] [c00efc38] fs_may_remount_ro+0x3c/0xd8 (unreliable)
>> >> > > [ce6e3e90] [c00f1198] do_remount_sb+0x11c/0x164
>> >> > > [ce6e3eb0] [c0113a3c] do_mount+0x538/0x86c
>> >> > > [ce6e3f10] [c0113e30] sys_mount+0xc0/0x120
>> >> > > [ce6e3f40] [c00178d8] ret_from_syscall+0x0/0x38
>> >> > > --- Exception: c01 at 0xfe5f8c4
>> >> > >     LR = 0x10051b88
>> >> > > Instruction dump:
>> >> > > 38000000 817d00c0 3bbd00c0 60088000 814b0000 2f8a0000 419e0008 7c00522c
>> >> > > 7f8be800 419e004c 812b000c 81290040 <80090028> 2f800000 419e0028 a009006e
>> >> > > ---[ end trace 17c711f9d369c3a3 ]---
>> >>
>> >> Hey Xianghua,
>> >>       What filesystem was this on? And what architecture?
>> >
>> it's ext2 and powerpc 834x. config.gz is attached.
>> the same config is used on 2.6.33.2-rt13 which did not show this umount oops.
>
> So I've not been able to reproduce the issue, but I have found a few
> problems in hunting down the issue Luis reported, and one of them may be
> affecting you here.
>
> Could you try the patch below and let me know if it resolves it for you?
>
> thanks
> -john
>
>
> Fix 3 logic bugs in the vfs-scalability patches.
>
> 1) Typo that could cause a deadlock in do_umount
> 2) Improve MNT_MOUNT handling on cloned rootfs
> 3) Fix might_sleep in atomic in put_mnt_ns
>
> These may not be totally correct, as I still am chasing down some
> namespace issues triggered by unshare().
>
> Signed-off-by: John Stultz <johnstul@us.ibm.com>
>
> diff --git a/fs/namespace.c b/fs/namespace.c
> index 5459a05..8c5d60b 100644
> --- a/fs/namespace.c
> +++ b/fs/namespace.c
> @@ -1233,7 +1233,7 @@ static int do_umount(struct vfsmount *mnt, int flags)
>                 */
>                vfsmount_write_lock();
>                if (count_mnt_count(mnt) != 2) {
> -                       vfsmount_write_lock();
> +                       vfsmount_write_unlock();
>                        return -EBUSY;
>                }
>                vfsmount_write_unlock();
> @@ -1376,6 +1376,12 @@ struct vfsmount *copy_tree(struct vfsmount *mnt, struct dentry *dentry,
>        if (!q)
>                goto Enomem;
>        q->mnt_mountpoint = mnt->mnt_mountpoint;
> +       /*
> +        * We don't call attach_mnt on rootfs, so set
> +        * it as mounted here.
> +        */
> +       WARN_ON(q->mnt_flags & MNT_MOUNTED);
> +       q->mnt_flags |= MNT_MOUNTED;
>
>        p = mnt;
>        list_for_each_entry(r, &mnt->mnt_mounts, mnt_child) {
> @@ -2513,17 +2519,15 @@ void put_mnt_ns(struct mnt_namespace *ns)
>  {
>        struct vfsmount *root;
>        LIST_HEAD(umount_list);
> -       spinlock_t *lock;
>
> -       lock = &get_cpu_var(vfsmount_lock);
> -       if (!atomic_dec_and_lock(&ns->count, lock)) {
> -               put_cpu_var(vfsmount_lock);
> +       vfsmount_write_lock();
> +       if (!atomic_dec_and_test(&ns->count)){
> +               vfsmount_write_unlock();
>                return;
>        }
>        root = ns->root;
>        ns->root = NULL;
> -       spin_unlock(lock);
> -       put_cpu_var(vfsmount_lock);
> +       vfsmount_write_unlock();
>
>        down_write(&namespace_sem);
>        vfsmount_write_lock();
>
>
>
>
>

John,
Just tried the patch, still got umount hang, please see below.
Thanks!
Xianghua

# umount hda2
# reboot
# Oops: Kernel access of bad area, sig: 11 [#1]
PREEMPT 834x SYS
Modules linked in:
NIP: c009ddd8 LR: c009dda8 CTR: 00000000
REGS: ce0f1dd0 TRAP: 0300   Not tainted  (2.6.33.3-rt16)
MSR: 00009032 <EE,ME,IR,DR>  CR: 24000444  XER: 00000000
DAR: 00000028, DSISR: 20000000
TASK = ceb65ab0[973] 'umount' THREAD: ce0f0000
GPR00: 00000000 ce0f1e80 ceb65ab0 ce0f1dfc 22222222 00000000 ce0f1e44
ce0f1e24
GPR08: 00008000 00000000 cf17cc50 cf17c978 44000442 100bbc1c 0fffd000
ffffffff
GPR16: 00000001 00000000 007fff00 00000000 00000000 0fffa1a8 00000000
ce0f1ec8
GPR24: 00000021 00000060 cebaec40 00000000 00000021 cebaecc0 00000001
c051221c
NIP [c009ddd8] fs_may_remount_ro+0x58/0xd0
LR [c009dda8] fs_may_remount_ro+0x28/0xd0
Call Trace:
[ce0f1e80] [c009dda8] fs_may_remount_ro+0x28/0xd0 (unreliable)
[ce0f1ea0] [c009ef1c] do_remount_sb+0x138/0x178
[ce0f1ec0] [c00bdbe8] do_mount+0x54c/0x840
[ce0f1f10] [c00bdfac] sys_mount+0xd0/0xfc
[ce0f1f40] [c0014208] ret_from_syscall+0x0/0x38
--- Exception: c01 at 0xfe5f8c4
    LR = 0x10051b44
Instruction dump:
38000000 817d00c0 60088000 3bbd00c0 814b0000 2f8a0000 419e0008
7c00522c
7f8be800 419e0060 812b000c 81290040 <80090028> 2f800000 419e0028
a009006e
---[ end trace faefbff1ebfe68f9 ]---
------------[ cut here ]------------
Kernel BUG at c03ae294 [verbose debug info unavailable]
Oops: Exception in kernel mode, sig: 5 [#2]
PREEMPT 834x SYS
Modules linked in:
NIP: c03ae294 LR: c03ae26c CTR: 00000000
REGS: ce0f1af0 TRAP: 0700   Tainted: G      D     (2.6.33.3-rt16)
MSR: 00021032 <ME,CE,IR,DR>  CR: 24004428  XER: 00000000
TASK = ceb65ab0[973] 'umount' THREAD: ce0f0000
GPR00: 00000001 ce0f1ba0 ceb65ab0 00000001 11111111 00000000 ce0f1bf4
ce0f1bd4
GPR08: ce0f1bcc 00000000 ceb65ab0 ce0f0000 24004422 100bbc1c 0fffd000
ffffffff
GPR16: 00000001 00000000 007fff00 00000000 00000000 0fffa1a8 c0512224
ce0f1ec8
GPR24: ce0f1bac cf0281a0 cec1ee84 c051221c cec1fdb0 00009032 ceba4b80
ceba4b80
NIP [c03ae294] rt_spin_lock_slowlock+0x90/0x348
LR [c03ae26c] rt_spin_lock_slowlock+0x68/0x348
Call Trace:
[ce0f1ba0] [c03ae26c] rt_spin_lock_slowlock+0x68/0x348 (unreliable)
[ce0f1c30] [c009dd48] file_sb_list_del+0x34/0x6c
[ce0f1c50] [c009e458] __fput+0x154/0x254
[ce0f1c80] [c0085530] remove_vma+0x64/0xd0
[ce0f1c90] [c0085704] exit_mmap+0x168/0x1c4
[ce0f1cf0] [c0022fe4] mmput+0x70/0x138
[ce0f1d10] [c0027c80] exit_mm+0x148/0x170
[ce0f1d40] [c0029e7c] do_exit+0x508/0x614
[ce0f1d90] [c0011ce0] die+0x19c/0x1a4
[ce0f1db0] [c001822c] bad_page_fault+0x98/0xd0
[ce0f1dc0] [c00146a8] handle_page_fault+0x7c/0x80
--- Exception: 300 at fs_may_remount_ro+0x58/0xd0
    LR = fs_may_remount_ro+0x28/0xd0
[ce0f1ea0] [c009ef1c] do_remount_sb+0x138/0x178
[ce0f1ec0] [c00bdbe8] do_mount+0x54c/0x840
[ce0f1f10] [c00bdfac] sys_mount+0xd0/0xfc
[ce0f1f40] [c0014208] ret_from_syscall+0x0/0x38
--- Exception: c01 at 0xfe5f8c4
    LR = 0x10051b44
Instruction dump:
38600001 4bc70781 801b0004 3adb0008 2f800000 419e027c 801b0018
7c4a1378
5400003a 7c400278 7c000034 5400d97e <0f000000> 83c20000 39200002
2f9e0002
---[ end trace faefbff1ebfe68fa ]---
Fixing recursive fault but reboot is needed!
BUG: scheduling while atomic: umount/0x00000001/973, CPU#0
Modules linked in:
Call Trace:
[ce0f18f0] [c0009d14] show_stack+0x70/0x1b8 (unreliable)
[ce0f1930] [c001e8cc] __schedule_bug+0x90/0x94
[ce0f1950] [c03ac910] __schedule+0x2ac/0x390
[ce0f1970] [c03acb98] schedule+0x28/0x54
[ce0f1980] [c0029df4] do_exit+0x480/0x614
[ce0f19d0] [c0011ce0] die+0x19c/0x1a4
[ce0f19f0] [c0011f64] _exception+0x138/0x16c
[ce0f1ae0] [c0014854] ret_from_except_full+0x0/0x4c
--- Exception: 700 at rt_spin_lock_slowlock+0x90/0x348
    LR = rt_spin_lock_slowlock+0x68/0x348
[ce0f1c30] [c009dd48] file_sb_list_del+0x34/0x6c
[ce0f1c50] [c009e458] __fput+0x154/0x254
[ce0f1c80] [c0085530] remove_vma+0x64/0xd0
[ce0f1c90] [c0085704] exit_mmap+0x168/0x1c4
[ce0f1cf0] [c0022fe4] mmput+0x70/0x138
[ce0f1d10] [c0027c80] exit_mm+0x148/0x170
[ce0f1d40] [c0029e7c] do_exit+0x508/0x614
[ce0f1d90] [c0011ce0] die+0x19c/0x1a4
[ce0f1db0] [c001822c] bad_page_fault+0x98/0xd0
[ce0f1dc0] [c00146a8] handle_page_fault+0x7c/0x80
--- Exception: 300 at fs_may_remount_ro+0x58/0xd0
    LR = fs_may_remount_ro+0x28/0xd0
[ce0f1ea0] [c009ef1c] do_remount_sb+0x138/0x178
[ce0f1ec0] [c00bdbe8] do_mount+0x54c/0x840
[ce0f1f10] [c00bdfac] sys_mount+0xd0/0xfc
[ce0f1f40] [c0014208] ret_from_syscall+0x0/0x38
--- Exception: c01 at 0xfe5f8c4
    LR = 0x10051b44


#
