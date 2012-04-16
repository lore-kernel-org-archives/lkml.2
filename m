Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755437Ab2DPUmJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 16:42:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42641 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755766Ab2DPUjA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 16:39:00 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Doug Thompson <norsk5@yahoo.com>,
        Greg K H <gregkh@linuxfoundation.org>
Subject: [EDAC ABI v13 17/25] edac: Create a per-Memory Controller bus
Date: Mon, 16 Apr 2012 17:38:41 -0300
Message-Id: <1334608729-30803-18-git-send-email-mchehab@redhat.com>
In-Reply-To: <1334608729-30803-1-git-send-email-mchehab@redhat.com>
References: <1334608729-30803-1-git-send-email-mchehab@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm getting this bug on machines with more than one memory controller:

[  819.094946] EDAC DEBUG: find_mci_by_dev: find_mci_by_dev()
[  819.094948] EDAC DEBUG: edac_create_sysfs_mci_device: edac_create_sysfs_mci_device() idx=1
[  819.094952] EDAC DEBUG: edac_create_sysfs_mci_device: edac_create_sysfs_mci_device(): creating device mc1
[  819.094967] EDAC DEBUG: edac_create_sysfs_mci_device: edac_create_sysfs_mci_device creating dimm0, located at channel 0 slot 0
[  819.094984] ------------[ cut here ]------------
[  819.100142] WARNING: at fs/sysfs/dir.c:481 sysfs_add_one+0xc1/0xf0()
[  819.107282] Hardware name: S2600CP
[  819.111078] sysfs: cannot create duplicate filename '/bus/edac/devices/dimm0'
[  819.119062] Modules linked in: sb_edac(+) edac_core ip6table_filter ip6_tables ebtable_nat ebtables ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack ipt_REJECT xt_CHECKSUM iptable_mangle iptable_filter ip_tables bridge stp llc sunrpc binfmt_misc dm_mirror dm_region_hash dm_log vhost_net macvtap macvlan tun kvm microcode pcspkr iTCO_wdt iTCO_vendor_support igb i2c_i801 i2c_core sg ioatdma dca sr_mod cdrom sd_mod crc_t10dif ahci libahci isci libsas libata scsi_transport_sas scsi_mod wmi dm_mod [last unloaded: scsi_wait_scan]
[  819.175748] Pid: 10902, comm: modprobe Not tainted 3.3.0-0.11.el7.v12.2.x86_64 #1
[  819.184113] Call Trace:
[  819.186868]  [<ffffffff8105adaf>] warn_slowpath_common+0x7f/0xc0
[  819.193573]  [<ffffffff8105aea6>] warn_slowpath_fmt+0x46/0x50
[  819.200000]  [<ffffffff811f53d1>] sysfs_add_one+0xc1/0xf0
[  819.206025]  [<ffffffff811f5cf5>] sysfs_do_create_link+0x135/0x220
[  819.212944]  [<ffffffff811f7023>] ? sysfs_create_group+0x13/0x20
[  819.219656]  [<ffffffff811f5df3>] sysfs_create_link+0x13/0x20
[  819.226109]  [<ffffffff813b04f6>] bus_add_device+0xe6/0x1b0
[  819.232350]  [<ffffffff813ae7cb>] device_add+0x2db/0x460
[  819.238300]  [<ffffffffa0325634>] edac_create_dimm_object+0x84/0xf0 [edac_core]
[  819.246460]  [<ffffffffa0325e18>] edac_create_sysfs_mci_device+0xe8/0x290 [edac_core]
[  819.255215]  [<ffffffffa0322e2a>] edac_mc_add_mc+0x5a/0x2c0 [edac_core]
[  819.262611]  [<ffffffffa03412df>] sbridge_register_mci+0x1bc/0x279 [sb_edac]
[  819.270493]  [<ffffffffa03417a3>] sbridge_probe+0xef/0x175 [sb_edac]
[  819.277630]  [<ffffffff813ba4e8>] ? pm_runtime_enable+0x58/0x90
[  819.284268]  [<ffffffff812f430c>] local_pci_probe+0x5c/0xd0
[  819.290508]  [<ffffffff812f5ba1>] __pci_device_probe+0xf1/0x100
[  819.297117]  [<ffffffff812f5bea>] pci_device_probe+0x3a/0x60
[  819.303457]  [<ffffffff813b1003>] really_probe+0x73/0x270
[  819.309496]  [<ffffffff813b138e>] driver_probe_device+0x4e/0xb0
[  819.316104]  [<ffffffff813b149b>] __driver_attach+0xab/0xb0
[  819.322337]  [<ffffffff813b13f0>] ? driver_probe_device+0xb0/0xb0
[  819.329151]  [<ffffffff813af5d6>] bus_for_each_dev+0x56/0x90
[  819.335489]  [<ffffffff813b0d7e>] driver_attach+0x1e/0x20
[  819.341534]  [<ffffffff813b0980>] bus_add_driver+0x1b0/0x2a0
[  819.347884]  [<ffffffffa0347000>] ? 0xffffffffa0346fff
[  819.353641]  [<ffffffff813b19f6>] driver_register+0x76/0x140
[  819.359980]  [<ffffffff8159f18b>] ? printk+0x51/0x53
[  819.365524]  [<ffffffffa0347000>] ? 0xffffffffa0346fff
[  819.371291]  [<ffffffff812f5896>] __pci_register_driver+0x56/0xd0
[  819.378096]  [<ffffffffa0347054>] sbridge_init+0x54/0x1000 [sb_edac]
[  819.385231]  [<ffffffff8100203f>] do_one_initcall+0x3f/0x170
[  819.391577]  [<ffffffff810bcd2e>] sys_init_module+0xbe/0x230
[  819.397926]  [<ffffffff815bb529>] system_call_fastpath+0x16/0x1b
[  819.404633] ---[ end trace 1654fdd39556689f ]---

This is happening because the bus is not being properly initialized.
Instead of putting the memory sub-devices inside the memory controller,
it is putting everything under the same directory:

$ tree /sys/bus/edac/
/sys/bus/edac/
├── devices
│   ├── all_channel_counts -> ../../../devices/system/edac/mc/mc0/all_channel_counts
│   ├── csrow0 -> ../../../devices/system/edac/mc/mc0/csrow0
│   ├── csrow1 -> ../../../devices/system/edac/mc/mc0/csrow1
│   ├── csrow2 -> ../../../devices/system/edac/mc/mc0/csrow2
│   ├── dimm0 -> ../../../devices/system/edac/mc/mc0/dimm0
│   ├── dimm1 -> ../../../devices/system/edac/mc/mc0/dimm1
│   ├── dimm3 -> ../../../devices/system/edac/mc/mc0/dimm3
│   ├── dimm6 -> ../../../devices/system/edac/mc/mc0/dimm6
│   ├── inject_addrmatch -> ../../../devices/system/edac/mc/mc0/inject_addrmatch
│   ├── mc -> ../../../devices/system/edac/mc
│   └── mc0 -> ../../../devices/system/edac/mc/mc0
├── drivers
├── drivers_autoprobe
├── drivers_probe
└── uevent

On a multi-memory controller system, the names "csrow%d" and "dimm%d"
should be under "mc%d", and not at the main hierarchy level.

So, we need to create a per-MC bus, in order to have its own namespace.

Reviewed-by: Aristeu Rozanski <arozansk@redhat.com>
Cc: Doug Thompson <norsk5@yahoo.com>
Cc: Greg K H <gregkh@linuxfoundation.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/edac/edac_mc_sysfs.c |   25 +++++++++++++++++++++----
 include/linux/edac.h         |    1 +
 2 files changed, 22 insertions(+), 4 deletions(-)

diff --git a/drivers/edac/edac_mc_sysfs.c b/drivers/edac/edac_mc_sysfs.c
index 5f7f0f1..38fccf2 100644
--- a/drivers/edac/edac_mc_sysfs.c
+++ b/drivers/edac/edac_mc_sysfs.c
@@ -357,7 +357,7 @@ static int edac_create_csrow_object(struct mem_ctl_info *mci,
 		return -ENODEV;
 
 	csrow->dev.type = &csrow_attr_type;
-	csrow->dev.bus = mci_pdev.bus;
+	csrow->dev.bus = &mci->bus;
 	device_initialize(&csrow->dev);
 	csrow->dev.parent = &mci->dev;
 	dev_set_name(&csrow->dev, "csrow%d", index);
@@ -580,7 +580,7 @@ static int edac_create_dimm_object(struct mem_ctl_info *mci,
 	dimm->mci = mci;
 
 	dimm->dev.type = &dimm_attr_type;
-	dimm->dev.bus = mci_pdev.bus;
+	dimm->dev.bus = &mci->bus;
 	device_initialize(&dimm->dev);
 
 	dimm->dev.parent = &mci->dev;
@@ -934,16 +934,29 @@ int edac_create_sysfs_mci_device(struct mem_ctl_info *mci)
 	device_initialize(&mci->dev);
 
 	mci->dev.parent = &mci_pdev;
-	mci->dev.bus = mci_pdev.bus;
+	mci->dev.bus = &mci->bus;
 	dev_set_name(&mci->dev, "mc%d", mci->mc_idx);
 	dev_set_drvdata(&mci->dev, mci);
 	pm_runtime_forbid(&mci->dev);
 
+	/*
+	 * The memory controller needs its own bus, in order to avoid
+	 * namespace conflicts at /sys/bus/edac.
+	 */
+	debugf0("creating bus %s\n",mci->bus.name);
+	mci->bus.name = kstrdup(dev_name(&mci->dev), GFP_KERNEL);
+	err = bus_register(&mci->bus);
+	if (err < 0)
+		return err;
+
 	debugf0("%s(): creating device %s\n", __func__,
 		dev_name(&mci->dev));
 	err = device_add(&mci->dev);
-	if (err < 0)
+	if (err < 0) {
+		bus_unregister(&mci->bus);
+		kfree(mci->bus.name);
 		return err;
+	}
 
 	/*
 	 * Create the dimm/rank devices
@@ -994,6 +1007,8 @@ fail:
 	}
 	put_device(&mci->dev);
 	device_del(&mci->dev);
+	bus_unregister(&mci->bus);
+	kfree(mci->bus.name);
 	return err;
 }
 
@@ -1029,6 +1044,8 @@ void edac_unregister_sysfs(struct mem_ctl_info *mci)
 	debugf1("Unregistering device %s\n", dev_name(&mci->dev));
 	put_device(&mci->dev);
 	device_del(&mci->dev);
+	bus_unregister(&mci->bus);
+	kfree(mci->bus.name);
 }
 
 static void mc_attr_release(struct device *device)
diff --git a/include/linux/edac.h b/include/linux/edac.h
index a32ed72..22c3fca 100644
--- a/include/linux/edac.h
+++ b/include/linux/edac.h
@@ -507,6 +507,7 @@ struct edac_hierarchy {
  */
 struct mem_ctl_info {
 	struct device			dev;
+	struct bus_type			bus;
 
 	struct list_head link;	/* for global list of mem_ctl_info structs */
 
-- 
1.7.8

