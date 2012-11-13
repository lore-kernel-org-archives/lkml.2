Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754371Ab2KMTFd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 14:05:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:3979 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751292Ab2KMTFa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 14:05:30 -0500
Message-ID: <50A299F3.6040901@redhat.com>
Date: Tue, 13 Nov 2012 14:05:23 -0500
From: Don Dutile <ddutile@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.5) Gecko/20120601 Thunderbird/10.0.5
MIME-Version: 1.0
To: Alex Williamson <alex.williamson@redhat.com>
CC: prometheanfire@gentoo.org, Doug Goldstein <cardoe@gentoo.org>,
        linux-kernel@vger.kernel.org, bhelgaas@google.com,
        linux-pci@vger.kernel.org, mthode@mthode.org,
        iommu@lists.linux-foundation.org
Subject: Re: [BUG 3.7-rc5] NULL pointer deref when using a pcie-pci bridged
 pci device and intel-iommu
References: <50A03281.6040206@gentoo.org>  <CAFWqQMQgmsFNqLS02Go3de-OZoxoPRbGuSmcj8ntic52C8AVpw@mail.gmail.com>  <50A1549C.7020404@redhat.com> <50A16481.5030309@gentoo.org> <1352821109.2233.3.camel@bling.home>
In-Reply-To: <1352821109.2233.3.camel@bling.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/13/2012 10:38 AM, Alex Williamson wrote:
> On Mon, 2012-11-12 at 15:05 -0600, Matthew Thode wrote:
>> On 11/12/2012 01:57 PM, Don Dutile wrote:
>>> On 11/12/2012 04:26 AM, Doug Goldstein wrote:
>>>> On Sun, Nov 11, 2012 at 5:19 PM, Matthew Thode
>>>> <prometheanfire@gentoo.org>   wrote:
>>>>> System boots with vt-d disabled in bios. Otherwise I get the errors in
>>>>> the attached log.  I can do whatever testing you need as this system is
>>>>> not in production yet.  gonna paste the important part here.  Let me
>>>>> know if you want anything else.
>>>>>
>>>>> Please CC me directly as I am not subscribed to the LKML.
>>>>>
>>>>>
>>>>> Trying to unpack rootfs image as initramfs...
>>>>> Freeing initrd memory: 5124k freed
>>>>> IOMMU 0 0xfbffe000: using Queued invalidation
>>>>> IOMMU: Setting RMRR:
>>>>> IOMMU: Setting identity map for device 0000:00:1d.0 [0xbf7ec000 -
>>>>> 0xbf7fffff]
>>>>> IOMMU: Setting identity map for device 0000:00:1d.1 [0xbf7ec000 -
>>>>> 0xbf7fffff]
>>>>> IOMMU: Setting identity map for device 0000:00:1d.2 [0xbf7ec000 -
>>>>> 0xbf7fffff]
>>>>> IOMMU: Setting identity map for device 0000:00:1d.7 [0xbf7ec000 -
>>>>> 0xbf7fffff]
>>>>> IOMMU: Setting identity map for device 0000:00:1a.0 [0xbf7ec000 -
>>>>> 0xbf7fffff]
>>>>> IOMMU: Setting identity map for device 0000:00:1a.1 [0xbf7ec000 -
>>>>> 0xbf7fffff]
>>>>> IOMMU: Setting identity map for device 0000:00:1a.2 [0xbf7ec000 -
>>>>> 0xbf7fffff]
>>>>> IOMMU: Setting identity map for device 0000:00:1a.7 [0xbf7ec000 -
>>>>> 0xbf7fffff]
>>>>> IOMMU: Setting identity map for device 0000:00:1d.0 [0xec000 - 0xeffff]
>>>>> IOMMU: Setting identity map for device 0000:00:1d.1 [0xec000 - 0xeffff]
>>>>> IOMMU: Setting identity map for device 0000:00:1d.2 [0xec000 - 0xeffff]
>>>>> IOMMU: Setting identity map for device 0000:00:1d.7 [0xec000 - 0xeffff]
>>>>> IOMMU: Setting identity map for device 0000:00:1a.0 [0xec000 - 0xeffff]
>>>>> IOMMU: Setting identity map for device 0000:00:1a.1 [0xec000 - 0xeffff]
>>>>> IOMMU: Setting identity map for device 0000:00:1a.2 [0xec000 - 0xeffff]
>>>>> IOMMU: Setting identity map for device 0000:00:1a.7 [0xec000 - 0xeffff]
>>>>> IOMMU: Prepare 0-16MiB unity mapping for LPC
>>>>> IOMMU: Setting identity map for device 0000:00:1f.0 [0x0 - 0xffffff]
>>>>> PCI-DMA: Intel(R) Virtualization Technology for Directed I/O
>>>>> BUG: unable to handle kernel NULL pointer dereference at
>>>>> 000000000000003c
>>>>> IP: [<ffffffff813bd796>] pci_get_dma_source+0xf/0x41
>>>>> PGD 0
>>>>> Oops: 0000 [#1] SMP
>>>>> Modules linked in:
>>>>> CPU 7
>>>>> Pid: 1, comm: swapper/0 Not tainted 3.7.0-rc5 #1 Penguin Computing
>>>>> Relion 1751/X8DTU
>>>>> RIP: 0010:[<ffffffff813bd796>]  [<ffffffff813bd796>]
>>>>> pci_get_dma_source+0xf/0x41
>>>>> RSP: 0000:ffff8806264d1d88  EFLAGS: 00010282
>>>>> RAX: ffffffff813bd3a8 RBX: ffff8806261d1000 RCX: 00000000e8221180
>>>>> RDX: ffffffff818624f0 RSI: ffff88062635b0c0 RDI: 0000000000000000
>>>>> RBP: ffff8806264d1d88 R08: ffff8806263d6000 R09: 00000000ffffffff
>>>>> R10: ffff8806264d1ca8 R11: 0000000000000005 R12: 0000000000000000
>>>>> R13: ffff8806261d1098 R14: 0000000000000000 R15: 0000000000000000
>>>>> FS:  0000000000000000(0000) GS:ffff88063f2e0000(0000)
>>>>> knlGS:0000000000000000
>>>>> CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
>>>>> CR2: 000000000000003c CR3: 0000000001c0b000 CR4: 00000000000007e0
>>>>> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>>>>> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
>>>>> Process swapper/0 (pid: 1, threadinfo ffff8806264d0000, task
>>>>> ffff8806264cf910)
>>>>> Stack:
>>>>>    ffff8806264d1dc8 ffffffff815d02c9 0000000000000000 ffff880600000000
>>>>>    ffff8806264d1dd8 ffffffff81c64b00 ffff8806261d1098 ffff8806264d1df8
>>>>>    ffff8806264d1de8 ffffffff815cd5a4 ffffffff81c64b00 ffffffff815cd56a
>>>>> Call Trace:
>>>>>    [<ffffffff815d02c9>] intel_iommu_add_device+0x95/0x167
>>>>>    [<ffffffff815cd5a4>] add_iommu_group+0x3a/0x41
>>>>>    [<ffffffff815cd56a>] ? bus_set_iommu+0x44/0x44
>>>>>    [<ffffffff8145eca1>] bus_for_each_dev+0x54/0x81
>>>>>    [<ffffffff815cd563>] bus_set_iommu+0x3d/0x44
>>>>>    [<ffffffff81cd3fa3>] intel_iommu_init+0xae5/0xb5e
>>>>>    [<ffffffff81ca0277>] ? free_initrd+0x9e/0x9e
>>>>>    [<ffffffff81ca4248>] ? memblock_find_dma_reserve+0x13f/0x13f
>>>>>    [<ffffffff81ca425e>] pci_iommu_init+0x16/0x41
>>>>>    [<ffffffff81cc4140>] ? pci_proc_init+0x6b/0x6b
>>>>>    [<ffffffff81000231>] do_one_initcall+0x7a/0x129
>>>>>    [<ffffffff816dac14>] kernel_init+0x139/0x2a2
>>>>>    [<ffffffff81c9d4c7>] ? loglevel+0x31/0x31
>>>>>    [<ffffffff816daadb>] ? rest_init+0x6f/0x6f
>>>>>    [<ffffffff816f66ac>] ret_from_fork+0x7c/0xb0
>>>>>    [<ffffffff816daadb>] ? rest_init+0x6f/0x6f
>>>>> Code: ff c1 75 04 ff d0 eb 12 48 83 c2 10 48 8b 42 08 48 85 c0 75 d3 b8
>>>>> e7 ff ff ff c9 c3 55 48 c7 c2 f0 24 86 81 48 89 e5 eb 24 8b 0a<66>   3b
>>>>> 4f 3c 74 05 66 ff c1 75 13 66 8b 4a 02 66 3b 4f 3e 74 05
>>>>> RIP  [<ffffffff813bd796>] pci_get_dma_source+0xf/0x41
>>>>>    RSP<ffff8806264d1d88>
>>>>> CR2: 000000000000003c
>>>>> ---[ end trace 5c5a2ceca067e0ec ]---
>>>>> Kernel panic - not syncing: Attempted to kill init! exitcode=0x00000009
>>>>>
>>>>> ------------[ cut here ]------------
>>>>> WARNING: at arch/x86/kernel/smp.c:123
>>>>> native_smp_send_reschedule+0x25/0x51()
>>>>> Hardware name: Relion 1751
>>>>> Modules linked in:
>>>>> Pid: 1, comm: swapper/0 Tainted: G      D      3.7.0-rc5 #1
>>>>> Call Trace:
>>>>>    <IRQ>    [<ffffffff810968ee>] warn_slowpath_common+0x80/0x98
>>>>>    [<ffffffff8109691b>] warn_slowpath_null+0x15/0x17
>>>>>    [<ffffffff8104e1a3>] native_smp_send_reschedule+0x25/0x51
>>>>>    [<ffffffff810bc81b>] trigger_load_balance+0x1e8/0x214
>>>>>    [<ffffffff810b731f>] scheduler_tick+0xd8/0xe1
>>>>>    [<ffffffff810a132f>] update_process_times+0x62/0x73
>>>>>    [<ffffffff810cb78b>] tick_sched_timer+0x7c/0x9b
>>>>>    [<ffffffff810b0f83>] __run_hrtimer.clone.24+0x4e/0xc1
>>>>>    [<ffffffff810b15b0>] hrtimer_interrupt+0xc7/0x1ac
>>>>>    [<ffffffff8104ef01>] smp_apic_timer_interrupt+0x81/0x94
>>>>>    [<ffffffff816f71ca>] apic_timer_interrupt+0x6a/0x70
>>>>>    <EOI>    [<ffffffff81097ffc>] ? console_unlock+0x2c2/0x2ed
>>>>>    [<ffffffff816f32fc>] ? panic+0x189/0x1c5
>>>>>    [<ffffffff816f3261>] ? panic+0xee/0x1c5
>>>>>    [<ffffffff8109ab6b>] do_exit+0x357/0x7b2
>>>>>    [<ffffffff810371b8>] oops_end+0xb2/0xba
>>>>>    [<ffffffff8105841d>] no_context+0x266/0x275
>>>>>    [<ffffffff810585e7>] __bad_area_nosemaphore+0x1bb/0x1db
>>>>>    [<ffffffff8118de46>] ? sysfs_addrm_finish+0x2f/0xa6
>>>>>    [<ffffffff81058615>] bad_area_nosemaphore+0xe/0x10
>>>>>    [<ffffffff81058bdb>] __do_page_fault+0x360/0x39f
>>>>>    [<ffffffff81394afa>] ? ida_get_new_above+0xf9/0x19e
>>>>>    [<ffffffff8112a077>] ? slab_node+0x59/0xa2
>>>>>    [<ffffffff816f3ffd>] ? mutex_unlock+0x9/0xb
>>>>>    [<ffffffff816da653>] ? klist_put+0x4c/0x70
>>>>>    [<ffffffff816da581>] ? klist_next+0x30/0xb6
>>>>>    [<ffffffff813b8cf9>] ? pci_do_find_bus+0x49/0x49
>>>>>    [<ffffffff81058c42>] do_page_fault+0x9/0xb
>>>>>    [<ffffffff816f6232>] page_fault+0x22/0x30
>>>>>    [<ffffffff813bd3a8>] ? nv_msi_ht_cap_quirk_all+0x10/0x10
>>>>>    [<ffffffff813bd796>] ? pci_get_dma_source+0xf/0x41
>>>>>    [<ffffffff815d02c9>] intel_iommu_add_device+0x95/0x167
>>>>>    [<ffffffff815cd5a4>] add_iommu_group+0x3a/0x41
>>>>>    [<ffffffff815cd56a>] ? bus_set_iommu+0x44/0x44
>>>>>    [<ffffffff8145eca1>] bus_for_each_dev+0x54/0x81
>>>>>    [<ffffffff815cd563>] bus_set_iommu+0x3d/0x44
>>>>>    [<ffffffff81cd3fa3>] intel_iommu_init+0xae5/0xb5e
>>>>>    [<ffffffff81ca0277>] ? free_initrd+0x9e/0x9e
>>>>>    [<ffffffff81ca4248>] ? memblock_find_dma_reserve+0x13f/0x13f
>>>>>    [<ffffffff81ca425e>] pci_iommu_init+0x16/0x41
>>>>>    [<ffffffff81cc4140>] ? pci_proc_init+0x6b/0x6b
>>>>>    [<ffffffff81000231>] do_one_initcall+0x7a/0x129
>>>>>    [<ffffffff816dac14>] kernel_init+0x139/0x2a2
>>>>>    [<ffffffff81c9d4c7>] ? loglevel+0x31/0x31
>>>>>    [<ffffffff816daadb>] ? rest_init+0x6f/0x6f
>>>>>    [<ffffffff816f66ac>] ret_from_fork+0x7c/0xb0
>>>>>    [<ffffffff816daadb>] ? rest_init+0x6f/0x6f
>>>>> ---[ end trace 5c5a2ceca067e0ed ]---
>>>>>
>>>>> --
>>>>> -- Matthew Thode (prometheanfire)
>>>>
>>>> The root cause of Matt's issue is that intel_iommu_add_device() calls
>>>> pci_get_domain_bus_and_slot() which is returning NULL. Which is not an
>>>> expected value. The reason NULL is being returned is that Matt has a
>>>> card with a TI XIO2000A/XIO2200A PCIe-PCI bridge (VID: 104C, DID:
>>>> 8231) on it. This device already has a quirk setup for disabling fast
>>>> back to back transfers on its secondary bus. If we cause it to use the
>>>> primary bus, that appears to resolve the issue. I'm not sure exactly
>>>> how to proceed from here due to relative lack of knowledge of PCI. Do
>>>> all PCIe-PCI bridges with secondary buses need their DMA parent to be
>>>> the primary bus or is that just something that should be done for the
>>>> TI XIO2000A due to the existing quirk?
>>>>
>>> DMA from a (legacy) PCI device does not have a SRC-ID in the transaction,
>>> so the source of the device generating the DMA is unknown.  When bridging
>>> to a PCIe device, the Parent PPB's dev-id is inserted on the PCIe as the
>>> source
>>> of a transaction -- in this case, DMA read/write transaction.
>>> This (sw) mapping should have happened by default, unless a recent
>>> change from VFIO
>>> broke this mapping.... or the TI bridge didn't report itself correctly
>>> as a PCIe-PCI bridge.
>>> Alex ?
>>>
>>>
>>>> The failing call with arguments was pci_get_domain_bus_and_slot(0, 5,
>>>> 0), while pci_get_domain_bus_and_slot(0, 4, 0) resulted in a system
>>>> that didn't panic and a device that worked.
>>>>
>>>> $ lspci -tvn
>>>> -+-[0000:ff]-+-00.0  8086:2c40
>>>>    |           +-00.1  8086:2c01
>>>>    |           +-02.0  8086:2c10
>>>>    |           +-02.1  8086:2c11
>>>>    |           +-02.4  8086:2c14
>>>>    |           +-02.5  8086:2c15
>>>>    |           +-03.0  8086:2c18
>>>>    |           +-03.1  8086:2c19
>>>>    |           +-03.2  8086:2c1a
>>>>    |           +-03.4  8086:2c1c
>>>>    |           +-04.0  8086:2c20
>>>>    |           +-04.1  8086:2c21
>>>>    |           +-04.2  8086:2c22
>>>>    |           +-04.3  8086:2c23
>>>>    |           +-05.0  8086:2c28
>>>>    |           +-05.1  8086:2c29
>>>>    |           +-05.2  8086:2c2a
>>>>    |           +-05.3  8086:2c2b
>>>>    |           +-06.0  8086:2c30
>>>>    |           +-06.1  8086:2c31
>>>>    |           +-06.2  8086:2c32
>>>>    |           \-06.3  8086:2c33
>>>>    \-[0000:00]-+-00.0  8086:3406
>>>>                +-01.0-[01]--+-00.0  8086:10c9
>>>>                |            \-00.1  8086:10c9
>>>>                +-03.0-[02]--
>>>>                +-05.0-[03]--
>>>>                +-07.0-[04-05]----00.0-[05]----08.0  d161:8006
>>>>                +-09.0-[06]----00.0  8086:10b9
>>>>                +-13.0  8086:342d
>>>>                +-14.0  8086:342e
>>>>                +-14.1  8086:3422
>>>>                +-14.2  8086:3423
>>>>                +-14.3  8086:3438
>>>>                +-16.0  8086:3430
>>>>                +-16.1  8086:3431
>>>>                +-16.2  8086:3432
>>>>                +-16.3  8086:3433
>>>>                +-16.4  8086:3429
>>>>                +-16.5  8086:342a
>>>>                +-16.6  8086:342b
>>>>                +-16.7  8086:342c
>>>>                +-1a.0  8086:3a37
>>>>                +-1a.1  8086:3a38
>>>>                +-1a.2  8086:3a39
>>>>                +-1a.7  8086:3a3c
>>>>                +-1d.0  8086:3a34
>>>>                +-1d.1  8086:3a35
>>>>                +-1d.2  8086:3a36
>>>>                +-1d.7  8086:3a3a
>>>>                +-1e.0-[07]----01.0  102b:0532
>>>>                +-1f.0  8086:3a16
>>>>                +-1f.2  8086:3a22
>>>>                \-1f.3  8086:3a30
>>>>
>>>> If someone can craft the correct patch that'd be great or answer the
>>>> above question and I'll gladly craft it.
>>>>
>>>> Thanks.
>>>
>> because I didn't see it.  Here was the patch that got it working for me
>> (ignore the printks), applies against 3.6.6 and 3.7-rc5.
>
> I think you're on the right track, but the solution is too specific.
> Here's a version that will fall back to the bridge device for the base
> of the group.  There may be opportunities to get rid of the pci_get_
> call altogether, but this seems pretty safe.  Can you please test it?
> Thanks,
>
> Alex
>
going through the logic, I don't see why the pci_get_domain_bus_and_slot()
is even called.  once there is a !NULL return for bridge, then
it should just do the pci_dev_get(bridge).
- Don

>
> commit ca15170f05b140ab8c611db5cb7cb9c218ddc930
> Author: Alex Williamson<alex.williamson@redhat.com>
> Date:   Tue Nov 13 08:34:08 2012 -0700
>
>      intel-iommu: Fix lookup in add device
>
>      We can't assume this device exists, fall back to the bridge itself.
>
>      Signed-off-by: Alex Williamson<alex.williamson@redhat.com>
>
> diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
> index d4a4cd4..0badfa4 100644
> --- a/drivers/iommu/intel-iommu.c
> +++ b/drivers/iommu/intel-iommu.c
> @@ -4108,7 +4108,7 @@ static void swap_pci_ref(struct pci_dev **from, struct pci_dev *to)
>   static int intel_iommu_add_device(struct device *dev)
>   {
>   	struct pci_dev *pdev = to_pci_dev(dev);
> -	struct pci_dev *bridge, *dma_pdev;
> +	struct pci_dev *bridge, *dma_pdev = NULL;
>   	struct iommu_group *group;
>   	int ret;
>
> @@ -4122,7 +4122,7 @@ static int intel_iommu_add_device(struct device *dev)
>   			dma_pdev = pci_get_domain_bus_and_slot(
>   						pci_domain_nr(pdev->bus),
>   						bridge->subordinate->number, 0);
> -		else
> +		if (!dma_pdev)
>   			dma_pdev = pci_dev_get(bridge);
>   	} else
>   		dma_pdev = pci_dev_get(pdev);
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

