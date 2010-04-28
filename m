Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932164Ab0D1UHB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 16:07:01 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:45922 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932148Ab0D1UG7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 16:06:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=wVj8DFyfknm4kD4HNNfbmJY+a6aWFB8qKLU7uhQ15um1Ypj7UNtRdaOWbI46/5D2Df
         Dnv8QzYPdQNULv24FvI/RLngDY2MWzH1FuY1u42EGiOYgSXbKob6/5uKncIIRXq6dppl
         nungwUwezOObNPBIpGALF+MqXS6lJAVImoQpQ=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1004282137330.2951@localhost.localdomain>
References: <l2ye6bf505b1004271144ta6817962vec8167d813658648@mail.gmail.com>
	 <alpine.LFD.2.00.1004272053130.2951@localhost.localdomain>
	 <1272399798.2255.2.camel@localhost>
	 <1272400246.2255.5.camel@localhost>
	 <s2me6bf505b1004271354v128e0e89q6b506ce99af6d7fd@mail.gmail.com>
	 <1272434481.1974.101.camel@work-vm>
	 <w2ge6bf505b1004280821g70610cb7lc3821ee890345273@mail.gmail.com>
	 <alpine.LFD.2.00.1004281833230.2951@localhost.localdomain>
	 <y2ge6bf505b1004281054kfc44529fkf87dc5e9d564f9b3@mail.gmail.com>
	 <alpine.LFD.2.00.1004282137330.2951@localhost.localdomain>
Date: Wed, 28 Apr 2010 15:06:58 -0500
Message-ID: <g2we6bf505b1004281306sa6ddb207p7a1b8853c3ab308f@mail.gmail.com>
Subject: Re: 2.6.33.3-rt16 Oops caused by umount
From: Xianghua Xiao <xiaoxianghua@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: john stultz <johnstul@us.ibm.com>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 28, 2010 at 2:38 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> On Wed, 28 Apr 2010, Xianghua Xiao wrote:
>> Thomas,
>> I patched it and re-run it however did not find any condition from
>> your patch had a hit.
>> In your patch I changed :
>>
>> if (!file->f_path) {
>> to
>> if(!(&(file->f_path))){
>> Otherwise it won't compile as f_path is a not a pointer.
>
> True :)
>
>> # reboot
>> # Oops: Kernel access of bad area, sig: 11 [#1]
>
> Ok. Can you please enable CONFIG_DEBUG_LIST ?
>
> Thanks,
>
>        tglx
>
I turned on that, could not find any difference from the oops log.
If I try to remount it rw then ro, the remount ro will cause similar oops
Thanks,
Xianghua

# reboot
# Oops: Kernel access of bad area, sig: 11 [#1]
PREEMPT 834x SYS
Modules linked in:
NIP: c009ca1c LR: c009c9cc CTR: 00000000
REGS: cde43dd0 TRAP: 0300   Not tainted  (2.6.33.3-rt16)
MSR: 00009032 <EE,ME,IR,DR>  CR: 24000444  XER: 20000000
DAR: 31c554a2, DSISR: 20000000
TASK = ce9219d0[1396] 'umount' THREAD: cde42000
GPR00: 0000001d cde43e80 ce9219d0 c0454910 000002ac 000002ac 00008000 00000000
GPR08: 00007fff 31c5547a c0454910 cea82b78 44000442 100bbc1c 0fffd000 ffffffff
GPR16: 00000001 00000000 007fff00 00000000 00000000 0fffa1a0 00000000 cde43ec8
GPR24: 00000021 00000060 c045869c c04586b8 c050bd6c ce951488 00008000 cea82960
NIP [c009ca1c] fs_may_remount_ro+0x88/0x150
LR [c009c9cc] fs_may_remount_ro+0x38/0x150
Call Trace:
[cde43e80] [c009c9cc] fs_may_remount_ro+0x38/0x150 (unreliable)
[cde43ea0] [c009da10] do_remount_sb+0x138/0x178
[cde43ec0] [c00bc420] do_mount+0x54c/0x840
[cde43f10] [c00bc7e4] sys_mount+0xd0/0xfc
[cde43f40] [c00141e8] ret_from_syscall+0x0/0x38
--- Exception: c01 at 0xfe5f8c4
    LR = 0x10051b88
Instruction dump:
817f0000 2f8b0000 419e0008 7c005a2c 7f9fe800 419e0080 813f000c 2f890000
419e00a8 81290024 2f890000 419e00b4 <80090028> 2f800000 419e0028 a009006e
---[ end trace cd3eb2ed5361fbce ]---
------------[ cut here ]------------
kernel BUG at kernel/rtmutex.c:808!
Oops: Exception in kernel mode, sig: 5 [#2]
PREEMPT 834x SYS
Modules linked in:
NIP: c03aa79c LR: c03aa774 CTR: c011fbfc
REGS: cde43b00 TRAP: 0700   Tainted: G      D     (2.6.33.3-rt16)
MSR: 00021032 <ME,CE,IR,DR>  CR: 82004428  XER: 00000000
TASK = ce9219d0[1396] 'umount' THREAD: cde42000
GPR00: 00000001 cde43bb0 ce9219d0 00000001 000002ac 000002ac 00008000 00000000
GPR08: 00000000 00000000 ce9219d0 cde42000 22004422 100bbc1c 0fffd000 ffffffff
GPR16: 00000001 00000000 007fff00 00000000 00000000 0fffa1a0 00000000 c050bd74
GPR24: 00000021 cf0231a0 cec19b34 c050bd6c cec1a9a8 00009032 cde52080 cde52080
NIP [c03aa79c] rt_spin_lock_slowlock+0x84/0x318
LR [c03aa774] rt_spin_lock_slowlock+0x5c/0x318
Call Trace:
[cde43bb0] [c03aa774] rt_spin_lock_slowlock+0x5c/0x318 (unreliable)
[cde43c30] [c009c7e4] file_sb_list_del+0x34/0x6c
[cde43c50] [c009cf6c] __fput+0x154/0x254
[cde43c80] [c00843dc] remove_vma+0x64/0xd0
[cde43c90] [c00845b0] exit_mmap+0x168/0x1c4
[cde43cf0] [c0022f48] mmput+0x7c/0x124
[cde43d10] [c0027ba8] exit_mm+0x148/0x170
[cde43d40] [c0029d90] do_exit+0x500/0x60c
[cde43d90] [c0011cc0] die+0x19c/0x1a4
[cde43db0] [c00181e0] bad_page_fault+0x98/0xd0
[cde43dc0] [c0014688] handle_page_fault+0x7c/0x80
--- Exception: 300 at fs_may_remount_ro+0x88/0x150
    LR = fs_may_remount_ro+0x38/0x150
[cde43ea0] [c009da10] do_remount_sb+0x138/0x178
[cde43ec0] [c00bc420] do_mount+0x54c/0x840
[cde43f10] [c00bc7e4] sys_mount+0xd0/0xfc
[cde43f40] [c00141e8] ret_from_syscall+0x0/0x38
--- Exception: c01 at 0xfe5f8c4
    LR = 0x10051b88
Instruction dump:
38600001 4bc74275 801b0004 3afb0008 2f800000 419e0270 801b0010 7c4a1378
5400003a 7c400278 7c000034 5400d97e <0f000000> 83c20000 39200002 2f9e0002
---[ end trace cd3eb2ed5361fbcf ]---
Fixing recursive fault but reboot is needed!
BUG: scheduling while atomic: umount/0x00000001/1396, CPU#0
Modules linked in:
Call Trace:
[cde43900] [c0009d0c] show_stack+0x70/0x1b8 (unreliable)
[cde43940] [c001e8c8] __schedule_bug+0x90/0x94
[cde43960] [c03a9024] __schedule+0x2ac/0x390
[cde43980] [c03a92ac] schedule+0x28/0x54
[cde43990] [c0029d08] do_exit+0x478/0x60c
[cde439e0] [c0011cc0] die+0x19c/0x1a4
[cde43a00] [c0011f44] _exception+0x138/0x16c
[cde43af0] [c0014834] ret_from_except_full+0x0/0x4c
--- Exception: 700 at rt_spin_lock_slowlock+0x84/0x318
    LR = rt_spin_lock_slowlock+0x5c/0x318
[cde43c30] [c009c7e4] file_sb_list_del+0x34/0x6c
[cde43c50] [c009cf6c] __fput+0x154/0x254
[cde43c80] [c00843dc] remove_vma+0x64/0xd0
[cde43c90] [c00845b0] exit_mmap+0x168/0x1c4
[cde43cf0] [c0022f48] mmput+0x7c/0x124
[cde43d10] [c0027ba8] exit_mm+0x148/0x170
[cde43d40] [c0029d90] do_exit+0x500/0x60c
[cde43d90] [c0011cc0] die+0x19c/0x1a4
[cde43db0] [c00181e0] bad_page_fault+0x98/0xd0
[cde43dc0] [c0014688] handle_page_fault+0x7c/0x80
--- Exception: 300 at fs_may_remount_ro+0x88/0x150
    LR = fs_may_remount_ro+0x38/0x150
[cde43ea0] [c009da10] do_remount_sb+0x138/0x178
[cde43ec0] [c00bc420] do_mount+0x54c/0x840
[cde43f10] [c00bc7e4] sys_mount+0xd0/0xfc
[cde43f40] [c00141e8] ret_from_syscall+0x0/0x38
--- Exception: c01 at 0xfe5f8c4
    LR = 0x10051b88
