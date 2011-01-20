Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754471Ab1ATUrt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 15:47:49 -0500
Received: from gerard.telenet-ops.be ([195.130.132.48]:35788 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753658Ab1ATUrp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 15:47:45 -0500
Date: Thu, 20 Jan 2011 21:47:42 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Build regressions/improvements in v2.6.38-rc1
Message-ID: <alpine.DEB.2.00.1101202147040.6236@ayla.of.borg>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Below is the list of build error/warning regressions/improvements in
v2.6.38-rc1[1] compared to v2.6.37[2].

Summarized:
  - build errors: +96/-14
  - build warnings: +142/-164

In addition, I put the verbose summary at
http://www.kernel.org/pub/linux/kernel/people/geert/linux-log/v2.6.38-rc1.summary.gz
so you can easily find out for which configs and architectures the
errors/warnings you're interested in are happening.

Happy fixing! ;-)

Thanks to the linux-next team for providing the build service.

[1] http://kisskb.ellerman.id.au/kisskb/head/3649/ (all 108 configs)
[2] http://kisskb.ellerman.id.au/kisskb/head/3595/ (all 108 configs)


*** ERRORS ***

96 regressions:
	build/linus_sparc64-allmodconfig_sparc64/usr/include/linux/types.h: error: expected '=', ',', ';', 'asm' or '__attribute__' before '__be16'/scratch/kisskb/src/Documentation/spi/spidev_test.c:57: error: unknown field 'bits_per_word' specified in initializer:  => 28
	src/Documentation/accounting/getdelays.c: error: 'struct nlattr' has no member named 'nla_len': 464, 495, 142, 187, 140, 469 => 464, 495, 142, 508, 187, 140, 469
	src/Documentation/accounting/getdelays.c: error: 'struct taskstats' has no member named 'cancelled_write_bytes':  => 245
	src/Documentation/networking/timestamping/timestamping.c: error: 'struct sock_extended_err' has no member named 'ee_origin': 227 => 229, 227
	src/Documentation/spi/spidev_fdx.c: error: 'lsb' undeclared (first use in this function)/scratch/kisskb/src/Documentation/accounting/getdelays.c:142: error: 'struct nlmsghdr' has no member named 'nlmsg_len':  => 88
	src/Documentation/spi/spidev_test.c: error: '__u32' undeclared (first use in this function):  => 193
	src/arch/avr32/include/asm/pgalloc.h: error: implicit declaration of function 'pgtable_page_ctor':  => 70
	src/arch/avr32/include/asm/pgalloc.h: error: implicit declaration of function 'pgtable_page_dtor':  => 82
	src/arch/cris/arch-v10/drivers/sync_serial.c: error: 'ret' undeclared (first use in this function):  => 628
	src/arch/cris/arch-v10/drivers/sync_serial.c: error: (Each undeclared identifier is reported only once:  => 628
	src/arch/cris/arch-v10/drivers/sync_serial.c: error: conflicting types for 'sync_serial_ioctl':  => 961
	src/arch/cris/arch-v10/drivers/sync_serial.c: error: for each function it appears in.):  => 628
	src/arch/cris/arch-v10/drivers/sync_serial.c: error: previous declaration of 'sync_serial_ioctl' was here:  => 161
	src/arch/cris/arch-v10/kernel/kgdb.c: error: expected string literal before '.' token:  => 1274
	src/arch/cris/arch-v10/kernel/kgdb.c: error: missing terminating " character:  => 1457, 1273, 1359, 1370
	src/arch/powerpc/platforms/83xx/mpc831x_rdb.c: error: 'board' undeclared (first use in this function):  => 74
	src/arch/powerpc/platforms/83xx/mpc831x_rdb.c: error: (Each undeclared identifier is reported only once:  => 74
	src/arch/powerpc/platforms/83xx/mpc831x_rdb.c: error: expected '{' before 'const':  => 63
	src/arch/powerpc/platforms/83xx/mpc831x_rdb.c: error: for each function it appears in.):  => 74
	src/arch/sh/boards/board-shmin.c: error: implicit declaration of function '__set_io_port_base':  => 27
	src/arch/sh/boards/mach-hp6xx/pm.c: error: implicit declaration of function 'inb':  => 109
	src/arch/sh/boards/mach-hp6xx/pm.c: error: implicit declaration of function 'inw':  => 113
	src/arch/sh/boards/mach-hp6xx/pm.c: error: implicit declaration of function 'outb':  => 107
	src/arch/sh/boards/mach-hp6xx/pm.c: error: implicit declaration of function 'outw':  => 115
	src/arch/sh/boards/mach-hp6xx/setup.c: error: implicit declaration of function 'inb':  => 66
	src/arch/sh/boards/mach-hp6xx/setup.c: error: implicit declaration of function 'inw':  => 61
	src/arch/sh/boards/mach-hp6xx/setup.c: error: implicit declaration of function 'outb':  => 68
	src/arch/sh/boards/mach-hp6xx/setup.c: error: implicit declaration of function 'outw':  => 63
	src/arch/sh/boards/mach-se/770x/setup.c: error: implicit declaration of function 'outb_p':  => 23
	src/arch/sh/kernel/cpu/sh4/setup-sh7750.c: error: asm/machtypes.h: No such file or directory:  => 17:27
	src/arch/sh/kernel/cpu/sh4/setup-sh7750.c: error: implicit declaration of function 'platform_register_device':  => 233
	src/drivers/block/paride/aten.c: error: implicit declaration of function 'inb':  => 57
	src/drivers/block/paride/aten.c: error: implicit declaration of function 'outb':  => 44
	src/drivers/block/paride/bpck.c: error: invalid operands to binary & (have 'void *' and 'int'):  => 56, 62
	src/drivers/bluetooth/bluecard_cs.c: error: implicit declaration of function 'inb':  => 348
	src/drivers/bluetooth/bluecard_cs.c: error: implicit declaration of function 'outb':  => 168
	src/drivers/bluetooth/bluecard_cs.c: error: implicit declaration of function 'outb_p':  => 209
	src/drivers/bluetooth/bt3c_cs.c: error: implicit declaration of function 'inb':  => 140
	src/drivers/bluetooth/bt3c_cs.c: error: implicit declaration of function 'outb':  => 119
	src/drivers/bluetooth/btuart_cs.c: error: implicit declaration of function 'inb':  => 117
	src/drivers/bluetooth/btuart_cs.c: error: implicit declaration of function 'outb':  => 123
	src/drivers/bluetooth/dtl1_cs.c: error: implicit declaration of function 'inb':  => 119
	src/drivers/bluetooth/dtl1_cs.c: error: implicit declaration of function 'outb':  => 125
	src/drivers/char/specialix.c: error: invalid operands to binary | (have 'void *' and 'int'):  => 237, 227
	src/drivers/char/tpm/tpm.h: error: implicit declaration of function 'inb':  => 124
	src/drivers/char/tpm/tpm.h: error: implicit declaration of function 'outb':  => 123
	src/drivers/dma/pch_dma.c: error: implicit declaration of function 'kfree':  => 920
	src/drivers/dma/pch_dma.c: error: implicit declaration of function 'kzalloc':  => 785
	src/drivers/media/radio/radio-aimslab.c: error: implicit declaration of function 'msleep':  => 76
	src/drivers/serial/8250.c: error: implicit declaration of function 'inb':  => 393
	src/drivers/serial/8250.c: error: implicit declaration of function 'inb_p':  => 1299
	src/drivers/serial/8250.c: error: implicit declaration of function 'outb':  => 392
	src/drivers/serial/8250.c: error: implicit declaration of function 'outb_p':  => 1300
	src/drivers/video/backlight/hp680_bl.c: error: implicit declaration of function 'inw':  => 48
	src/drivers/video/backlight/hp680_bl.c: error: implicit declaration of function 'outw':  => 50
	src/fs/xfs/xfs_log_priv.h: error: expected ')' before '*' token:  => 623, 593, 611, 581
	src/fs/xfs/xfs_log_priv.h: error: expected specifier-qualifier-list before 'atomic64_t':  => 520
	src/include/asm-generic/pgtable.h: error: 'struct mm_struct' declared inside parameter list:  => 72, 96, 113
	src/include/asm-generic/pgtable.h: error: its scope is only this definition or declaration, which is probably not what you want:  => 72
	src/include/asm-generic/pgtable.h: error: passing argument 1 of 'ptep_get_and_clear' from incompatible pointer type:  => 99, 299
	src/include/asm-generic/tlb.h: error: implicit declaration of function 'page_cache_release':  => 105
	src/include/asm-generic/tlb.h: error: implicit declaration of function 'release_pages':  => 76
	src/include/linux/quicklist.h: error: implicit declaration of function 'page_address':  => 75
	src/kernel/debug/kdb/kdb_keyboard.c: error: implicit declaration of function 'inb':  => 43
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
	src/mm/pgtable-generic.c: error: 'HPAGE_PMD_MASK' undeclared (first use in this function):  => 75
	src/mm/pgtable-generic.c: error: 'HPAGE_PMD_SIZE' undeclared (first use in this function):  => 78
	src/mm/pgtable-generic.c: error: (Each undeclared identifier is reported only once:  => 75
	src/mm/pgtable-generic.c: error: for each function it appears in.):  => 75
	src/net/mac80211/ieee80211_i.h: error: field 'trig' has incomplete type:  => 638
	src/sound/drivers/mtpav.c: error: implicit declaration of function 'inb':  => 227
	src/sound/drivers/mtpav.c: error: implicit declaration of function 'outb':  => 243
	src/sound/pcmcia/pdaudiocf/pdaudiocf.h: error: implicit declaration of function 'inw':  => 127
	src/sound/pcmcia/pdaudiocf/pdaudiocf.h: error: implicit declaration of function 'outw':  => 122
	src/sound/pcmcia/vx/vxp_ops.c: error: implicit declaration of function 'inb':  => 63
	src/sound/pcmcia/vx/vxp_ops.c: error: implicit declaration of function 'inw':  => 420
	src/sound/pcmcia/vx/vxp_ops.c: error: implicit declaration of function 'outb':  => 73
	src/sound/pcmcia/vx/vxp_ops.c: error: implicit declaration of function 'outw':  => 378

14 improvements:
	build/linus_sparc64-allmodconfig_sparc64/usr/include/linux/types.h: error: expected '=', ',', ';', 'asm' or '__attribute__' before '__be32'/scratch/kisskb/src/Documentation/networking/timestamping/timestamping.c:229: error: 'struct sock_extended_err' has no member named 'ee_origin': 30 => 
	src/Documentation/accounting/getdelays.c: error: 'struct nlattr' has no member named 'nla_len'/scratch/kisskb/src/Documentation/spi/spidev_test.c:193: error: '__u32' undeclared (first use in this function): 508 => 
	src/Documentation/accounting/getdelays.c: error: 'struct nlmsghdr' has no member named 'nlmsg_len': 447, 131, 142, 458, 183, 454 => 447, 131, 145, 458, 183
	src/Documentation/accounting/getdelays.c: error: 'struct nlmsghdr' has no member named 'nlmsg_len'In file included from /scratch/kisskb/build/linus_sparc64-allmodconfig_sparc64/usr/include/linux/errqueue.h:4,: 145 => 
	src/Documentation/spi/spidev_fdx.c: error: 'lsb' undeclared (first use in this function): 88 => 
	src/Documentation/spi/spidev_test.c: error: unknown field 'bits_per_word' specified in initializer: 57 => 
	src/arch/alpha/include/asm/io.h: error: 'arch_local_irq_restore' is static but used in inline function '__set_hae' which is not static: 49 => 
	src/arch/alpha/include/asm/io.h: error: 'arch_local_irq_save' is static but used in inline function '__set_hae' which is not static: 41 => 
	src/arch/avr32/include/asm/syscalls.h: error: previous declaration of 'sys_execve' was here: 25 => 
	src/arch/avr32/kernel/process.c: error: conflicting types for 'sys_execve': 390 => 
	src/arch/x86/include/asm/uaccess_32.h: error: call to 'copy_from_user_overflow' declared with attribute error: copy_from_user() buffer size is not provably correct: 212 => 
	src/drivers/i2c/busses/i2c-i801.c: error: implicit declaration of function 'kfree': 855 => 
	src/drivers/i2c/busses/i2c-i801.c: error: implicit declaration of function 'kzalloc': 737 => 
	src/include/linux/kprobes.h: error: dereferencing pointer to incomplete type: 316 => 


*** WARNINGS ***

142 regressions:
	.config: warning: override: SLOB changes choice state:  => 159, 141, 157
	modpost: WARNING: modpost: Found 10 section mismatch(es).:  => N/A
	modpost: WARNING: modpost: Found 11 section mismatch(es).:  => N/A
	modpost: WARNING: modpost: Found 3 section mismatch(es).:  => N/A
	modpost: WARNING: modpost: Found 56 section mismatch(es).:  => N/A
	modpost: WARNING: modpost: Found 71 section mismatch(es).:  => N/A
	src/Documentation/spi/spidev_test.c: warning: excess elements in struct initializer/scratch/kisskb/build/linus_sparc64-allmodconfig_sparc64/usr/include/linux/types.h:29: error: expected '=', ',', ';', 'asm' or '__attribute__' before '__le32':  => 57
	src/Documentation/spi/spidev_test.c: warning: excess elements in struct initializerIn file included from /scratch/kisskb/src/Documentation/spi/spidev_fdx.c:11::  => 56
	src/arch/cris/arch-v10/drivers/sync_serial.c: warning: initialization from incompatible pointer type:  => 252
	src/arch/cris/arch-v10/drivers/sync_serial.c: warning: passing argument 1 of 'memcpy' discards qualifiers from pointer target type:  => 1353, 1343
	src/arch/cris/arch-v10/drivers/sync_serial.c: warning: passing argument 1 of 'virt_to_phys' discards qualifiers from pointer target type:  => 1224
	src/arch/cris/arch-v10/kernel/kgdb.c: warning: missing terminating " character:  => 1359:1, 1273:6, 1457:1, 1370:6
	src/arch/cris/arch-v10/kernel/kgdb.c: warning: type defaults to 'int' in declaration of 'write_stack_register':  => 267
	src/arch/m68k/include/asm/atarihw.h: warning: this is the location of the previous definition:  => 403:1, 402:1
	src/arch/powerpc/platforms/iseries/htab.c: warning: division by zero:  => 249
	src/arch/s390/kvm/../../../virt/kvm/kvm_main.c: warning: 'kvm_create_dirty_bitmap' defined but not used:  => 597
	src/arch/sh/kernel/cpu/sh4/setup-sh7750.c: warning: passing argument 1 of 'early_platform_add_devices' from incompatible pointer type:  => 263, 260, 262
	src/arch/x86/kernel/cpu/perf_event.c: warning: 'x86_get_event_constraints' defined but not used:  => 1326
	src/arch/x86/platform/scx200/scx200_32.c: warning: 'base' may be used uninitialized in this function:  => 82
	src/crypto/algif_hash.c: warning: 'err' may be used uninitialized in this function:  => 47
	src/crypto/algif_hash.c: warning: 'hash_accept' uses dynamic stack allocation:  => 212
	src/drivers/char/cyclades.c: warning: 'cyz_interrupt' defined but not used: 1200 => 1200, 1201
	src/drivers/char/rocket.c: warning: 'rmSpeakerReset' defined but not used: 3166 => 3167, 3166
	src/drivers/char/rocket.c: warning: 'sPCIInitController' defined but not used: 2625 => 2625, 2630
	src/drivers/dma/pch_dma.c: warning: 'pch_dma_resume' defined but not used:  => 755
	src/drivers/dma/pch_dma.c: warning: 'pch_dma_suspend' defined but not used:  => 741
	src/drivers/dma/pch_dma.c: warning: assignment makes pointer from integer without a cast:  => 786
	src/drivers/gpio/74x164.c: warning: 'gen_74x164_remove' defined but not used:  => 136
	src/drivers/gpio/ml_ioh_gpio.c: warning: 'ioh_gpio_restore_reg_conf' defined but not used:  => 152
	src/drivers/gpio/ml_ioh_gpio.c: warning: 'ioh_gpio_save_reg_conf' defined but not used:  => 143
	src/drivers/i2c/busses/i2c-ocores.c: warning: assignment discards qualifiers from pointer target type:  => 254, 261
	src/drivers/md/dm-crypt.c: warning: 'crypt_iv_lmk_one' uses dynamic stack allocation:  => 585
	src/drivers/mfd/ab8500-core.c: warning: 'ab8500_debug_resources' defined but not used:  => 526
	src/drivers/misc/hpilo.c: warning: 'ilo_remove' defined but not used:  => 722
	src/drivers/net/cris/eth_v10.c: warning: unused variable 'np':  => 1135
	src/drivers/net/smc91x.c: warning: passing argument 1 of 'insw' makes integer from pointer without a cast:  => 489
	src/drivers/net/smc91x.c: warning: passing argument 1 of 'inw' makes integer from pointer without a cast:  => 1341, 1173, 795, 620, 1950, 1660, 469, 1827, 723, 1345, 1197, 859, 570, 329, 1279, 410, 1912, 1249, 1224, 690, 676, 1693, 1232, 313, 1265, 395, 678, 1285, 1882, 755, 420, 773, 491, 728, 1344, 1225, 1665, 799, 1925, 1342, 1686, 751, 716, 439, 1899, 832, 1288, 1691, 1340
	src/drivers/net/smc91x.c: warning: passing argument 1 of 'outsw' makes integer from pointer without a cast:  => 596
	src/drivers/net/smc91x.c: warning: passing argument 2 of 'outw' makes integer from pointer without a cast:  => 1661, 620, 1346, 1659, 850, 796, 324, 937, 580, 599, 1687, 1200, 440, 1682, 1681, 690, 752, 277, 395, 938, 379, 1898, 1653, 1343, 1266, 1285, 492, 295, 394, 820, 349, 1458, 837, 1654, 1695, 1657, 1198, 417, 668, 1174, 1023, 784, 312, 724, 1199, 1924, 1074, 309, 470, 593, 346, 389, 489, 1295, 327, 727, 859, 939, 1696, 380, 761, 1279, 1249, 252, 310, 760, 804, 1656, 1172, 581, 345, 308, 348, 596, 1819, 678, 1459, 1131, 1464, 1196, 613, 1684, 1226, 1949, 1813, 756, 1024, 328, 269, 1294, 864, 1668, 759, 344, 1685, 1264, 1073, 388, 355, 1667, 1461, 782, 390, 253, 1462, 1840, 356, 802, 832, 1288, 270, 1911, 1812
	src/drivers/net/wireless/rtlwifi/pci.c: warning: unused variable 'rtlpci':  => 1428
	src/drivers/net/wireless/rtlwifi/rtl8192ce/reg.h: warning: "GPIO_IN" redefined:  => 353:1
	src/drivers/net/wireless/rtlwifi/rtl8192ce/reg.h: warning: "GPIO_OUT" redefined:  => 354:1
	src/drivers/pps/kapi.c: warning: 'ts_real.flags' may be used uninitialized in this function:  => 196
	src/drivers/rtc/rtc-cmos.c: warning: 'cmos_resume' defined but not used:  => 907
	src/drivers/scsi/bfa/bfa_fcpim.c: warning: left shift count >= width of type:  => 2125, 2113
	src/drivers/scsi/bfa/bfa_fcpim.c: warning: right shift count >= width of type:  => 2125, 2113
	src/drivers/serial/mfd.c: warning: 'serial_hsu_remove' defined but not used:  => 1449
	src/drivers/serial/pch_uart.c: warning: 'pch_uart_pci_remove' defined but not used:  => 1332
	src/drivers/serial/pch_uart.c: warning: cast from pointer to integer of different size:  => 779
	src/drivers/staging/iio/accel/adis16201_core.c: warning: 'adis16201_remove' defined but not used:  => 615
	src/drivers/staging/iio/accel/adis16203_core.c: warning: 'adis16203_remove' defined but not used:  => 524
	src/drivers/staging/iio/accel/adis16204_core.c: warning: 'adis16204_remove' defined but not used:  => 569
	src/drivers/staging/iio/accel/adis16220_core.c: warning: 'adis16220_remove' defined but not used:  => 631
	src/drivers/staging/iio/accel/adis16240_core.c: warning: 'adis16240_remove' defined but not used:  => 561
	src/drivers/staging/iio/accel/sca3000_core.c: warning: 'sca3000_remove' defined but not used:  => 1434
	src/drivers/staging/iio/dac/ad5446.c: warning: 'ad5446_remove' defined but not used:  => 269
	src/drivers/staging/iio/gyro/adis16060_core.c: warning: 'adis16060_r_remove' defined but not used:  => 232
	src/drivers/staging/iio/gyro/adis16060_core.c: warning: 'adis16060_w_remove' defined but not used:  => 269
	src/drivers/staging/iio/gyro/adis16130_core.c: warning: 'adis16130_remove' defined but not used:  => 269
	src/drivers/staging/iio/gyro/adis16251_core.c: warning: 'adis16251_remove' defined but not used:  => 725
	src/drivers/staging/iio/gyro/adis16251_core.c: warning: 'adis16251_self_test' defined but not used:  => 454
	src/drivers/staging/iio/gyro/adis16260_core.c: warning: 'adis16260_remove' defined but not used:  => 660
	src/drivers/staging/iio/imu/adis16300_core.c: warning: 'adis16300_remove' defined but not used:  => 704
	src/drivers/staging/iio/light/tsl2563.c: warning: 'tsl2563_remove' defined but not used:  => 905
	src/drivers/staging/iio/meter/ade7753.c: warning: 'ade7753_remove' defined but not used:  => 678
	src/drivers/staging/iio/meter/ade7754.c: warning: 'ade7754_remove' defined but not used:  => 704
	src/drivers/staging/iio/meter/ade7758_core.c: warning: 'ade7758_remove' defined but not used:  => 814
	src/drivers/staging/iio/meter/ade7758_ring.c: warning: cast from pointer to integer of different size:  => 147
	src/drivers/staging/iio/meter/ade7758_ring.c: warning: cast to pointer from integer of different size:  => 147
	src/drivers/staging/iio/meter/ade7759.c: warning: 'ade7759_remove' defined but not used:  => 618
	src/drivers/tty/tty_io.c: warning: ignoring return value of 'device_create_file', declared with attribute warn_unused_result:  => 3309
	src/drivers/tty/vt/vt.c: warning: ignoring return value of 'device_create_file', declared with attribute warn_unused_result:  => 2997
	src/drivers/usb/gadget/u_ether.c: warning: comparison of distinct pointer types lacks a cast:  => 244
	src/drivers/usb/misc/usbled.c: warning: 'retval' may be used uninitialized in this function:  => 48
	src/drivers/usb/otg/twl6030-usb.c: warning: 'twl6030_set_phy_clk' defined but not used:  => 135
	src/drivers/video/udlfb.c: warning: ignoring return value of 'device_create_bin_file', declared with attribute warn_unused_result:  => 1592
	src/drivers/video/udlfb.c: warning: ignoring return value of 'device_create_file', declared with attribute warn_unused_result:  => 1590
	src/drivers/video/via/via-core.c: warning: assignment discards qualifiers from pointer target type:  => 684
	src/drivers/video/via/via_i2c.c: warning: 'id' is deprecated (declared at /scratch/kisskb/src/include/linux/i2c.h:359):  => 212
	src/fs/cifs/cifs_dfs_ref.c: warning: 'rc' may be used uninitialized in this function:  => 278
	src/fs/ext3/balloc.c: warning: passing argument 2 of 'test_and_clear_bit' from incompatible pointer type: 833, 619 => 849, 635, 2010
	src/fs/ncpfs/ncp_fs_sb.h: warning: 'packed' attribute ignored for field of type '__u16':  => 128, 130, 127, 129, 126
	src/fs/ncpfs/ncp_fs_sb.h: warning: 'packed' attribute ignored for field of type '__u32':  => 124, 125
	src/fs/nfs/callback_proc.c: warning: 'ino' may be used uninitialized in this function:  => 115
	src/fs/quota/quota_tree.c: warning: format '%zd' expects type 'signed size_t', but argument 4 has type 'ssize_t':  => 372
	src/fs/quota/quota_v2.c: warning: format '%zd' expects type 'signed size_t', but argument 5 has type 'ssize_t':  => 66
	src/fs/squashfs/xz_wrapper.c: warning: 'xz_err' may be used uninitialized in this function:  => 77
	src/fs/squashfs/zlib_wrapper.c: warning: 'zlib_err' may be used uninitialized in this function:  => 68
	src/fs/sysfs/dir.c: warning: 'sysfs_pathname' defined but not used: 411 => 414, 415
	src/fs/xfs/xfs_inode_item.c: warning: 'xfs_iflush_done' uses dynamic stack allocation:  => 944
	src/include/asm-generic/pgtable.h: warning: 'struct mm_struct' declared inside parameter list:  => 72, 96, 113
	src/include/asm-generic/pgtable.h: warning: its scope is only this definition or declaration, which is probably not what you want:  => 72
	src/include/asm-generic/pgtable.h: warning: passing argument 1 of 'ptep_get_and_clear' from incompatible pointer type:  => 99, 299
	src/include/linux/quicklist.h: warning: passing argument 3 of '__quicklist_free' makes pointer from integer without a cast:  => 75
	src/include/net/ipx.h: warning: 'packed' attribute ignored for field of type '__be16':  => 32, 30
	src/include/net/ipx.h: warning: 'packed' attribute ignored for field of type 'struct ipx_address':  => 42, 41
	src/kernel/watchdog.c: warning: 'watchdog_disable_all_cpus' defined but not used:  => 475
	src/kernel/watchdog.c: warning: 'watchdog_enable_all_cpus' defined but not used:  => 462
	src/lib/atomic64_test.c: warning: ISO C90 forbids mixed declarations and code:  => 25
	src/net/batman-adv/vis.c: warning: passing argument 2 of 'compare_orig' discards qualifiers from pointer target type:  => 116
	src/net/ipv6/mcast.c: warning: overflow in implicit constant conversion:  => 309, 241
	src/net/irda/irnet/irnet_ppp.c: warning: format '%Zd' expects type 'signed size_t', but argument 3 has type 'ssize_t':  => 331
	src/net/mac80211/tx.c: warning: unused variable 'mppath':  => 1753
	src/net/packet/af_packet.c: warning: 'vnet_hdr_len' may be used uninitialized in this function:  => 1119
	src/net/sched/sch_drr.c: warning: 'err' may be used uninitialized in this function:  => 354
	src/net/xfrm/xfrm_policy.c: warning: 'dst_ops' may be used uninitialized in this function:  => 1325
	src/security/selinux/hooks.c: warning: 'sclass' may be used uninitialized in this function:  => 1430
	src/sound/pci/hda/patch_realtek.c: warning: unused variable 'modelname':  => 1724
	src/sound/soc/soc-core.c: warning: 'compress_type' may be used uninitialized in this function:  => 1722
	warning: "saved_config" [vmlinux] is COMMON symbol:  => N/A
	warning: (ATH5K && ATH9K && ATH9K_HTC && CARL9170_LEDS) selects MAC80211_LEDS which has unmet direct dependencies (NET && WIRELESS && MAC80211 && LEDS_CLASS):  => N/A
	warning: (AX88796_93CX6 && RTL8180 && RTL8187 && ADM8211 && RT2400PCI && RT2500PCI && RT61PCI && RT2800PCI && R8187SE) selects EEPROM_93CX6 which has unmet direct dependencies (MISC_DEVICES):  => N/A
	warning: (CAVIUM_OCTEON_REFERENCE_BOARD && BCM63XX_CPU_6338) selects USB_ARCH_HAS_OHCI which has unmet direct dependencies (USB_SUPPORT):  => N/A
	warning: (CAVIUM_OCTEON_REFERENCE_BOARD) selects USB_ARCH_HAS_EHCI which has unmet direct dependencies (USB_SUPPORT):  => N/A
	warning: (COMPAT) selects COMPAT_BINFMT_ELF which has unmet direct dependencies (COMPAT && BINFMT_ELF):  => N/A
	warning: (CPU_SUBTYPE_SH7720 && CPU_SUBTYPE_SH7721 && CPU_SUBTYPE_SH7763 && CPU_SUBTYPE_SH7786) selects USB_ARCH_HAS_OHCI which has unmet direct dependencies (USB_SUPPORT):  => N/A
	warning: (ETRAX_USB_HOST && MOUSE_APPLETOUCH && MOUSE_BCM5974 && JOYSTICK_XPAD && TABLET_USB_ACECAD && TABLET_USB_AIPTEK && TABLET_USB_HANWANG && TABLET_USB_KBTAB && TABLET_USB_WACOM && TOUCHSCREEN_USB_COMPOSITE && INPUT_ATI_REMOTE && INPUT_ATI_REMOTE2 && INPUT_KEYSPAN_REMOTE && INPUT_POWERMATE && INPUT_YEALINK && INPUT_CM109) selects USB which has unmet direct dependencies (USB_SUPPORT && USB_ARCH_HAS_HCD):  => N/A
	warning: (I2C_ISCH && GPIO_SCH && GPIO_RDC321X) selects MFD_CORE which has unmet direct dependencies (MFD_SUPPORT):  => N/A
	warning: (I2C_ISCH && GPIO_SCH) selects LPC_SCH which has unmet direct dependencies (MFD_SUPPORT && PCI):  => N/A
	warning: (IMA) selects TCG_TPM which has unmet direct dependencies (HAS_IOMEM && EXPERIMENTAL):  => N/A
	warning: (LGUEST_GUEST && VIRTIO_PCI && VIRTIO_BALLOON) selects VIRTIO_RING which has unmet direct dependencies (VIRTUALIZATION && VIRTIO):  => N/A
	warning: (LGUEST_GUEST) selects VIRTIO which has unmet direct dependencies (VIRTUALIZATION):  => N/A
	warning: (LOCKDEP && FAULT_INJECTION_STACKTRACE_FILTER && LATENCYTOP && DWARF_UNWINDER && FUNCTION_TRACER && KMEMCHECK) selects FRAME_POINTER which has unmet direct dependencies (DEBUG_KERNEL && (CRIS || M68K || M68KNOMMU || FRV || UML || AVR32 || SUPERH || BLACKFIN || MN10300) || ARCH_WANT_FRAME_POINTERS):  => N/A
	warning: (LOCKDEP && FAULT_INJECTION_STACKTRACE_FILTER && LATENCYTOP && FUNCTION_TRACER && KMEMCHECK) selects FRAME_POINTER which has unmet direct dependencies (DEBUG_KERNEL && (CRIS || M68K || M68KNOMMU || FRV || UML || AVR32 || SUPERH || BLACKFIN || MN10300) || ARCH_WANT_FRAME_POINTERS):  => N/A
	warning: (MEDIA_TUNER) selects MEDIA_TUNER_TEA5761 which has unmet direct dependencies (MEDIA_SUPPORT && VIDEO_MEDIA && I2C && EXPERIMENTAL):  => N/A
	warning: (MPC836x_RDK && MTD_NAND_FSL_ELBC && MTD_NAND_FSL_UPM) selects FSL_LBC which has unmet direct dependencies (FSL_SOC):  => N/A
	warning: (NETFILTER_XT_MATCH_REALM) selects NET_CLS_ROUTE which has unmet direct dependencies (NET && NET_SCHED):  => N/A
	warning: (PAGE_POISONING) selects DEBUG_PAGEALLOC which has unmet direct dependencies (DEBUG_KERNEL && ARCH_SUPPORTS_DEBUG_PAGEALLOC && (!HIBERNATION || !PPC && !SPARC) && !KMEMCHECK):  => N/A
	warning: (PERF_EVENTS) selects IRQ_WORK which has unmet direct dependencies (HAVE_IRQ_WORK):  => N/A
	warning: (PPC_CELL_NATIVE && 440EPX && 440GRX && 440GX && 440SPe && 460EX && 460SX && APM821xx && 405EX) selects IBM_NEW_EMAC_EMAC4 which has unmet direct dependencies (NETDEVICES && NET_ETHERNET):  => N/A
	warning: (PPC_CELL_NATIVE && 440GX && 460EX && 460SX && APM821xx) selects IBM_NEW_EMAC_TAH which has unmet direct dependencies (NETDEVICES && NET_ETHERNET):  => N/A
	warning: (PPC_CELL_NATIVE && BLUESTONE && CANYONLANDS && GLACIER && EIGER && 440EPX && 440GRX && 440GX && 460SX && 405EX) selects IBM_NEW_EMAC_RGMII which has unmet direct dependencies (NETDEVICES && NET_ETHERNET):  => N/A
	warning: (PPC_CELL_NATIVE && CANYONLANDS && GLACIER && 440EP && 440EPX && 440GRX && 440GP && 440GX && 460SX && 405GP) selects IBM_NEW_EMAC_ZMII which has unmet direct dependencies (NETDEVICES && NET_ETHERNET):  => N/A
	warning: (PPC_PS3 && PPC_CELLEB && XPS_USB_HCD_XILINX && USB_OCTEON_EHCI) selects USB_EHCI_BIG_ENDIAN_MMIO which has unmet direct dependencies (USB_SUPPORT && USB_EHCI_HCD && (PPC_CELLEB || PPC_PS3 || 440EPX || ARCH_IXP4XX || XPS_USB_HCD_XILINX || PPC_MPC512x || CPU_CAVIUM_OCTEON)):  => N/A
	warning: (PPC_PS3 && SPU_FS) selects MEMORY_HOTPLUG which has unmet direct dependencies ((SPARSEMEM || X86_64_ACPI_NUMA) && HOTPLUG && ARCH_ENABLE_MEMORY_HOTPLUG && (IA64 || X86 || PPC_BOOK3S_64 || SUPERH || S390)):  => N/A
	warning: (RADIO_MIROPCM20) selects SND_ISA which has unmet direct dependencies (SOUND && !M68K && SND && ISA && ISA_DMA_API):  => N/A
	warning: (SCHED_AUTOGROUP) selects CGROUP_SCHED which has unmet direct dependencies (CGROUPS && EXPERIMENTAL):  => N/A
	warning: (SERIAL_PCH_UART) selects PCH_DMA which has unmet direct dependencies (DMADEVICES && PCI && X86):  => N/A
	warning: (STUB_POULSBO && DRM_I915) selects ACPI_VIDEO which has unmet direct dependencies (ACPI && X86 && BACKLIGHT_CLASS_DEVICE && VIDEO_OUTPUT_CONTROL && INPUT):  => N/A
	warning: (TRANSPARENT_HUGEPAGE) selects COMPACTION which has unmet direct dependencies (EXPERIMENTAL && HUGETLB_PAGE && MMU):  => N/A
	warning: (USB_WUSB) selects UWB which has unmet direct dependencies (EXPERIMENTAL && PCI):  => N/A
	warning: 3 bad relocations:  => N/A

164 improvements:
	arch/avr32/configs/atstk1002_defconfig: warning: symbol value 'm' invalid for LEDS_CLASS: 137 => 
	modpost: WARNING: modpost: Found 16 section mismatch(es).: N/A => 
	modpost: WARNING: modpost: Found 17 section mismatch(es).: N/A => 
	modpost: WARNING: modpost: Found 47 section mismatch(es).: N/A => 
	modpost: WARNING: modpost: Found 66 section mismatch(es).: N/A => 
	src/Documentation/spi/spidev_test.c: warning: excess elements in struct initializer: 52, 53, 57, 56, 55, 54 => 52, 53, 55, 54
	src/arch/alpha/include/asm/io.h: warning: 'arch_local_irq_restore' is static but used in inline function '__set_hae' which is not static: 49 => 
	src/arch/alpha/include/asm/io.h: warning: 'arch_local_irq_save' is static but used in inline function '__set_hae' which is not static: 41 => 
	src/arch/m68k/kernel/sys_m68k.c: warning: passing argument 1 of 'kunmap' from incompatible pointer type: 516, 508 => 
	src/arch/powerpc/platforms/embedded6xx/wii.c: warning: format '%08llx' expects type 'long long unsigned int', but argument 2 has type 'phys_addr_t': 89, 91 => 
	src/arch/powerpc/platforms/embedded6xx/wii.c: warning: format '%08llx' expects type 'long long unsigned int', but argument 3 has type 'phys_addr_t': 89, 91 => 
	src/arch/s390/kvm/../../../virt/kvm/kvm_main.c: warning: passing argument 3 of 'kvm_write_guest_page' makes pointer from integer without a cast: 1224 => 
	src/arch/s390/kvm/../../../virt/kvm/kvm_main.c: warning: unused variable 'r': 1827 => 
	src/arch/sh/include/asm/ptrace_32.h: warning: this is the location of the previous definition: 25:1 => 
	src/arch/x86/lguest/i386_head.S: Warning: shift count out of range (32 is not between 0 and 31): 65 => 
	src/drivers/char/ip2/ip2main.c: warning: 'ip2main_pci_tbl' defined but not used: 3227 => 
	src/drivers/char/rocket.c: warning: 'rocket_pci_ids' defined but not used: 1767 => 
	src/drivers/char/specialix.c: warning: 'specialx_pci_tbl' defined but not used: 2358 => 
	src/drivers/gpio/bt8xxgpio.c: warning: ignoring return value of 'gpiochip_remove', declared with attribute warn_unused_result: 247 => 
	src/drivers/gpu/drm/drm_pci.c: warning: passing argument 1 of 'virt_to_phys' makes pointer from integer without a cast: 109, 84 => 
	src/drivers/gpu/drm/drm_vm.c: warning: passing argument 1 of 'virt_to_phys' makes pointer from integer without a cast: 308 => 
	src/drivers/gpu/drm/radeon/radeon_gart.c: warning: passing argument 3 of 'pci_free_consistent' discards qualifiers from pointer target type: 69 => 
	src/drivers/hwmon/w83795.c: warning: 'lsb' may be used uninitialized in this function: 483 => 
	src/drivers/i2c/busses/i2c-i801.c: warning: assignment makes pointer from integer without a cast: 737 => 
	src/drivers/ide/ide-floppy.c: warning: 'pc' may be used uninitialized in this function: 234 => 
	src/drivers/infiniband/hw/amso1100/c2_vq.c: warning: cast from pointer to integer of different size: 154, 126, 110 => 
	src/drivers/input/misc/twl4030-vibra.c: warning: 'twl4030_vibra_resume' defined but not used: 188 => 
	src/drivers/input/misc/twl4030-vibra.c: warning: 'twl4030_vibra_suspend' defined but not used: 177 => 
	src/drivers/isdn/gigaset/capi.c: warning: 'format_ie' defined but not used: 301 => 
	src/drivers/isdn/hisax/config.c: warning: 'hisax_pci_tbl' defined but not used: 1920 => 
	src/drivers/leds/leds-alix2.c: warning: 'divil_pci' defined but not used: 25 => 
	src/drivers/leds/leds-gpio.c: warning: 'create_gpio_led' defined but not used: 91 => 
	src/drivers/leds/leds-gpio.c: warning: 'delete_gpio_led' defined but not used: 145 => 
	src/drivers/leds/leds-lp5521.c: warning: 'engine_state' may be used uninitialized in this function: 169 => 
	src/drivers/leds/leds-lp5523.c: warning: 'adc' may be used uninitialized in this function: 435 => 
	src/drivers/leds/leds-lp5523.c: warning: 'vdd' may be used uninitialized in this function: 435 => 
	src/drivers/media/dvb/frontends/af9013.c: warning: 'ret' may be used uninitialized in this function: 1011 => 
	src/drivers/media/video/cx88/cx88-i2c.c: warning: 'id' is deprecated (declared at /scratch/kisskb/src/include/linux/i2c.h:356): 149 => 
	src/drivers/media/video/cx88/cx88-vp3054-i2c.c: warning: 'id' is deprecated (declared at /scratch/kisskb/src/include/linux/i2c.h:356): 128 => 
	src/drivers/media/video/v4l2-compat-ioctl32.c: warning: ignoring return value of 'copy_to_user', declared with attribute warn_unused_result: 209 => 
	src/drivers/mfd/sh_mobile_sdhi.c: warning: 'sh_mobile_sdhi_remove' defined but not used: 161 => 
	src/drivers/misc/apds990x.c: warning: 'apds990x_resume' defined but not used: 1216 => 
	src/drivers/misc/apds990x.c: warning: 'apds990x_suspend' defined but not used: 1207 => 
	src/drivers/misc/bh1770glc.c: warning: 'bh1770_resume' defined but not used: 1325 => 
	src/drivers/misc/bh1770glc.c: warning: 'bh1770_suspend' defined but not used: 1315 => 
	src/drivers/misc/ics932s401.c: warning: 'reg' may be used uninitialized in this function: 392 => 
	src/drivers/misc/ics932s401.c: warning: 'x' may be used uninitialized in this function: 375 => 
	src/drivers/mtd/maps/solutionengine.c: warning: format '%08lx' expects type 'long unsigned int', but argument 2 has type 'resource_size_t': 86 => 
	src/drivers/mtd/maps/solutionengine.c: warning: format '%08lx' expects type 'long unsigned int', but argument 3 has type 'resource_size_t': 86 => 
	src/drivers/mtd/sm_ftl.c: warning: comparison of distinct pointer types lacks a cast: 200, 199 => 
	src/drivers/mtd/ubi/wl.c: warning: 'e' may be used uninitialized in this function: 390 => 
	src/drivers/net/bna/bnad.c: warning: 'using_dac' may be used uninitialized in this function: 3035 => 
	src/drivers/net/can/pch_can.c: warning: 'pch_can_get_int_enables' defined but not used: 269 => 
	src/drivers/net/can/pch_can.c: warning: 'pch_can_get_rx_buffer_link' defined but not used: 480 => 
	src/drivers/net/can/pch_can.c: warning: 'pch_can_get_rx_enable' defined but not used: 420 => 
	src/drivers/net/can/pch_can.c: warning: 'pch_can_get_tx_enable' defined but not used: 438 => 
	src/drivers/net/can/pch_can.c: warning: 'pch_can_set_int_custom' defined but not used: 258 => 
	src/drivers/net/can/pch_can.c: warning: 'pch_can_set_rx_buffer_link' defined but not used: 462 => 
	src/drivers/net/can/sja1000/sja1000.h: warning: "REG_SR" redefined: 60:1 => 
	src/drivers/net/enic/enic_main.c: warning: passing argument 3 of 'pci_alloc_consistent' from incompatible pointer type: 2057, 2083 => 
	src/drivers/net/macvtap.c: warning: control reaches end of non-void function: 102 => 
	src/drivers/net/pcmcia/nmclan_cs.c: warning: 'pcmcia_request_exclusive_irq' is deprecated (declared at /scratch/kisskb/src/include/pcmcia/ds.h:203): 628 => 
	src/drivers/net/pcmcia/smc91c92_cs.c: warning: unused variable 'smc': 960 => 
	src/drivers/net/sh_eth.c: warning: 'ctrl_inl' is deprecated (declared at /scratch/kisskb/src/arch/sh/include/asm/io.h:104): 365, 860, 660, 288, 1128, 814, 937, 891, 366, 1258, 286, 848, 361, 906, 664, 1298, 1266, 1256, 1302, 394, 842, 363, 830, 857, 364, 388, 1003, 362, 382, 855, 1199, 1254, 852 => 
	src/drivers/net/sh_eth.c: warning: 'ctrl_outl' is deprecated (declared at /scratch/kisskb/src/arch/sh/include/asm/io.h:124): 892, 643, 685, 660, 1330, 1314, 942, 831, 288, 1332, 1218, 647, 1200, 667, 918, 690, 676, 1310, 1312, 633, 1267, 1311, 1257, 1315, 815, 1319, 342, 1333, 1324, 857, 683, 1215, 1219, 1328, 382, 1318, 658, 1329, 673, 860, 1327, 650, 640, 661, 1317, 339, 286, 655, 848, 531, 687, 1259, 1313, 1298, 1325, 1255, 1302, 626, 639, 1316, 1331, 388, 636, 509, 1003, 652, 629, 855, 852 => 
	src/drivers/net/sky2.c: warning: control reaches end of non-void function: 2992 => 
	src/drivers/net/smc911x.c: warning: unused variable 'lp': 2127 => 
	src/drivers/net/smc911x.h: warning: control reaches end of non-void function: 135 => 
	src/drivers/net/smc91x.c: warning: passing argument 1 of 'sh_mv.mv_insw' makes integer from pointer without a cast: 489 => 
	src/drivers/net/smc91x.c: warning: passing argument 1 of 'sh_mv.mv_inw' makes integer from pointer without a cast: 1341, 1173, 795, 620, 1950, 1660, 469, 1827, 723, 1345, 1197, 859, 570, 329, 1279, 410, 1912, 1249, 1224, 690, 676, 1693, 1232, 313, 1265, 395, 678, 1285, 1882, 755, 420, 773, 491, 728, 1344, 1225, 1665, 799, 1925, 1342, 1686, 751, 716, 439, 1899, 832, 1288, 1691, 1340 => 
	src/drivers/net/smc91x.c: warning: passing argument 1 of 'sh_mv.mv_outsw' makes integer from pointer without a cast: 596 => 
	src/drivers/net/smc91x.c: warning: passing argument 2 of 'sh_mv.mv_outw' makes integer from pointer without a cast: 1661, 620, 1346, 1659, 850, 796, 324, 937, 580, 599, 1687, 1200, 440, 1682, 1681, 690, 752, 277, 395, 938, 379, 1898, 1653, 1343, 1266, 1285, 492, 295, 394, 820, 349, 1458, 837, 1654, 1695, 1657, 1198, 417, 668, 1174, 1023, 784, 312, 724, 1199, 1924, 1074, 309, 470, 593, 346, 389, 489, 1295, 327, 727, 859, 939, 1696, 380, 761, 1279, 1249, 252, 310, 760, 804, 1656, 1172, 581, 345, 308, 348, 596, 1819, 678, 1459, 1131, 1464, 1196, 613, 1684, 1226, 1949, 1813, 756, 1024, 328, 269, 1294, 864, 1668, 759, 344, 1685, 1264, 1073, 388, 355, 1667, 1461, 782, 390, 253, 1462, 1840, 356, 802, 832, 1288, 270, 1911, 1812 => 
	src/drivers/net/stmmac/stmmac_main.c: warning: ignoring return value of 'strict_strtoul', declared with attribute warn_unused_result: 1948, 1957, 1952, 1938, 1945, 1954, 1950, 1940, 1942 => 
	src/drivers/net/usb/hso.c: warning: unused variable 'uarg': 1744 => 
	src/drivers/net/wireless/ath/ar9170/ar9170.h: warning: control reaches end of non-void function: 76 => 
	src/drivers/net/wireless/ath/carl9170/phy.c: warning: control reaches end of non-void function: 1604 => 
	src/drivers/parport/parport_pc.c: warning: 'parport_pc_find_isa_ports' defined but not used: 3333 => 
	src/drivers/pci/pcie/portdrv_core.c: warning: 'cap_mask' may be used uninitialized in this function: 241 => 
	src/drivers/regulator/wm831x-dcdc.c: warning: control reaches end of non-void function: 124 => 
	src/drivers/rtc/rtc-cmos.c: warning: #warning Assuming 128 bytes of RTC+NVRAM address space, not 64 bytes.: 693:2 => 
	src/drivers/rtc/rtc-msm6242.c: warning: 'return' with a value, in function returning void: 85 => 
	src/drivers/rtc/rtc-rp5c01.c: warning: 'return' with a value, in function returning void: 79 => 
	src/drivers/scsi/lpfc/lpfc_bsg.c: warning: 'rpi' may be used uninitialized in this function: 2105 => 
	src/drivers/telephony/ixj.c: warning: 'ixj_pci_tbl' defined but not used: 287 => 
	src/drivers/usb/gadget/f_fs.c: warning: 'rem_type1' may be used uninitialized in this function: 1987 => 
	src/drivers/usb/host/oxu210hp-hcd.c: warning: unused variable 'base': 3897 => 
	src/drivers/usb/host/whci/hcd.c: warning: 'whci_hcd_id_table' defined but not used: 359 => 
	src/drivers/uwb/i1480/i1480-est.c: warning: 'i1480_est_id_table' defined but not used: 94 => 
	src/drivers/uwb/whc-rc.c: warning: 'whcrc_id_table' defined but not used: 452 => 
	src/drivers/video/backlight/adp5520_bl.c: warning: ignoring return value of 'strict_strtoul', declared with attribute warn_unused_result: 215 => 
	src/drivers/video/mb862xx/mb862xxfb.c: warning: 'mb862xxfb_init_fbinfo' defined but not used: 327, 326 => 326
	src/drivers/video/s1d13xxxfb.c: warning: 'bltbit_fifo_status' defined but not used: 464, 465 => 
	src/drivers/video/s1d13xxxfb.c: warning: 'bltbit_wait_bitset' defined but not used: 421, 422 => 
	src/drivers/video/sh_mobile_lcdcfb.c: warning: format '%u' expects type 'unsigned int', but argument 11 has type 'long unsigned int': 922 => 
	src/drivers/video/sis/sis_main.c: warning: unused variable 'temp': 4108 => 
	src/drivers/video/valkyriefb.c: warning: unused variable 'i': 268 => 
	src/drivers/video/valkyriefb.c: warning: unused variable 'req': 267 => 
	src/drivers/video/via/via_i2c.c: warning: 'id' is deprecated (declared at /scratch/kisskb/src/include/linux/i2c.h:356): 212 => 
	src/drivers/virtio/virtio_balloon.c: warning: 'events[11]' is used uninitialized in this function: 187 => 
	src/drivers/virtio/virtio_balloon.c: warning: 'events[12]' is used uninitialized in this function: 186 => 
	src/drivers/virtio/virtio_balloon.c: warning: 'events[2]' is used uninitialized in this function: 182 => 
	src/drivers/virtio/virtio_balloon.c: warning: 'events[3]' is used uninitialized in this function: 184 => 
	src/drivers/virtio/virtio_ring.c: warning: cast to pointer from integer of different size: 271 => 
	src/drivers/watchdog/alim7101_wdt.c: warning: 'alim7101_pci_tbl' defined but not used: 433 => 
	src/fs/autofs4/symlink.c: warning: passing argument 2 of 'nd_set_link' discards qualifiers from pointer target type: 18 => 
	src/fs/dcache.c: warning: control reaches end of non-void function: 1905 => 
	src/fs/ext4/super.c: warning: 'ret' may be used uninitialized in this function: 2919 => 
	src/fs/ncpfs/inode.c: warning: 'data.mounted_vol[10u]' may be used uninitialized in this function: 440 => 
	src/fs/ncpfs/inode.c: warning: 'data.mounted_vol[11u]' may be used uninitialized in this function: 440 => 
	src/fs/ncpfs/inode.c: warning: 'data.mounted_vol[12u]' may be used uninitialized in this function: 440 => 
	src/fs/ncpfs/inode.c: warning: 'data.mounted_vol[13u]' may be used uninitialized in this function: 440 => 
	src/fs/ncpfs/inode.c: warning: 'data.mounted_vol[14u]' may be used uninitialized in this function: 440 => 
	src/fs/ncpfs/inode.c: warning: 'data.mounted_vol[15u]' may be used uninitialized in this function: 440 => 
	src/fs/ncpfs/inode.c: warning: 'data.mounted_vol[16u]' may be used uninitialized in this function: 440 => 
	src/fs/ncpfs/inode.c: warning: 'data.mounted_vol[1u]' may be used uninitialized in this function: 440 => 
	src/fs/ncpfs/inode.c: warning: 'data.mounted_vol[2u]' may be used uninitialized in this function: 440 => 
	src/fs/ncpfs/inode.c: warning: 'data.mounted_vol[3u]' may be used uninitialized in this function: 440 => 
	src/fs/ncpfs/inode.c: warning: 'data.mounted_vol[4u]' may be used uninitialized in this function: 440 => 
	src/fs/ncpfs/inode.c: warning: 'data.mounted_vol[5u]' may be used uninitialized in this function: 440 => 
	src/fs/ncpfs/inode.c: warning: 'data.mounted_vol[6u]' may be used uninitialized in this function: 440 => 
	src/fs/ncpfs/inode.c: warning: 'data.mounted_vol[7u]' may be used uninitialized in this function: 440 => 
	src/fs/ncpfs/inode.c: warning: 'data.mounted_vol[8u]' may be used uninitialized in this function: 440 => 
	src/fs/ncpfs/inode.c: warning: 'data.mounted_vol[9u]' may be used uninitialized in this function: 440 => 
	src/fs/proc/task_mmu.c: warning: passing argument 1 of 'kunmap' from incompatible pointer type: 639, 383, 480 => 
	src/fs/udf/super.c: warning: 'map' may be used uninitialized in this function: 1157 => 
	src/include/linux/ncp_fs_sb.h: warning: 'packed' attribute ignored for field of type '__u16': 112, 114, 111, 115, 113 => 
	src/include/linux/ncp_fs_sb.h: warning: 'packed' attribute ignored for field of type '__u32': 109, 110 => 
	src/include/net/netlink.h: warning: 'len' is used uninitialized in this function: 647 => 
	src/kernel/trace/trace_events.c: warning: enumeration value 'TRACE_REG_PERF_REGISTER' not handled in switch: 146 => 
	src/kernel/trace/trace_events.c: warning: enumeration value 'TRACE_REG_PERF_UNREGISTER' not handled in switch: 146 => 
	src/kernel/trace/trace_kprobe.c: warning: enumeration value 'TRACE_REG_PERF_REGISTER' not handled in switch: 1647 => 
	src/kernel/trace/trace_kprobe.c: warning: enumeration value 'TRACE_REG_PERF_UNREGISTER' not handled in switch: 1647 => 
	src/mm/fremap.c: warning: passing argument 1 of 'kunmap' from incompatible pointer type: 78 => 
	src/mm/memory.c: warning: passing argument 1 of 'kunmap' from incompatible pointer type: 772, 1706, 1319, 3060, 1314, 1410, 1391, 770, 3426, 2788, 1403, 2047, 984, 2783, 1641, 2187, 2890, 2339, 3386, 3199, 1955, 1806, 2141, 3101, 2242, 1644, 2847, 1323 => 
	src/mm/mincore.c: warning: passing argument 1 of 'kunmap' from incompatible pointer type: 144 => 
	src/mm/mprotect.c: warning: passing argument 1 of 'kunmap' from incompatible pointer type: 78 => 
	src/mm/mremap.c: warning: passing argument 1 of 'kunmap' from incompatible pointer type: 123, 122 => 
	src/mm/pagewalk.c: warning: passing argument 1 of 'kunmap' from incompatible pointer type: 23 => 
	src/mm/rmap.c: warning: passing argument 1 of 'kunmap' from incompatible pointer type: 712, 442, 1063, 531, 453, 1199, 478, 1068 => 
	src/mm/swapfile.c: warning: passing argument 1 of 'kunmap' from incompatible pointer type: 951, 915, 944 => 
	src/mm/vmalloc.c: warning: passing argument 1 of 'kunmap' from incompatible pointer type: 228 => 
	src/net/dccp/ccids/ccid2.c: warning: 'veclen' may be used uninitialized in this function: 443 => 
	src/net/dccp/ccids/ccid2.c: warning: 'vector' may be used uninitialized in this function: 442 => 
	src/net/econet/af_econet.c: warning: label 'error' defined but not used: 494 => 
	src/net/econet/af_econet.c: warning: unused variable 'sk': 268 => 
	src/sound/soc/codecs/wm8350.c: warning: 'mask' may be used uninitialized in this function: 1343 => 
	warning: (ATH5K && NETDEVICES && WLAN && ATH_COMMON && PCI && MAC80211 || ATH9K && NETDEVICES && WLAN && ATH_COMMON && PCI && MAC80211 || ATH9K_HTC && NETDEVICES && WLAN && ATH_COMMON && USB && MAC80211 || CARL9170_LEDS && NETDEVICES && WLAN && ATH_COMMON && CARL9170) selects MAC80211_LEDS which has unmet direct dependencies (NET && WIRELESS && MAC80211 && LEDS_CLASS): N/A => 
	warning: (AX88796_93CX6 && NETDEVICES && NET_ETHERNET && AX88796 || RTL8180 && NETDEVICES && WLAN && MAC80211 && PCI && EXPERIMENTAL || RTL8187 && NETDEVICES && WLAN && MAC80211 && USB || ADM8211 && NETDEVICES && WLAN && MAC80211 && PCI && EXPERIMENTAL || RT2400PCI && NETDEVICES && WLAN && RT2X00 && PCI || RT2500PCI && NETDEVICES && WLAN && RT2X00 && PCI || RT61PCI && NETDEVICES && WLAN && RT2X00 && PCI || RT2800PCI && NETDEVICES && WLAN && RT2X00 && (RT2800PCI_PCI || RT2800PCI_SOC) && EXPERIMENTAL || R8187SE && STAGING && !STAGING_EXCLUDE_BUILD && PCI && WLAN) selects EEPROM_93CX6 which has unmet direct dependencies (MISC_DEVICES): N/A => 
	warning: (CAVIUM_OCTEON_REFERENCE_BOARD && <choice> || BCM63XX_CPU_6338 && BCM63XX) selects USB_ARCH_HAS_OHCI which has unmet direct dependencies (USB_SUPPORT): N/A => 
	warning: (CAVIUM_OCTEON_REFERENCE_BOARD && <choice>) selects USB_ARCH_HAS_EHCI which has unmet direct dependencies (USB_SUPPORT): N/A => 
	warning: (COMPAT && SPARC64) selects COMPAT_BINFMT_ELF which has unmet direct dependencies (COMPAT && BINFMT_ELF): N/A => 
	warning: (CRYPTO_LRW && CRYPTO && EXPERIMENTAL || CRYPTO_XTS && CRYPTO && EXPERIMENTAL || CRYPTO_GHASH && CRYPTO) selects CRYPTO_GF128MUL which has unmet direct dependencies (CRYPTO && EXPERIMENTAL): N/A => 
	warning: (ETRAX_USB_HOST && ETRAX_ARCH_V10 || MOUSE_APPLETOUCH && !S390 && INPUT && INPUT_MOUSE && USB_ARCH_HAS_HCD || MOUSE_BCM5974 && !S390 && INPUT && INPUT_MOUSE && USB_ARCH_HAS_HCD || JOYSTICK_XPAD && !S390 && INPUT && INPUT_JOYSTICK && USB_ARCH_HAS_HCD || TABLET_USB_ACECAD && !S390 && INPUT && INPUT_TABLET && USB_ARCH_HAS_HCD || TABLET_USB_AIPTEK && !S390 && INPUT && INPUT_TABLET && USB_ARCH_HAS_HCD || TABLET_USB_HANWANG && !S390 && INPUT && INPUT_TABLET && USB_ARCH_HAS_HCD || TABLET_USB_KBTAB && !S390 && INPUT && INPUT_TABLET && USB_ARCH_HAS_HCD || TABLET_USB_WACOM && !S390 && INPUT && INPUT_TABLET && USB_ARCH_HAS_HCD || TOUCHSCREEN_USB_COMPOSITE && !S390 && INPUT && INPUT_TOUCHSCREEN && USB_ARCH_HAS_HCD || INPUT_ATI_REMOTE && !S390 && INPUT && INPUT_MISC && USB_ARCH_HAS_HCD || INPUT_ATI_REMOTE2 && !S390 && INPUT && INPUT_MISC && USB_ARCH_HAS_HCD || INPUT_KEYSPAN_REMOTE && !S390 && INPUT && INPUT_MISC && EXPERIMENTAL && USB_ARCH_HAS_HCD || INPUT_POWERMATE && !S390 && INPUT && INPUT_MISC && USB_ARCH_HAS_HCD || INPUT_YEALINK && !S390 && INPUT && INPUT_MISC && EXPERIMENTAL && USB_ARCH_HAS_HCD || INPUT_CM109 && !S390 && INPUT && INPUT_MISC && EXPERIMENTAL && USB_ARCH_HAS_HCD) selects USB which has unmet direct dependencies (USB_SUPPORT && USB_ARCH_HAS_HCD): N/A => 
	warning: (LGUEST_GUEST && PARAVIRT_GUEST && X86_32 || VIRTIO_PCI && VIRTUALIZATION && PCI && EXPERIMENTAL || VIRTIO_BALLOON && VIRTUALIZATION) selects VIRTIO which has unmet direct dependencies (VIRTUALIZATION): N/A => 
	warning: (LGUEST_GUEST && PARAVIRT_GUEST && X86_32 || VIRTIO_PCI && VIRTUALIZATION && PCI && EXPERIMENTAL || VIRTIO_BALLOON && VIRTUALIZATION) selects VIRTIO_RING which has unmet direct dependencies (VIRTUALIZATION && VIRTIO): N/A => 
	warning: (LOCKDEP && DEBUG_KERNEL && TRACE_IRQFLAGS_SUPPORT && STACKTRACE_SUPPORT && LOCKDEP_SUPPORT && !MIPS && !PPC && !ARM_UNWIND && !S390 && !MICROBLAZE || FAULT_INJECTION_STACKTRACE_FILTER && FAULT_INJECTION_DEBUG_FS && STACKTRACE_SUPPORT && !X86_64 && !PPC && !S390 && !MICROBLAZE || LATENCYTOP && HAVE_LATENCYTOP_SUPPORT && DEBUG_KERNEL && STACKTRACE_SUPPORT && PROC_FS && !MIPS && !PPC && !S390 && !MICROBLAZE || DWARF_UNWINDER || FUNCTION_TRACER && TRACING_SUPPORT && FTRACE && HAVE_FUNCTION_TRACER && !ARM_UNWIND && !S390 || KMEMCHECK && HAVE_ARCH_KMEMCHECK && DEBUG_KERNEL && !X86_USE_3DNOW && (SLUB || SLAB) && !CC_OPTIMIZE_FOR_SIZE && !FUNCTION_TRACER) selects FRAME_POINTER which has unmet direct dependencies (DEBUG_KERNEL && (CRIS || M68K || M68KNOMMU || FRV || UML || AVR32 || SUPERH || BLACKFIN || MN10300) || ARCH_WANT_FRAME_POINTERS): N/A => 
	warning: (LOCKDEP && DEBUG_KERNEL && TRACE_IRQFLAGS_SUPPORT && STACKTRACE_SUPPORT && LOCKDEP_SUPPORT && !MIPS && !PPC && !ARM_UNWIND && !S390 && !MICROBLAZE || FAULT_INJECTION_STACKTRACE_FILTER && FAULT_INJECTION_DEBUG_FS && STACKTRACE_SUPPORT && !X86_64 && !PPC && !S390 && !MICROBLAZE || LATENCYTOP && HAVE_LATENCYTOP_SUPPORT && DEBUG_KERNEL && STACKTRACE_SUPPORT && PROC_FS && !MIPS && !PPC && !S390 && !MICROBLAZE || FUNCTION_TRACER && TRACING_SUPPORT && FTRACE && HAVE_FUNCTION_TRACER && !ARM_UNWIND && !S390 || KMEMCHECK && HAVE_ARCH_KMEMCHECK && DEBUG_KERNEL && !X86_USE_3DNOW && (SLUB || SLAB) && !CC_OPTIMIZE_FOR_SIZE && !FUNCTION_TRACER) selects FRAME_POINTER which has unmet direct dependencies (DEBUG_KERNEL && (CRIS || M68K || M68KNOMMU || FRV || UML || AVR32 || SUPERH || BLACKFIN || MN10300) || ARCH_WANT_FRAME_POINTERS): N/A => 
	warning: (MPC836x_RDK && PPC_83xx || MTD_NAND_FSL_ELBC && MTD && MTD_NAND && PPC_OF || MTD_NAND_FSL_UPM && MTD && MTD_NAND && (PPC_83xx || PPC_85xx)) selects FSL_LBC which has unmet direct dependencies (FSL_SOC): N/A => 
	warning: (NETFILTER_XT_MATCH_REALM && NET && INET && NETFILTER && NETFILTER_XTABLES && NETFILTER_ADVANCED || NET_CLS_ROUTE4 && NET && NET_SCHED) selects NET_CLS_ROUTE which has unmet direct dependencies (NET && NET_SCHED): N/A => 
	warning: (PAGE_POISONING && DEBUG_KERNEL && !ARCH_SUPPORTS_DEBUG_PAGEALLOC && !HIBERNATION) selects DEBUG_PAGEALLOC which has unmet direct dependencies (DEBUG_KERNEL && ARCH_SUPPORTS_DEBUG_PAGEALLOC && (!HIBERNATION || !PPC && !SPARC) && !KMEMCHECK): N/A => 
	warning: (PERF_EVENTS && HAVE_PERF_EVENTS) selects IRQ_WORK which has unmet direct dependencies (HAVE_IRQ_WORK): N/A => 
	warning: (PPC_C2K && EMBEDDED6xx || MTD_WRSBC8260 && MTD && (SBC82xx || SBC8560)) selects MTD_CFI_I4 which has unmet direct dependencies (MTD): N/A => 
	warning: (RADIO_MIROPCM20 && MEDIA_SUPPORT && RADIO_ADAPTERS && ISA && VIDEO_V4L2 && SND) selects SND_ISA which has unmet direct dependencies (SOUND && !M68K && SND && ISA && ISA_DMA_API): N/A => 
	warning: (USB_WUSB && USB_SUPPORT && EXPERIMENTAL && USB) selects UWB which has unmet direct dependencies (EXPERIMENTAL && PCI): N/A => 

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
