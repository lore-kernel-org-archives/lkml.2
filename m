Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754183Ab0IVSGL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 14:06:11 -0400
Received: from brigitte.telenet-ops.be ([195.130.137.66]:39728 "EHLO
	brigitte.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753586Ab0IVSGI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 14:06:08 -0400
Date: Wed, 22 Sep 2010 20:06:05 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Build regressions/improvements in v2.6.36-rc5
Message-ID: <alpine.DEB.2.00.1009221958570.8898@ayla.of.borg>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-7
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Below is the list of build error/warning regressions/improvements in
v2.6.36-rc5 compared to v2.6.35.

JFYI, when comparing v2.6.36-rc5 to v2.6.36-rc3 (I'm skipping -rc4 as the build
results were incomplete), the summaries are:
 - build errors: +6/-55
 - build warnings: +147/-73 (ough!)

In addition, I put the verbose summary at
http://www.kernel.org/pub/linux/kernel/people/geert/linux-log/v2.6.36-rc5.summary.gz
so you can easily find out for which configs and architectures the
errors/warnings you're interested in are happening.

Happy fixing! ;-)

Thanks to the linux-next team for providing the build service.


*** ERRORS ***

85 regressions:
	arch/avr32/include/asm/syscalls.h: error: previous declaration of ¡sys_execve¢ was here:  => 25
	arch/avr32/kernel/process.c: error: conflicting types for ¡sys_execve¢:  => 390
	arch/cris/arch-v10/drivers/sync_serial.c: error: 'ret' undeclared (first use in this function):  => 626
	arch/cris/arch-v10/drivers/sync_serial.c: error: (Each undeclared identifier is reported only once:  => 626
	arch/cris/arch-v10/drivers/sync_serial.c: error: conflicting types for 'sync_serial_ioctl':  => 959
	arch/cris/arch-v10/drivers/sync_serial.c: error: for each function it appears in.):  => 626
	arch/cris/arch-v10/drivers/sync_serial.c: error: previous declaration of 'sync_serial_ioctl' was here:  => 160
	arch/sh/include/asm/syscalls_32.h: error: previous declaration of 'sys_execve' was here:  => 22
	arch/sh/kernel/process_32.c: error: conflicting types for 'sys_execve':  => 299
	drivers/block/hd.c: error: implicit declaration of function 'inb_p':  => 257
	drivers/block/hd.c: error: implicit declaration of function 'outb_p':  => 298
	drivers/block/paride/bpck.c: error: invalid operands to binary & (have 'void *' and 'int'):  => 56, 62
	drivers/gpio/timbgpio.c: error: 'IRQ_TYPE_EDGE_BOTH' undeclared (first use in this function):  => 146
	drivers/gpio/timbgpio.c: error: 'IRQ_TYPE_EDGE_FALLING' undeclared (first use in this function):  => 153
	drivers/gpio/timbgpio.c: error: 'IRQ_TYPE_LEVEL_HIGH' undeclared (first use in this function):  => 138
	drivers/gpio/timbgpio.c: error: 'IRQ_TYPE_LEVEL_LOW' undeclared (first use in this function):  => 138
	drivers/gpio/timbgpio.c: error: 'handle_simple_irq' undeclared (first use in this function):  => 258
	drivers/gpio/timbgpio.c: error: (Each undeclared identifier is reported only once:  => 138
	drivers/gpio/timbgpio.c: error: dereferencing pointer to incomplete type:  => 173
	drivers/gpio/timbgpio.c: error: for each function it appears in.):  => 138
	drivers/gpio/timbgpio.c: error: implicit declaration of function 'generic_handle_irq':  => 178
	drivers/gpio/timbgpio.c: error: implicit declaration of function 'get_irq_chip_data':  => 109
	drivers/gpio/timbgpio.c: error: implicit declaration of function 'get_irq_data':  => 169
	drivers/gpio/timbgpio.c: error: implicit declaration of function 'set_irq_chained_handler':  => 266
	drivers/gpio/timbgpio.c: error: implicit declaration of function 'set_irq_chip':  => 293
	drivers/gpio/timbgpio.c: error: implicit declaration of function 'set_irq_chip_and_handler_name':  => 257
	drivers/gpio/timbgpio.c: error: implicit declaration of function 'set_irq_chip_data':  => 259
	drivers/gpio/timbgpio.c: error: implicit declaration of function 'set_irq_data':  => 265
	drivers/gpio/timbgpio.c: error: implicit declaration of function 'set_irq_handler':  => 297
	drivers/gpio/timbgpio.c: error: unknown field 'disable' specified in initializer:  => 184
	drivers/gpio/timbgpio.c: error: unknown field 'enable' specified in initializer:  => 183
	drivers/gpio/timbgpio.c: error: unknown field 'name' specified in initializer:  => 182
	drivers/gpio/timbgpio.c: error: unknown field 'set_type' specified in initializer:  => 185
	drivers/gpio/timbgpio.c: error: variable 'timbgpio_irqchip' has initializer but incomplete type:  => 181
	drivers/serial/mfd.c: error: implicit declaration of function 'kfree':  => 175
	drivers/serial/mfd.c: error: implicit declaration of function 'kzalloc':  => 144
	drivers/serial/mrst_max3110.c: error: 'IRQ_TYPE_EDGE_FALLING' undeclared (first use in this function):  => 470
	drivers/serial/mrst_max3110.c: error: (Each undeclared identifier is reported only once:  => 470
	drivers/serial/mrst_max3110.c: error: for each function it appears in.):  => 470
	error: "st_get_plat_device" [drivers/staging/ti-st/st_drv.ko] undefined!:  => N/A
	error: No rule to make target include/config/auto.conf:  => N/A
	error: hotplug-memory.c: undefined reference to `.__remove_pages':  => .text+0xe5e8)
	error: mm.c: undefined reference to `.online_pages':  => .init.text+0x5fd8)
	fs/9p/vfs_inode.c: error: implicit declaration of function 'inode_setattr':  => 1267
	fs/ceph/mds_client.c: error: insn does not satisfy its constraints::  => 3190
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
	lib/atomic64_test.c: error: implicit declaration of function 'atomic64_dec_if_positive':  => 119
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

46 improvements:
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

272 regressions:
	.config: warning: override: PCI_GOANY changes choice state:  => 353
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
	arch/cris/mm/fault.c: warning: ISO C90 forbids mixed declarations and code:  => 205
	arch/mips/sibyte/bcm1480/smp.c: warning: passing argument 1 of '__cpus_clear' discards qualifiers from pointer target type:  => 149
	arch/um/kernel/exec.c: warning: passing argument 2 of 'execve1' from incompatible pointer type:  => 69, 85
	arch/um/kernel/exec.c: warning: passing argument 3 of 'execve1' from incompatible pointer type:  => 69, 85
	arch/x86/include/asm/uaccess_32.h: warning: call to 'copy_from_user_overflow' declared with attribute warning: copy_from_user() buffer size is not provably correct:  => 212
	arch/x86/kernel/dumpstack_32.c: warning: 'c' may be used uninitialized in this function:  => 111
	arch/x86/kernel/scx200_32.c: warning: 'base' may be used uninitialized in this function:  => 82
	arch/x86/kernel/signal.c: warning: 'set.sig[1]' may be used uninitialized in this function:  => 563
	arch/xtensa/kernel/entry.S: Warning: value 0xffffffff30000000 truncated to 0x30000000: 1544 => 1544, 1545
	block/blk-merge.c: warning: 'bbio' may be used uninitialized in this function:  => 18
	block/bsg.c: warning: 'rw' may be used uninitialized in this function:  => 251
	drivers/acpi/sysfs.c: warning: passing argument 1 of '__check_old_set_param' from incompatible pointer type:  => 152, 154
	drivers/ata/libata-core.c: warning: 'native_sectors' may be used uninitialized in this function:  => 1501
	drivers/ata/libata-scsi.c: warning: 'dev' may be used uninitialized in this function:  => 3375
	drivers/atm/nicstar.c: warning: 'err' may be used uninitialized in this function:  => 956
	drivers/base/power/main.c: warning: comparison of distinct pointer types lacks a cast: 413 => 414, 415
	drivers/block/hd.c: warning: statement with no effect:  => 468
	drivers/block/loop.c: warning: 'xfer' may be used uninitialized in this function:  => 1490
	drivers/block/xd.c: warning: 'address' may be used uninitialized in this function:  => 158
	drivers/block/xd.c: warning: 'controller' may be used uninitialized in this function:  => 157
	drivers/block/z2ram.c: warning: format '%lu' expects type 'long unsigned int', but argument 2 has type 'sector_t': 82 => 83, 82
	drivers/char/consolemap.c: warning: 'h' may be used uninitialized in this function:  => 699
	drivers/char/n_gsm.c: warning: ignoring return value of '__kfifo_must_check_helper', declared with attribute warn_unused_result:  => 1580
	drivers/char/rocket.c: warning: 'rmSpeakerReset' defined but not used: 3152, 3153 => 3152, 3163, 3164
	drivers/char/rocket.c: warning: 'rocket_pci_ids' defined but not used: 1756 => 1756, 1767
	drivers/char/rocket.c: warning: 'sPCIInitController' defined but not used: 2611, 2616 => 2627, 2611, 2622
	drivers/char/tpm/tpm_atmel.c: warning: 'base' may be used uninitialized in this function:  => 194
	drivers/char/tty_buffer.c: warning: comparison of distinct pointer types lacks a cast:  => 251, 288
	drivers/char/vt_ioctl.c: warning: 'cc' may be used uninitialized in this function:  => 1121
	drivers/dma/pch_dma.c: warning: 'pch_dma_resume' defined but not used:  => 753
	drivers/dma/pch_dma.c: warning: 'pch_dma_suspend' defined but not used:  => 739
	drivers/edac/mpc85xx_edac.c: warning: 'mpc85xx_pci_err_remove' defined but not used:  => 308
	drivers/gpio/timbgpio.c: warning: (near initialization for 'timbgpio_irqchip'):  => 182, 185, 183, 184
	drivers/gpio/timbgpio.c: warning: excess elements in struct initializer:  => 182, 185, 183, 184
	drivers/gpio/timbgpio.c: warning: initialization makes pointer from integer without a cast:  => 109, 169, 125, 117
	drivers/gpu/drm/drm_bufs.c: warning: 'master' may be used uninitialized in this function:  => 429
	drivers/gpu/drm/drm_context.c: warning: passing argument 2 of '__constant_test_and_set_bit' discards qualifiers from pointer target type:  => 233
	drivers/gpu/drm/drm_context.c: warning: passing argument 2 of '__generic_test_and_set_bit' discards qualifiers from pointer target type:  => 233
	drivers/gpu/drm/drm_pci.c: warning: passing argument 1 of 'virt_to_phys' makes pointer from integer without a cast:  => 109, 84
	drivers/gpu/drm/drm_vm.c: warning: passing argument 1 of 'virt_to_phys' makes pointer from integer without a cast:  => 308
	drivers/gpu/drm/radeon/radeon_gart.c: warning: passing argument 3 of 'pci_free_consistent' discards qualifiers from pointer target type:  => 69
	drivers/i2c/busses/i2c-cpm.c: warning: passing argument 3 of 'dma_alloc_coherent' from incompatible pointer type:  => 536, 543
	drivers/infiniband/core/uverbs_main.c: warning: the address of 'uverbs_event_fops' will always evaluate as 'true': 523 => 526, 537
	drivers/infiniband/hw/amso1100/c2_qp.c: warning: 'actual_sge_count' may be used uninitialized in this function:  => 799, 961
	drivers/infiniband/hw/amso1100/c2_qp.c: warning: 'tot_len' may be used uninitialized in this function:  => 798
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
	drivers/leds/leds-gpio.c: warning: 'flags' may be used uninitialized in this function:  => 251
	drivers/media/dvb/frontends/dib3000mc.c: warning: the frame size of 2208 bytes is larger than 2048 bytes:  => 853
	drivers/media/dvb/frontends/dib7000p.c: warning: the frame size of 2288 bytes is larger than 2048 bytes:  => 1367
	drivers/media/dvb/ngene/ngene-core.c: warning: unused variable 'flags':  => 1308
	drivers/media/video/sh_mobile_ceu_camera.c: warning: 'sd' is used uninitialized in this function:  => 1245
	drivers/media/video/sh_mobile_ceu_camera.c: warning: 'sd' may be used uninitialized in this function:  => 1707, 1683, 943
	drivers/media/video/sh_mobile_ceu_camera.c: warning: unused variable 'sd':  => 1648
	drivers/message/fusion/mptsas.c: warning: unused variable 'log_info':  => 5010
	drivers/mtd/chips/cfi_cmdset_0020.c: warning: the frame size of 2288 bytes is larger than 2048 bytes:  => 657
	drivers/mtd/devices/doc2001plus.c: warning: passing argument 2 of 'MemWriteDOC' discards qualifiers from pointer target type:  => 767
	drivers/mtd/devices/docprobe.c: warning: #warning Unknown architecture for DiskOnChip. No default probe locations defined: 80:2 => 80:2, 79:2
	drivers/mtd/nand/alauda.c: warning: passing argument 3 of 'alauda_write_page' discards qualifiers from pointer target type:  => 480
	drivers/net/pcmcia/ibmtr_cs.c: warning: 'pcmcia_request_exclusive_irq' is deprecated (declared at /scratch/kisskb/src/include/pcmcia/ds.h:200):  => 235
	drivers/net/pcmcia/ibmtr_cs.c: warning: 'pcmcia_request_exclusive_irq' is deprecated (declared at /scratch/kisskb/src/include/pcmcia/ds.h:202):  => 235
	drivers/net/pcmcia/nmclan_cs.c: warning: 'pcmcia_request_exclusive_irq' is deprecated (declared at /scratch/kisskb/src/include/pcmcia/ds.h:200):  => 650
	drivers/net/pcmcia/nmclan_cs.c: warning: 'pcmcia_request_exclusive_irq' is deprecated (declared at /scratch/kisskb/src/include/pcmcia/ds.h:202):  => 650
	drivers/net/pcmcia/smc91c92_cs.c: warning: 'j' may be used uninitialized in this function:  => 846
	drivers/net/smc91x.c: warning: cast from pointer to integer of different size:  => 1913
	drivers/net/tehuti.c: warning: passing argument 2 of 'bdx_tx_push_desc_safe' discards qualifiers from pointer target type:  => 330
	drivers/net/tlan.c: warning: label 'err_out' defined but not used:  => 685
	drivers/net/wan/farsync.c: warning: cast to pointer from integer of different size:  => 1408
	drivers/net/wireless/iwmc3200wifi/rx.c: warning: comparison is always true due to limited range of data type:  => 1198
	drivers/net/wireless/libertas/cfg.c: warning: passing argument 3 of 'lbs_deb_hex' discards qualifiers from pointer target type:  => 273
	drivers/net/wireless/mwl8k.c: warning: 'ap_legacy_rates' may be used uninitialized in this function:  => 3403
	drivers/net/wireless/p54/p54usb.c: warning: 'p54u_device_reset' defined but not used:  => 406, 407
	drivers/parisc/led.c: warning: assignment from incompatible pointer type:  => 366
	drivers/pci/pcie/portdrv_core.c: warning: 'cap_mask' may be used uninitialized in this function:  => 241
	drivers/regulator/max1586.c: warning: 'selector' may be used uninitialized in this function:  => 116
	drivers/rtc/rtc-rx8025.c: warning: 'adj' may be used uninitialized in this function:  => 525
	drivers/scsi/advansys.c: warning: 'adv_scsiqp' may be used uninitialized in this function:  => 9439
	drivers/scsi/advansys.c: warning: 'next_qp' may be used uninitialized in this function:  => 9010
	drivers/scsi/advansys.c: warning: 'ret' may be used uninitialized in this function:  => 11891
	drivers/scsi/advansys.c: warning: 'share_irq' may be used uninitialized in this function:  => 11891
	drivers/scsi/aha1542.c: warning: 'dma_chan' may be used uninitialized in this function:  => 969
	drivers/scsi/aha1542.c: warning: 'irq_level' may be used uninitialized in this function:  => 970
	drivers/scsi/aha1542.c: warning: 'scsi_id' may be used uninitialized in this function:  => 971
	drivers/scsi/aic7xxx_old.c: warning: passing argument 3 of 'pci_free_consistent' discards qualifiers from pointer target type:  => 8490
	drivers/scsi/constants.c: warning: zero-length printf format string:  => 1407, 1413, 1456
	drivers/scsi/dpt_i2o.c: warning: 'dptids' defined but not used:  => 182
	drivers/scsi/hpsa.c: warning: 'asc' may be used uninitialized in this function:  => 963
	drivers/scsi/hpsa.c: warning: 'ascq' may be used uninitialized in this function:  => 964
	drivers/scsi/hpsa.c: warning: 'cp' may be used uninitialized in this function:  => 2335, 2299
	drivers/scsi/hpsa.c: warning: 'sense_key' may be used uninitialized in this function:  => 962
	drivers/scsi/mpt2sas/mpt2sas_base.c: warning: right shift count >= width of type:  => 3022, 3020
	drivers/scsi/mpt2sas/mpt2sas_ctl.c: warning: '_ctl_sas_device_find_by_handle' defined but not used:  => 94
	drivers/scsi/mpt2sas/mpt2sas_scsih.c: warning: unused variable 'mpi_reply':  => 2718
	drivers/scsi/ncr53c8xx.c: warning: 'cp' may be used uninitialized in this function:  => 4125
	drivers/scsi/ncr53c8xx.c: warning: 'host_data' may be used uninitialized in this function:  => 8299
	drivers/scsi/osst.c: warning: 'STp' may be used uninitialized in this function:  => 4445
	drivers/scsi/pmcraid.c: warning: passing argument 2 of 'access_ok' makes pointer from integer without a cast:  => 3800
	drivers/scsi/scsi_error.c: warning: 'add_sen_len' may be used uninitialized in this function:  => 2061
	drivers/scsi/scsi_transport_fc.c: warning: 'val' may be used uninitialized in this function:  => 1564
	drivers/scsi/sd.c: warning: zero-length printf format string:  => 2630, 2636, 2628
	drivers/scsi/sg.c: warning: 'sdp' may be used uninitialized in this function:  => 345, 776, 1129, 325, 537
	drivers/scsi/sg.c: warning: 'sfp' may be used uninitialized in this function:  => 1177, 1216
	drivers/scsi/st.c: warning: 'result2' may be used uninitialized in this function:  => 1268
	drivers/scsi/stex.c: warning: passing argument 2 of 'scsi_sg_copy_from_buffer' discards qualifiers from pointer target type:  => 636
	drivers/serial/mfd.c: warning: 'serial_hsu_remove' defined but not used:  => 1436
	drivers/serial/mfd.c: warning: assignment makes pointer from integer without a cast:  => 144, 1361, 818, 187
	drivers/staging/hv/channel.c: warning: 'msgCount' may be used uninitialized in this function:  => 495
	drivers/uio/uio.c: warning: passing argument 1 of 'virt_to_phys' makes pointer from integer without a cast:  => 654
	drivers/usb/gadget/storage_common.c: warning: 'fsg_show_nofua' defined but not used:  => 718, 720
	drivers/usb/gadget/storage_common.c: warning: 'fsg_store_nofua' defined but not used:  => 782, 785
	drivers/usb/host/ehci-lpm.c: warning: 'ehci_lpm_check' defined but not used:  => 40
	drivers/usb/host/ehci-lpm.c: warning: 'ehci_lpm_set_da' defined but not used:  => 20
	drivers/video/aty/atyfb_base.c: warning: 'ram_dram' defined but not used:  => 538
	drivers/video/aty/atyfb_base.c: warning: 'ram_resv' defined but not used:  => 539
	drivers/video/aty/atyfb_base.c: warning: overflow in implicit constant conversion:  => 441
	drivers/virtio/virtio_balloon.c: warning: 'events[10]' is used uninitialized in this function:  => 168
	drivers/virtio/virtio_balloon.c: warning: 'events[11]' is used uninitialized in this function:  => 168
	drivers/virtio/virtio_balloon.c: warning: 'events[2]' is used uninitialized in this function:  => 182
	drivers/virtio/virtio_balloon.c: warning: 'events[3]' is used uninitialized in this function:  => 184
	fs/9p/xattr.c: warning: format '%zd' expects type 'signed size_t', but argument 3 has type 'ssize_t':  => 52
	fs/9p/xattr.c: warning: format '%zd' expects type 'signed size_t', but argument 4 has type 'ssize_t':  => 52
	fs/autofs/root.c: warning: 'autofs_root_compat_ioctl' declared 'static' but never defined:  => 30
	fs/autofs4/root.c: warning: 'autofs4_root_compat_ioctl' declared 'static' but never defined:  => 31
	fs/cifs/asn1.c: warning: 'ch' may be used uninitialized in this function:  => 403, 170, 189, 250, 153
	fs/cifs/readdir.c: warning: 'current_entry' may be used uninitialized in this function:  => 771
	fs/exec.c: warning: 'len' may be used uninitialized in this function:  => 403
	fs/ext4/namei.c: warning: 'bh' may be used uninitialized in this function:  => 1881
	fs/fuse/dev.c: warning: 'total_len' may be used uninitialized in this function:  => 1357
	fs/fuse/dev.c: warning: ¡total_len¢ may be used uninitialized in this function:  => 1357
	fs/locks.c: warning: 'lock' may be used uninitialized in this function:  => 1572
	fs/ncpfs/inode.c: warning: 'data.dir_mode' may be used uninitialized in this function:  => 435
	fs/ncpfs/inode.c: warning: 'data.file_mode' may be used uninitialized in this function:  => 435
	fs/ncpfs/inode.c: warning: 'data.flags' may be used uninitialized in this function:  => 435
	fs/ncpfs/inode.c: warning: 'data.gid' may be used uninitialized in this function:  => 435
	fs/ncpfs/inode.c: warning: 'data.info_fd' may be used uninitialized in this function:  => 435
	fs/ncpfs/inode.c: warning: 'data.mounted_uid' may be used uninitialized in this function:  => 435
	fs/ncpfs/inode.c: warning: 'data.ncp_fd' may be used uninitialized in this function:  => 435
	fs/ncpfs/inode.c: warning: 'data.retry_count' may be used uninitialized in this function:  => 435
	fs/ncpfs/inode.c: warning: 'data.time_out' may be used uninitialized in this function:  => 435
	fs/ncpfs/inode.c: warning: 'data.uid' may be used uninitialized in this function:  => 435
	fs/nfsd/nfs4state.c: warning: control reaches end of non-void function:  => 452
	fs/notify/fanotify/fanotify.c: warning: 'marks_ignored_mask' may be used uninitialized in this function:  => 162
	fs/notify/fanotify/fanotify.c: warning: 'marks_mask' may be used uninitialized in this function:  => 162
	fs/notify/fanotify/fanotify_user.c: warning: unused variable 'lre':  => 375
	fs/notify/fanotify/fanotify_user.c: warning: unused variable 're':  => 375
	fs/ntfs/dir.c: warning: 'bmp_vi' may be used uninitialized in this function:  => 1104
	fs/ocfs2/aops.c: warning: 'wc' may be used uninitialized in this function:  => 1652
	fs/ocfs2/cluster/heartbeat.c: warning: 'block_bits' may be used uninitialized in this function:  => 1127
	fs/ocfs2/cluster/heartbeat.c: warning: 'block_bytes' may be used uninitialized in this function:  => 1126
	fs/ocfs2/dir.c: warning: 'split_hash' may be used uninitialized in this function:  => 3805
	fs/ocfs2/file.c: warning: 'blkno' may be used uninitialized in this function:  => 1695
	fs/ocfs2/file.c: warning: 'trunc_cpos' may be used uninitialized in this function:  => 1685
	fs/ocfs2/file.c: warning: 'trunc_len' may be used uninitialized in this function:  => 1685
	fs/ocfs2/ioctl.c: warning: 'flags' may be used uninitialized in this function:  => 115
	fs/ocfs2/quota_local.c: warning: 'dchunk' may be used uninitialized in this function:  => 923
	fs/ocfs2/refcounttree.c: warning: 'new_cpos' may be used uninitialized in this function:  => 1529
	fs/ocfs2/refcounttree.c: warning: 'ref_blkno' may be used uninitialized in this function:  => 2301
	fs/ocfs2/slot_map.c: warning: 'bytes' may be used uninitialized in this function:  => 360
	fs/ocfs2/xattr.c: warning: 'ret' may be used uninitialized in this function:  => 2940
	fs/reiserfs/fix_node.c: warning: 'l' may be used uninitialized in this function:  => 856
	fs/reiserfs/fix_node.c: warning: 'r' may be used uninitialized in this function:  => 878
	include/linux/sunrpc/cache.h: warning: 'rv' may be used uninitialized in this function:  => 223
	include/linux/sysv_fs.h: warning: 'packed' attribute ignored for field of type '__fs32'In file included from /scratch/kisskb/src/fs/sysv/sysv.h:9,:  => 144
	include/media/soc_camera.h: warning: 'dummy' is used uninitialized in this function:  => 278
	include/net/ipx.h: warning: 'packed' attribute ignored for field of type '__be16':  => 32, 30
	include/net/ipx.h: warning: 'packed' attribute ignored for field of type 'struct ipx_address':  => 42, 41
	kernel/cgroup.c: warning: 'l' may be used uninitialized in this function:  => 2963
	kernel/module.c: warning: 'hdr' may be used uninitialized in this function:  => 2109
	kernel/module.c: warning: passing argument 2 of 'add_kallsyms' discards qualifiers from pointer target type:  => 2534
	kernel/pm_qos_params.c: warning: control may reach end of non-void function ¡pm_qos_get_value¢ being inlined:  => 200
	kernel/pm_qos_params.c: warning: control reaches end of non-void function:  => 132
	kernel/ptrace.c: warning: 'kiov.iov_len' may be used uninitialized in this function:  => 652
	kernel/trace/trace_events.c: warning: enumeration value 'TRACE_REG_PERF_REGISTER' not handled in switch:  => 146
	kernel/trace/trace_events.c: warning: enumeration value 'TRACE_REG_PERF_UNREGISTER' not handled in switch:  => 146
	kernel/trace/trace_functions_graph.c: warning: comparison of distinct pointer types lacks a cast:  => 652
	kernel/watchdog.c: warning: 'watchdog_disable_all_cpus' defined but not used:  => 483, 484
	kernel/watchdog.c: warning: 'watchdog_enable_all_cpus' defined but not used:  => 470, 471
	kernel/workqueue.c: warning: 'last_gcwq' may be used uninitialized in this function:  => 964
	lib/atomic64_test.c: warning: ISO C90 forbids mixed declarations and code:  => 25
	lib/radix-tree.c: warning: 'radix_tree_range_tag_if_tagged' uses dynamic stack allocation:  => 737
	mm/percpu.c: warning: 'pcpu_build_alloc_info' defined but not used:  => 1094
	modpost: WARNING: modpost: Found 13 section mismatch(es).:  => N/A
	modpost: WARNING: modpost: Found 54 section mismatch(es).:  => N/A
	modpost: WARNING: modpost: Found 65 section mismatch(es).:  => N/A
	net/ax25/ax25_in.c: warning: 'make' may be used uninitialized in this function:  => 193
	net/core/neighbour.c: warning: 'error' may be used uninitialized in this function:  => 412
	net/core/neighbour.c: warning: 'neigh' may be used uninitialized in this function:  => 1202
	net/core/skbuff.c: warning: 'err' may be used uninitialized in this function:  => 1076
	net/decnet/sysctl_net_decnet.c: warning: 'dnaddr' may be used uninitialized in this function:  => 140
	net/ipv4/inet_connection_sock.c: warning: 'head' may be used uninitialized in this function:  => 95
	net/ipv4/ip_options.c: warning: 'faddr' may be used uninitialized in this function:  => 161
	net/ipv4/ip_output.c: warning: 'left' may be used uninitialized in this function:  => 1026
	net/ipv4/raw.c: warning: 'node' may be used uninitialized in this function:  => 112
	net/ipv4/tcp_ipv4.c: warning: 'node' may be used uninitialized in this function:  => 1995, 2146
	net/ipv4/udp.c: warning: 'node' may be used uninitialized in this function:  => 542
	net/irda/irnet/irnet_ppp.c: warning: format '%Zd' expects type 'signed size_t', but argument 3 has type 'ssize_t':  => 332
	net/mac80211/tx.c: warning: unused variable 'mesh_hdr':  => 1702
	net/packet/af_packet.c: warning: 'hdrlen' may be used uninitialized in this function: 655 => 657, 648
	net/rose/af_rose.c: warning: 'make' may be used uninitialized in this function:  => 985
	net/sched/cls_route.c: warning: 'f' may be used uninitialized in this function:  => 137
	net/sched/sch_cbq.c: warning: 'len' may be used uninitialized in this function:  => 1185
	net/sched/sch_hfsc.c: warning: 'cl' may be used uninitialized in this function:  => 1157
	net/sched/sch_hfsc.c: warning: 'len' may be used uninitialized in this function:  => 1683
	net/sched/sch_htb.c: warning: 'len' may be used uninitialized in this function:  => 919
	net/sunrpc/auth_gss/auth_gss.c: warning: format '%Zd' expects type 'signed size_t', but argument 2 has type 'ssize_t':  => 706
	net/sunrpc/auth_gss/auth_gss.c: warning: format '%zd' expects type 'signed size_t', but argument 3 has type 'ssize_t':  => 688
	net/sunrpc/stats.c: warning: 'proc' may be used uninitialized in this function:  => 83
	net/sunrpc/svcauth.c: warning: 'aops' may be used uninitialized in this function:  => 40
	net/xfrm/xfrm_state.c: warning: 'x0' may be used uninitialized in this function:  => 788
	security/apparmor/policy_unpack.c: warning: 'src_str' may be used uninitialized in this function:  => 251
	security/keys/keyctl.c: warning: #warning TIF_NOTIFY_RESUME not implemented: 1329:2 => 1346:2, 1342:2
	sound/pcmcia/pdaudiocf/pdaudiocf.c: warning: 'pcmcia_request_exclusive_irq' is deprecated (declared at /scratch/kisskb/src/include/pcmcia/ds.h:200):  => 226
	sound/pcmcia/pdaudiocf/pdaudiocf.c: warning: 'pcmcia_request_exclusive_irq' is deprecated (declared at /scratch/kisskb/src/include/pcmcia/ds.h:202):  => 226
	sound/pcmcia/vx/vxpocket.c: warning: 'pcmcia_request_exclusive_irq' is deprecated (declared at /scratch/kisskb/src/include/pcmcia/ds.h:200):  => 233
	sound/pcmcia/vx/vxpocket.c: warning: 'pcmcia_request_exclusive_irq' is deprecated (declared at /scratch/kisskb/src/include/pcmcia/ds.h:202):  => 233
	sound/usb/mixer.c: warning: unused variable 'chip':  => 762
	warning: (BATTERY_DS2760 && POWER_SUPPLY) selects W1 which has unmet direct dependencies (HAS_IOMEM):  => N/A
	warning: (COMPAT && SPARC64) selects COMPAT_BINFMT_ELF which has unmet direct dependencies (COMPAT && BINFMT_ELF):  => N/A
	warning: (COMPAT) selects COMPAT_BINFMT_ELF which has unmet direct dependencies (COMPAT && BINFMT_ELF):  => N/A
	warning: (CRYPTO_LRW && CRYPTO && EXPERIMENTAL || CRYPTO_XTS && CRYPTO && EXPERIMENTAL || CRYPTO_GHASH && CRYPTO) selects CRYPTO_GF128MUL which has unmet direct dependencies (EXPERIMENTAL):  => N/A
	warning: (EP8248E && PPC_82xx || MPC85xx_MDS && FSL_SOC_BOOKE || NET_DSA && NET && EXPERIMENTAL && NETDEVICES && !S390 || MACB && NETDEVICES && NET_ETHERNET && (AVR32 || ARCH_AT91SAM9260 || ARCH_AT91SAM9263 || ARCH_AT91SAM9G20 || ARCH_AT91SAM9G45 || ARCH_AT91CAP9) || IXP4XX_ETH && NETDEVICES && NET_ETHERNET && ARM && ARCH_IXP4XX && IXP4XX_NPE && IXP4XX_QMGR || W90P910_ETH && NETDEVICES && NET_ETHERNET && ARM && ARCH_W90X900 || MIPS_AU1X00_ENET && NETDEVICES && NET_ETHERNET && MIPS_ALCHEMY || SH_ETH && NETDEVICES && NET_ETHERNET && SUPERH && (CPU_SUBTYPE_SH7710 || CPU_SUBTYPE_SH7712 || CPU_SUBTYPE_SH7763 || CPU_SUBTYPE_SH7619 || CPU_SUBTYPE_SH7724 || CPU_SUBTYPE_SH7757) || BFIN_MAC && NETDEVICES && NET_ETHERNET && (BF516 || BF518 || BF526 || BF527 || BF536 || BF537) || PXA168_ETH && NETDEVICES && NET_ETHERNET && CPU_PXA168 || TI_DAVINCI_EMAC && NETDEVICES && NET_ETHERNET && ARM && (ARCH_DAVINCI || ARCH_OMAP3) || ETHOC && NETDEVICES && NET_ETHERNET && HAS_IOMEM && HAS_DMA || GRETH && NETDEVICES && NET_ETHERNET && SPARC || SMSC911X && NETDEVICES && NET_ETHERNET && (ARM || SUPERH || BLACKFIN || MIPS) || DNET && NETDEVICES && NET_ETHERNET && HAS_IOMEM || TC35815 && NETDEVICES && NET_ETHERNET && NET_PCI && PCI && MIPS || R6040 && NETDEVICES && NET_ETHERNET && NET_PCI && PCI || SMSC9420 && NETDEVICES && NET_ETHERNET && NET_PCI && PCI || CPMAC && NETDEVICES && NET_ETHERNET && EXPERIMENTAL && AR7 || FEC && NETDEVICES && NET_ETHERNET && (M523x || M527x || M5272 || M528x || M520x || M532x || MACH_MX27 || ARCH_MX35 || ARCH_MX25 || ARCH_MX5) || FEC_MPC52xx && NETDEVICES && NET_ETHERNET && PPC_MPC52xx && PPC_BESTCOMM || XILINX_EMACLITE && NETDEVICES && NET_ETHERNET && (PPC32 || MICROBLAZE) || BCM63XX_ENET && NETDEVICES && NET_ETHERNET && BCM63XX || FS_ENET && NETDEVICES && NET_ETHERNET && (CPM1 || CPM2 || PPC_MPC512x) || OCTEON_MGMT_ETHERNET && NETDEVICES && NET_ETHERNET && CPU_CAVIUM_OCTEON || SB1250_MAC && NETDEVICES && NETDEV_1000 && SIBYTE_SB1xxx_SOC || TIGON3 && NETDEVICES && NETDEV_1000 && PCI || FSL_PQ_MDIO &&!
  NETDEVICES && NETDEV_1000 && FSL_SOC || GIANFAR && NETDEVICES && NETDEV_1000 && FSL_SOC || UCC_GETH && NETDEVICES && NETDEV_1000 && QUICC_ENGINE || MV643XX_ETH && NETDEVICES && NETDEV_1000 && (MV64X60 || PPC32 || PLAT_ORION) || XILINX_LL_TEMAC && NETDEVICES && NETDEV_1000 && (PPC || MICROBLAZE) || S6GMAC && NETDEVICES && NETDEV_1000 && XTENSA_VARIANT_S6000 || STMMAC_ETH && NETDEV_1000 && NETDEVICES && CPU_SUBTYPE_ST40 || PASEMI_MAC && NETDEVICES && NETDEV_10000 && PPC_PASEMI && PCI || OCTEON_ETHERNET && STAGING && !STAGING_EXCLUDE_BUILD && CPU_CAVIUM_OCTEON && NETDEVICES) selects PHYLIB which has unmet direct dependencies (!S390 && NETDEVICES):  => N/A
	warning: (ETRAX_USB_HOST && ETRAX_ARCH_V10 || MOUSE_APPLETOUCH && !S390 && INPUT && INPUT_MOUSE && USB_ARCH_HAS_HCD || MOUSE_BCM5974 && !S390 && INPUT && INPUT_MOUSE && USB_ARCH_HAS_HCD || JOYSTICK_XPAD && !S390 && INPUT && INPUT_JOYSTICK && USB_ARCH_HAS_HCD || TABLET_USB_ACECAD && !S390 && INPUT && INPUT_TABLET && USB_ARCH_HAS_HCD || TABLET_USB_AIPTEK && !S390 && INPUT && INPUT_TABLET && USB_ARCH_HAS_HCD || TABLET_USB_KBTAB && !S390 && INPUT && INPUT_TABLET && USB_ARCH_HAS_HCD || TABLET_USB_WACOM && !S390 && INPUT && INPUT_TABLET && USB_ARCH_HAS_HCD || TOUCHSCREEN_USB_COMPOSITE && !S390 && INPUT && INPUT_TOUCHSCREEN && USB_ARCH_HAS_HCD || INPUT_ATI_REMOTE && !S390 && INPUT && INPUT_MISC && USB_ARCH_HAS_HCD || INPUT_ATI_REMOTE2 && !S390 && INPUT && INPUT_MISC && USB_ARCH_HAS_HCD || INPUT_KEYSPAN_REMOTE && !S390 && INPUT && INPUT_MISC && EXPERIMENTAL && USB_ARCH_HAS_HCD || INPUT_POWERMATE && !S390 && INPUT && INPUT_MISC && USB_ARCH_HAS_HCD || INPUT_YEALINK && !S390 && INPUT && INPUT_MISC && EXPERIMENTAL && USB_ARCH_HAS_HCD || INPUT_CM109 && !S390 && INPUT && INPUT_MISC && EXPERIMENTAL && USB_ARCH_HAS_HCD) selects USB which has unmet direct dependencies (USB_ARCH_HAS_HCD):  => N/A
	warning: (GFS2_FS && BLOCK && EXPERIMENTAL && (64BIT || LBDAF)) selects QUOTACTL which has unmet direct dependencies (XFS_QUOTA || QUOTA):  => N/A
	warning: (IMA && SECURITY && !S390) selects TCG_TPM which has unmet direct dependencies (HAS_IOMEM && EXPERIMENTAL):  => N/A
	warning: (IRQSOFF_TRACER && TRACING_SUPPORT && FTRACE && TRACE_IRQFLAGS_SUPPORT && !ARCH_USES_GETTIMEOFFSET) selects TRACE_IRQFLAGS which has unmet direct dependencies (DEBUG_KERNEL && TRACE_IRQFLAGS_SUPPORT && PROVE_LOCKING):  => N/A
	warning: (LOCKDEP && DEBUG_KERNEL && TRACE_IRQFLAGS_SUPPORT && STACKTRACE_SUPPORT && LOCKDEP_SUPPORT && !MIPS && !PPC && !ARM_UNWIND && !S390 && !MICROBLAZE || FAULT_INJECTION_STACKTRACE_FILTER && FAULT_INJECTION_DEBUG_FS && STACKTRACE_SUPPORT && !X86_64 && !PPC && !S390 && !MICROBLAZE || LATENCYTOP && HAVE_LATENCYTOP_SUPPORT && DEBUG_KERNEL && STACKTRACE_SUPPORT && PROC_FS && !MIPS && !PPC && !S390 && !MICROBLAZE || FUNCTION_TRACER && TRACING_SUPPORT && FTRACE && HAVE_FUNCTION_TRACER || KMEMCHECK && HAVE_ARCH_KMEMCHECK && DEBUG_KERNEL && !X86_USE_3DNOW && (SLUB || SLAB) && !CC_OPTIMIZE_FOR_SIZE && !FUNCTION_TRACER) selects FRAME_POINTER which has unmet direct dependencies (DEBUG_KERNEL && (CRIS || M68K || M68KNOMMU || FRV || UML || AVR32 || SUPERH || BLACKFIN || MN10300) || ARCH_WANT_FRAME_POINTERS):  => N/A
	warning: (PAGE_POISONING && DEBUG_KERNEL && !ARCH_SUPPORTS_DEBUG_PAGEALLOC && !HIBERNATION) selects DEBUG_PAGEALLOC which has unmet direct dependencies (DEBUG_KERNEL && ARCH_SUPPORTS_DEBUG_PAGEALLOC && (!HIBERNATION || !PPC && !SPARC) && !KMEMCHECK):  => N/A
	warning: (PCMCIA_LOAD_CIS && PCCARD && PCMCIA && EXPERIMENTAL || USB_IRDA && NET && IRDA && USB || BT_HCIBCM203X && NET && BT && USB || BT_HCIBFUSB && NET && BT && USB || BT_HCIBT3C && NET && BT && PCMCIA || BT_MRVL_SDIO && NET && BT && BT_MRVL && MMC || BT_ATH3K && NET && BT && BT_HCIBTUSB || IWMC3200TOP && MISC_DEVICES && MMC && EXPERIMENTAL || SCSI_AIC94XX && SCSI_LOWLEVEL && SCSI && PCI || SCSI_MVSAS && SCSI_LOWLEVEL && SCSI && PCI || SCSI_IPR && SCSI_LOWLEVEL && PCI && SCSI && ATA || SCSI_QLA_FC && SCSI_LOWLEVEL && PCI && SCSI || BNX2 && NETDEVICES && NETDEV_1000 && PCI || SPIDER_NET && NETDEVICES && NETDEV_1000 && PCI && (PPC_IBM_CELL_BLADE || PPC_CELLEB) || CHELSIO_T3 && NETDEVICES && NETDEV_10000 && CHELSIO_T3_DEPENDS || CHELSIO_T4 && NETDEVICES && NETDEV_10000 && CHELSIO_T4_DEPENDS || MYRI10GE && NETDEVICES && NETDEV_10000 && PCI && INET || NETXEN_NIC && NETDEVICES && NETDEV_10000 && PCI || BNX2X && NETDEVICES && NETDEV_10000 && PCI || QLCNIC && NETDEVICES && NETDEV_10000 && PCI || TMS380TR && NETDEVICES && TR && (PCI || ISA && ISA_DMA_API || MCA) || LIBERTAS_THINFIRM && NETDEVICES && WLAN && MAC80211 || ATMEL && NETDEVICES && WLAN && (PCI || PCMCIA) || PCMCIA_ATMEL && NETDEVICES && WLAN && ATMEL && PCMCIA || AT76C50X_USB && NETDEVICES && WLAN && MAC80211 && USB || PRISM54 && NETDEVICES && WLAN && PCI && EXPERIMENTAL || USB_ZD1201 && NETDEVICES && WLAN && USB || B43 && NETDEVICES && WLAN && SSB_POSSIBLE && MAC80211 && HAS_DMA || B43LEGACY && NETDEVICES && WLAN && SSB_POSSIBLE && MAC80211 && HAS_DMA || IPW2100 && NETDEVICES && WLAN && PCI && CFG80211 || IPW2200 && NETDEVICES && WLAN && PCI && CFG80211 && CFG80211_WEXT || IWLWIFI && NETDEVICES && WLAN && PCI && MAC80211 || IWM && NETDEVICES && WLAN && MMC && EXPERIMENTAL && CFG80211 || LIBERTAS && NETDEVICES && WLAN && CFG80211 || HERMES && NETDEVICES && WLAN && (PPC_PMAC || PCI || PCMCIA) && CFG80211 && CFG80211_WEXT || ORINOCO_USB && NETDEVICES && WLAN && USB && HERMES || P54_COMMON && NETDEVICES && WLAN && MAC80211 && EXPERIMENTAL || WL1251 &&!
  NETDEVICES && WLAN && WL12XX && GENERIC_HARDIRQS || WL1271 && NETDEVICES && WLAN && WL12XX && GENERIC_HARDIRQS && INET || ZD1211RW && NETDEVICES && WLAN && USB && MAC80211 && EXPERIMENTAL || AR9170_USB && NETDEVICES && WLAN && ATH_COMMON && USB && MAC80211 || RT2X00_LIB_FIRMWARE && NETDEVICES && WLAN && RT2X00 || WIMAX_I2400M && NETDEVICES && WIMAX || ATM_FORE200E && ATM_DRIVERS && NETDEVICES && ATM && (PCI || SBUS) || ATM_SOLOS && ATM_DRIVERS && NETDEVICES && ATM && PCI || CYCLADES && SERIAL_NONSTANDARD && (PCI || ISA) || MOXA_INTELLIO && SERIAL_NONSTANDARD && (ISA || EISA || PCI) || ISI && SERIAL_NONSTANDARD && PCI || SERIAL_ICOM && HAS_IOMEM && PCI && (PPC_ISERIES || PPC_PSERIES) || SERIAL_QE && HAS_IOMEM && QUICC_ENGINE || VIDEO_SAA7164 && MEDIA_SUPPORT && VIDEO_CAPTURE_DRIVERS && VIDEO_V4L2 && DVB_CORE && PCI && I2C || DVB_LGS8GXX && MEDIA_SUPPORT && DVB_CAPTURE_DRIVERS && DVB_FE_CUSTOMISE && DVB_CORE && I2C || DRM_R128 && HAS_IOMEM && DRM && PCI || DRM_RADEON && HAS_IOMEM && DRM && PCI || DRM_MGA && HAS_IOMEM && DRM && PCI || SND_SB16_CSP && SOUND && !M68K && SND && SND_ISA && (SND_SB16 || SND_SBAWE) && (BROKEN || !PPC) || SND_SSCAPE && SOUND && !M68K && SND && SND_ISA || SND_WAVEFRONT && SOUND && !M68K && SND && SND_ISA || SND_MSND_PINNACLE && SOUND && !M68K && SND && SND_ISA && X86 && EXPERIMENTAL || SND_MSND_CLASSIC && SOUND && !M68K && SND && SND_ISA && X86 && EXPERIMENTAL || SND_ASIHPI && SOUND && !M68K && SND && SND_PCI && X86 || SND_DARLA20 && SOUND && !M68K && SND && SND_PCI || SND_GINA20 && SOUND && !M68K && SND && SND_PCI || SND_LAYLA20 && SOUND && !M68K && SND && SND_PCI || SND_DARLA24 && SOUND && !M68K && SND && SND_PCI || SND_GINA24 && SOUND && !M68K && SND && SND_PCI || SND_LAYLA24 && SOUND && !M68K && SND && SND_PCI || SND_MONA && SOUND && !M68K && SND && SND_PCI || SND_MIA && SOUND && !M68K && SND && SND_PCI || SND_ECHO3G && SOUND && !M68K && SND && SND_PCI || SND_INDIGO && SOUND && !M68K && SND && SND_PCI || SND_INDIGOIO && SOUND && !M68K && SND && SND_PCI || SND_INDIGODJ && SOUND && !M68!
 K && SND && SND_PCI || SND_INDIGOIOX && SOUND && !M68K && SND && SND_PCI || SND_INDIGODJX && SOUND && !M68K && SND && SND_PCI || SND_EMU10K1 && SOUND && !M68K && SND && SND_PCI || SND_RIPTIDE && SOUND && !M68K && SND && SND_PCI || SND_HDA_PATCH_LOADER && SOUND && !M68K && SND && SND_PCI && SND_HDA_INTEL && EXPERIMENTAL || SND_SOC_SH4_SIU && SOUND && !M68K && SND && SND_SOC && (SUPERH || ARCH_SHMOBILE) && HAVE_CLK || USB_ISIGHTFW && USB_SUPPORT && USB || USB_SPEEDTOUCH && USB_SUPPORT && USB_ATM || USB_CXACRU && USB_SUPPORT && USB_ATM || USB_UEAGLEATM && USB_SUPPORT && USB_ATM || UWB_I1480U && UWB && UWB_HWA || RT2860 && STAGING && !STAGING_EXCLUDE_BUILD && PCI && X86 && WLAN || RT2870 && STAGING && !STAGING_EXCLUDE_BUILD && USB && (X86 || ARM) && WLAN || DRM_NOUVEAU && STAGING && !STAGING_EXCLUDE_BUILD && DRM && PCI || TI_ST && STAGING && !STAGING_EXCLUDE_BUILD && RFKILL) selects FW_LOADER which has unmet direct dependencies (HOTPLUG):  => N/A
	warning: (PPC_PS3 && PPC64 && PPC_BOOK3S || PPC_CELLEB && PPC64 && PPC_BOOK3S || USB_OHCI_HCD_PPC_SOC && USB_SUPPORT && USB_OHCI_HCD && (STB03xxx || PPC_MPC52xx) || USB_OHCI_HCD_PPC_OF_BE && USB_SUPPORT && USB_OHCI_HCD && PPC_OF) selects USB_OHCI_BIG_ENDIAN_MMIO which has unmet direct dependencies (USB_OHCI_HCD):  => N/A
	warning: (PPC_PS3 && PPC64 && PPC_BOOK3S || PPC_CELLEB && PPC64 && PPC_BOOK3S || XPS_USB_HCD_XILINX && USB_SUPPORT && USB_EHCI_HCD && (PPC32 || MICROBLAZE)) selects USB_EHCI_BIG_ENDIAN_MMIO which has unmet direct dependencies (USB_EHCI_HCD && (PPC_CELLEB || PPC_PS3 || 440EPX || ARCH_IXP4XX || XPS_USB_HCD_XILINX)):  => N/A
	warning: (PPC_PS3 && PPC64 && PPC_BOOK3S || SPU_FS && PPC_CELL) selects MEMORY_HOTPLUG which has unmet direct dependencies ((SPARSEMEM || X86_64_ACPI_NUMA) && HOTPLUG && ARCH_ENABLE_MEMORY_HOTPLUG && (IA64 || X86 || PPC_BOOK3S_64 || SUPERH || S390)):  => N/A
	warning: (PPC_PS3 && PPC64 && PPC_BOOK3S || USB_OHCI_HCD_PPC_OF_LE && USB_SUPPORT && USB_OHCI_HCD && PPC_OF || USB_OHCI_HCD_PCI && USB_SUPPORT && USB_OHCI_HCD && PCI && (STB03xxx || PPC_MPC52xx || USB_OHCI_HCD_PPC_OF)) selects USB_OHCI_LITTLE_ENDIAN which has unmet direct dependencies (USB_OHCI_HCD):  => N/A
	warning: (PS3_PS3AV && PPC_PS3 || PS3_SYS_MANAGER && PPC_PS3) selects PS3_VUART which has unmet direct dependencies (PPC_PS3 && PS3_ADVANCED):  => N/A
	warning: (RADIO_MIROPCM20 && MEDIA_SUPPORT && RADIO_ADAPTERS && ISA && VIDEO_V4L2 && SND) selects SND_ISA which has unmet direct dependencies (ISA && ISA_DMA_API):  => N/A
	warning: (SCSI_SAS_LIBSAS && SCSI || SCSI_MPT2SAS && SCSI_LOWLEVEL && PCI && SCSI || FUSION_SAS && FUSION && PCI && SCSI) selects SCSI_SAS_ATTRS which has unmet direct dependencies (SCSI && BLK_DEV_BSG):  => N/A
	warning: (SINGLE_MEMORY_CHUNK) selects NEED_MULTIPLE_NODES which has unmet direct dependencies (DISCONTIGMEM || NUMA):  => N/A
	warning: (SUPERH32) selects HAVE_HW_BREAKPOINT which has unmet direct dependencies (PERF_EVENTS):  => N/A
	warning: (USB_WUSB && USB_SUPPORT && EXPERIMENTAL && USB) selects UWB which has unmet direct dependencies (EXPERIMENTAL && PCI):  => N/A

170 improvements:
	.config: warning: override: SLOB changes choice state: 163, 166 => 145
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
	arch/sh/kernel/cpu/sh2a/clock-sh7201.c: warning: 'return' with a value, in function returning void: 37 => 
	arch/sh/kernel/cpu/sh4/clock-sh4-202.c: warning: 'cpg_clk_init' is deprecated (declared at /scratch/kisskb/src/arch/sh/include/asm/clock.h:11): 165 => 
	arch/sh/kernel/cpu/sh4a/clock-sh7780.c: warning: 'cpg_clk_init' is deprecated (declared at /scratch/kisskb/src/arch/sh/include/asm/clock.h:11): 112 => 
	arch/sh/kernel/cpu/sh4a/clock-shx3.c: warning: 'cpg_clk_init' is deprecated (declared at /scratch/kisskb/src/arch/sh/include/asm/clock.h:11): 122 => 
	arch/sparc/include/asm/uaccess_32.h: warning: call to 'copy_from_user_overflow' declared with attribute warning: copy_from_user() buffer size is not provably correct: 276 => 
	arch/sparc/include/asm/uaccess_64.h: warning: call to 'copy_from_user_overflow' declared with attribute warning: copy_from_user() buffer size is not provably correct: 232 => 
	arch/x86/kernel/cpu/perf_event.c: warning: 'emptyconstraint' defined but not used: 1234 => 
	arch/x86/kernel/cpu/perf_event.c: warning: 'x86_get_event_constraints' defined but not used: 1237 => 
	arch/x86/kernel/cpu/perf_event.c: warning: 'x86_pmu_disable_all' defined but not used: 567 => 
	arch/x86/kernel/cpu/perf_event.c: warning: 'x86_pmu_enable_all' defined but not used: 602 => 
	arch/x86/kernel/cpu/perf_event.c: warning: 'x86_pmu_enable_event' defined but not used: 936 => 
	arch/x86/kernel/cpu/perf_event.c: warning: 'x86_pmu_handle_irq' defined but not used: 1120 => 
	arch/x86/kernel/cpu/perf_event.c: warning: 'x86_pmu_hw_config' defined but not used: 492 => 
	arch/x86/kernel/cpu/perf_event.c: warning: 'x86_schedule_events' defined but not used: 627 => 
	arch/xtensa/include/asm/pgalloc.h: warning: return makes pointer from integer without a cast: 47 => 
	crypto/testmgr.c: warning: 'alg_test_crc32c' uses dynamic stack allocation: 1488 => 
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
	drivers/input/keyboard/matrix_keypad.c: warning: 'matrix_keypad_resume' defined but not used: 242 => 
	drivers/input/keyboard/matrix_keypad.c: warning: 'matrix_keypad_suspend' defined but not used: 219 => 
	drivers/media/dvb/frontends/dib3000mc.c: warning: the frame size of 2192 bytes is larger than 2048 bytes: 853 => 
	drivers/media/dvb/frontends/dib7000p.c: warning: the frame size of 2272 bytes is larger than 2048 bytes: 1367 => 
	drivers/media/video/sh_mobile_ceu_camera.c: warning: 'ceu_sub_height' may be used uninitialized in this function: 1517 => 
	drivers/media/video/sh_mobile_ceu_camera.c: warning: 'ceu_sub_width' may be used uninitialized in this function: 1517 => 
	drivers/mfd/sh_mobile_sdhi.c: warning: 'sh_mobile_sdhi_remove' defined but not used: 142 => 
	drivers/mfd/twl4030-irq.c: warning: cast to pointer from integer of different size: 731 => 
	drivers/mfd/wm8350-regmap.c: warning: #warning MFD_WM8350_CONFIG_MODE_n options from the board driver.: 3178:2 => 
	drivers/mfd/wm8350-regmap.c: warning: #warning No WM8350 config modes supported - select at least one of the: 3177:2 => 
	drivers/misc/enclosure.c: warning: ignoring return value of 'ERR_PTR', declared with attribute warn_unused_result: 289 => 
	drivers/misc/hpilo.c: warning: 'ilo_remove' defined but not used: 720 => 
	drivers/misc/hpilo.c: warning: cast to pointer from integer of different size: 275 => 
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
	drivers/net/sh_eth.c: warning: 'ctrl_inl' is deprecated (declared at /scratch/kisskb/src/arch/sh/include/asm/io.h:104): 237, 808, 793, 315, 1205, 806, 811, 333, 339, 1251, 1148, 313, 316, 345, 888, 611, 954, 239, 314, 842, 1247, 857, 1203, 799, 1207, 803, 1215, 615, 765, 312, 317, 1077, 781 => 1266, 365, 1256, 860, 660, 842, 394, 288, 1128, 814, 363, 857, 830, 937, 891, 366, 388, 364, 1258, 286, 1003, 848, 361, 906, 362, 664, 382, 1254, 1199, 855, 852
	drivers/net/sh_eth.c: warning: 'ctrl_outl' is deprecated (declared at /scratch/kisskb/src/arch/sh/include/asm/io.h:124): 460, 598, 1261, 580, 869, 806, 1167, 609, 587, 1206, 1273, 1168, 1280, 1251, 1268, 601, 1282, 1267, 634, 611, 843, 584, 1164, 1266, 1263, 1262, 612, 1277, 290, 803, 1208, 606, 482, 766, 624, 293, 237, 1204, 638, 808, 1276, 641, 893, 1274, 1281, 1279, 811, 333, 339, 590, 618, 1259, 1265, 627, 954, 594, 239, 1216, 1247, 1264, 799, 1149, 782, 636, 577, 1260, 591, 1278, 603 => 892, 643, 685, 860, 673, 660, 942, 831, 288, 1218, 647, 1200, 667, 640, 650, 661, 918, 286, 339, 690, 676, 848, 655, 531, 1259, 687, 633, 1267, 1257, 815, 1255, 342, 626, 857, 639, 683, 388, 1215, 1219, 636, 1003, 509, 629, 652, 382, 855, 852, 658
	drivers/net/sh_eth.c: warning: unused variable 'i': 1389 => 
	drivers/net/wireless/iwlwifi/iwl-tx.c: warning: passing argument 1 of 'ieee80211_stop_tx_ba_cb_irqsafe' from incompatible pointer type: 1356 => 
	drivers/pci/pcie/aer/aerdrv_core.c: warning: 'e_src.id' may be used uninitialized in this function: 756 => 
	drivers/pci/pcie/aer/aerdrv_core.c: warning: 'e_src.status' may be used uninitialized in this function: 756 => 
	drivers/platform/x86/fujitsu-laptop.c: warning: 'pnp_ids' defined but not used: 1245 => 
	drivers/rtc/rtc-cmos.c: warning: #warning Assuming 128 bytes of RTC+NVRAM address space, not 64 bytes.: 697:2, 693:2 => 693:2
	drivers/serial/mpc52xx_uart.c: warning: cast to pointer from integer of different size: 1139, 812, 1272 => 
	drivers/sh/maple/maple.c: warning: 'ctrl_inl' is deprecated (declared at /scratch/kisskb/src/arch/sh/include/asm/io.h:104): 133 => 
	drivers/sh/maple/maple.c: warning: 'ctrl_outl' is deprecated (declared at /scratch/kisskb/src/arch/sh/include/asm/io.h:124): 109, 453, 99, 639, 278, 97, 108, 799, 110 => 
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
	fs/dcache.c: warning: control reaches end of non-void function: 1885, 1870, 1887 => 1899, 1887
	fs/ecryptfs/messaging.c: warning: 'daemon' may be used uninitialized in this function: 277 => 
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
	fs/quota/quota_tree.c: warning: format '%zd' expects type 'signed size_t', but argument 2 has type 'ssize_t': 376 => 
	fs/quota/quota_v2.c: warning: format '%zd' expects type 'signed size_t', but argument 3 has type 'ssize_t': 66 => 
	fs/squashfs/xattr.c: warning: 'squashfs_xattr_handler' declared inline after being called: 37 => 
	fs/squashfs/xattr.c: warning: previous declaration of 'squashfs_xattr_handler' was here: 37 => 
	fs/sysfs/dir.c: warning: 'sysfs_pathname' defined but not used: 411, 410 => 411
	include/config/auto.conf: warning: symbol value '' invalid for CROSS_COMPILE: 165, 4001, 428, 309, 3655, 297 => 149, 3707, 428, 307, 4062
	include/config/auto.conf: warning: symbol value '' invalid for DEFAULT_SECURITY: 147 => 
	include/linux/bio.h: warning: "ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE" is not defined: 398:5 => 
	include/linux/blkdev.h: warning: "ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE" is not defined: 764:5 => 
	include/trace/events/timer.h: warning: format '%lu' expects type 'long unsigned int', but argument 4 has type 'cputime_t': 279 => 
	include/trace/events/timer.h: warning: format '%lu' expects type 'long unsigned int', but argument 5 has type 'cputime_t': 316 => 
	kernel/irq/handle.c: warning:   CC      kernel/irq/spurious.o: 432:3 => 
	lib/decompress_bunzip2.c: warning: the frame size of 1824 bytes is larger than 1024 bytes: 511 => 
	lib/decompress_bunzip2.c: warning: the frame size of 1840 bytes is larger than 1024 bytes: 511 => 
	lib/decompress_bunzip2.c: warning: the frame size of 1876 bytes is larger than 1024 bytes: 511 => 
	lib/decompress_bunzip2.c: warning: the frame size of 1916 bytes is larger than 1024 bytes: 511 => 
	mm/memcontrol.c: warning: 'val' may be used uninitialized in this function: 3119, 2725 => 3192
	modpost: WARNING: modpost: Found 10 section mismatch(es).: N/A => 
	modpost: WARNING: modpost: Found 11 section mismatch(es).: N/A => 
	modpost: WARNING: modpost: Found 26 section mismatch(es).: N/A => 
	modpost: WARNING: modpost: Found 28 section mismatch(es).: N/A => 
	modpost: WARNING: modpost: Found 3 section mismatch(es).: N/A => 
	modpost: WARNING: modpost: Found 43 section mismatch(es).: N/A => 
	modpost: WARNING: modpost: Found 45 section mismatch(es).: N/A => 
	modpost: WARNING: modpost: Found 49 section mismatch(es).: N/A => 
	modpost: WARNING: modpost: Found 70 section mismatch(es).: N/A => 
	modpost: WARNING: modpost: Found 81 section mismatch(es).: N/A => 
	net/bluetooth/l2cap.c: warning: comparison is always false due to limited range of data type: 4150, 4145, 3826, 3873 => 
	net/sched/sch_generic.c: warning: unused variable 'drivername': 256 => 
	sound/i2c/other/ak4xxx-adda.c: warning: no return statement in function returning non-void: 903 => 
	sound/pci/ice1712/quartet.c: warning: 'get_binary' defined but not used: 211 => 
	sound/pcmcia/pdaudiocf/pdaudiocf.c: warning: 'pcmcia_request_exclusive_irq' is deprecated (declared at /scratch/kisskb/src/include/pcmcia/ds.h:191): 226 => 
	sound/pcmcia/pdaudiocf/pdaudiocf.c: warning: 'pcmcia_request_exclusive_irq' is deprecated (declared at /scratch/kisskb/src/include/pcmcia/ds.h:193): 226 => 
	sound/pcmcia/vx/vxpocket.c: warning: 'pcmcia_request_exclusive_irq' is deprecated (declared at /scratch/kisskb/src/include/pcmcia/ds.h:191): 233 => 
	sound/pcmcia/vx/vxpocket.c: warning: 'pcmcia_request_exclusive_irq' is deprecated (declared at /scratch/kisskb/src/include/pcmcia/ds.h:193): 233 => 
	sound/usb/format.c: warning: 'ret' may be used uninitialized in this function: 355 => 
	sound/usb/misc/ua101.c: warning: unused variable 'ua': 1172 => 

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
