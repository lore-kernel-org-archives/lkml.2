Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753141Ab2FDTyV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 15:54:21 -0400
Received: from juliette.telenet-ops.be ([195.130.137.74]:42785 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751146Ab2FDTyQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 15:54:16 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-kernel@vger.kernel.org
Subject: Build regressions/improvements in v3.5-rc1
Date: Mon,  4 Jun 2012 21:54:12 +0200
Message-Id: <1338839652-29716-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Below is the list of build error/warning regressions/improvements in
v3.5-rc1[1] compared to v3.4[2].

Too make this mail fit in the lkml limit, I deleted
  - all implicit function declaration error improvements
  - 245 lines about __mcount_loc on sparc64
  - all warning improvements

Summarized:
  - build errors: +209/-607
  - build warnings: +539/-1045

In addition, I've put the verbose summary at
http://www.kernel.org/pub/linux/kernel/people/geert/linux-log/v3.5-rc1.summary.gz
so you can easily find out for which configs and architectures the
errors/warnings you're interested in are happening.

Happy fixing! ;-)

Thanks to the linux-next team for providing the build service.

[1] http://kisskb.ellerman.id.au/kisskb/head/5106/ (all 115 configs)
[2] http://kisskb.ellerman.id.au/kisskb/head/5055/ (all 115 configs)


*** ERRORS ***

209 regressions:
  + arch/avr32/kernel/signal.c: error: expected statement before ')' token:  => 303
  + arch/cris/arch-v10/kernel/kgdb.c: error: expected string literal before '.' token:  => 1274:3
  + arch/cris/arch-v10/kernel/kgdb.c: error: missing terminating " character:  => 1359:1, 1370:1, 1273:1, 1457:1
  + arch/h8300/kernel/signal.c: error: expected '=', ',', ';', 'asm' or '__attribute__' before 'void':  => 450:8
  + arch/h8300/kernel/signal.c: error: implicit declaration of function 'do_signal' [-Werror=implicit-function-declaration]:  => 495:3
  + arch/sh/include/asm/thread_info.h: error: 'TAINT_WARN' undeclared (first use in this function):  => 172:2
  + arch/sh/kernel/process.c: error: implicit declaration of function 'unlazy_fpu' [-Werror=implicit-function-declaration]:  => 23:2
  + arch/tile/kernel/setup.c: error: 'start_kernel' undeclared here (not in a function):  => 69:344
  + arch/xtensa/include/asm/unistd.h: error: 'sys_rt_sigsuspend' undeclared here (not in a function):  => 510:22
  + arch/xtensa/kernel/signal.c: error: incompatible type for argument 2 of 'signal_delivered':  => 496:3
  + arch/xtensa/kernel/signal.c: error: incompatible type for argument 3 of 'signal_delivered':  => 496:3
  + block/blk-cgroup.c: error: implicit declaration of function 'ATOMIC64_INIT' [-Werror=implicit-function-declaration]:  => 614:2
  + block/blk-cgroup.c: error: implicit declaration of function 'atomic64_inc_return' [-Werror=implicit-function-declaration]:  => 628:2
  + block/blk-cgroup.c: error: initializer element is not constant:  => 614:2
  + block/blk-cgroup.c: error: unknown type name 'atomic64_t':  => 614:2
  + drivers/block/hd.c: error: implicit declaration of function 'inb_p' [-Werror=implicit-function-declaration]:  => 256:2
  + drivers/block/hd.c: error: implicit declaration of function 'outb_p' [-Werror=implicit-function-declaration]:  => 297:3
  + drivers/block/paride/bpck.c: error: invalid operands to binary & (have 'void *' and 'int'):  => 62:140, 56:140
  + drivers/block/paride/epia.c: error: invalid operands to binary & (have 'void *' and 'int'):  => 63:502
  + drivers/block/paride/epia.c: error: invalid operands to binary | (have 'void *' and 'int'):  => 64:502
  + drivers/block/paride/kbic.c: error: invalid operands to binary | (have 'void *' and 'int'):  => 85:142, 61:142, 91:142, 53:142, 67:142, 57:142
  + drivers/char/ipmi/ipmi_si_intf.c: error: invalid operands to binary << (have 'void *' and 'int'):  => 1373:153, 1388:151
  + drivers/char/tpm/tpm.h: error: invalid operands to binary & (have 'void *' and 'int'):  => 144:131
  + drivers/extcon/extcon_gpio.c: error: implicit declaration of function 'gpio_free' [-Werror=implicit-function-declaration]:  => 135:2
  + drivers/extcon/extcon_gpio.c: error: implicit declaration of function 'gpio_request_one' [-Werror=implicit-function-declaration]:  => 110:2
  + drivers/gpu/drm/ast/ast_drv.h: error: implicit declaration of function 'ioread16' [-Werror=implicit-function-declaration]:  => 130:68
  + drivers/gpu/drm/ast/ast_drv.h: error: implicit declaration of function 'ioread32' [-Werror=implicit-function-declaration]:  => 131:68
  + drivers/gpu/drm/ast/ast_drv.h: error: implicit declaration of function 'ioread8' [-Werror=implicit-function-declaration]:  => 129:66
  + drivers/gpu/drm/ast/ast_drv.h: error: implicit declaration of function 'iowrite16' [-Werror=implicit-function-declaration]:  => 150:70
  + drivers/gpu/drm/ast/ast_drv.h: error: implicit declaration of function 'iowrite32' [-Werror=implicit-function-declaration]:  => 151:70
  + drivers/gpu/drm/ast/ast_drv.h: error: implicit declaration of function 'iowrite8' [-Werror=implicit-function-declaration]:  => 149:69
  + drivers/gpu/drm/ast/ast_main.c: error: implicit declaration of function 'pci_iomap' [-Werror=implicit-function-declaration]:  => 340:2
  + drivers/gpu/drm/ast/ast_main.c: error: implicit declaration of function 'pci_iounmap' [-Werror=implicit-function-declaration]:  => 406:2
  + drivers/gpu/drm/cirrus/cirrus_mode.c: error: implicit declaration of function 'ioread8' [-Werror=implicit-function-declaration]:  => 86:2
  + drivers/gpu/drm/cirrus/cirrus_mode.c: error: implicit declaration of function 'iowrite8' [-Werror=implicit-function-declaration]:  => 46:3
  + drivers/gpu/drm/mgag200/mgag200_i2c.c: error: implicit declaration of function 'ioread8' [-Werror=implicit-function-declaration]:  => 39:2
  + drivers/gpu/drm/mgag200/mgag200_i2c.c: error: implicit declaration of function 'iowrite8' [-Werror=implicit-function-declaration]:  => 38:2
  + drivers/gpu/drm/mgag200/mgag200_main.c: error: implicit declaration of function 'ioread16' [-Werror=implicit-function-declaration]:  => 103:2
  + drivers/gpu/drm/mgag200/mgag200_main.c: error: implicit declaration of function 'ioread32' [-Werror=implicit-function-declaration]:  => 193:3
  + drivers/gpu/drm/mgag200/mgag200_main.c: error: implicit declaration of function 'ioread8' [-Werror=implicit-function-declaration]:  => 107:3
  + drivers/gpu/drm/mgag200/mgag200_main.c: error: implicit declaration of function 'iowrite16' [-Werror=implicit-function-declaration]:  => 104:2
  + drivers/gpu/drm/mgag200/mgag200_main.c: error: implicit declaration of function 'pci_iomap' [-Werror=implicit-function-declaration]:  => 154:2
  + drivers/gpu/drm/mgag200/mgag200_main.c: error: implicit declaration of function 'pci_iounmap' [-Werror=implicit-function-declaration]:  => 89:2
  + drivers/gpu/drm/mgag200/mgag200_mode.c: error: implicit declaration of function 'ioread32' [-Werror=implicit-function-declaration]:  => 54:3
  + drivers/gpu/drm/mgag200/mgag200_mode.c: error: implicit declaration of function 'ioread8' [-Werror=implicit-function-declaration]:  => 70:3
  + drivers/gpu/drm/mgag200/mgag200_mode.c: error: implicit declaration of function 'iowrite32' [-Werror=implicit-function-declaration]:  => 994:3
  + drivers/gpu/drm/mgag200/mgag200_mode.c: error: implicit declaration of function 'iowrite8' [-Werror=implicit-function-declaration]:  => 38:2
  + drivers/gpu/drm/nouveau/nve0_fifo.c: error: implicit declaration of function 'ioremap_wc' [-Werror=implicit-function-declaration]:  => 114:2
  + drivers/gpu/drm/radeon/radeon.h: error: unknown type name 'atomic64_t':  => 263:2
  + drivers/gpu/drm/radeon/radeon_fence.c: error: implicit declaration of function 'atomic64_read' [-Werror=implicit-function-declaration]:  => 103:2
  + drivers/gpu/drm/radeon/radeon_fence.c: error: implicit declaration of function 'atomic64_set' [-Werror=implicit-function-declaration]:  => 553:2
  + drivers/gpu/drm/radeon/radeon_fence.c: error: implicit declaration of function 'atomic64_xchg' [-Werror=implicit-function-declaration]:  => 128:2
  + drivers/i2c/busses/i2c-bfin-twi.c: error: 'ANAK' undeclared (first use in this function):  => 154:19
  + drivers/i2c/busses/i2c-bfin-twi.c: error: 'BUFRDERR' undeclared (first use in this function):  => 158:19
  + drivers/i2c/busses/i2c-bfin-twi.c: error: 'BUFWRERR' undeclared (first use in this function):  => 160:19
  + drivers/i2c/busses/i2c-bfin-twi.c: error: 'BUSBUSY' undeclared (first use in this function):  => 401:35, 301:35
  + drivers/i2c/busses/i2c-bfin-twi.c: error: 'DNAK' undeclared (first use in this function):  => 156:19
  + drivers/i2c/busses/i2c-bfin-twi.c: error: 'FAST' undeclared (first use in this function):  => 511:17, 360:18
  + drivers/i2c/busses/i2c-bfin-twi.c: error: 'LOSTARB' undeclared (first use in this function):  => 152:19
  + drivers/i2c/busses/i2c-bfin-twi.c: error: 'MCOMP' undeclared (first use in this function):  => 189:22, 489:31, 344:31
  + drivers/i2c/busses/i2c-bfin-twi.c: error: 'MDIR' undeclared (first use in this function):  => 359:31, 567:32, 102:30
  + drivers/i2c/busses/i2c-bfin-twi.c: error: 'MEN' undeclared (first use in this function):  => 358:51, 510:52, 196:33
  + drivers/i2c/busses/i2c-bfin-twi.c: error: 'MERR' undeclared (first use in this function):  => 146:23, 489:24, 344:24
  + drivers/i2c/busses/i2c-bfin-twi.c: error: 'RCVSERV' undeclared (first use in this function):  => 489:49, 116:23, 344:49
  + drivers/i2c/busses/i2c-bfin-twi.c: error: 'RSTART' undeclared (first use in this function):  => 102:37
  + drivers/i2c/busses/i2c-bfin-twi.c: error: 'SCLOVR' undeclared (first use in this function):  => 171:29
  + drivers/i2c/busses/i2c-bfin-twi.c: error: 'SDAOVR' undeclared (first use in this function):  => 177:28
  + drivers/i2c/busses/i2c-bfin-twi.c: error: 'SDASEN' undeclared (first use in this function):  => 168:33
  + drivers/i2c/busses/i2c-bfin-twi.c: error: 'STOP' undeclared (first use in this function):  => 105:30
  + drivers/i2c/busses/i2c-bfin-twi.c: error: 'TWI_ENA' undeclared (first use in this function):  => 398:30, 624:47, 298:30, 725:45
  + drivers/i2c/busses/i2c-bfin-twi.c: error: 'XMTSERV' undeclared (first use in this function):  => 344:39, 489:39, 90:23
  + drivers/i2c/muxes/i2c-mux-gpio.c: error: implicit declaration of function 'gpio_direction_output' [-Werror=implicit-function-declaration]:  => 101:3
  + drivers/i2c/muxes/i2c-mux-gpio.c: error: implicit declaration of function 'gpio_free' [-Werror=implicit-function-declaration]:  => 130:3
  + drivers/i2c/muxes/i2c-mux-gpio.c: error: implicit declaration of function 'gpio_request' [-Werror=implicit-function-declaration]:  => 98:3
  + drivers/infiniband/hw/ocrdma/ocrdma_hw.c: error: implicit declaration of function 'iowrite32' [-Werror=implicit-function-declaration]:  => 286:2
  + drivers/infiniband/hw/ocrdma/ocrdma_verbs.c: error: implicit declaration of function 'iowrite32' [-Werror=implicit-function-declaration]:  => 1765:2
  + drivers/input/gameport/lightning.c: error: invalid operands to binary & (have 'void *' and 'int'):  => 177:136, 141:136, 86:133
  + drivers/input/gameport/ns558.c: error: invalid operands to binary & (have 'void *' and 'int'):  => 84:124
  + drivers/input/touchscreen/mk712.c: error: invalid operands to binary | (have 'void *' and 'int'):  => 129:136
  + drivers/media/video/smiapp/smiapp-core.c: error: implicit declaration of function 'kfree' [-Werror=implicit-function-declaration]:  => 2639:2
  + drivers/media/video/smiapp/smiapp-core.c: error: implicit declaration of function 'kzalloc' [-Werror=implicit-function-declaration]:  => 2472:3
  + drivers/mfd/lm3533-core.c: error: implicit declaration of function 'gpio_free' [-Werror=implicit-function-declaration]:  => 531:3
  + drivers/mfd/lm3533-core.c: error: implicit declaration of function 'gpio_request_one' [-Werror=implicit-function-declaration]:  => 498:3
  + drivers/net/cris/eth_v10.c: error: too many arguments to function 'e100rxtx_interrupt':  => 1715:2
  + drivers/net/ethernet/broadcom/bnx2.c: error: implicit declaration of function 'pci_iomap' [-Werror=implicit-function-declaration]:  => 8037:2
  + drivers/net/ethernet/broadcom/bnx2.c: error: implicit declaration of function 'pci_iounmap' [-Werror=implicit-function-declaration]:  => 8342:2
  + drivers/net/ethernet/dec/tulip/dmfe.c: error: implicit declaration of function 'ioread16' [-Werror=implicit-function-declaration]:  => 1843:3
  + drivers/net/ethernet/dec/tulip/dmfe.c: error: implicit declaration of function 'ioread32' [-Werror=implicit-function-declaration]:  => 809:2
  + drivers/net/ethernet/dec/tulip/dmfe.c: error: implicit declaration of function 'ioread8' [-Werror=implicit-function-declaration]:  => 1205:3
  + drivers/net/ethernet/dec/tulip/dmfe.c: error: implicit declaration of function 'iowrite16' [-Werror=implicit-function-declaration]:  => 1465:3
  + drivers/net/ethernet/dec/tulip/dmfe.c: error: implicit declaration of function 'iowrite32' [-Werror=implicit-function-declaration]:  => 626:2
  + drivers/net/ethernet/dec/tulip/dmfe.c: error: implicit declaration of function 'pci_iomap' [-Werror=implicit-function-declaration]:  => 464:2
  + drivers/net/ethernet/dec/tulip/dmfe.c: error: implicit declaration of function 'pci_iounmap' [-Werror=implicit-function-declaration]:  => 509:2
  + drivers/net/ethernet/dec/tulip/uli526x.c: error: implicit declaration of function 'ioread32' [-Werror=implicit-function-declaration]:  => 396:4
  + drivers/net/ethernet/dec/tulip/uli526x.c: error: implicit declaration of function 'iowrite32' [-Werror=implicit-function-declaration]:  => 257:2
  + drivers/net/ethernet/dec/tulip/uli526x.c: error: implicit declaration of function 'pci_iomap' [-Werror=implicit-function-declaration]:  => 363:2
  + drivers/net/ethernet/dec/tulip/uli526x.c: error: implicit declaration of function 'pci_iounmap' [-Werror=implicit-function-declaration]:  => 420:2
  + drivers/net/ethernet/dec/tulip/xircom_cb.c: error: implicit declaration of function 'ioread32' [-Werror=implicit-function-declaration]:  => 340:2
  + drivers/net/ethernet/dec/tulip/xircom_cb.c: error: implicit declaration of function 'ioread8' [-Werror=implicit-function-declaration]:  => 980:2
  + drivers/net/ethernet/dec/tulip/xircom_cb.c: error: implicit declaration of function 'iowrite32' [-Werror=implicit-function-declaration]:  => 370:2
  + drivers/net/ethernet/dec/tulip/xircom_cb.c: error: implicit declaration of function 'pci_iomap' [-Werror=implicit-function-declaration]:  => 258:2
  + drivers/net/ethernet/dec/tulip/xircom_cb.c: error: implicit declaration of function 'pci_iounmap' [-Werror=implicit-function-declaration]:  => 293:2
  + drivers/net/ethernet/dlink/de620.c: error: invalid operands to binary ^ (have 'void *' and 'int'):  => 395:147, 266:147, 371:147
  + drivers/net/ethernet/dlink/dl2k.c: error: implicit declaration of function 'ioread16' [-Werror=implicit-function-declaration]:  => 257:2
  + drivers/net/ethernet/dlink/dl2k.c: error: implicit declaration of function 'ioread32' [-Werror=implicit-function-declaration]:  => 428:2
  + drivers/net/ethernet/dlink/dl2k.c: error: implicit declaration of function 'ioread8' [-Werror=implicit-function-declaration]:  => 385:4
  + drivers/net/ethernet/dlink/dl2k.c: error: implicit declaration of function 'iowrite16' [-Werror=implicit-function-declaration]:  => 64:2
  + drivers/net/ethernet/dlink/dl2k.c: error: implicit declaration of function 'iowrite32' [-Werror=implicit-function-declaration]:  => 428:2
  + drivers/net/ethernet/dlink/dl2k.c: error: implicit declaration of function 'iowrite8' [-Werror=implicit-function-declaration]:  => 385:4
  + drivers/net/ethernet/dlink/dl2k.c: error: implicit declaration of function 'pci_iomap' [-Werror=implicit-function-declaration]:  => 150:2
  + drivers/net/ethernet/dlink/dl2k.c: error: implicit declaration of function 'pci_iounmap' [-Werror=implicit-function-declaration]:  => 302:2
  + drivers/net/ethernet/emulex/benet/be_main.c: error: implicit declaration of function 'pci_iomap' [-Werror=implicit-function-declaration]:  => 3264:2
  + drivers/net/ethernet/emulex/benet/be_main.c: error: implicit declaration of function 'pci_iounmap' [-Werror=implicit-function-declaration]:  => 3256:3
  + drivers/net/ethernet/seeq/seeq8005.c: error: invalid operands to binary >> (have 'void *' and 'int'):  => 544:161
  + drivers/net/ethernet/seeq/seeq8005.c: error: invalid operands to binary | (have 'void *' and 'int'):  => 640:138, 220:138, 661:139, 543:140, 438:139, 671:142, 722:138, 705:140, 700:138, 468:140, 673:138, 672:142, 322:139, 461:140, 502:139
  + drivers/net/ethernet/sis/sis900.c: error: implicit declaration of function 'ioread16' [-Werror=implicit-function-declaration]:  => 352:3
  + drivers/net/ethernet/sis/sis900.c: error: implicit declaration of function 'ioread32' [-Werror=implicit-function-declaration]:  => 341:2
  + drivers/net/ethernet/sis/sis900.c: error: implicit declaration of function 'iowrite32' [-Werror=implicit-function-declaration]:  => 343:2
  + drivers/net/ethernet/sis/sis900.c: error: implicit declaration of function 'iowrite8' [-Werror=implicit-function-declaration]:  => 964:3
  + drivers/net/ethernet/sis/sis900.c: error: implicit declaration of function 'pci_iomap' [-Werror=implicit-function-declaration]:  => 480:2
  + drivers/net/ethernet/sis/sis900.c: error: implicit declaration of function 'pci_iounmap' [-Werror=implicit-function-declaration]:  => 588:2
  + drivers/net/ethernet/smsc/epic100.c: error: implicit declaration of function 'ioread16' [-Werror=implicit-function-declaration]:  => 424:3
  + drivers/net/ethernet/smsc/epic100.c: error: implicit declaration of function 'ioread32' [-Werror=implicit-function-declaration]:  => 419:3
  + drivers/net/ethernet/smsc/epic100.c: error: implicit declaration of function 'ioread8' [-Werror=implicit-function-declaration]:  => 776:3
  + drivers/net/ethernet/smsc/epic100.c: error: implicit declaration of function 'iowrite16' [-Werror=implicit-function-declaration]:  => 638:2
  + drivers/net/ethernet/smsc/epic100.c: error: implicit declaration of function 'iowrite32' [-Werror=implicit-function-declaration]:  => 410:2
  + drivers/net/ethernet/smsc/epic100.c: error: implicit declaration of function 'pci_iomap' [-Werror=implicit-function-declaration]:  => 368:2
  + drivers/net/ethernet/smsc/epic100.c: error: implicit declaration of function 'pci_iounmap' [-Werror=implicit-function-declaration]:  => 507:2
  + drivers/net/ethernet/wiznet/w5100.c: error: implicit declaration of function 'ioread8' [-Werror=implicit-function-declaration]:  => 122:2
  + drivers/net/ethernet/wiznet/w5100.c: error: implicit declaration of function 'iowrite8' [-Werror=implicit-function-declaration]:  => 128:2
  + drivers/net/ethernet/wiznet/w5100.c: error: implicit declaration of function 'mmiowb' [-Werror=implicit-function-declaration]:  => 189:2
  + drivers/net/ethernet/wiznet/w5300.c: error: implicit declaration of function 'ioread16' [-Werror=implicit-function-declaration]:  => 118:2
  + drivers/net/ethernet/wiznet/w5300.c: error: implicit declaration of function 'iowrite16' [-Werror=implicit-function-declaration]:  => 124:2
  + drivers/net/ethernet/wiznet/w5300.c: error: implicit declaration of function 'mmiowb' [-Werror=implicit-function-declaration]:  => 145:2
  + drivers/net/hamradio/baycom_ser_fdx.c: error: invalid operands to binary >> (have 'void *' and 'int'):  => 189:152
  + drivers/net/hamradio/baycom_ser_fdx.c: error: invalid operands to binary | (have 'void *' and 'int'):  => 329:145, 388:132
  + drivers/net/hamradio/baycom_ser_hdx.c: error: invalid operands to binary | (have 'void *' and 'int'):  => 447:132, 209:142
  + drivers/net/hamradio/yam.c: error: invalid operands to binary ^ (have 'void *' and 'int'):  => 713:159
  + drivers/net/hamradio/yam.c: error: invalid operands to binary | (have 'void *' and 'int'):  => 320:134, 309:134, 317:134, 517:132, 481:142, 336:134
  + drivers/net/hippi/rrunner.c: error: implicit declaration of function 'pci_iomap' [-Werror=implicit-function-declaration]:  => 152:2
  + drivers/net/hippi/rrunner.c: error: implicit declaration of function 'pci_iounmap' [-Werror=implicit-function-declaration]:  => 213:3
  + drivers/net/irda/bfin_sir.c: error: 'IREN' undeclared (first use in this function):  => 161:9, 521:11, 435:18
  + drivers/net/wireless/ipw2x00/ipw2100.c: error: implicit declaration of function 'ioread16' [-Werror=implicit-function-declaration]:  => 366:2
  + drivers/net/wireless/ipw2x00/ipw2100.c: error: implicit declaration of function 'ioread32' [-Werror=implicit-function-declaration]:  => 349:2
  + drivers/net/wireless/ipw2x00/ipw2100.c: error: implicit declaration of function 'ioread8' [-Werror=implicit-function-declaration]:  => 374:2
  + drivers/net/wireless/ipw2x00/ipw2100.c: error: implicit declaration of function 'iowrite16' [-Werror=implicit-function-declaration]:  => 382:2
  + drivers/net/wireless/ipw2x00/ipw2100.c: error: implicit declaration of function 'iowrite32' [-Werror=implicit-function-declaration]:  => 357:2
  + drivers/net/wireless/ipw2x00/ipw2100.c: error: implicit declaration of function 'iowrite8' [-Werror=implicit-function-declaration]:  => 390:2
  + drivers/net/wireless/ipw2x00/ipw2100.c: error: implicit declaration of function 'pci_iomap' [-Werror=implicit-function-declaration]:  => 6242:2
  + drivers/net/wireless/ipw2x00/ipw2100.c: error: implicit declaration of function 'pci_iounmap' [-Werror=implicit-function-declaration]:  => 6420:2
  + drivers/pci/quirks.c: error: implicit declaration of function 'ioread32' [-Werror=implicit-function-declaration]:  => 3128:2
  + drivers/pci/quirks.c: error: implicit declaration of function 'iowrite32' [-Werror=implicit-function-declaration]:  => 3118:2
  + drivers/regulator/fixed.c: error: implicit declaration of function 'gpio_request_one' [-Werror=implicit-function-declaration]:  => 238:3
  + drivers/regulator/tps62360-regulator.c: error: implicit declaration of function 'gpio_request_one' [-Werror=implicit-function-declaration]:  => 452:3
  + drivers/regulator/wm831x-dcdc.c: error: implicit declaration of function 'gpio_request_one' [-Werror=implicit-function-declaration]:  => 411:2
  + drivers/staging/ipack/bridges/tpci200.c: error: implicit declaration of function 'ioread16' [-Werror=implicit-function-declaration]:  => 81:2
  + drivers/staging/ipack/bridges/tpci200.c: error: implicit declaration of function 'ioread32' [-Werror=implicit-function-declaration]:  => 87:2
  + drivers/staging/ipack/bridges/tpci200.c: error: implicit declaration of function 'ioread8' [-Werror=implicit-function-declaration]:  => 75:2
  + drivers/staging/ipack/bridges/tpci200.c: error: implicit declaration of function 'iowrite16' [-Werror=implicit-function-declaration]:  => 100:2
  + drivers/staging/ipack/bridges/tpci200.c: error: implicit declaration of function 'iowrite32' [-Werror=implicit-function-declaration]:  => 107:2
  + drivers/staging/ipack/bridges/tpci200.c: error: implicit declaration of function 'iowrite8' [-Werror=implicit-function-declaration]:  => 93:2
  + drivers/staging/ipack/bridges/tpci200.c: error: implicit declaration of function 'kfree' [-Werror=implicit-function-declaration]:  => 300:2
  + drivers/staging/ipack/bridges/tpci200.c: error: implicit declaration of function 'kzalloc' [-Werror=implicit-function-declaration]:  => 951:2
  + drivers/staging/ipack/bridges/tpci200.c: error: implicit declaration of function 'pci_iounmap' [-Werror=implicit-function-declaration]:  => 289:2
  + drivers/staging/speakup/serialio.c: error: invalid operands to binary & (have 'void *' and 'int'):  => 52:137
  + drivers/staging/speakup/serialio.c: error: invalid operands to binary >> (have 'void *' and 'int'):  => 53:137
  + drivers/staging/speakup/serialio.c: error: invalid operands to binary | (have 'void *' and 'int'):  => 51:137, 110:148, 107:149, 58:137
  + drivers/staging/speakup/speakup_apollo.c: error: invalid operands to binary | (have 'void *' and 'int'):  => 177:151
  + drivers/usb/chipidea/ci.h: error: implicit declaration of function 'ioread32' [-Werror=implicit-function-declaration]:  => 255:2
  + drivers/usb/chipidea/ci.h: error: implicit declaration of function 'iowrite32' [-Werror=implicit-function-declaration]:  => 271:2
  + drivers/usb/chipidea/core.c: error: implicit declaration of function 'ioread8' [-Werror=implicit-function-declaration]:  => 183:2
  + drivers/video/auo_k190x.c: error: implicit declaration of function 'gpio_direction_output' [-Werror=implicit-function-declaration]:  => 831:2
  + drivers/video/auo_k190x.c: error: implicit declaration of function 'gpio_free' [-Werror=implicit-function-declaration]:  => 996:2
  + drivers/video/auo_k190x.c: error: implicit declaration of function 'gpio_request' [-Werror=implicit-function-declaration]:  => 824:2
  + drivers/video/console/fonts.c: error: #error No fonts configured.:  => 71:2
  + drivers/vme/boards/vme_vmivme7805.c: error: implicit declaration of function 'ioread32' [-Werror=implicit-function-declaration]:  => 80:2
  + drivers/vme/boards/vme_vmivme7805.c: error: implicit declaration of function 'iowrite32' [-Werror=implicit-function-declaration]:  => 77:2
  + drivers/vme/bridges/vme_ca91cx42.c: error: implicit declaration of function 'ioread16' [-Werror=implicit-function-declaration]:  => 891:4
  + drivers/vme/bridges/vme_ca91cx42.c: error: implicit declaration of function 'ioread32' [-Werror=implicit-function-declaration]:  => 104:2
  + drivers/vme/bridges/vme_ca91cx42.c: error: implicit declaration of function 'ioread8' [-Werror=implicit-function-declaration]:  => 880:3
  + drivers/vme/bridges/vme_ca91cx42.c: error: implicit declaration of function 'iowrite16' [-Werror=implicit-function-declaration]:  => 945:4
  + drivers/vme/bridges/vme_ca91cx42.c: error: implicit declaration of function 'iowrite32' [-Werror=implicit-function-declaration]:  => 193:2
  + drivers/vme/bridges/vme_ca91cx42.c: error: implicit declaration of function 'iowrite8' [-Werror=implicit-function-declaration]:  => 934:3
  + drivers/vme/bridges/vme_tsi148.c: error: implicit declaration of function 'ioread16' [-Werror=implicit-function-declaration]:  => 1339:2
  + drivers/vme/bridges/vme_tsi148.c: error: implicit declaration of function 'ioread32' [-Werror=implicit-function-declaration]:  => 2325:2
  + drivers/vme/bridges/vme_tsi148.c: error: implicit declaration of function 'ioread32be' [-Werror=implicit-function-declaration]:  => 131:4
  + drivers/vme/bridges/vme_tsi148.c: error: implicit declaration of function 'ioread8' [-Werror=implicit-function-declaration]:  => 237:4
  + drivers/vme/bridges/vme_tsi148.c: error: implicit declaration of function 'iowrite32be' [-Werror=implicit-function-declaration]:  => 161:2
  + drivers/watchdog/wm831x_wdt.c: error: implicit declaration of function 'gpio_request_one' [-Werror=implicit-function-declaration]:  => 250:4
  + error: No rule to make target arch/cris/arch-v10/drivers/ds1302.o:  => N/A
  + error: mv643xx_eth.c: undefined reference to `clk_disable':  => .text+0xd3720)
  + error: mv643xx_eth.c: undefined reference to `clk_enable':  => .text+0xd6454)
  + error: mv643xx_eth.c: undefined reference to `clk_get':  => .text+0xd6440)
  + error: mv643xx_eth.c: undefined reference to `clk_get_rate':  => .text+0xd645c)
  + error: mv643xx_eth.c: undefined reference to `clk_put':  => .text+0xd3728)
  + include/linux/gpio.h: error: implicit declaration of function '__gpio_cansleep' [-Werror=implicit-function-declaration]:  => 62:2
  + include/linux/gpio.h: error: implicit declaration of function '__gpio_to_irq' [-Werror=implicit-function-declaration]:  => 67:2
  + include/linux/gpio.h: error: redefinition of 'gpio_cansleep':  => 60:50
  + include/linux/pagemap.h: error: assignment of read-only variable '__gu_val': 448:5, 442:2 => 448:4, 499:3, 508:3, 442:2
  + include/linux/thread_info.h: error: 'TAINT_WARN' undeclared (first use in this function):  => 129:418, 129:495
  + mm/nommu.c: error: 'ret' undeclared (first use in this function):  => 1489:2
  + net/mac80211/ieee80211_i.h: error: field 'trig' has incomplete type:  => 787:21
  + net/mac80211/led.c: error: 'struct led_classdev' has no member named 'trig_list':  => 278:411, 278:352, 278:59, 214:352, 214:411, 214:160, 278:319, 214:223, 214:319, 278:160, 214:59, 278:223
  + net/mac80211/led.c: error: dereferencing pointer to incomplete type:  => 74:16, 83:16, 101:19, 92:19
  + net/mac80211/led.c: error: implicit declaration of function 'led_trigger_register' [-Werror=implicit-function-declaration]:  => 75:3
  + net/mac80211/led.c: error: implicit declaration of function 'led_trigger_unregister' [-Werror=implicit-function-declaration]:  => 119:3
  + net/mac80211/led.c: error: invalid application of 'sizeof' to incomplete type 'struct led_trigger' :  => 90:36, 72:33, 99:36, 81:33
  + security/security.c: error: 'BDI_CAP_EXEC_MAP' undeclared (first use in this function):  => 688:16
  + security/security.c: error: dereferencing pointer to incomplete type:  => 687:36

607 improvements:
  - drivers/media/video/uvc/uvc_queue.c: error: 'buf' undeclared (first use in this function): 263:23 => 
  - drivers/media/video/uvc/uvc_queue.c: error: 'struct uvc_video_queue' has no member named 'buffer': 255:18 => 
  - drivers/media/video/uvc/uvc_queue.c: error: 'struct uvc_video_queue' has no member named 'count': 259:16, 254:23 => 
  - drivers/media/video/uvc/uvc_queue.c: error: 'struct vb2_buffer' has no member named 'm': 256:19 => 
  - error: "__ashrdi3" [fs/ntfs/ntfs.ko] undefined!: N/A => 
  - error: "__ashrdi3" [fs/xfs/xfs.ko] undefined!: N/A => 
  - error: "__lshrdi3" [drivers/mtd/mtd.ko] undefined!: N/A => 
  - error: "__lshrdi3" [fs/ntfs/ntfs.ko] undefined!: N/A => 
  - error: "__lshrdi3" [fs/xfs/xfs.ko] undefined!: N/A => 
  - error: arch/xtensa/platforms/iss/built-in.o: undefined reference to `__netif_schedule': .text+0x48) => 
  - error: arch/xtensa/platforms/iss/built-in.o: undefined reference to `alloc_etherdev_mqs': .text+0x11c) => 
  - error: arch/xtensa/platforms/iss/built-in.o: undefined reference to `consume_skb': .text+0x4c) => 
  - error: arch/xtensa/platforms/iss/built-in.o: undefined reference to `dev_alloc_skb': .text+0x60) => 
  - error: arch/xtensa/platforms/iss/built-in.o: undefined reference to `dev_close': .text+0x84) => 
  - error: arch/xtensa/platforms/iss/built-in.o: undefined reference to `eth_type_trans': .text+0xac) => 
  - error: arch/xtensa/platforms/iss/built-in.o: undefined reference to `eth_validate_addr': .rodata+0x114) => 
  - error: arch/xtensa/platforms/iss/built-in.o: undefined reference to `free_netdev': .text+0x134) => 
  - error: arch/xtensa/platforms/iss/built-in.o: undefined reference to `kfree_skb': .text+0x70) => 
  - error: arch/xtensa/platforms/iss/built-in.o: undefined reference to `netif_rx_ni': .text+0x6c) => 
  - error: arch/xtensa/platforms/iss/built-in.o: undefined reference to `register_netdevice': .text+0x12c) => 
  - error: arch/xtensa/platforms/iss/built-in.o: undefined reference to `rtnl_lock': .text+0x128) => 
  - error: arch/xtensa/platforms/iss/built-in.o: undefined reference to `rtnl_unlock': .text+0x130) => 
  - error: arch/xtensa/platforms/iss/built-in.o: undefined reference to `skb_put': .text+0x64) => 
  - error: arch/xtensa/platforms/iss/built-in.o: undefined reference to `skb_trim': .text+0x68) => 
  - error: kernel/built-in.o: undefined reference to `_sdata': .text+0x8c0), .text+0x84c) => 
  - error: network.c: undefined reference to `__netif_schedule': .text+0x3d7) => 
  - error: network.c: undefined reference to `alloc_etherdev_mqs': .text+0x8c8) => 
  - error: network.c: undefined reference to `consume_skb': .text+0x42e) => 
  - error: network.c: undefined reference to `dev_alloc_skb': .text+0x4c8) => 
  - error: network.c: undefined reference to `dev_close': .text+0x683) => 
  - error: network.c: undefined reference to `eth_type_trans': .text+0x7db) => 
  - error: network.c: undefined reference to `free_netdev': .text+0xad2) => 
  - error: network.c: undefined reference to `kfree_skb': .text+0x548) => 
  - error: network.c: undefined reference to `netif_rx_ni': .text+0x53e) => 
  - error: network.c: undefined reference to `register_netdevice': .text+0xab7) => 
  - error: network.c: undefined reference to `rtnl_lock': .text+0xaaf) => 
  - error: network.c: undefined reference to `rtnl_unlock': .text+0xabf) => 
  - error: network.c: undefined reference to `skb_put': .text+0x507) => 
  - error: network.c: undefined reference to `skb_trim': .text+0x514) => 
  - error: via-pmu-event.c: undefined reference to `.input_allocate_device': .init.text+0x8aa4) => 
  - error: via-pmu-event.c: undefined reference to `.input_free_device': .init.text+0x8b68) => 
  - error: via-pmu-event.c: undefined reference to `.input_register_device': .init.text+0x8b54) => 
  - error: vsprintf.c: relocation truncated to fit: R_AVR32_9UW_PCREL against `.text'+9e4: (.text+0x7da) => 
  - error: vsprintf.c: relocation truncated to fit: R_AVR32_9UW_PCREL against `.text'+9e8: (.text+0x7ea) => 
  - include/linux/types.h: error: unknown type name '__kernel_caddr_t': 88:1 => 
  - include/linux/types.h: error: unknown type name '__kernel_clock_t': 83:1 => 
  - include/linux/types.h: error: unknown type name '__kernel_clockid_t': 35:1 => 
  - include/linux/types.h: error: unknown type name '__kernel_daddr_t': 242:2, 31:1 => 
  - include/linux/types.h: error: unknown type name '__kernel_gid16_t': 43:1 => 
  - include/linux/types.h: error: unknown type name '__kernel_gid32_t': 41:1 => 
  - include/linux/types.h: error: unknown type name '__kernel_ino_t': 25:1, 243:2 => 
  - include/linux/types.h: error: unknown type name '__kernel_loff_t': 54:1 => 
  - include/linux/types.h: error: unknown type name '__kernel_off_t': 29:1 => 
  - include/linux/types.h: error: unknown type name '__kernel_old_gid_t': 50:1 => 
  - include/linux/types.h: error: unknown type name '__kernel_old_uid_t': 49:1 => 
  - include/linux/types.h: error: unknown type name '__kernel_pid_t': 30:1 => 
  - include/linux/types.h: error: unknown type name '__kernel_suseconds_t': 33:1 => 
  - include/linux/types.h: error: unknown type name '__kernel_time_t': 78:1 => 
  - include/linux/types.h: error: unknown type name '__kernel_timer_t': 34:1 => 
  - include/linux/types.h: error: unknown type name '__kernel_uid16_t': 42:1 => 
  - include/linux/types.h: error: unknown type name '__kernel_uid32_t': 40:1 => 


*** WARNINGS ***

539 regressions:
  + arch/arm/mm/dma-mapping.c: warning: 'page' may be used uninitialized in this function [-Wuninitialized]:  => 675:15
  + arch/blackfin/include/asm/bfin_serial.h: warning: "get_lsr_cache" redefined [enabled by default]:  => 383:0
  + arch/blackfin/include/asm/bfin_serial.h: warning: "port_membase" redefined [enabled by default]:  => 270:0
  + arch/blackfin/include/asm/bfin_serial.h: warning: "put_lsr_cache" redefined [enabled by default]:  => 384:0
  + arch/blackfin/include/asm/bfin_twi.h: warning: "ANOMALY_05001001" is not defined [-Wundef]:  => 87:6
  + arch/cris/arch-v10/drivers/axisflashmap.c: warning: format '%x' expects argument of type 'unsigned int', but argument 3 has type 'uint64_t' [-Wformat]:  => 350:11, 286:10, 368:10
  + arch/cris/arch-v10/drivers/axisflashmap.c: warning: format '%x' expects argument of type 'unsigned int', but argument 4 has type 'uint64_t' [-Wformat]:  => 350:11, 368:10
  + arch/cris/arch-v10/drivers/sync_serial.c: warning: passing argument 1 of 'memcpy' discards 'volatile' qualifier from pointer target type [enabled by default]:  => 1342:6, 1352:6
  + arch/cris/arch-v10/drivers/sync_serial.c: warning: passing argument 1 of 'virt_to_phys' discards 'const' qualifier from pointer target type [enabled by default]:  => 1223:2
  + arch/cris/arch-v10/kernel/kgdb.c: warning: 'copy_registers' defined but not used [-Wunused-function]:  => 508:1
  + arch/cris/arch-v10/kernel/kgdb.c: warning: 'copy_registers_from_stack' declared 'static' but never defined [-Wunused-function]:  => 255:13
  + arch/cris/arch-v10/kernel/kgdb.c: warning: 'copy_registers_to_stack' declared 'static' but never defined [-Wunused-function]:  => 259:13
  + arch/cris/arch-v10/kernel/kgdb.c: warning: 'current_thread_c' defined but not used [-Wunused-variable]:  => 425:12
  + arch/cris/arch-v10/kernel/kgdb.c: warning: 'current_thread_g' defined but not used [-Wunused-variable]:  => 426:12
  + arch/cris/arch-v10/kernel/kgdb.c: warning: 'do_printk' defined but not used [-Wunused-variable]:  => 679:12
  + arch/cris/arch-v10/kernel/kgdb.c: warning: 'handle_exception' defined but not used [-Wunused-function]:  => 924:1
  + arch/cris/arch-v10/kernel/kgdb.c: warning: 'is_dyn_brkp' defined but not used [-Wunused-variable]:  => 442:22
  + arch/cris/arch-v10/kernel/kgdb.c: warning: 'reg_g' defined but not used [-Wunused-variable]:  => 430:18
  + arch/cris/arch-v10/kernel/kgdb.c: warning: 'write_stack_register' declared 'static' but never defined [-Wunused-function]:  => 267:12
  + arch/cris/arch-v10/kernel/kgdb.c: warning: missing terminating " character [enabled by default]:  => 1359:1, 1273:6, 1457:1, 1370:6
  + arch/cris/arch-v32/drivers/axisflashmap.c: warning: ISO C90 forbids mixed declarations and code [-Wdeclaration-after-statement]:  => 397:3, 523:2
  + arch/cris/arch-v32/drivers/axisflashmap.c: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]:  => 586:8
  + arch/cris/arch-v32/drivers/axisflashmap.c: warning: format '%x' expects argument of type 'unsigned int', but argument 3 has type 'uint64_t' [-Wformat]:  => 336:10
  + arch/cris/arch-v32/kernel/debugport.c: warning: ISO C90 forbids mixed declarations and code [-Wdeclaration-after-statement]:  => 122:2
  + arch/cris/arch-v32/kernel/fasttimer.c: warning: ISO C90 forbids mixed declarations and code [-Wdeclaration-after-statement]:  => 352:2
  + arch/cris/arch-v32/mach-fs/pinmux.c: warning: ISO C90 forbids mixed declarations and code [-Wdeclaration-after-statement]:  => 225:2, 97:2
  + arch/cris/arch-v32/mm/intmem.c: warning: comparison of distinct pointer types lacks a cast [enabled by default]:  => 116:14, 123:14
  + arch/cris/arch-v32/mm/intmem.c: warning: initialization from incompatible pointer type [enabled by default]:  => 149:133
  + arch/cris/mm/fault.c: warning: ISO C90 forbids mixed declarations and code [-Wdeclaration-after-statement]:  => 227:3
  + arch/h8300/kernel/signal.c: warning: 'handle_signal' defined but not used [-Wunused-function]:  => 410:1
  + arch/m32r/kernel/signal.c: warning: 'return' with a value, in function returning void [enabled by default]:  => 289:6
  + arch/um/defconfig: warning: symbol value 'm' invalid for BLK_CGROUP:  => 166
  + arch/x86/xen/enlighten.c: warning: 'init_hvm_pv_info' defined but not used [-Wunused-function]:  => 1434:12
  + block/blk-cgroup.c: warning: unused variable 'q' [-Wunused-variable]:  => 248:24
  + block/blk-throttle.c: warning: value computed is not used [-Wunused-value]:  => 1035:3, 1036:3, 840:3
  + drivers/block/hd.c: warning: statement with no effect [-Wunused-value]:  => 467:2
  + drivers/block/paride/ppc6lnx.c: warning: statement with no effect [-Wunused-value]:  => 522:4
  + drivers/char/tpm/tpm.c: warning: format '%zd' expects argument of type 'signed size_t', but argument 3 has type 'ssize_t' [-Wformat]:  => 404:4, 437:4
  + drivers/gpu/drm/ast/ast_main.c: warning: assignment makes pointer from integer without a cast [enabled by default]:  => 345:14, 340:12
  + drivers/gpu/drm/mgag200/mgag200_main.c: warning: assignment makes pointer from integer without a cast [enabled by default]:  => 154:6, 187:14
  + drivers/gpu/drm/nouveau/nv40_grctx.c: warning: the frame size of 1184 bytes is larger than 1024 bytes [-Wframe-larger-than=]:  => 690:1
  + drivers/gpu/drm/nouveau/nve0_fifo.c: warning: assignment makes pointer from integer without a cast [enabled by default]:  => 114:13
  + drivers/hwmon/sch56xx-common.c: warning: 'address' may be used uninitialized in this function [-Wuninitialized]:  => 606:27
  + drivers/hwmon/sch56xx-common.c: warning: 'name' may be used uninitialized in this function [-Wuninitialized]:  => 606:2
  + drivers/ide/ide-floppy.c: warning: 'pc' may be used uninitialized in this function [-Wuninitialized]:  => 296:2
  + drivers/ide/ide-io-std.c: warning: statement with no effect [-Wunused-value]:  => 201:3, 186:4
  + drivers/input/gameport/lightning.c: warning: unused variable 'l4' [-Wunused-variable]:  => 78:13
  + drivers/media/dvb/frontends/cx24110.c: warning: value computed is not used [-Wunused-value]:  => 520:40
  + drivers/media/rc/ene_ir.c: warning: 'ene_remove' defined but not used [-Wunused-function]:  => 1107:13
  + drivers/media/video/as3645a.c: warning: 'mode' may be used uninitialized in this function [-Wuninitialized]:  => 273:2
  + drivers/media/video/as3645a.c: warning: 'on' may be used uninitialized in this function [-Wuninitialized]:  => 273:28
  + drivers/media/video/smiapp/smiapp-core.c: warning: assignment makes pointer from integer without a cast [enabled by default]:  => 2808:9, 2472:15
  + drivers/mfd/da9052-core.c: warning: unused variable 'desc' [-Wunused-variable]:  => 775:19
  + drivers/mfd/rc5t583-irq.c: warning: 'master_int' may be used uninitialized in this function [-Wuninitialized]: 276:20 => 258:10, 276:20
  + drivers/mfd/tps6586x.c: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]:  => 531:16
  + drivers/mfd/tps65910.c: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]:  => 157:14
  + drivers/mtd/chips/cfi_cmdset_0001.c: warning: the frame size of 1484 bytes is larger than 1024 bytes [-Wframe-larger-than=]:  => 1797:1
  + drivers/mtd/chips/cfi_cmdset_0002.c: warning: 'r.x[0]' may be used uninitialized in this function [-Wuninitialized]: 1350:7, 1773:7, 651:2, 1390:93, 1412:15 => 1364:7, 1426:3, 1787:7, 665:2, 1425:9, 1404:2
  + drivers/mtd/chips/cfi_cmdset_0020.c: warning: the frame size of 1224 bytes is larger than 1024 bytes [-Wframe-larger-than=]:  => 420:1
  + drivers/mtd/chips/cfi_cmdset_0020.c: warning: the frame size of 1408 bytes is larger than 1024 bytes [-Wframe-larger-than=]:  => 975:1
  + drivers/mtd/chips/cfi_cmdset_0020.c: warning: the frame size of 1472 bytes is larger than 1024 bytes [-Wframe-larger-than=]:  => 975:1
  + drivers/mtd/chips/cfi_cmdset_0020.c: warning: the frame size of 1716 bytes is larger than 1024 bytes [-Wframe-larger-than=]:  => 654:1
  + drivers/mtd/chips/cfi_cmdset_0020.c: warning: the frame size of 1764 bytes is larger than 1024 bytes [-Wframe-larger-than=]:  => 654:1
  + drivers/mtd/ftl.c: warning: passing argument 4 of 'mtd_read' from incompatible pointer type [enabled by default]:  => 527:28, 228:24, 294:24, 490:24
  + drivers/mtd/ftl.c: warning: passing argument 4 of 'mtd_write' from incompatible pointer type [enabled by default]:  => 557:21, 535:29, 442:25, 566:21, 426:21, 507:21
  + drivers/net/can/cc770/cc770_isa.c: warning: unused variable 'base' [-Wunused-variable]:  => 160:16
  + drivers/net/ethernet/broadcom/bnx2.c: warning: assignment makes pointer from integer without a cast [enabled by default]:  => 8037:14
  + drivers/net/ethernet/dec/tulip/dmfe.c: warning: assignment makes pointer from integer without a cast [enabled by default]:  => 464:13
  + drivers/net/ethernet/dec/tulip/uli526x.c: warning: assignment makes pointer from integer without a cast [enabled by default]:  => 363:9
  + drivers/net/ethernet/dec/tulip/xircom_cb.c: warning: assignment makes pointer from integer without a cast [enabled by default]:  => 258:18
  + drivers/net/ethernet/dlink/dl2k.c: warning: assignment makes pointer from integer without a cast [enabled by default]:  => 150:9
  + drivers/net/ethernet/emulex/benet/be_main.c: warning: assignment makes pointer from integer without a cast [enabled by default]:  => 3264:7
  + drivers/net/ethernet/seeq/seeq8005.c: warning: statement with no effect [-Wunused-value]:  => 559:4
  + drivers/net/ethernet/sis/sis900.c: warning: assignment makes pointer from integer without a cast [enabled by default]:  => 480:9
  + drivers/net/ethernet/smsc/epic100.c: warning: assignment makes pointer from integer without a cast [enabled by default]:  => 368:9
  + drivers/net/hamradio/baycom_ser_fdx.c: warning: statement with no effect [-Wunused-value]:  => 308:4, 396:2, 397:2, 312:4
  + drivers/net/hamradio/baycom_ser_fdx.c: warning: suggest explicit braces to avoid ambiguous 'else' [-Wparentheses]:  => 328:7
  + drivers/net/hamradio/baycom_ser_hdx.c: warning: statement with no effect [-Wunused-value]:  => 414:4, 397:4, 455:2, 456:2, 393:4
  + drivers/net/hamradio/yam.c: warning: statement with no effect [-Wunused-value]:  => 526:2, 907:3, 314:2, 315:2, 490:2, 525:2, 491:2
  + drivers/net/hippi/rrunner.c: warning: assignment makes pointer from integer without a cast [enabled by default]:  => 152:15
  + drivers/net/wimax/i2400m/control.c: warning: format '%zu' expects argument of type 'size_t', but argument 4 has type 'ssize_t' [-Wformat]:  => 134:10, 239:6
  + drivers/net/wimax/i2400m/control.c: warning: format '%zu' expects argument of type 'size_t', but argument 5 has type 'ssize_t' [-Wformat]:  => 239:6
  + drivers/net/wimax/i2400m/usb-fw.c: warning: format '%zd' expects argument of type 'signed size_t', but argument 4 has type 'ssize_t' [-Wformat]:  => 210:4
  + drivers/net/wimax/i2400m/usb-fw.c: warning: format '%zd' expects argument of type 'signed size_t', but argument 8 has type 'ssize_t' [-Wformat]:  => 222:2
  + drivers/net/wimax/i2400m/usb-fw.c: warning: format '%zu' expects argument of type 'size_t', but argument 4 has type 'ssize_t' [-Wformat]:  => 215:4
  + drivers/net/wireless/ath/ath6kl/htc_pipe.c: warning: integer overflow in expression [-Woverflow]:  => 1282:26, 1282:227
  + drivers/net/wireless/ath/carl9170/fwcmd.h: warning: 'packed' attribute ignored for field of type 'struct <anonymous>[]' [-Wattributes]:  => 123:2
  + drivers/net/wireless/brcm80211/brcmsmac/aiutils.c: warning: 'w' may be used uninitialized in this function [-Wuninitialized]:  => 823:9
  + drivers/net/wireless/ipw2x00/ipw2100.c: warning: assignment makes pointer from integer without a cast [enabled by default]:  => 6242:9
  + drivers/net/wireless/p54/lmac.h: warning: 'packed' attribute ignored for field of type 'struct <anonymous>[3]' [-Wattributes]:  => 377:2
  + drivers/pci/quirks.c: warning: assignment makes pointer from integer without a cast [enabled by default]:  => 3114:12
  + drivers/power/smb347-charger.c: warning: 'smb347_remove' defined but not used [-Wunused-function]:  => 1109:12
  + drivers/pps/clients/pps-gpio.c: warning: 'pps_gpio_remove' defined but not used [-Wunused-function]:  => 183:12
  + drivers/regulator/tps62360-regulator.c: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]:  => 384:13
  + drivers/scsi/qla4xxx/ql4_nx.c: warning: format '%lx' expects argument of type 'long unsigned int', but argument 5 has type 'uint32_t' [-Wformat]:  => 1867:2
  + drivers/staging/bcm/Bcmchar.c: warning: format '%zd' expects argument of type 'signed size_t', but argument 2 has type 'ssize_t' [-Wformat]:  => 146:3
  + drivers/staging/bcm/Bcmchar.c: warning: format '%zd' expects argument of type 'signed size_t', but argument 3 has type 'ssize_t' [-Wformat]:  => 146:3
  + drivers/staging/ipack/bridges/tpci200.c: warning: assignment makes pointer from integer without a cast [enabled by default]:  => 1048:16, 1017:17, 951:11, 1044:10
  + drivers/staging/media/easycap/easycap_main.c: warning: 'rc' may be used uninitialized in this function [-Wuninitialized]:  => 3985:6
  + drivers/staging/ramster/cluster/tcp.c: warning: format '%zd' expects argument of type 'signed size_t', but argument 12 has type 'ssize_t' [-Wformat]:  => 1003:3
  + drivers/staging/rts5139/rts51x.c: warning: 'rts51x_try_to_enter_ss' defined but not used [-Wunused-function]:  => 204:13
  + drivers/staging/speakup/serialio.c: warning: statement with no effect [-Wunused-value]:  => 114:2, 113:2, 115:2, 112:2
  + drivers/staging/speakup/synth.c: warning: suggest explicit braces to avoid ambiguous 'else' [-Wparentheses]:  => 142:6
  + drivers/staging/wlan-ng/prism2fw.c: warning: the frame size of 4228 bytes is larger than 1024 bytes [-Wframe-larger-than=]:  => 1115:1
  + drivers/staging/xgifb/vb_table.h: warning: (near initialization for 'XGI330_StandTable.CRTC') [-Wmissing-braces]:  => 214:3
  + drivers/staging/xgifb/vb_table.h: warning: (near initialization for 'XGI330_StandTable.CRTC[1]') [enabled by default]:  => 215:2, 218:3, 217:3, 216:3
  + drivers/staging/xgifb/vb_table.h: warning: (near initialization for 'XGI330_StandTable.CRTC[2]') [enabled by default]:  => 219:2, 220:3, 221:3
  + drivers/staging/xgifb/vb_table.h: warning: (near initialization for 'XGI330_StandTable.CRTC[3]') [enabled by default]:  => 223:3, 222:2
  + drivers/tty/serial/8250/8250.c: warning: statement with no effect [-Wunused-value]:  => 2134:3
  + drivers/tty/serial/crisv10.c: warning: 'ser_interrupt' defined but not used [-Wunused-function]:  => 2600:1
  + drivers/tty/serial/kgdboc.c: warning: statement with no effect [-Wunused-value]:  => 278:3, 292:3
  + drivers/tty/serial/serial_txx9.c: warning: "CONFIG_CONSOLE_POLL" is not defined [-Wundef]:  => 469:45
  + drivers/usb/gadget/f_hid.c: warning: format '%zd' expects argument of type 'signed size_t', but argument 3 has type 'ssize_t' [-Wformat]:  => 233:3
  + drivers/usb/gadget/inode.c: warning: format '%Zd' expects argument of type 'signed size_t', but argument 5 has type 'ssize_t' [-Wformat]:  => 1924:21
  + drivers/usb/host/isp1362.h: warning: statement with no effect [-Wunused-value]:  => 729:3
  + drivers/usb/misc/sisusbvga/sisusb.c: warning: format '%zd' expects argument of type 'signed size_t', but argument 3 has type 'ssize_t' [-Wformat]:  => 982:7
  + drivers/usb/misc/sisusbvga/sisusb.c: warning: passing argument 7 of 'sisusb_write_mem_bulk' from incompatible pointer type [enabled by default]:  => 1336:2
  + drivers/usb/misc/sisusbvga/sisusb_con.c: warning: passing argument 5 of 'sisusb_copy_memory' from incompatible pointer type [enabled by default]:  => 996:4, 880:5, 554:5, 472:5, 985:4, 418:5, 991:4, 505:5, 664:5, 383:5
  + drivers/usb/musb/musb_io.h: warning: statement with no effect [-Wunused-value]:  => 47:4, 45:4, 49:4
  + drivers/virtio/virtio_mmio.c: warning: format '%u' expects argument of type 'unsigned int *', but argument 4 has type 'resource_size_t *' [-Wformat]:  => 526:4
  + fs/9p/xattr.c: warning: format '%zd' expects argument of type 'signed size_t', but argument 4 has type 'ssize_t' [-Wformat]:  => 35:3
  + fs/afs/internal.h: warning: 'packed' attribute ignored for field of type 'enum <anonymous>' [-Wattributes]:  => 163:2
  + fs/afs/write.c: warning: format '%zd' expects argument of type 'signed size_t', but argument 4 has type 'ssize_t' [-Wformat]:  => 653:2, 649:3
  + fs/btrfs/inode.c: warning: 'cow_start' may be used uninitialized in this function [-Wuninitialized]:  => 1333:7
  + fs/cifs/connect.c: warning: format '%zd' expects argument of type 'signed size_t', but argument 3 has type 'ssize_t' [-Wformat]:  => 2514:3, 2532:3, 2522:3, 2507:3
  + fs/cifs/xattr.c: warning: format '%zd' expects argument of type 'signed size_t', but argument 3 has type 'ssize_t' [-Wformat]:  => 322:5
  + fs/ecryptfs/crypto.c: warning: format '%zd' expects argument of type 'signed size_t', but argument 3 has type 'ssize_t' [-Wformat]:  => 1513:11
  + fs/ecryptfs/miscdev.c: warning: format '%zd' expects argument of type 'signed size_t', but argument 3 has type 'ssize_t' [-Wformat]:  => 488:11, 448:10
  + fs/ext4/bitmap.c: warning: 'ext4_block_bitmap_csum_set' uses dynamic stack allocation [enabled by default]:  => 114:1
  + fs/ext4/bitmap.c: warning: 'ext4_block_bitmap_csum_verify' uses dynamic stack allocation [enabled by default]:  => 97:1
  + fs/ext4/bitmap.c: warning: 'ext4_inode_bitmap_csum_set' uses dynamic stack allocation [enabled by default]:  => 70:1
  + fs/ext4/bitmap.c: warning: 'ext4_inode_bitmap_csum_verify' uses dynamic stack allocation [enabled by default]:  => 53:1
  + fs/ext4/extents.c: warning: 'ext4_extent_block_csum' uses dynamic stack allocation [enabled by default]:  => 65:1
  + fs/ext4/ialloc.c: warning: 'ext4_new_inode' uses dynamic stack allocation [enabled by default]:  => 957:1
  + fs/ext4/inode.c: warning: 'ext4_iget' uses dynamic stack allocation [enabled by default]:  => 3913:1
  + fs/ext4/inode.c: warning: 'ext4_inode_csum' uses dynamic stack allocation [enabled by default]:  => 75:1
  + fs/ext4/inode.c: warning: format '%zd' expects argument of type 'signed size_t', but argument 6 has type 'ssize_t' [-Wformat]:  => 2835:2
  + fs/ext4/mmp.c: warning: 'ext4_mmp_csum' uses dynamic stack allocation [enabled by default]:  => 19:1
  + fs/ext4/namei.c: warning: 'ext4_dirent_csum' uses dynamic stack allocation [enabled by default]:  => 249:1
  + fs/ext4/namei.c: warning: 'ext4_dx_csum' uses dynamic stack allocation [enabled by default]:  => 345:1
  + fs/ext4/page-io.c: warning: format '%zd' expects argument of type 'signed size_t', but argument 6 has type 'ssize_t' [-Wformat]:  => 107:5
  + fs/ext4/super.c: warning: 'ext4_fill_super' uses dynamic stack allocation [enabled by default]:  => 3910:1
  + fs/ext4/super.c: warning: 'ext4_group_desc_csum' uses dynamic stack allocation [enabled by default]:  => 2012:1
  + fs/ext4/super.c: warning: 'ext4_superblock_csum' uses dynamic stack allocation [enabled by default]:  => 135:1
  + fs/ext4/xattr.c: warning: 'ext4_xattr_block_csum' uses dynamic stack allocation [enabled by default]:  => 145:1
  + fs/jbd2/commit.c: warning: '__kunmap_atomic_deprecated' is deprecated (declared at /scratch/kisskb/src/include/linux/highmem.h:135) [-Wdeprecated-declarations]:  => 357:1, 357:176
  + fs/jbd2/commit.c: warning: '__kunmap_atomic_deprecated' is deprecated (declared at /scratch/kisskb/src/include/linux/highmem.h:137):  => 357
  + fs/jbd2/commit.c: warning: 'jbd2_block_tag_csum_set.isra.5' uses dynamic stack allocation [enabled by default]:  => 360:1
  + fs/jbd2/commit.c: warning: 'jbd2_commit_block_csum_set' uses dynamic stack allocation [enabled by default]:  => 104:1
  + fs/jbd2/commit.c: warning: 'jbd2_descr_block_csum_set' uses dynamic stack allocation [enabled by default]:  => 339:1
  + fs/jbd2/commit.c: warning: 'kmap_atomic_deprecated' is deprecated (declared at /scratch/kisskb/src/include/linux/highmem.h:125) [-Wdeprecated-declarations]:  => 352:2
  + fs/jbd2/commit.c: warning: 'kmap_atomic_deprecated' is deprecated (declared at /scratch/kisskb/src/include/linux/highmem.h:127):  => 352
  + fs/jbd2/journal.c: warning: 'jbd2_journal_set_features' uses dynamic stack allocation [enabled by default]:  => 1796:1
  + fs/jbd2/journal.c: warning: 'jbd2_superblock_csum' uses dynamic stack allocation [enabled by default]:  => 119:1
  + fs/jbd2/journal.c: warning: 'journal_get_superblock' uses dynamic stack allocation [enabled by default]:  => 1499:1
  + fs/jbd2/recovery.c: warning: 'jbd2_block_tag_csum_verify.isra.0' uses dynamic stack allocation [enabled by default]:  => 411:1
  + fs/jbd2/recovery.c: warning: 'jbd2_commit_block_csum_verify' uses dynamic stack allocation [enabled by default]:  => 394:1
  + fs/jbd2/recovery.c: warning: 'jbd2_descr_block_csum_verify' uses dynamic stack allocation [enabled by default]:  => 195:1
  + fs/jbd2/recovery.c: warning: 'jbd2_revoke_block_csum_verify' uses dynamic stack allocation [enabled by default]:  => 823:1
  + fs/jbd2/revoke.c: warning: 'jbd2_revoke_csum_set' uses dynamic stack allocation [enabled by default]:  => 655:1
  + fs/ncpfs/ncp_fs_sb.h: warning: 'packed' attribute ignored for field of type '__u16' [-Wattributes]:  => 130:4, 127:4, 129:4, 128:4, 126:4
  + fs/ncpfs/ncp_fs_sb.h: warning: 'packed' attribute ignored for field of type '__u32' [-Wattributes]:  => 125:4, 124:4
  + fs/ocfs2/cluster/tcp.c: warning: format '%zd' expects argument of type 'signed size_t', but argument 12 has type 'ssize_t' [-Wformat]:  => 997:3
  + fs/ocfs2/dlmfs/dlmfs.c: warning: format '%zd' expects argument of type 'signed size_t', but argument 7 has type 'ssize_t' [-Wformat]:  => 328:2, 284:2
  + fs/quota/quota_tree.c: warning: format '%zd' expects argument of type 'signed size_t', but argument 4 has type 'ssize_t' [-Wformat]:  => 372:4
  + fs/quota/quota_v2.c: warning: format '%zd' expects argument of type 'signed size_t', but argument 5 has type 'ssize_t' [-Wformat]:  => 66:92
  + include/linux/sysv_fs.h: warning: 'packed' attribute ignored for field of type '__fs32' [-Wattributes]:  => 114:2, 181:2, 130:2, 43:2, 42:2, 30:2, 142:2, 100:2, 180:2, 168:2, 144:2, 112:2
  + include/linux/sysv_fs.h: warning: 'packed' attribute ignored for field of type 'sysv_zone_t[64]' [-Wattributes]:  => 171:2
  + include/linux/vga_switcheroo.h: warning: 'struct pci_dev' declared inside parameter list [enabled by default]: 49:91, 53:34, 28:30, 54:108 => 58:108, 32:50, 33:25, 55:91, 34:28, 57:16, 62:2, 28:30
  + include/net/ipx.h: warning: 'packed' attribute ignored for field of type '__be16' [-Wattributes]:  => 30:2, 32:2
  + include/net/ipx.h: warning: 'packed' attribute ignored for field of type 'struct ipx_address' [-Wattributes]:  => 42:9, 41:9
  + kernel/cgroup.c: warning: integer overflow in expression [-Woverflow]:  => 4156:32, 4156:21
  + kernel/sched/core.c: warning: unsupported argument to '__builtin_return_address' [enabled by default]:  => 3073:51, 3071:50
  + kernel/signal.c: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]: 2707:1244, 2683:2561, 2683:1202, 2676:2634, 2676:1245, 2707:2633, 3074:2342, 3074:1073 => 2718:2633, 2687:2634, 2722:1223, 2718:1244, 3092:1073, 2722:2597, 2694:2561, 2687:1245, 3092:2342, 2694:1202
  + kernel/trace/trace_events_filter.c: warning: 'ret' may be used uninitialized in this function [-Wuninitialized]: 2074:8 => 2074:8, 2005:17
  + lib/crc32.c: warning: unused variable 't4' [-Wunused-variable]:  => 77:13
  + lib/crc32.c: warning: unused variable 't5' [-Wunused-variable]:  => 77:27
  + lib/crc32.c: warning: unused variable 't6' [-Wunused-variable]:  => 77:41
  + lib/crc32.c: warning: unused variable 't7' [-Wunused-variable]:  => 77:55
  + lib/iomap.c: warning: statement with no effect [-Wunused-value]:  => 205:154, 201:154, 197:154
  + mm/oom_kill.c: warning: 'points' may be used uninitialized in this function:  => 694
  + modpost: WARNING: modpost: Found 11 section mismatch(es).:  => N/A
  + net/ipv4/esp4.c: warning: 'net_adj' may be used uninitialized in this function [-Wuninitialized]:  => 477:29
  + net/irda/irnet/irnet_ppp.c: warning: format '%Zd' expects argument of type 'signed size_t', but argument 3 has type 'ssize_t' [-Wformat]:  => 334:7
  + net/sctp/protocol.c: warning: label 'free_next' defined but not used [-Wunused-label]:  => 676:1
  + net/sunrpc/auth_gss/auth_gss.c: warning: format '%Zd' expects argument of type 'signed size_t', but argument 2 has type 'ssize_t' [-Wformat]:  => 684:2
  + net/sunrpc/auth_gss/auth_gss.c: warning: format '%zd' expects argument of type 'signed size_t', but argument 3 has type 'ssize_t' [-Wformat]:  => 666:5
  + net/sunrpc/xprtsock.c: warning: format '%Zd' expects argument of type 'signed size_t', but argument 3 has type 'ssize_t' [-Wformat]:  => 1205:2
  + sound/soc/codecs/lm49453.c: warning: passing argument 3 of 'snd_soc_register_codec' discards 'const' qualifier from pointer target type [enabled by default]:  => 1511:89, 1511:24
  + warning:   CC [M]  drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.o:  => N/A
  + warning:   CC [M]  fs/reiserfs/fix_node.o:  => N/A
  + warning: "cause_of_death" [vmlinux] is COMMON symbol:  => N/A
  + warning: (LOCKDEP && FAULT_INJECTION_STACKTRACE_FILTER && LATENCYTOP && KMEMCHECK) selects FRAME_POINTER which has unmet direct dependencies (DEBUG_KERNEL && (CRIS || M68K || FRV || UML || AVR32 || SUPERH || BLACKFIN || MN10300) || ARCH_WANT_FRAME_POINTERS):  => N/A
  + warning: (PM_SLEEP_SMP) selects HOTPLUG_CPU which has unmet direct dependencies (SMP && HOTPLUG && EXPERIMENTAL && (PPC_PSERIES || PPC_PMAC || PPC_POWERNV)):  => N/A
  + warning: (PPC_PS3 && PPC_CELLEB && USB_EHCI_HCD_PMC_MSP && XPS_USB_HCD_XILINX && USB_OCTEON_EHCI) selects USB_EHCI_BIG_ENDIAN_MMIO which has unmet direct dependencies (USB_SUPPORT && USB_EHCI_HCD && (PPC_CELLEB || PPC_PS3 || 440EPX || ARCH_IXP4XX || XPS_USB_HCD_XILINX || PPC_MPC512x || CPU_CAVIUM_OCTEON || PMC_MSP || SPARC_LEON || MIPS_SEAD3)):  => N/A
  + warning: (XEN_FBDEV_FRONTEND) selects INPUT_XEN_KBDDEV_FRONTEND which has unmet direct dependencies (!S390 && !UML && INPUT && INPUT_MISC && XEN):  => N/A
  + warning: WARNING: sound/pci/hda/snd-hda-codec-via.o (.xt.lit): unexpected non-allocatable section.:  => N/A
  + warning: arch/powerpc/platforms/built-in.o(.text+0x180b4): Section mismatch in reference from the function .pci_dn_reconfig_notifier() to the function .devinit.text:.eeh_dev_init():  => N/A
  + warning: arch/powerpc/platforms/built-in.o(.text+0x180d4): Section mismatch in reference from the function .pci_dn_reconfig_notifier() to the function .devinit.text:.eeh_dev_init():  => N/A
  + warning: arch/powerpc/platforms/pseries/built-in.o(.text+0x4538): Section mismatch in reference from the function .pci_dn_reconfig_notifier() to the function .devinit.text:.eeh_dev_init():  => N/A
  + warning: arch/x86/built-in.o(.data+0x10020): Section mismatch in reference from the variable test_nmi_ipi_callback_na.11101 to the function .init.text:test_nmi_ipi_callback():  => N/A
  + warning: arch/x86/built-in.o(.data+0x15d90): Section mismatch in reference from the variable nmi_unk_cb_na.9883 to the function .init.text:nmi_unk_cb():  => N/A
  + warning: arch/x86/built-in.o(.data+0x15dd0): Section mismatch in reference from the variable test_nmi_ipi_callback_na.9897 to the function .init.text:test_nmi_ipi_callback():  => N/A
  + warning: arch/x86/built-in.o(.data+0xfff0): Section mismatch in reference from the variable nmi_unk_cb_na.11046 to the function .init.text:nmi_unk_cb():  => N/A
  + warning: arch/x86/kernel/built-in.o(.data+0x11d90): Section mismatch in reference from the variable nmi_unk_cb_na.9883 to the function .init.text:nmi_unk_cb():  => N/A
  + warning: arch/x86/kernel/built-in.o(.data+0x11dd0): Section mismatch in reference from the variable test_nmi_ipi_callback_na.9897 to the function .init.text:test_nmi_ipi_callback():  => N/A
  + warning: arch/x86/kernel/built-in.o(.data+0xcff0): Section mismatch in reference from the variable nmi_unk_cb_na.11046 to the function .init.text:nmi_unk_cb():  => N/A
  + warning: arch/x86/kernel/built-in.o(.data+0xd020): Section mismatch in reference from the variable test_nmi_ipi_callback_na.11101 to the function .init.text:test_nmi_ipi_callback():  => N/A
  + warning: drivers/built-in.o(.data+0x110898): Section mismatch in reference from the variable moschip7840_4port_device to the variable .devinit.rodata:id_table:  => N/A
  + warning: drivers/built-in.o(.init.text+0x289cc): Section mismatch in reference from the function .libfcoe_init() to the function .exit.text:.fcoe_transport_exit():  => N/A
  + warning: drivers/built-in.o(.init.text+0x82d8): Section mismatch in reference from the function libfcoe_init() to the function .exit.text:fcoe_transport_exit():  => N/A
  + warning: drivers/iio/industrialio.o (.xt.lit): unexpected non-allocatable section.:  => N/A
  + warning: drivers/iio/industrialio.o (.xt.prop): unexpected non-allocatable section.:  => N/A
  + warning: drivers/infiniband/hw/nes/iw_nes.o (.xt.lit): unexpected non-allocatable section.:  => N/A
  + warning: drivers/media/dvb/dvb-usb/dvb-usb-af9035.o (.xt.lit): unexpected non-allocatable section.:  => N/A
  + warning: drivers/media/dvb/dvb-usb/dvb-usb-af9035.o (.xt.prop): unexpected non-allocatable section.:  => N/A
  + warning: drivers/media/dvb/frontends/drxk.o (.xt.lit): unexpected non-allocatable section.:  => N/A
  + warning: drivers/media/dvb/mantis/mantis_core.o (.xt.lit): unexpected non-allocatable section.:  => N/A
  + warning: drivers/media/video/em28xx/em28xx-rc.o (.xt.lit): unexpected non-allocatable section.:  => N/A
  + warning: drivers/media/video/em28xx/em28xx-rc.o (.xt.prop): unexpected non-allocatable section.:  => N/A
  + warning: drivers/net/wireless/ti/wl1251/wl1251.o (.xt.lit): unexpected non-allocatable section.:  => N/A
  + warning: drivers/net/wireless/ti/wl1251/wl1251.o (.xt.prop): unexpected non-allocatable section.:  => N/A
  + warning: drivers/net/wireless/ti/wl1251/wl1251_sdio.o (.xt.lit): unexpected non-allocatable section.:  => N/A
  + warning: drivers/net/wireless/ti/wl1251/wl1251_sdio.o (.xt.prop): unexpected non-allocatable section.:  => N/A
  + warning: drivers/net/wireless/ti/wl1251/wl1251_spi.o (.xt.lit): unexpected non-allocatable section.:  => N/A
  + warning: drivers/net/wireless/ti/wl1251/wl1251_spi.o (.xt.prop): unexpected non-allocatable section.:  => N/A
  + warning: drivers/net/wireless/ti/wl12xx/wl12xx.o (.xt.lit): unexpected non-allocatable section.:  => N/A
  + warning: drivers/net/wireless/ti/wl12xx/wl12xx.o (.xt.prop): unexpected non-allocatable section.:  => N/A
  + warning: drivers/net/wireless/ti/wlcore/built-in.o (.xt.lit): unexpected non-allocatable section.:  => N/A
  + warning: drivers/net/wireless/ti/wlcore/built-in.o (.xt.prop): unexpected non-allocatable section.:  => N/A
  + warning: drivers/sbus/char/bbc.o(.devinit.text+0x8): Section mismatch in reference from the function bbc_i2c_probe() to the function .init.text:attach_one_i2c.constprop.0():  => N/A
  + warning: drivers/scsi/built-in.o(.init.text+0x1870): Section mismatch in reference from the function libfcoe_init() to the function .exit.text:fcoe_transport_exit():  => N/A
  + warning: drivers/scsi/built-in.o(.init.text+0x18cc): Section mismatch in reference from the function .libfcoe_init() to the function .exit.text:.fcoe_transport_exit():  => N/A
  + warning: drivers/scsi/fcoe/built-in.o(.init.text+0x598): Section mismatch in reference from the function .libfcoe_init() to the function .exit.text:.fcoe_transport_exit():  => N/A
  + warning: drivers/scsi/fcoe/built-in.o(.init.text+0x7c): Section mismatch in reference from the function libfcoe_init() to the function .exit.text:fcoe_transport_exit():  => N/A
  + warning: drivers/scsi/fcoe/libfcoe.o(.init.literal+0x8): Section mismatch in reference from the (unknown reference) (unknown) to the function .exit.text:fcoe_transport_exit():  => N/A
  + warning: drivers/scsi/fcoe/libfcoe.o(.init.text+0x13): Section mismatch in reference from the function init_module() to the function .exit.text:fcoe_transport_exit():  => N/A
  + warning: drivers/scsi/fcoe/libfcoe.o(.init.text+0x20): Section mismatch in reference from the function init_module() to the function .exit.text:fcoe_transport_exit():  => N/A
  + warning: drivers/scsi/fcoe/libfcoe.o(.init.text+0x24): Section mismatch in reference from the function init_module() to the function .exit.text:fcoe_transport_exit():  => N/A
  + warning: drivers/scsi/fcoe/libfcoe.o(.init.text+0x30): Section mismatch in reference from the function init_module() to the function .exit.text:fcoe_transport_exit():  => N/A
  + warning: drivers/scsi/fcoe/libfcoe.o(.init.text+0x3a): Section mismatch in reference from the function init_module() to the function .exit.text:fcoe_transport_exit():  => N/A
  + warning: drivers/scsi/fcoe/libfcoe.o(.init.text+0x44): Section mismatch in reference from the function init_module() to the function .exit.text:fcoe_transport_exit():  => N/A
  + warning: drivers/scsi/fcoe/libfcoe.o(.init.text+0x64): Section mismatch in reference from the function .init_module() to the function .exit.text:.fcoe_transport_exit():  => N/A
  + warning: drivers/scsi/fcoe/libfcoe.o(.init.text+0x64): Section mismatch in reference from the function .libfcoe_init() to the function .exit.text:.fcoe_transport_exit():  => N/A
  + warning: drivers/scsi/fcoe/libfcoe.o(.init.text+0x7c): Section mismatch in reference from the function init_module() to the function .exit.text:fcoe_transport_exit():  => N/A
  + warning: drivers/scsi/fcoe/libfcoe.o(.init.text+0x7c): Section mismatch in reference from the function libfcoe_init() to the function .exit.text:fcoe_transport_exit():  => N/A
  + warning: drivers/staging/gdm72xx/gdmwm.o (.xt.lit): unexpected non-allocatable section.:  => N/A
  + warning: drivers/staging/gdm72xx/gdmwm.o (.xt.prop): unexpected non-allocatable section.:  => N/A
  + warning: drivers/staging/ipack/bridges/tpci200.o(.data+0x28): Section mismatch in reference from the variable tpci200_pci_drv to the function .devexit.text:tpci200_pci_remove():  => N/A
  + warning: drivers/tty/serial/jsm/jsm.o (.xt.prop): unexpected non-allocatable section.:  => N/A
  + warning: drivers/usb/built-in.o(.data+0x13268): Section mismatch in reference from the variable moschip7840_4port_device to the variable .devinit.rodata:id_table:  => N/A
  + warning: drivers/usb/serial/built-in.o(.data+0x80c0): Section mismatch in reference from the variable moschip7840_4port_device to the variable .devinit.rodata:id_table:  => N/A
  + warning: drivers/usb/serial/built-in.o(.data+0xb418): Section mismatch in reference from the variable moschip7840_4port_device to the variable .devinit.rodata:id_table:  => N/A
  + warning: drivers/usb/serial/mos7840.o(.data+0x4): Section mismatch in reference from the variable moschip7840_4port_device to the variable .devinit.rodata:id_table:  => N/A
  + warning: drivers/usb/serial/mos7840.o(.data+0x78): Section mismatch in reference from the variable moschip7840_4port_device to the variable .devinit.rodata:id_table:  => N/A
  + warning: drivers/usb/serial/mos7840.o(.data+0x8): Section mismatch in reference from the variable moschip7840_4port_device to the variable .devinit.rodata:id_table:  => N/A
  + warning: drivers/usb/serial/mos7840.o(.data.rel+0x70): Section mismatch in reference from the variable moschip7840_4port_device to the variable .devinit.rodata:id_table:  => N/A
  + warning: fs/lockd/lockd.o (.xt.lit): unexpected non-allocatable section.:  => N/A
  + warning: net/irda/irda.o (.xt.lit): unexpected non-allocatable section.:  => N/A
  + warning: net/mac802154/mac802154.o (.xt.lit): unexpected non-allocatable section.:  => N/A
  + warning: net/mac802154/mac802154.o (.xt.prop): unexpected non-allocatable section.:  => N/A
  + warning: net/nfc/hci/hci.o (.xt.lit): unexpected non-allocatable section.:  => N/A
  + warning: net/nfc/hci/hci.o (.xt.prop): unexpected non-allocatable section.:  => N/A
  + warning: net/nfc/nfc.o (.xt.lit): unexpected non-allocatable section.:  => N/A
  + warning: sound/soc/generic/snd-soc-simple-card.o (.xt.lit): unexpected non-allocatable section.:  => N/A
  + warning: sound/soc/generic/snd-soc-simple-card.o (.xt.prop): unexpected non-allocatable section.:  => N/A
  + warning: vmlinux.o(.data+0x184698): Section mismatch in reference from the variable moschip7840_4port_device to the variable .devinit.rodata:id_table:  => N/A
  + warning: vmlinux.o(.data+0x1bff0): Section mismatch in reference from the variable nmi_unk_cb_na.11046 to the function .init.text:nmi_unk_cb():  => N/A
  + warning: vmlinux.o(.data+0x1c020): Section mismatch in reference from the variable test_nmi_ipi_callback_na.11101 to the function .init.text:test_nmi_ipi_callback():  => N/A
  + warning: vmlinux.o(.data+0x20d90): Section mismatch in reference from the variable nmi_unk_cb_na.9883 to the function .init.text:nmi_unk_cb():  => N/A
  + warning: vmlinux.o(.data+0x20dd0): Section mismatch in reference from the variable test_nmi_ipi_callback_na.9897 to the function .init.text:test_nmi_ipi_callback():  => N/A
  + warning: vmlinux.o(.init.text+0x69530): Section mismatch in reference from the function libfcoe_init() to the function .exit.text:fcoe_transport_exit():  => N/A
  + warning: vmlinux.o(.init.text+0xa3738): Section mismatch in reference from the function .libfcoe_init() to the function .exit.text:.fcoe_transport_exit():  => N/A
  + warning: vmlinux.o(.text+0x2c724): Section mismatch in reference from the function .early_setup_secondary() to the function .cpuinit.text:.early_init_mmu_secondary():  => N/A
  + warning: vmlinux.o(.text+0x4e5f8): Section mismatch in reference from the function .wake_offline_cpus() to the function .cpuinit.text:.cpu_up():  => N/A
  + warning: vmlinux.o(.text+0x4fa14): Section mismatch in reference from the function .wake_offline_cpus() to the function .cpuinit.text:.cpu_up():  => N/A
  + warning: vmlinux.o(.text+0x727fc): Section mismatch in reference from the function .ics_rtas_init() to the function .init.text:.xics_register_ics():  => N/A
  + warning: vmlinux.o(.text+0x751a4): Section mismatch in reference from the function .ics_rtas_init() to the function .init.text:.xics_register_ics():  => N/A
  + warning: vmlinux.o(.text+0x8669c): Section mismatch in reference from the function .pnv_pci_ioda_msi_setup() to the function .devinit.text:.__pnv_ioda_get_one_pe():  => N/A
  + warning: vmlinux.o(.text+0x866b8): Section mismatch in reference from the function .pnv_pci_ioda_msi_setup() to the function .devinit.text:.__pnv_ioda_get_one_pe():  => N/A
  + warning: vmlinux.o(.text+0x8905c): Section mismatch in reference from the function .pnv_pci_ioda_msi_setup() to the function .devinit.text:.__pnv_ioda_get_one_pe():  => N/A
  + warning: vmlinux.o(.text+0x89078): Section mismatch in reference from the function .pnv_pci_ioda_msi_setup() to the function .devinit.text:.__pnv_ioda_get_one_pe():  => N/A
  + warning: vmlinux.o(.text+0x8af78): Section mismatch in reference from the function .pci_dn_reconfig_notifier() to the function .devinit.text:.update_dn_pci_info():  => N/A
  + warning: vmlinux.o(.text+0x8af94): Section mismatch in reference from the function .pci_dn_reconfig_notifier() to the function .devinit.text:.eeh_dev_init():  => N/A
  + warning: vmlinux.o(.text+0x8d938): Section mismatch in reference from the function .pci_dn_reconfig_notifier() to the function .devinit.text:.update_dn_pci_info():  => N/A
  + warning: vmlinux.o(.text+0x8d954): Section mismatch in reference from the function .pci_dn_reconfig_notifier() to the function .devinit.text:.eeh_dev_init():  => N/A
  + warning: vmlinux.o(.text+0x900c0): Section mismatch in reference from the function .dlpar_online_cpu() to the function .cpuinit.text:.cpu_up():  => N/A
  + warning: vmlinux.o(.text+0x92a80): Section mismatch in reference from the function .dlpar_online_cpu() to the function .cpuinit.text:.cpu_up():  => N/A
  + warning: vmlinux.o(.text+0x97c88): Section mismatch in reference from the function .pcibios_add_pci_devices() to the function .devinit.text:.of_rescan_bus():  => N/A
  + warning: vmlinux.o(.text+0x97d14): Section mismatch in reference from the function .pcibios_add_pci_devices() to the function .devinit.text:.pcibios_setup_bus_devices():  => N/A
  + warning: vmlinux.o(.text+0x97d78): Section mismatch in reference from the function .pcibios_add_pci_devices() to the function .devinit.text:.pci_scan_bridge():  => N/A
  + warning: vmlinux.o(.text+0x9abd4): Section mismatch in reference from the function .pcibios_add_pci_devices() to the function .devinit.text:.of_rescan_bus():  => N/A
  + warning: vmlinux.o(.text+0x9ac60): Section mismatch in reference from the function .pcibios_add_pci_devices() to the function .devinit.text:.pcibios_setup_bus_devices():  => N/A
  + warning: vmlinux.o(.text+0x9acc4): Section mismatch in reference from the function .pcibios_add_pci_devices() to the function .devinit.text:.pci_scan_bridge():  => N/A

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
