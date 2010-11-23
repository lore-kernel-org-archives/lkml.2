Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752359Ab0KWUzH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 15:55:07 -0500
Received: from juliette.telenet-ops.be ([195.130.137.74]:35134 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750793Ab0KWUzE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 15:55:04 -0500
Date: Tue, 23 Nov 2010 21:54:55 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Build regressions/improvements in v2.6.37-rc3
Message-ID: <alpine.DEB.2.00.1011232149520.800@ayla.of.borg>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Below is the list of build error/warning regressions/improvements in
v2.6.37-rc3[1] compared to v2.6.36[2].

Summarized:
  - build errors: +108/-10
  - build warnings: +232/-150

JFYI, when comparing v2.6.37-rc3 to v2.6.37-rc2[3], the summaries are:
  - build errors: +134/-5
  - build warnings: +286/-15

Note that there are some false regressions, as the logs for v2.6.36 and
v2.6.37-rc2 are incomplete. Still, they're build errors/warnings.

In addition, I put the verbose summary at
http://www.kernel.org/pub/linux/kernel/people/geert/linux-log/v2.6.37-rc3.summary.gz
so you can easily find out for which configs and architectures the
errors/warnings you're interested in are happening.

Happy fixing! ;-)

Thanks to the linux-next team for providing the build service.

[1] http://kisskb.ellerman.id.au/kisskb/head/3480/ (all 108 configs)
[2] http://kisskb.ellerman.id.au/kisskb/head/3363/ (97 out of 108 configs)
[3] http://kisskb.ellerman.id.au/kisskb/head/3461/ (75 out of 108 configs)


*** ERRORS ***

108 regressions:
	error: sgiseeq.c: relocation truncated to fit: R_MIPS_26 against `dma_cache_sync':  => (.text+0x4a834), (.text+0x4aeb4), (.text+0x4a7a8), (.text+0x4a7fc), (.text+0x4b01c), (.text+0x4ae10), (.text+0x4ae80), (.text+0x4aedc), (.text+0x4a780)
	error: sgiseeq.c: undefined reference to `dma_cache_sync':  => .text+0x4a834), .text+0x4a780), .text+0x4a7fc), .text+0x4a7a8)
	error: sgiwd93.c: relocation truncated to fit: R_MIPS_26 against `dma_cache_sync':  => (.text+0x38840)
	error: sgiwd93.c: undefined reference to `dma_cache_sync':  => .text+0x38840)
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
	src/arch/mips/include/asm/mach-ip27/dma-coherence.h: error: implicit declaration of function 'BRIDGE_CONTROLLER':  => 24
	src/arch/mips/include/asm/mach-ip27/dma-coherence.h: error: invalid type argument of '->':  => 32, 24
	src/arch/mips/mm/sc-mips.c: error: 'config2' undeclared (first use in this function):  => 77
	src/arch/mips/mm/sc-mips.c: error: 'tmp' undeclared (first use in this function):  => 81
	src/arch/mips/mm/sc-mips.c: error: (Each undeclared identifier is reported only once:  => 77
	src/arch/mips/mm/sc-mips.c: error: for each function it appears in.):  => 77
	src/arch/sh/boards/mach-se/7206/irq.c: error: 'INTC_ICR' undeclared (first use in this function):  => 143
	src/arch/sh/boards/mach-se/7206/irq.c: error: (Each undeclared identifier is reported only once:  => 143
	src/arch/sh/boards/mach-se/7206/irq.c: error: for each function it appears in.):  => 143
	src/drivers/char/ipmi/ipmi_si_intf.c: error: invalid operands to binary << (have 'void *' and 'int'):  => 1381, 1396
	src/drivers/char/specialix.c: error: invalid operands to binary | (have 'void *' and 'int'):  => 237, 227
	src/drivers/char/tpm/tpm.h: error: invalid operands to binary & (have 'void *' and 'int'):  => 125
	src/drivers/char/tpm/tpm_tis.c: error: implicit declaration of function 'ioread32':  => 392
	src/drivers/char/tpm/tpm_tis.c: error: implicit declaration of function 'ioread8':  => 83
	src/drivers/char/tpm/tpm_tis.c: error: implicit declaration of function 'iowrite32':  => 401
	src/drivers/char/tpm/tpm_tis.c: error: implicit declaration of function 'iowrite8':  => 96
	src/drivers/i2c/busses/i2c-i801.c: error: implicit declaration of function 'kfree':  => 855
	src/drivers/i2c/busses/i2c-i801.c: error: implicit declaration of function 'kzalloc':  => 737
	src/drivers/i2c/busses/i2c-ocores.c: error: implicit declaration of function 'ioread8':  => 74
	src/drivers/i2c/busses/i2c-ocores.c: error: implicit declaration of function 'iowrite8':  => 69
	src/drivers/mfd/88pm860x-core.c: error: unknown field 'bus_lock' specified in initializer:  => 457
	src/drivers/mfd/88pm860x-core.c: error: unknown field 'bus_sync_unlock' specified in initializer:  => 458
	src/drivers/mfd/88pm860x-core.c: error: unknown field 'disable' specified in initializer:  => 460
	src/drivers/mfd/88pm860x-core.c: error: unknown field 'enable' specified in initializer:  => 459
	src/drivers/mfd/wm831x-irq.c: error: unknown field 'bus_lock' specified in initializer:  => 425
	src/drivers/mfd/wm831x-irq.c: error: unknown field 'bus_sync_unlock' specified in initializer:  => 426
	src/drivers/mfd/wm831x-irq.c: error: unknown field 'mask' specified in initializer:  => 427
	src/drivers/mfd/wm831x-irq.c: error: unknown field 'set_type' specified in initializer:  => 429
	src/drivers/mfd/wm831x-irq.c: error: unknown field 'unmask' specified in initializer:  => 428
	src/drivers/usb/gadget/atmel_usba_udc.c: error: 'ubc' undeclared (first use in this function):  => 2020
	src/drivers/usb/gadget/atmel_usba_udc.c: error: (Each undeclared identifier is reported only once:  => 2020
	src/drivers/usb/gadget/atmel_usba_udc.c: error: for each function it appears in.):  => 2020
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

10 improvements:
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

232 regressions:
	arch/avr32/configs/atstk1002_defconfig: warning: symbol value 'm' invalid for LEDS_CLASS:  => 137
	arch/mips/configs/malta_defconfig: warning: symbol value 'm' invalid for LEDS_CLASS:  => 374
	modpost: WARNING: modpost: Found 17 section mismatch(es).:  => N/A
	modpost: WARNING: modpost: Found 18 section mismatch(es).:  => N/A
	modpost: WARNING: modpost: Found 66 section mismatch(es).:  => N/A
	src/arch/alpha/include/asm/io.h: warning: 'arch_local_irq_restore' is static but used in inline function '__set_hae' which is not static:  => 49
	src/arch/alpha/include/asm/io.h: warning: 'arch_local_irq_save' is static but used in inline function '__set_hae' which is not static:  => 41
	src/arch/arm/mm/init.c: warning: format '%08lx' expects type 'long unsigned int', but argument 12 has type 'unsigned int':  => 606
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
	src/arch/sh/kernel/cpu/sh2/../../entry-common.S: Warning: overflow in branch to __restore_all; converted into longer instruction sequence:  => 89
	src/arch/sh/kernel/cpu/sh2/../../entry-common.S: Warning: overflow in branch to syscall_call; converted into longer instruction sequence:  => 209
	src/arch/sh/kernel/cpu/sh2/../../entry-common.S: Warning: overflow in branch to syscall_exit_work; converted into longer instruction sequence:  => 364, 361
	src/arch/sh/kernel/cpu/sh2/../../entry-common.S: Warning: overflow in branch to syscall_trace_entry; converted into longer instruction sequence:  => 337, 335
	src/arch/sh/kernel/cpu/sh2a/clock-sh7201.c: warning: 'return' with a value, in function returning void:  => 37
	src/arch/sh/math-emu/math.c: warning: "READ" redefined:  => 56:1
	src/arch/sh/math-emu/math.c: warning: "WRITE" redefined:  => 55:1
	src/arch/x86/kernel/apic/io_apic.c: warning: unused variable 'desc':  => 2433
	src/arch/x86/kernel/pci-gart_64.c: warning: 'info.aper_size' may be used uninitialized in this function:  => 745
	src/arch/xtensa/mm/tlb.c: warning: comparison of distinct pointer types lacks a cast:  => 71, 68
	src/block/blk-merge.c: warning: 'bbio' may be used uninitialized in this function:  => 18
	src/drivers/acpi/processor_thermal.c: warning: 'acpi_thermal_cpufreq_decrease' defined but not used:  => 164
	src/drivers/acpi/processor_thermal.c: warning: 'acpi_thermal_cpufreq_increase' defined but not used:  => 160
	src/drivers/acpi/sleep.c: warning: 'acpi_target_sleep_state' defined but not used:  => 30
	src/drivers/char/tpm/tpm.c: warning: format '%zd' expects type 'signed size_t', but argument 3 has type 'ssize_t':  => 433, 400
	src/drivers/gpio/pch_gpio.c: warning: 'pch_gpio_restore_reg_conf' defined but not used:  => 140
	src/drivers/gpio/pch_gpio.c: warning: 'pch_gpio_save_reg_conf' defined but not used:  => 131
	src/drivers/hwmon/i5k_amb.c: warning: control reaches end of non-void function:  => 492
	src/drivers/hwmon/lis3lv02d_i2c.c: warning: 'lis3_i2c_runtime_resume' defined but not used:  => 231, 232
	src/drivers/hwmon/lis3lv02d_i2c.c: warning: 'lis3_i2c_runtime_suspend' defined but not used:  => 223, 222
	src/drivers/hwmon/lis3lv02d_i2c.c: warning: 'lis3lv02d_i2c_resume' defined but not used:  => 201
	src/drivers/hwmon/lis3lv02d_i2c.c: warning: 'lis3lv02d_i2c_suspend' defined but not used:  => 191
	src/drivers/hwmon/w83795.c: warning: 'lsb' may be used uninitialized in this function:  => 483
	src/drivers/i2c/busses/i2c-i801.c: warning: assignment makes pointer from integer without a cast:  => 737
	src/drivers/ide/ide-io-std.c: warning: statement with no effect:  => 200, 185
	src/drivers/infiniband/hw/mlx4/qp.c: warning: 'vlan' may be used uninitialized in this function:  => 1304
	src/drivers/infiniband/hw/nes/nes.c: warning: ignoring return value of 'strict_strtoul', declared with attribute warn_unused_result:  => 1115
	src/drivers/input/touchscreen/htcpen.c: warning: 'pnp_ids' defined but not used:  => 50
	src/drivers/isdn/i4l/isdn_common.c: warning: unused variable 's':  => 1285
	src/drivers/leds/leds-gpio.c: warning: 'create_gpio_led' defined but not used:  => 91
	src/drivers/leds/leds-gpio.c: warning: 'delete_gpio_led' defined but not used:  => 145
	src/drivers/leds/leds-lp5521.c: warning: 'engine_state' may be used uninitialized in this function:  => 158
	src/drivers/leds/leds-lp5523.c: warning: 'adc' may be used uninitialized in this function:  => 436
	src/drivers/leds/leds-lp5523.c: warning: 'vdd' may be used uninitialized in this function:  => 436
	src/drivers/media/common/tuners/tda18218.c: warning: 'ret' is used uninitialized in this function:  => 58
	src/drivers/media/dvb/frontends/af9013.c: warning: 'ret' is used uninitialized in this function:  => 1011
	src/drivers/media/video/cx88/cx88-i2c.c: warning: 'id' is deprecated (declared at /scratch/kisskb/src/include/linux/i2c.h:356):  => 149
	src/drivers/media/video/cx88/cx88-vp3054-i2c.c: warning: 'id' is deprecated (declared at /scratch/kisskb/src/include/linux/i2c.h:356):  => 128
	src/drivers/mfd/88pm860x-core.c: warning: initialization from incompatible pointer type:  => 457, 459, 458, 460
	src/drivers/mfd/wm831x-irq.c: warning: initialization from incompatible pointer type:  => 427, 426, 428, 429, 425
	src/drivers/misc/apds990x.c: warning: 'apds990x_chip_on' defined but not used:  => 612
	src/drivers/misc/apds990x.c: warning: 'apds990x_resume' defined but not used:  => 1216
	src/drivers/misc/apds990x.c: warning: 'apds990x_suspend' defined but not used:  => 1207
	src/drivers/misc/apds990x.c: warning: comparison is always false due to limited range of data type:  => 701
	src/drivers/misc/bh1770glc.c: warning: 'bh1770_resume' defined but not used:  => 1325
	src/drivers/misc/bh1770glc.c: warning: 'bh1770_suspend' defined but not used:  => 1315
	src/drivers/misc/pch_phub.c: warning: 'pch_phub_restore_reg_conf' defined but not used:  => 180
	src/drivers/misc/pch_phub.c: warning: 'pch_phub_save_reg_conf' defined but not used:  => 121
	src/drivers/net/bnx2x/bnx2x_init_ops.h: warning: 'bnx2x_src_init_t2' defined but not used:  => 843
	src/drivers/net/can/pch_can.c: warning: 'pch_can_get_int_enables' defined but not used:  => 269
	src/drivers/net/can/pch_can.c: warning: 'pch_can_get_rx_buffer_link' defined but not used:  => 480
	src/drivers/net/can/pch_can.c: warning: 'pch_can_get_rx_enable' defined but not used:  => 420
	src/drivers/net/can/pch_can.c: warning: 'pch_can_get_tx_enable' defined but not used:  => 438
	src/drivers/net/can/pch_can.c: warning: 'pch_can_set_int_custom' defined but not used:  => 258
	src/drivers/net/can/pch_can.c: warning: 'pch_can_set_rx_buffer_link' defined but not used:  => 462
	src/drivers/net/enic/enic_main.c: warning: passing argument 3 of 'pci_alloc_consistent' from incompatible pointer type:  => 2056, 2082
	src/drivers/net/macvtap.c: warning: control reaches end of non-void function:  => 102
	src/drivers/net/pcmcia/ibmtr_cs.c: warning: 'pcmcia_request_exclusive_irq' is deprecated (declared at /scratch/kisskb/src/include/pcmcia/ds.h:201):  => 195
	src/drivers/net/pcmcia/ibmtr_cs.c: warning: 'pcmcia_request_exclusive_irq' is deprecated (declared at /scratch/kisskb/src/include/pcmcia/ds.h:203):  => 195
	src/drivers/net/pcmcia/nmclan_cs.c: warning: 'pcmcia_request_exclusive_irq' is deprecated (declared at /scratch/kisskb/src/include/pcmcia/ds.h:201):  => 628
	src/drivers/net/pcmcia/nmclan_cs.c: warning: 'pcmcia_request_exclusive_irq' is deprecated (declared at /scratch/kisskb/src/include/pcmcia/ds.h:203):  => 628
	src/drivers/net/sky2.c: warning: control reaches end of non-void function:  => 2992
	src/drivers/net/usb/hso.c: warning: unused variable 'uarg':  => 1748
	src/drivers/net/wireless/libertas/cfg.c: warning: passing argument 3 of 'lbs_deb_hex' discards qualifiers from pointer target type: 273 => 274, 533
	src/drivers/net/wireless/rt2x00/rt2800lib.c: warning: 'gf20_mode' may be used uninitialized in this function:  => 1206
	src/drivers/net/wireless/rt2x00/rt2800lib.c: warning: 'gf40_mode' may be used uninitialized in this function:  => 1206
	src/drivers/net/wireless/rt2x00/rt2800lib.c: warning: 'mm20_mode' may be used uninitialized in this function:  => 1206
	src/drivers/net/wireless/rt2x00/rt2800lib.c: warning: 'mm40_mode' may be used uninitialized in this function:  => 1206
	src/drivers/parport/parport_pc.c: warning: passing argument 2 of 'dma_map_single_attrs' discards qualifiers from pointer target type:  => 635
	src/drivers/pci/pcie/portdrv_core.c: warning: 'cap_mask' may be used uninitialized in this function:  => 241
	src/drivers/platform/x86/ibm_rtl.c: warning: cast from pointer to integer of different size:  => 308, 296
	src/drivers/platform/x86/ibm_rtl.c: warning: format '%#llx' expects type 'long long unsigned int', but argument 2 has type 'phys_addr_t':  => 305
	src/drivers/power/twl4030_charger.c: warning: overflow in implicit constant conversion:  => 477, 485
	src/drivers/scsi/advansys.c: warning: 'ret' may be used uninitialized in this function:  => 11893
	src/drivers/scsi/advansys.c: warning: 'share_irq' may be used uninitialized in this function:  => 11893
	src/drivers/scsi/aha152x.c: warning: cast from pointer to integer of different size:  => 2979
	src/drivers/scsi/aic7xxx_old.c: warning: 'aic7xxx_chip_reset' defined but not used: 8347 => 8342, 8341
	src/drivers/scsi/aic7xxx_old.c: warning: 'aic7xxx_configure_bugs' defined but not used: 8901 => 8895, 8896
	src/drivers/scsi/aic7xxx_old.c: warning: 'aic7xxx_load_seeprom' defined but not used: 8502 => 8497, 8496
	src/drivers/scsi/dtc.c: warning: 'dtc_setup' defined but not used:  => 179
	src/drivers/scsi/g_NCR5380.c: warning: 'id_table' defined but not used:  => 943
	src/drivers/scsi/hpsa.c: warning: "PCI_DEVICE_ID_HP_CISSF" redefined:  => 93:1
	src/drivers/scsi/lpfc/lpfc_debugfs.c: warning: the frame size of 1028 bytes is larger than 1024 bytes:  => 429
	src/drivers/ssb/driver_mipscore.c: warning: unused variable 'irq_name':  => 158
	src/drivers/tty/vt/keyboard.c: warning: comparison is always true due to limited range of data type:  => 736
	src/drivers/uio/uio.c: warning: passing argument 1 of 'virt_to_phys' makes pointer from integer without a cast:  => 631
	src/drivers/usb/early/ehci-dbgp.c: warning: 'bus' may be used uninitialized in this function:  => 835
	src/drivers/usb/early/ehci-dbgp.c: warning: 'func' may be used uninitialized in this function:  => 835
	src/drivers/usb/early/ehci-dbgp.c: warning: 'slot' may be used uninitialized in this function:  => 835
	src/drivers/usb/serial/keyspan.c: warning: 'fw' may be used uninitialized in this function:  => 1334
	src/drivers/usb/serial/keyspan_pda.c: warning: 'fw' may be used uninitialized in this function:  => 763
	src/drivers/usb/serial/mos7720.c: warning: 'status' may be used uninitialized in this function:  => 1343, 1381
	src/drivers/usb/wusbcore/devconnect.c: warning: 'port' may be used uninitialized in this function:  => 307
	src/drivers/video/fsl-diu-fb.c: warning: format '%08x' expects type 'unsigned int', but argument 5 has type 'resource_size_t':  => 1538
	src/drivers/watchdog/alim1535_wdt.c: warning: 'ali_pci_tbl' defined but not used:  => 304
	src/fs/9p/acl.c: warning: 'name' may be used uninitialized in this function:  => 122
	src/fs/eventpoll.c: warning: 'slack' may be used uninitialized in this function:  => 1119
	src/fs/ext4/super.c: warning: 'ret' may be used uninitialized in this function:  => 2909
	src/fs/gfs2/inode.c: warning: 'inode' may be used uninitialized in this function:  => 208
	src/fs/nfs/callback.c: warning: ISO C90 forbids mixed declarations and code:  => 352
	src/fs/nfs/file.c: warning: unused variable 'count':  => 234
	src/fs/nfs/file.c: warning: unused variable 'dentry':  => 140
	src/fs/notify/fanotify/fanotify.c: warning: 'marks_ignored_mask' may be used uninitialized in this function:  => 163
	src/fs/notify/fanotify/fanotify.c: warning: 'marks_mask' may be used uninitialized in this function:  => 163
	src/fs/sysfs/dir.c: warning: 'sysfs_pathname' defined but not used: 411 => 411, 410
	src/include/acpi/video.h: warning: 'struct acpi_device' declared inside parameter list:  => 22
	src/include/acpi/video.h: warning: its scope is only this definition or declaration, which is probably not what you want:  => 22
	src/include/asm-generic/dma-mapping-common.h: warning: conflicting types for 'dma_sync_sg_for_cpu':  => 141
	src/include/asm-generic/dma-mapping-common.h: warning: conflicting types for 'dma_sync_sg_for_device':  => 153
	src/include/asm-generic/dma-mapping-common.h: warning: conflicting types for 'dma_sync_single_for_cpu':  => 99
	src/include/asm-generic/dma-mapping-common.h: warning: conflicting types for 'dma_sync_single_for_device':  => 111
	src/include/asm-generic/dma-mapping-common.h: warning: conflicting types for 'dma_unmap_page':  => 87
	src/include/asm-generic/pci-dma-compat.h: warning: return makes pointer from integer without a cast:  => 19
	src/include/linux/fs.h: warning: this is the location of the previous definition:  => 160:1, 159:1
	src/include/linux/pci_ids.h: warning: this is the location of the previous definition:  => 746:1
	src/include/net/ipx.h: warning: 'packed' attribute ignored for field of type '__be16':  => 32, 30
	src/include/net/ipx.h: warning: 'packed' attribute ignored for field of type 'struct ipx_address':  => 42, 41
	src/include/net/netfilter/xt_log.h: warning: value computed is not used:  => 50
	src/include/net/netlink.h: warning: 'len' is used uninitialized in this function:  => 647
	src/include/net/netlink.h: warning: 'len' may be used uninitialized in this function:  => 647
	src/kernel/debug/debug_core.c: warning: value computed is not used:  => 512, 497
	src/kernel/irq_work.c: warning: value computed is not used:  => 148
	src/kernel/sched.c: warning: control may reach end of non-void function 'pick_next_task' being inlined:  => 3937
	src/kernel/sched.c: warning: control reaches end of non-void function:  => 3878
	src/lib/atomic64_test.c: warning: ISO C90 forbids mixed declarations and code:  => 25
	src/net/ceph/messenger.c: warning: 'proto' may be used uninitialized in this function:  => 643
	src/net/ipv4/af_inet.c: warning: value computed is not used:  => 239
	src/net/ipv4/inet_connection_sock.c: warning: 'head' may be used uninitialized in this function:  => 95
	src/net/irda/irnet/irnet_ppp.c: warning: format '%Zd' expects type 'signed size_t', but argument 3 has type 'ssize_t':  => 331
	src/net/netfilter/nf_conntrack_core.c: warning: value computed is not used:  => 618
	src/net/netfilter/xt_socket.c: warning: 'daddr' may be used uninitialized in this function:  => 253
	src/net/netfilter/xt_socket.c: warning: 'dport' may be used uninitialized in this function:  => 254
	src/net/netfilter/xt_socket.c: warning: 'saddr' may be used uninitialized in this function:  => 253
	src/net/netfilter/xt_socket.c: warning: 'sport' may be used uninitialized in this function:  => 254
	src/net/sunrpc/rpcb_clnt.c: warning: unused variable 'task':  => 790, 748, 723, 699, 822
	src/security/selinux/selinuxfs.c: warning: passing argument 2 of 'security_read_policy' from incompatible pointer type:  => 390
	src/sound/oss/dmabuf.c: warning: passing argument 1 of 'virt_to_phys' makes pointer from integer without a cast:  => 139
	src/sound/pcmcia/pdaudiocf/pdaudiocf.c: warning: 'pcmcia_request_exclusive_irq' is deprecated (declared at /scratch/kisskb/src/include/pcmcia/ds.h:201):  => 226
	src/sound/pcmcia/pdaudiocf/pdaudiocf.c: warning: 'pcmcia_request_exclusive_irq' is deprecated (declared at /scratch/kisskb/src/include/pcmcia/ds.h:203):  => 226
	src/sound/pcmcia/vx/vxpocket.c: warning: 'pcmcia_request_exclusive_irq' is deprecated (declared at /scratch/kisskb/src/include/pcmcia/ds.h:201):  => 232
	src/sound/pcmcia/vx/vxpocket.c: warning: 'pcmcia_request_exclusive_irq' is deprecated (declared at /scratch/kisskb/src/include/pcmcia/ds.h:203):  => 232
	src/sound/soc/codecs/tlv320aic3x.c: warning: 'val' may be used uninitialized in this function:  => 1207, 1179, 1215
	src/sound/soc/codecs/wm8962.c: warning: ignoring return value of 'strict_strtol', declared with attribute warn_unused_result:  => 3504
	warning: (AX88796_93CX6 && NETDEVICES && NET_ETHERNET && AX88796 || RTL8180 && NETDEVICES && WLAN && MAC80211 && PCI && EXPERIMENTAL || RTL8187 && NETDEVICES && WLAN && MAC80211 && USB || ADM8211 && NETDEVICES && WLAN && MAC80211 && PCI && EXPERIMENTAL || RT2400PCI && NETDEVICES && WLAN && RT2X00 && PCI || RT2500PCI && NETDEVICES && WLAN && RT2X00 && PCI || RT61PCI && NETDEVICES && WLAN && RT2X00 && PCI || RT2800PCI && NETDEVICES && WLAN && RT2X00 && (RT2800PCI_PCI || RT2800PCI_SOC) && EXPERIMENTAL || R8187SE && STAGING && !STAGING_EXCLUDE_BUILD && PCI && WLAN) selects EEPROM_93CX6 which has unmet direct dependencies (MISC_DEVICES):  => N/A
	warning: (CAVIUM_OCTEON_REFERENCE_BOARD && <choice> || BCM63XX_CPU_6338 && BCM63XX) selects USB_ARCH_HAS_OHCI which has unmet direct dependencies (USB_SUPPORT):  => N/A
	warning: (CAVIUM_OCTEON_REFERENCE_BOARD && <choice>) selects USB_ARCH_HAS_EHCI which has unmet direct dependencies (USB_SUPPORT):  => N/A
	warning: (COMPAT && SPARC64) selects COMPAT_BINFMT_ELF which has unmet direct dependencies (COMPAT && BINFMT_ELF):  => N/A
	warning: (CRYPTO_LRW && CRYPTO && EXPERIMENTAL || CRYPTO_XTS && CRYPTO && EXPERIMENTAL || CRYPTO_GHASH && CRYPTO) selects CRYPTO_GF128MUL which has unmet direct dependencies (CRYPTO && EXPERIMENTAL):  => N/A
	warning: (ETRAX_USB_HOST && ETRAX_ARCH_V10 || MOUSE_APPLETOUCH && !S390 && INPUT && INPUT_MOUSE && USB_ARCH_HAS_HCD || MOUSE_BCM5974 && !S390 && INPUT && INPUT_MOUSE && USB_ARCH_HAS_HCD || JOYSTICK_XPAD && !S390 && INPUT && INPUT_JOYSTICK && USB_ARCH_HAS_HCD || TABLET_USB_ACECAD && !S390 && INPUT && INPUT_TABLET && USB_ARCH_HAS_HCD || TABLET_USB_AIPTEK && !S390 && INPUT && INPUT_TABLET && USB_ARCH_HAS_HCD || TABLET_USB_HANWANG && !S390 && INPUT && INPUT_TABLET && USB_ARCH_HAS_HCD || TABLET_USB_KBTAB && !S390 && INPUT && INPUT_TABLET && USB_ARCH_HAS_HCD || TABLET_USB_WACOM && !S390 && INPUT && INPUT_TABLET && USB_ARCH_HAS_HCD || TOUCHSCREEN_USB_COMPOSITE && !S390 && INPUT && INPUT_TOUCHSCREEN && USB_ARCH_HAS_HCD || INPUT_ATI_REMOTE && !S390 && INPUT && INPUT_MISC && USB_ARCH_HAS_HCD || INPUT_ATI_REMOTE2 && !S390 && INPUT && INPUT_MISC && USB_ARCH_HAS_HCD || INPUT_KEYSPAN_REMOTE && !S390 && INPUT && INPUT_MISC && EXPERIMENTAL && USB_ARCH_HAS_HCD || INPUT_POWERMATE && !S390 && INPUT && INPUT_MISC && USB_ARCH_HAS_HCD || INPUT_YEALINK && !S390 && INPUT && INPUT_MISC && EXPERIMENTAL && USB_ARCH_HAS_HCD || INPUT_CM109 && !S390 && INPUT && INPUT_MISC && EXPERIMENTAL && USB_ARCH_HAS_HCD) selects USB which has unmet direct dependencies (USB_SUPPORT && USB_ARCH_HAS_HCD):  => N/A
	warning: (GENERIC_ACL || EXT2_FS_POSIX_ACL && BLOCK && EXT2_FS_XATTR || EXT3_FS_POSIX_ACL && BLOCK && EXT3_FS_XATTR || EXT4_FS_POSIX_ACL && BLOCK && EXT4_FS_XATTR || REISERFS_FS_POSIX_ACL && BLOCK && REISERFS_FS_XATTR || JFS_POSIX_ACL && BLOCK && JFS_FS || XFS_POSIX_ACL && BLOCK && XFS_FS || GFS2_FS && BLOCK && (64BIT || LBDAF) || OCFS2_FS && BLOCK && NET && SYSFS || BTRFS_FS_POSIX_ACL && BLOCK && BTRFS_FS || JFFS2_FS_POSIX_ACL && MISC_FILESYSTEMS && JFFS2_FS_XATTR || NFSD_V4 && NETWORK_FILESYSTEMS && NFSD && PROC_FS && EXPERIMENTAL || NFS_ACL_SUPPORT && NETWORK_FILESYSTEMS || 9P_FS_POSIX_ACL && NETWORK_FILESYSTEMS && 9P_FS) selects FS_POSIX_ACL which has unmet direct dependencies (BLOCK):  => N/A
	warning: (GPIO_RDC321X && PCI && GPIOLIB) selects MFD_RDC321X which has unmet direct dependencies (MFD_SUPPORT && PCI):  => N/A
	warning: (GPIO_VX855 && GPIOLIB) selects MFD_VX855 which has unmet direct dependencies (MFD_SUPPORT && PCI):  => N/A
	warning: (I2C_ISCH && I2C && PCI || GPIO_SCH && GPIOLIB && PCI || GPIO_VX855 && GPIOLIB || GPIO_RDC321X && PCI && GPIOLIB || MFD_88PM860X && MFD_SUPPORT && I2C=y && GENERIC_HARDIRQS || MFD_ASIC3 && MFD_SUPPORT && GENERIC_HARDIRQS && GPIOLIB && ARM || MFD_SH_MOBILE_SDHI && MFD_SUPPORT && (SUPERH || ARCH_SHMOBILE) || MFD_DAVINCI_VOICECODEC && MFD_SUPPORT || HTC_PASIC3 && MFD_SUPPORT || TPS6507X && MFD_SUPPORT && I2C || TWL4030_CODEC && MFD_SUPPORT && TWL4030_CORE || MFD_STMPE && MFD_SUPPORT && I2C=y && GENERIC_HARDIRQS || MFD_TC35892 && MFD_SUPPORT && I2C=y && GENERIC_HARDIRQS || MFD_T7L66XB && MFD_SUPPORT && ARM && HAVE_CLK || MFD_TC6387XB && MFD_SUPPORT && ARM && HAVE_CLK || MFD_TC6393XB && MFD_SUPPORT && GPIOLIB && ARM || MFD_MAX8925 && MFD_SUPPORT && I2C=y && GENERIC_HARDIRQS || MFD_MAX8998 && MFD_SUPPORT && I2C=y && GENERIC_HARDIRQS || MFD_WM8400 && MFD_SUPPORT && I2C || MFD_WM831X_I2C && MFD_SUPPORT && I2C=y && GENERIC_HARDIRQS || MFD_WM831X_SPI && MFD_SUPPORT && SPI_MASTER && GENERIC_HARDIRQS || MFD_WM8994 && MFD_SUPPORT && I2C=y && GENERIC_HARDIRQS || MFD_MC13XXX && MFD_SUPPORT && SPI_MASTER || AB3100_CORE && MFD_SUPPORT && I2C=y && ABX500_CORE || AB8500_CORE && MFD_SUPPORT && GENERIC_HARDIRQS && ABX500_CORE && SPI_MASTER && ARCH_U8500 || AB3550_CORE && MFD_SUPPORT && I2C=y && GENERIC_HARDIRQS && ABX500_CORE || MFD_TIMBERDALE && MFD_SUPPORT && PCI && GPIOLIB || LPC_SCH && MFD_SUPPORT && PCI || MFD_RDC321X && MFD_SUPPORT && PCI || MFD_JANZ_CMODIO && MFD_SUPPORT && PCI || MFD_JZ4740_ADC && MFD_SUPPORT && MACH_JZ4740 || MFD_TPS6586X && MFD_SUPPORT && I2C=y && GPIOLIB && GENERIC_HARDIRQS || MFD_VX855 && MFD_SUPPORT && PCI) selects MFD_CORE which has unmet direct dependencies (MFD_SUPPORT):  => N/A
	warning: (I2C_ISCH && I2C && PCI || GPIO_SCH && GPIOLIB && PCI) selects LPC_SCH which has unmet direct dependencies (MFD_SUPPORT && PCI):  => N/A
	warning: (IA32_EMULATION && X86_64) selects COMPAT_BINFMT_ELF which has unmet direct dependencies (COMPAT && BINFMT_ELF):  => N/A
	warning: (LGUEST_GUEST && PARAVIRT_GUEST && X86_32 || VIRTIO_PCI && VIRTUALIZATION && PCI && EXPERIMENTAL || VIRTIO_BALLOON && VIRTUALIZATION) selects VIRTIO which has unmet direct dependencies (VIRTUALIZATION):  => N/A
	warning: (LGUEST_GUEST && PARAVIRT_GUEST && X86_32 || VIRTIO_PCI && VIRTUALIZATION && PCI && EXPERIMENTAL || VIRTIO_BALLOON && VIRTUALIZATION) selects VIRTIO_RING which has unmet direct dependencies (VIRTUALIZATION && VIRTIO):  => N/A
	warning: (LOCKDEP && DEBUG_KERNEL && TRACE_IRQFLAGS_SUPPORT && STACKTRACE_SUPPORT && LOCKDEP_SUPPORT && !MIPS && !PPC && !ARM_UNWIND && !S390 && !MICROBLAZE || FAULT_INJECTION_STACKTRACE_FILTER && FAULT_INJECTION_DEBUG_FS && STACKTRACE_SUPPORT && !X86_64 && !PPC && !S390 && !MICROBLAZE || LATENCYTOP && HAVE_LATENCYTOP_SUPPORT && DEBUG_KERNEL && STACKTRACE_SUPPORT && PROC_FS && !MIPS && !PPC && !S390 && !MICROBLAZE || FUNCTION_TRACER && TRACING_SUPPORT && FTRACE && HAVE_FUNCTION_TRACER && !ARM_UNWIND && !S390 || KMEMCHECK && HAVE_ARCH_KMEMCHECK && DEBUG_KERNEL && !X86_USE_3DNOW && (SLUB || SLAB) && !CC_OPTIMIZE_FOR_SIZE && !FUNCTION_TRACER) selects FRAME_POINTER which has unmet direct dependencies (DEBUG_KERNEL && (CRIS || M68K || M68KNOMMU || FRV || UML || AVR32 || SUPERH || BLACKFIN || MN10300) || ARCH_WANT_FRAME_POINTERS):  => N/A
	warning: (MAC80211_LEDS && NET && WIRELESS && MAC80211 || ADB_PMU_LED_IDE && MACINTOSH_DRIVERS && ADB_PMU_LED || INPUT_WINBOND_CIR && !S390 && INPUT && INPUT_MISC && X86 && PNP || LEDS_COBALT_RAQ && NEW_LEDS && LEDS_CLASS && MIPS_COBALT || LEDS_SUNFIRE && NEW_LEDS && LEDS_CLASS && SPARC64) selects LEDS_TRIGGERS which has unmet direct dependencies (NEW_LEDS && LEDS_CLASS):  => N/A
	warning: (MEDIA_TUNER && MEDIA_SUPPORT && VIDEO_MEDIA && I2C && !MEDIA_TUNER_CUSTOMISE || DVB_USB_AF9015 && MEDIA_SUPPORT && DVB_CAPTURE_DRIVERS && DVB_CORE && DVB_USB && !MEDIA_TUNER_CUSTOMISE) selects MEDIA_TUNER_MC44S803 which has unmet direct dependencies (MEDIA_SUPPORT && MEDIA_TUNER_CUSTOMISE && VIDEO_MEDIA && I2C):  => N/A
	warning: (MEDIA_TUNER && MEDIA_SUPPORT && VIDEO_MEDIA && I2C && !MEDIA_TUNER_CUSTOMISE || MEDIA_TUNER_SIMPLE && MEDIA_SUPPORT && MEDIA_TUNER_CUSTOMISE && VIDEO_MEDIA && I2C) selects MEDIA_TUNER_TDA9887 which has unmet direct dependencies (MEDIA_SUPPORT && MEDIA_TUNER_CUSTOMISE && VIDEO_MEDIA && I2C):  => N/A
	warning: (MEDIA_TUNER && MEDIA_SUPPORT && VIDEO_MEDIA && I2C && !MEDIA_TUNER_CUSTOMISE || VIDEO_CX23885 && MEDIA_SUPPORT && VIDEO_CAPTURE_DRIVERS && VIDEO_V4L2 && DVB_CORE && VIDEO_DEV && PCI && I2C && INPUT && IR_CORE && !MEDIA_TUNER_CUSTOMISE || DVB_USB_DIB0700 && MEDIA_SUPPORT && DVB_CAPTURE_DRIVERS && DVB_CORE && DVB_USB && !MEDIA_TUNER_CUSTOMISE || DVB_USB_CXUSB && MEDIA_SUPPORT && DVB_CAPTURE_DRIVERS && DVB_CORE && DVB_USB && !MEDIA_TUNER_CUSTOMISE || VIDEO_TM6000 && STAGING && !STAGING_EXCLUDE_BUILD && VIDEO_DEV && I2C && INPUT && IR_CORE && USB && EXPERIMENTAL) selects MEDIA_TUNER_XC2028 which has unmet direct dependencies (MEDIA_SUPPORT && MEDIA_TUNER_CUSTOMISE && VIDEO_MEDIA && I2C):  => N/A
	warning: (MEDIA_TUNER && MEDIA_SUPPORT && VIDEO_MEDIA && I2C && !MEDIA_TUNER_CUSTOMISE || VIDEO_CX23885 && MEDIA_SUPPORT && VIDEO_CAPTURE_DRIVERS && VIDEO_V4L2 && DVB_CORE && VIDEO_DEV && PCI && I2C && INPUT && IR_CORE && !MEDIA_TUNER_CUSTOMISE || VIDEO_AU0828 && MEDIA_SUPPORT && VIDEO_CAPTURE_DRIVERS && I2C && INPUT && DVB_CORE && USB && VIDEO_V4L2 && !MEDIA_TUNER_CUSTOMISE || VIDEO_CX231XX_DVB && MEDIA_SUPPORT && VIDEO_CAPTURE_DRIVERS && VIDEO_V4L2 && V4L_USB_DRIVERS && USB && VIDEO_CX231XX && DVB_CORE && !DVB_FE_CUSTOMISE || DVB_USB_DIB0700 && MEDIA_SUPPORT && DVB_CAPTURE_DRIVERS && DVB_CORE && DVB_USB && !MEDIA_TUNER_CUSTOMISE || VIDEO_TM6000 && STAGING && !STAGING_EXCLUDE_BUILD && VIDEO_DEV && I2C && INPUT && IR_CORE && USB && EXPERIMENTAL) selects MEDIA_TUNER_XC5000 which has unmet direct dependencies (MEDIA_SUPPORT && MEDIA_TUNER_CUSTOMISE && VIDEO_MEDIA && I2C):  => N/A
	warning: (MEDIA_TUNER && MEDIA_SUPPORT && VIDEO_MEDIA && I2C && !MEDIA_TUNER_CUSTOMISE || VIDEO_SAA7134_DVB && MEDIA_SUPPORT && VIDEO_CAPTURE_DRIVERS && VIDEO_V4L2 && VIDEO_SAA7134 && DVB_CORE && !MEDIA_TUNER_CUSTOMISE || VIDEO_CX23885 && MEDIA_SUPPORT && VIDEO_CAPTURE_DRIVERS && VIDEO_V4L2 && DVB_CORE && VIDEO_DEV && PCI && I2C && INPUT && IR_CORE && !MEDIA_TUNER_CUSTOMISE || VIDEO_PVRUSB2_DVB && MEDIA_SUPPORT && VIDEO_CAPTURE_DRIVERS && VIDEO_V4L2 && V4L_USB_DRIVERS && USB && VIDEO_PVRUSB2 && DVB_CORE && EXPERIMENTAL && !MEDIA_TUNER_CUSTOMISE) selects MEDIA_TUNER_TDA8290 which has unmet direct dependencies (MEDIA_SUPPORT && MEDIA_TUNER_CUSTOMISE && VIDEO_MEDIA && I2C):  => N/A
	warning: (MEDIA_TUNER && MEDIA_SUPPORT && VIDEO_MEDIA && I2C && !MEDIA_TUNER_CUSTOMISE || VIDEO_SAA7134_DVB && MEDIA_SUPPORT && VIDEO_CAPTURE_DRIVERS && VIDEO_V4L2 && VIDEO_SAA7134 && DVB_CORE && !MEDIA_TUNER_CUSTOMISE || VIDEO_CX88_DVB && MEDIA_SUPPORT && VIDEO_CAPTURE_DRIVERS && VIDEO_V4L2 && VIDEO_CX88 && DVB_CORE && !MEDIA_TUNER_CUSTOMISE || VIDEO_PVRUSB2_DVB && MEDIA_SUPPORT && VIDEO_CAPTURE_DRIVERS && VIDEO_V4L2 && V4L_USB_DRIVERS && USB && VIDEO_PVRUSB2 && DVB_CORE && EXPERIMENTAL && !MEDIA_TUNER_CUSTOMISE || DVB_USB_CXUSB && MEDIA_SUPPORT && DVB_CAPTURE_DRIVERS && DVB_CORE && DVB_USB && !MEDIA_TUNER_CUSTOMISE || DVB_USB_M920X && MEDIA_SUPPORT && DVB_CAPTURE_DRIVERS && DVB_CORE && DVB_USB && !MEDIA_TUNER_CUSTOMISE || DVB_B2C2_FLEXCOP && MEDIA_SUPPORT && DVB_CAPTURE_DRIVERS && DVB_CORE && I2C && !MEDIA_TUNER_CUSTOMISE || DVB_BT8XX && MEDIA_SUPPORT && DVB_CAPTURE_DRIVERS && DVB_CORE && PCI && I2C && VIDEO_BT848 && !MEDIA_TUNER_CUSTOMISE) selects MEDIA_TUNER_SIMPLE which has unmet direct dependencies (MEDIA_SUPPORT && MEDIA_TUNER_CUSTOMISE && VIDEO_MEDIA && I2C):  => N/A
	warning: (MEDIA_TUNER && MEDIA_SUPPORT && VIDEO_MEDIA && I2C && !MEDIA_TUNER_CUSTOMISE) selects MEDIA_TUNER_MT20XX which has unmet direct dependencies (MEDIA_SUPPORT && MEDIA_TUNER_CUSTOMISE && VIDEO_MEDIA && I2C):  => N/A
	warning: (MEDIA_TUNER && MEDIA_SUPPORT && VIDEO_MEDIA && I2C && !MEDIA_TUNER_CUSTOMISE) selects MEDIA_TUNER_TEA5761 which has unmet direct dependencies (MEDIA_SUPPORT && MEDIA_TUNER_CUSTOMISE && VIDEO_MEDIA && I2C && EXPERIMENTAL):  => N/A
	warning: (MEDIA_TUNER && MEDIA_SUPPORT && VIDEO_MEDIA && I2C && !MEDIA_TUNER_CUSTOMISE) selects MEDIA_TUNER_TEA5767 which has unmet direct dependencies (MEDIA_SUPPORT && MEDIA_TUNER_CUSTOMISE && VIDEO_MEDIA && I2C):  => N/A
	warning: (MPC836x_RDK && PPC_83xx || MTD_NAND_FSL_ELBC && MTD && MTD_NAND && PPC_OF || MTD_NAND_FSL_UPM && MTD && MTD_NAND && (PPC_83xx || PPC_85xx)) selects FSL_LBC which has unmet direct dependencies (FSL_SOC):  => N/A
	warning: (MTD_NAND && MTD || MTD_DOC2000 && MTD || MTD_DOC2001 && MTD || MTD_DOC2001PLUS && MTD) selects MTD_NAND_IDS which has unmet direct dependencies (MTD && MTD_NAND):  => N/A
	warning: (NETFILTER_XT_MATCH_REALM && NET && INET && NETFILTER && NETFILTER_XTABLES && NETFILTER_ADVANCED || NET_CLS_ROUTE4 && NET && NET_SCHED) selects NET_CLS_ROUTE which has unmet direct dependencies (NET && NET_SCHED):  => N/A
	warning: (PAGE_POISONING && DEBUG_KERNEL && !ARCH_SUPPORTS_DEBUG_PAGEALLOC && !HIBERNATION) selects DEBUG_PAGEALLOC which has unmet direct dependencies (DEBUG_KERNEL && ARCH_SUPPORTS_DEBUG_PAGEALLOC && (!HIBERNATION || !PPC && !SPARC) && !KMEMCHECK):  => N/A
	warning: (PARISC) selects GENERIC_HARDIRQS_NO__DO_IRQ which has unmet direct dependencies (HAVE_GENERIC_HARDIRQS):  => N/A
	warning: (PERF_EVENTS && HAVE_PERF_EVENTS) selects IRQ_WORK which has unmet direct dependencies (HAVE_IRQ_WORK):  => N/A
	warning: (PPP && NETDEVICES || SLIP_COMPRESSED && NETDEVICES && SLIP || ISDN_PPP && ISDN && ISDN_I4L && INET) selects SLHC which has unmet direct dependencies (NETDEVICES):  => N/A
	warning: (RADIO_MIROPCM20 && MEDIA_SUPPORT && RADIO_ADAPTERS && ISA && VIDEO_V4L2 && SND) selects SND_ISA which has unmet direct dependencies (SOUND && !M68K && SND && ISA && ISA_DMA_API):  => N/A
	warning: (SFC && NETDEVICES && NETDEV_10000 && PCI && INET || I2C_VIA && I2C && PCI && EXPERIMENTAL || I2C_HYDRA && I2C && PCI && PPC_CHRP && EXPERIMENTAL || I2C_GPIO && I2C && GENERIC_GPIO || I2C_IXP2000 && I2C && ARCH_IXP2000 || I2C_SIMTEC && I2C || I2C_VERSATILE && I2C && (ARCH_VERSATILE || ARCH_REALVIEW || ARCH_VEXPRESS) || I2C_PARPORT && I2C && PARPORT || I2C_PARPORT_LIGHT && I2C || I2C_ACORN && I2C && ARCH_ACORN || SCx200_I2C && I2C && SCx200_GPIO || VIDEO_BT848 && MEDIA_SUPPORT && VIDEO_CAPTURE_DRIVERS && VIDEO_DEV && PCI && I2C && VIDEO_V4L2 && INPUT && VIDEO_IR || VIDEO_CX88 && MEDIA_SUPPORT && VIDEO_CAPTURE_DRIVERS && VIDEO_V4L2 && VIDEO_DEV && PCI && I2C && INPUT && VIDEO_IR || VIDEO_CX23885 && MEDIA_SUPPORT && VIDEO_CAPTURE_DRIVERS && VIDEO_V4L2 && DVB_CORE && VIDEO_DEV && PCI && I2C && INPUT && IR_CORE || VIDEO_AU0828 && MEDIA_SUPPORT && VIDEO_CAPTURE_DRIVERS && I2C && INPUT && DVB_CORE && USB && VIDEO_V4L2 || VIDEO_IVTV && MEDIA_SUPPORT && VIDEO_CAPTURE_DRIVERS && VIDEO_V4L2 && PCI && I2C && INPUT && VIDEO_IR || VIDEO_CX18 && MEDIA_SUPPORT && VIDEO_CAPTURE_DRIVERS && VIDEO_V4L2 && DVB_CORE && PCI && I2C && EXPERIMENTAL && INPUT && VIDEO_IR || VIDEO_SAA7164 && MEDIA_SUPPORT && VIDEO_CAPTURE_DRIVERS && VIDEO_V4L2 && DVB_CORE && PCI && I2C || DVB_PLUTO2 && MEDIA_SUPPORT && DVB_CAPTURE_DRIVERS && DVB_CORE && PCI && I2C || DRM && HAS_IOMEM && (AGP || AGP=n) && !EMULATED_CMPXCHG && MMU || FB_DDC && HAS_IOMEM && FB || FB_VIA && HAS_IOMEM && FB && PCI && X86 || VIDEO_CX25821 && STAGING && !STAGING_EXCLUDE_BUILD && DVB_CORE && VIDEO_DEV && PCI && I2C && INPUT && BKL && VIDEO_IR) selects I2C_ALGOBIT which has unmet direct dependencies (I2C && I2C_HELPER_AUTO):  => N/A
	warning: (SINGLE_MEMORY_CHUNK) selects NEED_MULTIPLE_NODES which has unmet direct dependencies (DISCONTIGMEM || NUMA):  => N/A
	warning: (SMP && SYS_SUPPORTS_SMP) selects IRQ_PER_CPU which has unmet direct dependencies (HAVE_GENERIC_HARDIRQS):  => N/A
	warning: (USB_WUSB && USB_SUPPORT && EXPERIMENTAL && USB) selects UWB which has unmet direct dependencies (EXPERIMENTAL && PCI):  => N/A
	warning: (VIDEO_BT848 && MEDIA_SUPPORT && VIDEO_CAPTURE_DRIVERS && VIDEO_DEV && PCI && I2C && VIDEO_V4L2 && INPUT && VIDEO_IR && VIDEO_HELPER_CHIPS_AUTO || VIDEO_IVTV && MEDIA_SUPPORT && VIDEO_CAPTURE_DRIVERS && VIDEO_V4L2 && PCI && I2C && INPUT && VIDEO_IR || VIDEO_PVRUSB2 && MEDIA_SUPPORT && VIDEO_CAPTURE_DRIVERS && V4L_USB_DRIVERS && USB && VIDEO_V4L2 && I2C && VIDEO_MEDIA || VIDEO_EM28XX && MEDIA_SUPPORT && VIDEO_CAPTURE_DRIVERS && VIDEO_V4L2 && V4L_USB_DRIVERS && USB && VIDEO_DEV && I2C && INPUT && VIDEO_IR && VIDEO_HELPER_CHIPS_AUTO) selects VIDEO_MSP3400 which has unmet direct dependencies (MEDIA_SUPPORT && VIDEO_CAPTURE_DRIVERS && !VIDEO_HELPER_CHIPS_AUTO && VIDEO_V4L2 && I2C):  => N/A
	warning: (VIDEO_BT848 && MEDIA_SUPPORT && VIDEO_CAPTURE_DRIVERS && VIDEO_DEV && PCI && I2C && VIDEO_V4L2 && INPUT && VIDEO_IR && VIDEO_HELPER_CHIPS_AUTO || VIDEO_SAA7134 && MEDIA_SUPPORT && VIDEO_CAPTURE_DRIVERS && VIDEO_V4L2 && VIDEO_DEV && PCI && I2C && VIDEO_HELPER_CHIPS_AUTO) selects VIDEO_SAA6588 which has unmet direct dependencies (MEDIA_SUPPORT && VIDEO_CAPTURE_DRIVERS && !VIDEO_HELPER_CHIPS_AUTO && VIDEO_V4L2 && I2C):  => N/A
	warning: (VIDEO_BT848 && MEDIA_SUPPORT && VIDEO_CAPTURE_DRIVERS && VIDEO_DEV && PCI && I2C && VIDEO_V4L2 && INPUT && VIDEO_IR && VIDEO_HELPER_CHIPS_AUTO) selects VIDEO_TDA7432 which has unmet direct dependencies (MEDIA_SUPPORT && VIDEO_CAPTURE_DRIVERS && !VIDEO_HELPER_CHIPS_AUTO && VIDEO_V4L2 && I2C):  => N/A
	warning: (VIDEO_BT848 && MEDIA_SUPPORT && VIDEO_CAPTURE_DRIVERS && VIDEO_DEV && PCI && I2C && VIDEO_V4L2 && INPUT && VIDEO_IR && VIDEO_HELPER_CHIPS_AUTO) selects VIDEO_TVAUDIO which has unmet direct dependencies (MEDIA_SUPPORT && VIDEO_CAPTURE_DRIVERS && !VIDEO_HELPER_CHIPS_AUTO && VIDEO_V4L2 && I2C):  => N/A
	warning: (VIDEO_CAFE_CCIC && MEDIA_SUPPORT && VIDEO_CAPTURE_DRIVERS && PCI && I2C && VIDEO_V4L2 || VIDEO_VIA_CAMERA && MEDIA_SUPPORT && VIDEO_CAPTURE_DRIVERS && VIDEO_V4L2 && FB_VIA) selects VIDEO_OV7670 which has unmet direct dependencies (MEDIA_SUPPORT && VIDEO_CAPTURE_DRIVERS && !VIDEO_HELPER_CHIPS_AUTO && I2C && VIDEO_V4L2):  => N/A
	warning: (VIDEO_CX18 && MEDIA_SUPPORT && VIDEO_CAPTURE_DRIVERS && VIDEO_V4L2 && DVB_CORE && PCI && I2C && EXPERIMENTAL && INPUT && VIDEO_IR) selects VIDEO_CS5345 which has unmet direct dependencies (MEDIA_SUPPORT && VIDEO_CAPTURE_DRIVERS && !VIDEO_HELPER_CHIPS_AUTO && VIDEO_V4L2 && I2C):  => N/A
	warning: (VIDEO_CX23885 && MEDIA_SUPPORT && VIDEO_CAPTURE_DRIVERS && VIDEO_V4L2 && DVB_CORE && VIDEO_DEV && PCI && I2C && INPUT && IR_CORE || VIDEO_IVTV && MEDIA_SUPPORT && VIDEO_CAPTURE_DRIVERS && VIDEO_V4L2 && PCI && I2C && INPUT && VIDEO_IR || VIDEO_PVRUSB2 && MEDIA_SUPPORT && VIDEO_CAPTURE_DRIVERS && V4L_USB_DRIVERS && USB && VIDEO_V4L2 && I2C && VIDEO_MEDIA || VIDEO_CX231XX && MEDIA_SUPPORT && VIDEO_CAPTURE_DRIVERS && VIDEO_V4L2 && V4L_USB_DRIVERS && USB && VIDEO_DEV && I2C && INPUT && VIDEO_IR || VIDEO_CX25821 && STAGING && !STAGING_EXCLUDE_BUILD && DVB_CORE && VIDEO_DEV && PCI && I2C && INPUT && BKL && VIDEO_IR) selects VIDEO_CX25840 which has unmet direct dependencies (MEDIA_SUPPORT && VIDEO_CAPTURE_DRIVERS && !VIDEO_HELPER_CHIPS_AUTO && VIDEO_V4L2 && I2C):  => N/A
	warning: (VIDEO_CX88 && MEDIA_SUPPORT && VIDEO_CAPTURE_DRIVERS && VIDEO_V4L2 && VIDEO_DEV && PCI && I2C && INPUT && VIDEO_IR && VIDEO_HELPER_CHIPS_AUTO || VIDEO_IVTV && MEDIA_SUPPORT && VIDEO_CAPTURE_DRIVERS && VIDEO_V4L2 && PCI && I2C && INPUT && VIDEO_IR || VIDEO_PVRUSB2 && MEDIA_SUPPORT && VIDEO_CAPTURE_DRIVERS && V4L_USB_DRIVERS && USB && VIDEO_V4L2 && I2C && VIDEO_MEDIA) selects VIDEO_WM8775 which has unmet direct dependencies (MEDIA_SUPPORT && VIDEO_CAPTURE_DRIVERS && !VIDEO_HELPER_CHIPS_AUTO && VIDEO_V4L2 && I2C):  => N/A
	warning: (VIDEO_CX88_BLACKBIRD && MEDIA_SUPPORT && VIDEO_CAPTURE_DRIVERS && VIDEO_V4L2 && VIDEO_CX88 || VIDEO_CX23885 && MEDIA_SUPPORT && VIDEO_CAPTURE_DRIVERS && VIDEO_V4L2 && DVB_CORE && VIDEO_DEV && PCI && I2C && INPUT && IR_CORE || VIDEO_IVTV && MEDIA_SUPPORT && VIDEO_CAPTURE_DRIVERS && VIDEO_V4L2 && PCI && I2C && INPUT && VIDEO_IR || VIDEO_CX18 && MEDIA_SUPPORT && VIDEO_CAPTURE_DRIVERS && VIDEO_V4L2 && DVB_CORE && PCI && I2C && EXPERIMENTAL && INPUT && VIDEO_IR || VIDEO_PVRUSB2 && MEDIA_SUPPORT && VIDEO_CAPTURE_DRIVERS && V4L_USB_DRIVERS && USB && VIDEO_V4L2 && I2C && VIDEO_MEDIA || VIDEO_CX231XX && MEDIA_SUPPORT && VIDEO_CAPTURE_DRIVERS && VIDEO_V4L2 && V4L_USB_DRIVERS && USB && VIDEO_DEV && I2C && INPUT && VIDEO_IR || VIDEO_CX25821 && STAGING && !STAGING_EXCLUDE_BUILD && DVB_CORE && VIDEO_DEV && PCI && I2C && INPUT && BKL && VIDEO_IR) selects VIDEO_CX2341X which has unmet direct dependencies (MEDIA_SUPPORT && VIDEO_CAPTURE_DRIVERS && !VIDEO_HELPER_CHIPS_AUTO && VIDEO_V4L2 && VIDEO_V4L2_COMMON):  => N/A
	warning: (VIDEO_EM28XX && MEDIA_SUPPORT && VIDEO_CAPTURE_DRIVERS && VIDEO_V4L2 && V4L_USB_DRIVERS && USB && VIDEO_DEV && I2C && INPUT && VIDEO_IR && VIDEO_HELPER_CHIPS_AUTO) selects VIDEO_MT9V011 which has unmet direct dependencies (MEDIA_SUPPORT && VIDEO_CAPTURE_DRIVERS && !VIDEO_HELPER_CHIPS_AUTO && I2C && VIDEO_V4L2):  => N/A
	warning: (VIDEO_EM28XX && MEDIA_SUPPORT && VIDEO_CAPTURE_DRIVERS && VIDEO_V4L2 && V4L_USB_DRIVERS && USB && VIDEO_DEV && I2C && INPUT && VIDEO_IR && VIDEO_HELPER_CHIPS_AUTO) selects VIDEO_TVP5150 which has unmet direct dependencies (MEDIA_SUPPORT && VIDEO_CAPTURE_DRIVERS && !VIDEO_HELPER_CHIPS_AUTO && VIDEO_V4L2 && I2C):  => N/A
	warning: (VIDEO_IVTV && MEDIA_SUPPORT && VIDEO_CAPTURE_DRIVERS && VIDEO_V4L2 && PCI && I2C && INPUT && VIDEO_IR || VIDEO_PVRUSB2 && MEDIA_SUPPORT && VIDEO_CAPTURE_DRIVERS && V4L_USB_DRIVERS && USB && VIDEO_V4L2 && I2C && VIDEO_MEDIA) selects VIDEO_CS53L32A which has unmet direct dependencies (MEDIA_SUPPORT && VIDEO_CAPTURE_DRIVERS && !VIDEO_HELPER_CHIPS_AUTO && VIDEO_V4L2 && I2C):  => N/A
	warning: (VIDEO_IVTV && MEDIA_SUPPORT && VIDEO_CAPTURE_DRIVERS && VIDEO_V4L2 && PCI && I2C && INPUT && VIDEO_IR) selects VIDEO_M52790 which has unmet direct dependencies (MEDIA_SUPPORT && VIDEO_CAPTURE_DRIVERS && !VIDEO_HELPER_CHIPS_AUTO && VIDEO_V4L2 && I2C):  => N/A
	warning: (VIDEO_IVTV && MEDIA_SUPPORT && VIDEO_CAPTURE_DRIVERS && VIDEO_V4L2 && PCI && I2C && INPUT && VIDEO_IR) selects VIDEO_SAA7127 which has unmet direct dependencies (MEDIA_SUPPORT && VIDEO_CAPTURE_DRIVERS && !VIDEO_HELPER_CHIPS_AUTO && VIDEO_V4L2 && I2C):  => N/A
	warning: (VIDEO_IVTV && MEDIA_SUPPORT && VIDEO_CAPTURE_DRIVERS && VIDEO_V4L2 && PCI && I2C && INPUT && VIDEO_IR) selects VIDEO_SAA717X which has unmet direct dependencies (MEDIA_SUPPORT && VIDEO_CAPTURE_DRIVERS && !VIDEO_HELPER_CHIPS_AUTO && VIDEO_V4L2 && I2C):  => N/A
	warning: (VIDEO_IVTV && MEDIA_SUPPORT && VIDEO_CAPTURE_DRIVERS && VIDEO_V4L2 && PCI && I2C && INPUT && VIDEO_IR) selects VIDEO_UPD64031A which has unmet direct dependencies (MEDIA_SUPPORT && VIDEO_CAPTURE_DRIVERS && !VIDEO_HELPER_CHIPS_AUTO && VIDEO_V4L2 && I2C):  => N/A
	warning: (VIDEO_IVTV && MEDIA_SUPPORT && VIDEO_CAPTURE_DRIVERS && VIDEO_V4L2 && PCI && I2C && INPUT && VIDEO_IR) selects VIDEO_UPD64083 which has unmet direct dependencies (MEDIA_SUPPORT && VIDEO_CAPTURE_DRIVERS && !VIDEO_HELPER_CHIPS_AUTO && VIDEO_V4L2 && I2C):  => N/A
	warning: (VIDEO_IVTV && MEDIA_SUPPORT && VIDEO_CAPTURE_DRIVERS && VIDEO_V4L2 && PCI && I2C && INPUT && VIDEO_IR) selects VIDEO_VP27SMPX which has unmet direct dependencies (MEDIA_SUPPORT && VIDEO_CAPTURE_DRIVERS && !VIDEO_HELPER_CHIPS_AUTO && VIDEO_V4L2 && I2C):  => N/A
	warning: (VIDEO_IVTV && MEDIA_SUPPORT && VIDEO_CAPTURE_DRIVERS && VIDEO_V4L2 && PCI && I2C && INPUT && VIDEO_IR) selects VIDEO_WM8739 which has unmet direct dependencies (MEDIA_SUPPORT && VIDEO_CAPTURE_DRIVERS && !VIDEO_HELPER_CHIPS_AUTO && VIDEO_V4L2 && I2C):  => N/A
	warning: (VIDEO_MXB && MEDIA_SUPPORT && VIDEO_CAPTURE_DRIVERS && PCI && VIDEO_V4L2 && I2C && VIDEO_HELPER_CHIPS_AUTO) selects VIDEO_TDA9840 which has unmet direct dependencies (MEDIA_SUPPORT && VIDEO_CAPTURE_DRIVERS && VIDEO_V4L2 && !VIDEO_HELPER_CHIPS_AUTO && I2C):  => N/A
	warning: (VIDEO_MXB && MEDIA_SUPPORT && VIDEO_CAPTURE_DRIVERS && PCI && VIDEO_V4L2 && I2C && VIDEO_HELPER_CHIPS_AUTO) selects VIDEO_TEA6415C which has unmet direct dependencies (MEDIA_SUPPORT && VIDEO_CAPTURE_DRIVERS && VIDEO_V4L2 && !VIDEO_HELPER_CHIPS_AUTO && I2C):  => N/A
	warning: (VIDEO_MXB && MEDIA_SUPPORT && VIDEO_CAPTURE_DRIVERS && PCI && VIDEO_V4L2 && I2C && VIDEO_HELPER_CHIPS_AUTO) selects VIDEO_TEA6420 which has unmet direct dependencies (MEDIA_SUPPORT && VIDEO_CAPTURE_DRIVERS && VIDEO_V4L2 && !VIDEO_HELPER_CHIPS_AUTO && I2C):  => N/A
	warning: (VIDEO_VINO && MEDIA_SUPPORT && VIDEO_CAPTURE_DRIVERS && I2C && SGI_IP22 && EXPERIMENTAL && VIDEO_V4L2 && VIDEO_HELPER_CHIPS_AUTO) selects VIDEO_SAA7191 which has unmet direct dependencies (MEDIA_SUPPORT && VIDEO_CAPTURE_DRIVERS && !VIDEO_HELPER_CHIPS_AUTO && VIDEO_V4L2 && I2C):  => N/A
	warning: (VIDEO_ZORAN_AVS6EYES && MEDIA_SUPPORT && VIDEO_CAPTURE_DRIVERS && VIDEO_V4L2 && VIDEO_ZORAN_ZR36060 && EXPERIMENTAL && VIDEO_HELPER_CHIPS_AUTO) selects VIDEO_BT866 which has unmet direct dependencies (MEDIA_SUPPORT && VIDEO_CAPTURE_DRIVERS && !VIDEO_HELPER_CHIPS_AUTO && VIDEO_V4L2 && I2C):  => N/A
	warning: (VIDEO_ZORAN_AVS6EYES && MEDIA_SUPPORT && VIDEO_CAPTURE_DRIVERS && VIDEO_V4L2 && VIDEO_ZORAN_ZR36060 && EXPERIMENTAL && VIDEO_HELPER_CHIPS_AUTO) selects VIDEO_KS0127 which has unmet direct dependencies (MEDIA_SUPPORT && VIDEO_CAPTURE_DRIVERS && !VIDEO_HELPER_CHIPS_AUTO && VIDEO_V4L2 && I2C):  => N/A
	warning: (VIDEO_ZORAN_BUZ && MEDIA_SUPPORT && VIDEO_CAPTURE_DRIVERS && VIDEO_V4L2 && VIDEO_ZORAN_ZR36060 && VIDEO_HELPER_CHIPS_AUTO || VIDEO_ZORAN_LML33R10 && MEDIA_SUPPORT && VIDEO_CAPTURE_DRIVERS && VIDEO_V4L2 && VIDEO_ZORAN_ZR36060 && VIDEO_HELPER_CHIPS_AUTO || VIDEO_MXB && MEDIA_SUPPORT && VIDEO_CAPTURE_DRIVERS && PCI && VIDEO_V4L2 && I2C && VIDEO_HELPER_CHIPS_AUTO || VIDEO_IVTV && MEDIA_SUPPORT && VIDEO_CAPTURE_DRIVERS && VIDEO_V4L2 && PCI && I2C && INPUT && VIDEO_IR || VIDEO_PVRUSB2 && MEDIA_SUPPORT && VIDEO_CAPTURE_DRIVERS && V4L_USB_DRIVERS && USB && VIDEO_V4L2 && I2C && VIDEO_MEDIA || VIDEO_EM28XX && MEDIA_SUPPORT && VIDEO_CAPTURE_DRIVERS && VIDEO_V4L2 && V4L_USB_DRIVERS && USB && VIDEO_DEV && I2C && INPUT && VIDEO_IR && VIDEO_HELPER_CHIPS_AUTO || VIDEO_USBVISION && MEDIA_SUPPORT && VIDEO_CAPTURE_DRIVERS && V4L_USB_DRIVERS && USB && I2C && VIDEO_V4L2 && VIDEO_HELPER_CHIPS_AUTO) selects VIDEO_SAA711X which has unmet direct dependencies (MEDIA_SUPPORT && VIDEO_CAPTURE_DRIVERS && !VIDEO_HELPER_CHIPS_AUTO && VIDEO_V4L2 && I2C):  => N/A
	warning: (VIDEO_ZORAN_BUZ && MEDIA_SUPPORT && VIDEO_CAPTURE_DRIVERS && VIDEO_V4L2 && VIDEO_ZORAN_ZR36060 && VIDEO_HELPER_CHIPS_AUTO) selects VIDEO_SAA7185 which has unmet direct dependencies (MEDIA_SUPPORT && VIDEO_CAPTURE_DRIVERS && !VIDEO_HELPER_CHIPS_AUTO && VIDEO_V4L2 && I2C):  => N/A
	warning: (VIDEO_ZORAN_DC10 && MEDIA_SUPPORT && VIDEO_CAPTURE_DRIVERS && VIDEO_V4L2 && VIDEO_ZORAN_ZR36060 && VIDEO_HELPER_CHIPS_AUTO) selects VIDEO_SAA7110 which has unmet direct dependencies (MEDIA_SUPPORT && VIDEO_CAPTURE_DRIVERS && !VIDEO_HELPER_CHIPS_AUTO && VIDEO_V4L2 && I2C):  => N/A
	warning: (VIDEO_ZORAN_DC30 && MEDIA_SUPPORT && VIDEO_CAPTURE_DRIVERS && VIDEO_V4L2 && VIDEO_ZORAN && VIDEO_HELPER_CHIPS_AUTO || VIDEO_ZORAN_DC10 && MEDIA_SUPPORT && VIDEO_CAPTURE_DRIVERS && VIDEO_V4L2 && VIDEO_ZORAN_ZR36060 && VIDEO_HELPER_CHIPS_AUTO) selects VIDEO_ADV7175 which has unmet direct dependencies (MEDIA_SUPPORT && VIDEO_CAPTURE_DRIVERS && !VIDEO_HELPER_CHIPS_AUTO && VIDEO_V4L2 && I2C):  => N/A
	warning: (VIDEO_ZORAN_DC30 && MEDIA_SUPPORT && VIDEO_CAPTURE_DRIVERS && VIDEO_V4L2 && VIDEO_ZORAN && VIDEO_HELPER_CHIPS_AUTO) selects VIDEO_VPX3220 which has unmet direct dependencies (MEDIA_SUPPORT && VIDEO_CAPTURE_DRIVERS && !VIDEO_HELPER_CHIPS_AUTO && VIDEO_V4L2 && I2C):  => N/A
	warning: (VIDEO_ZORAN_LML33 && MEDIA_SUPPORT && VIDEO_CAPTURE_DRIVERS && VIDEO_V4L2 && VIDEO_ZORAN_ZR36060 && VIDEO_HELPER_CHIPS_AUTO || VIDEO_ZORAN_AVS6EYES && MEDIA_SUPPORT && VIDEO_CAPTURE_DRIVERS && VIDEO_V4L2 && VIDEO_ZORAN_ZR36060 && EXPERIMENTAL && VIDEO_HELPER_CHIPS_AUTO) selects VIDEO_BT856 which has unmet direct dependencies (MEDIA_SUPPORT && VIDEO_CAPTURE_DRIVERS && !VIDEO_HELPER_CHIPS_AUTO && VIDEO_V4L2 && I2C):  => N/A
	warning: (VIDEO_ZORAN_LML33 && MEDIA_SUPPORT && VIDEO_CAPTURE_DRIVERS && VIDEO_V4L2 && VIDEO_ZORAN_ZR36060 && VIDEO_HELPER_CHIPS_AUTO) selects VIDEO_BT819 which has unmet direct dependencies (MEDIA_SUPPORT && VIDEO_CAPTURE_DRIVERS && !VIDEO_HELPER_CHIPS_AUTO && VIDEO_V4L2 && I2C):  => N/A
	warning: (VIDEO_ZORAN_LML33R10 && MEDIA_SUPPORT && VIDEO_CAPTURE_DRIVERS && VIDEO_V4L2 && VIDEO_ZORAN_ZR36060 && VIDEO_HELPER_CHIPS_AUTO) selects VIDEO_ADV7170 which has unmet direct dependencies (MEDIA_SUPPORT && VIDEO_CAPTURE_DRIVERS && !VIDEO_HELPER_CHIPS_AUTO && VIDEO_V4L2 && I2C):  => N/A
	warning: 1 bad relocations:  => N/A

150 improvements:
	modpost: WARNING: modpost: Found 54 section mismatch(es).: N/A => 
	modpost: WARNING: modpost: Found 65 section mismatch(es).: N/A => 
	modpost: WARNING: modpost: Found 9 section mismatch(es).: N/A => 
	src/arch/sh/include/asm/ptrace.h: warning: this is the location of the previous definition: 39:1 => 
	src/arch/sh/kernel/cpu/sh4a/clock-shx3.c: warning: 'cpg_clk_init' is deprecated (declared at /scratch/kisskb/src/arch/sh/include/asm/clock.h:11): 122 => 
	src/arch/x86/kernel/apic/hw_nmi.c: warning: 'backtrace_mask' defined but not used: 21 => 
	src/arch/x86/kernel/scx200_32.c: warning: 'base' may be used uninitialized in this function: 82 => 
	src/drivers/base/power/main.c: warning: comparison of distinct pointer types lacks a cast: 415 => 
	src/drivers/block/z2ram.c: warning: format '%lu' expects type 'long unsigned int', but argument 2 has type 'sector_t': 83 => 
	src/drivers/cdrom/gdrom.c: warning: 'ctrl_inb' is deprecated (declared at /scratch/kisskb/src/arch/sh/include/asm/io.h:94): 238, 149, 538, 155, 387, 400, 548, 144, 634 => 
	src/drivers/cdrom/gdrom.c: warning: 'ctrl_inl' is deprecated (declared at /scratch/kisskb/src/arch/sh/include/asm/io.h:104): 409 => 
	src/drivers/cdrom/gdrom.c: warning: 'ctrl_inw' is deprecated (declared at /scratch/kisskb/src/arch/sh/include/asm/io.h:99): 190 => 
	src/drivers/cdrom/gdrom.c: warning: 'ctrl_outb' is deprecated (declared at /scratch/kisskb/src/arch/sh/include/asm/io.h:114): 613, 204, 206, 720, 638, 617, 205, 235, 616, 615, 183, 213, 618, 199, 202, 716, 201, 717, 619, 624 => 
	src/drivers/cdrom/gdrom.c: warning: 'ctrl_outl' is deprecated (declared at /scratch/kisskb/src/arch/sh/include/asm/io.h:124): 605, 602, 730, 731, 603, 604, 407 => 
	src/drivers/char/keyboard.c: warning: comparison is always true due to limited range of data type: 719 => 
	src/drivers/char/mem.c: warning: cast to pointer from integer of different size: 342 => 
	src/drivers/char/mxser.c: warning: 'mxser_disable_must_enchance_mode' defined but not used: 306, 307 => 
	src/drivers/char/mxser.c: warning: 'mxser_get_must_hardware_id' defined but not used: 391, 392 => 
	src/drivers/char/n_gsm.c: warning: ignoring return value of '__kfifo_must_check_helper', declared with attribute warn_unused_result: 1580 => 
	src/drivers/char/rtc.c: warning: 'rtc_freq' defined but not used: 192 => 
	src/drivers/gpio/bt8xxgpio.c: warning: ignoring return value of 'gpiochip_remove', declared with attribute warn_unused_result: 247 => 
	src/drivers/gpio/wm8994-gpio.c: warning: 'wm8994_gpio_to_irq' defined but not used: 84 => 
	src/drivers/i2c/busses/i2c-sh7760.c: warning: 'ctrl_inl' is deprecated (declared at /scratch/kisskb/src/arch/sh/include/asm/io.h:104): 109 => 
	src/drivers/i2c/busses/i2c-sh7760.c: warning: 'ctrl_outl' is deprecated (declared at /scratch/kisskb/src/arch/sh/include/asm/io.h:124): 104 => 
	src/drivers/infiniband/hw/cxgb4/cm.c: warning: cast to pointer from integer of different size: 2326 => 
	src/drivers/infiniband/hw/cxgb4/cq.c: warning: cast from pointer to integer of different size: 58, 135 => 
	src/drivers/infiniband/hw/cxgb4/mem.c: warning: cast from pointer to integer of different size: 74 => 
	src/drivers/infiniband/hw/cxgb4/qp.c: warning: cast from pointer to integer of different size: 147, 1063, 988 => 
	src/drivers/infiniband/hw/ipath/ipath_driver.c: warning: 'pnum' may be used uninitialized in this function: 1637 => 
	src/drivers/infiniband/hw/nes/nes_verbs.c: warning: cast to pointer from integer of different size: 477, 3486 => 
	src/drivers/input/keyboard/jornada680_kbd.c: warning: 'ctrl_inb' is deprecated (declared at /scratch/kisskb/src/arch/sh/include/asm/io.h:94): 170, 158, 169, 157 => 
	src/drivers/input/keyboard/jornada680_kbd.c: warning: 'ctrl_inw' is deprecated (declared at /scratch/kisskb/src/arch/sh/include/asm/io.h:99): 142, 143 => 
	src/drivers/input/keyboard/jornada680_kbd.c: warning: 'ctrl_outb' is deprecated (declared at /scratch/kisskb/src/arch/sh/include/asm/io.h:114): 152, 161, 162, 153 => 
	src/drivers/input/keyboard/jornada680_kbd.c: warning: 'ctrl_outw' is deprecated (declared at /scratch/kisskb/src/arch/sh/include/asm/io.h:119): 147, 166, 165, 148 => 
	src/drivers/input/touchscreen/hp680_ts_input.c: warning: 'ctrl_inb' is deprecated (declared at /scratch/kisskb/src/arch/sh/include/asm/io.h:94): 32, 53, 40, 31, 48 => 
	src/drivers/input/touchscreen/hp680_ts_input.c: warning: 'ctrl_outb' is deprecated (declared at /scratch/kisskb/src/arch/sh/include/asm/io.h:114): 35, 51, 43 => 
	src/drivers/media/dvb/ngene/ngene-core.c: warning: unused variable 'flags': 1308 => 
	src/drivers/media/video/sh_mobile_ceu_camera.c: warning: 'sd' is used uninitialized in this function: 1245 => 
	src/drivers/media/video/sh_mobile_ceu_camera.c: warning: 'sd' may be used uninitialized in this function: 1707, 1683, 943 => 
	src/drivers/media/video/sh_mobile_ceu_camera.c: warning: unused variable 'sd': 1648 => 
	src/drivers/media/video/videobuf-dma-sg.c: warning: comparison of distinct pointer types lacks a cast: 119, 120 => 
	src/drivers/message/fusion/mptbase.c: warning: 'seq_mpt_print_ioc_summary' defined but not used: 6810 => 
	src/drivers/message/i2o/i2o_config.c: warning: cast to pointer from integer of different size: 935, 880 => 
	src/drivers/misc/sgi-gru/grufault.c: warning: 'paddr' may be used uninitialized in this function: 265 => 
	src/drivers/misc/sgi-gru/grufault.c: warning: 'ps' may be used uninitialized in this function: 266 => 
	src/drivers/mmc/host/sdhci.c: warning: 'pwr' may be used uninitialized in this function: 1037 => 
	src/drivers/mtd/maps/solutionengine.c: warning: assignment makes pointer from integer without a cast: 74, 76 => 
	src/drivers/mtd/maps/solutionengine.c: warning: format '%08lx' expects type 'long unsigned int', but argument 2 has type 'resource_size_t': 86 => 
	src/drivers/mtd/maps/solutionengine.c: warning: format '%08lx' expects type 'long unsigned int', but argument 3 has type 'resource_size_t': 86 => 
	src/drivers/net/3c59x.c: warning: dereferencing 'void *' pointer: 3211 => 
	src/drivers/net/can/sja1000/sja1000.h: warning: "REG_SR" redefined: 60:1 => 
	src/drivers/net/pcmcia/ibmtr_cs.c: warning: 'pcmcia_request_exclusive_irq' is deprecated (declared at /scratch/kisskb/src/include/pcmcia/ds.h:200): 235 => 
	src/drivers/net/pcmcia/ibmtr_cs.c: warning: 'pcmcia_request_exclusive_irq' is deprecated (declared at /scratch/kisskb/src/include/pcmcia/ds.h:202): 235 => 
	src/drivers/net/pcmcia/nmclan_cs.c: warning: 'pcmcia_request_exclusive_irq' is deprecated (declared at /scratch/kisskb/src/include/pcmcia/ds.h:200): 650 => 
	src/drivers/net/pcmcia/nmclan_cs.c: warning: 'pcmcia_request_exclusive_irq' is deprecated (declared at /scratch/kisskb/src/include/pcmcia/ds.h:202): 650 => 
	src/drivers/net/pcmcia/smc91c92_cs.c: warning: unused variable 'smc': 1004 => 
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
	src/drivers/net/qlcnic/qlcnic_main.c: warning: 'pci_using_dac' may be used uninitialized in this function: 1340 => 
	src/drivers/net/s2io.c: warning: 'tcp_len' may be used uninitialized in this function: 7568 => 
	src/drivers/net/smc911x.c: warning: unused variable 'lp': 2127 => 
	src/drivers/net/smc911x.h: warning: control reaches end of non-void function: 135 => 
	src/drivers/net/tehuti.c: warning: passing argument 2 of 'bdx_tx_push_desc_safe' discards qualifiers from pointer target type: 330 => 
	src/drivers/net/wireless/ath/ar9170/ar9170.h: warning: control reaches end of non-void function: 76 => 
	src/drivers/net/wireless/iwmc3200wifi/rx.c: warning: comparison is always true due to limited range of data type: 1198 => 
	src/drivers/net/wireless/mwl8k.c: warning: 'ap_legacy_rates' may be used uninitialized in this function: 3403 => 
	src/drivers/net/wireless/p54/p54usb.c: warning: 'p54u_device_reset' defined but not used: 406, 407 => 
	src/drivers/parisc/led.c: warning: assignment from incompatible pointer type: 366 => 
	src/drivers/parport/parport_pc.c: warning: 'parport_pc_find_isa_ports' defined but not used: 3333 => 
	src/drivers/pcmcia/cs.c: warning: 'pcmcia_socket_dev_resume' defined but not used: 849 => 
	src/drivers/regulator/wm831x-dcdc.c: warning: control reaches end of non-void function: 124 => 
	src/drivers/rtc/rtc-rp5c01.c: warning: 'return' with a value, in function returning void: 79 => 
	src/drivers/scsi/advansys.c: warning: label 'err_unmap' defined but not used: 12377 => 
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
	src/drivers/usb/gadget/f_fs.c: warning: 'rem_type1' may be used uninitialized in this function: 1987 => 
	src/drivers/usb/gadget/r8a66597-udc.h: warning: 'data' may be used uninitialized in this function: 139 => 
	src/drivers/usb/gadget/storage_common.c: warning: 'fsg_show_nofua' defined but not used: 718, 720 => 
	src/drivers/usb/gadget/storage_common.c: warning: 'fsg_store_nofua' defined but not used: 782, 785 => 
	src/drivers/usb/host/oxu210hp-hcd.c: warning: unused variable 'base': 3906 => 
	src/drivers/usb/host/xhci-ring.c: warning: 'event_trb' may be used uninitialized in this function: 1719 => 
	src/drivers/virtio/virtio_ring.c: warning: cast to pointer from integer of different size: 274 => 
	src/drivers/xen/events.c: warning: 'gsi_from_irq' defined but not used: 187 => 
	src/drivers/xen/events.c: warning: 'mk_pirq_info' defined but not used: 141 => 
	src/drivers/xen/events.c: warning: 'vector_from_irq' defined but not used: 197 => 
	src/fs/autofs/root.c: warning: 'autofs_root_compat_ioctl' declared 'static' but never defined: 30 => 
	src/fs/autofs4/root.c: warning: 'autofs4_root_compat_ioctl' declared 'static' but never defined: 31 => 
	src/fs/ceph/messenger.c: warning: 'proto' may be used uninitialized in this function: 631 => 
	src/fs/cifs/cifssmb.c: warning: 'pdata' may be used uninitialized in this function: 3099 => 
	src/fs/fat/namei_vfat.c: warning: 'lcase' may be used uninitialized in this function: 590 => 
	src/fs/qnx4/namei.c: warning: 'ino' may be used uninitialized in this function: 104 => 
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
	src/net/dccp/ccids/ccid2.c: warning: 'veclen' may be used uninitialized in this function: 508 => 
	src/net/dccp/ccids/ccid2.c: warning: 'vector' may be used uninitialized in this function: 507 => 
	src/net/mac80211/tx.c: warning: unused variable 'mesh_hdr': 1702 => 
	src/net/rds/tcp_send.c: warning: passing argument 1 of 'virt_to_phys' makes pointer from integer without a cast: 113 => 
	src/net/sctp/socket.c: warning: 'newsock' may be used uninitialized in this function: 4036 => 
	src/sound/drivers/serial-u16550.c: warning: 'uart' may be used uninitialized in this function: 905 => 
	src/sound/oss/pss.c: warning: 'check_region' is deprecated (declared at /scratch/kisskb/src/include/linux/ioport.h:169): 676 => 
	src/sound/pci/atiixp.c: warning: 'chip' may be used uninitialized in this function: 1652 => 
	src/sound/pci/atiixp_modem.c: warning: 'chip' may be used uninitialized in this function: 1288 => 
	src/sound/pci/via82xx.c: warning: 'chip' may be used uninitialized in this function: 2503 => 
	src/sound/pci/via82xx_modem.c: warning: 'chip' may be used uninitialized in this function: 1168 => 
	src/sound/pcmcia/pdaudiocf/pdaudiocf.c: warning: 'pcmcia_request_exclusive_irq' is deprecated (declared at /scratch/kisskb/src/include/pcmcia/ds.h:200): 226 => 
	src/sound/pcmcia/pdaudiocf/pdaudiocf.c: warning: 'pcmcia_request_exclusive_irq' is deprecated (declared at /scratch/kisskb/src/include/pcmcia/ds.h:202): 226 => 
	src/sound/pcmcia/vx/vxpocket.c: warning: 'pcmcia_request_exclusive_irq' is deprecated (declared at /scratch/kisskb/src/include/pcmcia/ds.h:200): 233 => 
	src/sound/pcmcia/vx/vxpocket.c: warning: 'pcmcia_request_exclusive_irq' is deprecated (declared at /scratch/kisskb/src/include/pcmcia/ds.h:202): 233 => 
	src/sound/soc/codecs/wm8900.c: warning: 'fll_div.fll_ratio' may be used uninitialized in this function: 749 => 
	src/sound/soc/codecs/wm8900.c: warning: 'fll_div.fll_slow_lock_ref' may be used uninitialized in this function: 749 => 
	src/sound/soc/codecs/wm8900.c: warning: 'fll_div.fllclk_div' may be used uninitialized in this function: 749 => 
	src/sound/soc/codecs/wm8900.c: warning: 'fll_div.k' may be used uninitialized in this function: 749 => 
	src/sound/soc/codecs/wm8900.c: warning: 'fll_div.n' may be used uninitialized in this function: 749 => 
	src/sound/soc/codecs/wm_hubs.c: warning: 'reg_l' may be used uninitialized in this function: 95 => 
	src/sound/soc/codecs/wm_hubs.c: warning: 'reg_r' may be used uninitialized in this function: 95 => 
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
