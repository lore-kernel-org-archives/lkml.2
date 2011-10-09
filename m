Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751674Ab1JICer (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Oct 2011 22:34:47 -0400
Received: from vms173005pub.verizon.net ([206.46.173.5]:44539 "EHLO
	vms173005pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751270Ab1JICeq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Oct 2011 22:34:46 -0400
Message-id: <4E910844.9060501@acm.org>
Date: Sat, 08 Oct 2011 21:34:44 -0500
From: Corey Minyard <minyard@acm.org>
Reply-to: minyard@acm.org
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23)
 Gecko/20110922 Thunderbird/3.1.15
MIME-version: 1.0
To: Denys Fedoryshchenko <nuclearcat@nuclearcat.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: ipmi_si crashed kernel during modprobe
References: <201010012141.34069.nuclearcat@nuclearcat.com>
 <4E9107A2.8020200@acm.org>
In-reply-to: <4E9107A2.8020200@acm.org>
Content-type: text/plain; charset=KOI8-R; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/08/2011 09:32 PM, Corey Minyard wrote:
> On 10/01/2010 01:41 PM, Denys Fedoryshchenko wrote:
>> Kernel 2.6.35.4
>> Linux MegaRouterXeon-KARAM 2.6.35.4-build-0053 #2 SMP Mon Sep 6 
>> 00:00:21 EEST
>> 2010 i686 GNU/Linux
>>
>> Hyperthreading, x86 (32-bit)
>> If required i can attach kernel config.
> I'm guessing you unloaded and reloaded the driver.  There was a bug 
> fixed by commit d2478521afc20227658a10a8c5c2bf1a2aa615b3 that fixes this.
Oops, sorry, this was old.  Never mind.

>
> -corey
>
>>
>>
>>
>> kernel: [2229840.807025] IPMI System Interface driver.
>> kernel: [2229840.807508] BUG: unable to handle kernel paging request at
>> 68746190
>> kernel: [2229840.807548] IP: [<c02064d4>] kobject_put+0xa/0x3c
>> kernel: [2229840.807578] *pdpt = 000000003638d001 *pde = 
>> 0000000000000000
>> kernel: [2229840.807607] Oops: 0000 [#1] SMP
>> kernel: [2229840.807627] last sysfs file:
>> /sys/devices/pci0000:00/0000:00:1e.0/0000:04:0c.0/uevent
>> kernel: [2229840.807655] Modules linked in: ipmi_si(+) ipmi_msghandler
>> rtc_cmos rtc_core rtc_lib nf_conntrack_netlink nf_conntrack nfnetlink
>> sch_ingress act_nat cls_u32 sch_htb tun xt_mark xt_tcpudp iptable_mangle
>> e1000e iptable_filter
>> kernel: [2229840.808183]
>> kernel: [2229840.808183] Pid: 2184, comm: modprobe Not tainted 2.6.35.4-
>> build-0053 #2 SE7520JR22S/
>> kernel: [2229840.808183] EIP: 0060:[<c02064d4>] EFLAGS: 00010202 CPU: 1
>> kernel: [2229840.808183] EIP is at kobject_put+0xa/0x3c
>> kernel: [2229840.808183] EAX: 68746170 EBX: 68746170 ECX: f375f27c EDX:
>> f8bd10c1
>> kernel: [2229840.808183] ESI: 00000000 EDI: f8bd23ec EBP: f31a5f30 ESP:
>> f31a5f2c
>> kernel: [2229840.808183]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
>> kernel: [2229840.808183] Process modprobe (pid: 2184, ti=f31a5000
>> task=f69c6000 task.ti=f31a5000)
>> kernel: [2229840.808183] Stack:
>> kernel: [2229840.808183]  f8bd24fc f31a5f4c c0265851 c0265957 f31a5f54
>> f8bd24fc 00000000 00000001
>> kernel: [2229840.808183]<0>  f31a5f54 c0249c05 f31a5f84 f8bd0363 
>> 00000000
>> 00000000 00000000 00000000
>> kernel: [2229840.808183]<0>  00000000 00000000 00000000 f8bd24fc 
>> 00000000
>> f8bd00d4 f31a5f9c c0101139
>> kernel: [2229840.808183] Call Trace:
>> kernel: [2229840.808183]  [<c0265851>] ? driver_register+0x6d/0xeb
>> kernel: [2229840.808183]  [<c0265957>] ? driver_create_file+0x16/0x18
>> kernel: [2229840.808183]  [<c0249c05>] ? pnp_register_driver+0x17/0x19
>> kernel: [2229840.808183]  [<f8bd0363>] ? init_ipmi_si+0x28f/0x7cd 
>> [ipmi_si]
>> kernel: [2229840.808183]  [<f8bd00d4>] ? init_ipmi_si+0x0/0x7cd 
>> [ipmi_si]
>> kernel: [2229840.808183]  [<c0101139>] ? do_one_initcall+0x4c/0x131
>> kernel: [2229840.808183]  [<c01514ee>] ? sys_init_module+0x77/0x197
>> kernel: [2229840.808183]  [<c0304f15>] ? syscall_call+0x7/0xb
>> kernel: [2229840.808183]  [<c0300000>] ? mce_cpu_callback+0x137/0x14b
>> kernel: [2229840.808183] Code: e5 b8 24 00 00 00 53 e8 39 ff ff ff 85 
>> c0 89 c3
>> 74 0a ba 88 d2 41 c0 e8 6d ff ff ff 89 d8 5b 5d c3 55 85 c0 89 e5 53 
>> 89 c3 74
>> 2d<f6>  40 20 01 75 1a 50 ff 30 68 7b 5b 3c c0 68 53 02 00 00 68 ca
>> kernel: [2229840.808183] EIP: [<c02064d4>] kobject_put+0xa/0x3c SS:ESP
>> 0068:f31a5f2c
>> kernel: [2229840.808183] CR2: 0000000068746190
>> kernel: [2229840.816407] ---[ end trace c276a726e0f282ae ]---
>> kernel: [2229840.816615] Kernel panic - not syncing: Fatal exception
>> kernel: [2229840.816816] Pid: 2184, comm: modprobe Tainted: G      D
>> 2.6.35.4-build-0053 #2
>> kernel: [2229840.817458] Call Trace:
>> kernel: [2229840.817720]  [<c030347e>] ? printk+0xf/0x11
>> kernel: [2229840.817962]  [<c03033fe>] panic+0x4b/0xbc
>> kernel: [2229840.818268]  [<c01051dc>] oops_end+0x8b/0x9a
>> kernel: [2229840.818552]  [<c011b3f2>] no_context+0x13f/0x149
>> kernel: [2229840.818785]  [<c011b52c>] 
>> __bad_area_nosemaphore+0x130/0x138
>> kernel: [2229840.819062]  [<c0122228>] ? __wake_up_common+0x35/0x5b
>> kernel: [2229840.819459]  [<c0122eae>] ? __wake_up+0x31/0x3b
>> kernel: [2229840.819732]  [<c0205ba1>] ? ida_get_new_above+0xe3/0x187
>> kernel: [2229840.820001]  [<c011b574>] bad_area+0x30/0x39
>> kernel: [2229840.820392]  [<c011b85c>] do_page_fault+0x162/0x256
>> kernel: [2229840.820622]  [<c011b6fa>] ? do_page_fault+0x0/0x256
>> kernel: [2229840.820857]  [<c030552e>] error_code+0x66/0x6c
>> kernel: [2229840.821162]  [<c02000d8>] ? blk_send_start_stop+0x5a/0x70
>> kernel: [2229840.821451]  [<c011b6fa>] ? do_page_fault+0x0/0x256
>> kernel: [2229840.821687]  [<c02064d4>] ? kobject_put+0xa/0x3c
>> kernel: [2229840.821925]  [<c0265851>] driver_register+0x6d/0xeb
>> kernel: [2229840.822177]  [<c0265957>] ? driver_create_file+0x16/0x18
>> kernel: [2229840.822455]  [<c0249c05>] pnp_register_driver+0x17/0x19
>> kernel: [2229840.822769]  [<f8bd0363>] init_ipmi_si+0x28f/0x7cd 
>> [ipmi_si]
>> kernel: [2229840.823009]  [<f8bd00d4>] ? init_ipmi_si+0x0/0x7cd 
>> [ipmi_si]
>> kernel: [2229840.823281]  [<c0101139>] do_one_initcall+0x4c/0x131
>> kernel: [2229840.828657]  [<c01514ee>] sys_init_module+0x77/0x197
>> kernel: [2229840.828918]  [<c0304f15>] syscall_call+0x7/0xb
>> kernel: [2229840.829193]  [<c0300000>] ? mce_cpu_callback+0x137/0x14b
>> Oct  1 21:16:53 10.22.24.2 kernel: [   84.908221] rtc_cmos 00:02: RTC 
>> can wake
>> from S4
>

