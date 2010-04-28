Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755769Ab0D1VWu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 17:22:50 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:38426 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754917Ab0D1VWt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 17:22:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Y2ZFUUYWugPFY2S8JqRE2FsJSoWFtbpEDVaJXGRV35v17jDPKNfNiJjqsKYv8PpR2d
         OXIW5z1shIHJcOLdH+zN7c/Qpoojiw/VhjNCcCwvkPNrigSQmHoZIzIgyf+ZVtT71vXV
         xrPziLvu3EmIjUqglg0SPjtPfvq7+qKAipt/A=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1004282218470.2951@localhost.localdomain>
References: <l2ye6bf505b1004271144ta6817962vec8167d813658648@mail.gmail.com>
	 <1272400246.2255.5.camel@localhost>
	 <s2me6bf505b1004271354v128e0e89q6b506ce99af6d7fd@mail.gmail.com>
	 <1272434481.1974.101.camel@work-vm>
	 <w2ge6bf505b1004280821g70610cb7lc3821ee890345273@mail.gmail.com>
	 <alpine.LFD.2.00.1004281833230.2951@localhost.localdomain>
	 <y2ge6bf505b1004281054kfc44529fkf87dc5e9d564f9b3@mail.gmail.com>
	 <alpine.LFD.2.00.1004282137330.2951@localhost.localdomain>
	 <g2we6bf505b1004281306sa6ddb207p7a1b8853c3ab308f@mail.gmail.com>
	 <alpine.LFD.2.00.1004282218470.2951@localhost.localdomain>
Date: Wed, 28 Apr 2010 16:22:46 -0500
Message-ID: <x2oe6bf505b1004281422m41f96ec4zf98a94a321d78ba2@mail.gmail.com>
Subject: Re: 2.6.33.3-rt16 Oops caused by umount
From: Xianghua Xiao <xiaoxianghua@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: john stultz <johnstul@us.ibm.com>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 28, 2010 at 3:22 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> On Wed, 28 Apr 2010, Xianghua Xiao wrote:
>> On Wed, Apr 28, 2010 at 2:38 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
>> > On Wed, 28 Apr 2010, Xianghua Xiao wrote:
>> >> Thomas,
>> >> I patched it and re-run it however did not find any condition from
>> >> your patch had a hit.
>> >> In your patch I changed :
>> >>
>> >> if (!file->f_path) {
>> >> to
>> >> if(!(&(file->f_path))){
>> >> Otherwise it won't compile as f_path is a not a pointer.
>> >
>> > True :)
>> >
>> >> # reboot
>> >> # Oops: Kernel access of bad area, sig: 11 [#1]
>> >
>> > Ok. Can you please enable CONFIG_DEBUG_LIST ?
>> >
>> > Thanks,
>> >
>> >        tglx
>> >
>> I turned on that, could not find any difference from the oops log.
>> If I try to remount it rw then ro, the remount ro will cause similar oops
>> Thanks,
>> Xianghua
>>
>> # reboot
>> # Oops: Kernel access of bad area, sig: 11 [#1]
>> PREEMPT 834x SYS
>> Modules linked in:
>> NIP: c009ca1c LR: c009c9cc CTR: 00000000
>
> Can you please decode the code lines with
>
> # addr2line -e vmlinux 0xc009ca1c 0xc009c9cc
>
> You need to enable CONFIG_DEBUG_INFO to get real line numbers.
>
> Thanks,
>
>        tglx

Here it is, thanks!
Xianghua

# reboot
# Oops: Kernel access of bad area, sig: 11 [#1]
PREEMPT 834x SYS
Modules linked in:
NIP: c009ded8 LR: c009de88 CTR: 00000000
REGS: cde51dd0 TRAP: 0300   Not tainted  (2.6.33.3-rt16)
MSR: 00009032 <EE,ME,IR,DR>  CR: 24000444  XER: 00000000
DAR: 00000030, DSISR: 20000000
TASK = ce99d580[1404] 'umount' THREAD: cde50000
GPR00: 0000001d cde51e80 ce99d580 cde51dfc 22222222 00000000 cde51e44 cde51e24
GPR08: cde51e1c 00000008 ce99d580 cdf77c90 44000442 100bbc1c 0fffd000 ffffffff
GPR16: 00000001 00000000 007fff00 00000000 00000000 0fffa1a0 00000000 cde51ec8
GPR24: 00000021 00000060 c045a09c c045a0b8 c051321c cdf084c0 00008000 cdf779b8
NIP [c009ded8] fs_may_remount_ro+0x88/0x150
LR [c009de88] fs_may_remount_ro+0x38/0x150
Call Trace:
[cde51e80] [c009de88] fs_may_remount_ro+0x38/0x150 (unreliable)
[cde51ea0] [c009ef50] do_remount_sb+0x138/0x178
[cde51ec0] [c00bd9c0] do_mount+0x54c/0x840
[cde51f10] [c00bdd84] sys_mount+0xd0/0xfc
[cde51f40] [c00141e8] ret_from_syscall+0x0/0x38
--- Exception: c01 at 0xfe5f8c4
    LR = 0x10051b88
Instruction dump:
817f0000 2f8b0000 419e0008 7c005a2c 7f9fe800 419e0080 813f000c 2f890000
419e00a8 81290040 2f890000 419e00b4 <80090028> 2f800000 419e0028 a009006e
---[ end trace 8efa68ffffb3f0d2 ]---
------------[ cut here ]------------
kernel BUG at kernel/rtmutex.c:808!
Oops: Exception in kernel mode, sig: 5 [#2]
PREEMPT 834x SYS
Modules linked in:
NIP: c03ac1fc LR: c03ac1d4 CTR: 00000000
REGS: cde51af0 TRAP: 0700   Tainted: G      D     (2.6.33.3-rt16)
MSR: 00021032 <ME,CE,IR,DR>  CR: 24004428  XER: 00000000
TASK = ce99d580[1404] 'umount' THREAD: cde50000
GPR00: 00000001 cde51ba0 ce99d580 00000001 11111111 00000000 cde51bf4 cde51bd4
GPR08: cde51bcc 00000000 ce99d580 cde50000 24004422 100bbc1c 0fffd000 ffffffff
GPR16: 00000001 00000000 007fff00 00000000 00000000 0fffa1a0 c0513224 cde51ec8
GPR24: cde51bac cf0281a0 cec21e84 c051321c cec22a60 00009032 cde0e060 cde0e060
NIP [c03ac1fc] rt_spin_lock_slowlock+0x90/0x348
LR [c03ac1d4] rt_spin_lock_slowlock+0x68/0x348
Call Trace:
[cde51ba0] [c03ac1d4] rt_spin_lock_slowlock+0x68/0x348 (unreliable)
[cde51c30] [c009dc24] file_sb_list_del+0x34/0x6c
[cde51c50] [c009e44c] __fput+0x154/0x27c
[cde51c80] [c0085588] remove_vma+0x64/0xd0
[cde51c90] [c008575c] exit_mmap+0x168/0x1c4
[cde51cf0] [c0023054] mmput+0x7c/0x124
[cde51d10] [c0027c9c] exit_mm+0x148/0x170
[cde51d40] [c0029e84] do_exit+0x500/0x60c
[cde51d90] [c0011cc0] die+0x19c/0x1a4
[cde51db0] [c00181e0] bad_page_fault+0x98/0xd0
[cde51dc0] [c0014688] handle_page_fault+0x7c/0x80
--- Exception: 300 at fs_may_remount_ro+0x88/0x150
    LR = fs_may_remount_ro+0x38/0x150
[cde51ea0] [c009ef50] do_remount_sb+0x138/0x178
[cde51ec0] [c00bd9c0] do_mount+0x54c/0x840
[cde51f10] [c00bdd84] sys_mount+0xd0/0xfc
[cde51f40] [c00141e8] ret_from_syscall+0x0/0x38
--- Exception: c01 at 0xfe5f8c4
    LR = 0x10051b88
Instruction dump:
38600001 4bc72915 801b0004 3adb0008 2f800000 419e027c 801b0018 7c4a1378
5400003a 7c400278 7c000034 5400d97e <0f000000> 83c20000 39200002 2f9e0002
---[ end trace 8efa68ffffb3f0d3 ]---
Fixing recursive fault but reboot is needed!
BUG: scheduling while atomic: umount/0x00000001/1404, CPU#0
Modules linked in:
Call Trace:
[cde518f0] [c0009d0c] show_stack+0x70/0x1b8 (unreliable)
[cde51930] [c001e9c8] __schedule_bug+0x90/0x94
[cde51950] [c03aa8a4] __schedule+0x2ac/0x390
[cde51970] [c03aab2c] schedule+0x28/0x54
[cde51980] [c0029dfc] do_exit+0x478/0x60c
[cde519d0] [c0011cc0] die+0x19c/0x1a4
[cde519f0] [c0011f44] _exception+0x138/0x16c
[cde51ae0] [c0014834] ret_from_except_full+0x0/0x4c
--- Exception: 700 at rt_spin_lock_slowlock+0x90/0x348
    LR = rt_spin_lock_slowlock+0x68/0x348
[cde51c30] [c009dc24] file_sb_list_del+0x34/0x6c
[cde51c50] [c009e44c] __fput+0x154/0x27c
[cde51c80] [c0085588] remove_vma+0x64/0xd0
[cde51c90] [c008575c] exit_mmap+0x168/0x1c4
[cde51cf0] [c0023054] mmput+0x7c/0x124
[cde51d10] [c0027c9c] exit_mm+0x148/0x170
[cde51d40] [c0029e84] do_exit+0x500/0x60c
[cde51d90] [c0011cc0] die+0x19c/0x1a4
[cde51db0] [c00181e0] bad_page_fault+0x98/0xd0
[cde51dc0] [c0014688] handle_page_fault+0x7c/0x80
--- Exception: 300 at fs_may_remount_ro+0x88/0x150
    LR = fs_may_remount_ro+0x38/0x150
[cde51ea0] [c009ef50] do_remount_sb+0x138/0x178
[cde51ec0] [c00bd9c0] do_mount+0x54c/0x840
[cde51f10] [c00bdd84] sys_mount+0xd0/0xfc
[cde51f40] [c00141e8] ret_from_syscall+0x0/0x38
--- Exception: c01 at 0xfe5f8c4
    LR = 0x10051b88
