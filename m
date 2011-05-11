Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755909Ab1EKVAL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 17:00:11 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:16866 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755598Ab1EKVAF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 17:00:05 -0400
Message-ID: <4DCAF894.7030707@kernel.org>
Date: Wed, 11 May 2011 13:59:00 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110414 SUSE/3.1.10 Thunderbird/3.1.10
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Len Brown <lenb@kernel.org>
Subject: Re: [GIT PULL rcu/next] rcu commits for 2.6.40
References: <20110508151848.GA21906@linux.vnet.ibm.com> <20110509073636.GA18247@elte.hu> <BANLkTin82W0yZ5Nvv3Dp62X1eou_GxZ6EA@mail.gmail.com> <20110510085623.GG2258@linux.vnet.ibm.com> <4DC97E49.7040401@kernel.org> <20110510193216.GN2258@linux.vnet.ibm.com> <4DC9A5A4.1050308@kernel.org> <20110511045443.GS2258@linux.vnet.ibm.com> <BANLkTi=r707A9yy5-7+dw3Hozt=G1HBQ-Q@mail.gmail.com> <20110511201852.GC2258@linux.vnet.ibm.com>
In-Reply-To: <20110511201852.GC2258@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4DCAF89D.00A5,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/11/2011 01:18 PM, Paul E. McKenney wrote:
> On Wed, May 11, 2011 at 09:56:35AM -0700, Yinghai Lu wrote:
>> On Tue, May 10, 2011 at 9:54 PM, Paul E. McKenney
>> <paulmck@linux.vnet.ibm.com> wrote:
>>> On Tue, May 10, 2011 at 01:52:52PM -0700, Yinghai Lu wrote:
>>>> On 05/10/2011 12:32 PM, Paul E. McKenney wrote:
>>>>> On Tue, May 10, 2011 at 11:04:57AM -0700, Yinghai Lu wrote:
>>>>>> On 05/10/2011 01:56 AM, Paul E. McKenney wrote:
>>>>>>> On Mon, May 09, 2011 at 02:09:21PM -0700, Yinghai Lu wrote:
>>>>>>>> On Mon, May 9, 2011 at 12:36 AM, Ingo Molnar <mingo@elte.hu> wrote:
>>>>>>>>>
>>>>>>>>> * Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:
>>>>>>>>>
>>>>>>>>>> Hello, Ingo,
>>>>>>>>>>
>>>>>>>>>> This pull request covers RCU chnages for 2.6.40.  The major new features
>>>>>>>>>> are RCU priority boosting and the addition of kfree_rcu(), the latter
>>>>>>>>>> courtesy of Lai Jiangshan.  These two features cover well over half
>>>>>>>>>> of the commits.  There are a number of smaller features and bug fixes.
>>>>>>>>>> All have been sent to LKML in the following batches:
>>>>>>>>>>
>>>>>>>>>> 0.    https://lkml.org/lkml/2011/2/22/660: RCU priority boosting preview
>>>>>>>>>> 1.    https://lkml.org/lkml/2011/5/1/19: RCU priority boosting, kfree_rcu()
>>>>>>>>>> 2.    https://lkml.org/lkml/2011/5/2/40: More uses of kfree_rcu()
>>>>>>>>>> 3.    https://lkml.org/lkml/2011/5/8/60: miscellaneous
>>>>>>>>>>
>>>>>>>>>> The kfree_rcu() uses in the pull request have Acked-by:s from the
>>>>>>>>>> maintainers.  I have some additional kfree_rcu() requests that lack
>>>>>>>>>> Acked-by:s, and I will deal with these later.
>>>>>>>>>>
>>>>>>>>>> These channges are available in the -rcu git repository at:
>>>>>>>>>>
>>>>>>>>>>   git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-2.6-rcu.git rcu/next
>>>>>>>>>
>>>>>>>>> Pulled, thanks a lot Paul!
>>>>>>>>>
>>>>>>>>
>>>>>>>> it seems with this one in tip, my 8 sockets test setup will report cpu stall.
>>>>>>>>
>>>>>>>> after hard code to enable rcu_cpu_stall_suppress
>>>>>>>>
>>>>>>>> Index: linux-2.6/kernel/rcutree.c
>>>>>>>> ===================================================================
>>>>>>>> --- linux-2.6.orig/kernel/rcutree.c
>>>>>>>> +++ linux-2.6/kernel/rcutree.c
>>>>>>>> @@ -174,7 +174,7 @@ module_param(blimit, int, 0);
>>>>>>>>  module_param(qhimark, int, 0);
>>>>>>>>  module_param(qlowmark, int, 0);
>>>>>>>>
>>>>>>>> -int rcu_cpu_stall_suppress __read_mostly;
>>>>>>>> +int rcu_cpu_stall_suppress __read_mostly = 1;
>>>>>>>>  module_param(rcu_cpu_stall_suppress, int, 0644);
>>>>>>>>
>>>>>>>>  static void force_quiescent_state(struct rcu_state *rsp, int relaxed);
>>>>>>>>
>>>>>>>> will get system hang after pnp ACPI init.
>>>>>>>
>>>>>>> Could you please send the stack traces from the RCU CPU stall?  Also,
>>>>>>> you do have ce31332d3c77532d6ea97ddcb475a2b02dd358b4 applied, correct?
>>>>>>>
>>>>>>>                                                   Thanx, Paul
>>>>>>
>>>>>> Do not have time to bisect it at this point.
>>>>>
>>>>> Could you please send the stack traces from the RCU CPU stall?
>>>
>>> Thank you!  OK, so CPU 0 has not been responding, despite resched IPIs.
>>> Everyone is idle, except for CPU 124, which detected the stall, and
>>> possibly CPU 0, which has csum_partial_copy_generic() on the stack, though
>>> that looks like a backtrace error to me.  The fact that it hangs if you
>>> disable RCU CPU stall detection leads me to believe that something real
>>> is being detected.
>>
>> the problem is that now I can not disable RCU CPU stall detection any more.
> 
> There is a rcu_cpu_stall_suppress module parameter, and you should be
> able to pass in rcu_cpu_stall_suppress=1 as a boot parameter.  However,
> I did produce a patch that reverts the change, please see below.
> I would be surprised if this did anything different than your change
> that initializes rcu_cpu_stall_suppress to 1.  If this patch somehow
> does make a difference, please let me know.

the same.

looks like other commit in the pull cause the delay...of acpi related stuff.

[   22.255535] calling  pnpacpi_init+0x0/0x8c @ 1
[   22.260001] pnp: PnP ACPI init
[   22.263125] ACPI: bus type pnp registered
[  603.121084] pnp 00:00: [bus 00-7f]
...
[  603.130564] pnp 00:0c: Plug and Play ACPI device, IDs PNP0103 (active)
[ 1202.948788] pnp 00:0d: [bus 80-ff]
[ 1202.952187] pnp 00:0d: [io  0x0000 window]
[ 1202.956316] pnp 00:0d: [io  0xc000-0xffff window]
[ 1202.961056] pnp 00:0d: [mem 0x00000000 window]
[ 1202.965533] pnp 00:0d: [mem 0xe0000000-0xfbffffff window]
[ 1202.970965] pnp 00:0d: [mem 0x00000000 window]
[ 1202.975934] pnp 00:0d: Plug and Play ACPI device, IDs PNP0a08 PNP0a03 (active)
[ 1202.983823] system 00:0e: Plug and Play ACPI device, IDs PNP0c01 (active)
[ 1202.991093] pnp: PnP ACPI: found 15 devices
[ 1202.995310] ACPI: ACPI bus type pnp unregistered
[ 1202.999963] initcall pnpacpi_init+0x0/0x8c returned 0 after 1153066591 usecs
...
[ 1206.094838] calling  shpcd_init+0x0/0xe8 @ 1
[ 1206.095194] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[ 1206.095199] initcall shpcd_init+0x0/0xe8 returned 0 after 347 usecs
[ 1206.095202] calling  acpiphp_init+0x0/0x5f @ 1
[ 1206.095206] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[ 1302.573367] initcall acpiphp_init+0x0/0x5f returned -19 after 94216997 usecs
[ 1302.580449] calling  ibm_acpiphp_init+0x0/0x175 @ 1
[ 1398.573429] acpiphp_ibm: ibm_acpiphp_init: acpi_walk_namespace failed
[ 1398.579896] initcall ibm_acpiphp_init+0x0/0x175 returned -19 after 93744718 usecs
...
[ 1398.739321] calling  acpi_pci_slot_init+0x0/0x20 @ 1
[ 1494.572598] initcall acpi_pci_slot_init+0x0/0x20 returned 0 after 93582352 usecs
[ 1494.580019] calling  acpi_processor_init+0x0/0xcd @ 1
[ 1494.585119] ACPI: acpi_idle registered with cpuidle
[ 1494.622886] initcall acpi_processor_init+0x0/0xcd returned 0 after 36896 usecs
[ 1494.630135] calling  acpi_container_init+0x0/0x4a @ 1
[ 1734.573253] initcall acpi_container_init+0x0/0x4a returned 0 after 234314615 usecs
[ 1734.580854] calling  acpi_thermal_init+0x0/0x42 @ 1
[ 1734.586032] initcall acpi_thermal_init+0x0/0x42 returned 0 after 275 usecs
[ 1734.592926] calling  acpi_memory_device_init+0x0/0x87 @ 1
[ 1974.573125] initcall acpi_memory_device_init+0x0/0x87 returned 0 after 234350484 usecs
[ 1974.581069] calling  acpi_battery_init+0x0/0x16 @ 1
[ 1974.586009] initcall acpi_battery_init+0x0/0x16 returned 0 after 34 usecs
[ 1974.586112] calling  1_acpi_battery_init_async+0x0/0x20 @ 5
[ 1974.586636] initcall 1_acpi_battery_init_async+0x0/0x20 returned 0 after 505 usecs
[ 1974.605962] calling  acpi_power_meter_init+0x0/0x32 @ 1
[ 1974.611505] initcall acpi_power_meter_init+0x0/0x32 returned 0 after 286 usecs
[ 1974.618748] calling  acpi_hed_init+0x0/0x26 @ 1
[ 1974.623565] initcall acpi_hed_init+0x0/0x26 returned 0 after 255 usecs
[ 1974.630115] calling  acpi_pad_init+0x0/0x26 @ 1
[ 1974.634932] initcall acpi_pad_init+0x0/0x26 returned 0 after 254 usecs
[ 1974.641475] calling  erst_init+0x0/0x2bb @ 1
[ 1974.645956] ERST: Can not request iomem region <0x              3f-0x              3f> for ERST.
[ 2070.572123] initcall erst_init+0x0/0x2bb returned -5 after 93678128 usecs
...
[ 2070.792625] calling  serial8250_init+0x0/0x18e @ 1
[ 2070.797433] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[ 2070.824642] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[ 2534.572086] initcall serial8250_init+0x0/0x18e returned 0 after 452905158 usecs
[ 2534.579451] calling  serial8250_pnp_init+0x0/0x12 @ 1
[ 2662.572104] initcall serial8250_pnp_init+0x0/0x12 returned 0 after 124987929 usecs
[ 2662.579749] calling  serial8250_pci_init+0x0/0x1b @ 1
[ 2662.585088] initcall serial8250_pci_init+0x0/0x1b returned 0 after 261 usecs

