Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757298Ab2HIJi1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 05:38:27 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:40385 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751000Ab2HIJiY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 05:38:24 -0400
Message-ID: <50238496.1000504@huawei.com>
Date: Thu, 9 Aug 2012 17:36:22 +0800
From: Jiang Liu <jiang.liu@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:9.0) Gecko/20111222 Thunderbird/9.0.1
MIME-Version: 1.0
To: Tang Chen <tangchen@cn.fujitsu.com>
CC: Yinghai Lu <yinghai@kernel.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Wen Congyang <wency@cn.fujitsu.com>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>,
        Tony Luck <tony.luck@intel.com>, Huang Ying <ying.huang@intel.com>,
        Bob Moore <robert.moore@intel.com>, Len Brown <lenb@kernel.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Bjorn Helgaas <bhelgaas@google.com>, <linux-kernel@vger.kernel.org>,
        <linux-acpi@vger.kernel.org>, <linux-pci@vger.kernel.org>,
        Jiang Liu <liuj97@gmail.com>, Hanjun Guo <guohanjun@huawei.com>
Subject: Re: [RFC PATCH v2 10/16] ACPIHP: system device hotplug driver skeleton
References: <1344082443-4608-1-git-send-email-jiang.liu@huawei.com> <1344082443-4608-11-git-send-email-jiang.liu@huawei.com> <502362E3.8010901@cn.fujitsu.com> <50236978.70208@huawei.com> <502377C0.70401@cn.fujitsu.com>
In-Reply-To: <502377C0.70401@cn.fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.108.108.229]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-8-9 16:41, Tang Chen wrote:
> Hi Liu ~
> 
> On 08/09/2012 03:40 PM, Jiang Liu wrote:
>> Hi Tang,
>> 	Thanks for testing.
>> 	Currently there's a limitation that you need to insert acpihp_enum driver first.
> 
> Sorry, I didn't make it clear. I did load acpihp_enum module first, and then load acpihp_drv.
> 
> And I just tried it some more times. It just hung up, but dmesg had no output.
> Like this:
> 
> # modprobe acpihp_enum
> (OK, and sysfs interfaces have been created)
> # modprobe acpihp_drv
> (hang up)
> 
> # dmesg
> (nothing)
> 
> The "modprobe acpihp_drv" process's call trace shows that it hung at the following function:
> #0  0x00000032836aab80 in __nanosleep_nocancel () from /lib64/libc.so.6
> #1  0x00000032836deb64 in usleep () from /lib64/libc.so.6
> ......
> 
> I have tried several times and I cannot reproduce the situation I just said.
You can reproduce it by loading acpihp_drv without acpihp_enum driver, I guess.
The acpihp_drv module_init() should call acpihp_register_class() to initialize the core.

> Maybe my box has something different with yours. And I'll try to find out why.
> 
> Thanks for your advice. :)
> 
>> Will fix this issue in next version.
>> 	Regards!
>> 	Gerry
>>
>> On 2012-8-9 15:12, Tang Chen wrote:
>>> Hi Liu~
>>>
>>> I compiled this driver as a module, acpihp_drv. And when I loaded this module, it
>>> gave the following error message:
>>>
>>> # modprobe acpihp_drv
>>> (the command hangs up, no return after 10 min)
>>>
>>> #dmesg
>>> ......
>>> [  126.643350] BUG: unable to handle kernel NULL pointer dereference at 0000000000000078
>>> [  126.644007] IP: [<ffffffff814c0cd3>] mutex_lock+0x19/0x37
>>> [  126.644007] PGD 105277a067 PUD 104f823067 PMD 0 
>>> [  126.644007] Oops: 0002 [#1] SMP 
>>> [  126.644007] Modules linked in: acpihp_drv(+) ebtable_nat ebtables ipt_MASQUERADE iptable_nat nf_nat iptable_mangle bridge stp llc sunrpc cpufreq_ondemand acpi_cpufreq freq_table mperf ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_filter ip6_tables ipv6 vhost_net macvtap macvlan tun uinput iTCO_wdt iTCO_vendor_support coretemp kvm_intel kvm crc32c_intel microcode lpc_ich mfd_core pcspkr i2c_i801 i2c_core ioatdma e1000e acpi_memhotplug i7core_edac edac_core igb dca mptsas mptscsih mptbase scsi_transport_sas
>>> [  126.644007] CPU 10 
>>> [  126.644007] Pid: 2821, comm: modprobe Tainted: G       A     3.6.0-rc1+ #6 FUJITSU-SV PRIMEQUEST 1800E/SB
>>> [  126.644007] RIP: 0010:[<ffffffff814c0cd3>]  [<ffffffff814c0cd3>] mutex_lock+0x19/0x37
>>> [  126.644007] RSP: 0018:ffff8810589a9de8  EFLAGS: 00010246
>>> [  126.644007] RAX: 0000000000000000 RBX: 0000000000000078 RCX: 0000000000000000
>>> [  126.644007] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000078
>>> [  126.644007] RBP: ffff8810589a9e08 R08: 0000000000000000 R09: ffff8810589a9d88
>>> [  126.644007] R10: 00000000000013e5 R11: 00000000000013e5 R12: ffffffffa01460d0
>>> [  126.644007] R13: 0000000000000000 R14: ffffffffa014732b R15: 00000000000000bf
>>> [  126.644007] FS:  00007fecb1802700(0000) GS:ffff88105e640000(0000) knlGS:0000000000000000
>>> [  126.644007] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>>> [  126.644007] CR2: 0000000000000078 CR3: 0000001052772000 CR4: 00000000000007e0
>>> [  126.644007] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>>> [  126.644007] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
>>> [  126.644007] Process modprobe (pid: 2821, threadinfo ffff8810589a8000, task ffff8810592f8000)
>>> [  126.644007] Stack:
>>> [  126.644007]  ffff8810589a9e08 ffffffff810be37f ffffffffa0146220 ffffffff81a7b390
>>> [  126.644007]  ffff8810589a9e58 ffffffff81317eb3 ffff8810589a9e48 0000000000000000
>>> [  126.644007]  ffffffff81a342c0 ffffffff81a342e0 0000000000000000 ffffffffa0146220
>>> [  126.644007] Call Trace:
>>> [  126.644007]  [<ffffffff810be37f>] ? tracepoint_module_notify+0xd9/0x14a
>>> [  126.644007]  [<ffffffff81317eb3>] class_interface_register+0x4a/0xbc
>>> [  126.644007]  [<ffffffffa00b8000>] ? 0xffffffffa00b7fff
>>> [  126.644007]  [<ffffffffa00b8010>] acpihp_drv_init+0x10/0x12 [acpihp_drv]
>>> [  126.644007]  [<ffffffff8100207f>] do_one_initcall+0x7f/0x139
>>> [  126.644007]  [<ffffffff81093414>] sys_init_module+0x12d3/0x14e3
>>> [  126.644007]  [<ffffffff81264b0d>] ? ddebug_dyndbg_boot_param_cb+0x45/0x45
>>> [  126.644007]  [<ffffffff814c9469>] system_call_fastpath+0x16/0x1b
>>> [  126.644007] Code: 48 8b 04 25 80 c6 00 00 48 89 43 18 31 c0 5b 5b c9 c3 55 48 89 e5 53 48 83 ec 18 66 66 66 66 90 48 89 fb e8 5a 0c 00 00 48 89 df <f0> ff 0f 79 05 e8 06 ff ff ff 65 48 8b 04 25 80 c6 00 00 48 89 
>>> [  126.644007] RIP  [<ffffffff814c0cd3>] mutex_lock+0x19/0x37
>>> [  126.644007]  RSP <ffff8810589a9de8>
>>> [  126.644007] CR2: 0000000000000078
>>> [  129.981335] ---[ end trace da17e9c9de8dd560 ]---
>>> [  139.085895] nr_pdflush_threads exported in /proc is scheduled for removal
>>> [  139.167394] sysctl: The scan_unevictable_pages sysctl/node-interface has been disabled for lack of a legitimate use case.  If you have one, please send an email to linux-mm@kvack.org.
>>>
>>> Looks like it dereferenced a NULL pointer here.
>>> May be it was my mistake that I didn't configure the environment correctly.
>>> Would you please give me some advice ?
>>>
>>> Thanks. :)
>>>
>>>
> 


