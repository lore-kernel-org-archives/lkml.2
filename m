Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759012Ab2EUTvJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 15:51:09 -0400
Received: from georges.telenet-ops.be ([195.130.137.68]:46729 "EHLO
	georges.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758263Ab2EUTvF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 15:51:05 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-kernel@vger.kernel.org
Subject: Build regressions/improvements in v3.4
Date: Mon, 21 May 2012 21:51:02 +0200
Message-Id: <1337629862-23393-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Below is the list of build error/warning regressions/improvements in
v3.4[1] compared to v3.3[2].

Too make this mail fit in the lkml limit, I deleted
  - 116 lines about __mcount_loc on sparc64
  - all warning improvements

Summarized:
  - build errors: +96/-78
  - build warnings: +362/-488

JFYI, when comparing v3.4 to v3.4-rc7[3], the summaries are:
  - build errors: +5/-14
  - build warnings: +109/-127

Note that there may be false regressions, as some logs are incomplete.
Still, they're build errors/warnings.

As I haven't set up kup yet, there's no verbose summary yet at
http://www.kernel.org/pub/linux/kernel/people/geert/linux-log/v3.4.summary.gz

Happy fixing! ;-)

Thanks to the linux-next team for providing the build service.

[1] http://kisskb.ellerman.id.au/kisskb/head/5055/ (115 out of 116 configs)
[2] http://kisskb.ellerman.id.au/kisskb/head/4840/ (all 116 configs)
[3] http://kisskb.ellerman.id.au/kisskb/head/5036/ (115 out of 116 configs)


*** ERRORS ***

96 regressions:
  + arch/um/drivers/cow_user.c: error: implicit declaration of function 'be32toh':  => 303
  + arch/um/drivers/cow_user.c: error: implicit declaration of function 'be64toh':  => 330
  + arch/um/drivers/cow_user.c: error: implicit declaration of function 'htobe32':  => 216
  + arch/um/drivers/cow_user.c: error: implicit declaration of function 'htobe64':  => 249
  + drivers/block/rbd.c: error: implicit declaration of function 'ATOMIC64_INIT' [-Werror=implicit-function-declaration]:  => 2186:1
  + drivers/block/rbd.c: error: implicit declaration of function 'atomic64_cmpxchg' [-Werror=implicit-function-declaration]:  => 2246:2
  + drivers/block/rbd.c: error: implicit declaration of function 'atomic64_inc_return' [-Werror=implicit-function-declaration]:  => 2194:2
  + drivers/block/rbd.c: error: implicit declaration of function 'atomic64_read' [-Werror=implicit-function-declaration]:  => 2220:2
  + drivers/block/rbd.c: error: initializer element is not constant:  => 2186:1
  + drivers/block/rbd.c: error: unknown type name 'atomic64_t':  => 2186:1
  + drivers/media/rc/gpio-ir-recv.c: error: implicit declaration of function 'gpio_direction_input' [-Werror=implicit-function-declaration]:  => 99:2
  + drivers/media/rc/gpio-ir-recv.c: error: implicit declaration of function 'gpio_free' [-Werror=implicit-function-declaration]:  => 125:2
  + drivers/media/rc/gpio-ir-recv.c: error: implicit declaration of function 'gpio_request' [-Werror=implicit-function-declaration]:  => 96:2
  + drivers/media/rc/gpio-ir-recv.c: error: implicit declaration of function 'gpio_to_irq' [-Werror=implicit-function-declaration]:  => 111:2
  + drivers/mmc/core/cd-gpio.c: error: implicit declaration of function 'gpio_to_irq' [-Werror=implicit-function-declaration]:  => 36:2
  + drivers/net/can/sja1000/peak_pcmcia.c: error: implicit declaration of function 'ioport_map' [-Werror=implicit-function-declaration]:  => 672:2
  + drivers/net/can/sja1000/peak_pcmcia.c: error: implicit declaration of function 'ioport_unmap' [-Werror=implicit-function-declaration]:  => 626:2
  + drivers/net/can/sja1000/peak_pcmcia.c: error: implicit declaration of function 'ioread8' [-Werror=implicit-function-declaration]:  => 187:2
  + drivers/net/can/sja1000/peak_pcmcia.c: error: implicit declaration of function 'iowrite8' [-Werror=implicit-function-declaration]:  => 214:2
  + drivers/net/ethernet/realtek/r8169.c: error: implicit declaration of function 'mmiowb' [-Werror=implicit-function-declaration]:  => 1207:2
  + drivers/net/wireless/iwlegacy/common.h: error: implicit declaration of function 'mmiowb' [-Werror=implicit-function-declaration]:  => 2034:2
  + drivers/net/wireless/iwlwifi/iwl-io.c: error: implicit declaration of function 'mmiowb' [-Werror=implicit-function-declaration]:  => 145:2
  + drivers/net/wireless/iwlwifi/iwl-testmode.c: error: implicit declaration of function 'mmiowb' [-Werror=implicit-function-declaration]:  => 839:5
  + drivers/pci/quirks.c: error: implicit declaration of function 'pci_iomap' [-Werror=implicit-function-declaration]:  => 2901:2
  + drivers/pci/quirks.c: error: implicit declaration of function 'pci_iounmap' [-Werror=implicit-function-declaration]:  => 2915:2
  + drivers/power/smb347-charger.c: error: implicit declaration of function 'gpio_free' [-Werror=implicit-function-declaration]:  => 939:2
  + drivers/power/smb347-charger.c: error: implicit declaration of function 'gpio_request_one' [-Werror=implicit-function-declaration]:  => 897:2
  + drivers/power/smb347-charger.c: error: implicit declaration of function 'gpio_to_irq' [-Werror=implicit-function-declaration]:  => 895:2
  + drivers/ptp/ptp_pch.c: error: implicit declaration of function 'ioread32' [-Werror=implicit-function-declaration]:  => 153:2
  + drivers/ptp/ptp_pch.c: error: implicit declaration of function 'iowrite32' [-Werror=implicit-function-declaration]:  => 154:2
  + drivers/regulator/tps62360-regulator.c: error: implicit declaration of function 'gpio_direction_output' [-Werror=implicit-function-declaration]:  => 336:3
  + drivers/regulator/tps62360-regulator.c: error: implicit declaration of function 'gpio_free' [-Werror=implicit-function-declaration]:  => 341:4
  + drivers/regulator/tps62360-regulator.c: error: implicit declaration of function 'gpio_request' [-Werror=implicit-function-declaration]:  => 329:3
  + drivers/staging/xgifb/../../video/sis/vstruct.h: error: expected identifier or '(' before numeric constant:  => 135:16
  + drivers/usb/gadget/pch_udc.c: error: implicit declaration of function 'gpio_direction_input' [-Werror=implicit-function-declaration]:  => 1401:2
  + drivers/usb/gadget/pch_udc.c: error: implicit declaration of function 'gpio_free' [-Werror=implicit-function-declaration]:  => 1432:3
  + drivers/usb/gadget/pch_udc.c: error: implicit declaration of function 'gpio_get_value' [-Werror=implicit-function-declaration]:  => 1267:3
  + drivers/usb/gadget/pch_udc.c: error: implicit declaration of function 'gpio_request' [-Werror=implicit-function-declaration]:  => 1393:2
  + drivers/usb/gadget/pch_udc.c: error: implicit declaration of function 'gpio_to_irq' [-Werror=implicit-function-declaration]:  => 1404:2
  + drivers/video/i740fb.c: error: implicit declaration of function 'pci_iounmap' [-Werror=implicit-function-declaration]:  => 1165:2
  + error: arch/xtensa/platforms/iss/built-in.o: undefined reference to `__netif_schedule':  => .text+0x48)
  + error: arch/xtensa/platforms/iss/built-in.o: undefined reference to `alloc_etherdev_mqs':  => .text+0x11c)
  + error: arch/xtensa/platforms/iss/built-in.o: undefined reference to `consume_skb':  => .text+0x4c)
  + error: arch/xtensa/platforms/iss/built-in.o: undefined reference to `dev_alloc_skb':  => .text+0x60)
  + error: arch/xtensa/platforms/iss/built-in.o: undefined reference to `dev_close':  => .text+0x84)
  + error: arch/xtensa/platforms/iss/built-in.o: undefined reference to `eth_type_trans':  => .text+0xac)
  + error: arch/xtensa/platforms/iss/built-in.o: undefined reference to `eth_validate_addr':  => .rodata+0x114)
  + error: arch/xtensa/platforms/iss/built-in.o: undefined reference to `free_netdev':  => .text+0x134)
  + error: arch/xtensa/platforms/iss/built-in.o: undefined reference to `kfree_skb':  => .text+0x70)
  + error: arch/xtensa/platforms/iss/built-in.o: undefined reference to `netif_rx_ni':  => .text+0x6c)
  + error: arch/xtensa/platforms/iss/built-in.o: undefined reference to `register_netdevice':  => .text+0x12c)
  + error: arch/xtensa/platforms/iss/built-in.o: undefined reference to `rtnl_lock':  => .text+0x128)
  + error: arch/xtensa/platforms/iss/built-in.o: undefined reference to `rtnl_unlock':  => .text+0x130)
  + error: arch/xtensa/platforms/iss/built-in.o: undefined reference to `skb_put':  => .text+0x64)
  + error: arch/xtensa/platforms/iss/built-in.o: undefined reference to `skb_trim':  => .text+0x68)
  + error: kernel/built-in.o: undefined reference to `_sdata':  => .text+0x8c0), .text+0x84c)
  + error: network.c: undefined reference to `__netif_schedule':  => .text+0x3d7)
  + error: network.c: undefined reference to `alloc_etherdev_mqs':  => .text+0x8c8)
  + error: network.c: undefined reference to `consume_skb':  => .text+0x42e)
  + error: network.c: undefined reference to `dev_alloc_skb':  => .text+0x4c8)
  + error: network.c: undefined reference to `dev_close':  => .text+0x683)
  + error: network.c: undefined reference to `eth_type_trans':  => .text+0x7db)
  + error: network.c: undefined reference to `free_netdev':  => .text+0xad2)
  + error: network.c: undefined reference to `kfree_skb':  => .text+0x548)
  + error: network.c: undefined reference to `netif_rx_ni':  => .text+0x53e)
  + error: network.c: undefined reference to `register_netdevice':  => .text+0xab7)
  + error: network.c: undefined reference to `rtnl_lock':  => .text+0xaaf)
  + error: network.c: undefined reference to `rtnl_unlock':  => .text+0xabf)
  + error: network.c: undefined reference to `skb_put':  => .text+0x507)
  + error: network.c: undefined reference to `skb_trim':  => .text+0x514)
  + error: via-pmu-event.c: undefined reference to `.input_allocate_device':  => .init.text+0x8aa4)
  + error: via-pmu-event.c: undefined reference to `.input_free_device':  => .init.text+0x8b68)
  + error: via-pmu-event.c: undefined reference to `.input_register_device':  => .init.text+0x8b54)
  + include/linux/types.h: error: unknown type name '__kernel_caddr_t':  => 88:1
  + include/linux/types.h: error: unknown type name '__kernel_clock_t':  => 83:1
  + include/linux/types.h: error: unknown type name '__kernel_clockid_t':  => 35:1
  + include/linux/types.h: error: unknown type name '__kernel_daddr_t':  => 242:2, 31:1
  + include/linux/types.h: error: unknown type name '__kernel_gid16_t':  => 43:1
  + include/linux/types.h: error: unknown type name '__kernel_gid32_t':  => 41:1
  + include/linux/types.h: error: unknown type name '__kernel_ino_t':  => 25:1, 243:2
  + include/linux/types.h: error: unknown type name '__kernel_loff_t':  => 54:1
  + include/linux/types.h: error: unknown type name '__kernel_off_t':  => 29:1
  + include/linux/types.h: error: unknown type name '__kernel_old_gid_t':  => 50:1
  + include/linux/types.h: error: unknown type name '__kernel_old_uid_t':  => 49:1
  + include/linux/types.h: error: unknown type name '__kernel_pid_t':  => 30:1
  + include/linux/types.h: error: unknown type name '__kernel_suseconds_t':  => 33:1
  + include/linux/types.h: error: unknown type name '__kernel_time_t':  => 78:1
  + include/linux/types.h: error: unknown type name '__kernel_timer_t':  => 34:1
  + include/linux/types.h: error: unknown type name '__kernel_uid16_t':  => 42:1
  + include/linux/types.h: error: unknown type name '__kernel_uid32_t':  => 40:1
  + kernel/fork.c: error: implicit declaration of function 'alloc_task_struct_node' [-Werror=implicit-function-declaration]:  => 266:2
  + kernel/fork.c: error: implicit declaration of function 'free_task_struct' [-Werror=implicit-function-declaration]:  => 174:2
  + sound/soc/codecs/max9768.c: error: implicit declaration of function 'gpio_free' [-Werror=implicit-function-declaration]:  => 206:3
  + sound/soc/codecs/max9768.c: error: implicit declaration of function 'gpio_request_one' [-Werror=implicit-function-declaration]:  => 175:3
  + sound/soc/codecs/wm2200.c: error: implicit declaration of function 'gpio_free' [-Werror=implicit-function-declaration]:  => 2169:3
  + sound/soc/codecs/wm2200.c: error: implicit declaration of function 'gpio_request_one' [-Werror=implicit-function-declaration]:  => 2046:3

78 improvements:
  - arch/cris/arch-v10/kernel/kgdb.c: error: expected string literal before '.' token: 1274:3 => 
  - arch/cris/arch-v10/kernel/kgdb.c: error: missing terminating " character: 1359:1, 1370:1, 1273:1, 1457:1 => 
  - arch/frv/kernel/head.S: Error: operand out of range (0xffff31ff not between 0 and 0xffff) `sethi.p %hi(~(0x80000000|0x40000000|0x08000000|0x0...': 52 => 
  - arch/h8300/include/asm/irqflags.h: error: unknown type name 'bool': 38:1, 33:1 => 
  - arch/xtensa/include/asm/irqflags.h: Error: invalid symbolic operand: 26 => 
  - drivers/block/hd.c: error: implicit declaration of function 'inb_p' [-Werror=implicit-function-declaration]: 257:2 => 
  - drivers/block/hd.c: error: implicit declaration of function 'outb_p' [-Werror=implicit-function-declaration]: 298:3 => 
  - drivers/block/paride/bpck.c: error: invalid operands to binary & (have 'void *' and 'int'): 62:140, 56:140 => 
  - drivers/block/paride/epia.c: error: invalid operands to binary & (have 'void *' and 'int'): 63:502 => 
  - drivers/block/paride/epia.c: error: invalid operands to binary | (have 'void *' and 'int'): 64:502 => 
  - drivers/block/paride/kbic.c: error: invalid operands to binary | (have 'void *' and 'int'): 85:142, 61:142, 91:142, 53:142, 67:142, 57:142 => 
  - drivers/char/ipmi/ipmi_si_intf.c: error: invalid operands to binary << (have 'void *' and 'int'): 1392:153, 1407:151 => 
  - drivers/char/tpm/tpm.h: error: invalid operands to binary & (have 'void *' and 'int'): 142:131 => 
  - drivers/char/tpm/tpm_tis.c: error: implicit declaration of function 'ioread32' [-Werror=implicit-function-declaration]: 457:2 => 
  - drivers/char/tpm/tpm_tis.c: error: implicit declaration of function 'ioread8' [-Werror=implicit-function-declaration]: 103:2 => 
  - drivers/char/tpm/tpm_tis.c: error: implicit declaration of function 'iowrite32' [-Werror=implicit-function-declaration]: 466:2 => 
  - drivers/char/tpm/tpm_tis.c: error: implicit declaration of function 'iowrite8' [-Werror=implicit-function-declaration]: 116:3 => 
  - drivers/hwmon/gpio-fan.c: error: implicit declaration of function 'gpio_direction_input' [-Werror=implicit-function-declaration]: 102:2 => 
  - drivers/hwmon/gpio-fan.c: error: implicit declaration of function 'gpio_direction_output' [-Werror=implicit-function-declaration]: 372:3 => 
  - drivers/hwmon/gpio-fan.c: error: implicit declaration of function 'gpio_free' [-Werror=implicit-function-declaration]: 130:2 => 
  - drivers/hwmon/gpio-fan.c: error: implicit declaration of function 'gpio_get_value' [-Werror=implicit-function-declaration]: 79:2 => 
  - drivers/hwmon/gpio-fan.c: error: implicit declaration of function 'gpio_request' [-Werror=implicit-function-declaration]: 98:2 => 
  - drivers/hwmon/gpio-fan.c: error: implicit declaration of function 'gpio_set_value' [-Werror=implicit-function-declaration]: 156:3 => 
  - drivers/hwmon/gpio-fan.c: error: implicit declaration of function 'gpio_to_irq' [-Werror=implicit-function-declaration]: 114:2 => 
  - drivers/hwmon/sht15.c: error: implicit declaration of function 'gpio_direction_input' [-Werror=implicit-function-declaration]: 293:2 => 
  - drivers/hwmon/sht15.c: error: implicit declaration of function 'gpio_direction_output' [-Werror=implicit-function-declaration]: 216:2 => 
  - drivers/hwmon/sht15.c: error: implicit declaration of function 'gpio_free' [-Werror=implicit-function-declaration]: 1000:2 => 
  - drivers/hwmon/sht15.c: error: implicit declaration of function 'gpio_get_value' [-Werror=implicit-function-declaration]: 296:2 => 
  - drivers/hwmon/sht15.c: error: implicit declaration of function 'gpio_request' [-Werror=implicit-function-declaration]: 946:2 => 
  - drivers/hwmon/sht15.c: error: implicit declaration of function 'gpio_set_value' [-Werror=implicit-function-declaration]: 218:2 => 
  - drivers/hwmon/sht15.c: error: implicit declaration of function 'gpio_to_irq' [-Werror=implicit-function-declaration]: 514:2 => 
  - drivers/input/gameport/lightning.c: error: invalid operands to binary & (have 'void *' and 'int'): 177:136, 141:136, 86:133 => 
  - drivers/input/gameport/ns558.c: error: invalid operands to binary & (have 'void *' and 'int'): 84:124 => 
  - drivers/input/touchscreen/mk712.c: error: invalid operands to binary | (have 'void *' and 'int'): 129:136 => 
  - drivers/net/cris/eth_v10.c: error: too many arguments to function 'e100rxtx_interrupt': 1717:2 => 
  - drivers/net/ethernet/dlink/de620.c: error: invalid operands to binary ^ (have 'void *' and 'int'): 267:147, 372:147, 396:147 => 
  - drivers/net/ethernet/seeq/seeq8005.c: error: invalid operands to binary >> (have 'void *' and 'int'): 545:161 => 
  - drivers/net/ethernet/seeq/seeq8005.c: error: invalid operands to binary | (have 'void *' and 'int'): 706:140, 662:139, 701:138, 674:138, 544:140, 723:138, 503:139, 323:139, 439:139, 641:138, 469:140, 221:138, 462:140, 673:142, 672:142 => 
  - drivers/net/hamradio/baycom_ser_fdx.c: error: invalid operands to binary >> (have 'void *' and 'int'): 189:152 => 
  - drivers/net/hamradio/baycom_ser_fdx.c: error: invalid operands to binary | (have 'void *' and 'int'): 329:145, 388:132 => 
  - drivers/net/hamradio/baycom_ser_hdx.c: error: invalid operands to binary | (have 'void *' and 'int'): 447:132, 209:142 => 
  - drivers/net/hamradio/yam.c: error: invalid operands to binary ^ (have 'void *' and 'int'): 715:159 => 
  - drivers/net/hamradio/yam.c: error: invalid operands to binary | (have 'void *' and 'int'): 318:134, 337:134, 483:142, 519:132, 321:134, 310:134 => 
  - drivers/net/wireless/iwlegacy/3945-mac.c: error: implicit declaration of function 'pci_iomap' [-Werror=implicit-function-declaration]: 3691:2 => 
  - drivers/net/wireless/iwlegacy/3945-mac.c: error: implicit declaration of function 'pci_iounmap' [-Werror=implicit-function-declaration]: 3817:2 => 
  - drivers/net/wireless/iwlegacy/4965-mac.c: error: implicit declaration of function 'pci_iomap' [-Werror=implicit-function-declaration]: 6202:2 => 
  - drivers/net/wireless/iwlegacy/4965-mac.c: error: implicit declaration of function 'pci_iounmap' [-Werror=implicit-function-declaration]: 6337:2 => 
  - drivers/net/wireless/iwlegacy/common.h: error: implicit declaration of function 'ioread32' [-Werror=implicit-function-declaration]: 2193:2 => 
  - drivers/net/wireless/iwlegacy/common.h: error: implicit declaration of function 'iowrite32' [-Werror=implicit-function-declaration]: 2187:2 => 
  - drivers/net/wireless/iwlegacy/common.h: error: implicit declaration of function 'iowrite8' [-Werror=implicit-function-declaration]: 2180:2 => 
  - drivers/net/wireless/iwlwifi/iwl-pci.c: error: implicit declaration of function 'ioread32' [-Werror=implicit-function-declaration]: 166:2 => 
  - drivers/net/wireless/iwlwifi/iwl-pci.c: error: implicit declaration of function 'iowrite32' [-Werror=implicit-function-declaration]: 161:2 => 
  - drivers/net/wireless/iwlwifi/iwl-pci.c: error: implicit declaration of function 'iowrite8' [-Werror=implicit-function-declaration]: 156:2 => 
  - drivers/net/wireless/iwlwifi/iwl-pci.c: error: implicit declaration of function 'pci_iomap' [-Werror=implicit-function-declaration]: 420:2 => 
  - drivers/net/wireless/iwlwifi/iwl-pci.c: error: implicit declaration of function 'pci_iounmap' [-Werror=implicit-function-declaration]: 464:2 => 
  - drivers/regulator/bq24022.c: error: implicit declaration of function 'gpio_direction_output' [-Werror=implicit-function-declaration]: 106:2 => 
  - drivers/regulator/bq24022.c: error: implicit declaration of function 'gpio_free' [-Werror=implicit-function-declaration]: 121:2 => 
  - drivers/regulator/bq24022.c: error: implicit declaration of function 'gpio_get_value' [-Werror=implicit-function-declaration]: 40:2 => 
  - drivers/regulator/bq24022.c: error: implicit declaration of function 'gpio_request' [-Werror=implicit-function-declaration]: 94:2 => 
  - drivers/regulator/bq24022.c: error: implicit declaration of function 'gpio_set_value' [-Werror=implicit-function-declaration]: 32:2 => 
  - drivers/staging/speakup/serialio.c: error: invalid operands to binary & (have 'void *' and 'int'): 53:137 => 
  - drivers/staging/speakup/serialio.c: error: invalid operands to binary >> (have 'void *' and 'int'): 54:137 => 
  - drivers/staging/speakup/serialio.c: error: invalid operands to binary | (have 'void *' and 'int'): 59:137, 108:149, 52:137, 111:148 => 
  - drivers/staging/speakup/speakup_apollo.c: error: invalid operands to binary | (have 'void *' and 'int'): 177:151 => 
  - drivers/staging/xgifb/vb_struct.h: error: expected identifier or '(' before numeric constant: 56:16 => 
  - drivers/video/console/fonts.c: error: #error No fonts configured.: 71:2 => 
  - error: "__ashldi3" [drivers/mtd/nand/nand.ko] undefined!: N/A => 
  - error: "__ashldi3" [fs/fat/fat.ko] undefined!: N/A => 
  - error: "__ashldi3" [fs/xfs/xfs.ko] undefined!: N/A => 
  - fs/xfs/xfs_log_priv.h: error: unknown type name 'atomic64_t': 533:2, 529:2, 521:2, 580:23, 519:2, 622:24, 610:23, 592:24 => 529:2, 479:2, 580:23, 622:24, 610:23, 592:24, 531:2
  - include/linux/prefetch.h: Error: couldn't find a valid instruction format: 62 => 
  - include/linux/prefetch.h: Error: unknown opcode or format name 'static': 53 => 
  - net/mac80211/ieee80211_i.h: error: field 'trig' has incomplete type: 707:21 => 
  - net/mac80211/led.c: error: 'struct led_classdev' has no member named 'trig_list': 278:411, 278:352, 278:59, 214:352, 214:411, 214:160, 278:319, 214:223, 214:319, 278:160, 214:59, 278:223 => 
  - net/mac80211/led.c: error: dereferencing pointer to incomplete type: 74:16, 83:16, 101:19, 92:19 => 
  - net/mac80211/led.c: error: implicit declaration of function 'led_trigger_register' [-Werror=implicit-function-declaration]: 75:3 => 
  - net/mac80211/led.c: error: implicit declaration of function 'led_trigger_unregister' [-Werror=implicit-function-declaration]: 119:3 => 
  - net/mac80211/led.c: error: invalid application of 'sizeof' to incomplete type 'struct led_trigger' : 90:36, 72:33, 99:36, 81:33 => 


*** WARNINGS ***

362 regressions:
  + .config: warning: override: SPARSEMEM_MANUAL changes choice state:  => 288
  + arch/m32r/include/asm/ptrace.h: warning: "PTRACE_O_TRACESYSGOOD" redefined [enabled by default]:  => 117:0
  + arch/powerpc/include/asm/swab.h: warning: 'type' may be used uninitialized in this function [-Wuninitialized]:  => 77:2
  + arch/powerpc/kvm/book3s_emulate.c: warning: 'bat' may be used uninitialized in this function [-Wuninitialized]:  => 313:2
  + arch/powerpc/kvm/powerpc.c: warning: 'r' may be used uninitialized in this function [-Wuninitialized]:  => 149:2
  + arch/x86/kernel/apic/io_apic.c: warning: 'io_apic_level_ack_pending' defined but not used [-Wunused-function]:  => 382:13
  + arch/x86/kernel/cpu/intel_cacheinfo.c: warning: 'this_leaf.eax.split.num_threads_sharing' may be used uninitialized in this function [-Wuninitialized]:  => 622:30
  + arch/x86/kernel/cpu/intel_cacheinfo.c: warning: 'this_leaf.size' may be used uninitialized in this function [-Wuninitialized]:  => 621:13
  + drivers/ata/pata_arasan_cf.c: warning: 'arasan_cf_resume' defined but not used [-Wunused-function]:  => 936:12
  + drivers/ata/pata_arasan_cf.c: warning: 'arasan_cf_suspend' defined but not used [-Wunused-function]:  => 923:12
  + drivers/base/regmap/regmap.c: warning: 'ret' may be used uninitialized in this function [-Wuninitialized]:  => 744:2
  + drivers/char/ipmi/ipmi_msghandler.c: warning: 'lun' may be used uninitialized in this function [-Wuninitialized]:  => 1859:23, 1891:23
  + drivers/char/ipmi/ipmi_msghandler.c: warning: 'saddr' may be used uninitialized in this function [-Wuninitialized]:  => 1859:23, 1891:23
  + drivers/char/rtc.c: warning: 'rtc_freq' defined but not used [-Wunused-variable]:  => 192:22
  + drivers/dma/fsldma.c: warning: 'cookie' may be used uninitialized in this function [-Wuninitialized]:  => 426:2
  + drivers/gpu/drm/i915/i915_debugfs.c: warning: array subscript is above array bounds [-Warray-bounds]:  => 712:12, 711:12, 709:12, 713:12, 710:12, 708:12
  + drivers/gpu/drm/i915/i915_gem.c: warning: 'ret' may be used uninitialized in this function [-Wuninitialized]:  => 797:38, 390:38
  + drivers/gpu/drm/nouveau/nouveau_fbcon.c: warning: passing argument 1 of 'vga_switcheroo_client_fb_set' from incompatible pointer type [enabled by default]:  => 410:2
  + drivers/gpu/drm/nouveau/nv50_pm.c: warning: 'M' may be used uninitialized in this function [-Wuninitialized]:  => 136:5
  + drivers/gpu/drm/nouveau/nv50_pm.c: warning: 'N' may be used uninitialized in this function [-Wuninitialized]:  => 137:15
  + drivers/gpu/drm/nouveau/nv50_pm.c: warning: 'P' may be used uninitialized in this function [-Wuninitialized]:  => 137:3
  + drivers/gpu/drm/nouveau/nvd0_display.c: warning: 'or_config' may be used uninitialized in this function [-Wuninitialized]:  => 1543:15
  + drivers/gpu/drm/radeon/ni.c: warning: 'chip_name' may be used uninitialized in this function [-Wuninitialized]:  => 386:11
  + drivers/gpu/drm/radeon/ni.c: warning: 'mc_req_size' may be used uninitialized in this function [-Wuninitialized]:  => 390:6
  + drivers/gpu/drm/radeon/ni.c: warning: 'me_req_size' may be used uninitialized in this function [-Wuninitialized]:  => 366:5
  + drivers/gpu/drm/radeon/ni.c: warning: 'pfp_req_size' may be used uninitialized in this function [-Wuninitialized]:  => 354:5
  + drivers/gpu/drm/radeon/ni.c: warning: 'rlc_chip_name' may be used uninitialized in this function [-Wuninitialized]:  => 373:10
  + drivers/gpu/drm/radeon/ni.c: warning: 'rlc_req_size' may be used uninitialized in this function [-Wuninitialized]:  => 377:5
  + drivers/gpu/drm/radeon/r600.c: warning: 'chip_name' may be used uninitialized in this function [-Wuninitialized]:  => 2064:10
  + drivers/gpu/drm/radeon/r600.c: warning: 'rlc_chip_name' may be used uninitialized in this function [-Wuninitialized]:  => 2075:10
  + drivers/gpu/drm/radeon/si.c: warning: 'chip_name' may be used uninitialized in this function [-Wuninitialized]:  => 375:10
  + drivers/gpu/drm/radeon/si.c: warning: 'rlc_chip_name' may be used uninitialized in this function [-Wuninitialized]:  => 364:10
  + drivers/i2c/busses/i2c-cpm.c: warning: passing argument 3 of 'dma_alloc_attrs' from incompatible pointer type [enabled by default]:  => 543:3, 534:3
  + drivers/ide/pmac.c: warning: 'cycleTime' may be used uninitialized in this function [-Wuninitialized]:  => 670:109
  + drivers/media/dvb/dvb-usb/mxl111sf.c: warning: unused variable 'tmp' [-Wunused-variable]:  => 343:5
  + drivers/media/video/uvc/uvc_v4l2.c: warning: ignoring return value of '__clear_user', declared with attribute warn_unused_result [-Wunused-result]:  => 1100:14
  + drivers/mfd/rc5t583-irq.c: warning: 'master_int' may be used uninitialized in this function [-Wuninitialized]:  => 276:20
  + drivers/mfd/rc5t583.c: warning: 'sleepseq_val' may be used uninitialized in this function [-Wuninitialized]:  => 105:15
  + drivers/mfd/s5m-core.c: warning: 'ret' may be used uninitialized in this function [-Wuninitialized]:  => 153:5
  + drivers/mfd/twl6030-irq.c: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]: 376:24, 394:9 => 398:24, 415:9, 415:81
  + drivers/mfd/wm8994-core.c: warning: 'patch_regs' may be used uninitialized in this function [-Wuninitialized]:  => 582:7
  + drivers/misc/ics932s401.c: warning: 'x' may be used uninitialized in this function [-Wuninitialized]: 384:2 => 384:2, 384:16
  + drivers/misc/vmw_balloon.c: warning: 'target' may be used uninitialized in this function [-Wuninitialized]:  => 672:32
  + drivers/mmc/core/bus.c: warning: 'mmc_bus_resume' defined but not used [-Wunused-function]:  => 136:12
  + drivers/mmc/core/bus.c: warning: 'mmc_bus_suspend' defined but not used [-Wunused-function]:  => 125:12
  + drivers/mmc/core/sdio_bus.c: warning: 'pm_no_operation' defined but not used [-Wunused-function]:  => 197:12
  + drivers/mtd/chips/cfi_cmdset_0001.c: warning: the frame size of 1452 bytes is larger than 1024 bytes [-Wframe-larger-than=]:  => 1797:1
  + drivers/mtd/chips/cfi_cmdset_0002.c: warning: 'r.x[0]' may be used uninitialized in this function [-Wuninitialized]: 647:2, 1421:9, 1360:7 => 1350:7, 1773:7, 651:2, 1390:93, 1412:15
  + drivers/mtd/chips/cfi_cmdset_0020.c: warning: the frame size of 1064 bytes is larger than 1024 bytes [-Wframe-larger-than=]:  => 1180:1
  + drivers/mtd/chips/cfi_cmdset_0020.c: warning: the frame size of 1356 bytes is larger than 1024 bytes [-Wframe-larger-than=]:  => 975:1
  + drivers/mtd/chips/cfi_cmdset_0020.c: warning: the frame size of 1440 bytes is larger than 1024 bytes [-Wframe-larger-than=]:  => 420:1
  + drivers/mtd/chips/cfi_cmdset_0020.c: warning: the frame size of 1704 bytes is larger than 1024 bytes [-Wframe-larger-than=]:  => 975:1
  + drivers/mtd/chips/cfi_cmdset_0020.c: warning: the frame size of 1788 bytes is larger than 1024 bytes [-Wframe-larger-than=]:  => 975:1
  + drivers/mtd/maps/latch-addr-flash.c: warning: 'r.x[0]' may be used uninitialized in this function [-Wuninitialized]:  => 53:2
  + drivers/net/can/sja1000/peak_pcmcia.c: warning: assignment makes pointer from integer without a cast [enabled by default]:  => 672:20
  + drivers/net/ethernet/pasemi/pasemi_mac.c: warning: passing argument 1 of 'netdev_alloc_skb' discards 'const' qualifier from pointer target type [enabled by default]:  => 646:3
  + drivers/net/wireless/ath/carl9170/mac.c: warning: 'power' may be used uninitialized in this function [-Wuninitialized]:  => 509:10
  + drivers/net/wireless/iwlwifi/iwl-devtrace.h: warning: 'struct device' declared inside parameter list [enabled by default]:  => 50:16, 67:16, 309:16, 263:16, 154:16, 101:16, 84:16, 114:16, 238:16, 134:16, 369:16, 278:16
  + drivers/net/wireless/iwlwifi/iwl-devtrace.h: warning: its scope is only this definition or declaration, which is probably not what you want [enabled by default]:  => 50:16
  + drivers/net/wireless/iwlwifi/iwl-io.h: warning: passing argument 1 of 'trace_iwlwifi_dev_ioread32' from incompatible pointer type [enabled by default]:  => 51:2
  + drivers/net/wireless/iwlwifi/iwl-io.h: warning: passing argument 1 of 'trace_iwlwifi_dev_iowrite32' from incompatible pointer type [enabled by default]:  => 44:2
  + drivers/net/wireless/iwlwifi/iwl-io.h: warning: passing argument 1 of 'trace_iwlwifi_dev_iowrite8' from incompatible pointer type [enabled by default]:  => 38:2
  + drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c: warning: passing argument 1 of 'trace_iwlwifi_dev_ict_read' from incompatible pointer type [enabled by default]:  => 1364:2, 1384:9
  + drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c: warning: passing argument 1 of 'trace_iwlwifi_dev_irq' from incompatible pointer type [enabled by default]:  => 1347:2, 1257:2
  + drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c: warning: passing argument 1 of 'trace_iwlwifi_dev_rx' from incompatible pointer type [enabled by default]:  => 391:2
  + drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c: warning: passing argument 1 of 'trace_iwlwifi_dev_ucode_error' from incompatible pointer type [enabled by default]:  => 633:11
  + drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c: warning: passing argument 1 of 'trace_iwlwifi_dev_ucode_event' from incompatible pointer type [enabled by default]:  => 775:6, 761:6
  + drivers/pci/quirks.c: warning: initialization makes pointer from integer without a cast [enabled by default]:  => 2901:15
  + drivers/scsi/mvsas/mv_sas.c: warning: unused variable 'dev' [-Wunused-variable]:  => 888:24
  + drivers/staging/android/alarm.c: warning: format '%ld' expects argument of type 'long int', but argument 2 has type 'int' [-Wformat]:  => 367:3, 344:2, 345:2
  + drivers/staging/android/persistent_ram.c: warning: format '%ld' expects argument of type 'long int', but argument 2 has type 'size_t' [-Wformat]:  => 430:4, 426:4
  + drivers/staging/android/persistent_ram.c: warning: format '%ld' expects argument of type 'long int', but argument 3 has type 'size_t' [-Wformat]:  => 430:4, 426:4
  + drivers/staging/ramster/zcache-main.c: warning: 'page' may be used uninitialized in this function [-Wuninitialized]:  => 1554:13
  + drivers/staging/ramster/zcache-main.c: warning: 'ramster_remotify_init' defined but not used [-Wunused-function]:  => 1002:13
  + drivers/staging/ramster/zcache-main.c: warning: 'zcache_do_remotify_ops' defined but not used [-Wunused-function]:  => 913:13
  + drivers/staging/telephony/ixj.c: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]:  => 7535:64, 7525:63
  + drivers/staging/vt6656/main_usb.c: warning: the frame size of 1284 bytes is larger than 1024 bytes [-Wframe-larger-than=]:  => 2056:1
  + drivers/staging/wlan-ng/prism2fw.c: warning: the frame size of 4236 bytes is larger than 1024 bytes [-Wframe-larger-than=]:  => 1115:1
  + drivers/staging/zcache/zcache-main.c: warning: 'ret' may be used uninitialized in this function [-Wuninitialized]:  => 115:2
  + drivers/tty/serial/8250/8250.c: warning: 'i' may be used uninitialized in this function [-Wuninitialized]: 1718:28, 1718:2, 1718:32, 1723:18 => 1698:18, 1696:28, 1696:32, 1696:2, 1660:306, 1701:18
  + drivers/tty/vt/consolemap.c: warning: 'h' may be used uninitialized in this function [-Wuninitialized]:  => 734:6
  + drivers/video/backlight/platform_lcd.c: warning: 'platform_lcd_resume' defined but not used [-Wunused-function]:  => 134:12
  + drivers/video/backlight/platform_lcd.c: warning: 'platform_lcd_suspend' defined but not used [-Wunused-function]:  => 124:12
  + drivers/video/sh_mobile_meram.c: warning: 'sh_mobile_meram_resume' defined but not used [-Wunused-function]:  => 566:12
  + drivers/video/sh_mobile_meram.c: warning: 'sh_mobile_meram_suspend' defined but not used [-Wunused-function]:  => 542:12
  + fs/autofs4/waitq.c: warning: 'wq' may be used uninitialized in this function [-Wuninitialized]:  => 460:517
  + fs/btrfs/acl.c: warning: 'name' may be used uninitialized in this function [-Wuninitialized]: 56:7 => 56:25, 56:7
  + fs/btrfs/extent_io.c: warning: 'ret' may be used uninitialized in this function [-Wuninitialized]:  => 3194:5
  + fs/btrfs/file-item.c: warning: comparison of distinct pointer types lacks a cast [enabled by default]:  => 808:346, 767:320, 717:306, 808:703, 808:9, 717:7, 808:711, 717:302, 767:316, 767:21, 808:350
  + fs/ext4/ext4_jbd2.h: warning: control reaches end of non-void function [-Wreturn-type]:  => 360:1
  + fs/fat/namei_vfat.c: warning: 'ulen' may be used uninitialized in this function [-Wuninitialized]:  => 337:20
  + fs/nfs/nfs4xdr.c: warning: the frame size of 1032 bytes is larger than 1024 bytes [-Wframe-larger-than=]:  => 1719:1
  + fs/quota/quota.c: warning: 'quotactl_cmd_write' defined but not used [-Wunused-function]:  => 295:12
  + fs/ubifs/dir.c: warning: 'saved_nlink' may be used uninitialized in this function [-Wuninitialized]:  => 1107:12
  + fs/ubifs/dir.c: warning: 'saved_nlink' may be used uninitialized in this function:  => 980
  + include/linux/list.h: warning: 'prev_page' may be used uninitialized in this function [-Wuninitialized]:  => 44:13
  + include/linux/ptrace.h: warning: "PTRACE_O_TRACESYSGOOD" redefined [enabled by default]:  => 65:0
  + include/linux/rculist.h: warning: 'ulp' may be used uninitialized in this function [-Wuninitialized]:  => 38:90
  + include/linux/spinlock.h: warning: 'dst_ptl' may be used uninitialized in this function [-Wuninitialized]:  => 325:19
  + include/linux/spinlock.h: warning: 'ptl' may be used uninitialized in this function [-Wuninitialized]:  => 325:19
  + include/linux/vga_switcheroo.h: warning: 'struct pci_dev' declared inside parameter list [enabled by default]:  => 49:91, 53:34, 28:30, 54:108
  + include/linux/vga_switcheroo.h: warning: its scope is only this definition or declaration, which is probably not what you want [enabled by default]:  => 28:30
  + include/media/v4l2-ctrls.h: warning: 'struct file' declared inside parameter list [enabled by default]:  => 505:55, 497:33
  + include/media/v4l2-ctrls.h: warning: its scope is only this definition or declaration, which is probably not what you want [enabled by default]:  => 497:33
  + ipc/sem.c: warning: 'undo_list' may be used uninitialized in this function [-Wuninitialized]:  => 1567:13
  + kernel/cgroup.c: warning: 'l' may be used uninitialized in this function [-Wuninitialized]:  => 3378:51
  + kernel/fork.c: warning: assignment makes pointer from integer without a cast [enabled by default]:  => 266:6
  + kernel/futex.c: warning: 'entry' may be used uninitialized in this function [-Wuninitialized]:  => 2598:27
  + kernel/futex.c: warning: 'pending' may be used uninitialized in this function [-Wuninitialized]:  => 2615:283
  + kernel/futex.c: warning: 'pip' may be used uninitialized in this function [-Wuninitialized]:  => 2616:21
  + kernel/power/qos.c: warning: control reaches end of non-void function:  => 143
  + kernel/rcutree.c: warning: unused variable 'idle' [-Wunused-variable]:  => 349:23, 458:23
  + kernel/trace/ring_buffer.c: warning: unused variable 'local_clock_stable' [-Wunused-variable]:  => 2170:8
  + kernel/trace/trace_events_filter.c: warning: 'ret' may be used uninitialized in this function [-Wuninitialized]:  => 2074:8
  + kernel/watchdog.c: warning: 'watchdog_disable' defined but not used [-Wunused-function]:  => 470:13
  + lib/debugobjects.c: warning: 'obj_states' defined but not used [-Wunused-variable]:  => 73:20
  + lib/debugobjects.c: warning: unused variable 'hint' [-Wunused-variable]:  => 256:9
  + lib/dynamic_debug.c: warning: 'rc' may be used uninitialized in this function [-Wuninitialized]:  => 385:278
  + mm/memblock.c: warning: 'r' may be used uninitialized in this function [-Wuninitialized]:  => 696:15
  + modpost: WARNING: modpost: Found 12 section mismatch(es).:  => N/A
  + modpost: WARNING: modpost: Found 14 section mismatch(es).:  => N/A
  + net/bridge/br_notify.c: warning: statement with no effect [-Wunused-value]:  => 42:3
  + net/netfilter/nfnetlink_cttimeout.c: warning: 'ctnl_timeout_parse_policy' uses dynamic stack allocation [enabled by default]:  => 66:1
  + sound/soc/codecs/wm8962.c: warning: 'fll_div.fll_fratio' may be used uninitialized in this function [-Wuninitialized]:  => 2839:21
  + sound/soc/codecs/wm8962.c: warning: 'fll_div.fll_outdiv' may be used uninitialized in this function [-Wuninitialized]:  => 2836:28
  + sound/soc/codecs/wm8962.c: warning: 'fll_div.lambda' may be used uninitialized in this function [-Wuninitialized]:  => 2843:15
  + sound/soc/codecs/wm8962.c: warning: 'fll_div.n' may be used uninitialized in this function [-Wuninitialized]:  => 2844:15
  + sound/soc/codecs/wm8962.c: warning: 'fll_div.theta' may be used uninitialized in this function [-Wuninitialized]:  => 2842:15
  + sound/soc/codecs/wm8993.c: warning: 'fll_div.fll_fratio' may be used uninitialized in this function [-Wuninitialized]:  => 536:29
  + sound/soc/codecs/wm8993.c: warning: 'fll_div.fll_outdiv' may be used uninitialized in this function [-Wuninitialized]:  => 535:29
  + sound/soc/codecs/wm8993.c: warning: 'fll_div.k' may be used uninitialized in this function [-Wuninitialized]:  => 537:15
  + sound/soc/codecs/wm8993.c: warning: 'fll_div.n' may be used uninitialized in this function [-Wuninitialized]:  => 541:20
  + sound/soc/codecs/wm8996.c: warning: 'fll_div.fll_fratio' may be used uninitialized in this function [-Wuninitialized]:  => 2249:56
  + sound/soc/codecs/wm8996.c: warning: 'fll_div.fll_loop_gain' may be used uninitialized in this function [-Wuninitialized]:  => 2256:42
  + sound/soc/codecs/wm8996.c: warning: 'fll_div.fll_outdiv' may be used uninitialized in this function [-Wuninitialized]:  => 2249:28
  + sound/soc/codecs/wm8996.c: warning: 'fll_div.fll_ref_freq' may be used uninitialized in this function [-Wuninitialized]:  => 2233:30
  + sound/soc/codecs/wm8996.c: warning: 'fll_div.lambda' may be used uninitialized in this function [-Wuninitialized]:  => 2259:15
  + sound/soc/codecs/wm8996.c: warning: 'fll_div.n' may be used uninitialized in this function [-Wuninitialized]:  => 2256:19
  + sound/soc/codecs/wm8996.c: warning: 'fll_div.theta' may be used uninitialized in this function [-Wuninitialized]:  => 2252:15
  + sound/soc/codecs/wm9081.c: warning: 'fll_div.fll_clk_ref_div' may be used uninitialized in this function [-Wuninitialized]:  => 624:34
  + sound/soc/codecs/wm9081.c: warning: 'fll_div.fll_fratio' may be used uninitialized in this function [-Wuninitialized]:  => 615:28
  + sound/soc/codecs/wm9081.c: warning: 'fll_div.fll_outdiv' may be used uninitialized in this function [-Wuninitialized]:  => 614:28
  + sound/soc/codecs/wm9081.c: warning: 'fll_div.k' may be used uninitialized in this function [-Wuninitialized]:  => 616:15
  + sound/soc/codecs/wm9081.c: warning: 'fll_div.n' may be used uninitialized in this function [-Wuninitialized]:  => 620:20
  + warning:   CC [M]  drivers/mtd/devices/docprobe.o:  => N/A
  + warning:   CC [M]  drivers/net/ethernet/chelsio/cxgb4/sge.o:  => N/A
  + warning:   CC [M]  drivers/net/ethernet/sfc/mcdi_phy.o:  => N/A
  + warning:   CC [M]  drivers/net/ppp/ppp_synctty.o:  => N/A
  + warning:   CC [M]  fs/ocfs2/buffer_head_io.o:  => N/A
  + warning:   LD      fs/ntfs/built-in.o:  => N/A
  + warning: (DRM) selects DMA_SHARED_BUFFER which has unmet direct dependencies (EXPERIMENTAL):  => N/A
  + warning: (ETRAX_USB_HOST && MOUSE_APPLETOUCH && MOUSE_BCM5974 && MOUSE_SYNAPTICS_USB && JOYSTICK_XPAD && TABLET_USB_ACECAD && TABLET_USB_AIPTEK && TABLET_USB_HANWANG && TABLET_USB_KBTAB && TABLET_USB_WACOM && TOUCHSCREEN_USB_COMPOSITE && INPUT_ATI_REMOTE2 && INPUT_KEYSPAN_REMOTE && INPUT_POWERMATE && INPUT_YEALINK && INPUT_CM109) selects USB which has unmet direct dependencies (USB_SUPPORT && USB_ARCH_HAS_HCD):  => N/A
  + warning: (MOUSE_APPLETOUCH && MOUSE_BCM5974 && MOUSE_SYNAPTICS_USB && JOYSTICK_XPAD && TABLET_USB_ACECAD && TABLET_USB_AIPTEK && TABLET_USB_HANWANG && TABLET_USB_KBTAB && TABLET_USB_WACOM && TOUCHSCREEN_USB_COMPOSITE && INPUT_ATI_REMOTE2 && INPUT_KEYSPAN_REMOTE && INPUT_POWERMATE && INPUT_YEALINK && INPUT_CM109 && RC_ATI_REMOTE && IR_IMON && IR_MCEUSB && IR_REDRAT3 && IR_STREAMZAP && DRM_USB) selects USB which has unmet direct dependencies (USB_SUPPORT && USB_ARCH_HAS_HCD):  => N/A
  + warning: (PPC_CELL_NATIVE && 440EPX && 440GRX && 440GX && 440SPe && 460EX && 460SX && APM821xx && 405EX) selects IBM_EMAC_EMAC4 which has unmet direct dependencies (NETDEVICES && ETHERNET && NET_VENDOR_IBM):  => N/A
  + warning: (PPC_CELL_NATIVE && 440GX && 460EX && 460SX && APM821xx) selects IBM_EMAC_TAH which has unmet direct dependencies (NETDEVICES && ETHERNET && NET_VENDOR_IBM):  => N/A
  + warning: (PPC_CELL_NATIVE && BLUESTONE && CANYONLANDS && GLACIER && EIGER && 440EPX && 440GRX && 440GX && 460SX && 405EX) selects IBM_EMAC_RGMII which has unmet direct dependencies (NETDEVICES && ETHERNET && NET_VENDOR_IBM):  => N/A
  + warning: (PPC_CELL_NATIVE && CANYONLANDS && GLACIER && 440EP && 440EPX && 440GRX && 440GP && 440GX && 460SX && 405GP) selects IBM_EMAC_ZMII which has unmet direct dependencies (NETDEVICES && ETHERNET && NET_VENDOR_IBM):  => N/A
  + warning: (PPC_PS3 && PPC_CELLEB && USB_EHCI_HCD_PMC_MSP && XPS_USB_HCD_XILINX && USB_OCTEON_EHCI) selects USB_EHCI_BIG_ENDIAN_MMIO which has unmet direct dependencies (USB_SUPPORT && USB_EHCI_HCD && (PPC_CELLEB || PPC_PS3 || 440EPX || ARCH_IXP4XX || XPS_USB_HCD_XILINX || PPC_MPC512x || CPU_CAVIUM_OCTEON || PMC_MSP || SPARC_LEON)):  => N/A
  + warning: (PPC_PS3 && PPC_CELLEB) selects USB_OHCI_BIG_ENDIAN_MMIO which has unmet direct dependencies (USB_SUPPORT && USB_OHCI_HCD):  => N/A
  + warning: (USB_DWC3) selects USB_XHCI_PLATFORM which has unmet direct dependencies (USB_SUPPORT && USB_XHCI_HCD):  => N/A
  + warning: In file included from /scratch/kisskb/src/drivers/usb/host/whci/whcd.h:23:0,:  => N/A
  + warning: arch/powerpc/platforms/built-in.o(.text+0x137bc): Section mismatch in reference from the function .pnv_pci_ioda_msi_setup() to the function .devinit.text:.__pnv_ioda_get_one_pe():  => N/A
  + warning: arch/powerpc/platforms/built-in.o(.text+0x137d8): Section mismatch in reference from the function .pnv_pci_ioda_msi_setup() to the function .devinit.text:.__pnv_ioda_get_one_pe():  => N/A
  + warning: arch/powerpc/platforms/built-in.o(.text+0x137dc): Section mismatch in reference from the function .pnv_pci_ioda_msi_setup() to the function .devinit.text:.__pnv_ioda_get_one_pe():  => N/A
  + warning: arch/powerpc/platforms/built-in.o(.text+0x137f8): Section mismatch in reference from the function .pnv_pci_ioda_msi_setup() to the function .devinit.text:.__pnv_ioda_get_one_pe():  => N/A
  + warning: arch/powerpc/platforms/built-in.o(.text+0x18090): Section mismatch in reference from the function .pci_dn_reconfig_notifier() to the function .devinit.text:.eeh_dev_init():  => N/A
  + warning: arch/powerpc/platforms/built-in.o(.text+0x180b0): Section mismatch in reference from the function .pci_dn_reconfig_notifier() to the function .devinit.text:.eeh_dev_init():  => N/A
  + warning: arch/powerpc/platforms/powernv/built-in.o(.text+0x3d50): Section mismatch in reference from the function .pnv_pci_ioda_msi_setup() to the function .devinit.text:.__pnv_ioda_get_one_pe():  => N/A
  + warning: arch/powerpc/platforms/powernv/built-in.o(.text+0x3d6c): Section mismatch in reference from the function .pnv_pci_ioda_msi_setup() to the function .devinit.text:.__pnv_ioda_get_one_pe():  => N/A
  + warning: arch/powerpc/platforms/pseries/built-in.o(.text+0x4514): Section mismatch in reference from the function .pci_dn_reconfig_notifier() to the function .devinit.text:.eeh_dev_init():  => N/A
  + warning: arch/powerpc/sysdev/built-in.o(.text+0xe154): Section mismatch in reference from the function .ics_rtas_init() to the function .init.text:.xics_register_ics():  => N/A
  + warning: arch/powerpc/sysdev/built-in.o(.text+0xf6fc): Section mismatch in reference from the function .ics_rtas_init() to the function .init.text:.xics_register_ics():  => N/A
  + warning: arch/powerpc/sysdev/xics/built-in.o(.text+0x2634): Section mismatch in reference from the function .ics_rtas_init() to the function .init.text:.xics_register_ics():  => N/A
  + warning: arch/xtensa/platforms/iss/built-in.o (.xt.lit): unexpected non-allocatable section.:  => N/A
  + warning: drivers/base/built-in.o (.xt.lit): unexpected non-allocatable section.:  => N/A
  + warning: drivers/built-in.o(.data+0x660): Section mismatch in reference from the variable lba_driver to the function .init.text:lba_driver_probe():  => N/A
  + warning: drivers/built-in.o(.data+0x6fc): Section mismatch in reference from the variable ccio_driver to the function .init.text:ccio_probe():  => N/A
  + warning: drivers/built-in.o(.data+0x84c): Section mismatch in reference from the variable dino_driver to the function .init.text:dino_probe():  => N/A
  + warning: drivers/built-in.o(.data+0x94c): Section mismatch in reference from the variable lasi_driver to the function .init.text:lasi_init_chip():  => N/A
  + warning: drivers/built-in.o(.data+0x9a8): Section mismatch in reference from the variable asp_driver to the function .init.text:asp_init_chip():  => N/A
  + warning: drivers/built-in.o(.data+0xa04): Section mismatch in reference from the variable wax_driver to the function .init.text:wax_init_chip():  => N/A
  + warning: drivers/built-in.o(.data+0xa6c): Section mismatch in reference from the variable eisa_driver to the function .init.text:eisa_probe():  => N/A
  + warning: drivers/built-in.o(.data+0xc10): Section mismatch in reference from the variable superio_driver to the function .init.text:superio_probe():  => N/A
  + warning: drivers/char/built-in.o (.xt.lit): unexpected non-allocatable section.:  => N/A
  + warning: drivers/char/built-in.o (.xt.prop): unexpected non-allocatable section.:  => N/A
  + warning: drivers/char/tpm/built-in.o (.xt.lit): unexpected non-allocatable section.:  => N/A
  + warning: drivers/char/tpm/built-in.o (.xt.prop): unexpected non-allocatable section.:  => N/A
  + warning: drivers/gpu/drm/udl/udl.o (.xt.lit): unexpected non-allocatable section.:  => N/A
  + warning: drivers/gpu/drm/udl/udl.o (.xt.prop): unexpected non-allocatable section.:  => N/A
  + warning: drivers/hsi/built-in.o (.xt.lit): unexpected non-allocatable section.:  => N/A
  + warning: drivers/hsi/built-in.o (.xt.prop): unexpected non-allocatable section.:  => N/A
  + warning: drivers/media/dvb/dvb-usb/dvb-usb-az6007.o (.xt.lit): unexpected non-allocatable section.:  => N/A
  + warning: drivers/media/dvb/dvb-usb/dvb-usb-az6007.o (.xt.prop): unexpected non-allocatable section.:  => N/A
  + warning: drivers/media/dvb/dvb-usb/dvb-usb-rtl28xxu.o (.xt.lit): unexpected non-allocatable section.:  => N/A
  + warning: drivers/media/dvb/dvb-usb/dvb-usb-rtl28xxu.o (.xt.prop): unexpected non-allocatable section.:  => N/A
  + warning: drivers/net/can/usb/peak_usb/peak_usb.o (.xt.lit): unexpected non-allocatable section.:  => N/A
  + warning: drivers/net/can/usb/peak_usb/peak_usb.o (.xt.prop): unexpected non-allocatable section.:  => N/A
  + warning: drivers/net/wireless/ath/ath6kl/ath6kl_core.o (.xt.lit): unexpected non-allocatable section.:  => N/A
  + warning: drivers/net/wireless/ath/ath6kl/ath6kl_core.o (.xt.prop): unexpected non-allocatable section.:  => N/A
  + warning: drivers/net/wireless/ath/ath6kl/ath6kl_sdio.o (.xt.lit): unexpected non-allocatable section.:  => N/A
  + warning: drivers/net/wireless/ath/ath6kl/ath6kl_sdio.o (.xt.prop): unexpected non-allocatable section.:  => N/A
  + warning: drivers/net/wireless/ath/ath6kl/ath6kl_usb.o (.xt.lit): unexpected non-allocatable section.:  => N/A
  + warning: drivers/net/wireless/ath/ath6kl/ath6kl_usb.o (.xt.prop): unexpected non-allocatable section.:  => N/A
  + warning: drivers/staging/comedi/drivers/s626.o(.text+0x2ebf): Section mismatch in reference from the function s626_attach() to the variable .devinit.rodata:s626_pci_table:  => N/A
  + warning: drivers/staging/comedi/drivers/s626.o(.text+0x2ece): Section mismatch in reference from the function s626_attach() to the variable .devinit.rodata:s626_pci_table:  => N/A
  + warning: drivers/staging/ozwpan/ozwpan.o (.xt.lit): unexpected non-allocatable section.:  => N/A
  + warning: drivers/staging/ozwpan/ozwpan.o (.xt.prop): unexpected non-allocatable section.:  => N/A
  + warning: drivers/staging/sep/sep_driver.o (.xt.lit): unexpected non-allocatable section.:  => N/A
  + warning: drivers/staging/sep/sep_driver.o (.xt.prop): unexpected non-allocatable section.:  => N/A
  + warning: fs/debugfs/debugfs.o (.xt.prop): unexpected non-allocatable section.:  => N/A
  + warning: fs/qnx6/qnx6.o (.xt.lit): unexpected non-allocatable section.:  => N/A
  + warning: fs/qnx6/qnx6.o (.xt.prop): unexpected non-allocatable section.:  => N/A
  + warning: net/ipv6/ipv6.o (.xt.lit): unexpected non-allocatable section.:  => N/A
  + warning: net/ipv6/ipv6.o (.xt.prop): unexpected non-allocatable section.:  => N/A
  + warning: net/sunrpc/sunrpc.o (.xt.lit): unexpected non-allocatable section.:  => N/A
  + warning: net/sunrpc/sunrpc.o (.xt.prop): unexpected non-allocatable section.:  => N/A
  + warning: net/unix/unix.o (.xt.lit): unexpected non-allocatable section.:  => N/A
  + warning: security/yama/built-in.o (.xt.lit): unexpected non-allocatable section.:  => N/A
  + warning: security/yama/built-in.o (.xt.prop): unexpected non-allocatable section.:  => N/A
  + warning: security/yama/yama.o (.xt.lit): unexpected non-allocatable section.:  => N/A
  + warning: security/yama/yama.o (.xt.prop): unexpected non-allocatable section.:  => N/A
  + warning: vmlinux.o (.xt.lit): unexpected non-allocatable section.:  => N/A
  + warning: vmlinux.o (.xt.prop): unexpected non-allocatable section.:  => N/A
  + warning: vmlinux.o(.text+0x2ccec): Section mismatch in reference from the function .early_setup_secondary() to the function .cpuinit.text:.early_init_mmu_secondary():  => N/A
  + warning: vmlinux.o(.text+0x4e7c8): Section mismatch in reference from the function .wake_offline_cpus() to the function .cpuinit.text:.cpu_up():  => N/A
  + warning: vmlinux.o(.text+0x4fbe4): Section mismatch in reference from the function .wake_offline_cpus() to the function .cpuinit.text:.cpu_up():  => N/A
  + warning: vmlinux.o(.text+0x72a7c): Section mismatch in reference from the function .ics_rtas_init() to the function .init.text:.xics_register_ics():  => N/A
  + warning: vmlinux.o(.text+0x75424): Section mismatch in reference from the function .ics_rtas_init() to the function .init.text:.xics_register_ics():  => N/A
  + warning: vmlinux.o(.text+0x8691c): Section mismatch in reference from the function .pnv_pci_ioda_msi_setup() to the function .devinit.text:.__pnv_ioda_get_one_pe():  => N/A
  + warning: vmlinux.o(.text+0x86938): Section mismatch in reference from the function .pnv_pci_ioda_msi_setup() to the function .devinit.text:.__pnv_ioda_get_one_pe():  => N/A
  + warning: vmlinux.o(.text+0x892dc): Section mismatch in reference from the function .pnv_pci_ioda_msi_setup() to the function .devinit.text:.__pnv_ioda_get_one_pe():  => N/A
  + warning: vmlinux.o(.text+0x892f8): Section mismatch in reference from the function .pnv_pci_ioda_msi_setup() to the function .devinit.text:.__pnv_ioda_get_one_pe():  => N/A
  + warning: vmlinux.o(.text+0x8b1d4): Section mismatch in reference from the function .pci_dn_reconfig_notifier() to the function .devinit.text:.update_dn_pci_info():  => N/A
  + warning: vmlinux.o(.text+0x8b1f0): Section mismatch in reference from the function .pci_dn_reconfig_notifier() to the function .devinit.text:.eeh_dev_init():  => N/A
  + warning: vmlinux.o(.text+0x8db94): Section mismatch in reference from the function .pci_dn_reconfig_notifier() to the function .devinit.text:.update_dn_pci_info():  => N/A
  + warning: vmlinux.o(.text+0x8dbb0): Section mismatch in reference from the function .pci_dn_reconfig_notifier() to the function .devinit.text:.eeh_dev_init():  => N/A
  + warning: vmlinux.o(.text+0x9031c): Section mismatch in reference from the function .dlpar_online_cpu() to the function .cpuinit.text:.cpu_up():  => N/A
  + warning: vmlinux.o(.text+0x92cdc): Section mismatch in reference from the function .dlpar_online_cpu() to the function .cpuinit.text:.cpu_up():  => N/A
  + warning: vmlinux.o(.text+0x93ec): Section mismatch in reference from the function .start_secondary_prolog() to the function .devinit.text:.start_secondary():  => N/A
  + warning: vmlinux.o(.text+0x9400): Section mismatch in reference from the function .start_secondary_resume() to the function .devinit.text:.start_secondary():  => N/A
  + warning: vmlinux.o(.text+0x97ecc): Section mismatch in reference from the function .pcibios_add_pci_devices() to the function .devinit.text:.of_rescan_bus():  => N/A
  + warning: vmlinux.o(.text+0x97f58): Section mismatch in reference from the function .pcibios_add_pci_devices() to the function .devinit.text:.pcibios_setup_bus_devices():  => N/A
  + warning: vmlinux.o(.text+0x97fbc): Section mismatch in reference from the function .pcibios_add_pci_devices() to the function .devinit.text:.pci_scan_bridge():  => N/A
  + warning: vmlinux.o(.text+0x9ae18): Section mismatch in reference from the function .pcibios_add_pci_devices() to the function .devinit.text:.of_rescan_bus():  => N/A
  + warning: vmlinux.o(.text+0x9aea4): Section mismatch in reference from the function .pcibios_add_pci_devices() to the function .devinit.text:.pcibios_setup_bus_devices():  => N/A
  + warning: vmlinux.o(.text+0x9af08): Section mismatch in reference from the function .pcibios_add_pci_devices() to the function .devinit.text:.pci_scan_bridge():  => N/A

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
