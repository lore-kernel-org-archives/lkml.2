Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757725Ab1KPCUT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 21:20:19 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38433 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754201Ab1KPCUR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 21:20:17 -0500
Message-ID: <4EC31E55.6040809@redhat.com>
Date: Wed, 16 Nov 2011 10:22:13 +0800
From: Dave Young <dyoung@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: tim@edgecast.com
CC: tj@kernel.org, WANG Cong <xiyou.wangcong@gmail.com>,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: Crash during vmcore_init
References: <1318376345.2050.20.camel@boudreau> <j9r5m5$b18$1@dough.gmane.org> <1321296650.2066.17.camel@boudreau> <4EC21F67.10905@redhat.com> <1321396371.4198.5.camel@boudreau>
In-Reply-To: <1321396371.4198.5.camel@boudreau>
Content-Type: multipart/mixed;
 boundary="------------060509080109010400030907"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060509080109010400030907
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

On 11/16/2011 06:32 AM, Tim Hartrick wrote:

> 
> Dave,
> 
> I tested with
> 
> linux-image-3.1.1-030101-generic_3.1.1-030101.201111111651_amd64.deb
> 
> which, as far as I know, is the Ubuntu build of the latest stable.
> Below are the results.
> 
> [    1.427457] ioremap: invalid physical address 5800000000000


Hi, thanks for the testing

Can you applied the debug patch to see if it's per cpu problem?

Don't need test kdump, just
cd /sys/devices/system/cpu
cat cpu[x]/crash_notes

probably cat crash notes of cpu number other than 0 will get the invalid
address

> [    1.433017] ------------[ cut here ]------------
> [    1.437632] WARNING: at /home/apw/COD/linux/arch/x86/mm/ioremap.c:83
> __ioremap_caller+0x35e/0x3a0()
> [    1.446656] Hardware name: PowerEdge R710
> [    1.450655] Modules linked in:
> [    1.453712] Pid: 1, comm: swapper Not tainted 3.1.1-030101-generic
> #201111111651
> [    1.461092] Call Trace:
> [    1.463539]  [<ffffffff81065aef>] warn_slowpath_common+0x7f/0xc0
> [    1.469532]  [<ffffffff81065b4a>] warn_slowpath_null+0x1a/0x20
> [    1.475352]  [<ffffffff810412be>] __ioremap_caller+0x35e/0x3a0
> [    1.481176]  [<ffffffff8103852e>] ? copy_oldmem_page+0x4e/0xc0
> [    1.486995]  [<ffffffff81041334>] ioremap_cache+0x14/0x20
> [    1.492380]  [<ffffffff8103852e>] copy_oldmem_page+0x4e/0xc0
> [    1.498031]  [<ffffffff811dc7b1>] read_from_oldmem+0xb1/0xf0
> [    1.503682]  [<ffffffff8115e4ec>] ? __kmalloc+0x5c/0x160
> [    1.508984]  [<ffffffff81cfef55>] T.635+0x6e/0x211
> [    1.513767]  [<ffffffff811dc7b1>] ? read_from_oldmem+0xb1/0xf0
> [    1.519588]  [<ffffffff8115e4ec>] ? __kmalloc+0x5c/0x160
> [    1.524887]  [<ffffffff81cff20b>] parse_crash_elf64_headers
> +0x113/0x212
> [    1.531489]  [<ffffffff81cff82f>] ? parse_crash_elf_headers
> +0x122/0x122
> [    1.538088]  [<ffffffff81cff78b>] parse_crash_elf_headers+0x7e/0x122
> [    1.544427]  [<ffffffff81cff850>] vmcore_init+0x21/0x75
> [    1.549645]  [<ffffffff81002043>] do_one_initcall+0x43/0x190
> [    1.555293]  [<ffffffff81cd8680>] kernel_init+0xcd/0x151
> [    1.560596]  [<ffffffff81608af4>] kernel_thread_helper+0x4/0x10
> [    1.566504]  [<ffffffff81cd85b3>] ? parse_early_options+0x20/0x20
> [    1.572584]  [<ffffffff81608af0>] ? gs_change+0x13/0x13
> [    1.577802] ---[ end trace a22d306b065d4a66 ]---
> 
> [    0.000000] Command line: BOOT_IMAGE=/vmlinuz-3.1.1-030101-generic
> root=UUID=ea7a5a27-d58f-469f-a19c-3e65b69587f6 ro console=ttyS0,115200n8
> irqpoll maxcpus=1 nousb memmap=exactmap memmap=640K@0K
> memmap=489836K@33408K elfcorehdr=523244K memmap=252K#2087484K
> 
> 00000000-0000ffff : reserved
> 00010000-0009ffff : System RAM
> 000a0000-000bffff : PCI Bus 0000:00
> 000c0000-000c7fff : Video ROM
> 000c8000-000cdbff : Adapter ROM
> 000ce000-000cefff : Adapter ROM
> 000cf000-000d15ff : Adapter ROM
> 000f0000-000fffff : System ROM
> 00100000-7f678fff : System RAM
>   01000000-0160b9e3 : Kernel code
>   0160b9e4-01cc2dff : Kernel data
>   01dc1000-01f14fff : Kernel bss
>   02000000-1fefffff : Crash kernel
> 7f679000-7f68efff : reserved
>   7f679000-7f679003 : APEI ERST
>   7f67900c-7f679016 : APEI ERST
>   7f679060-7f67906b : APEI ERST
>   7f68d000-7f68efff : APEI ERST
> 7f68f000-7f6cdfff : ACPI Tables
> 7f6ce000-7fffffff : reserved
> 80000000-fdffffff : PCI Bus 0000:00
>   d5800000-d5ffffff : PCI Bus 0000:08
>     d5800000-d5ffffff : 0000:08:03.0
>   d6000000-d9ffffff : PCI Bus 0000:01
>     d6000000-d7ffffff : 0000:01:00.0
>       d6000000-d7ffffff : bnx2
>     d8000000-d9ffffff : 0000:01:00.1
>       d8000000-d9ffffff : bnx2
>   da000000-ddffffff : PCI Bus 0000:02
>     da000000-dbffffff : 0000:02:00.0
>       da000000-dbffffff : bnx2
>     dc000000-ddffffff : 0000:02:00.1
>       dc000000-ddffffff : bnx2
>   de000000-deffffff : PCI Bus 0000:08
>     de000000-de00ffff : 0000:08:03.0
>     de7fc000-de7fffff : 0000:08:03.0
>     de800000-deffffff : 0000:08:03.0
>   df0ff800-df0ffbff : 0000:00:1a.7
>     df0ff800-df0ffbff : ehci_hcd
>   df0ffc00-df0fffff : 0000:00:1d.7
>     df0ffc00-df0fffff : ehci_hcd
>   df100000-df2fffff : PCI Bus 0000:03
>     df100000-df1fffff : 0000:03:00.0
>     df2ec000-df2effff : 0000:03:00.0
>       df2ec000-df2effff : mpt
>     df2f0000-df2fffff : 0000:03:00.0
>       df2f0000-df2fffff : mpt
>   e0000000-efffffff : PCI MMCONFIG 0000 [bus 00-ff]
>     e0000000-efffffff : reserved
>       e0000000-efffffff : pnp 00:09
> fe000000-ffffffff : reserved
>   fec00000-fec003ff : IOAPIC 0
>   fec80000-fec803ff : IOAPIC 1
>   fed00000-fed003ff : HPET 0
>   fed40000-fed44fff : PCI Bus 0000:00
>   fed90000-fed91fff : pnp 00:0b
>   fee00000-fee00fff : Local APIC
> 100000000-c7fffffff : System RAM
> 
> 
> 
> On Tue, 2011-11-15 at 16:14 +0800, Dave Young wrote:
>> On 11/15/2011 02:50 AM, Tim Hartrick wrote:
>>
>>>
>>> Wang,
>>>
>>> Thanks for taking the time to look at this.
>>>
>>>
>>> Here is the result from a 2.6.38 kernel used as base kernel and
>>> crashkernel:
>>>
>>> [    1.314762] WARNING:
>>> at /build/buildd/linux-2.6.38/arch/x86/mm/ioremap.c:83 __ioremap_caller
>>> +0x350/0x3d0()
>>> [    1.324394] Hardware name: PowerEdge R710
>>> [    1.328390] Modules linked in:
>>> [    1.331443] Pid: 1, comm: swapper Not tainted 2.6.38-8-server
>>> #42-Ubuntu
>>> [    1.338128] Call Trace:
>>> [    1.340572]  [<ffffffff81065d1f>] ? warn_slowpath_common+0x7f/0xc0
>>> [    1.346741]  [<ffffffff81065d7a>] ? warn_slowpath_null+0x1a/0x20
>>> [    1.352729]  [<ffffffff81040eb0>] ? __ioremap_caller+0x350/0x3d0
>>> [    1.358726]  [<ffffffff810d8575>] ? call_rcu_sched+0x15/0x20
>>> [    1.364375]  [<ffffffff8103452e>] ? copy_oldmem_page+0x4e/0xc0
>>> [    1.370194]  [<ffffffff8113c39e>] ? __purge_vmap_area_lazy+0xfe/0x1f0
>>> [    1.376622]  [<ffffffff81040f64>] ? ioremap_cache+0x14/0x20
>>> [    1.382176]  [<ffffffff8103452e>] ? copy_oldmem_page+0x4e/0xc0
>>> [    1.388002]  [<ffffffff811cad0a>] ? read_from_oldmem+0x7a/0xb0
>>> [    1.393827]  [<ffffffff81b099a0>] ? merge_note_headers_elf64.clone.3
>>> +0x6c/0x214
>>> [    1.401115]  [<ffffffff8103456a>] ? copy_oldmem_page+0x8a/0xc0
>>> [    1.406936]  [<ffffffff811cad0a>] ? read_from_oldmem+0x7a/0xb0
>>> [    1.412752]  [<ffffffff81b09e79>] ? vmcore_init+0x0/0x73
>>> [    1.418051]  [<ffffffff81b09c52>] ? parse_crash_elf64_headers
>>> +0x10a/0x211
>>> [    1.424825]  [<ffffffff8103456a>] ? copy_oldmem_page+0x8a/0xc0
>>> [    1.430640]  [<ffffffff81b09e79>] ? vmcore_init+0x0/0x73
>>> [    1.435940]  [<ffffffff81b09dd4>] ? parse_crash_elf_headers
>>> +0x7b/0x120
>>> [    1.442450]  [<ffffffff81b09e9c>] ? vmcore_init+0x23/0x73
>>> [    1.447839]  [<ffffffff81002175>] ? do_one_initcall+0x45/0x190
>>> [    1.453661]  [<ffffffff81ae1dff>] ? kernel_init+0x169/0x1f3
>>> [    1.459218]  [<ffffffff8100cde4>] ? kernel_thread_helper+0x4/0x10
>>> [    1.465298]  [<ffffffff81ae1c96>] ? kernel_init+0x0/0x1f3
>>> [    1.470680]  [<ffffffff8100cde0>] ? kernel_thread_helper+0x0/0x10
>>>
>>> The command line for the crashkernel:
>>>
>>> [    0.000000] Command line: BOOT_IMAGE=/vmlinuz-2.6.38-8-server
>>> root=UUID=ea7a5a27-d58f-469f-a19c-3e65b69587f6 ro console=ttyS0,115200n8
>>> irqpoll maxcpus=1 nousb memmap=exactmap memmap=640K@0K
>>> memmap=261484K@623232K elfcorehdr=884716K memmap=252K#2087484K
>>>
>>> The contents of /proc/iomem while running the base kernel:
>>>
>>> 00000000-0000ffff : reserved
>>> 00010000-0009ffff : System RAM
>>> 000a0000-000bffff : PCI Bus 0000:00
>>> 00100000-7f678fff : System RAM
>>>   01000000-015e1d6c : Kernel code
>>>   015e1d6d-01aca17f : Kernel data
>>>   01bae000-01d03fff : Kernel bss
>>>   26000000-35ffffff : Crash kernel
>>> 7f679000-7f68efff : reserved
>>>   7f679000-7f679003 : APEI ERST
>>>   7f67900c-7f679016 : APEI ERST
>>>   7f679060-7f67906b : APEI ERST
>>>   7f68d000-7f68efff : APEI ERST
>>> 7f68f000-7f6cdfff : ACPI Tables
>>> 7f6ce000-7fffffff : reserved
>>> 80000000-fdffffff : PCI Bus 0000:00
>>>   d5800000-d5ffffff : PCI Bus 0000:08
>>>     d5800000-d5ffffff : 0000:08:03.0
>>>   d6000000-d9ffffff : PCI Bus 0000:01
>>>     d6000000-d7ffffff : 0000:01:00.0
>>>       d6000000-d7ffffff : bnx2
>>>     d8000000-d9ffffff : 0000:01:00.1
>>>       d8000000-d9ffffff : bnx2
>>>   da000000-ddffffff : PCI Bus 0000:02
>>>     da000000-dbffffff : 0000:02:00.0
>>>       da000000-dbffffff : bnx2
>>>     dc000000-ddffffff : 0000:02:00.1
>>>       dc000000-ddffffff : bnx2
>>>   de000000-deffffff : PCI Bus 0000:08
>>>     de000000-de00ffff : 0000:08:03.0
>>>     de7fc000-de7fffff : 0000:08:03.0
>>>     de800000-deffffff : 0000:08:03.0
>>>   df0ff800-df0ffbff : 0000:00:1a.7
>>>     df0ff800-df0ffbff : ehci_hcd
>>>   df0ffc00-df0fffff : 0000:00:1d.7
>>>     df0ffc00-df0fffff : ehci_hcd
>>>   df100000-df2fffff : PCI Bus 0000:03
>>>     df100000-df1fffff : 0000:03:00.0
>>>     df2ec000-df2effff : 0000:03:00.0
>>>       df2ec000-df2effff : mpt
>>>     df2f0000-df2fffff : 0000:03:00.0
>>>       df2f0000-df2fffff : mpt
>>>   e0000000-efffffff : PCI MMCONFIG 0000 [bus 00-ff]
>>>     e0000000-efffffff : reserved
>>>       e0000000-efffffff : pnp 00:09
>>> fe000000-ffffffff : reserved
>>>   fec00000-fec003ff : IOAPIC 0
>>>   fec80000-fec803ff : IOAPIC 1
>>>   fed00000-fed003ff : HPET 0
>>>   fed40000-fed44fff : PCI Bus 0000:00
>>>   fed90000-fed91fff : pnp 00:0b
>>>   fee00000-fee00fff : Local APIC
>>> 100000000-c7fffffff : System RAM
>>>
>>>
>>> tim
>>>
>>>
>>>
>>> On Mon, 2011-11-14 at 13:39 +0000, WANG Cong wrote:
>>>> On Tue, 11 Oct 2011 16:39:05 -0700, Tim Hartrick wrote:
>>>>
>>>>> Kexec,
>>>>>
>>>>> I have been experiencing the crash below on Ubuntu 10.04 running
>>>>> 2.6.32-34-server and 2.6.38-8-server as the crashkernel on X86_64. The
>>>>> tools are:
>>>>>
>>>>> kexec-tools	1:2.0.2-1ubuntu3
>>>>> makedumpfile	1.3.7-2
>>>>> kdump-tools	1.3.7-2
>>>>>
>>>>> I would be interested to know if this is a known problem and if so
>>>>> whether or not there is a patch in the pipeline to correct the problem.
>>>>>
>>>>> I will be happy to provide any other details that are required including
>>>>> debug builds if necessary.
>>>> ....
>>>>>
>>>>> [    1.322100] ioremap: invalid physical address db74000000000000 [  
>>
>>
>> Searching db74000000000000 got several similar cases of this, all are
>> about per cpu invalid crash_notes address, is this one more?
>>
>> OTOH, Can you test latest mainline kernel?
>>
>> ccing lkml and Tejun Heo
>>
>>  
>>>>> 1.327919] ------------[ cut here ]------------ [    1.332530] WARNING:
>>>>> at /build/buildd/linux-2.6.32/arch/x86/mm/ioremap.c:120 __ioremap_caller
>>>>> +0x360/0x3d0()
>>>>
>>>> This probably means that kexec-tools passed some incorrect
>>>> kernel parameter to the second kernel.
>>>>
>>>> So, what is the cmdline of your second kernel? And what is your
>>>> /proc/iomem of your first kernel?
>>>>
>>>> Cheers.
>>>>
>>>>
>>>> _______________________________________________
>>>> kexec mailing list
>>>> kexec@lists.infradead.org
>>>> http://lists.infradead.org/mailman/listinfo/kexec
>>>
>>>
>>>
>>> _______________________________________________
>>> kexec mailing list
>>> kexec@lists.infradead.org
>>> http://lists.infradead.org/mailman/listinfo/kexec
>>
>>
>>
> 
> 
> 
> _______________________________________________
> kexec mailing list
> kexec@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/kexec



-- 
Thanks
Dave

--------------060509080109010400030907
Content-Type: text/plain;
 name="percpu-test.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="percpu-test.patch"

--- linux-2.6.orig/mm/percpu.c	2011-11-16 09:38:58.000000000 +0800
+++ linux-2.6/mm/percpu.c	2011-11-16 10:05:36.804771014 +0800
@@ -987,6 +987,7 @@ phys_addr_t per_cpu_ptr_to_phys(void *ad
 	unsigned long first_start, first_end;
 	unsigned int cpu;
 
+	printk(KERN_INFO "per cpu addr %lx\n", addr);
 	/*
 	 * The following test on first_start/end isn't strictly
 	 * necessary but will speed up lookups of addresses which
@@ -1002,11 +1003,19 @@ phys_addr_t per_cpu_ptr_to_phys(void *ad
 
 			if (addr >= start && addr < start + pcpu_unit_size) {
 				in_first_chunk = true;
+				printk(KERN_INFO "addr is in first chunk\n");
+				printk(KERN_INFO "cpu %d, %lx - %lx\n",
+						start, start + pcpu_unit_size);
 				break;
 			}
 		}
 	}
 
+	if (is_vmalloc_addr(addr))
+		printk(KERN_INFO "addr is in vmalloc area\n");
+	else
+		printk(KERN_INFO "addr is not in vmalloc area\n");
+
 	if (in_first_chunk) {
 		if (!is_vmalloc_addr(addr))
 			return __pa(addr);

--------------060509080109010400030907--
