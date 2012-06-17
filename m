Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752572Ab2FQTqV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2012 15:46:21 -0400
Received: from gerard.telenet-ops.be ([195.130.132.48]:58633 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751271Ab2FQTqR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2012 15:46:17 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-kernel@vger.kernel.org
Subject: Build regressions/improvements in v3.5-rc3
Date: Sun, 17 Jun 2012 21:46:13 +0200
Message-Id: <1339962373-3224-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Below is the list of build error/warning regressions/improvements in
v3.5-rc3[1] compared to v3.4[2].

Too make this mail fit in the lkml limit, I deleted
  - 259 lines about __mcount_loc on sparc64
  - all error and warning improvements

Summarized:
  - build errors: +424/-574
  - build warnings: +730/-627

JFYI, when comparing v3.5-rc3 to v3.5-rc2[3], the summaries are:
  - build errors: +235/-10
  - build warnings: +968/-331

Note that there may be false regressions, as some logs are incomplete.
Still, they're build errors/warnings.

As I haven't mastered kup yet, there's no verbose summary at
http://www.kernel.org/pub/linux/kernel/people/geert/linux-log/v3.5-rc3.summary.gz

Happy fixing! ;-)

Thanks to the linux-next team for providing the build service.

[1] http://kisskb.ellerman.id.au/kisskb/head/5155/ (116 out of 115 configs)
[2] http://kisskb.ellerman.id.au/kisskb/head/5055/ (all 115 configs)
[3] http://kisskb.ellerman.id.au/kisskb/head/5131/ (all 115 configs)


*** ERRORS ***

424 regressions:
  + /opt/crosstool/gcc-4.6.3-nolibc/powerpc-linux/bin/../lib/gcc/powerpc-linux/4.6.3/include/stdarg.h: Error: Unrecognized opcode: `typedef':  => 40, 102
  + arch/cris/arch-v10/kernel/kgdb.c: error: expected string literal before '.' token:  => 1274:3
  + arch/cris/arch-v10/kernel/kgdb.c: error: missing terminating " character:  => 1359:1, 1370:1, 1273:1, 1457:1
  + arch/h8300/kernel/signal.c: error: expected '=', ',', ';', 'asm' or '__attribute__' before 'void':  => 450:8
  + arch/h8300/kernel/signal.c: error: implicit declaration of function 'do_signal' [-Werror=implicit-function-declaration]:  => 495:3
  + arch/mips/include/asm/bitops.h: error: static declaration of 'fls' follows non-static declaration:  => 615:50
  + arch/powerpc/include/asm/bitops.h: Error:   CC      arch/powerpc/kernel/pci_32.o:  => 285
  + arch/powerpc/include/asm/bitops.h: Error:   CC      arch/powerpc/kernel/setup_32.o:  => 149
  + arch/powerpc/include/asm/bitops.h: Error:   CC      arch/powerpc/math-emu/fctiwz.o:  => 155
  + arch/powerpc/include/asm/bitops.h: Error:   CC      arch/powerpc/oprofile/../../../drivers/oprofile/oprofilefs.o:  => 173
  + arch/powerpc/include/asm/bitops.h: Error:   CC      arch/powerpc/sysdev/dcr.o:  => 298
  + arch/powerpc/include/asm/bitops.h: Error:   CC      block/elevator.o:  => 131
  + arch/powerpc/include/asm/bitops.h: Error:   CC [M]  fs/xfs/xfs_globals.o:  => 133
  + arch/powerpc/include/asm/bitops.h: Error: Unrecognized opcode: `__asm__':  => 81, 131, 127, 165, 129, 80, 133, 82, 79
  + arch/powerpc/include/asm/bitops.h: Error: Unrecognized opcode: `__clear_bit(nr':  => 298
  + arch/powerpc/include/asm/bitops.h: Error: Unrecognized opcode: `__clear_bit(nr,':  => 166
  + arch/powerpc/include/asm/bitops.h: Error: Unrecognized opcode: `__const__':  => 287, 285
  + arch/powerpc/include/asm/bitops.h: Error: Unrecognized opcode: `__set_bit(nr':  => 293
  + arch/powerpc/include/asm/bitops.h: Error: Unrecognized opcode: `addr':  => 146
  + arch/powerpc/include/asm/bitops.h: Error: Unrecognized opcode: `asm':  => 244, 186, 178, 263, 195
  + arch/powerpc/include/asm/bitops.h: Error: Unrecognized opcode: `change_bits((1UL':  => 101
  + arch/powerpc/include/asm/bitops.h: Error: Unrecognized opcode: `clear_bits((1UL':  => 91
  + arch/powerpc/include/asm/bitops.h: Error: Unrecognized opcode: `clear_bits_unlock((1UL':  => 96
  + arch/powerpc/include/asm/bitops.h: Error: Unrecognized opcode: `if':  => 208
  + arch/powerpc/include/asm/bitops.h: Error: Unrecognized opcode: `int':  => 261, 194, 185, 192, 183, 176, 174, 242
  + arch/powerpc/include/asm/bitops.h: Error: Unrecognized opcode: `return'  CC      fs/ioctl.o:  => 127
  + arch/powerpc/include/asm/bitops.h: Error: Unrecognized opcode: `return':  => 152, 131, 127, 217, 245, 139, 129, 288, 158, 179, 318, 264, 133, 222, 233, 303, 250, 313, 308, 209, 145, 196, 187
  + arch/powerpc/include/asm/bitops.h: Error: Unrecognized opcode: `set_bits((1UL':  => 86
  + arch/powerpc/include/asm/bitops.h: Error: Unrecognized opcode: `static'  CC      lib/parser.o:  => 291
  + arch/powerpc/include/asm/bitops.h: Error: Unrecognized opcode: `static':  => 306, 155, 131, 127, 142, 129, 80, 79, 205, 99, 136, 133, 301, 82, 240, 84, 149, 182, 291, 259, 248, 94, 230, 220, 316, 163, 81, 191, 296, 173, 89, 284, 311
  + arch/powerpc/include/asm/bitops.h: Error: Unrecognized opcode: `unsigned'  CC      arch/powerpc/math-emu/fadds.o:  => 326
  + arch/powerpc/include/asm/bitops.h: Error: Unrecognized opcode: `unsigned':  => 274, 271, 131, 127, 129, 80, 79, 327, 324, 133, 82, 272, 273, 326, 323, 81, 232
  + arch/powerpc/include/asm/bitops.h: Error: Unrecognized opcode: `volatile':  => 137, 156, 150, 143
  + arch/powerpc/include/asm/bitops.h: Error: backward ref to unknown label "971:":  => 129
  + arch/powerpc/include/asm/bitops.h: Error: junk at end of line, first unrecognized character is `:':  => 129
  + arch/powerpc/include/asm/bitops.h: Error: junk at end of line, first unrecognized character is `{'  CC      mm/truncate.o:  => 317
  + arch/powerpc/include/asm/bitops.h: Error: junk at end of line, first unrecognized character is `{':  => 90, 241, 206, 307, 193, 292, 144, 157, 100, 297, 221, 286, 85, 95, 138, 249, 184, 231, 317, 312, 302, 164, 151, 260, 175
  + arch/powerpc/include/asm/bitops.h: Error: junk at end of line, first unrecognized character is `}':  => 127, 309, 289, 102, 188, 129, 80, 180, 82, 246, 147, 299, 218, 92, 319, 140, 223, 131, 234, 314, 167, 79, 87, 294, 133, 159, 197, 251, 304, 97, 153, 81, 265
  + arch/powerpc/include/asm/string.h: Error: Unrecognized opcode: `extern':  => 27, 25, 28, 21, 26, 20, 22, 18, 24, 19, 23
  + arch/powerpc/include/asm/swab.h: Error: Unrecognized opcode: `__asm__':  => 33, 53, 46, 26
  + arch/powerpc/include/asm/swab.h: Error: Unrecognized opcode: `__asm__("rlwimi':  => 77, 66
  + arch/powerpc/include/asm/swab.h: Error: Unrecognized opcode: `__u16':  => 64, 24
  + arch/powerpc/include/asm/swab.h: Error: Unrecognized opcode: `__u32':  => 75, 44
  + arch/powerpc/include/asm/swab.h: Error: Unrecognized opcode: `return':  => 69, 27, 82, 47
  + arch/powerpc/include/asm/swab.h: Error: Unrecognized opcode: `st_le16(addr,':  => 38
  + arch/powerpc/include/asm/swab.h: Error: Unrecognized opcode: `st_le32(addr,':  => 58
  + arch/powerpc/include/asm/swab.h: Error: Unrecognized opcode: `static'  CC [M]  drivers/input/serio/i8042.o:  => 42
  + arch/powerpc/include/asm/swab.h: Error: Unrecognized opcode: `static':  => 42, 22, 56, 36, 73, 51, 62, 31
  + arch/powerpc/include/asm/swab.h: Error: junk at end of line, first unrecognized character is `"':  => 78, 79
  + arch/powerpc/include/asm/swab.h: Error: junk at end of line, first unrecognized character is `:':  => 81, 67, 80, 68
  + arch/powerpc/include/asm/swab.h: Error: junk at end of line, first unrecognized character is `{':  => 74, 32, 63, 57, 52, 37, 23, 43
  + arch/powerpc/include/asm/swab.h: Error: junk at end of line, first unrecognized character is `}':  => 39, 28, 83, 70, 48, 59, 34, 54
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
  + drivers/edac/mpc85xx_edac.c: error: too few arguments to function 'edac_mc_alloc':  => 983:90
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
  + drivers/infiniband/hw/ocrdma/ocrdma_verbs.c: error: implicit declaration of function 'iowrite32' [-Werror=implicit-function-declaration]:  => 1760:2
  + drivers/input/gameport/lightning.c: error: invalid operands to binary & (have 'void *' and 'int'):  => 177:136, 141:136, 86:133
  + drivers/input/gameport/ns558.c: error: invalid operands to binary & (have 'void *' and 'int'):  => 84:124
  + drivers/input/touchscreen/mk712.c: error: invalid operands to binary | (have 'void *' and 'int'):  => 129:136
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
  + drivers/net/ethernet/dlink/de600.c: error: expected expression before 'do':  => 146:2, 301:3, 210:3, 150:2, 468:2, 404:2, 208:3, 495:3, 328:2, 138:2, 499:2, 217:3, 417:2, 136:2, 300:3, 464:2, 501:2, 493:2, 206:2, 216:3, 254:4, 350:2, 196:3, 137:2, 405:2, 463:2
  + drivers/net/ethernet/dlink/de620.c: error: invalid operands to binary ^ (have 'void *' and 'int'):  => 395:147, 266:147, 371:147
  + drivers/net/ethernet/dlink/dl2k.c: error: implicit declaration of function 'ioread16' [-Werror=implicit-function-declaration]:  => 257:2
  + drivers/net/ethernet/dlink/dl2k.c: error: implicit declaration of function 'ioread32' [-Werror=implicit-function-declaration]:  => 428:2
  + drivers/net/ethernet/dlink/dl2k.c: error: implicit declaration of function 'ioread8' [-Werror=implicit-function-declaration]:  => 385:4
  + drivers/net/ethernet/dlink/dl2k.c: error: implicit declaration of function 'iowrite16' [-Werror=implicit-function-declaration]:  => 64:2
  + drivers/net/ethernet/dlink/dl2k.c: error: implicit declaration of function 'iowrite32' [-Werror=implicit-function-declaration]:  => 428:2
  + drivers/net/ethernet/dlink/dl2k.c: error: implicit declaration of function 'iowrite8' [-Werror=implicit-function-declaration]:  => 385:4
  + drivers/net/ethernet/dlink/dl2k.c: error: implicit declaration of function 'pci_iomap' [-Werror=implicit-function-declaration]:  => 150:2
  + drivers/net/ethernet/dlink/dl2k.c: error: implicit declaration of function 'pci_iounmap' [-Werror=implicit-function-declaration]:  => 302:2
  + drivers/net/ethernet/emulex/benet/be_main.c: error: implicit declaration of function 'pci_iomap' [-Werror=implicit-function-declaration]:  => 3265:2
  + drivers/net/ethernet/emulex/benet/be_main.c: error: implicit declaration of function 'pci_iounmap' [-Werror=implicit-function-declaration]:  => 3257:3
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
  + drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c: error: implicit declaration of function 'pci_iomap' [-Werror=implicit-function-declaration]:  => 90:3
  + drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c: error: implicit declaration of function 'pci_iounmap' [-Werror=implicit-function-declaration]:  => 142:2
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
  + drivers/net/wireless/ipw2x00/ipw2100.c: error: implicit declaration of function 'pci_iomap' [-Werror=implicit-function-declaration]:  => 6233:2
  + drivers/net/wireless/ipw2x00/ipw2100.c: error: implicit declaration of function 'pci_iounmap' [-Werror=implicit-function-declaration]:  => 6410:2
  + drivers/pci/quirks.c: error: implicit declaration of function 'ioread32' [-Werror=implicit-function-declaration]:  => 3154:2
  + drivers/pci/quirks.c: error: implicit declaration of function 'iowrite32' [-Werror=implicit-function-declaration]:  => 3144:2
  + drivers/regulator/fixed.c: error: implicit declaration of function 'gpio_request_one' [-Werror=implicit-function-declaration]:  => 238:3
  + drivers/regulator/tps62360-regulator.c: error: implicit declaration of function 'gpio_request_one' [-Werror=implicit-function-declaration]:  => 452:3
  + drivers/regulator/wm831x-dcdc.c: error: implicit declaration of function 'gpio_request_one' [-Werror=implicit-function-declaration]:  => 411:2
  + drivers/scsi/pcmcia/sym53c500_cs.c: error: expected expression before 'do':  => 453:4, 434:4, 574:2, 371:2
  + drivers/scsi/qlogicfas408.c: error: expected expression before 'do':  => 234:2, 221:2, 312:3, 583:2, 535:2, 324:3, 85:2, 406:2, 316:5, 569:9, 89:3, 230:2, 546:2
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
  + drivers/staging/wlags49_h2/hcf.c: error: expected expression before 'do':  => 3375:4, 3592:3, 4378:3, 1135:3, 1203:3, 3593:3, 4731:3, 3653:3, 704:4, 3802:3, 1150:2, 1209:2, 3645:10, 4178:2, 3699:5, 3007:5, 4033:2, 787:3, 2646:4, 1190:2, 3797:3, 717:3, 2630:3, 4732:3, 703:4, 3582:2, 751:5, 2629:3, 755:5, 3507:3, 1153:2, 750:5, 3057:4, 781:4, 2654:4, 3700:5
  + drivers/staging/wlags49_h25/../wlags49_h2/hcf.c: error: expected expression before 'do':  => 3375:4, 3592:3, 4378:3, 1135:3, 1203:3, 3593:3, 4731:3, 3653:3, 704:4, 3802:3, 1150:2, 1209:2, 3645:10, 3699:5, 4033:2, 787:3, 2646:4, 1190:2, 717:3, 2630:3, 4732:3, 703:4, 3582:2, 751:5, 2629:3, 755:5, 3507:3, 1153:2, 750:5, 3057:4, 781:4, 2654:4, 3700:5
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
  + error: No rule to make target include/config/auto.conf:  => N/A
  + error: arch/xtensa/platforms/iss/built-in.o: undefined reference to `__netdev_alloc_skb':  => .text+0x60)
  + error: network.c: undefined reference to `__netdev_alloc_skb':  => .text+0x4cc)
  + error: vsprintf.c: relocation truncated to fit: R_AVR32_9UW_PCREL against `.text'+b28:  => (.text+0x92a)
  + include/asm-generic/bitops/arch_hweight.h: Error: Unrecognized opcode: `return':  => 8, 18, 23, 13
  + include/asm-generic/bitops/arch_hweight.h: Error: Unrecognized opcode: `static':  => 6, 11, 21, 16
  + include/asm-generic/bitops/arch_hweight.h: Error: junk at end of line, first unrecognized character is `{':  => 22, 7, 17, 12
  + include/asm-generic/bitops/arch_hweight.h: Error: junk at end of line, first unrecognized character is `}':  => 24, 19, 9, 14
  + include/asm-generic/bitops/find.h: Error: Unrecognized opcode: `extern':  => 22, 11
  + include/asm-generic/bitops/find.h: Error: Unrecognized opcode: `long':  => 23
  + include/asm-generic/bitops/find.h: Error: Unrecognized opcode: `size,':  => 12
  + include/asm-generic/bitops/fls64.h: Error: Unrecognized opcode: `__u32':  => 20
  + include/asm-generic/bitops/fls64.h: Error: Unrecognized opcode: `if':  => 21
  + include/asm-generic/bitops/fls64.h: Error: Unrecognized opcode: `return':  => 22, 23
  + include/asm-generic/bitops/fls64.h: Error: Unrecognized opcode: `static':  => 18
  + include/asm-generic/bitops/fls64.h: Error: junk at end of line, first unrecognized character is `{':  => 19
  + include/asm-generic/bitops/fls64.h: Error: junk at end of line, first unrecognized character is `}':  => 24
  + include/asm-generic/bitops/fls64.h: error: static declaration of 'fls64' follows non-static declaration:  => 26:81, 18:81
  + include/asm-generic/bitops/non-atomic.h: Error:   CC      arch/powerpc/kernel/module_32.o:  => 23
  + include/asm-generic/bitops/non-atomic.h: Error: Unrecognized opcode: `return':  => 95, 83, 64, 105
  + include/asm-generic/bitops/non-atomic.h: Error: Unrecognized opcode: `static':  => 103, 87, 57, 40, 76, 23, 15
  + include/asm-generic/bitops/non-atomic.h: Error: Unrecognized opcode: `unsigned':  => 25, 90, 61, 91, 80, 26, 78, 17, 79, 92, 42, 59, 60, 18, 43
  + include/asm-generic/bitops/non-atomic.h: Error: Unrecognized opcode: `volatile':  => 88
  + include/asm-generic/bitops/non-atomic.h: Error: junk at end of line, first unrecognized character is `*'  CC      arch/powerpc/kernel/time.o:  => 20
  + include/asm-generic/bitops/non-atomic.h: Error: junk at end of line, first unrecognized character is `*':  => 63, 28, 94, 45, 82, 20
  + include/asm-generic/bitops/non-atomic.h: Error: junk at end of line, first unrecognized character is `{':  => 104, 77, 89, 24, 16, 58, 41
  + include/asm-generic/bitops/non-atomic.h: Error: junk at end of line, first unrecognized character is `}'  CC      kernel/task_work.o:  => 46
  + include/asm-generic/bitops/non-atomic.h: Error: junk at end of line, first unrecognized character is `}':  => 84, 21, 106, 46, 96, 65, 29
  + include/asm-generic/bitops/sched.h: Error: Unrecognized opcode: `if':  => 21, 23, 19, 15
  + include/asm-generic/bitops/sched.h: Error: Unrecognized opcode: `return':  => 25, 22, 24, 16, 17, 20
  + include/asm-generic/bitops/sched.h: Error: Unrecognized opcode: `static':  => 12
  + include/asm-generic/bitops/sched.h: Error: junk at end of line, first unrecognized character is `{':  => 13
  + include/asm-generic/bitops/sched.h: Error: junk at end of line, first unrecognized character is `}':  => 29
  + include/asm-generic/div64.h: Error: Unrecognized opcode: `extern':  => 35
  + include/linux/bitops.h: Error:   CALL    /scratch/kisskb/src/arch/powerpc/kernel/systbl_chk.sh:  => 135
  + include/linux/bitops.h: Error:   CC      kernel/sched/fair.o:  => 184
  + include/linux/bitops.h: Error:   LDS     arch/powerpc/kernel/vdso32/vdso32.lds:  => 178
  + include/linux/bitops.h: Error: Unrecognized opcode: `__u8':  => 156
  + include/linux/bitops.h: Error: Unrecognized opcode: `extern':  => 196, 16, 13, 15, 14
  + include/linux/bitops.h: Error: Unrecognized opcode: `if':  => 59, 162, 178
  + include/linux/bitops.h: Error: Unrecognized opcode: `int':  => 56, 48
  + include/linux/bitops.h: Error: Unrecognized opcode: `order++':  => 60
  + include/linux/bitops.h: Error: Unrecognized opcode: `return':  => 116, 136, 179, 106, 157, 96, 126, 61, 183, 51, 146, 163, 66, 164, 86, 76
  + include/linux/bitops.h: Error: Unrecognized opcode: `static'  CC      kernel/fork.o:  => 175
  + include/linux/bitops.h: Error: Unrecognized opcode: `static':  => 124, 104, 84, 74, 134, 64, 94, 160, 114, 154, 46, 144, 175, 54
  + include/linux/bitops.h: Error: Unrecognized opcode: `unsigned':  => 197
  + include/linux/bitops.h: Error: junk at end of line, first unrecognized character is `(':  => 50, 58
  + include/linux/bitops.h: Error: junk at end of line, first unrecognized character is `{':  => 161, 155, 85, 95, 75, 115, 176, 135, 47, 145, 125, 65, 105, 55
  + include/linux/bitops.h: Error: junk at end of line, first unrecognized character is `}':  => 147, 127, 67, 165, 97, 184, 107, 158, 137, 52, 87, 77, 117, 62
  + include/linux/bitops.h: error: conflicting types for 'fls_long':  => 160:55
  + include/linux/byteorder/big_endian.h: Error: Unrecognized opcode: `return'  CC      arch/powerpc/kernel/prom.o:  => 45
  + include/linux/byteorder/big_endian.h: Error: Unrecognized opcode: `return':  => 85, 53, 57, 61, 81, 69, 77, 49, 89, 45, 73, 65
  + include/linux/byteorder/big_endian.h: Error: Unrecognized opcode: `static':  => 67, 63, 83, 75, 71, 51, 79, 47, 59, 87, 43, 55
  + include/linux/byteorder/big_endian.h: Error: junk at end of line, first unrecognized character is `{':  => 84, 64, 80, 68, 48, 52, 60, 88, 56, 72, 76, 44
  + include/linux/byteorder/big_endian.h: Error: junk at end of line, first unrecognized character is `}':  => 74, 50, 90, 70, 78, 58, 46, 66, 86, 62, 82, 54
  + include/linux/byteorder/generic.h: Error: Unrecognized opcode: `static':  => 163, 158, 148, 168, 153, 143
  + include/linux/byteorder/generic.h: Error: junk at end of line, first unrecognized character is `*':  => 170, 155, 145, 165, 160, 150
  + include/linux/byteorder/generic.h: Error: junk at end of line, first unrecognized character is `{':  => 159, 149, 154, 169, 164, 144
  + include/linux/byteorder/generic.h: Error: junk at end of line, first unrecognized character is `}':  => 166, 161, 156, 151, 146, 171
  + include/linux/dynamic_debug.h: Error: Unrecognized opcode: `const':  => 40, 61, 17, 48, 15, 14, 109, 60, 16, 54
  + include/linux/dynamic_debug.h: Error: Unrecognized opcode: `extern':  => 52, 43, 58, 44, 47
  + include/linux/dynamic_debug.h: Error: Unrecognized opcode: `if':  => 111
  + include/linux/dynamic_debug.h: Error: Unrecognized opcode: `int':  => 59, 53, 39, 45
  + include/linux/dynamic_debug.h: Error: Unrecognized opcode: `printk("<4>"':  => 113
  + include/linux/dynamic_debug.h: Error: Unrecognized opcode: `return':  => 117, 115, 105
  + include/linux/dynamic_debug.h: Error: Unrecognized opcode: `static':  => 103, 108
  + include/linux/dynamic_debug.h: Error: Unrecognized opcode: `struct':  => 50, 56, 9
  + include/linux/dynamic_debug.h: Error: Unrecognized opcode: `unsigned':  => 35, 18
  + include/linux/dynamic_debug.h: Error: junk at end of line, first unrecognized character is `"':  => 114
  + include/linux/dynamic_debug.h: Error: junk at end of line, first unrecognized character is `{':  => 104, 110
  + include/linux/dynamic_debug.h: Error: junk at end of line, first unrecognized character is `}':  => 116, 118, 106, 36
  + include/linux/gpio.h: error: implicit declaration of function '__gpio_cansleep' [-Werror=implicit-function-declaration]:  => 62:2
  + include/linux/gpio.h: error: implicit declaration of function '__gpio_to_irq' [-Werror=implicit-function-declaration]:  => 67:2
  + include/linux/gpio.h: error: redefinition of 'gpio_cansleep':  => 60:50
  + include/linux/kernel.h: Error:   CC      mm/backing-dev.o:  => 139
  + include/linux/kernel.h: Error:   CC [M]  drivers/gpu/drm/radeon/radeon_connectors.o:  => 236
  + include/linux/kernel.h: Error: Unrecognized opcode: `__alignof__(long)':  => 243
  + include/linux/kernel.h: Error: Unrecognized opcode: `__alignof__(unsigned':  => 230
  + include/linux/kernel.h: Error: Unrecognized opcode: `__ftrace_vbprintk(unsigned':  => 524
  + include/linux/kernel.h: Error: Unrecognized opcode: `__ftrace_vprintk(unsigned':  => 527
  + include/linux/kernel.h: Error: Unrecognized opcode: `__noreturn':  => 215, 207, 213
  + include/linux/kernel.h: Error: Unrecognized opcode: `__printf(1,':  => 205
  + include/linux/kernel.h: Error: Unrecognized opcode: `char':  => 334
  + include/linux/kernel.h: Error: Unrecognized opcode: `do':  => 199
  + include/linux/kernel.h: Error: Unrecognized opcode: `dump_all,':  => 444
  + include/linux/kernel.h: Error: Unrecognized opcode: `dump_none,':  => 443
  + include/linux/kernel.h: Error: Unrecognized opcode: `dump_orig,':  => 445
  + include/linux/kernel.h: Error: Unrecognized opcode: `else':  => 245, 232
  + include/linux/kernel.h: Error: Unrecognized opcode: `enum':  => 442
  + include/linux/kernel.h: Error: Unrecognized opcode: `extern':  => 371, 365, 204, 523, 455, 346, 358, 331, 327, 453, 353, 324, 526, 366, 329, 359, 333, 339, 710, 310, 368, 323, 361, 454, 313, 348, 501, 319, 529, 414, 504, 343, 342, 208, 347, 143, 413, 397, 363, 360, 349, 344, 364, 325, 350, 203, 369, 374, 211, 367, 362, 209, 498, 312, 337, 335, 357, 311
  + include/linux/kernel.h: Error: Unrecognized opcode: `ftrace_vprintk(const':  => 549
  + include/linux/kernel.h: Error: Unrecognized opcode: `if':  => 229, 242
  + include/linux/kernel.h: Error: Unrecognized opcode: `int':  => 274, 330, 328, 165, 502, 282, 281, 219, 532, 338, 275, 222, 221, 272, 286, 283, 280, 332, 326, 250, 273, 451, 218, 249, 279, 277, 499, 278, 340, 284, 285
  + include/linux/kernel.h: Error: Unrecognized opcode: `return'  VDSO32A arch/powerpc/kernel/vdso32/gettimeofday.o:  => 233
  + include/linux/kernel.h: Error: Unrecognized opcode: `return':  => 246, 233, 259, 546, 305, 295, 231, 269, 254, 244, 551, 405, 264, 410, 300, 290
  + include/linux/kernel.h: Error: Unrecognized opcode: `static'  CC      arch/powerpc/kernel/pci-common.o:  => 540
  + include/linux/kernel.h: Error: Unrecognized opcode: `static'  CC      arch/powerpc/sysdev/cpm2.o:  => 293
  + include/linux/kernel.h: Error: Unrecognized opcode: `static'  CC      mm/mempool.o:  => 267
  + include/linux/kernel.h: Error: Unrecognized opcode: `static':  => 543, 267, 288, 262, 537, 535, 401, 457, 548, 541, 257, 553, 197, 252, 298, 303, 540, 236, 534, 531, 408, 439, 536, 164, 539, 293, 223
  + include/linux/kernel.h: Error: Unrecognized opcode: `struct':  => 352, 139, 138, 140
  + include/linux/kernel.h: Error: Unrecognized opcode: `system_booting,':  => 375
  + include/linux/kernel.h: Error: Unrecognized opcode: `system_halt,':  => 377
  + include/linux/kernel.h: Error: Unrecognized opcode: `system_power_off,':  => 378
  + include/linux/kernel.h: Error: Unrecognized opcode: `system_restart,':  => 379
  + include/linux/kernel.h: Error: Unrecognized opcode: `system_running,':  => 376
  + include/linux/kernel.h: Error: Unrecognized opcode: `system_suspend_disk,':  => 380
  + include/linux/kernel.h: Error: Unrecognized opcode: `trace_printk(const':  => 544
  + include/linux/kernel.h: Error: Unrecognized opcode: `unsigned':  => 355
  + include/linux/kernel.h: Error: Unrecognized opcode: `void':  => 437, 210, 206, 458, 212, 450, 214, 449, 195, 150
  + include/linux/kernel.h: Error: junk at end of line, first unrecognized character is `*':  => 403, 404
  + include/linux/kernel.h: Error: junk at end of line, first unrecognized character is `{':  => 237, 289, 198, 263, 402, 294, 304, 253, 268, 299, 258, 545, 409, 459, 224, 550
  + include/linux/kernel.h: Error: junk at end of line, first unrecognized character is `}':  => 306, 446, 234, 552, 460, 200, 255, 541, 301, 547, 291, 199, 381, 406, 265, 296, 411, 260, 270, 247
  + include/linux/log2.h: Error:   CC      kernel/resource.o:  => 54
  + include/linux/log2.h: Error: Unrecognized opcode: `bool':  => 52
  + include/linux/log2.h: Error: Unrecognized opcode: `extern':  => 21
  + include/linux/log2.h: Error: Unrecognized opcode: `int':  => 22, 40
  + include/linux/log2.h: Error: Unrecognized opcode: `return'  AS      arch/powerpc/kernel/entry_32.o:  => 54
  + include/linux/log2.h: Error: Unrecognized opcode: `return':  => 42, 63, 72, 54
  + include/linux/log2.h: Error: Unrecognized opcode: `static':  => 69, 60, 39, 51
  + include/linux/log2.h: Error: Unrecognized opcode: `unsigned':  => 70, 61
  + include/linux/log2.h: Error: junk at end of line, first unrecognized character is `{':  => 53, 71, 41, 62
  + include/linux/log2.h: Error: junk at end of line, first unrecognized character is `}':  => 64, 73, 43, 55
  + include/linux/log2.h: error: implicit declaration of function 'fls' [-Werror=implicit-function-declaration]:  => 34:2
  + include/linux/log2.h: error: implicit declaration of function 'fls64' [-Werror=implicit-function-declaration]:  => 42:2
  + include/linux/log2.h: error: implicit declaration of function 'fls_long' [-Werror=implicit-function-declaration]:  => 63:2
  + include/linux/pagemap.h: error: assignment of read-only variable '__gu_val': 448:5, 442:2 => 448:4, 499:3, 508:3, 442:2
  + include/linux/printk.h: Error:   CC      arch/powerpc/kernel/traps.o:  => 316
  + include/linux/printk.h: Error: Unrecognized opcode: `__printf(1,'  CC      kernel/fork.o:  => 117
  + include/linux/printk.h: Error: Unrecognized opcode: `__printf(1,':  => 103, 117, 111
  + include/linux/printk.h: Error: Unrecognized opcode: `__printf(5,':  => 98, 106
  + include/linux/printk.h: Error: Unrecognized opcode: `char':  => 312
  + include/linux/printk.h: Error: Unrecognized opcode: `const':  => 109, 46, 318, 101, 108, 100, 316
  + include/linux/printk.h: Error: Unrecognized opcode: `dump_prefix_address,':  => 307
  + include/linux/printk.h: Error: Unrecognized opcode: `dump_prefix_none,':  => 306
  + include/linux/printk.h: Error: Unrecognized opcode: `dump_prefix_offset':  => 308
  + include/linux/printk.h: Error: Unrecognized opcode: `enum':  => 305
  + include/linux/printk.h: Error: Unrecognized opcode: `extern':  => 170, 124, 27, 6, 131, 130, 310, 95, 303, 94, 7, 314, 129, 91, 317, 126
  + include/linux/printk.h: Error: Unrecognized opcode: `if':  => 41
  + include/linux/printk.h: Error: Unrecognized opcode: `int':  => 315, 112, 104, 99, 86, 311, 107
  + include/linux/printk.h: Error: Unrecognized opcode: `return':  => 88
  + include/linux/printk.h: Error: Unrecognized opcode: `static':  => 85, 39, 34
  + include/linux/printk.h: Error: Unrecognized opcode: `struct':  => 45
  + include/linux/printk.h: Error: Unrecognized opcode: `unsigned':  => 127
  + include/linux/printk.h: Error: Unrecognized opcode: `va_list':  => 47
  + include/linux/printk.h: Error: Unrecognized opcode: `void':  => 92, 134, 133
  + include/linux/printk.h: Error: junk at end of line, first unrecognized character is `(':  => 42, 36
  + include/linux/printk.h: Error: junk at end of line, first unrecognized character is `{':  => 35, 87, 40
  + include/linux/printk.h: Error: junk at end of line, first unrecognized character is `}':  => 309, 89, 37, 43, 48
  + include/linux/stddef.h: Error: Unrecognized opcode: `enum':  => 11
  + include/linux/stddef.h: Error: junk at end of line, first unrecognized character is `,':  => 12
  + include/linux/stddef.h: Error: junk at end of line, first unrecognized character is `}':  => 14
  + include/linux/string.h: Error: Unrecognized opcode: `const':  => 136
  + include/linux/string.h: Error: Unrecognized opcode: `extern':  => 124, 127, 67, 90, 63, 78, 121, 48, 119, 87, 93, 16, 96, 65, 126, 123, 84, 120, 39, 36, 57, 75, 51, 135, 15, 109, 60, 54
  + include/linux/string.h: Error: Unrecognized opcode: `int':  => 131, 130, 132
  + include/linux/string.h: Error: Unrecognized opcode: `return':  => 145, 71
  + include/linux/string.h: Error: Unrecognized opcode: `size_t':  => 30
  + include/linux/string.h: Error: Unrecognized opcode: `static':  => 69, 143
  + include/linux/string.h: Error: Unrecognized opcode: `void':  => 117
  + include/linux/string.h: Error: junk at end of line, first unrecognized character is `{':  => 70, 144
  + include/linux/string.h: Error: junk at end of line, first unrecognized character is `}':  => 72, 146
  + include/linux/swab.h: Error:   CC      kernel/fork.o:  => 205
  + include/linux/swab.h: Error:   LD [M]  drivers/infiniband/core/ib_ucm.o:  => 64
  + include/linux/swab.h: Error: Unrecognized opcode: `__arch_swab16s(p)':  => 220
  + include/linux/swab.h: Error: Unrecognized opcode: `__arch_swab32s(p)':  => 232
  + include/linux/swab.h: Error: Unrecognized opcode: `__u32':  => 69, 70
  + include/linux/swab.h: Error: Unrecognized opcode: `return':  => 71, 194, 91, 58, 209, 49, 179, 73, 151, 164, 82
  + include/linux/swab.h: Error: Unrecognized opcode: `static':  => 272, 189, 161, 217, 204, 64, 77, 174, 46, 229, 86, 148, 257, 242, 55
  + include/linux/swab.h: Error: junk at end of line, first unrecognized character is `*':  => 262, 277, 247
  + include/linux/swab.h: Error: junk at end of line, first unrecognized character is `{':  => 149, 190, 273, 230, 218, 78, 258, 47, 243, 205, 87, 56, 162, 175, 65
  + include/linux/swab.h: Error: junk at end of line, first unrecognized character is `}':  => 84, 155, 181, 53, 75, 236, 279, 249, 168, 211, 93, 264, 224, 196, 62
  + include/linux/sysinfo.h: Error: Unrecognized opcode: `__kernel_long_t':  => 8
  + include/linux/sysinfo.h: Error: Unrecognized opcode: `__kernel_ulong_t'  CC      ipc/ipc_sysctl.o:  => 13
  + include/linux/sysinfo.h: Error: Unrecognized opcode: `__kernel_ulong_t':  => 11, 9, 12, 15, 14, 18, 10, 13, 19
  + include/linux/sysinfo.h: Error: Unrecognized opcode: `__u16':  => 16, 17
  + include/linux/sysinfo.h: Error: Unrecognized opcode: `__u32':  => 20
  + include/linux/sysinfo.h: Error: Unrecognized opcode: `char':  => 21
  + include/linux/sysinfo.h: Error: Unrecognized opcode: `struct':  => 7
  + include/linux/sysinfo.h: Error: junk at end of line, first unrecognized character is `}':  => 22
  + kernel/sys.c: error: 'mmap_min_addr' undeclared (first use in this function):  => 1864:34, 1864:2
  + net/mac80211/ieee80211_i.h: error: field 'trig' has incomplete type:  => 787:21
  + net/mac80211/led.c: error: 'struct led_classdev' has no member named 'trig_list':  => 278:411, 278:352, 278:59, 214:352, 214:411, 214:160, 278:319, 214:223, 214:319, 278:160, 214:59, 278:223
  + net/mac80211/led.c: error: dereferencing pointer to incomplete type:  => 74:16, 83:16, 101:19, 92:19
  + net/mac80211/led.c: error: implicit declaration of function 'led_trigger_register' [-Werror=implicit-function-declaration]:  => 75:3
  + net/mac80211/led.c: error: implicit declaration of function 'led_trigger_unregister' [-Werror=implicit-function-declaration]:  => 119:3
  + net/mac80211/led.c: error: invalid application of 'sizeof' to incomplete type 'struct led_trigger' :  => 90:36, 72:33, 99:36, 81:33
  + security/security.c: error: 'BDI_CAP_EXEC_MAP' undeclared (first use in this function):  => 688:16, 688:3
  + security/security.c: error: dereferencing pointer to incomplete type:  => 687:36


*** WARNINGS ***

730 regressions:
  + .config: warning: override: HIGHMEM4G changes choice state:  => 372
  + .config: warning: override: PCI_GOANY changes choice state:  => 525
  + .config: warning: override: SLOB changes choice state: 134 => 145, 171
  + .config: warning: override: USB_G_SERIAL changes choice state:  => 2112
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
  + arch/sh/include/asm/atomic-irq.h: warning: 'data' may be used uninitialized in this function [-Wuninitialized]:  => 25:13
  + arch/sh/kernel/cpu/sh4a/clock-sh7343.c: warning: 'sh_clk_mstp32_register' is deprecated (declared at /scratch/kisskb/src/include/linux/sh_clk.h:138) [-Wdeprecated-declarations]:  => 286:3
  + arch/sh/kernel/cpu/sh4a/clock-sh7722.c: warning: 'sh_clk_mstp32_register' is deprecated (declared at /scratch/kisskb/src/include/linux/sh_clk.h:138) [-Wdeprecated-declarations]:  => 264:3
  + arch/sh/kernel/cpu/sh4a/clock-sh7723.c: warning: 'sh_clk_mstp32_register' is deprecated (declared at /scratch/kisskb/src/include/linux/sh_clk.h:138) [-Wdeprecated-declarations]:  => 314:3
  + arch/sh/kernel/cpu/sh4a/clock-sh7785.c: warning: 'sh_clk_mstp32_register' is deprecated (declared at /scratch/kisskb/src/include/linux/sh_clk.h:138) [-Wdeprecated-declarations]:  => 178:3
  + arch/sh/kernel/cpu/sh4a/clock-shx3.c: warning: 'sh_clk_mstp32_register' is deprecated (declared at /scratch/kisskb/src/include/linux/sh_clk.h:138) [-Wdeprecated-declarations]:  => 152:3
  + arch/sh/math-emu/math.c: warning: left shift count >= width of type [enabled by default]: 108:2620, 115:2620, 145:2, 122:2620, 310:1, 334:2, 122:13306, 310:325, 115:1, 122:1, 108:1 => 108:2620, 115:2620, 334:1, 145:2, 122:2620, 310:1, 145:1, 334:2, 122:13306, 310:325, 115:1, 122:1, 108:1
  + arch/sh/math-emu/math.c: warning: left shift count is negative [enabled by default]: 333:1, 129:2620, 115:2620, 122:2620, 92:2569, 92:445, 310:325, 129:1, 115:1, 92:1, 108:1, 81:1, 108:496, 333:254, 108:2620, 122:496, 115:496, 310:1, 81:445, 81:2569, 323:2, 122:1, 129:496 => 333:1, 129:2620, 115:2620, 122:2620, 92:2569, 92:445, 92:2, 310:325, 129:1, 323:1, 115:1, 92:1, 108:1, 81:1, 108:496, 333:254, 108:2620, 122:496, 115:496, 310:1, 81:445, 81:2, 81:2569, 323:2, 122:1, 129:496
  + arch/sh/math-emu/math.c: warning: right shift count >= width of type [enabled by default]: 296:3, 294:3 => 294:1, 296:3, 296:1, 294:3
  + arch/sh/math-emu/math.c: warning: right shift count is negative [enabled by default]: 108:2620, 324:2, 129:2620, 115:2620, 145:2, 122:2620, 310:1, 334:2, 122:13306, 310:325, 129:1, 122:1, 115:1, 294:3, 108:1 => 129:2620, 115:2620, 145:2, 122:2620, 334:2, 310:325, 129:1, 115:1, 108:1, 108:2620, 324:2, 334:1, 310:1, 145:1, 294:1, 122:13306, 294:3, 122:1, 324:1
  + arch/um/defconfig: warning: symbol value 'm' invalid for BLK_CGROUP:  => 166
  + arch/x86/include/asm/bitops.h: warning: 'rdev' may be used uninitialized in this function [-Wuninitialized]:  => 314:8
  + block/blk-cgroup.c: warning: unused variable 'q' [-Wunused-variable]:  => 248:24
  + block/blk-merge.c: warning: 'bbio' may be used uninitialized in this function [-Wuninitialized]:  => 65:2
  + block/blk-throttle.c: warning: value computed is not used [-Wunused-value]:  => 1035:3, 1036:3, 840:3
  + block/bsg.c: warning: 'rw' may be used uninitialized in this function [-Wuninitialized]:  => 273:5
  + drivers/acpi/sleep.c: warning: 'pwr_btn_event_pending' defined but not used [-Wunused-variable]:  => 60:13
  + drivers/base/regmap/regmap.c: warning: 'ret' may be used uninitialized in this function [-Wuninitialized]: 744:2 => 1062:9, 882:6
  + drivers/block/hd.c: warning: statement with no effect [-Wunused-value]:  => 467:2
  + drivers/block/paride/ppc6lnx.c: warning: statement with no effect [-Wunused-value]:  => 522:4
  + drivers/bluetooth/bluecard_cs.c: warning: unused variable 'iobase' [-Wunused-variable]:  => 644:15, 178:15, 822:15, 624:15, 161:15
  + drivers/bluetooth/btuart_cs.c: warning: unused variable 'iobase' [-Wunused-variable]:  => 541:15, 474:15
  + drivers/bluetooth/dtl1_cs.c: warning: unused variable 'iobase' [-Wunused-variable]:  => 524:15, 454:15
  + drivers/char/ipmi/ipmi_si_intf.c: warning: unused variable 'addr' [-Wunused-variable]:  => 1386:15, 1371:15, 1356:15
  + drivers/char/pcmcia/cm4000_cs.c: warning: unused variable 'iobase' [-Wunused-variable]:  => 1402:15, 423:15
  + drivers/char/pcmcia/cm4040_cs.c: warning: unused variable 'iobase' [-Wunused-variable]:  => 171:6, 321:6
  + drivers/char/tpm/tpm.c: warning: format '%zd' expects argument of type 'signed size_t', but argument 3 has type 'ssize_t' [-Wformat]:  => 404:4, 437:4
  + drivers/edac/mpc85xx_edac.c: warning: 'mpc85xx_pci_err_remove' defined but not used [-Wunused-function]:  => 307:12
  + drivers/edac/mpc85xx_edac.c: warning: passing argument 3 of 'edac_mc_alloc' makes pointer from integer without a cast [enabled by default]:  => 983:90
  + drivers/edac/mpc85xx_edac.c: warning: unused variable 'pvr' [-Wunused-variable]:  => 1172:6
  + drivers/gpu/drm/ast/ast_main.c: warning: assignment makes pointer from integer without a cast [enabled by default]:  => 345:14, 340:12
  + drivers/gpu/drm/mgag200/mgag200_main.c: warning: assignment makes pointer from integer without a cast [enabled by default]:  => 154:6, 187:14
  + drivers/gpu/drm/nouveau/nv40_grctx.c: warning: the frame size of 1184 bytes is larger than 1024 bytes [-Wframe-larger-than=]:  => 690:1
  + drivers/gpu/drm/nouveau/nve0_fifo.c: warning: assignment makes pointer from integer without a cast [enabled by default]:  => 114:13
  + drivers/hwmon/f71882fg.c: warning: 'address' may be used uninitialized in this function [-Wuninitialized]:  => 2685:27
  + drivers/hwmon/pc87427.c: warning: unused variable 'iobase' [-Wunused-variable]:  => 620:6, 565:6, 431:6
  + drivers/hwmon/sch56xx-common.c: warning: 'address' may be used uninitialized in this function [-Wuninitialized]:  => 606:27
  + drivers/hwmon/sch56xx-common.c: warning: 'name' may be used uninitialized in this function [-Wuninitialized]:  => 606:2
  + drivers/i2c/busses/i2c-designware-platdrv.c: warning: 'dw_i2c_resume' defined but not used [-Wunused-function]:  => 213:12
  + drivers/i2c/busses/i2c-designware-platdrv.c: warning: 'dw_i2c_suspend' defined but not used [-Wunused-function]:  => 203:12
  + drivers/ide/ide-floppy.c: warning: 'pc' may be used uninitialized in this function [-Wuninitialized]:  => 296:2
  + drivers/ide/ide-io-std.c: warning: statement with no effect [-Wunused-value]:  => 201:3, 186:4
  + drivers/input/gameport/lightning.c: warning: unused variable 'l4' [-Wunused-variable]:  => 78:13
  + drivers/isdn/hisax/avm_pci.c: warning: unused variable 'idx' [-Wunused-variable]:  => 249:9, 145:18, 114:17, 80:18, 125:17, 134:18, 91:18
  + drivers/isdn/i4l/isdn_common.c: warning: unused variable 's' [-Wunused-variable]:  => 1278:8
  + drivers/isdn/sc/init.c: warning: return from incompatible pointer type [enabled by default]: 37:71, 36:71 => 37:71, 36:1, 37:1, 36:71
  + drivers/leds/leds-ot200.c: warning: 'val' may be used uninitialized in this function [-Wuninitialized]:  => 112:8
  + drivers/md/md.c: warning: large integer implicitly truncated to unsigned type [-Woverflow]:  => 1453:3, 1162:3
  + drivers/media/dvb/frontends/cx24110.c: warning: value computed is not used [-Wunused-value]:  => 520:40
  + drivers/mfd/da9052-core.c: warning: unused variable 'desc' [-Wunused-variable]:  => 775:19
  + drivers/mfd/rc5t583-irq.c: warning: 'master_int' may be used uninitialized in this function [-Wuninitialized]: 276:20 => 258:10, 276:20
  + drivers/mfd/tps6586x.c: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]:  => 531:16
  + drivers/mfd/tps65910.c: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]:  => 157:14
  + drivers/misc/bmp085.c: warning: 'pressure' may be used uninitialized in this function [-Wuninitialized]:  => 344:3
  + drivers/misc/lkdtm.c: warning: the frame size of 1028 bytes is larger than 1024 bytes [-Wframe-larger-than=]:  => 276:1
  + drivers/mtd/chips/cfi_cmdset_0001.c: warning: the frame size of 1484 bytes is larger than 1024 bytes [-Wframe-larger-than=]:  => 1797:1
  + drivers/mtd/chips/cfi_cmdset_0020.c: warning: the frame size of 1224 bytes is larger than 1024 bytes [-Wframe-larger-than=]:  => 420:1
  + drivers/mtd/chips/cfi_cmdset_0020.c: warning: the frame size of 1472 bytes is larger than 1024 bytes [-Wframe-larger-than=]:  => 975:1
  + drivers/mtd/chips/cfi_cmdset_0020.c: warning: the frame size of 1764 bytes is larger than 1024 bytes [-Wframe-larger-than=]:  => 654:1
  + drivers/mtd/ftl.c: warning: passing argument 4 of 'mtd_read' from incompatible pointer type [enabled by default]:  => 527:28, 228:24, 294:24, 490:24
  + drivers/mtd/ftl.c: warning: passing argument 4 of 'mtd_write' from incompatible pointer type [enabled by default]:  => 557:21, 535:29, 442:25, 566:21, 426:21, 507:21
  + drivers/mtd/maps/latch-addr-flash.c: warning: 'latch_addr_flash_remove' defined but not used [-Wunused-function]:  => 97:12
  + drivers/mtd/ubi/vmt.c: warning: 'err' may be used uninitialized in this function [-Wuninitialized]:  => 407:9
  + drivers/net/arcnet/com20020.c: warning: unused variable 'ioaddr' [-Wunused-variable]:  => 327:6, 63:6, 295:8, 77:6, 310:6
  + drivers/net/arcnet/com20020.c: warning: unused variable 'ofs' [-Wunused-variable]:  => 77:31, 63:31
  + drivers/net/arcnet/com20020_cs.c: warning: unused variable 'ioaddr' [-Wunused-variable]:  => 310:7
  + drivers/net/arcnet/com20020_cs.c: warning: unused variable 'lp' [-Wunused-variable]:  => 311:24
  + drivers/net/arcnet/com90io.c: warning: unused variable 'ioaddr' [-Wunused-variable]:  => 420:6, 325:8, 132:6, 341:8, 237:6
  + drivers/net/arcnet/com90xx.c: warning: unused variable 'ioaddr' [-Wunused-variable]:  => 574:8, 558:8
  + drivers/net/can/cc770/cc770_isa.c: warning: unused variable 'base' [-Wunused-variable]:  => 160:16
  + drivers/net/can/sja1000/sja1000_isa.c: warning: unused variable 'base' [-Wunused-variable]:  => 114:16
  + drivers/net/ethernet/3com/3c574_cs.c: warning: unused variable 'dataval' [-Wunused-variable]:  => 556:7, 580:7
  + drivers/net/ethernet/3com/3c574_cs.c: warning: unused variable 'ioaddr' [-Wunused-variable]:  => 1096:15, 1119:15, 699:15
  + drivers/net/ethernet/3com/3c574_cs.c: warning: unused variable 'mdio_addr' [-Wunused-variable]:  => 535:15, 572:15
  + drivers/net/ethernet/3com/3c589_cs.c: warning: unused variable 'ioaddr' [-Wunused-variable]:  => 849:18, 519:18, 392:18
  + drivers/net/ethernet/8390/axnet_cs.c: warning: unused variable 'dat' [-Wunused-variable]:  => 435:6, 454:6
  + drivers/net/ethernet/8390/axnet_cs.c: warning: unused variable 'e8390_base' [-Wunused-variable]:  => 1587:7, 975:7
  + drivers/net/ethernet/8390/axnet_cs.c: warning: unused variable 'endcfg' [-Wunused-variable]:  => 1649:6
  + drivers/net/ethernet/8390/axnet_cs.c: warning: unused variable 'info' [-Wunused-variable]:  => 1473:15
  + drivers/net/ethernet/8390/axnet_cs.c: warning: unused variable 'nic_base' [-Wunused-variable]:  => 634:18, 673:18, 471:18
  + drivers/net/ethernet/8390/lib8390.c: warning: unused variable 'e8390_base' [-Wunused-variable]:  => 896:16, 303:16
  + drivers/net/ethernet/8390/lib8390.c: warning: unused variable 'endcfg' [-Wunused-variable]:  => 1007:6
  + drivers/net/ethernet/8390/pcnet_cs.c: warning: unused variable 'dat' [-Wunused-variable]:  => 711:6, 730:6
  + drivers/net/ethernet/8390/pcnet_cs.c: warning: unused variable 'dataval' [-Wunused-variable]:  => 768:8
  + drivers/net/ethernet/8390/pcnet_cs.c: warning: unused variable 'ee_addr' [-Wunused-variable]:  => 794:15
  + drivers/net/ethernet/8390/pcnet_cs.c: warning: unused variable 'mask' [-Wunused-variable]:  => 726:12, 707:24, 697:15
  + drivers/net/ethernet/8390/pcnet_cs.c: warning: unused variable 'nic_base' [-Wunused-variable]:  => 1128:18, 901:18
  + drivers/net/ethernet/amd/nmclan_cs.c: warning: unused variable 'ioaddr' [-Wunused-variable]:  => 863:16, 781:16, 804:16
  + drivers/net/ethernet/broadcom/bnx2.c: warning: assignment makes pointer from integer without a cast [enabled by default]:  => 8037:14
  + drivers/net/ethernet/dec/tulip/dmfe.c: warning: assignment makes pointer from integer without a cast [enabled by default]:  => 464:13
  + drivers/net/ethernet/dec/tulip/uli526x.c: warning: assignment makes pointer from integer without a cast [enabled by default]:  => 363:9
  + drivers/net/ethernet/dec/tulip/xircom_cb.c: warning: assignment makes pointer from integer without a cast [enabled by default]:  => 258:18
  + drivers/net/ethernet/dlink/de620.c: warning: unused variable 'dflip' [-Wunused-variable]:  => 337:7, 297:7
  + drivers/net/ethernet/dlink/de620.c: warning: unused variable 'uflip' [-Wunused-variable]:  => 296:7, 336:7
  + drivers/net/ethernet/dlink/dl2k.c: warning: assignment makes pointer from integer without a cast [enabled by default]:  => 150:9
  + drivers/net/ethernet/emulex/benet/be_main.c: warning: assignment makes pointer from integer without a cast [enabled by default]:  => 3265:7
  + drivers/net/ethernet/fujitsu/fmvj18x_cs.c: warning: unused variable 'buf' [-Wunused-variable]:  => 832:17
  + drivers/net/ethernet/fujitsu/fmvj18x_cs.c: warning: unused variable 'ioaddr' [-Wunused-variable]:  => 819:18, 1103:18
  + drivers/net/ethernet/fujitsu/fmvj18x_cs.c: warning: unused variable 'saved_config_0' [-Wunused-variable]:  => 1144:9
  + drivers/net/ethernet/seeq/seeq8005.c: warning: statement with no effect [-Wunused-value]:  => 559:4
  + drivers/net/ethernet/seeq/seeq8005.c: warning: unused variable 'ioaddr' [-Wunused-variable]:  => 586:6
  + drivers/net/ethernet/seeq/seeq8005.c: warning: unused variable 'transmit_ptr' [-Wunused-variable]:  => 692:6
  + drivers/net/ethernet/sis/sis900.c: warning: assignment makes pointer from integer without a cast [enabled by default]:  => 480:9
  + drivers/net/ethernet/smsc/epic100.c: warning: assignment makes pointer from integer without a cast [enabled by default]:  => 368:9
  + drivers/net/ethernet/smsc/smc91c92_cs.c: warning: unused variable 'buf' [-Wunused-variable]:  => 1155:10
  + drivers/net/ethernet/smsc/smc91c92_cs.c: warning: unused variable 'dat' [-Wunused-variable]:  => 994:6, 1014:6
  + drivers/net/ethernet/smsc/smc91c92_cs.c: warning: unused variable 'ioaddr' [-Wunused-variable]:  => 1642:18, 1549:18
  + drivers/net/ethernet/smsc/smc91c92_cs.c: warning: unused variable 'packet_no' [-Wunused-variable]:  => 1275:9
  + drivers/net/ethernet/smsc/smc91c92_cs.c: warning: unused variable 'saved_bank' [-Wunused-variable]:  => 1919:6, 1957:6, 1974:7, 1938:6
  + drivers/net/ethernet/smsc/smc91c92_cs.c: warning: unused variable 'saved_packet' [-Wunused-variable]:  => 1274:9
  + drivers/net/ethernet/smsc/smc91c92_cs.c: warning: unused variable 'smc' [-Wunused-variable]: 959:23 => 1314:25, 959:23
  + drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c: warning: assignment makes pointer from integer without a cast [enabled by default]:  => 90:8
  + drivers/net/ethernet/wiznet/w5100.c: warning: 'w5100_resume' defined but not used [-Wunused-function]:  => 777:12
  + drivers/net/ethernet/wiznet/w5100.c: warning: 'w5100_suspend' defined but not used [-Wunused-function]:  => 762:12
  + drivers/net/ethernet/wiznet/w5300.c: warning: 'w5300_resume' defined but not used [-Wunused-function]:  => 689:12
  + drivers/net/ethernet/wiznet/w5300.c: warning: 'w5300_suspend' defined but not used [-Wunused-function]:  => 674:12
  + drivers/net/ethernet/xircom/xirc2ps_cs.c: warning: unused variable 'ioaddr' [-Wunused-variable]:  => 1458:18, 1718:18, 1706:18, 1281:15
  + drivers/net/hamradio/baycom_ser_fdx.c: warning: statement with no effect [-Wunused-value]:  => 308:4, 396:2, 397:2, 312:4
  + drivers/net/hamradio/baycom_ser_fdx.c: warning: suggest explicit braces to avoid ambiguous 'else' [-Wparentheses]:  => 328:7
  + drivers/net/hamradio/baycom_ser_hdx.c: warning: statement with no effect [-Wunused-value]:  => 414:4, 397:4, 455:2, 456:2, 393:4
  + drivers/net/hamradio/yam.c: warning: statement with no effect [-Wunused-value]:  => 526:2, 907:3, 314:2, 315:2, 490:2, 525:2, 491:2
  + drivers/net/hamradio/yam.c: warning: unused variable 'divisor' [-Wunused-variable]:  => 478:6
  + drivers/net/hippi/rrunner.c: warning: assignment makes pointer from integer without a cast [enabled by default]:  => 152:15
  + drivers/net/wimax/i2400m/control.c: warning: format '%zu' expects argument of type 'size_t', but argument 4 has type 'ssize_t' [-Wformat]:  => 134:10, 239:6
  + drivers/net/wimax/i2400m/control.c: warning: format '%zu' expects argument of type 'size_t', but argument 5 has type 'ssize_t' [-Wformat]:  => 239:6
  + drivers/net/wimax/i2400m/usb-fw.c: warning: format '%zd' expects argument of type 'signed size_t', but argument 4 has type 'ssize_t' [-Wformat]:  => 210:4
  + drivers/net/wimax/i2400m/usb-fw.c: warning: format '%zd' expects argument of type 'signed size_t', but argument 8 has type 'ssize_t' [-Wformat]:  => 222:2
  + drivers/net/wimax/i2400m/usb-fw.c: warning: format '%zu' expects argument of type 'size_t', but argument 4 has type 'ssize_t' [-Wformat]:  => 215:4
  + drivers/net/wireless/ath/ath6kl/htc_pipe.c: warning: integer overflow in expression [-Woverflow]:  => 1282:26, 1282:227
  + drivers/net/wireless/ath/carl9170/fwcmd.h: warning: 'packed' attribute ignored for field of type 'struct <anonymous>[]' [-Wattributes]:  => 123:2
  + drivers/net/wireless/ath/carl9170/mac.c: warning: 'power' may be used uninitialized in this function [-Wuninitialized]: 509:10 => 509:10, 509:122
  + drivers/net/wireless/ath/carl9170/rx.c: warning: 'head' may be used uninitialized in this function [-Wuninitialized]: 730:6 => 730:6, 730:48
  + drivers/net/wireless/brcm80211/brcmsmac/aiutils.c: warning: 'w' may be used uninitialized in this function [-Wuninitialized]:  => 823:9
  + drivers/net/wireless/hostap/hostap_cs.c: warning: unused variable 'dev' [-Wunused-variable]:  => 247:21
  + drivers/net/wireless/ipw2x00/ipw2100.c: warning: assignment makes pointer from integer without a cast [enabled by default]:  => 6233:9
  + drivers/net/wireless/p54/lmac.h: warning: 'packed' attribute ignored for field of type 'struct <anonymous>[3]' [-Wattributes]:  => 377:2
  + drivers/net/wireless/wl3501_cs.c: warning: 'addr' may be used uninitialized in this function [-Wuninitialized]:  => 805:23
  + drivers/net/wireless/wl3501_cs.c: warning: 'implemented' may be used uninitialized in this function [-Wuninitialized]:  => 1765:5
  + drivers/net/wireless/wl3501_cs.c: warning: 'len_keys' may be used uninitialized in this function [-Wuninitialized]:  => 1783:11
  + drivers/net/wireless/wl3501_cs.c: warning: 'next' may be used uninitialized in this function [-Wuninitialized]:  => 343:24
  + drivers/net/wireless/wl3501_cs.c: warning: 'pwr_state' may be used uninitialized in this function [-Wuninitialized]:  => 1802:25
  + drivers/net/wireless/wl3501_cs.c: warning: 'restricted' may be used uninitialized in this function [-Wuninitialized]:  => 1773:23
  + drivers/net/wireless/wl3501_cs.c: warning: 'retry' may be used uninitialized in this function [-Wuninitialized]:  => 1748:20
  + drivers/net/wireless/wl3501_cs.c: warning: 'rssi' is used uninitialized in this function [-Wuninitialized]:  => 951:34
  + drivers/net/wireless/wl3501_cs.c: warning: 'sig_id' may be used uninitialized in this function [-Wuninitialized]:  => 1046:2
  + drivers/net/wireless/wl3501_cs.c: warning: 'threshold' may be used uninitialized in this function [-Wuninitialized]:  => 1698:20, 1682:19
  + drivers/net/wireless/wl3501_cs.c: warning: 'tmp' is used uninitialized in this function [-Wuninitialized]:  => 818:13
  + drivers/net/wireless/wl3501_cs.c: warning: 'tmp' may be used uninitialized in this function [-Wuninitialized]:  => 802:6
  + drivers/net/wireless/wl3501_cs.c: warning: 'txpow' may be used uninitialized in this function [-Wuninitialized]:  => 1715:23
  + drivers/net/wireless/wl3501_cs.c: warning: 'value' may be used uninitialized in this function [-Wuninitialized]:  => 1379:24
  + drivers/net/wireless/wl3501_cs.c: warning: unused variable 'new' [-Wunused-variable]:  => 721:5, 738:5
  + drivers/parport/parport_pc.c: warning: unused variable 'fifo' [-Wunused-variable]:  => 477:12
  + drivers/pci/quirks.c: warning: assignment makes pointer from integer without a cast [enabled by default]:  => 3140:12
  + drivers/power/smb347-charger.c: warning: 'smb347_remove' defined but not used [-Wunused-function]:  => 1109:12
  + drivers/regulator/tps62360-regulator.c: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]:  => 384:13
  + drivers/scsi/libsas/sas_host_smp.c: warning: 'bit' may be used uninitialized in this function [-Wuninitialized]:  => 112:16
  + drivers/scsi/osst.c: warning: 'STp' may be used uninitialized in this function [-Wuninitialized]:  => 4612:2
  + drivers/scsi/pcmcia/sym53c500_cs.c: warning: unused variable 'port_base' [-Wunused-variable]:  => 553:6
  + drivers/scsi/qla4xxx/ql4_nx.c: warning: format '%lx' expects argument of type 'long unsigned int', but argument 5 has type 'uint32_t' [-Wformat]:  => 1867:2
  + drivers/scsi/qlogicfas408.c: warning: 'qlcfg5' defined but not used [-Wunused-variable]:  => 63:12
  + drivers/scsi/qlogicfas408.c: warning: 'qlcfg6' defined but not used [-Wunused-variable]:  => 64:12
  + drivers/scsi/qlogicfas408.c: warning: 'qlcfg7' defined but not used [-Wunused-variable]:  => 65:12
  + drivers/scsi/qlogicfas408.c: warning: 'qlcfg8' defined but not used [-Wunused-variable]:  => 66:12
  + drivers/scsi/qlogicfas408.c: warning: 'qlcfg9' defined but not used [-Wunused-variable]:  => 67:12
  + drivers/scsi/qlogicfas408.c: warning: 'qlcfgc' defined but not used [-Wunused-variable]:  => 68:12
  + drivers/scsi/qlogicfas408.c: warning: unused variable 'int_type' [-Wunused-variable]:  => 271:6, 216:6, 82:6, 581:6
  + drivers/scsi/qlogicfas408.c: warning: unused variable 'qbase' [-Wunused-variable]:  => 580:6
  + drivers/scsi/scsi_debug.c: warning: 'csum' may be used uninitialized in this function [-Wuninitialized]: 1755:6 => 1755:6, 1755:3
  + drivers/staging/bcm/Bcmchar.c: warning: format '%zd' expects argument of type 'signed size_t', but argument 2 has type 'ssize_t' [-Wformat]:  => 146:3
  + drivers/staging/bcm/Bcmchar.c: warning: format '%zd' expects argument of type 'signed size_t', but argument 3 has type 'ssize_t' [-Wformat]:  => 146:3
  + drivers/staging/iio/accel/adis16204_core.c: warning: 'adis16204_remove' defined but not used [-Wunused-function]:  => 606:12
  + drivers/staging/iio/accel/adis16209_core.c: warning: 'adis16209_remove' defined but not used [-Wunused-function]:  => 605:12
  + drivers/staging/iio/accel/lis3l02dq_core.c: warning: 'lis3l02dq_remove' defined but not used [-Wunused-function]:  => 783:12
  + drivers/staging/iio/adc/ad7476_core.c: warning: 'ad7476_remove' defined but not used [-Wunused-function]:  => 207:12
  + drivers/staging/iio/adc/ad7793.c: warning: 'ad7793_remove' defined but not used [-Wunused-function]:  => 996:12
  + drivers/staging/iio/gyro/adis16060_core.c: warning: 'adis16060_r_remove' defined but not used [-Wunused-function]:  => 187:12
  + drivers/staging/iio/gyro/adis16060_core.c: warning: 'adis16060_w_remove' defined but not used [-Wunused-function]:  => 213:12
  + drivers/staging/iio/gyro/adxrs450_core.c: warning: 'adxrs450_remove' defined but not used [-Wunused-function]:  => 412:12
  + drivers/staging/iio/imu/adis16400_core.c: warning: 'adis16400_remove' defined but not used [-Wunused-function]:  => 1227:12
  + drivers/staging/iio/light/tsl2563.c: warning: 'tsl2563_remove' defined but not used [-Wunused-function]:  => 808:12
  + drivers/staging/iio/magnetometer/ak8975.c: warning: 'ak8975_remove' defined but not used [-Wunused-function]:  => 548:12
  + drivers/staging/iio/meter/ade7753.c: warning: 'ade7753_remove' defined but not used [-Wunused-function]:  => 556:12
  + drivers/staging/iio/meter/ade7758_core.c: warning: 'ade7758_remove' defined but not used [-Wunused-function]:  => 970:12
  + drivers/staging/ipack/bridges/tpci200.c: warning: assignment makes pointer from integer without a cast [enabled by default]:  => 1048:16, 1017:17, 951:11, 1044:10
  + drivers/staging/media/easycap/easycap_main.c: warning: 'rc' may be used uninitialized in this function [-Wuninitialized]:  => 3985:6
  + drivers/staging/ramster/cluster/tcp.c: warning: format '%zd' expects argument of type 'signed size_t', but argument 12 has type 'ssize_t' [-Wformat]:  => 1003:3
  + drivers/staging/ramster/zcache-main.c: warning: 'page' may be used uninitialized in this function [-Wuninitialized]: 1554:13 => 1556:14, 1554:13
  + drivers/staging/rts5139/rts51x.c: warning: 'rts51x_try_to_enter_ss' defined but not used [-Wunused-function]:  => 204:13
  + drivers/staging/speakup/serialio.c: warning: statement with no effect [-Wunused-value]:  => 114:2, 113:2, 115:2, 112:2
  + drivers/staging/speakup/synth.c: warning: suggest explicit braces to avoid ambiguous 'else' [-Wparentheses]:  => 142:6
  + drivers/staging/vt6656/main_usb.c: warning: the frame size of 1872 bytes is larger than 1024 bytes [-Wframe-larger-than=]:  => 2054:1
  + drivers/staging/wlags49_h2/hcf.c: warning: unused variable 'io_port' [-Wunused-variable]:  => 4349:14, 3636:22
  + drivers/staging/wlags49_h25/../wlags49_h2/hcf.c: warning: unused variable 'io_port' [-Wunused-variable]:  => 4349:14, 3636:22
  + drivers/staging/wlan-ng/prism2fw.c: warning: the frame size of 4228 bytes is larger than 1024 bytes [-Wframe-larger-than=]:  => 1115:1
  + drivers/staging/wlan-ng/prism2fw.c: warning: the frame size of 4264 bytes is larger than 1024 bytes [-Wframe-larger-than=]:  => 1115:1
  + drivers/staging/xgifb/vb_table.h: warning: (near initialization for 'XGI330_StandTable.CRTC') [-Wmissing-braces]:  => 214:3
  + drivers/staging/xgifb/vb_table.h: warning: (near initialization for 'XGI330_StandTable.CRTC[1]') [enabled by default]:  => 215:2, 218:3, 217:3, 216:3
  + drivers/staging/xgifb/vb_table.h: warning: (near initialization for 'XGI330_StandTable.CRTC[2]') [enabled by default]:  => 219:2, 220:3, 221:3
  + drivers/staging/xgifb/vb_table.h: warning: (near initialization for 'XGI330_StandTable.CRTC[3]') [enabled by default]:  => 223:3, 222:2
  + drivers/tty/n_gsm.c: warning: unused variable 'buf' [-Wunused-variable]:  => 2256:7
  + drivers/tty/serial/8250/8250.c: warning: statement with no effect [-Wunused-value]:  => 2134:3
  + drivers/tty/serial/8250/serial_cs.c: warning: unused variable 'ctrl' [-Wunused-variable]:  => 160:15
  + drivers/tty/serial/crisv10.c: warning: 'ser_interrupt' defined but not used [-Wunused-function]:  => 2600:1
  + drivers/tty/serial/ifx6x60.c: warning: 'ifx_spi_spi_remove' defined but not used [-Wunused-function]:  => 1191:12
  + drivers/tty/serial/mfd.c: warning: 'serial_hsu_remove' defined but not used [-Wunused-function]:  => 1436:13
  + drivers/usb/gadget/f_hid.c: warning: format '%zd' expects argument of type 'signed size_t', but argument 3 has type 'ssize_t' [-Wformat]:  => 233:3
  + drivers/usb/gadget/f_ncm.c: warning: 'tmp' may be used uninitialized in this function [-Wuninitialized]: 986:5, 1000:28, 1032:4, 1053:14, 1053:30 => 1032:13, 1073:6, 986:5, 1000:28, 1073:19, 1032:4, 1053:14, 1053:30
  + drivers/usb/gadget/inode.c: warning: format '%Zd' expects argument of type 'signed size_t', but argument 5 has type 'ssize_t' [-Wformat]:  => 1924:21
  + drivers/usb/host/isp1362.h: warning: statement with no effect [-Wunused-value]:  => 729:3
  + drivers/usb/misc/sisusbvga/sisusb.c: warning: format '%zd' expects argument of type 'signed size_t', but argument 3 has type 'ssize_t' [-Wformat]:  => 982:7
  + drivers/usb/misc/sisusbvga/sisusb.c: warning: passing argument 7 of 'sisusb_write_mem_bulk' from incompatible pointer type [enabled by default]:  => 1336:2
  + drivers/usb/misc/sisusbvga/sisusb_con.c: warning: passing argument 5 of 'sisusb_copy_memory' from incompatible pointer type [enabled by default]:  => 996:4, 880:5, 554:5, 472:5, 985:4, 418:5, 991:4, 505:5, 664:5, 383:5
  + drivers/usb/musb/musb_io.h: warning: statement with no effect [-Wunused-value]:  => 47:4, 45:4, 49:4
  + drivers/usb/storage/realtek_cr.c: warning: 'buf[0]' may be used uninitialized in this function [-Wuninitialized]:  => 463:40
  + drivers/usb/storage/realtek_cr.c: warning: 'buf[10]' may be used uninitialized in this function [-Wuninitialized]:  => 470:31
  + drivers/usb/storage/realtek_cr.c: warning: 'buf[11]' may be used uninitialized in this function [-Wuninitialized]:  => 471:31
  + drivers/usb/storage/realtek_cr.c: warning: 'buf[12]' may be used uninitialized in this function [-Wuninitialized]:  => 472:30
  + drivers/usb/storage/realtek_cr.c: warning: 'buf[13]' may be used uninitialized in this function [-Wuninitialized]:  => 474:50
  + drivers/usb/storage/realtek_cr.c: warning: 'buf[14]' may be used uninitialized in this function [-Wuninitialized]:  => 475:33
  + drivers/usb/storage/realtek_cr.c: warning: 'buf[15]' may be used uninitialized in this function [-Wuninitialized]:  => 476:33
  + drivers/usb/storage/realtek_cr.c: warning: 'buf[1]' may be used uninitialized in this function [-Wuninitialized]:  => 463:24
  + drivers/usb/storage/realtek_cr.c: warning: 'buf[2]' may be used uninitialized in this function [-Wuninitialized]:  => 464:40
  + drivers/usb/storage/realtek_cr.c: warning: 'buf[3]' may be used uninitialized in this function [-Wuninitialized]:  => 464:24
  + drivers/usb/storage/realtek_cr.c: warning: 'buf[4]' may be used uninitialized in this function [-Wuninitialized]:  => 465:28
  + drivers/usb/storage/realtek_cr.c: warning: 'buf[5]' may be used uninitialized in this function [-Wuninitialized]:  => 466:30
  + drivers/usb/storage/realtek_cr.c: warning: 'buf[6]' may be used uninitialized in this function [-Wuninitialized]:  => 467:30
  + drivers/usb/storage/realtek_cr.c: warning: 'buf[7]' may be used uninitialized in this function [-Wuninitialized]:  => 468:43
  + drivers/usb/storage/realtek_cr.c: warning: 'buf[8]' may be used uninitialized in this function [-Wuninitialized]:  => 468:27
  + drivers/usb/storage/realtek_cr.c: warning: 'buf[9]' may be used uninitialized in this function [-Wuninitialized]:  => 469:30
  + drivers/video/auo_k190x.c: warning: 'auok190x_resume' defined but not used [-Wunused-function]:  => 726:12
  + drivers/video/auo_k190x.c: warning: 'auok190x_suspend' defined but not used [-Wunused-function]:  => 686:12
  + drivers/video/backlight/ams369fg06.c: warning: 'ret' may be used uninitialized in this function [-Wuninitialized]:  => 354:2, 360:2, 387:2
  + drivers/virtio/virtio_mmio.c: warning: format '%u' expects argument of type 'unsigned int *', but argument 4 has type 'resource_size_t *' [-Wformat]:  => 526:4
  + fs/9p/xattr.c: warning: format '%zd' expects argument of type 'signed size_t', but argument 4 has type 'ssize_t' [-Wformat]:  => 35:3
  + fs/afs/internal.h: warning: 'packed' attribute ignored for field of type 'enum <anonymous>' [-Wattributes]:  => 163:2
  + fs/afs/write.c: warning: format '%zd' expects argument of type 'signed size_t', but argument 4 has type 'ssize_t' [-Wformat]:  => 653:2, 649:3
  + fs/befs/linuxvfs.c: warning: 'nlsname' may be used uninitialized in this function [-Wuninitialized]:  => 259:10
  + fs/befs/linuxvfs.c: warning: 'nlsnamelen' may be used uninitialized in this function [-Wuninitialized]:  => 259:10
  + fs/befs/linuxvfs.c: warning: 'utfname' may be used uninitialized in this function [-Wuninitialized]:  => 184:7
  + fs/btrfs/backref.c: warning: 'type' may be used uninitialized in this function [-Wuninitialized]:  => 1307:3
  + fs/btrfs/ctree.c: warning: 'pslot' may be used uninitialized in this function [-Wuninitialized]:  => 1904:24, 1700:24
  + fs/btrfs/ctree.c: warning: 'tm' may be used uninitialized in this function [-Wuninitialized]:  => 593:17, 573:6, 533:6
  + fs/btrfs/file-item.c: warning: comparison of distinct pointer types lacks a cast [enabled by default]: 808:346, 767:320, 717:306, 808:703, 808:9, 717:7, 808:711, 717:302, 767:316, 767:21, 808:350 => 808:346, 767:320, 716:3, 717:306, 808:703, 808:9, 717:7, 808:711, 717:302, 767:316, 767:21, 808:350, 765:2
  + fs/btrfs/free-space-cache.c: warning: 'next_zero' may be used uninitialized in this function [-Wuninitialized]:  => 2377:5
  + fs/btrfs/free-space-cache.c: warning: 'start' may be used uninitialized in this function [-Wuninitialized]:  => 967:7
  + fs/btrfs/free-space-cache.c: warning: 'type' may be used uninitialized in this function [-Wuninitialized]:  => 720:3
  + fs/btrfs/inode.c: warning: 'cow_start' may be used uninitialized in this function [-Wuninitialized]:  => 1359:7
  + fs/btrfs/inode.c: warning: 'cur_offset' may be used uninitialized in this function [-Wuninitialized]: 1228:16 => 1377:31, 1254:16
  + fs/btrfs/inode.c: warning: 'extent_end' may be used uninitialized in this function [-Wuninitialized]: 1247:6 => 1273:6, 1273:3
  + fs/cifs/connect.c: warning: format '%zd' expects argument of type 'signed size_t', but argument 3 has type 'ssize_t' [-Wformat]:  => 2524:3, 2516:3, 2534:3, 2509:3
  + fs/cifs/xattr.c: warning: format '%zd' expects argument of type 'signed size_t', but argument 3 has type 'ssize_t' [-Wformat]:  => 322:5
  + fs/dlm/lock.c: warning: 'r' may be used uninitialized in this function [-Wuninitialized]:  => 1181:3
  + fs/ecryptfs/crypto.c: warning: format '%zd' expects argument of type 'signed size_t', but argument 3 has type 'ssize_t' [-Wformat]:  => 1513:11
  + fs/ecryptfs/keystore.c: warning: 'payload_len' may be used uninitialized in this function [-Wuninitialized]:  => 1168:28
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
  + fs/ext4/mballoc.c: warning: 'e4b.bd_bitmap' may be used uninitialized in this function [-Wuninitialized]:  => 1046:6
  + fs/ext4/mmp.c: warning: 'ext4_mmp_csum' uses dynamic stack allocation [enabled by default]:  => 19:1
  + fs/ext4/namei.c: warning: 'ext4_dirent_csum' uses dynamic stack allocation [enabled by default]:  => 249:1
  + fs/ext4/namei.c: warning: 'ext4_dx_csum' uses dynamic stack allocation [enabled by default]:  => 345:1
  + fs/ext4/page-io.c: warning: format '%zd' expects argument of type 'signed size_t', but argument 6 has type 'ssize_t' [-Wformat]:  => 107:5
  + fs/ext4/super.c: warning: 'ext4_fill_super' uses dynamic stack allocation [enabled by default]:  => 3910:1
  + fs/ext4/super.c: warning: 'ext4_group_desc_csum' uses dynamic stack allocation [enabled by default]:  => 2012:1
  + fs/ext4/super.c: warning: 'ext4_superblock_csum' uses dynamic stack allocation [enabled by default]:  => 135:1
  + fs/ext4/super.c: warning: 'first_not_zeroed' may be used uninitialized in this function [-Wuninitialized]:  => 3815:6
  + fs/ext4/xattr.c: warning: 'ext4_xattr_block_csum' uses dynamic stack allocation [enabled by default]:  => 145:1
  + fs/fuse/control.c: warning: 'val' may be used uninitialized in this function [-Wuninitialized]:  => 165:29, 128:23
  + fs/hfsplus/unicode.c: warning: 'dsize' may be used uninitialized in this function [-Wuninitialized]:  => 298:5
  + fs/hfsplus/wrapper.c: warning: 'wd.ablk_size' may be used uninitialized in this function [-Wuninitialized]:  => 213:16
  + fs/hfsplus/wrapper.c: warning: 'wd.ablk_start' may be used uninitialized in this function [-Wuninitialized]:  => 214:17
  + fs/hfsplus/wrapper.c: warning: 'wd.embed_count' may be used uninitialized in this function [-Wuninitialized]:  => 216:15
  + fs/hfsplus/wrapper.c: warning: 'wd.embed_start' may be used uninitialized in this function [-Wuninitialized]:  => 215:11
  + fs/hpfs/alloc.c: warning: 'sec' may be used uninitialized in this function [-Wuninitialized]:  => 206:2
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
  + fs/locks.c: warning: 'lock' may be used uninitialized in this function [-Wuninitialized]:  => 1663:39
  + fs/ncpfs/ncp_fs_sb.h: warning: 'packed' attribute ignored for field of type '__u16' [-Wattributes]:  => 130:4, 127:4, 129:4, 128:4, 126:4
  + fs/ncpfs/ncp_fs_sb.h: warning: 'packed' attribute ignored for field of type '__u32' [-Wattributes]:  => 125:4, 124:4
  + fs/nfs/nfs4xdr.c: warning: the frame size of 1028 bytes is larger than 1024 bytes [-Wframe-larger-than=]:  => 1747:1
  + fs/ocfs2/aops.c: warning: 'wc' may be used uninitialized in this function [-Wuninitialized]:  => 1428:20
  + fs/ocfs2/cluster/heartbeat.c: warning: 'block_bits' may be used uninitialized in this function [-Wuninitialized]:  => 1557:21
  + fs/ocfs2/cluster/heartbeat.c: warning: 'block_bytes' may be used uninitialized in this function [-Wuninitialized]:  => 1556:22
  + fs/ocfs2/cluster/tcp.c: warning: format '%zd' expects argument of type 'signed size_t', but argument 12 has type 'ssize_t' [-Wformat]:  => 997:3
  + fs/ocfs2/dir.c: warning: 'split_hash' may be used uninitialized in this function [-Wuninitialized]:  => 3754:4
  + fs/ocfs2/dlmfs/dlmfs.c: warning: format '%zd' expects argument of type 'signed size_t', but argument 7 has type 'ssize_t' [-Wformat]:  => 328:2, 284:2
  + fs/ocfs2/quota_local.c: warning: 'dchunk' may be used uninitialized in this function [-Wuninitialized]:  => 952:45
  + fs/ocfs2/refcounttree.c: warning: 'new_cpos' may be used uninitialized in this function [-Wuninitialized]:  => 1608:6
  + fs/ocfs2/refcounttree.c: warning: 'ref_blkno' may be used uninitialized in this function [-Wuninitialized]:  => 2316:6
  + fs/ocfs2/xattr.c: warning: 'ret' may be used uninitialized in this function [-Wuninitialized]:  => 2979:2
  + fs/omfs/file.c: warning: 'remain' may be used uninitialized in this function [-Wuninitialized]:  => 258:4
  + fs/quota/quota_tree.c: warning: format '%zd' expects argument of type 'signed size_t', but argument 4 has type 'ssize_t' [-Wformat]:  => 372:4
  + fs/quota/quota_v2.c: warning: format '%zd' expects argument of type 'signed size_t', but argument 5 has type 'ssize_t' [-Wformat]:  => 66:92
  + fs/udf/super.c: warning: 'map' may be used uninitialized in this function [-Wuninitialized]: 1193:9 => 1193:9, 1193:2
  + include/linux/err.h: warning: 'bg_bh' may be used uninitialized in this function [-Wuninitialized]:  => 34:9
  + include/linux/kernel.h: warning: "ALIGN" redefined [enabled by default]:  => 44:0
  + include/linux/list.h: warning: 'head' may be used uninitialized in this function [-Wuninitialized]:  => 612:21
  + include/linux/sysv_fs.h: warning: 'packed' attribute ignored for field of type '__fs32' [-Wattributes]:  => 114:2, 181:2, 130:2, 43:2, 42:2, 30:2, 142:2, 100:2, 180:2, 168:2, 144:2, 112:2
  + include/linux/sysv_fs.h: warning: 'packed' attribute ignored for field of type 'sysv_zone_t[64]' [-Wattributes]:  => 171:2
  + include/linux/vga_switcheroo.h: warning: 'struct pci_dev' declared inside parameter list [enabled by default]: 49:91, 53:34, 28:30, 54:108 => 67:2, 63:108, 60:91, 31:30, 35:50, 37:28, 70:89, 62:16, 36:25
  + include/math-emu/double.h: warning: "__LITTLE_ENDIAN" is not defined [-Wundef]:  => 59:5
  + include/math-emu/single.h: warning: "__LITTLE_ENDIAN" is not defined [-Wundef]:  => 50:5
  + include/net/ipx.h: warning: 'packed' attribute ignored for field of type '__be16' [-Wattributes]:  => 30:2, 32:2
  + include/net/ipx.h: warning: 'packed' attribute ignored for field of type 'struct ipx_address' [-Wattributes]:  => 42:9, 41:9
  + ipc/mqueue.c: warning: 'msg_ptr' may be used uninitialized in this function [-Wuninitialized]:  => 1184:3
  + kernel/cgroup.c: warning: integer overflow in expression [-Woverflow]:  => 4167:32, 4167:21
  + kernel/sched/core.c: warning: unsupported argument to '__builtin_return_address' [enabled by default]:  => 3105:51, 3103:50
  + kernel/signal.c: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]: 2707:1244, 2683:2561, 2683:1202, 2676:2634, 2676:1245, 2707:2633, 3074:2342, 3074:1073 => 2718:2633, 2687:2634, 2722:1223, 2718:1244, 3092:1073, 2722:2597, 2694:2561, 2687:1245, 3092:2342, 2694:1202
  + kernel/sys.c: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]:  => 1980:2306, 1980:1057
  + kernel/trace/trace_sched_wakeup.c: warning: 'pc' may be used uninitialized in this function [-Wuninitialized]:  => 122:16
  + lib/crc32.c: warning: unused variable 't4' [-Wunused-variable]:  => 77:13
  + lib/crc32.c: warning: unused variable 't5' [-Wunused-variable]:  => 77:27
  + lib/crc32.c: warning: unused variable 't6' [-Wunused-variable]:  => 77:41
  + lib/crc32.c: warning: unused variable 't7' [-Wunused-variable]:  => 77:55
  + lib/iomap.c: warning: statement with no effect [-Wunused-value]:  => 205:154, 201:154, 197:154
  + lib/mpi/mpi-inline.h: warning: '______f' is static but declared in inline function 'mpihelp_add' which is not static [enabled by default]:  => 70:2, 73:2
  + lib/mpi/mpi-inline.h: warning: '______f' is static but declared in inline function 'mpihelp_add_1' which is not static [enabled by default]:  => 45:2, 49:4, 56:2
  + lib/mpi/mpi-inline.h: warning: '______f' is static but declared in inline function 'mpihelp_sub' which is not static [enabled by default]:  => 113:2, 116:2
  + lib/mpi/mpi-inline.h: warning: '______f' is static but declared in inline function 'mpihelp_sub_1' which is not static [enabled by default]:  => 92:4, 99:2, 88:2
  + mm/memcontrol.c: warning: 'thresholds' may be used uninitialized in this function [-Wuninitialized]: 4491:35, 4392:19, 4389:16 => 4435:32, 4314:16, 4317:19, 4417:35
  + mm/memory-failure.c: warning: statement with no effect [-Wunused-value]:  => 1451:2
  + mm/nommu.c: warning: 'capabilities' may be used uninitialized in this function [-Wuninitialized]:  => 1391:18
  + mm/oom_kill.c: warning: 'points' may be used uninitialized in this function [-Wuninitialized]:  => 741:19
  + mm/oom_kill.c: warning: 'points' may be used uninitialized in this function:  => 694
  + mm/slob.c: warning: comparison of distinct pointer types lacks a cast [enabled by default]: 482:152, 535:153, 554:153 => 482:152, 535:15, 482:14, 535:153, 554:15, 554:153
  + mm/swapfile.c: warning: 'span' may be used uninitialized in this function [-Wuninitialized]:  => 2117:15
  + net/ceph/messenger.c: warning: 'proto' may be used uninitialized in this function [-Wuninitialized]: 726:38 => 729:39, 729:38
  + net/core/skbuff.c: warning: 'err' may be used uninitialized in this function [-Wuninitialized]:  => 1258:6
  + net/ipv4/esp4.c: warning: 'net_adj' may be used uninitialized in this function [-Wuninitialized]:  => 477:29
  + net/ipv4/inet_connection_sock.c: warning: 'head' may be used uninitialized in this function [-Wuninitialized]:  => 207:2
  + net/ipv4/tcp.c: warning: 'copy' may be used uninitialized in this function [-Wuninitialized]:  => 870:3
  + net/irda/irnet/irnet_ppp.c: warning: format '%Zd' expects argument of type 'signed size_t', but argument 3 has type 'ssize_t' [-Wformat]:  => 334:7
  + net/mac80211/cfg.c: warning: 'send_direct' may be used uninitialized in this function [-Wuninitialized]:  => 2745:2
  + net/mac80211/mlme.c: warning: 'sta' may be used uninitialized in this function [-Wuninitialized]:  => 3174:7
  + net/nfc/llcp/llcp.c: warning: 'sn_len' may be used uninitialized in this function [-Wuninitialized]  LD [M]  net/caif/caif.o:  => 576:4
  + net/rds/rdma.c: warning: 'iov_size' may be used uninitialized in this function [-Wuninitialized]:  => 697:15
  + net/sctp/protocol.c: warning: label 'free_next' defined but not used [-Wunused-label]:  => 676:1
  + net/sunrpc/auth_gss/auth_gss.c: warning: format '%Zd' expects argument of type 'signed size_t', but argument 2 has type 'ssize_t' [-Wformat]:  => 684:2
  + net/sunrpc/auth_gss/auth_gss.c: warning: format '%zd' expects argument of type 'signed size_t', but argument 3 has type 'ssize_t' [-Wformat]:  => 666:5
  + net/sunrpc/xprtsock.c: warning: format '%Zd' expects argument of type 'signed size_t', but argument 3 has type 'ssize_t' [-Wformat]:  => 1205:2
  + net/wireless/nl80211.c: warning: 'rdev' may be used uninitialized in this function [-Wuninitialized]:  => 1531:14
  + net/wireless/radiotap.c: warning: 'size' may be used uninitialized in this function [-Wuninitialized]:  => 283:10
  + security/integrity/iint.c: warning: 'iint' may be used uninitialized in this function [-Wuninitialized]:  => 35:31
  + sound/pcmcia/vx/vxp_ops.c: warning: unused variable 'port' [-Wunused-variable]:  => 367:7
  + sound/soc/codecs/lm49453.c: warning: passing argument 3 of 'snd_soc_register_codec' discards 'const' qualifier from pointer target type [enabled by default]:  => 1511:89, 1511:24
  + sound/soc/codecs/wm8804.c: warning: 'pll_div.freqmode' may be used uninitialized in this function [-Wuninitialized]:  => 406:26
  + sound/soc/codecs/wm8804.c: warning: 'pll_div.k' may be used uninitialized in this function [-Wuninitialized]:  => 409:48
  + sound/soc/codecs/wm8804.c: warning: 'pll_div.mclkdiv' may be used uninitialized in this function [-Wuninitialized]:  => 406:45
  + sound/soc/codecs/wm8804.c: warning: 'pll_div.n' may be used uninitialized in this function [-Wuninitialized]:  => 403:19
  + sound/soc/codecs/wm8804.c: warning: 'pll_div.prescale' may be used uninitialized in this function [-Wuninitialized]:  => 403:39
  + sound/soc/codecs/wm8983.c: warning: 'pll_div.k' may be used uninitialized in this function [-Wuninitialized]: 872:15 => 873:50, 872:15
  + sound/soc/codecs/wm8985.c: warning: 'pll_div.k' may be used uninitialized in this function [-Wuninitialized]: 851:15 => 852:50, 851:15
  + sound/soc/soc-dapm.c: warning: 'ret' may be used uninitialized in this function [-Wuninitialized]:  => 2996:6
  + warning:   CC [M]  drivers/media/video/cx88/cx88-vbi.o:  => N/A
  + warning:   CC [M]  drivers/net/wireless/iwlegacy/common.o:  => N/A
  + warning:   CC [M]  drivers/net/wireless/ti/wl1251/ps.o:  => N/A
  + warning: "cause_of_death" [vmlinux] is COMMON symbol:  => N/A
  + warning: (LOCKDEP && FAULT_INJECTION_STACKTRACE_FILTER && LATENCYTOP && KMEMCHECK) selects FRAME_POINTER which has unmet direct dependencies (DEBUG_KERNEL && (CRIS || M68K || FRV || UML || AVR32 || SUPERH || BLACKFIN || MN10300) || ARCH_WANT_FRAME_POINTERS):  => N/A
  + warning: WARNING: drivers/tty/ipwireless/ipwireless.o (.xt.lit): unexpected non-allocatable section.:  => N/A
  + warning: arch/powerpc/platforms/built-in.o(.text+0x180b4): Section mismatch in reference from the function .pci_dn_reconfig_notifier() to the function .devinit.text:.eeh_dev_init():  => N/A
  + warning: arch/powerpc/platforms/built-in.o(.text+0x180d4): Section mismatch in reference from the function .pci_dn_reconfig_notifier() to the function .devinit.text:.eeh_dev_init():  => N/A
  + warning: arch/powerpc/platforms/pseries/built-in.o(.text+0x4538): Section mismatch in reference from the function .pci_dn_reconfig_notifier() to the function .devinit.text:.eeh_dev_init():  => N/A
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
  + warning: drivers/scsi/fcoe/built-in.o(.init.text+0x88): Section mismatch in reference from the function libfcoe_init() to the function .exit.text:fcoe_transport_exit():  => N/A
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
  + warning: drivers/scsi/fcoe/libfcoe.o(.init.text+0x88): Section mismatch in reference from the function init_module() to the function .exit.text:fcoe_transport_exit():  => N/A
  + warning: drivers/scsi/fcoe/libfcoe.o(.init.text+0x88): Section mismatch in reference from the function libfcoe_init() to the function .exit.text:fcoe_transport_exit():  => N/A
  + warning: drivers/spi/built-in.o(.devinit.text+0x1c20): Section mismatch in reference from the function rspi_probe() to the function .devexit.text:spidev_remove():  => N/A
  + warning: drivers/staging/gdm72xx/gdmwm.o (.xt.lit): unexpected non-allocatable section.:  => N/A
  + warning: drivers/staging/gdm72xx/gdmwm.o (.xt.prop): unexpected non-allocatable section.:  => N/A
  + warning: drivers/staging/ipack/bridges/tpci200.o(.data+0x28): Section mismatch in reference from the variable tpci200_pci_drv to the function .devexit.text:tpci200_pci_remove():  => N/A
  + warning: drivers/tty/serial/jsm/jsm.o (.xt.prop): unexpected non-allocatable section.:  => N/A
  + warning: fs/lockd/lockd.o (.xt.lit): unexpected non-allocatable section.:  => N/A
  + warning: net/irda/irda.o (.xt.lit): unexpected non-allocatable section.:  => N/A
  + warning: net/mac802154/mac802154.o (.xt.lit): unexpected non-allocatable section.:  => N/A
  + warning: net/mac802154/mac802154.o (.xt.prop): unexpected non-allocatable section.:  => N/A
  + warning: net/nfc/hci/hci.o (.xt.lit): unexpected non-allocatable section.:  => N/A
  + warning: net/nfc/hci/hci.o (.xt.prop): unexpected non-allocatable section.:  => N/A
  + warning: net/nfc/nfc.o (.xt.lit): unexpected non-allocatable section.:  => N/A
  + warning: sound/soc/generic/snd-soc-simple-card.o (.xt.lit): unexpected non-allocatable section.:  => N/A
  + warning: sound/soc/generic/snd-soc-simple-card.o (.xt.prop): unexpected non-allocatable section.:  => N/A
  + warning: vmlinux.o(.init.text+0x696ec): Section mismatch in reference from the function libfcoe_init() to the function .exit.text:fcoe_transport_exit():  => N/A

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
