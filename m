Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756413Ab1BRK2S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 05:28:18 -0500
Received: from jacques.telenet-ops.be ([195.130.132.50]:53249 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751745Ab1BRK2N convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 05:28:13 -0500
Date: Fri, 18 Feb 2011 11:28:11 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Build regressions/improvements in v2.6.38-rc5
Message-ID: <alpine.DEB.2.00.1102181123510.17177@ayla.of.borg>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Below is the list of build error/warning regressions/improvements in
v2.6.38-rc5[1] compared to v2.6.37[2].

Summarized:
  - build errors: +71/-17
  - build warnings: +119/-161

JFYI, when comparing v2.6.38-rc5 to v2.6.38-rc4[3], the summaries are:
  - build errors: +24/-60
  - build warnings: +52/-39

In addition, I put the verbose summary at
http://www.kernel.org/pub/linux/kernel/people/geert/linux-log/v2.6.38-rc5.summary.gz
so you can easily find out for which configs and architectures the
errors/warnings you're interested in are happening.

Happy fixing! ;-)

Thanks to the linux-next team for providing the build service.

[1] http://kisskb.ellerman.id.au/kisskb/head/3741/ (all 108 configs)
[2] http://kisskb.ellerman.id.au/kisskb/head/3595/ (all 108 configs)
[3] http://kisskb.ellerman.id.au/kisskb/head/3711/ (all 108 configs)


*** ERRORS ***

71 regressions:
  + build/linus_sparc64-allmodconfig_sparc64/usr/include/linux/types.h: error: expected '=', ',', ';', 'asm' or '__attribute__' before '__be16'/scratch/kisskb/build/linus_sparc64-allmodconfig_sparc64/usr/include/linux/types.h:35: error: expected '=', ',', ';', 'asm' or '__attribute__' before '__wsum':  => 28
  + build/linus_sparc64-allmodconfig_sparc64/usr/include/linux/types.h: error: expected '=', ',', ';', 'asm' or '__attribute__' before '__sum16'In file included from /scratch/kisskb/src/Documentation/spi/spidev_test.c:21::  => 34
  + error: vsprintf.c: relocation truncated to fit: R_AVR32_11H_PCREL against `.text'+71c:  => (.text+0xb22)
  + src/Documentation/accounting/getdelays.c: error: 'struct nlattr' has no member named 'nla_len': 464, 495, 142, 187, 140, 469 => 464, 495, 142, 508, 187, 140, 469
  + src/Documentation/accounting/getdelays.c: error: 'struct nlmsghdr' has no member named 'nlmsg_len': 447, 131, 142, 458, 183, 454 => 447, 131, 145, 142, 458, 183, 454
  + src/Documentation/accounting/getdelays.c: error: 'struct taskstats' has no member named 'cancelled_write_bytes':  => 245
  + src/Documentation/networking/timestamping/timestamping.c: error: 'struct sock_extended_err' has no member named 'ee_origin': 227 => 229, 227
  + src/Documentation/spi/spidev_fdx.c: error: 'struct spi_ioc_transfer' has no member named 'len'/scratch/kisskb/src/Documentation/accounting/getdelays.c:132: error: (Each undeclared identifier is reported only once:  => 65
  + src/Documentation/spi/spidev_fdx.c: error: 'struct spi_ioc_transfer' has no member named 'rx_buf'/scratch/kisskb/src/Documentation/accounting/getdelays.c:132: error: 'struct nlmsghdr' has no member named 'nlmsg_type':  => 64
  + src/Documentation/spi/spidev_test.c: error: '__u32' undeclared (first use in this function):  => 193
  + src/Documentation/spi/spidev_test.c: error: unknown field 'delay_usecs' specified in initializer/scratch/kisskb/build/linus_sparc64-allmodconfig_sparc64/usr/include/linux/if_link.h:230: error: expected specifier-qualifier-list before '__u32':  => 55
  + src/arch/cris/arch-v10/drivers/sync_serial.c: error: 'ret' undeclared (first use in this function):  => 628
  + src/arch/cris/arch-v10/drivers/sync_serial.c: error: (Each undeclared identifier is reported only once:  => 628
  + src/arch/cris/arch-v10/drivers/sync_serial.c: error: conflicting types for 'sync_serial_ioctl':  => 961
  + src/arch/cris/arch-v10/drivers/sync_serial.c: error: for each function it appears in.):  => 628
  + src/arch/cris/arch-v10/drivers/sync_serial.c: error: previous declaration of 'sync_serial_ioctl' was here:  => 161
  + src/arch/cris/arch-v10/kernel/irq.c: error: implicit declaration of function 'set_irq_desc_and_handler':  => 202
  + src/arch/powerpc/kernel/exceptions-64s.S: Error: attempt to move .org backwards:  => 999, 989, 1008
  + src/arch/powerpc/sysdev/mv64x60_dev.c: error: implicit declaration of function 'of_get_mac_address':  => 253
  + src/arch/powerpc/sysdev/tsi108_dev.c: error: implicit declaration of function 'of_get_mac_address':  => 108
  + src/arch/sh/boards/board-shmin.c: error: implicit declaration of function '__set_io_port_base':  => 27
  + src/arch/sh/boards/mach-hp6xx/pm.c: error: implicit declaration of function 'inb':  => 109
  + src/arch/sh/boards/mach-hp6xx/pm.c: error: implicit declaration of function 'inw':  => 113
  + src/arch/sh/boards/mach-hp6xx/pm.c: error: implicit declaration of function 'outb':  => 107
  + src/arch/sh/boards/mach-hp6xx/pm.c: error: implicit declaration of function 'outw':  => 115
  + src/arch/sh/boards/mach-hp6xx/setup.c: error: implicit declaration of function 'inb':  => 66
  + src/arch/sh/boards/mach-hp6xx/setup.c: error: implicit declaration of function 'inw':  => 61
  + src/arch/sh/boards/mach-hp6xx/setup.c: error: implicit declaration of function 'outb':  => 68
  + src/arch/sh/boards/mach-hp6xx/setup.c: error: implicit declaration of function 'outw':  => 63
  + src/arch/sh/boards/mach-se/770x/setup.c: error: implicit declaration of function 'outb_p':  => 23
  + src/arch/sh/kernel/cpu/sh4/setup-sh7750.c: error: asm/machtypes.h: No such file or directory:  => 17:27
  + src/drivers/block/paride/aten.c: error: implicit declaration of function 'inb':  => 57
  + src/drivers/block/paride/aten.c: error: implicit declaration of function 'outb':  => 44
  + src/drivers/block/paride/bpck.c: error: invalid operands to binary & (have 'void *' and 'int'):  => 56, 62
  + src/drivers/bluetooth/bt3c_cs.c: error: implicit declaration of function 'inb':  => 140
  + src/drivers/bluetooth/bt3c_cs.c: error: implicit declaration of function 'outb':  => 119
  + src/drivers/bluetooth/dtl1_cs.c: error: implicit declaration of function 'inb':  => 119
  + src/drivers/bluetooth/dtl1_cs.c: error: implicit declaration of function 'outb':  => 125
  + src/drivers/char/specialix.c: error: implicit declaration of function 'inb':  => 228
  + src/drivers/char/specialix.c: error: implicit declaration of function 'outb':  => 227
  + src/drivers/dma/pch_dma.c: error: implicit declaration of function 'kfree':  => 920
  + src/drivers/dma/pch_dma.c: error: implicit declaration of function 'kzalloc':  => 785
  + src/drivers/hwmon/f71882fg.c: error: implicit declaration of function 'inb':  => 855
  + src/drivers/hwmon/f71882fg.c: error: implicit declaration of function 'outb':  => 854
  + src/drivers/i2c/busses/i2c-eg20t.c: error: implicit declaration of function 'kfree':  => 790
  + src/drivers/i2c/busses/i2c-eg20t.c: error: implicit declaration of function 'kzalloc':  => 720
  + src/drivers/net/lib8390.c: error: implicit declaration of function 'inb':  => 266
  + src/drivers/net/lib8390.c: error: implicit declaration of function 'outb':  => 325
  + src/drivers/tty/serial/8250.c: error: implicit declaration of function 'inb':  => 394
  + src/drivers/tty/serial/8250.c: error: implicit declaration of function 'inb_p':  => 1300
  + src/drivers/tty/serial/8250.c: error: implicit declaration of function 'outb':  => 393
  + src/drivers/tty/serial/8250.c: error: implicit declaration of function 'outb_p':  => 1301
  + src/drivers/tty/serial/8250_early.c: error: implicit declaration of function 'inb':  => 59
  + src/drivers/tty/serial/8250_early.c: error: implicit declaration of function 'outb':  => 75
  + src/drivers/video/backlight/hp680_bl.c: error: implicit declaration of function 'inw':  => 48
  + src/drivers/video/backlight/hp680_bl.c: error: implicit declaration of function 'outw':  => 50
  + src/include/linux/gameport.h: error: implicit declaration of function 'inb':  => 189
  + src/include/linux/gameport.h: error: implicit declaration of function 'outb':  => 181
  + src/kernel/debug/kdb/kdb_keyboard.c: error: implicit declaration of function 'inb':  => 43
  + src/net/mac80211/ieee80211_i.h: error: field 'trig' has incomplete type:  => 638
  + src/sound/drivers/mtpav.c: error: implicit declaration of function 'inb':  => 226
  + src/sound/drivers/mtpav.c: error: implicit declaration of function 'outb':  => 242
  + src/sound/drivers/serial-u16550.c: error: implicit declaration of function 'inb':  => 218
  + src/sound/drivers/serial-u16550.c: error: implicit declaration of function 'outb':  => 196
  + src/sound/oss/sb_mixer.c: error: conflicting types for 'change_bits':  => 235
  + src/sound/pcmcia/pdaudiocf/pdaudiocf.h: error: implicit declaration of function 'inw':  => 127
  + src/sound/pcmcia/pdaudiocf/pdaudiocf.h: error: implicit declaration of function 'outw':  => 122
  + src/sound/pcmcia/vx/vxp_ops.c: error: implicit declaration of function 'inb':  => 63
  + src/sound/pcmcia/vx/vxp_ops.c: error: implicit declaration of function 'inw':  => 420
  + src/sound/pcmcia/vx/vxp_ops.c: error: implicit declaration of function 'outb':  => 73
  + src/sound/pcmcia/vx/vxp_ops.c: error: implicit declaration of function 'outw':  => 378

17 improvements:
  - build/linus_sparc64-allmodconfig_sparc64/usr/include/linux/if_link.h: error: expected specifier-qualifier-list before '__u32': 272, 203, 261, 267, 9, 173, 216, 256 => 243, 200, 289, 295, 284, 9, 300
  - build/linus_sparc64-allmodconfig_sparc64/usr/include/linux/types.h: error: expected '=', ',', ';', 'asm' or '__attribute__' before '__be32'/scratch/kisskb/src/Documentation/networking/timestamping/timestamping.c:229: error: 'struct sock_extended_err' has no member named 'ee_origin': 30 => 
  - src/Documentation/accounting/getdelays.c: error: 'struct nlattr' has no member named 'nla_len'/scratch/kisskb/src/Documentation/spi/spidev_test.c:193: error: '__u32' undeclared (first use in this function): 508 => 
  - src/Documentation/accounting/getdelays.c: error: 'struct nlmsghdr' has no member named 'nlmsg_len'In file included from /scratch/kisskb/build/linus_sparc64-allmodconfig_sparc64/usr/include/linux/errqueue.h:4,: 145 => 
  - src/Documentation/accounting/getdelays.c: error: 'struct nlmsghdr' has no member named 'nlmsg_type': 182, 446, 132 => 182, 446
  - src/Documentation/accounting/getdelays.c: error: (Each undeclared identifier is reported only once: 132 => 
  - src/Documentation/spi/spidev_fdx.c: error: 'struct spi_ioc_transfer' has no member named 'len': 65, 62 => 62
  - src/Documentation/spi/spidev_fdx.c: error: 'struct spi_ioc_transfer' has no member named 'rx_buf': 64 => 
  - src/Documentation/spi/spidev_test.c: error: unknown field 'delay_usecs' specified in initializer: 55 => 
  - src/arch/alpha/include/asm/io.h: error: 'arch_local_irq_restore' is static but used in inline function '__set_hae' which is not static: 49 => 
  - src/arch/alpha/include/asm/io.h: error: 'arch_local_irq_save' is static but used in inline function '__set_hae' which is not static: 41 => 
  - src/arch/avr32/include/asm/syscalls.h: error: previous declaration of 'sys_execve' was here: 25 => 
  - src/arch/avr32/kernel/process.c: error: conflicting types for 'sys_execve': 390 => 
  - src/arch/x86/include/asm/uaccess_32.h: error: call to 'copy_from_user_overflow' declared with attribute error: copy_from_user() buffer size is not provably correct: 212 => 
  - src/drivers/i2c/busses/i2c-i801.c: error: implicit declaration of function 'kfree': 855 => 
  - src/drivers/i2c/busses/i2c-i801.c: error: implicit declaration of function 'kzalloc': 737 => 
  - src/include/linux/kprobes.h: error: dereferencing pointer to incomplete type: 316 => 


*** WARNINGS ***

119 regressions:
  + .config: warning: override: PCI_GOANY changes choice state:  => 461
  + .config: warning: override: SLOB changes choice state:  => 137
  + modpost: WARNING: modpost: Found 28 section mismatch(es).:  => N/A
  + modpost: WARNING: modpost: Found 3 section mismatch(es).:  => N/A
  + modpost: WARNING: modpost: Found 56 section mismatch(es).:  => N/A
  + modpost: WARNING: modpost: Found 9 section mismatch(es).:  => N/A
  + src/arch/cris/arch-v10/drivers/sync_serial.c: warning: initialization from incompatible pointer type:  => 252
  + src/arch/cris/arch-v10/drivers/sync_serial.c: warning: passing argument 1 of 'memcpy' discards qualifiers from pointer target type:  => 1353, 1343
  + src/arch/cris/arch-v10/drivers/sync_serial.c: warning: passing argument 1 of 'virt_to_phys' discards qualifiers from pointer target type:  => 1224
  + src/arch/m68k/include/asm/atarihw.h: warning: this is the location of the previous definition:  => 403:1, 402:1
  + src/arch/powerpc/sysdev/mv64x60_dev.c: warning: assignment makes pointer from integer without a cast:  => 253
  + src/arch/powerpc/sysdev/tsi108_dev.c: warning: assignment makes pointer from integer without a cast:  => 108
  + src/arch/s390/kvm/../../../virt/kvm/kvm_main.c: warning: 'kvm_create_dirty_bitmap' defined but not used:  => 597
  + src/arch/sh/kernel/cpu/sh4/setup-sh7750.c: warning: passing argument 1 of 'early_platform_add_devices' from incompatible pointer type:  => 263, 260, 262
  + src/arch/x86/include/asm/uaccess_32.h: warning: call to 'copy_from_user_overflow' declared with attribute warning: copy_from_user() buffer size is not provably correct:  => 212
  + src/arch/x86/kernel/cpu/perf_event.c: warning: 'emptyconstraint' defined but not used:  => 1323
  + src/arch/x86/kernel/cpu/perf_event.c: warning: 'x86_get_event_constraints' defined but not used:  => 1326
  + src/arch/x86/kernel/cpu/perf_event.c: warning: 'x86_pmu_disable_all' defined but not used:  => 610
  + src/arch/x86/kernel/cpu/perf_event.c: warning: 'x86_pmu_enable_all' defined but not used:  => 645
  + src/arch/x86/kernel/cpu/perf_event.c: warning: 'x86_pmu_enable_event' defined but not used:  => 998
  + src/arch/x86/kernel/cpu/perf_event.c: warning: 'x86_pmu_handle_irq' defined but not used:  => 1190
  + src/arch/x86/kernel/cpu/perf_event.c: warning: 'x86_pmu_hw_config' defined but not used:  => 537
  + src/arch/x86/kernel/cpu/perf_event.c: warning: 'x86_schedule_events' defined but not used:  => 670
  + src/crypto/algif_hash.c: warning: 'hash_accept' uses dynamic stack allocation:  => 212
  + src/drivers/char/cyclades.c: warning: 'cyz_interrupt' defined but not used: 1200 => 1200, 1201
  + src/drivers/char/rocket.c: warning: 'rmSpeakerReset' defined but not used: 3166 => 3167, 3166
  + src/drivers/char/rocket.c: warning: 'sPCIInitController' defined but not used: 2625 => 2625, 2630
  + src/drivers/char/rtc.c: warning: 'rtc_freq' defined but not used:  => 192
  + src/drivers/char/tpm/tpm_tis.c: warning: 'is_itpm' defined but not used:  => 96
  + src/drivers/dma/pch_dma.c: warning: 'pch_dma_resume' defined but not used:  => 755
  + src/drivers/dma/pch_dma.c: warning: 'pch_dma_suspend' defined but not used:  => 741
  + src/drivers/dma/pch_dma.c: warning: assignment makes pointer from integer without a cast:  => 786
  + src/drivers/gpio/ml_ioh_gpio.c: warning: 'ioh_gpio_restore_reg_conf' defined but not used:  => 152
  + src/drivers/gpio/ml_ioh_gpio.c: warning: 'ioh_gpio_save_reg_conf' defined but not used:  => 143
  + src/drivers/i2c/busses/i2c-eg20t.c: warning: assignment makes pointer from integer without a cast:  => 720
  + src/drivers/i2c/busses/i2c-ocores.c: warning: assignment discards qualifiers from pointer target type:  => 254, 261
  + src/drivers/input/misc/cma3000_d0x.c: warning: comparison is always false due to limited range of data type:  => 320, 121
  + src/drivers/input/touchscreen/eeti_ts.c: warning: 'eeti_ts_resume' defined but not used:  => 283
  + src/drivers/input/touchscreen/eeti_ts.c: warning: 'eeti_ts_suspend' defined but not used:  => 264
  + src/drivers/isdn/sc/init.c: warning: passing argument 1 of 'readl' makes pointer from integer without a cast:  => 497, 487, 507
  + src/drivers/md/dm-crypt.c: warning: 'crypt_iv_lmk_one' uses dynamic stack allocation:  => 585
  + src/drivers/media/video/vino.c: warning: 'data_norm' may be used uninitialized in this function:  => 2566, 2656
  + src/drivers/misc/apds990x.c: warning: comparison is always false due to limited range of data type:  => 701
  + src/drivers/net/cris/eth_v10.c: warning: unused variable 'np':  => 1135
  + src/drivers/net/sky2.c: warning: 'sky2_resume' defined but not used:  => 4988
  + src/drivers/net/smc91x.c: warning: passing argument 1 of 'insw' makes integer from pointer without a cast:  => 489
  + src/drivers/net/smc91x.c: warning: passing argument 1 of 'inw' makes integer from pointer without a cast:  => 1341, 1173, 795, 620, 1950, 1660, 469, 1827, 723, 1345, 1197, 859, 570, 329, 1279, 410, 1912, 1249, 1224, 690, 676, 1693, 1232, 313, 1265, 395, 678, 1285, 1882, 755, 420, 773, 491, 728, 1344, 1225, 1665, 799, 1925, 1342, 1686, 751, 716, 439, 1899, 832, 1288, 1691, 1340
  + src/drivers/net/smc91x.c: warning: passing argument 1 of 'outsw' makes integer from pointer without a cast:  => 596
  + src/drivers/net/smc91x.c: warning: passing argument 2 of 'outw' makes integer from pointer without a cast:  => 1661, 620, 1346, 1659, 850, 796, 324, 937, 580, 599, 1687, 1200, 440, 1682, 1681, 690, 752, 277, 395, 938, 379, 1898, 1653, 1343, 1266, 1285, 492, 295, 394, 820, 349, 1458, 837, 1654, 1695, 1657, 1198, 417, 668, 1174, 1023, 784, 312, 724, 1199, 1924, 1074, 309, 470, 593, 346, 389, 489, 1295, 327, 727, 859, 939, 1696, 380, 761, 1279, 1249, 252, 310, 760, 804, 1656, 1172, 581, 345, 308, 348, 596, 1819, 678, 1459, 1131, 1464, 1196, 613, 1684, 1226, 1949, 1813, 756, 1024, 328, 269, 1294, 864, 1668, 759, 344, 1685, 1264, 1073, 388, 355, 1667, 1461, 782, 390, 253, 1462, 1840, 356, 802, 832, 1288, 270, 1911, 1812
  + src/drivers/net/wireless/rtlwifi/pci.c: warning: unused variable 'rtlpci':  => 1435
  + src/drivers/net/wireless/rtlwifi/rtl8192ce/reg.h: warning: "GPIO_IN" redefined:  => 353:1
  + src/drivers/net/wireless/rtlwifi/rtl8192ce/reg.h: warning: "GPIO_OUT" redefined:  => 354:1
  + src/drivers/pps/kapi.c: warning: 'ts_real.flags' may be used uninitialized in this function:  => 196
  + src/drivers/rtc/rtc-cmos.c: warning: 'cmos_resume' defined but not used:  => 906, 907
  + src/drivers/scsi/advansys.c: warning: label 'err_unmap' defined but not used:  => 12379
  + src/drivers/scsi/bfa/bfa_fcpim.c: warning: left shift count >= width of type:  => 2125, 2113
  + src/drivers/scsi/bfa/bfa_fcpim.c: warning: right shift count >= width of type:  => 2125, 2113
  + src/drivers/tty/n_gsm.c: warning: unused variable 'buf':  => 2149
  + src/drivers/tty/serial/8250.c: warning: 'i' may be used uninitialized in this function:  => 1728
  + src/drivers/tty/serial/8250_hp300.c: warning: #warning CONFIG_8250 defined but neither CONFIG_HPDCA nor CONFIG_HPAPCI defined, are you sure?:  => 24:2
  + src/drivers/tty/serial/pch_uart.c: warning: cast from pointer to integer of different size:  => 779
  + src/drivers/tty/serial/ucc_uart.c: warning: format '%x' expects type 'unsigned int', but argument 3 has type 'dma_addr_t':  => 238
  + src/drivers/usb/gadget/u_ether.c: warning: comparison of distinct pointer types lacks a cast:  => 244
  + src/drivers/usb/otg/twl6030-usb.c: warning: 'twl6030_set_phy_clk' defined but not used:  => 135
  + src/drivers/video/aty/atyfb_base.c: warning: 'ram_dram' defined but not used:  => 538
  + src/drivers/video/aty/atyfb_base.c: warning: 'ram_resv' defined but not used:  => 539
  + src/drivers/video/aty/radeon_pm.c: warning: 'radeon_reinitialize_M10' defined but not used:  => 1718
  + src/drivers/video/aty/radeon_pm.c: warning: 'radeon_reinitialize_M9P' defined but not used:  => 1971
  + src/drivers/video/udlfb.c: warning: ignoring return value of 'device_create_bin_file', declared with attribute warn_unused_result:  => 1592
  + src/drivers/video/udlfb.c: warning: ignoring return value of 'device_create_file', declared with attribute warn_unused_result:  => 1590
  + src/drivers/video/via/via-core.c: warning: assignment discards qualifiers from pointer target type:  => 684
  + src/drivers/video/via/via_i2c.c: warning: 'id' is deprecated (declared at /scratch/kisskb/src/include/linux/i2c.h:359):  => 212
  + src/drivers/video/via/viafbdev.c: warning: unused variable 'iga1_entry':  => 1626
  + src/drivers/video/via/viafbdev.c: warning: unused variable 'iga2_entry':  => 1627
  + src/fs/cifs/file.c: warning: 'rc' may be used uninitialized in this function:  => 1822
  + src/fs/ext3/balloc.c: warning: passing argument 2 of 'test_and_clear_bit' from incompatible pointer type: 833, 619 => 849, 635, 2010
  + src/fs/ncpfs/ncp_fs_sb.h: warning: 'packed' attribute ignored for field of type '__u16':  => 128, 130, 127, 129, 126
  + src/fs/ncpfs/ncp_fs_sb.h: warning: 'packed' attribute ignored for field of type '__u32':  => 124, 125
  + src/fs/nfs/callback_proc.c: warning: 'ino' may be used uninitialized in this function:  => 115
  + src/fs/quota/quota_tree.c: warning: format '%zd' expects type 'signed size_t', but argument 4 has type 'ssize_t':  => 372
  + src/fs/quota/quota_v2.c: warning: format '%zd' expects type 'signed size_t', but argument 5 has type 'ssize_t':  => 66
  + src/fs/sysfs/dir.c: warning: 'sysfs_pathname' defined but not used: 411 => 414, 415
  + src/fs/xfs/xfs_inode_item.c: warning: 'xfs_iflush_done' uses dynamic stack allocation:  => 944
  + src/include/net/ipx.h: warning: 'packed' attribute ignored for field of type '__be16':  => 32, 30
  + src/include/net/ipx.h: warning: 'packed' attribute ignored for field of type 'struct ipx_address':  => 42, 41
  + src/mm/vmstat.c: warning: 'frag_next' defined but not used:  => 623
  + src/mm/vmstat.c: warning: 'frag_start' defined but not used:  => 611
  + src/mm/vmstat.c: warning: 'frag_stop' defined but not used:  => 631
  + src/mm/vmstat.c: warning: 'walk_zones_in_node' defined but not used:  => 636
  + src/net/batman-adv/vis.c: warning: passing argument 2 of 'compare_orig' discards qualifiers from pointer target type:  => 117
  + src/net/ipv6/mcast.c: warning: overflow in implicit constant conversion:  => 309, 241
  + src/net/irda/irnet/irnet_ppp.c: warning: format '%Zd' expects type 'signed size_t', but argument 3 has type 'ssize_t':  => 331
  + src/net/mac80211/tx.c: warning: unused variable 'mppath':  => 1753
  + src/net/packet/af_packet.c: warning: 'vnet_hdr_len' may be used uninitialized in this function:  => 1119
  + src/sound/pci/ctxfi/ctvmem.c: warning: 'entry' may be used uninitialized in this function:  => 34, 80
  + src/sound/soc/soc-core.c: warning: 'compress_type' may be used uninitialized in this function:  => 1719
  + warning: "saved_config" [vmlinux] is COMMON symbol:  => N/A
  + warning: (AMIGAONE) selects PCSPKR_PLATFORM which has unmet direct dependencies (ALPHA || X86 || MIPS || PPC_PREP || PPC_CHRP || PPC_PSERIES):  => N/A
  + warning: (ATH5K && ATH9K && ATH9K_HTC && CARL9170_LEDS) selects MAC80211_LEDS which has unmet direct dependencies (NET && WIRELESS && MAC80211 && LEDS_CLASS):  => N/A
  + warning: (AX88796_93CX6 && RTL8180 && RTL8187 && ADM8211 && RT2400PCI && RT2500PCI && RT61PCI && RT2800PCI && R8187SE) selects EEPROM_93CX6 which has unmet direct dependencies (MISC_DEVICES):  => N/A
  + warning: (CAVIUM_OCTEON_REFERENCE_BOARD && BCM63XX_CPU_6338) selects USB_ARCH_HAS_OHCI which has unmet direct dependencies (USB_SUPPORT):  => N/A
  + warning: (CAVIUM_OCTEON_REFERENCE_BOARD) selects USB_ARCH_HAS_EHCI which has unmet direct dependencies (USB_SUPPORT):  => N/A
  + warning: (COMPAT) selects COMPAT_BINFMT_ELF which has unmet direct dependencies (COMPAT && BINFMT_ELF):  => N/A
  + warning: (CPU_SUBTYPE_SH7720 && CPU_SUBTYPE_SH7721 && CPU_SUBTYPE_SH7763 && CPU_SUBTYPE_SH7786) selects USB_ARCH_HAS_OHCI which has unmet direct dependencies (USB_SUPPORT):  => N/A
  + warning: (ETRAX_USB_HOST && MOUSE_APPLETOUCH && MOUSE_BCM5974 && JOYSTICK_XPAD && TABLET_USB_ACECAD && TABLET_USB_AIPTEK && TABLET_USB_HANWANG && TABLET_USB_KBTAB && TABLET_USB_WACOM && TOUCHSCREEN_USB_COMPOSITE && INPUT_ATI_REMOTE && INPUT_ATI_REMOTE2 && INPUT_KEYSPAN_REMOTE && INPUT_POWERMATE && INPUT_YEALINK && INPUT_CM109) selects USB which has unmet direct dependencies (USB_SUPPORT && USB_ARCH_HAS_HCD):  => N/A
  + warning: (I2C_ISCH && GPIO_SCH && GPIO_RDC321X) selects MFD_CORE which has unmet direct dependencies (MFD_SUPPORT):  => N/A
  + warning: (I2C_ISCH && GPIO_SCH) selects LPC_SCH which has unmet direct dependencies (MFD_SUPPORT && PCI):  => N/A
  + warning: (LOCKDEP && FAULT_INJECTION_STACKTRACE_FILTER && LATENCYTOP && DWARF_UNWINDER && FUNCTION_TRACER && KMEMCHECK) selects FRAME_POINTER which has unmet direct dependencies (DEBUG_KERNEL && (CRIS || M68K || FRV || UML || AVR32 || SUPERH || BLACKFIN || MN10300) || ARCH_WANT_FRAME_POINTERS):  => N/A
  + warning: (LOCKDEP && FAULT_INJECTION_STACKTRACE_FILTER && LATENCYTOP && FUNCTION_TRACER && KMEMCHECK) selects FRAME_POINTER which has unmet direct dependencies (DEBUG_KERNEL && (CRIS || M68K || FRV || UML || AVR32 || SUPERH || BLACKFIN || MN10300) || ARCH_WANT_FRAME_POINTERS):  => N/A
  + warning: (MPC836x_RDK && MTD_NAND_FSL_ELBC && MTD_NAND_FSL_UPM) selects FSL_LBC which has unmet direct dependencies (FSL_SOC):  => N/A
  + warning: (MTD_DOC2000 && MTD_DOC2001 && MTD_DOC2001PLUS) selects MTD_NAND_IDS which has unmet direct dependencies (MTD && MTD_NAND):  => N/A
  + warning: (NETFILTER_XT_MATCH_REALM) selects NET_CLS_ROUTE which has unmet direct dependencies (NET && NET_SCHED):  => N/A
  + warning: (PAGE_POISONING) selects DEBUG_PAGEALLOC which has unmet direct dependencies (DEBUG_KERNEL && ARCH_SUPPORTS_DEBUG_PAGEALLOC && (!HIBERNATION || !PPC && !SPARC) && !KMEMCHECK):  => N/A
  + warning: (PERF_EVENTS) selects IRQ_WORK which has unmet direct dependencies (HAVE_IRQ_WORK):  => N/A
  + warning: (RADIO_MIROPCM20) selects SND_ISA which has unmet direct dependencies (SOUND && !M68K && SND && ISA && ISA_DMA_API):  => N/A
  + warning: (SCHED_AUTOGROUP) selects CGROUP_SCHED which has unmet direct dependencies (CGROUPS && EXPERIMENTAL):  => N/A
  + warning: (SERIAL_PCH_UART) selects PCH_DMA which has unmet direct dependencies (DMADEVICES && PCI && X86):  => N/A
  + warning: (STUB_POULSBO && DRM_I915) selects ACPI_VIDEO which has unmet direct dependencies (ACPI && X86 && BACKLIGHT_CLASS_DEVICE && VIDEO_OUTPUT_CONTROL && INPUT):  => N/A
  + warning: (USB_WUSB) selects UWB which has unmet direct dependencies (EXPERIMENTAL && PCI):  => N/A

161 improvements:
  - arch/avr32/configs/atstk1002_defconfig: warning: symbol value 'm' invalid for LEDS_CLASS: 137 => 
  - modpost: WARNING: modpost: Found 16 section mismatch(es).: N/A => 
  - modpost: WARNING: modpost: Found 17 section mismatch(es).: N/A => 
  - modpost: WARNING: modpost: Found 47 section mismatch(es).: N/A => 
  - modpost: WARNING: modpost: Found 66 section mismatch(es).: N/A => 
  - src/arch/alpha/include/asm/io.h: warning: 'arch_local_irq_restore' is static but used in inline function '__set_hae' which is not static: 49 => 
  - src/arch/alpha/include/asm/io.h: warning: 'arch_local_irq_save' is static but used in inline function '__set_hae' which is not static: 41 => 
  - src/arch/m68k/kernel/sys_m68k.c: warning: passing argument 1 of 'kunmap' from incompatible pointer type: 516, 508 => 
  - src/arch/powerpc/platforms/embedded6xx/wii.c: warning: format '%08llx' expects type 'long long unsigned int', but argument 2 has type 'phys_addr_t': 89, 91 => 
  - src/arch/powerpc/platforms/embedded6xx/wii.c: warning: format '%08llx' expects type 'long long unsigned int', but argument 3 has type 'phys_addr_t': 89, 91 => 
  - src/arch/s390/kvm/../../../virt/kvm/kvm_main.c: warning: passing argument 3 of 'kvm_write_guest_page' makes pointer from integer without a cast: 1224 => 
  - src/arch/s390/kvm/../../../virt/kvm/kvm_main.c: warning: unused variable 'r': 1827 => 
  - src/arch/sh/include/asm/ptrace_32.h: warning: this is the location of the previous definition: 25:1 => 
  - src/arch/x86/lguest/i386_head.S: Warning: shift count out of range (32 is not between 0 and 31): 65 => 
  - src/drivers/char/ip2/ip2main.c: warning: 'ip2main_pci_tbl' defined but not used: 3227 => 
  - src/drivers/char/rocket.c: warning: 'rocket_pci_ids' defined but not used: 1767 => 
  - src/drivers/char/specialix.c: warning: 'specialx_pci_tbl' defined but not used: 2358 => 
  - src/drivers/gpio/bt8xxgpio.c: warning: ignoring return value of 'gpiochip_remove', declared with attribute warn_unused_result: 247 => 
  - src/drivers/hwmon/w83795.c: warning: 'lsb' may be used uninitialized in this function: 483 => 
  - src/drivers/i2c/busses/i2c-i801.c: warning: assignment makes pointer from integer without a cast: 737 => 
  - src/drivers/ide/ide-floppy.c: warning: 'pc' may be used uninitialized in this function: 234 => 
  - src/drivers/infiniband/hw/amso1100/c2_vq.c: warning: cast from pointer to integer of different size: 154, 126, 110 => 
  - src/drivers/input/misc/twl4030-vibra.c: warning: 'twl4030_vibra_resume' defined but not used: 188 => 
  - src/drivers/input/misc/twl4030-vibra.c: warning: 'twl4030_vibra_suspend' defined but not used: 177 => 
  - src/drivers/isdn/gigaset/capi.c: warning: 'format_ie' defined but not used: 301 => 
  - src/drivers/isdn/hisax/config.c: warning: 'hisax_pci_tbl' defined but not used: 1920 => 
  - src/drivers/leds/leds-alix2.c: warning: 'divil_pci' defined but not used: 25 => 
  - src/drivers/leds/leds-gpio.c: warning: 'create_gpio_led' defined but not used: 91 => 
  - src/drivers/leds/leds-gpio.c: warning: 'delete_gpio_led' defined but not used: 145 => 
  - src/drivers/leds/leds-lp5521.c: warning: 'engine_state' may be used uninitialized in this function: 169 => 
  - src/drivers/leds/leds-lp5523.c: warning: 'adc' may be used uninitialized in this function: 435 => 
  - src/drivers/leds/leds-lp5523.c: warning: 'vdd' may be used uninitialized in this function: 435 => 
  - src/drivers/media/dvb/frontends/af9013.c: warning: 'ret' may be used uninitialized in this function: 1011 => 
  - src/drivers/media/video/cx88/cx88-i2c.c: warning: 'id' is deprecated (declared at /scratch/kisskb/src/include/linux/i2c.h:356): 149 => 
  - src/drivers/media/video/cx88/cx88-vp3054-i2c.c: warning: 'id' is deprecated (declared at /scratch/kisskb/src/include/linux/i2c.h:356): 128 => 
  - src/drivers/media/video/v4l2-compat-ioctl32.c: warning: ignoring return value of 'copy_to_user', declared with attribute warn_unused_result: 209 => 
  - src/drivers/memstick/core/mspro_block.c: warning: control reaches end of non-void function: 664 => 
  - src/drivers/mfd/sh_mobile_sdhi.c: warning: 'sh_mobile_sdhi_remove' defined but not used: 161 => 
  - src/drivers/misc/apds990x.c: warning: 'apds990x_resume' defined but not used: 1216 => 
  - src/drivers/misc/apds990x.c: warning: 'apds990x_suspend' defined but not used: 1207 => 
  - src/drivers/misc/ics932s401.c: warning: 'reg' may be used uninitialized in this function: 392 => 
  - src/drivers/misc/ics932s401.c: warning: 'x' may be used uninitialized in this function: 375 => 
  - src/drivers/mtd/maps/solutionengine.c: warning: format '%08lx' expects type 'long unsigned int', but argument 2 has type 'resource_size_t': 86 => 
  - src/drivers/mtd/maps/solutionengine.c: warning: format '%08lx' expects type 'long unsigned int', but argument 3 has type 'resource_size_t': 86 => 
  - src/drivers/mtd/sm_ftl.c: warning: comparison of distinct pointer types lacks a cast: 200, 199 => 
  - src/drivers/net/bna/bnad.c: warning: 'using_dac' may be used uninitialized in this function: 3035 => 
  - src/drivers/net/can/pch_can.c: warning: 'pch_can_get_int_enables' defined but not used: 269 => 
  - src/drivers/net/can/pch_can.c: warning: 'pch_can_get_rx_buffer_link' defined but not used: 480 => 
  - src/drivers/net/can/pch_can.c: warning: 'pch_can_get_rx_enable' defined but not used: 420 => 
  - src/drivers/net/can/pch_can.c: warning: 'pch_can_get_tx_enable' defined but not used: 438 => 
  - src/drivers/net/can/pch_can.c: warning: 'pch_can_set_int_custom' defined but not used: 258 => 
  - src/drivers/net/can/pch_can.c: warning: 'pch_can_set_rx_buffer_link' defined but not used: 462 => 
  - src/drivers/net/can/sja1000/sja1000.h: warning: "REG_SR" redefined: 60:1 => 
  - src/drivers/net/enic/enic_main.c: warning: passing argument 3 of 'pci_alloc_consistent' from incompatible pointer type: 2057, 2083 => 
  - src/drivers/net/macvtap.c: warning: control reaches end of non-void function: 102 => 
  - src/drivers/net/pcmcia/nmclan_cs.c: warning: 'pcmcia_request_exclusive_irq' is deprecated (declared at /scratch/kisskb/src/include/pcmcia/ds.h:203): 628 => 
  - src/drivers/net/pcmcia/smc91c92_cs.c: warning: unused variable 'smc': 960 => 
  - src/drivers/net/sh_eth.c: warning: 'ctrl_inl' is deprecated (declared at /scratch/kisskb/src/arch/sh/include/asm/io.h:104): 365, 860, 660, 288, 1128, 814, 937, 891, 366, 1258, 286, 848, 361, 906, 664, 1298, 1266, 1256, 1302, 394, 842, 363, 830, 857, 364, 388, 1003, 362, 382, 855, 1199, 1254, 852 => 
  - src/drivers/net/sh_eth.c: warning: 'ctrl_outl' is deprecated (declared at /scratch/kisskb/src/arch/sh/include/asm/io.h:124): 892, 643, 685, 660, 1330, 1314, 942, 831, 288, 1332, 1218, 647, 1200, 667, 918, 690, 676, 1310, 1312, 633, 1267, 1311, 1257, 1315, 815, 1319, 342, 1333, 1324, 857, 683, 1215, 1219, 1328, 382, 1318, 658, 1329, 673, 860, 1327, 650, 640, 661, 1317, 339, 286, 655, 848, 531, 687, 1259, 1313, 1298, 1325, 1255, 1302, 626, 639, 1316, 1331, 388, 636, 509, 1003, 652, 629, 855, 852 => 
  - src/drivers/net/smc911x.c: warning: unused variable 'lp': 2127 => 
  - src/drivers/net/smc911x.h: warning: control reaches end of non-void function: 135 => 
  - src/drivers/net/smc91x.c: warning: passing argument 1 of 'sh_mv.mv_insw' makes integer from pointer without a cast: 489 => 
  - src/drivers/net/smc91x.c: warning: passing argument 1 of 'sh_mv.mv_inw' makes integer from pointer without a cast: 1341, 1173, 795, 620, 1950, 1660, 469, 1827, 723, 1345, 1197, 859, 570, 329, 1279, 410, 1912, 1249, 1224, 690, 676, 1693, 1232, 313, 1265, 395, 678, 1285, 1882, 755, 420, 773, 491, 728, 1344, 1225, 1665, 799, 1925, 1342, 1686, 751, 716, 439, 1899, 832, 1288, 1691, 1340 => 
  - src/drivers/net/smc91x.c: warning: passing argument 1 of 'sh_mv.mv_outsw' makes integer from pointer without a cast: 596 => 
  - src/drivers/net/smc91x.c: warning: passing argument 2 of 'sh_mv.mv_outw' makes integer from pointer without a cast: 1661, 620, 1346, 1659, 850, 796, 324, 937, 580, 599, 1687, 1200, 440, 1682, 1681, 690, 752, 277, 395, 938, 379, 1898, 1653, 1343, 1266, 1285, 492, 295, 394, 820, 349, 1458, 837, 1654, 1695, 1657, 1198, 417, 668, 1174, 1023, 784, 312, 724, 1199, 1924, 1074, 309, 470, 593, 346, 389, 489, 1295, 327, 727, 859, 939, 1696, 380, 761, 1279, 1249, 252, 310, 760, 804, 1656, 1172, 581, 345, 308, 348, 596, 1819, 678, 1459, 1131, 1464, 1196, 613, 1684, 1226, 1949, 1813, 756, 1024, 328, 269, 1294, 864, 1668, 759, 344, 1685, 1264, 1073, 388, 355, 1667, 1461, 782, 390, 253, 1462, 1840, 356, 802, 832, 1288, 270, 1911, 1812 => 
  - src/drivers/net/stmmac/stmmac_main.c: warning: ignoring return value of 'strict_strtoul', declared with attribute warn_unused_result: 1948, 1957, 1952, 1938, 1945, 1954, 1950, 1940, 1942 => 
  - src/drivers/net/usb/hso.c: warning: unused variable 'uarg': 1744 => 
  - src/drivers/net/wireless/ath/ar9170/ar9170.h: warning: control reaches end of non-void function: 76 => 
  - src/drivers/net/wireless/ath/carl9170/phy.c: warning: control reaches end of non-void function: 1604 => 
  - src/drivers/parport/parport_pc.c: warning: 'parport_pc_find_isa_ports' defined but not used: 3333 => 
  - src/drivers/pci/pcie/portdrv_core.c: warning: 'cap_mask' may be used uninitialized in this function: 241 => 
  - src/drivers/regulator/wm831x-dcdc.c: warning: control reaches end of non-void function: 124 => 
  - src/drivers/rtc/rtc-cmos.c: warning: #warning Assuming 128 bytes of RTC+NVRAM address space, not 64 bytes.: 693:2 => 
  - src/drivers/rtc/rtc-msm6242.c: warning: 'return' with a value, in function returning void: 85 => 
  - src/drivers/rtc/rtc-rp5c01.c: warning: 'return' with a value, in function returning void: 79 => 
  - src/drivers/scsi/lpfc/lpfc_bsg.c: warning: 'rpi' may be used uninitialized in this function: 2105 => 
  - src/drivers/serial/8250.c: warning: 'i' may be used uninitialized in this function: 1696 => 
  - src/drivers/serial/8250_hp300.c: warning: #warning CONFIG_8250 defined but neither CONFIG_HPDCA nor CONFIG_HPAPCI defined, are you sure?: 24:2 => 
  - src/drivers/serial/ucc_uart.c: warning: format '%x' expects type 'unsigned int', but argument 3 has type 'dma_addr_t': 238 => 
  - src/drivers/telephony/ixj.c: warning: 'ixj_pci_tbl' defined but not used: 287 => 
  - src/drivers/usb/gadget/f_fs.c: warning: 'rem_type1' may be used uninitialized in this function: 1987 => 
  - src/drivers/usb/host/oxu210hp-hcd.c: warning: unused variable 'base': 3897 => 
  - src/drivers/usb/host/whci/hcd.c: warning: 'whci_hcd_id_table' defined but not used: 359 => 
  - src/drivers/uwb/i1480/i1480-est.c: warning: 'i1480_est_id_table' defined but not used: 94 => 
  - src/drivers/uwb/whc-rc.c: warning: 'whcrc_id_table' defined but not used: 452 => 
  - src/drivers/video/backlight/adp5520_bl.c: warning: ignoring return value of 'strict_strtoul', declared with attribute warn_unused_result: 215 => 
  - src/drivers/video/mb862xx/mb862xxfb.c: warning: 'mb862xxfb_init_fbinfo' defined but not used: 327, 326 => 326
  - src/drivers/video/s1d13xxxfb.c: warning: 'bltbit_fifo_status' defined but not used: 464, 465 => 
  - src/drivers/video/s1d13xxxfb.c: warning: 'bltbit_wait_bitset' defined but not used: 421, 422 => 
  - src/drivers/video/sh_mobile_lcdcfb.c: warning: format '%u' expects type 'unsigned int', but argument 11 has type 'long unsigned int': 922 => 
  - src/drivers/video/sis/sis_main.c: warning: unused variable 'temp': 4108 => 
  - src/drivers/video/valkyriefb.c: warning: unused variable 'i': 268 => 
  - src/drivers/video/valkyriefb.c: warning: unused variable 'req': 267 => 
  - src/drivers/video/via/via_i2c.c: warning: 'id' is deprecated (declared at /scratch/kisskb/src/include/linux/i2c.h:356): 212 => 
  - src/drivers/virtio/virtio_ring.c: warning: cast to pointer from integer of different size: 271 => 
  - src/drivers/watchdog/alim7101_wdt.c: warning: 'alim7101_pci_tbl' defined but not used: 433 => 
  - src/fs/autofs4/symlink.c: warning: passing argument 2 of 'nd_set_link' discards qualifiers from pointer target type: 18 => 
  - src/fs/dcache.c: warning: control reaches end of non-void function: 1905 => 
  - src/fs/ext4/super.c: warning: 'ret' may be used uninitialized in this function: 2919 => 
  - src/fs/ncpfs/inode.c: warning: 'data.mounted_vol[10u]' may be used uninitialized in this function: 440 => 
  - src/fs/ncpfs/inode.c: warning: 'data.mounted_vol[11u]' may be used uninitialized in this function: 440 => 
  - src/fs/ncpfs/inode.c: warning: 'data.mounted_vol[12u]' may be used uninitialized in this function: 440 => 
  - src/fs/ncpfs/inode.c: warning: 'data.mounted_vol[13u]' may be used uninitialized in this function: 440 => 
  - src/fs/ncpfs/inode.c: warning: 'data.mounted_vol[14u]' may be used uninitialized in this function: 440 => 
  - src/fs/ncpfs/inode.c: warning: 'data.mounted_vol[15u]' may be used uninitialized in this function: 440 => 
  - src/fs/ncpfs/inode.c: warning: 'data.mounted_vol[16u]' may be used uninitialized in this function: 440 => 
  - src/fs/ncpfs/inode.c: warning: 'data.mounted_vol[1u]' may be used uninitialized in this function: 440 => 
  - src/fs/ncpfs/inode.c: warning: 'data.mounted_vol[2u]' may be used uninitialized in this function: 440 => 
  - src/fs/ncpfs/inode.c: warning: 'data.mounted_vol[3u]' may be used uninitialized in this function: 440 => 
  - src/fs/ncpfs/inode.c: warning: 'data.mounted_vol[4u]' may be used uninitialized in this function: 440 => 
  - src/fs/ncpfs/inode.c: warning: 'data.mounted_vol[5u]' may be used uninitialized in this function: 440 => 
  - src/fs/ncpfs/inode.c: warning: 'data.mounted_vol[6u]' may be used uninitialized in this function: 440 => 
  - src/fs/ncpfs/inode.c: warning: 'data.mounted_vol[7u]' may be used uninitialized in this function: 440 => 
  - src/fs/ncpfs/inode.c: warning: 'data.mounted_vol[8u]' may be used uninitialized in this function: 440 => 
  - src/fs/ncpfs/inode.c: warning: 'data.mounted_vol[9u]' may be used uninitialized in this function: 440 => 
  - src/fs/proc/task_mmu.c: warning: passing argument 1 of 'kunmap' from incompatible pointer type: 639, 383, 480 => 
  - src/fs/udf/super.c: warning: 'map' may be used uninitialized in this function: 1157 => 
  - src/include/linux/ncp_fs_sb.h: warning: 'packed' attribute ignored for field of type '__u16': 112, 114, 111, 115, 113 => 
  - src/include/linux/ncp_fs_sb.h: warning: 'packed' attribute ignored for field of type '__u32': 109, 110 => 
  - src/include/linux/sysv_fs.h: warning: 'packed' attribute ignored for field of type '__fs32': 130, 181, 142, 114, 168, 42, 112, 180, 30, 144, 43, 100 => 
  - src/include/linux/sysv_fs.h: warning: 'packed' attribute ignored for field of type 'sysv_zone_t[64]': 171 => 
  - src/include/net/netlink.h: warning: 'len' is used uninitialized in this function: 647 => 
  - src/kernel/irq/handle.c: warning: #warning __do_IRQ is deprecated. Please convert to proper flow handlers: 125:3 => 
  - src/kernel/trace/trace_events.c: warning: enumeration value 'TRACE_REG_PERF_REGISTER' not handled in switch: 146 => 
  - src/kernel/trace/trace_events.c: warning: enumeration value 'TRACE_REG_PERF_UNREGISTER' not handled in switch: 146 => 
  - src/kernel/trace/trace_kprobe.c: warning: enumeration value 'TRACE_REG_PERF_REGISTER' not handled in switch: 1647 => 
  - src/kernel/trace/trace_kprobe.c: warning: enumeration value 'TRACE_REG_PERF_UNREGISTER' not handled in switch: 1647 => 
  - src/mm/fremap.c: warning: passing argument 1 of 'kunmap' from incompatible pointer type: 78 => 
  - src/mm/memory.c: warning: passing argument 1 of 'kunmap' from incompatible pointer type: 772, 1706, 1319, 3060, 1314, 1410, 1391, 770, 3426, 2788, 1403, 2047, 984, 2783, 1641, 2187, 2890, 2339, 3386, 3199, 1955, 1806, 2141, 3101, 2242, 1644, 2847, 1323 => 
  - src/mm/mincore.c: warning: passing argument 1 of 'kunmap' from incompatible pointer type: 144 => 
  - src/mm/mprotect.c: warning: passing argument 1 of 'kunmap' from incompatible pointer type: 78 => 
  - src/mm/mremap.c: warning: passing argument 1 of 'kunmap' from incompatible pointer type: 123, 122 => 
  - src/mm/pagewalk.c: warning: passing argument 1 of 'kunmap' from incompatible pointer type: 23 => 
  - src/mm/rmap.c: warning: passing argument 1 of 'kunmap' from incompatible pointer type: 712, 442, 1063, 531, 453, 1199, 478, 1068 => 
  - src/mm/swapfile.c: warning: passing argument 1 of 'kunmap' from incompatible pointer type: 951, 915, 944 => 
  - src/mm/vmalloc.c: warning: passing argument 1 of 'kunmap' from incompatible pointer type: 228 => 
  - src/net/dccp/ccids/ccid2.c: warning: 'veclen' may be used uninitialized in this function: 443 => 
  - src/net/dccp/ccids/ccid2.c: warning: 'vector' may be used uninitialized in this function: 442 => 
  - src/net/econet/af_econet.c: warning: label 'error' defined but not used: 494 => 
  - src/net/econet/af_econet.c: warning: unused variable 'sk': 268 => 
  - src/sound/soc/codecs/wm8350.c: warning: 'mask' may be used uninitialized in this function: 1343 => 
  - warning: (ATH5K && NETDEVICES && WLAN && ATH_COMMON && PCI && MAC80211 || ATH9K && NETDEVICES && WLAN && ATH_COMMON && PCI && MAC80211 || ATH9K_HTC && NETDEVICES && WLAN && ATH_COMMON && USB && MAC80211 || CARL9170_LEDS && NETDEVICES && WLAN && ATH_COMMON && CARL9170) selects MAC80211_LEDS which has unmet direct dependencies (NET && WIRELESS && MAC80211 && LEDS_CLASS): N/A => 
  - warning: (AX88796_93CX6 && NETDEVICES && NET_ETHERNET && AX88796 || RTL8180 && NETDEVICES && WLAN && MAC80211 && PCI && EXPERIMENTAL || RTL8187 && NETDEVICES && WLAN && MAC80211 && USB || ADM8211 && NETDEVICES && WLAN && MAC80211 && PCI && EXPERIMENTAL || RT2400PCI && NETDEVICES && WLAN && RT2X00 && PCI || RT2500PCI && NETDEVICES && WLAN && RT2X00 && PCI || RT61PCI && NETDEVICES && WLAN && RT2X00 && PCI || RT2800PCI && NETDEVICES && WLAN && RT2X00 && (RT2800PCI_PCI || RT2800PCI_SOC) && EXPERIMENTAL || R8187SE && STAGING && !STAGING_EXCLUDE_BUILD && PCI && WLAN) selects EEPROM_93CX6 which has unmet direct dependencies (MISC_DEVICES): N/A => 
  - warning: (CAVIUM_OCTEON_REFERENCE_BOARD && <choice> || BCM63XX_CPU_6338 && BCM63XX) selects USB_ARCH_HAS_OHCI which has unmet direct dependencies (USB_SUPPORT): N/A => 
  - warning: (CAVIUM_OCTEON_REFERENCE_BOARD && <choice>) selects USB_ARCH_HAS_EHCI which has unmet direct dependencies (USB_SUPPORT): N/A => 
  - warning: (COMPAT && SPARC64) selects COMPAT_BINFMT_ELF which has unmet direct dependencies (COMPAT && BINFMT_ELF): N/A => 
  - warning: (CRYPTO_LRW && CRYPTO && EXPERIMENTAL || CRYPTO_XTS && CRYPTO && EXPERIMENTAL || CRYPTO_GHASH && CRYPTO) selects CRYPTO_GF128MUL which has unmet direct dependencies (CRYPTO && EXPERIMENTAL): N/A => 
  - warning: (ETRAX_USB_HOST && ETRAX_ARCH_V10 || MOUSE_APPLETOUCH && !S390 && INPUT && INPUT_MOUSE && USB_ARCH_HAS_HCD || MOUSE_BCM5974 && !S390 && INPUT && INPUT_MOUSE && USB_ARCH_HAS_HCD || JOYSTICK_XPAD && !S390 && INPUT && INPUT_JOYSTICK && USB_ARCH_HAS_HCD || TABLET_USB_ACECAD && !S390 && INPUT && INPUT_TABLET && USB_ARCH_HAS_HCD || TABLET_USB_AIPTEK && !S390 && INPUT && INPUT_TABLET && USB_ARCH_HAS_HCD || TABLET_USB_HANWANG && !S390 && INPUT && INPUT_TABLET && USB_ARCH_HAS_HCD || TABLET_USB_KBTAB && !S390 && INPUT && INPUT_TABLET && USB_ARCH_HAS_HCD || TABLET_USB_WACOM && !S390 && INPUT && INPUT_TABLET && USB_ARCH_HAS_HCD || TOUCHSCREEN_USB_COMPOSITE && !S390 && INPUT && INPUT_TOUCHSCREEN && USB_ARCH_HAS_HCD || INPUT_ATI_REMOTE && !S390 && INPUT && INPUT_MISC && USB_ARCH_HAS_HCD || INPUT_ATI_REMOTE2 && !S390 && INPUT && INPUT_MISC && USB_ARCH_HAS_HCD || INPUT_KEYSPAN_REMOTE && !S390 && INPUT && INPUT_MISC && EXPERIMENTAL && USB_ARCH_HAS_HCD || INPUT_POWERMATE && !S390 && INPUT && INPUT_MISC && USB_ARCH_HAS_HCD || INPUT_YEALINK && !S390 && INPUT && INPUT_MISC && EXPERIMENTAL && USB_ARCH_HAS_HCD || INPUT_CM109 && !S390 && INPUT && INPUT_MISC && EXPERIMENTAL && USB_ARCH_HAS_HCD) selects USB which has unmet direct dependencies (USB_SUPPORT && USB_ARCH_HAS_HCD): N/A => 
  - warning: (LGUEST_GUEST && PARAVIRT_GUEST && X86_32 || VIRTIO_PCI && VIRTUALIZATION && PCI && EXPERIMENTAL || VIRTIO_BALLOON && VIRTUALIZATION) selects VIRTIO which has unmet direct dependencies (VIRTUALIZATION): N/A => 
  - warning: (LGUEST_GUEST && PARAVIRT_GUEST && X86_32 || VIRTIO_PCI && VIRTUALIZATION && PCI && EXPERIMENTAL || VIRTIO_BALLOON && VIRTUALIZATION) selects VIRTIO_RING which has unmet direct dependencies (VIRTUALIZATION && VIRTIO): N/A => 
  - warning: (LOCKDEP && DEBUG_KERNEL && TRACE_IRQFLAGS_SUPPORT && STACKTRACE_SUPPORT && LOCKDEP_SUPPORT && !MIPS && !PPC && !ARM_UNWIND && !S390 && !MICROBLAZE || FAULT_INJECTION_STACKTRACE_FILTER && FAULT_INJECTION_DEBUG_FS && STACKTRACE_SUPPORT && !X86_64 && !PPC && !S390 && !MICROBLAZE || LATENCYTOP && HAVE_LATENCYTOP_SUPPORT && DEBUG_KERNEL && STACKTRACE_SUPPORT && PROC_FS && !MIPS && !PPC && !S390 && !MICROBLAZE || DWARF_UNWINDER || FUNCTION_TRACER && TRACING_SUPPORT && FTRACE && HAVE_FUNCTION_TRACER && !ARM_UNWIND && !S390 || KMEMCHECK && HAVE_ARCH_KMEMCHECK && DEBUG_KERNEL && !X86_USE_3DNOW && (SLUB || SLAB) && !CC_OPTIMIZE_FOR_SIZE && !FUNCTION_TRACER) selects FRAME_POINTER which has unmet direct dependencies (DEBUG_KERNEL && (CRIS || M68K || M68KNOMMU || FRV || UML || AVR32 || SUPERH || BLACKFIN || MN10300) || ARCH_WANT_FRAME_POINTERS): N/A => 
  - warning: (LOCKDEP && DEBUG_KERNEL && TRACE_IRQFLAGS_SUPPORT && STACKTRACE_SUPPORT && LOCKDEP_SUPPORT && !MIPS && !PPC && !ARM_UNWIND && !S390 && !MICROBLAZE || FAULT_INJECTION_STACKTRACE_FILTER && FAULT_INJECTION_DEBUG_FS && STACKTRACE_SUPPORT && !X86_64 && !PPC && !S390 && !MICROBLAZE || LATENCYTOP && HAVE_LATENCYTOP_SUPPORT && DEBUG_KERNEL && STACKTRACE_SUPPORT && PROC_FS && !MIPS && !PPC && !S390 && !MICROBLAZE || FUNCTION_TRACER && TRACING_SUPPORT && FTRACE && HAVE_FUNCTION_TRACER && !ARM_UNWIND && !S390 || KMEMCHECK && HAVE_ARCH_KMEMCHECK && DEBUG_KERNEL && !X86_USE_3DNOW && (SLUB || SLAB) && !CC_OPTIMIZE_FOR_SIZE && !FUNCTION_TRACER) selects FRAME_POINTER which has unmet direct dependencies (DEBUG_KERNEL && (CRIS || M68K || M68KNOMMU || FRV || UML || AVR32 || SUPERH || BLACKFIN || MN10300) || ARCH_WANT_FRAME_POINTERS): N/A => 
  - warning: (MPC836x_RDK && PPC_83xx || MTD_NAND_FSL_ELBC && MTD && MTD_NAND && PPC_OF || MTD_NAND_FSL_UPM && MTD && MTD_NAND && (PPC_83xx || PPC_85xx)) selects FSL_LBC which has unmet direct dependencies (FSL_SOC): N/A => 
  - warning: (NETFILTER_XT_MATCH_REALM && NET && INET && NETFILTER && NETFILTER_XTABLES && NETFILTER_ADVANCED || NET_CLS_ROUTE4 && NET && NET_SCHED) selects NET_CLS_ROUTE which has unmet direct dependencies (NET && NET_SCHED): N/A => 
  - warning: (PAGE_POISONING && DEBUG_KERNEL && !ARCH_SUPPORTS_DEBUG_PAGEALLOC && !HIBERNATION) selects DEBUG_PAGEALLOC which has unmet direct dependencies (DEBUG_KERNEL && ARCH_SUPPORTS_DEBUG_PAGEALLOC && (!HIBERNATION || !PPC && !SPARC) && !KMEMCHECK): N/A => 
  - warning: (PARISC) selects GENERIC_HARDIRQS_NO__DO_IRQ which has unmet direct dependencies (HAVE_GENERIC_HARDIRQS): N/A => 
  - warning: (PERF_EVENTS && HAVE_PERF_EVENTS) selects IRQ_WORK which has unmet direct dependencies (HAVE_IRQ_WORK): N/A => 
  - warning: (PPC_C2K && EMBEDDED6xx || MTD_WRSBC8260 && MTD && (SBC82xx || SBC8560)) selects MTD_CFI_I4 which has unmet direct dependencies (MTD): N/A => 
  - warning: (RADIO_MIROPCM20 && MEDIA_SUPPORT && RADIO_ADAPTERS && ISA && VIDEO_V4L2 && SND) selects SND_ISA which has unmet direct dependencies (SOUND && !M68K && SND && ISA && ISA_DMA_API): N/A => 
  - warning: (USB_WUSB && USB_SUPPORT && EXPERIMENTAL && USB) selects UWB which has unmet direct dependencies (EXPERIMENTAL && PCI): N/A => 
  - warning: 1 bad relocations: N/A => 

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
