Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753905Ab0FHIuq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 04:50:46 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:52984 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752849Ab0FHIun (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 04:50:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=eHl6T+pRoErwOf1iQPQOornDESadFDOjh//+3Sc4fBwRL/UajYF1t0fcA+GOBhwlo/
         jdUSnKCCIogODiviHXtL8ymKw7pJBP4ud2s94pNBd3H1P0Wx7gJuo8sR6BHG8zzt2b/y
         nkmobP8loTfskW9ki+MjTqw+mSBf/R1+9/V4w=
Date: Tue, 8 Jun 2010 16:54:40 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Pavan Naregundi <pavan@linux.vnet.ibm.com>
Cc: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>,
       linux-kernel@vger.kernel.org, vgoyal@redhat.com, hbabu@us.ibm.com,
       kexec@lists.infradead.org
Subject: Re: [PATCH] Fix Oops in crash_shrink_memory
Message-ID: <20100608085440.GC7110@cr0.nay.redhat.com>
References: <1275895711.4365.18.camel@pavan.naregundi>
 <1275980857.2583.15.camel@pavan.naregundi>
 <20100608075959.GB7110@cr0.nay.redhat.com>
 <1275986405.5015.13.camel@pavan.naregundi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1275986405.5015.13.camel@pavan.naregundi>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 08, 2010 at 02:10:05PM +0530, Pavan Naregundi wrote:
>On Tue, 2010-06-08 at 15:59 +0800, Américo Wang wrote:
>> On Tue, Jun 08, 2010 at 12:37:37PM +0530, Pavan Naregundi wrote:
>> >Adding CC's..
>> >
>> >
>> >On Mon, 2010-06-07 at 12:58 +0530, Pavan Naregundi wrote:
>> >> Hi Everyone,
>> >> 
>> >> Please add me to CC in your reply..
>> >> 
>> >> When crashkernel is not enabled, "echo 0 > /sys/kernel/kexec_crash_size"
>> >> will generate OOPS message in the kernel. Below is the OOPS message and
>> >> other details,
>> >> 
>> >> # cat /proc/cmdline 
>> >> ro  LANG=en_US.UTF-8 SYSFONT=latarcyrheb-sun16 KEYTABLE=us console=hvc0
>> >> rhgb root=UUID=eafd9874-010c-46f9-a0c6-ea8db7c61ac3
>> >> # uname -a
>> >> Linux XXXXXXXX 2.6.35-rc1 #1 SMP Mon Jun 7 18:04:53 IST 2010 ppc64 ppc64
>> >> ppc64 GNU/Linux
>> >> # cd /sys/kernel/
>> >> # ls
>> >> debug               kexec_loaded  profiling      uevent_seqnum
>> >> kexec_crash_loaded  mm            security       vmcoreinfo
>> >> kexec_crash_size    notes         uevent_helper
>> >> # cat kexec_crash_loaded
>> >> 0
>> >> # cat kexec_loaded
>> >> 0
>> >> # cat kexec_crash_size
>> >> 1
>> >> # echo 0 > kexec_crash_size
>> >> Unable to handle kernel paging request for data at address 0x00000030
>> >> Faulting instruction address: 0xc0000000000930b4
>> >> Oops: Kernel access of bad area, sig: 11 [#1]
>> >> SMP NR_CPUS=1024 NUMA pSeries
>> >> last sysfs file: /sys/kernel/kexec_crash_size
>> >> Modules linked in: sunrpc ipv6 ext3 jbd dm_mirror dm_region_hash dm_log
>> >> dm_multipath dm_mod uinput sg ehea sr_mod ibmveth cdrom ext4 jbd2
>> >> mbcache sd_mod crc_t10dif ibmvscsic scsi_transport_srp scsi_tgt [last
>> >> unloaded: scsi_wait_scan]
>> >> NIP: c0000000000930b4 LR: c0000000000930ac CTR: c0000000000b7ce0
>> >> REGS: c0000000b7803750 TRAP: 0300   Not tainted  (2.6.35-rc1)
>> >> MSR: 8000000000009032 <EE,ME,IR,DR>  CR: 28242482  XER: 20000000
>> >> DAR: 0000000000000030, DSISR: 0000000040000000
>> >> TASK = c0000000b9cc3dc0[1381] 'bash' THREAD: c0000000b7800000 CPU: 12
>> >> GPR00: c0000000000930ac c0000000b78039d0 c000000000e885a8
>> >> c000000000f42950 
>> >> GPR04: c0000000b7803af0 0000000000000008 0000000000000002
>> >> c0000000005c6438 
>> >> GPR08: 0000000000000000 000000008000000c 0000000000000000
>> >> 0000000000000000 
>> >> GPR12: 0000000040242448 c000000007441e00 00000000100f6210
>> >> 0000000000000000 
>> >> GPR16: 00000000100f4a38 00000000100cfb98 00000000100f4bdc
>> >> 00000000100f4b4c 
>> >> GPR20: 00000000103f4de8 0000000000000000 0000000000000000
>> >> 00000000100f0000 
>> >> GPR24: c0000000005c65c0 0000000000000000 c000000000da83e0
>> >> c0000000bc67f780 
>> >> GPR28: c0000000bc684ae0 c000000000f42950 c000000000e1e3f8
>> >> c000000000da8408 
>> >> NIP [c0000000000930b4] .release_resource+0x34/0xe0
>> >> LR [c0000000000930ac] .release_resource+0x2c/0xe0
>> >> Call Trace:
>> >> [c0000000b78039d0] [c0000000000930ac] .release_resource+0x2c/0xe0
>> >> (unreliable)
>> >> [c0000000b7803a60] [c0000000000d4fc8] .crash_shrink_memory+0x1c8/0x1f0
>> >> [c0000000b7803b30] [c0000000000b7d38] .kexec_crash_size_store+0x58/0x90
>> >> [c0000000b7803bc0] [c0000000002b0bb4] .kobj_attr_store+0x34/0x50
>> >> [c0000000b7803c30] [c000000000226d5c] .sysfs_write_file+0xec/0x1f0
>> >> [c0000000b7803ce0] [c00000000019e0bc] .vfs_write+0xec/0x1f0
>> >> [c0000000b7803d80] [c00000000019e2e8] .SyS_write+0x58/0xb0
>> >> [c0000000b7803e30] [c00000000000852c] syscall_exit+0x0/0x40
>> >> Instruction dump:
>> >> fba1ffe8 fbc1fff0 fbe1fff8 ebc2b228 7c7f1b78 f8010010 f821ff71 ebbe8000 
>> >> 7fa3eb78 484e35d9 60000000 e97f0020 <e92b0030> 2fa90000 419e002c
>> >> 7fbf4800 
>> >> ---[ end trace afbc780462c9bf4e ]---
>> >> 
>> >> When crashkernel is not enabled, crashk_res resource have not been
>> >> reserved. Hence crashk_res.parent will be NULL.
>> >> 
>> >> Attaching a simple patch to this problem. Patch is tested and resolves this bug.
>> 
>> 
>> Ouch...
>> 
>> The patch indeed addresses the problem, looks good to me.
>> Please add your Signed-off-by and my:
>> 
>> Reviewed-by: WANG Cong <xiyou.wangcong@gmail.com>
>> 
>> Another problem is that you should get 0 instead of 1 when you don't
>> reserve any memory.
>
>We get 1 here because, crash_get_memory_size() adds 1 as below, 
>
>size = crashk_res.end - crashk_res.start + 1;
>
>We cant remove this addition, as it is required to display correct size
>in case if we reserve the crash memory.

Yeah, but 0 is a special case, isn't it?


>
>Coming back to issue.. Attaching the patch again.
>
>Signed-off-by: Pavan Naregundi <pavan@linux.vnet.ibm.com>
>Reviewed-by: WANG Cong <xiyou.wangcong@gmail.com>

Thanks!


>---

>diff -Naur a/kernel/kexec.c b/kernel/kexec.c
>--- a/kernel/kexec.c	2010-06-07 18:45:55.050000000 +0530
>+++ b/kernel/kexec.c	2010-06-07 18:50:28.070000004 +0530
>@@ -1134,7 +1134,7 @@
> 
> 	free_reserved_phys_range(end, crashk_res.end);
> 
>-	if (start == end)
>+	if ((start == end) && (crashk_res.parent != NULL))
> 		release_resource(&crashk_res);
> 	crashk_res.end = end - 1;
> 

