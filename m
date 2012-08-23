Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934355Ab2HWUqX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 16:46:23 -0400
Received: from juliette.telenet-ops.be ([195.130.137.74]:56940 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934320Ab2HWUqM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 16:46:12 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-kernel@vger.kernel.org
Subject: Build regressions/improvements in v3.6-rc3
Date: Thu, 23 Aug 2012 22:46:08 +0200
Message-Id: <1345754768-4634-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Below is the list of build error/warning regressions/improvements in
v3.6-rc3[1] compared to v3.5[2].

Too make this mail fit in the lkml limit, I deleted
  - 6021 lines about __mcount_loc on sparc64

Summarized:
  - build errors: +54/-118
  - build warnings: +6202/-246

JFYI, when comparing v3.6-rc3 to v3.6-rc2[3], the summaries are:
  - build errors: +13/-9
  - build warnings: +491/-167

As I haven't mastered kup yet, there's no verbose summary at
http://www.kernel.org/pub/linux/kernel/people/geert/linux-log/v3.6-rc3.summary.gz

Happy fixing! ;-)

Thanks to the linux-next team for providing the build service.

[1] http://kisskb.ellerman.id.au/kisskb/head/5359/ (all 116 configs)
[2] http://kisskb.ellerman.id.au/kisskb/head/5266/ (all 116 configs)
[3] http://kisskb.ellerman.id.au/kisskb/head/5338/ (all 116 configs)


*** ERRORS ***

54 regressions:
  + arch/sh/lib/mcount.S: Error: pcrel too far:  => 89
  + arch/um/os-Linux/skas/process.c: error: 'PTRACE_GETSIGINFO' undeclared (first use in this function):  => 412
  + arch/x86/include/asm/uaccess_32.h: error: call to 'copy_from_user_overflow' declared with attribute error: copy_from_user() buffer size is not provably correct:  => 211:26
  + drivers/extcon/extcon-arizona.c: error: implicit declaration of function 'devm_gpio_request_one' [-Werror=implicit-function-declaration]:  => 372:3
  + drivers/extcon/extcon_gpio.c: error: implicit declaration of function 'devm_gpio_request_one' [-Werror=implicit-function-declaration]:  => 110:2
  + drivers/i2c/busses/i2c-ocores.c: error: implicit declaration of function 'ioread16' [-Werror=implicit-function-declaration]:  => 89:3
  + drivers/i2c/busses/i2c-ocores.c: error: implicit declaration of function 'ioread32' [-Werror=implicit-function-declaration]:  => 87:3
  + drivers/i2c/busses/i2c-ocores.c: error: implicit declaration of function 'iowrite16' [-Werror=implicit-function-declaration]:  => 79:3
  + drivers/i2c/busses/i2c-ocores.c: error: implicit declaration of function 'iowrite32' [-Werror=implicit-function-declaration]:  => 77:3
  + drivers/i2c/busses/i2c-piix4.c: error: implicit declaration of function 'kfree' [-Werror=implicit-function-declaration]:  => 563:3
  + drivers/i2c/busses/i2c-piix4.c: error: implicit declaration of function 'kzalloc' [-Werror=implicit-function-declaration]:  => 551:2
  + drivers/ieee802154/at86rf230.c: error: implicit declaration of function 'gpio_direction_output' [-Werror=implicit-function-declaration]:  => 832:2
  + drivers/ieee802154/at86rf230.c: error: implicit declaration of function 'gpio_free' [-Werror=implicit-function-declaration]:  => 912:3
  + drivers/ieee802154/at86rf230.c: error: implicit declaration of function 'gpio_request' [-Werror=implicit-function-declaration]:  => 822:2
  + drivers/iio/adc/ad7266.c: error: implicit declaration of function 'gpio_free_array' [-Werror=implicit-function-declaration]:  => 485:3
  + drivers/iio/adc/ad7266.c: error: implicit declaration of function 'gpio_request_array' [-Werror=implicit-function-declaration]:  => 432:4
  + drivers/iio/frequency/adf4350.c: error: implicit declaration of function 'gpio_direction_input' [-Werror=implicit-function-declaration]:  => 412:3
  + drivers/iio/frequency/adf4350.c: error: implicit declaration of function 'gpio_free' [-Werror=implicit-function-declaration]:  => 429:3
  + drivers/iio/frequency/adf4350.c: error: implicit declaration of function 'gpio_request' [-Werror=implicit-function-declaration]:  => 406:3
  + drivers/input/touchscreen/edt-ft5x06.c: error: implicit declaration of function 'gpio_free' [-Werror=implicit-function-declaration]:  => 824:3
  + drivers/input/touchscreen/edt-ft5x06.c: error: implicit declaration of function 'gpio_request_one' [-Werror=implicit-function-declaration]:  => 631:3
  + drivers/input/touchscreen/eeti_ts.c: error: implicit declaration of function 'gpio_free' [-Werror=implicit-function-declaration]:  => 243:2
  + drivers/input/touchscreen/eeti_ts.c: error: implicit declaration of function 'gpio_request_one' [-Werror=implicit-function-declaration]:  => 205:2
  + drivers/mfd/arizona-core.c: error: implicit declaration of function 'gpio_free' [-Werror=implicit-function-declaration]:  => 543:3
  + drivers/mfd/arizona-core.c: error: implicit declaration of function 'gpio_request_one' [-Werror=implicit-function-declaration]:  => 356:3
  + drivers/mmc/core/slot-gpio.c: error: implicit declaration of function 'gpio_free' [-Werror=implicit-function-declaration]:  => 166:2
  + drivers/mmc/core/slot-gpio.c: error: implicit declaration of function 'gpio_request_one' [-Werror=implicit-function-declaration]:  => 103:2
  + drivers/net/can/c_can/c_can_pci.c: error: implicit declaration of function 'pci_iomap' [-Werror=implicit-function-declaration]:  => 90:2
  + drivers/net/can/c_can/c_can_pci.c: error: implicit declaration of function 'pci_iounmap' [-Werror=implicit-function-declaration]:  => 166:2
  + drivers/net/can/usb/peak_usb/pcan_usb_core.c: error: conflicting types for 'dump_mem':  => 56:6
  + drivers/net/can/usb/peak_usb/pcan_usb_core.h: error: conflicting types for 'dump_mem':  => 134:6
  + drivers/net/wireless/iwlwifi/iwl-test.c: error: implicit declaration of function 'mmiowb' [-Werror=implicit-function-declaration]:  => 515:5
  + drivers/regulator/core.c: error: implicit declaration of function 'gpio_free' [-Werror=implicit-function-declaration]:  => 3309:3
  + drivers/regulator/core.c: error: implicit declaration of function 'gpio_request_one' [-Werror=implicit-function-declaration]:  => 3221:3
  + drivers/regulator/tps62360-regulator.c: error: implicit declaration of function 'devm_gpio_request_one' [-Werror=implicit-function-declaration]:  => 431:3
  + drivers/spi/spi-rspi.c: error: 'struct sh_dmae_slave' has no member named 'slave_id':  => 696:15, 687:15
  + drivers/video/backlight/l4f00242t03.c: error: implicit declaration of function 'devm_gpio_request_one' [-Werror=implicit-function-declaration]:  => 178:2
  + drivers/video/backlight/lms283gf05.c: error: implicit declaration of function 'devm_gpio_request' [-Werror=implicit-function-declaration]:  => 161:3
  + drivers/vme/bridges/vme_tsi148.c: error: implicit declaration of function 'iowrite16' [-Werror=implicit-function-declaration]:  => 1376:4
  + drivers/vme/bridges/vme_tsi148.c: error: implicit declaration of function 'iowrite8' [-Werror=implicit-function-declaration]:  => 1365:3
  + error: No rule to make target /scratch/kisskb/build/linus_m68k-allmodconfig_m68k/usr/include/linux/kvm_para.h:  => N/A
  + error: No rule to make target drivers/scsi/aic7xxx/aicasm/*.[chyl]:  => N/A
  + error: eni.c: relocation truncated to fit: R_PPC64_REL24 against symbol `._raw_read_lock' defined in .spinlock.text section in kernel/built-in.o:  => (.text+0x1ff91bc)
  + error: eni.c: relocation truncated to fit: R_PPC64_REL24 against symbol `.sprintf' defined in .text section in lib/lib.a(vsprintf.o):  => (.text+0x1ff940c)
  + error: eni.c: relocation truncated to fit: R_PPC64_REL24 against symbol `_restgpr0_16' defined in .text.save.restore section in arch/powerpc/lib/built-in.o:  => (.text+0x1ffa6e8)
  + error: eni.c: relocation truncated to fit: R_PPC64_REL24 against symbol `_savegpr0_27' defined in .text.save.restore section in arch/powerpc/lib/built-in.o:  => (.text+0x1ff9854)
  + error: eni.c: relocation truncated to fit: R_PPC64_REL24 against symbol `_savegpr0_30' defined in .text.save.restore section in arch/powerpc/lib/built-in.o:  => (.text+0x1ff8eb4), (.text+0x1ff8e80)
  + error: fore200e.c: relocation truncated to fit: R_PPC64_REL24 against symbol `._raw_spin_unlock_irqrestore' defined in .spinlock.text section in kernel/built-in.o:  => (.text+0x1ff82cc), (.text+0x1ff8278)
  + error: fore200e.c: relocation truncated to fit: R_PPC64_REL24 against symbol `.mutex_unlock' defined in .sched.text section in kernel/built-in.o:  => (.text+0x1ff83fc), (.text+0x1ff83a8)
  + error: via-pmu-event.c: undefined reference to `.input_allocate_device':  => .init.text+0xdfbc)
  + error: via-pmu-event.c: undefined reference to `.input_free_device':  => .init.text+0xe084)
  + error: via-pmu-event.c: undefined reference to `.input_register_device':  => .init.text+0xe06c)
  + net/core/sock.c: error: (near initialization for 'memalloc_socks'):  => 274:45
  + net/core/sock.c: error: initializer element is not constant:  => 274:45

118 improvements:
  - block/blk-cgroup.c: error: implicit declaration of function 'ATOMIC64_INIT' [-Werror=implicit-function-declaration]: 609:2 => 
  - block/blk-cgroup.c: error: implicit declaration of function 'atomic64_inc_return' [-Werror=implicit-function-declaration]: 623:2 => 
  - block/blk-cgroup.c: error: initializer element is not constant: 609:2 => 
  - block/blk-cgroup.c: error: unknown type name 'atomic64_t': 609:2 => 
  - drivers/block/rbd.c: error: implicit declaration of function 'ATOMIC64_INIT' [-Werror=implicit-function-declaration]: 2172:1 => 
  - drivers/block/rbd.c: error: implicit declaration of function 'atomic64_cmpxchg' [-Werror=implicit-function-declaration]: 2232:2 => 
  - drivers/block/rbd.c: error: implicit declaration of function 'atomic64_inc_return' [-Werror=implicit-function-declaration]: 2180:2 => 
  - drivers/block/rbd.c: error: implicit declaration of function 'atomic64_read' [-Werror=implicit-function-declaration]: 2206:2 => 
  - drivers/block/rbd.c: error: initializer element is not constant: 2172:1 => 
  - drivers/block/rbd.c: error: unknown type name 'atomic64_t': 2172:1 => 
  - drivers/extcon/extcon_gpio.c: error: implicit declaration of function 'gpio_free' [-Werror=implicit-function-declaration]: 136:2 => 
  - drivers/extcon/extcon_gpio.c: error: implicit declaration of function 'gpio_request_one' [-Werror=implicit-function-declaration]: 110:2 => 
  - drivers/gpu/drm/radeon/radeon.h: error: unknown type name 'atomic64_t': 263:2 => 
  - drivers/gpu/drm/radeon/radeon_fence.c: error: implicit declaration of function 'atomic64_read' [-Werror=implicit-function-declaration]: 103:2 => 
  - drivers/gpu/drm/radeon/radeon_fence.c: error: implicit declaration of function 'atomic64_set' [-Werror=implicit-function-declaration]: 553:2 => 
  - drivers/gpu/drm/radeon/radeon_fence.c: error: implicit declaration of function 'atomic64_xchg' [-Werror=implicit-function-declaration]: 128:2 => 
  - drivers/i2c/busses/i2c-bfin-twi.c: error: 'ANAK' undeclared (first use in this function): 154:19 => 
  - drivers/i2c/busses/i2c-bfin-twi.c: error: 'BUFRDERR' undeclared (first use in this function): 158:19 => 
  - drivers/i2c/busses/i2c-bfin-twi.c: error: 'BUFWRERR' undeclared (first use in this function): 160:19 => 
  - drivers/i2c/busses/i2c-bfin-twi.c: error: 'BUSBUSY' undeclared (first use in this function): 401:35, 301:35 => 
  - drivers/i2c/busses/i2c-bfin-twi.c: error: 'DNAK' undeclared (first use in this function): 156:19 => 
  - drivers/i2c/busses/i2c-bfin-twi.c: error: 'FAST' undeclared (first use in this function): 511:17, 360:18 => 
  - drivers/i2c/busses/i2c-bfin-twi.c: error: 'LOSTARB' undeclared (first use in this function): 152:19 => 
  - drivers/i2c/busses/i2c-bfin-twi.c: error: 'MCOMP' undeclared (first use in this function): 189:22, 489:31, 344:31 => 
  - drivers/i2c/busses/i2c-bfin-twi.c: error: 'MDIR' undeclared (first use in this function): 359:31, 567:32, 102:30 => 
  - drivers/i2c/busses/i2c-bfin-twi.c: error: 'MEN' undeclared (first use in this function): 358:51, 510:52, 196:33 => 
  - drivers/i2c/busses/i2c-bfin-twi.c: error: 'MERR' undeclared (first use in this function): 146:23, 489:24, 344:24 => 
  - drivers/i2c/busses/i2c-bfin-twi.c: error: 'RCVSERV' undeclared (first use in this function): 489:49, 116:23, 344:49 => 
  - drivers/i2c/busses/i2c-bfin-twi.c: error: 'RSTART' undeclared (first use in this function): 102:37 => 
  - drivers/i2c/busses/i2c-bfin-twi.c: error: 'SCLOVR' undeclared (first use in this function): 171:29 => 
  - drivers/i2c/busses/i2c-bfin-twi.c: error: 'SDAOVR' undeclared (first use in this function): 177:28 => 
  - drivers/i2c/busses/i2c-bfin-twi.c: error: 'SDASEN' undeclared (first use in this function): 168:33 => 
  - drivers/i2c/busses/i2c-bfin-twi.c: error: 'STOP' undeclared (first use in this function): 105:30 => 
  - drivers/i2c/busses/i2c-bfin-twi.c: error: 'TWI_ENA' undeclared (first use in this function): 398:30, 624:47, 298:30, 725:45 => 
  - drivers/i2c/busses/i2c-bfin-twi.c: error: 'XMTSERV' undeclared (first use in this function): 344:39, 489:39, 90:23 => 
  - drivers/mmc/core/cd-gpio.c: error: implicit declaration of function 'gpio_free' [-Werror=implicit-function-declaration]: 65:2 => 
  - drivers/mmc/core/cd-gpio.c: error: implicit declaration of function 'gpio_request_one' [-Werror=implicit-function-declaration]: 48:2 => 
  - drivers/net/cris/eth_v10.c: error: too many arguments to function 'e100rxtx_interrupt': 1715:2 => 
  - drivers/net/irda/bfin_sir.c: error: 'IREN' undeclared (first use in this function): 161:9, 521:11, 435:18 => 
  - drivers/net/wireless/iwlwifi/iwl-testmode.c: error: implicit declaration of function 'mmiowb' [-Werror=implicit-function-declaration]: 851:5 => 
  - drivers/regulator/fixed.c: error: implicit declaration of function 'gpio_free' [-Werror=implicit-function-declaration]: 274:3 => 
  - drivers/regulator/fixed.c: error: implicit declaration of function 'gpio_request_one' [-Werror=implicit-function-declaration]: 238:3 => 
  - drivers/regulator/gpio-regulator.c: error: implicit declaration of function 'gpio_direction_output' [-Werror=implicit-function-declaration]: 254:4 => 
  - drivers/regulator/gpio-regulator.c: error: implicit declaration of function 'gpio_free' [-Werror=implicit-function-declaration]: 310:3 => 
  - drivers/regulator/gpio-regulator.c: error: implicit declaration of function 'gpio_request' [-Werror=implicit-function-declaration]: 241:3 => 
  - drivers/regulator/tps62360-regulator.c: error: implicit declaration of function 'gpio_free' [-Werror=implicit-function-declaration]: 510:3 => 
  - drivers/regulator/tps62360-regulator.c: error: implicit declaration of function 'gpio_request_one' [-Werror=implicit-function-declaration]: 452:3 => 
  - drivers/staging/ccg/../../usb/gadget/f_mass_storage.c: error: implicit declaration of function 'get_ds' [-Werror=implicit-function-declaration]: 2624:2 => 
  - drivers/staging/ccg/../../usb/gadget/f_mass_storage.c: error: implicit declaration of function 'set_fs' [-Werror=implicit-function-declaration]: 2624:2 => 
  - drivers/staging/ccg/../../usb/gadget/storage_common.c: error: implicit declaration of function 'bdev_logical_block_size' [-Werror=implicit-function-declaration]: 686:3 => 
  - drivers/staging/ccg/../../usb/gadget/storage_common.c: error: implicit declaration of function 'blksize_bits' [-Werror=implicit-function-declaration]: 687:3 => 
  - drivers/staging/iio/magnetometer/ak8975.c: error: implicit declaration of function 'gpio_direction_input' [-Werror=implicit-function-declaration]: 499:3 => 
  - drivers/staging/iio/magnetometer/ak8975.c: error: implicit declaration of function 'gpio_free' [-Werror=implicit-function-declaration]: 543:3 => 
  - drivers/staging/iio/magnetometer/ak8975.c: error: implicit declaration of function 'gpio_request' [-Werror=implicit-function-declaration]: 491:3 => 
  - drivers/video/backlight/l4f00242t03.c: error: implicit declaration of function 'gpio_free' [-Werror=implicit-function-declaration]: 231:2 => 
  - drivers/video/backlight/l4f00242t03.c: error: implicit declaration of function 'gpio_request_one' [-Werror=implicit-function-declaration]: 178:2 => 
  - drivers/video/backlight/lms283gf05.c: error: implicit declaration of function 'gpio_free' [-Werror=implicit-function-declaration]: 199:3 => 
  - drivers/video/backlight/lms283gf05.c: error: implicit declaration of function 'gpio_request' [-Werror=implicit-function-declaration]: 161:3 => 
  - error: "__lshrdi3" [drivers/mtd/mtd.ko] undefined!: N/A => 
  - error: "__lshrdi3" [fs/ntfs/ntfs.ko] undefined!: N/A => 
  - error: "__lshrdi3" [fs/xfs/xfs.ko] undefined!: N/A => 
  - error: No rule to make target /scratch/kisskb/build/linus_sh-randconfig_sh4/usr/include/linux/kvm_para.h: N/A => 
  - error: No rule to make target include/config/auto.conf: N/A => 
  - error: idt77252.c: relocation truncated to fit: R_PPC64_REL24 against symbol `.__raw_spin_lock_init' defined in .text section in lib/built-in.o: (.text+0x1ff8874), (.text+0x1ff8844), (.text+0x1ff8800), (.text+0x1ff8820) => 
  - error: idt77252.c: relocation truncated to fit: R_PPC64_REL24 against symbol `.printk' defined in .text.unlikely section in kernel/built-in.o: (.text+0x1ff9144), (.text+0x1ff9704), (.text+0x1ff90c4), (.text+0x1ff9018), (.text+0x1ff9744) => 
  - error: idt77252.c: relocation truncated to fit: R_PPC64_REL24 against symbol `_restgpr0_29' defined in .text section in arch/powerpc/lib/built-in.o: (.text+0x1ff8370) => 
  - fs/xfs/xfs_log.c: error: implicit declaration of function 'atomic64_read' [-Werror=implicit-function-declaration]: 947:3 => 
  - fs/xfs/xfs_log.c: error: implicit declaration of function 'atomic64_set' [-Werror=implicit-function-declaration]: 948:2 => 
  - fs/xfs/xfs_log.c: error: implicit declaration of function 'xlog_assign_atomic_lsn' [-Werror=implicit-function-declaration]: 1163:2 => 
  - fs/xfs/xfs_log.c: error: implicit declaration of function 'xlog_assign_grant_head' [-Werror=implicit-function-declaration]: 161:2 => 
  - fs/xfs/xfs_log.c: error: implicit declaration of function 'xlog_crack_atomic_lsn' [-Werror=implicit-function-declaration]: 1354:2 => 
  - fs/xfs/xfs_log.c: error: implicit declaration of function 'xlog_crack_grant_head' [-Werror=implicit-function-declaration]: 3328:2 => 
  - fs/xfs/xfs_log.c: error: implicit declaration of function 'xlog_grant_add_space' [-Werror=implicit-function-declaration]: 370:2 => 
  - fs/xfs/xfs_log.c: error: implicit declaration of function 'xlog_grant_sub_space' [-Werror=implicit-function-declaration]: 2642:2 => 
  - fs/xfs/xfs_log.c: error: implicit declaration of function 'xlog_space_left' [-Werror=implicit-function-declaration]: 243:2 => 
  - fs/xfs/xfs_log.c: error: unknown type name 'atomic64_t': 105:2, 982:2, 55:2, 131:2 => 
  - fs/xfs/xfs_log_priv.h: error: unknown type name 'atomic64_t': 533:2, 622:23, 634:24, 531:2, 604:24, 481:2, 592:23 => 
  - fs/xfs/xfs_log_recover.c: error: implicit declaration of function 'atomic64_read' [-Werror=implicit-function-declaration]: 1004:2 => 
  - fs/xfs/xfs_log_recover.c: error: implicit declaration of function 'atomic64_set' [-Werror=implicit-function-declaration]: 969:2 => 
  - fs/xfs/xfs_log_recover.c: error: implicit declaration of function 'xlog_assign_atomic_lsn' [-Werror=implicit-function-declaration]: 1019:4 => 
  - fs/xfs/xfs_log_recover.c: error: implicit declaration of function 'xlog_assign_grant_head' [-Werror=implicit-function-declaration]: 971:2 => 
  - include/net/netfilter/nf_conntrack_acct.h: error: unknown type name 'atomic64_t': 18:2, 19:2 => 
  - lib/atomic64_test.c: error: implicit declaration of function 'ATOMIC64_INIT' [-Werror=implicit-function-declaration]: 25:2 => 
  - lib/atomic64_test.c: error: implicit declaration of function 'atomic64_add' [-Werror=implicit-function-declaration]: 35:2 => 
  - lib/atomic64_test.c: error: implicit declaration of function 'atomic64_add_return' [-Werror=implicit-function-declaration]: 46:2 => 
  - lib/atomic64_test.c: error: implicit declaration of function 'atomic64_add_unless' [-Werror=implicit-function-declaration]: 109:2 => 
  - lib/atomic64_test.c: error: implicit declaration of function 'atomic64_cmpxchg' [-Werror=implicit-function-declaration]: 100:2 => 
  - lib/atomic64_test.c: error: implicit declaration of function 'atomic64_dec' [-Werror=implicit-function-declaration]: 85:2 => 
  - lib/atomic64_test.c: error: implicit declaration of function 'atomic64_dec_return' [-Werror=implicit-function-declaration]: 91:2 => 
  - lib/atomic64_test.c: error: implicit declaration of function 'atomic64_inc' [-Werror=implicit-function-declaration]: 75:2 => 
  - lib/atomic64_test.c: error: implicit declaration of function 'atomic64_inc_not_zero' [-Werror=implicit-function-declaration]: 136:2 => 
  - lib/atomic64_test.c: error: implicit declaration of function 'atomic64_inc_return' [-Werror=implicit-function-declaration]: 81:2 => 
  - lib/atomic64_test.c: error: implicit declaration of function 'atomic64_read' [-Werror=implicit-function-declaration]: 32:2 => 
  - lib/atomic64_test.c: error: implicit declaration of function 'atomic64_set' [-Werror=implicit-function-declaration]: 29:2 => 
  - lib/atomic64_test.c: error: implicit declaration of function 'atomic64_sub' [-Werror=implicit-function-declaration]: 55:2 => 
  - lib/atomic64_test.c: error: implicit declaration of function 'atomic64_sub_return' [-Werror=implicit-function-declaration]: 66:2 => 
  - lib/atomic64_test.c: error: implicit declaration of function 'atomic64_xchg' [-Werror=implicit-function-declaration]: 95:2 => 
  - lib/atomic64_test.c: error: request for member 'counter' in something not a structure or union: 72:32, 47:32, 42:32, 77:32, 87:32, 102:32, 67:32, 52:32, 106:32, 110:32, 37:32, 62:32, 57:32, 115:32, 31:32, 82:32, 92:32, 142:32, 97:32, 147:32, 138:32, 27:32 => 
  - lib/atomic64_test.c: error: unknown type name 'atomic64_t': 25:2 => 
  - lib/mpi/mpih-div.c: error: impossible constraint in 'asm': 135:202, 135:55, 106:201, 97:55, 106:54, 97:202 => 205:6, 142:6
  - lib/mpi/mpih-div.c: error: inconsistent operand constraints in an 'asm': 135:122, 135:371, 97:122, 106:121, 106:370, 97:371 => 142:73, 205:73
  - net/mac80211/cfg.c: error: implicit declaration of function 'atomic64_read' [-Werror=implicit-function-declaration]: 271:3 => 
  - net/mac80211/debugfs_key.c: error: implicit declaration of function 'atomic64_read' [-Werror=implicit-function-declaration]: 97:3 => 
  - net/mac80211/key.c: error: implicit declaration of function 'atomic64_read' [-Werror=implicit-function-declaration]: 644:3 => 
  - net/mac80211/key.h: error: unknown type name 'atomic64_t': 100:4, 88:4 => 
  - net/mac80211/wpa.c: error: implicit declaration of function 'atomic64_inc_return' [-Werror=implicit-function-declaration]: 442:2 => 
  - net/netfilter/nf_conntrack_acct.c: error: implicit declaration of function 'atomic64_read' [-Werror=implicit-function-declaration]: 49:6 => 
  - net/netfilter/nf_conntrack_core.c: error: implicit declaration of function 'atomic64_add' [-Werror=implicit-function-declaration]: 1102:4 => 
  - net/netfilter/nf_conntrack_core.c: error: implicit declaration of function 'atomic64_inc' [-Werror=implicit-function-declaration]: 1101:4 => 
  - net/netfilter/nf_conntrack_netlink.c: error: implicit declaration of function 'atomic64_read' [-Werror=implicit-function-declaration]: 248:3 => 
  - net/netfilter/nf_conntrack_netlink.c: error: implicit declaration of function 'atomic64_xchg' [-Werror=implicit-function-declaration]: 245:3 => 
  - net/netfilter/nfnetlink_acct.c: error: implicit declaration of function 'atomic64_add' [-Werror=implicit-function-declaration]: 330:2 => 
  - net/netfilter/nfnetlink_acct.c: error: implicit declaration of function 'atomic64_inc' [-Werror=implicit-function-declaration]: 329:2 => 
  - net/netfilter/nfnetlink_acct.c: error: implicit declaration of function 'atomic64_read' [-Werror=implicit-function-declaration]: 119:3 => 
  - net/netfilter/nfnetlink_acct.c: error: implicit declaration of function 'atomic64_set' [-Werror=implicit-function-declaration]: 67:4 => 
  - net/netfilter/nfnetlink_acct.c: error: implicit declaration of function 'atomic64_xchg' [-Werror=implicit-function-declaration]: 116:3 => 
  - net/netfilter/nfnetlink_acct.c: error: unknown type name 'atomic64_t': 33:2, 34:2 => 
  - net/netfilter/xt_connbytes.c: error: implicit declaration of function 'atomic64_read' [-Werror=implicit-function-declaration]: 43:4 => 


*** WARNINGS ***

6202 regressions:
  + Documentation/watchdog/src/watchdog-test.c: warning: no previous prototype for 'term' [-Wmissing-prototypes]:  => 34:6
  + arch/blackfin/include/asm/bfin_twi.h: warning: "ANOMALY_16000030" is not defined [-Wundef]:  => 87:6
  + arch/powerpc/kvm/book3s_emulate.c: warning: 'bat' may be used uninitialized in this function [-Wuninitialized]:  => 347:17, 450:18
  + arch/powerpc/kvm/powerpc.c: warning: 'r' may be used uninitialized in this function [-Wuninitialized]:  => 159:2
  + arch/um/kernel/ptrace.c: warning: ignoring return value of 'tracehook_report_syscall_entry', declared with attribute warn_unused_result:  => 178
  + arch/x86/kernel/cpu/perf_event_intel_uncore.c: warning: 'count' is used uninitialized in this function [-Wuninitialized]:  => 164:2
  + arch/x86/pci/sta2x11-fixup.c: warning: (near initialization for 'sta2x11_dma_ops.free') [enabled by default]:  => 186:2
  + arch/x86/pci/sta2x11-fixup.c: warning: initialization from incompatible pointer type [enabled by default]:  => 186:2
  + drivers/ata/ahci_platform.c: warning: 'ahci_resume' defined but not used [-Wunused-function]:  => 251:12
  + drivers/ata/ahci_platform.c: warning: 'ahci_suspend' defined but not used [-Wunused-function]:  => 218:12
  + drivers/extcon/extcon-max77693.c: warning: 'adc' may be used uninitialized in this function [-Wuninitialized]:  => 361:10
  + drivers/extcon/extcon-max77693.c: warning: 'adc1k' may be used uninitialized in this function [-Wuninitialized]:  => 361:10
  + drivers/extcon/extcon-max77693.c: warning: 'adclow' may be used uninitialized in this function [-Wuninitialized]:  => 361:10
  + drivers/gpio/gpio-bt8xx.c: warning: ignoring return value of 'gpiochip_remove', declared with attribute warn_unused_result [-Wunused-result]:  => 244:17
  + drivers/gpu/drm/drm_pci.c: warning: 'lnkcap' may be used uninitialized in this function [-Wuninitialized]:  => 496:9
  + drivers/gpu/drm/drm_pci.c: warning: 'lnkcap2' may be used uninitialized in this function [-Wuninitialized]:  => 497:10
  + drivers/i2c/busses/i2c-ocores.c: warning: 'ocores_i2c_resume' defined but not used [-Wunused-function]:  => 375:12
  + drivers/i2c/busses/i2c-ocores.c: warning: 'ocores_i2c_suspend' defined but not used [-Wunused-function]:  => 364:12
  + drivers/i2c/busses/i2c-piix4.c: warning: assignment makes pointer from integer without a cast [enabled by default]:  => 561:11, 551:7
  + drivers/iio/dac/ad5446.c: warning: 'ad5446_remove' defined but not used [-Wunused-function]:  => 339:12
  + drivers/infiniband/hw/ocrdma/ocrdma_main.c: warning: 'ocrdma_del_sgid' defined but not used [-Wunused-function]:  => 131:13
  + drivers/md/raid10.c: warning: 'handle_reshape_read_error' uses dynamic stack allocation [enabled by default]:  => 4476:1
  + drivers/md/raid10.c: warning: 'raid10_mergeable_bvec' uses dynamic stack allocation [enabled by default]:  => 708:1
  + drivers/media/dvb/frontends/drxk_hard.c: warning: 'status' may be used uninitialized in this function [-Wuninitialized]:  => 5467:5
  + drivers/mfd/sec-core.c: warning: 'ret' may be used uninitialized in this function [-Wuninitialized]:  => 163:5
  + drivers/mfd/twl6030-irq.c: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]: 398:24, 415:9 => 398:24, 415:9, 415:81
  + drivers/mfd/wl1273-core.c: warning: 'wl1273_core_remove' defined but not used [-Wunused-function]:  => 173:12
  + drivers/misc/bmp085-i2c.c: warning: 'bmp085_i2c_remove' defined but not used [-Wunused-function]:  => 55:12
  + drivers/net/can/c_can/c_can_pci.c: warning: assignment makes pointer from integer without a cast [enabled by default]:  => 90:7
  + drivers/net/ethernet/broadcom/cnic.c: warning: the frame size of 1096 bytes is larger than 1024 bytes [-Wframe-larger-than=]:  => 4759:1
  + drivers/net/ethernet/sun/sunbmac.c: warning: unused variable 'dev' [-Wunused-variable]:  => 215:21
  + drivers/net/wimax/i2400m/control.c: warning: format '%zd' expects argument of type 'signed size_t', but argument 4 has type 'ssize_t' [-Wformat]:  => 134:10
  + drivers/net/wimax/i2400m/control.c: warning: format '%zd' expects argument of type 'signed size_t', but argument 5 has type 'ssize_t' [-Wformat]:  => 239:6
  + drivers/net/wimax/i2400m/usb-fw.c: warning: format '%zd' expects argument of type 'signed size_t', but argument 4 has type 'ssize_t' [-Wformat]: 210:4 => 210:4, 215:4
  + drivers/pci/pci-driver.c: warning: 'pci_restore_standard_config' defined but not used [-Wunused-function]:  => 448:12
  + drivers/power/smb347-charger.c: warning: 'smb347_remove' defined but not used [-Wunused-function]:  => 1220:12
  + drivers/regulator/core.c: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]:  => 2183:10
  + drivers/regulator/twl-regulator.c: warning: 'twl6030_fixed_resource' defined but not used [-Wunused-variable]:  => 662:29
  + drivers/rtc/rtc-88pm80x.c: warning: 'pm80x_rtc_resume' defined but not used [-Wunused-function]:  => 243:12
  + drivers/rtc/rtc-88pm80x.c: warning: 'pm80x_rtc_suspend' defined but not used [-Wunused-function]:  => 238:12
  + drivers/scsi/aacraid/src.c: warning: right shift count >= width of type [enabled by default]:  => 434:2, 410:3
  + drivers/scsi/atp870u.c: warning: 'atp870u_remove' defined but not used [-Wunused-function]:  => 3148:13
  + drivers/scsi/ufs/ufshcd.c: warning: 'ufshcd_remove' defined but not used [-Wunused-function]:  => 1759:13
  + drivers/scsi/vmw_pvscsi.c: warning: 'pvscsi_remove' defined but not used [-Wunused-function]:  => 1437:13
  + drivers/staging/comedi/drivers/ni_mio_common.c: warning: 'sample' may be used uninitialized in this function [-Wuninitialized]:  => 5970:11
  + drivers/staging/sm7xxfb/sm7xxfb.c: warning: 'sm7xx_vga_setup' defined but not used [-Wunused-function]:  => 112:122, 112:19
  + drivers/staging/vt6656/iwctl.c: warning: the frame size of 1292 bytes is larger than 1024 bytes [-Wframe-larger-than=]:  => 683:1
  + drivers/staging/wlan-ng/cfg80211.c: warning: (near initialization for 'prism2_usb_cfg_ops.scan') [enabled by default]:  => 726:2
  + drivers/staging/wlan-ng/cfg80211.c: warning: initialization from incompatible pointer type [enabled by default]:  => 726:2
  + drivers/tty/serial/8250/8250.c: warning: 'i' may be used uninitialized in this function [-Wuninitialized]: 1653:28, 1653:32, 1658:18, 1653:2 => 1661:28, 1661:32, 1663:18, 1666:18, 1661:2
  + drivers/usb/storage/uas.c: warning: 'cmdinfo' may be used uninitialized in this function [-Wuninitialized]:  => 261:15
  + drivers/video/backlight/adp8870_bl.c: warning: 'reg_val' may be used uninitialized in this function [-Wuninitialized]:  => 807:11
  + drivers/video/backlight/pwm_bl.c: warning: 'pwm_backlight_resume' defined but not used [-Wunused-function]:  => 295:12
  + drivers/video/backlight/pwm_bl.c: warning: 'pwm_backlight_suspend' defined but not used [-Wunused-function]:  => 281:12
  + fs/btrfs/ctree.h: warning: 'ref_root' may be used uninitialized in this function [-Wuninitialized]:  => 3525:6
  + fs/btrfs/delayed-inode.c: warning: 'root' may be used uninitialized in this function [-Wuninitialized]: 468:17 => 469:17, 454:9
  + fs/btrfs/qgroup.c: warning: 'sgn' may be used uninitialized in this function [-Wuninitialized]:  => 1111:28, 1221:21
  + fs/btrfs/send.c: warning: 'cb' may be used uninitialized in this function [-Wuninitialized]:  => 3228:7
  + fs/btrfs/send.c: warning: 'root' may be used uninitialized in this function [-Wuninitialized]:  => 3208:7
  + fs/btrfs/send.c: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]:  => 1034:13
  + fs/btrfs/send.c: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]:  => 1067:18
  + fs/jbd2/commit.c: warning: 'jbd2_block_tag_csum_set.isra.3' uses dynamic stack allocation [enabled by default]:  => 360:1
  + fs/namei.c: warning: 'cookie' may be used uninitialized in this function [-Wuninitialized]:  => 1553:11, 2921:11, 1946:12, 650:24
  + fs/namei.c: warning: 'cookie' may be used uninitialized in this function:  => 2905, 1546, 1936
  + fs/ocfs2/stack_o2cb.c: warning: array subscript is above array bounds [-Warray-bounds]:  => 161:19
  + fs/pstore/ram.c: warning: format '%lu' expects argument of type 'long unsigned int', but argument 2 has type 'size_t' [-Wformat]:  => 409:3
  + kernel/rcutree.c: warning: unused variable 'idle' [-Wunused-variable]:  => 359:23, 468:23
  + lib/atomic64_test.c: warning: #warning Please implement atomic64_dec_if_positive for your architecture and select the above Kconfig symbol [-Wcpp]:  => 131:2
  + lib/vsprintf.c: warning: 'resource_string.isra.9' uses dynamic stack allocation [enabled by default]:  => 655:1
  + modpost: WARNING: modpost: Found 11 section mismatch(es).:  => N/A
  + modpost: WARNING: modpost: Found 4 section mismatch(es).:  => N/A
  + net/netfilter/nf_conntrack_sip.c: warning: 'ret' may be used uninitialized in this function [-Wuninitialized]:  => 709:5
  + net/unix/af_unix.c: warning: 'path.dentry' may be used uninitialized in this function:  => 898
  + net/unix/af_unix.c: warning: 'path.mnt' may be used uninitialized in this function:  => 898
  + sound/pci/cs4281.c: warning: 'cs4281_resume' defined but not used [-Wunused-function]:  => 2048:12
  + sound/pci/cs4281.c: warning: 'cs4281_suspend' defined but not used [-Wunused-function]:  => 2000:12
  + sound/pci/cs46xx/cs46xx_lib.c: warning: 'snd_cs46xx_resume' defined but not used [-Wunused-function]:  => 3636:12
  + sound/pci/cs46xx/cs46xx_lib.c: warning: 'snd_cs46xx_suspend' defined but not used [-Wunused-function]:  => 3602:12
  + sound/pci/emu10k1/emu10k1.c: warning: 'snd_emu10k1_resume' defined but not used [-Wunused-function]:  => 239:12
  + sound/pci/emu10k1/emu10k1.c: warning: 'snd_emu10k1_suspend' defined but not used [-Wunused-function]:  => 210:12
  + sound/pci/fm801.c: warning: 'snd_fm801_resume' defined but not used [-Wunused-function]:  => 1393:12
  + sound/pci/fm801.c: warning: 'snd_fm801_suspend' defined but not used [-Wunused-function]:  => 1372:12
  + sound/soc/dwc/designware_i2s.c: warning: "CCR" redefined [enabled by default]:  => 31:0
  + warning:   CC [M]  net/unix/diag.o:  => N/A
  + warning:   LD      net/netlink/built-in.o:  => N/A
  + warning: (DRM) selects DMA_SHARED_BUFFER which has unmet direct dependencies (EXPERIMENTAL):  => N/A
  + warning: (HAVE_TEXT_POKE_SMP) selects STOP_MACHINE which has unmet direct dependencies (SMP && MODULE_UNLOAD || HOTPLUG_CPU):  => N/A
  + warning: (IA32_EMULATION) selects COMPAT_BINFMT_ELF which has unmet direct dependencies (COMPAT && BINFMT_ELF):  => N/A
  + warning: (INFINIBAND_OCRDMA) selects BE2NET which has unmet direct dependencies (NETDEVICES && ETHERNET && NET_VENDOR_EMULEX && PCI && INET):  => N/A
  + warning: (INFINIBAND_OCRDMA) selects NET_VENDOR_EMULEX which has unmet direct dependencies (NETDEVICES && ETHERNET && PCI && INET):  => N/A
  + warning: (PPC_PS3) selects USB_OHCI_LITTLE_ENDIAN which has unmet direct dependencies (USB_SUPPORT && USB_OHCI_HCD):  => N/A
  + warning: arch/powerpc/platforms/built-in.o(.text+0x17ed8): Section mismatch in reference from the function .pci_dn_reconfig_notifier() to the function .devinit.text:.eeh_dev_init():  => N/A
  + warning: arch/powerpc/platforms/built-in.o(.text+0x17ef8): Section mismatch in reference from the function .pci_dn_reconfig_notifier() to the function .devinit.text:.eeh_dev_init():  => N/A
  + warning: arch/powerpc/platforms/pseries/built-in.o(.text+0x435c): Section mismatch in reference from the function .pci_dn_reconfig_notifier() to the function .devinit.text:.eeh_dev_init():  => N/A
  + warning: arch/powerpc/sysdev/built-in.o(.text+0xe134): Section mismatch in reference from the function .ics_rtas_init() to the function .init.text:.xics_register_ics():  => N/A
  + warning: arch/powerpc/sysdev/built-in.o(.text+0xf6dc): Section mismatch in reference from the function .ics_rtas_init() to the function .init.text:.xics_register_ics():  => N/A
  + warning: arch/powerpc/sysdev/xics/built-in.o(.text+0x2614): Section mismatch in reference from the function .ics_rtas_init() to the function .init.text:.xics_register_ics():  => N/A
  + warning: block/built-in.o (.xt.lit): unexpected non-allocatable section.:  => N/A
  + warning: block/built-in.o (.xt.prop): unexpected non-allocatable section.:  => N/A
  + warning: drivers/built-in.o(.data+0x2449b0): Section mismatch in reference from the variable tpci200_pci_drv to the variable .devinit.rodata:tpci200_idtable:  => N/A
  + warning: drivers/extcon/built-in.o (.xt.lit): unexpected non-allocatable section.:  => N/A
  + warning: drivers/extcon/built-in.o (.xt.prop): unexpected non-allocatable section.:  => N/A
  + warning: drivers/media/radio/shark2.o (.xt.lit): unexpected non-allocatable section.:  => N/A
  + warning: drivers/media/radio/shark2.o (.xt.prop): unexpected non-allocatable section.:  => N/A
  + warning: drivers/net/cris/built-in.o(.text+0x135e): Section mismatch in reference from the function etrax_init_module() to the function .init.text:etrax_ethernet_init():  => N/A
  + warning: drivers/net/usb/asix.o (.xt.lit): unexpected non-allocatable section.:  => N/A
  + warning: drivers/net/usb/asix.o (.xt.prop): unexpected non-allocatable section.:  => N/A
  + warning: drivers/net/wireless/ath/ath.o (.xt.lit): unexpected non-allocatable section.:  => N/A
  + warning: drivers/net/wireless/iwlwifi/dvm/iwldvm.o (.xt.lit): unexpected non-allocatable section.:  => N/A
  + warning: drivers/net/wireless/iwlwifi/dvm/iwldvm.o (.xt.prop): unexpected non-allocatable section.:  => N/A
  + warning: drivers/net/wireless/ti/wl18xx/wl18xx.o (.xt.lit): unexpected non-allocatable section.:  => N/A
  + warning: drivers/net/wireless/ti/wl18xx/wl18xx.o (.xt.prop): unexpected non-allocatable section.:  => N/A
  + warning: drivers/pwm/built-in.o (.xt.lit): unexpected non-allocatable section.:  => N/A
  + warning: drivers/pwm/built-in.o (.xt.prop): unexpected non-allocatable section.:  => N/A
  + warning: drivers/scsi/aic94xx/aic94xx.o (.xt.lit): unexpected non-allocatable section.:  => N/A
  + warning: drivers/staging/built-in.o(.data+0x9a08): Section mismatch in reference from the variable tpci200_pci_drv to the variable .devinit.rodata:tpci200_idtable:  => N/A
  + warning: drivers/staging/csr/csr_helper.o (.xt.lit): unexpected non-allocatable section.:  => N/A
  + warning: drivers/staging/csr/csr_helper.o (.xt.prop): unexpected non-allocatable section.:  => N/A
  + warning: drivers/staging/csr/csr_wifi.o (.xt.lit): unexpected non-allocatable section.:  => N/A
  + warning: drivers/staging/csr/csr_wifi.o (.xt.prop): unexpected non-allocatable section.:  => N/A
  + warning: drivers/staging/ipack/bridges/built-in.o(.data+0x18): Section mismatch in reference from the variable tpci200_pci_drv to the variable .devinit.rodata:tpci200_idtable:  => N/A
  + warning: drivers/staging/ipack/bridges/tpci200.o(.data+0x18): Section mismatch in reference from the variable tpci200_pci_drv to the variable .devinit.rodata:tpci200_idtable:  => N/A
  + warning: drivers/staging/ipack/bridges/tpci200.o(.data+0x80): Section mismatch in reference from the variable tpci200_pci_drv to the variable .devinit.rodata:tpci200_idtable:  => N/A
  + warning: drivers/staging/ipack/built-in.o(.data+0x128): Section mismatch in reference from the variable tpci200_pci_drv to the variable .devinit.rodata:tpci200_idtable:  => N/A
  + warning: drivers/staging/zram/zram.o (.xt.lit): unexpected non-allocatable section.:  => N/A
  + warning: drivers/staging/zram/zram.o (.xt.prop): unexpected non-allocatable section.:  => N/A
  + warning: drivers/staging/zsmalloc/zsmalloc.o (.xt.lit): unexpected non-allocatable section.:  => N/A
  + warning: drivers/staging/zsmalloc/zsmalloc.o (.xt.prop): unexpected non-allocatable section.:  => N/A
  + warning: fs/built-in.o (.xt.lit): unexpected non-allocatable section.:  => N/A
  + warning: fs/built-in.o (.xt.prop): unexpected non-allocatable section.:  => N/A
  + warning: fs/nfs/nfsv2.o (.xt.lit): unexpected non-allocatable section.:  => N/A
  + warning: fs/nfs/nfsv2.o (.xt.prop): unexpected non-allocatable section.:  => N/A
  + warning: fs/nfs/nfsv3.o (.xt.lit): unexpected non-allocatable section.:  => N/A
  + warning: fs/nfs/nfsv3.o (.xt.prop): unexpected non-allocatable section.:  => N/A
  + warning: fs/nfs/nfsv4.o (.xt.lit): unexpected non-allocatable section.:  => N/A
  + warning: fs/nfs/nfsv4.o (.xt.prop): unexpected non-allocatable section.:  => N/A
  + warning: fs/xfs/xfs.o (.xt.lit): unexpected non-allocatable section.:  => N/A
  + warning: fs/xfs/xfs.o (.xt.prop): unexpected non-allocatable section.:  => N/A
  + warning: lib/built-in.o (.xt.lit): unexpected non-allocatable section.:  => N/A
  + warning: lib/built-in.o (.xt.prop): unexpected non-allocatable section.:  => N/A
  + warning: mm/built-in.o(.meminit.text+0x1078): Section mismatch in reference from the function .free_area_init_core.isra.33() to the function .init.text:.set_pageblock_order():  => N/A
  + warning: net/ipv4/built-in.o (.xt.lit): unexpected non-allocatable section.:  => N/A
  + warning: net/ipv4/built-in.o (.xt.prop): unexpected non-allocatable section.:  => N/A
  + warning: net/ipv4/netfilter/iptable_nat.o (.xt.lit): unexpected non-allocatable section.:  => N/A
  + warning: net/ipv4/netfilter/iptable_nat.o (.xt.prop): unexpected non-allocatable section.:  => N/A
  + warning: net/ipv4/netfilter/nf_conntrack_ipv4.o (.xt.lit): unexpected non-allocatable section.:  => N/A
  + warning: net/ipv4/netfilter/nf_conntrack_ipv4.o (.xt.prop): unexpected non-allocatable section.:  => N/A
  + warning: net/ipv4/netfilter/nf_nat.o (.xt.lit): unexpected non-allocatable section.:  => N/A
  + warning: net/ipv4/netfilter/nf_nat.o (.xt.prop): unexpected non-allocatable section.:  => N/A
  + warning: net/mac80211/mac80211.o (.xt.lit): unexpected non-allocatable section.:  => N/A
  + warning: net/mac80211/mac80211.o (.xt.prop): unexpected non-allocatable section.:  => N/A
  + warning: net/netfilter/nf_conntrack.o (.xt.lit): unexpected non-allocatable section.:  => N/A
  + warning: net/netfilter/nf_conntrack.o (.xt.prop): unexpected non-allocatable section.:  => N/A
  + warning: net/netfilter/nf_conntrack_h323.o (.xt.lit): unexpected non-allocatable section.:  => N/A
  + warning: net/netfilter/nf_conntrack_h323.o (.xt.prop): unexpected non-allocatable section.:  => N/A
  + warning: net/netfilter/nfnetlink_queue.o (.xt.lit): unexpected non-allocatable section.:  => N/A
  + warning: net/netfilter/nfnetlink_queue.o (.xt.prop): unexpected non-allocatable section.:  => N/A
  + warning: sound/drivers/snd-aloop.o (.xt.lit): unexpected non-allocatable section.:  => N/A
  + warning: vmlinux.o(.data+0x2b83a0): Section mismatch in reference from the variable tpci200_pci_drv to the variable .devinit.rodata:tpci200_idtable:  => N/A
  + warning: vmlinux.o(.meminit.text+0x1488): Section mismatch in reference from the function .free_area_init_core.isra.33() to the function .init.text:.set_pageblock_order():  => N/A
  + warning: vmlinux.o(.text+0x2bdc0): Section mismatch in reference from the function .early_setup_secondary() to the function .cpuinit.text:.early_init_mmu_secondary():  => N/A
  + warning: vmlinux.o(.text+0x4dff0): Section mismatch in reference from the function .wake_offline_cpus() to the function .cpuinit.text:.cpu_up():  => N/A
  + warning: vmlinux.o(.text+0x4f40c): Section mismatch in reference from the function .wake_offline_cpus() to the function .cpuinit.text:.cpu_up():  => N/A
  + warning: vmlinux.o(.text+0x72ecc): Section mismatch in reference from the function .ics_rtas_init() to the function .init.text:.xics_register_ics():  => N/A
  + warning: vmlinux.o(.text+0x75874): Section mismatch in reference from the function .ics_rtas_init() to the function .init.text:.xics_register_ics():  => N/A
  + warning: vmlinux.o(.text+0x86d5c): Section mismatch in reference from the function .pnv_pci_ioda_msi_setup() to the function .devinit.text:.__pnv_ioda_get_one_pe():  => N/A
  + warning: vmlinux.o(.text+0x86d78): Section mismatch in reference from the function .pnv_pci_ioda_msi_setup() to the function .devinit.text:.__pnv_ioda_get_one_pe():  => N/A
  + warning: vmlinux.o(.text+0x8973c): Section mismatch in reference from the function .pnv_pci_ioda_msi_setup() to the function .devinit.text:.__pnv_ioda_get_one_pe():  => N/A
  + warning: vmlinux.o(.text+0x89758): Section mismatch in reference from the function .pnv_pci_ioda_msi_setup() to the function .devinit.text:.__pnv_ioda_get_one_pe():  => N/A
  + warning: vmlinux.o(.text+0x8b45c): Section mismatch in reference from the function .pci_dn_reconfig_notifier() to the function .devinit.text:.update_dn_pci_info():  => N/A
  + warning: vmlinux.o(.text+0x8b478): Section mismatch in reference from the function .pci_dn_reconfig_notifier() to the function .devinit.text:.eeh_dev_init():  => N/A
  + warning: vmlinux.o(.text+0x8de3c): Section mismatch in reference from the function .pci_dn_reconfig_notifier() to the function .devinit.text:.update_dn_pci_info():  => N/A
  + warning: vmlinux.o(.text+0x8de58): Section mismatch in reference from the function .pci_dn_reconfig_notifier() to the function .devinit.text:.eeh_dev_init():  => N/A
  + warning: vmlinux.o(.text+0x90910): Section mismatch in reference from the function .dlpar_online_cpu() to the function .cpuinit.text:.cpu_up():  => N/A
  + warning: vmlinux.o(.text+0x932f0): Section mismatch in reference from the function .dlpar_online_cpu() to the function .cpuinit.text:.cpu_up():  => N/A
  + warning: vmlinux.o(.text+0x98494): Section mismatch in reference from the function .pcibios_add_pci_devices() to the function .devinit.text:.of_rescan_bus():  => N/A
  + warning: vmlinux.o(.text+0x98520): Section mismatch in reference from the function .pcibios_add_pci_devices() to the function .devinit.text:.pcibios_setup_bus_devices():  => N/A
  + warning: vmlinux.o(.text+0x98584): Section mismatch in reference from the function .pcibios_add_pci_devices() to the function .devinit.text:.pci_scan_bridge():  => N/A
  + warning: vmlinux.o(.text+0x9b400): Section mismatch in reference from the function .pcibios_add_pci_devices() to the function .devinit.text:.of_rescan_bus():  => N/A
  + warning: vmlinux.o(.text+0x9b48c): Section mismatch in reference from the function .pcibios_add_pci_devices() to the function .devinit.text:.pcibios_setup_bus_devices():  => N/A
  + warning: vmlinux.o(.text+0x9b4f0): Section mismatch in reference from the function .pcibios_add_pci_devices() to the function .devinit.text:.pci_scan_bridge():  => N/A

246 improvements:
  - .config: warning: override: SLOB changes choice state: 159, 146, 175 => 180, 175
  - arch/blackfin/include/asm/bfin_twi.h: warning: "ANOMALY_05001001" is not defined [-Wundef]: 87:6 => 
  - arch/m68k/include/asm/bitops.h: warning: 'rdev' may be used uninitialized in this function [-Wuninitialized]: 158:15 => 
  - arch/s390/include/asm/bitops.h: warning: 'rdev' may be used uninitialized in this function [-Wuninitialized]: 389:6 => 
  - arch/um/defconfig: warning: symbol value 'm' invalid for BLK_CGROUP: 166 => 
  - drivers/acpi/sleep.c: warning: 'pwr_btn_event_pending' defined but not used [-Wunused-variable]: 60:13 => 
  - drivers/base/power/sysfs.c: warning: 'dev_attr_async' defined but not used [-Wunused-variable]: 502:1 => 
  - drivers/base/regmap/regmap.c: warning: 'ret' may be used uninitialized in this function [-Wuninitialized]: 1062:9, 882:6 => 1172:6
  - drivers/dma/ioat/dma_v2.c: warning: unused variable 'chanerr' [-Wunused-variable]: 558:7 => 
  - drivers/gpio/gpio-wm831x.c: warning: 'powerdomain' may be used uninitialized in this function [-Wuninitialized]: 217:13 => 
  - drivers/gpu/drm/drm_bufs.c: warning: 'master' may be used uninitialized in this function [-Wuninitialized]: 467:13 => 
  - drivers/gpu/drm/gma500/psb_irq.c: warning: control reaches end of non-void function [-Wreturn-type]: 47:1, 83:1, 59:1 => 
  - drivers/gpu/drm/radeon/ni.c: warning: 'chip_name' may be used uninitialized in this function [-Wuninitialized]: 386:11 => 
  - drivers/gpu/drm/radeon/ni.c: warning: 'mc_req_size' may be used uninitialized in this function [-Wuninitialized]: 390:27 => 
  - drivers/gpu/drm/radeon/ni.c: warning: 'me_req_size' may be used uninitialized in this function [-Wuninitialized]: 366:26 => 
  - drivers/gpu/drm/radeon/ni.c: warning: 'pfp_req_size' may be used uninitialized in this function [-Wuninitialized]: 354:26 => 
  - drivers/gpu/drm/radeon/ni.c: warning: 'rlc_chip_name' may be used uninitialized in this function [-Wuninitialized]: 373:10 => 
  - drivers/gpu/drm/radeon/ni.c: warning: 'rlc_req_size' may be used uninitialized in this function [-Wuninitialized]: 377:26 => 
  - drivers/gpu/drm/radeon/r600.c: warning: 'chip_name' may be used uninitialized in this function [-Wuninitialized]: 1986:10 => 
  - drivers/gpu/drm/radeon/r600.c: warning: 'rlc_chip_name' may be used uninitialized in this function [-Wuninitialized]: 2009:10 => 
  - drivers/gpu/drm/radeon/r600_cp.c: warning: 'chip_name' may be used uninitialized in this function [-Wuninitialized]: 352:10 => 
  - drivers/gpu/drm/radeon/si.c: warning: 'chip_name' may be used uninitialized in this function [-Wuninitialized]: 375:10 => 
  - drivers/gpu/drm/radeon/si.c: warning: 'rlc_chip_name' may be used uninitialized in this function [-Wuninitialized]: 364:10 => 
  - drivers/hid/hid-picolcd.c: warning: 'err' may be used uninitialized in this function [-Wuninitialized]: 1758:10 => 
  - drivers/hid/hid-wiimote-debug.c: warning: 'size' may be used uninitialized in this function [-Wuninitialized]: 69:98, 69:28, 69:18, 73:6, 69:105 => 69:98, 69:28, 69:18, 69:105
  - drivers/hwmon/w83781d.c: warning: 'sc_addr[1]' may be used uninitialized in this function [-Wuninitialized]: 910:32 => 
  - drivers/i2c/busses/i2c-diolan-u2c.c: warning: 'byte' may be used uninitialized in this function [-Wuninitialized]: 394:18 => 
  - drivers/i2c/busses/i2c-pxa.c: warning: 'i2c_type' may be used uninitialized in this function [-Wuninitialized]: 1155:33 => 
  - drivers/i2c/busses/i2c-pxa.c: warning: unused variable 'i2c' [-Wunused-variable]: 1249:18 => 
  - drivers/isdn/gigaset/capi.c: warning: 'format_ie' defined but not used [-Wunused-function]: 291:20 => 
  - drivers/md/raid10.c: warning: 'rdev' may be used uninitialized in this function [-Wuninitialized]: 830:20 => 
  - drivers/media/video/m5mols/m5mols.h: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]: 331:9 => 
  - drivers/media/video/m5mols/m5mols.h: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]: 326:15 => 
  - drivers/media/video/m5mols/m5mols_controls.c: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]: 466:130 => 
  - drivers/media/video/pwc/pwc-if.c: warning: label 'err_video_unreg' defined but not used [-Wunused-label]: 1238:1 => 
  - drivers/mfd/adp5520.c: warning: 'adp5520_resume' defined but not used [-Wunused-function]: 333:12 => 
  - drivers/mfd/adp5520.c: warning: 'adp5520_suspend' defined but not used [-Wunused-function]: 324:12 => 
  - drivers/mfd/da9052-core.c: warning: unused variable 'desc' [-Wunused-variable]: 775:19 => 
  - drivers/mfd/s5m-core.c: warning: 'ret' may be used uninitialized in this function [-Wuninitialized]: 153:5 => 
  - drivers/mfd/tc3589x.c: warning: 'tc3589x_resume' defined but not used [-Wunused-function]: 375:12 => 
  - drivers/mfd/tc3589x.c: warning: 'tc3589x_suspend' defined but not used [-Wunused-function]: 361:12 => 
  - drivers/mfd/tps65910.c: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]: 157:14, 157:13 => 175:14
  - drivers/misc/bmp085.c: warning: 'pressure' may be used uninitialized in this function [-Wuninitialized]: 344:3 => 
  - drivers/mmc/host/sh_mobile_sdhi.c: warning: 'sh_mobile_sdhi_remove' defined but not used [-Wunused-function]: 258:12 => 
  - drivers/mtd/chips/cfi_util.c: warning: the frame size of 1476 bytes is larger than 1024 bytes [-Wframe-larger-than=]: 89:1 => 
  - drivers/mtd/chips/jedec_probe.c: warning: the frame size of 1076 bytes is larger than 1024 bytes [-Wframe-larger-than=]: 2242:1 => 
  - drivers/mtd/devices/docg3.c: warning: unused variable 'base' [-Wunused-variable]: 2128:16, 2128:8 => 2128:16
  - drivers/mtd/devices/phram.c: warning: 'name' may be used uninitialized in this function [-Wuninitialized]: 114:16 => 
  - drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c: warning: comparison of distinct pointer types lacks a cast [enabled by default]: 1661:7, 1661:417 => 
  - drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c: warning: comparison of distinct pointer types lacks a cast [enabled by default]: 2883:437, 2883:413 => 
  - drivers/net/ethernet/broadcom/cnic.c: warning: the frame size of 1304 bytes is larger than 1024 bytes [-Wframe-larger-than=]: 4739:1 => 
  - drivers/net/ethernet/chelsio/cxgb3/ael1002.c: warning: 'stat1' may be used uninitialized in this function [-Wuninitialized]: 850:30, 192:21 => 
  - drivers/net/ethernet/chelsio/cxgb3/ael1002.c: warning: 'stat2' may be used uninitialized in this function [-Wuninitialized]: 850:46, 192:38 => 
  - drivers/net/ethernet/chelsio/cxgb3/vsc8211.c: warning: 'adv' may be used uninitialized in this function [-Wuninitialized]: 186:28, 246:34 => 
  - drivers/net/ethernet/chelsio/cxgb3/vsc8211.c: warning: 'status' may be used uninitialized in this function [-Wuninitialized]: 223:39, 147:39 => 
  - drivers/net/ethernet/mellanox/mlx4/mcg.c: warning: 'hash' may be used uninitialized in this function [-Wuninitialized]: 589:9 => 
  - drivers/net/ethernet/neterion/vxge/vxge-config.c: warning: 'val32' may be used uninitialized in this function [-Wuninitialized]: 4594:18 => 
  - drivers/net/ethernet/sfc/filter.c: warning: 'data3' may be used uninitialized in this function [-Wuninitialized]: 516:2 => 
  - drivers/net/wimax/i2400m/control.c: warning: format '%zu' expects argument of type 'size_t', but argument 4 has type 'ssize_t' [-Wformat]: 134:10, 239:6 => 239:6
  - drivers/net/wimax/i2400m/control.c: warning: format '%zu' expects argument of type 'size_t', but argument 5 has type 'ssize_t' [-Wformat]: 239:6 => 
  - drivers/net/wimax/i2400m/usb-fw.c: warning: format '%zu' expects argument of type 'size_t', but argument 4 has type 'ssize_t' [-Wformat]: 215:4 => 
  - drivers/net/wireless/iwlwifi/iwl-devtrace.h: warning: 'struct device' declared inside parameter list [enabled by default]: 50:16, 67:16, 309:16, 263:16, 154:16, 101:16, 84:16, 114:16, 238:16, 134:16, 369:16, 278:16 => 
  - drivers/net/wireless/iwlwifi/iwl-devtrace.h: warning: its scope is only this definition or declaration, which is probably not what you want [enabled by default]: 50:16 => 
  - drivers/net/wireless/iwlwifi/iwl-io.h: warning: passing argument 1 of 'trace_iwlwifi_dev_ioread32' from incompatible pointer type [enabled by default]: 50:2 => 
  - drivers/net/wireless/iwlwifi/iwl-io.h: warning: passing argument 1 of 'trace_iwlwifi_dev_iowrite32' from incompatible pointer type [enabled by default]: 43:2 => 
  - drivers/net/wireless/iwlwifi/iwl-io.h: warning: passing argument 1 of 'trace_iwlwifi_dev_iowrite8' from incompatible pointer type [enabled by default]: 37:2 => 
  - drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c: warning: passing argument 1 of 'trace_iwlwifi_dev_ict_read' from incompatible pointer type [enabled by default]: 1020:9, 1000:2 => 
  - drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c: warning: passing argument 1 of 'trace_iwlwifi_dev_irq' from incompatible pointer type [enabled by default]: 983:2, 893:2 => 
  - drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c: warning: passing argument 1 of 'trace_iwlwifi_dev_rx' from incompatible pointer type [enabled by default]: 403:3 => 
  - drivers/pci/pci-driver.c: warning: 'pci_pm_default_resume_early' defined but not used [-Wunused-function]: 462:13 => 
  - drivers/power/ds2782_battery.c: warning: 'raw' may be used uninitialized in this function [-Wuninitialized]: 164:12, 205:17 => 
  - drivers/power/ds2782_battery.c: warning: 'sense_res_raw' may be used uninitialized in this function [-Wuninitialized]: 125:26 => 
  - drivers/rtc/rtc-cmos.c: warning: 'cmos_resume' defined but not used [-Wunused-function]: 842:12 => 
  - drivers/scsi/aha152x.c: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]: 2987:59, 2987:2 => 
  - drivers/scsi/mvsas/mv_sas.c: warning: unused variable 'dev' [-Wunused-variable]: 888:24 => 
  - drivers/staging/ccg/../../usb/gadget/f_fs.c: warning: "pr_vdebug" redefined [enabled by default]: 40:0 => 
  - drivers/staging/comedi/drivers/pcmmio.c: warning: 'irq[1]' may be used uninitialized in this function [-Wuninitialized]: 1214:445 => 
  - drivers/staging/comedi/drivers/pcmmio.c: warning: array subscript is above array bounds [-Warray-bounds]: 1151:54 => 
  - drivers/staging/iio/gyro/adis16080_core.c: warning: 'ut' may be used uninitialized in this function [-Wuninitialized]: 99:8 => 
  - drivers/staging/ramster/cluster/tcp.c: warning: format '%zd' expects argument of type 'signed size_t', but argument 12 has type 'ssize_t' [-Wformat]: 1003:3 => 
  - drivers/staging/ramster/zcache-main.c: warning: 'page' may be used uninitialized in this function [-Wuninitialized]: 1556:14, 1554:13 => 
  - drivers/staging/ramster/zcache-main.c: warning: 'ramster_remotify_init' defined but not used [-Wunused-function]: 1002:13 => 
  - drivers/staging/ramster/zcache-main.c: warning: 'zcache_do_remotify_ops' defined but not used [-Wunused-function]: 913:13 => 
  - drivers/staging/rtl8187se/ieee80211/ieee80211.h: warning: '______f' is static but declared in inline function 'ieee80211_get_hdrlen' which is not static [enabled by default]: 1274:251, 1272:229 => 
  - drivers/staging/rtl8187se/ieee80211/ieee80211.h: warning: '______f' is static but declared in inline function 'ieee80211_is_empty_essid' which is not static [enabled by default]: 1227:234, 1233:217 => 
  - drivers/staging/rtl8187se/ieee80211/ieee80211.h: warning: '______f' is static but declared in inline function 'ieee80211_is_valid_mode' which is not static [enabled by default]: 1253:320, 1258:320, 1248:320 => 
  - drivers/staging/rtl8192u/ieee80211/ieee80211.h: warning: '______f' is static but declared in inline function 'ieee80211_get_hdrlen' which is not static [enabled by default]: 2302:229, 2304:251 => 
  - drivers/staging/rtl8192u/ieee80211/ieee80211.h: warning: '______f' is static but declared in inline function 'ieee80211_is_empty_essid' which is not static [enabled by default]: 2257:234, 2263:217 => 
  - drivers/staging/rtl8192u/ieee80211/ieee80211.h: warning: '______f' is static but declared in inline function 'ieee80211_is_valid_mode' which is not static [enabled by default]: 2283:320, 2288:320, 2278:320 => 
  - drivers/staging/rtl8712/ieee80211.h: warning: '______f' is static but declared in inline function 'ieee80211_get_hdrlen' which is not static [enabled by default]: 759:229, 757:191 => 
  - drivers/staging/rtl8712/ieee80211.h: warning: '______f' is static but declared in inline function 'ieee80211_is_empty_essid' which is not static [enabled by default]: 740:234, 745:217 => 
  - drivers/staging/sm7xx/smtcfb.c: warning: 'sm712vga_setup' defined but not used [-Wunused-function]: 786:19, 786:122 => 
  - drivers/staging/vt6656/main_usb.c: warning: the frame size of 1284 bytes is larger than 1024 bytes [-Wframe-larger-than=]: 2054:1 => 
  - drivers/staging/wlan-ng/prism2fw.c: warning: the frame size of 4224 bytes is larger than 1024 bytes [-Wframe-larger-than=]: 1115:1 => 
  - drivers/staging/wlan-ng/prism2fw.c: warning: the frame size of 4224 bytes is larger than 2048 bytes [-Wframe-larger-than=]: 1115:1 => 
  - drivers/staging/wlan-ng/prism2fw.c: warning: the frame size of 4228 bytes is larger than 1024 bytes [-Wframe-larger-than=]: 1115:1 => 
  - drivers/staging/wlan-ng/prism2fw.c: warning: the frame size of 4236 bytes is larger than 1024 bytes [-Wframe-larger-than=]: 1115:1 => 
  - drivers/staging/wlan-ng/prism2fw.c: warning: the frame size of 4240 bytes is larger than 1024 bytes [-Wframe-larger-than=]: 1115:1 => 
  - drivers/staging/wlan-ng/prism2fw.c: warning: the frame size of 4240 bytes is larger than 2048 bytes [-Wframe-larger-than=]: 1115:1 => 
  - drivers/staging/wlan-ng/prism2fw.c: warning: the frame size of 4256 bytes is larger than 2048 bytes [-Wframe-larger-than=]: 1115:1 => 
  - drivers/staging/wlan-ng/prism2fw.c: warning: the frame size of 4264 bytes is larger than 1024 bytes [-Wframe-larger-than=]: 1115:1 => 
  - drivers/staging/zcache/zcache-main.c: warning: 'ret' may be used uninitialized in this function [-Wuninitialized]: 115:2 => 
  - drivers/tty/n_gsm.c: warning: unused variable 'buf' [-Wunused-variable]: 2256:7 => 
  - drivers/uio/uio.c: warning: 'ret' may be used uninitialized in this function [-Wuninitialized]: 266:6 => 
  - drivers/usb/gadget/f_ncm.c: warning: 'tmp' may be used uninitialized in this function [-Wuninitialized]: 1053:53, 1053:37, 1000:28, 1053:14, 1053:30, 1032:13, 1073:6, 986:368, 1073:19, 986:5, 1032:4 => 1032:13, 1073:6, 986:5, 1000:28, 1073:19, 1032:4, 1053:14, 1053:30
  - drivers/usb/host/ehci-hcd.c: warning: 'ehci_port_power' defined but not used [-Wunused-function]: 506:13 => 
  - drivers/usb/host/xhci-mem.c: warning: 'type' may be used uninitialized in this function [-Wuninitialized]: 1436:19 => 
  - drivers/usb/renesas_usbhs/fifo.c: warning: passing argument 1 of 'virt_to_phys' makes pointer from integer without a cast [enabled by default]: 784:2 => 
  - drivers/video/aty/atyfb_base.c: warning: 'ram_dram' defined but not used [-Wunused-variable]: 534:13 => 
  - drivers/video/aty/atyfb_base.c: warning: 'ram_resv' defined but not used [-Wunused-variable]: 535:13 => 
  - drivers/video/aty/atyfb_base.c: warning: overflow in implicit constant conversion [-Woverflow]: 437:72 => 
  - drivers/video/sh_mobile_meram.c: warning: 'sh_mobile_meram_resume' defined but not used [-Wunused-function]: 566:12 => 
  - drivers/video/sh_mobile_meram.c: warning: 'sh_mobile_meram_suspend' defined but not used [-Wunused-function]: 542:12 => 
  - drivers/virtio/virtio_pci.c: warning: 'virtio_pci_freeze' defined but not used [-Wunused-function]: 723:12 => 
  - drivers/virtio/virtio_pci.c: warning: 'virtio_pci_restore' defined but not used [-Wunused-function]: 743:12 => 
  - drivers/virtio/virtio_ring.c: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]: 382:9, 382:10 => 382:9
  - fs/ext4/bitmap.c: warning: 'ext4_block_bitmap_csum_set' uses dynamic stack allocation [enabled by default]: 114:1 => 
  - fs/ext4/bitmap.c: warning: 'ext4_block_bitmap_csum_verify' uses dynamic stack allocation [enabled by default]: 97:1 => 
  - fs/ext4/bitmap.c: warning: 'ext4_inode_bitmap_csum_set' uses dynamic stack allocation [enabled by default]: 70:1 => 
  - fs/ext4/bitmap.c: warning: 'ext4_inode_bitmap_csum_verify' uses dynamic stack allocation [enabled by default]: 53:1 => 
  - fs/ext4/extents.c: warning: 'ext4_extent_block_csum' uses dynamic stack allocation [enabled by default]: 65:1 => 
  - fs/ext4/ialloc.c: warning: 'ext4_new_inode' uses dynamic stack allocation [enabled by default]: 957:1 => 
  - fs/ext4/inode.c: warning: 'ext4_iget' uses dynamic stack allocation [enabled by default]: 3913:1 => 
  - fs/ext4/inode.c: warning: 'ext4_inode_csum' uses dynamic stack allocation [enabled by default]: 75:1 => 
  - fs/ext4/mmp.c: warning: 'ext4_mmp_csum' uses dynamic stack allocation [enabled by default]: 19:1 => 
  - fs/ext4/namei.c: warning: 'ext4_dirent_csum' uses dynamic stack allocation [enabled by default]: 249:1 => 
  - fs/ext4/namei.c: warning: 'ext4_dx_csum' uses dynamic stack allocation [enabled by default]: 345:1 => 
  - fs/ext4/super.c: warning: 'ext4_fill_super' uses dynamic stack allocation [enabled by default]: 3910:1 => 
  - fs/ext4/super.c: warning: 'ext4_group_desc_csum' uses dynamic stack allocation [enabled by default]: 2012:1 => 
  - fs/ext4/super.c: warning: 'ext4_superblock_csum' uses dynamic stack allocation [enabled by default]: 135:1 => 
  - fs/ext4/xattr.c: warning: 'ext4_xattr_block_csum' uses dynamic stack allocation [enabled by default]: 145:1 => 
  - fs/jbd2/commit.c: warning: '__kunmap_atomic_deprecated' is deprecated (declared at /scratch/kisskb/src/include/linux/highmem.h:135) [-Wdeprecated-declarations]: 357:1, 357:176 => 
  - fs/jbd2/commit.c: warning: '__kunmap_atomic_deprecated' is deprecated (declared at /scratch/kisskb/src/include/linux/highmem.h:137): 357 => 
  - fs/jbd2/commit.c: warning: 'jbd2_block_tag_csum_set.isra.5' uses dynamic stack allocation [enabled by default]: 360:1 => 
  - fs/jbd2/commit.c: warning: 'kmap_atomic_deprecated' is deprecated (declared at /scratch/kisskb/src/include/linux/highmem.h:125) [-Wdeprecated-declarations]: 352:2 => 
  - fs/jbd2/commit.c: warning: 'kmap_atomic_deprecated' is deprecated (declared at /scratch/kisskb/src/include/linux/highmem.h:127): 352 => 
  - fs/lockd/svc.c: warning: label 'err_sysctl' defined but not used [-Wunused-label]: 630:1 => 
  - fs/ncpfs/dir.c: warning: unused variable 'sb' [-Wunused-variable]: 128:23 => 
  - fs/ubifs/dir.c: warning: 'saved_nlink' may be used uninitialized in this function [-Wuninitialized]: 1099:12 => 
  - fs/ubifs/dir.c: warning: 'saved_nlink' may be used uninitialized in this function: 972 => 
  - include/asm-generic/bitops/non-atomic.h: warning: 'rdev' may be used uninitialized in this function [-Wuninitialized]: 105:20 => 
  - include/linux/list.h: warning: 'head' may be used uninitialized in this function [-Wuninitialized]: 616:11 => 
  - include/linux/list.h: warning: 'prev_page' may be used uninitialized in this function [-Wuninitialized]: 62:12 => 
  - kernel/printk.c: warning: 'syslog_partial' defined but not used [-Wunused-variable]: 223:15 => 
  - kernel/printk.c: warning: 'syslog_partial' defined but not used: 223 => 
  - kernel/seccomp.c: warning: control reaches end of non-void function [-Wreturn-type]: 112:1 => 
  - lib/atomic64_test.c: warning: #warning Please implement atomic64_dec_if_positive for your architecture, and add it to the IF above [-Wcpp]: 132:2 => 
  - lib/debugobjects.c: warning: 'obj_states' defined but not used [-Wunused-variable]: 73:20 => 
  - lib/debugobjects.c: warning: unused variable 'hint' [-Wunused-variable]: 255:9 => 
  - lib/vsprintf.c: warning: 'resource_string.isra.8' uses dynamic stack allocation [enabled by default]: 655:1 => 
  - mm/memblock.c: warning: 'r' may be used uninitialized in this function [-Wuninitialized]: 731:15 => 
  - mm/memcontrol.c: warning: 'thresholds' may be used uninitialized in this function [-Wuninitialized]: 4435:32, 4314:16, 4317:19, 4417:35 => 4385:19, 4503:32, 4485:35
  - mm/oom_kill.c: warning: 'points' may be used uninitialized in this function: 693 => 
  - mm/swapfile.c: warning: 'span' may be used uninitialized in this function: 2007 => 
  - modpost: WARNING: modpost: Found 14 section mismatch(es).: N/A => 
  - modpost: WARNING: modpost: Found 5 section mismatch(es).: N/A => 
  - net/ipv4/inet_connection_sock.c: warning: 'head' may be used uninitialized in this function [-Wuninitialized]: 207:17 => 
  - net/ipv4/ip_options.c: warning: 'nexthop' may be used uninitialized in this function [-Wuninitialized]: 648:16 => 
  - sound/soc/codecs/lm49453.c: warning: passing argument 3 of 'snd_soc_register_codec' discards 'const' qualifier from pointer target type [enabled by default]: 1511:89, 1511:24 => 
  - warning:   CC [M]  sound/drivers/opl3/opl3_midi.o: N/A => 
  - warning:   LD [M]  drivers/media/dvb/dvb-usb/dvb-usb.o: N/A => 
  - warning: (BRIDGE_NF_EBTABLES) selects NETFILTER_XTABLES which has unmet direct dependencies (NET && INET && NETFILTER): N/A => 
  - warning: (MOUSE_APPLETOUCH && MOUSE_BCM5974 && MOUSE_SYNAPTICS_USB && JOYSTICK_XPAD && TABLET_USB_ACECAD && TABLET_USB_AIPTEK && TABLET_USB_HANWANG && TABLET_USB_KBTAB && TABLET_USB_WACOM && TOUCHSCREEN_USB_COMPOSITE && INPUT_ATI_REMOTE2 && INPUT_KEYSPAN_REMOTE && INPUT_POWERMATE && INPUT_YEALINK && INPUT_CM109 && RC_ATI_REMOTE && IR_IMON && IR_MCEUSB && IR_REDRAT3 && IR_STREAMZAP && DRM_USB) selects USB which has unmet direct dependencies (USB_SUPPORT && USB_ARCH_HAS_HCD): N/A => 
  - warning: arch/powerpc/platforms/built-in.o(.text+0x17f3c): Section mismatch in reference from the function .pci_dn_reconfig_notifier() to the function .devinit.text:.eeh_dev_init(): N/A => 
  - warning: arch/powerpc/platforms/built-in.o(.text+0x17f5c): Section mismatch in reference from the function .pci_dn_reconfig_notifier() to the function .devinit.text:.eeh_dev_init(): N/A => 
  - warning: arch/powerpc/platforms/built-in.o(.text+0xcd84): Section mismatch in reference from the function .pci_dn_reconfig_notifier() to the function .devinit.text:.eeh_dev_init(): N/A => 
  - warning: arch/powerpc/platforms/pseries/built-in.o(.text+0x2bc4): Section mismatch in reference from the function .pci_dn_reconfig_notifier() to the function .devinit.text:.eeh_dev_init(): N/A => 
  - warning: arch/powerpc/platforms/pseries/built-in.o(.text+0x43c0): Section mismatch in reference from the function .pci_dn_reconfig_notifier() to the function .devinit.text:.eeh_dev_init(): N/A => 
  - warning: arch/powerpc/sysdev/built-in.o(.text+0x9320): Section mismatch in reference from the function .ics_rtas_init() to the function .init.text:.xics_register_ics(): N/A => 
  - warning: arch/powerpc/sysdev/built-in.o(.text+0xe154): Section mismatch in reference from the function .ics_rtas_init() to the function .init.text:.xics_register_ics(): N/A => 
  - warning: arch/powerpc/sysdev/built-in.o(.text+0xf6fc): Section mismatch in reference from the function .ics_rtas_init() to the function .init.text:.xics_register_ics(): N/A => 
  - warning: arch/powerpc/sysdev/xics/built-in.o(.text+0x1870): Section mismatch in reference from the function .ics_rtas_init() to the function .init.text:.xics_register_ics(): N/A => 
  - warning: arch/powerpc/sysdev/xics/built-in.o(.text+0x2634): Section mismatch in reference from the function .ics_rtas_init() to the function .init.text:.xics_register_ics(): N/A => 
  - warning: drivers/built-in.o(.init.text+0x28a80): Section mismatch in reference from the function .libfcoe_init() to the function .exit.text:.fcoe_transport_exit(): N/A => 
  - warning: drivers/built-in.o(.init.text+0x82d8): Section mismatch in reference from the function libfcoe_init() to the function .exit.text:fcoe_transport_exit(): N/A => 
  - warning: drivers/misc/iwmc3200top/iwmc3200top.o (.xt.lit): unexpected non-allocatable section.: N/A => 
  - warning: drivers/misc/iwmc3200top/iwmc3200top.o (.xt.prop): unexpected non-allocatable section.: N/A => 
  - warning: drivers/net/ethernet/amd/depca.o(.devinit.text+0x38): Section mismatch in reference from the function depca_isa_probe() to the function .init.text:DevicePresent(): N/A => 
  - warning: drivers/net/ethernet/amd/depca.o(.devinit.text+0x9a): Section mismatch in reference from the function depca_isa_probe() to the function .init.text:DepcaSignature(): N/A => 
  - warning: drivers/net/ethernet/amd/depca.o(.devinit.text+0xe8): Section mismatch in reference from the function depca_isa_probe() to the function .init.text:depca_hw_init(): N/A => 
  - warning: drivers/net/wimax/i2400m/i2400m-sdio.o (.xt.lit): unexpected non-allocatable section.: N/A => 
  - warning: drivers/net/wimax/i2400m/i2400m-sdio.o (.xt.prop): unexpected non-allocatable section.: N/A => 
  - warning: drivers/net/wireless/iwmc3200wifi/iwmc3200wifi.o (.xt.lit): unexpected non-allocatable section.: N/A => 
  - warning: drivers/net/wireless/iwmc3200wifi/iwmc3200wifi.o (.xt.prop): unexpected non-allocatable section.: N/A => 
  - warning: drivers/regulator/built-in.o (.xt.lit): unexpected non-allocatable section.: N/A => 
  - warning: drivers/regulator/built-in.o (.xt.prop): unexpected non-allocatable section.: N/A => 
  - warning: drivers/scsi/built-in.o(.init.text+0x15b0): Section mismatch in reference from the function libfcoe_init() to the function .exit.text:exit_scsi(): N/A => 
  - warning: drivers/scsi/built-in.o(.init.text+0x1870): Section mismatch in reference from the function libfcoe_init() to the function .exit.text:fcoe_transport_exit(): N/A => 
  - warning: drivers/scsi/built-in.o(.init.text+0x18cc): Section mismatch in reference from the function .libfcoe_init() to the function .exit.text:.fcoe_transport_exit(): N/A => 
  - warning: drivers/scsi/fcoe/built-in.o(.init.text+0x598): Section mismatch in reference from the function .libfcoe_init() to the function .exit.text:.fcoe_transport_exit(): N/A => 
  - warning: drivers/scsi/fcoe/built-in.o(.init.text+0x7c): Section mismatch in reference from the function libfcoe_init() to the function .exit.text:fcoe_transport_exit(): N/A => 
  - warning: drivers/scsi/fcoe/built-in.o(.init.text+0x88): Section mismatch in reference from the function libfcoe_init() to the function .exit.text:fcoe_transport_exit(): N/A => 
  - warning: drivers/scsi/fcoe/libfcoe.o(.init.literal+0x8): Section mismatch in reference from the (unknown reference) (unknown) to the function .exit.text:fcoe_transport_exit(): N/A => 
  - warning: drivers/scsi/fcoe/libfcoe.o(.init.text+0x13): Section mismatch in reference from the function init_module() to the function .exit.text:fcoe_transport_exit(): N/A => 
  - warning: drivers/scsi/fcoe/libfcoe.o(.init.text+0x20): Section mismatch in reference from the function init_module() to the function .exit.text:fcoe_transport_exit(): N/A => 
  - warning: drivers/scsi/fcoe/libfcoe.o(.init.text+0x24): Section mismatch in reference from the function init_module() to the function .exit.text:fcoe_transport_exit(): N/A => 
  - warning: drivers/scsi/fcoe/libfcoe.o(.init.text+0x30): Section mismatch in reference from the function init_module() to the function .exit.text:fcoe_transport_exit(): N/A => 
  - warning: drivers/scsi/fcoe/libfcoe.o(.init.text+0x3a): Section mismatch in reference from the function init_module() to the function .exit.text:fcoe_transport_exit(): N/A => 
  - warning: drivers/scsi/fcoe/libfcoe.o(.init.text+0x44): Section mismatch in reference from the function init_module() to the function .exit.text:fcoe_transport_exit(): N/A => 
  - warning: drivers/scsi/fcoe/libfcoe.o(.init.text+0x64): Section mismatch in reference from the function .init_module() to the function .exit.text:.fcoe_transport_exit(): N/A => 
  - warning: drivers/scsi/fcoe/libfcoe.o(.init.text+0x64): Section mismatch in reference from the function .libfcoe_init() to the function .exit.text:.fcoe_transport_exit(): N/A => 
  - warning: drivers/scsi/fcoe/libfcoe.o(.init.text+0x7c): Section mismatch in reference from the function init_module() to the function .exit.text:fcoe_transport_exit(): N/A => 
  - warning: drivers/scsi/fcoe/libfcoe.o(.init.text+0x7c): Section mismatch in reference from the function libfcoe_init() to the function .exit.text:fcoe_transport_exit(): N/A => 
  - warning: drivers/scsi/fcoe/libfcoe.o(.init.text+0x88): Section mismatch in reference from the function init_module() to the function .exit.text:fcoe_transport_exit(): N/A => 
  - warning: drivers/scsi/fcoe/libfcoe.o(.init.text+0x88): Section mismatch in reference from the function libfcoe_init() to the function .exit.text:fcoe_transport_exit(): N/A => 
  - warning: drivers/spi/built-in.o(.devinit.text+0x1c20): Section mismatch in reference from the function rspi_probe() to the function .devexit.text:spidev_remove(): N/A => 
  - warning: drivers/staging/sm7xx/sm7xx.o (.xt.lit): unexpected non-allocatable section.: N/A => 
  - warning: drivers/staging/sm7xx/sm7xx.o (.xt.prop): unexpected non-allocatable section.: N/A => 
  - warning: fs/romfs/romfs.o (.xt.lit): unexpected non-allocatable section.: N/A => 
  - warning: lib/xz/xz_dec.o (.xt.lit): unexpected non-allocatable section.: N/A => 
  - warning: make[6]: drivers/scsi/aic94xx/aic94xx.o (.xt.lit): unexpected non-allocatable section.: N/A => 
  - warning: vmlinux.o(.init.text+0x697e0): Section mismatch in reference from the function libfcoe_init() to the function .exit.text:fcoe_transport_exit(): N/A => 
  - warning: vmlinux.o(.init.text+0xa3af4): Section mismatch in reference from the function .libfcoe_init() to the function .exit.text:.fcoe_transport_exit(): N/A => 
  - warning: vmlinux.o(.text+0x1dfe4): Section mismatch in reference from the function .early_setup_secondary() to the function .cpuinit.text:.early_init_mmu_secondary(): N/A => 
  - warning: vmlinux.o(.text+0x2c898): Section mismatch in reference from the function .early_setup_secondary() to the function .cpuinit.text:.early_init_mmu_secondary(): N/A => 
  - warning: vmlinux.o(.text+0x3139c): Section mismatch in reference from the function .kexec_prepare_cpus() to the function .cpuinit.text:.cpu_up(): N/A => 
  - warning: vmlinux.o(.text+0x47ae0): Section mismatch in reference from the function .ics_rtas_init() to the function .init.text:.xics_register_ics(): N/A => 
  - warning: vmlinux.o(.text+0x4e75c): Section mismatch in reference from the function .wake_offline_cpus() to the function .cpuinit.text:.cpu_up(): N/A => 
  - warning: vmlinux.o(.text+0x4fb78): Section mismatch in reference from the function .wake_offline_cpus() to the function .cpuinit.text:.cpu_up(): N/A => 
  - warning: vmlinux.o(.text+0x54890): Section mismatch in reference from the function .pci_dn_reconfig_notifier() to the function .devinit.text:.update_dn_pci_info(): N/A => 
  - warning: vmlinux.o(.text+0x548a4): Section mismatch in reference from the function .pci_dn_reconfig_notifier() to the function .devinit.text:.eeh_dev_init(): N/A => 
  - warning: vmlinux.o(.text+0x57484): Section mismatch in reference from the function .dlpar_online_cpu() to the function .cpuinit.text:.cpu_up(): N/A => 
  - warning: vmlinux.o(.text+0x5c508): Section mismatch in reference from the function .pcibios_add_pci_devices() to the function .devinit.text:.of_rescan_bus(): N/A => 
  - warning: vmlinux.o(.text+0x5c55c): Section mismatch in reference from the function .pcibios_add_pci_devices() to the function .devinit.text:.pcibios_setup_bus_devices(): N/A => 
  - warning: vmlinux.o(.text+0x5c5a0): Section mismatch in reference from the function .pcibios_add_pci_devices() to the function .devinit.text:.pci_scan_bridge(): N/A => 
  - warning: vmlinux.o(.text+0x7297c): Section mismatch in reference from the function .ics_rtas_init() to the function .init.text:.xics_register_ics(): N/A => 
  - warning: vmlinux.o(.text+0x75324): Section mismatch in reference from the function .ics_rtas_init() to the function .init.text:.xics_register_ics(): N/A => 
  - warning: vmlinux.o(.text+0x8681c): Section mismatch in reference from the function .pnv_pci_ioda_msi_setup() to the function .devinit.text:.__pnv_ioda_get_one_pe(): N/A => 
  - warning: vmlinux.o(.text+0x86838): Section mismatch in reference from the function .pnv_pci_ioda_msi_setup() to the function .devinit.text:.__pnv_ioda_get_one_pe(): N/A => 
  - warning: vmlinux.o(.text+0x891dc): Section mismatch in reference from the function .pnv_pci_ioda_msi_setup() to the function .devinit.text:.__pnv_ioda_get_one_pe(): N/A => 
  - warning: vmlinux.o(.text+0x891f8): Section mismatch in reference from the function .pnv_pci_ioda_msi_setup() to the function .devinit.text:.__pnv_ioda_get_one_pe(): N/A => 
  - warning: vmlinux.o(.text+0x8af80): Section mismatch in reference from the function .pci_dn_reconfig_notifier() to the function .devinit.text:.update_dn_pci_info(): N/A => 
  - warning: vmlinux.o(.text+0x8af9c): Section mismatch in reference from the function .pci_dn_reconfig_notifier() to the function .devinit.text:.eeh_dev_init(): N/A => 
  - warning: vmlinux.o(.text+0x8d940): Section mismatch in reference from the function .pci_dn_reconfig_notifier() to the function .devinit.text:.update_dn_pci_info(): N/A => 
  - warning: vmlinux.o(.text+0x8d95c): Section mismatch in reference from the function .pci_dn_reconfig_notifier() to the function .devinit.text:.eeh_dev_init(): N/A => 
  - warning: vmlinux.o(.text+0x900c8): Section mismatch in reference from the function .dlpar_online_cpu() to the function .cpuinit.text:.cpu_up(): N/A => 
  - warning: vmlinux.o(.text+0x9082): Section mismatch in reference from the variable generic_secondary_common_init to the variable .init.data:spinning_secondaries: N/A => 
  - warning: vmlinux.o(.text+0x92a88): Section mismatch in reference from the function .dlpar_online_cpu() to the function .cpuinit.text:.cpu_up(): N/A => 
  - warning: vmlinux.o(.text+0x92ec): Section mismatch in reference from the function .start_secondary_prolog() to the function .devinit.text:.start_secondary(): N/A => 
  - warning: vmlinux.o(.text+0x9300): Section mismatch in reference from the function .start_secondary_resume() to the function .devinit.text:.start_secondary(): N/A => 
  - warning: vmlinux.o(.text+0x97c90): Section mismatch in reference from the function .pcibios_add_pci_devices() to the function .devinit.text:.of_rescan_bus(): N/A => 
  - warning: vmlinux.o(.text+0x97d1c): Section mismatch in reference from the function .pcibios_add_pci_devices() to the function .devinit.text:.pcibios_setup_bus_devices(): N/A => 
  - warning: vmlinux.o(.text+0x97d80): Section mismatch in reference from the function .pcibios_add_pci_devices() to the function .devinit.text:.pci_scan_bridge(): N/A => 
  - warning: vmlinux.o(.text+0x9abdc): Section mismatch in reference from the function .pcibios_add_pci_devices() to the function .devinit.text:.of_rescan_bus(): N/A => 
  - warning: vmlinux.o(.text+0x9ac68): Section mismatch in reference from the function .pcibios_add_pci_devices() to the function .devinit.text:.pcibios_setup_bus_devices(): N/A => 
  - warning: vmlinux.o(.text+0x9accc): Section mismatch in reference from the function .pcibios_add_pci_devices() to the function .devinit.text:.pci_scan_bridge(): N/A => 

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
