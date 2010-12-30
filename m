Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755287Ab0L3TmS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Dec 2010 14:42:18 -0500
Received: from juliette.telenet-ops.be ([195.130.137.74]:52893 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754941Ab0L3TmP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Dec 2010 14:42:15 -0500
Date: Thu, 30 Dec 2010 20:42:10 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Build regressions/improvements in v2.6.37-rc8
Message-ID: <alpine.DEB.2.00.1012302040430.3899@ayla.of.borg>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Below is the list of build error/warning regressions/improvements in
v2.6.37-rc8[1] compared to v2.6.36[2].

Summarized:
  - build errors: +91/-11
  - build warnings: +245/-133

JFYI, when comparing v2.6.37-rc8 to v2.6.37-rc7[3] (both have full coverage
of the 108 configs), the summaries are:
  - build errors: +48/-7
  - build warnings: +121/-45

Note that there may be false regressions, as some logs are incomplete.
Still, they're build errors/warnings.

In addition, I put the verbose summary at
http://www.kernel.org/pub/linux/kernel/people/geert/linux-log/v2.6.37-rc8.summary.gz
so you can easily find out for which configs and architectures the
errors/warnings you're interested in are happening.

Happy fixing! ;-)

Thanks to the linux-next team for providing the build service.

[1] http://kisskb.ellerman.id.au/kisskb/head/3578/ (108 configs)
[2] http://kisskb.ellerman.id.au/kisskb/head/3363/ (97 out of 108 configs)
[3] http://kisskb.ellerman.id.au/kisskb/head/3560/ (108 configs)


*** ERRORS ***

91 regressions:
	error: vga16fb.c: undefined reference to `vgacon_remap_base':  => .devinit.text+0x1a08e), .devinit.text+0x1a092)
	src/arch/alpha/include/asm/io.h: error: 'arch_local_irq_restore' is static but used in inline function '__set_hae' which is not static:  => 49
	src/arch/alpha/include/asm/io.h: error: 'arch_local_irq_save' is static but used in inline function '__set_hae' which is not static:  => 41
	src/arch/cris/arch-v10/drivers/sync_serial.c: error: 'ret' undeclared (first use in this function):  => 628
	src/arch/cris/arch-v10/drivers/sync_serial.c: error: (Each undeclared identifier is reported only once:  => 628
	src/arch/cris/arch-v10/drivers/sync_serial.c: error: conflicting types for 'sync_serial_ioctl':  => 961
	src/arch/cris/arch-v10/drivers/sync_serial.c: error: for each function it appears in.):  => 628
	src/arch/cris/arch-v10/drivers/sync_serial.c: error: previous declaration of 'sync_serial_ioctl' was here:  => 161
	src/arch/cris/arch-v10/kernel/kgdb.c: error: expected string literal before '.' token:  => 1274
	src/arch/cris/arch-v10/kernel/kgdb.c: error: missing terminating " character:  => 1457, 1273, 1359, 1370
	src/arch/mips/include/asm/dma-mapping.h: error: conflicting types for 'dma_alloc_coherent':  => 60
	src/arch/mips/include/asm/dma-mapping.h: error: static declaration of 'dma_free_coherent' follows non-static declaration:  => 73
	src/arch/mips/include/asm/dma-mapping.h: error: static declaration of 'dma_mapping_error' follows non-static declaration:  => 39
	src/arch/mips/include/asm/dma-mapping.h: error: static declaration of 'dma_set_mask' follows non-static declaration:  => 46
	src/arch/mips/include/asm/dma-mapping.h: error: static declaration of 'dma_supported' follows non-static declaration:  => 33
	src/arch/mips/include/asm/io.h: error: 'asm' operand has impossible constraints:  => 430
	src/arch/mips/include/asm/mach-ip27/dma-coherence.h: error: implicit declaration of function 'BRIDGE_CONTROLLER':  => 24
	src/arch/mips/include/asm/mach-ip27/dma-coherence.h: error: invalid type argument of '->':  => 32, 24
	src/drivers/block/paride/kbic.c: error: invalid operands to binary | (have 'void *' and 'int'):  => 67, 85, 53, 57, 61, 91
	src/drivers/char/ipmi/ipmi_si_intf.c: error: invalid operands to binary << (have 'void *' and 'int'):  => 1381, 1396
	src/drivers/char/specialix.c: error: invalid operands to binary | (have 'void *' and 'int'):  => 237, 227
	src/drivers/char/tpm/tpm.h: error: invalid operands to binary & (have 'void *' and 'int'):  => 125
	src/drivers/char/tpm/tpm_tis.c: error: implicit declaration of function 'ioread32':  => 413
	src/drivers/char/tpm/tpm_tis.c: error: implicit declaration of function 'ioread8':  => 104
	src/drivers/char/tpm/tpm_tis.c: error: implicit declaration of function 'iowrite32':  => 422
	src/drivers/char/tpm/tpm_tis.c: error: implicit declaration of function 'iowrite8':  => 117
	src/drivers/i2c/busses/i2c-i801.c: error: implicit declaration of function 'kfree':  => 855
	src/drivers/i2c/busses/i2c-i801.c: error: implicit declaration of function 'kzalloc':  => 737
	src/drivers/i2c/busses/i2c-ocores.c: error: implicit declaration of function 'ioread8':  => 74
	src/drivers/i2c/busses/i2c-ocores.c: error: implicit declaration of function 'iowrite8':  => 69
	src/drivers/input/gameport/lightning.c: error: invalid operands to binary & (have 'void *' and 'int'):  => 177, 141, 86
	src/drivers/input/gameport/ns558.c: error: invalid operands to binary & (have 'void *' and 'int'):  => 84
	src/drivers/input/touchscreen/mk712.c: error: invalid operands to binary | (have 'void *' and 'int'):  => 129
	src/include/asm-generic/dma-mapping-common.h: error: conflicting types for 'dma_map_page':  => 73
	src/include/asm-generic/dma-mapping-common.h: error: static declaration of 'dma_sync_sg_for_cpu' follows non-static declaration:  => 141
	src/include/asm-generic/dma-mapping-common.h: error: static declaration of 'dma_sync_sg_for_device' follows non-static declaration:  => 153
	src/include/asm-generic/dma-mapping-common.h: error: static declaration of 'dma_sync_single_for_cpu' follows non-static declaration:  => 99
	src/include/asm-generic/dma-mapping-common.h: error: static declaration of 'dma_sync_single_for_device' follows non-static declaration:  => 111
	src/include/asm-generic/dma-mapping-common.h: error: static declaration of 'dma_unmap_page' follows non-static declaration:  => 87
	src/include/asm-generic/pci-dma-compat.h: error: implicit declaration of function 'dma_alloc_coherent':  => 19
	src/include/asm-generic/pci-dma-compat.h: error: implicit declaration of function 'dma_free_coherent':  => 26
	src/include/asm-generic/pci-dma-compat.h: error: implicit declaration of function 'dma_map_page':  => 46
	src/include/asm-generic/pci-dma-compat.h: error: implicit declaration of function 'dma_map_sg':  => 60
	src/include/asm-generic/pci-dma-compat.h: error: implicit declaration of function 'dma_map_single':  => 32
	src/include/asm-generic/pci-dma-compat.h: error: implicit declaration of function 'dma_mapping_error':  => 101
	src/include/asm-generic/pci-dma-compat.h: error: implicit declaration of function 'dma_set_coherent_mask':  => 112
	src/include/asm-generic/pci-dma-compat.h: error: implicit declaration of function 'dma_set_mask':  => 107
	src/include/asm-generic/pci-dma-compat.h: error: implicit declaration of function 'dma_supported':  => 12
	src/include/asm-generic/pci-dma-compat.h: error: implicit declaration of function 'dma_sync_sg_for_cpu':  => 88
	src/include/asm-generic/pci-dma-compat.h: error: implicit declaration of function 'dma_sync_sg_for_device':  => 95
	src/include/asm-generic/pci-dma-compat.h: error: implicit declaration of function 'dma_sync_single_for_cpu':  => 74
	src/include/asm-generic/pci-dma-compat.h: error: implicit declaration of function 'dma_sync_single_for_device':  => 81
	src/include/asm-generic/pci-dma-compat.h: error: implicit declaration of function 'dma_unmap_page':  => 53
	src/include/asm-generic/pci-dma-compat.h: error: implicit declaration of function 'dma_unmap_sg':  => 67
	src/include/asm-generic/pci-dma-compat.h: error: implicit declaration of function 'dma_unmap_single':  => 39
	src/include/asm-generic/pci-dma-compat.h: error: previous implicit declaration of 'dma_alloc_coherent' was here:  => 19
	src/include/asm-generic/pci-dma-compat.h: error: previous implicit declaration of 'dma_free_coherent' was here:  => 26
	src/include/asm-generic/pci-dma-compat.h: error: previous implicit declaration of 'dma_map_page' was here:  => 46
	src/include/asm-generic/pci-dma-compat.h: error: previous implicit declaration of 'dma_mapping_error' was here:  => 101
	src/include/asm-generic/pci-dma-compat.h: error: previous implicit declaration of 'dma_set_coherent_mask' was here:  => 112
	src/include/asm-generic/pci-dma-compat.h: error: previous implicit declaration of 'dma_set_mask' was here:  => 107
	src/include/asm-generic/pci-dma-compat.h: error: previous implicit declaration of 'dma_supported' was here:  => 12
	src/include/asm-generic/pci-dma-compat.h: error: previous implicit declaration of 'dma_sync_sg_for_cpu' was here:  => 88
	src/include/asm-generic/pci-dma-compat.h: error: previous implicit declaration of 'dma_sync_sg_for_device' was here:  => 95
	src/include/asm-generic/pci-dma-compat.h: error: previous implicit declaration of 'dma_sync_single_for_cpu' was here:  => 74
	src/include/asm-generic/pci-dma-compat.h: error: previous implicit declaration of 'dma_sync_single_for_device' was here:  => 81
	src/include/asm-generic/pci-dma-compat.h: error: previous implicit declaration of 'dma_unmap_page' was here:  => 53
	src/include/linux/dma-mapping.h: error: static declaration of 'dma_set_coherent_mask' follows non-static declaration:  => 109
	src/lib/atomic64_test.c: error: 'atomic64_t' undeclared (first use in this function):  => 24
	src/lib/atomic64_test.c: error: 'v' undeclared (first use in this function):  => 26
	src/lib/atomic64_test.c: error: (Each undeclared identifier is reported only once:  => 24
	src/lib/atomic64_test.c: error: expected ';' before 'v':  => 24
	src/lib/atomic64_test.c: error: for each function it appears in.):  => 24
	src/lib/atomic64_test.c: error: implicit declaration of function 'atomic64_add':  => 34
	src/lib/atomic64_test.c: error: implicit declaration of function 'atomic64_add_return':  => 45
	src/lib/atomic64_test.c: error: implicit declaration of function 'atomic64_add_unless':  => 108
	src/lib/atomic64_test.c: error: implicit declaration of function 'atomic64_cmpxchg':  => 99
	src/lib/atomic64_test.c: error: implicit declaration of function 'atomic64_dec':  => 84
	src/lib/atomic64_test.c: error: implicit declaration of function 'atomic64_dec_return':  => 90
	src/lib/atomic64_test.c: error: implicit declaration of function 'atomic64_inc':  => 74
	src/lib/atomic64_test.c: error: implicit declaration of function 'atomic64_inc_not_zero':  => 135
	src/lib/atomic64_test.c: error: implicit declaration of function 'atomic64_inc_return':  => 80
	src/lib/atomic64_test.c: error: implicit declaration of function 'atomic64_read':  => 31
	src/lib/atomic64_test.c: error: implicit declaration of function 'atomic64_set':  => 28
	src/lib/atomic64_test.c: error: implicit declaration of function 'atomic64_sub':  => 54
	src/lib/atomic64_test.c: error: implicit declaration of function 'atomic64_sub_return':  => 65
	src/lib/atomic64_test.c: error: implicit declaration of function 'atomic64_xchg':  => 94
	src/net/mac80211/led.c: error: dereferencing pointer to incomplete type:  => 74, 85, 63, 96
	src/net/mac80211/led.c: error: implicit declaration of function 'led_trigger_register':  => 64
	src/net/mac80211/led.c: error: implicit declaration of function 'led_trigger_unregister':  => 107
	src/net/mac80211/led.c: error: invalid application of 'sizeof' to incomplete type 'struct led_trigger' :  => 92, 81, 59, 70

11 improvements:
	/opt/crosstool/gcc-4.3.2-nolibc/bin/../lib/gcc/sh4-linux/4.3.2/../../../../sh4-linux/bin/ld: error in arch/sh/kernel/vsyscall/vsyscall-trapa.o(.eh_frame); no .eh_frame_hdr table will be created.: N/A => 
	init/Kconfig: error: recursive dependency detected!: 985 => 
	src/arch/mips/include/asm/bug.h: error: previous definition of 'BUG' was here: 12 => 
	src/arch/parisc/include/asm/spinlock.h: error: 'asm' operand has impossible constraints: 25 => 
	src/arch/parisc/include/asm/spinlock.h: error: can't find a register in class 'R1_REGS' while reloading 'asm': 25 => 
	src/arch/sh/include/asm/syscalls_32.h: error: previous declaration of 'sys_execve' was here: 22 => 
	src/arch/sh/kernel/process_32.c: error: conflicting types for 'sys_execve': 299 => 
	src/drivers/misc/lkdtm.c: error: 'BUG' redeclared as different kind of symbol: 70 => 
	src/drivers/misc/lkdtm.c: error: called object '2' is not a function: 281 => 
	src/drivers/net/3c59x.c: error: request for member 'current_state' in something not a structure or union: 3211 => 
	src/fs/ceph/mds_client.c: error: insn does not satisfy its constraints:: 3192 => 


*** WARNINGS ***

245 regressions:
	.config: warning: override: HIGHMEM4G changes choice state:  => 308
	arch/avr32/configs/atstk1002_defconfig: warning: symbol value 'm' invalid for LEDS_CLASS:  => 137
	arch/mips/configs/malta_defconfig: warning: symbol value 'm' invalid for LEDS_CLASS:  => 374
	modpost: WARNING: modpost: Found 11 section mismatch(es).:  => N/A
	modpost: WARNING: modpost: Found 16 section mismatch(es).:  => N/A
	modpost: WARNING: modpost: Found 17 section mismatch(es).:  => N/A
	modpost: WARNING: modpost: Found 47 section mismatch(es).:  => N/A
	modpost: WARNING: modpost: Found 66 section mismatch(es).:  => N/A
	src/arch/alpha/include/asm/io.h: warning: 'arch_local_irq_restore' is static but used in inline function '__set_hae' which is not static:  => 49
	src/arch/alpha/include/asm/io.h: warning: 'arch_local_irq_save' is static but used in inline function '__set_hae' which is not static:  => 41
	src/arch/cris/arch-v10/drivers/sync_serial.c: warning: initialization from incompatible pointer type:  => 252
	src/arch/cris/arch-v10/drivers/sync_serial.c: warning: passing argument 1 of 'memcpy' discards qualifiers from pointer target type:  => 1353, 1343
	src/arch/cris/arch-v10/drivers/sync_serial.c: warning: passing argument 1 of 'virt_to_phys' discards qualifiers from pointer target type:  => 1224
	src/arch/cris/arch-v10/kernel/kgdb.c: warning: missing terminating " character:  => 1359:1, 1273:6, 1457:1, 1370:6
	src/arch/cris/arch-v10/kernel/kgdb.c: warning: type defaults to 'int' in declaration of 'write_stack_register':  => 267
	src/arch/cris/arch-v32/mach-a3/pinmux.c: warning: ISO C90 forbids mixed declarations and code:  => 273, 96
	src/arch/mips/include/asm/dma-mapping.h: warning: conflicting types for 'dma_free_coherent':  => 73
	src/arch/mips/sibyte/bcm1480/smp.c: warning: passing argument 1 of '__cpus_clear' discards qualifiers from pointer target type:  => 149
	src/arch/s390/kvm/../../../virt/kvm/kvm_main.c: warning: 'entry' may be used uninitialized in this function:  => 1036
	src/arch/s390/kvm/../../../virt/kvm/kvm_main.c: warning: passing argument 3 of 'kvm_write_guest_page' makes pointer from integer without a cast:  => 1224
	src/arch/sh/include/asm/ptrace_32.h: warning: this is the location of the previous definition:  => 25:1
	src/arch/sh/kernel/cpu/sh2/../../entry-common.S: Warning: overflow in branch to __restore_all; converted into longer instruction sequence:  => 89
	src/arch/sh/kernel/cpu/sh2/../../entry-common.S: Warning: overflow in branch to syscall_call; converted into longer instruction sequence:  => 209
	src/arch/sh/kernel/cpu/sh2/../../entry-common.S: Warning: overflow in branch to syscall_exit_work; converted into longer instruction sequence:  => 364, 361
	src/arch/sh/kernel/cpu/sh2/../../entry-common.S: Warning: overflow in branch to syscall_trace_entry; converted into longer instruction sequence:  => 337, 335
	src/arch/sh/math-emu/math.c: warning: "READ" redefined:  => 56:1
	src/arch/sh/math-emu/math.c: warning: "WRITE" redefined:  => 55:1
	src/arch/x86/kernel/cpu/intel_cacheinfo.c: warning: 'cache_disable_0' defined but not used:  => 555
	src/arch/x86/kernel/cpu/intel_cacheinfo.c: warning: 'cache_disable_1' defined but not used:  => 557
	src/arch/x86/kernel/cpu/intel_cacheinfo.c: warning: 'this_leaf.size' may be used uninitialized in this function:  => 636
	src/arch/x86/kernel/dumpstack_64.c: warning: 'id' may be used uninitialized in this function:  => 182
	src/arch/x86/kernel/pci-gart_64.c: warning: 'info.aper_size' may be used uninitialized in this function:  => 745
	src/arch/x86/platform/scx200/scx200_32.c: warning: 'base' may be used uninitialized in this function:  => 82
	src/arch/xtensa/mm/tlb.c: warning: comparison of distinct pointer types lacks a cast:  => 71, 68
	src/drivers/acpi/acpica/exprep.c: warning: 'byte_alignment' may be used uninitialized in this function:  => 323
	src/drivers/acpi/power_meter.c: warning: 'val' may be used uninitialized in this function:  => 380
	src/drivers/acpi/scan.c: warning: 'type' may be used uninitialized in this function:  => 1372
	src/drivers/char/ip2/i2lib.c: warning: 'pCh' may be used uninitialized in this function:  => 1454
	src/drivers/char/tpm/tpm.c: warning: format '%zd' expects type 'signed size_t', but argument 3 has type 'ssize_t':  => 433, 400
	src/drivers/edac/i7300_edac.c: warning: 'nr_pages' may be used uninitialized in this function:  => 780
	src/drivers/gpio/pch_gpio.c: warning: 'pch_gpio_restore_reg_conf' defined but not used:  => 140
	src/drivers/gpio/pch_gpio.c: warning: 'pch_gpio_save_reg_conf' defined but not used:  => 131
	src/drivers/gpu/drm/drm_bufs.c: warning: 'master' may be used uninitialized in this function:  => 429
	src/drivers/gpu/drm/radeon/r600.c: warning: 'chip_name' may be used uninitialized in this function:  => 1937
	src/drivers/gpu/drm/radeon/r600.c: warning: 'rlc_chip_name' may be used uninitialized in this function:  => 1938
	src/drivers/gpu/drm/radeon/r600_cs.c: warning: 'base_align' may be used uninitialized in this function:  => 1169, 375, 239
	src/drivers/gpu/drm/radeon/r600_cs.c: warning: 'height_align' may be used uninitialized in this function:  => 238, 374
	src/drivers/gpu/drm/radeon/r600_cs.c: warning: 'pitch_align' may be used uninitialized in this function:  => 238, 1168, 374
	src/drivers/hid/hid-picolcd.c: warning: 'err' may be used uninitialized in this function:  => 1768
	src/drivers/hid/usbhid/hid-core.c: warning: 'field' may be used uninitialized in this function:  => 757
	src/drivers/hwmon/adm1031.c: warning: 'reg' may be used uninitialized in this function:  => 287
	src/drivers/hwmon/lm90.c: warning: 'chip_id' may be used uninitialized in this function:  => 1092
	src/drivers/hwmon/lm90.c: warning: 'reg_config1' may be used uninitialized in this function:  => 1092
	src/drivers/hwmon/lm90.c: warning: 'reg_convrate' may be used uninitialized in this function:  => 1092
	src/drivers/hwmon/lm90.c: warning: 'reg_emerg2' may be used uninitialized in this function:  => 1159
	src/drivers/hwmon/lm90.c: warning: 'reg_status2' may be used uninitialized in this function:  => 1159
	src/drivers/hwmon/w83795.c: warning: 'lsb' may be used uninitialized in this function:  => 483
	src/drivers/i2c/busses/i2c-i801.c: warning: assignment makes pointer from integer without a cast:  => 737
	src/drivers/ide/ide-io-std.c: warning: statement with no effect:  => 200, 185
	src/drivers/infiniband/hw/mlx4/qp.c: warning: 'vlan' may be used uninitialized in this function:  => 1304
	src/drivers/infiniband/hw/nes/nes.c: warning: ignoring return value of 'strict_strtoul', declared with attribute warn_unused_result:  => 1115
	src/drivers/input/input.c: warning: 'index' may be used uninitialized in this function:  => 737, 708
	src/drivers/input/input.c: warning: 'scancode' may be used uninitialized in this function:  => 852
	src/drivers/isdn/gigaset/capi.c: warning: 'format_ie' defined but not used:  => 301
	src/drivers/isdn/i4l/isdn_common.c: warning: unused variable 's':  => 1285
	src/drivers/leds/leds-lp5521.c: warning: 'engine_state' may be used uninitialized in this function:  => 169
	src/drivers/leds/leds-lp5523.c: warning: 'adc' may be used uninitialized in this function:  => 435
	src/drivers/leds/leds-lp5523.c: warning: 'vdd' may be used uninitialized in this function:  => 435
	src/drivers/media/IR/ir-keytable.c: warning: 'retval' may be used uninitialized in this function:  => 244
	src/drivers/media/IR/ir-sysfs.c: warning: 'mask' may be used uninitialized in this function:  => 126
	src/drivers/media/dvb/frontends/af9013.c: warning: 'ret' may be used uninitialized in this function:  => 1011
	src/drivers/media/video/cx88/cx88-i2c.c: warning: 'id' is deprecated (declared at /scratch/kisskb/src/include/linux/i2c.h:356):  => 149
	src/drivers/media/video/cx88/cx88-vp3054-i2c.c: warning: 'id' is deprecated (declared at /scratch/kisskb/src/include/linux/i2c.h:356):  => 128
	src/drivers/mfd/mc13xxx-core.c: warning: 'id' may be used uninitialized in this function:  => 716
	src/drivers/misc/apds990x.c: warning: 'apds990x_chip_on' defined but not used:  => 612
	src/drivers/misc/apds990x.c: warning: 'apds990x_resume' defined but not used:  => 1216
	src/drivers/misc/apds990x.c: warning: 'apds990x_suspend' defined but not used:  => 1207
	src/drivers/misc/bh1770glc.c: warning: 'bh1770_resume' defined but not used:  => 1325
	src/drivers/misc/bh1770glc.c: warning: 'bh1770_suspend' defined but not used:  => 1315
	src/drivers/misc/bh1770glc.c: warning: 'mode' may be used uninitialized in this function:  => 469
	src/drivers/misc/pch_phub.c: warning: 'pch_phub_restore_reg_conf' defined but not used:  => 180
	src/drivers/misc/pch_phub.c: warning: 'pch_phub_save_reg_conf' defined but not used:  => 121
	src/drivers/misc/vmw_balloon.c: warning: 'target' may be used uninitialized in this function:  => 654
	src/drivers/net/atl1c/atl1c_main.c: warning: 'atl1c_resume' defined but not used:  => 2542
	src/drivers/net/bna/bnad.c: warning: 'using_dac' may be used uninitialized in this function:  => 3035
	src/drivers/net/can/pch_can.c: warning: 'pch_can_get_int_enables' defined but not used:  => 269
	src/drivers/net/can/pch_can.c: warning: 'pch_can_get_rx_buffer_link' defined but not used:  => 480
	src/drivers/net/can/pch_can.c: warning: 'pch_can_get_rx_enable' defined but not used:  => 420
	src/drivers/net/can/pch_can.c: warning: 'pch_can_get_tx_enable' defined but not used:  => 438
	src/drivers/net/can/pch_can.c: warning: 'pch_can_set_int_custom' defined but not used:  => 258
	src/drivers/net/can/pch_can.c: warning: 'pch_can_set_rx_buffer_link' defined but not used:  => 462
	src/drivers/net/enic/enic_main.c: warning: passing argument 3 of 'pci_alloc_consistent' from incompatible pointer type:  => 2057, 2083
	src/drivers/net/macvtap.c: warning: control reaches end of non-void function:  => 102
	src/drivers/net/pcmcia/ibmtr_cs.c: warning: 'pcmcia_request_exclusive_irq' is deprecated (declared at /scratch/kisskb/src/include/pcmcia/ds.h:201):  => 195
	src/drivers/net/pcmcia/nmclan_cs.c: warning: 'pcmcia_request_exclusive_irq' is deprecated (declared at /scratch/kisskb/src/include/pcmcia/ds.h:201):  => 628
	src/drivers/net/pcmcia/nmclan_cs.c: warning: 'pcmcia_request_exclusive_irq' is deprecated (declared at /scratch/kisskb/src/include/pcmcia/ds.h:203):  => 628
	src/drivers/net/sky2.c: warning: control reaches end of non-void function:  => 2992
	src/drivers/net/stmmac/stmmac_main.c: warning: ignoring return value of 'strict_strtoul', declared with attribute warn_unused_result:  => 1948, 1957, 1952, 1938, 1945, 1954, 1950, 1940, 1942
	src/drivers/net/usb/hso.c: warning: unused variable 'uarg':  => 1744
	src/drivers/net/wireless/ath/carl9170/phy.c: warning: control reaches end of non-void function:  => 1604
	src/drivers/pci/pcie/portdrv_core.c: warning: 'cap_mask' may be used uninitialized in this function:  => 241
	src/drivers/power/twl4030_charger.c: warning: overflow in implicit constant conversion:  => 477, 485
	src/drivers/scsi/aha152x.c: warning: cast from pointer to integer of different size:  => 2979
	src/drivers/scsi/lpfc/lpfc_bsg.c: warning: 'rpi' may be used uninitialized in this function:  => 2105
	src/drivers/tty/vt/consolemap.c: warning: 'h' may be used uninitialized in this function:  => 699
	src/drivers/tty/vt/keyboard.c: warning: comparison is always true due to limited range of data type:  => 736
	src/drivers/tty/vt/vt_ioctl.c: warning: 'cc' may be used uninitialized in this function:  => 1122
	src/drivers/uio/uio.c: warning: passing argument 1 of 'virt_to_phys' makes pointer from integer without a cast:  => 631
	src/drivers/usb/core/inode.c: warning: 'dentry' may be used uninitialized in this function:  => 532
	src/drivers/usb/serial/keyspan_pda.c: warning: 'fw' may be used uninitialized in this function:  => 763
	src/drivers/usb/serial/mos7720.c: warning: 'divisor' may be used uninitialized in this function:  => 1545
	src/drivers/usb/serial/mos7720.c: warning: 'status' may be used uninitialized in this function:  => 1343, 1381
	src/drivers/video/aty/aty128fb.c: warning: 'backlight' defined but not used:  => 362
	src/drivers/video/aty/aty128fb.c: warning: 'crtc.bpp' may be used uninitialized in this function:  => 1518
	src/drivers/video/aty/aty128fb.c: warning: 'crtc.depth' may be used uninitialized in this function:  => 1518
	src/drivers/video/aty/aty128fb.c: warning: 'crtc.gen_cntl' may be used uninitialized in this function:  => 1518
	src/drivers/video/aty/aty128fb.c: warning: 'crtc.h_sync_strt_wid' may be used uninitialized in this function:  => 1518
	src/drivers/video/aty/aty128fb.c: warning: 'crtc.h_total' may be used uninitialized in this function:  => 1518
	src/drivers/video/aty/aty128fb.c: warning: 'crtc.offset_cntl' may be used uninitialized in this function:  => 1518
	src/drivers/video/aty/aty128fb.c: warning: 'crtc.pitch' may be used uninitialized in this function:  => 1518
	src/drivers/video/aty/aty128fb.c: warning: 'crtc.v_sync_strt_wid' may be used uninitialized in this function:  => 1518
	src/drivers/video/aty/aty128fb.c: warning: 'crtc.v_total' may be used uninitialized in this function:  => 1518
	src/drivers/video/aty/aty128fb.c: warning: 'crtc.vxres' may be used uninitialized in this function:  => 1518
	src/drivers/video/aty/aty128fb.c: warning: 'crtc.vyres' may be used uninitialized in this function:  => 1518
	src/drivers/video/aty/aty128fb.c: warning: 'crtc.xoffset' may be used uninitialized in this function:  => 1518
	src/drivers/video/aty/aty128fb.c: warning: 'crtc.yoffset' may be used uninitialized in this function:  => 1518
	src/drivers/video/aty/aty128fb.c: warning: 'fifo_reg.dda_config' may be used uninitialized in this function:  => 1520
	src/drivers/video/aty/aty128fb.c: warning: 'fifo_reg.dda_on_off' may be used uninitialized in this function:  => 1520
	src/drivers/video/aty/atyfb_base.c: warning: 'ram_dram' defined but not used:  => 538
	src/drivers/video/aty/atyfb_base.c: warning: 'ram_resv' defined but not used:  => 539
	src/drivers/video/backlight/adp5520_bl.c: warning: ignoring return value of 'strict_strtoul', declared with attribute warn_unused_result:  => 215
	src/drivers/video/fsl-diu-fb.c: warning: format '%08x' expects type 'unsigned int', but argument 5 has type 'resource_size_t':  => 1538
	src/drivers/video/sh_mobile_lcdcfb.c: warning: format '%u' expects type 'unsigned int', but argument 11 has type 'long unsigned int':  => 922
	src/drivers/video/sis/sis_main.c: warning: unused variable 'temp':  => 4108
	src/drivers/video/via/via_i2c.c: warning: 'id' is deprecated (declared at /scratch/kisskb/src/include/linux/i2c.h:356):  => 212
	src/drivers/video/via/viafbdev.c: warning: ignoring return value of 'strict_strtoul', declared with attribute warn_unused_result:  => 1380, 1214, 1417, 1311, 1144, 1272
	src/drivers/video/via/viafbdev.c: warning: unused variable 'iga1_entry':  => 1626
	src/drivers/video/via/viafbdev.c: warning: unused variable 'iga2_entry':  => 1627
	src/drivers/xen/events.c: warning: 'find_unbound_pirq' defined but not used:  => 387
	src/drivers/xen/grant-table.c: warning: 'rc' may be used uninitialized in this function:  => 85
	src/fs/9p/acl.c: warning: 'name' may be used uninitialized in this function:  => 122
	src/fs/cifs/asn1.c: warning: 'ch' may be used uninitialized in this function:  => 403, 170, 189, 250, 153
	src/fs/cifs/readdir.c: warning: 'current_entry' may be used uninitialized in this function:  => 774
	src/fs/cifs/xattr.c: warning: format '%zd' expects type 'signed size_t', but argument 3 has type 'ssize_t':  => 306
	src/fs/coda/sysctl.c: warning: 'coda_table' defined but not used:  => 18
	src/fs/eventpoll.c: warning: 'slack' may be used uninitialized in this function:  => 1119
	src/fs/exec.c: warning: 'len' may be used uninitialized in this function:  => 440
	src/fs/ext4/super.c: warning: 'ret' may be used uninitialized in this function:  => 2919
	src/fs/gfs2/inode.c: warning: 'inode' may be used uninitialized in this function:  => 208
	src/fs/locks.c: warning: 'lock' may be used uninitialized in this function:  => 1614
	src/fs/nfs/callback.c: warning: ISO C90 forbids mixed declarations and code:  => 352
	src/fs/nfs/file.c: warning: unused variable 'count':  => 234
	src/fs/nfs/file.c: warning: unused variable 'dentry':  => 140
	src/fs/nfs/fscache.c: warning: 'ulen' may be used uninitialized in this function:  => 73
	src/fs/nfs/fscache.c: warning: unused variable 'old':  => 332
	src/fs/nfs/nfs4xdr.c: warning: 'attrlen' may be used uninitialized in this function:  => 4164, 4074
	src/fs/nfs/nfs4xdr.c: warning: 'len' may be used uninitialized in this function:  => 6166
	src/fs/nfs/nfs4xdr.c: warning: 'savep' may be used uninitialized in this function:  => 4073, 4163
	src/fs/notify/fanotify/fanotify.c: warning: 'marks_ignored_mask' may be used uninitialized in this function:  => 167
	src/fs/notify/fanotify/fanotify.c: warning: 'marks_mask' may be used uninitialized in this function:  => 167
	src/include/asm-generic/dma-mapping-common.h: warning: conflicting types for 'dma_sync_sg_for_cpu':  => 141
	src/include/asm-generic/dma-mapping-common.h: warning: conflicting types for 'dma_sync_sg_for_device':  => 153
	src/include/asm-generic/dma-mapping-common.h: warning: conflicting types for 'dma_sync_single_for_cpu':  => 99
	src/include/asm-generic/dma-mapping-common.h: warning: conflicting types for 'dma_sync_single_for_device':  => 111
	src/include/asm-generic/dma-mapping-common.h: warning: conflicting types for 'dma_unmap_page':  => 87
	src/include/asm-generic/pci-dma-compat.h: warning: return makes pointer from integer without a cast:  => 19
	src/include/linux/fs.h: warning: this is the location of the previous definition:  => 160:1, 159:1
	src/include/linux/sunrpc/cache.h: warning: 'rv' may be used uninitialized in this function:  => 247
	src/include/net/ipx.h: warning: 'packed' attribute ignored for field of type '__be16':  => 32, 30
	src/include/net/ipx.h: warning: 'packed' attribute ignored for field of type 'struct ipx_address':  => 42, 41
	src/include/net/netfilter/xt_log.h: warning: value computed is not used:  => 50
	src/include/net/netlink.h: warning: 'len' is used uninitialized in this function:  => 647
	src/ipc/sem.c: warning: 'undo_list' may be used uninitialized in this function:  => 1501
	src/kernel/debug/debug_core.c: warning: value computed is not used:  => 512, 497
	src/kernel/futex.c: warning: 'entry' may be used uninitialized in this function:  => 2491
	src/kernel/futex.c: warning: 'pending' may be used uninitialized in this function:  => 2491
	src/kernel/futex.c: warning: 'pi' may be used uninitialized in this function:  => 2492
	src/kernel/futex.c: warning: 'pip' may be used uninitialized in this function:  => 2492
	src/kernel/module.c: warning: 'hdr' may be used uninitialized in this function:  => 2111
	src/kernel/ptrace.c: warning: 'kiov.iov_len' may be used uninitialized in this function:  => 655
	src/kernel/sched.c: warning: control may reach end of non-void function 'pick_next_task' being inlined:  => 4120
	src/kernel/sched.c: warning: control reaches end of non-void function:  => 4062
	src/kernel/workqueue.c: warning: 'last_gcwq' may be used uninitialized in this function:  => 951
	src/lib/atomic64_test.c: warning: ISO C90 forbids mixed declarations and code:  => 25
	src/lib/debugobjects.c: warning: 'obj_states' defined but not used:  => 73
	src/net/ceph/messenger.c: warning: 'proto' may be used uninitialized in this function:  => 641
	src/net/core/neighbour.c: warning: 'error' may be used uninitialized in this function:  => 464
	src/net/core/neighbour.c: warning: 'neigh' may be used uninitialized in this function:  => 1304
	src/net/core/skbuff.c: warning: 'err' may be used uninitialized in this function:  => 1062
	src/net/ipv4/af_inet.c: warning: value computed is not used:  => 239
	src/net/ipv4/inet_connection_sock.c: warning: 'head' may be used uninitialized in this function:  => 95
	src/net/ipv4/ip_options.c: warning: 'faddr' may be used uninitialized in this function:  => 161
	src/net/ipv4/ip_output.c: warning: 'left' may be used uninitialized in this function:  => 1035
	src/net/ipv4/raw.c: warning: 'node' may be used uninitialized in this function:  => 112
	src/net/ipv4/syncookies.c: warning: 'mss' may be used uninitialized in this function:  => 276
	src/net/ipv4/udp.c: warning: 'node' may be used uninitialized in this function:  => 542
	src/net/irda/irnet/irnet_ppp.c: warning: format '%Zd' expects type 'signed size_t', but argument 3 has type 'ssize_t':  => 331
	src/net/netfilter/nf_conntrack_core.c: warning: value computed is not used:  => 618
	src/net/netfilter/xt_socket.c: warning: 'daddr' may be used uninitialized in this function:  => 253
	src/net/netfilter/xt_socket.c: warning: 'dport' may be used uninitialized in this function:  => 254
	src/net/netfilter/xt_socket.c: warning: 'saddr' may be used uninitialized in this function:  => 253
	src/net/netfilter/xt_socket.c: warning: 'sport' may be used uninitialized in this function:  => 254
	src/net/sunrpc/auth_gss/svcauth_gss.c: warning: 'N' may be used uninitialized in this function:  => 460
	src/net/sunrpc/auth_gss/svcauth_gss.c: warning: 'tmpobj.data' may be used uninitialized in this function:  => 1002
	src/net/sunrpc/auth_gss/svcauth_gss.c: warning: 'tmpobj.len' may be used uninitialized in this function:  => 1002
	src/net/sunrpc/rpcb_clnt.c: warning: unused variable 'task':  => 790, 748, 723, 699, 822
	src/net/sunrpc/svcauth.c: warning: 'aops' may be used uninitialized in this function:  => 40
	src/net/sunrpc/svcauth_unix.c: warning: 'gid' may be used uninitialized in this function:  => 602
	src/net/sunrpc/svcauth_unix.c: warning: 'gids' may be used uninitialized in this function:  => 573
	src/net/sunrpc/svcauth_unix.c: warning: 'uid' may be used uninitialized in this function:  => 572
	src/net/xfrm/xfrm_policy.c: warning: 'dst_ops' may be used uninitialized in this function:  => 1325
	src/net/xfrm/xfrm_state.c: warning: 'x0' may be used uninitialized in this function:  => 796
	src/security/selinux/selinuxfs.c: warning: passing argument 2 of 'security_read_policy' from incompatible pointer type:  => 390
	src/sound/oss/pss.c: warning: 'check_region' is deprecated (declared at /scratch/kisskb/src/include/linux/ioport.h:170):  => 676
	src/sound/oss/sequencer.c: warning: 'err' may be used uninitialized in this function:  => 1325
	src/sound/pci/ctxfi/ctvmem.c: warning: 'entry' may be used uninitialized in this function:  => 34, 80
	src/sound/pcmcia/pdaudiocf/pdaudiocf.c: warning: 'pcmcia_request_exclusive_irq' is deprecated (declared at /scratch/kisskb/src/include/pcmcia/ds.h:201):  => 226
	src/sound/pcmcia/pdaudiocf/pdaudiocf.c: warning: 'pcmcia_request_exclusive_irq' is deprecated (declared at /scratch/kisskb/src/include/pcmcia/ds.h:203):  => 226
	src/sound/pcmcia/vx/vxpocket.c: warning: 'pcmcia_request_exclusive_irq' is deprecated (declared at /scratch/kisskb/src/include/pcmcia/ds.h:201):  => 232
	src/sound/pcmcia/vx/vxpocket.c: warning: 'pcmcia_request_exclusive_irq' is deprecated (declared at /scratch/kisskb/src/include/pcmcia/ds.h:203):  => 232
	src/sound/soc/codecs/wm8985.c: warning: 'pll_div.div2' may be used uninitialized in this function:  => 785
	src/sound/soc/codecs/wm8985.c: warning: 'pll_div.k' may be used uninitialized in this function:  => 785
	src/sound/soc/codecs/wm8985.c: warning: 'pll_div.n' may be used uninitialized in this function:  => 785
	warning: (ATH5K && NETDEVICES && WLAN && ATH_COMMON && PCI && MAC80211 || ATH9K && NETDEVICES && WLAN && ATH_COMMON && PCI && MAC80211 || ATH9K_HTC && NETDEVICES && WLAN && ATH_COMMON && USB && MAC80211 || CARL9170_LEDS && NETDEVICES && WLAN && ATH_COMMON && CARL9170) selects MAC80211_LEDS which has unmet direct dependencies (NET && WIRELESS && MAC80211 && LEDS_CLASS):  => N/A
	warning: (AX88796_93CX6 && NETDEVICES && NET_ETHERNET && AX88796 || RTL8180 && NETDEVICES && WLAN && MAC80211 && PCI && EXPERIMENTAL || RTL8187 && NETDEVICES && WLAN && MAC80211 && USB || ADM8211 && NETDEVICES && WLAN && MAC80211 && PCI && EXPERIMENTAL || RT2400PCI && NETDEVICES && WLAN && RT2X00 && PCI || RT2500PCI && NETDEVICES && WLAN && RT2X00 && PCI || RT61PCI && NETDEVICES && WLAN && RT2X00 && PCI || RT2800PCI && NETDEVICES && WLAN && RT2X00 && (RT2800PCI_PCI || RT2800PCI_SOC) && EXPERIMENTAL || R8187SE && STAGING && !STAGING_EXCLUDE_BUILD && PCI && WLAN) selects EEPROM_93CX6 which has unmet direct dependencies (MISC_DEVICES):  => N/A
	warning: (CAVIUM_OCTEON_REFERENCE_BOARD && <choice> || BCM63XX_CPU_6338 && BCM63XX) selects USB_ARCH_HAS_OHCI which has unmet direct dependencies (USB_SUPPORT):  => N/A
	warning: (CAVIUM_OCTEON_REFERENCE_BOARD && <choice>) selects USB_ARCH_HAS_EHCI which has unmet direct dependencies (USB_SUPPORT):  => N/A
	warning: (COMPAT && SPARC64) selects COMPAT_BINFMT_ELF which has unmet direct dependencies (COMPAT && BINFMT_ELF):  => N/A
	warning: (CRYPTO_LRW && CRYPTO && EXPERIMENTAL || CRYPTO_XTS && CRYPTO && EXPERIMENTAL || CRYPTO_GHASH && CRYPTO) selects CRYPTO_GF128MUL which has unmet direct dependencies (CRYPTO && EXPERIMENTAL):  => N/A
	warning: (EP8248E && PPC_82xx || MPC85xx_MDS && FSL_SOC_BOOKE && PPC32 || NET_DSA && NET && EXPERIMENTAL && NETDEVICES && !S390 || MACB && NETDEVICES && NET_ETHERNET && HAVE_NET_MACB || IXP4XX_ETH && NETDEVICES && NET_ETHERNET && ARM && ARCH_IXP4XX && IXP4XX_NPE && IXP4XX_QMGR || W90P910_ETH && NETDEVICES && NET_ETHERNET && ARM && ARCH_W90X900 || MIPS_AU1X00_ENET && NETDEVICES && NET_ETHERNET && MIPS_ALCHEMY || SH_ETH && NETDEVICES && NET_ETHERNET && SUPERH && (CPU_SUBTYPE_SH7710 || CPU_SUBTYPE_SH7712 || CPU_SUBTYPE_SH7763 || CPU_SUBTYPE_SH7619 || CPU_SUBTYPE_SH7724 || CPU_SUBTYPE_SH7757) || BFIN_MAC && NETDEVICES && NET_ETHERNET && (BF516 || BF518 || BF526 || BF527 || BF536 || BF537) || PXA168_ETH && NETDEVICES && NET_ETHERNET && CPU_PXA168 || TI_DAVINCI_EMAC && NETDEVICES && NET_ETHERNET && ARM && (ARCH_DAVINCI || ARCH_OMAP3) || TI_DAVINCI_MDIO && NETDEVICES && NET_ETHERNET && ARM && (ARCH_DAVINCI || ARCH_OMAP3) || ETHOC && NETDEVICES && NET_ETHERNET && HAS_IOMEM && HAS_DMA || GRETH && NETDEVICES && NET_ETHERNET && SPARC || SMSC911X && NETDEVICES && NET_ETHERNET && (ARM || SUPERH || BLACKFIN || MIPS || MN10300) || DNET && NETDEVICES && NET_ETHERNET && HAS_IOMEM || TC35815 && NETDEVICES && NET_ETHERNET && NET_PCI && PCI && MIPS || R6040 && NETDEVICES && NET_ETHERNET && NET_PCI && PCI || SMSC9420 && NETDEVICES && NET_ETHERNET && NET_PCI && PCI || CPMAC && NETDEVICES && NET_ETHERNET && EXPERIMENTAL && AR7 || FEC && NETDEVICES && NET_ETHERNET && (M523x || M527x || M5272 || M528x || M520x || M532x || MACH_MX27 || ARCH_MX35 || ARCH_MX25 || ARCH_MX5) || FEC_MPC52xx && NETDEVICES && NET_ETHERNET && PPC_MPC52xx && PPC_BESTCOMM || XILINX_EMACLITE && NETDEVICES && NET_ETHERNET && (PPC32 || MICROBLAZE) || BCM63XX_ENET && NETDEVICES && NET_ETHERNET && BCM63XX || FS_ENET && NETDEVICES && NET_ETHERNET && (CPM1 || CPM2 || PPC_MPC512x) || OCTEON_MGMT_ETHERNET && NETDEVICES && NET_ETHERNET && CPU_CAVIUM_OCTEON || SB1250_MAC && NETDEVICES && NETDEV_1000 && SIBYTE_SB1xxx_SOC || TIGON3 && NETDEVICES && NETDEV_1000 && PCI !
 || FSL_PQ_MDIO && NETDEVICES && NETDEV_1000 && FSL_SOC || GIANFAR && NETDEVICES && NETDEV_1000 && FSL_SOC || UCC_GETH && NETDEVICES && NETDEV_1000 && QUICC_ENGINE || MV643XX_ETH && NETDEVICES && NETDEV_1000 && (MV64X60 || PPC32 || PLAT_ORION) && INET || XILINX_LL_TEMAC && NETDEVICES && NETDEV_1000 && (PPC || MICROBLAZE) || S6GMAC && NETDEVICES && NETDEV_1000 && XTENSA_VARIANT_S6000 || STMMAC_ETH && NETDEV_1000 && NETDEVICES && HAS_IOMEM || PASEMI_MAC && NETDEVICES && NETDEV_10000 && PPC_PASEMI && PCI && INET || OCTEON_ETHERNET && STAGING && !STAGING_EXCLUDE_BUILD && CPU_CAVIUM_OCTEON && NETDEVICES) selects PHYLIB which has unmet direct dependencies (!S390 && NETDEVICES):  => N/A
	warning: (EP8248E && PPC_82xx || SH_ETH && NETDEVICES && NET_ETHERNET && SUPERH && (CPU_SUBTYPE_SH7710 || CPU_SUBTYPE_SH7712 || CPU_SUBTYPE_SH7763 || CPU_SUBTYPE_SH7619 || CPU_SUBTYPE_SH7724 || CPU_SUBTYPE_SH7757) || FS_ENET_MDIO_FCC && NETDEVICES && NET_ETHERNET && FS_ENET && CPM2) selects MDIO_BITBANG which has unmet direct dependencies (NETDEVICES && PHYLIB):  => N/A
	warning: (ETRAX_USB_HOST && ETRAX_ARCH_V10 || MOUSE_APPLETOUCH && !S390 && INPUT && INPUT_MOUSE && USB_ARCH_HAS_HCD || MOUSE_BCM5974 && !S390 && INPUT && INPUT_MOUSE && USB_ARCH_HAS_HCD || JOYSTICK_XPAD && !S390 && INPUT && INPUT_JOYSTICK && USB_ARCH_HAS_HCD || TABLET_USB_ACECAD && !S390 && INPUT && INPUT_TABLET && USB_ARCH_HAS_HCD || TABLET_USB_AIPTEK && !S390 && INPUT && INPUT_TABLET && USB_ARCH_HAS_HCD || TABLET_USB_HANWANG && !S390 && INPUT && INPUT_TABLET && USB_ARCH_HAS_HCD || TABLET_USB_KBTAB && !S390 && INPUT && INPUT_TABLET && USB_ARCH_HAS_HCD || TABLET_USB_WACOM && !S390 && INPUT && INPUT_TABLET && USB_ARCH_HAS_HCD || TOUCHSCREEN_USB_COMPOSITE && !S390 && INPUT && INPUT_TOUCHSCREEN && USB_ARCH_HAS_HCD || INPUT_ATI_REMOTE && !S390 && INPUT && INPUT_MISC && USB_ARCH_HAS_HCD || INPUT_ATI_REMOTE2 && !S390 && INPUT && INPUT_MISC && USB_ARCH_HAS_HCD || INPUT_KEYSPAN_REMOTE && !S390 && INPUT && INPUT_MISC && EXPERIMENTAL && USB_ARCH_HAS_HCD || INPUT_POWERMATE && !S390 && INPUT && INPUT_MISC && USB_ARCH_HAS_HCD || INPUT_YEALINK && !S390 && INPUT && INPUT_MISC && EXPERIMENTAL && USB_ARCH_HAS_HCD || INPUT_CM109 && !S390 && INPUT && INPUT_MISC && EXPERIMENTAL && USB_ARCH_HAS_HCD) selects USB which has unmet direct dependencies (USB_SUPPORT && USB_ARCH_HAS_HCD):  => N/A
	warning: (I2C_ISCH && I2C && PCI || GPIO_SCH && GPIOLIB && PCI || GPIO_VX855 && GPIOLIB || GPIO_RDC321X && PCI && GPIOLIB || MFD_88PM860X && MFD_SUPPORT && I2C=y && GENERIC_HARDIRQS || MFD_ASIC3 && MFD_SUPPORT && GENERIC_HARDIRQS && GPIOLIB && ARM || MFD_SH_MOBILE_SDHI && MFD_SUPPORT && (SUPERH || ARCH_SHMOBILE) || MFD_DAVINCI_VOICECODEC && MFD_SUPPORT || HTC_PASIC3 && MFD_SUPPORT || TPS6507X && MFD_SUPPORT && I2C || TWL4030_CODEC && MFD_SUPPORT && TWL4030_CORE || MFD_STMPE && MFD_SUPPORT && I2C=y && GENERIC_HARDIRQS || MFD_TC35892 && MFD_SUPPORT && I2C=y && GENERIC_HARDIRQS || MFD_T7L66XB && MFD_SUPPORT && ARM && HAVE_CLK || MFD_TC6387XB && MFD_SUPPORT && ARM && HAVE_CLK || MFD_TC6393XB && MFD_SUPPORT && GPIOLIB && ARM || MFD_MAX8925 && MFD_SUPPORT && I2C=y && GENERIC_HARDIRQS || MFD_MAX8998 && MFD_SUPPORT && I2C=y && GENERIC_HARDIRQS || MFD_WM8400 && MFD_SUPPORT && I2C || MFD_WM831X_I2C && MFD_SUPPORT && I2C=y && GENERIC_HARDIRQS || MFD_WM831X_SPI && MFD_SUPPORT && SPI_MASTER && GENERIC_HARDIRQS || MFD_WM8994 && MFD_SUPPORT && I2C=y && GENERIC_HARDIRQS || MFD_MC13XXX && MFD_SUPPORT && SPI_MASTER || AB3100_CORE && MFD_SUPPORT && I2C=y && ABX500_CORE || AB8500_CORE && MFD_SUPPORT && GENERIC_HARDIRQS && ABX500_CORE && SPI_MASTER && ARCH_U8500 || AB3550_CORE && MFD_SUPPORT && I2C=y && GENERIC_HARDIRQS && ABX500_CORE || MFD_TIMBERDALE && MFD_SUPPORT && PCI && GPIOLIB || LPC_SCH && MFD_SUPPORT && PCI || MFD_RDC321X && MFD_SUPPORT && PCI || MFD_JANZ_CMODIO && MFD_SUPPORT && PCI || MFD_JZ4740_ADC && MFD_SUPPORT && MACH_JZ4740 || MFD_TPS6586X && MFD_SUPPORT && I2C=y && GPIOLIB && GENERIC_HARDIRQS || MFD_VX855 && MFD_SUPPORT && PCI) selects MFD_CORE which has unmet direct dependencies (MFD_SUPPORT):  => N/A
	warning: (I2C_ISCH && I2C && PCI || GPIO_SCH && GPIOLIB && PCI) selects LPC_SCH which has unmet direct dependencies (MFD_SUPPORT && PCI):  => N/A
	warning: (LOCKDEP && DEBUG_KERNEL && TRACE_IRQFLAGS_SUPPORT && STACKTRACE_SUPPORT && LOCKDEP_SUPPORT && !MIPS && !PPC && !ARM_UNWIND && !S390 && !MICROBLAZE || FAULT_INJECTION_STACKTRACE_FILTER && FAULT_INJECTION_DEBUG_FS && STACKTRACE_SUPPORT && !X86_64 && !PPC && !S390 && !MICROBLAZE || LATENCYTOP && HAVE_LATENCYTOP_SUPPORT && DEBUG_KERNEL && STACKTRACE_SUPPORT && PROC_FS && !MIPS && !PPC && !S390 && !MICROBLAZE || FUNCTION_TRACER && TRACING_SUPPORT && FTRACE && HAVE_FUNCTION_TRACER && !ARM_UNWIND && !S390 || KMEMCHECK && HAVE_ARCH_KMEMCHECK && DEBUG_KERNEL && !X86_USE_3DNOW && (SLUB || SLAB) && !CC_OPTIMIZE_FOR_SIZE && !FUNCTION_TRACER) selects FRAME_POINTER which has unmet direct dependencies (DEBUG_KERNEL && (CRIS || M68K || M68KNOMMU || FRV || UML || AVR32 || SUPERH || BLACKFIN || MN10300) || ARCH_WANT_FRAME_POINTERS):  => N/A
	warning: (MPC836x_RDK && PPC_83xx || MTD_NAND_FSL_ELBC && MTD && MTD_NAND && PPC_OF || MTD_NAND_FSL_UPM && MTD && MTD_NAND && (PPC_83xx || PPC_85xx)) selects FSL_LBC which has unmet direct dependencies (FSL_SOC):  => N/A
	warning: (NETFILTER_XT_MATCH_REALM && NET && INET && NETFILTER && NETFILTER_XTABLES && NETFILTER_ADVANCED || NET_CLS_ROUTE4 && NET && NET_SCHED) selects NET_CLS_ROUTE which has unmet direct dependencies (NET && NET_SCHED):  => N/A
	warning: (PAGE_POISONING && DEBUG_KERNEL && !ARCH_SUPPORTS_DEBUG_PAGEALLOC && !HIBERNATION) selects DEBUG_PAGEALLOC which has unmet direct dependencies (DEBUG_KERNEL && ARCH_SUPPORTS_DEBUG_PAGEALLOC && (!HIBERNATION || !PPC && !SPARC) && !KMEMCHECK):  => N/A
	warning: (PARISC) selects GENERIC_HARDIRQS_NO__DO_IRQ which has unmet direct dependencies (HAVE_GENERIC_HARDIRQS):  => N/A
	warning: (PERF_EVENTS && HAVE_PERF_EVENTS) selects IRQ_WORK which has unmet direct dependencies (HAVE_IRQ_WORK):  => N/A
	warning: (PPP && NETDEVICES || SLIP_COMPRESSED && NETDEVICES && SLIP || ISDN_PPP && ISDN && ISDN_I4L && INET) selects SLHC which has unmet direct dependencies (NETDEVICES):  => N/A
	warning: (RADIO_MIROPCM20 && MEDIA_SUPPORT && RADIO_ADAPTERS && ISA && VIDEO_V4L2 && SND) selects SND_ISA which has unmet direct dependencies (SOUND && !M68K && SND && ISA && ISA_DMA_API):  => N/A
	warning: (SINGLE_MEMORY_CHUNK) selects NEED_MULTIPLE_NODES which has unmet direct dependencies (DISCONTIGMEM || NUMA):  => N/A
	warning: (USB_WUSB && USB_SUPPORT && EXPERIMENTAL && USB) selects UWB which has unmet direct dependencies (EXPERIMENTAL && PCI):  => N/A
	warning: 1 bad relocations:  => N/A

133 improvements:
	modpost: WARNING: modpost: Found 12 section mismatch(es).: N/A => 
	modpost: WARNING: modpost: Found 54 section mismatch(es).: N/A => 
	modpost: WARNING: modpost: Found 65 section mismatch(es).: N/A => 
	modpost: WARNING: modpost: Found 9 section mismatch(es).: N/A => 
	src/arch/sh/include/asm/ptrace.h: warning: this is the location of the previous definition: 39:1 => 
	src/arch/sh/kernel/cpu/sh4a/clock-shx3.c: warning: 'cpg_clk_init' is deprecated (declared at /scratch/kisskb/src/arch/sh/include/asm/clock.h:11): 122 => 
	src/arch/x86/include/asm/uaccess_32.h: warning: call to 'copy_from_user_overflow' declared with attribute warning: copy_from_user() buffer size is not provably correct: 212 => 
	src/arch/x86/kernel/apic/hw_nmi.c: warning: 'backtrace_mask' defined but not used: 21 => 
	src/arch/x86/kernel/scx200_32.c: warning: 'base' may be used uninitialized in this function: 82 => 
	src/drivers/base/power/main.c: warning: comparison of distinct pointer types lacks a cast: 415 => 
	src/drivers/block/z2ram.c: warning: format '%lu' expects type 'long unsigned int', but argument 2 has type 'sector_t': 83 => 
	src/drivers/cdrom/gdrom.c: warning: 'ctrl_inb' is deprecated (declared at /scratch/kisskb/src/arch/sh/include/asm/io.h:94): 238, 149, 538, 155, 387, 400, 548, 144, 634 => 
	src/drivers/cdrom/gdrom.c: warning: 'ctrl_inl' is deprecated (declared at /scratch/kisskb/src/arch/sh/include/asm/io.h:104): 409 => 
	src/drivers/cdrom/gdrom.c: warning: 'ctrl_inw' is deprecated (declared at /scratch/kisskb/src/arch/sh/include/asm/io.h:99): 190 => 
	src/drivers/cdrom/gdrom.c: warning: 'ctrl_outb' is deprecated (declared at /scratch/kisskb/src/arch/sh/include/asm/io.h:114): 613, 204, 206, 720, 638, 617, 205, 235, 616, 615, 183, 213, 618, 199, 202, 716, 201, 717, 619, 624 => 
	src/drivers/cdrom/gdrom.c: warning: 'ctrl_outl' is deprecated (declared at /scratch/kisskb/src/arch/sh/include/asm/io.h:124): 605, 602, 730, 731, 603, 604, 407 => 
	src/drivers/char/cyclades.c: warning: 'cyz_interrupt' defined but not used: 1200, 1201 => 1200
	src/drivers/char/keyboard.c: warning: comparison is always true due to limited range of data type: 719 => 
	src/drivers/char/mem.c: warning: cast to pointer from integer of different size: 342 => 
	src/drivers/char/mxser.c: warning: 'mxser_disable_must_enchance_mode' defined but not used: 306, 307 => 
	src/drivers/char/mxser.c: warning: 'mxser_get_must_hardware_id' defined but not used: 391, 392 => 
	src/drivers/char/n_gsm.c: warning: ignoring return value of '__kfifo_must_check_helper', declared with attribute warn_unused_result: 1580 => 
	src/drivers/char/rocket.c: warning: 'rmSpeakerReset' defined but not used: 3163, 3164 => 3166
	src/drivers/char/rocket.c: warning: 'sPCIInitController' defined but not used: 2627, 2622 => 2625
	src/drivers/char/rtc.c: warning: 'rtc_freq' defined but not used: 192 => 
	src/drivers/gpio/bt8xxgpio.c: warning: ignoring return value of 'gpiochip_remove', declared with attribute warn_unused_result: 247 => 
	src/drivers/gpio/wm8994-gpio.c: warning: 'wm8994_gpio_to_irq' defined but not used: 84 => 
	src/drivers/hwmon/i5k_amb.c: warning: 'i5k_amb_ids' defined but not used: 500 => 
	src/drivers/i2c/busses/i2c-sh7760.c: warning: 'ctrl_inl' is deprecated (declared at /scratch/kisskb/src/arch/sh/include/asm/io.h:104): 109 => 
	src/drivers/i2c/busses/i2c-sh7760.c: warning: 'ctrl_outl' is deprecated (declared at /scratch/kisskb/src/arch/sh/include/asm/io.h:124): 104 => 
	src/drivers/infiniband/hw/cxgb4/cm.c: warning: cast to pointer from integer of different size: 2326 => 
	src/drivers/infiniband/hw/cxgb4/cq.c: warning: cast from pointer to integer of different size: 58, 135 => 
	src/drivers/infiniband/hw/cxgb4/mem.c: warning: cast from pointer to integer of different size: 74 => 
	src/drivers/infiniband/hw/cxgb4/qp.c: warning: cast from pointer to integer of different size: 147, 1063, 988 => 
	src/drivers/infiniband/hw/nes/nes_verbs.c: warning: cast to pointer from integer of different size: 477, 3486 => 
	src/drivers/input/keyboard/jornada680_kbd.c: warning: 'ctrl_inb' is deprecated (declared at /scratch/kisskb/src/arch/sh/include/asm/io.h:94): 170, 158, 169, 157 => 
	src/drivers/input/keyboard/jornada680_kbd.c: warning: 'ctrl_inw' is deprecated (declared at /scratch/kisskb/src/arch/sh/include/asm/io.h:99): 142, 143 => 
	src/drivers/input/keyboard/jornada680_kbd.c: warning: 'ctrl_outb' is deprecated (declared at /scratch/kisskb/src/arch/sh/include/asm/io.h:114): 152, 161, 162, 153 => 
	src/drivers/input/keyboard/jornada680_kbd.c: warning: 'ctrl_outw' is deprecated (declared at /scratch/kisskb/src/arch/sh/include/asm/io.h:119): 147, 166, 165, 148 => 
	src/drivers/input/touchscreen/hp680_ts_input.c: warning: 'ctrl_inb' is deprecated (declared at /scratch/kisskb/src/arch/sh/include/asm/io.h:94): 32, 53, 40, 31, 48 => 
	src/drivers/input/touchscreen/hp680_ts_input.c: warning: 'ctrl_outb' is deprecated (declared at /scratch/kisskb/src/arch/sh/include/asm/io.h:114): 35, 51, 43 => 
	src/drivers/isdn/hardware/mISDN/mISDNipac.c: warning: unsupported argument to '__builtin_return_address': 754 => 
	src/drivers/isdn/hardware/mISDN/netjet.c: warning: comparison is always false due to limited range of data type: 318 => 
	src/drivers/isdn/hardware/mISDN/w6692.c: warning: unsupported argument to '__builtin_return_address': 1188 => 
	src/drivers/isdn/sc/init.c: warning: passing argument 1 of 'readl' makes pointer from integer without a cast: 497, 487, 507 => 
	src/drivers/media/dvb/ngene/ngene-core.c: warning: unused variable 'flags': 1308 => 
	src/drivers/media/video/sh_mobile_ceu_camera.c: warning: 'sd' is used uninitialized in this function: 1245 => 
	src/drivers/media/video/sh_mobile_ceu_camera.c: warning: 'sd' may be used uninitialized in this function: 1707, 1683, 943 => 
	src/drivers/media/video/sh_mobile_ceu_camera.c: warning: unused variable 'sd': 1648 => 
	src/drivers/media/video/videobuf-dma-sg.c: warning: comparison of distinct pointer types lacks a cast: 119, 120 => 
	src/drivers/media/video/vino.c: warning: 'data_norm' may be used uninitialized in this function: 2566, 2656 => 
	src/drivers/message/fusion/mptbase.c: warning: 'seq_mpt_print_ioc_summary' defined but not used: 6810 => 
	src/drivers/mmc/host/sdhci.c: warning: 'pwr' may be used uninitialized in this function: 1037 => 
	src/drivers/mtd/devices/doc2001plus.c: warning: passing argument 2 of 'MemWriteDOC' discards qualifiers from pointer target type: 767 => 
	src/drivers/mtd/maps/solutionengine.c: warning: assignment makes pointer from integer without a cast: 74, 76 => 
	src/drivers/mtd/nand/alauda.c: warning: passing argument 3 of 'alauda_write_page' discards qualifiers from pointer target type: 480 => 
	src/drivers/net/3c59x.c: warning: dereferencing 'void *' pointer: 3211 => 
	src/drivers/net/pcmcia/ibmtr_cs.c: warning: 'pcmcia_request_exclusive_irq' is deprecated (declared at /scratch/kisskb/src/include/pcmcia/ds.h:200): 235 => 
	src/drivers/net/pcmcia/ibmtr_cs.c: warning: 'pcmcia_request_exclusive_irq' is deprecated (declared at /scratch/kisskb/src/include/pcmcia/ds.h:202): 235 => 
	src/drivers/net/pcmcia/nmclan_cs.c: warning: 'pcmcia_request_exclusive_irq' is deprecated (declared at /scratch/kisskb/src/include/pcmcia/ds.h:200): 650 => 
	src/drivers/net/pcmcia/nmclan_cs.c: warning: 'pcmcia_request_exclusive_irq' is deprecated (declared at /scratch/kisskb/src/include/pcmcia/ds.h:202): 650 => 
	src/drivers/net/pcmcia/smc91c92_cs.c: warning: 'j' may be used uninitialized in this function: 846 => 
	src/drivers/net/phy/broadcom.c: warning: 'broadcom_tbl' defined but not used: 933 => 
	src/drivers/net/phy/cicada.c: warning: 'cicada_tbl' defined but not used: 162 => 
	src/drivers/net/phy/davicom.c: warning: 'davicom_tbl' defined but not used: 222 => 
	src/drivers/net/phy/et1011c.c: warning: 'et1011c_tbl' defined but not used: 114 => 
	src/drivers/net/phy/icplus.c: warning: 'icplus_tbl' defined but not used: 137 => 
	src/drivers/net/phy/lxt.c: warning: 'lxt_tbl' defined but not used: 226 => 
	src/drivers/net/phy/marvell.c: warning: 'marvell_tbl' defined but not used: 724 => 
	src/drivers/net/phy/micrel.c: warning: 'micrel_tbl' defined but not used: 234 => 
	src/drivers/net/phy/national.c: warning: 'ns_tbl' defined but not used: 154 => 
	src/drivers/net/phy/qsemi.c: warning: 'qs6612_tbl' defined but not used: 141 => 
	src/drivers/net/phy/realtek.c: warning: 'realtek_tbl' defined but not used: 82 => 
	src/drivers/net/phy/smsc.c: warning: 'smsc_tbl' defined but not used: 257 => 
	src/drivers/net/phy/ste10Xp.c: warning: 'ste10Xp_tbl' defined but not used: 135 => 
	src/drivers/net/phy/vitesse.c: warning: 'vitesse_tbl' defined but not used: 195 => 
	src/drivers/net/tehuti.c: warning: passing argument 2 of 'bdx_tx_push_desc_safe' discards qualifiers from pointer target type: 330 => 
	src/drivers/net/tlan.c: warning: label 'err_out' defined but not used: 685 => 
	src/drivers/net/wireless/iwmc3200wifi/rx.c: warning: comparison is always true due to limited range of data type: 1198 => 
	src/drivers/net/wireless/libertas/cfg.c: warning: passing argument 3 of 'lbs_deb_hex' discards qualifiers from pointer target type: 273 => 
	src/drivers/net/wireless/mwl8k.c: warning: 'ap_legacy_rates' may be used uninitialized in this function: 3403 => 
	src/drivers/net/wireless/p54/p54usb.c: warning: 'p54u_device_reset' defined but not used: 406, 407 => 
	src/drivers/parisc/led.c: warning: assignment from incompatible pointer type: 366 => 
	src/drivers/pcmcia/cs.c: warning: 'pcmcia_socket_dev_resume' defined but not used: 849 => 
	src/drivers/scsi/advansys.c: warning: label 'err_unmap' defined but not used: 12377 => 
	src/drivers/scsi/aic7xxx_old.c: warning: passing argument 3 of 'pci_free_consistent' discards qualifiers from pointer target type: 8490 => 
	src/drivers/scsi/initio.c: warning: 'initio_remove_one' defined but not used: 2966 => 
	src/drivers/scsi/stex.c: warning: passing argument 2 of 'scsi_sg_copy_from_buffer' discards qualifiers from pointer target type: 636 => 
	src/drivers/scsi/vmw_pvscsi.c: warning: 'pvscsi_remove' defined but not used: 1372 => 
	src/drivers/sh/maple/maple.c: warning: 'ctrl_inl' is deprecated (declared at /scratch/kisskb/src/arch/sh/include/asm/io.h:104): 133 => 
	src/drivers/sh/maple/maple.c: warning: 'ctrl_outl' is deprecated (declared at /scratch/kisskb/src/arch/sh/include/asm/io.h:124): 109, 453, 99, 639, 278, 97, 108, 799, 110 => 
	src/drivers/staging/iio/light/tsl2563.c: warning: 'tsl2563_remove' defined but not used: 903 => 
	src/drivers/staging/lirc/lirc_imon.c: warning: 'chunk_num' may be used uninitialized in this function: 661 => 
	src/drivers/staging/lirc/lirc_parallel.c: warning: 'poll_state' defined but not used: 583 => 
	src/drivers/staging/lirc/lirc_parallel.c: warning: initialization discards qualifiers from pointer target type: 571 => 
	src/drivers/staging/lirc/lirc_sir.c: warning: initialization discards qualifiers from pointer target type: 482 => 
	src/drivers/staging/lirc/lirc_zilog.c: warning: assignment discards qualifiers from pointer target type: 1284 => 
	src/drivers/staging/zram/zram_drv.c: warning: large integer implicitly truncated to unsigned type: 707, 706 => 
	src/drivers/usb/gadget/dbgp.c: warning: comparison is always true due to limited range of data type: 389 => 
	src/drivers/usb/gadget/r8a66597-udc.h: warning: 'data' may be used uninitialized in this function: 139 => 
	src/drivers/usb/gadget/storage_common.c: warning: 'fsg_show_nofua' defined but not used: 718, 720 => 
	src/drivers/usb/gadget/storage_common.c: warning: 'fsg_store_nofua' defined but not used: 782, 785 => 
	src/drivers/usb/host/xhci-ring.c: warning: 'event_trb' may be used uninitialized in this function: 1719 => 
	src/drivers/video/metronomefb.c: warning: passing argument 1 of 'load_waveform' discards qualifiers from pointer target type: 687 => 
	src/drivers/w1/masters/ds2490.c: warning: passing argument 2 of 'ds_write_block' discards qualifiers from pointer target type: 827 => 
	src/drivers/xen/events.c: warning: 'gsi_from_irq' defined but not used: 187 => 
	src/drivers/xen/events.c: warning: 'mk_pirq_info' defined but not used: 141 => 
	src/drivers/xen/events.c: warning: 'vector_from_irq' defined but not used: 197 => 
	src/fs/autofs/root.c: warning: 'autofs_root_compat_ioctl' declared 'static' but never defined: 30 => 
	src/fs/autofs4/root.c: warning: 'autofs4_root_compat_ioctl' declared 'static' but never defined: 31 => 
	src/fs/ceph/messenger.c: warning: 'proto' may be used uninitialized in this function: 631 => 
	src/fs/smbfs/file.c: warning: format '%Zd' expects type 'signed size_t', but argument 5 has type 'ssize_t': 353, 230, 277 => 
	src/include/math-emu/double.h: warning: "__LITTLE_ENDIAN" is not defined: 59:5 => 
	src/include/math-emu/single.h: warning: "__LITTLE_ENDIAN" is not defined: 50:5 => 
	src/include/sound/tlv320aic3x.h: warning: no newline at end of file: 17:7 => 
	src/kernel/module.c: warning: passing argument 2 of 'add_kallsyms' discards qualifiers from pointer target type: 2535 => 
	src/kernel/profile.c: warning: 'profile_cpu_callback' defined but not used: 359 => 
	src/kernel/profile.c: warning: 'profile_discard_flip_buffers' defined but not used: 293 => 
	src/kernel/profile.c: warning: 'profile_flip_buffers' defined but not used: 270 => 
	src/kernel/trace/trace_functions_graph.c: warning: comparison of distinct pointer types lacks a cast: 652 => 
	src/mm/percpu.c: warning: 'pcpu_build_alloc_info' defined but not used: 1094 => 
	src/net/econet/af_econet.c: warning: 'econet_sendmsg' uses dynamic stack allocation: 508 => 
	src/net/mac80211/tx.c: warning: unused variable 'mesh_hdr': 1702 => 
	src/net/rds/tcp_send.c: warning: passing argument 1 of 'virt_to_phys' makes pointer from integer without a cast: 113 => 
	src/sound/oss/pss.c: warning: 'check_region' is deprecated (declared at /scratch/kisskb/src/include/linux/ioport.h:169): 676 => 
	src/sound/pcmcia/pdaudiocf/pdaudiocf.c: warning: 'pcmcia_request_exclusive_irq' is deprecated (declared at /scratch/kisskb/src/include/pcmcia/ds.h:200): 226 => 
	src/sound/pcmcia/pdaudiocf/pdaudiocf.c: warning: 'pcmcia_request_exclusive_irq' is deprecated (declared at /scratch/kisskb/src/include/pcmcia/ds.h:202): 226 => 
	src/sound/pcmcia/vx/vxpocket.c: warning: 'pcmcia_request_exclusive_irq' is deprecated (declared at /scratch/kisskb/src/include/pcmcia/ds.h:200): 233 => 
	src/sound/pcmcia/vx/vxpocket.c: warning: 'pcmcia_request_exclusive_irq' is deprecated (declared at /scratch/kisskb/src/include/pcmcia/ds.h:202): 233 => 
	src/sound/soc/soc-dapm.c: warning: unused variable 'codec': 440 => 
	src/sound/usb/mixer.c: warning: unused variable 'chip': 762 => 
	warning: "saved_config" [vmlinux] is COMMON symbol: N/A => 
	warning: 3 bad relocations: N/A => 

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
