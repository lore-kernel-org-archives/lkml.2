Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754770Ab0JGTha (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 15:37:30 -0400
Received: from gerard.telenet-ops.be ([195.130.132.48]:44443 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753165Ab0JGTh1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 15:37:27 -0400
X-Greylist: delayed 301 seconds by postgrey-1.27 at vger.kernel.org; Thu, 07 Oct 2010 15:37:26 EDT
Date: Thu, 7 Oct 2010 21:32:22 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Build regressions/improvements in v2.6.36-rc7
Message-ID: <alpine.DEB.2.00.1010072128070.28349@ayla.of.borg>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-7
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Below is the list of build error/warning regressions/improvements in
v2.6.36-rc7 compared to v2.6.35.
Summarized:
  - build errors: +70/-47
  - build warnings: +189/-218

JFYI, when comparing v2.6.36-rc7 to v2.6.36-rc6, the summaries are:
 - build errors: +6/-58
 - build warnings: +52/-80

In addition, I put the verbose summary at
http://www.kernel.org/pub/linux/kernel/people/geert/linux-log/v2.6.36-rc7.summary.gz
so you can easily find out for which configs and architectures the
errors/warnings you're interested in are happening.

Happy fixing! ;-)

Thanks to the linux-next team for providing the build service.

*** ERRORS ***

70 regressions:
	arch/avr32/include/asm/syscalls.h: error: previous declaration of ¡sys_execve¢ was here:  => 25
	arch/avr32/kernel/process.c: error: conflicting types for ¡sys_execve¢:  => 390
	arch/cris/arch-v10/drivers/sync_serial.c: error: 'ret' undeclared (first use in this function):  => 626
	arch/cris/arch-v10/drivers/sync_serial.c: error: (Each undeclared identifier is reported only once:  => 626
	arch/cris/arch-v10/drivers/sync_serial.c: error: conflicting types for 'sync_serial_ioctl':  => 959
	arch/cris/arch-v10/drivers/sync_serial.c: error: for each function it appears in.):  => 626
	arch/cris/arch-v10/drivers/sync_serial.c: error: previous declaration of 'sync_serial_ioctl' was here:  => 160
	arch/cris/arch-v10/kernel/kgdb.c: error: expected string literal before '.' token:  => 1274
	arch/cris/arch-v10/kernel/kgdb.c: error: missing terminating " character:  => 1457, 1273, 1359, 1370
	arch/sh/include/asm/syscalls_32.h: error: previous declaration of 'sys_execve' was here:  => 22
	arch/sh/kernel/process_32.c: error: conflicting types for 'sys_execve':  => 299
	drivers/block/hd.c: error: implicit declaration of function 'inb_p':  => 257
	drivers/block/hd.c: error: implicit declaration of function 'outb_p':  => 298
	drivers/block/paride/bpck.c: error: invalid operands to binary & (have 'void *' and 'int'):  => 56, 62
	drivers/block/paride/kbic.c: error: invalid operands to binary | (have 'void *' and 'int'):  => 67, 85, 53, 57, 61, 91
	drivers/char/ipmi/ipmi_si_intf.c: error: invalid operands to binary << (have 'void *' and 'int'):  => 1381, 1396
	drivers/char/specialix.c: error: invalid operands to binary | (have 'void *' and 'int'):  => 238, 228
	drivers/char/tpm/tpm.h: error: invalid operands to binary & (have 'void *' and 'int'):  => 125
	drivers/char/tpm/tpm_tis.c: error: implicit declaration of function 'ioread32':  => 392
	drivers/char/tpm/tpm_tis.c: error: implicit declaration of function 'ioread8':  => 83
	drivers/char/tpm/tpm_tis.c: error: implicit declaration of function 'iowrite32':  => 401
	drivers/char/tpm/tpm_tis.c: error: implicit declaration of function 'iowrite8':  => 96
	drivers/i2c/busses/i2c-ocores.c: error: implicit declaration of function 'ioread8':  => 74
	drivers/i2c/busses/i2c-ocores.c: error: implicit declaration of function 'iowrite8':  => 69
	drivers/input/gameport/lightning.c: error: invalid operands to binary & (have 'void *' and 'int'):  => 177, 141, 86
	drivers/input/gameport/ns558.c: error: invalid operands to binary & (have 'void *' and 'int'):  => 84
	drivers/input/touchscreen/mk712.c: error: invalid operands to binary | (have 'void *' and 'int'):  => 129
	drivers/net/3c59x.c: error: request for member 'current_state' in something not a structure or union:  => 3211
	error: No rule to make target include/config/auto.conf:  => N/A
	fs/9p/vfs_inode.c: error: implicit declaration of function 'inode_setattr':  => 1267
	fs/ceph/mds_client.c: error: insn does not satisfy its constraints::  => 3192
	fs/nfs/nfsroot.c: error: __setup_str_nfs_root_setup causes a section type conflict:  => 403
	fs/ntfs/file.c: error: insn does not satisfy its constraints::  => 2069
	include/linux/kprobes.h: error: dereferencing pointer to incomplete type:  => 316
	include/linux/vgaarb.h: error: asm/vga.h: No such file or directory:  => 34:21
	init/Kconfig: error: recursive dependency detected!:  => 985
	kernel/trace/trace_clock.c: error: implicit declaration of function 'raw_local_irq_restore':  => 112
	kernel/trace/trace_clock.c: error: implicit declaration of function 'raw_local_irq_save':  => 86
	lib/atomic64_test.c: error: 'atomic64_t' undeclared (first use in this function):  => 24
	lib/atomic64_test.c: error: 'v' undeclared (first use in this function):  => 26
	lib/atomic64_test.c: error: (Each undeclared identifier is reported only once:  => 24
	lib/atomic64_test.c: error: expected ';' before 'v':  => 24
	lib/atomic64_test.c: error: for each function it appears in.):  => 24
	lib/atomic64_test.c: error: implicit declaration of function 'atomic64_add':  => 34
	lib/atomic64_test.c: error: implicit declaration of function 'atomic64_add_return':  => 45
	lib/atomic64_test.c: error: implicit declaration of function 'atomic64_add_unless':  => 108
	lib/atomic64_test.c: error: implicit declaration of function 'atomic64_cmpxchg':  => 99
	lib/atomic64_test.c: error: implicit declaration of function 'atomic64_dec':  => 84
	lib/atomic64_test.c: error: implicit declaration of function 'atomic64_dec_return':  => 90
	lib/atomic64_test.c: error: implicit declaration of function 'atomic64_inc':  => 74
	lib/atomic64_test.c: error: implicit declaration of function 'atomic64_inc_not_zero':  => 135
	lib/atomic64_test.c: error: implicit declaration of function 'atomic64_inc_return':  => 80
	lib/atomic64_test.c: error: implicit declaration of function 'atomic64_read':  => 31
	lib/atomic64_test.c: error: implicit declaration of function 'atomic64_set':  => 28
	lib/atomic64_test.c: error: implicit declaration of function 'atomic64_sub':  => 54
	lib/atomic64_test.c: error: implicit declaration of function 'atomic64_sub_return':  => 65
	lib/atomic64_test.c: error: implicit declaration of function 'atomic64_xchg':  => 94
	mm/memcontrol.c: error: implicit declaration of function 'is_swap_pte':  => 4016
	mm/memcontrol.c: error: implicit declaration of function 'mem_cgroup_do_precharge':  => 4118
	mm/memcontrol.c: error: previous definition of 'mem_cgroup_can_attach' was here:  => 3954
	mm/memcontrol.c: error: previous definition of 'mem_cgroup_cancel_attach' was here:  => 3961
	mm/memcontrol.c: error: previous definition of 'mem_cgroup_move_task' was here:  => 3968
	mm/memcontrol.c: error: redefinition of 'mem_cgroup_can_attach':  => 4165
	mm/memcontrol.c: error: redefinition of 'mem_cgroup_cancel_attach':  => 4206
	mm/memcontrol.c: error: redefinition of 'mem_cgroup_move_task':  => 4314
	net/mac80211/led.c: error: dereferencing pointer to incomplete type:  => 74, 85, 63, 96
	net/mac80211/led.c: error: implicit declaration of function 'led_trigger_register':  => 64
	net/mac80211/led.c: error: implicit declaration of function 'led_trigger_unregister':  => 107
	net/mac80211/led.c: error: invalid application of 'sizeof' to incomplete type 'struct led_trigger' :  => 92, 81, 59, 70
	net/rds/rdma.c: error: insn does not satisfy its constraints::  => 647

47 improvements:
	arch/alpha/kernel/pci-sysfs.c: error: passing argument 1 of 'pci_mmap_resource' from incompatible pointer type: 98, 105 => 
	arch/alpha/kernel/pci-sysfs.c: error: passing argument 2 of 'pci_mmap_resource' from incompatible pointer type: 98, 105 => 
	arch/alpha/kernel/pci-sysfs.c: error: passing argument 3 of 'pci_mmap_resource' from incompatible pointer type: 98, 105 => 
	arch/alpha/kernel/pci-sysfs.c: error: passing argument 4 of 'pci_mmap_resource' makes pointer from integer without a cast: 98 => 
	arch/alpha/kernel/pci-sysfs.c: error: too few arguments to function 'pci_mmap_resource': 98, 105 => 
	arch/powerpc/kernel/crash_dump.c: error: comparison of distinct pointer types lacks a cast: 131 => 
	arch/powerpc/sysdev/fsl_rio.c: error: 'MCSR_BUS_RBERR' undeclared (first use in this function): 250 => 
	arch/powerpc/sysdev/fsl_rio.c: error: 'MCSR_MASK' undeclared (first use in this function): 248 => 
	arch/powerpc/sysdev/fsl_rio.c: error: (Each undeclared identifier is reported only once: 248 => 
	arch/powerpc/sysdev/fsl_rio.c: error: for each function it appears in.): 248 => 
	arch/sparc/include/asm/uaccess_64.h: error: call to 'copy_from_user_overflow' declared with attribute error: copy_from_user() buffer size is not provably correct: 232 => 
	arch/xtensa/include/asm/pgalloc.h: error: implicit declaration of function 'kmem_cache_alloc': 47 => 
	arch/xtensa/include/asm/pgalloc.h: error: implicit declaration of function 'kmem_cache_free': 62 => 
	drivers/gpio/gpiolib.c: error: 'ARCH_NR_GPIOS' undeclared here (not in a function): 68 => 
	drivers/gpio/gpiolib.c: error: 'GPIOF_DIR_IN' undeclared (first use in this function): 1261 => 
	drivers/gpio/gpiolib.c: error: 'GPIOF_INIT_HIGH' undeclared (first use in this function): 1265 => 
	drivers/gpio/gpiolib.c: error: (Each undeclared identifier is reported only once: 1261 => 
	drivers/gpio/gpiolib.c: error: arithmetic on pointer to an incomplete type: 1302, 1289, 1280 => 
	drivers/gpio/gpiolib.c: error: decrement of pointer to unknown structure: 1289 => 
	drivers/gpio/gpiolib.c: error: dereferencing pointer to incomplete type: 1588, 743, 1720, 1428, 1410, 942, 1481, 1637, 943, 1375, 598, 1532, 1423, 1360, 1721, 1013, 1188, 986, 1138, 1413, 1289, 1232, 744, 1531, 1370, 1072, 1604, 1550, 1081, 1614, 1624, 1184, 1233, 750, 1628, 1191, 949, 1077, 1636, 1063, 1483, 1088, 1097, 144, 1281, 100, 1110, 979, 1412, 957, 1230, 589, 749, 1384, 1357, 1471, 1172, 1468, 112, 1321, 1470, 1131, 1570, 1196, 104, 1713, 962, 1373, 1707, 755, 1302, 1359, 1714, 607, 1551, 1237, 1715, 1437, 1426, 1061, 1708 => 
	drivers/gpio/gpiolib.c: error: for each function it appears in.): 1261 => 
	drivers/gpio/gpiolib.c: error: increment of pointer to unknown structure: 1302, 1280 => 
	drivers/gpio/gpiolib.c: error: redefinition of 'gpio_direction_input': 1346 => 
	drivers/gpio/gpiolib.c: error: redefinition of 'gpio_direction_output': 1399 => 
	drivers/gpio/gpiolib.c: error: redefinition of 'gpio_export': 721 => 
	drivers/gpio/gpiolib.c: error: redefinition of 'gpio_export_link': 807 => 
	drivers/gpio/gpiolib.c: error: redefinition of 'gpio_free': 1211 => 
	drivers/gpio/gpiolib.c: error: redefinition of 'gpio_get_value_cansleep': 1599 => 
	drivers/gpio/gpiolib.c: error: redefinition of 'gpio_request': 1157 => 
	drivers/gpio/gpiolib.c: error: redefinition of 'gpio_set_debounce': 1457 => 
	drivers/gpio/gpiolib.c: error: redefinition of 'gpio_set_value_cansleep': 1609 => 
	drivers/gpio/gpiolib.c: error: redefinition of 'gpio_sysfs_set_active_low': 854 => 
	drivers/gpio/gpiolib.c: error: redefinition of 'gpio_unexport': 894 => 
	error: vga16fb.c: undefined reference to `vgacon_remap_base': .devinit.text+0x1a8fa), .devinit.text+0x1a8fe) => 
	include/linux/bio.h: error: #error "You should define ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE for your platform": 396:3 => 
	include/linux/blkdev.h: error: #error "You should define ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE for your platform": 762:3 => 
	include/linux/gpio.h: error: previous definition of 'gpio_direction_input' was here: 45 => 
	include/linux/gpio.h: error: previous definition of 'gpio_direction_output' was here: 50 => 
	include/linux/gpio.h: error: previous definition of 'gpio_export' was here: 93 => 
	include/linux/gpio.h: error: previous definition of 'gpio_export_link' was here: 101 => 
	include/linux/gpio.h: error: previous definition of 'gpio_free' was here: 37 => 
	include/linux/gpio.h: error: previous definition of 'gpio_get_value_cansleep' was here: 80 => 
	include/linux/gpio.h: error: previous definition of 'gpio_request' was here: 32 => 
	include/linux/gpio.h: error: previous definition of 'gpio_set_debounce' was here: 55 => 
	include/linux/gpio.h: error: previous definition of 'gpio_set_value_cansleep' was here: 87 => 
	include/linux/gpio.h: error: previous definition of 'gpio_sysfs_set_active_low' was here: 108 => 
	include/linux/gpio.h: error: previous definition of 'gpio_unexport' was here: 115 => 


*** WARNINGS ***

189 regressions:
	.config: warning: override: PCI_GOANY changes choice state:  => 402
	<stdin>: warning: #warning syscall dup3 not implemented: 1495:2 => 1494:2, 1495:2
	<stdin>: warning: #warning syscall epoll_create1 not implemented: 1491:2 => 1490:2, 1491:2
	<stdin>: warning: #warning syscall eventfd2 not implemented: 1487:2 => 1486:2, 1487:2
	<stdin>: warning: #warning syscall fallocate not implemented: 1471:2 => 1470:2, 1471:2
	<stdin>: warning: #warning syscall fanotify_init not implemented:  => 1526:2
	<stdin>: warning: #warning syscall fanotify_mark not implemented:  => 1530:2
	<stdin>: warning: #warning syscall inotify_init1 not implemented: 1503:2 => 1503:2, 1502:2
	<stdin>: warning: #warning syscall perf_event_open not implemented: 1519:2 => 1518:2, 1519:2
	<stdin>: warning: #warning syscall pipe2 not implemented: 1499:2 => 1499:2, 1498:2
	<stdin>: warning: #warning syscall pread64 not implemented: 907:2 => 906:2, 907:2
	<stdin>: warning: #warning syscall preadv not implemented: 1507:2 => 1507:2, 1506:2
	<stdin>: warning: #warning syscall prlimit64 not implemented:  => 1534:2
	<stdin>: warning: #warning syscall pwrite64 not implemented: 911:2 => 910:2, 911:2
	<stdin>: warning: #warning syscall pwritev not implemented: 1511:2 => 1511:2, 1510:2
	<stdin>: warning: #warning syscall recvmmsg not implemented: 1523:2 => 1523:2, 1522:2
	<stdin>: warning: #warning syscall rt_tgsigqueueinfo not implemented: 1515:2 => 1515:2, 1514:2
	<stdin>: warning: #warning syscall signalfd4 not implemented: 1483:2 => 1483:2, 1482:2
	<stdin>: warning: #warning syscall sync_file_range not implemented: 1431:2 => 1431:2, 1430:2
	<stdin>: warning: #warning syscall timerfd_create not implemented: 1463:2 => 1462:2, 1463:2
	<stdin>: warning: #warning syscall timerfd_gettime not implemented: 1479:2 => 1478:2, 1479:2
	<stdin>: warning: #warning syscall timerfd_settime not implemented: 1475:2 => 1474:2, 1475:2
	<stdin>: warning: #warning syscall umount2 not implemented: 395:2 => 394:2, 395:2
	arch/cris/arch-v10/drivers/sync_serial.c: warning: initialization from incompatible pointer type:  => 251
	arch/cris/arch-v10/drivers/sync_serial.c: warning: passing argument 1 of 'memcpy' discards qualifiers from pointer target type:  => 1341, 1351
	arch/cris/arch-v10/drivers/sync_serial.c: warning: passing argument 1 of 'virt_to_phys' discards qualifiers from pointer target type:  => 1222
	arch/cris/arch-v10/kernel/kgdb.c: warning: missing terminating " character:  => 1359:1, 1273:6, 1457:1, 1370:6
	arch/cris/arch-v10/kernel/kgdb.c: warning: type defaults to 'int' in declaration of 'write_stack_register':  => 267
	arch/cris/mm/fault.c: warning: ISO C90 forbids mixed declarations and code:  => 205
	arch/mips/sibyte/bcm1480/smp.c: warning: passing argument 1 of '__cpus_clear' discards qualifiers from pointer target type:  => 149
	arch/powerpc/platforms/iseries/htab.c: warning: division by zero:  => 249
	arch/x86/include/asm/mrst.h: warning: 'mrst_identify_cpu' defined but not used:  => 29
	arch/x86/include/asm/uaccess_32.h: warning: call to 'copy_from_user_overflow' declared with attribute warning: copy_from_user() buffer size is not provably correct:  => 212
	arch/xtensa/kernel/entry.S: Warning: value 0xffffffff30000000 truncated to 0x30000000: 1544 => 1544, 1545
	block/blk-merge.c: warning: 'bbio' may be used uninitialized in this function:  => 18
	drivers/acpi/acpica/exprep.c: warning: 'byte_alignment' may be used uninitialized in this function:  => 323
	drivers/acpi/scan.c: warning: 'type' may be used uninitialized in this function:  => 1349
	drivers/atm/nicstar.c: warning: 'err' may be used uninitialized in this function:  => 956
	drivers/base/power/main.c: warning: comparison of distinct pointer types lacks a cast: 413 => 414, 415
	drivers/block/hd.c: warning: statement with no effect:  => 468
	drivers/block/z2ram.c: warning: format '%lu' expects type 'long unsigned int', but argument 2 has type 'sector_t': 82 => 83, 82
	drivers/char/n_gsm.c: warning: ignoring return value of '__kfifo_must_check_helper', declared with attribute warn_unused_result:  => 1580
	drivers/char/rocket.c: warning: 'rmSpeakerReset' defined but not used: 3152, 3153 => 3163, 3162, 3164
	drivers/char/rocket.c: warning: 'rocket_pci_ids' defined but not used: 1756 => 1756, 1767
	drivers/char/rocket.c: warning: 'sPCIInitController' defined but not used: 2611, 2616 => 2621, 2627, 2622
	drivers/char/tpm/tpm.c: warning: format '%zd' expects type 'signed size_t', but argument 3 has type 'ssize_t':  => 390, 423
	drivers/char/tty_buffer.c: warning: comparison of distinct pointer types lacks a cast:  => 251, 288
	drivers/gpu/drm/drm_context.c: warning: passing argument 2 of '__constant_test_and_set_bit' discards qualifiers from pointer target type:  => 233
	drivers/gpu/drm/drm_context.c: warning: passing argument 2 of '__generic_test_and_set_bit' discards qualifiers from pointer target type:  => 233
	drivers/gpu/drm/drm_pci.c: warning: passing argument 1 of 'virt_to_phys' makes pointer from integer without a cast:  => 109, 84
	drivers/gpu/drm/drm_vm.c: warning: passing argument 1 of 'virt_to_phys' makes pointer from integer without a cast:  => 308
	drivers/gpu/drm/radeon/radeon_gart.c: warning: passing argument 3 of 'pci_free_consistent' discards qualifiers from pointer target type:  => 69
	drivers/i2c/busses/i2c-cpm.c: warning: passing argument 3 of 'dma_alloc_coherent' from incompatible pointer type:  => 536, 543
	drivers/ide/ide-io-std.c: warning: statement with no effect:  => 200, 185
	drivers/infiniband/core/uverbs_main.c: warning: the address of 'uverbs_event_fops' will always evaluate as 'true': 523 => 526, 537
	drivers/infiniband/hw/cxgb4/cm.c: warning: cast to pointer from integer of different size:  => 2326
	drivers/infiniband/hw/cxgb4/cq.c: warning: cast from pointer to integer of different size:  => 58, 135
	drivers/infiniband/hw/cxgb4/mem.c: warning: cast from pointer to integer of different size:  => 74
	drivers/infiniband/hw/cxgb4/qp.c: warning: cast from pointer to integer of different size:  => 147, 1063, 988
	drivers/input/misc/hp_sdc_rtc.c: warning: 'hp_sdc_rtc_set_fhs' defined but not used: 319 => 319, 320
	drivers/input/misc/hp_sdc_rtc.c: warning: 'hp_sdc_rtc_set_i8042timer' defined but not used: 359 => 360, 359
	drivers/input/misc/hp_sdc_rtc.c: warning: 'hp_sdc_rtc_set_rt' defined but not used: 279 => 280, 279
	drivers/isdn/hardware/mISDN/mISDNipac.c: warning: unsupported argument to '__builtin_return_address':  => 754
	drivers/isdn/hardware/mISDN/netjet.c: warning: comparison is always false due to limited range of data type:  => 318
	drivers/isdn/hardware/mISDN/w6692.c: warning: unsupported argument to '__builtin_return_address':  => 1188
	drivers/media/dvb/frontends/dib3000mc.c: warning: the frame size of 2208 bytes is larger than 2048 bytes:  => 853
	drivers/media/dvb/frontends/dib7000p.c: warning: the frame size of 2288 bytes is larger than 2048 bytes:  => 1367
	drivers/media/dvb/ngene/ngene-core.c: warning: unused variable 'flags':  => 1308
	drivers/media/video/sh_mobile_ceu_camera.c: warning: 'sd' is used uninitialized in this function:  => 1245
	drivers/media/video/sh_mobile_ceu_camera.c: warning: 'sd' may be used uninitialized in this function:  => 1707, 1683, 943
	drivers/media/video/sh_mobile_ceu_camera.c: warning: unused variable 'sd':  => 1648
	drivers/message/fusion/mptsas.c: warning: unused variable 'log_info':  => 5010
	drivers/mtd/devices/doc2001plus.c: warning: passing argument 2 of 'MemWriteDOC' discards qualifiers from pointer target type:  => 767
	drivers/mtd/devices/docprobe.c: warning: #warning Unknown architecture for DiskOnChip. No default probe locations defined: 80:2 => 80:2, 79:2
	drivers/mtd/ftl.c: warning: passing argument 4 of 'part->mbd.mtd->read' from incompatible pointer type:  => 527, 294, 228, 490
	drivers/mtd/ftl.c: warning: passing argument 4 of 'part->mbd.mtd->write' from incompatible pointer type:  => 564, 535, 426, 507, 442, 555
	drivers/mtd/nand/alauda.c: warning: passing argument 3 of 'alauda_write_page' discards qualifiers from pointer target type:  => 480
	drivers/net/3c59x.c: warning: dereferencing 'void *' pointer:  => 3211
	drivers/net/pcmcia/ibmtr_cs.c: warning: 'pcmcia_request_exclusive_irq' is deprecated (declared at /scratch/kisskb/src/include/pcmcia/ds.h:200):  => 235
	drivers/net/pcmcia/ibmtr_cs.c: warning: 'pcmcia_request_exclusive_irq' is deprecated (declared at /scratch/kisskb/src/include/pcmcia/ds.h:202):  => 235
	drivers/net/pcmcia/nmclan_cs.c: warning: 'pcmcia_request_exclusive_irq' is deprecated (declared at /scratch/kisskb/src/include/pcmcia/ds.h:200):  => 650
	drivers/net/pcmcia/nmclan_cs.c: warning: 'pcmcia_request_exclusive_irq' is deprecated (declared at /scratch/kisskb/src/include/pcmcia/ds.h:202):  => 650
	drivers/net/pcmcia/smc91c92_cs.c: warning: 'j' may be used uninitialized in this function:  => 846
	drivers/net/smc91x.c: warning: cast from pointer to integer of different size:  => 1913
	drivers/net/tehuti.c: warning: passing argument 2 of 'bdx_tx_push_desc_safe' discards qualifiers from pointer target type:  => 330
	drivers/net/tlan.c: warning: label 'err_out' defined but not used:  => 685
	drivers/net/wireless/iwmc3200wifi/rx.c: warning: comparison is always true due to limited range of data type:  => 1198
	drivers/net/wireless/libertas/cfg.c: warning: passing argument 3 of 'lbs_deb_hex' discards qualifiers from pointer target type:  => 273
	drivers/net/wireless/mwl8k.c: warning: 'ap_legacy_rates' may be used uninitialized in this function:  => 3403
	drivers/net/wireless/p54/p54usb.c: warning: 'p54u_device_reset' defined but not used:  => 407
	drivers/parisc/led.c: warning: assignment from incompatible pointer type:  => 366
	drivers/pci/pcie/portdrv_core.c: warning: 'cap_mask' may be used uninitialized in this function:  => 241
	drivers/pcmcia/cs.c: warning: 'pcmcia_socket_dev_resume' defined but not used: 896 => 849, 848
	drivers/power/ds2782_battery.c: warning: 'raw' may be used uninitialized in this function:  => 159, 199
	drivers/power/ds2782_battery.c: warning: 'sense_res_raw' may be used uninitialized in this function:  => 115
	drivers/scsi/aic7xxx_old.c: warning: passing argument 3 of 'pci_free_consistent' discards qualifiers from pointer target type:  => 8490
	drivers/scsi/constants.c: warning: zero-length printf format string:  => 1407, 1413, 1456
	drivers/scsi/hpsa.c: warning: 'cp' may be used uninitialized in this function:  => 2335, 2299
	drivers/scsi/mpt2sas/mpt2sas_ctl.c: warning: '_ctl_sas_device_find_by_handle' defined but not used:  => 94
	drivers/scsi/mpt2sas/mpt2sas_scsih.c: warning: unused variable 'mpi_reply':  => 2718
	drivers/scsi/pmcraid.c: warning: passing argument 2 of 'access_ok' makes pointer from integer without a cast:  => 3800
	drivers/scsi/sd.c: warning: zero-length printf format string:  => 2630, 2636, 2628
	drivers/scsi/stex.c: warning: passing argument 2 of 'scsi_sg_copy_from_buffer' discards qualifiers from pointer target type:  => 636
	drivers/serial/mfd.c: warning: 'serial_hsu_remove' defined but not used:  => 1436
	drivers/uio/uio.c: warning: passing argument 1 of 'virt_to_phys' makes pointer from integer without a cast:  => 654
	drivers/usb/early/ehci-dbgp.c: warning: 'bus' may be used uninitialized in this function:  => 835
	drivers/usb/early/ehci-dbgp.c: warning: 'func' may be used uninitialized in this function:  => 835
	drivers/usb/early/ehci-dbgp.c: warning: 'slot' may be used uninitialized in this function:  => 835
	drivers/usb/gadget/dbgp.c: warning: comparison is always true due to limited range of data type:  => 389
	drivers/usb/gadget/storage_common.c: warning: 'fsg_show_nofua' defined but not used:  => 718, 720
	drivers/usb/gadget/storage_common.c: warning: 'fsg_store_nofua' defined but not used:  => 782, 785
	drivers/usb/host/ehci-lpm.c: warning: 'ehci_lpm_check' defined but not used:  => 40
	drivers/usb/host/ehci-lpm.c: warning: 'ehci_lpm_set_da' defined but not used:  => 20
	drivers/usb/host/xhci-ring.c: warning: 'event_trb' may be used uninitialized in this function:  => 1719
	drivers/usb/serial/mos7720.c: warning: 'status' may be used uninitialized in this function:  => 1385, 1347
	drivers/video/metronomefb.c: warning: passing argument 1 of 'load_waveform' discards qualifiers from pointer target type:  => 687
	drivers/w1/masters/ds2490.c: warning: passing argument 2 of 'ds_write_block' discards qualifiers from pointer target type:  => 827
	fs/9p/xattr.c: warning: format '%zd' expects type 'signed size_t', but argument 3 has type 'ssize_t':  => 52
	fs/9p/xattr.c: warning: format '%zd' expects type 'signed size_t', but argument 4 has type 'ssize_t':  => 52
	fs/autofs/root.c: warning: 'autofs_root_compat_ioctl' declared 'static' but never defined:  => 30
	fs/autofs4/root.c: warning: 'autofs4_root_compat_ioctl' declared 'static' but never defined:  => 31
	fs/fuse/dev.c: warning: ¡total_len¢ may be used uninitialized in this function:  => 1357
	fs/locks.c: warning: 'lock' may be used uninitialized in this function:  => 1572
	fs/nfs/file.c: warning: unused variable 'count':  => 233
	fs/nfs/file.c: warning: unused variable 'dentry':  => 139
	fs/nfsd/nfs4state.c: warning: control reaches end of non-void function:  => 452
	fs/notify/fanotify/fanotify.c: warning: 'marks_ignored_mask' may be used uninitialized in this function:  => 162
	fs/notify/fanotify/fanotify.c: warning: 'marks_mask' may be used uninitialized in this function:  => 162
	fs/ocfs2/ioctl.c: warning: 'flags' may be used uninitialized in this function:  => 115
	fs/ocfs2/refcounttree.c: warning: 'ref_blkno' may be used uninitialized in this function:  => 2301
	fs/ocfs2/xattr.c: warning: 'ret' may be used uninitialized in this function:  => 2940
	fs/xfs/linux-2.6/./xfs_trace.h: warning: format '%llx' expects type 'long long unsigned int', but argument 22 has type 'xfs_fsblock_t':  => 1349
	include/linux/sysv_fs.h: warning: 'packed' attribute ignored for field of type '__fs32'  CC [M]  fs/xfs/quota/xfs_qm.o:  => 30
	include/media/soc_camera.h: warning: 'dummy' is used uninitialized in this function:  => 278
	include/net/ipx.h: warning: 'packed' attribute ignored for field of type '__be16':  => 32, 30
	include/net/ipx.h: warning: 'packed' attribute ignored for field of type 'struct ipx_address':  => 42, 41
	kernel/module.c: warning: passing argument 2 of 'add_kallsyms' discards qualifiers from pointer target type:  => 2535
	kernel/pm_qos_params.c: warning: control may reach end of non-void function ¡pm_qos_get_value¢ being inlined:  => 200
	kernel/pm_qos_params.c: warning: control reaches end of non-void function:  => 132
	kernel/trace/trace_events.c: warning: enumeration value 'TRACE_REG_PERF_REGISTER' not handled in switch:  => 146
	kernel/trace/trace_events.c: warning: enumeration value 'TRACE_REG_PERF_UNREGISTER' not handled in switch:  => 146
	kernel/trace/trace_functions_graph.c: warning: comparison of distinct pointer types lacks a cast:  => 652
	kernel/watchdog.c: warning: 'watchdog_disable_all_cpus' defined but not used:  => 484
	kernel/watchdog.c: warning: 'watchdog_enable_all_cpus' defined but not used:  => 471
	lib/atomic64_test.c: warning: ISO C90 forbids mixed declarations and code:  => 25
	lib/radix-tree.c: warning: 'radix_tree_range_tag_if_tagged' uses dynamic stack allocation:  => 737
	mm/percpu.c: warning: 'pcpu_build_alloc_info' defined but not used:  => 1094
	mm/swapfile.c: warning: 'span' may be used uninitialized in this function:  => 1819
	modpost: WARNING: modpost: Found 13 section mismatch(es).:  => N/A
	modpost: WARNING: modpost: Found 65 section mismatch(es).:  => N/A
	net/ipv4/inet_connection_sock.c: warning: 'head' may be used uninitialized in this function:  => 95
	net/irda/irnet/irnet_ppp.c: warning: format '%Zd' expects type 'signed size_t', but argument 3 has type 'ssize_t':  => 332
	net/mac80211/tx.c: warning: unused variable 'mesh_hdr':  => 1702
	net/packet/af_packet.c: warning: 'hdrlen' may be used uninitialized in this function: 655 => 657, 648
	net/sunrpc/auth_gss/auth_gss.c: warning: format '%Zd' expects type 'signed size_t', but argument 2 has type 'ssize_t':  => 706
	net/sunrpc/auth_gss/auth_gss.c: warning: format '%zd' expects type 'signed size_t', but argument 3 has type 'ssize_t':  => 688
	net/sunrpc/rpcb_clnt.c: warning: unused variable 'task':  => 796, 747, 870, 838, 771
	net/sunrpc/svcauth_unix.c: warning: 'gids' may be used uninitialized in this function:  => 550
	security/apparmor/lsm.c: warning: initialization from incompatible pointer type:  => 663
	security/keys/keyctl.c: warning: #warning TIF_NOTIFY_RESUME not implemented: 1329:2 => 1346:2, 1342:2
	sound/pcmcia/pdaudiocf/pdaudiocf.c: warning: 'pcmcia_request_exclusive_irq' is deprecated (declared at /scratch/kisskb/src/include/pcmcia/ds.h:200):  => 226
	sound/pcmcia/pdaudiocf/pdaudiocf.c: warning: 'pcmcia_request_exclusive_irq' is deprecated (declared at /scratch/kisskb/src/include/pcmcia/ds.h:202):  => 226
	sound/pcmcia/vx/vxpocket.c: warning: 'pcmcia_request_exclusive_irq' is deprecated (declared at /scratch/kisskb/src/include/pcmcia/ds.h:200):  => 233
	sound/pcmcia/vx/vxpocket.c: warning: 'pcmcia_request_exclusive_irq' is deprecated (declared at /scratch/kisskb/src/include/pcmcia/ds.h:202):  => 233
	sound/usb/mixer.c: warning: unused variable 'chip':  => 762
	warning: (ACPI_HOTPLUG_CPU && ACPI && ACPI_PROCESSOR && HOTPLUG_CPU) selects ACPI_CONTAINER which has unmet direct dependencies (EXPERIMENTAL):  => N/A
	warning: (BATTERY_DS2760 && POWER_SUPPLY) selects W1 which has unmet direct dependencies (HAS_IOMEM):  => N/A
	warning: (COMPAT && SPARC64) selects COMPAT_BINFMT_ELF which has unmet direct dependencies (COMPAT && BINFMT_ELF):  => N/A
	warning: (COMPAT) selects COMPAT_BINFMT_ELF which has unmet direct dependencies (COMPAT && BINFMT_ELF):  => N/A
	warning: (CRYPTO_LRW && CRYPTO && EXPERIMENTAL || CRYPTO_XTS && CRYPTO && EXPERIMENTAL || CRYPTO_GHASH && CRYPTO) selects CRYPTO_GF128MUL which has unmet direct dependencies (EXPERIMENTAL):  => N/A
	warning: (EP8248E && PPC_82xx || MPC85xx_MDS && FSL_SOC_BOOKE || NET_DSA && NET && EXPERIMENTAL && NETDEVICES && !S390 || MACB && NETDEVICES && NET_ETHERNET && (AVR32 || ARCH_AT91SAM9260 || ARCH_AT91SAM9263 || ARCH_AT91SAM9G20 || ARCH_AT91SAM9G45 || ARCH_AT91CAP9) || IXP4XX_ETH && NETDEVICES && NET_ETHERNET && ARM && ARCH_IXP4XX && IXP4XX_NPE && IXP4XX_QMGR || W90P910_ETH && NETDEVICES && NET_ETHERNET && ARM && ARCH_W90X900 || MIPS_AU1X00_ENET && NETDEVICES && NET_ETHERNET && MIPS_ALCHEMY || SH_ETH && NETDEVICES && NET_ETHERNET && SUPERH && (CPU_SUBTYPE_SH7710 || CPU_SUBTYPE_SH7712 || CPU_SUBTYPE_SH7763 || CPU_SUBTYPE_SH7619 || CPU_SUBTYPE_SH7724 || CPU_SUBTYPE_SH7757) || BFIN_MAC && NETDEVICES && NET_ETHERNET && (BF516 || BF518 || BF526 || BF527 || BF536 || BF537) || PXA168_ETH && NETDEVICES && NET_ETHERNET && CPU_PXA168 || TI_DAVINCI_EMAC && NETDEVICES && NET_ETHERNET && ARM && (ARCH_DAVINCI || ARCH_OMAP3) || ETHOC && NETDEVICES && NET_ETHERNET && HAS_IOMEM && HAS_DMA || GRETH && NETDEVICES && NET_ETHERNET && SPARC || SMSC911X && NETDEVICES && NET_ETHERNET && (ARM || SUPERH || BLACKFIN || MIPS) || DNET && NETDEVICES && NET_ETHERNET && HAS_IOMEM || TC35815 && NETDEVICES && NET_ETHERNET && NET_PCI && PCI && MIPS || R6040 && NETDEVICES && NET_ETHERNET && NET_PCI && PCI || SMSC9420 && NETDEVICES && NET_ETHERNET && NET_PCI && PCI || CPMAC && NETDEVICES && NET_ETHERNET && EXPERIMENTAL && AR7 || FEC && NETDEVICES && NET_ETHERNET && (M523x || M527x || M5272 || M528x || M520x || M532x || MACH_MX27 || ARCH_MX35 || ARCH_MX25 || ARCH_MX5) || FEC_MPC52xx && NETDEVICES && NET_ETHERNET && PPC_MPC52xx && PPC_BESTCOMM || XILINX_EMACLITE && NETDEVICES && NET_ETHERNET && (PPC32 || MICROBLAZE) || BCM63XX_ENET && NETDEVICES && NET_ETHERNET && BCM63XX || FS_ENET && NETDEVICES && NET_ETHERNET && (CPM1 || CPM2 || PPC_MPC512x) || OCTEON_MGMT_ETHERNET && NETDEVICES && NET_ETHERNET && CPU_CAVIUM_OCTEON || SB1250_MAC && NETDEVICES && NETDEV_1000 && SIBYTE_SB1xxx_SOC || TIGON3 && NETDEVICES && NETDEV_1000 && PCI || FSL_PQ_MDIO &&!
  NETDEVICES && NETDEV_1000 && FSL_SOC || GIANFAR && NETDEVICES && NETDEV_1000 && FSL_SOC || UCC_GETH && NETDEVICES && NETDEV_1000 && QUICC_ENGINE || MV643XX_ETH && NETDEVICES && NETDEV_1000 && (MV64X60 || PPC32 || PLAT_ORION) || XILINX_LL_TEMAC && NETDEVICES && NETDEV_1000 && (PPC || MICROBLAZE) || S6GMAC && NETDEVICES && NETDEV_1000 && XTENSA_VARIANT_S6000 || STMMAC_ETH && NETDEV_1000 && NETDEVICES && CPU_SUBTYPE_ST40 || PASEMI_MAC && NETDEVICES && NETDEV_10000 && PPC_PASEMI && PCI || OCTEON_ETHERNET && STAGING && !STAGING_EXCLUDE_BUILD && CPU_CAVIUM_OCTEON && NETDEVICES) selects PHYLIB which has unmet direct dependencies (!S390 && NETDEVICES):  => N/A
	warning: (ETRAX_USB_HOST && ETRAX_ARCH_V10 || MOUSE_APPLETOUCH && !S390 && INPUT && INPUT_MOUSE && USB_ARCH_HAS_HCD || MOUSE_BCM5974 && !S390 && INPUT && INPUT_MOUSE && USB_ARCH_HAS_HCD || JOYSTICK_XPAD && !S390 && INPUT && INPUT_JOYSTICK && USB_ARCH_HAS_HCD || TABLET_USB_ACECAD && !S390 && INPUT && INPUT_TABLET && USB_ARCH_HAS_HCD || TABLET_USB_AIPTEK && !S390 && INPUT && INPUT_TABLET && USB_ARCH_HAS_HCD || TABLET_USB_KBTAB && !S390 && INPUT && INPUT_TABLET && USB_ARCH_HAS_HCD || TABLET_USB_WACOM && !S390 && INPUT && INPUT_TABLET && USB_ARCH_HAS_HCD || TOUCHSCREEN_USB_COMPOSITE && !S390 && INPUT && INPUT_TOUCHSCREEN && USB_ARCH_HAS_HCD || INPUT_ATI_REMOTE && !S390 && INPUT && INPUT_MISC && USB_ARCH_HAS_HCD || INPUT_ATI_REMOTE2 && !S390 && INPUT && INPUT_MISC && USB_ARCH_HAS_HCD || INPUT_KEYSPAN_REMOTE && !S390 && INPUT && INPUT_MISC && EXPERIMENTAL && USB_ARCH_HAS_HCD || INPUT_POWERMATE && !S390 && INPUT && INPUT_MISC && USB_ARCH_HAS_HCD || INPUT_YEALINK && !S390 && INPUT && INPUT_MISC && EXPERIMENTAL && USB_ARCH_HAS_HCD || INPUT_CM109 && !S390 && INPUT && INPUT_MISC && EXPERIMENTAL && USB_ARCH_HAS_HCD) selects USB which has unmet direct dependencies (USB_ARCH_HAS_HCD):  => N/A
	warning: (GFS2_FS && BLOCK && EXPERIMENTAL && (64BIT || LBDAF)) selects QUOTACTL which has unmet direct dependencies (XFS_QUOTA || QUOTA):  => N/A
	warning: (IMA && SECURITY && !S390) selects TCG_TPM which has unmet direct dependencies (HAS_IOMEM && EXPERIMENTAL):  => N/A
	warning: (IP_NF_TARGET_TTL && NET && INET && NETFILTER && IP_NF_IPTABLES && NETFILTER_ADVANCED || IP6_NF_TARGET_HL && NET && INET && IPV6 && NETFILTER && IP6_NF_IPTABLES && NETFILTER_ADVANCED) selects NETFILTER_XT_TARGET_HL which has unmet direct dependencies ((IP_NF_MANGLE || IP6_NF_MANGLE) && NETFILTER_ADVANCED):  => N/A
	warning: (IRQSOFF_TRACER && TRACING_SUPPORT && FTRACE && TRACE_IRQFLAGS_SUPPORT && !ARCH_USES_GETTIMEOFFSET) selects TRACE_IRQFLAGS which has unmet direct dependencies (DEBUG_KERNEL && TRACE_IRQFLAGS_SUPPORT && PROVE_LOCKING):  => N/A
	warning: (LOCKDEP && DEBUG_KERNEL && TRACE_IRQFLAGS_SUPPORT && STACKTRACE_SUPPORT && LOCKDEP_SUPPORT && !MIPS && !PPC && !ARM_UNWIND && !S390 && !MICROBLAZE || FAULT_INJECTION_STACKTRACE_FILTER && FAULT_INJECTION_DEBUG_FS && STACKTRACE_SUPPORT && !X86_64 && !PPC && !S390 && !MICROBLAZE || LATENCYTOP && HAVE_LATENCYTOP_SUPPORT && DEBUG_KERNEL && STACKTRACE_SUPPORT && PROC_FS && !MIPS && !PPC && !S390 && !MICROBLAZE || FUNCTION_TRACER && TRACING_SUPPORT && FTRACE && HAVE_FUNCTION_TRACER || KMEMCHECK && HAVE_ARCH_KMEMCHECK && DEBUG_KERNEL && !X86_USE_3DNOW && (SLUB || SLAB) && !CC_OPTIMIZE_FOR_SIZE && !FUNCTION_TRACER) selects FRAME_POINTER which has unmet direct dependencies (DEBUG_KERNEL && (CRIS || M68K || M68KNOMMU || FRV || UML || AVR32 || SUPERH || BLACKFIN || MN10300) || ARCH_WANT_FRAME_POINTERS):  => N/A
	warning: (PAGE_POISONING && DEBUG_KERNEL && !ARCH_SUPPORTS_DEBUG_PAGEALLOC && !HIBERNATION) selects DEBUG_PAGEALLOC which has unmet direct dependencies (DEBUG_KERNEL && ARCH_SUPPORTS_DEBUG_PAGEALLOC && (!HIBERNATION || !PPC && !SPARC) && !KMEMCHECK):  => N/A
	warning: (PCMCIA_LOAD_CIS && PCCARD && PCMCIA && EXPERIMENTAL || USB_IRDA && NET && IRDA && USB || BT_HCIBCM203X && NET && BT && USB || BT_HCIBFUSB && NET && BT && USB || BT_HCIBT3C && NET && BT && PCMCIA || BT_MRVL_SDIO && NET && BT && BT_MRVL && MMC || BT_ATH3K && NET && BT && BT_HCIBTUSB || IWMC3200TOP && MISC_DEVICES && MMC && EXPERIMENTAL || SCSI_AIC94XX && SCSI_LOWLEVEL && SCSI && PCI || SCSI_MVSAS && SCSI_LOWLEVEL && SCSI && PCI || SCSI_IPR && SCSI_LOWLEVEL && PCI && SCSI && ATA || SCSI_QLA_FC && SCSI_LOWLEVEL && PCI && SCSI || BNX2 && NETDEVICES && NETDEV_1000 && PCI || SPIDER_NET && NETDEVICES && NETDEV_1000 && PCI && (PPC_IBM_CELL_BLADE || PPC_CELLEB) || CHELSIO_T3 && NETDEVICES && NETDEV_10000 && CHELSIO_T3_DEPENDS || CHELSIO_T4 && NETDEVICES && NETDEV_10000 && CHELSIO_T4_DEPENDS || MYRI10GE && NETDEVICES && NETDEV_10000 && PCI && INET || NETXEN_NIC && NETDEVICES && NETDEV_10000 && PCI || BNX2X && NETDEVICES && NETDEV_10000 && PCI || QLCNIC && NETDEVICES && NETDEV_10000 && PCI || TMS380TR && NETDEVICES && TR && (PCI || ISA && ISA_DMA_API || MCA) || LIBERTAS_THINFIRM && NETDEVICES && WLAN && MAC80211 || ATMEL && NETDEVICES && WLAN && (PCI || PCMCIA) || PCMCIA_ATMEL && NETDEVICES && WLAN && ATMEL && PCMCIA || AT76C50X_USB && NETDEVICES && WLAN && MAC80211 && USB || PRISM54 && NETDEVICES && WLAN && PCI && EXPERIMENTAL || USB_ZD1201 && NETDEVICES && WLAN && USB || B43 && NETDEVICES && WLAN && SSB_POSSIBLE && MAC80211 && HAS_DMA || B43LEGACY && NETDEVICES && WLAN && SSB_POSSIBLE && MAC80211 && HAS_DMA || IPW2100 && NETDEVICES && WLAN && PCI && CFG80211 || IPW2200 && NETDEVICES && WLAN && PCI && CFG80211 && CFG80211_WEXT || IWLWIFI && NETDEVICES && WLAN && PCI && MAC80211 || IWM && NETDEVICES && WLAN && MMC && EXPERIMENTAL && CFG80211 || LIBERTAS && NETDEVICES && WLAN && CFG80211 || HERMES && NETDEVICES && WLAN && (PPC_PMAC || PCI || PCMCIA) && CFG80211 && CFG80211_WEXT || ORINOCO_USB && NETDEVICES && WLAN && USB && HERMES || P54_COMMON && NETDEVICES && WLAN && MAC80211 && EXPERIMENTAL || WL1251 &&!
  NETDEVICES && WLAN && WL12XX && GENERIC_HARDIRQS || WL1271 && NETDEVICES && WLAN && WL12XX && GENERIC_HARDIRQS && INET || ZD1211RW && NETDEVICES && WLAN && USB && MAC80211 && EXPERIMENTAL || AR9170_USB && NETDEVICES && WLAN && ATH_COMMON && USB && MAC80211 || RT2X00_LIB_FIRMWARE && NETDEVICES && WLAN && RT2X00 || WIMAX_I2400M && NETDEVICES && WIMAX || ATM_FORE200E && ATM_DRIVERS && NETDEVICES && ATM && (PCI || SBUS) || ATM_SOLOS && ATM_DRIVERS && NETDEVICES && ATM && PCI || CYCLADES && SERIAL_NONSTANDARD && (PCI || ISA) || MOXA_INTELLIO && SERIAL_NONSTANDARD && (ISA || EISA || PCI) || ISI && SERIAL_NONSTANDARD && PCI || SERIAL_ICOM && HAS_IOMEM && PCI && (PPC_ISERIES || PPC_PSERIES) || SERIAL_QE && HAS_IOMEM && QUICC_ENGINE || VIDEO_SAA7164 && MEDIA_SUPPORT && VIDEO_CAPTURE_DRIVERS && VIDEO_V4L2 && DVB_CORE && PCI && I2C || DVB_LGS8GXX && MEDIA_SUPPORT && DVB_CAPTURE_DRIVERS && DVB_FE_CUSTOMISE && DVB_CORE && I2C || DRM_R128 && HAS_IOMEM && DRM && PCI || DRM_RADEON && HAS_IOMEM && DRM && PCI || DRM_MGA && HAS_IOMEM && DRM && PCI || SND_SB16_CSP && SOUND && !M68K && SND && SND_ISA && (SND_SB16 || SND_SBAWE) && (BROKEN || !PPC) || SND_SSCAPE && SOUND && !M68K && SND && SND_ISA || SND_WAVEFRONT && SOUND && !M68K && SND && SND_ISA || SND_MSND_PINNACLE && SOUND && !M68K && SND && SND_ISA && X86 && EXPERIMENTAL || SND_MSND_CLASSIC && SOUND && !M68K && SND && SND_ISA && X86 && EXPERIMENTAL || SND_ASIHPI && SOUND && !M68K && SND && SND_PCI && X86 || SND_DARLA20 && SOUND && !M68K && SND && SND_PCI || SND_GINA20 && SOUND && !M68K && SND && SND_PCI || SND_LAYLA20 && SOUND && !M68K && SND && SND_PCI || SND_DARLA24 && SOUND && !M68K && SND && SND_PCI || SND_GINA24 && SOUND && !M68K && SND && SND_PCI || SND_LAYLA24 && SOUND && !M68K && SND && SND_PCI || SND_MONA && SOUND && !M68K && SND && SND_PCI || SND_MIA && SOUND && !M68K && SND && SND_PCI || SND_ECHO3G && SOUND && !M68K && SND && SND_PCI || SND_INDIGO && SOUND && !M68K && SND && SND_PCI || SND_INDIGOIO && SOUND && !M68K && SND && SND_PCI || SND_INDIGODJ && SOUND && !M68!
 K && SND && SND_PCI || SND_INDIGOIOX && SOUND && !M68K && SND && SND_PCI || SND_INDIGODJX && SOUND && !M68K && SND && SND_PCI || SND_EMU10K1 && SOUND && !M68K && SND && SND_PCI || SND_RIPTIDE && SOUND && !M68K && SND && SND_PCI || SND_HDA_PATCH_LOADER && SOUND && !M68K && SND && SND_PCI && SND_HDA_INTEL && EXPERIMENTAL || SND_SOC_SH4_SIU && SOUND && !M68K && SND && SND_SOC && (SUPERH || ARCH_SHMOBILE) && HAVE_CLK || USB_ISIGHTFW && USB_SUPPORT && USB || USB_SPEEDTOUCH && USB_SUPPORT && USB_ATM || USB_CXACRU && USB_SUPPORT && USB_ATM || USB_UEAGLEATM && USB_SUPPORT && USB_ATM || UWB_I1480U && UWB && UWB_HWA || RT2860 && STAGING && !STAGING_EXCLUDE_BUILD && PCI && X86 && WLAN || RT2870 && STAGING && !STAGING_EXCLUDE_BUILD && USB && (X86 || ARM) && WLAN || DRM_NOUVEAU && STAGING && !STAGING_EXCLUDE_BUILD && DRM && PCI || TI_ST && STAGING && !STAGING_EXCLUDE_BUILD && RFKILL) selects FW_LOADER which has unmet direct dependencies (HOTPLUG):  => N/A
	warning: (PPC_PS3 && PPC64 && PPC_BOOK3S || PPC_CELLEB && PPC64 && PPC_BOOK3S || USB_OHCI_HCD_PPC_SOC && USB_SUPPORT && USB_OHCI_HCD && (STB03xxx || PPC_MPC52xx) || USB_OHCI_HCD_PPC_OF_BE && USB_SUPPORT && USB_OHCI_HCD && PPC_OF) selects USB_OHCI_BIG_ENDIAN_MMIO which has unmet direct dependencies (USB_OHCI_HCD):  => N/A
	warning: (PPC_PS3 && PPC64 && PPC_BOOK3S || PPC_CELLEB && PPC64 && PPC_BOOK3S || XPS_USB_HCD_XILINX && USB_SUPPORT && USB_EHCI_HCD && (PPC32 || MICROBLAZE)) selects USB_EHCI_BIG_ENDIAN_MMIO which has unmet direct dependencies (USB_EHCI_HCD && (PPC_CELLEB || PPC_PS3 || 440EPX || ARCH_IXP4XX || XPS_USB_HCD_XILINX)):  => N/A
	warning: (PPC_PS3 && PPC64 && PPC_BOOK3S || SPU_FS && PPC_CELL) selects MEMORY_HOTPLUG which has unmet direct dependencies ((SPARSEMEM || X86_64_ACPI_NUMA) && HOTPLUG && ARCH_ENABLE_MEMORY_HOTPLUG && (IA64 || X86 || PPC_BOOK3S_64 || SUPERH || S390)):  => N/A
	warning: (PS3_PS3AV && PPC_PS3 || PS3_SYS_MANAGER && PPC_PS3) selects PS3_VUART which has unmet direct dependencies (PPC_PS3 && PS3_ADVANCED):  => N/A
	warning: (RADIO_MIROPCM20 && MEDIA_SUPPORT && RADIO_ADAPTERS && ISA && VIDEO_V4L2 && SND) selects SND_ISA which has unmet direct dependencies (ISA && ISA_DMA_API):  => N/A
	warning: (SCSI_SAS_LIBSAS && SCSI || SCSI_MPT2SAS && SCSI_LOWLEVEL && PCI && SCSI || FUSION_SAS && FUSION && PCI && SCSI) selects SCSI_SAS_ATTRS which has unmet direct dependencies (SCSI && BLK_DEV_BSG):  => N/A
	warning: (SINGLE_MEMORY_CHUNK) selects NEED_MULTIPLE_NODES which has unmet direct dependencies (DISCONTIGMEM || NUMA):  => N/A
	warning: (SUPERH32) selects HAVE_HW_BREAKPOINT which has unmet direct dependencies (PERF_EVENTS):  => N/A
	warning: (USB_WUSB && USB_SUPPORT && EXPERIMENTAL && USB) selects UWB which has unmet direct dependencies (EXPERIMENTAL && PCI):  => N/A
	warning: 5 bad relocations:  => N/A

218 improvements:
	.config: warning: override: SLOB changes choice state: 163, 166 => 150
	arch/cris/arch-v32/mach-fs/pinmux.c: warning: ISO C90 forbids mixed declarations and code: 225, 97 => 
	arch/cris/boot/compressed/misc.c: warning: conflicting types for built-in function 'puts': 109 => 
	arch/cris/boot/compressed/misc.c: warning: value computed is not used: 182 => 
	arch/cris/configs/etrax-100lx_defconfig: warning: override: reassigning to symbol MTD: 120 => 
	arch/cris/configs/etrax-100lx_defconfig: warning: override: reassigning to symbol MTD_BLOCK: 173 => 
	arch/cris/configs/etrax-100lx_defconfig: warning: override: reassigning to symbol MTD_CFI: 143 => 
	arch/cris/configs/etrax-100lx_defconfig: warning: override: reassigning to symbol MTD_CFI_AMDSTD: 146 => 
	arch/cris/configs/etrax-100lx_defconfig: warning: override: reassigning to symbol MTD_CFI_INTELEXT: 145 => 
	arch/cris/configs/etrax-100lx_defconfig: warning: override: reassigning to symbol MTD_CHAR: 172 => 
	arch/cris/configs/etrax-100lx_defconfig: warning: override: reassigning to symbol NET_ETHERNET: 301 => 
	arch/cris/configs/etrax-100lx_defconfig: warning: override: reassigning to symbol USB: 497 => 
	arch/cris/kernel/profile.c: warning: no return statement in function returning non-void: 57 => 
	arch/ia64/configs/generic_defconfig: warning: symbol value 'm' invalid for INET_LRO: 317 => 
	arch/m68k/configs/multi_defconfig: warning: symbol value 'm' invalid for INET_LRO: 222 => 
	arch/m68k/configs/sun3_defconfig: warning: symbol value 'm' invalid for INET_LRO: 207 => 
	arch/mips/configs/ip22_defconfig: warning: symbol value 'm' invalid for RFKILL_INPUT: 611 => 
	arch/parisc/configs/a500_defconfig: warning: symbol value 'm' invalid for PCCARD_NONSTATIC: 199 => 
	arch/powerpc/configs/iseries_defconfig: warning: symbol value 'm' invalid for GFS2_FS_LOCKING_DLM: 953 => 
	arch/powerpc/configs/pmac32_defconfig: warning: symbol value 'm' invalid for PCCARD_NONSTATIC: 332 => 
	arch/powerpc/configs/ppc6xx_defconfig: warning: symbol value 'm' invalid for GFS2_FS_LOCKING_DLM: 3021 => 
	arch/powerpc/configs/ppc6xx_defconfig: warning: symbol value 'm' invalid for IP_DCCP_CCID3: 683 => 
	arch/powerpc/configs/ppc6xx_defconfig: warning: symbol value 'm' invalid for IP_DCCP_TFRC_LIB: 686 => 
	arch/powerpc/kernel/crash_dump.c: warning: comparison of distinct pointer types lacks a cast: 131 => 
	arch/powerpc/kvm/book3s_paired_singles.c: warning: the frame size of 2288 bytes is larger than 2048 bytes: 1289 => 
	arch/powerpc/platforms/52xx/mpc52xx_pci.c: warning: cast to pointer from integer of different size: 295 => 
	arch/powerpc/platforms/52xx/mpc52xx_pci.c: warning: format '%x' expects type 'unsigned int', but argument 2 has type 'resource_size_t': 277 => 
	arch/powerpc/platforms/52xx/mpc52xx_pci.c: warning: format '%x' expects type 'unsigned int', but argument 3 has type 'resource_size_t': 277 => 
	arch/sh/kernel/cpu/sh2/../../entry-common.S: Warning: overflow in branch to __restore_all; converted into longer instruction sequence: 89 => 
	arch/sh/kernel/cpu/sh2/../../entry-common.S: Warning: overflow in branch to syscall_call; converted into longer instruction sequence: 209 => 
	arch/sh/kernel/cpu/sh2/../../entry-common.S: Warning: overflow in branch to syscall_exit_work; converted into longer instruction sequence: 364, 361 => 
	arch/sh/kernel/cpu/sh2/../../entry-common.S: Warning: overflow in branch to syscall_trace_entry; converted into longer instruction sequence: 337, 335 => 
	arch/sh/kernel/cpu/sh4/clock-sh4-202.c: warning: 'cpg_clk_init' is deprecated (declared at /scratch/kisskb/src/arch/sh/include/asm/clock.h:11): 165 => 
	arch/sh/kernel/cpu/sh4a/clock-sh7780.c: warning: 'cpg_clk_init' is deprecated (declared at /scratch/kisskb/src/arch/sh/include/asm/clock.h:11): 112 => 
	arch/sh/kernel/cpu/sh4a/clock-shx3.c: warning: 'cpg_clk_init' is deprecated (declared at /scratch/kisskb/src/arch/sh/include/asm/clock.h:11): 122 => 
	arch/sparc/include/asm/uaccess_32.h: warning: call to 'copy_from_user_overflow' declared with attribute warning: copy_from_user() buffer size is not provably correct: 276 => 
	arch/sparc/include/asm/uaccess_64.h: warning: call to 'copy_from_user_overflow' declared with attribute warning: copy_from_user() buffer size is not provably correct: 232 => 
	arch/x86/kernel/cpu/perf_event.c: warning: 'emptyconstraint' defined but not used: 1234 => 
	arch/x86/kernel/cpu/perf_event.c: warning: 'x86_pmu_disable_all' defined but not used: 567 => 
	arch/x86/kernel/cpu/perf_event.c: warning: 'x86_pmu_enable_all' defined but not used: 602 => 
	arch/x86/kernel/cpu/perf_event.c: warning: 'x86_pmu_enable_event' defined but not used: 936 => 
	arch/x86/kernel/cpu/perf_event.c: warning: 'x86_pmu_handle_irq' defined but not used: 1120 => 
	arch/x86/kernel/cpu/perf_event.c: warning: 'x86_pmu_hw_config' defined but not used: 492 => 
	arch/x86/kernel/cpu/perf_event.c: warning: 'x86_schedule_events' defined but not used: 627 => 
	arch/x86/kernel/pci-gart_64.c: warning: 'info.aper_base' may be used uninitialized in this function: 735 => 
	arch/xtensa/include/asm/pgalloc.h: warning: return makes pointer from integer without a cast: 47 => 
	crypto/testmgr.c: warning: 'alg_test_crc32c' uses dynamic stack allocation: 1488 => 
	drivers/acpi/acpi_pad.c: warning: 'num_cpus' may be used uninitialized in this function: 432 => 
	drivers/bluetooth/btmrvl_sdio.c: warning: 'fws1' may be used uninitialized in this function: 80 => 
	drivers/cdrom/gdrom.c: warning: 'ctrl_inb' is deprecated (declared at /scratch/kisskb/src/arch/sh/include/asm/io.h:94): 152, 621, 386, 146, 535, 141, 399, 235, 525 => 
	drivers/cdrom/gdrom.c: warning: 'ctrl_inl' is deprecated (declared at /scratch/kisskb/src/arch/sh/include/asm/io.h:104): 408 => 
	drivers/cdrom/gdrom.c: warning: 'ctrl_inw' is deprecated (declared at /scratch/kisskb/src/arch/sh/include/asm/io.h:99): 187 => 
	drivers/cdrom/gdrom.c: warning: 'ctrl_outb' is deprecated (declared at /scratch/kisskb/src/arch/sh/include/asm/io.h:114): 605, 198, 600, 180, 708, 625, 203, 704, 210, 199, 202, 604, 606, 201, 602, 232, 196, 611, 705, 603 => 
	drivers/cdrom/gdrom.c: warning: 'ctrl_outl' is deprecated (declared at /scratch/kisskb/src/arch/sh/include/asm/io.h:124): 718, 592, 591, 590, 589, 406, 719 => 
	drivers/char/isicom.c: warning: unused variable 'card': 875 => 
	drivers/char/specialix.c: warning: 'specialx_pci_tbl' defined but not used: 2359, 2358 => 2359
	drivers/dma/timb_dma.c: warning: cast to pointer from integer of different size: 203 => 
	drivers/gpio/gpiolib.c: warning: 'struct gpio' declared inside parameter list: 1299, 1276 => 
	drivers/gpio/gpiolib.c: warning: its scope is only this definition or declaration, which is probably not what you want: 1276 => 
	drivers/gpu/drm/drm_edid.c: warning: array subscript is above array bounds: 1174, 954, 1525, 1577 => 1294, 1256, 1080
	drivers/i2c/busses/i2c-sh7760.c: warning: 'ctrl_inl' is deprecated (declared at /scratch/kisskb/src/arch/sh/include/asm/io.h:104): 109 => 
	drivers/i2c/busses/i2c-sh7760.c: warning: 'ctrl_outl' is deprecated (declared at /scratch/kisskb/src/arch/sh/include/asm/io.h:124): 104 => 
	drivers/infiniband/hw/ipath/ipath_driver.c: warning: 'pnum' may be used uninitialized in this function: 1630 => 
	drivers/infiniband/hw/nes/nes_verbs.c: warning: cast to pointer from integer of different size: 477, 3488 => 3486
	drivers/input/keyboard/matrix_keypad.c: warning: 'matrix_keypad_resume' defined but not used: 242 => 
	drivers/input/keyboard/matrix_keypad.c: warning: 'matrix_keypad_suspend' defined but not used: 219 => 
	drivers/media/dvb/frontends/dib3000mc.c: warning: the frame size of 2192 bytes is larger than 2048 bytes: 853 => 
	drivers/media/dvb/frontends/dib7000p.c: warning: the frame size of 2272 bytes is larger than 2048 bytes: 1367 => 
	drivers/media/video/sh_mobile_ceu_camera.c: warning: 'ceu_sub_height' may be used uninitialized in this function: 1517 => 
	drivers/media/video/sh_mobile_ceu_camera.c: warning: 'ceu_sub_width' may be used uninitialized in this function: 1517 => 
	drivers/message/i2o/i2o_config.c: warning: cast to pointer from integer of different size: 878, 933 => 
	drivers/mfd/sh_mobile_sdhi.c: warning: 'sh_mobile_sdhi_remove' defined but not used: 142 => 
	drivers/mfd/twl4030-irq.c: warning: cast to pointer from integer of different size: 731 => 
	drivers/mfd/wm8350-regmap.c: warning: #warning MFD_WM8350_CONFIG_MODE_n options from the board driver.: 3178:2 => 
	drivers/mfd/wm8350-regmap.c: warning: #warning No WM8350 config modes supported - select at least one of the: 3177:2 => 
	drivers/misc/enclosure.c: warning: ignoring return value of 'ERR_PTR', declared with attribute warn_unused_result: 289 => 
	drivers/misc/hpilo.c: warning: 'ilo_remove' defined but not used: 720 => 
	drivers/misc/hpilo.c: warning: cast to pointer from integer of different size: 275 => 
	drivers/misc/sgi-gru/grufault.c: warning: 'paddr' may be used uninitialized in this function: 265 => 
	drivers/misc/sgi-gru/grufault.c: warning: 'ps' may be used uninitialized in this function: 266 => 
	drivers/mtd/chips/cfi_cmdset_0001.c: warning: the frame size of 2080 bytes is larger than 2048 bytes: 1800 => 
	drivers/mtd/chips/cfi_cmdset_0020.c: warning: the frame size of 1324 bytes is larger than 1024 bytes: 606 => 
	drivers/mtd/chips/cfi_cmdset_0020.c: warning: the frame size of 2160 bytes is larger than 2048 bytes: 983 => 
	drivers/mtd/chips/cfi_cmdset_0020.c: warning: the frame size of 2368 bytes is larger than 2048 bytes: 658 => 
	drivers/mtd/maps/gpio-addr-flash.c: warning: cast to pointer from integer of different size: 212, 224 => 
	drivers/mtd/nand/diskonchip.c: warning: #warning Unknown architecture for DiskOnChip. No default probe locations defined: 56:2, 57:2 => 56:2
	drivers/net/arcnet/capmode.c: warning: 'arcnet_cap_init' defined but not used: 64, 65 => 64
	drivers/net/bonding/bond_main.c: warning: 'disable_netpoll' defined but not used: 171 => 
	drivers/net/fs_enet/mii-fec.c: warning: format '%x' expects type 'unsigned int', but argument 4 has type 'resource_size_t': 131 => 
	drivers/net/mac8390.c: warning: passing argument 1 of '__builtin_memcpy' makes pointer from integer without a cast: 248 => 
	drivers/net/mac8390.c: warning: passing argument 1 of 'word_memcpy_tocard' makes pointer from integer without a cast: 253 => 
	drivers/net/mac8390.c: warning: passing argument 2 of 'word_memcpy_fromcard' makes pointer from integer without a cast: 255 => 
	drivers/net/pcmcia/ibmtr_cs.c: warning: 'pcmcia_request_exclusive_irq' is deprecated (declared at /scratch/kisskb/src/include/pcmcia/ds.h:191): 237 => 
	drivers/net/pcmcia/nmclan_cs.c: warning: 'pcmcia_request_exclusive_irq' is deprecated (declared at /scratch/kisskb/src/include/pcmcia/ds.h:191): 651 => 
	drivers/net/pcmcia/nmclan_cs.c: warning: 'pcmcia_request_exclusive_irq' is deprecated (declared at /scratch/kisskb/src/include/pcmcia/ds.h:193): 651 => 
	drivers/net/qlcnic/qlcnic_main.c: warning: 'pci_using_dac' may be used uninitialized in this function: 1041 => 
	drivers/net/s2io.c: warning: 'tcp_len' may be used uninitialized in this function: 7521 => 
	drivers/net/sh_eth.c: warning: unused variable 'i': 1389 => 
	drivers/net/smc91x.c: warning: passing argument 1 of 'sh_mv.mv_insw' makes integer from pointer without a cast: 488 => 
	drivers/net/smc91x.c: warning: passing argument 1 of 'sh_mv.mv_inw' makes integer from pointer without a cast: 1341, 1248, 1284, 831, 794, 1659, 727, 1287, 677, 1339, 798, 1231, 1224, 1881, 1172, 1664, 1898, 722, 858, 490, 1196, 1343, 772, 1949, 1826, 1690, 468, 328, 394, 438, 1223, 715, 419, 754, 1685, 1344, 1264, 1692, 675, 569, 750, 689, 312, 1278, 619, 409, 1924, 1911, 1340 => 
	drivers/net/smc91x.c: warning: passing argument 1 of 'sh_mv.mv_outsw' makes integer from pointer without a cast: 595 => 
	drivers/net/smc91x.c: warning: passing argument 2 of 'sh_mv.mv_outw' makes integer from pointer without a cast: 836, 1839, 276, 1284, 831, 1457, 1460, 723, 598, 1923, 937, 580, 667, 595, 1666, 1681, 488, 1694, 938, 379, 1653, 1680, 1130, 1072, 343, 1263, 849, 612, 936, 579, 347, 726, 394, 294, 1022, 1458, 1225, 378, 803, 592, 1695, 1198, 751, 1023, 689, 393, 1199, 311, 1948, 1248, 1173, 309, 795, 1195, 1683, 389, 1660, 469, 327, 1652, 1287, 677, 1345, 1197, 1171, 416, 1293, 252, 760, 1656, 863, 323, 758, 783, 268, 345, 308, 348, 819, 1910, 1265, 858, 1658, 1897, 1818, 1684, 387, 755, 307, 801, 491, 269, 1294, 1463, 354, 759, 344, 1073, 388, 355, 1811, 1667, 1461, 251, 1342, 326, 1686, 1655, 439, 1278, 619, 781, 1812 => 
	drivers/net/smc91x.h: warning: "SMC_inb" redefined: 604:1 => 
	drivers/net/smc91x.h: warning: "SMC_inl" redefined: 562:1 => 
	drivers/net/smc91x.h: warning: "SMC_insl" redefined: 564:1 => 
	drivers/net/smc91x.h: warning: "SMC_outb" redefined: 605:1 => 
	drivers/net/smc91x.h: warning: "SMC_outl" redefined: 563:1 => 
	drivers/net/smc91x.h: warning: "SMC_outsl" redefined: 565:1 => 
	drivers/net/smc91x.h: warning: this is the location of the previous definition: 221:1, 217:1, 218:1, 222:1, 215:1, 220:1 => 
	drivers/net/wireless/iwlwifi/iwl-tx.c: warning: passing argument 1 of 'ieee80211_stop_tx_ba_cb_irqsafe' from incompatible pointer type: 1356 => 
	drivers/pci/pcie/aer/aerdrv_core.c: warning: 'e_src.id' may be used uninitialized in this function: 756 => 
	drivers/pci/pcie/aer/aerdrv_core.c: warning: 'e_src.status' may be used uninitialized in this function: 756 => 
	drivers/rtc/rtc-cmos.c: warning: #warning Assuming 128 bytes of RTC+NVRAM address space, not 64 bytes.: 697:2, 693:2 => 693:2
	drivers/serial/mpc52xx_uart.c: warning: cast to pointer from integer of different size: 1139, 812, 1272 => 
	drivers/sh/maple/maple.c: warning: 'ctrl_inl' is deprecated (declared at /scratch/kisskb/src/arch/sh/include/asm/io.h:104): 133 => 
	drivers/sh/maple/maple.c: warning: 'ctrl_outl' is deprecated (declared at /scratch/kisskb/src/arch/sh/include/asm/io.h:124): 109, 453, 99, 639, 278, 97, 108, 799, 110 => 
	drivers/sh/superhyway/superhyway-sysfs.c: warning: format '%08lx' expects type 'long unsigned int', but argument 3 has type 'resource_size_t': 33 => 
	drivers/staging/comedi/drivers/serial2002.c: warning: the frame size of 1664 bytes is larger than 1024 bytes: 677 => 
	drivers/staging/iio/accel/adis16220_core.c: warning: initialization from incompatible pointer type: 437, 484, 460 => 
	drivers/staging/iio/imu/adis16400_core.c: warning: 'adis16400_self_test' defined but not used: 416 => 
	drivers/staging/quatech_usb2/quatech_usb2.c: warning: 'qt2_box_flush' defined but not used: 1852 => 
	drivers/staging/udlfb/udlfb.c: warning: ignoring return value of 'device_create_bin_file', declared with attribute warn_unused_result: 1364 => 
	drivers/staging/udlfb/udlfb.c: warning: ignoring return value of 'device_create_file', declared with attribute warn_unused_result: 1362 => 
	drivers/staging/xgifb/XGI_main.h: warning: 'XGIfb_pdc' defined but not used: 391 => 
	drivers/staging/xgifb/XGI_main_26.c: warning: 'XGIfb_search_crt2type' defined but not used: 858 => 
	drivers/staging/xgifb/XGI_main_26.c: warning: 'XGIfb_search_queuemode' defined but not used: 877 => 
	drivers/staging/xgifb/XGI_main_26.c: warning: 'XGIfb_search_tvstd' defined but not used: 941 => 
	drivers/staging/xgifb/XGI_main_26.c: warning: 'crt1off' defined but not used: 3588 => 
	drivers/usb/host/whci/hcd.c: warning: 'whci_hcd_id_table' defined but not used: 359, 358 => 359
	drivers/video/aty/radeon_pm.c: warning: 'radeon_reinitialize_M10' defined but not used: 1718 => 
	drivers/video/aty/radeon_pm.c: warning: 'radeon_reinitialize_M9P' defined but not used: 1971 => 
	drivers/video/fsl-diu-fb.c: warning: format '%08x' expects type 'unsigned int', but argument 5 has type 'resource_size_t': 1457 => 
	drivers/video/via/via-gpio.c: warning: assignment from incompatible pointer type: 216 => 
	drivers/xen/events.c: warning: 'gsi_from_irq' defined but not used: 181 => 
	drivers/xen/events.c: warning: 'mk_pirq_info' defined but not used: 135 => 
	drivers/xen/events.c: warning: 'vector_from_irq' defined but not used: 191 => 
	fs/cifs/cifssmb.c: warning: 'pdata' may be used uninitialized in this function: 3082 => 
	fs/dcache.c: warning: control reaches end of non-void function: 1885, 1870, 1887 => 1899, 1887
	fs/ecryptfs/messaging.c: warning: 'daemon' may be used uninitialized in this function: 277 => 
	fs/fat/namei_vfat.c: warning: 'lcase' may be used uninitialized in this function: 590 => 
	fs/fat/namei_vfat.c: warning: 'ulen' may be used uninitialized in this function: 595 => 
	fs/ncpfs/inode.c: warning: 'data.mounted_vol[10u]' may be used uninitialized in this function: 435 => 
	fs/ncpfs/inode.c: warning: 'data.mounted_vol[11u]' may be used uninitialized in this function: 435 => 
	fs/ncpfs/inode.c: warning: 'data.mounted_vol[12u]' may be used uninitialized in this function: 435 => 
	fs/ncpfs/inode.c: warning: 'data.mounted_vol[13u]' may be used uninitialized in this function: 435 => 
	fs/ncpfs/inode.c: warning: 'data.mounted_vol[14u]' may be used uninitialized in this function: 435 => 
	fs/ncpfs/inode.c: warning: 'data.mounted_vol[15u]' may be used uninitialized in this function: 435 => 
	fs/ncpfs/inode.c: warning: 'data.mounted_vol[16u]' may be used uninitialized in this function: 435 => 
	fs/ncpfs/inode.c: warning: 'data.mounted_vol[1u]' may be used uninitialized in this function: 435 => 
	fs/ncpfs/inode.c: warning: 'data.mounted_vol[2u]' may be used uninitialized in this function: 435 => 
	fs/ncpfs/inode.c: warning: 'data.mounted_vol[3u]' may be used uninitialized in this function: 435 => 
	fs/ncpfs/inode.c: warning: 'data.mounted_vol[4u]' may be used uninitialized in this function: 435 => 
	fs/ncpfs/inode.c: warning: 'data.mounted_vol[5u]' may be used uninitialized in this function: 435 => 
	fs/ncpfs/inode.c: warning: 'data.mounted_vol[6u]' may be used uninitialized in this function: 435 => 
	fs/ncpfs/inode.c: warning: 'data.mounted_vol[7u]' may be used uninitialized in this function: 435 => 
	fs/ncpfs/inode.c: warning: 'data.mounted_vol[8u]' may be used uninitialized in this function: 435 => 
	fs/ncpfs/inode.c: warning: 'data.mounted_vol[9u]' may be used uninitialized in this function: 435 => 
	fs/omfs/file.c: warning: 'new_block' may be used uninitialized in this function: 225 => 
	fs/qnx4/namei.c: warning: 'ino' may be used uninitialized in this function: 104 => 
	fs/quota/quota_tree.c: warning: format '%zd' expects type 'signed size_t', but argument 2 has type 'ssize_t': 376 => 
	fs/quota/quota_v2.c: warning: format '%zd' expects type 'signed size_t', but argument 3 has type 'ssize_t': 66 => 
	fs/squashfs/xattr.c: warning: 'squashfs_xattr_handler' declared inline after being called: 37 => 
	fs/squashfs/xattr.c: warning: previous declaration of 'squashfs_xattr_handler' was here: 37 => 
	include/config/auto.conf: warning: symbol value '' invalid for CROSS_COMPILE: 165, 4001, 428, 309, 3655, 297 => 149, 3707, 428, 307, 4062
	include/config/auto.conf: warning: symbol value '' invalid for DEFAULT_SECURITY: 147 => 
	include/linux/bio.h: warning: "ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE" is not defined: 398:5 => 
	include/linux/blkdev.h: warning: "ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE" is not defined: 764:5 => 
	include/trace/events/timer.h: warning: format '%lu' expects type 'long unsigned int', but argument 4 has type 'cputime_t': 279 => 
	include/trace/events/timer.h: warning: format '%lu' expects type 'long unsigned int', but argument 5 has type 'cputime_t': 316 => 
	kernel/irq/handle.c: warning:   CC      kernel/irq/spurious.o: 432:3 => 
	kernel/kprobes.c: warning: ¡cleanup_rp_inst¢ defined but not used: 910 => 
	lib/decompress_bunzip2.c: warning: the frame size of 1824 bytes is larger than 1024 bytes: 511 => 
	lib/decompress_bunzip2.c: warning: the frame size of 1840 bytes is larger than 1024 bytes: 511 => 
	lib/decompress_bunzip2.c: warning: the frame size of 1876 bytes is larger than 1024 bytes: 511 => 
	lib/decompress_bunzip2.c: warning: the frame size of 1916 bytes is larger than 1024 bytes: 511 => 
	mm/memcontrol.c: warning: 'val' may be used uninitialized in this function: 3119, 2725 => 3192
	modpost: WARNING: modpost: Found 10 section mismatch(es).: N/A => 
	modpost: WARNING: modpost: Found 11 section mismatch(es).: N/A => 
	modpost: WARNING: modpost: Found 14 section mismatch(es).: N/A => 
	modpost: WARNING: modpost: Found 26 section mismatch(es).: N/A => 
	modpost: WARNING: modpost: Found 28 section mismatch(es).: N/A => 
	modpost: WARNING: modpost: Found 3 section mismatch(es).: N/A => 
	modpost: WARNING: modpost: Found 43 section mismatch(es).: N/A => 
	modpost: WARNING: modpost: Found 45 section mismatch(es).: N/A => 
	modpost: WARNING: modpost: Found 49 section mismatch(es).: N/A => 
	modpost: WARNING: modpost: Found 70 section mismatch(es).: N/A => 
	modpost: WARNING: modpost: Found 81 section mismatch(es).: N/A => 
	net/bluetooth/l2cap.c: warning: comparison is always false due to limited range of data type: 4150, 4145, 3826, 3873 => 
	net/dccp/ccids/ccid2.c: warning: 'veclen' may be used uninitialized in this function: 508 => 
	net/dccp/ccids/ccid2.c: warning: 'vector' may be used uninitialized in this function: 507 => 
	net/packet/af_packet.c: warning: ¡vnet_hdr_len¢ may be used uninitialized in this function: 1092 => 
	net/sctp/socket.c: warning: 'newsock' may be used uninitialized in this function: 4025 => 
	sound/drivers/serial-u16550.c: warning: 'uart' may be used uninitialized in this function: 905 => 
	sound/i2c/other/ak4xxx-adda.c: warning: no return statement in function returning non-void: 903 => 
	sound/mips/hal2.c: warning: 'l' may be used uninitialized in this function: 203 => 
	sound/mips/hal2.c: warning: 'new' may be used uninitialized in this function: 232 => 
	sound/mips/hal2.c: warning: 'old' may be used uninitialized in this function: 232 => 
	sound/mips/hal2.c: warning: 'r' may be used uninitialized in this function: 203 => 
	sound/oss/pss.c: warning: 'check_region' is deprecated (declared at /scratch/kisskb/src/include/linux/ioport.h:169): 676 => 
	sound/pci/atiixp.c: warning: 'chip' may be used uninitialized in this function: 1652 => 
	sound/pci/atiixp_modem.c: warning: 'chip' may be used uninitialized in this function: 1288 => 
	sound/pci/ice1712/quartet.c: warning: 'get_binary' defined but not used: 211 => 
	sound/pci/lx6464es/lx6464es.c: warning: cast to pointer from integer of different size: 456, 455 => 
	sound/pci/lx6464es/lx_core.c: warning: cast to pointer from integer of different size: 1185 => 
	sound/pci/via82xx.c: warning: 'chip' may be used uninitialized in this function: 2498 => 
	sound/pci/via82xx_modem.c: warning: 'chip' may be used uninitialized in this function: 1168 => 
	sound/pcmcia/pdaudiocf/pdaudiocf.c: warning: 'pcmcia_request_exclusive_irq' is deprecated (declared at /scratch/kisskb/src/include/pcmcia/ds.h:191): 226 => 
	sound/pcmcia/pdaudiocf/pdaudiocf.c: warning: 'pcmcia_request_exclusive_irq' is deprecated (declared at /scratch/kisskb/src/include/pcmcia/ds.h:193): 226 => 
	sound/pcmcia/vx/vxpocket.c: warning: 'pcmcia_request_exclusive_irq' is deprecated (declared at /scratch/kisskb/src/include/pcmcia/ds.h:191): 233 => 
	sound/pcmcia/vx/vxpocket.c: warning: 'pcmcia_request_exclusive_irq' is deprecated (declared at /scratch/kisskb/src/include/pcmcia/ds.h:193): 233 => 
	sound/soc/codecs/wm8900.c: warning: 'fll_div.fll_ratio' may be used uninitialized in this function: 749 => 
	sound/soc/codecs/wm8900.c: warning: 'fll_div.fll_slow_lock_ref' may be used uninitialized in this function: 749 => 
	sound/soc/codecs/wm8900.c: warning: 'fll_div.fllclk_div' may be used uninitialized in this function: 749 => 
	sound/soc/codecs/wm8900.c: warning: 'fll_div.k' may be used uninitialized in this function: 749 => 
	sound/soc/codecs/wm8900.c: warning: 'fll_div.n' may be used uninitialized in this function: 749 => 
	sound/soc/soc-dapm.c: warning: unused variable 'codec': 440 => 
	sound/usb/format.c: warning: 'ret' may be used uninitialized in this function: 355 => 
	sound/usb/misc/ua101.c: warning: unused variable 'ua': 1172 => 

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
