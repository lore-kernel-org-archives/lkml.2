Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932826Ab2GCL2R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 07:28:17 -0400
Received: from mga01.intel.com ([192.55.52.88]:37090 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755913Ab2GCL1g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 07:27:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="172902028"
Date: Tue, 3 Jul 2012 19:27:26 +0800
From: wfg@linux.intel.com
To: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
Cc: Johannes Berg <johannes.berg@intel.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [mac80211-next:for-john] WARNING: at
 /c/kernel-tests/net/net/wireless/core.c:471 wiphy_register+0x401/0x451()
Message-ID: <20120703112726.GA32627@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="5vNYLRcllDrimb99"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Heirloom mailx 12.5 6/20/10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--5vNYLRcllDrimb99
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Vladimir,

The below commit triggers a warning.

tree:   git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git for-john
head:   ba0afa2f22e1e3f332e45460f99328025d44564e
commit: 3a0c52a6d82cc41da965284412608c74aece34e4 [648/651] cfg80211: add 802.11ad (60gHz band) support

647:	b d9b3b28  2012-07-02 14:47:44 +0200  mac80211: allow calling ieee80211_ap_probereq_get() during auth/assoc
648:	B 3a0c52a  [   72.865235] WARNING: at /c/kernel-tests/net/net/wireless/core.c:471 wiphy_register+0x401/0x451() 
649:	B 90cdc6d  [   64.868502] WARNING: at /c/kernel-tests/net/net/wireless/core.c:471 wiphy_register+0x401/0x451() 
650:	B b188148  [   30.024352] WARNING: at /c/kernel-tests/net/net/wireless/core.c:471 wiphy_register+0x401/0x451() 
651:	B ba0afa2  [   77.237955] WARNING: at /c/kernel-tests/net/net/wireless/core.c:471 wiphy_register+0x401/0x451() 
       [b] boot OK [B] kernel boots with some problem

[   72.862898] mac80211_hwsim: Initializing radio 0
[   72.864155] ------------[ cut here ]------------
[   72.865235] WARNING: at /c/kernel-tests/net/net/wireless/core.c:471 wiphy_register+0x401/0x451()
[   72.867261] Hardware name: Bochs
[   72.868096] Modules linked in:
[   72.868885] Pid: 1, comm: swapper/0 Not tainted 3.5.0-rc1+ #4
[   72.870152] Call Trace:
[   72.870885]  [<ffffffff81090261>] warn_slowpath_common+0x83/0x9c
[   72.872241]  [<ffffffff81090294>] warn_slowpath_null+0x1a/0x1c
[   72.873542]  [<ffffffff82c293e3>] wiphy_register+0x401/0x451
[   72.874835]  [<ffffffff811758a0>] ? __kmalloc+0x128/0x13a
[   72.876069]  [<ffffffff82c46713>] ? ieee80211_register_hw+0x113/0x5dc
[   72.877473]  [<ffffffff82c469a4>] ieee80211_register_hw+0x3a4/0x5dc
[   72.878944]  [<ffffffff8464e113>] init_mac80211_hwsim+0x423/0x6a0
[   72.880294]  [<ffffffff8464dcf0>] ? carl9170_driver_init+0x1b/0x1b
[   72.881671]  [<ffffffff81002099>] do_one_initcall+0x7f/0x13a
[   72.882985]  [<ffffffff845f0d39>] kernel_init+0x170/0x1f8
[   72.884215]  [<ffffffff845f0590>] ? do_early_param+0x8c/0x8c
[   72.885483]  [<ffffffff82e516b4>] kernel_thread_helper+0x4/0x10
[   72.886787]  [<ffffffff82e498f0>] ? retint_restore_args+0x13/0x13
[   72.888244]  [<ffffffff845f0bc9>] ? start_kernel+0x3e7/0x3e7
[   72.889506]  [<ffffffff82e516b0>] ? gs_change+0x13/0x13
[   72.890695] ---[ end trace bd81035d49db0c0f ]---
[   72.891797] mac80211_hwsim: ieee80211_register_hw failed (-22)

commit 3a0c52a6d82cc41da965284412608c74aece34e4
Author: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
Date:   Mon Jul 2 09:32:32 2012 +0300

    cfg80211: add 802.11ad (60gHz band) support
    
    Add enumerations for both cfg80211 and nl80211.
    This expands wiphy.bands etc. arrays.
    
    Extend channel <-> frequency translation to cover 60g band
    and modify the rate check logic since there are no legacy
    mandatory rates (only MCS is used.)
    
    Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
    Signed-off-by: Johannes Berg <johannes.berg@intel.com>

diff --git a/drivers/net/wireless/iwlegacy/3945-rs.c b/drivers/net/wireless/iwlegacy/3945-rs.c
index 4b10157..d4fd29a 100644
--- a/drivers/net/wireless/iwlegacy/3945-rs.c
+++ b/drivers/net/wireless/iwlegacy/3945-rs.c
@@ -946,7 +946,7 @@ il3945_rate_scale_init(struct ieee80211_hw *hw, s32 sta_id)
 	case IEEE80211_BAND_5GHZ:
 		rs_sta->expected_tpt = il3945_expected_tpt_a;
 		break;
-	case IEEE80211_NUM_BANDS:
+	default:
 		BUG();
 		break;
 	}
diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index 2300327..74cc55c 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -2545,10 +2545,12 @@ enum nl80211_tx_rate_attributes {
  * enum nl80211_band - Frequency band
  * @NL80211_BAND_2GHZ: 2.4 GHz ISM band
  * @NL80211_BAND_5GHZ: around 5 GHz band (4.9 - 5.7 GHz)
+ * @NL80211_BAND_60GHZ: around 60 GHz band (58.32 - 64.80 GHz)
  */
 enum nl80211_band {
 	NL80211_BAND_2GHZ,
 	NL80211_BAND_5GHZ,
+	NL80211_BAND_60GHZ,
 };
 
 /**
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index fa26934..0b564e8 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -70,11 +70,13 @@
  *
  * @IEEE80211_BAND_2GHZ: 2.4GHz ISM band
  * @IEEE80211_BAND_5GHZ: around 5GHz band (4.9-5.7)
+ * @IEEE80211_BAND_60GHZ: around 60 GHz band (58.32 - 64.80 GHz)
  * @IEEE80211_NUM_BANDS: number of defined bands
  */
 enum ieee80211_band {
 	IEEE80211_BAND_2GHZ = NL80211_BAND_2GHZ,
 	IEEE80211_BAND_5GHZ = NL80211_BAND_5GHZ,
+	IEEE80211_BAND_60GHZ = NL80211_BAND_60GHZ,
 
 	/* keep last */
 	IEEE80211_NUM_BANDS
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 4e75303..4990f4f 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -140,6 +140,8 @@ static __le16 ieee80211_duration(struct ieee80211_tx_data *tx,
 			if (r->flags & IEEE80211_RATE_MANDATORY_A)
 				mrate = r->bitrate;
 			break;
+		case IEEE80211_BAND_60GHZ:
+			/* TODO, for now fall through */
 		case IEEE80211_NUM_BANDS:
 			WARN_ON(1);
 			break;
diff --git a/net/wireless/core.c b/net/wireless/core.c
index ca2b95f..e13365f 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -468,8 +468,14 @@ int wiphy_register(struct wiphy *wiphy)
 			continue;
 
 		sband->band = band;
-
-		if (WARN_ON(!sband->n_channels || !sband->n_bitrates))
+		if (WARN_ON(!sband->n_channels))
+			return -EINVAL;
+		/*
+		 * on 60gHz band, there are no legacy rates, so
+		 * n_bitrates is 0
+		 */
+		if (WARN_ON(band != IEEE80211_BAND_60GHZ &&
+			    !sband->n_bitrates))
 			return -EINVAL;
 
 		/*
diff --git a/net/wireless/util.c b/net/wireless/util.c
index a9260ac..0228c64 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -35,19 +35,29 @@ int ieee80211_channel_to_frequency(int chan, enum ieee80211_band band)
 {
 	/* see 802.11 17.3.8.3.2 and Annex J
 	 * there are overlapping channel numbers in 5GHz and 2GHz bands */
-	if (band == IEEE80211_BAND_5GHZ) {
-		if (chan >= 182 && chan <= 196)
-			return 4000 + chan * 5;
-		else
-			return 5000 + chan * 5;
-	} else { /* IEEE80211_BAND_2GHZ */
+	if (chan <= 0)
+		return 0; /* not supported */
+	switch (band) {
+	case IEEE80211_BAND_2GHZ:
 		if (chan == 14)
 			return 2484;
 		else if (chan < 14)
 			return 2407 + chan * 5;
+		break;
+	case IEEE80211_BAND_5GHZ:
+		if (chan >= 182 && chan <= 196)
+			return 4000 + chan * 5;
 		else
-			return 0; /* not supported */
+			return 5000 + chan * 5;
+		break;
+	case IEEE80211_BAND_60GHZ:
+		if (chan < 5)
+			return 56160 + chan * 2160;
+		break;
+	default:
+		;
 	}
+	return 0; /* not supported */
 }
 EXPORT_SYMBOL(ieee80211_channel_to_frequency);
 
@@ -60,8 +70,12 @@ int ieee80211_frequency_to_channel(int freq)
 		return (freq - 2407) / 5;
 	else if (freq >= 4910 && freq <= 4980)
 		return (freq - 4000) / 5;
-	else
+	else if (freq <= 45000) /* DMG band lower limit */
 		return (freq - 5000) / 5;
+	else if (freq >= 58320 && freq <= 64800)
+		return (freq - 56160) / 2160;
+	else
+		return 0;
 }
 EXPORT_SYMBOL(ieee80211_frequency_to_channel);
 
@@ -137,6 +151,11 @@ static void set_mandatory_flags_band(struct ieee80211_supported_band *sband,
 		}
 		WARN_ON(want != 0 && want != 3 && want != 6);
 		break;
+	case IEEE80211_BAND_60GHZ:
+		/* check for mandatory HT MCS 1..4 */
+		WARN_ON(!sband->ht_cap.ht_supported);
+		WARN_ON((sband->ht_cap.mcs.rx_mask[0] & 0x1e) != 0x1e);
+		break;
 	case IEEE80211_NUM_BANDS:
 		WARN_ON(1);
 		break;

--5vNYLRcllDrimb99
Content-Type: application/octet-stream
Content-Disposition: attachment; filename=dmesg-kvm-waimea-2443-2012-07-02-22-56-10
Content-Transfer-Encoding: 8bit

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.5.0-rc1+ (wfg@bee) (gcc version 4.7.0 (Debian 4.7.1-1) ) #4 SMP Mon Jul 2 22:53:55 CST 2012
[    0.000000] Command line: rcutorture.rcutorture_runnable=0 auth_hashtable_size=10 sunrpc.auth_hashtable_size=10 log_buf_len=8M ignore_loglevel debug sched_debug apic=debug dynamic_printk sysrq_always_enabled panic=10 hung_task_panic=1 softlockup_panic=1 unknown_nmi_panic=1 nmi_watchdog=panic,lapic load_ramdisk=2 prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal ip=::::kvm::dhcp nfsroot=10.239.97.14:/nfsroot/wfg,tcp,v3,nocto,actimeo=600,nolock,rsize=524288,wsize=524288 rw link=vmlinuz-2012-07-02-22-54-36-net-mac80211-next.for-john-ba0afa2-3a0c52a-x86_64-allyesdebian-1 BOOT_IMAGE=kernel-tests/kernels/x86_64-allyesdebian/3a0c52a6d82cc41da965284412608c74aece34e4/vmlinuz-3.5.0-rc1+
[    0.000000] Disabled fast string operations
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009f3ff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009f400-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000001fffcfff] usable
[    0.000000] BIOS-e820: [mem 0x000000001fffd000-0x000000001fffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fffbc000-0x00000000ffffffff] reserved
[    0.000000] debug: ignoring loglevel setting.
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI 2.4 present.
[    0.000000] DMI: Bochs Bochs, BIOS Bochs 01/01/2007
[    0.000000] e820: update [mem 0x00000000-0x0000ffff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] No AGP bridge found
[    0.000000] e820: last_pfn = 0x1fffd max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: write-back
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 00E0000000 mask FFE0000000 uncachable
[    0.000000]   1 disabled
[    0.000000]   2 disabled
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x70106, new 0x7010600070106
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000f8860-0x000f886f] mapped at [ffff8800000f8860]
[    0.000000]   mpc: f8870-f898c
[    0.000000] initial memory mapped: [mem 0x00000000-0x1fffffff]
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x1fffcfff]
[    0.000000]  [mem 0x00000000-0x1fffcfff] page 4k
[    0.000000] kernel direct mapping tables up to 0x1fffcfff @ [mem 0x1fefb000-0x1fffcfff]
[    0.000000] log_buf_len: 8388608
[    0.000000] early log buf free: 127856(97%)
[    0.000000] ACPI: RSDP 00000000000f8810 00014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 000000001fffde10 00034 (v01 BOCHS  BXPCRSDT 00000001 BXPC 00000001)
[    0.000000] ACPI: FACP 000000001ffffe40 00074 (v01 BOCHS  BXPCFACP 00000001 BXPC 00000001)
[    0.000000] ACPI: DSDT 000000001fffdfd0 01E22 (v01   BXPC   BXDSDT 00000001 INTL 20090123)
[    0.000000] ACPI: FACS 000000001ffffe00 00040
[    0.000000] ACPI: SSDT 000000001fffdf80 00044 (v01 BOCHS  BXPCSSDT 00000001 BXPC 00000001)
[    0.000000] ACPI: APIC 000000001fffde90 0007A (v01 BOCHS  BXPCAPIC 00000001 BXPC 00000001)
[    0.000000] ACPI: HPET 000000001fffde50 00038 (v01 BOCHS  BXPCHPET 00000001 BXPC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5fb000 (        fee00000)
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x000000001fffcfff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x1fffcfff]
[    0.000000]   NODE_DATA [mem 0x1f6f6000-0x1f6fafff]
[    0.000000] kvm-clock: Using msrs 12 and 11
[    0.000000] kvm-clock: cpu 0, msr 0:45eea81, boot clock
[    0.000000]  [ffffea0000000000-ffffea00007fffff] PMD -> [ffff88001e600000-ffff88001edfffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00010000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00010000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x1fffcfff]
[    0.000000] On node 0 totalpages: 130956
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 6 pages reserved
[    0.000000]   DMA zone: 3913 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 1984 pages used for memmap
[    0.000000]   DMA32 zone: 124989 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5fb000 (        fee00000)
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 17, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 00, APIC ID 2, APIC INT 02
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 5 global_irq 5 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 05, APIC ID 2, APIC INT 05
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 09, APIC ID 2, APIC INT 09
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 10 global_irq 10 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0a, APIC ID 2, APIC INT 0a
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 11 global_irq 11 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0b, APIC ID 2, APIC INT 0b
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 01, APIC ID 2, APIC INT 01
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 03, APIC ID 2, APIC INT 03
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 04, APIC ID 2, APIC INT 04
[    0.000000] ACPI: IRQ5 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 06, APIC ID 2, APIC INT 06
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 07, APIC ID 2, APIC INT 07
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 08, APIC ID 2, APIC INT 08
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] ACPI: IRQ10 used by override.
[    0.000000] ACPI: IRQ11 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0c, APIC ID 2, APIC INT 0c
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0d, APIC ID 2, APIC INT 0d
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0e, APIC ID 2, APIC INT 0e
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0f, APIC ID 2, APIC INT 0f
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] mapped IOAPIC to ffffffffff5fa000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000f0000
[    0.000000] PM: Registered nosave memory: 00000000000f0000 - 0000000000100000
[    0.000000] e820: [mem 0x20000000-0xfffbbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] setup_percpu: NR_CPUS:512 nr_cpumask_bits:512 nr_cpu_ids:2 nr_node_ids:1
[    0.000000] PERCPU: Embedded 477 pages/cpu @ffff88001f200000 s1924184 r8192 d21416 u2097152
[    0.000000] pcpu-alloc: s1924184 r8192 d21416 u2097152 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 [0] 1 
[    0.000000] kvm-clock: cpu 0, msr 0:1f3d4a81, primary cpu clock
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 128902
[    0.000000] Policy zone: DMA32
[    0.000000] Kernel command line: rcutorture.rcutorture_runnable=0 auth_hashtable_size=10 sunrpc.auth_hashtable_size=10 log_buf_len=8M ignore_loglevel debug sched_debug apic=debug dynamic_printk sysrq_always_enabled panic=10 hung_task_panic=1 softlockup_panic=1 unknown_nmi_panic=1 nmi_watchdog=panic,lapic load_ramdisk=2 prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal ip=::::kvm::dhcp nfsroot=10.239.97.14:/nfsroot/wfg,tcp,v3,nocto,actimeo=600,nolock,rsize=524288,wsize=524288 rw link=vmlinuz-2012-07-02-22-54-36-net-mac80211-next.for-john-ba0afa2-3a0c52a-x86_64-allyesdebian-1 BOOT_IMAGE=kernel-tests/kernels/x86_64-allyesdebian/3a0c52a6d82cc41da965284412608c74aece34e4/vmlinuz-3.5.0-rc1+
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 2048 (order: 2, 16384 bytes)
[    0.000000] __ex_table already sorted, skipping sort
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.000000] Memory: 430212k/524276k available (31064k kernel code, 452k absent, 93612k reserved, 22279k data, 3908k init)
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU debugfs-based tracing is enabled.
[    0.000000] 	RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000] NR_IRQS:33024 nr_irqs:512 16
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] console [ttyS0] enabled
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
[    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
[    0.000000] ... CHAINHASH_SIZE:          16384
[    0.000000]  memory used by lock dependency info: 6367 kB
[    0.000000]  per task-struct memory footprint: 2688 bytes
[    0.000000] ------------------------
[    0.000000] | Locking API testsuite:
[    0.000000] ----------------------------------------------------------------------------
[    0.000000]                                  | spin |wlock |rlock |mutex | wsem | rsem |
[    0.000000]   --------------------------------------------------------------------------
[    0.000000]                      A-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]                  A-B-B-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]              A-B-B-C-C-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]              A-B-C-A-B-C deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]          A-B-B-C-C-D-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]          A-B-C-D-B-D-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]          A-B-C-D-B-C-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]                     double unlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]                   initialize held:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]                  bad unlock order:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]   --------------------------------------------------------------------------
[    0.000000]               recursive read-lock:             |  ok  |             |  ok  |
[    0.000000]            recursive read-lock #2:             |  ok  |             |  ok  |
[    0.000000]             mixed read-write-lock:             |  ok  |             |  ok  |
[    0.000000]             mixed write-read-lock:             |  ok  |             |  ok  |
[    0.000000]   --------------------------------------------------------------------------
[    0.000000]      hard-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
[    0.000000]      soft-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
[    0.000000]      hard-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
[    0.000000]      soft-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
[    0.000000]        sirq-safe-A => hirqs-on/12:  ok  |  ok  |  ok  |
[    0.000000]        sirq-safe-A => hirqs-on/21:  ok  |  ok  |  ok  |
[    0.000000]          hard-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
[    0.000000]          soft-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
[    0.000000]          hard-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
[    0.000000]          soft-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/123:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/123:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/132:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/132:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/213:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/213:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/231:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/231:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/312:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/312:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/321:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/321:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq read-recursion/123:  ok  |
[    0.000000]       soft-irq read-recursion/123:  ok  |
[    0.000000]       hard-irq read-recursion/132:  ok  |
[    0.000000]       soft-irq read-recursion/132:  ok  |
[    0.000000]       hard-irq read-recursion/213:  ok  |
[    0.000000]       soft-irq read-recursion/213:  ok  |
[    0.000000]       hard-irq read-recursion/231:  ok  |
[    0.000000]       soft-irq read-recursion/231:  ok  |
[    0.000000]       hard-irq read-recursion/312:  ok  |
[    0.000000]       soft-irq read-recursion/312:  ok  |
[    0.000000]       hard-irq read-recursion/321:  ok  |
[    0.000000]       soft-irq read-recursion/321:  ok  |
[    0.000000] -------------------------------------------------------
[    0.000000] Good, all 218 testcases passed! |
[    0.000000] ---------------------------------
[    0.000000] allocated 2097152 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
[    0.000000] ODEBUG: 0 of 0 active objects replaced
[    0.000000] hpet clockevent registered
[    0.000000] Detected 3300.348 MHz processor.
[    0.004000] Calibrating delay loop (skipped) preset value.. 6600.69 BogoMIPS (lpj=13201392)
[    0.004020] pid_max: default: 32768 minimum: 301
[    0.005671] Security Framework initialized
[    0.006752] AppArmor: AppArmor disabled by boot time parameter
[    0.008300] Dentry cache hash table entries: 65536 (order: 7, 524288 bytes)
[    0.010688] Inode-cache hash table entries: 32768 (order: 6, 262144 bytes)
[    0.012377] Mount-cache hash table entries: 256
[    0.016722] Initializing cgroup subsys cpuacct
[    0.017845] Initializing cgroup subsys memory
[    0.019198] Initializing cgroup subsys devices
[    0.020011] Initializing cgroup subsys freezer
[    0.021207] Initializing cgroup subsys net_cls
[    0.022369] Initializing cgroup subsys blkio
[    0.024435] Disabled fast string operations
[    0.025795] mce: CPU supports 10 MCE banks
[    0.027097] numa_add_cpu cpu 0 node 0: mask now 0
[    0.029802] ACPI: Core revision 20120320
[    0.035239] ftrace: allocating 117425 entries in 459 pages
[    0.064357] Getting VERSION: 50014
[    0.065270] Getting VERSION: 50014
[    0.068029] Getting ID: 0
[    0.068782] Getting ID: ff000000
[    0.069669] Getting LVT0: 8700
[    0.070519] Getting LVT1: 8400
[    0.072083] enabled ExtINT on CPU#0
[    0.073814] ENABLING IO-APIC IRQs
[    0.074735] init IO_APIC IRQs
[    0.075568]  apic 2 pin 0 not connected
[    0.076025] IOAPIC[0]: Set routing entry (2-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:1)
[    0.078075] IOAPIC[0]: Set routing entry (2-2 -> 0x30 -> IRQ 0 Mode:0 Active:0 Dest:1)
[    0.080028] IOAPIC[0]: Set routing entry (2-3 -> 0x33 -> IRQ 3 Mode:0 Active:0 Dest:1)
[    0.082027] IOAPIC[0]: Set routing entry (2-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:1)
[    0.084026] IOAPIC[0]: Set routing entry (2-5 -> 0x35 -> IRQ 5 Mode:1 Active:0 Dest:1)
[    0.086064] IOAPIC[0]: Set routing entry (2-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:1)
[    0.088026] IOAPIC[0]: Set routing entry (2-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:1)
[    0.090165] IOAPIC[0]: Set routing entry (2-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:1)
[    0.092026] IOAPIC[0]: Set routing entry (2-9 -> 0x39 -> IRQ 9 Mode:1 Active:0 Dest:1)
[    0.093961] IOAPIC[0]: Set routing entry (2-10 -> 0x3a -> IRQ 10 Mode:1 Active:0 Dest:1)
[    0.096026] IOAPIC[0]: Set routing entry (2-11 -> 0x3b -> IRQ 11 Mode:1 Active:0 Dest:1)
[    0.097982] IOAPIC[0]: Set routing entry (2-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:1)
[    0.100026] IOAPIC[0]: Set routing entry (2-13 -> 0x3d -> IRQ 13 Mode:0 Active:0 Dest:1)
[    0.101975] IOAPIC[0]: Set routing entry (2-14 -> 0x3e -> IRQ 14 Mode:0 Active:0 Dest:1)
[    0.104028] IOAPIC[0]: Set routing entry (2-15 -> 0x3f -> IRQ 15 Mode:0 Active:0 Dest:1)
[    0.105987]  apic 2 pin 16 not connected
[    0.108010]  apic 2 pin 17 not connected
[    0.109015]  apic 2 pin 18 not connected
[    0.110008]  apic 2 pin 19 not connected
[    0.111005]  apic 2 pin 20 not connected
[    0.112010]  apic 2 pin 21 not connected
[    0.113023]  apic 2 pin 22 not connected
[    0.114017]  apic 2 pin 23 not connected
[    0.115158] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.116014] CPU0: Intel Common KVM processor stepping 01
[    0.120011] Using local APIC timer interrupts.
[    0.120011] calibrating APIC timer ...
[    0.128007] ... lapic delta = 6249001
[    0.128007] ... PM-Timer delta = 357855
[    0.128007] ... PM-Timer result ok
[    0.128007] ..... delta 6249001
[    0.128007] ..... mult: 268375775
[    0.128007] ..... calibration result: 3999360
[    0.128007] ..... CPU clock speed is 3299.1693 MHz.
[    0.128007] ..... host bus clock speed is 999.3360 MHz.
[    0.128065] Performance Events: unsupported Netburst CPU model 6 no PMU driver, software events only.
[    0.131864] Testing tracer nop: PASSED
[    0.132049] NMI watchdog: disabled (cpu0): hardware events not enabled
[    0.136928] lockdep: fixing up alternatives.
[    0.138410] Booting Node   0, Processors  #1 Ok.
[    0.004000] kvm-clock: cpu 1, msr 0:1f5d4a81, secondary cpu clock
[    0.004000] masked ExtINT on CPU#1
[    0.004000] Disabled fast string operations
[    0.004000] numa_add_cpu cpu 1 node 0: mask now 0-1
[    0.156009] TSC synchronization [CPU#0 -> CPU#1]:
[    0.156009] Measured 685 cycles TSC warp between CPUs, turning off TSC clock.
[    0.156009] Marking TSC unstable due to check_tsc_sync_source failed
[    0.160080] NMI watchdog: disabled (cpu1): hardware events not enabled
[    0.164156] Brought up 2 CPUs
[    0.165029] Total of 2 processors activated (13201.39 BogoMIPS).
[    0.166893] CPU0 attaching sched-domain:
[    0.168041]  domain 0: span 0-1 level CPU
[    0.169137]   groups: 0 (cpu_power = 1023) 1
[    0.170297] CPU1 attaching sched-domain:
[    0.172015]  domain 0: span 0-1 level CPU
[    0.173041]   groups: 1 0 (cpu_power = 1023)
[    0.176018] devtmpfs: initialized
[    0.181335] initlevel:0=early, 4 registered initcalls
[    0.185896] initlevel:1=core, 36 registered initcalls
[    0.190911] xor: automatically using best checksumming function:
[    0.232027]    generic_sse:   213.000 MB/sec
[    0.233146] atomic64 test passed for x86-64 platform with CX8 and with SSE
[    0.235508] dummy: 
[    0.236768] NET: Registered protocol family 16
[    0.238053] initlevel:2=postcore, 15 registered initcalls
[    0.243181] initlevel:3=arch, 13 registered initcalls
[    0.246989] ACPI: bus type pci registered
[    0.248214] dca service started, version 1.12.1
[    0.249517] PCI: Using configuration type 1 for base access
[    0.250891] initlevel:4=subsys, 92 registered initcalls
[    0.255126] mtrr: your CPUs had inconsistent variable MTRR settings
[    0.256019] mtrr: your CPUs had inconsistent MTRRdefType settings
[    0.257527] mtrr: probably your BIOS does not setup all CPUs.
[    0.260019] mtrr: corrected configuration.
[    0.372814] bio: create slab <bio-0> at 0
[    0.440039] raid6: sse2x1    9480 MB/s
[    0.508041] raid6: sse2x2   11716 MB/s
[    0.576042] raid6: sse2x4   13383 MB/s
[    0.577047] raid6: using algorithm sse2x4 (13383 MB/s)
[    0.578354] raid6: using intx1 recovery algorithm
[    0.579852] ACPI: Added _OSI(Module Device)
[    0.580041] ACPI: Added _OSI(Processor Device)
[    0.581175] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.582416] ACPI: Added _OSI(Processor Aggregator Device)
[    0.586072] ACPI: EC: Look up EC in DSDT
[    0.593590] ACPI: Interpreter enabled
[    0.594718] ACPI: (supports S0 S3 S4 S5)
[    0.595747] ACPI: Using IOAPIC for interrupt routing
[    0.608499] ACPI: No dock devices found.
[    0.609535] PCI: Ignoring host bridge windows from ACPI; if necessary, use "pci=use_crs" and report a bug
[    0.612014] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.612111] pci_root PNP0A03:00: host bridge window [io  0x0000-0x0cf7] (ignored)
[    0.614085] pci_root PNP0A03:00: host bridge window [io  0x0d00-0xffff] (ignored)
[    0.616043] pci_root PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff] (ignored)
[    0.618125] pci_root PNP0A03:00: host bridge window [mem 0xe0000000-0xfebfffff] (ignored)
[    0.620051] PCI: root bus 00: using default resources
[    0.621592] PCI host bridge to bus 0000:00
[    0.624044] pci_bus 0000:00: root bus resource [io  0x0000-0xffff]
[    0.625522] pci_bus 0000:00: root bus resource [mem 0x00000000-0xffffffffff]
[    0.627290] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.628485] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.630642] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.632394] pci 0000:00:01.1: reg 20: [io  0xc000-0xc00f]
[    0.634072] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.636580] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX4 ACPI
[    0.638497] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX4 SMB
[    0.640280] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.648130] pci 0000:00:02.0: reg 10: [mem 0xf0000000-0xf1ffffff pref]
[    0.653331] pci 0000:00:02.0: reg 14: [mem 0xf2000000-0xf2000fff]
[    0.670092] pci 0000:00:02.0: reg 30: [mem 0xf2010000-0xf201ffff pref]
[    0.672377] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    0.676047] pci 0000:00:03.0: reg 10: [mem 0xf2020000-0xf203ffff]
[    0.678838] pci 0000:00:03.0: reg 14: [io  0xc040-0xc07f]
[    0.686514] pci 0000:00:03.0: reg 30: [mem 0xf2040000-0xf2047fff pref]
[    0.688296] pci 0000:00:04.0: [1af4:1001] type 00 class 0x010000
[    0.690027] pci 0000:00:04.0: reg 10: [io  0xc080-0xc0bf]
[    0.691419] pci 0000:00:04.0: reg 14: [mem 0xf2048000-0xf2048fff]
[    0.692834] pci 0000:00:05.0: [1af4:1001] type 00 class 0x010000
[    0.694445] pci 0000:00:05.0: reg 10: [io  0xc0c0-0xc0ff]
[    0.696130] pci 0000:00:05.0: reg 14: [mem 0xf2049000-0xf2049fff]
[    0.698430] pci 0000:00:06.0: [1af4:1001] type 00 class 0x010000
[    0.700192] pci 0000:00:06.0: reg 10: [io  0xc100-0xc13f]
[    0.701662] pci 0000:00:06.0: reg 14: [mem 0xf204a000-0xf204afff]
[    0.704984] pci 0000:00:07.0: [1af4:1001] type 00 class 0x010000
[    0.706678] pci 0000:00:07.0: reg 10: [io  0xc140-0xc17f]
[    0.708151] pci 0000:00:07.0: reg 14: [mem 0xf204b000-0xf204bfff]
[    0.710622] pci 0000:00:08.0: [1af4:1001] type 00 class 0x010000
[    0.712198] pci 0000:00:08.0: reg 10: [io  0xc180-0xc1bf]
[    0.713762] pci 0000:00:08.0: reg 14: [mem 0xf204c000-0xf204cfff]
[    0.716431] pci 0000:00:09.0: [1af4:1001] type 00 class 0x010000
[    0.718113] pci 0000:00:09.0: reg 10: [io  0xc1c0-0xc1ff]
[    0.719570] pci 0000:00:09.0: reg 14: [mem 0xf204d000-0xf204dfff]
[    0.720870] pci 0000:00:0a.0: [8086:25ab] type 00 class 0x088000
[    0.722438] pci 0000:00:0a.0: reg 10: [mem 0xf204e000-0xf204e00f]
[    0.724919] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.729483]  pci0000:00: Unable to request _OSC control (_OSC support mask: 0x1e)
[    0.748368] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    0.750011] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    0.751539] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    0.752242] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    0.754522] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.756069] vgaarb: loaded
[    0.756892] vgaarb: bridge control possible 0000:00:02.0
[    0.760427] tps65010: version 2 May 2005
[    0.792125] tps65010: no chip?
[    0.794362] SCSI subsystem initialized
[    0.795667] libata version 3.00 loaded.
[    0.796396] ACPI: bus type usb registered
[    0.797880] usbcore: registered new interface driver usbfs
[    0.800136] usbcore: registered new interface driver hub
[    0.801719] usbcore: registered new device driver usb
[    0.801769] Linux media interface: v0.10
[    0.804113] Linux video capture interface: v2.00
[    0.805477] pps_core: LinuxPPS API ver. 1 registered
[    0.806913] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
[    0.808091] PTP clock support registered
[    0.812342] wmi: Mapper loaded
[    5.812771] Advanced Linux Sound Architecture Driver Version 1.0.25.
[    5.814374] PCI: Using ACPI for IRQ routing
[    5.815524] PCI: pci_cache_line_size set to 64 bytes
[    5.816769] e820: reserve RAM buffer [mem 0x0009f400-0x0009ffff]
[    5.818218] e820: reserve RAM buffer [mem 0x1fffd000-0x1fffffff]
[    5.821067] Sangoma WANPIPE Router v1.1 (c) 1995-2000 Sangoma Technologies Inc.
[    5.823085] NET: Registered protocol family 23
[    5.824546] Bluetooth: Core ver 2.16
[    5.825549] NET: Registered protocol family 31
[    5.826678] Bluetooth: HCI device and connection manager initialized
[    5.828316] Bluetooth: HCI socket layer initialized
[    5.828369] Bluetooth: L2CAP socket layer initialized
[    5.829728] Bluetooth: SCO socket layer initialized
[    5.831101] NET: Registered protocol family 8
[    5.832368] NET: Registered protocol family 20
[    5.834343] cfg80211: Calling CRDA to update world regulatory domain
[    5.836789] nfc: nfc_init: NFC Core ver 0.1
[    5.837696] NET: Registered protocol family 39
[    5.838916] initlevel:5=fs, 39 registered initcalls
[    5.845037] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
[    5.846732] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    5.848177] hpet0: 3 comparators, 64-bit 100.000000 MHz counter
[    5.856442] Switching to clocksource kvm-clock
[    6.155888] FS-Cache: Loaded
[    6.157202] CacheFiles: Loaded
[    6.158154] pnp: PnP ACPI init
[    6.159110] ACPI: bus type pnp registered
[    6.160241] pnp 00:00: [bus 00-ff]
[    6.161176] pnp 00:00: [io  0x0cf8-0x0cff]
[    6.162224] pnp 00:00: [io  0x0000-0x0cf7 window]
[    6.163479] pnp 00:00: [io  0x0d00-0xffff window]
[    6.164638] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[    6.165938] pnp 00:00: [mem 0xe0000000-0xfebfffff window]
[    6.167516] pnp 00:00: Plug and Play ACPI device, IDs PNP0a03 (active)
[    6.169279] pnp 00:01: [io  0x0070-0x0071]
[    6.170369] IOAPIC[0]: Set routing entry (2-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:3)
[    6.172456] pnp 00:01: [irq 8]
[    6.173303] pnp 00:01: [io  0x0072-0x0077]
[    6.174511] pnp 00:01: Plug and Play ACPI device, IDs PNP0b00 (active)
[    6.176238] pnp 00:02: [io  0x0060]
[    6.186276] pnp 00:02: [io  0x0064]
[    6.187315] IOAPIC[0]: Set routing entry (2-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:3)
[    6.189281] pnp 00:02: [irq 1]
[    6.190275] pnp 00:02: Plug and Play ACPI device, IDs PNP0303 (active)
[    6.191992] IOAPIC[0]: Set routing entry (2-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:3)
[    6.194012] pnp 00:03: [irq 12]
[    6.195056] pnp 00:03: Plug and Play ACPI device, IDs PNP0f13 (active)
[    6.196727] pnp 00:04: [io  0x03f2-0x03f5]
[    6.197897] pnp 00:04: [io  0x03f7]
[    6.198890] IOAPIC[0]: Set routing entry (2-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:3)
[    6.201021] pnp 00:04: [irq 6]
[    6.201878] pnp 00:04: [dma 2]
[    6.202897] pnp 00:04: Plug and Play ACPI device, IDs PNP0700 (active)
[    6.204592] pnp 00:05: [io  0x0378-0x037f]
[    6.205677] IOAPIC[0]: Set routing entry (2-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:3)
[    6.207707] pnp 00:05: [irq 7]
[    6.208719] pnp 00:05: Plug and Play ACPI device, IDs PNP0400 (active)
[    6.210404] pnp 00:06: [io  0x03f8-0x03ff]
[    6.211625] IOAPIC[0]: Set routing entry (2-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:3)
[    6.213689] pnp 00:06: [irq 4]
[    6.214730] pnp 00:06: Plug and Play ACPI device, IDs PNP0501 (active)
[    6.216531] pnp 00:07: [mem 0xfed00000-0xfed003ff]
[    6.217915] pnp 00:07: Plug and Play ACPI device, IDs PNP0103 (active)
[    6.219816] pnp: PnP ACPI: found 8 devices
[    6.220905] ACPI: ACPI bus type pnp unregistered
[    6.246396] pci_bus 0000:00: resource 4 [io  0x0000-0xffff]
[    6.247947] pci_bus 0000:00: resource 5 [mem 0x00000000-0xffffffffff]
[    6.250101] NET: Registered protocol family 2
[    6.251714] IP route cache hash table entries: 4096 (order: 3, 32768 bytes)
[    6.254680] TCP established hash table entries: 16384 (order: 6, 262144 bytes)
[    6.257296] TCP bind hash table entries: 16384 (order: 8, 1310720 bytes)
[    6.261500] TCP: Hash tables configured (established 16384 bind 16384)
[    6.263293] TCP: reno registered
[    6.264229] UDP hash table entries: 256 (order: 3, 49152 bytes)
[    6.265763] UDP-Lite hash table entries: 256 (order: 3, 49152 bytes)
[    6.268160] NET: Registered protocol family 1
[    6.270479] RPC: Registered named UNIX socket transport module.
[    6.271982] RPC: Registered udp transport module.
[    6.273359] RPC: Registered tcp transport module.
[    6.274554] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    6.276318] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    6.277760] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    6.279247] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    6.280784] pci 0000:00:02.0: Boot video device
[    6.282049] PCI: CLS 0 bytes, default 64
[    6.317409] DMA-API: preallocated 32768 debug entries
[    6.318738] DMA-API: debugging enabled by kernel config
[    6.320162] initlevel:6=device, 2532 registered initcalls
[    6.324912] kvm: no hardware support
[    6.325905] has_svm: not amd
[    6.326743] kvm: no hardware support
[    6.328819] Machine check injector initialized
[    6.331281] microcode: CPU0 sig=0xf61, pf=0x1, revision=0x1
[    6.332739] microcode: CPU1 sig=0xf61, pf=0x1, revision=0x1
[    6.334361] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    6.337118] blowfish-x86_64: performance on this CPU would be suboptimal: disabling blowfish-x86_64.
[    6.337140] cryptomgr_test (29) used greatest stack depth: 6008 bytes left
[    6.341622] cryptomgr_test (30) used greatest stack depth: 5784 bytes left
[    6.341672] twofish-x86_64-3way: performance on this CPU would be suboptimal: disabling twofish-x86_64-3way.
[    6.349582] sha1_ssse3: Neither AVX nor SSSE3 is available/usable.
[    6.354041] Initializing RT-Tester: OK
[    6.355305] audit: initializing netlink socket (disabled)
[    6.356801] type=2000 audit(1341240895.352:1): initialized
[    6.423317] Kprobe smoke test started
[    6.831002] Kprobe smoke test passed successfully
[   12.527014] Testing tracer function: PASSED
[   13.016089] Testing dynamic ftrace: PASSED
[   13.698501] Testing dynamic ftrace ops #1: (1 0 1 1 0) (1 1 2 1 0) (2 1 3 1 56) (2 2 4 1 73) PASSED
[   16.163942] Testing dynamic ftrace ops #2: (1 0 1 51 0) (1 1 2 68 0) (2 1 3 2 26) (2 2 4 30 52) PASSED
[   28.636131] Testing tracer irqsoff: PASSED
[   36.163538] Testing tracer wakeup: PASSED
[   56.165100] Testing tracer wakeup_rt: PASSED
[   68.712162] Testing tracer function_graph: PASSED
[   68.715232] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[   68.719801] VFS: Disk quotas dquot_6.5.2
[   68.721210] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[   68.724960] DLM installed
[   68.727877] squashfs: version 4.0 (2009/01/31) Phillip Lougher
[   68.732614] NFS: Registering the id_resolver key type
[   68.733874] Key type id_resolver registered
[   68.735054] FS-Cache: Netfs 'nfs' registered for caching
[   68.737603] nfs4filelayout_init: NFSv4 File Layout Driver Registering...
[   68.739302] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[   68.742994] FS-Cache: Netfs 'cifs' registered for caching
[   68.745040] Key type cifs.spnego registered
[   68.746232] Key type cifs.idmap registered
[   68.747325] NTFS driver 2.1.30 [Flags: R/W].
[   68.748779] EFS: 1.0a - http://aeschi.ch.eu.org/efs/
[   68.750055] jffs2: version 2.2. (NAND) (SUMMARY)  © 2001-2006 Red Hat, Inc.
[   68.752704] ROMFS MTD (C) 2007 Red Hat, Inc.
[   68.753862] QNX4 filesystem 0.2.3 registered.
[   68.755205] fuse init (API version 7.18)
[   68.756869] JFS: nTxBlock = 3361, nTxLock = 26888
[   68.764065] SGI XFS with ACLs, security attributes, realtime, large block/inode numbers, no debug enabled
[   68.768952] 9p: Installing v9fs 9p2000 file system support
[   68.770386] FS-Cache: Netfs '9p' registered for caching
[   68.771874] NILFS version 2 loaded
[   68.772796] BeFS version: 0.9.3
[   68.773672] OCFS2 1.5.0
[   68.775316] ocfs2: Registered cluster interface o2cb
[   68.776753] ocfs2: Registered cluster interface user
[   68.777908] OCFS2 DLMFS 1.5.0
[   68.779288] OCFS2 User DLM kernel interface loaded
[   68.780448] OCFS2 Node Manager 1.5.0
[   68.781959] OCFS2 DLM 1.5.0
[   68.783893] Btrfs loaded
[   68.786591] GFS2 installed
[   68.787693] ceph: loaded (mds proto 32)
[   68.788708] msgmni has been set to 840
[   68.790961] alg: No test for cipher_null (cipher_null-generic)
[   68.792435] alg: No test for ecb(cipher_null) (ecb-cipher_null)
[   68.794140] alg: No test for digest_null (digest_null-generic)
[   68.795845] alg: No test for compress_null (compress_null-generic)
[   68.797495] cryptomgr_test (67) used greatest stack depth: 5400 bytes left
[   68.806777] alg: No test for fcrypt (fcrypt-generic)
[   68.816423] alg: No test for stdrng (krng)
[   68.824947] alg: No test for fips(ansi_cprng) (fips_ansi_cprng)
[   68.827609] NET: Registered protocol family 38
[   68.828750] async_tx: api initialized (async)
[   68.829929] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 249)
[   68.831949] io scheduler noop registered
[   68.833089] io scheduler deadline registered
[   68.834499] io scheduler cfq registered (default)
[   68.835788] start plist test
[   68.838337] end plist test
[   68.839225] list_sort_test: start testing list_sort()
[   68.841897] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[   68.843260] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[   68.844752] cpcihp_zt5550: ZT5550 CompactPCI Hot Plug Driver version: 0.2
[   68.846315] cpcihp_generic: Generic port I/O CompactPCI Hot Plug Driver version: 0.1
[   68.848117] cpcihp_generic: not configured, disabling.
[   68.849348] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[   68.850894] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[   68.852590] acpiphp: Slot [1] registered
[   68.853618] acpiphp: Slot [2] registered
[   68.854717] acpiphp: Slot [3] registered
[   68.855726] acpiphp: Slot [4] registered
[   68.856784] acpiphp: Slot [5] registered
[   68.857799] acpiphp: Slot [6] registered
[   68.858900] acpiphp: Slot [7] registered
[   68.859933] acpiphp: Slot [8] registered
[   68.861009] acpiphp: Slot [9] registered
[   68.862046] acpiphp: Slot [10] registered
[   68.863119] acpiphp: Slot [11] registered
[   68.864196] acpiphp: Slot [12] registered
[   68.865241] acpiphp: Slot [13] registered
[   68.866530] acpiphp: Slot [14] registered
[   68.867616] acpiphp: Slot [15] registered
[   68.868687] acpiphp: Slot [16] registered
[   68.869755] acpiphp: Slot [17] registered
[   68.870934] acpiphp: Slot [18] registered
[   68.871985] acpiphp: Slot [19] registered
[   68.873052] acpiphp: Slot [20] registered
[   68.874093] acpiphp: Slot [21] registered
[   68.875232] acpiphp: Slot [22] registered
[   68.876328] acpiphp: Slot [23] registered
[   68.877395] acpiphp: Slot [24] registered
[   68.878564] acpiphp: Slot [25] registered
[   68.879616] acpiphp: Slot [26] registered
[   68.880700] acpiphp: Slot [27] registered
[   68.881741] acpiphp: Slot [28] registered
[   68.882936] acpiphp: Slot [29] registered
[   68.883981] acpiphp: Slot [30] registered
[   68.885078] acpiphp: Slot [31] registered
[   68.888282] acpiphp_ibm: ibm_acpiphp_init: acpi_walk_namespace failed
[   68.890078] progear_bl: ALI M7101 PMU not found.
[   68.900051] VIA Graphics Integration Chipset framebuffer 2.4 initializing
[   68.901985] vmlfb: initializing
[   68.902890] Could not find Carillo Ranch MCH device.
[   68.904199] no IO addresses supplied
[   68.905239] hgafb: HGA card not detected.
[   68.906255] hgafb: probe of hgafb.0 failed with error -22
[   68.907684] usbcore: registered new interface driver udlfb
[   68.910654] uvesafb: failed to execute /sbin/v86d
[   68.911767] uvesafb: make sure that the v86d helper is installed and executable
[   68.913499] uvesafb: Getting VBE info block failed (eax=0x4f00, err=-2)
[   68.915017] uvesafb: vbe_init() failed with -22
[   68.916098] uvesafb: probe of uvesafb.0 failed with error -22
[   68.917977] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
[   68.919773] ACPI: Power Button [PWRF]
[   68.928781] GHES: HEST is not enabled!
[   68.929731] ioatdma: Intel(R) QuickData Technology Driver 4.00
[   68.931744] ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 11
[   68.933073] IOAPIC[0]: Set routing entry (2-11 -> 0x3b -> IRQ 11 Mode:1 Active:0 Dest:3)
[   68.935047] virtio-pci 0000:00:04.0: setting latency timer to 64
[   68.937003] ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 10
[   68.938334] IOAPIC[0]: Set routing entry (2-10 -> 0x3a -> IRQ 10 Mode:1 Active:0 Dest:3)
[   68.940255] virtio-pci 0000:00:05.0: setting latency timer to 64
[   68.942027] ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 10
[   68.943408] virtio-pci 0000:00:06.0: setting latency timer to 64
[   68.945185] ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 11
[   68.946565] virtio-pci 0000:00:07.0: setting latency timer to 64
[   68.948204] virtio-pci 0000:00:08.0: setting latency timer to 64
[   68.949784] virtio-pci 0000:00:09.0: setting latency timer to 64
[   68.951378] XENFS: not registering filesystem on non-xen platform
[   68.953045] HDLC line discipline maxframe=4096
[   68.954089] N_HDLC line discipline registered.
[   68.955178] r3964: Philips r3964 Driver $Revision: 1.10 $
[   68.956411] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[   68.981962] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[   69.008086] 00:06: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[   69.010360] Cyclades driver 2.6
[   69.011402] MOXA Intellio family driver version 6.0k
[   69.028178] MOXA Smartio/Industio family driver version 2.0.5
[   69.029541] Initializing Nozomi driver 2.1d
[   69.030711] RocketPort device driver module, version 2.09, 12-June-2003
[   69.032216] No rocketport ports found; unloading driver
[   69.033427] SyncLink GT
[   69.034144] SyncLink GT, tty major#244
[   69.035161] SyncLink GT no devices found
[   69.036133] SyncLink MultiPort driver $Revision: 4.38 $
[   69.052645] SyncLink MultiPort driver $Revision: 4.38 $, tty major#243
[   69.054071] SyncLink serial driver $Revision: 4.38 $
[   69.070606] SyncLink serial driver $Revision: 4.38 $, tty major#242
[   69.073252] lp: driver loaded but no devices found
[   69.074417] Applicom driver: $Id: ac.c,v 1.30 2000/03/22 16:03:57 dwmw2 Exp $
[   69.075952] ac.o: No PCI boards found.
[   69.077018] ac.o: For an ISA board you must supply memory and irq parameters.
[   69.079106] Non-volatile memory driver v1.3
[   69.081213] ppdev: user-space parallel port driver
[   69.082383] telclk_interrupt = 0xf non-mcpbl0010 hw.
[   69.083566] smapi::smapi_init, ERROR invalid usSmapiID
[   69.084755] mwave: tp3780i::tp3780I_InitializeBoardData: Error: SMAPI is not available on this machine
[   69.086881] mwave: mwavedd::mwave_init: Error: Failed to initialize board data
[   69.088584] mwave: mwavedd::mwave_init: Error: Failed to initialize
[   69.089956] Linux agpgart interface v0.103
[   69.092256] SyncLink PC Card driver $Revision: 4.34 $, tty major#240
[   69.093781] ipmi message handler version 39.2
[   69.094956] ipmi device interface
[   69.095881] IPMI System Interface driver.
[   69.096992] ipmi_si: Adding default-specified kcs state machine
[   69.098302] ipmi_si: Trying default-specified kcs state machine at i/o address 0xca2, slave address 0x0, irq 0
[   69.100530] ipmi_si: Interface detection failed
[   69.101701] ipmi_si: Adding default-specified smic state machine
[   69.103158] ipmi_si: Trying default-specified smic state machine at i/o address 0xca9, slave address 0x0, irq 0
[   69.105396] ipmi_si: Interface detection failed
[   69.108146] ipmi_si: Adding default-specified bt state machine
[   69.109434] ipmi_si: Trying default-specified bt state machine at i/o address 0xe4, slave address 0x0, irq 0
[   69.111685] ipmi_si: Interface detection failed
[   69.112923] ipmi_si: Unable to find any System Interface(s)
[   69.114180] IPMI Watchdog: driver initialized
[   69.115232] Copyright (C) 2004 MontaVista Software - IPMI Powerdown via sys_reboot.
[   69.117011] Hangcheck: starting hangcheck timer 0.9.1 (tick is 180 seconds, margin is 60 seconds).
[   69.119086] Hangcheck: Using getrawmonotonic().
[   69.120378] [drm] Initialized drm 1.1.0 20060810
[   69.121779] [drm] radeon defaulting to kernel modesetting.
[   69.123101] [drm] radeon kernel modesetting enabled.
[   69.124382] [drm:i915_init] *ERROR* drm/i915 can't work without intel_agp module!
[   69.126526] i2c-core: driver [ch7006] using legacy suspend method
[   69.127867] i2c-core: driver [ch7006] using legacy resume method
[   69.129400] parport_pc 00:05: reported by Plug and Play ACPI
[   69.130961] parport0: PC-style at 0x378, irq 7 [PCSPP,TRISTATE]
[   69.229952] lp0: using parport0 (interrupt-driven).
[   69.258147] FDC 0 is a S82078B
[   69.273757] brd: module loaded
[   69.278159] loop: module loaded
[   69.279032] Compaq SMART2 Driver (v 2.6.0)
[   69.280114] HP CISS Driver (v 3.6.26)
[   69.282207] MM: desc_per_page = 128
[   69.285589] nbd: registered device at major 43
[   69.293030] virtio-pci 0000:00:04.0: irq 40 for MSI/MSI-X
[   69.294296] virtio-pci 0000:00:04.0: irq 41 for MSI/MSI-X
[   69.313963]  vda: unknown partition table
[   69.318265] virtio-pci 0000:00:05.0: irq 42 for MSI/MSI-X
[   69.320936] virtio-pci 0000:00:05.0: irq 43 for MSI/MSI-X
[   69.339048]  vdb: unknown partition table
[   69.343329] virtio-pci 0000:00:06.0: irq 44 for MSI/MSI-X
[   69.347308] virtio-pci 0000:00:06.0: irq 45 for MSI/MSI-X
[   69.367117]  vdc: unknown partition table
[   69.371342] virtio-pci 0000:00:07.0: irq 46 for MSI/MSI-X
[   69.375315] virtio-pci 0000:00:07.0: irq 47 for MSI/MSI-X
[   69.397177]  vdd: unknown partition table
[   69.401427] virtio-pci 0000:00:08.0: irq 48 for MSI/MSI-X
[   69.405304] virtio-pci 0000:00:08.0: irq 49 for MSI/MSI-X
[   69.426358]  vde: unknown partition table
[   69.430449] virtio-pci 0000:00:09.0: irq 50 for MSI/MSI-X
[   69.434129] virtio-pci 0000:00:09.0: irq 51 for MSI/MSI-X
[   69.455197]  vdf: unknown partition table
[   69.468945] drbd: initialized. Version: 8.3.13 (api:88/proto:86-96)
[   69.471412] drbd: built-in
[   69.472156] drbd: registered as block device major 147
[   69.473329] drbd: minor_table @ 0xffff880016447ef0
[   69.474517] rbd: loaded rbd (rados block device)
[   69.475718] ibmasm: IBM ASM Service Processor Driver version 1.0 loaded
[   69.477592] lkdtm: No crash points registered, enable through debugfs
[   69.479212] Phantom Linux Driver, version n0.9.8, init OK
[   69.480765] i2c-core: driver [apds9802als] using legacy suspend method
[   69.482183] i2c-core: driver [apds9802als] using legacy resume method
[   69.483754] i2c-core: driver [isl29003] using legacy suspend method
[   69.485183] i2c-core: driver [isl29003] using legacy resume method
[   69.486599] i2c-core: driver [tsl2550] using legacy suspend method
[   69.488071] i2c-core: driver [tsl2550] using legacy resume method
[   69.489471] Silicon Labs C2 port support v. 0.51.0 - (C) 2007 Rodolfo Giometti
[   69.491624] c2port c2port0: C2 port uc added
[   69.492664] c2port c2port0: uc flash has 30 blocks x 512 bytes (15360 bytes total)
[   69.495231] usbcore: registered new interface driver pn533
[   69.496518] Uniform Multi-Platform E-IDE driver
[   69.497911] piix 0000:00:01.1: IDE controller (0x8086:0x7010 rev 0x00)
[   69.499657] piix 0000:00:01.1: not 100% native mode: will probe irqs later
[   69.501212]     ide0: BM-DMA at 0xc000-0xc007
[   69.502289]     ide1: BM-DMA at 0xc008-0xc00f
[   69.503427] Probing IDE interface ide0...
[   70.072316] Probing IDE interface ide1...
[   70.812636] hdc: QEMU DVD-ROM, ATAPI CD/DVD-ROM drive
[   71.488741] hdc: host max PIO4 wanted PIO255(auto-tune) selected PIO0
[   71.491682] hdc: MWDMA2 mode selected
[   71.493027] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
[   71.494346] ide1 at 0x170-0x177,0x376 on irq 15
[   71.496647] ide_generic: please use "probe_mask=0x3f" module parameter for probing all legacy ISA IDE ports
[   71.498825] ide-gd driver 1.18
[   71.499699] ide-cd driver 5.00
[   71.500998] ide-cd: hdc: ATAPI 4X CD-ROM drive, 512kB Cache
[   71.502239] cdrom: Uniform CD-ROM driver Revision: 3.20
[   71.506202] Loading iSCSI transport class v2.0-870.
[   71.508384] rdac: device handler registered
[   71.509809] hp_sw: device handler registered
[   71.510976] emc: device handler registered
[   71.511956] alua: device handler registered
[   71.514799] fnic: Cisco FCoE HBA Driver, ver 1.5.0.2
[   71.516772] bnx2fc: Broadcom NetXtreme II FCoE Driver bnx2fc v1.0.11 (Apr 24, 2012)
[   71.519963] iscsi: registered transport (tcp)
[   71.521433] Loading Adaptec I2O RAID: Version 2.4 Build 5go
[   71.523003] Detecting Adaptec I2O RAID controllers...
[   71.524664] Adaptec aacraid driver 1.2-0[28900]-ms
[   71.526327] aic94xx: Adaptec aic94xx SAS/SATA driver version 1.0.3 loaded
[   71.528706] isci: Intel(R) C600 SAS Controller Driver - version 1.1.0
[   71.530647] scsi: <fdomain> Detection failed (no card)
[   71.532045] qla2xxx [0000:00:00.0]-0005: : QLogic Fibre Channel HBA Driver: 8.04.00.03-k.
[   71.534135] iscsi: registered transport (qla4xxx)
[   71.543594] QLogic iSCSI HBA Driver
[   71.544486] Brocade BFA FC/FCOE SCSI driver - version: 3.0.23.0
[   71.546152] DC390: clustering now enabled by default. If you get problems load
[   71.548031]        with "disable_clustering=1" and report to maintainers
[   71.549647] megaraid cmm: 2.20.2.7 (Release Date: Sun Jul 16 00:01:03 EST 2006)
[   71.551628] megaraid: 2.20.5.1 (Release Date: Thu Nov 16 15:32:35 EST 2006)
[   71.553203] megasas: 00.00.06.15-rc1 Mon. Mar. 19 17:00:00 PDT 2012
[   71.554684] mpt2sas version 13.100.00.00 loaded
[   71.556078] GDT-HA: Storage RAID Controller Driver. Version: 3.05
[   71.557617] 3ware Storage Controller device driver for Linux v1.26.02.003.
[   71.559240] 3ware 9000 Storage Controller device driver for Linux v2.26.02.014.
[   71.561026] LSI 3ware SAS/SATA-RAID Controller device driver for Linux v3.26.02.000.
[   71.562925] ppa: Version 2.07 (for Linux 2.4.x)
[   71.566415] imm: Version 2.05 (for Linux 2.4.0)
[   71.568196] ipr: IBM Power RAID SCSI Device Driver version: 2.5.3 (March 10, 2012)
[   71.569998] RocketRAID 3xxx/4xxx Controller driver v1.6 (090910)
[   71.571482] stex: Promise SuperTrak EX Driver version: 4.6.0000.4
[   71.573117] libcxgbi:libcxgbi_init_module: tag itt 0x1fff, 13 bits, age 0xf, 4 bits.
[   71.574986] libcxgbi:ddp_setup_host_page_size: system PAGE 4096, ddp idx 0.
[   71.576505] Chelsio T3 iSCSI Driver cxgb3i v2.0.0 (Jun. 2010)
[   71.577854] iscsi: registered transport (cxgb3i)
[   71.578991] Chelsio T4 iSCSI Driver cxgb4i v0.9.1 (Aug. 2010)
[   71.580362] iscsi: registered transport (cxgb4i)
[   71.581477] Broadcom NetXtreme II iSCSI Driver bnx2i v2.7.2.2 (Apr 25, 2012)
[   71.583111] iscsi: registered transport (bnx2i)
[   71.585124] iscsi: registered transport (be2iscsi)
[   71.586422] VMware PVSCSI driver - version 1.0.2.0-k
[   71.587711] hv_vmbus: registering driver hv_storvsc
[   71.588863] st: Version 20101219, fixed bufsize 32768, s/g segs 256
[   71.590286] osst :I: Tape driver with OnStream support version 0.99.4
[   71.590286] osst :I: $Id: osst.c,v 1.73 2005/01/01 21:13:34 wriede Exp $
[   71.593497] SCSI Media Changer driver v0.25 
[   71.594665] osd: LOADED open-osd 0.2.1
[   71.607853] scsi_debug: host protection
[   71.608830] scsi0 : scsi_debug, version 1.82 [20100324], dev_size_mb=8, opts=0x0
[   71.616297] Rounding down aligned max_sectors from 4294967295 to 8388600
[   71.618621] scsi 0:0:0:0: Direct-Access     Linux    scsi_debug       0004 PQ: 0 ANSI: 5
[   71.621977] sd 0:0:0:0: Attached scsi generic sg0 type 0
[   71.623896] scsi_scan_0 (135) used greatest stack depth: 4280 bytes left
[   71.625480] sd 0:0:0:0: [sda] 16384 512-byte logical blocks: (8.38 MB/8.00 MiB)
[   71.625536] SSFDC read-only Flash Translation layer
[   71.625539] mtdoops: mtd device (mtddev=name/number) must be supplied
[   71.625633] SBC-GXx flash: IO:0x258-0x259 MEM:0xdc000-0xdffff
[   71.625769] Could not find PAR responsible for SC520CDP Flash Bank #0
[   71.625770] Trying default address 0x8400000
[   71.625772] Could not find PAR responsible for SC520CDP Flash Bank #1
[   71.625773] Trying default address 0x8c00000
[   71.625773] Could not find PAR responsible for SC520CDP DIL Flash
[   71.625774] Trying default address 0x9400000
[   71.639346] SC520 CDP flash device: 0x800000 at 0x8400000
[   71.640058] sd 0:0:0:0: [sda] Write Protect is off
[   71.640060] sd 0:0:0:0: [sda] Mode Sense: 73 00 10 08
[   71.642989] Failed to ioremap_nocache
[   71.643908] NetSc520 flash device: 0x100000 at 0x200000
[   71.645102] Failed to ioremap_nocache
[   71.646000] Failed to ioremap_nocache
[   71.647067] Generic platform RAM MTD, (c) 2004 Simtec Electronics
[   71.648080] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, supports DPO and FUA
[   71.676085]  sda: unknown partition table
[   71.678417] No recognised DiskOnChip devices found
[   71.679705] slram: not enough parameters.
[   71.680705] Ramix PMC551 PCI Mezzanine Ram Driver. (C) 1999,2000 Nortel Networks.
[   71.682446] pmc551: not detected
[   71.687788] ftl_cs: FTL header not found.
[   71.692179] sd 0:0:0:0: [sda] Attached SCSI disk
[   71.723838] No valid DiskOnChip devices found
[   71.724933] [nandsim] warning: read_byte: unexpected data output cycle, state is STATE_READY return 0x0
[   71.727060] [nandsim] warning: read_byte: unexpected data output cycle, state is STATE_READY return 0x0
[   71.729195] [nandsim] warning: read_byte: unexpected data output cycle, state is STATE_READY return 0x0
[   71.731351] [nandsim] warning: read_byte: unexpected data output cycle, state is STATE_READY return 0x0
[   71.733443] [nandsim] warning: read_byte: unexpected data output cycle, state is STATE_READY return 0x0
[   71.735585] [nandsim] warning: read_byte: unexpected data output cycle, state is STATE_READY return 0x0
[   71.737691] NAND device: Manufacturer ID: 0x98, Chip ID: 0x39 (Toshiba NAND 128MiB 1,8V 8-bit), page size: 512, OOB size: 16
[   71.740188] flash size: 128 MiB
[   71.741010] page size: 512 bytes
[   71.741834] OOB area size: 16 bytes
[   71.742702] sector size: 16 KiB
[   71.743542] pages number: 262144
[   71.744373] pages per sector: 32
[   71.745194] bus width: 8
[   71.745887] bits in sector size: 14
[   71.746753] bits in page size: 9
[   71.747692] bits in OOB size: 4
[   71.748514] flash size with OOB: 135168 KiB
[   71.749510] page address bytes: 4
[   71.750336] sector address bytes: 3
[   71.751275] options: 0x42
[   71.755212] Scanning device for bad blocks
[   71.800173] Creating 1 MTD partitions on "NAND 128MiB 1,8V 8-bit":
[   71.801563] 0x000000000000-0x000008000000 : "NAND simulator partition 0"
[   71.803979] ftl_cs: FTL header not found.
[   71.806053] usbcore: registered new interface driver alauda
[   71.848040] onenand_wait: timeout! ctrl=0x0000 intr=0x0000
[   71.849296] OneNAND Manufacturer: Samsung (0xec)
[   71.850364] OneNAND 16MB 1.8V 16-bit (0x04)
[   71.851444] OneNAND version = 0x001e
[   71.852335] Lock scheme is Continuous Lock
[   71.853348] Scanning device for bad blocks
[   71.856616] Creating 1 MTD partitions on "OneNAND simulator":
[   71.857905] 0x000000000000-0x000001000000 : "OneNAND simulator partition"
[   71.860769] ftl_cs: FTL header not found.
[   71.976804] parport_pc 00:05: master is unqueued, this is deprecated
[   71.984783] parport0: AVR Butterfly
[   71.985701] parport0: cannot grant exclusive access for device spi-lm70llp
[   71.987277] spi-lm70llp: spi_lm70llp probe fail, status -12
[   71.988741] bonding: Ethernet Channel Bonding Driver: v3.7.1 (April 27, 2011)
[   71.993171] eql: Equalizer2002: Simon Janes (simon@ncm.com) and David S. Miller (davem@redhat.com)
[   71.997957] D-Link DE-620 pocket adapter io 0x378, which is busy.
[   72.001628] tun: Universal TUN/TAP device driver, 1.6
[   72.002788] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[   72.004812] arcnet loaded.
[   72.005592] arcnet: RFC1201 "standard" (`a') encapsulation support loaded.
[   72.007184] arcnet: RFC1051 "simple standard" (`s') encapsulation support loaded.
[   72.008936] arcnet: raw mode (`r') encapsulation support loaded.
[   72.010252] arcnet: cap mode (`c') encapsulation support loaded.
[   72.011695] arcnet: COM90xx chipset support
[   72.312646] S3: No ARCnet cards found.
[   72.315638] arcnet: COM90xx IO-mapped mode support (by David Woodhouse et el.)
[   72.320753] E-mail me if you actually test this driver, please!
[   72.322059]  arc%d: No autoprobe for IO mapped cards; you must specify the base address!
[   72.324174] arcnet: RIM I (entirely mem-mapped) support
[   72.325383] E-mail me if you actually test the RIM I driver, please!
[   72.326871] Given: node 00h, shmem 0h, irq 0
[   72.327910] No autoprobe for RIM I; you must specify the shmem and irq!
[   72.329392] arcnet: COM20020 PCI support
[   72.330553] ipddp.c:v0.01 8/28/97 Bradford W. Johnson <johns393@maroon.tc.umn.edu>
[   72.332748] ipddp0: Appletalk-IP Encap. mode by Bradford W. Johnson <johns393@maroon.tc.umn.edu>
[   72.334736] vcan: Virtual CAN interface driver
[   72.335912] slcan: serial line CAN interface driver
[   72.337075] slcan: 10 dynamic interface channels.
[   72.338165] CAN device driver interface
[   72.339321] usbcore: registered new interface driver ems_usb
[   72.340735] usbcore: registered new interface driver esd_usb2
[   72.342097] sja1000 CAN netdevice driver
[   72.344214] pcnet32: pcnet32.c:v1.35 21.Apr.2008 tsbogend@alpha.franken.de
[   72.345854] Atheros(R) L2 Ethernet Driver - version 2.2.3
[   72.347267] Copyright (c) 2007 Atheros Corporation.
[   72.348766] cnic: Broadcom NetXtreme II CNIC Driver cnic v2.5.10 (March 21, 2012)
[   72.350692] bnx2x: Broadcom NetXtreme II 5771x/578xx 10/20-Gigabit Ethernet Driver bnx2x 1.72.50-0 (2012/04/23)
[   72.353197] Brocade 10G Ethernet driver - version: 3.0.23.0
[   72.355100] enic: Cisco VIC Ethernet NIC Driver, ver 2.1.1.39
[   72.356567] dmfe: Davicom DM9xxx net driver, version 1.36.4 (2002-01-17)
[   72.358074] v1.01-e (2.4 port) Sep-11-2006  Donald Becker <becker@scyld.com>
[   72.358074]   http://www.scyld.com/network/drivers.html
[   72.361085] uli526x: ULi M5261/M5263 net driver, version 0.9.3 (2005-7-29)
[   72.362671] DE600: port 0x378 busy
[   72.363841] vxge: Copyright(c) 2002-2010 Exar Corp.
[   72.364982] vxge: Driver version: 2.5.3.22640-k
[   72.366203] e100: Intel(R) PRO/100 Network Driver, 3.5.24-k2-NAPI
[   72.367682] e100: Copyright(c) 1999-2006 Intel Corporation
[   72.369012] e1000: Intel(R) PRO/1000 Network Driver - version 7.3.21-k8-NAPI
[   72.370540] e1000: Copyright (c) 1999-2006 Intel Corporation.
[   72.371977] e1000 0000:00:03.0: setting latency timer to 64
[   72.700421] e1000 0000:00:03.0: eth0: (PCI:33MHz:32-bit) 52:54:00:12:34:56
[   72.710091] e1000 0000:00:03.0: eth0: Intel(R) PRO/1000 Network Connection
[   72.711770] e1000e: Intel(R) PRO/1000 Network Driver - 2.0.0-k
[   72.713078] e1000e: Copyright(c) 1999 - 2012 Intel Corporation.
[   72.714453] igb: Intel(R) Gigabit Ethernet Network Driver - version 3.4.7-k
[   72.716037] igb: Copyright (c) 2007-2012 Intel Corporation.
[   72.717355] igbvf: Intel(R) Gigabit Virtual Function Network Driver - version 2.0.1-k
[   72.719260] igbvf: Copyright (c) 2009 - 2012 Intel Corporation.
[   72.720699] ixgbe: Intel(R) 10 Gigabit PCI Express Network Driver - version 3.9.15-k
[   72.722487] ixgbe: Copyright (c) 1999-2012 Intel Corporation.
[   72.723967] ixgbevf: Intel(R) 10 Gigabit PCI Express Virtual Function Network Driver - version 2.6.0-k
[   72.726052] ixgbevf: Copyright (c) 2009 - 2012 Intel Corporation.
[   72.727581] ixgb: Intel(R) PRO/10GbE Network Driver - version 1.0.135-k2-NAPI
[   72.729117] ixgb: Copyright (c) 1999-2008 Intel Corporation.
[   72.730536] jme: JMicron JMC2XX ethernet driver version 1.0.8
[   72.732071] sky2: driver version 1.30
[   72.733578] myri10ge: Version 1.5.3-1.534
[   72.734736] ns83820.c: National Semiconductor DP83820 10/100/1000 driver.
[   72.736690] QLogic 1/10 GbE Converged/Intelligent Ethernet Driver v5.0.28
[   72.738609] QLogic/NetXen Network Driver v4.0.79
[   72.740031] atp.c:v1.09=ac 2002/10/01 Donald Becker <becker@scyld.com>
[   72.741938] Solarflare NET driver v3.1
[   72.743990] tehuti: Tehuti Networks(R) Network Driver, 7.29.3
[   72.745293] tehuti: Options: hw_csum 
[   72.746252] tlan: ThunderLAN driver v1.17
[   72.747359] tlan: 0 devices installed, PCI: 0  EISA: 0
[   72.748878] mkiss: AX.25 Multikiss, Hans Albas PE1AYX
[   72.750032] AX.25: 6pack driver, Revision: 0.3.0
[   72.751239] YAM driver version 0.8 by F1OAT/F6FBB
[   72.753805] AX.25: bpqether driver version 004
[   72.754961] baycom_ser_fdx: (C) 1996-2000 Thomas Sailer, HB9JNX/AE4WA
[   72.754961] baycom_ser_fdx: version 0.10
[   72.758643] hdlcdrv: (C) 1996-2000 Thomas Sailer HB9JNX/AE4WA
[   72.759965] hdlcdrv: version 0.8
[   72.760849] baycom_ser_hdx: (C) 1996-2000 Thomas Sailer, HB9JNX/AE4WA
[   72.760849] baycom_ser_hdx: version 0.10
[   72.764622] baycom_par: (C) 1996-2000 Thomas Sailer, HB9JNX/AE4WA
[   72.764622] baycom_par: version 0.9
[   72.768258] usbcore: registered new interface driver irda-usb
[   72.769608] usbcore: registered new interface driver stir4200
[   72.772131] usbcore: registered new interface driver mcs7780
[   72.773675] usbcore: registered new interface driver kingsun-sir
[   72.775091] usbcore: registered new interface driver ksdazzle-sir
[   72.776502] usbcore: registered new interface driver ks959-sir
[   72.778202] NET3 PLIP version 2.4-parport gniibe@mri.co.jp
[   72.779583] plip0: Parallel port at 0x378, using IRQ 7.
[   72.780792] PPP generic driver version 2.4.2
[   72.781993] PPP BSD Compression module registered
[   72.783148] PPP Deflate Compression module registered
[   72.786499] PPP MPPE Compression module registered
[   72.787733] NET: Registered protocol family 24
[   72.788828] PPTP driver version 0.8.5
[   72.790632] SLIP: version 0.8.4-NET3.019-NEWTTY (dynamic channels, max=256) (6 bit encapsulation enabled).
[   72.792780] CSLIP: code copyright 1989 Regents of the University of California.
[   72.794474] SLIP linefill/keepalive option.
[   72.795628] hdlc: HDLC support module revision 1.22
[   72.796951] DLCI driver v0.35, 4 Jan 1997, mike.mclagan@linux.org.
[   72.798338] cycx_drv: Cyclom 2X Support Module v0.6 (c) 1998-2003 Arnaldo Carvalho de Melo <acme@conectiva.com.br>
[   72.800681] cyclomx: CYCLOM 2X(tm) Sync Card Driver v0.11 (c) 1998-2003 Arnaldo Carvalho de Melo <acme@conectiva.com.br>
[   72.803246] ipw2200: Intel(R) PRO/Wireless 2200/2915 Network Driver, 1.2.2kmprq
[   72.804971] ipw2200: Copyright(c) 2003-2006 Intel Corporation
[   72.806321] libipw: 802.11 data/management/control stack, git-1.1.13
[   72.807802] libipw: Copyright (C) 2004-2005 Intel Corporation <jketreno@linux.intel.com>
[   72.809668] orinoco 0.15 (David Gibson <hermes@gibson.dropbear.id.au>, Pavel Roskin <proski@gnu.org>, et al)
[   72.812093] orinoco_plx 0.15 (Pavel Roskin <proski@gnu.org>, David Gibson <hermes@gibson.dropbear.id.au>, Daniel Barlow <dan@telent.net>)
[   72.814755] orinoco_tmd 0.15 (Joerg Dorchain <joerg@dorchain.net>)
[   72.816334] orinoco_nortel 0.15 (Tobias Hoffmann & Christoph Jungegger <disdos@traum404.de>)
[   72.818392] usbcore: registered new interface driver orinoco_usb
[   72.819832] airo(): Probing for PCI adapters
[   72.820957] airo(): Finished probing for PCI adapters
[   72.822243] Atmel at76x USB Wireless LAN Driver 0.17 loading
[   72.823648] usbcore: registered new interface driver at76c50x-usb
[   72.825345] Broadcom 43xx driver loaded [ Features: PMNLS ]
[   72.826653] Broadcom 43xx-legacy driver loaded [ Features: PLID ]
[   72.828386] usbcore: registered new interface driver zd1211rw
[   72.829800] usbcore: registered new interface driver rtl8187
[   72.831300] usbcore: registered new interface driver rtl8192cu
[   72.832980] usbcore: registered new interface driver rndis_wlan
[   72.834346] usbcore: registered new interface driver zd1201
[   72.835744] usbcore: registered new interface driver usb8xxx
[   72.837079] libertas_sdio: Libertas SDIO driver
[   72.838137] libertas_sdio: Copyright Pierre Ossman
[   72.839401] libertas_spi: Libertas SPI driver
[   72.840746] usbcore: registered new interface driver lbtf_usb
[   72.842165] Intel(R) Wireless WiFi driver for Linux, in-tree:
[   72.843527] Copyright(c) 2003-2012 Intel Corporation
[   72.844754] iwldvm: Intel(R) Wireless WiFi Link AGN driver for Linux, in-tree:
[   72.846423] iwldvm: Copyright(c) 2003-2012 Intel Corporation
[   72.847779] iwl4965: Intel(R) Wireless WiFi 4965 driver for Linux, in-tree:
[   72.849295] iwl4965: Copyright(c) 2003-2011 Intel Corporation
[   72.850692] iwl3945: Intel(R) PRO/Wireless 3945ABG/BG Network Connection driver for Linux, in-tree:s
[   72.852740] iwl3945: Copyright(c) 2003-2011 Intel Corporation
[   72.854386] usbcore: registered new interface driver rt2500usb
[   72.855824] usbcore: registered new interface driver rt73usb
[   72.857187] usbcore: registered new interface driver rt2800usb
[   72.858535] usbcore: registered new interface driver p54usb
[   72.860173] usbcore: registered new interface driver ath9k_htc
[   72.861551] usbcore: registered new interface driver carl9170
[   72.862898] mac80211_hwsim: Initializing radio 0
[   72.864155] ------------[ cut here ]------------
[   72.865235] WARNING: at /c/kernel-tests/net/net/wireless/core.c:471 wiphy_register+0x401/0x451()
[   72.867261] Hardware name: Bochs
[   72.868096] Modules linked in:
[   72.868885] Pid: 1, comm: swapper/0 Not tainted 3.5.0-rc1+ #4
[   72.870152] Call Trace:
[   72.870885]  [<ffffffff81090261>] warn_slowpath_common+0x83/0x9c
[   72.872241]  [<ffffffff81090294>] warn_slowpath_null+0x1a/0x1c
[   72.873542]  [<ffffffff82c293e3>] wiphy_register+0x401/0x451
[   72.874835]  [<ffffffff811758a0>] ? __kmalloc+0x128/0x13a
[   72.876069]  [<ffffffff82c46713>] ? ieee80211_register_hw+0x113/0x5dc
[   72.877473]  [<ffffffff82c469a4>] ieee80211_register_hw+0x3a4/0x5dc
[   72.878944]  [<ffffffff8464e113>] init_mac80211_hwsim+0x423/0x6a0
[   72.880294]  [<ffffffff8464dcf0>] ? carl9170_driver_init+0x1b/0x1b
[   72.881671]  [<ffffffff81002099>] do_one_initcall+0x7f/0x13a
[   72.882985]  [<ffffffff845f0d39>] kernel_init+0x170/0x1f8
[   72.884215]  [<ffffffff845f0590>] ? do_early_param+0x8c/0x8c
[   72.885483]  [<ffffffff82e516b4>] kernel_thread_helper+0x4/0x10
[   72.886787]  [<ffffffff82e498f0>] ? retint_restore_args+0x13/0x13
[   72.888244]  [<ffffffff845f0bc9>] ? start_kernel+0x3e7/0x3e7
[   72.889506]  [<ffffffff82e516b0>] ? gs_change+0x13/0x13
[   72.890695] ---[ end trace bd81035d49db0c0f ]---
[   72.891797] mac80211_hwsim: ieee80211_register_hw failed (-22)
[   72.893466] usbcore: registered new interface driver i2400m_usb
[   72.894810] VMware vmxnet3 virtual NIC driver - version 1.1.29.0-k-NAPI
[   72.896406] usbcore: registered new interface driver catc
[   72.897673] usbcore: registered new interface driver kaweth
[   72.898977] pegasus: v0.6.14 (2006/09/27), Pegasus/Pegasus II USB Ethernet driver
[   72.900792] usbcore: registered new interface driver pegasus
[   72.902119] usbcore: registered new interface driver rtl8150
[   72.903455] hso: /c/kernel-tests/net/drivers/net/usb/hso.c: Option Wireless
[   72.905048] usbcore: registered new interface driver hso
[   72.906304] usbcore: registered new interface driver asix
[   72.907651] usbcore: registered new interface driver cdc_ether
[   72.909027] usbcore: registered new interface driver cdc_eem
[   72.910337] usbcore: registered new interface driver dm9601
[   72.911804] usbcore: registered new interface driver smsc75xx
[   72.913159] usbcore: registered new interface driver smsc95xx
[   72.914505] usbcore: registered new interface driver gl620a
[   72.915932] usbcore: registered new interface driver net1080
[   72.917304] usbcore: registered new interface driver plusb
[   72.918586] usbcore: registered new interface driver rndis_host
[   72.920027] usbcore: registered new interface driver cdc_subset
[   72.921399] usbcore: registered new interface driver zaurus
[   72.922713] usbcore: registered new interface driver MOSCHIP usb-ethernet driver
[   72.924516] usbcore: registered new interface driver int51x1
[   72.925856] usbcore: registered new interface driver cdc_phonet
[   72.927310] usbcore: registered new interface driver kalmia
[   72.928654] usbcore: registered new interface driver ipheth
[   72.929957] usbcore: registered new interface driver sierra_net
[   72.931468] usbcore: registered new interface driver cx82310_eth
[   72.932856] usbcore: registered new interface driver cdc_ncm
[   72.934178] usbcore: registered new interface driver lg-vl600
[   72.935532] hv_vmbus: registering driver hv_netvsc
[   72.936790] Madge ATM Ambassador driver version 1.2.4
[   72.938023] Madge ATM Horizon [Ultra] driver version 1.2.1
[   72.939547] fore200e: FORE Systems 200E-series ATM driver - version 0.3e
[   72.941172] idt77252_init: at ffffffff8464f056
[   72.942282] Solos PCI Driver Version 0.07
[   72.943398] adummy: version 1.0
[   72.944671] I2O subsystem v1.325
[   72.945498] i2o: max drivers = 8
[   72.946998] I2O Configuration OSM v1.323
[   72.948127] I2O Bus Adapter OSM v1.317
[   72.949085] I2O Block Device OSM v1.325
[   72.959316] I2O SCSI Peripheral OSM v1.316
[   72.960365] I2O ProcFS OSM v1.316
[   72.961281] Fusion MPT base driver 3.04.20
[   72.962262] Copyright (c) 1999-2008 LSI Corporation
[   72.963524] Fusion MPT SPI Host driver 3.04.20
[   72.964695] Fusion MPT FC Host driver 3.04.20
[   72.965798] Fusion MPT SAS Host driver 3.04.20
[   72.966982] Fusion MPT misc device (ioctl) driver 3.04.20
[   72.968346] mptctl: Registered with Fusion MPT base driver
[   72.969588] mptctl: /dev/mptctl @ (major,minor=10,220)
[   72.970758] Fusion MPT LAN driver 3.04.20
[   72.973001] Generic UIO driver for PCI 2.3 devices version: 0.01.0
[   72.975541] aoe: AoE v47 initialised.
[   72.977508] usbcore: registered new interface driver hwa-rc
[   72.978803] usbcore: registered new interface driver i1480-dfu-usb
[   72.980549] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[   72.982076] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[   72.983672] uhci_hcd: USB Universal Host Controller Interface driver
[   72.985372] driver u132_hcd
[   72.986732] usbcore: registered new interface driver hwa-hc
[   72.988504] usbcore: registered new interface driver wusb-cbaf
[   72.989852] usbcore: registered new interface driver cdc_acm
[   72.991196] cdc_acm: USB Abstract Control Model driver for USB modems and ISDN adapters
[   72.993173] usbcore: registered new interface driver usblp
[   72.994488] usbcore: registered new interface driver cdc_wdm
[   72.995913] usbcore: registered new interface driver usbtmc
[   72.997249] usbcore: registered new interface driver uas
[   72.998461] Initializing USB Mass Storage driver...
[   72.999751] usbcore: registered new interface driver usb-storage
[   73.001115] USB Mass Storage support registered.
[   73.002231] usbcore: registered new interface driver ums-alauda
[   73.003669] usbcore: registered new interface driver ums-cypress
[   73.005057] usbcore: registered new interface driver ums-datafab
[   73.006529] usbcore: registered new interface driver ums_eneub6250
[   73.007998] usbcore: registered new interface driver ums-freecom
[   73.009394] usbcore: registered new interface driver ums-isd200
[   73.010766] usbcore: registered new interface driver ums-jumpshot
[   73.012265] usbcore: registered new interface driver ums-karma
[   73.013604] usbcore: registered new interface driver ums-onetouch
[   73.015104] usbcore: registered new interface driver ums-realtek
[   73.016533] usbcore: registered new interface driver ums-sddr09
[   73.017889] usbcore: registered new interface driver ums-sddr55
[   73.019372] usbcore: registered new interface driver ums-usbat
[   73.020783] usbcore: registered new interface driver mdc800
[   73.022020] mdc800: v0.7.5 (30/10/2000):USB Driver for Mustek MDC800 Digital Camera
[   73.023950] usbcore: registered new interface driver microtekX6
[   73.025431] usbcore: registered new interface driver usbserial
[   73.026776] usbcore: registered new interface driver usbserial_generic
[   73.028329] USB Serial support registered for generic
[   73.029485] usbserial: USB Serial Driver core
[   73.030566] usbcore: registered new interface driver aircable
[   73.031928] USB Serial support registered for aircable
[   73.033161] usbcore: registered new interface driver ark3116
[   73.034462] USB Serial support registered for ark3116
[   73.035723] usbcore: registered new interface driver belkin_sa
[   73.037086] USB Serial support registered for Belkin / Peracom / GoHubs USB Serial Adapter
[   73.039189] usbcore: registered new interface driver ch341
[   73.040490] USB Serial support registered for ch341-uart
[   73.041737] usbcore: registered new interface driver cp210x
[   73.043089] USB Serial support registered for cp210x
[   73.044311] usbcore: registered new interface driver cyberjack
[   73.045658] USB Serial support registered for Reiner SCT Cyberjack USB card reader
[   73.047569] usbcore: registered new interface driver cypress_m8
[   73.048942] USB Serial support registered for DeLorme Earthmate USB
[   73.050340] USB Serial support registered for HID->COM RS232 Adapter
[   73.051849] USB Serial support registered for Nokia CA-42 V2 Adapter
[   73.053301] usbcore: registered new interface driver usb_debug
[   73.054643] USB Serial support registered for debug
[   73.055844] usbcore: registered new interface driver digi_acceleport
[   73.057293] USB Serial support registered for Digi 2 port USB adapter
[   73.058745] USB Serial support registered for Digi 4 port USB adapter
[   73.060313] usbcore: registered new interface driver io_edgeport
[   73.061697] USB Serial support registered for Edgeport 2 port adapter
[   73.063269] USB Serial support registered for Edgeport 4 port adapter
[   73.064729] USB Serial support registered for Edgeport 8 port adapter
[   73.066171] USB Serial support registered for EPiC device
[   73.067574] usbcore: registered new interface driver io_ti
[   73.068863] USB Serial support registered for Edgeport TI 1 port adapter
[   73.070347] USB Serial support registered for Edgeport TI 2 port adapter
[   73.072044] usbcore: registered new interface driver empeg
[   73.073309] USB Serial support registered for empeg
[   73.074500] usbcore: registered new interface driver ftdi_sio
[   73.075957] USB Serial support registered for FTDI USB Serial Device
[   73.077358] ftdi_sio: v1.6.0:USB FTDI Serial Converters Driver
[   73.078699] usbcore: registered new interface driver funsoft
[   73.080048] USB Serial support registered for funsoft
[   73.081262] usbcore: registered new interface driver garmin_gps
[   73.082624] USB Serial support registered for Garmin GPS usb/tty
[   73.084107] usbcore: registered new interface driver hp4x
[   73.085356] USB Serial support registered for hp4X
[   73.086522] usbcore: registered new interface driver ipaq
[   73.087863] USB Serial support registered for PocketPC PDA
[   73.089170] usbcore: registered new interface driver ipw
[   73.090396] USB Serial support registered for IPWireless converter
[   73.091950] usbcore: registered new interface driver ir_usb
[   73.093264] USB Serial support registered for IR Dongle
[   73.094456] ir_usb: v0.5:USB IR Dongle driver
[   73.095670] usbcore: registered new interface driver iuu_phoenix
[   73.097051] USB Serial support registered for iuu_phoenix
[   73.098361] usbcore: registered new interface driver keyspan
[   73.099824] USB Serial support registered for Keyspan - (without firmware)
[   73.101384] USB Serial support registered for Keyspan 1 port adapter
[   73.102818] USB Serial support registered for Keyspan 2 port adapter
[   73.104296] USB Serial support registered for Keyspan 4 port adapter
[   73.105777] usbcore: registered new interface driver keyspan_pda
[   73.107285] USB Serial support registered for Keyspan PDA
[   73.108568] USB Serial support registered for Keyspan PDA - (prerenumeration)
[   73.110142] USB Serial support registered for Xircom / Entregra PGS - (prerenumeration)
[   73.112144] usbcore: registered new interface driver kl5kusb105
[   73.113493] USB Serial support registered for KL5KUSB105D / PalmConnect
[   73.115091] usbcore: registered new interface driver kobil_sct
[   73.116453] USB Serial support registered for KOBIL USB smart card terminal
[   73.118011] usbcore: registered new interface driver mct_u232
[   73.119397] USB Serial support registered for MCT U232
[   73.120663] usbcore: registered new interface driver mos7720
[   73.121971] USB Serial support registered for Moschip 2 port adapter
[   73.123501] usbcore: registered new interface driver mos7840
[   73.124820] USB Serial support registered for Moschip 7840/7820 USB Serial Driver
[   73.126597] usbcore: registered new interface driver moto_modem
[   73.127995] USB Serial support registered for moto-modem
[   73.129280] usbcore: registered new interface driver navman
[   73.130584] USB Serial support registered for navman
[   73.131818] usbcore: registered new interface driver omninet
[   73.133145] USB Serial support registered for ZyXEL - omni.net lcd plus usb
[   73.134705] usbcore: registered new interface driver opticon
[   73.136064] USB Serial support registered for opticon
[   73.137276] usbcore: registered new interface driver option
[   73.138582] USB Serial support registered for GSM modem (1-port)
[   73.139999] usbcore: registered new interface driver oti6858
[   73.141350] USB Serial support registered for oti6858
[   73.142564] usbcore: registered new interface driver pl2303
[   73.143894] USB Serial support registered for pl2303
[   73.145122] usbcore: registered new interface driver qcaux
[   73.146387] USB Serial support registered for qcaux
[   73.147715] usbcore: registered new interface driver qcserial
[   73.149051] USB Serial support registered for Qualcomm USB modem
[   73.150374] safe_serial: v0.1:USB Safe Encapsulated Serial
[   73.151809] usbcore: registered new interface driver safe_serial
[   73.153200] USB Serial support registered for safe_serial
[   73.154495] usbcore: registered new interface driver siemens_mpi
[   73.155989] USB Serial support registered for siemens_mpi
[   73.157333] usbcore: registered new interface driver sierra
[   73.158619] USB Serial support registered for Sierra USB modem
[   73.160055] usbcore: registered new interface driver spcp8x5
[   73.161372] USB Serial support registered for SPCP8x5
[   73.162585] usbcore: registered new interface driver ssu100
[   73.163911] USB Serial support registered for Quatech SSU-100 USB to Serial Driver
[   73.165749] usbcore: registered new interface driver symbolserial
[   73.167254] USB Serial support registered for symbol
[   73.168473] usbcore: registered new interface driver ti_usb_3410_5052
[   73.169907] USB Serial support registered for TI USB 3410 1 port adapter
[   73.171550] USB Serial support registered for TI USB 5052 2 port adapter
[   73.173011] ti_usb_3410_5052: v0.10:TI USB 3410/5052 Serial Driver
[   73.174430] usbcore: registered new interface driver visor
[   73.175795] USB Serial support registered for Handspring Visor / Palm OS
[   73.177302] USB Serial support registered for Sony Clie 5.0
[   73.178604] USB Serial support registered for Sony Clie 3.5
[   73.179944] usbcore: registered new interface driver whiteheat
[   73.181310] USB Serial support registered for Connect Tech - WhiteHEAT - (prerenumeration)
[   73.183299] USB Serial support registered for Connect Tech - WhiteHEAT
[   73.184813] usbcore: registered new interface driver vivopay_serial
[   73.186218] USB Serial support registered for vivopay-serial
[   73.187675] usbcore: registered new interface driver zio
[   73.188936] USB Serial support registered for zio
[   73.190089] usbcore: registered new interface driver adutux
[   73.192004] usbcore: registered new interface driver appledisplay
[   73.193446] usbcore: registered new interface driver cypress_cy7c63
[   73.194938] usbcore: registered new interface driver cytherm
[   73.196261] usbcore: registered new interface driver emi26 - firmware loader
[   73.197828] usbcore: registered new interface driver emi62 - firmware loader
[   73.199412] driver ftdi-elan
[   73.201915] usbcore: registered new interface driver ftdi-elan
[   73.211562] usbcore: registered new interface driver idmouse
[   73.212910] usbcore: registered new interface driver iowarrior
[   73.214260] usbcore: registered new interface driver isight_firmware
[   73.215783] usbcore: registered new interface driver usblcd
[   73.217102] usbcore: registered new interface driver ldusb
[   73.218472] usbcore: registered new interface driver usbled
[   73.219878] usbcore: registered new interface driver legousbtower
[   73.221326] usbcore: registered new interface driver rio500
[   73.222674] usbcore: registered new interface driver usbtest
[   73.224058] usbcore: registered new interface driver trancevibrator
[   73.225488] usbcore: registered new interface driver uss720
[   73.226729] uss720: v0.6:USB Parport Cable driver for Cables using the Lucent Technologies USS720 Chip
[   73.228782] uss720: NOTE: this is a special purpose driver to allow nonstandard
[   73.230479] uss720: protocols (eg. bitbang) over USS720 usb to parallel cables
[   73.232209] uss720: If you just want to connect to a printer, use usblp instead
[   73.233967] usbcore: registered new interface driver usbsevseg
[   73.235368] usbcore: registered new interface driver yurex
[   73.236679] usbcore: registered new interface driver sisusb
[   73.237987] usbcore: registered new interface driver cxacru
[   73.239359] usbcore: registered new interface driver speedtch
[   73.240737] usbcore: registered new interface driver ueagle-atm
[   73.242040] xusbatm: malformed module parameters
[   73.243289] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
[   73.246194] serio: i8042 KBD port at 0x60,0x64 irq 1
[   73.247529] serio: i8042 AUX port at 0x60,0x64 irq 12
[   73.249049] parport0: cannot grant exclusive access for device parkbd
[   73.317256] mousedev: PS/2 mouse device common for all mice
[   73.319642] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input1
[   73.322194] usbcore: registered new interface driver appletouch
[   73.326161] usbcore: registered new interface driver bcm5974
[   73.333638] usbcore: registered new interface driver iforce
[   73.337091] usbcore: registered new interface driver xpad
[   73.338431] parport0: cannot grant exclusive access for device walkera0701
[   73.340150] usbcore: registered new interface driver usb_acecad
[   73.341566] usbcore: registered new interface driver aiptek
[   73.342955] usbcore: registered new interface driver gtco
[   73.344258] usbcore: registered new interface driver hanwang
[   73.345587] usbcore: registered new interface driver kbtab
[   73.346954] usbcore: registered new interface driver wacom
[   73.348743] mk712: device not present
[   73.349710] usbcore: registered new interface driver usbtouchscreen
[   73.351627] apanel: Fujitsu BIOS signature 'FJKEYINF' not found...
[   73.353075] usbcore: registered new interface driver ati_remote2
[   73.354472] cm109: Keymap for Komunikate KIP1000 phone loaded
[   73.355934] usbcore: registered new interface driver cm109
[   73.357182] cm109: CM109 phone driver: 20080805 (C) Alfred E. Heggestad
[   73.358688] usbcore: registered new interface driver keyspan_remote
[   73.360309] input: PC Speaker as /devices/platform/pcspkr/input/input2
[   73.362269] usbcore: registered new interface driver powermate
[   73.364200] usbcore: registered new interface driver yealink
[   73.366575] rtc_cmos 00:01: rtc core: registered rtc_cmos as rtc0
[   73.368135] rtc0: alarms up to one day, 114 bytes nvram, hpet irqs
[   73.371362] rtc-test rtc-test.0: rtc core: registered test as rtc1
[   73.373363] rtc-test rtc-test.1: rtc core: registered test as rtc2
[   73.374855] i2c /dev entries driver
[   73.376467] piix4_smbus 0000:00:01.3: SMBus Host Controller at 0xb100, revision 0
[   73.489717] usbcore: registered new interface driver i2c-diolan-u2c
[   73.491809] i2c-parport: adapter type unspecified
[   73.492925] i2c-parport-light: adapter type unspecified
[   73.494213] usbcore: registered new interface driver i2c-tiny-usb
[   73.495801] lirc_dev: IR Remote Control driver registered, major 222 
[   73.497246] IR NEC protocol handler initialized
[   73.498304] IR RC5(x) protocol handler initialized
[   73.499490] IR RC6 protocol handler initialized
[   73.500571] IR JVC protocol handler initialized
[   73.501628] IR Sony protocol handler initialized
[   73.502697] IR RC5 (streamzap) protocol handler initialized
[   73.503978] IR SANYO protocol handler initialized
[   73.505090] IR MCE Keyboard/mouse protocol handler initialized
[   73.506375] IR LIRC bridge handler initialized
[   73.507565] usbcore: registered new interface driver imon
[   73.508900] usbcore: registered new interface driver mceusb
[   73.510341] usbcore: registered new interface driver redrat3
[   73.511751] usbcore: registered new interface driver streamzap
[   73.513134] Registered IR keymap rc-empty
[   73.514366] input: rc-core loopback device as /devices/virtual/rc/rc0/input3
[   73.516550] rc0: rc-core loopback device as /devices/virtual/rc/rc0
[   73.518903] input: MCE IR Keyboard/Mouse (rc-loopback) as /devices/virtual/input/input4
[   73.522384] rc rc0: lirc_dev: driver ir-lirc-codec (rc-loopback) registered at minor = 0
[   73.525507] bttv: driver version 0.9.19 loaded
[   73.526557] bttv: using 8 buffers with 2080k (520 pages) each for capture
[   73.528071] bttv: Host bridge needs ETBF enabled
[   73.529291] Zoran MJPEG board driver version 0.10.1
[   73.530507] Linux video codec intermediate layer: v0.2
[   73.531787] meye: using 2 buffers with 600k (1200k total) for capture
[   73.533338] saa7130/34: v4l2 driver version 0, 2, 17 loaded
[   73.534709] cx88/0: cx2388x v4l2 driver version 0.0.9 loaded
[   73.536183] cx88/2: cx2388x MPEG-TS Driver Manager version 0.0.9 loaded
[   73.537770] cx2388x alsa driver version 0.0.9 loaded
[   73.539023] cx2388x blackbird driver version 0.0.9 loaded
[   73.540281] cx88/2: registering cx8802 driver, type: blackbird access: shared
[   73.541849] cx88/2: cx2388x dvb driver version 0.0.9 loaded
[   73.543176] cx88/2: registering cx8802 driver, type: dvb access: shared
[   73.544688] usbcore: registered new interface driver em28xx
[   73.545951] Em28xx: Initialized (Em28xx Audio Extension) extension
[   73.547460] Em28xx: Initialized (Em28xx dvb Extension) extension
[   73.548797] Em28xx: Initialized (Em28xx Input Extension) extension
[   73.550227] usbcore: registered new interface driver poseidon
[   73.551665] usbcore: registered new interface driver cx231xx
[   73.552963] cx231xx: Cx231xx Audio Extension initialized
[   73.554162] cx231xx: Cx231xx dvb Extension initialized
[   73.555485] usbcore: registered new interface driver usbvision
[   73.556791] USBVision USB Video Device Driver for Linux : 0.9.11
[   73.558532] usbcore: registered new interface driver pvrusb2
[   73.559842] pvrusb2: V4L in-tree version:Hauppauge WinTV-PVR-USB2 MPEG2 Encoder/Tuner
[   73.561674] pvrusb2: Debug mask is 31 (0x1f)
[   73.562683] cpia2: V4L-Driver for Vision CPiA2 based cameras v3.0.1
[   73.564164] usbcore: registered new interface driver cpia2
[   73.565479] usbcore: registered new interface driver tm6000
[   73.566748] saa7146: register extension 'Multimedia eXtension Board'
[   73.568369] saa7146: register extension 'hexium HV-PCI6 Orion'
[   73.569823] saa7146: register extension 'hexium gemini'
[   73.571184] usbcore: registered new interface driver zr364xx
[   73.572538] usbcore: registered new interface driver stkwebcam
[   73.573883] usbcore: registered new interface driver sn9c102
[   73.575337] usbcore: registered new interface driver Philips webcam
[   73.576732] gspca_main: v2.14.0 registered
[   73.577897] usbcore: registered new interface driver benq
[   73.579252] usbcore: registered new interface driver conex
[   73.580588] usbcore: registered new interface driver cpia1
[   73.581865] usbcore: registered new interface driver etoms
[   73.583276] usbcore: registered new interface driver finepix
[   73.584618] usbcore: registered new interface driver jeilinj
[   73.585941] usbcore: registered new interface driver kinect
[   73.587365] usbcore: registered new interface driver konica
[   73.588692] usbcore: registered new interface driver mars
[   73.589975] usbcore: registered new interface driver mr97310a
[   73.591396] usbcore: registered new interface driver nw80x
[   73.592720] usbcore: registered new interface driver ov519
[   73.594007] usbcore: registered new interface driver ov534
[   73.595356] usbcore: registered new interface driver ov534_9
[   73.596707] usbcore: registered new interface driver pac207
[   73.598016] usbcore: registered new interface driver gspca_pac7302
[   73.599569] usbcore: registered new interface driver pac7311
[   73.600918] usbcore: registered new interface driver se401
[   73.602212] usbcore: registered new interface driver sn9c2028
[   73.603630] usbcore: registered new interface driver gspca_sn9c20x
[   73.605055] usbcore: registered new interface driver sonixb
[   73.606351] usbcore: registered new interface driver sonixj
[   73.607799] usbcore: registered new interface driver spca500
[   73.609134] usbcore: registered new interface driver spca501
[   73.610468] usbcore: registered new interface driver spca505
[   73.611917] usbcore: registered new interface driver spca506
[   73.613250] usbcore: registered new interface driver spca508
[   73.614578] usbcore: registered new interface driver spca561
[   73.615936] usbcore: registered new interface driver spca1528
[   73.617299] usbcore: registered new interface driver sq905
[   73.618604] usbcore: registered new interface driver sq905c
[   73.619947] usbcore: registered new interface driver sq930x
[   73.621290] usbcore: registered new interface driver sunplus
[   73.622611] usbcore: registered new interface driver stk014
[   73.623968] usbcore: registered new interface driver stv0680
[   73.625303] usbcore: registered new interface driver t613
[   73.626582] usbcore: registered new interface driver tv8532
[   73.627973] usbcore: registered new interface driver vc032x
[   73.629289] usbcore: registered new interface driver vicam
[   73.630610] usbcore: registered new interface driver xirlink-cit
[   73.632091] usbcore: registered new interface driver gspca_zc3xx
[   73.633496] usbcore: registered new interface driver ALi m5602
[   73.634846] usbcore: registered new interface driver STV06xx
[   73.636174] usbcore: registered new interface driver gspca_gl860
[   73.637643] usbcore: registered new interface driver hdpvr
[   73.638975] usbcore: registered new interface driver s2255
[   73.640224] ivtv: Start initialization, version 1.4.3
[   73.641485] ivtv: End initialization
[   73.642377] ivtvfb:  no cards found
[   73.643380] cx18:  Start initialization, version 1.5.1
[   73.644654] cx18:  End initialization
[   73.645561] cx18-alsa: module loading...
[   73.647109] vivi-000: V4L2 device registered as video0
[   73.656444] Video Technology Magazine Virtual Video Capture Board ver 0.8.1 successfully loaded.
[   73.658403] cx23885 driver version 0.0.3 loaded
[   73.659647] au0828 driver loaded
[   73.660571] usbcore: registered new interface driver au0828
[   73.661907] usbcore: registered new interface driver uvcvideo
[   73.663249] USB Video Class driver (1.1.1)
[   73.664243] saa7164 driver loaded
[   73.665446] usbcore: registered new interface driver dsbr100
[   73.666775] usbcore: registered new interface driver radio-si470x
[   73.668289] usbcore: registered new interface driver radio-mr800
[   73.669829] saa7146: register extension 'budget dvb'
[   73.671090] saa7146: register extension 'budget_av'
[   73.672318] saa7146: register extension 'budget_ci dvb'
[   73.673588] saa7146: register extension 'budget_patch dvb'
[   73.674958] saa7146: register extension 'av7110'
[   73.676177] usbcore: registered new interface driver ttusb-dec
[   73.677546] usbcore: registered new interface driver ttusb
[   73.678781] b2c2-flexcop: B2C2 FlexcopII/II(b)/III digital TV receiver chip loaded successfully
[   73.680940] usbcore: registered new interface driver b2c2_flexcop_usb
[   73.682339] bt878: AUDIO driver version 0.0.0 loaded
[   73.683741] usbcore: registered new interface driver dvb_usb_vp7045
[   73.685211] usbcore: registered new interface driver dvb_usb_vp702x
[   73.686688] usbcore: registered new interface driver dvb_usb_gp8psk
[   73.688184] usbcore: registered new interface driver dvb_usb_dtt200u
[   73.689642] usbcore: registered new interface driver dvb_usb_a800
[   73.691102] usbcore: registered new interface driver dvb_usb_dibusb_mb
[   73.692603] usbcore: registered new interface driver dvb_usb_dibusb_mc
[   73.694083] usbcore: registered new interface driver dvb_usb_nova_t_usb2
[   73.695681] usbcore: registered new interface driver dvb_usb_umt_010
[   73.697150] usbcore: registered new interface driver dvb_usb_m920x
[   73.698571] usbcore: registered new interface driver dvb_usb_gl861
[   73.700058] usbcore: registered new interface driver dvb_usb_au6610
[   73.701536] usbcore: registered new interface driver dvb_usb_digitv
[   73.703072] usbcore: registered new interface driver dvb_usb_cxusb
[   73.704556] usbcore: registered new interface driver dvb_usb_ttusb2
[   73.705979] usbcore: registered new interface driver dvb_usb_dib0700
[   73.707511] usbcore: registered new interface driver opera1
[   73.708831] usbcore: registered new interface driver dvb_usb_af9005
[   73.710310] usbcore: registered new interface driver dvb_usb_anysee
[   73.711850] usbcore: registered new interface driver dw2102
[   73.713180] usbcore: registered new interface driver dvb_usb_dtv5100
[   73.714648] usbcore: registered new interface driver dvb_usb_af9015
[   73.716143] usbcore: registered new interface driver cinergyT2
[   73.717526] usbcore: registered new interface driver dvb_usb_ce6230
[   73.719032] usbcore: registered new interface driver dvb_usb_friio
[   73.720502] usbcore: registered new interface driver dvb_usb_ec168
[   73.721941] usbcore: registered new interface driver dvb_usb_az6027
[   73.723501] usbcore: registered new interface driver LME2510C_DVB-S
[   73.724972] usbcore: registered new interface driver dvb_usb_technisat_usb2
[   73.726537] usbcore: registered new interface driver it913x
[   73.728036] usbcore: registered new interface driver smsusb
[   73.729282] smssdio: Siano SMS1xxx SDIO driver
[   73.730320] smssdio: Copyright Pierre Ossman
[   73.731839] nGene PCIE bridge driver, Copyright (C) 2005-2007 Micronas
[   73.733394] pps_ldisc: PPS line discipline registered
[   73.734554] pps_parport: parallel port PPS client
[   73.735715] parport0: cannot grant exclusive access for device pps_parport
[   73.737209] pps_parport: couldn't register with parport0
[   73.738404] Driver for 1-wire Dallas network protocol.
[   73.739867] usbcore: registered new interface driver DS9490R
[   73.741247] 1-Wire driver for the DS2760 battery monitor  chip  - (c) 2004-2005, Szabolcs Gyurko
[   73.743513] i2c-core: driver [max17040] using legacy suspend method
[   73.744903] i2c-core: driver [max17040] using legacy resume method
[   73.775976] input: ImExPS/2 Generic Explorer Mouse as /devices/platform/i8042/serio1/input/input5
[   75.036292] i2c i2c-0: detect fail: address match, 0x2c
[   75.056264] i2c i2c-0: detect fail: address match, 0x2d
[   75.076263] i2c i2c-0: detect fail: address match, 0x2e
[   75.096275] i2c i2c-0: detect fail: address match, 0x2f
[   75.364242] applesmc: supported laptop not found!
[   75.367828] applesmc: driver init failed (ret=-19)!

--5vNYLRcllDrimb99
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="config-3.5.0-rc1+"

#
# Automatically generated file; DO NOT EDIT.
# Linux/x86_64 3.5.0-rc1 Kernel Configuration
#
CONFIG_64BIT=y
# CONFIG_X86_32 is not set
CONFIG_X86_64=y
CONFIG_X86=y
CONFIG_INSTRUCTION_DECODER=y
CONFIG_OUTPUT_FORMAT="elf64-x86-64"
CONFIG_ARCH_DEFCONFIG="arch/x86/configs/x86_64_defconfig"
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_HAVE_LATENCYTOP_SUPPORT=y
CONFIG_MMU=y
CONFIG_NEED_DMA_MAP_STATE=y
CONFIG_NEED_SG_DMA_LENGTH=y
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_BUG_RELATIVE_POINTERS=y
CONFIG_GENERIC_HWEIGHT=y
CONFIG_GENERIC_GPIO=y
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
# CONFIG_RWSEM_GENERIC_SPINLOCK is not set
CONFIG_RWSEM_XCHGADD_ALGORITHM=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
CONFIG_ARCH_HAS_CPU_RELAX=y
CONFIG_ARCH_HAS_DEFAULT_IDLE=y
CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
CONFIG_ARCH_HAS_CPU_AUTOPROBE=y
CONFIG_HAVE_SETUP_PER_CPU_AREA=y
CONFIG_NEED_PER_CPU_EMBED_FIRST_CHUNK=y
CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK=y
CONFIG_ARCH_HIBERNATION_POSSIBLE=y
CONFIG_ARCH_SUSPEND_POSSIBLE=y
CONFIG_ZONE_DMA32=y
CONFIG_AUDIT_ARCH=y
CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
CONFIG_HAVE_INTEL_TXT=y
CONFIG_X86_64_SMP=y
CONFIG_X86_HT=y
CONFIG_ARCH_HWEIGHT_CFLAGS="-fcall-saved-rdi -fcall-saved-rsi -fcall-saved-rdx -fcall-saved-rcx -fcall-saved-r8 -fcall-saved-r9 -fcall-saved-r10 -fcall-saved-r11"
CONFIG_ARCH_CPU_PROBE_RELEASE=y
CONFIG_ARCH_SUPPORTS_UPROBES=y
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
CONFIG_HAVE_IRQ_WORK=y
CONFIG_IRQ_WORK=y
CONFIG_BUILDTIME_EXTABLE_SORT=y

#
# General setup
#
CONFIG_EXPERIMENTAL=y
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_CROSS_COMPILE=""
CONFIG_LOCALVERSION=""
# CONFIG_LOCALVERSION_AUTO is not set
CONFIG_HAVE_KERNEL_GZIP=y
CONFIG_HAVE_KERNEL_BZIP2=y
CONFIG_HAVE_KERNEL_LZMA=y
CONFIG_HAVE_KERNEL_XZ=y
CONFIG_HAVE_KERNEL_LZO=y
CONFIG_KERNEL_GZIP=y
# CONFIG_KERNEL_BZIP2 is not set
# CONFIG_KERNEL_LZMA is not set
# CONFIG_KERNEL_XZ is not set
# CONFIG_KERNEL_LZO is not set
CONFIG_DEFAULT_HOSTNAME="(none)"
CONFIG_SWAP=y
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
CONFIG_POSIX_MQUEUE=y
CONFIG_POSIX_MQUEUE_SYSCTL=y
CONFIG_BSD_PROCESS_ACCT=y
CONFIG_BSD_PROCESS_ACCT_V3=y
CONFIG_FHANDLE=y
CONFIG_TASKSTATS=y
CONFIG_TASK_DELAY_ACCT=y
CONFIG_TASK_XACCT=y
CONFIG_TASK_IO_ACCOUNTING=y
CONFIG_AUDIT=y
CONFIG_AUDITSYSCALL=y
CONFIG_AUDIT_WATCH=y
CONFIG_AUDIT_TREE=y
# CONFIG_AUDIT_LOGINUID_IMMUTABLE is not set
CONFIG_HAVE_GENERIC_HARDIRQS=y

#
# IRQ subsystem
#
CONFIG_GENERIC_HARDIRQS=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_IRQ_SHOW=y
CONFIG_GENERIC_PENDING_IRQ=y
CONFIG_GENERIC_IRQ_CHIP=y
CONFIG_IRQ_FORCED_THREADING=y
CONFIG_SPARSE_IRQ=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_ARCH_CLOCKSOURCE_DATA=y
CONFIG_GENERIC_TIME_VSYSCALL=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
CONFIG_GENERIC_CLOCKEVENTS_MIN_ADJUST=y
CONFIG_GENERIC_CMOS_UPDATE=y

#
# Timers subsystem
#
CONFIG_TICK_ONESHOT=y
CONFIG_NO_HZ=y
CONFIG_HIGH_RES_TIMERS=y

#
# RCU Subsystem
#
CONFIG_TREE_RCU=y
# CONFIG_PREEMPT_RCU is not set
CONFIG_RCU_FANOUT=64
CONFIG_RCU_FANOUT_LEAF=16
# CONFIG_RCU_FANOUT_EXACT is not set
CONFIG_RCU_FAST_NO_HZ=y
CONFIG_TREE_RCU_TRACE=y
# CONFIG_IKCONFIG is not set
CONFIG_LOG_BUF_SHIFT=17
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_CGROUPS=y
# CONFIG_CGROUP_DEBUG is not set
CONFIG_CGROUP_FREEZER=y
CONFIG_CGROUP_DEVICE=y
CONFIG_CPUSETS=y
CONFIG_PROC_PID_CPUSET=y
CONFIG_CGROUP_CPUACCT=y
CONFIG_RESOURCE_COUNTERS=y
CONFIG_CGROUP_MEM_RES_CTLR=y
CONFIG_CGROUP_MEM_RES_CTLR_SWAP=y
# CONFIG_CGROUP_MEM_RES_CTLR_SWAP_ENABLED is not set
# CONFIG_CGROUP_MEM_RES_CTLR_KMEM is not set
# CONFIG_CGROUP_PERF is not set
CONFIG_CGROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
# CONFIG_CFS_BANDWIDTH is not set
# CONFIG_RT_GROUP_SCHED is not set
CONFIG_BLK_CGROUP=y
# CONFIG_DEBUG_BLK_CGROUP is not set
# CONFIG_CHECKPOINT_RESTORE is not set
CONFIG_NAMESPACES=y
CONFIG_UTS_NS=y
CONFIG_IPC_NS=y
CONFIG_PID_NS=y
CONFIG_NET_NS=y
CONFIG_SCHED_AUTOGROUP=y
CONFIG_MM_OWNER=y
# CONFIG_SYSFS_DEPRECATED is not set
CONFIG_RELAY=y
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
CONFIG_RD_BZIP2=y
CONFIG_RD_LZMA=y
CONFIG_RD_XZ=y
CONFIG_RD_LZO=y
CONFIG_CC_OPTIMIZE_FOR_SIZE=y
CONFIG_SYSCTL=y
CONFIG_ANON_INODES=y
# CONFIG_EXPERT is not set
CONFIG_UID16=y
# CONFIG_SYSCTL_SYSCALL is not set
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_HOTPLUG=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
CONFIG_PCSPKR_PLATFORM=y
CONFIG_HAVE_PCSPKR_PLATFORM=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
CONFIG_AIO=y
# CONFIG_EMBEDDED is not set
CONFIG_HAVE_PERF_EVENTS=y

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
# CONFIG_DEBUG_PERF_USE_VMALLOC is not set
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_PCI_QUIRKS=y
# CONFIG_COMPAT_BRK is not set
CONFIG_SLAB=y
# CONFIG_SLUB is not set
CONFIG_PROFILING=y
CONFIG_TRACEPOINTS=y
CONFIG_OPROFILE=y
# CONFIG_OPROFILE_EVENT_MULTIPLEX is not set
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
CONFIG_KPROBES=y
# CONFIG_JUMP_LABEL is not set
CONFIG_OPTPROBES=y
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_KRETPROBES=y
CONFIG_USER_RETURN_NOTIFIER=y
CONFIG_HAVE_IOREMAP_PROT=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_HAVE_OPTPROBES=y
CONFIG_HAVE_ARCH_TRACEHOOK=y
CONFIG_HAVE_DMA_ATTRS=y
CONFIG_USE_GENERIC_SMP_HELPERS=y
CONFIG_GENERIC_SMP_IDLE_THREAD=y
CONFIG_HAVE_REGS_AND_STACK_ACCESS_API=y
CONFIG_HAVE_DMA_API_DEBUG=y
CONFIG_HAVE_HW_BREAKPOINT=y
CONFIG_HAVE_MIXED_BREAKPOINTS_REGS=y
CONFIG_HAVE_USER_RETURN_NOTIFIER=y
CONFIG_HAVE_PERF_EVENTS_NMI=y
CONFIG_HAVE_ARCH_JUMP_LABEL=y
CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG=y
CONFIG_HAVE_CMPXCHG_LOCAL=y
CONFIG_HAVE_CMPXCHG_DOUBLE=y
CONFIG_ARCH_WANT_OLD_COMPAT_IPC=y
CONFIG_HAVE_ARCH_SECCOMP_FILTER=y
CONFIG_SECCOMP_FILTER=y

#
# GCOV-based kernel profiling
#
# CONFIG_GCOV_KERNEL is not set
# CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
CONFIG_MODULES=y
CONFIG_MODULE_FORCE_LOAD=y
CONFIG_MODULE_UNLOAD=y
CONFIG_MODULE_FORCE_UNLOAD=y
CONFIG_MODVERSIONS=y
# CONFIG_MODULE_SRCVERSION_ALL is not set
CONFIG_STOP_MACHINE=y
CONFIG_BLOCK=y
CONFIG_BLK_DEV_BSG=y
CONFIG_BLK_DEV_BSGLIB=y
CONFIG_BLK_DEV_INTEGRITY=y
# CONFIG_BLK_DEV_THROTTLING is not set

#
# Partition Types
#
CONFIG_PARTITION_ADVANCED=y
CONFIG_ACORN_PARTITION=y
# CONFIG_ACORN_PARTITION_CUMANA is not set
# CONFIG_ACORN_PARTITION_EESOX is not set
CONFIG_ACORN_PARTITION_ICS=y
# CONFIG_ACORN_PARTITION_ADFS is not set
# CONFIG_ACORN_PARTITION_POWERTEC is not set
CONFIG_ACORN_PARTITION_RISCIX=y
CONFIG_OSF_PARTITION=y
CONFIG_AMIGA_PARTITION=y
CONFIG_ATARI_PARTITION=y
CONFIG_MAC_PARTITION=y
CONFIG_MSDOS_PARTITION=y
CONFIG_BSD_DISKLABEL=y
CONFIG_MINIX_SUBPARTITION=y
CONFIG_SOLARIS_X86_PARTITION=y
CONFIG_UNIXWARE_DISKLABEL=y
CONFIG_LDM_PARTITION=y
# CONFIG_LDM_DEBUG is not set
CONFIG_SGI_PARTITION=y
CONFIG_ULTRIX_PARTITION=y
CONFIG_SUN_PARTITION=y
CONFIG_KARMA_PARTITION=y
CONFIG_EFI_PARTITION=y
# CONFIG_SYSV68_PARTITION is not set
CONFIG_BLOCK_COMPAT=y

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_DEADLINE=y
CONFIG_IOSCHED_CFQ=y
CONFIG_CFQ_GROUP_IOSCHED=y
# CONFIG_DEFAULT_DEADLINE is not set
CONFIG_DEFAULT_CFQ=y
# CONFIG_DEFAULT_NOOP is not set
CONFIG_DEFAULT_IOSCHED="cfq"
CONFIG_PREEMPT_NOTIFIERS=y
CONFIG_PADATA=y
# CONFIG_INLINE_SPIN_TRYLOCK is not set
# CONFIG_INLINE_SPIN_TRYLOCK_BH is not set
# CONFIG_INLINE_SPIN_LOCK is not set
# CONFIG_INLINE_SPIN_LOCK_BH is not set
# CONFIG_INLINE_SPIN_LOCK_IRQ is not set
# CONFIG_INLINE_SPIN_LOCK_IRQSAVE is not set
CONFIG_UNINLINE_SPIN_UNLOCK=y
# CONFIG_INLINE_SPIN_UNLOCK_BH is not set
# CONFIG_INLINE_SPIN_UNLOCK_IRQ is not set
# CONFIG_INLINE_SPIN_UNLOCK_IRQRESTORE is not set
# CONFIG_INLINE_READ_TRYLOCK is not set
# CONFIG_INLINE_READ_LOCK is not set
# CONFIG_INLINE_READ_LOCK_BH is not set
# CONFIG_INLINE_READ_LOCK_IRQ is not set
# CONFIG_INLINE_READ_LOCK_IRQSAVE is not set
# CONFIG_INLINE_READ_UNLOCK is not set
# CONFIG_INLINE_READ_UNLOCK_BH is not set
# CONFIG_INLINE_READ_UNLOCK_IRQ is not set
# CONFIG_INLINE_READ_UNLOCK_IRQRESTORE is not set
# CONFIG_INLINE_WRITE_TRYLOCK is not set
# CONFIG_INLINE_WRITE_LOCK is not set
# CONFIG_INLINE_WRITE_LOCK_BH is not set
# CONFIG_INLINE_WRITE_LOCK_IRQ is not set
# CONFIG_INLINE_WRITE_LOCK_IRQSAVE is not set
# CONFIG_INLINE_WRITE_UNLOCK is not set
# CONFIG_INLINE_WRITE_UNLOCK_BH is not set
# CONFIG_INLINE_WRITE_UNLOCK_IRQ is not set
# CONFIG_INLINE_WRITE_UNLOCK_IRQRESTORE is not set
# CONFIG_MUTEX_SPIN_ON_OWNER is not set
CONFIG_FREEZER=y

#
# Processor type and features
#
CONFIG_ZONE_DMA=y
CONFIG_SMP=y
CONFIG_X86_X2APIC=y
CONFIG_X86_MPPARSE=y
# CONFIG_X86_EXTENDED_PLATFORM is not set
CONFIG_X86_SUPPORTS_MEMORY_FAILURE=y
CONFIG_SCHED_OMIT_FRAME_POINTER=y
CONFIG_PARAVIRT_GUEST=y
# CONFIG_PARAVIRT_TIME_ACCOUNTING is not set
CONFIG_XEN=y
CONFIG_XEN_DOM0=y
CONFIG_XEN_PRIVILEGED_GUEST=y
CONFIG_XEN_PVHVM=y
CONFIG_XEN_MAX_DOMAIN_MEMORY=500
CONFIG_XEN_SAVE_RESTORE=y
# CONFIG_XEN_DEBUG_FS is not set
CONFIG_KVM_CLOCK=y
CONFIG_KVM_GUEST=y
CONFIG_PARAVIRT=y
# CONFIG_PARAVIRT_SPINLOCKS is not set
CONFIG_PARAVIRT_CLOCK=y
# CONFIG_PARAVIRT_DEBUG is not set
CONFIG_NO_BOOTMEM=y
CONFIG_MEMTEST=y
# CONFIG_MK8 is not set
# CONFIG_MPSC is not set
# CONFIG_MCORE2 is not set
# CONFIG_MATOM is not set
CONFIG_GENERIC_CPU=y
CONFIG_X86_INTERNODE_CACHE_SHIFT=6
CONFIG_X86_CMPXCHG=y
CONFIG_X86_L1_CACHE_SHIFT=6
CONFIG_X86_XADD=y
CONFIG_X86_WP_WORKS_OK=y
CONFIG_X86_TSC=y
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=64
CONFIG_X86_DEBUGCTLMSR=y
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_CENTAUR=y
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
CONFIG_DMI=y
CONFIG_GART_IOMMU=y
CONFIG_CALGARY_IOMMU=y
CONFIG_CALGARY_IOMMU_ENABLED_BY_DEFAULT=y
CONFIG_SWIOTLB=y
CONFIG_IOMMU_HELPER=y
# CONFIG_MAXSMP is not set
CONFIG_NR_CPUS=512
CONFIG_SCHED_SMT=y
CONFIG_SCHED_MC=y
# CONFIG_IRQ_TIME_ACCOUNTING is not set
# CONFIG_PREEMPT_NONE is not set
CONFIG_PREEMPT_VOLUNTARY=y
# CONFIG_PREEMPT is not set
CONFIG_PREEMPT_COUNT=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS=y
CONFIG_X86_MCE=y
CONFIG_X86_MCE_INTEL=y
CONFIG_X86_MCE_AMD=y
CONFIG_X86_MCE_THRESHOLD=y
CONFIG_X86_MCE_INJECT=y
CONFIG_X86_THERMAL_VECTOR=y
CONFIG_I8K=y
CONFIG_MICROCODE=y
CONFIG_MICROCODE_INTEL=y
CONFIG_MICROCODE_AMD=y
CONFIG_MICROCODE_OLD_INTERFACE=y
CONFIG_X86_MSR=y
CONFIG_X86_CPUID=y
CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
CONFIG_ARCH_DMA_ADDR_T_64BIT=y
CONFIG_DIRECT_GBPAGES=y
CONFIG_NUMA=y
CONFIG_AMD_NUMA=y
CONFIG_X86_64_ACPI_NUMA=y
CONFIG_NODES_SPAN_OTHER_NODES=y
CONFIG_NUMA_EMU=y
CONFIG_NODES_SHIFT=6
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_DEFAULT=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ARCH_MEMORY_PROBE=y
CONFIG_ARCH_PROC_KCORE_TEXT=y
CONFIG_ILLEGAL_POINTER_VALUE=0xdead000000000000
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_SPARSEMEM_MANUAL=y
CONFIG_SPARSEMEM=y
CONFIG_NEED_MULTIPLE_NODES=y
CONFIG_HAVE_MEMORY_PRESENT=y
CONFIG_SPARSEMEM_EXTREME=y
CONFIG_SPARSEMEM_VMEMMAP_ENABLE=y
CONFIG_SPARSEMEM_ALLOC_MEM_MAP_TOGETHER=y
CONFIG_SPARSEMEM_VMEMMAP=y
CONFIG_HAVE_MEMBLOCK=y
CONFIG_HAVE_MEMBLOCK_NODE_MAP=y
CONFIG_ARCH_DISCARD_MEMBLOCK=y
CONFIG_MEMORY_HOTPLUG=y
CONFIG_MEMORY_HOTPLUG_SPARSE=y
CONFIG_MEMORY_HOTREMOVE=y
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=999999
CONFIG_COMPACTION=y
CONFIG_MIGRATION=y
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_VIRT_TO_BUS=y
CONFIG_MMU_NOTIFIER=y
CONFIG_KSM=y
CONFIG_DEFAULT_MMAP_MIN_ADDR=65536
CONFIG_ARCH_SUPPORTS_MEMORY_FAILURE=y
CONFIG_MEMORY_FAILURE=y
CONFIG_HWPOISON_INJECT=y
CONFIG_TRANSPARENT_HUGEPAGE=y
# CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS is not set
CONFIG_TRANSPARENT_HUGEPAGE_MADVISE=y
CONFIG_CROSS_MEMORY_ATTACH=y
# CONFIG_CLEANCACHE is not set
# CONFIG_X86_CHECK_BIOS_CORRUPTION is not set
CONFIG_X86_RESERVE_LOW=64
CONFIG_MTRR=y
CONFIG_MTRR_SANITIZER=y
CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=0
CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1
CONFIG_X86_PAT=y
CONFIG_ARCH_USES_PG_UNCACHED=y
CONFIG_ARCH_RANDOM=y
CONFIG_EFI=y
# CONFIG_EFI_STUB is not set
CONFIG_SECCOMP=y
CONFIG_CC_STACKPROTECTOR=y
# CONFIG_HZ_100 is not set
CONFIG_HZ_250=y
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=250
CONFIG_SCHED_HRTICK=y
CONFIG_KEXEC=y
# CONFIG_CRASH_DUMP is not set
# CONFIG_KEXEC_JUMP is not set
CONFIG_PHYSICAL_START=0x1000000
CONFIG_RELOCATABLE=y
CONFIG_PHYSICAL_ALIGN=0x1000000
CONFIG_HOTPLUG_CPU=y
# CONFIG_COMPAT_VDSO is not set
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
CONFIG_ARCH_ENABLE_MEMORY_HOTREMOVE=y
CONFIG_USE_PERCPU_NUMA_NODE_ID=y

#
# Power management and ACPI options
#
CONFIG_ARCH_HIBERNATION_HEADER=y
CONFIG_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
CONFIG_HIBERNATE_CALLBACKS=y
CONFIG_HIBERNATION=y
CONFIG_PM_STD_PARTITION=""
CONFIG_PM_SLEEP=y
CONFIG_PM_SLEEP_SMP=y
# CONFIG_PM_AUTOSLEEP is not set
# CONFIG_PM_WAKELOCKS is not set
CONFIG_PM_RUNTIME=y
CONFIG_PM=y
CONFIG_PM_DEBUG=y
CONFIG_PM_ADVANCED_DEBUG=y
CONFIG_PM_TEST_SUSPEND=y
CONFIG_CAN_PM_TRACE=y
# CONFIG_PM_TRACE_RTC is not set
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
# CONFIG_ACPI_PROCFS is not set
# CONFIG_ACPI_PROCFS_POWER is not set
# CONFIG_ACPI_EC_DEBUGFS is not set
# CONFIG_ACPI_PROC_EVENT is not set
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_VIDEO=y
CONFIG_ACPI_FAN=y
CONFIG_ACPI_DOCK=y
CONFIG_ACPI_PROCESSOR=y
CONFIG_ACPI_IPMI=y
CONFIG_ACPI_HOTPLUG_CPU=y
CONFIG_ACPI_PROCESSOR_AGGREGATOR=y
CONFIG_ACPI_THERMAL=y
CONFIG_ACPI_NUMA=y
# CONFIG_ACPI_CUSTOM_DSDT is not set
CONFIG_ACPI_BLACKLIST_YEAR=0
# CONFIG_ACPI_DEBUG is not set
CONFIG_ACPI_PCI_SLOT=y
CONFIG_X86_PM_TIMER=y
CONFIG_ACPI_CONTAINER=y
CONFIG_ACPI_HOTPLUG_MEMORY=y
CONFIG_ACPI_SBS=y
CONFIG_ACPI_HED=y
# CONFIG_ACPI_CUSTOM_METHOD is not set
# CONFIG_ACPI_BGRT is not set
CONFIG_ACPI_APEI=y
CONFIG_ACPI_APEI_GHES=y
CONFIG_ACPI_APEI_PCIEAER=y
CONFIG_ACPI_APEI_MEMORY_FAILURE=y
# CONFIG_ACPI_APEI_EINJ is not set
# CONFIG_ACPI_APEI_ERST_DEBUG is not set
CONFIG_SFI=y

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_TABLE=y
CONFIG_CPU_FREQ_STAT=y
# CONFIG_CPU_FREQ_STAT_DETAILS is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
CONFIG_CPU_FREQ_GOV_POWERSAVE=y
CONFIG_CPU_FREQ_GOV_USERSPACE=y
CONFIG_CPU_FREQ_GOV_ONDEMAND=y
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=y

#
# x86 CPU frequency scaling drivers
#
CONFIG_X86_PCC_CPUFREQ=y
CONFIG_X86_ACPI_CPUFREQ=y
CONFIG_X86_POWERNOW_K8=y
CONFIG_X86_SPEEDSTEP_CENTRINO=y
CONFIG_X86_P4_CLOCKMOD=y

#
# shared options
#
CONFIG_X86_SPEEDSTEP_LIB=y
CONFIG_CPU_IDLE=y
CONFIG_CPU_IDLE_GOV_LADDER=y
CONFIG_CPU_IDLE_GOV_MENU=y
CONFIG_INTEL_IDLE=y

#
# Memory power savings
#
CONFIG_I7300_IDLE_IOAT_CHANNEL=y
CONFIG_I7300_IDLE=y

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
CONFIG_PCI_XEN=y
CONFIG_PCI_DOMAINS=y
# CONFIG_PCI_CNB20LE_QUIRK is not set
CONFIG_PCIEPORTBUS=y
CONFIG_HOTPLUG_PCI_PCIE=y
CONFIG_PCIEAER=y
# CONFIG_PCIE_ECRC is not set
CONFIG_PCIEAER_INJECT=y
CONFIG_PCIEASPM=y
CONFIG_PCIEASPM_DEBUG=y
CONFIG_PCIEASPM_DEFAULT=y
# CONFIG_PCIEASPM_POWERSAVE is not set
# CONFIG_PCIEASPM_PERFORMANCE is not set
CONFIG_PCIE_PME=y
CONFIG_ARCH_SUPPORTS_MSI=y
CONFIG_PCI_MSI=y
# CONFIG_PCI_DEBUG is not set
# CONFIG_PCI_REALLOC_ENABLE_AUTO is not set
CONFIG_PCI_STUB=y
CONFIG_XEN_PCIDEV_FRONTEND=y
CONFIG_HT_IRQ=y
CONFIG_PCI_ATS=y
CONFIG_PCI_IOV=y
CONFIG_PCI_PRI=y
CONFIG_PCI_PASID=y
CONFIG_PCI_IOAPIC=y
CONFIG_PCI_LABEL=y
CONFIG_ISA_DMA_API=y
CONFIG_AMD_NB=y
CONFIG_PCCARD=y
CONFIG_PCMCIA=y
CONFIG_PCMCIA_LOAD_CIS=y
CONFIG_CARDBUS=y

#
# PC-card bridges
#
CONFIG_YENTA=y
CONFIG_YENTA_O2=y
CONFIG_YENTA_RICOH=y
CONFIG_YENTA_TI=y
CONFIG_YENTA_ENE_TUNE=y
CONFIG_YENTA_TOSHIBA=y
CONFIG_PD6729=y
CONFIG_I82092=y
CONFIG_PCCARD_NONSTATIC=y
CONFIG_HOTPLUG_PCI=y
CONFIG_HOTPLUG_PCI_FAKE=y
CONFIG_HOTPLUG_PCI_ACPI=y
CONFIG_HOTPLUG_PCI_ACPI_IBM=y
CONFIG_HOTPLUG_PCI_CPCI=y
CONFIG_HOTPLUG_PCI_CPCI_ZT5550=y
CONFIG_HOTPLUG_PCI_CPCI_GENERIC=y
CONFIG_HOTPLUG_PCI_SHPC=y
# CONFIG_RAPIDIO is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_COMPAT_BINFMT_ELF=y
CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS=y
# CONFIG_HAVE_AOUT is not set
CONFIG_BINFMT_MISC=y
CONFIG_IA32_EMULATION=y
CONFIG_IA32_AOUT=y
# CONFIG_X86_X32 is not set
CONFIG_COMPAT=y
CONFIG_COMPAT_FOR_U64_ALIGNMENT=y
CONFIG_SYSVIPC_COMPAT=y
CONFIG_KEYS_COMPAT=y
CONFIG_HAVE_TEXT_POKE_SMP=y
CONFIG_X86_DEV_DMA_OPS=y
CONFIG_NET=y
CONFIG_COMPAT_NETLINK_MESSAGES=y

#
# Networking options
#
CONFIG_PACKET=y
CONFIG_UNIX=y
# CONFIG_UNIX_DIAG is not set
CONFIG_XFRM=y
CONFIG_XFRM_ALGO=y
CONFIG_XFRM_USER=y
CONFIG_XFRM_SUB_POLICY=y
CONFIG_XFRM_MIGRATE=y
# CONFIG_XFRM_STATISTICS is not set
CONFIG_XFRM_IPCOMP=y
CONFIG_NET_KEY=y
CONFIG_NET_KEY_MIGRATE=y
CONFIG_INET=y
CONFIG_IP_MULTICAST=y
CONFIG_IP_ADVANCED_ROUTER=y
CONFIG_IP_FIB_TRIE_STATS=y
CONFIG_IP_MULTIPLE_TABLES=y
CONFIG_IP_ROUTE_MULTIPATH=y
CONFIG_IP_ROUTE_VERBOSE=y
CONFIG_IP_ROUTE_CLASSID=y
CONFIG_IP_PNP=y
CONFIG_IP_PNP_DHCP=y
CONFIG_IP_PNP_BOOTP=y
CONFIG_IP_PNP_RARP=y
CONFIG_NET_IPIP=y
CONFIG_NET_IPGRE_DEMUX=y
CONFIG_NET_IPGRE=y
CONFIG_NET_IPGRE_BROADCAST=y
CONFIG_IP_MROUTE=y
CONFIG_IP_MROUTE_MULTIPLE_TABLES=y
CONFIG_IP_PIMSM_V1=y
CONFIG_IP_PIMSM_V2=y
# CONFIG_ARPD is not set
CONFIG_SYN_COOKIES=y
CONFIG_INET_AH=y
CONFIG_INET_ESP=y
CONFIG_INET_IPCOMP=y
CONFIG_INET_XFRM_TUNNEL=y
CONFIG_INET_TUNNEL=y
CONFIG_INET_XFRM_MODE_TRANSPORT=y
CONFIG_INET_XFRM_MODE_TUNNEL=y
CONFIG_INET_XFRM_MODE_BEET=y
CONFIG_INET_LRO=y
CONFIG_INET_DIAG=y
CONFIG_INET_TCP_DIAG=y
# CONFIG_INET_UDP_DIAG is not set
CONFIG_TCP_CONG_ADVANCED=y
CONFIG_TCP_CONG_BIC=y
CONFIG_TCP_CONG_CUBIC=y
CONFIG_TCP_CONG_WESTWOOD=y
CONFIG_TCP_CONG_HTCP=y
CONFIG_TCP_CONG_HSTCP=y
CONFIG_TCP_CONG_HYBLA=y
CONFIG_TCP_CONG_VEGAS=y
CONFIG_TCP_CONG_SCALABLE=y
CONFIG_TCP_CONG_LP=y
CONFIG_TCP_CONG_VENO=y
CONFIG_TCP_CONG_YEAH=y
CONFIG_TCP_CONG_ILLINOIS=y
# CONFIG_DEFAULT_BIC is not set
CONFIG_DEFAULT_CUBIC=y
# CONFIG_DEFAULT_HTCP is not set
# CONFIG_DEFAULT_HYBLA is not set
# CONFIG_DEFAULT_VEGAS is not set
# CONFIG_DEFAULT_VENO is not set
# CONFIG_DEFAULT_WESTWOOD is not set
# CONFIG_DEFAULT_RENO is not set
CONFIG_DEFAULT_TCP_CONG="cubic"
CONFIG_TCP_MD5SIG=y
CONFIG_IPV6=y
CONFIG_IPV6_PRIVACY=y
CONFIG_IPV6_ROUTER_PREF=y
CONFIG_IPV6_ROUTE_INFO=y
CONFIG_IPV6_OPTIMISTIC_DAD=y
CONFIG_INET6_AH=y
CONFIG_INET6_ESP=y
CONFIG_INET6_IPCOMP=y
CONFIG_IPV6_MIP6=y
CONFIG_INET6_XFRM_TUNNEL=y
CONFIG_INET6_TUNNEL=y
CONFIG_INET6_XFRM_MODE_TRANSPORT=y
CONFIG_INET6_XFRM_MODE_TUNNEL=y
CONFIG_INET6_XFRM_MODE_BEET=y
CONFIG_INET6_XFRM_MODE_ROUTEOPTIMIZATION=y
CONFIG_IPV6_SIT=y
CONFIG_IPV6_SIT_6RD=y
CONFIG_IPV6_NDISC_NODETYPE=y
CONFIG_IPV6_TUNNEL=y
CONFIG_IPV6_MULTIPLE_TABLES=y
CONFIG_IPV6_SUBTREES=y
CONFIG_IPV6_MROUTE=y
CONFIG_IPV6_MROUTE_MULTIPLE_TABLES=y
CONFIG_IPV6_PIMSM_V2=y
# CONFIG_NETLABEL is not set
CONFIG_NETWORK_SECMARK=y
# CONFIG_NETWORK_PHY_TIMESTAMPING is not set
CONFIG_NETFILTER=y
# CONFIG_NETFILTER_DEBUG is not set
CONFIG_NETFILTER_ADVANCED=y
CONFIG_BRIDGE_NETFILTER=y

#
# Core Netfilter Configuration
#
CONFIG_NETFILTER_NETLINK=y
# CONFIG_NETFILTER_NETLINK_ACCT is not set
CONFIG_NETFILTER_NETLINK_QUEUE=y
CONFIG_NETFILTER_NETLINK_LOG=y
CONFIG_NF_CONNTRACK=y
CONFIG_NF_CONNTRACK_MARK=y
CONFIG_NF_CONNTRACK_SECMARK=y
CONFIG_NF_CONNTRACK_ZONES=y
CONFIG_NF_CONNTRACK_PROCFS=y
CONFIG_NF_CONNTRACK_EVENTS=y
# CONFIG_NF_CONNTRACK_TIMEOUT is not set
CONFIG_NF_CONNTRACK_TIMESTAMP=y
CONFIG_NF_CT_PROTO_DCCP=y
CONFIG_NF_CT_PROTO_GRE=y
CONFIG_NF_CT_PROTO_SCTP=y
CONFIG_NF_CT_PROTO_UDPLITE=y
CONFIG_NF_CONNTRACK_AMANDA=y
CONFIG_NF_CONNTRACK_FTP=y
CONFIG_NF_CONNTRACK_H323=y
CONFIG_NF_CONNTRACK_IRC=y
CONFIG_NF_CONNTRACK_BROADCAST=y
CONFIG_NF_CONNTRACK_NETBIOS_NS=y
CONFIG_NF_CONNTRACK_SNMP=y
CONFIG_NF_CONNTRACK_PPTP=y
CONFIG_NF_CONNTRACK_SANE=y
CONFIG_NF_CONNTRACK_SIP=y
CONFIG_NF_CONNTRACK_TFTP=y
CONFIG_NF_CT_NETLINK=y
# CONFIG_NF_CT_NETLINK_TIMEOUT is not set
CONFIG_NETFILTER_TPROXY=y
CONFIG_NETFILTER_XTABLES=y

#
# Xtables combined modules
#
CONFIG_NETFILTER_XT_MARK=y
CONFIG_NETFILTER_XT_CONNMARK=y
CONFIG_NETFILTER_XT_SET=y

#
# Xtables targets
#
CONFIG_NETFILTER_XT_TARGET_AUDIT=y
CONFIG_NETFILTER_XT_TARGET_CHECKSUM=y
CONFIG_NETFILTER_XT_TARGET_CLASSIFY=y
CONFIG_NETFILTER_XT_TARGET_CONNMARK=y
CONFIG_NETFILTER_XT_TARGET_CONNSECMARK=y
CONFIG_NETFILTER_XT_TARGET_CT=y
CONFIG_NETFILTER_XT_TARGET_DSCP=y
CONFIG_NETFILTER_XT_TARGET_HL=y
# CONFIG_NETFILTER_XT_TARGET_HMARK is not set
CONFIG_NETFILTER_XT_TARGET_IDLETIMER=y
CONFIG_NETFILTER_XT_TARGET_LED=y
# CONFIG_NETFILTER_XT_TARGET_LOG is not set
CONFIG_NETFILTER_XT_TARGET_MARK=y
CONFIG_NETFILTER_XT_TARGET_NFLOG=y
CONFIG_NETFILTER_XT_TARGET_NFQUEUE=y
CONFIG_NETFILTER_XT_TARGET_NOTRACK=y
CONFIG_NETFILTER_XT_TARGET_RATEEST=y
CONFIG_NETFILTER_XT_TARGET_TEE=y
CONFIG_NETFILTER_XT_TARGET_TPROXY=y
CONFIG_NETFILTER_XT_TARGET_TRACE=y
CONFIG_NETFILTER_XT_TARGET_SECMARK=y
CONFIG_NETFILTER_XT_TARGET_TCPMSS=y
CONFIG_NETFILTER_XT_TARGET_TCPOPTSTRIP=y

#
# Xtables matches
#
CONFIG_NETFILTER_XT_MATCH_ADDRTYPE=y
CONFIG_NETFILTER_XT_MATCH_CLUSTER=y
CONFIG_NETFILTER_XT_MATCH_COMMENT=y
CONFIG_NETFILTER_XT_MATCH_CONNBYTES=y
CONFIG_NETFILTER_XT_MATCH_CONNLIMIT=y
CONFIG_NETFILTER_XT_MATCH_CONNMARK=y
CONFIG_NETFILTER_XT_MATCH_CONNTRACK=y
CONFIG_NETFILTER_XT_MATCH_CPU=y
CONFIG_NETFILTER_XT_MATCH_DCCP=y
CONFIG_NETFILTER_XT_MATCH_DEVGROUP=y
CONFIG_NETFILTER_XT_MATCH_DSCP=y
CONFIG_NETFILTER_XT_MATCH_ECN=y
CONFIG_NETFILTER_XT_MATCH_ESP=y
CONFIG_NETFILTER_XT_MATCH_HASHLIMIT=y
CONFIG_NETFILTER_XT_MATCH_HELPER=y
CONFIG_NETFILTER_XT_MATCH_HL=y
CONFIG_NETFILTER_XT_MATCH_IPRANGE=y
CONFIG_NETFILTER_XT_MATCH_IPVS=y
CONFIG_NETFILTER_XT_MATCH_LENGTH=y
CONFIG_NETFILTER_XT_MATCH_LIMIT=y
CONFIG_NETFILTER_XT_MATCH_MAC=y
CONFIG_NETFILTER_XT_MATCH_MARK=y
CONFIG_NETFILTER_XT_MATCH_MULTIPORT=y
# CONFIG_NETFILTER_XT_MATCH_NFACCT is not set
CONFIG_NETFILTER_XT_MATCH_OSF=y
CONFIG_NETFILTER_XT_MATCH_OWNER=y
CONFIG_NETFILTER_XT_MATCH_POLICY=y
CONFIG_NETFILTER_XT_MATCH_PHYSDEV=y
CONFIG_NETFILTER_XT_MATCH_PKTTYPE=y
CONFIG_NETFILTER_XT_MATCH_QUOTA=y
CONFIG_NETFILTER_XT_MATCH_RATEEST=y
CONFIG_NETFILTER_XT_MATCH_REALM=y
CONFIG_NETFILTER_XT_MATCH_RECENT=y
CONFIG_NETFILTER_XT_MATCH_SCTP=y
CONFIG_NETFILTER_XT_MATCH_SOCKET=y
CONFIG_NETFILTER_XT_MATCH_STATE=y
CONFIG_NETFILTER_XT_MATCH_STATISTIC=y
CONFIG_NETFILTER_XT_MATCH_STRING=y
CONFIG_NETFILTER_XT_MATCH_TCPMSS=y
CONFIG_NETFILTER_XT_MATCH_TIME=y
CONFIG_NETFILTER_XT_MATCH_U32=y
CONFIG_IP_SET=y
CONFIG_IP_SET_MAX=256
CONFIG_IP_SET_BITMAP_IP=y
CONFIG_IP_SET_BITMAP_IPMAC=y
CONFIG_IP_SET_BITMAP_PORT=y
CONFIG_IP_SET_HASH_IP=y
CONFIG_IP_SET_HASH_IPPORT=y
CONFIG_IP_SET_HASH_IPPORTIP=y
CONFIG_IP_SET_HASH_IPPORTNET=y
CONFIG_IP_SET_HASH_NET=y
CONFIG_IP_SET_HASH_NETPORT=y
CONFIG_IP_SET_HASH_NETIFACE=y
CONFIG_IP_SET_LIST_SET=y
CONFIG_IP_VS=y
CONFIG_IP_VS_IPV6=y
# CONFIG_IP_VS_DEBUG is not set
CONFIG_IP_VS_TAB_BITS=12

#
# IPVS transport protocol load balancing support
#
CONFIG_IP_VS_PROTO_TCP=y
CONFIG_IP_VS_PROTO_UDP=y
CONFIG_IP_VS_PROTO_AH_ESP=y
CONFIG_IP_VS_PROTO_ESP=y
CONFIG_IP_VS_PROTO_AH=y
CONFIG_IP_VS_PROTO_SCTP=y

#
# IPVS scheduler
#
CONFIG_IP_VS_RR=y
CONFIG_IP_VS_WRR=y
CONFIG_IP_VS_LC=y
CONFIG_IP_VS_WLC=y
CONFIG_IP_VS_LBLC=y
CONFIG_IP_VS_LBLCR=y
CONFIG_IP_VS_DH=y
CONFIG_IP_VS_SH=y
CONFIG_IP_VS_SED=y
CONFIG_IP_VS_NQ=y

#
# IPVS SH scheduler
#
CONFIG_IP_VS_SH_TAB_BITS=8

#
# IPVS application helper
#
CONFIG_IP_VS_NFCT=y
CONFIG_IP_VS_PE_SIP=y

#
# IP: Netfilter Configuration
#
CONFIG_NF_DEFRAG_IPV4=y
CONFIG_NF_CONNTRACK_IPV4=y
CONFIG_NF_CONNTRACK_PROC_COMPAT=y
CONFIG_IP_NF_QUEUE=y
CONFIG_IP_NF_IPTABLES=y
CONFIG_IP_NF_MATCH_AH=y
CONFIG_IP_NF_MATCH_ECN=y
# CONFIG_IP_NF_MATCH_RPFILTER is not set
CONFIG_IP_NF_MATCH_TTL=y
CONFIG_IP_NF_FILTER=y
CONFIG_IP_NF_TARGET_REJECT=y
CONFIG_IP_NF_TARGET_ULOG=y
# CONFIG_NF_NAT is not set
CONFIG_IP_NF_MANGLE=y
CONFIG_IP_NF_TARGET_CLUSTERIP=y
CONFIG_IP_NF_TARGET_ECN=y
CONFIG_IP_NF_TARGET_TTL=y
CONFIG_IP_NF_RAW=y
CONFIG_IP_NF_SECURITY=y
CONFIG_IP_NF_ARPTABLES=y
CONFIG_IP_NF_ARPFILTER=y
CONFIG_IP_NF_ARP_MANGLE=y

#
# IPv6: Netfilter Configuration
#
CONFIG_NF_DEFRAG_IPV6=y
CONFIG_NF_CONNTRACK_IPV6=y
CONFIG_IP6_NF_IPTABLES=y
CONFIG_IP6_NF_MATCH_AH=y
CONFIG_IP6_NF_MATCH_EUI64=y
CONFIG_IP6_NF_MATCH_FRAG=y
CONFIG_IP6_NF_MATCH_OPTS=y
CONFIG_IP6_NF_MATCH_HL=y
CONFIG_IP6_NF_MATCH_IPV6HEADER=y
CONFIG_IP6_NF_MATCH_MH=y
# CONFIG_IP6_NF_MATCH_RPFILTER is not set
CONFIG_IP6_NF_MATCH_RT=y
CONFIG_IP6_NF_TARGET_HL=y
CONFIG_IP6_NF_FILTER=y
CONFIG_IP6_NF_TARGET_REJECT=y
CONFIG_IP6_NF_MANGLE=y
CONFIG_IP6_NF_RAW=y
CONFIG_IP6_NF_SECURITY=y

#
# DECnet: Netfilter Configuration
#
CONFIG_DECNET_NF_GRABULATOR=y
CONFIG_BRIDGE_NF_EBTABLES=y
CONFIG_BRIDGE_EBT_BROUTE=y
CONFIG_BRIDGE_EBT_T_FILTER=y
CONFIG_BRIDGE_EBT_T_NAT=y
CONFIG_BRIDGE_EBT_802_3=y
CONFIG_BRIDGE_EBT_AMONG=y
CONFIG_BRIDGE_EBT_ARP=y
CONFIG_BRIDGE_EBT_IP=y
CONFIG_BRIDGE_EBT_IP6=y
CONFIG_BRIDGE_EBT_LIMIT=y
CONFIG_BRIDGE_EBT_MARK=y
CONFIG_BRIDGE_EBT_PKTTYPE=y
CONFIG_BRIDGE_EBT_STP=y
CONFIG_BRIDGE_EBT_VLAN=y
CONFIG_BRIDGE_EBT_ARPREPLY=y
CONFIG_BRIDGE_EBT_DNAT=y
CONFIG_BRIDGE_EBT_MARK_T=y
CONFIG_BRIDGE_EBT_REDIRECT=y
CONFIG_BRIDGE_EBT_SNAT=y
CONFIG_BRIDGE_EBT_LOG=y
CONFIG_BRIDGE_EBT_ULOG=y
CONFIG_BRIDGE_EBT_NFLOG=y
CONFIG_IP_DCCP=y
CONFIG_INET_DCCP_DIAG=y

#
# DCCP CCIDs Configuration (EXPERIMENTAL)
#
# CONFIG_IP_DCCP_CCID2_DEBUG is not set
CONFIG_IP_DCCP_CCID3=y
# CONFIG_IP_DCCP_CCID3_DEBUG is not set
CONFIG_IP_DCCP_TFRC_LIB=y

#
# DCCP Kernel Hacking
#
# CONFIG_IP_DCCP_DEBUG is not set
CONFIG_NET_DCCPPROBE=y
CONFIG_IP_SCTP=y
CONFIG_NET_SCTPPROBE=y
# CONFIG_SCTP_DBG_MSG is not set
# CONFIG_SCTP_DBG_OBJCNT is not set
# CONFIG_SCTP_HMAC_NONE is not set
# CONFIG_SCTP_HMAC_SHA1 is not set
CONFIG_SCTP_HMAC_MD5=y
CONFIG_RDS=y
CONFIG_RDS_RDMA=y
CONFIG_RDS_TCP=y
# CONFIG_RDS_DEBUG is not set
CONFIG_TIPC=y
CONFIG_TIPC_ADVANCED=y
CONFIG_TIPC_PORTS=8191
CONFIG_TIPC_LOG=0
# CONFIG_TIPC_DEBUG is not set
CONFIG_ATM=y
CONFIG_ATM_CLIP=y
# CONFIG_ATM_CLIP_NO_ICMP is not set
CONFIG_ATM_LANE=y
CONFIG_ATM_MPOA=y
CONFIG_ATM_BR2684=y
# CONFIG_ATM_BR2684_IPFILTER is not set
CONFIG_L2TP=y
CONFIG_L2TP_DEBUGFS=y
CONFIG_L2TP_V3=y
CONFIG_L2TP_IP=y
CONFIG_L2TP_ETH=y
CONFIG_STP=y
CONFIG_GARP=y
CONFIG_BRIDGE=y
CONFIG_BRIDGE_IGMP_SNOOPING=y
# CONFIG_NET_DSA is not set
CONFIG_VLAN_8021Q=y
CONFIG_VLAN_8021Q_GVRP=y
CONFIG_DECNET=y
# CONFIG_DECNET_ROUTER is not set
CONFIG_LLC=y
CONFIG_LLC2=y
CONFIG_IPX=y
# CONFIG_IPX_INTERN is not set
CONFIG_ATALK=y
CONFIG_DEV_APPLETALK=y
CONFIG_IPDDP=y
CONFIG_IPDDP_ENCAP=y
CONFIG_IPDDP_DECAP=y
# CONFIG_X25 is not set
CONFIG_LAPB=y
CONFIG_WAN_ROUTER=y
CONFIG_PHONET=y
CONFIG_IEEE802154=y
CONFIG_IEEE802154_6LOWPAN=y
# CONFIG_MAC802154 is not set
CONFIG_NET_SCHED=y

#
# Queueing/Scheduling
#
CONFIG_NET_SCH_CBQ=y
CONFIG_NET_SCH_HTB=y
CONFIG_NET_SCH_HFSC=y
CONFIG_NET_SCH_ATM=y
CONFIG_NET_SCH_PRIO=y
CONFIG_NET_SCH_MULTIQ=y
CONFIG_NET_SCH_RED=y
CONFIG_NET_SCH_SFB=y
CONFIG_NET_SCH_SFQ=y
CONFIG_NET_SCH_TEQL=y
CONFIG_NET_SCH_TBF=y
CONFIG_NET_SCH_GRED=y
CONFIG_NET_SCH_DSMARK=y
CONFIG_NET_SCH_NETEM=y
CONFIG_NET_SCH_DRR=y
CONFIG_NET_SCH_MQPRIO=y
CONFIG_NET_SCH_CHOKE=y
CONFIG_NET_SCH_QFQ=y
# CONFIG_NET_SCH_CODEL is not set
# CONFIG_NET_SCH_FQ_CODEL is not set
CONFIG_NET_SCH_INGRESS=y
# CONFIG_NET_SCH_PLUG is not set

#
# Classification
#
CONFIG_NET_CLS=y
CONFIG_NET_CLS_BASIC=y
CONFIG_NET_CLS_TCINDEX=y
CONFIG_NET_CLS_ROUTE4=y
CONFIG_NET_CLS_FW=y
CONFIG_NET_CLS_U32=y
CONFIG_CLS_U32_PERF=y
CONFIG_CLS_U32_MARK=y
CONFIG_NET_CLS_RSVP=y
CONFIG_NET_CLS_RSVP6=y
CONFIG_NET_CLS_FLOW=y
CONFIG_NET_CLS_CGROUP=y
CONFIG_NET_EMATCH=y
CONFIG_NET_EMATCH_STACK=32
CONFIG_NET_EMATCH_CMP=y
CONFIG_NET_EMATCH_NBYTE=y
CONFIG_NET_EMATCH_U32=y
CONFIG_NET_EMATCH_META=y
CONFIG_NET_EMATCH_TEXT=y
CONFIG_NET_CLS_ACT=y
CONFIG_NET_ACT_POLICE=y
CONFIG_NET_ACT_GACT=y
CONFIG_GACT_PROB=y
CONFIG_NET_ACT_MIRRED=y
CONFIG_NET_ACT_IPT=y
CONFIG_NET_ACT_NAT=y
CONFIG_NET_ACT_PEDIT=y
CONFIG_NET_ACT_SIMP=y
CONFIG_NET_ACT_SKBEDIT=y
CONFIG_NET_ACT_CSUM=y
CONFIG_NET_CLS_IND=y
CONFIG_NET_SCH_FIFO=y
CONFIG_DCB=y
CONFIG_DNS_RESOLVER=y
CONFIG_BATMAN_ADV=y
CONFIG_BATMAN_ADV_BLA=y
# CONFIG_BATMAN_ADV_DEBUG is not set
# CONFIG_OPENVSWITCH is not set
CONFIG_RPS=y
CONFIG_RFS_ACCEL=y
CONFIG_XPS=y
# CONFIG_NETPRIO_CGROUP is not set
CONFIG_BQL=y
CONFIG_BPF_JIT=y

#
# Network testing
#
CONFIG_NET_PKTGEN=y
# CONFIG_NET_TCPPROBE is not set
CONFIG_NET_DROP_MONITOR=y
CONFIG_HAMRADIO=y

#
# Packet Radio protocols
#
CONFIG_AX25=y
# CONFIG_AX25_DAMA_SLAVE is not set
CONFIG_NETROM=y
CONFIG_ROSE=y

#
# AX.25 network device drivers
#
CONFIG_MKISS=y
CONFIG_6PACK=y
CONFIG_BPQETHER=y
CONFIG_BAYCOM_SER_FDX=y
CONFIG_BAYCOM_SER_HDX=y
CONFIG_BAYCOM_PAR=y
CONFIG_YAM=y
CONFIG_CAN=y
CONFIG_CAN_RAW=y
CONFIG_CAN_BCM=y
CONFIG_CAN_GW=y

#
# CAN Device Drivers
#
CONFIG_CAN_VCAN=y
CONFIG_CAN_SLCAN=y
CONFIG_CAN_DEV=y
CONFIG_CAN_CALC_BITTIMING=y
CONFIG_CAN_MCP251X=y
CONFIG_PCH_CAN=y
CONFIG_CAN_SJA1000=y
# CONFIG_CAN_SJA1000_ISA is not set
# CONFIG_CAN_SJA1000_PLATFORM is not set
CONFIG_CAN_EMS_PCMCIA=y
CONFIG_CAN_EMS_PCI=y
# CONFIG_CAN_PEAK_PCMCIA is not set
CONFIG_CAN_PEAK_PCI=y
CONFIG_CAN_PEAK_PCIEC=y
CONFIG_CAN_KVASER_PCI=y
CONFIG_CAN_PLX_PCI=y
# CONFIG_CAN_C_CAN is not set
# CONFIG_CAN_CC770 is not set

#
# CAN USB interfaces
#
CONFIG_CAN_EMS_USB=y
CONFIG_CAN_ESD_USB2=y
# CONFIG_CAN_PEAK_USB is not set
CONFIG_CAN_SOFTING=y
CONFIG_CAN_SOFTING_CS=y
# CONFIG_CAN_DEBUG_DEVICES is not set
CONFIG_IRDA=y

#
# IrDA protocols
#
CONFIG_IRLAN=y
CONFIG_IRNET=y
CONFIG_IRCOMM=y
# CONFIG_IRDA_ULTRA is not set

#
# IrDA options
#
CONFIG_IRDA_CACHE_LAST_LSAP=y
CONFIG_IRDA_FAST_RR=y
# CONFIG_IRDA_DEBUG is not set

#
# Infrared-port device drivers
#

#
# SIR device drivers
#
CONFIG_IRTTY_SIR=y

#
# Dongle support
#
CONFIG_DONGLE=y
CONFIG_ESI_DONGLE=y
CONFIG_ACTISYS_DONGLE=y
CONFIG_TEKRAM_DONGLE=y
CONFIG_TOIM3232_DONGLE=y
CONFIG_LITELINK_DONGLE=y
CONFIG_MA600_DONGLE=y
CONFIG_GIRBIL_DONGLE=y
CONFIG_MCP2120_DONGLE=y
CONFIG_OLD_BELKIN_DONGLE=y
CONFIG_ACT200L_DONGLE=y
CONFIG_KINGSUN_DONGLE=y
CONFIG_KSDAZZLE_DONGLE=y
CONFIG_KS959_DONGLE=y

#
# FIR device drivers
#
CONFIG_USB_IRDA=y
CONFIG_SIGMATEL_FIR=y
CONFIG_NSC_FIR=y
CONFIG_WINBOND_FIR=y
CONFIG_SMC_IRCC_FIR=y
CONFIG_ALI_FIR=y
CONFIG_VLSI_FIR=y
CONFIG_VIA_FIR=y
CONFIG_MCS_FIR=y
CONFIG_BT=y
# CONFIG_BT_RFCOMM is not set
# CONFIG_BT_BNEP is not set
# CONFIG_BT_CMTP is not set
# CONFIG_BT_HIDP is not set

#
# Bluetooth device drivers
#
CONFIG_BT_HCIBTUSB=y
CONFIG_BT_HCIBTSDIO=y
CONFIG_BT_HCIUART=y
CONFIG_BT_HCIUART_H4=y
CONFIG_BT_HCIUART_BCSP=y
CONFIG_BT_HCIUART_ATH3K=y
CONFIG_BT_HCIUART_LL=y
CONFIG_BT_HCIBCM203X=y
CONFIG_BT_HCIBPA10X=y
CONFIG_BT_HCIBFUSB=y
CONFIG_BT_HCIDTL1=y
CONFIG_BT_HCIBT3C=y
CONFIG_BT_HCIBLUECARD=y
CONFIG_BT_HCIBTUART=y
CONFIG_BT_HCIVHCI=y
CONFIG_BT_MRVL=y
CONFIG_BT_MRVL_SDIO=y
CONFIG_BT_ATH3K=y
CONFIG_AF_RXRPC=y
# CONFIG_AF_RXRPC_DEBUG is not set
CONFIG_RXKAD=y
CONFIG_FIB_RULES=y
CONFIG_WIRELESS=y
CONFIG_WIRELESS_EXT=y
CONFIG_WEXT_CORE=y
CONFIG_WEXT_PROC=y
CONFIG_WEXT_SPY=y
CONFIG_WEXT_PRIV=y
CONFIG_CFG80211=y
# CONFIG_NL80211_TESTMODE is not set
# CONFIG_CFG80211_DEVELOPER_WARNINGS is not set
# CONFIG_CFG80211_REG_DEBUG is not set
CONFIG_CFG80211_DEFAULT_PS=y
# CONFIG_CFG80211_DEBUGFS is not set
# CONFIG_CFG80211_INTERNAL_REGDB is not set
CONFIG_CFG80211_WEXT=y
CONFIG_LIB80211=y
CONFIG_LIB80211_CRYPT_WEP=y
CONFIG_LIB80211_CRYPT_CCMP=y
CONFIG_LIB80211_CRYPT_TKIP=y
# CONFIG_LIB80211_DEBUG is not set
CONFIG_MAC80211=y
CONFIG_MAC80211_HAS_RC=y
CONFIG_MAC80211_RC_MINSTREL=y
CONFIG_MAC80211_RC_MINSTREL_HT=y
CONFIG_MAC80211_RC_DEFAULT_MINSTREL=y
CONFIG_MAC80211_RC_DEFAULT="minstrel_ht"
CONFIG_MAC80211_MESH=y
CONFIG_MAC80211_LEDS=y
# CONFIG_MAC80211_DEBUGFS is not set
# CONFIG_MAC80211_MESSAGE_TRACING is not set
# CONFIG_MAC80211_DEBUG_MENU is not set
CONFIG_WIMAX=y
CONFIG_WIMAX_DEBUG_LEVEL=8
CONFIG_RFKILL=y
CONFIG_RFKILL_LEDS=y
CONFIG_RFKILL_INPUT=y
# CONFIG_RFKILL_REGULATOR is not set
CONFIG_NET_9P=y
CONFIG_NET_9P_VIRTIO=y
CONFIG_NET_9P_RDMA=y
# CONFIG_NET_9P_DEBUG is not set
# CONFIG_CAIF is not set
CONFIG_CEPH_LIB=y
# CONFIG_CEPH_LIB_PRETTYDEBUG is not set
# CONFIG_CEPH_LIB_USE_DNS_RESOLVER is not set
CONFIG_NFC=y
CONFIG_NFC_NCI=y
# CONFIG_NFC_HCI is not set
# CONFIG_NFC_LLCP is not set

#
# Near Field Communication (NFC) devices
#
# CONFIG_PN544_NFC is not set
CONFIG_NFC_PN533=y
CONFIG_HAVE_BPF_JIT=y

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH=""
CONFIG_DEVTMPFS=y
# CONFIG_DEVTMPFS_MOUNT is not set
CONFIG_STANDALONE=y
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=y
# CONFIG_FIRMWARE_IN_KERNEL is not set
CONFIG_EXTRA_FIRMWARE=""
# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
CONFIG_SYS_HYPERVISOR=y
# CONFIG_GENERIC_CPU_DEVICES is not set
CONFIG_REGMAP=y
CONFIG_REGMAP_I2C=y
CONFIG_DMA_SHARED_BUFFER=y
CONFIG_CONNECTOR=y
CONFIG_PROC_EVENTS=y
CONFIG_MTD=y
# CONFIG_MTD_TESTS is not set
CONFIG_MTD_REDBOOT_PARTS=y
CONFIG_MTD_REDBOOT_DIRECTORY_BLOCK=-1
# CONFIG_MTD_REDBOOT_PARTS_UNALLOCATED is not set
# CONFIG_MTD_REDBOOT_PARTS_READONLY is not set
# CONFIG_MTD_CMDLINE_PARTS is not set
CONFIG_MTD_AR7_PARTS=y

#
# User Modules And Translation Layers
#
CONFIG_MTD_CHAR=y
CONFIG_MTD_BLKDEVS=y
CONFIG_MTD_BLOCK=y
CONFIG_FTL=y
CONFIG_NFTL=y
CONFIG_NFTL_RW=y
CONFIG_INFTL=y
CONFIG_RFD_FTL=y
CONFIG_SSFDC=y
# CONFIG_SM_FTL is not set
CONFIG_MTD_OOPS=y
CONFIG_MTD_SWAP=y

#
# RAM/ROM/Flash chip drivers
#
CONFIG_MTD_CFI=y
CONFIG_MTD_JEDECPROBE=y
CONFIG_MTD_GEN_PROBE=y
# CONFIG_MTD_CFI_ADV_OPTIONS is not set
CONFIG_MTD_MAP_BANK_WIDTH_1=y
CONFIG_MTD_MAP_BANK_WIDTH_2=y
CONFIG_MTD_MAP_BANK_WIDTH_4=y
# CONFIG_MTD_MAP_BANK_WIDTH_8 is not set
# CONFIG_MTD_MAP_BANK_WIDTH_16 is not set
# CONFIG_MTD_MAP_BANK_WIDTH_32 is not set
CONFIG_MTD_CFI_I1=y
CONFIG_MTD_CFI_I2=y
# CONFIG_MTD_CFI_I4 is not set
# CONFIG_MTD_CFI_I8 is not set
CONFIG_MTD_CFI_INTELEXT=y
CONFIG_MTD_CFI_AMDSTD=y
CONFIG_MTD_CFI_STAA=y
CONFIG_MTD_CFI_UTIL=y
CONFIG_MTD_RAM=y
CONFIG_MTD_ROM=y
CONFIG_MTD_ABSENT=y

#
# Mapping drivers for chip access
#
CONFIG_MTD_COMPLEX_MAPPINGS=y
CONFIG_MTD_PHYSMAP=y
# CONFIG_MTD_PHYSMAP_COMPAT is not set
CONFIG_MTD_SC520CDP=y
CONFIG_MTD_NETSC520=y
CONFIG_MTD_TS5500=y
CONFIG_MTD_SBC_GXX=y
# CONFIG_MTD_AMD76XROM is not set
# CONFIG_MTD_ICHXROM is not set
# CONFIG_MTD_ESB2ROM is not set
# CONFIG_MTD_CK804XROM is not set
# CONFIG_MTD_SCB2_FLASH is not set
# CONFIG_MTD_NETtel is not set
# CONFIG_MTD_L440GX is not set
CONFIG_MTD_PCI=y
CONFIG_MTD_PCMCIA=y
# CONFIG_MTD_PCMCIA_ANONYMOUS is not set
# CONFIG_MTD_GPIO_ADDR is not set
CONFIG_MTD_INTEL_VR_NOR=y
CONFIG_MTD_PLATRAM=y
# CONFIG_MTD_LATCH_ADDR is not set

#
# Self-contained MTD device drivers
#
CONFIG_MTD_PMC551=y
# CONFIG_MTD_PMC551_BUGFIX is not set
# CONFIG_MTD_PMC551_DEBUG is not set
CONFIG_MTD_DATAFLASH=y
# CONFIG_MTD_DATAFLASH_WRITE_VERIFY is not set
# CONFIG_MTD_DATAFLASH_OTP is not set
CONFIG_MTD_M25P80=y
CONFIG_M25PXX_USE_FAST_READ=y
CONFIG_MTD_SST25L=y
CONFIG_MTD_SLRAM=y
CONFIG_MTD_PHRAM=y
CONFIG_MTD_MTDRAM=y
CONFIG_MTDRAM_TOTAL_SIZE=4096
CONFIG_MTDRAM_ERASE_SIZE=128
CONFIG_MTDRAM_ABS_POS=0
CONFIG_MTD_BLOCK2MTD=y

#
# Disk-On-Chip Device Drivers
#
CONFIG_MTD_DOC2000=y
CONFIG_MTD_DOC2001=y
CONFIG_MTD_DOC2001PLUS=y
# CONFIG_MTD_DOCG3 is not set
CONFIG_MTD_DOCPROBE=y
CONFIG_MTD_DOCECC=y
# CONFIG_MTD_DOCPROBE_ADVANCED is not set
CONFIG_MTD_DOCPROBE_ADDRESS=0x0
CONFIG_MTD_NAND_ECC=y
# CONFIG_MTD_NAND_ECC_SMC is not set
CONFIG_MTD_NAND=y
# CONFIG_MTD_NAND_VERIFY_WRITE is not set
# CONFIG_MTD_NAND_ECC_BCH is not set
CONFIG_MTD_SM_COMMON=y
# CONFIG_MTD_NAND_MUSEUM_IDS is not set
# CONFIG_MTD_NAND_DENALI is not set
CONFIG_MTD_NAND_IDS=y
CONFIG_MTD_NAND_RICOH=y
CONFIG_MTD_NAND_DISKONCHIP=y
# CONFIG_MTD_NAND_DISKONCHIP_PROBE_ADVANCED is not set
CONFIG_MTD_NAND_DISKONCHIP_PROBE_ADDRESS=0
# CONFIG_MTD_NAND_DISKONCHIP_BBTWRITE is not set
# CONFIG_MTD_NAND_DOCG4 is not set
CONFIG_MTD_NAND_CAFE=y
CONFIG_MTD_NAND_NANDSIM=y
CONFIG_MTD_NAND_PLATFORM=y
CONFIG_MTD_ALAUDA=y
CONFIG_MTD_ONENAND=y
CONFIG_MTD_ONENAND_VERIFY_WRITE=y
CONFIG_MTD_ONENAND_GENERIC=y
# CONFIG_MTD_ONENAND_OTP is not set
CONFIG_MTD_ONENAND_2X_PROGRAM=y
CONFIG_MTD_ONENAND_SIM=y

#
# LPDDR flash memory drivers
#
CONFIG_MTD_LPDDR=y
CONFIG_MTD_QINFO_PROBE=y
CONFIG_MTD_UBI=y
CONFIG_MTD_UBI_WL_THRESHOLD=4096
CONFIG_MTD_UBI_BEB_RESERVE=1
# CONFIG_MTD_UBI_GLUEBI is not set
CONFIG_PARPORT=y
CONFIG_PARPORT_PC=y
CONFIG_PARPORT_SERIAL=y
# CONFIG_PARPORT_PC_FIFO is not set
# CONFIG_PARPORT_PC_SUPERIO is not set
CONFIG_PARPORT_PC_PCMCIA=y
# CONFIG_PARPORT_GSC is not set
CONFIG_PARPORT_AX88796=y
CONFIG_PARPORT_1284=y
CONFIG_PARPORT_NOT_PC=y
CONFIG_PNP=y
# CONFIG_PNP_DEBUG_MESSAGES is not set

#
# Protocols
#
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
CONFIG_BLK_DEV_FD=y
CONFIG_PARIDE=m

#
# Parallel IDE high-level drivers
#
CONFIG_PARIDE_PD=m
CONFIG_PARIDE_PCD=m
CONFIG_PARIDE_PF=m
CONFIG_PARIDE_PT=m
CONFIG_PARIDE_PG=m

#
# Parallel IDE protocol modules
#
CONFIG_PARIDE_ATEN=m
CONFIG_PARIDE_BPCK=m
CONFIG_PARIDE_COMM=m
CONFIG_PARIDE_DSTR=m
CONFIG_PARIDE_FIT2=m
CONFIG_PARIDE_FIT3=m
CONFIG_PARIDE_EPAT=m
# CONFIG_PARIDE_EPATC8 is not set
CONFIG_PARIDE_EPIA=m
CONFIG_PARIDE_FRIQ=m
CONFIG_PARIDE_FRPW=m
CONFIG_PARIDE_KBIC=m
CONFIG_PARIDE_KTTI=m
CONFIG_PARIDE_ON20=m
CONFIG_PARIDE_ON26=m
# CONFIG_BLK_DEV_PCIESSD_MTIP32XX is not set
CONFIG_BLK_CPQ_DA=y
CONFIG_BLK_CPQ_CISS_DA=y
CONFIG_CISS_SCSI_TAPE=y
CONFIG_BLK_DEV_DAC960=y
CONFIG_BLK_DEV_UMEM=y
# CONFIG_BLK_DEV_COW_COMMON is not set
CONFIG_BLK_DEV_LOOP=y
CONFIG_BLK_DEV_LOOP_MIN_COUNT=8
# CONFIG_BLK_DEV_CRYPTOLOOP is not set
CONFIG_BLK_DEV_DRBD=y
# CONFIG_DRBD_FAULT_INJECTION is not set
CONFIG_BLK_DEV_NBD=y
# CONFIG_BLK_DEV_NVME is not set
CONFIG_BLK_DEV_OSD=y
CONFIG_BLK_DEV_SX8=y
# CONFIG_BLK_DEV_UB is not set
CONFIG_BLK_DEV_RAM=y
CONFIG_BLK_DEV_RAM_COUNT=16
CONFIG_BLK_DEV_RAM_SIZE=65536
# CONFIG_BLK_DEV_XIP is not set
CONFIG_CDROM_PKTCDVD=y
CONFIG_CDROM_PKTCDVD_BUFFERS=8
# CONFIG_CDROM_PKTCDVD_WCACHE is not set
CONFIG_ATA_OVER_ETH=y
CONFIG_XEN_BLKDEV_FRONTEND=y
CONFIG_XEN_BLKDEV_BACKEND=y
CONFIG_VIRTIO_BLK=y
# CONFIG_BLK_DEV_HD is not set
CONFIG_BLK_DEV_RBD=y

#
# Misc devices
#
CONFIG_SENSORS_LIS3LV02D=y
CONFIG_AD525X_DPOT=y
CONFIG_AD525X_DPOT_I2C=y
CONFIG_AD525X_DPOT_SPI=y
CONFIG_IBM_ASM=y
CONFIG_PHANTOM=y
# CONFIG_INTEL_MID_PTI is not set
CONFIG_SGI_IOC4=y
CONFIG_TIFM_CORE=y
CONFIG_TIFM_7XX1=y
CONFIG_ICS932S401=y
CONFIG_ENCLOSURE_SERVICES=y
CONFIG_HP_ILO=y
CONFIG_APDS9802ALS=y
CONFIG_ISL29003=y
CONFIG_ISL29020=y
CONFIG_SENSORS_TSL2550=y
CONFIG_SENSORS_BH1780=y
CONFIG_SENSORS_BH1770=y
CONFIG_SENSORS_APDS990X=y
CONFIG_HMC6352=y
CONFIG_DS1682=y
CONFIG_TI_DAC7512=y
CONFIG_VMWARE_BALLOON=y
# CONFIG_BMP085_I2C is not set
# CONFIG_BMP085_SPI is not set
CONFIG_PCH_PHUB=y
# CONFIG_USB_SWITCH_FSA9480 is not set
CONFIG_C2PORT=y
CONFIG_C2PORT_DURAMAR_2150=y

#
# EEPROM support
#
CONFIG_EEPROM_AT24=y
CONFIG_EEPROM_AT25=y
CONFIG_EEPROM_LEGACY=y
CONFIG_EEPROM_MAX6875=y
CONFIG_EEPROM_93CX6=y
# CONFIG_EEPROM_93XX46 is not set
CONFIG_CB710_CORE=y
# CONFIG_CB710_DEBUG is not set
CONFIG_CB710_DEBUG_ASSUMPTIONS=y
CONFIG_IWMC3200TOP=y
# CONFIG_IWMC3200TOP_DEBUG is not set
# CONFIG_IWMC3200TOP_DEBUGFS is not set

#
# Texas Instruments shared transport line discipline
#
# CONFIG_TI_ST is not set
CONFIG_SENSORS_LIS3_I2C=y

#
# Altera FPGA firmware download module
#
# CONFIG_ALTERA_STAPL is not set
# CONFIG_INTEL_MEI is not set
CONFIG_HAVE_IDE=y
CONFIG_IDE=y

#
# Please see Documentation/ide/ide.txt for help/info on IDE drives
#
CONFIG_IDE_XFER_MODE=y
CONFIG_IDE_ATAPI=y
# CONFIG_BLK_DEV_IDE_SATA is not set
CONFIG_IDE_GD=y
CONFIG_IDE_GD_ATA=y
CONFIG_IDE_GD_ATAPI=y
# CONFIG_BLK_DEV_IDECS is not set
CONFIG_BLK_DEV_DELKIN=y
CONFIG_BLK_DEV_IDECD=y
CONFIG_BLK_DEV_IDECD_VERBOSE_ERRORS=y
CONFIG_BLK_DEV_IDETAPE=y
# CONFIG_BLK_DEV_IDEACPI is not set
# CONFIG_IDE_TASK_IOCTL is not set
CONFIG_IDE_PROC_FS=y

#
# IDE chipset support/bugfixes
#
CONFIG_IDE_GENERIC=y
# CONFIG_BLK_DEV_PLATFORM is not set
# CONFIG_BLK_DEV_CMD640 is not set
CONFIG_BLK_DEV_IDEPNP=y
CONFIG_BLK_DEV_IDEDMA_SFF=y

#
# PCI IDE chipsets support
#
CONFIG_BLK_DEV_IDEPCI=y
CONFIG_IDEPCI_PCIBUS_ORDER=y
# CONFIG_BLK_DEV_OFFBOARD is not set
# CONFIG_BLK_DEV_GENERIC is not set
CONFIG_BLK_DEV_OPTI621=y
# CONFIG_BLK_DEV_RZ1000 is not set
CONFIG_BLK_DEV_IDEDMA_PCI=y
# CONFIG_BLK_DEV_AEC62XX is not set
# CONFIG_BLK_DEV_ALI15X3 is not set
# CONFIG_BLK_DEV_AMD74XX is not set
# CONFIG_BLK_DEV_ATIIXP is not set
# CONFIG_BLK_DEV_CMD64X is not set
# CONFIG_BLK_DEV_TRIFLEX is not set
# CONFIG_BLK_DEV_CS5520 is not set
# CONFIG_BLK_DEV_CS5530 is not set
CONFIG_BLK_DEV_HPT366=y
# CONFIG_BLK_DEV_JMICRON is not set
# CONFIG_BLK_DEV_SC1200 is not set
CONFIG_BLK_DEV_PIIX=y
CONFIG_BLK_DEV_IT8172=y
CONFIG_BLK_DEV_IT8213=y
# CONFIG_BLK_DEV_IT821X is not set
# CONFIG_BLK_DEV_NS87415 is not set
# CONFIG_BLK_DEV_PDC202XX_OLD is not set
# CONFIG_BLK_DEV_PDC202XX_NEW is not set
# CONFIG_BLK_DEV_SVWKS is not set
# CONFIG_BLK_DEV_SIIMAGE is not set
# CONFIG_BLK_DEV_SIS5513 is not set
# CONFIG_BLK_DEV_SLC90E66 is not set
CONFIG_BLK_DEV_TRM290=y
# CONFIG_BLK_DEV_VIA82CXXX is not set
CONFIG_BLK_DEV_TC86C001=y
CONFIG_BLK_DEV_IDEDMA=y

#
# SCSI device support
#
CONFIG_SCSI_MOD=y
CONFIG_RAID_ATTRS=y
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
CONFIG_SCSI_TGT=y
CONFIG_SCSI_NETLINK=y
# CONFIG_SCSI_PROC_FS is not set

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=y
CONFIG_CHR_DEV_ST=y
CONFIG_CHR_DEV_OSST=y
CONFIG_BLK_DEV_SR=y
CONFIG_BLK_DEV_SR_VENDOR=y
CONFIG_CHR_DEV_SG=y
CONFIG_CHR_DEV_SCH=y
CONFIG_SCSI_ENCLOSURE=y
CONFIG_SCSI_MULTI_LUN=y
CONFIG_SCSI_CONSTANTS=y
CONFIG_SCSI_LOGGING=y
CONFIG_SCSI_SCAN_ASYNC=y
CONFIG_SCSI_WAIT_SCAN=m

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=y
CONFIG_SCSI_FC_ATTRS=y
CONFIG_SCSI_FC_TGT_ATTRS=y
CONFIG_SCSI_ISCSI_ATTRS=y
CONFIG_SCSI_SAS_ATTRS=y
CONFIG_SCSI_SAS_LIBSAS=y
CONFIG_SCSI_SAS_ATA=y
CONFIG_SCSI_SAS_HOST_SMP=y
CONFIG_SCSI_SRP_ATTRS=y
CONFIG_SCSI_SRP_TGT_ATTRS=y
CONFIG_SCSI_LOWLEVEL=y
CONFIG_ISCSI_TCP=y
CONFIG_ISCSI_BOOT_SYSFS=y
CONFIG_SCSI_CXGB3_ISCSI=y
CONFIG_SCSI_CXGB4_ISCSI=y
CONFIG_SCSI_BNX2_ISCSI=y
CONFIG_SCSI_BNX2X_FCOE=y
CONFIG_BE2ISCSI=y
CONFIG_BLK_DEV_3W_XXXX_RAID=y
CONFIG_SCSI_HPSA=y
CONFIG_SCSI_3W_9XXX=y
CONFIG_SCSI_3W_SAS=y
CONFIG_SCSI_ACARD=y
CONFIG_SCSI_AACRAID=y
CONFIG_SCSI_AIC7XXX=y
CONFIG_AIC7XXX_CMDS_PER_DEVICE=8
CONFIG_AIC7XXX_RESET_DELAY_MS=15000
CONFIG_AIC7XXX_DEBUG_ENABLE=y
CONFIG_AIC7XXX_DEBUG_MASK=0
CONFIG_AIC7XXX_REG_PRETTY_PRINT=y
CONFIG_SCSI_AIC7XXX_OLD=y
CONFIG_SCSI_AIC79XX=y
CONFIG_AIC79XX_CMDS_PER_DEVICE=32
CONFIG_AIC79XX_RESET_DELAY_MS=15000
CONFIG_AIC79XX_DEBUG_ENABLE=y
CONFIG_AIC79XX_DEBUG_MASK=0
CONFIG_AIC79XX_REG_PRETTY_PRINT=y
CONFIG_SCSI_AIC94XX=y
# CONFIG_AIC94XX_DEBUG is not set
CONFIG_SCSI_MVSAS=y
# CONFIG_SCSI_MVSAS_DEBUG is not set
# CONFIG_SCSI_MVSAS_TASKLET is not set
CONFIG_SCSI_MVUMI=y
CONFIG_SCSI_DPT_I2O=y
CONFIG_SCSI_ADVANSYS=y
CONFIG_SCSI_ARCMSR=y
CONFIG_MEGARAID_NEWGEN=y
CONFIG_MEGARAID_MM=y
CONFIG_MEGARAID_MAILBOX=y
CONFIG_MEGARAID_LEGACY=y
CONFIG_MEGARAID_SAS=y
CONFIG_SCSI_MPT2SAS=y
CONFIG_SCSI_MPT2SAS_MAX_SGE=128
# CONFIG_SCSI_MPT2SAS_LOGGING is not set
# CONFIG_SCSI_UFSHCD is not set
CONFIG_SCSI_HPTIOP=y
CONFIG_SCSI_BUSLOGIC=y
CONFIG_VMWARE_PVSCSI=y
CONFIG_HYPERV_STORAGE=y
CONFIG_LIBFC=y
CONFIG_LIBFCOE=y
CONFIG_FCOE=y
CONFIG_FCOE_FNIC=y
CONFIG_SCSI_DMX3191D=y
CONFIG_SCSI_EATA=y
CONFIG_SCSI_EATA_TAGGED_QUEUE=y
CONFIG_SCSI_EATA_LINKED_COMMANDS=y
CONFIG_SCSI_EATA_MAX_TAGS=16
CONFIG_SCSI_FUTURE_DOMAIN=y
CONFIG_SCSI_GDTH=y
CONFIG_SCSI_ISCI=y
CONFIG_SCSI_IPS=y
CONFIG_SCSI_INITIO=y
CONFIG_SCSI_INIA100=y
CONFIG_SCSI_PPA=y
CONFIG_SCSI_IMM=y
# CONFIG_SCSI_IZIP_EPP16 is not set
# CONFIG_SCSI_IZIP_SLOW_CTR is not set
CONFIG_SCSI_STEX=y
CONFIG_SCSI_SYM53C8XX_2=y
CONFIG_SCSI_SYM53C8XX_DMA_ADDRESSING_MODE=1
CONFIG_SCSI_SYM53C8XX_DEFAULT_TAGS=16
CONFIG_SCSI_SYM53C8XX_MAX_TAGS=64
CONFIG_SCSI_SYM53C8XX_MMIO=y
CONFIG_SCSI_IPR=y
# CONFIG_SCSI_IPR_TRACE is not set
# CONFIG_SCSI_IPR_DUMP is not set
CONFIG_SCSI_QLOGIC_1280=y
CONFIG_SCSI_QLA_FC=y
# CONFIG_TCM_QLA2XXX is not set
CONFIG_SCSI_QLA_ISCSI=y
# CONFIG_SCSI_LPFC is not set
CONFIG_SCSI_DC395x=y
CONFIG_SCSI_DC390T=y
CONFIG_SCSI_DEBUG=y
CONFIG_SCSI_PMCRAID=y
CONFIG_SCSI_PM8001=y
CONFIG_SCSI_SRP=y
CONFIG_SCSI_BFA_FC=y
# CONFIG_SCSI_VIRTIO is not set
CONFIG_SCSI_LOWLEVEL_PCMCIA=y
CONFIG_PCMCIA_AHA152X=m
CONFIG_PCMCIA_FDOMAIN=m
CONFIG_PCMCIA_QLOGIC=m
CONFIG_PCMCIA_SYM53C500=m
CONFIG_SCSI_DH=y
CONFIG_SCSI_DH_RDAC=y
CONFIG_SCSI_DH_HP_SW=y
CONFIG_SCSI_DH_EMC=y
CONFIG_SCSI_DH_ALUA=y
CONFIG_SCSI_OSD_INITIATOR=y
CONFIG_SCSI_OSD_ULD=y
CONFIG_SCSI_OSD_DPRINT_SENSE=1
# CONFIG_SCSI_OSD_DEBUG is not set
CONFIG_ATA=y
# CONFIG_ATA_NONSTANDARD is not set
CONFIG_ATA_VERBOSE_ERROR=y
CONFIG_ATA_ACPI=y
CONFIG_SATA_PMP=y

#
# Controllers with non-SFF native interface
#
CONFIG_SATA_AHCI=y
# CONFIG_SATA_AHCI_PLATFORM is not set
CONFIG_SATA_INIC162X=y
CONFIG_SATA_ACARD_AHCI=y
CONFIG_SATA_SIL24=y
CONFIG_ATA_SFF=y

#
# SFF controllers with custom DMA interface
#
CONFIG_PDC_ADMA=y
CONFIG_SATA_QSTOR=y
CONFIG_SATA_SX4=y
CONFIG_ATA_BMDMA=y

#
# SATA SFF controllers with BMDMA
#
CONFIG_ATA_PIIX=y
CONFIG_SATA_MV=y
CONFIG_SATA_NV=y
CONFIG_SATA_PROMISE=y
CONFIG_SATA_SIL=y
CONFIG_SATA_SIS=y
CONFIG_SATA_SVW=y
CONFIG_SATA_ULI=y
CONFIG_SATA_VIA=y
CONFIG_SATA_VITESSE=y

#
# PATA SFF controllers with BMDMA
#
CONFIG_PATA_ALI=y
CONFIG_PATA_AMD=y
CONFIG_PATA_ARASAN_CF=y
CONFIG_PATA_ARTOP=y
CONFIG_PATA_ATIIXP=y
CONFIG_PATA_ATP867X=y
CONFIG_PATA_CMD64X=y
CONFIG_PATA_CS5520=y
CONFIG_PATA_CS5530=y
# CONFIG_PATA_CS5536 is not set
# CONFIG_PATA_CYPRESS is not set
CONFIG_PATA_EFAR=y
# CONFIG_PATA_HPT366 is not set
# CONFIG_PATA_HPT37X is not set
# CONFIG_PATA_HPT3X2N is not set
# CONFIG_PATA_HPT3X3 is not set
# CONFIG_PATA_IT8213 is not set
CONFIG_PATA_IT821X=y
CONFIG_PATA_JMICRON=y
CONFIG_PATA_MARVELL=y
CONFIG_PATA_NETCELL=y
# CONFIG_PATA_NINJA32 is not set
CONFIG_PATA_NS87415=y
CONFIG_PATA_OLDPIIX=y
# CONFIG_PATA_OPTIDMA is not set
CONFIG_PATA_PDC2027X=y
CONFIG_PATA_PDC_OLD=y
# CONFIG_PATA_RADISYS is not set
CONFIG_PATA_RDC=y
CONFIG_PATA_SC1200=y
CONFIG_PATA_SCH=y
CONFIG_PATA_SERVERWORKS=y
CONFIG_PATA_SIL680=y
CONFIG_PATA_SIS=y
CONFIG_PATA_TOSHIBA=y
CONFIG_PATA_TRIFLEX=y
CONFIG_PATA_VIA=y
# CONFIG_PATA_WINBOND is not set

#
# PIO-only SFF controllers
#
# CONFIG_PATA_CMD640_PCI is not set
CONFIG_PATA_MPIIX=y
CONFIG_PATA_NS87410=y
# CONFIG_PATA_OPTI is not set
CONFIG_PATA_PCMCIA=y
CONFIG_PATA_RZ1000=y

#
# Generic fallback / legacy drivers
#
# CONFIG_PATA_ACPI is not set
CONFIG_ATA_GENERIC=y
# CONFIG_PATA_LEGACY is not set
CONFIG_MD=y
CONFIG_BLK_DEV_MD=y
CONFIG_MD_AUTODETECT=y
CONFIG_MD_LINEAR=y
CONFIG_MD_RAID0=y
CONFIG_MD_RAID1=y
CONFIG_MD_RAID10=y
CONFIG_MD_RAID456=y
# CONFIG_MULTICORE_RAID456 is not set
CONFIG_MD_MULTIPATH=y
CONFIG_MD_FAULTY=y
CONFIG_BLK_DEV_DM=y
# CONFIG_DM_DEBUG is not set
CONFIG_DM_BUFIO=y
CONFIG_DM_PERSISTENT_DATA=y
CONFIG_DM_CRYPT=y
CONFIG_DM_SNAPSHOT=y
CONFIG_DM_THIN_PROVISIONING=y
# CONFIG_DM_DEBUG_BLOCK_STACK_TRACING is not set
# CONFIG_DM_DEBUG_SPACE_MAPS is not set
CONFIG_DM_MIRROR=y
CONFIG_DM_RAID=y
CONFIG_DM_LOG_USERSPACE=y
CONFIG_DM_ZERO=y
CONFIG_DM_MULTIPATH=y
CONFIG_DM_MULTIPATH_QL=y
CONFIG_DM_MULTIPATH_ST=y
CONFIG_DM_DELAY=y
CONFIG_DM_UEVENT=y
CONFIG_DM_FLAKEY=y
# CONFIG_DM_VERITY is not set
CONFIG_TARGET_CORE=y
CONFIG_TCM_IBLOCK=y
CONFIG_TCM_FILEIO=y
CONFIG_TCM_PSCSI=y
CONFIG_LOOPBACK_TARGET=y
CONFIG_TCM_FC=y
CONFIG_ISCSI_TARGET=y
# CONFIG_SBP_TARGET is not set
CONFIG_FUSION=y
CONFIG_FUSION_SPI=y
CONFIG_FUSION_FC=y
CONFIG_FUSION_SAS=y
CONFIG_FUSION_MAX_SGE=128
CONFIG_FUSION_CTL=y
CONFIG_FUSION_LAN=y
# CONFIG_FUSION_LOGGING is not set

#
# IEEE 1394 (FireWire) support
#
CONFIG_FIREWIRE=y
CONFIG_FIREWIRE_OHCI=y
CONFIG_FIREWIRE_SBP2=y
CONFIG_FIREWIRE_NET=y
CONFIG_FIREWIRE_NOSY=y
CONFIG_I2O=y
CONFIG_I2O_LCT_NOTIFY_ON_CHANGES=y
CONFIG_I2O_EXT_ADAPTEC=y
CONFIG_I2O_EXT_ADAPTEC_DMA64=y
CONFIG_I2O_CONFIG=y
CONFIG_I2O_CONFIG_OLD_IOCTL=y
CONFIG_I2O_BUS=y
CONFIG_I2O_BLOCK=y
CONFIG_I2O_SCSI=y
CONFIG_I2O_PROC=y
CONFIG_MACINTOSH_DRIVERS=y
CONFIG_MAC_EMUMOUSEBTN=y
CONFIG_NETDEVICES=y
CONFIG_NET_CORE=y
CONFIG_BONDING=y
CONFIG_DUMMY=y
CONFIG_EQUALIZER=y
CONFIG_NET_FC=y
CONFIG_MII=y
CONFIG_IEEE802154_DRIVERS=y
CONFIG_IEEE802154_FAKEHARD=y
CONFIG_IFB=y
# CONFIG_NET_TEAM is not set
CONFIG_MACVLAN=y
CONFIG_MACVTAP=y
CONFIG_NETCONSOLE=y
CONFIG_NETCONSOLE_DYNAMIC=y
CONFIG_NETPOLL=y
# CONFIG_NETPOLL_TRAP is not set
CONFIG_NET_POLL_CONTROLLER=y
CONFIG_TUN=y
CONFIG_VETH=y
CONFIG_VIRTIO_NET=y
CONFIG_SUNGEM_PHY=y
CONFIG_ARCNET=y
CONFIG_ARCNET_1201=y
CONFIG_ARCNET_1051=y
CONFIG_ARCNET_RAW=y
CONFIG_ARCNET_CAP=y
CONFIG_ARCNET_COM90xx=y
CONFIG_ARCNET_COM90xxIO=y
CONFIG_ARCNET_RIM_I=y
CONFIG_ARCNET_COM20020=y
CONFIG_ARCNET_COM20020_PCI=y
CONFIG_ARCNET_COM20020_CS=y
CONFIG_ATM_DRIVERS=y
CONFIG_ATM_DUMMY=y
CONFIG_ATM_TCP=y
CONFIG_ATM_LANAI=y
CONFIG_ATM_ENI=y
# CONFIG_ATM_ENI_DEBUG is not set
# CONFIG_ATM_ENI_TUNE_BURST is not set
CONFIG_ATM_FIRESTREAM=y
CONFIG_ATM_ZATM=y
# CONFIG_ATM_ZATM_DEBUG is not set
CONFIG_ATM_NICSTAR=y
CONFIG_ATM_NICSTAR_USE_SUNI=y
CONFIG_ATM_NICSTAR_USE_IDT77105=y
CONFIG_ATM_IDT77252=y
# CONFIG_ATM_IDT77252_DEBUG is not set
# CONFIG_ATM_IDT77252_RCV_ALL is not set
CONFIG_ATM_IDT77252_USE_SUNI=y
CONFIG_ATM_AMBASSADOR=y
# CONFIG_ATM_AMBASSADOR_DEBUG is not set
CONFIG_ATM_HORIZON=y
# CONFIG_ATM_HORIZON_DEBUG is not set
CONFIG_ATM_IA=y
# CONFIG_ATM_IA_DEBUG is not set
CONFIG_ATM_FORE200E=y
# CONFIG_ATM_FORE200E_USE_TASKLET is not set
CONFIG_ATM_FORE200E_TX_RETRY=16
CONFIG_ATM_FORE200E_DEBUG=0
CONFIG_ATM_HE=y
CONFIG_ATM_HE_USE_SUNI=y
CONFIG_ATM_SOLOS=y

#
# CAIF transport drivers
#
CONFIG_ETHERNET=y
CONFIG_MDIO=y
CONFIG_NET_VENDOR_3COM=y
CONFIG_PCMCIA_3C574=y
CONFIG_PCMCIA_3C589=y
CONFIG_VORTEX=y
CONFIG_TYPHOON=y
CONFIG_NET_VENDOR_ADAPTEC=y
CONFIG_ADAPTEC_STARFIRE=y
CONFIG_NET_VENDOR_ALTEON=y
CONFIG_ACENIC=y
# CONFIG_ACENIC_OMIT_TIGON_I is not set
CONFIG_NET_VENDOR_AMD=y
CONFIG_AMD8111_ETH=y
CONFIG_PCNET32=y
CONFIG_PCMCIA_NMCLAN=y
CONFIG_NET_VENDOR_ATHEROS=y
CONFIG_ATL2=y
CONFIG_ATL1=y
CONFIG_ATL1E=y
CONFIG_ATL1C=y
CONFIG_NET_VENDOR_BROADCOM=y
CONFIG_B44=y
CONFIG_B44_PCI_AUTOSELECT=y
CONFIG_B44_PCICORE_AUTOSELECT=y
CONFIG_B44_PCI=y
CONFIG_BNX2=y
CONFIG_CNIC=y
CONFIG_TIGON3=y
CONFIG_BNX2X=y
CONFIG_NET_VENDOR_BROCADE=y
CONFIG_BNA=y
# CONFIG_NET_CALXEDA_XGMAC is not set
CONFIG_NET_VENDOR_CHELSIO=y
CONFIG_CHELSIO_T1=y
CONFIG_CHELSIO_T1_1G=y
CONFIG_CHELSIO_T3=y
CONFIG_CHELSIO_T4=y
CONFIG_CHELSIO_T4VF=y
CONFIG_NET_VENDOR_CISCO=y
CONFIG_ENIC=y
CONFIG_DNET=y
CONFIG_NET_VENDOR_DEC=y
CONFIG_NET_TULIP=y
CONFIG_DE2104X=y
CONFIG_DE2104X_DSL=0
CONFIG_TULIP=y
# CONFIG_TULIP_MWI is not set
# CONFIG_TULIP_MMIO is not set
CONFIG_TULIP_NAPI=y
CONFIG_TULIP_NAPI_HW_MITIGATION=y
CONFIG_DE4X5=y
CONFIG_WINBOND_840=y
CONFIG_DM9102=y
CONFIG_ULI526X=y
CONFIG_PCMCIA_XIRCOM=y
CONFIG_NET_VENDOR_DLINK=y
CONFIG_DE600=y
CONFIG_DE620=y
CONFIG_DL2K=y
CONFIG_SUNDANCE=y
# CONFIG_SUNDANCE_MMIO is not set
CONFIG_NET_VENDOR_EMULEX=y
CONFIG_BE2NET=y
CONFIG_NET_VENDOR_EXAR=y
CONFIG_S2IO=y
CONFIG_VXGE=y
# CONFIG_VXGE_DEBUG_TRACE_ALL is not set
CONFIG_NET_VENDOR_FUJITSU=y
CONFIG_PCMCIA_FMVJ18X=y
CONFIG_NET_VENDOR_HP=y
CONFIG_HP100=y
CONFIG_NET_VENDOR_INTEL=y
CONFIG_E100=y
CONFIG_E1000=y
CONFIG_E1000E=y
CONFIG_IGB=y
CONFIG_IGB_DCA=y
CONFIG_IGB_PTP=y
CONFIG_IGBVF=y
CONFIG_IXGB=y
CONFIG_IXGBE=y
CONFIG_IXGBE_HWMON=y
CONFIG_IXGBE_DCA=y
CONFIG_IXGBE_DCB=y
# CONFIG_IXGBE_PTP is not set
CONFIG_IXGBEVF=y
CONFIG_NET_VENDOR_I825XX=y
# CONFIG_ZNET is not set
CONFIG_IP1000=y
CONFIG_JME=y
CONFIG_NET_VENDOR_MARVELL=y
CONFIG_SKGE=y
CONFIG_SKGE_DEBUG=y
CONFIG_SKGE_GENESIS=y
CONFIG_SKY2=y
CONFIG_SKY2_DEBUG=y
CONFIG_NET_VENDOR_MELLANOX=y
CONFIG_MLX4_EN=y
CONFIG_MLX4_EN_DCB=y
CONFIG_MLX4_CORE=y
CONFIG_MLX4_DEBUG=y
CONFIG_NET_VENDOR_MICREL=y
CONFIG_KS8842=y
CONFIG_KS8851=y
CONFIG_KS8851_MLL=y
CONFIG_KSZ884X_PCI=y
CONFIG_NET_VENDOR_MICROCHIP=y
CONFIG_ENC28J60=y
# CONFIG_ENC28J60_WRITEVERIFY is not set
CONFIG_NET_VENDOR_MYRI=y
CONFIG_MYRI10GE=y
CONFIG_MYRI10GE_DCA=y
CONFIG_FEALNX=y
CONFIG_NET_VENDOR_NATSEMI=y
CONFIG_NATSEMI=y
CONFIG_NS83820=y
CONFIG_NET_VENDOR_8390=y
CONFIG_PCMCIA_AXNET=y
CONFIG_NE2K_PCI=y
CONFIG_PCMCIA_PCNET=y
CONFIG_NET_VENDOR_NVIDIA=y
CONFIG_FORCEDETH=y
CONFIG_NET_VENDOR_OKI=y
CONFIG_PCH_GBE=y
CONFIG_ETHOC=y
CONFIG_NET_PACKET_ENGINE=y
CONFIG_HAMACHI=y
CONFIG_YELLOWFIN=y
CONFIG_NET_VENDOR_QLOGIC=y
CONFIG_QLA3XXX=y
CONFIG_QLCNIC=y
CONFIG_QLGE=y
CONFIG_NETXEN_NIC=y
CONFIG_NET_VENDOR_REALTEK=y
CONFIG_ATP=y
CONFIG_8139CP=y
CONFIG_8139TOO=y
CONFIG_8139TOO_PIO=y
CONFIG_8139TOO_TUNE_TWISTER=y
CONFIG_8139TOO_8129=y
# CONFIG_8139_OLD_RX_RESET is not set
CONFIG_R8169=y
CONFIG_NET_VENDOR_RDC=y
CONFIG_R6040=y
CONFIG_NET_VENDOR_SEEQ=y
# CONFIG_SEEQ8005 is not set
CONFIG_NET_VENDOR_SILAN=y
CONFIG_SC92031=y
CONFIG_NET_VENDOR_SIS=y
CONFIG_SIS900=y
CONFIG_SIS190=y
CONFIG_SFC=y
CONFIG_SFC_MTD=y
CONFIG_SFC_MCDI_MON=y
CONFIG_SFC_SRIOV=y
CONFIG_NET_VENDOR_SMSC=y
CONFIG_PCMCIA_SMC91C92=y
CONFIG_EPIC100=y
CONFIG_SMSC9420=y
CONFIG_NET_VENDOR_STMICRO=y
# CONFIG_STMMAC_ETH is not set
CONFIG_NET_VENDOR_SUN=y
CONFIG_HAPPYMEAL=y
CONFIG_SUNGEM=y
CONFIG_CASSINI=y
CONFIG_NIU=y
CONFIG_NET_VENDOR_TEHUTI=y
CONFIG_TEHUTI=y
CONFIG_NET_VENDOR_TI=y
CONFIG_TLAN=y
CONFIG_NET_VENDOR_VIA=y
CONFIG_VIA_RHINE=y
# CONFIG_VIA_RHINE_MMIO is not set
CONFIG_VIA_VELOCITY=y
CONFIG_NET_VENDOR_WIZNET=y
# CONFIG_WIZNET_W5100 is not set
# CONFIG_WIZNET_W5300 is not set
CONFIG_NET_VENDOR_XIRCOM=y
CONFIG_PCMCIA_XIRC2PS=y
CONFIG_FDDI=y
CONFIG_DEFXX=y
# CONFIG_DEFXX_MMIO is not set
CONFIG_SKFP=y
# CONFIG_HIPPI is not set
CONFIG_NET_SB1000=y
CONFIG_PHYLIB=y

#
# MII PHY device drivers
#
# CONFIG_AMD_PHY is not set
CONFIG_MARVELL_PHY=y
CONFIG_DAVICOM_PHY=y
CONFIG_QSEMI_PHY=y
CONFIG_LXT_PHY=y
CONFIG_CICADA_PHY=y
CONFIG_VITESSE_PHY=y
CONFIG_SMSC_PHY=y
CONFIG_BROADCOM_PHY=y
CONFIG_ICPLUS_PHY=y
CONFIG_REALTEK_PHY=y
CONFIG_NATIONAL_PHY=y
CONFIG_STE10XP=y
CONFIG_LSI_ET1011C_PHY=y
CONFIG_MICREL_PHY=y
# CONFIG_FIXED_PHY is not set
CONFIG_MDIO_BITBANG=y
# CONFIG_MDIO_GPIO is not set
# CONFIG_MICREL_KS8995MA is not set
CONFIG_PLIP=y
CONFIG_PPP=y
CONFIG_PPP_BSDCOMP=y
CONFIG_PPP_DEFLATE=y
CONFIG_PPP_FILTER=y
CONFIG_PPP_MPPE=y
CONFIG_PPP_MULTILINK=y
CONFIG_PPPOATM=y
CONFIG_PPPOE=y
CONFIG_PPTP=y
CONFIG_PPPOL2TP=y
CONFIG_PPP_ASYNC=y
CONFIG_PPP_SYNC_TTY=y
CONFIG_SLIP=y
CONFIG_SLHC=y
CONFIG_SLIP_COMPRESSED=y
CONFIG_SLIP_SMART=y
CONFIG_SLIP_MODE_SLIP6=y

#
# USB Network Adapters
#
CONFIG_USB_CATC=y
CONFIG_USB_KAWETH=y
CONFIG_USB_PEGASUS=y
CONFIG_USB_RTL8150=y
CONFIG_USB_USBNET=y
CONFIG_USB_NET_AX8817X=y
CONFIG_USB_NET_CDCETHER=y
CONFIG_USB_NET_CDC_EEM=y
CONFIG_USB_NET_CDC_NCM=y
CONFIG_USB_NET_DM9601=y
CONFIG_USB_NET_SMSC75XX=y
CONFIG_USB_NET_SMSC95XX=y
CONFIG_USB_NET_GL620A=y
CONFIG_USB_NET_NET1080=y
CONFIG_USB_NET_PLUSB=y
CONFIG_USB_NET_MCS7830=y
CONFIG_USB_NET_RNDIS_HOST=y
CONFIG_USB_NET_CDC_SUBSET=y
CONFIG_USB_ALI_M5632=y
CONFIG_USB_AN2720=y
CONFIG_USB_BELKIN=y
CONFIG_USB_ARMLINUX=y
CONFIG_USB_EPSON2888=y
CONFIG_USB_KC2190=y
CONFIG_USB_NET_ZAURUS=y
CONFIG_USB_NET_CX82310_ETH=y
CONFIG_USB_NET_KALMIA=y
# CONFIG_USB_NET_QMI_WWAN is not set
CONFIG_USB_HSO=y
CONFIG_USB_NET_INT51X1=y
CONFIG_USB_CDC_PHONET=y
CONFIG_USB_IPHETH=y
CONFIG_USB_SIERRA_NET=y
CONFIG_USB_VL600=y
CONFIG_WLAN=y
CONFIG_PCMCIA_RAYCS=y
CONFIG_LIBERTAS_THINFIRM=y
# CONFIG_LIBERTAS_THINFIRM_DEBUG is not set
CONFIG_LIBERTAS_THINFIRM_USB=y
CONFIG_AIRO=y
CONFIG_ATMEL=y
CONFIG_PCI_ATMEL=y
CONFIG_PCMCIA_ATMEL=y
CONFIG_AT76C50X_USB=y
CONFIG_AIRO_CS=y
CONFIG_PCMCIA_WL3501=y
# CONFIG_PRISM54 is not set
CONFIG_USB_ZD1201=y
CONFIG_USB_NET_RNDIS_WLAN=y
CONFIG_RTL8180=y
CONFIG_RTL8187=y
CONFIG_RTL8187_LEDS=y
CONFIG_ADM8211=y
CONFIG_MAC80211_HWSIM=y
CONFIG_MWL8K=y
CONFIG_ATH_COMMON=y
# CONFIG_ATH_DEBUG is not set
CONFIG_ATH5K=y
# CONFIG_ATH5K_DEBUG is not set
# CONFIG_ATH5K_TRACER is not set
CONFIG_ATH5K_PCI=y
CONFIG_ATH9K_HW=y
CONFIG_ATH9K_COMMON=y
CONFIG_ATH9K_BTCOEX_SUPPORT=y
CONFIG_ATH9K=y
CONFIG_ATH9K_PCI=y
# CONFIG_ATH9K_AHB is not set
# CONFIG_ATH9K_DEBUGFS is not set
CONFIG_ATH9K_RATE_CONTROL=y
CONFIG_ATH9K_HTC=y
# CONFIG_ATH9K_HTC_DEBUGFS is not set
CONFIG_CARL9170=y
CONFIG_CARL9170_LEDS=y
CONFIG_CARL9170_WPC=y
# CONFIG_CARL9170_HWRNG is not set
# CONFIG_ATH6KL is not set
CONFIG_B43=y
CONFIG_B43_BCMA=y
CONFIG_B43_BCMA_EXTRA=y
CONFIG_B43_SSB=y
CONFIG_B43_PCI_AUTOSELECT=y
CONFIG_B43_PCICORE_AUTOSELECT=y
CONFIG_B43_PCMCIA=y
CONFIG_B43_SDIO=y
CONFIG_B43_BCMA_PIO=y
CONFIG_B43_PIO=y
CONFIG_B43_PHY_N=y
CONFIG_B43_PHY_LP=y
CONFIG_B43_PHY_HT=y
CONFIG_B43_LEDS=y
CONFIG_B43_HWRNG=y
# CONFIG_B43_DEBUG is not set
CONFIG_B43LEGACY=y
CONFIG_B43LEGACY_PCI_AUTOSELECT=y
CONFIG_B43LEGACY_PCICORE_AUTOSELECT=y
CONFIG_B43LEGACY_LEDS=y
CONFIG_B43LEGACY_HWRNG=y
CONFIG_B43LEGACY_DEBUG=y
CONFIG_B43LEGACY_DMA=y
CONFIG_B43LEGACY_PIO=y
CONFIG_B43LEGACY_DMA_AND_PIO_MODE=y
# CONFIG_B43LEGACY_DMA_MODE is not set
# CONFIG_B43LEGACY_PIO_MODE is not set
# CONFIG_BRCMSMAC is not set
# CONFIG_BRCMFMAC is not set
CONFIG_HOSTAP=y
CONFIG_HOSTAP_FIRMWARE=y
# CONFIG_HOSTAP_FIRMWARE_NVRAM is not set
CONFIG_HOSTAP_PLX=y
CONFIG_HOSTAP_PCI=y
CONFIG_HOSTAP_CS=y
# CONFIG_IPW2100 is not set
CONFIG_IPW2200=y
CONFIG_IPW2200_MONITOR=y
CONFIG_IPW2200_RADIOTAP=y
CONFIG_IPW2200_PROMISCUOUS=y
CONFIG_IPW2200_QOS=y
# CONFIG_IPW2200_DEBUG is not set
CONFIG_LIBIPW=y
# CONFIG_LIBIPW_DEBUG is not set
CONFIG_IWLWIFI=y
CONFIG_IWLDVM=y

#
# Debugging Options
#
# CONFIG_IWLWIFI_DEBUG is not set
# CONFIG_IWLWIFI_DEVICE_TRACING is not set
CONFIG_IWLWIFI_P2P=y
# CONFIG_IWLWIFI_EXPERIMENTAL_MFP is not set
CONFIG_IWLEGACY=y
CONFIG_IWL4965=y
CONFIG_IWL3945=y

#
# iwl3945 / iwl4965 Debugging Options
#
# CONFIG_IWLEGACY_DEBUG is not set
CONFIG_IWM=y
# CONFIG_IWM_DEBUG is not set
# CONFIG_IWM_TRACING is not set
CONFIG_LIBERTAS=y
CONFIG_LIBERTAS_USB=y
CONFIG_LIBERTAS_CS=y
CONFIG_LIBERTAS_SDIO=y
CONFIG_LIBERTAS_SPI=y
# CONFIG_LIBERTAS_DEBUG is not set
CONFIG_LIBERTAS_MESH=y
CONFIG_HERMES=y
# CONFIG_HERMES_PRISM is not set
CONFIG_HERMES_CACHE_FW_ON_INIT=y
CONFIG_PLX_HERMES=y
CONFIG_TMD_HERMES=y
CONFIG_NORTEL_HERMES=y
CONFIG_PCMCIA_HERMES=y
CONFIG_PCMCIA_SPECTRUM=y
CONFIG_ORINOCO_USB=y
CONFIG_P54_COMMON=y
CONFIG_P54_USB=y
CONFIG_P54_PCI=y
CONFIG_P54_SPI=y
# CONFIG_P54_SPI_DEFAULT_EEPROM is not set
CONFIG_P54_LEDS=y
CONFIG_RT2X00=y
CONFIG_RT2400PCI=y
CONFIG_RT2500PCI=y
CONFIG_RT61PCI=y
CONFIG_RT2800PCI=y
CONFIG_RT2800PCI_RT33XX=y
CONFIG_RT2800PCI_RT35XX=y
CONFIG_RT2800PCI_RT53XX=y
CONFIG_RT2800PCI_RT3290=y
CONFIG_RT2500USB=y
CONFIG_RT73USB=y
CONFIG_RT2800USB=y
CONFIG_RT2800USB_RT33XX=y
CONFIG_RT2800USB_RT35XX=y
CONFIG_RT2800USB_RT53XX=y
# CONFIG_RT2800USB_UNKNOWN is not set
CONFIG_RT2800_LIB=y
CONFIG_RT2X00_LIB_PCI=y
CONFIG_RT2X00_LIB_USB=y
CONFIG_RT2X00_LIB=y
CONFIG_RT2X00_LIB_FIRMWARE=y
CONFIG_RT2X00_LIB_CRYPTO=y
CONFIG_RT2X00_LIB_LEDS=y
# CONFIG_RT2X00_DEBUG is not set
CONFIG_RTL8192CE=y
CONFIG_RTL8192SE=y
CONFIG_RTL8192DE=y
CONFIG_RTL8192CU=y
CONFIG_RTLWIFI=y
CONFIG_RTLWIFI_DEBUG=y
CONFIG_RTL8192C_COMMON=y
# CONFIG_WL_TI is not set
CONFIG_ZD1211RW=y
# CONFIG_ZD1211RW_DEBUG is not set
CONFIG_MWIFIEX=y
CONFIG_MWIFIEX_SDIO=y
CONFIG_MWIFIEX_PCIE=y
# CONFIG_MWIFIEX_USB is not set

#
# WiMAX Wireless Broadband devices
#
CONFIG_WIMAX_I2400M=y
CONFIG_WIMAX_I2400M_USB=y
CONFIG_WIMAX_I2400M_SDIO=y
CONFIG_WIMAX_IWMC3200_SDIO=y
CONFIG_WIMAX_I2400M_DEBUG_LEVEL=8
CONFIG_WAN=y
CONFIG_LANMEDIA=y
CONFIG_HDLC=y
CONFIG_HDLC_RAW=y
CONFIG_HDLC_RAW_ETH=y
CONFIG_HDLC_CISCO=y
CONFIG_HDLC_FR=y
CONFIG_HDLC_PPP=y
# CONFIG_HDLC_X25 is not set
CONFIG_PCI200SYN=y
CONFIG_WANXL=y
# CONFIG_PC300TOO is not set
CONFIG_FARSYNC=y
CONFIG_DSCC4=m
CONFIG_DSCC4_PCISYNC=y
CONFIG_DSCC4_PCI_RST=y
CONFIG_DLCI=y
CONFIG_DLCI_MAX=8
CONFIG_WAN_ROUTER_DRIVERS=y
CONFIG_CYCLADES_SYNC=y
# CONFIG_CYCLOMX_X25 is not set
CONFIG_SBNI=y
# CONFIG_SBNI_MULTILINE is not set
CONFIG_XEN_NETDEV_FRONTEND=y
CONFIG_XEN_NETDEV_BACKEND=y
CONFIG_VMXNET3=y
CONFIG_HYPERV_NET=y
CONFIG_ISDN=y
# CONFIG_ISDN_I4L is not set
CONFIG_ISDN_CAPI=y
CONFIG_ISDN_DRV_AVMB1_VERBOSE_REASON=y
CONFIG_CAPI_TRACE=y
CONFIG_ISDN_CAPI_MIDDLEWARE=y
CONFIG_ISDN_CAPI_CAPI20=y

#
# CAPI hardware drivers
#
CONFIG_CAPI_AVM=y
CONFIG_ISDN_DRV_AVMB1_B1PCI=y
CONFIG_ISDN_DRV_AVMB1_B1PCIV4=y
CONFIG_ISDN_DRV_AVMB1_B1PCMCIA=y
CONFIG_ISDN_DRV_AVMB1_AVM_CS=y
CONFIG_ISDN_DRV_AVMB1_T1PCI=y
CONFIG_ISDN_DRV_AVMB1_C4=y
# CONFIG_CAPI_EICON is not set
CONFIG_ISDN_DRV_GIGASET=y
CONFIG_GIGASET_CAPI=y
# CONFIG_GIGASET_DUMMYLL is not set
CONFIG_GIGASET_BASE=y
CONFIG_GIGASET_M105=y
CONFIG_GIGASET_M101=y
# CONFIG_GIGASET_DEBUG is not set
CONFIG_HYSDN=m
CONFIG_HYSDN_CAPI=y
CONFIG_MISDN=y
CONFIG_MISDN_DSP=y
CONFIG_MISDN_L1OIP=y

#
# mISDN hardware drivers
#
CONFIG_MISDN_HFCPCI=y
CONFIG_MISDN_HFCMULTI=y
CONFIG_MISDN_HFCUSB=y
CONFIG_MISDN_AVMFRITZ=y
CONFIG_MISDN_SPEEDFAX=y
CONFIG_MISDN_INFINEON=y
CONFIG_MISDN_W6692=y
# CONFIG_MISDN_NETJET is not set
CONFIG_MISDN_IPAC=y
CONFIG_MISDN_ISAR=y

#
# Input device support
#
CONFIG_INPUT=y
CONFIG_INPUT_FF_MEMLESS=y
CONFIG_INPUT_POLLDEV=y
CONFIG_INPUT_SPARSEKMAP=y
# CONFIG_INPUT_MATRIXKMAP is not set

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
CONFIG_INPUT_MOUSEDEV_PSAUX=y
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
CONFIG_INPUT_JOYDEV=y
CONFIG_INPUT_EVDEV=y
# CONFIG_INPUT_EVBUG is not set

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
CONFIG_KEYBOARD_ADP5588=y
# CONFIG_KEYBOARD_ADP5589 is not set
CONFIG_KEYBOARD_ATKBD=y
# CONFIG_KEYBOARD_QT1070 is not set
CONFIG_KEYBOARD_QT2160=y
CONFIG_KEYBOARD_LKKBD=y
# CONFIG_KEYBOARD_GPIO is not set
# CONFIG_KEYBOARD_GPIO_POLLED is not set
# CONFIG_KEYBOARD_TCA6416 is not set
# CONFIG_KEYBOARD_TCA8418 is not set
# CONFIG_KEYBOARD_MATRIX is not set
CONFIG_KEYBOARD_LM8323=y
# CONFIG_KEYBOARD_LM8333 is not set
CONFIG_KEYBOARD_MAX7359=y
# CONFIG_KEYBOARD_MCS is not set
# CONFIG_KEYBOARD_MPR121 is not set
CONFIG_KEYBOARD_NEWTON=y
CONFIG_KEYBOARD_OPENCORES=y
CONFIG_KEYBOARD_STOWAWAY=y
CONFIG_KEYBOARD_SUNKBD=y
# CONFIG_KEYBOARD_OMAP4 is not set
CONFIG_KEYBOARD_XTKBD=y
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=y
CONFIG_MOUSE_PS2_ALPS=y
CONFIG_MOUSE_PS2_LOGIPS2PP=y
CONFIG_MOUSE_PS2_SYNAPTICS=y
CONFIG_MOUSE_PS2_LIFEBOOK=y
CONFIG_MOUSE_PS2_TRACKPOINT=y
CONFIG_MOUSE_PS2_ELANTECH=y
CONFIG_MOUSE_PS2_SENTELIC=y
# CONFIG_MOUSE_PS2_TOUCHKIT is not set
CONFIG_MOUSE_SERIAL=y
CONFIG_MOUSE_APPLETOUCH=y
CONFIG_MOUSE_BCM5974=y
CONFIG_MOUSE_VSXXXAA=y
# CONFIG_MOUSE_GPIO is not set
CONFIG_MOUSE_SYNAPTICS_I2C=y
# CONFIG_MOUSE_SYNAPTICS_USB is not set
CONFIG_INPUT_JOYSTICK=y
CONFIG_JOYSTICK_ANALOG=y
CONFIG_JOYSTICK_A3D=y
CONFIG_JOYSTICK_ADI=y
CONFIG_JOYSTICK_COBRA=y
CONFIG_JOYSTICK_GF2K=y
CONFIG_JOYSTICK_GRIP=y
CONFIG_JOYSTICK_GRIP_MP=y
CONFIG_JOYSTICK_GUILLEMOT=y
CONFIG_JOYSTICK_INTERACT=y
CONFIG_JOYSTICK_SIDEWINDER=y
CONFIG_JOYSTICK_TMDC=y
CONFIG_JOYSTICK_IFORCE=y
CONFIG_JOYSTICK_IFORCE_USB=y
CONFIG_JOYSTICK_IFORCE_232=y
CONFIG_JOYSTICK_WARRIOR=y
CONFIG_JOYSTICK_MAGELLAN=y
CONFIG_JOYSTICK_SPACEORB=y
CONFIG_JOYSTICK_SPACEBALL=y
CONFIG_JOYSTICK_STINGER=y
CONFIG_JOYSTICK_TWIDJOY=y
CONFIG_JOYSTICK_ZHENHUA=y
CONFIG_JOYSTICK_DB9=y
CONFIG_JOYSTICK_GAMECON=y
CONFIG_JOYSTICK_TURBOGRAFX=y
# CONFIG_JOYSTICK_AS5011 is not set
CONFIG_JOYSTICK_JOYDUMP=y
CONFIG_JOYSTICK_XPAD=y
CONFIG_JOYSTICK_XPAD_FF=y
CONFIG_JOYSTICK_XPAD_LEDS=y
CONFIG_JOYSTICK_WALKERA0701=y
CONFIG_INPUT_TABLET=y
CONFIG_TABLET_USB_ACECAD=y
CONFIG_TABLET_USB_AIPTEK=y
CONFIG_TABLET_USB_GTCO=y
CONFIG_TABLET_USB_HANWANG=y
CONFIG_TABLET_USB_KBTAB=y
CONFIG_TABLET_USB_WACOM=y
CONFIG_INPUT_TOUCHSCREEN=y
CONFIG_TOUCHSCREEN_ADS7846=y
CONFIG_TOUCHSCREEN_AD7877=y
CONFIG_TOUCHSCREEN_AD7879=y
CONFIG_TOUCHSCREEN_AD7879_I2C=y
# CONFIG_TOUCHSCREEN_AD7879_SPI is not set
# CONFIG_TOUCHSCREEN_ATMEL_MXT is not set
# CONFIG_TOUCHSCREEN_AUO_PIXCIR is not set
# CONFIG_TOUCHSCREEN_BU21013 is not set
# CONFIG_TOUCHSCREEN_CY8CTMG110 is not set
# CONFIG_TOUCHSCREEN_CYTTSP_CORE is not set
CONFIG_TOUCHSCREEN_DYNAPRO=y
CONFIG_TOUCHSCREEN_HAMPSHIRE=y
CONFIG_TOUCHSCREEN_EETI=y
# CONFIG_TOUCHSCREEN_EGALAX is not set
CONFIG_TOUCHSCREEN_FUJITSU=y
# CONFIG_TOUCHSCREEN_ILI210X is not set
CONFIG_TOUCHSCREEN_GUNZE=y
CONFIG_TOUCHSCREEN_ELO=y
CONFIG_TOUCHSCREEN_WACOM_W8001=y
# CONFIG_TOUCHSCREEN_WACOM_I2C is not set
# CONFIG_TOUCHSCREEN_MAX11801 is not set
CONFIG_TOUCHSCREEN_MCS5000=y
CONFIG_TOUCHSCREEN_MTOUCH=y
CONFIG_TOUCHSCREEN_INEXIO=y
CONFIG_TOUCHSCREEN_MK712=y
CONFIG_TOUCHSCREEN_PENMOUNT=y
CONFIG_TOUCHSCREEN_TOUCHRIGHT=y
CONFIG_TOUCHSCREEN_TOUCHWIN=y
# CONFIG_TOUCHSCREEN_PIXCIR is not set
CONFIG_TOUCHSCREEN_WM97XX=y
CONFIG_TOUCHSCREEN_WM9705=y
CONFIG_TOUCHSCREEN_WM9712=y
CONFIG_TOUCHSCREEN_WM9713=y
CONFIG_TOUCHSCREEN_USB_COMPOSITE=y
CONFIG_TOUCHSCREEN_USB_EGALAX=y
CONFIG_TOUCHSCREEN_USB_PANJIT=y
CONFIG_TOUCHSCREEN_USB_3M=y
CONFIG_TOUCHSCREEN_USB_ITM=y
CONFIG_TOUCHSCREEN_USB_ETURBO=y
CONFIG_TOUCHSCREEN_USB_GUNZE=y
CONFIG_TOUCHSCREEN_USB_DMC_TSC10=y
CONFIG_TOUCHSCREEN_USB_IRTOUCH=y
CONFIG_TOUCHSCREEN_USB_IDEALTEK=y
CONFIG_TOUCHSCREEN_USB_GENERAL_TOUCH=y
CONFIG_TOUCHSCREEN_USB_GOTOP=y
CONFIG_TOUCHSCREEN_USB_JASTEC=y
CONFIG_TOUCHSCREEN_USB_ELO=y
CONFIG_TOUCHSCREEN_USB_E2I=y
CONFIG_TOUCHSCREEN_USB_ZYTRONIC=y
CONFIG_TOUCHSCREEN_USB_ETT_TC45USB=y
CONFIG_TOUCHSCREEN_USB_NEXIO=y
CONFIG_TOUCHSCREEN_USB_EASYTOUCH=y
CONFIG_TOUCHSCREEN_TOUCHIT213=y
# CONFIG_TOUCHSCREEN_TSC_SERIO is not set
# CONFIG_TOUCHSCREEN_TSC2005 is not set
CONFIG_TOUCHSCREEN_TSC2007=y
# CONFIG_TOUCHSCREEN_ST1232 is not set
CONFIG_TOUCHSCREEN_TPS6507X=y
CONFIG_INPUT_MISC=y
# CONFIG_INPUT_AD714X is not set
# CONFIG_INPUT_BMA150 is not set
CONFIG_INPUT_PCSPKR=y
# CONFIG_INPUT_MMA8450 is not set
# CONFIG_INPUT_MPU3050 is not set
CONFIG_INPUT_APANEL=y
# CONFIG_INPUT_GP2A is not set
# CONFIG_INPUT_GPIO_TILT_POLLED is not set
CONFIG_INPUT_ATLAS_BTNS=y
CONFIG_INPUT_ATI_REMOTE2=y
CONFIG_INPUT_KEYSPAN_REMOTE=y
# CONFIG_INPUT_KXTJ9 is not set
CONFIG_INPUT_POWERMATE=y
CONFIG_INPUT_YEALINK=y
CONFIG_INPUT_CM109=y
CONFIG_INPUT_UINPUT=y
CONFIG_INPUT_PCF50633_PMU=y
# CONFIG_INPUT_PCF8574 is not set
# CONFIG_INPUT_GPIO_ROTARY_ENCODER is not set
# CONFIG_INPUT_ADXL34X is not set
# CONFIG_INPUT_CMA3000 is not set
CONFIG_INPUT_XEN_KBDDEV_FRONTEND=y

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
CONFIG_SERIO_CT82C710=y
CONFIG_SERIO_PARKBD=y
CONFIG_SERIO_PCIPS2=y
CONFIG_SERIO_LIBPS2=y
CONFIG_SERIO_RAW=y
CONFIG_SERIO_ALTERA_PS2=y
# CONFIG_SERIO_PS2MULT is not set
CONFIG_GAMEPORT=y
CONFIG_GAMEPORT_NS558=y
CONFIG_GAMEPORT_L4=y
CONFIG_GAMEPORT_EMU10K1=y
CONFIG_GAMEPORT_FM801=y

#
# Character devices
#
CONFIG_VT=y
CONFIG_CONSOLE_TRANSLATIONS=y
CONFIG_VT_CONSOLE=y
CONFIG_VT_CONSOLE_SLEEP=y
CONFIG_HW_CONSOLE=y
CONFIG_VT_HW_CONSOLE_BINDING=y
CONFIG_UNIX98_PTYS=y
CONFIG_DEVPTS_MULTIPLE_INSTANCES=y
# CONFIG_LEGACY_PTYS is not set
CONFIG_SERIAL_NONSTANDARD=y
CONFIG_ROCKETPORT=y
CONFIG_CYCLADES=y
# CONFIG_CYZ_INTR is not set
CONFIG_MOXA_INTELLIO=y
CONFIG_MOXA_SMARTIO=y
CONFIG_SYNCLINK=y
CONFIG_SYNCLINKMP=y
CONFIG_SYNCLINK_GT=y
CONFIG_NOZOMI=y
CONFIG_ISI=y
CONFIG_N_HDLC=y
CONFIG_N_GSM=y
# CONFIG_TRACE_SINK is not set
# CONFIG_DEVKMEM is not set
CONFIG_STALDRV=y

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_PNP=y
CONFIG_SERIAL_8250_CS=y
CONFIG_SERIAL_8250_NR_UARTS=32
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
CONFIG_SERIAL_8250_EXTENDED=y
CONFIG_SERIAL_8250_MANY_PORTS=y
CONFIG_SERIAL_8250_SHARE_IRQ=y
# CONFIG_SERIAL_8250_DETECT_IRQ is not set
CONFIG_SERIAL_8250_RSA=y

#
# Non-8250 serial port support
#
CONFIG_SERIAL_MAX3100=y
# CONFIG_SERIAL_MAX3107 is not set
CONFIG_SERIAL_MFD_HSU=y
# CONFIG_SERIAL_MFD_HSU_CONSOLE is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
CONFIG_SERIAL_JSM=y
# CONFIG_SERIAL_TIMBERDALE is not set
# CONFIG_SERIAL_ALTERA_JTAGUART is not set
# CONFIG_SERIAL_ALTERA_UART is not set
# CONFIG_SERIAL_IFX6X60 is not set
CONFIG_SERIAL_PCH_UART=y
# CONFIG_SERIAL_PCH_UART_CONSOLE is not set
# CONFIG_SERIAL_XILINX_PS_UART is not set
CONFIG_PRINTER=y
# CONFIG_LP_CONSOLE is not set
CONFIG_PPDEV=y
CONFIG_HVC_DRIVER=y
CONFIG_HVC_IRQ=y
CONFIG_HVC_XEN=y
CONFIG_HVC_XEN_FRONTEND=y
CONFIG_VIRTIO_CONSOLE=y
CONFIG_IPMI_HANDLER=y
# CONFIG_IPMI_PANIC_EVENT is not set
CONFIG_IPMI_DEVICE_INTERFACE=y
CONFIG_IPMI_SI=y
CONFIG_IPMI_WATCHDOG=y
CONFIG_IPMI_POWEROFF=y
CONFIG_HW_RANDOM=y
CONFIG_HW_RANDOM_TIMERIOMEM=y
CONFIG_HW_RANDOM_INTEL=y
CONFIG_HW_RANDOM_AMD=y
CONFIG_HW_RANDOM_VIA=y
CONFIG_HW_RANDOM_VIRTIO=y
CONFIG_NVRAM=y
CONFIG_R3964=y
CONFIG_APPLICOM=y

#
# PCMCIA character devices
#
CONFIG_SYNCLINK_CS=y
CONFIG_CARDMAN_4000=y
CONFIG_CARDMAN_4040=y
CONFIG_IPWIRELESS=y
CONFIG_MWAVE=y
CONFIG_RAW_DRIVER=y
CONFIG_MAX_RAW_DEVS=256
CONFIG_HPET=y
CONFIG_HPET_MMAP=y
CONFIG_HANGCHECK_TIMER=y
CONFIG_TCG_TPM=y
CONFIG_TCG_TIS=y
CONFIG_TCG_NSC=y
CONFIG_TCG_ATMEL=y
CONFIG_TCG_INFINEON=y
CONFIG_TELCLOCK=y
CONFIG_DEVPORT=y
CONFIG_I2C=y
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_COMPAT=y
CONFIG_I2C_CHARDEV=y
# CONFIG_I2C_MUX is not set
CONFIG_I2C_HELPER_AUTO=y
CONFIG_I2C_SMBUS=y
CONFIG_I2C_ALGOBIT=y
CONFIG_I2C_ALGOPCA=y

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
CONFIG_I2C_ALI1535=y
CONFIG_I2C_ALI1563=y
CONFIG_I2C_ALI15X3=y
CONFIG_I2C_AMD756=y
CONFIG_I2C_AMD756_S4882=y
CONFIG_I2C_AMD8111=y
CONFIG_I2C_I801=y
CONFIG_I2C_ISCH=y
CONFIG_I2C_PIIX4=y
CONFIG_I2C_NFORCE2=y
CONFIG_I2C_NFORCE2_S4985=y
CONFIG_I2C_SIS5595=y
CONFIG_I2C_SIS630=y
CONFIG_I2C_SIS96X=y
CONFIG_I2C_VIA=y
CONFIG_I2C_VIAPRO=y

#
# ACPI drivers
#
CONFIG_I2C_SCMI=y

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
# CONFIG_I2C_DESIGNWARE_PCI is not set
CONFIG_I2C_EG20T=y
# CONFIG_I2C_GPIO is not set
# CONFIG_I2C_INTEL_MID is not set
CONFIG_I2C_OCORES=y
CONFIG_I2C_PCA_PLATFORM=y
# CONFIG_I2C_PXA_PCI is not set
CONFIG_I2C_SIMTEC=y
# CONFIG_I2C_XILINX is not set

#
# External I2C/SMBus adapter drivers
#
CONFIG_I2C_DIOLAN_U2C=y
CONFIG_I2C_PARPORT=y
CONFIG_I2C_PARPORT_LIGHT=y
CONFIG_I2C_TAOS_EVM=y
CONFIG_I2C_TINY_USB=y

#
# Other I2C/SMBus bus drivers
#
CONFIG_I2C_STUB=m
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
CONFIG_SPI=y
# CONFIG_SPI_DEBUG is not set
CONFIG_SPI_MASTER=y

#
# SPI Master Controller Drivers
#
# CONFIG_SPI_ALTERA is not set
CONFIG_SPI_BITBANG=y
CONFIG_SPI_BUTTERFLY=y
# CONFIG_SPI_GPIO is not set
CONFIG_SPI_LM70_LLP=y
# CONFIG_SPI_OC_TINY is not set
# CONFIG_SPI_PXA2XX_PCI is not set
CONFIG_SPI_TOPCLIFF_PCH=y
# CONFIG_SPI_XILINX is not set
# CONFIG_SPI_DESIGNWARE is not set

#
# SPI Protocol Masters
#
# CONFIG_SPI_SPIDEV is not set
CONFIG_SPI_TLE62X0=y
# CONFIG_HSI is not set

#
# PPS support
#
CONFIG_PPS=y
# CONFIG_PPS_DEBUG is not set

#
# PPS clients support
#
# CONFIG_PPS_CLIENT_KTIMER is not set
CONFIG_PPS_CLIENT_LDISC=y
CONFIG_PPS_CLIENT_PARPORT=y
# CONFIG_PPS_CLIENT_GPIO is not set

#
# PPS generators support
#

#
# PTP clock support
#
CONFIG_PTP_1588_CLOCK=y

#
# Enable PHYLIB and NETWORK_PHY_TIMESTAMPING to see the additional clocks.
#
# CONFIG_PTP_1588_CLOCK_PCH is not set
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
CONFIG_GPIOLIB=y
# CONFIG_DEBUG_GPIO is not set
# CONFIG_GPIO_SYSFS is not set

#
# Memory mapped GPIO drivers:
#
# CONFIG_GPIO_GENERIC_PLATFORM is not set
# CONFIG_GPIO_IT8761E is not set
# CONFIG_GPIO_SCH is not set
# CONFIG_GPIO_ICH is not set
# CONFIG_GPIO_VX855 is not set

#
# I2C GPIO expanders:
#
# CONFIG_GPIO_MAX7300 is not set
# CONFIG_GPIO_MAX732X is not set
# CONFIG_GPIO_PCA953X is not set
# CONFIG_GPIO_PCF857X is not set
# CONFIG_GPIO_SX150X is not set
# CONFIG_GPIO_ADP5588 is not set

#
# PCI GPIO expanders:
#
# CONFIG_GPIO_LANGWELL is not set
CONFIG_GPIO_PCH=y
CONFIG_GPIO_ML_IOH=y
# CONFIG_GPIO_RDC321X is not set

#
# SPI GPIO expanders:
#
# CONFIG_GPIO_MAX7301 is not set
# CONFIG_GPIO_MCP23S08 is not set
# CONFIG_GPIO_MC33880 is not set
# CONFIG_GPIO_74X164 is not set

#
# AC97 GPIO expanders:
#

#
# MODULbus GPIO expanders:
#
CONFIG_W1=y
CONFIG_W1_CON=y

#
# 1-wire Bus Masters
#
CONFIG_W1_MASTER_MATROX=y
CONFIG_W1_MASTER_DS2490=y
CONFIG_W1_MASTER_DS2482=y
# CONFIG_W1_MASTER_DS1WM is not set
# CONFIG_W1_MASTER_GPIO is not set

#
# 1-wire Slaves
#
CONFIG_W1_SLAVE_THERM=y
CONFIG_W1_SLAVE_SMEM=y
# CONFIG_W1_SLAVE_DS2408 is not set
# CONFIG_W1_SLAVE_DS2423 is not set
CONFIG_W1_SLAVE_DS2431=y
CONFIG_W1_SLAVE_DS2433=y
# CONFIG_W1_SLAVE_DS2433_CRC is not set
CONFIG_W1_SLAVE_DS2760=y
# CONFIG_W1_SLAVE_DS2780 is not set
# CONFIG_W1_SLAVE_DS2781 is not set
CONFIG_W1_SLAVE_BQ27000=y
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
CONFIG_PDA_POWER=y
# CONFIG_TEST_POWER is not set
CONFIG_BATTERY_DS2760=y
# CONFIG_BATTERY_DS2780 is not set
# CONFIG_BATTERY_DS2781 is not set
CONFIG_BATTERY_DS2782=y
# CONFIG_BATTERY_WM97XX is not set
# CONFIG_BATTERY_SBS is not set
CONFIG_BATTERY_BQ27x00=y
CONFIG_BATTERY_BQ27X00_I2C=y
CONFIG_BATTERY_BQ27X00_PLATFORM=y
CONFIG_BATTERY_MAX17040=y
# CONFIG_BATTERY_MAX17042 is not set
CONFIG_CHARGER_PCF50633=y
# CONFIG_CHARGER_ISP1704 is not set
# CONFIG_CHARGER_MAX8903 is not set
# CONFIG_CHARGER_LP8727 is not set
# CONFIG_CHARGER_GPIO is not set
# CONFIG_CHARGER_MANAGER is not set
# CONFIG_CHARGER_SMB347 is not set
CONFIG_HWMON=y
CONFIG_HWMON_VID=y
# CONFIG_HWMON_DEBUG_CHIP is not set

#
# Native drivers
#
CONFIG_SENSORS_ABITUGURU=y
CONFIG_SENSORS_ABITUGURU3=y
# CONFIG_SENSORS_AD7314 is not set
CONFIG_SENSORS_AD7414=y
CONFIG_SENSORS_AD7418=y
CONFIG_SENSORS_ADCXX=y
CONFIG_SENSORS_ADM1021=y
CONFIG_SENSORS_ADM1025=y
CONFIG_SENSORS_ADM1026=y
CONFIG_SENSORS_ADM1029=y
CONFIG_SENSORS_ADM1031=y
CONFIG_SENSORS_ADM9240=y
CONFIG_SENSORS_ADT7411=y
CONFIG_SENSORS_ADT7462=y
CONFIG_SENSORS_ADT7470=y
CONFIG_SENSORS_ADT7475=y
CONFIG_SENSORS_ASC7621=y
CONFIG_SENSORS_K8TEMP=y
CONFIG_SENSORS_K10TEMP=y
CONFIG_SENSORS_FAM15H_POWER=y
CONFIG_SENSORS_ASB100=y
CONFIG_SENSORS_ATXP1=y
CONFIG_SENSORS_DS620=y
CONFIG_SENSORS_DS1621=y
CONFIG_SENSORS_I5K_AMB=y
CONFIG_SENSORS_F71805F=y
CONFIG_SENSORS_F71882FG=y
CONFIG_SENSORS_F75375S=y
CONFIG_SENSORS_FSCHMD=y
CONFIG_SENSORS_G760A=y
CONFIG_SENSORS_GL518SM=y
CONFIG_SENSORS_GL520SM=y
# CONFIG_SENSORS_GPIO_FAN is not set
CONFIG_SENSORS_CORETEMP=y
CONFIG_SENSORS_IBMAEM=y
CONFIG_SENSORS_IBMPEX=y
CONFIG_SENSORS_IT87=y
# CONFIG_SENSORS_JC42 is not set
CONFIG_SENSORS_LINEAGE=y
CONFIG_SENSORS_LM63=y
CONFIG_SENSORS_LM70=y
CONFIG_SENSORS_LM73=y
CONFIG_SENSORS_LM75=y
CONFIG_SENSORS_LM77=y
CONFIG_SENSORS_LM78=y
CONFIG_SENSORS_LM80=y
CONFIG_SENSORS_LM83=y
CONFIG_SENSORS_LM85=y
CONFIG_SENSORS_LM87=y
CONFIG_SENSORS_LM90=y
CONFIG_SENSORS_LM92=y
CONFIG_SENSORS_LM93=y
CONFIG_SENSORS_LTC4151=y
CONFIG_SENSORS_LTC4215=y
CONFIG_SENSORS_LTC4245=y
CONFIG_SENSORS_LTC4261=y
CONFIG_SENSORS_LM95241=y
CONFIG_SENSORS_LM95245=y
CONFIG_SENSORS_MAX1111=y
CONFIG_SENSORS_MAX16065=y
CONFIG_SENSORS_MAX1619=y
CONFIG_SENSORS_MAX1668=y
CONFIG_SENSORS_MAX6639=y
CONFIG_SENSORS_MAX6642=y
CONFIG_SENSORS_MAX6650=y
# CONFIG_SENSORS_MCP3021 is not set
CONFIG_SENSORS_NTC_THERMISTOR=y
CONFIG_SENSORS_PC87360=y
CONFIG_SENSORS_PC87427=y
CONFIG_SENSORS_PCF8591=y
# CONFIG_PMBUS is not set
# CONFIG_SENSORS_SHT15 is not set
CONFIG_SENSORS_SHT21=y
CONFIG_SENSORS_SIS5595=y
CONFIG_SENSORS_SMM665=y
CONFIG_SENSORS_DME1737=y
CONFIG_SENSORS_EMC1403=y
CONFIG_SENSORS_EMC2103=y
CONFIG_SENSORS_EMC6W201=y
CONFIG_SENSORS_SMSC47M1=y
CONFIG_SENSORS_SMSC47M192=y
CONFIG_SENSORS_SMSC47B397=y
CONFIG_SENSORS_SCH56XX_COMMON=y
CONFIG_SENSORS_SCH5627=y
# CONFIG_SENSORS_SCH5636 is not set
CONFIG_SENSORS_ADS1015=y
CONFIG_SENSORS_ADS7828=y
CONFIG_SENSORS_ADS7871=y
CONFIG_SENSORS_AMC6821=y
# CONFIG_SENSORS_INA2XX is not set
CONFIG_SENSORS_THMC50=y
CONFIG_SENSORS_TMP102=y
CONFIG_SENSORS_TMP401=y
CONFIG_SENSORS_TMP421=y
CONFIG_SENSORS_VIA_CPUTEMP=y
CONFIG_SENSORS_VIA686A=y
CONFIG_SENSORS_VT1211=y
CONFIG_SENSORS_VT8231=y
CONFIG_SENSORS_W83781D=y
CONFIG_SENSORS_W83791D=y
CONFIG_SENSORS_W83792D=y
CONFIG_SENSORS_W83793=y
CONFIG_SENSORS_W83795=y
# CONFIG_SENSORS_W83795_FANCTRL is not set
CONFIG_SENSORS_W83L785TS=y
CONFIG_SENSORS_W83L786NG=y
CONFIG_SENSORS_W83627HF=y
CONFIG_SENSORS_W83627EHF=y
CONFIG_SENSORS_APPLESMC=y

#
# ACPI drivers
#
CONFIG_SENSORS_ACPI_POWER=y
CONFIG_SENSORS_ATK0110=y
CONFIG_THERMAL=y
CONFIG_THERMAL_HWMON=y
CONFIG_WATCHDOG=y
CONFIG_WATCHDOG_CORE=y
# CONFIG_WATCHDOG_NOWAYOUT is not set

#
# Watchdog Device Drivers
#
CONFIG_SOFT_WATCHDOG=y
CONFIG_ACQUIRE_WDT=y
CONFIG_ADVANTECH_WDT=y
CONFIG_ALIM1535_WDT=y
CONFIG_ALIM7101_WDT=y
CONFIG_F71808E_WDT=y
CONFIG_SP5100_TCO=y
CONFIG_SC520_WDT=y
CONFIG_SBC_FITPC2_WATCHDOG=y
CONFIG_EUROTECH_WDT=y
CONFIG_IB700_WDT=y
CONFIG_IBMASR=y
CONFIG_WAFER_WDT=y
CONFIG_I6300ESB_WDT=y
# CONFIG_IE6XX_WDT is not set
CONFIG_ITCO_WDT=y
CONFIG_ITCO_VENDOR_SUPPORT=y
CONFIG_IT8712F_WDT=y
CONFIG_IT87_WDT=y
CONFIG_HP_WATCHDOG=y
CONFIG_HPWDT_NMI_DECODING=y
CONFIG_SC1200_WDT=y
CONFIG_PC87413_WDT=y
CONFIG_NV_TCO=y
CONFIG_60XX_WDT=y
CONFIG_SBC8360_WDT=y
CONFIG_CPU5_WDT=y
CONFIG_SMSC_SCH311X_WDT=y
CONFIG_SMSC37B787_WDT=y
# CONFIG_VIA_WDT is not set
CONFIG_W83627HF_WDT=y
CONFIG_W83697HF_WDT=y
CONFIG_W83697UG_WDT=y
CONFIG_W83877F_WDT=y
CONFIG_W83977F_WDT=y
CONFIG_MACHZ_WDT=y
CONFIG_SBC_EPX_C3_WATCHDOG=y
CONFIG_XEN_WDT=y

#
# PCI-based Watchdog Cards
#
CONFIG_PCIPCWATCHDOG=y
CONFIG_WDTPCI=y

#
# USB-based Watchdog Cards
#
CONFIG_USBPCWATCHDOG=y
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
CONFIG_SSB=y
CONFIG_SSB_SPROM=y
CONFIG_SSB_BLOCKIO=y
CONFIG_SSB_PCIHOST_POSSIBLE=y
CONFIG_SSB_PCIHOST=y
CONFIG_SSB_B43_PCI_BRIDGE=y
CONFIG_SSB_PCMCIAHOST_POSSIBLE=y
CONFIG_SSB_PCMCIAHOST=y
CONFIG_SSB_SDIOHOST_POSSIBLE=y
CONFIG_SSB_SDIOHOST=y
# CONFIG_SSB_DEBUG is not set
CONFIG_SSB_DRIVER_PCICORE_POSSIBLE=y
CONFIG_SSB_DRIVER_PCICORE=y
CONFIG_BCMA_POSSIBLE=y

#
# Broadcom specific AMBA
#
CONFIG_BCMA=y
CONFIG_BCMA_BLOCKIO=y
CONFIG_BCMA_HOST_PCI_POSSIBLE=y
CONFIG_BCMA_HOST_PCI=y
# CONFIG_BCMA_DEBUG is not set

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=y
# CONFIG_MFD_88PM860X is not set
CONFIG_MFD_SM501=y
# CONFIG_MFD_SM501_GPIO is not set
CONFIG_HTC_PASIC3=y
# CONFIG_HTC_I2CPLD is not set
# CONFIG_UCB1400_CORE is not set
# CONFIG_MFD_LM3533 is not set
# CONFIG_TPS6105X is not set
CONFIG_TPS65010=y
# CONFIG_TPS6507X is not set
# CONFIG_MFD_TPS65217 is not set
# CONFIG_MFD_TPS6586X is not set
# CONFIG_MFD_TPS65910 is not set
# CONFIG_MFD_TPS65912_I2C is not set
# CONFIG_MFD_TPS65912_SPI is not set
# CONFIG_TWL4030_CORE is not set
# CONFIG_TWL6040_CORE is not set
# CONFIG_MFD_STMPE is not set
# CONFIG_MFD_TC3589X is not set
# CONFIG_MFD_TMIO is not set
# CONFIG_PMIC_DA903X is not set
# CONFIG_MFD_DA9052_SPI is not set
# CONFIG_MFD_DA9052_I2C is not set
# CONFIG_PMIC_ADP5520 is not set
# CONFIG_MFD_MAX77693 is not set
# CONFIG_MFD_MAX8925 is not set
# CONFIG_MFD_MAX8997 is not set
# CONFIG_MFD_MAX8998 is not set
# CONFIG_MFD_S5M_CORE is not set
CONFIG_MFD_WM8400=y
# CONFIG_MFD_WM831X_I2C is not set
# CONFIG_MFD_WM831X_SPI is not set
# CONFIG_MFD_WM8350_I2C is not set
# CONFIG_MFD_WM8994 is not set
CONFIG_MFD_PCF50633=y
CONFIG_PCF50633_ADC=y
CONFIG_PCF50633_GPIO=y
# CONFIG_MFD_MC13XXX_SPI is not set
# CONFIG_MFD_MC13XXX_I2C is not set
# CONFIG_ABX500_CORE is not set
# CONFIG_EZX_PCAP is not set
# CONFIG_MFD_CS5535 is not set
# CONFIG_MFD_TIMBERDALE is not set
CONFIG_LPC_SCH=y
CONFIG_LPC_ICH=y
# CONFIG_MFD_RDC321X is not set
# CONFIG_MFD_JANZ_CMODIO is not set
# CONFIG_MFD_VX855 is not set
CONFIG_MFD_WL1273_CORE=y
# CONFIG_MFD_TPS65090 is not set
# CONFIG_MFD_AAT2870_CORE is not set
# CONFIG_MFD_RC5T583 is not set
# CONFIG_MFD_PALMAS is not set
CONFIG_REGULATOR=y
# CONFIG_REGULATOR_DEBUG is not set
# CONFIG_REGULATOR_DUMMY is not set
CONFIG_REGULATOR_FIXED_VOLTAGE=y
# CONFIG_REGULATOR_VIRTUAL_CONSUMER is not set
CONFIG_REGULATOR_USERSPACE_CONSUMER=y
# CONFIG_REGULATOR_GPIO is not set
# CONFIG_REGULATOR_AD5398 is not set
# CONFIG_REGULATOR_ISL6271A is not set
CONFIG_REGULATOR_MAX1586=y
CONFIG_REGULATOR_MAX8649=y
CONFIG_REGULATOR_MAX8660=y
# CONFIG_REGULATOR_MAX8952 is not set
CONFIG_REGULATOR_LP3971=y
# CONFIG_REGULATOR_LP3972 is not set
CONFIG_REGULATOR_PCF50633=y
# CONFIG_REGULATOR_TPS62360 is not set
CONFIG_REGULATOR_TPS65023=y
CONFIG_REGULATOR_TPS6507X=y
# CONFIG_REGULATOR_TPS6524X is not set
CONFIG_REGULATOR_WM8400=y
CONFIG_MEDIA_SUPPORT=y

#
# Multimedia core support
#
CONFIG_MEDIA_CONTROLLER=y
CONFIG_VIDEO_DEV=y
CONFIG_VIDEO_V4L2_COMMON=y
# CONFIG_VIDEO_V4L2_SUBDEV_API is not set
CONFIG_DVB_CORE=y
CONFIG_DVB_NET=y
CONFIG_VIDEO_MEDIA=y

#
# Multimedia drivers
#
CONFIG_VIDEO_SAA7146=y
CONFIG_VIDEO_SAA7146_VV=y
CONFIG_RC_CORE=y
CONFIG_LIRC=y
CONFIG_RC_MAP=y
CONFIG_IR_NEC_DECODER=y
CONFIG_IR_RC5_DECODER=y
CONFIG_IR_RC6_DECODER=y
CONFIG_IR_JVC_DECODER=y
CONFIG_IR_SONY_DECODER=y
CONFIG_IR_RC5_SZ_DECODER=y
CONFIG_IR_SANYO_DECODER=y
CONFIG_IR_MCE_KBD_DECODER=y
CONFIG_IR_LIRC_CODEC=y
# CONFIG_RC_ATI_REMOTE is not set
CONFIG_IR_ENE=y
CONFIG_IR_IMON=y
CONFIG_IR_MCEUSB=y
CONFIG_IR_ITE_CIR=y
CONFIG_IR_FINTEK=y
CONFIG_IR_NUVOTON=y
CONFIG_IR_REDRAT3=y
CONFIG_IR_STREAMZAP=y
CONFIG_IR_WINBOND_CIR=y
CONFIG_RC_LOOPBACK=y
# CONFIG_IR_GPIO_CIR is not set
CONFIG_MEDIA_ATTACH=y
CONFIG_MEDIA_TUNER=y
# CONFIG_MEDIA_TUNER_CUSTOMISE is not set
CONFIG_MEDIA_TUNER_SIMPLE=y
CONFIG_MEDIA_TUNER_TDA8290=y
CONFIG_MEDIA_TUNER_TDA827X=y
CONFIG_MEDIA_TUNER_TDA18271=y
CONFIG_MEDIA_TUNER_TDA9887=y
CONFIG_MEDIA_TUNER_TEA5761=y
CONFIG_MEDIA_TUNER_TEA5767=y
CONFIG_MEDIA_TUNER_MT20XX=y
CONFIG_MEDIA_TUNER_MT2060=y
CONFIG_MEDIA_TUNER_MT2266=y
CONFIG_MEDIA_TUNER_MT2131=y
CONFIG_MEDIA_TUNER_QT1010=y
CONFIG_MEDIA_TUNER_XC2028=y
CONFIG_MEDIA_TUNER_XC5000=y
CONFIG_MEDIA_TUNER_XC4000=y
CONFIG_MEDIA_TUNER_MXL5005S=y
CONFIG_MEDIA_TUNER_MXL5007T=y
CONFIG_MEDIA_TUNER_MC44S803=y
CONFIG_MEDIA_TUNER_MAX2165=y
CONFIG_MEDIA_TUNER_TDA18218=y
CONFIG_MEDIA_TUNER_TDA18212=y
CONFIG_VIDEO_V4L2=y
CONFIG_VIDEOBUF_GEN=y
CONFIG_VIDEOBUF_DMA_SG=y
CONFIG_VIDEOBUF_VMALLOC=y
CONFIG_VIDEOBUF_DVB=y
CONFIG_VIDEO_BTCX=y
CONFIG_VIDEO_TVEEPROM=y
CONFIG_VIDEO_TUNER=y
CONFIG_VIDEOBUF2_CORE=y
CONFIG_VIDEOBUF2_MEMOPS=y
CONFIG_VIDEOBUF2_VMALLOC=y
CONFIG_VIDEO_CAPTURE_DRIVERS=y
# CONFIG_VIDEO_ADV_DEBUG is not set
# CONFIG_VIDEO_FIXED_MINOR_RANGES is not set
CONFIG_VIDEO_HELPER_CHIPS_AUTO=y
CONFIG_VIDEO_IR_I2C=y

#
# Audio decoders, processors and mixers
#
CONFIG_VIDEO_TVAUDIO=y
CONFIG_VIDEO_TDA7432=y
CONFIG_VIDEO_TDA9840=y
CONFIG_VIDEO_TEA6415C=y
CONFIG_VIDEO_TEA6420=y
CONFIG_VIDEO_MSP3400=y
CONFIG_VIDEO_CS5345=y
CONFIG_VIDEO_CS53L32A=y
CONFIG_VIDEO_WM8775=y
CONFIG_VIDEO_WM8739=y
CONFIG_VIDEO_VP27SMPX=y

#
# RDS decoders
#
CONFIG_VIDEO_SAA6588=y

#
# Video decoders
#
CONFIG_VIDEO_BT819=y
CONFIG_VIDEO_BT856=y
CONFIG_VIDEO_BT866=y
CONFIG_VIDEO_KS0127=y
CONFIG_VIDEO_SAA7110=y
CONFIG_VIDEO_SAA711X=y
CONFIG_VIDEO_TVP5150=y
CONFIG_VIDEO_VPX3220=y

#
# Video and audio decoders
#
CONFIG_VIDEO_SAA717X=y
CONFIG_VIDEO_CX25840=y

#
# MPEG video encoders
#
CONFIG_VIDEO_CX2341X=y

#
# Video encoders
#
CONFIG_VIDEO_SAA7127=y
CONFIG_VIDEO_SAA7185=y
CONFIG_VIDEO_ADV7170=y
CONFIG_VIDEO_ADV7175=y

#
# Camera sensor devices
#
CONFIG_VIDEO_MT9V011=y

#
# Flash devices
#

#
# Video improvement chips
#
CONFIG_VIDEO_UPD64031A=y
CONFIG_VIDEO_UPD64083=y

#
# Miscelaneous helper chips
#
CONFIG_VIDEO_M52790=y
CONFIG_VIDEO_VIVI=y
CONFIG_V4L_USB_DRIVERS=y
CONFIG_VIDEO_AU0828=y
CONFIG_USB_VIDEO_CLASS=y
CONFIG_USB_VIDEO_CLASS_INPUT_EVDEV=y
CONFIG_USB_GSPCA=y
CONFIG_USB_M5602=y
CONFIG_USB_STV06XX=y
CONFIG_USB_GL860=y
CONFIG_USB_GSPCA_BENQ=y
CONFIG_USB_GSPCA_CONEX=y
CONFIG_USB_GSPCA_CPIA1=y
CONFIG_USB_GSPCA_ETOMS=y
CONFIG_USB_GSPCA_FINEPIX=y
CONFIG_USB_GSPCA_JEILINJ=y
# CONFIG_USB_GSPCA_JL2005BCD is not set
CONFIG_USB_GSPCA_KINECT=y
CONFIG_USB_GSPCA_KONICA=y
CONFIG_USB_GSPCA_MARS=y
CONFIG_USB_GSPCA_MR97310A=y
CONFIG_USB_GSPCA_NW80X=y
CONFIG_USB_GSPCA_OV519=y
CONFIG_USB_GSPCA_OV534=y
CONFIG_USB_GSPCA_OV534_9=y
CONFIG_USB_GSPCA_PAC207=y
CONFIG_USB_GSPCA_PAC7302=y
CONFIG_USB_GSPCA_PAC7311=y
CONFIG_USB_GSPCA_SE401=y
CONFIG_USB_GSPCA_SN9C2028=y
CONFIG_USB_GSPCA_SN9C20X=y
CONFIG_USB_GSPCA_SONIXB=y
CONFIG_USB_GSPCA_SONIXJ=y
CONFIG_USB_GSPCA_SPCA500=y
CONFIG_USB_GSPCA_SPCA501=y
CONFIG_USB_GSPCA_SPCA505=y
CONFIG_USB_GSPCA_SPCA506=y
CONFIG_USB_GSPCA_SPCA508=y
CONFIG_USB_GSPCA_SPCA561=y
CONFIG_USB_GSPCA_SPCA1528=y
CONFIG_USB_GSPCA_SQ905=y
CONFIG_USB_GSPCA_SQ905C=y
CONFIG_USB_GSPCA_SQ930X=y
CONFIG_USB_GSPCA_STK014=y
CONFIG_USB_GSPCA_STV0680=y
CONFIG_USB_GSPCA_SUNPLUS=y
CONFIG_USB_GSPCA_T613=y
# CONFIG_USB_GSPCA_TOPRO is not set
CONFIG_USB_GSPCA_TV8532=y
CONFIG_USB_GSPCA_VC032X=y
CONFIG_USB_GSPCA_VICAM=y
CONFIG_USB_GSPCA_XIRLINK_CIT=y
CONFIG_USB_GSPCA_ZC3XX=y
CONFIG_VIDEO_PVRUSB2=y
CONFIG_VIDEO_PVRUSB2_SYSFS=y
CONFIG_VIDEO_PVRUSB2_DVB=y
# CONFIG_VIDEO_PVRUSB2_DEBUGIFC is not set
CONFIG_VIDEO_HDPVR=y
CONFIG_VIDEO_EM28XX=y
CONFIG_VIDEO_EM28XX_ALSA=y
CONFIG_VIDEO_EM28XX_DVB=y
CONFIG_VIDEO_EM28XX_RC=y
CONFIG_VIDEO_TLG2300=y
CONFIG_VIDEO_CX231XX=y
CONFIG_VIDEO_CX231XX_RC=y
CONFIG_VIDEO_CX231XX_ALSA=y
CONFIG_VIDEO_CX231XX_DVB=y
CONFIG_VIDEO_TM6000=y
CONFIG_VIDEO_TM6000_ALSA=y
CONFIG_VIDEO_TM6000_DVB=y
CONFIG_VIDEO_USBVISION=y
CONFIG_USB_SN9C102=y
CONFIG_USB_PWC=y
# CONFIG_USB_PWC_DEBUG is not set
CONFIG_USB_PWC_INPUT_EVDEV=y
CONFIG_VIDEO_CPIA2=y
CONFIG_USB_ZR364XX=y
CONFIG_USB_STKWEBCAM=y
CONFIG_USB_S2255=y
CONFIG_V4L_PCI_DRIVERS=y
CONFIG_VIDEO_BT848=y
CONFIG_VIDEO_BT848_DVB=y
CONFIG_VIDEO_CX18=y
CONFIG_VIDEO_CX18_ALSA=y
CONFIG_VIDEO_CX23885=y
# CONFIG_MEDIA_ALTERA_CI is not set
# CONFIG_VIDEO_CX25821 is not set
CONFIG_VIDEO_CX88=y
CONFIG_VIDEO_CX88_ALSA=y
CONFIG_VIDEO_CX88_BLACKBIRD=y
CONFIG_VIDEO_CX88_DVB=y
CONFIG_VIDEO_CX88_VP3054=y
CONFIG_VIDEO_CX88_MPEG=y
CONFIG_VIDEO_HEXIUM_GEMINI=y
CONFIG_VIDEO_HEXIUM_ORION=y
CONFIG_VIDEO_IVTV=y
CONFIG_VIDEO_FB_IVTV=y
CONFIG_VIDEO_MEYE=y
CONFIG_VIDEO_MXB=y
CONFIG_VIDEO_SAA7134=y
CONFIG_VIDEO_SAA7134_ALSA=y
CONFIG_VIDEO_SAA7134_RC=y
CONFIG_VIDEO_SAA7134_DVB=y
CONFIG_VIDEO_SAA7164=y
CONFIG_VIDEO_ZORAN=y
CONFIG_VIDEO_ZORAN_DC30=y
CONFIG_VIDEO_ZORAN_ZR36060=y
CONFIG_VIDEO_ZORAN_BUZ=y
CONFIG_VIDEO_ZORAN_DC10=y
CONFIG_VIDEO_ZORAN_LML33=y
CONFIG_VIDEO_ZORAN_LML33R10=y
CONFIG_VIDEO_ZORAN_AVS6EYES=y
# CONFIG_V4L_ISA_PARPORT_DRIVERS is not set
# CONFIG_V4L_PLATFORM_DRIVERS is not set
CONFIG_V4L_MEM2MEM_DRIVERS=y
# CONFIG_VIDEO_MEM2MEM_TESTDEV is not set
CONFIG_RADIO_ADAPTERS=y
CONFIG_RADIO_SI470X=y
CONFIG_USB_SI470X=y
CONFIG_USB_MR800=y
CONFIG_USB_DSBR=y
CONFIG_RADIO_MAXIRADIO=y
CONFIG_I2C_SI4713=y
CONFIG_RADIO_SI4713=y
# CONFIG_USB_KEENE is not set
CONFIG_RADIO_TEA5764=y
CONFIG_RADIO_TEA5764_XTAL=y
CONFIG_RADIO_SAA7706H=y
CONFIG_RADIO_TEF6862=y
CONFIG_RADIO_WL1273=y

#
# Texas Instruments WL128x FM driver (ST based)
#
# CONFIG_RADIO_WL128X is not set
CONFIG_DVB_MAX_ADAPTERS=8
CONFIG_DVB_DYNAMIC_MINORS=y
CONFIG_DVB_CAPTURE_DRIVERS=y

#
# Supported SAA7146 based PCI Adapters
#
CONFIG_TTPCI_EEPROM=y
CONFIG_DVB_AV7110=y
CONFIG_DVB_AV7110_OSD=y
CONFIG_DVB_BUDGET_CORE=y
CONFIG_DVB_BUDGET=y
CONFIG_DVB_BUDGET_CI=y
CONFIG_DVB_BUDGET_AV=y
CONFIG_DVB_BUDGET_PATCH=y

#
# Supported USB Adapters
#
CONFIG_DVB_USB=y
# CONFIG_DVB_USB_DEBUG is not set
CONFIG_DVB_USB_A800=y
CONFIG_DVB_USB_DIBUSB_MB=y
CONFIG_DVB_USB_DIBUSB_MB_FAULTY=y
CONFIG_DVB_USB_DIBUSB_MC=y
CONFIG_DVB_USB_DIB0700=y
CONFIG_DVB_USB_UMT_010=y
CONFIG_DVB_USB_CXUSB=y
CONFIG_DVB_USB_M920X=y
CONFIG_DVB_USB_GL861=y
CONFIG_DVB_USB_AU6610=y
CONFIG_DVB_USB_DIGITV=y
CONFIG_DVB_USB_VP7045=y
CONFIG_DVB_USB_VP702X=y
CONFIG_DVB_USB_GP8PSK=y
CONFIG_DVB_USB_NOVA_T_USB2=y
CONFIG_DVB_USB_TTUSB2=y
CONFIG_DVB_USB_DTT200U=y
CONFIG_DVB_USB_OPERA1=y
CONFIG_DVB_USB_AF9005=y
CONFIG_DVB_USB_AF9005_REMOTE=y
# CONFIG_DVB_USB_PCTV452E is not set
CONFIG_DVB_USB_DW2102=y
CONFIG_DVB_USB_CINERGY_T2=y
CONFIG_DVB_USB_ANYSEE=y
CONFIG_DVB_USB_DTV5100=y
CONFIG_DVB_USB_AF9015=y
CONFIG_DVB_USB_CE6230=y
CONFIG_DVB_USB_FRIIO=y
CONFIG_DVB_USB_EC168=y
# CONFIG_DVB_USB_AZ6007 is not set
CONFIG_DVB_USB_AZ6027=y
CONFIG_DVB_USB_LME2510=y
CONFIG_DVB_USB_TECHNISAT_USB2=y
CONFIG_DVB_USB_IT913X=y
# CONFIG_DVB_USB_MXL111SF is not set
# CONFIG_DVB_USB_RTL28XXU is not set
# CONFIG_DVB_USB_AF9035 is not set
CONFIG_DVB_TTUSB_BUDGET=y
CONFIG_DVB_TTUSB_DEC=y
CONFIG_SMS_SIANO_MDTV=y

#
# Siano module components
#
CONFIG_SMS_USB_DRV=y
CONFIG_SMS_SDIO_DRV=y

#
# Supported FlexCopII (B2C2) Adapters
#
CONFIG_DVB_B2C2_FLEXCOP=y
CONFIG_DVB_B2C2_FLEXCOP_PCI=y
CONFIG_DVB_B2C2_FLEXCOP_USB=y
# CONFIG_DVB_B2C2_FLEXCOP_DEBUG is not set

#
# Supported BT878 Adapters
#
CONFIG_DVB_BT8XX=y

#
# Supported Pluto2 Adapters
#
CONFIG_DVB_PLUTO2=y

#
# Supported SDMC DM1105 Adapters
#
CONFIG_DVB_DM1105=y

#
# Supported FireWire (IEEE 1394) Adapters
#
CONFIG_DVB_FIREDTV=y
CONFIG_DVB_FIREDTV_INPUT=y

#
# Supported Earthsoft PT1 Adapters
#
CONFIG_DVB_PT1=y

#
# Supported Mantis Adapters
#
CONFIG_MANTIS_CORE=y
CONFIG_DVB_MANTIS=y
CONFIG_DVB_HOPPER=y

#
# Supported nGene Adapters
#
CONFIG_DVB_NGENE=y

#
# Supported ddbridge ('Octopus') Adapters
#
# CONFIG_DVB_DDBRIDGE is not set

#
# Supported DVB Frontends
#
# CONFIG_DVB_FE_CUSTOMISE is not set

#
# Multistandard (satellite) frontends
#
CONFIG_DVB_STB0899=y
CONFIG_DVB_STB6100=y
CONFIG_DVB_STV090x=y
CONFIG_DVB_STV6110x=y

#
# Multistandard (cable + terrestrial) frontends
#
CONFIG_DVB_DRXK=y
CONFIG_DVB_TDA18271C2DD=y

#
# DVB-S (satellite) frontends
#
CONFIG_DVB_CX24110=y
CONFIG_DVB_CX24123=y
CONFIG_DVB_MT312=y
CONFIG_DVB_ZL10036=y
CONFIG_DVB_ZL10039=y
CONFIG_DVB_S5H1420=y
CONFIG_DVB_STV0288=y
CONFIG_DVB_STB6000=y
CONFIG_DVB_STV0299=y
CONFIG_DVB_STV6110=y
CONFIG_DVB_STV0900=y
CONFIG_DVB_TDA8083=y
CONFIG_DVB_TDA10086=y
CONFIG_DVB_TDA8261=y
CONFIG_DVB_VES1X93=y
CONFIG_DVB_TUNER_ITD1000=y
CONFIG_DVB_TUNER_CX24113=y
CONFIG_DVB_TDA826X=y
CONFIG_DVB_TUA6100=y
CONFIG_DVB_CX24116=y
CONFIG_DVB_SI21XX=y
CONFIG_DVB_DS3000=y
CONFIG_DVB_MB86A16=y
CONFIG_DVB_TDA10071=y

#
# DVB-T (terrestrial) frontends
#
CONFIG_DVB_SP8870=y
CONFIG_DVB_SP887X=y
CONFIG_DVB_CX22700=y
CONFIG_DVB_CX22702=y
CONFIG_DVB_DRXD=y
CONFIG_DVB_L64781=y
CONFIG_DVB_TDA1004X=y
CONFIG_DVB_NXT6000=y
CONFIG_DVB_MT352=y
CONFIG_DVB_ZL10353=y
CONFIG_DVB_DIB3000MB=y
CONFIG_DVB_DIB3000MC=y
CONFIG_DVB_DIB7000M=y
CONFIG_DVB_DIB7000P=y
CONFIG_DVB_TDA10048=y
CONFIG_DVB_AF9013=y
CONFIG_DVB_EC100=y
CONFIG_DVB_STV0367=y
CONFIG_DVB_CXD2820R=y

#
# DVB-C (cable) frontends
#
CONFIG_DVB_VES1820=y
CONFIG_DVB_TDA10021=y
CONFIG_DVB_TDA10023=y
CONFIG_DVB_STV0297=y

#
# ATSC (North American/Korean Terrestrial/Cable DTV) frontends
#
CONFIG_DVB_NXT200X=y
CONFIG_DVB_OR51211=y
CONFIG_DVB_OR51132=y
CONFIG_DVB_BCM3510=y
CONFIG_DVB_LGDT330X=y
CONFIG_DVB_LGDT3305=y
CONFIG_DVB_S5H1409=y
CONFIG_DVB_AU8522=y
CONFIG_DVB_AU8522_DTV=y
CONFIG_DVB_AU8522_V4L=y
CONFIG_DVB_S5H1411=y

#
# ISDB-T (terrestrial) frontends
#
CONFIG_DVB_S921=y
CONFIG_DVB_DIB8000=y
CONFIG_DVB_MB86A20S=y

#
# Digital terrestrial only tuners/PLL
#
CONFIG_DVB_PLL=y
CONFIG_DVB_TUNER_DIB0070=y
CONFIG_DVB_TUNER_DIB0090=y

#
# SEC control devices for DVB-S
#
CONFIG_DVB_LNBP21=y
CONFIG_DVB_ISL6405=y
CONFIG_DVB_ISL6421=y
CONFIG_DVB_ISL6423=y
CONFIG_DVB_A8293=y
CONFIG_DVB_LGS8GXX=y
CONFIG_DVB_ATBM8830=y
CONFIG_DVB_TDA665x=y
CONFIG_DVB_IX2505V=y
CONFIG_DVB_IT913X_FE=y
CONFIG_DVB_M88RS2000=y

#
# Tools to develop new frontends
#
# CONFIG_DVB_DUMMY_FE is not set

#
# Graphics support
#
CONFIG_AGP=y
CONFIG_AGP_AMD64=y
CONFIG_AGP_INTEL=y
CONFIG_AGP_SIS=y
CONFIG_AGP_VIA=y
CONFIG_VGA_ARB=y
CONFIG_VGA_ARB_MAX_GPUS=16
CONFIG_VGA_SWITCHEROO=y
CONFIG_DRM=y
CONFIG_DRM_KMS_HELPER=y
# CONFIG_DRM_LOAD_EDID_FIRMWARE is not set
CONFIG_DRM_TTM=y
CONFIG_DRM_TDFX=y
CONFIG_DRM_R128=y
CONFIG_DRM_RADEON=y
CONFIG_DRM_RADEON_KMS=y
CONFIG_DRM_NOUVEAU=y
CONFIG_DRM_NOUVEAU_BACKLIGHT=y
# CONFIG_DRM_NOUVEAU_DEBUG is not set

#
# I2C encoder or helper chips
#
CONFIG_DRM_I2C_CH7006=y
CONFIG_DRM_I2C_SIL164=y
# CONFIG_DRM_I810 is not set
CONFIG_DRM_I915=y
CONFIG_DRM_I915_KMS=y
CONFIG_DRM_MGA=y
CONFIG_DRM_SIS=y
CONFIG_DRM_VIA=y
CONFIG_DRM_SAVAGE=y
CONFIG_DRM_VMWGFX=y
# CONFIG_DRM_GMA500 is not set
# CONFIG_DRM_UDL is not set
# CONFIG_DRM_AST is not set
# CONFIG_DRM_MGAG200 is not set
# CONFIG_DRM_CIRRUS_QEMU is not set
# CONFIG_STUB_POULSBO is not set
CONFIG_VGASTATE=y
CONFIG_VIDEO_OUTPUT_CONTROL=y
CONFIG_FB=y
CONFIG_FIRMWARE_EDID=y
CONFIG_FB_DDC=y
CONFIG_FB_BOOT_VESA_SUPPORT=y
CONFIG_FB_CFB_FILLRECT=y
CONFIG_FB_CFB_COPYAREA=y
CONFIG_FB_CFB_IMAGEBLIT=y
# CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
CONFIG_FB_SYS_FILLRECT=y
CONFIG_FB_SYS_COPYAREA=y
CONFIG_FB_SYS_IMAGEBLIT=y
# CONFIG_FB_FOREIGN_ENDIAN is not set
CONFIG_FB_SYS_FOPS=y
# CONFIG_FB_WMT_GE_ROPS is not set
CONFIG_FB_DEFERRED_IO=y
CONFIG_FB_HECUBA=y
CONFIG_FB_SVGALIB=y
# CONFIG_FB_MACMODES is not set
CONFIG_FB_BACKLIGHT=y
CONFIG_FB_MODE_HELPERS=y
CONFIG_FB_TILEBLITTING=y

#
# Frame buffer hardware drivers
#
# CONFIG_FB_CIRRUS is not set
CONFIG_FB_PM2=y
CONFIG_FB_PM2_FIFO_DISCONNECT=y
CONFIG_FB_CYBER2000=y
CONFIG_FB_CYBER2000_DDC=y
CONFIG_FB_ARC=y
# CONFIG_FB_ASILIANT is not set
# CONFIG_FB_IMSTT is not set
# CONFIG_FB_VGA16 is not set
CONFIG_FB_UVESA=y
CONFIG_FB_VESA=y
CONFIG_FB_EFI=y
CONFIG_FB_N411=y
CONFIG_FB_HGA=y
CONFIG_FB_S1D13XXX=y
CONFIG_FB_NVIDIA=y
# CONFIG_FB_NVIDIA_I2C is not set
# CONFIG_FB_NVIDIA_DEBUG is not set
CONFIG_FB_NVIDIA_BACKLIGHT=y
# CONFIG_FB_RIVA is not set
# CONFIG_FB_I740 is not set
CONFIG_FB_LE80578=y
CONFIG_FB_CARILLO_RANCH=y
CONFIG_FB_MATROX=y
CONFIG_FB_MATROX_MILLENIUM=y
CONFIG_FB_MATROX_MYSTIQUE=y
CONFIG_FB_MATROX_G=y
CONFIG_FB_MATROX_I2C=y
CONFIG_FB_MATROX_MAVEN=y
CONFIG_FB_RADEON=y
CONFIG_FB_RADEON_I2C=y
CONFIG_FB_RADEON_BACKLIGHT=y
# CONFIG_FB_RADEON_DEBUG is not set
CONFIG_FB_ATY128=y
CONFIG_FB_ATY128_BACKLIGHT=y
CONFIG_FB_ATY=y
CONFIG_FB_ATY_CT=y
# CONFIG_FB_ATY_GENERIC_LCD is not set
CONFIG_FB_ATY_GX=y
CONFIG_FB_ATY_BACKLIGHT=y
CONFIG_FB_S3=y
CONFIG_FB_S3_DDC=y
CONFIG_FB_SAVAGE=y
# CONFIG_FB_SAVAGE_I2C is not set
# CONFIG_FB_SAVAGE_ACCEL is not set
CONFIG_FB_SIS=y
CONFIG_FB_SIS_300=y
CONFIG_FB_SIS_315=y
CONFIG_FB_VIA=y
# CONFIG_FB_VIA_DIRECT_PROCFS is not set
CONFIG_FB_VIA_X_COMPATIBILITY=y
CONFIG_FB_NEOMAGIC=y
CONFIG_FB_KYRO=y
CONFIG_FB_3DFX=y
# CONFIG_FB_3DFX_ACCEL is not set
CONFIG_FB_3DFX_I2C=y
CONFIG_FB_VOODOO1=y
CONFIG_FB_VT8623=y
CONFIG_FB_TRIDENT=y
CONFIG_FB_ARK=y
CONFIG_FB_PM3=y
# CONFIG_FB_CARMINE is not set
# CONFIG_FB_GEODE is not set
# CONFIG_FB_TMIO is not set
CONFIG_FB_SM501=y
# CONFIG_FB_SMSCUFX is not set
CONFIG_FB_UDL=y
CONFIG_FB_VIRTUAL=y
CONFIG_XEN_FBDEV_FRONTEND=y
CONFIG_FB_METRONOME=y
CONFIG_FB_MB862XX=y
CONFIG_FB_MB862XX_PCI_GDC=y
CONFIG_FB_MB862XX_I2C=y
# CONFIG_FB_BROADSHEET is not set
# CONFIG_FB_AUO_K190X is not set
# CONFIG_EXYNOS_VIDEO is not set
CONFIG_BACKLIGHT_LCD_SUPPORT=y
# CONFIG_LCD_CLASS_DEVICE is not set
CONFIG_BACKLIGHT_CLASS_DEVICE=y
# CONFIG_BACKLIGHT_GENERIC is not set
CONFIG_BACKLIGHT_PROGEAR=y
CONFIG_BACKLIGHT_APPLE=y
# CONFIG_BACKLIGHT_SAHARA is not set
# CONFIG_BACKLIGHT_ADP8860 is not set
# CONFIG_BACKLIGHT_ADP8870 is not set
# CONFIG_BACKLIGHT_PCF50633 is not set
# CONFIG_BACKLIGHT_LP855X is not set

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
# CONFIG_VGACON_SOFT_SCROLLBACK is not set
CONFIG_DUMMY_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY=y
CONFIG_FRAMEBUFFER_CONSOLE_ROTATION=y
# CONFIG_FONTS is not set
CONFIG_FONT_8x8=y
CONFIG_FONT_8x16=y
# CONFIG_LOGO is not set
CONFIG_SOUND=y
CONFIG_SOUND_OSS_CORE=y
# CONFIG_SOUND_OSS_CORE_PRECLAIM is not set
CONFIG_SND=y
CONFIG_SND_TIMER=y
CONFIG_SND_PCM=y
CONFIG_SND_HWDEP=y
CONFIG_SND_RAWMIDI=y
CONFIG_SND_JACK=y
CONFIG_SND_SEQUENCER=y
CONFIG_SND_SEQ_DUMMY=y
CONFIG_SND_OSSEMUL=y
CONFIG_SND_MIXER_OSS=y
CONFIG_SND_PCM_OSS=y
CONFIG_SND_PCM_OSS_PLUGINS=y
# CONFIG_SND_SEQUENCER_OSS is not set
CONFIG_SND_HRTIMER=y
CONFIG_SND_SEQ_HRTIMER_DEFAULT=y
CONFIG_SND_DYNAMIC_MINORS=y
CONFIG_SND_SUPPORT_OLD_API=y
CONFIG_SND_VERBOSE_PROCFS=y
# CONFIG_SND_VERBOSE_PRINTK is not set
# CONFIG_SND_DEBUG is not set
CONFIG_SND_VMASTER=y
CONFIG_SND_KCTL_JACK=y
CONFIG_SND_DMA_SGBUF=y
CONFIG_SND_RAWMIDI_SEQ=y
CONFIG_SND_OPL3_LIB_SEQ=y
# CONFIG_SND_OPL4_LIB_SEQ is not set
# CONFIG_SND_SBAWE_SEQ is not set
CONFIG_SND_EMU10K1_SEQ=y
CONFIG_SND_MPU401_UART=y
CONFIG_SND_OPL3_LIB=y
CONFIG_SND_VX_LIB=y
CONFIG_SND_AC97_CODEC=y
CONFIG_SND_DRIVERS=y
CONFIG_SND_PCSP=y
CONFIG_SND_DUMMY=y
CONFIG_SND_ALOOP=y
CONFIG_SND_VIRMIDI=y
CONFIG_SND_MTPAV=y
CONFIG_SND_MTS64=y
CONFIG_SND_SERIAL_U16550=y
CONFIG_SND_MPU401=y
CONFIG_SND_PORTMAN2X4=y
CONFIG_SND_AC97_POWER_SAVE=y
CONFIG_SND_AC97_POWER_SAVE_DEFAULT=0
CONFIG_SND_SB_COMMON=y
CONFIG_SND_SB16_DSP=y
CONFIG_SND_TEA575X=y
CONFIG_SND_PCI=y
CONFIG_SND_AD1889=y
CONFIG_SND_ALS300=y
CONFIG_SND_ALS4000=y
CONFIG_SND_ALI5451=y
CONFIG_SND_ASIHPI=y
CONFIG_SND_ATIIXP=y
CONFIG_SND_ATIIXP_MODEM=y
CONFIG_SND_AU8810=y
CONFIG_SND_AU8820=y
CONFIG_SND_AU8830=y
# CONFIG_SND_AW2 is not set
CONFIG_SND_AZT3328=y
CONFIG_SND_BT87X=y
# CONFIG_SND_BT87X_OVERCLOCK is not set
CONFIG_SND_CA0106=y
CONFIG_SND_CMIPCI=y
CONFIG_SND_OXYGEN_LIB=y
CONFIG_SND_OXYGEN=y
CONFIG_SND_CS4281=y
CONFIG_SND_CS46XX=y
CONFIG_SND_CS46XX_NEW_DSP=y
CONFIG_SND_CS5530=y
CONFIG_SND_CS5535AUDIO=y
CONFIG_SND_CTXFI=y
CONFIG_SND_DARLA20=y
CONFIG_SND_GINA20=y
CONFIG_SND_LAYLA20=y
CONFIG_SND_DARLA24=y
CONFIG_SND_GINA24=y
CONFIG_SND_LAYLA24=y
CONFIG_SND_MONA=y
CONFIG_SND_MIA=y
CONFIG_SND_ECHO3G=y
CONFIG_SND_INDIGO=y
CONFIG_SND_INDIGOIO=y
CONFIG_SND_INDIGODJ=y
CONFIG_SND_INDIGOIOX=y
CONFIG_SND_INDIGODJX=y
CONFIG_SND_EMU10K1=y
CONFIG_SND_EMU10K1X=y
CONFIG_SND_ENS1370=y
CONFIG_SND_ENS1371=y
CONFIG_SND_ES1938=y
CONFIG_SND_ES1968=y
CONFIG_SND_ES1968_INPUT=y
CONFIG_SND_ES1968_RADIO=y
CONFIG_SND_FM801=y
CONFIG_SND_FM801_TEA575X_BOOL=y
CONFIG_SND_HDA_INTEL=y
CONFIG_SND_HDA_PREALLOC_SIZE=64
CONFIG_SND_HDA_HWDEP=y
CONFIG_SND_HDA_RECONFIG=y
CONFIG_SND_HDA_INPUT_BEEP=y
CONFIG_SND_HDA_INPUT_BEEP_MODE=1
CONFIG_SND_HDA_INPUT_JACK=y
CONFIG_SND_HDA_PATCH_LOADER=y
CONFIG_SND_HDA_CODEC_REALTEK=y
CONFIG_SND_HDA_ENABLE_REALTEK_QUIRKS=y
CONFIG_SND_HDA_CODEC_ANALOG=y
CONFIG_SND_HDA_CODEC_SIGMATEL=y
CONFIG_SND_HDA_CODEC_VIA=y
CONFIG_SND_HDA_CODEC_HDMI=y
CONFIG_SND_HDA_CODEC_CIRRUS=y
CONFIG_SND_HDA_CODEC_CONEXANT=y
CONFIG_SND_HDA_CODEC_CA0110=y
CONFIG_SND_HDA_CODEC_CA0132=y
CONFIG_SND_HDA_CODEC_CMEDIA=y
CONFIG_SND_HDA_CODEC_SI3054=y
CONFIG_SND_HDA_GENERIC=y
CONFIG_SND_HDA_POWER_SAVE=y
CONFIG_SND_HDA_POWER_SAVE_DEFAULT=0
CONFIG_SND_HDSP=y

#
# Don't forget to add built-in firmwares for HDSP driver
#
CONFIG_SND_HDSPM=y
CONFIG_SND_ICE1712=y
CONFIG_SND_ICE1724=y
CONFIG_SND_INTEL8X0=y
CONFIG_SND_INTEL8X0M=y
CONFIG_SND_KORG1212=y
CONFIG_SND_LOLA=y
CONFIG_SND_LX6464ES=y
CONFIG_SND_MAESTRO3=y
CONFIG_SND_MAESTRO3_INPUT=y
CONFIG_SND_MIXART=y
CONFIG_SND_NM256=y
CONFIG_SND_PCXHR=y
CONFIG_SND_RIPTIDE=y
CONFIG_SND_RME32=y
CONFIG_SND_RME96=y
CONFIG_SND_RME9652=y
CONFIG_SND_SONICVIBES=y
CONFIG_SND_TRIDENT=y
CONFIG_SND_VIA82XX=y
CONFIG_SND_VIA82XX_MODEM=y
CONFIG_SND_VIRTUOSO=y
CONFIG_SND_VX222=y
CONFIG_SND_YMFPCI=y
CONFIG_SND_SPI=y
CONFIG_SND_USB=y
CONFIG_SND_USB_AUDIO=y
CONFIG_SND_USB_UA101=y
CONFIG_SND_USB_USX2Y=y
CONFIG_SND_USB_CAIAQ=y
CONFIG_SND_USB_CAIAQ_INPUT=y
CONFIG_SND_USB_US122L=y
CONFIG_SND_USB_6FIRE=y
CONFIG_SND_FIREWIRE=y
CONFIG_SND_FIREWIRE_LIB=y
CONFIG_SND_FIREWIRE_SPEAKERS=y
CONFIG_SND_ISIGHT=y
CONFIG_SND_PCMCIA=y
CONFIG_SND_VXPOCKET=y
CONFIG_SND_PDAUDIOCF=y
# CONFIG_SND_SOC is not set
# CONFIG_SOUND_PRIME is not set
CONFIG_AC97_BUS=y
CONFIG_HID_SUPPORT=y
CONFIG_HID=y
# CONFIG_HID_BATTERY_STRENGTH is not set
CONFIG_HIDRAW=y

#
# USB Input Devices
#
CONFIG_USB_HID=y
CONFIG_HID_PID=y
CONFIG_USB_HIDDEV=y

#
# Special HID drivers
#
CONFIG_HID_GENERIC=y
CONFIG_HID_A4TECH=y
CONFIG_HID_ACRUX=y
# CONFIG_HID_ACRUX_FF is not set
CONFIG_HID_APPLE=y
# CONFIG_HID_AUREAL is not set
CONFIG_HID_BELKIN=y
CONFIG_HID_CHERRY=y
CONFIG_HID_CHICONY=y
CONFIG_HID_PRODIKEYS=y
CONFIG_HID_CYPRESS=y
CONFIG_HID_DRAGONRISE=y
CONFIG_DRAGONRISE_FF=y
CONFIG_HID_EMS_FF=y
CONFIG_HID_EZKEY=y
# CONFIG_HID_HOLTEK is not set
CONFIG_HID_KEYTOUCH=y
CONFIG_HID_KYE=y
CONFIG_HID_UCLOGIC=y
CONFIG_HID_WALTOP=y
CONFIG_HID_GYRATION=y
CONFIG_HID_TWINHAN=y
CONFIG_HID_KENSINGTON=y
CONFIG_HID_LCPOWER=y
CONFIG_HID_LOGITECH=y
CONFIG_HID_LOGITECH_DJ=y
CONFIG_LOGITECH_FF=y
CONFIG_LOGIRUMBLEPAD2_FF=y
CONFIG_LOGIG940_FF=y
CONFIG_LOGIWHEELS_FF=y
CONFIG_HID_MICROSOFT=y
CONFIG_HID_MONTEREY=y
CONFIG_HID_MULTITOUCH=y
CONFIG_HID_NTRIG=y
CONFIG_HID_ORTEK=y
CONFIG_HID_PANTHERLORD=y
CONFIG_PANTHERLORD_FF=y
CONFIG_HID_PETALYNX=y
CONFIG_HID_PICOLCD=y
CONFIG_HID_PICOLCD_FB=y
CONFIG_HID_PICOLCD_BACKLIGHT=y
CONFIG_HID_PICOLCD_LEDS=y
# CONFIG_HID_PRIMAX is not set
CONFIG_HID_ROCCAT=y
# CONFIG_HID_SAITEK is not set
CONFIG_HID_SAMSUNG=y
CONFIG_HID_SONY=y
# CONFIG_HID_SPEEDLINK is not set
CONFIG_HID_SUNPLUS=y
CONFIG_HID_GREENASIA=y
CONFIG_GREENASIA_FF=y
# CONFIG_HID_HYPERV_MOUSE is not set
CONFIG_HID_SMARTJOYPLUS=y
CONFIG_SMARTJOYPLUS_FF=y
# CONFIG_HID_TIVO is not set
CONFIG_HID_TOPSEED=y
CONFIG_HID_THRUSTMASTER=y
CONFIG_THRUSTMASTER_FF=y
CONFIG_HID_ZEROPLUS=y
CONFIG_ZEROPLUS_FF=y
CONFIG_HID_ZYDACRON=y
CONFIG_USB_ARCH_HAS_OHCI=y
CONFIG_USB_ARCH_HAS_EHCI=y
CONFIG_USB_ARCH_HAS_XHCI=y
CONFIG_USB_SUPPORT=y
CONFIG_USB_COMMON=y
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB=y
# CONFIG_USB_DEBUG is not set
CONFIG_USB_ANNOUNCE_NEW_DEVICES=y

#
# Miscellaneous USB options
#
CONFIG_USB_DYNAMIC_MINORS=y
CONFIG_USB_SUSPEND=y
# CONFIG_USB_OTG is not set
# CONFIG_USB_DWC3 is not set
CONFIG_USB_MON=y
CONFIG_USB_WUSB=y
CONFIG_USB_WUSB_CBAF=y
# CONFIG_USB_WUSB_CBAF_DEBUG is not set

#
# USB Host Controller Drivers
#
CONFIG_USB_C67X00_HCD=y
CONFIG_USB_XHCI_HCD=y
# CONFIG_USB_XHCI_HCD_DEBUGGING is not set
CONFIG_USB_EHCI_HCD=y
CONFIG_USB_EHCI_ROOT_HUB_TT=y
CONFIG_USB_EHCI_TT_NEWSCHED=y
# CONFIG_USB_OXU210HP_HCD is not set
CONFIG_USB_ISP116X_HCD=y
# CONFIG_USB_ISP1760_HCD is not set
# CONFIG_USB_ISP1362_HCD is not set
CONFIG_USB_OHCI_HCD=y
# CONFIG_USB_OHCI_HCD_SSB is not set
# CONFIG_USB_OHCI_HCD_PLATFORM is not set
# CONFIG_USB_EHCI_HCD_PLATFORM is not set
# CONFIG_USB_OHCI_BIG_ENDIAN_DESC is not set
# CONFIG_USB_OHCI_BIG_ENDIAN_MMIO is not set
CONFIG_USB_OHCI_LITTLE_ENDIAN=y
CONFIG_USB_UHCI_HCD=y
CONFIG_USB_U132_HCD=y
CONFIG_USB_SL811_HCD=y
# CONFIG_USB_SL811_HCD_ISO is not set
CONFIG_USB_SL811_CS=y
CONFIG_USB_R8A66597_HCD=y
CONFIG_USB_WHCI_HCD=y
CONFIG_USB_HWA_HCD=y
# CONFIG_USB_HCD_BCMA is not set
# CONFIG_USB_HCD_SSB is not set
# CONFIG_USB_MUSB_HDRC is not set
# CONFIG_USB_CHIPIDEA is not set
# CONFIG_USB_RENESAS_USBHS is not set

#
# USB Device Class drivers
#
CONFIG_USB_ACM=y
CONFIG_USB_PRINTER=y
CONFIG_USB_WDM=y
CONFIG_USB_TMC=y

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
#

#
# also be needed; see USB_STORAGE Help for more info
#
CONFIG_USB_STORAGE=y
# CONFIG_USB_STORAGE_DEBUG is not set
CONFIG_USB_STORAGE_REALTEK=y
CONFIG_REALTEK_AUTOPM=y
CONFIG_USB_STORAGE_DATAFAB=y
CONFIG_USB_STORAGE_FREECOM=y
CONFIG_USB_STORAGE_ISD200=y
CONFIG_USB_STORAGE_USBAT=y
CONFIG_USB_STORAGE_SDDR09=y
CONFIG_USB_STORAGE_SDDR55=y
CONFIG_USB_STORAGE_JUMPSHOT=y
CONFIG_USB_STORAGE_ALAUDA=y
CONFIG_USB_STORAGE_ONETOUCH=y
CONFIG_USB_STORAGE_KARMA=y
CONFIG_USB_STORAGE_CYPRESS_ATACB=y
CONFIG_USB_STORAGE_ENE_UB6250=y
CONFIG_USB_UAS=y
# CONFIG_USB_LIBUSUAL is not set

#
# USB Imaging devices
#
CONFIG_USB_MDC800=y
CONFIG_USB_MICROTEK=y

#
# USB port drivers
#
CONFIG_USB_USS720=y
CONFIG_USB_SERIAL=y
# CONFIG_USB_SERIAL_CONSOLE is not set
CONFIG_USB_EZUSB=y
CONFIG_USB_SERIAL_GENERIC=y
CONFIG_USB_SERIAL_AIRCABLE=y
CONFIG_USB_SERIAL_ARK3116=y
CONFIG_USB_SERIAL_BELKIN=y
CONFIG_USB_SERIAL_CH341=y
CONFIG_USB_SERIAL_WHITEHEAT=y
CONFIG_USB_SERIAL_DIGI_ACCELEPORT=y
CONFIG_USB_SERIAL_CP210X=y
CONFIG_USB_SERIAL_CYPRESS_M8=y
CONFIG_USB_SERIAL_EMPEG=y
CONFIG_USB_SERIAL_FTDI_SIO=y
CONFIG_USB_SERIAL_FUNSOFT=y
CONFIG_USB_SERIAL_VISOR=y
CONFIG_USB_SERIAL_IPAQ=y
CONFIG_USB_SERIAL_IR=y
CONFIG_USB_SERIAL_EDGEPORT=y
CONFIG_USB_SERIAL_EDGEPORT_TI=y
# CONFIG_USB_SERIAL_F81232 is not set
CONFIG_USB_SERIAL_GARMIN=y
CONFIG_USB_SERIAL_IPW=y
CONFIG_USB_SERIAL_IUU=y
CONFIG_USB_SERIAL_KEYSPAN_PDA=y
CONFIG_USB_SERIAL_KEYSPAN=y
CONFIG_USB_SERIAL_KLSI=y
CONFIG_USB_SERIAL_KOBIL_SCT=y
CONFIG_USB_SERIAL_MCT_U232=y
# CONFIG_USB_SERIAL_METRO is not set
CONFIG_USB_SERIAL_MOS7720=y
CONFIG_USB_SERIAL_MOS7715_PARPORT=y
CONFIG_USB_SERIAL_MOS7840=y
CONFIG_USB_SERIAL_MOTOROLA=y
CONFIG_USB_SERIAL_NAVMAN=y
CONFIG_USB_SERIAL_PL2303=y
CONFIG_USB_SERIAL_OTI6858=y
CONFIG_USB_SERIAL_QCAUX=y
CONFIG_USB_SERIAL_QUALCOMM=y
CONFIG_USB_SERIAL_SPCP8X5=y
CONFIG_USB_SERIAL_HP4X=y
CONFIG_USB_SERIAL_SAFE=y
# CONFIG_USB_SERIAL_SAFE_PADDED is not set
CONFIG_USB_SERIAL_SIEMENS_MPI=y
CONFIG_USB_SERIAL_SIERRAWIRELESS=y
CONFIG_USB_SERIAL_SYMBOL=y
CONFIG_USB_SERIAL_TI=y
CONFIG_USB_SERIAL_CYBERJACK=y
CONFIG_USB_SERIAL_XIRCOM=y
CONFIG_USB_SERIAL_WWAN=y
CONFIG_USB_SERIAL_OPTION=y
CONFIG_USB_SERIAL_OMNINET=y
CONFIG_USB_SERIAL_OPTICON=y
CONFIG_USB_SERIAL_VIVOPAY_SERIAL=y
CONFIG_USB_SERIAL_ZIO=y
CONFIG_USB_SERIAL_SSU100=y
# CONFIG_USB_SERIAL_QT2 is not set
CONFIG_USB_SERIAL_DEBUG=y

#
# USB Miscellaneous drivers
#
CONFIG_USB_EMI62=y
CONFIG_USB_EMI26=y
CONFIG_USB_ADUTUX=y
CONFIG_USB_SEVSEG=y
CONFIG_USB_RIO500=y
CONFIG_USB_LEGOTOWER=y
CONFIG_USB_LCD=y
CONFIG_USB_LED=y
CONFIG_USB_CYPRESS_CY7C63=y
CONFIG_USB_CYTHERM=y
CONFIG_USB_IDMOUSE=y
CONFIG_USB_FTDI_ELAN=y
CONFIG_USB_APPLEDISPLAY=y
CONFIG_USB_SISUSBVGA=y
CONFIG_USB_SISUSBVGA_CON=y
CONFIG_USB_LD=y
CONFIG_USB_TRANCEVIBRATOR=y
CONFIG_USB_IOWARRIOR=y
CONFIG_USB_TEST=y
CONFIG_USB_ISIGHTFW=y
CONFIG_USB_YUREX=y

#
# USB Physical Layer drivers
#
# CONFIG_USB_ISP1301 is not set
CONFIG_USB_ATM=y
CONFIG_USB_SPEEDTOUCH=y
CONFIG_USB_CXACRU=y
CONFIG_USB_UEAGLEATM=y
CONFIG_USB_XUSBATM=y
CONFIG_USB_GADGET=y
# CONFIG_USB_GADGET_DEBUG is not set
# CONFIG_USB_GADGET_DEBUG_FILES is not set
# CONFIG_USB_GADGET_DEBUG_FS is not set
CONFIG_USB_GADGET_VBUS_DRAW=2
CONFIG_USB_GADGET_STORAGE_NUM_BUFFERS=2

#
# USB Peripheral Controller
#
# CONFIG_USB_R8A66597 is not set
# CONFIG_USB_MV_UDC is not set
# CONFIG_USB_M66592 is not set
# CONFIG_USB_AMD5536UDC is not set
# CONFIG_USB_NET2272 is not set
# CONFIG_USB_NET2280 is not set
# CONFIG_USB_GOKU is not set
CONFIG_USB_EG20T=m
# CONFIG_USB_DUMMY_HCD is not set
CONFIG_USB_GADGET_DUALSPEED=y
# CONFIG_USB_ZERO is not set
# CONFIG_USB_AUDIO is not set
# CONFIG_USB_ETH is not set
# CONFIG_USB_G_NCM is not set
# CONFIG_USB_GADGETFS is not set
# CONFIG_USB_FUNCTIONFS is not set
# CONFIG_USB_FILE_STORAGE is not set
# CONFIG_USB_MASS_STORAGE is not set
# CONFIG_USB_GADGET_TARGET is not set
# CONFIG_USB_G_SERIAL is not set
# CONFIG_USB_MIDI_GADGET is not set
# CONFIG_USB_G_PRINTER is not set
# CONFIG_USB_CDC_COMPOSITE is not set
# CONFIG_USB_G_NOKIA is not set
# CONFIG_USB_G_ACM_MS is not set
# CONFIG_USB_G_MULTI is not set
# CONFIG_USB_G_HID is not set
# CONFIG_USB_G_DBGP is not set
# CONFIG_USB_G_WEBCAM is not set

#
# OTG and related infrastructure
#
CONFIG_USB_OTG_UTILS=y
# CONFIG_USB_GPIO_VBUS is not set
CONFIG_NOP_USB_XCEIV=y
CONFIG_UWB=y
CONFIG_UWB_HWA=y
CONFIG_UWB_WHCI=y
CONFIG_UWB_I1480U=y
CONFIG_MMC=y
# CONFIG_MMC_DEBUG is not set
# CONFIG_MMC_UNSAFE_RESUME is not set
# CONFIG_MMC_CLKGATE is not set

#
# MMC/SD/SDIO Card Drivers
#
CONFIG_MMC_BLOCK=y
CONFIG_MMC_BLOCK_MINORS=8
CONFIG_MMC_BLOCK_BOUNCE=y
CONFIG_SDIO_UART=y
# CONFIG_MMC_TEST is not set

#
# MMC/SD/SDIO Host Controller Drivers
#
CONFIG_MMC_SDHCI=y
CONFIG_MMC_SDHCI_PCI=y
CONFIG_MMC_RICOH_MMC=y
CONFIG_MMC_SDHCI_PLTFM=y
CONFIG_MMC_WBSD=y
CONFIG_MMC_TIFM_SD=y
CONFIG_MMC_SPI=y
CONFIG_MMC_SDRICOH_CS=y
CONFIG_MMC_CB710=y
CONFIG_MMC_VIA_SDMMC=y
CONFIG_MMC_VUB300=y
CONFIG_MMC_USHC=y
CONFIG_MEMSTICK=y
# CONFIG_MEMSTICK_DEBUG is not set

#
# MemoryStick drivers
#
# CONFIG_MEMSTICK_UNSAFE_RESUME is not set
CONFIG_MSPRO_BLOCK=y

#
# MemoryStick Host Controller Drivers
#
CONFIG_MEMSTICK_TIFM_MS=y
CONFIG_MEMSTICK_JMICRON_38X=y
CONFIG_MEMSTICK_R592=y
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y

#
# LED drivers
#
# CONFIG_LEDS_LM3530 is not set
CONFIG_LEDS_PCA9532=y
# CONFIG_LEDS_PCA9532_GPIO is not set
# CONFIG_LEDS_GPIO is not set
CONFIG_LEDS_LP3944=y
# CONFIG_LEDS_LP5521 is not set
# CONFIG_LEDS_LP5523 is not set
CONFIG_LEDS_CLEVO_MAIL=y
CONFIG_LEDS_PCA955X=y
# CONFIG_LEDS_PCA9633 is not set
CONFIG_LEDS_DAC124S085=y
CONFIG_LEDS_REGULATOR=y
CONFIG_LEDS_BD2802=y
CONFIG_LEDS_INTEL_SS4200=y
CONFIG_LEDS_LT3593=y
CONFIG_LEDS_DELL_NETBOOKS=y
# CONFIG_LEDS_TCA6507 is not set
# CONFIG_LEDS_OT200 is not set
CONFIG_LEDS_TRIGGERS=y

#
# LED Triggers
#
CONFIG_LEDS_TRIGGER_TIMER=y
CONFIG_LEDS_TRIGGER_IDE_DISK=y
CONFIG_LEDS_TRIGGER_HEARTBEAT=y
CONFIG_LEDS_TRIGGER_BACKLIGHT=y
# CONFIG_LEDS_TRIGGER_GPIO is not set
CONFIG_LEDS_TRIGGER_DEFAULT_ON=y

#
# iptables trigger is under Netfilter config (LED target)
#
# CONFIG_LEDS_TRIGGER_TRANSIENT is not set
CONFIG_ACCESSIBILITY=y
CONFIG_A11Y_BRAILLE_CONSOLE=y
CONFIG_INFINIBAND=y
CONFIG_INFINIBAND_USER_MAD=y
CONFIG_INFINIBAND_USER_ACCESS=y
CONFIG_INFINIBAND_USER_MEM=y
CONFIG_INFINIBAND_ADDR_TRANS=y
CONFIG_INFINIBAND_MTHCA=y
CONFIG_INFINIBAND_MTHCA_DEBUG=y
CONFIG_INFINIBAND_IPATH=y
CONFIG_INFINIBAND_QIB=y
CONFIG_INFINIBAND_AMSO1100=y
# CONFIG_INFINIBAND_AMSO1100_DEBUG is not set
CONFIG_INFINIBAND_CXGB3=y
# CONFIG_INFINIBAND_CXGB3_DEBUG is not set
CONFIG_INFINIBAND_CXGB4=y
CONFIG_MLX4_INFINIBAND=y
CONFIG_INFINIBAND_NES=y
# CONFIG_INFINIBAND_NES_DEBUG is not set
# CONFIG_INFINIBAND_OCRDMA is not set
CONFIG_INFINIBAND_IPOIB=y
CONFIG_INFINIBAND_IPOIB_CM=y
CONFIG_INFINIBAND_IPOIB_DEBUG=y
# CONFIG_INFINIBAND_IPOIB_DEBUG_DATA is not set
CONFIG_INFINIBAND_SRP=y
# CONFIG_INFINIBAND_SRPT is not set
CONFIG_INFINIBAND_ISER=y
CONFIG_EDAC=y

#
# Reporting subsystems
#
# CONFIG_EDAC_DEBUG is not set
CONFIG_EDAC_DECODE_MCE=y
# CONFIG_EDAC_MCE_INJ is not set
CONFIG_EDAC_MM_EDAC=y
CONFIG_EDAC_AMD64=y
# CONFIG_EDAC_AMD64_ERROR_INJECTION is not set
CONFIG_EDAC_E752X=y
CONFIG_EDAC_I82975X=y
CONFIG_EDAC_I3000=y
CONFIG_EDAC_I3200=y
CONFIG_EDAC_X38=y
CONFIG_EDAC_I5400=y
CONFIG_EDAC_I7CORE=y
CONFIG_EDAC_I5000=y
CONFIG_EDAC_I5100=y
CONFIG_EDAC_I7300=y
# CONFIG_EDAC_SBRIDGE is not set
CONFIG_RTC_LIB=y
CONFIG_RTC_CLASS=y
CONFIG_RTC_HCTOSYS=y
CONFIG_RTC_HCTOSYS_DEVICE="rtc0"
# CONFIG_RTC_DEBUG is not set

#
# RTC interfaces
#
CONFIG_RTC_INTF_SYSFS=y
CONFIG_RTC_INTF_PROC=y
CONFIG_RTC_INTF_DEV=y
# CONFIG_RTC_INTF_DEV_UIE_EMUL is not set
CONFIG_RTC_DRV_TEST=y

#
# I2C RTC drivers
#
CONFIG_RTC_DRV_DS1307=y
CONFIG_RTC_DRV_DS1374=y
CONFIG_RTC_DRV_DS1672=y
# CONFIG_RTC_DRV_DS3232 is not set
CONFIG_RTC_DRV_MAX6900=y
CONFIG_RTC_DRV_RS5C372=y
CONFIG_RTC_DRV_ISL1208=y
# CONFIG_RTC_DRV_ISL12022 is not set
CONFIG_RTC_DRV_X1205=y
CONFIG_RTC_DRV_PCF8563=y
CONFIG_RTC_DRV_PCF8583=y
CONFIG_RTC_DRV_M41T80=y
# CONFIG_RTC_DRV_M41T80_WDT is not set
CONFIG_RTC_DRV_BQ32K=y
CONFIG_RTC_DRV_S35390A=y
CONFIG_RTC_DRV_FM3130=y
CONFIG_RTC_DRV_RX8581=y
CONFIG_RTC_DRV_RX8025=y
# CONFIG_RTC_DRV_EM3027 is not set
# CONFIG_RTC_DRV_RV3029C2 is not set

#
# SPI RTC drivers
#
# CONFIG_RTC_DRV_M41T93 is not set
CONFIG_RTC_DRV_M41T94=y
CONFIG_RTC_DRV_DS1305=y
CONFIG_RTC_DRV_DS1390=y
CONFIG_RTC_DRV_MAX6902=y
CONFIG_RTC_DRV_R9701=y
CONFIG_RTC_DRV_RS5C348=y
CONFIG_RTC_DRV_DS3234=y
CONFIG_RTC_DRV_PCF2123=y

#
# Platform RTC drivers
#
CONFIG_RTC_DRV_CMOS=y
CONFIG_RTC_DRV_DS1286=y
CONFIG_RTC_DRV_DS1511=y
CONFIG_RTC_DRV_DS1553=y
CONFIG_RTC_DRV_DS1742=y
CONFIG_RTC_DRV_STK17TA8=y
CONFIG_RTC_DRV_M48T86=y
CONFIG_RTC_DRV_M48T35=y
CONFIG_RTC_DRV_M48T59=y
CONFIG_RTC_DRV_MSM6242=y
CONFIG_RTC_DRV_BQ4802=y
CONFIG_RTC_DRV_RP5C01=y
CONFIG_RTC_DRV_V3020=y
CONFIG_RTC_DRV_PCF50633=y

#
# on-CPU RTC drivers
#
CONFIG_DMADEVICES=y
# CONFIG_DMADEVICES_DEBUG is not set

#
# DMA Devices
#
# CONFIG_INTEL_MID_DMAC is not set
CONFIG_INTEL_IOATDMA=y
# CONFIG_TIMB_DMA is not set
CONFIG_PCH_DMA=y
CONFIG_DMA_ENGINE=y

#
# DMA Clients
#
CONFIG_NET_DMA=y
CONFIG_ASYNC_TX_DMA=y
# CONFIG_DMATEST is not set
CONFIG_DCA=y
# CONFIG_AUXDISPLAY is not set
CONFIG_UIO=y
CONFIG_UIO_CIF=y
CONFIG_UIO_PDRV=y
CONFIG_UIO_PDRV_GENIRQ=y
CONFIG_UIO_AEC=y
CONFIG_UIO_SERCOS3=y
CONFIG_UIO_PCI_GENERIC=y
CONFIG_UIO_NETX=y
CONFIG_VIRTIO=y
CONFIG_VIRTIO_RING=y

#
# Virtio drivers
#
CONFIG_VIRTIO_PCI=y
CONFIG_VIRTIO_BALLOON=y
CONFIG_VIRTIO_MMIO=y
# CONFIG_VIRTIO_MMIO_CMDLINE_DEVICES is not set

#
# Microsoft Hyper-V guest support
#
CONFIG_HYPERV=y
CONFIG_HYPERV_UTILS=y

#
# Xen driver support
#
CONFIG_XEN_BALLOON=y
# CONFIG_XEN_BALLOON_MEMORY_HOTPLUG is not set
CONFIG_XEN_SCRUB_PAGES=y
CONFIG_XEN_DEV_EVTCHN=y
CONFIG_XEN_BACKEND=y
CONFIG_XENFS=y
CONFIG_XEN_COMPAT_XENFS=y
CONFIG_XEN_SYS_HYPERVISOR=y
CONFIG_XEN_XENBUS_FRONTEND=y
CONFIG_XEN_GNTDEV=y
CONFIG_XEN_GRANT_DEV_ALLOC=y
CONFIG_SWIOTLB_XEN=y
CONFIG_XEN_PCIDEV_BACKEND=y
CONFIG_XEN_PRIVCMD=y
CONFIG_XEN_ACPI_PROCESSOR=m
CONFIG_STAGING=y
CONFIG_ET131X=y
# CONFIG_SLICOSS is not set
CONFIG_USBIP_CORE=y
CONFIG_USBIP_VHCI_HCD=y
CONFIG_USBIP_HOST=y
# CONFIG_USBIP_DEBUG is not set
# CONFIG_W35UND is not set
CONFIG_PRISM2_USB=y
# CONFIG_ECHO is not set
CONFIG_COMEDI=m
# CONFIG_COMEDI_DEBUG is not set
CONFIG_COMEDI_DEFAULT_BUF_SIZE_KB=2048
CONFIG_COMEDI_DEFAULT_BUF_MAXSIZE_KB=20480
CONFIG_COMEDI_MISC_DRIVERS=m
CONFIG_COMEDI_KCOMEDILIB=m
CONFIG_COMEDI_BOND=m
CONFIG_COMEDI_TEST=m
CONFIG_COMEDI_PARPORT=m
CONFIG_COMEDI_SERIAL2002=m
# CONFIG_COMEDI_SKEL is not set
CONFIG_COMEDI_PCI_DRIVERS=m
CONFIG_COMEDI_ADDI_APCI_035=m
CONFIG_COMEDI_ADDI_APCI_1032=m
CONFIG_COMEDI_ADDI_APCI_1500=m
CONFIG_COMEDI_ADDI_APCI_1516=m
CONFIG_COMEDI_ADDI_APCI_1564=m
CONFIG_COMEDI_ADDI_APCI_16XX=m
CONFIG_COMEDI_ADDI_APCI_2016=m
CONFIG_COMEDI_ADDI_APCI_2032=m
CONFIG_COMEDI_ADDI_APCI_2200=m
CONFIG_COMEDI_ADDI_APCI_3001=m
CONFIG_COMEDI_ADDI_APCI_3120=m
CONFIG_COMEDI_ADDI_APCI_3501=m
CONFIG_COMEDI_ADDI_APCI_3XXX=m
CONFIG_COMEDI_ADL_PCI6208=m
# CONFIG_COMEDI_ADL_PCI7230 is not set
CONFIG_COMEDI_ADL_PCI7296=m
CONFIG_COMEDI_ADL_PCI7432=m
CONFIG_COMEDI_ADL_PCI8164=m
CONFIG_COMEDI_ADL_PCI9111=m
CONFIG_COMEDI_ADL_PCI9118=m
CONFIG_COMEDI_ADV_PCI1710=m
CONFIG_COMEDI_ADV_PCI1723=m
CONFIG_COMEDI_ADV_PCI_DIO=m
# CONFIG_COMEDI_AMPLC_DIO200_PCI is not set
# CONFIG_COMEDI_AMPLC_PC236_PCI is not set
# CONFIG_COMEDI_AMPLC_PC263_PCI is not set
CONFIG_COMEDI_AMPLC_PCI224=m
CONFIG_COMEDI_AMPLC_PCI230=m
CONFIG_COMEDI_CONTEC_PCI_DIO=m
# CONFIG_COMEDI_DAS08_PCI is not set
CONFIG_COMEDI_DT3000=m
# CONFIG_COMEDI_DYNA_PCI10XX is not set
CONFIG_COMEDI_UNIOXX5=m
CONFIG_COMEDI_GSC_HPDI=m
CONFIG_COMEDI_ICP_MULTI=m
CONFIG_COMEDI_II_PCI20KC=m
CONFIG_COMEDI_DAQBOARD2000=m
CONFIG_COMEDI_JR3_PCI=m
CONFIG_COMEDI_KE_COUNTER=m
CONFIG_COMEDI_CB_PCIDAS64=m
CONFIG_COMEDI_CB_PCIDAS=m
CONFIG_COMEDI_CB_PCIDDA=m
CONFIG_COMEDI_CB_PCIDIO=m
CONFIG_COMEDI_CB_PCIMDAS=m
CONFIG_COMEDI_CB_PCIMDDA=m
CONFIG_COMEDI_ME4000=m
CONFIG_COMEDI_ME_DAQ=m
CONFIG_COMEDI_NI_6527=m
CONFIG_COMEDI_NI_65XX=m
CONFIG_COMEDI_NI_660X=m
CONFIG_COMEDI_NI_670X=m
CONFIG_COMEDI_NI_PCIDIO=m
CONFIG_COMEDI_NI_PCIMIO=m
CONFIG_COMEDI_RTD520=m
CONFIG_COMEDI_S526=m
CONFIG_COMEDI_S626=m
CONFIG_COMEDI_SSV_DNP=m
CONFIG_COMEDI_PCMCIA_DRIVERS=m
CONFIG_COMEDI_CB_DAS16_CS=m
CONFIG_COMEDI_DAS08_CS=m
CONFIG_COMEDI_NI_DAQ_700_CS=m
CONFIG_COMEDI_NI_DAQ_DIO24_CS=m
CONFIG_COMEDI_NI_LABPC_CS=m
CONFIG_COMEDI_NI_MIO_CS=m
CONFIG_COMEDI_QUATECH_DAQP_CS=m
CONFIG_COMEDI_USB_DRIVERS=m
CONFIG_COMEDI_DT9812=m
CONFIG_COMEDI_USBDUX=m
CONFIG_COMEDI_USBDUXFAST=m
# CONFIG_COMEDI_USBDUXSIGMA is not set
CONFIG_COMEDI_VMK80XX=m
CONFIG_COMEDI_NI_COMMON=m
CONFIG_COMEDI_MITE=m
CONFIG_COMEDI_NI_TIO=m
CONFIG_COMEDI_NI_LABPC=m
CONFIG_COMEDI_8255=m
CONFIG_COMEDI_FC=m
CONFIG_COMEDI_DAS08=m
# CONFIG_ASUS_OLED is not set
# CONFIG_PANEL is not set
CONFIG_R8187SE=m
CONFIG_RTL8192U=m
# CONFIG_RTLLIB is not set
CONFIG_R8712U=y
CONFIG_RTS_PSTOR=y
# CONFIG_RTS_PSTOR_DEBUG is not set
# CONFIG_RTS5139 is not set
# CONFIG_TRANZPORT is not set
# CONFIG_IDE_PHISON is not set
# CONFIG_LINE6_USB is not set
# CONFIG_USB_SERIAL_QUATECH2 is not set
# CONFIG_VT6655 is not set
CONFIG_VT6656=m
# CONFIG_DX_SEP is not set
CONFIG_ZRAM=y
# CONFIG_ZRAM_DEBUG is not set
CONFIG_ZSMALLOC=y
# CONFIG_WLAGS49_H2 is not set
# CONFIG_WLAGS49_H25 is not set
# CONFIG_FB_SM7XX is not set
# CONFIG_CRYSTALHD is not set
# CONFIG_CXT1E1 is not set
# CONFIG_FB_XGI is not set
# CONFIG_ACPI_QUICKSTART is not set
# CONFIG_SBE_2T3E3 is not set
# CONFIG_USB_ENESTORAGE is not set
# CONFIG_BCM_WIMAX is not set
# CONFIG_FT1000 is not set

#
# Speakup console speech
#
CONFIG_SPEAKUP=y
CONFIG_SPEAKUP_SYNTH_ACNTSA=y
CONFIG_SPEAKUP_SYNTH_ACNTPC=y
CONFIG_SPEAKUP_SYNTH_APOLLO=y
CONFIG_SPEAKUP_SYNTH_AUDPTR=y
CONFIG_SPEAKUP_SYNTH_BNS=y
CONFIG_SPEAKUP_SYNTH_DECTLK=y
CONFIG_SPEAKUP_SYNTH_DECEXT=y
# CONFIG_SPEAKUP_SYNTH_DECPC is not set
CONFIG_SPEAKUP_SYNTH_DTLK=y
CONFIG_SPEAKUP_SYNTH_KEYPC=y
CONFIG_SPEAKUP_SYNTH_LTLK=y
CONFIG_SPEAKUP_SYNTH_SOFT=y
CONFIG_SPEAKUP_SYNTH_SPKOUT=y
CONFIG_SPEAKUP_SYNTH_TXPRT=y
CONFIG_SPEAKUP_SYNTH_DUMMY=y
# CONFIG_TOUCHSCREEN_CLEARPAD_TM1217 is not set
# CONFIG_TOUCHSCREEN_SYNAPTICS_I2C_RMI4 is not set
CONFIG_STAGING_MEDIA=y
# CONFIG_DVB_AS102 is not set
# CONFIG_DVB_CXD2099 is not set
# CONFIG_VIDEO_DT3155 is not set
CONFIG_EASYCAP=y
# CONFIG_EASYCAP_DEBUG is not set
# CONFIG_VIDEO_GO7007 is not set
# CONFIG_SOLO6X10 is not set
CONFIG_LIRC_STAGING=y
CONFIG_LIRC_BT829=y
CONFIG_LIRC_IGORPLUGUSB=y
CONFIG_LIRC_IMON=y
# CONFIG_LIRC_PARALLEL is not set
CONFIG_LIRC_SASEM=y
CONFIG_LIRC_SERIAL=y
CONFIG_LIRC_SERIAL_TRANSMITTER=y
CONFIG_LIRC_SIR=y
CONFIG_LIRC_TTUSBIR=y
CONFIG_LIRC_ZILOG=y

#
# Android
#
# CONFIG_ANDROID is not set
CONFIG_PHONE=y
CONFIG_PHONE_IXJ=y
CONFIG_PHONE_IXJ_PCMCIA=y
# CONFIG_USB_WPAN_HCD is not set
# CONFIG_USB_G_CCG is not set
# CONFIG_IPACK_BUS is not set
# CONFIG_WIMAX_GDM72XX is not set
CONFIG_X86_PLATFORM_DEVICES=y
CONFIG_ACER_WMI=y
CONFIG_ACERHDF=y
CONFIG_ASUS_LAPTOP=y
CONFIG_DELL_LAPTOP=y
CONFIG_DELL_WMI=y
CONFIG_DELL_WMI_AIO=y
CONFIG_FUJITSU_LAPTOP=y
# CONFIG_FUJITSU_LAPTOP_DEBUG is not set
# CONFIG_FUJITSU_TABLET is not set
# CONFIG_AMILO_RFKILL is not set
CONFIG_HP_ACCEL=y
CONFIG_HP_WMI=y
CONFIG_MSI_LAPTOP=y
CONFIG_PANASONIC_LAPTOP=y
CONFIG_COMPAL_LAPTOP=y
CONFIG_SONY_LAPTOP=y
CONFIG_SONYPI_COMPAT=y
CONFIG_IDEAPAD_LAPTOP=y
CONFIG_THINKPAD_ACPI=y
CONFIG_THINKPAD_ACPI_ALSA_SUPPORT=y
# CONFIG_THINKPAD_ACPI_DEBUGFACILITIES is not set
# CONFIG_THINKPAD_ACPI_DEBUG is not set
# CONFIG_THINKPAD_ACPI_UNSAFE_LEDS is not set
CONFIG_THINKPAD_ACPI_VIDEO=y
CONFIG_THINKPAD_ACPI_HOTKEY_POLL=y
CONFIG_SENSORS_HDAPS=y
# CONFIG_INTEL_MENLOW is not set
CONFIG_EEEPC_LAPTOP=y
CONFIG_ASUS_WMI=y
CONFIG_ASUS_NB_WMI=y
CONFIG_EEEPC_WMI=y
CONFIG_ACPI_WMI=y
CONFIG_MSI_WMI=y
CONFIG_TOPSTAR_LAPTOP=y
CONFIG_ACPI_TOSHIBA=y
CONFIG_TOSHIBA_BT_RFKILL=y
CONFIG_ACPI_CMPC=y
CONFIG_INTEL_IPS=y
# CONFIG_IBM_RTL is not set
# CONFIG_XO15_EBOOK is not set
CONFIG_SAMSUNG_LAPTOP=y
CONFIG_MXM_WMI=y
CONFIG_INTEL_OAKTRAIL=y
# CONFIG_SAMSUNG_Q10 is not set
# CONFIG_APPLE_GMUX is not set

#
# Hardware Spinlock drivers
#
CONFIG_CLKEVT_I8253=y
CONFIG_I8253_LOCK=y
CONFIG_CLKBLD_I8253=y
CONFIG_IOMMU_API=y
CONFIG_IOMMU_SUPPORT=y
CONFIG_AMD_IOMMU=y
# CONFIG_AMD_IOMMU_STATS is not set
# CONFIG_AMD_IOMMU_V2 is not set
CONFIG_DMAR_TABLE=y
CONFIG_INTEL_IOMMU=y
# CONFIG_INTEL_IOMMU_DEFAULT_ON is not set
CONFIG_INTEL_IOMMU_FLOPPY_WA=y
CONFIG_IRQ_REMAP=y

#
# Remoteproc drivers (EXPERIMENTAL)
#

#
# Rpmsg drivers (EXPERIMENTAL)
#
# CONFIG_VIRT_DRIVERS is not set
# CONFIG_PM_DEVFREQ is not set
# CONFIG_EXTCON is not set
# CONFIG_MEMORY is not set
# CONFIG_IIO is not set
# CONFIG_VME_BUS is not set

#
# Firmware Drivers
#
CONFIG_EDD=y
# CONFIG_EDD_OFF is not set
CONFIG_FIRMWARE_MEMMAP=y
CONFIG_EFI_VARS=y
CONFIG_DELL_RBU=y
CONFIG_DCDBAS=y
CONFIG_DMIID=y
# CONFIG_DMI_SYSFS is not set
CONFIG_ISCSI_IBFT_FIND=y
CONFIG_ISCSI_IBFT=y
# CONFIG_GOOGLE_FIRMWARE is not set

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
CONFIG_EXT2_FS=y
CONFIG_EXT2_FS_XATTR=y
CONFIG_EXT2_FS_POSIX_ACL=y
CONFIG_EXT2_FS_SECURITY=y
# CONFIG_EXT2_FS_XIP is not set
CONFIG_EXT3_FS=y
CONFIG_EXT3_DEFAULTS_TO_ORDERED=y
CONFIG_EXT3_FS_XATTR=y
CONFIG_EXT3_FS_POSIX_ACL=y
CONFIG_EXT3_FS_SECURITY=y
CONFIG_EXT4_FS=y
CONFIG_EXT4_FS_XATTR=y
CONFIG_EXT4_FS_POSIX_ACL=y
CONFIG_EXT4_FS_SECURITY=y
# CONFIG_EXT4_DEBUG is not set
CONFIG_JBD=y
# CONFIG_JBD_DEBUG is not set
CONFIG_JBD2=y
# CONFIG_JBD2_DEBUG is not set
CONFIG_FS_MBCACHE=y
CONFIG_REISERFS_FS=y
# CONFIG_REISERFS_CHECK is not set
# CONFIG_REISERFS_PROC_INFO is not set
CONFIG_REISERFS_FS_XATTR=y
CONFIG_REISERFS_FS_POSIX_ACL=y
CONFIG_REISERFS_FS_SECURITY=y
CONFIG_JFS_FS=y
CONFIG_JFS_POSIX_ACL=y
CONFIG_JFS_SECURITY=y
# CONFIG_JFS_DEBUG is not set
# CONFIG_JFS_STATISTICS is not set
CONFIG_XFS_FS=y
CONFIG_XFS_QUOTA=y
CONFIG_XFS_POSIX_ACL=y
CONFIG_XFS_RT=y
# CONFIG_XFS_DEBUG is not set
CONFIG_GFS2_FS=y
CONFIG_GFS2_FS_LOCKING_DLM=y
CONFIG_OCFS2_FS=y
CONFIG_OCFS2_FS_O2CB=y
CONFIG_OCFS2_FS_USERSPACE_CLUSTER=y
CONFIG_OCFS2_FS_STATS=y
CONFIG_OCFS2_DEBUG_MASKLOG=y
# CONFIG_OCFS2_DEBUG_FS is not set
CONFIG_BTRFS_FS=y
CONFIG_BTRFS_FS_POSIX_ACL=y
# CONFIG_BTRFS_FS_CHECK_INTEGRITY is not set
CONFIG_NILFS2_FS=y
CONFIG_FS_POSIX_ACL=y
CONFIG_EXPORTFS=y
CONFIG_FILE_LOCKING=y
CONFIG_FSNOTIFY=y
CONFIG_DNOTIFY=y
CONFIG_INOTIFY_USER=y
CONFIG_FANOTIFY=y
# CONFIG_FANOTIFY_ACCESS_PERMISSIONS is not set
CONFIG_QUOTA=y
CONFIG_QUOTA_NETLINK_INTERFACE=y
CONFIG_PRINT_QUOTA_WARNING=y
# CONFIG_QUOTA_DEBUG is not set
CONFIG_QUOTA_TREE=y
CONFIG_QFMT_V1=y
CONFIG_QFMT_V2=y
CONFIG_QUOTACTL=y
CONFIG_QUOTACTL_COMPAT=y
CONFIG_AUTOFS4_FS=y
CONFIG_FUSE_FS=y
CONFIG_CUSE=y
CONFIG_GENERIC_ACL=y

#
# Caches
#
CONFIG_FSCACHE=y
CONFIG_FSCACHE_STATS=y
# CONFIG_FSCACHE_HISTOGRAM is not set
# CONFIG_FSCACHE_DEBUG is not set
# CONFIG_FSCACHE_OBJECT_LIST is not set
CONFIG_CACHEFILES=y
# CONFIG_CACHEFILES_DEBUG is not set
# CONFIG_CACHEFILES_HISTOGRAM is not set

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=y
CONFIG_JOLIET=y
CONFIG_ZISOFS=y
CONFIG_UDF_FS=y
CONFIG_UDF_NLS=y

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=y
CONFIG_MSDOS_FS=y
CONFIG_VFAT_FS=y
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_FAT_DEFAULT_IOCHARSET="utf8"
CONFIG_NTFS_FS=y
# CONFIG_NTFS_DEBUG is not set
CONFIG_NTFS_RW=y

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
CONFIG_TMPFS_POSIX_ACL=y
CONFIG_TMPFS_XATTR=y
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
CONFIG_CONFIGFS_FS=y
CONFIG_MISC_FILESYSTEMS=y
CONFIG_ADFS_FS=y
# CONFIG_ADFS_FS_RW is not set
CONFIG_AFFS_FS=y
CONFIG_ECRYPT_FS=y
CONFIG_HFS_FS=y
CONFIG_HFSPLUS_FS=y
CONFIG_BEFS_FS=y
# CONFIG_BEFS_DEBUG is not set
CONFIG_BFS_FS=y
CONFIG_EFS_FS=y
CONFIG_JFFS2_FS=y
CONFIG_JFFS2_FS_DEBUG=0
CONFIG_JFFS2_FS_WRITEBUFFER=y
# CONFIG_JFFS2_FS_WBUF_VERIFY is not set
CONFIG_JFFS2_SUMMARY=y
CONFIG_JFFS2_FS_XATTR=y
CONFIG_JFFS2_FS_POSIX_ACL=y
CONFIG_JFFS2_FS_SECURITY=y
CONFIG_JFFS2_COMPRESSION_OPTIONS=y
CONFIG_JFFS2_ZLIB=y
CONFIG_JFFS2_LZO=y
CONFIG_JFFS2_RTIME=y
# CONFIG_JFFS2_RUBIN is not set
# CONFIG_JFFS2_CMODE_NONE is not set
CONFIG_JFFS2_CMODE_PRIORITY=y
# CONFIG_JFFS2_CMODE_SIZE is not set
# CONFIG_JFFS2_CMODE_FAVOURLZO is not set
CONFIG_UBIFS_FS=y
CONFIG_UBIFS_FS_ADVANCED_COMPR=y
CONFIG_UBIFS_FS_LZO=y
CONFIG_UBIFS_FS_ZLIB=y
CONFIG_LOGFS=y
CONFIG_CRAMFS=y
CONFIG_SQUASHFS=y
CONFIG_SQUASHFS_XATTR=y
CONFIG_SQUASHFS_ZLIB=y
CONFIG_SQUASHFS_LZO=y
CONFIG_SQUASHFS_XZ=y
# CONFIG_SQUASHFS_4K_DEVBLK_SIZE is not set
# CONFIG_SQUASHFS_EMBEDDED is not set
CONFIG_SQUASHFS_FRAGMENT_CACHE_SIZE=3
CONFIG_VXFS_FS=y
CONFIG_MINIX_FS=y
CONFIG_OMFS_FS=y
# CONFIG_HPFS_FS is not set
CONFIG_QNX4FS_FS=y
# CONFIG_QNX6FS_FS is not set
CONFIG_ROMFS_FS=y
# CONFIG_ROMFS_BACKED_BY_BLOCK is not set
# CONFIG_ROMFS_BACKED_BY_MTD is not set
CONFIG_ROMFS_BACKED_BY_BOTH=y
CONFIG_ROMFS_ON_BLOCK=y
CONFIG_ROMFS_ON_MTD=y
CONFIG_PSTORE=y
# CONFIG_PSTORE_RAM is not set
CONFIG_SYSV_FS=y
CONFIG_UFS_FS=y
# CONFIG_UFS_FS_WRITE is not set
# CONFIG_UFS_DEBUG is not set
CONFIG_EXOFS_FS=y
# CONFIG_EXOFS_DEBUG is not set
CONFIG_ORE=y
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NFS_FS=y
CONFIG_NFS_V2=y
CONFIG_NFS_V3=y
CONFIG_NFS_V3_ACL=y
CONFIG_NFS_V4=y
CONFIG_NFS_V4_1=y
CONFIG_PNFS_FILE_LAYOUT=y
CONFIG_PNFS_BLOCK=m
CONFIG_PNFS_OBJLAYOUT=m
CONFIG_NFS_V4_1_IMPLEMENTATION_ID_DOMAIN="kernel.org"
CONFIG_ROOT_NFS=y
CONFIG_NFS_FSCACHE=y
# CONFIG_NFS_USE_LEGACY_DNS is not set
CONFIG_NFS_USE_KERNEL_DNS=y
CONFIG_NFSD=y
CONFIG_NFSD_V2_ACL=y
CONFIG_NFSD_V3=y
CONFIG_NFSD_V3_ACL=y
CONFIG_NFSD_V4=y
# CONFIG_NFSD_FAULT_INJECTION is not set
CONFIG_LOCKD=y
CONFIG_LOCKD_V4=y
CONFIG_NFS_ACL_SUPPORT=y
CONFIG_NFS_COMMON=y
CONFIG_SUNRPC=y
CONFIG_SUNRPC_GSS=y
CONFIG_SUNRPC_BACKCHANNEL=y
CONFIG_SUNRPC_XPRT_RDMA=y
CONFIG_RPCSEC_GSS_KRB5=y
# CONFIG_SUNRPC_DEBUG is not set
CONFIG_CEPH_FS=y
CONFIG_CIFS=y
# CONFIG_CIFS_STATS is not set
CONFIG_CIFS_WEAK_PW_HASH=y
CONFIG_CIFS_UPCALL=y
CONFIG_CIFS_XATTR=y
CONFIG_CIFS_POSIX=y
# CONFIG_CIFS_DEBUG2 is not set
CONFIG_CIFS_DFS_UPCALL=y
CONFIG_CIFS_FSCACHE=y
CONFIG_CIFS_ACL=y
CONFIG_NCP_FS=y
CONFIG_NCPFS_PACKET_SIGNING=y
CONFIG_NCPFS_IOCTL_LOCKING=y
CONFIG_NCPFS_STRONG=y
CONFIG_NCPFS_NFS_NS=y
CONFIG_NCPFS_OS2_NS=y
# CONFIG_NCPFS_SMALLDOS is not set
CONFIG_NCPFS_NLS=y
CONFIG_NCPFS_EXTRAS=y
CONFIG_CODA_FS=y
CONFIG_AFS_FS=y
# CONFIG_AFS_DEBUG is not set
CONFIG_AFS_FSCACHE=y
CONFIG_9P_FS=y
CONFIG_9P_FSCACHE=y
CONFIG_9P_FS_POSIX_ACL=y
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="utf8"
CONFIG_NLS_CODEPAGE_437=y
CONFIG_NLS_CODEPAGE_737=y
CONFIG_NLS_CODEPAGE_775=y
CONFIG_NLS_CODEPAGE_850=y
CONFIG_NLS_CODEPAGE_852=y
CONFIG_NLS_CODEPAGE_855=y
CONFIG_NLS_CODEPAGE_857=y
CONFIG_NLS_CODEPAGE_860=y
CONFIG_NLS_CODEPAGE_861=y
CONFIG_NLS_CODEPAGE_862=y
CONFIG_NLS_CODEPAGE_863=y
CONFIG_NLS_CODEPAGE_864=y
CONFIG_NLS_CODEPAGE_865=y
CONFIG_NLS_CODEPAGE_866=y
CONFIG_NLS_CODEPAGE_869=y
CONFIG_NLS_CODEPAGE_936=y
CONFIG_NLS_CODEPAGE_950=y
CONFIG_NLS_CODEPAGE_932=y
CONFIG_NLS_CODEPAGE_949=y
CONFIG_NLS_CODEPAGE_874=y
CONFIG_NLS_ISO8859_8=y
CONFIG_NLS_CODEPAGE_1250=y
CONFIG_NLS_CODEPAGE_1251=y
CONFIG_NLS_ASCII=y
CONFIG_NLS_ISO8859_1=y
CONFIG_NLS_ISO8859_2=y
CONFIG_NLS_ISO8859_3=y
CONFIG_NLS_ISO8859_4=y
CONFIG_NLS_ISO8859_5=y
CONFIG_NLS_ISO8859_6=y
CONFIG_NLS_ISO8859_7=y
CONFIG_NLS_ISO8859_9=y
CONFIG_NLS_ISO8859_13=y
CONFIG_NLS_ISO8859_14=y
CONFIG_NLS_ISO8859_15=y
CONFIG_NLS_KOI8_R=y
CONFIG_NLS_KOI8_U=y
# CONFIG_NLS_MAC_ROMAN is not set
# CONFIG_NLS_MAC_CELTIC is not set
# CONFIG_NLS_MAC_CENTEURO is not set
# CONFIG_NLS_MAC_CROATIAN is not set
# CONFIG_NLS_MAC_CYRILLIC is not set
# CONFIG_NLS_MAC_GAELIC is not set
# CONFIG_NLS_MAC_GREEK is not set
# CONFIG_NLS_MAC_ICELAND is not set
# CONFIG_NLS_MAC_INUIT is not set
# CONFIG_NLS_MAC_ROMANIAN is not set
# CONFIG_NLS_MAC_TURKISH is not set
CONFIG_NLS_UTF8=y
CONFIG_DLM=y
CONFIG_DLM_DEBUG=y

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_PRINTK_TIME=y
CONFIG_DEFAULT_MESSAGE_LOGLEVEL=4
CONFIG_ENABLE_WARN_DEPRECATED=y
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_FRAME_WARN=2048
CONFIG_MAGIC_SYSRQ=y
CONFIG_STRIP_ASM_SYMS=y
# CONFIG_READABLE_ASM is not set
CONFIG_UNUSED_SYMBOLS=y
CONFIG_DEBUG_FS=y
# CONFIG_HEADERS_CHECK is not set
CONFIG_DEBUG_SECTION_MISMATCH=y
CONFIG_DEBUG_KERNEL=y
CONFIG_DEBUG_SHIRQ=y
CONFIG_LOCKUP_DETECTOR=y
CONFIG_HARDLOCKUP_DETECTOR=y
# CONFIG_BOOTPARAM_HARDLOCKUP_PANIC is not set
CONFIG_BOOTPARAM_HARDLOCKUP_PANIC_VALUE=0
# CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC is not set
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE=0
CONFIG_DETECT_HUNG_TASK=y
CONFIG_DEFAULT_HUNG_TASK_TIMEOUT=300
CONFIG_BOOTPARAM_HUNG_TASK_PANIC=y
CONFIG_BOOTPARAM_HUNG_TASK_PANIC_VALUE=1
CONFIG_SCHED_DEBUG=y
CONFIG_SCHEDSTATS=y
CONFIG_TIMER_STATS=y
CONFIG_DEBUG_OBJECTS=y
# CONFIG_DEBUG_OBJECTS_SELFTEST is not set
# CONFIG_DEBUG_OBJECTS_FREE is not set
# CONFIG_DEBUG_OBJECTS_TIMERS is not set
# CONFIG_DEBUG_OBJECTS_WORK is not set
# CONFIG_DEBUG_OBJECTS_RCU_HEAD is not set
# CONFIG_DEBUG_OBJECTS_PERCPU_COUNTER is not set
CONFIG_DEBUG_OBJECTS_ENABLE_DEFAULT=1
CONFIG_DEBUG_SLAB=y
# CONFIG_DEBUG_SLAB_LEAK is not set
# CONFIG_DEBUG_KMEMLEAK is not set
CONFIG_DEBUG_RT_MUTEXES=y
CONFIG_DEBUG_PI_LIST=y
CONFIG_RT_MUTEX_TESTER=y
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
CONFIG_DEBUG_LOCK_ALLOC=y
CONFIG_PROVE_LOCKING=y
# CONFIG_PROVE_RCU is not set
CONFIG_SPARSE_RCU_POINTER=y
CONFIG_LOCKDEP=y
CONFIG_LOCK_STAT=y
# CONFIG_DEBUG_LOCKDEP is not set
CONFIG_TRACE_IRQFLAGS=y
CONFIG_DEBUG_ATOMIC_SLEEP=y
CONFIG_DEBUG_LOCKING_API_SELFTESTS=y
CONFIG_STACKTRACE=y
CONFIG_DEBUG_STACK_USAGE=y
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_BUGVERBOSE=y
# CONFIG_DEBUG_INFO is not set
CONFIG_DEBUG_VM=y
CONFIG_DEBUG_VIRTUAL=y
CONFIG_DEBUG_WRITECOUNT=y
CONFIG_DEBUG_MEMORY_INIT=y
CONFIG_DEBUG_LIST=y
CONFIG_TEST_LIST_SORT=y
CONFIG_DEBUG_SG=y
CONFIG_DEBUG_NOTIFIERS=y
CONFIG_DEBUG_CREDENTIALS=y
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
CONFIG_BOOT_PRINTK_DELAY=y
# CONFIG_RCU_TORTURE_TEST is not set
CONFIG_RCU_CPU_STALL_TIMEOUT=60
# CONFIG_RCU_CPU_STALL_INFO is not set
CONFIG_RCU_TRACE=y
CONFIG_KPROBES_SANITY_TEST=y
# CONFIG_BACKTRACE_SELF_TEST is not set
CONFIG_DEBUG_BLOCK_EXT_DEVT=y
CONFIG_DEBUG_FORCE_WEAK_PER_CPU=y
CONFIG_DEBUG_PER_CPU_MAPS=y
CONFIG_LKDTM=y
CONFIG_CPU_NOTIFIER_ERROR_INJECT=y
CONFIG_FAULT_INJECTION=y
# CONFIG_FAILSLAB is not set
# CONFIG_FAIL_PAGE_ALLOC is not set
# CONFIG_FAIL_MAKE_REQUEST is not set
# CONFIG_FAIL_IO_TIMEOUT is not set
# CONFIG_FAIL_MMC_REQUEST is not set
# CONFIG_FAULT_INJECTION_DEBUG_FS is not set
CONFIG_LATENCYTOP=y
CONFIG_DEBUG_PAGEALLOC=y
CONFIG_WANT_PAGE_DEBUG_FLAGS=y
CONFIG_PAGE_GUARD=y
CONFIG_USER_STACKTRACE_SUPPORT=y
CONFIG_NOP_TRACER=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_FP_TEST=y
CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_HAVE_SYSCALL_TRACEPOINTS=y
CONFIG_HAVE_C_RECORDMCOUNT=y
CONFIG_TRACER_MAX_TRACE=y
CONFIG_RING_BUFFER=y
CONFIG_EVENT_TRACING=y
CONFIG_EVENT_POWER_TRACING_DEPRECATED=y
CONFIG_CONTEXT_SWITCH_TRACER=y
CONFIG_RING_BUFFER_ALLOW_SWAP=y
CONFIG_TRACING=y
CONFIG_GENERIC_TRACER=y
CONFIG_TRACING_SUPPORT=y
CONFIG_FTRACE=y
CONFIG_FUNCTION_TRACER=y
CONFIG_FUNCTION_GRAPH_TRACER=y
CONFIG_IRQSOFF_TRACER=y
CONFIG_SCHED_TRACER=y
CONFIG_FTRACE_SYSCALLS=y
CONFIG_BRANCH_PROFILE_NONE=y
# CONFIG_PROFILE_ANNOTATED_BRANCHES is not set
# CONFIG_PROFILE_ALL_BRANCHES is not set
# CONFIG_STACK_TRACER is not set
CONFIG_BLK_DEV_IO_TRACE=y
CONFIG_KPROBE_EVENT=y
# CONFIG_UPROBE_EVENT is not set
CONFIG_PROBE_EVENTS=y
CONFIG_DYNAMIC_FTRACE=y
# CONFIG_FUNCTION_PROFILER is not set
CONFIG_FTRACE_MCOUNT_RECORD=y
CONFIG_FTRACE_SELFTEST=y
CONFIG_FTRACE_STARTUP_TEST=y
# CONFIG_EVENT_TRACE_TEST_SYSCALLS is not set
CONFIG_MMIOTRACE=y
# CONFIG_MMIOTRACE_TEST is not set
# CONFIG_RING_BUFFER_BENCHMARK is not set
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
# CONFIG_FIREWIRE_OHCI_REMOTE_DMA is not set
# CONFIG_DYNAMIC_DEBUG is not set
CONFIG_DMA_API_DEBUG=y
CONFIG_ATOMIC64_SELFTEST=y
# CONFIG_ASYNC_RAID6_TEST is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
CONFIG_HAVE_ARCH_KMEMCHECK=y
# CONFIG_TEST_KSTRTOX is not set
CONFIG_STRICT_DEVMEM=y
CONFIG_X86_VERBOSE_BOOTUP=y
CONFIG_EARLY_PRINTK=y
# CONFIG_EARLY_PRINTK_DBGP is not set
CONFIG_DEBUG_STACKOVERFLOW=y
CONFIG_X86_PTDUMP=y
CONFIG_DEBUG_RODATA=y
CONFIG_DEBUG_RODATA_TEST=y
CONFIG_DEBUG_SET_MODULE_RONX=y
CONFIG_DEBUG_NX_TEST=m
# CONFIG_IOMMU_DEBUG is not set
# CONFIG_IOMMU_STRESS is not set
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
# CONFIG_X86_DECODER_SELFTEST is not set
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
CONFIG_IO_DELAY_0X80=y
# CONFIG_IO_DELAY_0XED is not set
# CONFIG_IO_DELAY_UDELAY is not set
# CONFIG_IO_DELAY_NONE is not set
CONFIG_DEFAULT_IO_DELAY_TYPE=0
# CONFIG_DEBUG_BOOT_PARAMS is not set
# CONFIG_CPA_DEBUG is not set
CONFIG_OPTIMIZE_INLINING=y
# CONFIG_DEBUG_STRICT_USER_COPY_CHECKS is not set
# CONFIG_DEBUG_NMI_SELFTEST is not set

#
# Security options
#
CONFIG_KEYS=y
# CONFIG_TRUSTED_KEYS is not set
# CONFIG_ENCRYPTED_KEYS is not set
CONFIG_KEYS_DEBUG_PROC_KEYS=y
# CONFIG_SECURITY_DMESG_RESTRICT is not set
CONFIG_SECURITY=y
CONFIG_SECURITYFS=y
CONFIG_SECURITY_NETWORK=y
CONFIG_SECURITY_NETWORK_XFRM=y
CONFIG_SECURITY_PATH=y
# CONFIG_INTEL_TXT is not set
CONFIG_LSM_MMAP_MIN_ADDR=65536
CONFIG_SECURITY_SELINUX=y
# CONFIG_SECURITY_SELINUX_BOOTPARAM is not set
# CONFIG_SECURITY_SELINUX_DISABLE is not set
CONFIG_SECURITY_SELINUX_DEVELOP=y
CONFIG_SECURITY_SELINUX_AVC_STATS=y
CONFIG_SECURITY_SELINUX_CHECKREQPROT_VALUE=1
# CONFIG_SECURITY_SELINUX_POLICYDB_VERSION_MAX is not set
CONFIG_SECURITY_TOMOYO=y
CONFIG_SECURITY_TOMOYO_MAX_ACCEPT_ENTRY=2048
CONFIG_SECURITY_TOMOYO_MAX_AUDIT_LOG=1024
# CONFIG_SECURITY_TOMOYO_OMIT_USERSPACE_LOADER is not set
CONFIG_SECURITY_TOMOYO_POLICY_LOADER="/sbin/tomoyo-init"
CONFIG_SECURITY_TOMOYO_ACTIVATION_TRIGGER="/sbin/init"
CONFIG_SECURITY_APPARMOR=y
CONFIG_SECURITY_APPARMOR_BOOTPARAM_VALUE=1
# CONFIG_SECURITY_YAMA is not set
# CONFIG_IMA is not set
# CONFIG_EVM is not set
# CONFIG_DEFAULT_SECURITY_SELINUX is not set
# CONFIG_DEFAULT_SECURITY_TOMOYO is not set
# CONFIG_DEFAULT_SECURITY_APPARMOR is not set
CONFIG_DEFAULT_SECURITY_DAC=y
CONFIG_DEFAULT_SECURITY=""
CONFIG_XOR_BLOCKS=y
CONFIG_ASYNC_CORE=y
CONFIG_ASYNC_MEMCPY=y
CONFIG_ASYNC_XOR=y
CONFIG_ASYNC_PQ=y
CONFIG_ASYNC_RAID6_RECOV=y
CONFIG_ASYNC_TX_DISABLE_PQ_VAL_DMA=y
CONFIG_ASYNC_TX_DISABLE_XOR_VAL_DMA=y
CONFIG_CRYPTO=y

#
# Crypto core or helper
#
CONFIG_CRYPTO_FIPS=y
CONFIG_CRYPTO_ALGAPI=y
CONFIG_CRYPTO_ALGAPI2=y
CONFIG_CRYPTO_AEAD=y
CONFIG_CRYPTO_AEAD2=y
CONFIG_CRYPTO_BLKCIPHER=y
CONFIG_CRYPTO_BLKCIPHER2=y
CONFIG_CRYPTO_HASH=y
CONFIG_CRYPTO_HASH2=y
CONFIG_CRYPTO_RNG=y
CONFIG_CRYPTO_RNG2=y
CONFIG_CRYPTO_PCOMP=y
CONFIG_CRYPTO_PCOMP2=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
# CONFIG_CRYPTO_USER is not set
# CONFIG_CRYPTO_MANAGER_DISABLE_TESTS is not set
CONFIG_CRYPTO_GF128MUL=y
CONFIG_CRYPTO_NULL=y
CONFIG_CRYPTO_PCRYPT=y
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CRYPTD=y
CONFIG_CRYPTO_AUTHENC=y
CONFIG_CRYPTO_TEST=m

#
# Authenticated Encryption with Associated Data
#
CONFIG_CRYPTO_CCM=y
CONFIG_CRYPTO_GCM=y
CONFIG_CRYPTO_SEQIV=y

#
# Block modes
#
CONFIG_CRYPTO_CBC=y
CONFIG_CRYPTO_CTR=y
CONFIG_CRYPTO_CTS=y
CONFIG_CRYPTO_ECB=y
CONFIG_CRYPTO_LRW=y
CONFIG_CRYPTO_PCBC=y
CONFIG_CRYPTO_XTS=y

#
# Hash modes
#
CONFIG_CRYPTO_HMAC=y
CONFIG_CRYPTO_XCBC=y
CONFIG_CRYPTO_VMAC=y

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
CONFIG_CRYPTO_CRC32C_INTEL=y
CONFIG_CRYPTO_GHASH=y
CONFIG_CRYPTO_MD4=y
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_MICHAEL_MIC=y
CONFIG_CRYPTO_RMD128=y
CONFIG_CRYPTO_RMD160=y
CONFIG_CRYPTO_RMD256=y
CONFIG_CRYPTO_RMD320=y
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA1_SSSE3=y
CONFIG_CRYPTO_SHA256=y
CONFIG_CRYPTO_SHA512=y
CONFIG_CRYPTO_TGR192=y
CONFIG_CRYPTO_WP512=y
CONFIG_CRYPTO_GHASH_CLMUL_NI_INTEL=y

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
CONFIG_CRYPTO_AES_X86_64=y
CONFIG_CRYPTO_AES_NI_INTEL=y
CONFIG_CRYPTO_ANUBIS=y
CONFIG_CRYPTO_ARC4=y
CONFIG_CRYPTO_BLOWFISH=y
CONFIG_CRYPTO_BLOWFISH_COMMON=y
CONFIG_CRYPTO_BLOWFISH_X86_64=y
CONFIG_CRYPTO_CAMELLIA=y
# CONFIG_CRYPTO_CAMELLIA_X86_64 is not set
CONFIG_CRYPTO_CAST5=y
CONFIG_CRYPTO_CAST6=y
CONFIG_CRYPTO_DES=y
CONFIG_CRYPTO_FCRYPT=y
CONFIG_CRYPTO_KHAZAD=y
CONFIG_CRYPTO_SALSA20=y
CONFIG_CRYPTO_SALSA20_X86_64=y
CONFIG_CRYPTO_SEED=y
CONFIG_CRYPTO_SERPENT=y
# CONFIG_CRYPTO_SERPENT_SSE2_X86_64 is not set
CONFIG_CRYPTO_TEA=y
CONFIG_CRYPTO_TWOFISH=y
CONFIG_CRYPTO_TWOFISH_COMMON=y
CONFIG_CRYPTO_TWOFISH_X86_64=y
CONFIG_CRYPTO_TWOFISH_X86_64_3WAY=y

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=y
CONFIG_CRYPTO_ZLIB=y
CONFIG_CRYPTO_LZO=y

#
# Random Number Generation
#
CONFIG_CRYPTO_ANSI_CPRNG=y
CONFIG_CRYPTO_USER_API=y
CONFIG_CRYPTO_USER_API_HASH=y
CONFIG_CRYPTO_USER_API_SKCIPHER=y
CONFIG_CRYPTO_HW=y
CONFIG_CRYPTO_DEV_PADLOCK=y
CONFIG_CRYPTO_DEV_PADLOCK_AES=y
CONFIG_CRYPTO_DEV_PADLOCK_SHA=y
CONFIG_HAVE_KVM=y
CONFIG_HAVE_KVM_IRQCHIP=y
CONFIG_HAVE_KVM_EVENTFD=y
CONFIG_KVM_APIC_ARCHITECTURE=y
CONFIG_KVM_MMIO=y
CONFIG_KVM_ASYNC_PF=y
CONFIG_HAVE_KVM_MSI=y
CONFIG_VIRTUALIZATION=y
CONFIG_KVM=y
CONFIG_KVM_INTEL=y
CONFIG_KVM_AMD=y
# CONFIG_KVM_MMU_AUDIT is not set
CONFIG_VHOST_NET=y
CONFIG_BINARY_PRINTF=y

#
# Library routines
#
CONFIG_RAID6_PQ=y
CONFIG_BITREVERSE=y
CONFIG_GENERIC_STRNCPY_FROM_USER=y
CONFIG_GENERIC_STRNLEN_USER=y
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_GENERIC_PCI_IOMAP=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_IO=y
CONFIG_CRC_CCITT=y
CONFIG_CRC16=y
CONFIG_CRC_T10DIF=y
CONFIG_CRC_ITU_T=y
CONFIG_CRC32=y
# CONFIG_CRC32_SELFTEST is not set
CONFIG_CRC32_SLICEBY8=y
# CONFIG_CRC32_SLICEBY4 is not set
# CONFIG_CRC32_SARWATE is not set
# CONFIG_CRC32_BIT is not set
CONFIG_CRC7=y
CONFIG_LIBCRC32C=y
CONFIG_CRC8=y
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_XZ_DEC=y
CONFIG_XZ_DEC_X86=y
CONFIG_XZ_DEC_POWERPC=y
CONFIG_XZ_DEC_IA64=y
CONFIG_XZ_DEC_ARM=y
CONFIG_XZ_DEC_ARMTHUMB=y
CONFIG_XZ_DEC_SPARC=y
CONFIG_XZ_DEC_BCJ=y
# CONFIG_XZ_DEC_TEST is not set
CONFIG_DECOMPRESS_GZIP=y
CONFIG_DECOMPRESS_BZIP2=y
CONFIG_DECOMPRESS_LZMA=y
CONFIG_DECOMPRESS_XZ=y
CONFIG_DECOMPRESS_LZO=y
CONFIG_GENERIC_ALLOCATOR=y
CONFIG_REED_SOLOMON=y
CONFIG_REED_SOLOMON_DEC16=y
CONFIG_TEXTSEARCH=y
CONFIG_TEXTSEARCH_KMP=y
CONFIG_TEXTSEARCH_BM=y
CONFIG_TEXTSEARCH_FSM=y
CONFIG_BTREE=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_CHECK_SIGNATURE=y
# CONFIG_CPUMASK_OFFSTACK is not set
CONFIG_CPU_RMAP=y
CONFIG_DQL=y
CONFIG_NLATTR=y
CONFIG_LRU_CACHE=y
CONFIG_AVERAGE=y
CONFIG_CORDIC=y
# CONFIG_DDR is not set

--5vNYLRcllDrimb99--
