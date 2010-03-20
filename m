Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751592Ab0CTByZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 21:54:25 -0400
Received: from hera.kernel.org ([140.211.167.34]:46604 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750802Ab0CTByX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 21:54:23 -0400
Message-ID: <4BA42A95.4000301@kernel.org>
Date: Fri, 19 Mar 2010 18:53:25 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100228 SUSE/3.0.3-1.1.1 Thunderbird/3.0.3
MIME-Version: 1.0
To: "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       David Woodhouse <David.Woodhouse@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: intel iommu ixgbevf ....
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

when intel_iommu=off or iommu=pt is used, will work well.

eth304 ip=192.171.178.102 mac=56:95:16:88:4C:C1 pci=0000:0e:18.3 drv=ixgbevf
eth305 ip=192.171.179.102 mac=D6:41:8C:4A:87:B3 pci=0000:0e:18.5 drv=ixgbevf
[ 9534.886519] BUG: unable to handle kernel NULL pointer dereference at
0000000000000008
[ 9534.889775] IP: [<ffffffff813ddf94>] list_del+0xc/0x8b
[ 9534.889775] PGD e0660dd067 PUD e063a14067 PMD 0
[ 9534.889775] Oops: 0000 [#1] SMP
[ 9534.889775] last sysfs file:
/sys/devices/system/cpu/cpu0/cpufreq/related_cpus
[ 9534.889775] CPU 113
[ 9534.889775] Modules linked in:
[ 9534.889775]
[ 9534.889775] Pid: 28555, comm: ifconfig Not tainted
2.6.34-rc1-tip-yh-05104-g3af3b12-dirty #14   
[ 9534.889775] RIP: 0010:[<ffffffff813ddf94>]  [<ffffffff813ddf94>]
list_del+0xc/0x8b
[ 9534.889775] RSP: 0018:ffff88c070373af8  EFLAGS: 00010092
[ 9534.889775] RAX: 0000000000000296 RBX: 0000000000000000 RCX:
0000000000000000
[ 9534.889775] RDX: ffff88c0f140f940 RSI: ffffffff8237dc68 RDI:
0000000000000000
[ 9534.889775] RBP: ffff88c070373b08 R08: 0000000000000002 R09:
000000000044c295
[ 9534.889775] R10: 0000000000000000 R11: 0000000000000002 R12:
ffff88e063a81c00
[ 9534.889775] R13: ffff88e063a81c10 R14: 0000000000000000 R15:
0000000000000000
[ 9534.889775] FS:  00007f1bce8446f0(0000) GS:ffff88c0f1400000(0000)
knlGS:0000000000000000
[ 9534.889775] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 9534.889775] CR2: 0000000000000008 CR3: 000000e0639cb000 CR4:
00000000000006e0
[ 9534.889775] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
[ 9534.889775] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
0000000000000400
[ 9534.889775] Process ifconfig (pid: 28555, threadinfo
ffff88c070372000, task ffff88c07254a350)
[ 9534.889775] Stack:
[ 9534.889775]  ffff88e063a81c00 0000000000000000 ffff88c070373b48
ffffffff81406a3d
[ 9534.889775] <0> 0000000000000006 0000000000000296 ffff88207fc13290
ffff88e063a81c00
[ 9534.889775] <0> ffff882070abd000 0000000000000000 ffff88c070373b78
ffffffff81408a1d
[ 9534.889775] Call Trace:
[ 9534.889775]  [<ffffffff81406a3d>] domain_remove_dev_info+0x34/0xcf
[ 9534.889775]  [<ffffffff81408a1d>] domain_exit+0x23/0xc4
[ 9534.889775]  [<ffffffff81409c1c>] T.953+0x173/0x342
[ 9534.889775]  [<ffffffff81409fd0>] __intel_map_single+0x63/0x1b3
[ 9534.889775]  [<ffffffff8140a22a>] intel_alloc_coherent+0xc7/0xee
[ 9534.889775]  [<ffffffff816c3e7d>] ? ixgbevf_setup_tx_resources+0x2f/0x12c
[ 9534.889775]  [<ffffffff816c3f36>] ixgbevf_setup_tx_resources+0xe8/0x12c
[ 9534.889775]  [<ffffffff816c42d2>] ixgbevf_open+0x7a/0x160
[ 9534.889775]  [<ffffffff81adf21e>] __dev_open+0x8e/0xbc
[ 9534.889775]  [<ffffffff81adb716>] __dev_change_flags+0xad/0x130
[ 9534.889775]  [<ffffffff81adf15a>] dev_change_flags+0x21/0x57
[ 9534.889775]  [<ffffffff81b211e5>] devinet_ioctl+0x29d/0x541
[ 9534.889775]  [<ffffffff810a4b92>] ? trace_hardirqs_off_caller+0x1f/0xa9
[ 9534.889775]  [<ffffffff81b22801>] inet_ioctl+0x8f/0xa7
[ 9534.889775]  [<ffffffff81acc258>] sock_do_ioctl+0x29/0x48
[ 9534.889775]  [<ffffffff81acca64>] sock_ioctl+0x1fe/0x20d
[ 9534.889775]  [<ffffffff8113b86a>] vfs_ioctl+0x32/0xa6
[ 9534.889775]  [<ffffffff8113bd04>] do_vfs_ioctl+0x2b0/0x2cb
[ 9534.889775]  [<ffffffff81033c4c>] ? sysret_check+0x27/0x62
[ 9534.889775]  [<ffffffff8113bd66>] sys_ioctl+0x47/0x6a
[ 9534.889775]  [<ffffffff81033c1b>] system_call_fastpath+0x16/0x1b
[ 9534.889775] Code: cd 7f cc ff 41 54 9d 48 83 c4 20 5b 41 5c 41 5d 41
5e c9 c3 55 48 89 e5 e8 11 ff ff ff c9 c3 55 48 89 e5 53 48 89 fb 48 83
ec 08 <48> 8b 47 08 4c 8b 00 49 39 f8 74 1d 48 89 f9 48 c7 c2 7f e9 18
[ 9534.889775] RIP  [<ffffffff813ddf94>] list_del+0xc/0x8b
[ 9534.889775]  RSP <ffff88c070373af8>
[ 9534.889775] CR2: 0000000000000008
[ 9534.889775] ---[ end trace 072bd8cdb08a760c ]---
xifconfig8_2x_vf.sh: line 10: 28555 Killed                  ifconfig
$DEV $IP


/* domain is initialized */
static struct dmar_domain *get_domain_for_dev(struct pci_dev *pdev, int gaw)
{
        struct dmar_domain *domain, *found = NULL;
        struct intel_iommu *iommu;
        struct dmar_drhd_unit *drhd;
        struct device_domain_info *info, *tmp;
        struct pci_dev *dev_tmp;
        unsigned long flags;
        int bus = 0, devfn = 0;
        int segment;
        int ret;

        domain = find_domain(pdev);
        if (domain)
                return domain;

        segment = pci_domain_nr(pdev->bus);

        dev_tmp = pci_find_upstream_pcie_bridge(pdev);
        if (dev_tmp) {
                if (pci_is_pcie(dev_tmp)) {
                        bus = dev_tmp->subordinate->number;
                        devfn = 0;
                } else {
                        bus = dev_tmp->bus->number;
                        devfn = dev_tmp->devfn;
                }
                spin_lock_irqsave(&device_domain_lock, flags);
                list_for_each_entry(info, &device_domain_list, global) {
                        if (info->segment == segment &&
                            info->bus == bus && info->devfn == devfn) {
                                found = info->domain;
                                break;
                        }
                }
                spin_unlock_irqrestore(&device_domain_lock, flags);
                /* pcie-pci bridge already has a domain, uses it */
                if (found) {
                        domain = found;
                        goto found_domain;
                }
        }

        domain = alloc_domain();
        if (!domain)
                goto error;

        /* Allocate new domain for the device */
        drhd = dmar_find_matched_drhd_unit(pdev);
        if (!drhd) {
                printk(KERN_ERR "IOMMU: can't find DMAR for device %s\n",
                        pci_name(pdev));
                return NULL;
        }
        iommu = drhd->iommu;

        ret = iommu_attach_domain(domain, iommu);
        if (ret) {
                domain_exit(domain);
                goto error;
        }

        if (domain_init(domain, gaw)) {
                domain_exit(domain);
                goto error;
        }

        /* register pcie-to-pci device */
        if (dev_tmp) {
                info = alloc_devinfo_mem(); =============> can not get
devinfo?
                if (!info) {
                        domain_exit(domain); =======>
                        goto error;
                }

looks werid:
1. it should not go that path, it is sharing one domain with others
2. alloc_devinfo_mem() fail?

YH
