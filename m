Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754012Ab0GIG6J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 02:58:09 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:53920 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752940Ab0GIG6H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 02:58:07 -0400
Message-ID: <4C36C876.9090404@linux.vnet.ibm.com>
Date: Fri, 09 Jul 2010 12:27:58 +0530
From: divya <dipraksh@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100423 Thunderbird/3.0.4
MIME-Version: 1.0
To: maciej.rutecki@gmail.com
CC: linuxppc-dev@ozlabs.org, LKML <linux-kernel@vger.kernel.org>,
       Ron Minnich <rminnich@sandia.gov>, Latchesar Ionkov <lucho@ionkov.net>,
       hch@lst.de, jaxboe@fusionio.com
Subject: Re: Oops while running fs_racer test on a POWER6 box against latest
 git
References: <4C2B28F3.7000006@linux.vnet.ibm.com> <201007012025.30452.maciej.rutecki@gmail.com> <4C2D8B63.2030500@linux.vnet.ibm.com>
In-Reply-To: <4C2D8B63.2030500@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 02 July 2010 12:16 PM, divya wrote:
> On Thursday 01 July 2010 11:55 PM, Maciej Rutecki wrote:
>> On środa, 30 czerwca 2010 o 13:22:27 divya wrote:
>>> While running fs_racer test from LTP on a POWER6 box against latest
>>> git(2.6.35-rc3-git4 - commitid 984bc9601f64fd) came across the 
>>> following
>>> warning followed by multiple oops.
>>>
>> I created a Bugzilla entry at
>> https://bugzilla.kernel.org/show_bug.cgi?id=16324
>> for your bug report, please add your address to the CC list in there, 
>> thanks!
>>
>>
> Here I find a cleaner back trace while running fs_racer test from LTP 
> on a POWER6
> box against the latest git(2.6.35-rc3-git5 - commitid 980019d74e4b242)
>
> Badness at kernel/mutex-debug.c:64
> BUG: key (null) not in .data!
> NIP: c0000000000be9e8 LR: c0000000000be9cc CTR: 0000000000000000
> REGS: c00000010bb176f0 TRAP: 0700   Not tainted  
> (2.6.35-rc3-git5-autotest)
> BUG: key 00000000000001d8 not in .data!
> BUG: key 00000000000001e0 not in .data!
> BUG: key 00000000000001e8 not in .data!
> MSR: 8000000000029032
> Unable to handle kernel paging request for data at address 0x00000028
> Faulting instruction address: 0xc0000000003ad0ec
> Oops: Kernel access of bad area, sig: 11 [#1]
> SMP NR_CPUS=1024 NUMA pSeries
> last sysfs file: 
> /sys/devices/system/cpu/cpu19/cache/index1/shared_cpu_map
> Page fault in user mode with in_atomic() = 1 mm = c00000010943e600
> Modules linked in:
> NIP = fff9e98fc40  MSR = 800000004001d032
>  ipv6 fuse loop
> Unable to handle kernel paging request for unknown fault
>  dm_mod
> Faulting instruction address: 0xc00000000008d0f4
>  sr_mod ibmveth cdrom sg sd_mod crc_t10dif ibmvscsic 
> scsi_transport_srp scsi_tgt scsi_mod
> NIP: c0000000003ad0ec LR: c00000000064c3b0 CTR: c0000000003a6eb0
> REGS: c000000109b4f610 TRAP: 0300   Not tainted  
> (2.6.35-rc3-git5-autotest)
> MSR: 8000000000009032<EE,ME,IR,DR>   CR: 88004484  XER: 00000001
> DAR: 0000000000000028, DSISR: 0000000040010000
> TASK = c000000109a98600[7403] 'mkdir' THREAD: c000000109b4c000 CPU: 19
> GPR00: 0000000080000013 c000000109b4f890 c000000000d3d798 
> 0000000000000028
> GPR04: 0000000000000000 0000000000000000 0000000000000000 
> 0000000000000001
> GPR08: 0000000000000000 0000000000000028 c000000000189f2c 
> c000000109a98600
> GPR12: 0000000024004424 c00000000f602f80 00000000000041ff 
> 0000000000000001
> GPR16: 0000000000000002 c00000010d8304c0 c000000109b4fb44 
> 0000000000000000
> GPR20: c00000010df77908 fffffffffffff000 0000000000010000 
> 00000000000041ff
> GPR24: c00000010df77758 c000000109fa1800 c00000010df77908 
> c0000000ff236600
> GPR28: 0000000000000028 0000000000000040 c000000000ca7b38 
> c000000000189f2c
> NIP [c0000000003ad0ec] .do_raw_spin_trylock+0x10/0x48
> LR [c00000000064c3b0] ._raw_spin_lock+0x50/0xa4
> Call Trace:
> [c000000109b4f890] [c00000000064c3a4] ._raw_spin_lock+0x44/0xa4 
> (unreliable)
> [c000000109b4f920] [c000000000189f2c] .new_inode+0x4c/0xe4
> [c000000109b4f9b0] [c0000000002257fc] .ext3_new_inode+0x84/0xb70
> [c000000109b4fad0] [c00000000022f1ec] .ext3_mkdir+0x130/0x438
> [c000000109b4fbe0] [c00000000017adb4] .vfs_mkdir+0xb8/0x160
> [c000000109b4fc80] [c00000000017e52c] .SyS_mkdirat+0xb0/0x114
> [c000000109b4fdc0] [c00000000017a730] .SyS_mkdir+0x1c/0x30
> [c000000109b4fe30] [c0000000000085b4] syscall_exit+0x0/0x40
> Instruction dump:
> eb41ffd0 7c0803a6 eb61ffd8 eb81ffe0 eba1ffe8 ebc1fff0 ebe1fff8 4e800020
> 38000000 7c691b78 980d0214 800d0008<7d601829>  2c0b0000 40c20010 7c00192d
> Oops: Weird page fault, sig: 11 [#2]
>
> Pls let me know if this back trace would help in analyzing further.
> Meanwhile I shall do a git bisect and send the inputs.
>
> Thanks
> Divya
>
>
>
Hi All,

 From the git bisect,seems like the commit 57439f878afafefad8836ebf5c49da2a0a746105 is the corrupt for the above issue.

Thanks
Divya


