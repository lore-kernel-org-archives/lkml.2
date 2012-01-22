Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751605Ab2AVK2r (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jan 2012 05:28:47 -0500
Received: from gerard.telenet-ops.be ([195.130.132.48]:34119 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751165Ab2AVK2m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jan 2012 05:28:42 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-kernel@vger.kernel.org
Subject: Build regressions/improvements in v3.3-rc1
Date: Sun, 22 Jan 2012 11:28:38 +0100
Message-Id: <1327228118-17136-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Below is the list of build error/warning regressions/improvements in
v3.3-rc1[1] compared to v3.2[2].
Note that I deleted 1249 lines about "__mcount_loc already exists", to avoid
my email being rejected.

Summarized:
  - build errors: +80/-21
  - build warnings: +1216/-545

Note that there may be false regressions, as some logs are incomplete.
Still, they're build errors/warnings.

As master.kernel.org is down, there's no verbose summary yet at
http://www.kernel.org/pub/linux/kernel/people/geert/linux-log/v3.3-rc1.summary.gz

Happy fixing! ;-)

Thanks to the linux-next team for providing the build service.

[1] http://kisskb.ellerman.id.au/kisskb/head/4626/ (106 out of 107 configs)
[2] http://kisskb.ellerman.id.au/kisskb/head/4572/ (107 out of 107 configs)


*** ERRORS ***

80 regressions:
  + build/linus_sparc-allmodconfig_sparc64/usr/include/linux/types.h: error: unknown type name '__u64': 32:1 => 32:1, 31:1
  + error: "st_register" [drivers/media/radio/wl128x/fm_drv.ko] undefined!:  => N/A
  + error: "st_unregister" [drivers/media/radio/wl128x/fm_drv.ko] undefined!:  => N/A
  + error: "usb_add_hcd" [drivers/usb/otg/mv_otg.ko] undefined!:  => N/A
  + error: "usb_remove_hcd" [drivers/usb/otg/mv_otg.ko] undefined!:  => N/A
  + src/arch/mips/include/asm/io.h: error: previous definition of 'readsb' was here:  => 527
  + src/arch/mips/include/asm/io.h: error: previous definition of 'readsl' was here:  => 529
  + src/arch/mips/include/asm/io.h: error: previous definition of 'readsw' was here:  => 528
  + src/arch/mips/include/asm/io.h: error: previous definition of 'writesb' was here:  => 527
  + src/arch/mips/include/asm/io.h: error: previous definition of 'writesl' was here:  => 529
  + src/arch/mips/include/asm/io.h: error: previous definition of 'writesw' was here:  => 528
  + src/arch/mips/include/asm/page.h: error: this is the location of the previous definition:  => 43:1
  + src/arch/powerpc/platforms/512x/mpc512x_shared.c: error: 'FSL_DIU_PORT_DVI' undeclared (first use in this function):  => 189:9
  + src/arch/powerpc/platforms/512x/mpc512x_shared.c: error: 'enum fsl_diu_monitor_port' declared inside parameter list:  => 70:9, 84:9, 88:36
  + src/arch/powerpc/platforms/512x/mpc512x_shared.c: error: 'return' with a value, in function returning void:  => 189:2
  + src/arch/powerpc/platforms/512x/mpc512x_shared.c: error: function declaration isn't a prototype:  => 69:5, 88:6, 83:6, 187:1
  + src/arch/powerpc/platforms/512x/mpc512x_shared.c: error: its scope is only this definition or declaration, which is probably not what you want:  => 70:9
  + src/arch/powerpc/platforms/512x/mpc512x_shared.c: error: parameter 1 ('port') has incomplete type:  => 187:54, 83:56, 88:57, 69:56
  + src/arch/powerpc/platforms/512x/mpc512x_shared.c: error: return type is an incomplete type:  => 187:1
  + src/arch/powerpc/platforms/85xx/p1022_ds.c: error: 'udbg_progress' undeclared here (not in a function):  => 341:14
  + src/arch/powerpc/platforms/pseries/processor_idle.c: error: redefinition of 'pseries_notify_cpuidle_add_cpu':  => 175:5
  + src/arch/powerpc/platforms/pseries/processor_idle.c: error: redefinition of 'update_smt_snooze_delay':  => 35:6
  + src/drivers/media/video/uvc/uvc_queue.c: error: 'buf' undeclared (first use in this function):  => 263
  + src/drivers/media/video/uvc/uvc_queue.c: error: 'struct uvc_video_queue' has no member named 'buffer':  => 255
  + src/drivers/media/video/uvc/uvc_queue.c: error: 'struct uvc_video_queue' has no member named 'count':  => 254, 259
  + src/drivers/media/video/uvc/uvc_queue.c: error: 'struct vb2_buffer' has no member named 'm':  => 256
  + src/drivers/media/video/uvc/uvc_queue.c: error: (Each undeclared identifier is reported only once:  => 263
  + src/drivers/media/video/uvc/uvc_queue.c: error: for each function it appears in.):  => 263
  + src/drivers/net/can/cc770/cc770_isa.c: error: implicit declaration of function 'inb':  => 128
  + src/drivers/net/can/cc770/cc770_isa.c: error: implicit declaration of function 'outb':  => 134
  + src/drivers/net/can/cc770/cc770_platform.c: error: implicit declaration of function 'ioread8':  => 68
  + src/drivers/net/can/cc770/cc770_platform.c: error: implicit declaration of function 'iowrite8':  => 74
  + src/drivers/net/can/sja1000/sja1000_isa.c: error: implicit declaration of function 'inb':  => 93
  + src/drivers/net/can/sja1000/sja1000_isa.c: error: implicit declaration of function 'outb':  => 99
  + src/drivers/usb/musb/musb_io.h: error: conflicting types for 'readsb':  => 48
  + src/drivers/usb/musb/musb_io.h: error: conflicting types for 'readsl':  => 44
  + src/drivers/usb/musb/musb_io.h: error: conflicting types for 'readsw':  => 46
  + src/drivers/usb/musb/musb_io.h: error: conflicting types for 'writesb':  => 55
  + src/drivers/usb/musb/musb_io.h: error: conflicting types for 'writesl':  => 51
  + src/drivers/usb/musb/musb_io.h: error: conflicting types for 'writesw':  => 53
  + src/drivers/video/console/fonts.c: error: #error No fonts configured.:  => 71:2
  + src/drivers/video/fsl-diu-fb.c: error: incompatible type for argument 1 of 'disable_lcdc':  => 1435:2
  + src/drivers/video/fsl-diu-fb.c: error: incompatible type for argument 1 of 'enable_lcdc':  => 1445:2
  + src/fs/btrfs/volumes.c: error: insn does not satisfy its constraints::  => 2754
  + src/include/linux/kernel.h: error: "BUILD_BUG" redefined:  => 717:1
  + src/include/net/netfilter/nf_conntrack_acct.h: error: expected specifier-qualifier-list before 'atomic64_t':  => 18
  + src/lib/mpi/generic_mpih-mul1.c: error: 'asm' operand has impossible constraints:  => 50
  + src/lib/mpi/generic_mpih-mul1.c: error: can't find a register in class 'FP_REGS' while reloading 'asm':  => 50
  + src/lib/mpi/generic_mpih-mul2.c: error: 'asm' operand has impossible constraints:  => 49
  + src/lib/mpi/generic_mpih-mul2.c: error: can't find a register in class 'FP_REGS' while reloading 'asm':  => 49
  + src/lib/mpi/generic_mpih-mul3.c: error: 'asm' operand has impossible constraints:  => 49
  + src/lib/mpi/generic_mpih-mul3.c: error: can't find a register in class 'FP_REGS' while reloading 'asm':  => 49
  + src/lib/mpi/mpih-div.c: error: 'asm' operand has impossible constraints:  => 448, 457, 485
  + src/lib/mpi/mpih-div.c: error: can't find a register in class 'FP_REGS' while reloading 'asm':  => 448, 457, 485
  + src/net/netfilter/nf_conntrack_acct.c: error: 'struct nf_conn_counter' has no member named 'bytes':  => 50
  + src/net/netfilter/nf_conntrack_acct.c: error: 'struct nf_conn_counter' has no member named 'packets':  => 49
  + src/net/netfilter/nf_conntrack_acct.c: error: implicit declaration of function 'atomic64_read':  => 49
  + src/net/netfilter/nf_conntrack_core.c: error: 'struct nf_conn_counter' has no member named 'bytes':  => 1049, 1067
  + src/net/netfilter/nf_conntrack_core.c: error: 'struct nf_conn_counter' has no member named 'packets':  => 1048, 1065
  + src/net/netfilter/nf_conntrack_core.c: error: implicit declaration of function 'atomic64_add':  => 1049
  + src/net/netfilter/nf_conntrack_core.c: error: implicit declaration of function 'atomic64_inc':  => 1048
  + src/net/netfilter/nf_conntrack_netlink.c: error: 'struct nf_conn_counter' has no member named 'bytes':  => 243, 240
  + src/net/netfilter/nf_conntrack_netlink.c: error: 'struct nf_conn_counter' has no member named 'packets':  => 239, 242
  + src/net/netfilter/nf_conntrack_netlink.c: error: implicit declaration of function 'atomic64_read':  => 242
  + src/net/netfilter/nf_conntrack_netlink.c: error: implicit declaration of function 'atomic64_xchg':  => 239
  + src/net/netfilter/nfnetlink_acct.c: error: 'struct nf_acct' has no member named 'bytes':  => 119, 81, 116, 326, 68
  + src/net/netfilter/nfnetlink_acct.c: error: 'struct nf_acct' has no member named 'head':  => 240, 147, 221, 182, 53, 295, 353, 352, 89, 247
  + src/net/netfilter/nfnetlink_acct.c: error: 'struct nf_acct' has no member named 'name':  => 112, 296, 185, 248, 78, 54
  + src/net/netfilter/nfnetlink_acct.c: error: 'struct nf_acct' has no member named 'pkts':  => 67, 85, 118, 325, 115
  + src/net/netfilter/nfnetlink_acct.c: error: 'struct nf_acct' has no member named 'rcu_head':  => 356, 222
  + src/net/netfilter/nfnetlink_acct.c: error: 'struct nf_acct' has no member named 'refcnt':  => 123, 302, 225, 88, 219, 318
  + src/net/netfilter/nfnetlink_acct.c: error: expected specifier-qualifier-list before 'atomic64_t':  => 33
  + src/net/netfilter/nfnetlink_acct.c: error: implicit declaration of function 'atomic64_add':  => 326
  + src/net/netfilter/nfnetlink_acct.c: error: implicit declaration of function 'atomic64_inc':  => 325
  + src/net/netfilter/nfnetlink_acct.c: error: implicit declaration of function 'atomic64_read':  => 118
  + src/net/netfilter/nfnetlink_acct.c: error: implicit declaration of function 'atomic64_set':  => 67
  + src/net/netfilter/nfnetlink_acct.c: error: implicit declaration of function 'atomic64_xchg':  => 115
  + src/net/netfilter/xt_connbytes.c: error: 'const struct nf_conn_counter' has no member named 'bytes':  => 60, 63, 75, 71, 64, 57, 80, 79
  + src/net/netfilter/xt_connbytes.c: error: 'const struct nf_conn_counter' has no member named 'packets':  => 81, 50, 72, 49, 46, 76, 43, 82
  + src/net/netfilter/xt_connbytes.c: error: implicit declaration of function 'atomic64_read':  => 43

21 improvements:
  - build/linus_sparc-allmodconfig_sparc64/usr/include/linux/types.h: error: unknown type name '__u64'  CC [M]  samples/kprobes/jprobe_example.o: 31:1 => 
  - error: ".register_early_udbg_console" [drivers/tty/ehv_bytechan.ko] undefined!: N/A => 
  - error: ".udbg_printf" [drivers/tty/ehv_bytechan.ko] undefined!: N/A => 
  - error: "udbg_putc" [drivers/tty/ehv_bytechan.ko] undefined!: N/A => 
  - src/arch/parisc/lib/iomap.c: error: redefinition of 'pci_iomap': 441 => 
  - src/arch/powerpc/sysdev/mv64x60_dev.c: error: assignment makes pointer from integer without a cast: 253:11 => 
  - src/arch/powerpc/sysdev/mv64x60_dev.c: error: implicit declaration of function 'of_get_mac_address': 253:2 => 
  - src/arch/powerpc/sysdev/tsi108_dev.c: error: assignment makes pointer from integer without a cast: 108:12 => 
  - src/arch/powerpc/sysdev/tsi108_dev.c: error: implicit declaration of function 'of_get_mac_address': 108:3 => 
  - src/arch/sh/boards/board-magicpanelr2.c: error: implicit declaration of function 'parse_mtd_partitions': 354 => 
  - src/arch/sh/boards/mach-rsk/setup.c: error: implicit declaration of function 'parse_mtd_partitions': 82 => 
  - src/arch/xtensa/include/asm/irqflags.h: Error: invalid symbolic operand: 26 => 
  - src/drivers/target/target_core_rd.c: error: this is the insn:: 543 => 
  - src/drivers/target/target_core_rd.c: error: unable to find a register to spill in class 'R0_REGS': 543 => 
  - src/drivers/virt/fsl_hypervisor.c: error: 'MSR_GS' undeclared (first use in this function): 799:80 => 
  - src/fs/nilfs2/bmap.c: error: this is the insn:: 466 => 
  - src/fs/nilfs2/bmap.c: error: unable to find a register to spill in class 'R0_REGS': 466 => 
  - src/include/asm-generic/iomap.h: error: previous definition of 'pci_iomap' was here: 77 => 
  - src/include/linux/prefetch.h: Error: couldn't find a valid instruction format: 62 => 
  - src/include/linux/prefetch.h: Error: unknown opcode or format name 'static': 53 => 
  - src/lib/radix-tree.c: error: insn does not satisfy its constraints:: 741 => 


*** WARNINGS ***

1216 regressions:
  + /tmp/cctzaVmy.s: Warning: source register same as write-back base:  => 104
  + modpost: WARNING: modpost: Found 13 section mismatch(es).:  => N/A
  + modpost: WARNING: modpost: Found 14 section mismatch(es).:  => N/A
  + modpost: WARNING: modpost: missing MODULE_LICENSE() in drivers/staging/media/go7007/go7007-usb.o:  => N/A
  + src/arch/mips/include/asm/page.h: warning: this is the location of the previous definition:  => 43:1
  + src/arch/mips/lib/iomap-pci.c: warning: 'ioport_map_pci' defined but not used:  => 15
  + src/arch/sh/drivers/dma/dma-sysfs.c: warning: passing argument 2 of 'device_create_file' from incompatible pointer type:  => 57
  + src/arch/sh/drivers/pci/pci.c: warning: 'ioport_map_pci' defined but not used:  => 361
  + src/arch/sh/math-emu/math.c: warning: statement with no effect:  => 123, 130, 295, 336, 109, 116, 148, 325, 297
  + src/arch/x86/kernel/cpu/mcheck/mce-inject.c: warning: 'mce_irq_ipi' defined but not used:  => 96
  + src/arch/x86/platform/scx200/scx200_32.c: warning: 'base' may be used uninitialized in this function:  => 82
  + src/drivers/block/nvme.c: warning: 'iod' may be used uninitialized in this function:  => 1155:19, 1155
  + src/drivers/block/nvme.c: warning: passing argument 3 of 'dma_free_coherent' discards qualifiers from pointer target type:  => 878, 920, 967
  + src/drivers/crypto/caam/ctrl.c: warning: unused variable 'd':  => 49:6
  + src/drivers/gpio/gpio-bt8xx.c: warning: ignoring return value of 'gpiochip_remove', declared with attribute warn_unused_result:  => 244:17
  + src/drivers/gpu/drm/nouveau/nv50_pm.c: warning: 'id' may be used uninitialized in this function:  => 75
  + src/drivers/gpu/drm/sis/sis_drv.c: warning: 'ret' is used uninitialized in this function:  => 53
  + src/drivers/gpu/drm/sis/sis_drv.c: warning: 'ret' may be used uninitialized in this function:  => 53
  + src/drivers/hid/hid-wiimote-debug.c: warning: 'size' may be used uninitialized in this function:  => 40:8, 40
  + src/drivers/input/evdev.c: warning: 'retval' may be used uninitialized in this function:  => 389
  + src/drivers/isdn/hardware/mISDN/hfcsusb.c: warning: 'hfcsusb_rev' defined but not used:  => 39:20, 39
  + src/drivers/isdn/i4l/isdn_common.c: warning: unused variable 's': 1279 => 1279:8, 1279
  + src/drivers/isdn/sc/init.c: warning: return from incompatible pointer type:  => 36, 37
  + src/drivers/md/md.c: warning: large integer implicitly truncated to unsigned type:  => 1146:3, 1146, 1428, 1428:3
  + src/drivers/md/raid10.c: warning: 'rdev' may be used uninitialized in this function:  => 624:18, 624
  + src/drivers/media/video/cx18/cx18-driver.c: warning: initialization from incompatible pointer type:  => 113:1, 113
  + src/drivers/media/video/cx18/cx18-driver.c: warning: return from incompatible pointer type:  => 113:1, 113
  + src/drivers/media/video/ivtv/ivtv-driver.c: warning: initialization from incompatible pointer type:  => 142, 142:1
  + src/drivers/media/video/ivtv/ivtv-driver.c: warning: return from incompatible pointer type:  => 142, 142:1
  + src/drivers/media/video/uvc/uvc_video.c: warning: format '%06lu' expects type 'long unsigned int', but argument 9 has type '__kernel_suseconds_t':  => 666
  + src/drivers/media/video/w9966.c: warning: return from incompatible pointer type:  => 136, 136:1
  + src/drivers/message/fusion/mptbase.c: warning: 'seq_mpt_print_ioc_summary' defined but not used:  => 6883
  + src/drivers/mtd/chips/cfi_cmdset_0020.c: warning: the frame size of 1136 bytes is larger than 1024 bytes:  => 422
  + src/drivers/mtd/chips/cfi_cmdset_0020.c: warning: the frame size of 1380 bytes is larger than 1024 bytes:  => 987
  + src/drivers/mtd/chips/cfi_cmdset_0020.c: warning: the frame size of 1676 bytes is larger than 1024 bytes:  => 660
  + src/drivers/mtd/devices/docg3.c: warning: unused variable 'base':  => 2085
  + src/drivers/mtd/ftl.c: warning: passing argument 4 of 'mtd_read' from incompatible pointer type:  => 527, 294, 228, 490
  + src/drivers/mtd/ftl.c: warning: passing argument 4 of 'mtd_write' from incompatible pointer type:  => 535, 426, 566, 507, 442, 557
  + src/drivers/mtd/mtdcore.c: warning: unused variable 'mtd':  => 110
  + src/drivers/net/can/cc770/cc770_platform.c: warning: unused variable 'priv':  => 243
  + src/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c: warning: comparison of distinct pointer types lacks a cast:  => 1530:441, 1530
  + src/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c: warning: comparison of distinct pointer types lacks a cast:  => 2784, 2784:3
  + src/drivers/net/ethernet/dec/ewrk3.c: warning: return from incompatible pointer type:  => 1912, 1912:71
  + src/drivers/net/ethernet/intel/igb/igb_main.c: warning: 'igb_resume' defined but not used:  => 6733
  + src/drivers/net/ethernet/intel/igb/igb_main.c: warning: 'igb_suspend' defined but not used:  => 6713
  + src/drivers/net/ethernet/intel/igb/igb_main.c: warning: 'wake' may be used uninitialized in this function:  => 6831
  + src/drivers/net/hamradio/baycom_epp.c: warning: return from incompatible pointer type:  => 1168
  + src/drivers/net/hamradio/baycom_par.c: warning: return from incompatible pointer type:  => 483, 483:1
  + src/drivers/net/wireless/ath/ath5k/base.c: warning: return from incompatible pointer type:  => 84, 85:1
  + src/drivers/net/wireless/ath/ath6kl/init.c: warning: 'hw' may be used uninitialized in this function:  => 1377:26
  + src/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c: warning: 'in' is used uninitialized in this function:  => 915
  + src/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c: warning: 'in' may be used uninitialized in this function:  => 915
  + src/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c: warning: 'val' is used uninitialized in this function:  => 765, 1159
  + src/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c: warning: 'val' may be used uninitialized in this function:  => 765, 1159
  + src/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c: warning: 'w' is used uninitialized in this function:  => 1185
  + src/drivers/net/wireless/brcm80211/brcmsmac/main.c: warning: comparison is always false due to limited range of data type:  => 5682, 5582
  + src/drivers/net/wireless/brcm80211/brcmsmac/nicpci.c: warning: 'byte_val' is used uninitialized in this function:  => 280
  + src/drivers/net/wireless/brcm80211/brcmsmac/nicpci.c: warning: 'reg_val' is used uninitialized in this function:  => 487
  + src/drivers/net/wireless/ipw2x00/libipw_wx.c: warning: unused variable 'dev':  => 526
  + src/drivers/net/wireless/orinoco/orinoco_usb.c: warning: 'version' defined but not used:  => 1759, 1759:13
  + src/drivers/pci/hotplug/cpcihp_generic.c: warning: return from incompatible pointer type:  => 219
  + src/drivers/power/charger-manager.c: warning: 'i' may be used uninitialized in this function:  => 405, 405:6
  + src/drivers/power/sbs-battery.c: warning: 'gpio_flags' is used uninitialized in this function:  => 661
  + src/drivers/power/sbs-battery.c: warning: 'gpio_flags' may be used uninitialized in this function:  => 661
  + src/drivers/rapidio/devices/tsi721.c: warning: unused variable 'i':  => 2157:6
  + src/drivers/rtc/rtc-ds1374.c: warning: 'ds1374_resume' defined but not used: 423 => 423, 422
  + src/drivers/rtc/rtc-ds1374.c: warning: 'ds1374_suspend' defined but not used: 414 => 413, 414
  + src/drivers/scsi/advansys.c: warning: label 'err_unmap' defined but not used:  => 12379
  + src/drivers/staging/android/binder.c: warning: 'buffer' may be used uninitialized in this function:  => 713, 713:24
  + src/drivers/staging/android/binder.c: warning: 'buffer_size' may be used uninitialized in this function:  => 714:9, 714
  + src/drivers/staging/android/binder.c: warning: cast from pointer to integer of different size:  => 2379, 2339, 2336
  + src/drivers/staging/android/binder.c: warning: return from incompatible pointer type:  => 106:1, 106
  + src/drivers/staging/android/lowmemorykiller.c: warning: return from incompatible pointer type:  => 212:1, 211
  + src/drivers/staging/comedi/drivers/vmk80xx.c: warning: 'reg[0]' may be used uninitialized in this function:  => 588, 962
  + src/drivers/staging/media/lirc/lirc_imon.c: warning: 'imon_exit' declared 'static' but never defined:  => 75, 75:20
  + src/drivers/staging/media/lirc/lirc_imon.c: warning: 'imon_init' declared 'static' but never defined:  => 74:19, 74
  + src/drivers/staging/media/lirc/lirc_sasem.c: warning: 'sasem_exit' declared 'static' but never defined:  => 85:20, 85
  + src/drivers/staging/media/lirc/lirc_sasem.c: warning: 'sasem_init' declared 'static' but never defined:  => 84, 84:19
  + src/drivers/staging/media/lirc/lirc_serial.c: warning: return from incompatible pointer type:  => 1296, 1296:1
  + src/drivers/staging/vme/devices/vme_pio2_core.c: warning: return from incompatible pointer type:  => 516, 512, 512:1, 516:1
  + src/drivers/staging/wlan-ng/cfg80211.c: warning: ignoring return value of 'cfg80211_inform_bss', declared with attribute warn_unused_result:  => 404:22, 404
  + src/drivers/usb/gadget/acm_ms.c: warning: return from incompatible pointer type:  => 119, 119:1
  + src/drivers/usb/gadget/mass_storage.c: warning: return from incompatible pointer type:  => 94:1, 94
  + src/drivers/usb/gadget/multi.c: warning: return from incompatible pointer type:  => 147, 147:1
  + src/drivers/usb/host/ohci-hub.c: warning: 'ohci_finish_controller_resume' defined but not used:  => 320:13
  + src/drivers/usb/misc/emi26.c: warning: 'emi26_exit' declared 'static' but never defined:  => 41:123, 41:20, 41
  + src/drivers/usb/misc/emi26.c: warning: 'emi26_init' declared 'static' but never defined:  => 40, 40:122, 40:19
  + src/drivers/usb/misc/emi62.c: warning: 'emi62_exit' declared 'static' but never defined:  => 50, 50:20, 50:123
  + src/drivers/usb/misc/emi62.c: warning: 'emi62_init' declared 'static' but never defined:  => 49:19, 49, 49:122
  + src/drivers/usb/misc/sisusbvga/sisusb.c: warning: format '%zd' expects type 'signed size_t', but argument 3 has type 'ssize_t':  => 982
  + src/drivers/usb/misc/sisusbvga/sisusb.c: warning: passing argument 7 of 'sisusb_write_mem_bulk' from incompatible pointer type:  => 1336
  + src/drivers/usb/misc/sisusbvga/sisusb_con.c: warning: passing argument 5 of 'sisusb_copy_memory' from incompatible pointer type:  => 996, 554, 418, 991, 505, 472, 664, 985, 383, 880
  + src/drivers/usb/musb/musb_core.c: warning: unused variable 'ctrl_base':  => 2107
  + src/drivers/usb/musb/musb_gadget.c: warning: 'double_buffer_not_ok' is deprecated (declared at /scratch/kisskb/src/drivers/usb/musb/musb_core.h:452):  => 1125:3, 1085, 1085:3, 1125
  + src/drivers/usb/musb/musb_host.c: warning: 'double_buffer_not_ok' is deprecated (declared at /scratch/kisskb/src/drivers/usb/musb/musb_core.h:452):  => 599:2, 774, 774:4, 599
  + src/drivers/usb/musb/musb_io.h: warning: statement with no effect:  => 46, 44, 48
  + src/drivers/usb/serial/kobil_sct.c: warning: return from incompatible pointer type:  => 719:74, 719:1, 719
  + src/drivers/video/amifb.c: warning: 'amifb_setup' defined but not used:  => 2348
  + src/drivers/video/aty/atyfb_base.c: warning: 'ram_dram' defined but not used:  => 534
  + src/drivers/video/aty/atyfb_base.c: warning: 'ram_resv' defined but not used:  => 535
  + src/drivers/video/aty/atyfb_base.c: warning: overflow in implicit constant conversion:  => 437
  + src/drivers/virtio/virtio_balloon.c: warning: 'events[10]' is used uninitialized in this function:  => 167
  + src/drivers/virtio/virtio_balloon.c: warning: 'events[11]' is used uninitialized in this function:  => 167
  + src/drivers/virtio/virtio_balloon.c: warning: 'events[2]' is used uninitialized in this function:  => 181
  + src/drivers/virtio/virtio_balloon.c: warning: 'events[3]' is used uninitialized in this function:  => 183
  + src/drivers/xen/xenbus/xenbus_client.c: warning: 'addr' may be used uninitialized in this function:  => 655
  + src/fs/btrfs/backref.c: warning: 'ret' may be used uninitialized in this function: 419, 485 => 395:6, 300:6, 395, 300
  + src/fs/btrfs/backref.c: warning: 'sgn' may be used uninitialized in this function:  => 299
  + src/fs/btrfs/check-integrity.c: warning: 'bytenr' may be used uninitialized in this function:  => 1665:7, 1665
  + src/fs/btrfs/check-integrity.c: warning: 'next_bytenr' may be used uninitialized in this function:  => 864, 692, 2168
  + src/fs/btrfs/check-integrity.c: warning: 'ret' may be used uninitialized in this function:  => 647:6, 647
  + src/fs/btrfs/check-integrity.c: warning: 'tmp_disk_key.objectid' may be used uninitialized in this function:  => 2175, 868
  + src/fs/btrfs/check-integrity.c: warning: format '%lu' expects type 'long unsigned int', but argument 3 has type 'sector_t':  => 2782
  + src/fs/btrfs/check-integrity.c: warning: format '%lu' expects type 'long unsigned int', but argument 4 has type 'sector_t':  => 2849
  + src/fs/btrfs/check-integrity.c: warning: format '%lu' expects type 'long unsigned int', but argument 5 has type 'size_t':  => 2782
  + src/fs/btrfs/extent-tree.c: warning: cast from pointer to integer of different size:  => 3335, 3314, 3915, 4134, 3769, 4194, 3698, 4141, 4713
  + src/fs/btrfs/inode-map.c: warning: cast from pointer to integer of different size:  => 503, 441
  + src/fs/btrfs/transaction.c: warning: cast from pointer to integer of different size:  => 330
  + src/fs/ncpfs/dir.c: warning: unused variable 'sb':  => 128
  + src/include/linux/kernel.h: warning: "BUILD_BUG" redefined:  => 717:1
  + src/include/linux/netdevice.h: warning: "__enabled_CONFIG_FCOE" is not defined:  => 1289:1, 964:1
  + src/include/linux/netdevice.h: warning: "__enabled_CONFIG_FCOE_MODULE" is not defined:  => 1289:1, 964:1
  + src/include/linux/netdevice.h: warning: "__enabled_CONFIG_LIBFCOE" is not defined:  => 981:1
  + src/include/linux/netdevice.h: warning: "__enabled_CONFIG_LIBFCOE_MODULE" is not defined:  => 981:1
  + src/include/linux/netdevice.h: warning: ::  => 964:1
  + src/include/linux/netdevice.h: warning: In file included from /scratch/kisskb/src/include/net/sock.h:50,:  => 964:1
  + src/kernel/debug/kdb/kdb_support.c: warning: passing argument 1 of 'is_idle_task' discards qualifiers from pointer target type:  => 639, 639:2
  + src/kernel/profile.c: warning: 'profile_cpu_callback' defined but not used:  => 355
  + src/kernel/profile.c: warning: 'profile_discard_flip_buffers' defined but not used:  => 291
  + src/kernel/profile.c: warning: 'profile_flip_buffers' defined but not used:  => 268
  + src/kernel/rcutiny.c: warning: unused variable 'idle':  => 122, 68
  + src/kernel/rcutorture.c: warning: return from incompatible pointer type:  => 82:1, 80:1, 80, 82
  + src/kernel/sched/core.c: warning: control may reach end of non-void function 'pick_next_task' being inlined:  => 3206
  + src/kernel/sched/core.c: warning: control reaches end of non-void function:  => 3150
  + src/kernel/sched/core.c: warning: initialization from incompatible pointer type:  => 6268
  + src/kernel/sched/core.c: warning: unsupported argument to '__builtin_return_address':  => 3018, 3020
  + src/kernel/sched/fair.c: warning: 'account_cfs_rq_runtime' declared inline after being called:  => 419, 420
  + src/kernel/sched/fair.c: warning: 'return_cfs_rq_runtime' declared inline after being called:  => 1178
  + src/kernel/sched/fair.c: warning: previous declaration of 'account_cfs_rq_runtime' was here:  => 419, 420
  + src/kernel/sched/fair.c: warning: previous declaration of 'return_cfs_rq_runtime' was here:  => 1178
  + src/lib/mpi/longlong.h: warning: "COUNT_LEADING_ZEROS_0" redefined:  => 1461:1
  + src/lib/mpi/longlong.h: warning: function declaration isn't a prototype:  => 355
  + src/lib/mpi/longlong.h: warning: this is the location of the previous definition:  => 610:1
  + src/mm/memcontrol.c: warning: 'mem_cgroup_is_root' declared inline after being called:  => 379
  + src/mm/memcontrol.c: warning: previous declaration of 'mem_cgroup_is_root' was here:  => 379
  + src/mm/memcontrol.c: warning: unused variable 'do_numainfo':  => 779
  + src/net/bluetooth/hci_core.c: warning: return from incompatible pointer type:  => 2587:1, 2587, 2587:78
  + src/net/bluetooth/rfcomm/tty.c: warning: 'p' is used uninitialized in this function:  => 218
  + src/net/bluetooth/rfcomm/tty.c: warning: 'p' may be used uninitialized in this function:  => 218
  + src/net/core/dev.c: warning: unused variable 'null_features':  => 1892
  + src/net/ipv4/tcp_memcontrol.c: warning: 'val' may be used uninitialized in this function:  => 204
  + src/net/netfilter/nfnetlink_acct.c: warning: initialization from incompatible pointer type:  => 240, 147, 182, 53, 352, 295, 247
  + src/net/netfilter/nfnetlink_acct.c: warning: initialization makes pointer from integer without a cast:  => 147, 295
  + src/net/netfilter/nfnetlink_acct.c: warning: left-hand operand of comma expression has no effect:  => 352
  + src/net/netfilter/nfnetlink_acct.c: warning: type defaults to 'int' in declaration of '__mptr':  => 240, 147, 182, 53, 352, 295, 247
  + src/net/netfilter/nfnetlink_acct.c: warning: type defaults to 'int' in declaration of '__ptr':  => 147, 295
  + src/net/netfilter/nfnetlink_acct.c: warning: type defaults to 'int' in declaration of 'type name':  => 147, 295
  + src/sound/isa/opti9xx/opti92x-ad1848.c: warning: return from incompatible pointer type:  => 87
  + src/sound/oss/msnd_pinnacle.c: warning: return from incompatible pointer type:  => 1727
  + src/sound/soc/codecs/wm8958-dsp2.c: warning: format '%d' expects type 'int', but argument 4 has type 'size_t':  => 59:4
  + src/sound/soc/codecs/wm9090.c: warning: unused variable 'i':  => 496, 496:6
  + src/sound/soc/codecs/wm9090.c: warning: unused variable 'reg_cache':  => 495:7, 495
  + src/sound/soc/codecs/wm9090.c: warning: unused variable 'ret':  => 496:9, 496
  + src/sound/soc/codecs/wm9090.c: warning: unused variable 'wm9090':  => 658:22, 658
  + warning:   LD [M]  sound/pci/snd-es1938.o:  => N/A
  + warning: (BRIDGE_NF_EBTABLES) selects NETFILTER_XTABLES which has unmet direct dependencies (NET && INET && NETFILTER):  => N/A
  + warning: (EP8248E && MPC85xx_MDS && GRETH && DNET && OCTEON_MGMT_ETHERNET && ETHOC && SH_ETH && S6GMAC && MIPS_AU1X00_ENET && MACB && BFIN_MAC && BCM63XX_ENET && SB1250_MAC && TIGON3 && FTGMAC100 && FEC && FEC_MPC52xx && FS_ENET && FSL_PQ_MDIO && UCC_GETH && GIANFAR && IXP4XX_ETH && MV643XX_ETH && PXA168_ETH && AX88796 && W90P910_ETH && PASEMI_MAC && R6040 && SMSC911X && SMSC9420 && STMMAC_ETH && TI_DAVINCI_EMAC && TI_DAVINCI_MDIO && CPMAC && TC35815 && XILINX_EMACLITE && XILINX_LL_TEMAC && ET131X && OCTEON_ETHERNET) selects PHYLIB which has unmet direct dependencies (!S390 && NETDEVICES):  => N/A
  + warning: (EP8248E && SH_ETH && FS_ENET_MDIO_FCC && AX88796) selects MDIO_BITBANG which has unmet direct dependencies (NETDEVICES && PHYLIB):  => N/A
  + warning: (IA32_EMULATION) selects COMPAT_BINFMT_ELF which has unmet direct dependencies (COMPAT && BINFMT_ELF):  => N/A
  + warning: (IMA) selects TCG_TIS which has unmet direct dependencies (TCG_TPM && X86):  => N/A
  + warning: (IWLWIFI && IWLEGACY && ATH5K && ATH9K && ATH9K_HTC && CARL9170_LEDS) selects MAC80211_LEDS which has unmet direct dependencies (NET && WIRELESS && MAC80211 && LEDS_CLASS):  => N/A
  + warning: (KS8851 && AX88796_93CX6 && RTL8180 && RTL8187 && ADM8211 && RT2400PCI && RT2500PCI && RT61PCI && RT2800PCI && R8187SE) selects EEPROM_93CX6 which has unmet direct dependencies (MISC_DEVICES):  => N/A
  + warning: (MIPS_ALCHEMY && CAVIUM_OCTEON_REFERENCE_BOARD && SOC_AR71XX && SOC_AR724X && SOC_AR913X && SOC_AR933X) selects USB_ARCH_HAS_EHCI which has unmet direct dependencies (USB_SUPPORT):  => N/A
  + warning: (PPC_MPC5200_LPBFIFO) selects PPC_BESTCOMM_GEN_BD which has unmet direct dependencies (PPC_BESTCOMM):  => N/A
  + warning: (USB_HWA_HCD) selects USB_WUSB which has unmet direct dependencies (USB_SUPPORT && EXPERIMENTAL && USB && PCI):  => N/A
  + warning: (USB_HWA_HCD) selects UWB_HWA which has unmet direct dependencies (UWB && USB):  => N/A
  + warning: (USB_LANGWELL_OTG && FSL_USB2_OTG && USB_MV_OTG) selects USB_OTG which has unmet direct dependencies (USB_SUPPORT && USB && EXPERIMENTAL && USB_SUSPEND):  => N/A
  + warning: __mcount_loc already exists: arch/sparc/kernel/irq_64.o:  => N/A

    [ 940 lines deleted ]

  + warning: arch/powerpc/kernel/built-in.o(.text+0x3ee78): Section mismatch in reference from the function .prom_query_opal() to the function .init.text:.call_prom():  => N/A
  + warning: arch/powerpc/kernel/built-in.o(.text+0x3eea0): Section mismatch in reference from the function .prom_query_opal() to the function .init.text:.call_prom():  => N/A
  + warning: arch/powerpc/kernel/built-in.o(.text+0x3eeb8): Section mismatch in reference from the function .prom_query_opal() to the function .init.text:.prom_printf():  => N/A
  + warning: arch/powerpc/kernel/built-in.o(.text+0x3eefc): Section mismatch in reference from the function .prom_query_opal() to the function .init.text:.prom_printf():  => N/A
  + warning: arch/powerpc/kernel/built-in.o(.text+0x3ef1c): Section mismatch in reference from the function .prom_query_opal() to the function .init.text:.prom_printf():  => N/A
  + warning: arch/powerpc/kernel/built-in.o(.text+0x3f1f4): Section mismatch in reference from the function .prom_opal_takeover() to the function .init.text:.prom_printf():  => N/A
  + warning: arch/powerpc/kernel/built-in.o(.text+0x3f1f8): Section mismatch in reference from the function .prom_opal_takeover() to the function .init.text:.prom_close_stdin():  => N/A
  + warning: arch/powerpc/kernel/built-in.o(.text+0x405a0): Section mismatch in reference from the function .prom_query_opal() to the function .init.text:.call_prom():  => N/A
  + warning: arch/powerpc/kernel/built-in.o(.text+0x405c8): Section mismatch in reference from the function .prom_query_opal() to the function .init.text:.call_prom():  => N/A
  + warning: arch/powerpc/kernel/built-in.o(.text+0x405e0): Section mismatch in reference from the function .prom_query_opal() to the function .init.text:.prom_printf():  => N/A
  + warning: arch/powerpc/kernel/built-in.o(.text+0x40624): Section mismatch in reference from the function .prom_query_opal() to the function .init.text:.prom_printf():  => N/A
  + warning: arch/powerpc/kernel/built-in.o(.text+0x40644): Section mismatch in reference from the function .prom_query_opal() to the function .init.text:.prom_printf():  => N/A
  + warning: arch/powerpc/kernel/built-in.o(.text+0x4091c): Section mismatch in reference from the function .prom_opal_takeover() to the function .init.text:.prom_printf():  => N/A
  + warning: arch/powerpc/kernel/built-in.o(.text+0x40920): Section mismatch in reference from the function .prom_opal_takeover() to the function .init.text:.prom_close_stdin():  => N/A
  + warning: arch/powerpc/platforms/built-in.o(.text+0x154d0): Section mismatch in reference from the function .pnv_pci_ioda_msi_setup() to the function .devinit.text:.__pnv_ioda_get_one_pe():  => N/A
  + warning: arch/powerpc/platforms/built-in.o(.text+0x154ec): Section mismatch in reference from the function .pnv_pci_ioda_msi_setup() to the function .devinit.text:.__pnv_ioda_get_one_pe():  => N/A
  + warning: arch/powerpc/platforms/powernv/built-in.o(.text+0x4444): Section mismatch in reference from the function .pnv_pci_ioda_msi_setup() to the function .devinit.text:.__pnv_ioda_get_one_pe():  => N/A
  + warning: arch/powerpc/platforms/powernv/built-in.o(.text+0x4460): Section mismatch in reference from the function .pnv_pci_ioda_msi_setup() to the function .devinit.text:.__pnv_ioda_get_one_pe():  => N/A
  + warning: arch/powerpc/sysdev/built-in.o(.text+0x1011c): Section mismatch in reference from the function .ics_rtas_init() to the function .init.text:.xics_register_ics():  => N/A
  + warning: arch/powerpc/sysdev/built-in.o(.text+0xea64): Section mismatch in reference from the function .ics_rtas_init() to the function .init.text:.xics_register_ics():  => N/A
  + warning: arch/powerpc/sysdev/xics/built-in.o(.text+0x282c): Section mismatch in reference from the function .ics_rtas_init() to the function .init.text:.xics_register_ics():  => N/A
  + warning: drivers/built-in.o(.devexit.text+0x38a90): Section mismatch in reference from the function .pio2_remove() to the function .exit.text:.pio2_gpio_exit():  => N/A
  + warning: drivers/built-in.o(.devinit.text+0x21a838): Section mismatch in reference from the function .pio2_probe() to the function .init.text:.pio2_gpio_init():  => N/A
  + warning: drivers/built-in.o(.devinit.text+0x21a988): Section mismatch in reference from the function .pio2_probe() to the function .exit.text:.pio2_gpio_exit():  => N/A
  + warning: drivers/built-in.o(.text+0x1052c1): Section mismatch in reference from the function da9052_spi_probe() to the function .devinit.text:da9052_device_init():  => N/A
  + warning: drivers/built-in.o(.text+0x108cb90): Section mismatch in reference from the function .doc_probe_device() to the function .init.text:.doc_set_driver_info():  => N/A
  + warning: drivers/built-in.o(.text+0x30d5a): Section mismatch in reference from the function da9052_spi_probe() to the function .devinit.text:da9052_device_init():  => N/A
  + warning: drivers/built-in.o(.text+0x5c098): Section mismatch in reference from the function da9052_spi_probe() to the function .devinit.text:da9052_device_init():  => N/A
  + warning: drivers/built-in.o(.text+0x8c6b70): Section mismatch in reference from the function .da9052_spi_probe() to the function .devinit.text:.da9052_device_init():  => N/A
  + warning: drivers/built-in.o(.text+0xf9898): Section mismatch in reference from the function .da9052_spi_probe() to the function .devinit.text:.da9052_device_init():  => N/A
  + warning: drivers/leds/built-in.o(.data+0x274): Section mismatch in reference from the variable pwmled_driver to the function .init.text:leds_init():  => N/A
  + warning: drivers/mfd/built-in.o(.text+0x14d64): Section mismatch in reference from the function da9052_spi_probe() to the function .devinit.text:da9052_device_init():  => N/A
  + warning: drivers/mfd/built-in.o(.text+0x1c824): Section mismatch in reference from the function .da9052_spi_probe() to the function .devinit.text:.da9052_device_init():  => N/A
  + warning: drivers/mfd/built-in.o(.text+0x2f42): Section mismatch in reference from the function da9052_spi_probe() to the function .devinit.text:da9052_device_init():  => N/A
  + warning: drivers/mfd/built-in.o(.text+0x4440): Section mismatch in reference from the function da9052_spi_probe() to the function .devinit.text:da9052_device_init():  => N/A
  + warning: drivers/mfd/built-in.o(.text+0x4d68): Section mismatch in reference from the function da9052_spi_probe() to the function .devinit.text:da9052_device_init():  => N/A
  + warning: drivers/mfd/built-in.o(.text+0x57a1): Section mismatch in reference from the function da9052_spi_probe() to the function .devinit.text:da9052_device_init():  => N/A
  + warning: drivers/mfd/built-in.o(.text+0x73dc): Section mismatch in reference from the function da9052_spi_probe() to the function .devinit.text:da9052_device_init():  => N/A
  + warning: drivers/mtd/built-in.o(.text+0x89f74): Section mismatch in reference from the function .doc_probe_device() to the function .init.text:.doc_set_driver_info():  => N/A
  + warning: drivers/mtd/devices/built-in.o(.text+0x2665c): Section mismatch in reference from the function .doc_probe_device() to the function .init.text:.doc_set_driver_info():  => N/A
  + warning: drivers/sbus/char/bbc.o(.devinit.text+0x8): Section mismatch in reference from the function bbc_i2c_probe() to the function .init.text:T.408():  => N/A
  + warning: drivers/staging/built-in.o(.devexit.text+0x71c): Section mismatch in reference from the function .pio2_remove() to the function .exit.text:.pio2_gpio_exit():  => N/A
  + warning: drivers/staging/built-in.o(.devinit.text+0x431c): Section mismatch in reference from the function .pio2_probe() to the function .init.text:.pio2_gpio_init():  => N/A
  + warning: drivers/staging/built-in.o(.devinit.text+0x446c): Section mismatch in reference from the function .pio2_probe() to the function .exit.text:.pio2_gpio_exit():  => N/A
  + warning: drivers/staging/comedi/drivers/s626.o(.text+0x2ef9): Section mismatch in reference from the function s626_attach() to the variable .devinit.rodata:s626_pci_table:  => N/A
  + warning: drivers/staging/comedi/drivers/s626.o(.text+0x2f03): Section mismatch in reference from the function s626_attach() to the variable .devinit.rodata:s626_pci_table:  => N/A
  + warning: drivers/staging/comedi/drivers/s626.o(.text+0x2f0a): Section mismatch in reference from the function s626_attach() to the variable .devinit.rodata:s626_pci_table:  => N/A
  + warning: drivers/staging/comedi/drivers/s626.o(.text+0x2f2a): Section mismatch in reference from the function s626_attach() to the variable .devinit.rodata:s626_pci_table:  => N/A
  + warning: drivers/staging/vme/built-in.o(.devexit.text+0x1d4): Section mismatch in reference from the function .pio2_remove() to the function .exit.text:.pio2_gpio_exit():  => N/A
  + warning: drivers/staging/vme/built-in.o(.devinit.text+0xe9c): Section mismatch in reference from the function .pio2_probe() to the function .init.text:.pio2_gpio_init():  => N/A
  + warning: drivers/staging/vme/built-in.o(.devinit.text+0xfec): Section mismatch in reference from the function .pio2_probe() to the function .exit.text:.pio2_gpio_exit():  => N/A
  + warning: drivers/staging/vme/devices/built-in.o(.devexit.text+0x1d4): Section mismatch in reference from the function .pio2_remove() to the function .exit.text:.pio2_gpio_exit():  => N/A
  + warning: drivers/staging/vme/devices/built-in.o(.devinit.text+0xe9c): Section mismatch in reference from the function .pio2_probe() to the function .init.text:.pio2_gpio_init():  => N/A
  + warning: drivers/staging/vme/devices/built-in.o(.devinit.text+0xfec): Section mismatch in reference from the function .pio2_probe() to the function .exit.text:.pio2_gpio_exit():  => N/A
  + warning: drivers/staging/vme/devices/vme_pio2.o(.devexit.text+0x18): Section mismatch in reference from the function pio2_remove() to the function .exit.text:pio2_gpio_exit():  => N/A
  + warning: drivers/staging/vme/devices/vme_pio2.o(.devexit.text+0x31): Section mismatch in reference from the function pio2_remove() to the function .exit.text:pio2_gpio_exit():  => N/A
  + warning: drivers/staging/vme/devices/vme_pio2.o(.devexit.text+0x44): Section mismatch in reference from the function .pio2_remove() to the function .exit.text:.pio2_gpio_exit():  => N/A
  + warning: drivers/staging/vme/devices/vme_pio2.o(.devinit.text+0x490): Section mismatch in reference from the function pio2_probe() to the function .init.text:pio2_gpio_init():  => N/A
  + warning: drivers/staging/vme/devices/vme_pio2.o(.devinit.text+0x548): Section mismatch in reference from the function pio2_probe() to the function .exit.text:pio2_gpio_exit():  => N/A
  + warning: drivers/staging/vme/devices/vme_pio2.o(.devinit.text+0x57e): Section mismatch in reference from the function pio2_probe() to the function .init.text:pio2_gpio_init():  => N/A
  + warning: drivers/staging/vme/devices/vme_pio2.o(.devinit.text+0x67d): Section mismatch in reference from the function pio2_probe() to the function .exit.text:pio2_gpio_exit():  => N/A
  + warning: drivers/staging/vme/devices/vme_pio2.o(.devinit.text+0x730): Section mismatch in reference from the function .pio2_probe() to the function .init.text:.pio2_gpio_init():  => N/A
  + warning: drivers/staging/vme/devices/vme_pio2.o(.devinit.text+0x880): Section mismatch in reference from the function .pio2_probe() to the function .exit.text:.pio2_gpio_exit():  => N/A
  + warning: drivers/usb/gadget/g_ffs.o(.text+0x4fea): Section mismatch in reference from the function eth_bind_config() to the function .init.text:geth_bind_config():  => N/A
  + warning: drivers/usb/gadget/g_ffs.o(.text+0xbe1c): Section mismatch in reference from the function eth_bind_config() to the function .init.text:geth_bind_config():  => N/A
  + warning: drivers/usb/gadget/g_multi.o(.text+0x804c): Section mismatch in reference from the function cdc_config_register() to the function .init.text:cdc_do_config():  => N/A
  + warning: drivers/usb/gadget/g_multi.o(.text+0x80b4): Section mismatch in reference from the function rndis_config_register() to the function .init.text:rndis_do_config():  => N/A
  + warning: kernel/built-in.o(.text+0x15c6e0): Section mismatch in reference from the function .rcu_torture_onoff() to the function .cpuinit.text:.cpu_up():  => N/A
  + warning: kernel/built-in.o(.text+0x1a7490): Section mismatch in reference from the function rcu_torture_onoff() to the function .cpuinit.text:cpu_up():  => N/A
  + warning: vmlinux.o(.devexit.text+0x38a90): Section mismatch in reference from the function .pio2_remove() to the function .exit.text:.pio2_gpio_exit():  => N/A
  + warning: vmlinux.o(.devinit.text+0x223ba0): Section mismatch in reference from the function .pio2_probe() to the function .init.text:.pio2_gpio_init():  => N/A
  + warning: vmlinux.o(.devinit.text+0x223cf0): Section mismatch in reference from the function .pio2_probe() to the function .exit.text:.pio2_gpio_exit():  => N/A
  + warning: vmlinux.o(.text+0x1961f74): Section mismatch in reference from the function .da9052_spi_probe() to the function .devinit.text:.da9052_device_init():  => N/A
  + warning: vmlinux.o(.text+0x1afcce): Section mismatch in reference from the function da9052_spi_probe() to the function .devinit.text:da9052_device_init():  => N/A
  + warning: vmlinux.o(.text+0x2127f94): Section mismatch in reference from the function .doc_probe_device() to the function .init.text:.doc_set_driver_info():  => N/A
  + warning: vmlinux.o(.text+0x2204e8): Section mismatch in reference from the function rcu_torture_onoff() to the function .cpuinit.text:cpu_up():  => N/A
  + warning: vmlinux.o(.text+0x282630): Section mismatch in reference from the function .rcu_torture_onoff() to the function .cpuinit.text:.cpu_up():  => N/A
  + warning: vmlinux.o(.text+0x3082c): Section mismatch in reference from the function .early_setup_secondary() to the function .cpuinit.text:.early_init_mmu_secondary():  => N/A
  + warning: vmlinux.o(.text+0x32b178): Section mismatch in reference from the function da9052_spi_probe() to the function .devinit.text:da9052_device_init():  => N/A
  + warning: vmlinux.o(.text+0x48aaa9): Section mismatch in reference from the function da9052_spi_probe() to the function .devinit.text:da9052_device_init():  => N/A
  + warning: vmlinux.o(.text+0x4bbe0): Section mismatch in reference from the function .prom_query_opal() to the function .init.text:.call_prom():  => N/A
  + warning: vmlinux.o(.text+0x4bc08): Section mismatch in reference from the function .prom_query_opal() to the function .init.text:.call_prom():  => N/A
  + warning: vmlinux.o(.text+0x4bc20): Section mismatch in reference from the function .prom_query_opal() to the function .init.text:.prom_printf():  => N/A
  + warning: vmlinux.o(.text+0x4bc64): Section mismatch in reference from the function .prom_query_opal() to the function .init.text:.prom_printf():  => N/A
  + warning: vmlinux.o(.text+0x4bc84): Section mismatch in reference from the function .prom_query_opal() to the function .init.text:.prom_printf():  => N/A
  + warning: vmlinux.o(.text+0x4bf5c): Section mismatch in reference from the function .prom_opal_takeover() to the function .init.text:.prom_printf():  => N/A
  + warning: vmlinux.o(.text+0x4bf60): Section mismatch in reference from the function .prom_opal_takeover() to the function .init.text:.prom_close_stdin():  => N/A
  + warning: vmlinux.o(.text+0x54654): Section mismatch in reference from the function .wake_offline_cpus() to the function .cpuinit.text:.cpu_up():  => N/A
  + warning: vmlinux.o(.text+0x60469): Section mismatch in reference from the function mem_hole_size() to the function .init.text:absent_pages_in_range():  => N/A
  + warning: vmlinux.o(.text+0x868c4): Section mismatch in reference from the function .ics_rtas_init() to the function .init.text:.xics_register_ics():  => N/A
  + warning: vmlinux.o(.text+0x9c550): Section mismatch in reference from the function .pnv_pci_ioda_msi_setup() to the function .devinit.text:.__pnv_ioda_get_one_pe():  => N/A
  + warning: vmlinux.o(.text+0x9c56c): Section mismatch in reference from the function .pnv_pci_ioda_msi_setup() to the function .devinit.text:.__pnv_ioda_get_one_pe():  => N/A
  + warning: vmlinux.o(.text+0xa1698): Section mismatch in reference from the function .pci_dn_reconfig_notifier() to the function .devinit.text:.update_dn_pci_info():  => N/A
  + warning: vmlinux.o(.text+0xa644c): Section mismatch in reference from the function .dlpar_online_cpu() to the function .cpuinit.text:.cpu_up():  => N/A
  + warning: vmlinux.o(.text+0xae1a0): Section mismatch in reference from the function .pcibios_add_pci_devices() to the function .devinit.text:.of_rescan_bus():  => N/A
  + warning: vmlinux.o(.text+0xae22c): Section mismatch in reference from the function .pcibios_add_pci_devices() to the function .devinit.text:.pcibios_setup_bus_devices():  => N/A
  + warning: vmlinux.o(.text+0xae290): Section mismatch in reference from the function .pcibios_add_pci_devices() to the function .devinit.text:.pci_scan_bridge():  => N/A
  + warning: vmlinux.o(.text+0xb6112): Section mismatch in reference from the variable system_reset_iSeries to the variable .init.data:boot_paca:  => N/A

545 improvements:
  - .config: warning: override: HIGHMEM4G changes choice state: 316 => 
  - .config: warning: override: PCI_GOANY changes choice state: 424 => 
  - /tmp/ccjgBklk.s: Warning: source register same as write-back base: 104 => 
  - <stdin>: warning: #warning syscall clock_adjtime not implemented: 1546:2 => 
  - <stdin>: warning: #warning syscall dup3 not implemented: 1494:2 => 
  - <stdin>: warning: #warning syscall epoll_create1 not implemented: 1490:2 => 
  - <stdin>: warning: #warning syscall eventfd2 not implemented: 1486:2 => 
  - <stdin>: warning: #warning syscall fallocate not implemented: 1470:2 => 
  - <stdin>: warning: #warning syscall fanotify_init not implemented: 1526:2 => 
  - <stdin>: warning: #warning syscall fanotify_mark not implemented: 1530:2 => 
  - <stdin>: warning: #warning syscall inotify_init1 not implemented: 1502:2 => 
  - <stdin>: warning: #warning syscall name_to_handle_at not implemented: 1538:2 => 
  - <stdin>: warning: #warning syscall open_by_handle_at not implemented: 1542:2 => 
  - <stdin>: warning: #warning syscall perf_event_open not implemented: 1518:2 => 
  - <stdin>: warning: #warning syscall pipe2 not implemented: 1498:2 => 
  - <stdin>: warning: #warning syscall pread64 not implemented: 906:2 => 
  - <stdin>: warning: #warning syscall preadv not implemented: 1506:2 => 
  - <stdin>: warning: #warning syscall prlimit64 not implemented: 1534:2 => 
  - <stdin>: warning: #warning syscall process_vm_readv not implemented: 1562:2 => 
  - <stdin>: warning: #warning syscall process_vm_writev not implemented: 1566:2 => 
  - <stdin>: warning: #warning syscall pwrite64 not implemented: 910:2 => 
  - <stdin>: warning: #warning syscall pwritev not implemented: 1510:2 => 
  - <stdin>: warning: #warning syscall recvmmsg not implemented: 1522:2 => 
  - <stdin>: warning: #warning syscall rt_tgsigqueueinfo not implemented: 1514:2 => 
  - <stdin>: warning: #warning syscall sendmmsg not implemented: 1554:2 => 
  - <stdin>: warning: #warning syscall signalfd4 not implemented: 1482:2 => 
  - <stdin>: warning: #warning syscall sync_file_range not implemented: 1430:2 => 
  - <stdin>: warning: #warning syscall syncfs not implemented: 1550:2 => 
  - <stdin>: warning: #warning syscall timerfd_create not implemented: 1462:2 => 
  - <stdin>: warning: #warning syscall timerfd_gettime not implemented: 1478:2 => 
  - <stdin>: warning: #warning syscall timerfd_settime not implemented: 1474:2 => 
  - <stdin>: warning: #warning syscall umount2 not implemented: 394:2 => 
  - modpost: WARNING: modpost: Found 10 section mismatch(es).: N/A => 
  - modpost: WARNING: modpost: Found 11 section mismatch(es).: N/A => 
  - modpost: WARNING: modpost: Found 17 section mismatch(es).: N/A => 
  - modpost: WARNING: modpost: Found 20 section mismatch(es).: N/A => 
  - src/arch/ia64/sn/kernel/tiocx.c: warning: ignoring return value of 'bus_register', declared with attribute warn_unused_result: 493 => 
  - src/arch/ia64/sn/kernel/tiocx.c: warning: ignoring return value of 'device_create_file', declared with attribute warn_unused_result: 213 => 
  - src/arch/x86/kernel/apm_32.c: warning: #warning deprecated CONFIG_APM_CPU_IDLE will be deleted in 2012: 362:2 => 
  - src/arch/x86/kernel/quirks.c: warning: 'd' may be used uninitialized in this function: 364 => 
  - src/arch/x86/kernel/quirks.c: warning: 'val' may be used uninitialized in this function: 407 => 
  - src/arch/xtensa/include/asm/regs.h: warning: this is the location of the previous definition: 59:1 => 
  - src/arch/xtensa/kernel/entry.S: Warning: value 0xffffffff30000000 truncated to 0x30000000: 1545 => 
  - src/arch/xtensa/kernel/irq.c: warning: passing argument 1 of 'xtensa_irq_mask' makes pointer from integer without a cast: 92 => 
  - src/arch/xtensa/kernel/irq.c: warning: passing argument 1 of 'xtensa_irq_unmask' makes pointer from integer without a cast: 87 => 
  - src/arch/xtensa/kernel/process.c: warning: unused variable 'ti': 180 => 
  - src/arch/xtensa/kernel/time.c: warning: initialization from incompatible pointer type: 42 => 
  - src/arch/xtensa/mm/tlb.c: warning: comparison of distinct pointer types lacks a cast: 71, 68 => 
  - src/drivers/bluetooth/btwilink.c: warning: overflow in implicit constant conversion: 179 => 
  - src/drivers/char/mbcs.c: warning: ignoring return value of 'device_create_file', declared with attribute warn_unused_result: 786 => 
  - src/drivers/char/rtc.c: warning: 'rtc_freq' defined but not used: 193 => 
  - src/drivers/idle/intel_idle.c: warning: cast to pointer from integer of different size: 518 => 
  - src/drivers/input/misc/twl4030-vibra.c: warning: 'twl4030_vibra_resume' defined but not used: 188 => 
  - src/drivers/input/misc/twl4030-vibra.c: warning: 'twl4030_vibra_suspend' defined but not used: 177 => 
  - src/drivers/leds/leds-lp5521.c: warning: 'ret' may be used uninitialized in this function: 648, 648:6 => 648
  - src/drivers/md/dm-table.c: warning: statement with no effect: 1285, 1285:3 => 
  - src/drivers/media/rc/redrat3.c: warning: assignment from incompatible pointer type: 1100:12, 1100 => 
  - src/drivers/media/video/em28xx/em28xx-core.c: warning: 'packet_size' may be used uninitialized in this function: 1116 => 
  - src/drivers/media/video/uvc/uvc_queue.c: warning: 'buffer' may be used uninitialized in this function: 504 => 
  - src/drivers/media/video/uvc/uvc_queue.c: warning: unused variable 'page': 413 => 
  - src/drivers/mfd/mc13xxx-core.c: warning: 'id' may be used uninitialized in this function: 703 => 
  - src/drivers/mfd/twl6030-irq.c: warning: cast to pointer from integer of different size: 396:9, 378:24 => 
  - src/drivers/mtd/chips/cfi_cmdset_0020.c: warning: the frame size of 1132 bytes is larger than 1024 bytes: 421 => 
  - src/drivers/mtd/chips/cfi_cmdset_0020.c: warning: the frame size of 1376 bytes is larger than 1024 bytes: 984 => 
  - src/drivers/mtd/chips/cfi_cmdset_0020.c: warning: the frame size of 1672 bytes is larger than 1024 bytes: 659 => 
  - src/drivers/mtd/devices/docg3.c: warning: 'doc_get_erase_count' defined but not used: 752:12, 752, 753 => 
  - src/drivers/mtd/devices/sst25l.c: warning: unused variable 'i': 381:11, 381 => 
  - src/drivers/mtd/ftl.c: warning: passing argument 4 of 'part->mbd.mtd->read' from incompatible pointer type: 527, 294, 228, 490 => 
  - src/drivers/mtd/ftl.c: warning: passing argument 4 of 'part->mbd.mtd->write' from incompatible pointer type: 564, 535, 426, 507, 442, 555 => 
  - src/drivers/mtd/sm_ftl.c: warning: comparison of distinct pointer types lacks a cast: 216:95, 215, 215:100, 216 => 215, 216
  - src/drivers/nfc/nfcwilink.c: warning: overflow in implicit constant conversion: 140 => 
  - src/drivers/staging/gma500/mid_bios.c: warning: cast from pointer to integer of different size: 201, 192, 202 => 
  - src/drivers/staging/gma500/power.c: warning: passing argument 1 of 'gma_resume_display' from incompatible pointer type: 269 => 
  - src/drivers/staging/gma500/psb_drv.c: warning: cast to pointer from integer of different size: 712 => 
  - src/drivers/staging/iio/accel/lis3l02dq_core.c: warning: initialization from incompatible pointer type: 660:2, 660 => 
  - src/drivers/staging/iio/gyro/adis16080_core.c: warning: 'ut' may be used uninitialized in this function: 85:6, 85 => 85
  - src/drivers/staging/media/dt3155v4l/dt3155v4l.c: warning: initialization from incompatible pointer type: 311:2, 307:2, 307, 311 => 
  - src/drivers/staging/sm7xx/smtcfb.c: warning: 'sm712vga_setup' defined but not used: 831:122, 831:19, 832, 831 => 831:19, 832, 831
  - src/drivers/staging/vme/bridges/vme_ca91cx42.c: warning: cast from pointer to integer of different size: 993, 939, 879, 933, 885 => 
  - src/drivers/thermal/thermal_sys.c: warning: 'thermal_event_seqnum' defined but not used: 63:21, 63 => 63
  - src/drivers/usb/dwc3/gadget.c: warning: 'trb' is used uninitialized in this function: 1331 => 
  - src/drivers/usb/host/ehci-xilinx-of.c: warning: initialization from incompatible pointer type: 293:2 => 
  - src/drivers/uwb/i1480/dfu/dfu.c: warning: format '%zd' expects type 'signed size_t', but argument 4 has type 'ssize_t': 123 => 
  - src/drivers/uwb/i1480/dfu/dfu.c: warning: format '%zu' expects type 'size_t', but argument 4 has type 'ssize_t': 142 => 
  - src/drivers/uwb/i1480/dfu/mac.c: warning: format '%zd' expects type 'signed size_t', but argument 3 has type 'ssize_t': 180 => 
  - src/drivers/uwb/i1480/dfu/mac.c: warning: format '%zd' expects type 'signed size_t', but argument 7 has type 'ssize_t': 243, 234 => 
  - src/drivers/uwb/i1480/dfu/mac.c: warning: format '%zu' expects type 'size_t', but argument 4 has type 'ssize_t': 488 => 
  - src/drivers/uwb/i1480/dfu/usb.c: warning: format '%zd' expects type 'signed size_t', but argument 4 has type 'ssize_t': 174 => 
  - src/drivers/uwb/i1480/dfu/usb.c: warning: format '%zu' expects type 'size_t', but argument 4 has type 'ssize_t': 181 => 
  - src/drivers/uwb/ie.c: warning: format '%zu' expects type 'size_t', but argument 3 has type 'ssize_t': 140, 135 => 
  - src/drivers/uwb/neh.c: warning: format '%zd' expects type 'signed size_t', but argument 6 has type 'ssize_t': 517 => 
  - src/drivers/uwb/neh.c: warning: format '%zu' expects type 'size_t', but argument 3 has type 'ssize_t': 387 => 
  - src/drivers/uwb/reset.c: warning: format '%zu' expects type 'size_t', but argument 4 has type 'ssize_t': 240 => 
  - src/drivers/video/gbefb.c: warning: ignoring return value of 'device_create_file', declared with attribute warn_unused_result: 1094, 1093 => 
  - src/drivers/watchdog/gef_wdt.c: warning: 'gef_wdt_remove' defined but not used: 287:125 => 
  - src/fs/9p/xattr.c: warning: format '%zd' expects type 'signed size_t', but argument 3 has type 'ssize_t': 35 => 
  - src/fs/compat_binfmt_elf.c: warning: 'cputime_to_compat_timeval' defined but not used: 51 => 
  - src/fs/nfs/nfs4filelayout.c: warning: comparison of distinct pointer types lacks a cast: 58 => 
  - src/fs/sysfs/dir.c: warning: 'sysfs_pathname' defined but not used: 440, 441 => 441
  - src/include/math-emu/double.h: warning: "__LITTLE_ENDIAN" is not defined: 59:5 => 
  - src/include/math-emu/single.h: warning: "__LITTLE_ENDIAN" is not defined: 50:5 => 
  - src/kernel/irq/debug.h: warning: "PS" redefined: 8:1 => 
  - src/kernel/sched.c: warning: control may reach end of non-void function 'pick_next_task' being inlined: 4446 => 
  - src/kernel/sched.c: warning: control reaches end of non-void function: 4390 => 
  - src/kernel/sched.c: warning: initialization from incompatible pointer type: 7533 => 
  - src/kernel/sched.c: warning: unsupported argument to '__builtin_return_address': 4263, 4261 => 
  - src/kernel/sched_fair.c: warning: 'account_cfs_rq_runtime' declared inline after being called: 310, 309 => 
  - src/kernel/sched_fair.c: warning: 'return_cfs_rq_runtime' declared inline after being called: 1068 => 
  - src/kernel/sched_fair.c: warning: previous declaration of 'account_cfs_rq_runtime' was here: 310, 309 => 
  - src/kernel/sched_fair.c: warning: previous declaration of 'return_cfs_rq_runtime' was here: 1068 => 
  - src/kernel/trace/ring_buffer.c: warning: unused variable 'local_clock_stable': 2202 => 
  - src/kernel/watchdog.c: warning: 'watchdog_disable' defined but not used: 463:13, 463 => 
  - src/lib/debugobjects.c: warning: 'obj_states' defined but not used: 73 => 
  - src/lib/debugobjects.c: warning: unused variable 'hint': 256 => 
  - src/lib/radix-tree.c: warning: 'radix_tree_range_tag_if_tagged' uses dynamic stack allocation: 741 => 
  - src/net/core/net-sysfs.c: warning: comparison is always false due to limited range of data type: 672 => 
  - src/net/ipv4/ipconfig.c: warning: 'ic_nameservers' defined but not used: 152 => 
  - src/net/sched/cls_flow.c: warning: 'flow_classify' uses dynamic stack allocation: 408 => 
  - src/sound/soc/codecs/adav80x.c: warning: 'adav80x_bus_remove' defined but not used: 863 => 
  - src/sound/soc/codecs/wm2000.c: warning: 'wm2000_i2c_resume' defined but not used: 848 => 
  - src/sound/soc/codecs/wm2000.c: warning: 'wm2000_i2c_suspend' defined but not used: 840 => 
  - src/sound/soc/codecs/wm8994.c: warning: unused variable 'wm8994': 58:22, 58 => 
  - src/sound/soc/sh/fsi.c: warning: passing argument 1 of '__fsi_reg_mask_set' makes pointer from integer without a cast: 664, 920, 742, 898, 739 => 
  - src/sound/soc/sh/fsi.c: warning: passing argument 1 of '__fsi_reg_read' makes pointer from integer without a cast: 453, 506, 443, 529, 444, 454 => 
  - src/sound/soc/sh/fsi.c: warning: passing argument 1 of '__fsi_reg_write' makes pointer from integer without a cast: 741, 738, 468, 518, 911, 469, 915, 494, 914 => 
  - warning: (AX88796_93CX6 && RTL8180 && RTL8187 && ADM8211 && RT2400PCI && RT2500PCI && RT61PCI && RT2800PCI && R8187SE) selects EEPROM_93CX6 which has unmet direct dependencies (MISC_DEVICES): N/A => 
  - warning: (IMA) selects TCG_TPM which has unmet direct dependencies (HAS_IOMEM && EXPERIMENTAL): N/A => 
  - warning: (ISDN_PPP) selects SLHC which has unmet direct dependencies (NETDEVICES): N/A => 
  - warning: (IWLWIFI && IWLWIFI_LEGACY && ATH5K && ATH9K && ATH9K_HTC && CARL9170_LEDS) selects MAC80211_LEDS which has unmet direct dependencies (NET && WIRELESS && MAC80211 && LEDS_CLASS): N/A => 
  - warning: (MIPS_ALCHEMY && CAVIUM_OCTEON_REFERENCE_BOARD && SOC_AR71XX && SOC_AR724X && SOC_AR913X) selects USB_ARCH_HAS_EHCI which has unmet direct dependencies (USB_SUPPORT): N/A => 
  - warning: (MTD_DOC2000 && MTD_DOC2001 && MTD_DOC2001PLUS) selects MTD_NAND_IDS which has unmet direct dependencies (MTD && MTD_NAND): N/A => 
  - warning: (RADIO_WL128X) selects TI_ST which has unmet direct dependencies (MISC_DEVICES && NET && GPIOLIB): N/A => 
  - warning: (SCHED_AUTOGROUP) selects CGROUP_SCHED which has unmet direct dependencies (CGROUPS && EXPERIMENTAL): N/A => 
  - warning: (USB_WUSB) selects UWB which has unmet direct dependencies (EXPERIMENTAL && PCI): N/A => 
  - warning: 1 bad relocations: N/A => 
  - warning: __mcount_loc already exists: arch/sparc/kernel/power.o: N/A => 

    [ 309 lines deleted ]

  - warning: arch/powerpc/kernel/built-in.o(.text+0x3ebd4): Section mismatch in reference from the function .prom_query_opal() to the function .init.text:.call_prom(): N/A => 
  - warning: arch/powerpc/kernel/built-in.o(.text+0x3ebfc): Section mismatch in reference from the function .prom_query_opal() to the function .init.text:.call_prom(): N/A => 
  - warning: arch/powerpc/kernel/built-in.o(.text+0x3ec14): Section mismatch in reference from the function .prom_query_opal() to the function .init.text:.prom_printf(): N/A => 
  - warning: arch/powerpc/kernel/built-in.o(.text+0x3ec58): Section mismatch in reference from the function .prom_query_opal() to the function .init.text:.prom_printf(): N/A => 
  - warning: arch/powerpc/kernel/built-in.o(.text+0x3ec78): Section mismatch in reference from the function .prom_query_opal() to the function .init.text:.prom_printf(): N/A => 
  - warning: arch/powerpc/kernel/built-in.o(.text+0x3ef50): Section mismatch in reference from the function .prom_opal_takeover() to the function .init.text:.prom_printf(): N/A => 
  - warning: arch/powerpc/kernel/built-in.o(.text+0x3ef54): Section mismatch in reference from the function .prom_opal_takeover() to the function .init.text:.prom_close_stdin(): N/A => 
  - warning: arch/powerpc/kernel/built-in.o(.text+0x402d0): Section mismatch in reference from the function .prom_query_opal() to the function .init.text:.call_prom(): N/A => 
  - warning: arch/powerpc/kernel/built-in.o(.text+0x402f8): Section mismatch in reference from the function .prom_query_opal() to the function .init.text:.call_prom(): N/A => 
  - warning: arch/powerpc/kernel/built-in.o(.text+0x40310): Section mismatch in reference from the function .prom_query_opal() to the function .init.text:.prom_printf(): N/A => 
  - warning: arch/powerpc/kernel/built-in.o(.text+0x40354): Section mismatch in reference from the function .prom_query_opal() to the function .init.text:.prom_printf(): N/A => 
  - warning: arch/powerpc/kernel/built-in.o(.text+0x40374): Section mismatch in reference from the function .prom_query_opal() to the function .init.text:.prom_printf(): N/A => 
  - warning: arch/powerpc/kernel/built-in.o(.text+0x4064c): Section mismatch in reference from the function .prom_opal_takeover() to the function .init.text:.prom_printf(): N/A => 
  - warning: arch/powerpc/kernel/built-in.o(.text+0x40650): Section mismatch in reference from the function .prom_opal_takeover() to the function .init.text:.prom_close_stdin(): N/A => 
  - warning: arch/powerpc/mm/built-in.o(.text+0x9384): Section mismatch in reference from the function .of_get_lmb_size() to the function .devinit.text:.read_n_cells(): N/A => 
  - warning: arch/powerpc/mm/built-in.o(.text+0x9540): Section mismatch in reference from the function .hot_add_drconf_scn_to_nid() to the function .devinit.text:.read_n_cells(): N/A => 
  - warning: arch/powerpc/mm/built-in.o(.text+0x9bdc): Section mismatch in reference from the function .hot_add_node_scn_to_nid() to the function .devinit.text:.read_n_cells(): N/A => 
  - warning: arch/powerpc/mm/built-in.o(.text+0x9bf8): Section mismatch in reference from the function .hot_add_node_scn_to_nid() to the function .devinit.text:.read_n_cells(): N/A => 
  - warning: arch/powerpc/platforms/built-in.o(.text+0x582dc): Section mismatch in reference from the function .ps3_smp_probe() to the function .init.text:.ps3_register_ipi_irq(): N/A => 
  - warning: arch/powerpc/platforms/built-in.o(.text+0x5831c): Section mismatch in reference from the function .ps3_smp_probe() to the function .init.text:.ps3_register_ipi_debug_brk(): N/A => 
  - warning: arch/powerpc/platforms/built-in.o(.text+0x77924): Section mismatch in reference from the function .ps3_smp_probe() to the function .init.text:.ps3_register_ipi_irq(): N/A => 
  - warning: arch/powerpc/platforms/built-in.o(.text+0x77964): Section mismatch in reference from the function .ps3_smp_probe() to the function .init.text:.ps3_register_ipi_debug_brk(): N/A => 
  - warning: arch/powerpc/platforms/ps3/built-in.o(.text+0xc440): Section mismatch in reference from the function .ps3_smp_probe() to the function .init.text:.ps3_register_ipi_irq(): N/A => 
  - warning: arch/powerpc/platforms/ps3/built-in.o(.text+0xc480): Section mismatch in reference from the function .ps3_smp_probe() to the function .init.text:.ps3_register_ipi_debug_brk(): N/A => 
  - warning: arch/powerpc/sysdev/built-in.o(.text+0xe230): Section mismatch in reference from the function .ics_rtas_init() to the function .init.text:.xics_register_ics(): N/A => 
  - warning: arch/powerpc/sysdev/built-in.o(.text+0xf8e4): Section mismatch in reference from the function .ics_rtas_init() to the function .init.text:.xics_register_ics(): N/A => 
  - warning: arch/powerpc/sysdev/xics/built-in.o(.text+0x225c): Section mismatch in reference from the function .ics_rtas_init() to the function .init.text:.xics_register_ics(): N/A => 
  - warning: drivers/macintosh/built-in.o(.data+0x220): Section mismatch in reference from the variable via_pmu_driver to the function .init.text:pmu_init(): N/A => 
  - warning: drivers/mfd/cs5535-mfd.o(.data+0x20): Section mismatch in reference from the variable cs5535_mfd_drv to the function .devinit.text:cs5535_mfd_probe(): N/A => 
  - warning: drivers/mfd/cs5535-mfd.o(.data+0x28): Section mismatch in reference from the variable cs5535_mfd_drv to the function .devexit.text:cs5535_mfd_remove(): N/A => 
  - warning: drivers/sbus/char/bbc.o(.devinit.text+0x8): Section mismatch in reference from the function bbc_i2c_probe() to the function .init.text:T.409(): N/A => 
  - warning: drivers/staging/comedi/drivers/s626.o(.text+0x2efe): Section mismatch in reference from the function s626_attach() to the variable .devinit.rodata:s626_pci_table: N/A => 
  - warning: drivers/staging/comedi/drivers/s626.o(.text+0x2f08): Section mismatch in reference from the function s626_attach() to the variable .devinit.rodata:s626_pci_table: N/A => 
  - warning: drivers/staging/comedi/drivers/s626.o(.text+0x2f0f): Section mismatch in reference from the function s626_attach() to the variable .devinit.rodata:s626_pci_table: N/A => 
  - warning: drivers/staging/comedi/drivers/s626.o(.text+0x2f2f): Section mismatch in reference from the function s626_attach() to the variable .devinit.rodata:s626_pci_table: N/A => 
  - warning: drivers/usb/gadget/g_ffs.o(.text+0x5468): Section mismatch in reference from the function eth_bind_config() to the function .init.text:geth_bind_config(): N/A => 
  - warning: drivers/usb/gadget/g_ffs.o(.text+0xba64): Section mismatch in reference from the function eth_bind_config() to the function .init.text:geth_bind_config(): N/A => 
  - warning: drivers/usb/gadget/g_ffs.o(.text+0xee94): Section mismatch in reference from the function .eth_bind_config() to the function .init.text:.geth_bind_config(): N/A => 
  - warning: drivers/usb/gadget/g_multi.o(.text+0x8580): Section mismatch in reference from the function cdc_config_register() to the function .init.text:cdc_do_config(): N/A => 
  - warning: drivers/usb/gadget/g_multi.o(.text+0x85e8): Section mismatch in reference from the function rndis_config_register() to the function .init.text:rndis_do_config(): N/A => 
  - warning: vmlinux.o(.devinit.text+0xa607): Section mismatch in reference from the function cnb20le_res() to the function .init.text:acpi_os_get_root_pointer(): N/A => 
  - warning: vmlinux.o(.text+0x123590): Section mismatch in reference from the function .kvm_rma_init() to the function .init.text:.__alloc_bootmem(): N/A => 
  - warning: vmlinux.o(.text+0x1235d0): Section mismatch in reference from the function .kvm_rma_init() to the function .init.text:.__alloc_bootmem(): N/A => 
  - warning: vmlinux.o(.text+0x3056c): Section mismatch in reference from the function .early_setup_secondary() to the function .cpuinit.text:.early_init_mmu_secondary(): N/A => 
  - warning: vmlinux.o(.text+0x305cc): Section mismatch in reference from the function .early_setup_secondary() to the function .cpuinit.text:.early_init_mmu_secondary(): N/A => 
  - warning: vmlinux.o(.text+0x31bf38): Section mismatch in reference from the function kernel_tree_alloc() to the function .init.text:prom_early_alloc(): N/A => 
  - warning: vmlinux.o(.text+0x4a1b4): Section mismatch in reference from the function .prom_query_opal() to the function .init.text:.call_prom(): N/A => 
  - warning: vmlinux.o(.text+0x4a1dc): Section mismatch in reference from the function .prom_query_opal() to the function .init.text:.call_prom(): N/A => 
  - warning: vmlinux.o(.text+0x4a1f4): Section mismatch in reference from the function .prom_query_opal() to the function .init.text:.prom_printf(): N/A => 
  - warning: vmlinux.o(.text+0x4a238): Section mismatch in reference from the function .prom_query_opal() to the function .init.text:.prom_printf(): N/A => 
  - warning: vmlinux.o(.text+0x4a258): Section mismatch in reference from the function .prom_query_opal() to the function .init.text:.prom_printf(): N/A => 
  - warning: vmlinux.o(.text+0x4a530): Section mismatch in reference from the function .prom_opal_takeover() to the function .init.text:.prom_printf(): N/A => 
  - warning: vmlinux.o(.text+0x4a534): Section mismatch in reference from the function .prom_opal_takeover() to the function .init.text:.prom_close_stdin(): N/A => 
  - warning: vmlinux.o(.text+0x4b910): Section mismatch in reference from the function .prom_query_opal() to the function .init.text:.call_prom(): N/A => 
  - warning: vmlinux.o(.text+0x4b938): Section mismatch in reference from the function .prom_query_opal() to the function .init.text:.call_prom(): N/A => 
  - warning: vmlinux.o(.text+0x4b950): Section mismatch in reference from the function .prom_query_opal() to the function .init.text:.prom_printf(): N/A => 
  - warning: vmlinux.o(.text+0x4b994): Section mismatch in reference from the function .prom_query_opal() to the function .init.text:.prom_printf(): N/A => 
  - warning: vmlinux.o(.text+0x4b9b4): Section mismatch in reference from the function .prom_query_opal() to the function .init.text:.prom_printf(): N/A => 
  - warning: vmlinux.o(.text+0x4bc8c): Section mismatch in reference from the function .prom_opal_takeover() to the function .init.text:.prom_printf(): N/A => 
  - warning: vmlinux.o(.text+0x4bc90): Section mismatch in reference from the function .prom_opal_takeover() to the function .init.text:.prom_close_stdin(): N/A => 
  - warning: vmlinux.o(.text+0x531c0): Section mismatch in reference from the function .wake_offline_cpus() to the function .cpuinit.text:.cpu_up(): N/A => 
  - warning: vmlinux.o(.text+0x5491c): Section mismatch in reference from the function .wake_offline_cpus() to the function .cpuinit.text:.cpu_up(): N/A => 
  - warning: vmlinux.o(.text+0x6ba74): Section mismatch in reference from the function .of_get_lmb_size() to the function .devinit.text:.read_n_cells(): N/A => 
  - warning: vmlinux.o(.text+0x6bc30): Section mismatch in reference from the function .hot_add_drconf_scn_to_nid() to the function .devinit.text:.read_n_cells(): N/A => 
  - warning: vmlinux.o(.text+0x6be34): Section mismatch in reference from the function .mark_reserved_regions_for_nid() to the function .meminit.text:.early_pfn_to_nid(): N/A => 
  - warning: vmlinux.o(.text+0x6be5c): Section mismatch in reference from the function .mark_reserved_regions_for_nid() to the function .init.text:.work_with_active_regions(): N/A => 
  - warning: vmlinux.o(.text+0x6bf0c): Section mismatch in reference from the function .mark_reserved_regions_for_nid() to the function .init.text:.reserve_bootmem_node(): N/A => 
  - warning: vmlinux.o(.text+0x6bf3c): Section mismatch in reference from the function .mark_reserved_regions_for_nid() to the function .meminit.text:.early_pfn_to_nid(): N/A => 
  - warning: vmlinux.o(.text+0x6bf64): Section mismatch in reference from the function .mark_reserved_regions_for_nid() to the function .init.text:.work_with_active_regions(): N/A => 
  - warning: vmlinux.o(.text+0x6c2cc): Section mismatch in reference from the function .hot_add_node_scn_to_nid() to the function .devinit.text:.read_n_cells(): N/A => 
  - warning: vmlinux.o(.text+0x6c2e8): Section mismatch in reference from the function .hot_add_node_scn_to_nid() to the function .devinit.text:.read_n_cells(): N/A => 
  - warning: vmlinux.o(.text+0x6d1d4): Section mismatch in reference from the function .of_get_lmb_size() to the function .devinit.text:.read_n_cells(): N/A => 
  - warning: vmlinux.o(.text+0x6d390): Section mismatch in reference from the function .hot_add_drconf_scn_to_nid() to the function .devinit.text:.read_n_cells(): N/A => 
  - warning: vmlinux.o(.text+0x6d594): Section mismatch in reference from the function .mark_reserved_regions_for_nid() to the function .meminit.text:.early_pfn_to_nid(): N/A => 
  - warning: vmlinux.o(.text+0x6d5bc): Section mismatch in reference from the function .mark_reserved_regions_for_nid() to the function .init.text:.work_with_active_regions(): N/A => 
  - warning: vmlinux.o(.text+0x6d66c): Section mismatch in reference from the function .mark_reserved_regions_for_nid() to the function .init.text:.reserve_bootmem_node(): N/A => 
  - warning: vmlinux.o(.text+0x6d69c): Section mismatch in reference from the function .mark_reserved_regions_for_nid() to the function .meminit.text:.early_pfn_to_nid(): N/A => 
  - warning: vmlinux.o(.text+0x6d6c4): Section mismatch in reference from the function .mark_reserved_regions_for_nid() to the function .init.text:.work_with_active_regions(): N/A => 
  - warning: vmlinux.o(.text+0x6da2c): Section mismatch in reference from the function .hot_add_node_scn_to_nid() to the function .devinit.text:.read_n_cells(): N/A => 
  - warning: vmlinux.o(.text+0x6da48): Section mismatch in reference from the function .hot_add_node_scn_to_nid() to the function .devinit.text:.read_n_cells(): N/A => 
  - warning: vmlinux.o(.text+0x82914): Section mismatch in reference from the function .ics_rtas_init() to the function .init.text:.xics_register_ics(): N/A => 
  - warning: vmlinux.o(.text+0x85748): Section mismatch in reference from the function .ics_rtas_init() to the function .init.text:.xics_register_ics(): N/A => 
  - warning: vmlinux.o(.text+0x9bf1c): Section mismatch in reference from the function .pci_dn_reconfig_notifier() to the function .devinit.text:.update_dn_pci_info(): N/A => 
  - warning: vmlinux.o(.text+0x9ed9c): Section mismatch in reference from the function .pci_dn_reconfig_notifier() to the function .devinit.text:.update_dn_pci_info(): N/A => 
  - warning: vmlinux.o(.text+0xa0ecc): Section mismatch in reference from the function .dlpar_online_cpu() to the function .cpuinit.text:.cpu_up(): N/A => 
  - warning: vmlinux.o(.text+0xa3d4c): Section mismatch in reference from the function .dlpar_online_cpu() to the function .cpuinit.text:.cpu_up(): N/A => 
  - warning: vmlinux.o(.text+0xa86f8): Section mismatch in reference from the function .pcibios_add_pci_devices() to the function .devinit.text:.of_rescan_bus(): N/A => 
  - warning: vmlinux.o(.text+0xa8784): Section mismatch in reference from the function .pcibios_add_pci_devices() to the function .devinit.text:.pcibios_setup_bus_devices(): N/A => 
  - warning: vmlinux.o(.text+0xa87e8): Section mismatch in reference from the function .pcibios_add_pci_devices() to the function .devinit.text:.pci_scan_bridge(): N/A => 
  - warning: vmlinux.o(.text+0xabaa4): Section mismatch in reference from the function .pcibios_add_pci_devices() to the function .devinit.text:.of_rescan_bus(): N/A => 
  - warning: vmlinux.o(.text+0xabb30): Section mismatch in reference from the function .pcibios_add_pci_devices() to the function .devinit.text:.pcibios_setup_bus_devices(): N/A => 
  - warning: vmlinux.o(.text+0xabb94): Section mismatch in reference from the function .pcibios_add_pci_devices() to the function .devinit.text:.pci_scan_bridge(): N/A => 
  - warning: vmlinux.o(.text+0xad38e): Section mismatch in reference from the variable system_reset_iSeries to the variable .init.data:boot_paca: N/A => 
  - warning: vmlinux.o(.text+0xb2fc2): Section mismatch in reference from the variable system_reset_iSeries to the variable .init.data:boot_paca: N/A => 
  - warning: vmlinux.o(.text+0xdb39c): Section mismatch in reference from the function .ps3_smp_probe() to the function .init.text:.ps3_register_ipi_irq(): N/A => 
  - warning: vmlinux.o(.text+0xdb3dc): Section mismatch in reference from the function .ps3_smp_probe() to the function .init.text:.ps3_register_ipi_debug_brk(): N/A => 
  - warning: vmlinux.o(.text+0xecc64): Section mismatch in reference from the function .kvm_rma_init() to the function .init.text:.__alloc_bootmem(): N/A => 
  - warning: vmlinux.o(.text+0xecca4): Section mismatch in reference from the function .kvm_rma_init() to the function .init.text:.__alloc_bootmem(): N/A => 
  - warning: vmlinux.o(.text+0xfd824): Section mismatch in reference from the function .ps3_smp_probe() to the function .init.text:.ps3_register_ipi_irq(): N/A => 
  - warning: vmlinux.o(.text+0xfd864): Section mismatch in reference from the function .ps3_smp_probe() to the function .init.text:.ps3_register_ipi_debug_brk(): N/A => 

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
