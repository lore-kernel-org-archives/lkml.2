Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755241Ab2H1Aia (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 20:38:30 -0400
Received: from mga14.intel.com ([143.182.124.37]:18303 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755104Ab2H1Ai1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 20:38:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,322,1344236400"; 
   d="scan'208";a="185563664"
Message-ID: <1346114304.6279.341.camel@yhuang-dev>
Subject: Re: [RESEND BUGFIX PATCH 1/3] PCI/AER: fix pci_ops return NULL when
 hotplug a pci bus which was doing aer error inject
From: Huang Ying <ying.huang@intel.com>
To: Jiang Liu <liuj97@gmail.com>
Cc: Yijing Wang <wangyijing@huawei.com>, Bjorn Helgaas <bhelgaas@google.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        PCI <linux-pci@vger.kernel.org>, Hanjun Guo <guohanjun@huawei.com>,
        linux-kernel@vger.kernel.org
Date: Tue, 28 Aug 2012 08:38:24 +0800
In-Reply-To: <503B8CD4.8070802@gmail.com>
References: <1344685946-8172-1-git-send-email-wangyijing@huawei.com>
	  <5038A210.4030005@huawei.com> <1346030599.6279.315.camel@yhuang-dev>
	 <503B8CD4.8070802@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-08-27 at 23:05 +0800, Jiang Liu wrote:
> Is it ok to ignore such a case? After all, aer_inject is just a test tool:)
> It's not worth to change the core logic for such a corner case.
> --Gerry

Why ignore?  At least you can prevent aer_inject from unload if
something special happened.

Best Regards,
Huang Ying

> On 08/27/2012 09:23 AM, Huang Ying wrote:
> > On Sat, 2012-08-25 at 17:59 +0800, Yijing Wang wrote:
> >> When we inject aer errors to the target pci device by aer_inject module, the pci_ops of pci
> >> bus which the target device is on will be assign to pci_ops_aer.So if the target pci device
> >> is a bridge, once we hotplug the pci bus(child bus) which the target device bridges to, child
> >> bus's pci_ops will be assigned to pci_ops_aer too.Now every access to the child bus's device
> >> will result to system panic, because it return NULL pci_ops in pci_read_aer.
> >> This patch fix this.
> >>
> >> CallTrace:
> >> bash[5908]: NaT consumption 17179869216 [1]
> >> Modules linked in: aer_inject cpufreq_conservative cpufreq_userspace cpufreq_pow
> >> ersave acpi_cpufreq binfmt_misc fuse nls_iso8859_1 loop ipmi_si(+) ipmi_devintf
> >> ipmi_msghandler dm_mod ppdev iTCO_wdt iTCO_vendor_support sg igb parport_pc i2c_
> >> i801 mptctl i2c_core serio_raw hid_generic lpc_ich mfd_core parport button conta
> >> iner usbhid hid uhci_hcd ehci_hcd usbcore usb_common sd_mod crc_t10dif ext3 mbca
> >> che jbd fan processor ide_pci_generic ide_core ata_piix libata mptsas mptscsih m
> >> ptbase scsi_transport_sas scsi_mod thermal thermal_sys hwmon
> >>
> >> Pid: 5908, CPU 9, comm:                 bash
> >> psr : 00001010085a2010 ifs : 800000000000048e ip  : [<a000000220b815b0>]    Not
> >> tainted (3.5.0-rc6yijing-repo)
> >> ip is at pci_read_aer+0x330/0x460 [aer_inject]
> >> unat: 0000000000000000 pfs : 000000000000048e rsc : 0000000000000003
> >> rnat: 0000000000000000 bsps: 0000000000000000 pr  : 65519aa6a6969aa5
> >> ldrs: 0000000000000000 ccv : ffffffff00000001 fpsr: 0009804c8a70033f
> >> csd : 0000000000000000 ssd : 0000000000000000
> >> b0  : a000000220b815b0 b6  : a000000220b81280 b7  : a0000001006d56a0
> >> f6  : 1003e0000000000000005 f7  : 1003e0000000000000028
> >> f8  : 1003e00000000000000c8 f9  : 1003e0000000000000005
> >> f10 : 1003e627ec1e2f4c0d8a7 f11 : 1003e0000000000000011
> >> r1  : a0000001014e63c0 r2  : 0000000000000738 r3  : 000000000000fffe
> >> r8  : 0000000000000736 r9  : 0000000000000042 r10 : e000001f08f4c898
> >> r11 : 0000000000000000 r12 : e000000f3dfcfdc0 r13 : e000000f3dfc0000
> >> r14 : 0000000000000738 r15 : 0000000000004000 r16 : a000000220b827c8
> >> r17 : a000000220b827b8 r18 : ffffffffffffff00 r19 : e000000f073b0110
> >> r20 : 0000000000000042 r21 : e000000f073b0114 r22 : 0000000000000000
> >> r23 : e000000f073b0118 r24 : a0000001009e0e49 r25 : 0000000000000001
> >> r26 : 0000000000007041 r27 : e000000f3dfcfde0 r28 : 0000000000000000
> >> r29 : e000000f3dfcfc08 r30 : a000000220b827c8 r31 : e000001f074d6000
> >>
> >> Call Trace:
> >>  [<a000000100016500>] show_stack+0x80/0xa0
> >>                                 sp=e000000f3dfcf800 bsp=e000000f3dfc1758
> >>  [<a000000100016b60>] show_regs+0x640/0x920
> >>                                 sp=e000000f3dfcf9d0 bsp=e000000f3dfc1700
> >>  [<a000000100040770>] die+0x190/0x2c0
> >>                                 sp=e000000f3dfcf9e0 bsp=e000000f3dfc16c0
> >>  [<a0000001000408f0>] die_if_kernel+0x50/0x80
> >>                                 sp=e000000f3dfcf9e0 bsp=e000000f3dfc1690
> >>  [<a000000100903a90>] ia64_fault+0xf0/0x15e0
> >>                                 sp=e000000f3dfcf9e0 bsp=e000000f3dfc1640
> >>  [<a00000010000c0a0>] ia64_native_leave_kernel+0x0/0x270
> >>                                 sp=e000000f3dfcfbf0 bsp=e000000f3dfc1640
> >>  [<a000000220b815b0>] pci_read_aer+0x330/0x460 [aer_inject]
> >>                                 sp=e000000f3dfcfdc0 bsp=e000000f3dfc15c8
> >>  [<a0000001004ace00>] pci_bus_read_config_dword+0xe0/0x140
> >>                                 sp=e000000f3dfcfdc0 bsp=e000000f3dfc1580
> >>  [<a0000001004b0c10>] pci_bus_read_dev_vendor_id+0x50/0x200
> >>                                 sp=e000000f3dfcfdd0 bsp=e000000f3dfc1530
> >>  [<a0000001008d3d10>] pci_scan_single_device+0x90/0x200
> >>                                 sp=e000000f3dfcfdd0 bsp=e000000f3dfc14f8
> >>  [<a0000001004b24b0>] pci_scan_slot+0xb0/0x320
> >>                                 sp=e000000f3dfcfde0 bsp=e000000f3dfc14a8
> >>  [<a0000001008d9e90>] pci_scan_child_bus+0x90/0x2e0
> >>                                 sp=e000000f3dfcfde0 bsp=e000000f3dfc1468
> >>  [<a0000001008d9580>] pci_scan_bridge+0x540/0xdc0
> >>                                 sp=e000000f3dfcfde0 bsp=e000000f3dfc13d0
> >>  [<a0000001008da0b0>] pci_scan_child_bus+0x2b0/0x2e0
> >>                                 sp=e000000f3dfcfe00 bsp=e000000f3dfc1390
> >>  [<a0000001008d5bd0>] pci_rescan_bus+0x50/0x220
> >>                                 sp=e000000f3dfcfe00 bsp=e000000f3dfc1358
> >>  [<a0000001004c2ab0>] bus_rescan_store+0xf0/0x160
> >>                                 sp=e000000f3dfcfe10 bsp=e000000f3dfc1328
> >>  [<a0000001006110b0>] bus_attr_store+0x70/0xa0
> >>                                 sp=e000000f3dfcfe20 bsp=e000000f3dfc12f0
> >>  [<a000000100343b00>] sysfs_write_file+0x240/0x340
> >>                                 sp=e000000f3dfcfe20 bsp=e000000f3dfc1298
> >>  [<a00000010025e230>] vfs_write+0x1b0/0x3a0
> >>                                 sp=e000000f3dfcfe20 bsp=e000000f3dfc1250
> >>  [<a00000010025e5e0>] sys_write+0x80/0x100
> >>                                 sp=e000000f3dfcfe20 bsp=e000000f3dfc11d0
> >>  [<a00000010000bf20>] ia64_ret_from_syscall+0x0/0x20
> >>                                 sp=e000000f3dfcfe30 bsp=e000000f3dfc11d0
> >>  [<a000000000040720>] __kernel_syscall_via_break+0x0/0x20
> >>                                 sp=e000000f3dfd0000 bsp=e000000f3dfc11d0
> >> Disabling lock debugging due to kernel taint
> >>
> >> Signed-off-by: Yijing Wang <wangyijing@huawei.com>
> >> Signed-off-by: Jiang Liu <liuj97@gmail.com>
> >> ---
> >>  drivers/pci/pcie/aer/aer_inject.c |   21 +++++++++++++++++++++
> >>  1 files changed, 21 insertions(+), 0 deletions(-)
> >>
> >> diff --git a/drivers/pci/pcie/aer/aer_inject.c b/drivers/pci/pcie/aer/aer_inject.c
> >> index 5222986..fc28785 100644
> >> --- a/drivers/pci/pcie/aer/aer_inject.c
> >> +++ b/drivers/pci/pcie/aer/aer_inject.c
> >> @@ -109,6 +109,19 @@ static struct aer_error *__find_aer_error_by_dev(struct pci_dev *dev)
> >>  	return __find_aer_error((u16)domain, dev->bus->number, dev->devfn);
> >>  }
> >>
> >> +static bool pci_is_upstream_bus(struct pci_bus *bus, struct pci_bus *up_bus)
> >> +{
> >> +	struct pci_bus *pbus = bus->parent;
> >> +
> >> +	while (pbus) {
> >> +		if (pbus == up_bus)
> >> +			return true;
> >> +		pbus = pbus->parent;
> >> +	}
> >> +
> >> +	return false;
> >> +}
> >> +
> >>  /* inject_lock must be held before calling */
> >>  static struct pci_ops *__find_pci_bus_ops(struct pci_bus *bus)
> >>  {
> >> @@ -118,6 +131,13 @@ static struct pci_ops *__find_pci_bus_ops(struct pci_bus *bus)
> >>  		if (bus_ops->bus == bus)
> >>  			return bus_ops->ops;
> >>  	}
> >> +
> >> +	/* here can't find bus_ops, fall back to get bus_ops of upstream bus */
> >> +	list_for_each_entry(bus_ops, &pci_bus_ops_list, list) {
> >> +		if (pci_is_upstream_bus(bus, bus_ops->bus))
> >> +			return bus_ops->ops;
> >> +	}
> >> +
> >>  	return NULL;
> >>  }
> >>
> >> @@ -506,6 +526,7 @@ static struct miscdevice aer_inject_device = {
> >>  	.fops = &aer_inject_fops,
> >>  };
> >>
> >> +
> >>  static int __init aer_inject_init(void)
> >>  {
> >>  	return misc_register(&aer_inject_device);
> > 
> > After
> > 
> > # rmmod aer_inject
> > 
> > What will happen?
> > 
> > Best Regards,
> > Huang Ying
> > 
> > 
> 


