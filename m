Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757402Ab2HYTVX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2012 15:21:23 -0400
Received: from jacques.telenet-ops.be ([195.130.132.50]:59399 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757117Ab2HYTVS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2012 15:21:18 -0400
Date: Sat, 25 Aug 2012 21:21:14 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linux Kernel Development <linux-kernel@vger.kernel.org>,
        linux-next@vger.kernel.org
Subject: Build regressions/improvements in next-20120824
Message-ID: <alpine.DEB.2.00.1208252120430.3159@ayla.of.borg>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Below is the list of build error/warning regressions/improvements in
next-20120824[1] compared to v3.6-rc3[2].

To make this mail fit in the lkml limit, I deleted
  - all implicit function declaration error improvements
  - 204 lines about __mcount_loc on sparc64 
  - all unexpected non-allocatable section warnings on xtensa
  - all warning improvements

Summarized:
  - build errors: +329/-861
  - build warnings: +1206/-3875

Note that there may be false regressions, as the linux-next builds cover more
than twice as many configs.  Still, I decided not to filter them as there are
only 24 additional build errors due to this, which we probably also want to
fix.

Happy fixing! ;-)

Thanks to the linux-next team for providing the build service.

[1] http://kisskb.ellerman.id.au/kisskb/head/5364/ (275 configs)
[2] http://kisskb.ellerman.id.au/kisskb/head/5359/ (116 configs)


*** ERRORS ***

329 regressions:
  + arch/arm/include/asm/glue-cache.h: error: #error Unknown cache maintenance model:  => 129:2
  + arch/arm/include/asm/glue-df.h: error: #error Unknown data abort handler type:  => 99:2
  + arch/arm/include/asm/glue-pf.h: error: #error Unknown prefetch abort handler type:  => 54:2
  + arch/arm/mach-ep93xx/adssphere.c: error: 'SZ_32M' undeclared (first use in this function):  => 32:39
  + arch/arm/mach-ep93xx/gesbc9312.c: error: 'SZ_8M' undeclared (first use in this function):  => 32:39
  + arch/arm/mach-kirkwood/db88f6281-bp-setup.c: error: 'SZ_1M' undeclared here (not in a function):  => 28:11
  + arch/arm/mach-kirkwood/db88f6281-bp-setup.c: error: 'SZ_4M' undeclared here (not in a function):  => 32:11
  + arch/arm/mach-nomadik/board-nhk8815.c: error: 'NAND_NO_READRDY' undeclared here (not in a function):  => 118:6
  + arch/arm/mach-ux500/cpu-db8500.c: error: unknown field 'handle_irq' specified in initializer:  => 119:2
  + arch/arm/mach-ux500/cpu-db8500.c: error: variable 'db8500_pmu_platdata' has initializer but incomplete type:  => 118:8
  + arch/avr32/kernel/entry-avr32b.S: Error: undefined symbol `_TIF_BREAKPOINT' in operation:  => 631, 232, 852, 258
  + arch/blackfin/mach-bf538/boards/ezkit.c: error: #endif without #if:  => 768:2
  + arch/mips/kernel/module.c: error: #endif without #if:  => 247:2
  + drivers/ata/ata_generic.c: error: implicit declaration of function 'read' [-Werror=implicit-function-declaration]:  => 63:3
  + drivers/ata/libata-sff.c: error: implicit declaration of function 'read' [-Werror=implicit-function-declaration]:  => 86:2
  + drivers/ata/pata_arasan_cf.c: error: implicit declaration of function 'read' [-Werror=implicit-function-declaration]:  => 546:3
  + drivers/ata/pata_atp867x.c: error: implicit declaration of function 'read' [-Werror=implicit-function-declaration]:  => 142:2
  + drivers/ata/pata_cs5530.c: error: implicit declaration of function 'read' [-Werror=implicit-function-declaration]:  => 125:2
  + drivers/ata/pata_hpt37x.c: error: implicit declaration of function 'read' [-Werror=implicit-function-declaration]:  => 480:2
  + drivers/ata/pata_hpt3x2n.c: error: implicit declaration of function 'read' [-Werror=implicit-function-declaration]:  => 289:2
  + drivers/ata/pata_hpt3x3.c: error: implicit declaration of function 'read' [-Werror=implicit-function-declaration]:  => 103:2
  + drivers/ata/pata_it821x.c: error: implicit declaration of function 'read' [-Werror=implicit-function-declaration]:  => 677:3
  + drivers/ata/pata_legacy.c: error: implicit declaration of function 'read' [-Werror=implicit-function-declaration]:  => 320:3
  + drivers/ata/pata_marvell.c: error: implicit declaration of function 'read' [-Werror=implicit-function-declaration]:  => 49:3
  + drivers/ata/pata_ns87415.c: error: implicit declaration of function 'read' [-Werror=implicit-function-declaration]:  => 132:2
  + drivers/ata/pata_pcmcia.c: error: implicit declaration of function 'read' [-Werror=implicit-function-declaration]:  => 142:3
  + drivers/ata/pata_pdc2027x.c: error: implicit declaration of function 'read' [-Werror=implicit-function-declaration]:  => 235:2
  + drivers/ata/pata_pdc202xx_old.c: error: implicit declaration of function 'read' [-Werror=implicit-function-declaration]:  => 192:3
  + drivers/ata/pata_sil680.c: error: implicit declaration of function 'read' [-Werror=implicit-function-declaration]:  => 217:2
  + drivers/ata/sata_mv.c: error: implicit declaration of function 'read' [-Werror=implicit-function-declaration]:  => 1955:3
  + drivers/ata/sata_nv.c: error: implicit declaration of function 'read' [-Werror=implicit-function-declaration]:  => 1526:2
  + drivers/ata/sata_sil.c: error: implicit declaration of function 'read' [-Werror=implicit-function-declaration]:  => 570:2
  + drivers/ata/sata_sx4.c: error: implicit declaration of function 'read' [-Werror=implicit-function-declaration]:  => 789:2
  + drivers/bcma/host_pci.c: error: implicit declaration of function 'read' [-Werror=implicit-function-declaration]:  => 43:2
  + drivers/bus/omap-ocp2scp.c: error: '__mod_of_device_table' aliased to undefined symbol 'omap_usb2_id_table':  => 70:34, 70:1
  + drivers/gpio/devres.c: error: redefinition of 'devm_gpio_free':  => 113:6
  + drivers/gpio/devres.c: error: redefinition of 'devm_gpio_request':  => 51:5
  + drivers/gpio/devres.c: error: redefinition of 'devm_gpio_request_one':  => 80:5
  + drivers/gpio/gpio-74x164.c: error: field 'gpio_chip' has incomplete type:  => 22:19
  + drivers/gpio/gpio-74x164.c: error: implicit declaration of function 'gpiochip_add' [-Werror=implicit-function-declaration]:  => 119:2
  + drivers/gpio/gpio-74x164.c: error: implicit declaration of function 'gpiochip_remove' [-Werror=implicit-function-declaration]:  => 143:2
  + drivers/gpio/gpio-adp5588.c: error: dereferencing pointer to incomplete type:  => 383:4, 425:42, 425:32, 380:4, 377:4, 379:4, 381:4, 384:4, 378:4, 385:4, 386:4
  + drivers/gpio/gpio-adp5588.c: error: field 'gpio_chip' has incomplete type:  => 32:19
  + drivers/gpio/gpio-adp5588.c: error: implicit declaration of function 'gpiochip_add' [-Werror=implicit-function-declaration]:  => 417:2
  + drivers/gpio/gpio-adp5588.c: error: implicit declaration of function 'gpiochip_remove' [-Werror=implicit-function-declaration]:  => 460:2
  + drivers/gpio/gpio-amd8111.c: error: (near initialization for 'gp.chip'):  => 169:3, 166:3, 165:3, 170:3, 168:3, 164:3, 173:3, 172:3, 167:3, 171:3
  + drivers/gpio/gpio-amd8111.c: error: field 'chip' has incomplete type:  => 70:19
  + drivers/gpio/gpio-amd8111.c: error: field name not in record or union initializer:  => 169:3, 166:3, 165:3, 170:3, 168:3, 164:3, 173:3, 172:3, 167:3, 171:3
  + drivers/gpio/gpio-amd8111.c: error: implicit declaration of function 'gpiochip_add' [-Werror=implicit-function-declaration]:  => 222:2
  + drivers/gpio/gpio-amd8111.c: error: implicit declaration of function 'gpiochip_remove' [-Werror=implicit-function-declaration]:  => 235:2
  + drivers/gpio/gpio-amd8111.c: error: implicit declaration of function 'ioport_unmap' [-Werror=implicit-function-declaration]:  => 237:2
  + drivers/gpio/gpio-amd8111.c: error: implicit declaration of function 'read' [-Werror=implicit-function-declaration]:  => 84:2
  + drivers/gpio/gpio-arizona.c: error: field 'gpio_chip' has incomplete type:  => 28:19
  + drivers/gpio/gpio-arizona.c: error: implicit declaration of function 'gpiochip_add' [-Werror=implicit-function-declaration]:  => 129:2
  + drivers/gpio/gpio-arizona.c: error: implicit declaration of function 'gpiochip_remove' [-Werror=implicit-function-declaration]:  => 148:2
  + drivers/gpio/gpio-arizona.c: error: unknown field 'can_sleep' specified in initializer:  => 94:2
  + drivers/gpio/gpio-arizona.c: error: unknown field 'direction_input' specified in initializer:  => 90:2
  + drivers/gpio/gpio-arizona.c: error: unknown field 'direction_output' specified in initializer:  => 92:2
  + drivers/gpio/gpio-arizona.c: error: unknown field 'get' specified in initializer:  => 91:2
  + drivers/gpio/gpio-arizona.c: error: unknown field 'label' specified in initializer:  => 88:2
  + drivers/gpio/gpio-arizona.c: error: unknown field 'owner' specified in initializer:  => 89:2
  + drivers/gpio/gpio-arizona.c: error: unknown field 'set' specified in initializer:  => 93:2
  + drivers/gpio/gpio-arizona.c: error: variable 'template_chip' has initializer but incomplete type:  => 87:15
  + drivers/gpio/gpio-generic.c: error: dereferencing pointer to incomplete type:  => 206:4, 181:4, 238:4
  + drivers/gpio/gpio-generic.c: error: implicit declaration of function 'gpiochip_remove' [-Werror=implicit-function-declaration]:  => 356:2
  + drivers/gpio/gpio-janz-ttl.c: error: dereferencing pointer to incomplete type:  => 190:6, 192:6, 188:6, 195:6, 62:47, 84:47, 189:6, 191:6, 196:6
  + drivers/gpio/gpio-janz-ttl.c: error: field 'gpio' has incomplete type:  => 48:19
  + drivers/gpio/gpio-janz-ttl.c: error: implicit declaration of function 'gpiochip_add' [-Werror=implicit-function-declaration]:  => 198:2
  + drivers/gpio/gpio-janz-ttl.c: error: implicit declaration of function 'gpiochip_remove' [-Werror=implicit-function-declaration]:  => 220:2
  + drivers/gpio/gpio-max730x.c: error: implicit declaration of function 'gpiochip_add' [-Werror=implicit-function-declaration]:  => 216:2
  + drivers/gpio/gpio-max730x.c: error: implicit declaration of function 'gpiochip_remove' [-Werror=implicit-function-declaration]:  => 242:2
  + drivers/gpio/gpio-max732x.c: error: dereferencing pointer to incomplete type:  => 571:4, 567:4, 566:4, 561:5, 572:4, 564:5, 570:4, 563:5, 569:4
  + drivers/gpio/gpio-max732x.c: error: field 'gpio_chip' has incomplete type:  => 120:19
  + drivers/gpio/gpio-max732x.c: error: implicit declaration of function 'gpiochip_add' [-Werror=implicit-function-declaration]:  => 634:2
  + drivers/gpio/gpio-max732x.c: error: implicit declaration of function 'gpiochip_remove' [-Werror=implicit-function-declaration]:  => 670:2
  + drivers/gpio/gpio-mc33880.c: error: field 'chip' has incomplete type:  => 51:19
  + drivers/gpio/gpio-mc33880.c: error: implicit declaration of function 'gpiochip_add' [-Werror=implicit-function-declaration]:  => 137:2
  + drivers/gpio/gpio-mc33880.c: error: implicit declaration of function 'gpiochip_remove' [-Werror=implicit-function-declaration]:  => 161:2
  + drivers/gpio/gpio-mcp23s08.c: error: dereferencing pointer to incomplete type:  => 353:8, 345:32
  + drivers/gpio/gpio-mcp23s08.c: error: field 'chip' has incomplete type:  => 61:19
  + drivers/gpio/gpio-mcp23s08.c: error: implicit declaration of function 'gpiochip_add' [-Werror=implicit-function-declaration]:  => 466:2
  + drivers/gpio/gpio-mcp23s08.c: error: implicit declaration of function 'gpiochip_is_requested' [-Werror=implicit-function-declaration]:  => 348:3
  + drivers/gpio/gpio-mcp23s08.c: error: implicit declaration of function 'gpiochip_remove' [-Werror=implicit-function-declaration]:  => 626:3
  + drivers/gpio/gpio-ml-ioh.c: error: dereferencing pointer to incomplete type:  => 244:6, 242:6, 241:6, 238:6, 240:6, 246:6, 236:6, 243:6, 239:6, 237:6, 245:6
  + drivers/gpio/gpio-ml-ioh.c: error: field 'gpio' has incomplete type:  => 96:19
  + drivers/gpio/gpio-ml-ioh.c: error: implicit declaration of function 'gpiochip_add' [-Werror=implicit-function-declaration]:  => 453:3
  + drivers/gpio/gpio-ml-ioh.c: error: implicit declaration of function 'gpiochip_remove' [-Werror=implicit-function-declaration]:  => 499:3
  + drivers/gpio/gpio-pca953x.c: error: dereferencing pointer to incomplete type:  => 315:4, 316:4, 313:4, 312:4, 318:4, 309:4, 320:4, 319:4, 310:4, 317:4, 311:4
  + drivers/gpio/gpio-pca953x.c: error: field 'gpio_chip' has incomplete type:  => 89:19
  + drivers/gpio/gpio-pca953x.c: error: implicit declaration of function 'gpiochip_add' [-Werror=implicit-function-declaration]:  => 705:2
  + drivers/gpio/gpio-pca953x.c: error: implicit declaration of function 'gpiochip_remove' [-Werror=implicit-function-declaration]:  => 742:2
  + drivers/gpio/gpio-pcf857x.c: error: field 'chip' has incomplete type:  => 65:19
  + drivers/gpio/gpio-pcf857x.c: error: implicit declaration of function 'gpiochip_add' [-Werror=implicit-function-declaration]:  => 367:2
  + drivers/gpio/gpio-pcf857x.c: error: implicit declaration of function 'gpiochip_remove' [-Werror=implicit-function-declaration]:  => 424:2
  + drivers/gpio/gpio-pcf857x.c: error: implicit declaration of function 'irq_create_mapping' [-Werror=implicit-function-declaration]:  => 167:2
  + drivers/gpio/gpio-pcf857x.c: error: implicit declaration of function 'irq_domain_add_linear' [-Werror=implicit-function-declaration]:  => 230:2
  + drivers/gpio/gpio-pcf857x.c: error: implicit declaration of function 'irq_domain_remove' [-Werror=implicit-function-declaration]:  => 218:3
  + drivers/gpio/gpio-pcf857x.c: error: implicit declaration of function 'irq_find_mapping' [-Werror=implicit-function-declaration]:  => 183:3
  + drivers/gpio/gpio-rdc321x.c: error: field 'chip' has incomplete type:  => 40:19
  + drivers/gpio/gpio-rdc321x.c: error: implicit declaration of function 'gpiochip_add' [-Werror=implicit-function-declaration]:  => 199:2
  + drivers/gpio/gpio-rdc321x.c: error: implicit declaration of function 'gpiochip_remove' [-Werror=implicit-function-declaration]:  => 213:2
  + drivers/gpio/gpio-stmpe.c: error: field 'chip' has incomplete type:  => 27:19
  + drivers/gpio/gpio-stmpe.c: error: implicit declaration of function 'gpiochip_add' [-Werror=implicit-function-declaration]:  => 355:2
  + drivers/gpio/gpio-stmpe.c: error: implicit declaration of function 'gpiochip_remove' [-Werror=implicit-function-declaration]:  => 392:2
  + drivers/gpio/gpio-stmpe.c: error: unknown field 'can_sleep' specified in initializer:  => 129:2
  + drivers/gpio/gpio-stmpe.c: error: unknown field 'direction_input' specified in initializer:  => 123:2
  + drivers/gpio/gpio-stmpe.c: error: unknown field 'direction_output' specified in initializer:  => 125:2
  + drivers/gpio/gpio-stmpe.c: error: unknown field 'get' specified in initializer:  => 124:2
  + drivers/gpio/gpio-stmpe.c: error: unknown field 'label' specified in initializer:  => 121:2
  + drivers/gpio/gpio-stmpe.c: error: unknown field 'owner' specified in initializer:  => 122:2
  + drivers/gpio/gpio-stmpe.c: error: unknown field 'request' specified in initializer:  => 128:2
  + drivers/gpio/gpio-stmpe.c: error: unknown field 'set' specified in initializer:  => 126:2
  + drivers/gpio/gpio-stmpe.c: error: unknown field 'to_irq' specified in initializer:  => 127:2
  + drivers/gpio/gpio-stmpe.c: error: variable 'template_chip' has initializer but incomplete type:  => 120:15
  + drivers/gpio/gpio-timberdale.c: error: dereferencing pointer to incomplete type:  => 279:4, 268:4, 269:4, 271:4, 276:4, 274:4, 270:4, 275:4, 278:4, 277:4, 272:4, 273:4
  + drivers/gpio/gpio-timberdale.c: error: field 'gpio' has incomplete type:  => 48:19
  + drivers/gpio/gpio-timberdale.c: error: implicit declaration of function 'gpiochip_add' [-Werror=implicit-function-declaration]:  => 281:2
  + drivers/gpio/gpio-timberdale.c: error: implicit declaration of function 'gpiochip_remove' [-Werror=implicit-function-declaration]:  => 338:2
  + drivers/gpio/gpio-tps65912.c: error: field 'gpio_chip' has incomplete type:  => 26:19
  + drivers/gpio/gpio-tps65912.c: error: implicit declaration of function 'gpiochip_add' [-Werror=implicit-function-declaration]:  => 105:2
  + drivers/gpio/gpio-tps65912.c: error: implicit declaration of function 'gpiochip_remove' [-Werror=implicit-function-declaration]:  => 125:2
  + drivers/gpio/gpio-tps65912.c: error: unknown field 'base' specified in initializer:  => 85:2
  + drivers/gpio/gpio-tps65912.c: error: unknown field 'can_sleep' specified in initializer:  => 83:2
  + drivers/gpio/gpio-tps65912.c: error: unknown field 'direction_input' specified in initializer:  => 79:2
  + drivers/gpio/gpio-tps65912.c: error: unknown field 'direction_output' specified in initializer:  => 80:2
  + drivers/gpio/gpio-tps65912.c: error: unknown field 'get' specified in initializer:  => 81:2
  + drivers/gpio/gpio-tps65912.c: error: unknown field 'label' specified in initializer:  => 77:2
  + drivers/gpio/gpio-tps65912.c: error: unknown field 'ngpio' specified in initializer:  => 84:2
  + drivers/gpio/gpio-tps65912.c: error: unknown field 'owner' specified in initializer:  => 78:2
  + drivers/gpio/gpio-tps65912.c: error: unknown field 'set' specified in initializer:  => 82:2
  + drivers/gpio/gpio-tps65912.c: error: variable 'template_chip' has initializer but incomplete type:  => 76:15
  + drivers/gpio/gpio-ucb1400.c: error: implicit declaration of function 'gpiochip_add' [-Werror=implicit-function-declaration]:  => 71:2
  + drivers/gpio/gpio-ucb1400.c: error: implicit declaration of function 'gpiochip_remove' [-Werror=implicit-function-declaration]:  => 94:2
  + drivers/gpio/gpio-vx855.c: error: dereferencing pointer to incomplete type:  => 213:3, 218:3, 216:3, 210:3, 214:3, 215:3, 209:3, 208:3, 211:3, 217:3, 212:3
  + drivers/gpio/gpio-vx855.c: error: field 'gpio' has incomplete type:  => 51:19
  + drivers/gpio/gpio-vx855.c: error: implicit declaration of function 'gpiochip_add' [-Werror=implicit-function-declaration]:  => 269:2
  + drivers/gpio/gpio-vx855.c: error: implicit declaration of function 'gpiochip_remove' [-Werror=implicit-function-declaration]:  => 292:2
  + drivers/gpio/gpio-wm831x.c: error: dereferencing pointer to incomplete type:  => 148:22, 147:22
  + drivers/gpio/gpio-wm831x.c: error: field 'gpio_chip' has incomplete type:  => 30:19
  + drivers/gpio/gpio-wm831x.c: error: implicit declaration of function 'gpiochip_add' [-Werror=implicit-function-declaration]:  => 266:2
  + drivers/gpio/gpio-wm831x.c: error: implicit declaration of function 'gpiochip_is_requested' [-Werror=implicit-function-declaration]:  => 157:3
  + drivers/gpio/gpio-wm831x.c: error: implicit declaration of function 'gpiochip_remove' [-Werror=implicit-function-declaration]:  => 287:2
  + drivers/gpio/gpio-wm831x.c: error: unknown field 'can_sleep' specified in initializer:  => 243:2
  + drivers/gpio/gpio-wm831x.c: error: unknown field 'dbg_show' specified in initializer:  => 242:2
  + drivers/gpio/gpio-wm831x.c: error: unknown field 'direction_input' specified in initializer:  => 236:2
  + drivers/gpio/gpio-wm831x.c: error: unknown field 'direction_output' specified in initializer:  => 238:2
  + drivers/gpio/gpio-wm831x.c: error: unknown field 'get' specified in initializer:  => 237:2
  + drivers/gpio/gpio-wm831x.c: error: unknown field 'label' specified in initializer:  => 234:2
  + drivers/gpio/gpio-wm831x.c: error: unknown field 'owner' specified in initializer:  => 235:2
  + drivers/gpio/gpio-wm831x.c: error: unknown field 'set' specified in initializer:  => 239:2
  + drivers/gpio/gpio-wm831x.c: error: unknown field 'set_debounce' specified in initializer:  => 241:2
  + drivers/gpio/gpio-wm831x.c: error: unknown field 'to_irq' specified in initializer:  => 240:2
  + drivers/gpio/gpio-wm831x.c: error: variable 'template_chip' has initializer but incomplete type:  => 233:15
  + drivers/gpio/gpiolib.c: error: 'ARCH_NR_GPIOS' undeclared here (not in a function):  => 73:35
  + drivers/gpio/gpiolib.c: error: dereferencing pointer to incomplete type:  => 1078:31, 1836:12, 1835:8, 969:154, 100:23, 1225:19, 570:34, 1042:17, 1096:187, 1261:17, 1259:11, 1617:49, 1407:20, 1841:29, 1613:13, 1470:34, 1133:47, 1434:15, 962:7, 932:6, 730:16, 1842:10, 730:37, 1220:43, 1729:14, 940:14, 1811:18, 724:18, 588:34, 1533:18, 1103:122, 1069:35, 1811:31, 1133:34, 1103:105, 1595:32, 1596:14, 1668:32, 1423:16, 1470:20, 925:39, 1770:12, 1694:13, 1472:14, 1835:20, 1613:48, 1103:80, 1545:13, 1497:15, 1217:10, 579:34, 1473:18, 1638:13, 1103:92, 1438:27, 945:154, 1096:175, 1712:28, 1044:57, 1530:34, 1420:15, 736:46, 1712:54, 1483:15, 1062:34, 1747:7, 1729:49, 1371:22, 1201:26, 1058:7, 1840:10, 1488:154, 1617:13, 1596:26, 1757:22, 730:62, 1126:33, 1712:13, 1486:16, 926:23, 1096:200, 1262:32, 1675:30, 1747:30, 1133:17, 1262:8, 1532:14, 731:47, 1769:8, 1501:27, 1500:23, 1642:48, 112:11, 104:27, 1761:22, 731:22, 1096:217, 1410:18, 1729:26, 1407:34, 994:20, 1126:46, 1409:14, 1846:10, 1530:20, 1543:15, 1425:154, 1596:49, 1126:16, 1053:33, 1220:16, 1266:24, 725:19, 1638:49, 144:14, 1835:33, 1675:7, 1847:7, 1642:13, 1213:18
  + drivers/gpio/gpiolib.c: error: redefinition of 'gpio_direction_input':  => 1395:5
  + drivers/gpio/gpiolib.c: error: redefinition of 'gpio_direction_output':  => 1450:5
  + drivers/gpio/gpiolib.c: error: redefinition of 'gpio_export':  => 701:5
  + drivers/gpio/gpiolib.c: error: redefinition of 'gpio_export_link':  => 787:5
  + drivers/gpio/gpiolib.c: error: redefinition of 'gpio_free':  => 1239:6
  + drivers/gpio/gpiolib.c: error: redefinition of 'gpio_free_array':  => 1349:6
  + drivers/gpio/gpiolib.c: error: redefinition of 'gpio_get_value_cansleep':  => 1722:5
  + drivers/gpio/gpiolib.c: error: redefinition of 'gpio_request':  => 1185:5
  + drivers/gpio/gpiolib.c: error: redefinition of 'gpio_request_array':  => 1326:5
  + drivers/gpio/gpiolib.c: error: redefinition of 'gpio_request_one':  => 1284:5
  + drivers/gpio/gpiolib.c: error: redefinition of 'gpio_set_debounce':  => 1518:5
  + drivers/gpio/gpiolib.c: error: redefinition of 'gpio_set_value_cansleep':  => 1735:6
  + drivers/gpio/gpiolib.c: error: redefinition of 'gpio_sysfs_set_active_low':  => 834:5
  + drivers/gpio/gpiolib.c: error: redefinition of 'gpio_unexport':  => 874:6
  + drivers/gpu/drm/ast/ast_drv.h: error: implicit declaration of function 'read' [-Werror=implicit-function-declaration]:  => 129:106
  + drivers/gpu/drm/cirrus/cirrus_mode.c: error: implicit declaration of function 'read' [-Werror=implicit-function-declaration]:  => 86:2
  + drivers/gpu/drm/mgag200/mgag200_i2c.c: error: implicit declaration of function 'read' [-Werror=implicit-function-declaration]:  => 39:2
  + drivers/gpu/drm/mgag200/mgag200_main.c: error: implicit declaration of function 'read' [-Werror=implicit-function-declaration]:  => 107:3
  + drivers/gpu/drm/mgag200/mgag200_mode.c: error: implicit declaration of function 'read' [-Werror=implicit-function-declaration]:  => 70:3
  + drivers/gpu/drm/nouveau/nouveau_drv.h: error: implicit declaration of function 'read' [-Werror=implicit-function-declaration]:  => 1454:2
  + drivers/hwmon/i5k_amb.c: error: implicit declaration of function 'read' [-Werror=implicit-function-declaration]:  => 132:2
  + drivers/i2c/busses/i2c-i801.c: error: dereferencing pointer to incomplete type:  => 1047:27, 1011:21
  + drivers/i2c/busses/i2c-i801.c: error: implicit declaration of function 'gpiochip_find' [-Werror=implicit-function-declaration]:  => 1028:2
  + drivers/i2c/busses/i2c-ocores.c: error: implicit declaration of function 'read' [-Werror=implicit-function-declaration]:  => 91:3
  + drivers/i2c/busses/i2c-pca-platform.c: error: implicit declaration of function 'read' [-Werror=implicit-function-declaration]:  => 46:2
  + drivers/i2c/busses/i2c-xiic.c: error: implicit declaration of function 'read' [-Werror=implicit-function-declaration]:  => 184:2
  + drivers/input/keyboard/adp5588-keys.c: error: field 'gc' has incomplete type:  => 52:19
  + drivers/input/keyboard/adp5588-keys.c: error: implicit declaration of function 'gpiochip_add' [-Werror=implicit-function-declaration]:  => 204:2
  + drivers/input/keyboard/adp5588-keys.c: error: implicit declaration of function 'gpiochip_remove' [-Werror=implicit-function-declaration]:  => 245:2
  + drivers/input/keyboard/adp5589-keys.c: error: field 'gc' has incomplete type:  => 243:19
  + drivers/input/keyboard/adp5589-keys.c: error: implicit declaration of function 'gpiochip_add' [-Werror=implicit-function-declaration]:  => 529:2
  + drivers/input/keyboard/adp5589-keys.c: error: implicit declaration of function 'gpiochip_remove' [-Werror=implicit-function-declaration]:  => 571:2
  + drivers/input/touchscreen/ad7879.c: error: field 'gc' has incomplete type:  => 115:19
  + drivers/input/touchscreen/ad7879.c: error: implicit declaration of function 'gpiochip_add' [-Werror=implicit-function-declaration]:  => 462:3
  + drivers/input/touchscreen/ad7879.c: error: implicit declaration of function 'gpiochip_remove' [-Werror=implicit-function-declaration]:  => 477:3
  + drivers/leds/leds-gpio.c: error: 'of_gpio_leds_match' undeclared here (not in a function):  => 288:22
  + drivers/leds/leds-pca9532.c: error: field 'gpio' has incomplete type:  => 46:19
  + drivers/leds/leds-pca9532.c: error: implicit declaration of function 'gpiochip_add' [-Werror=implicit-function-declaration]:  => 427:3
  + drivers/leds/leds-pca9532.c: error: implicit declaration of function 'gpiochip_remove' [-Werror=implicit-function-declaration]:  => 324:3
  + drivers/leds/leds-tca6507.c: error: field 'gpio' has incomplete type:  => 179:19
  + drivers/leds/leds-tca6507.c: error: implicit declaration of function 'gpiochip_add' [-Werror=implicit-function-declaration]:  => 640:2
  + drivers/leds/leds-tca6507.c: error: implicit declaration of function 'gpiochip_remove' [-Werror=implicit-function-declaration]:  => 653:3
  + drivers/mfd/janz-cmodio.c: error: implicit declaration of function 'read' [-Werror=implicit-function-declaration]:  => 219:2
  + drivers/mfd/sm501.c: error: dereferencing pointer to incomplete type:  => 1039:7, 1036:8, 1032:8
  + drivers/mfd/sm501.c: error: field 'gpio' has incomplete type:  => 42:19
  + drivers/mfd/sm501.c: error: implicit declaration of function 'gpiochip_add' [-Werror=implicit-function-declaration]:  => 1042:2
  + drivers/mfd/sm501.c: error: implicit declaration of function 'gpiochip_remove' [-Werror=implicit-function-declaration]:  => 1089:2
  + drivers/mfd/sm501.c: error: unknown field 'direction_input' specified in initializer:  => 1011:2
  + drivers/mfd/sm501.c: error: unknown field 'direction_output' specified in initializer:  => 1012:2
  + drivers/mfd/sm501.c: error: unknown field 'get' specified in initializer:  => 1014:2
  + drivers/mfd/sm501.c: error: unknown field 'ngpio' specified in initializer:  => 1010:2
  + drivers/mfd/sm501.c: error: unknown field 'set' specified in initializer:  => 1013:2
  + drivers/mfd/sm501.c: error: variable 'gpio_chip_template' has initializer but incomplete type:  => 1009:15
  + drivers/mfd/tps65010.c: error: field 'chip' has incomplete type:  => 91:19
  + drivers/mfd/tps65010.c: error: implicit declaration of function 'gpiochip_add' [-Werror=implicit-function-declaration]:  => 654:3
  + drivers/misc/hpilo.c: error: implicit declaration of function 'read' [-Werror=implicit-function-declaration]:  => 411:2
  + drivers/misc/pch_phub.c: error: implicit declaration of function 'read' [-Werror=implicit-function-declaration]:  => 295:2
  + drivers/mmc/host/bfin_sdh.c: error: 'BYTE_BUS_8' undeclared (first use in this function):  => 387:14
  + drivers/mmc/host/bfin_sdh.c: error: 'WIDE_BUS_4' undeclared (first use in this function):  => 378:14
  + drivers/mtd/nand/atmel_nand.c: error: label 'err_ecc_ioremap' used but not defined:  => 1451:4
  + drivers/net/can/cc770/cc770_platform.c: error: implicit declaration of function 'read' [-Werror=implicit-function-declaration]:  => 68:2
  + drivers/net/can/janz-ican3.c: error: implicit declaration of function 'read' [-Werror=implicit-function-declaration]:  => 293:2
  + drivers/net/can/sja1000/kvaser_pci.c: error: implicit declaration of function 'read' [-Werror=implicit-function-declaration]:  => 121:2
  + drivers/net/can/sja1000/peak_pcmcia.c: error: implicit declaration of function 'read' [-Werror=implicit-function-declaration]:  => 187:2
  + drivers/net/can/sja1000/plx_pci.c: error: implicit declaration of function 'read' [-Werror=implicit-function-declaration]:  => 309:2
  + drivers/net/can/sja1000/sja1000_platform.c: error: implicit declaration of function 'read' [-Werror=implicit-function-declaration]:  => 41:2
  + drivers/net/can/softing/softing_fw.c: error: implicit declaration of function 'read' [-Werror=implicit-function-declaration]:  => 46:3
  + drivers/net/can/softing/softing_main.c: error: implicit declaration of function 'read' [-Werror=implicit-function-declaration]:  => 47:3
  + drivers/net/ethernet/3com/3c59x.c: error: implicit declaration of function 'read' [-Werror=implicit-function-declaration]:  => 692:31
  + drivers/net/ethernet/cisco/enic/vnic_dev.c: error: implicit declaration of function 'read' [-Werror=implicit-function-declaration]:  => 124:2
  + drivers/net/ethernet/dec/tulip/dmfe.c: error: implicit declaration of function 'read' [-Werror=implicit-function-declaration]:  => 1205:3
  + drivers/net/ethernet/dec/tulip/xircom_cb.c: error: implicit declaration of function 'read' [-Werror=implicit-function-declaration]:  => 980:2
  + drivers/net/ethernet/dlink/dl2k.c: error: implicit declaration of function 'read' [-Werror=implicit-function-declaration]:  => 385:4
  + drivers/net/ethernet/dlink/sundance.c: error: implicit declaration of function 'read' [-Werror=implicit-function-declaration]:  => 742:3
  + drivers/net/ethernet/fealnx.c: error: implicit declaration of function 'read' [-Werror=implicit-function-declaration]:  => 543:3
  + drivers/net/ethernet/icplus/ipg.c: error: implicit declaration of function 'read' [-Werror=implicit-function-declaration]:  => 206:2
  + drivers/net/ethernet/intel/e100.c: error: implicit declaration of function 'read' [-Werror=implicit-function-declaration]:  => 638:2
  + drivers/net/ethernet/micrel/ks8842.c: error: implicit declaration of function 'read' [-Werror=implicit-function-declaration]:  => 233:2
  + drivers/net/ethernet/micrel/ks8851_mll.c: error: implicit declaration of function 'read' [-Werror=implicit-function-declaration]:  => 757:3
  + drivers/net/ethernet/packetengines/yellowfin.c: error: implicit declaration of function 'read' [-Werror=implicit-function-declaration]:  => 420:4
  + drivers/net/ethernet/rdc/r6040.c: error: implicit declaration of function 'read' [-Werror=implicit-function-declaration]:  => 453:2
  + drivers/net/ethernet/realtek/8139too.c: error: implicit declaration of function 'read' [-Werror=implicit-function-declaration]:  => 744:3
  + drivers/net/ethernet/smsc/epic100.c: error: implicit declaration of function 'read' [-Werror=implicit-function-declaration]:  => 776:3
  + drivers/net/ethernet/via/via-rhine.c: error: implicit declaration of function 'read' [-Werror=implicit-function-declaration]:  => 512:3
  + drivers/net/ethernet/wiznet/w5100.c: error: implicit declaration of function 'read' [-Werror=implicit-function-declaration]:  => 122:2
  + drivers/net/fddi/skfp/drvfbi.c: error: implicit declaration of function 'read' [-Werror=implicit-function-declaration]:  => 109:2
  + drivers/net/wireless/ipw2x00/ipw2100.c: error: implicit declaration of function 'read' [-Werror=implicit-function-declaration]:  => 374:2
  + drivers/net/wireless/libertas/if_cs.c: error: implicit declaration of function 'read' [-Werror=implicit-function-declaration]:  => 111:2
  + drivers/net/wireless/orinoco/orinoco_plx.c: error: implicit declaration of function 'read' [-Werror=implicit-function-declaration]:  => 150:3
  + drivers/net/wireless/rtl818x/rtl8180/rtl8180.h: error: implicit declaration of function 'read' [-Werror=implicit-function-declaration]:  => 99:2
  + drivers/scsi/sym53c8xx_2/sym_glue.c: error: implicit declaration of function 'read' [-Werror=implicit-function-declaration]:  => 1718:2
  + drivers/scsi/sym53c8xx_2/sym_hipd.c: error: implicit declaration of function 'read' [-Werror=implicit-function-declaration]:  => 136:2
  + drivers/scsi/sym53c8xx_2/sym_nvram.c: error: implicit declaration of function 'read' [-Werror=implicit-function-declaration]:  => 276:2
  + drivers/ssb/pci.c: error: implicit declaration of function 'read' [-Werror=implicit-function-declaration]:  => 912:2
  + drivers/staging/ipack/bridges/tpci200.c: error: implicit declaration of function 'read' [-Werror=implicit-function-declaration]:  => 57:2
  + drivers/staging/rts_pstor/rtsx_chip.c: error: implicit declaration of function 'read' [-Werror=implicit-function-declaration]:  => 667:2
  + drivers/staging/vme/devices/vme_pio2.h: error: field 'gc' has incomplete type:  => 237:19
  + drivers/staging/vme/devices/vme_pio2_gpio.c: error: implicit declaration of function 'gpiochip_add' [-Werror=implicit-function-declaration]:  => 213:2
  + drivers/staging/vme/devices/vme_pio2_gpio.c: error: implicit declaration of function 'gpiochip_remove' [-Werror=implicit-function-declaration]:  => 226:2
  + drivers/tty/serial/8250/8250_pci.c: error: implicit declaration of function 'read' [-Werror=implicit-function-declaration]:  => 1026:3
  + drivers/tty/serial/max310x.c: error: field 'gpio' has incomplete type:  => 277:19
  + drivers/tty/serial/max310x.c: error: implicit declaration of function 'gpiochip_add' [-Werror=implicit-function-declaration]:  => 1181:3
  + drivers/tty/serial/max310x.c: error: implicit declaration of function 'gpiochip_remove' [-Werror=implicit-function-declaration]:  => 1223:3
  + drivers/tty/serial/pch_uart.c: error: implicit declaration of function 'read' [-Werror=implicit-function-declaration]:  => 333:4
  + drivers/tty/serial/timbuart.c: error: implicit declaration of function 'read' [-Werror=implicit-function-declaration]:  => 84:3
  + drivers/uio/uio_aec.c: error: implicit declaration of function 'read' [-Werror=implicit-function-declaration]:  => 57:2
  + drivers/uio/uio_cif.c: error: implicit declaration of function 'read' [-Werror=implicit-function-declaration]:  => 34:2
  + drivers/usb/chipidea/core.c: error: implicit declaration of function 'read' [-Werror=implicit-function-declaration]:  => 184:2
  + drivers/video/gbefb.c: error: implicit declaration of function 'devm_ioremap' [-Werror=implicit-function-declaration]:  => 1159:16
  + drivers/video/gbefb.c: error: implicit declaration of function 'devm_ioremap_nocache' [-Werror=implicit-function-declaration]:  => 1179:3
  + drivers/video/mbx/mbxfb.c: error: implicit declaration of function 'devm_ioremap_nocache' [-Werror=implicit-function-declaration]:  => 942:2
  + drivers/virtio/virtio_pci.c: error: implicit declaration of function 'read' [-Werror=implicit-function-declaration]:  => 143:3
  + drivers/vme/bridges/vme_ca91cx42.c: error: implicit declaration of function 'read' [-Werror=implicit-function-declaration]:  => 880:3
  + drivers/vme/bridges/vme_tsi148.c: error: implicit declaration of function 'read' [-Werror=implicit-function-declaration]:  => 237:4
  + error: "__ashrdi3" [drivers/usb/gadget/g_file_storage.ko] undefined!:  => N/A
  + error: iphase.c: relocation truncated to fit: R_PPC64_REL24 against symbol `._mcount' defined in .text section in arch/powerpc/kernel/entry_64.o:  => (.text+0x1ff9da8), (.text+0x1ffa0c0), (.text+0x1ff94a8)
  + error: iphase.c: relocation truncated to fit: R_PPC64_REL24 against symbol `.eeh_check_failure' defined in .text section in arch/powerpc/platforms/built-in.o:  => (.text+0x1ffa3b8)
  + error: iphase.c: relocation truncated to fit: R_PPC64_REL24 against symbol `.printk' defined in .text.unlikely section in kernel/built-in.o:  => (.text+0x1ffa688), (.text+0x1ffa590), (.text+0x1ffa6c8), (.text+0x1ffa53c), (.text+0x1ffa640), (.text+0x1ffa604)
  + include/linux/basic_mmio_gpio.h: error: field 'gc' has incomplete type:  => 29:19
  + include/linux/cb710.h: error: implicit declaration of function 'read' [-Werror=implicit-function-declaration]:  => 75:347
  + include/linux/math64.h: error: '__LINUX_ARM_ARCH__' undeclared (first use in this function):  => 55:15
  + include/linux/mfd/tps65912.h: error: field 'gpio' has incomplete type:  => 301:19
  + include/linux/spi/max7301.h: error: field 'chip' has incomplete type:  => 15:19
  + include/linux/ucb1400.h: error: field 'gc' has incomplete type:  => 93:19
  + kernel/sys.c: error: 'mmap_min_addr' undeclared (first use in this function): 1868:34 => 1868:2, 1868:34
  + net/core/pktgen.c: error: 'asm' operand has impossible constraints:  => 682:2775, 682:3153
  + net/core/pktgen.c: error: can't find a register in class 'GENERAL_REGS' while reloading 'asm':  => 682:2775, 682:3153
  + sound/pci/intel8x0.c: error: implicit declaration of function 'read' [-Werror=implicit-function-declaration]:  => 468:2
  + sound/pci/intel8x0m.c: error: implicit declaration of function 'read' [-Werror=implicit-function-declaration]:  => 253:2
  + sound/soc/codecs/wm5100.c: error: field 'gpio_chip' has incomplete type:  => 82:19
  + sound/soc/codecs/wm5100.c: error: implicit declaration of function 'gpiochip_add' [-Werror=implicit-function-declaration]:  => 2299:2
  + sound/soc/codecs/wm5100.c: error: implicit declaration of function 'gpiochip_remove' [-Werror=implicit-function-declaration]:  => 2309:2
  + sound/soc/codecs/wm5100.c: error: unknown field 'can_sleep' specified in initializer:  => 2282:2
  + sound/soc/codecs/wm5100.c: error: unknown field 'direction_input' specified in initializer:  => 2280:2
  + sound/soc/codecs/wm5100.c: error: unknown field 'direction_output' specified in initializer:  => 2278:2
  + sound/soc/codecs/wm5100.c: error: unknown field 'get' specified in initializer:  => 2281:2
  + sound/soc/codecs/wm5100.c: error: unknown field 'label' specified in initializer:  => 2276:2
  + sound/soc/codecs/wm5100.c: error: unknown field 'owner' specified in initializer:  => 2277:2
  + sound/soc/codecs/wm5100.c: error: unknown field 'set' specified in initializer:  => 2279:2
  + sound/soc/codecs/wm5100.c: error: variable 'wm5100_template_chip' has initializer but incomplete type:  => 2275:15
  + sound/soc/codecs/wm8903.c: error: field 'gpio_chip' has incomplete type:  => 142:19
  + sound/soc/codecs/wm8903.c: error: implicit declaration of function 'gpiochip_add' [-Werror=implicit-function-declaration]:  => 1872:2
  + sound/soc/codecs/wm8903.c: error: implicit declaration of function 'gpiochip_remove' [-Werror=implicit-function-declaration]:  => 1881:2
  + sound/soc/codecs/wm8903.c: error: unknown field 'can_sleep' specified in initializer:  => 1855:2
  + sound/soc/codecs/wm8903.c: error: unknown field 'direction_input' specified in initializer:  => 1851:2
  + sound/soc/codecs/wm8903.c: error: unknown field 'direction_output' specified in initializer:  => 1853:2
  + sound/soc/codecs/wm8903.c: error: unknown field 'get' specified in initializer:  => 1852:2
  + sound/soc/codecs/wm8903.c: error: unknown field 'label' specified in initializer:  => 1848:2
  + sound/soc/codecs/wm8903.c: error: unknown field 'owner' specified in initializer:  => 1849:2
  + sound/soc/codecs/wm8903.c: error: unknown field 'request' specified in initializer:  => 1850:2
  + sound/soc/codecs/wm8903.c: error: unknown field 'set' specified in initializer:  => 1854:2
  + sound/soc/codecs/wm8903.c: error: variable 'wm8903_template_chip' has initializer but incomplete type:  => 1847:15
  + sound/soc/codecs/wm8962.c: error: field 'gpio_chip' has incomplete type:  => 83:19
  + sound/soc/codecs/wm8962.c: error: implicit declaration of function 'gpiochip_add' [-Werror=implicit-function-declaration]:  => 3352:2
  + sound/soc/codecs/wm8962.c: error: implicit declaration of function 'gpiochip_remove' [-Werror=implicit-function-declaration]:  => 3362:2
  + sound/soc/codecs/wm8962.c: error: unknown field 'can_sleep' specified in initializer:  => 3334:2
  + sound/soc/codecs/wm8962.c: error: unknown field 'direction_output' specified in initializer:  => 3332:2
  + sound/soc/codecs/wm8962.c: error: unknown field 'label' specified in initializer:  => 3329:2
  + sound/soc/codecs/wm8962.c: error: unknown field 'owner' specified in initializer:  => 3330:2
  + sound/soc/codecs/wm8962.c: error: unknown field 'request' specified in initializer:  => 3331:2
  + sound/soc/codecs/wm8962.c: error: unknown field 'set' specified in initializer:  => 3333:2
  + sound/soc/codecs/wm8962.c: error: variable 'wm8962_template_chip' has initializer but incomplete type:  => 3328:15
  + sound/soc/codecs/wm8996.c: error: field 'gpio_chip' has incomplete type:  => 96:19
  + sound/soc/codecs/wm8996.c: error: implicit declaration of function 'gpiochip_add' [-Werror=implicit-function-declaration]:  => 2214:2
  + sound/soc/codecs/wm8996.c: error: implicit declaration of function 'gpiochip_remove' [-Werror=implicit-function-declaration]:  => 2223:2
  + sound/soc/codecs/wm8996.c: error: unknown field 'can_sleep' specified in initializer:  => 2198:2
  + sound/soc/codecs/wm8996.c: error: unknown field 'direction_input' specified in initializer:  => 2196:2
  + sound/soc/codecs/wm8996.c: error: unknown field 'direction_output' specified in initializer:  => 2194:2
  + sound/soc/codecs/wm8996.c: error: unknown field 'get' specified in initializer:  => 2197:2
  + sound/soc/codecs/wm8996.c: error: unknown field 'label' specified in initializer:  => 2192:2
  + sound/soc/codecs/wm8996.c: error: unknown field 'owner' specified in initializer:  => 2193:2
  + sound/soc/codecs/wm8996.c: error: unknown field 'set' specified in initializer:  => 2195:2
  + sound/soc/codecs/wm8996.c: error: variable 'wm8996_template_chip' has initializer but incomplete type:  => 2191:15
  + sound/soc/omap/mcbsp.c: error: 'struct omap_mcbsp_platform_data' has no member named 'mux_signal':  => 793:21, 769:19

861 improvements:
  - arch/x86/include/asm/uaccess_32.h: error: call to 'copy_from_user_overflow' declared with attribute error: copy_from_user() buffer size is not provably correct: 211:26 => 
  - arch/xtensa/kernel/pci.c: error: '_PAGE_NO_CACHE' undeclared (first use in this function): 344:11 => 
  - error: No rule to make target drivers/scsi/aic7xxx/aicasm/*.[chyl]: N/A => 
  - error: arch/xtensa/platforms/iss/built-in.o: undefined reference to `__netdev_alloc_skb': .text+0x60) => 
  - error: arch/xtensa/platforms/iss/built-in.o: undefined reference to `__netif_schedule': .text+0x48) => 
  - error: arch/xtensa/platforms/iss/built-in.o: undefined reference to `alloc_etherdev_mqs': .text+0x11c) => 
  - error: arch/xtensa/platforms/iss/built-in.o: undefined reference to `consume_skb': .text+0x4c) => 
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
  - error: eni.c: relocation truncated to fit: R_PPC64_REL24 against symbol `._raw_read_lock' defined in .spinlock.text section in kernel/built-in.o: (.text+0x1ff91bc) => 
  - error: eni.c: relocation truncated to fit: R_PPC64_REL24 against symbol `.sprintf' defined in .text section in lib/lib.a(vsprintf.o): (.text+0x1ff940c) => 
  - error: eni.c: relocation truncated to fit: R_PPC64_REL24 against symbol `_restgpr0_16' defined in .text.save.restore section in arch/powerpc/lib/built-in.o: (.text+0x1ffa6e8) => 
  - error: eni.c: relocation truncated to fit: R_PPC64_REL24 against symbol `_savegpr0_27' defined in .text.save.restore section in arch/powerpc/lib/built-in.o: (.text+0x1ff9854) => 
  - error: eni.c: relocation truncated to fit: R_PPC64_REL24 against symbol `_savegpr0_30' defined in .text.save.restore section in arch/powerpc/lib/built-in.o: (.text+0x1ff8eb4), (.text+0x1ff8e80) => 
  - error: fore200e.c: relocation truncated to fit: R_PPC64_REL24 against symbol `._raw_spin_unlock_irqrestore' defined in .spinlock.text section in kernel/built-in.o: (.text+0x1ff82cc), (.text+0x1ff8278) => 
  - error: fore200e.c: relocation truncated to fit: R_PPC64_REL24 against symbol `.mutex_unlock' defined in .sched.text section in kernel/built-in.o: (.text+0x1ff83fc), (.text+0x1ff83a8) => 
  - error: network.c: undefined reference to `__netdev_alloc_skb': .text+0x4cc) => 
  - error: network.c: undefined reference to `__netif_schedule': .text+0x3d7) => 
  - error: network.c: undefined reference to `alloc_etherdev_mqs': .text+0x8c8) => 
  - error: network.c: undefined reference to `consume_skb': .text+0x42e) => 
  - error: network.c: undefined reference to `dev_close': .text+0x683) => 
  - error: network.c: undefined reference to `eth_type_trans': .text+0x7db) => 
  - error: network.c: undefined reference to `free_netdev': .text+0xaca) => 
  - error: network.c: undefined reference to `kfree_skb': .text+0x54c) => 
  - error: network.c: undefined reference to `netif_rx_ni': .text+0x542) => 
  - error: network.c: undefined reference to `register_netdevice': .text+0xaaf) => 
  - error: network.c: undefined reference to `rtnl_lock': .text+0xaa7) => 
  - error: network.c: undefined reference to `rtnl_unlock': .text+0xab7) => 
  - error: network.c: undefined reference to `skb_put': .text+0x50b) => 
  - error: network.c: undefined reference to `skb_trim': .text+0x518) => 
  - error: via-pmu-event.c: undefined reference to `.input_allocate_device': .init.text+0xdfbc) => 
  - error: via-pmu-event.c: undefined reference to `.input_free_device': .init.text+0xe084) => 
  - error: via-pmu-event.c: undefined reference to `.input_register_device': .init.text+0xe06c) => 
  - error: vsprintf.c: relocation truncated to fit: R_AVR32_9UW_PCREL against `.text'+b28: (.text+0x92a) => 
  - include/linux/gpio.h: error: redefinition of 'gpio_cansleep': 60:90 => 
  - net/core/sock.c: error: (near initialization for 'memalloc_socks'): 274:45 => 
  - net/core/sock.c: error: initializer element is not constant: 274:45 => 


*** WARNINGS ***

1206 regressions:
  + .config: warning: override: SPARSEMEM_MANUAL changes choice state:  => 365
  + arch/arm/common/it8152.c: warning: assignment makes integer from pointer without a cast [enabled by default]:  => 288:16, 291:17, 287:18
  + arch/arm/include/asm/atomic.h: warning: "__LINUX_ARM_ARCH__" is not defined [-Wundef]:  => 32:5
  + arch/arm/include/asm/barrier.h: warning: "__LINUX_ARM_ARCH__" is not defined [-Wundef]:  => 16:5, 9:5, 20:35, 10:3
  + arch/arm/include/asm/bitops.h: warning: "__LINUX_ARM_ARCH__" is not defined [-Wundef]:  => 217:5
  + arch/arm/include/asm/cacheflush.h: warning: "__LINUX_ARM_ARCH__" is not defined [-Wundef]:  => 194:7, 196:7
  + arch/arm/include/asm/cachetype.h: warning: "__LINUX_ARM_ARCH__" is not defined [-Wundef]:  => 28:5, 33:7
  + arch/arm/include/asm/cmpxchg.h: warning: "__LINUX_ARM_ARCH__" is not defined [-Wundef]:  => 108:5, 40:5, 33:5
  + arch/arm/include/asm/dma-mapping.h: warning: passing argument 1 of '__virt_to_phys' makes integer from pointer without a cast [enabled by default]:  => 85:2
  + arch/arm/include/asm/fpstate.h: warning: "__LINUX_ARM_ARCH__" is not defined [-Wundef]:  => 32:5
  + arch/arm/include/asm/irqflags.h: warning: "__LINUX_ARM_ARCH__" is not defined [-Wundef]:  => 11:5
  + arch/arm/include/asm/mc146818rtc.h: warning: "RTC_IRQ" redefined [enabled by default]:  => 10:0
  + arch/arm/include/asm/processor.h: warning: "__LINUX_ARM_ARCH__" is not defined [-Wundef]:  => 82:5, 102:5
  + arch/arm/include/asm/swab.h: warning: "__LINUX_ARM_ARCH__" is not defined [-Wundef]:  => 46:29, 26:5
  + arch/arm/kernel/entry-armv.S: warning: #warning "NPTL on non MMU needs fixing" [-Wcpp]:  => 940:2, 867:2, 404:2
  + arch/arm/kernel/return_address.c: warning: #warning "TODO: return_address should use unwind tables" [-Wcpp]:  => 62:2
  + arch/arm/kernel/setup.c: warning: large integer implicitly truncated to unsigned type [-Woverflow]:  => 791:2
  + arch/arm/mach-at91/pm.c: warning: unused variable 'i' [-Wunused-variable]:  => 138:6
  + arch/arm/mach-at91/pm.h: warning: #warning Assuming EB1 SDRAM controller is *NOT* used [-Wcpp]:  => 78:2
  + arch/arm/mach-at91/setup.c: warning: 'at91_io_desc' defined but not used [-Wunused-variable]:  => 90:24
  + arch/arm/mach-iop13xx/iq81340sc.c: warning: (near initialization for 'iq81340sc_pci.map_irq') [enabled by default]:  => 62:2
  + arch/arm/mach-iop13xx/iq81340sc.c: warning: initialization from incompatible pointer type [enabled by default]:  => 62:2
  + arch/arm/mach-pnx4008/clock.c: warning: format '%ld' expects argument of type 'long int', but argument 4 has type 'u32' [-Wformat]:  => 983:3
  + arch/arm/mach-pxa/include/mach/mfp-pxa27x.h: warning: "GPIO24_SSP1_SFRM" redefined [enabled by default]:  => 216:0
  + arch/arm/mach-pxa/palmte2.c: warning: 'palmte2_pxa_keys' defined but not used [-Wunused-variable]:  => 128:31
  + arch/arm/mach-pxa/sharpsl_pm.c: warning: 'sharpsl_fatal_check' defined but not used [-Wunused-function]:  => 693:12
  + arch/arm/mach-pxa/viper.c: warning: ignoring return value of 'kstrtoul', declared with attribute warn_unused_result [-Wunused-result]:  => 771:10
  + arch/arm/mach-rpc/ecard.c: warning: ignoring return value of 'device_register', declared with attribute warn_unused_result [-Wunused-result]:  => 963:17
  + arch/arm/mach-sa1100/assabet.c: warning: 'scr' may be used uninitialized in this function [-Wuninitialized]:  => 399:6
  + arch/arm/mach-sa1100/lart.c: warning: #warning "include/asm/arch-sa1100/ide.h needs fixing for lart" [-Wcpp]:  => 28:2
  + arch/arm/mach-shark/pci.c: warning: 'return' with no value, in function returning non-void [-Wreturn-type]:  => 44:3
  + arch/arm/mach-ux500/board-mop500.c: warning: 'snowball_of_platform_devs' defined but not used [-Wunused-variable]:  => 729:32
  + arch/arm/mach-ux500/cpu-db8500.c: warning: (near initialization for 'db8500_pmu_platdata') [enabled by default]:  => 119:2
  + arch/arm/mach-ux500/cpu-db8500.c: warning: excess elements in struct initializer [enabled by default]:  => 119:2
  + arch/arm/mm/dma-mapping.c: warning: 'page' may be used uninitialized in this function [-Wuninitialized]:  => 626:122
  + arch/blackfin/mach-common/ints-priority.c: warning: 'save_pint_sec_ctl' defined but not used [-Wunused-variable]:  => 1108:12
  + arch/mn10300/mm/dma-alloc.c: warning: format '%zu' expects argument of type 'size_t', but argument 3 has type 'unsigned int' [-Wformat]:  => 29:2
  + arch/tile/kernel/module.c: warning: "ELF_R_SYM" redefined [enabled by default]:  => 29:0
  + arch/tile/kernel/module.c: warning: "ELF_R_TYPE" redefined [enabled by default]:  => 30:0
  + arch/x86/kernel/apm_32.c: warning: #warning deprecated CONFIG_APM_CPU_IDLE will be deleted in 2012 [-Wcpp]:  => 363:2
  + arch/x86/kvm/pmu.c: warning: 'config' may be used uninitialized in this function [-Wuninitialized]:  => 239:19
  + arch/x86/kvm/vmx.c: warning: 'save' may be used uninitialized in this function [-Wuninitialized]:  => 3134:6
  + arch/x86/kvm/x86.c: warning: 'exchanged' may be used uninitialized in this function [-Wuninitialized]:  => 3971:29
  + block/blk-merge.c: warning: 'bbio' may be used uninitialized in this function [-Wuninitialized]:  => 65:44
  + block/bsg.c: warning: 'rw' may be used uninitialized in this function [-Wuninitialized]:  => 273:5
  + drivers/acpi/acpica/exprep.c: warning: 'byte_alignment' may be used uninitialized in this function [-Wuninitialized]:  => 377:46
  + drivers/acpi/scan.c: warning: 'type' may be used uninitialized in this function [-Wuninitialized]:  => 1435:25
  + drivers/ata/pata_atiixp.c: warning: 'wanted_pio' may be used uninitialized in this function [-Wuninitialized]:  => 196:24
  + drivers/base/firmware_class.c: warning: 'device_cache_fw_images' defined but not used [-Wunused-function]:  => 1147:13
  + drivers/base/firmware_class.c: warning: 'device_cache_fw_images' defined but not used:  => 1148
  + drivers/base/firmware_class.c: warning: 'device_uncache_fw_images_delay' defined but not used [-Wunused-function]:  => 1212:13
  + drivers/base/firmware_class.c: warning: 'device_uncache_fw_images_delay' defined but not used:  => 1213
  + drivers/base/power/domain.c: warning: 'genpd_start_dev_no_timing' defined but not used [-Wunused-function]:  => 96:12
  + drivers/base/regmap/regmap.c: warning: 'ret' may be used uninitialized in this function [-Wuninitialized]: 1172:6 => 1353:9, 1167:6
  + drivers/block/cciss.c: warning: 'sn[0]' may be used uninitialized in this function [-Wuninitialized]:  => 677:18
  + drivers/block/cciss.c: warning: 'sn[10]' may be used uninitialized in this function [-Wuninitialized]:  => 677:18
  + drivers/block/cciss.c: warning: 'sn[11]' may be used uninitialized in this function [-Wuninitialized]:  => 677:18
  + drivers/block/cciss.c: warning: 'sn[12]' may be used uninitialized in this function [-Wuninitialized]:  => 677:18
  + drivers/block/cciss.c: warning: 'sn[13]' may be used uninitialized in this function [-Wuninitialized]:  => 677:18
  + drivers/block/cciss.c: warning: 'sn[14]' may be used uninitialized in this function [-Wuninitialized]:  => 677:18
  + drivers/block/cciss.c: warning: 'sn[15]' may be used uninitialized in this function [-Wuninitialized]:  => 677:18
  + drivers/block/cciss.c: warning: 'sn[1]' may be used uninitialized in this function [-Wuninitialized]:  => 677:18
  + drivers/block/cciss.c: warning: 'sn[2]' may be used uninitialized in this function [-Wuninitialized]:  => 677:18
  + drivers/block/cciss.c: warning: 'sn[3]' may be used uninitialized in this function [-Wuninitialized]:  => 677:18
  + drivers/block/cciss.c: warning: 'sn[4]' may be used uninitialized in this function [-Wuninitialized]:  => 677:18
  + drivers/block/cciss.c: warning: 'sn[5]' may be used uninitialized in this function [-Wuninitialized]:  => 677:18
  + drivers/block/cciss.c: warning: 'sn[6]' may be used uninitialized in this function [-Wuninitialized]:  => 677:18
  + drivers/block/cciss.c: warning: 'sn[7]' may be used uninitialized in this function [-Wuninitialized]:  => 677:18
  + drivers/block/cciss.c: warning: 'sn[8]' may be used uninitialized in this function [-Wuninitialized]:  => 677:18
  + drivers/block/cciss.c: warning: 'sn[9]' may be used uninitialized in this function [-Wuninitialized]:  => 677:18
  + drivers/block/floppy.c: warning: 'size' may be used uninitialized in this function [-Wuninitialized]:  => 3484:111
  + drivers/block/mtip32xx/mtip32xx.c: warning: the frame size of 1032 bytes is larger than 1024 bytes [-Wframe-larger-than=]:  => 2677:1
  + drivers/block/mtip32xx/mtip32xx.c: warning: the frame size of 1036 bytes is larger than 1024 bytes [-Wframe-larger-than=]:  => 2651:1
  + drivers/bluetooth/btwilink.c: warning: overflow in implicit constant conversion [-Woverflow]:  => 179:3
  + drivers/char/ds1620.c: warning: passing argument 1 of 'spin_unlock_irqrestore' from incompatible pointer type [enabled by default]:  => 91:2, 82:2
  + drivers/char/ds1620.c: warning: passing argument 1 of 'spinlock_check' from incompatible pointer type [enabled by default]:  => 89:2, 77:2
  + drivers/char/nwflash.c: warning: passing argument 1 of 'spin_unlock_irqrestore' from incompatible pointer type [enabled by default]:  => 588:2
  + drivers/char/nwflash.c: warning: passing argument 1 of 'spinlock_check' from incompatible pointer type [enabled by default]:  => 586:2
  + drivers/char/tpm/tpm_atmel.c: warning: 'base' may be used uninitialized in this function [-Wuninitialized]:  => 225:19
  + drivers/dma/ioat/dma_v2.c: warning: unused variable 'chanerr' [-Wunused-variable]:  => 558:7
  + drivers/gpio/gpio-74x164.c: warning: initialization from incompatible pointer type [enabled by default]:  => 29:79
  + drivers/gpio/gpio-adp5588.c: warning: (near initialization for 'dev') [enabled by default]:  => 80:73, 119:73, 101:73, 69:73
  + drivers/gpio/gpio-adp5588.c: warning: initialization from incompatible pointer type [enabled by default]:  => 80:73, 119:73, 101:73, 69:73
  + drivers/gpio/gpio-amd8111.c: warning: (near initialization for 'agp') [enabled by default]:  => 103:83, 82:83, 94:83, 118:83, 130:83, 147:83
  + drivers/gpio/gpio-amd8111.c: warning: initialization from incompatible pointer type [enabled by default]:  => 103:83, 82:83, 94:83, 118:83, 130:83, 147:83
  + drivers/gpio/gpio-arizona.c: warning: (near initialization for 'template_chip') [enabled by default]:  => 91:2, 89:2, 92:2, 93:2, 88:2, 90:2, 94:2
  + drivers/gpio/gpio-arizona.c: warning: control reaches end of non-void function [-Wreturn-type]:  => 149:1
  + drivers/gpio/gpio-arizona.c: warning: excess elements in struct initializer [enabled by default]:  => 91:2, 89:2, 92:2, 93:2, 88:2, 90:2, 94:2
  + drivers/gpio/gpio-arizona.c: warning: initialization from incompatible pointer type [enabled by default]:  => 33:76
  + drivers/gpio/gpio-max730x.c: warning: (near initialization for 'ts') [enabled by default]:  => 123:80, 151:80, 95:80, 53:80
  + drivers/gpio/gpio-max730x.c: warning: initialization from incompatible pointer type [enabled by default]:  => 123:80, 151:80, 95:80, 53:80
  + drivers/gpio/gpio-max732x.c: warning: initialization from incompatible pointer type [enabled by default]:  => 202:76, 227:76, 251:76, 187:76
  + drivers/gpio/gpio-mc33880.c: warning: (near initialization for 'mc') [enabled by default]:  => 74:80
  + drivers/gpio/gpio-mc33880.c: warning: initialization from incompatible pointer type [enabled by default]:  => 74:80
  + drivers/gpio/gpio-mc33880.c: warning: left-hand operand of comma expression has no effect [-Wunused-value]:  => 114:28
  + drivers/gpio/gpio-mcp23s08.c: warning: (near initialization for 'mcp') [enabled by default]:  => 260:83, 291:83, 248:83, 302:83
  + drivers/gpio/gpio-mcp23s08.c: warning: assignment makes pointer from integer without a cast [enabled by default]:  => 348:9
  + drivers/gpio/gpio-mcp23s08.c: warning: initialization from incompatible pointer type [enabled by default]:  => 333:66, 260:83, 291:83, 248:83, 302:83
  + drivers/gpio/gpio-ml-ioh.c: warning: (near initialization for 'chip') [enabled by default]:  => 133:84, 228:84, 125:84, 109:84, 158:84
  + drivers/gpio/gpio-ml-ioh.c: warning: initialization from incompatible pointer type [enabled by default]:  => 133:84, 228:84, 125:84, 109:84, 158:84
  + drivers/gpio/gpio-pca953x.c: warning: initialization from incompatible pointer type [enabled by default]:  => 248:76, 198:76, 278:76, 167:76
  + drivers/gpio/gpio-pcf857x.c: warning: (near initialization for 'gpio') [enabled by default]:  => 165:82, 119:82, 141:82, 132:82
  + drivers/gpio/gpio-pcf857x.c: warning: assignment makes pointer from integer without a cast [enabled by default]:  => 230:19
  + drivers/gpio/gpio-pcf857x.c: warning: initialization from incompatible pointer type [enabled by default]:  => 165:82, 119:82, 141:82, 132:82
  + drivers/gpio/gpio-rdc321x.c: warning: initialization from incompatible pointer type [enabled by default]:  => 50:71, 86:71, 68:71, 99:71
  + drivers/gpio/gpio-stmpe.c: warning: (near initialization for 'template_chip') [enabled by default]:  => 126:2, 128:2, 125:2, 121:2, 129:2, 122:20, 127:2, 124:2, 123:2
  + drivers/gpio/gpio-stmpe.c: warning: excess elements in struct initializer [enabled by default]:  => 126:2, 128:2, 125:2, 121:2, 129:2, 122:20, 127:2, 124:2, 123:2
  + drivers/gpio/gpio-stmpe.c: warning: initialization from incompatible pointer type [enabled by default]:  => 42:69
  + drivers/gpio/gpio-timberdale.c: warning: (near initialization for 'tgpio') [enabled by default]:  => 101:85, 80:85, 56:85
  + drivers/gpio/gpio-timberdale.c: warning: initialization from incompatible pointer type [enabled by default]:  => 101:85, 80:85, 56:85
  + drivers/gpio/gpio-tps65912.c: warning: (near initialization for 'template_chip') [enabled by default]:  => 82:2, 85:2, 78:2, 80:2, 81:2, 84:2, 79:2, 83:2, 77:2
  + drivers/gpio/gpio-tps65912.c: warning: (near initialization for 'tps65912') [enabled by default]:  => 45:88, 69:88, 58:88, 31:88
  + drivers/gpio/gpio-tps65912.c: warning: excess elements in struct initializer [enabled by default]:  => 82:2, 85:2, 78:2, 80:2, 81:2, 84:2, 79:2, 83:2, 77:2
  + drivers/gpio/gpio-tps65912.c: warning: initialization from incompatible pointer type [enabled by default]:  => 45:88, 69:88, 58:88, 31:88
  + drivers/gpio/gpio-ucb1400.c: warning: initialization from incompatible pointer type [enabled by default]:  => 37:69, 20:69, 44:69, 28:69
  + drivers/gpio/gpio-vx855.c: warning: (near initialization for 'vg') [enabled by default]:  => 125:86, 101:86, 151:86
  + drivers/gpio/gpio-vx855.c: warning: initialization from incompatible pointer type [enabled by default]:  => 125:86, 101:86, 151:86
  + drivers/gpio/gpio-wm831x.c: warning: (near initialization for 'template_chip') [enabled by default]:  => 240:2, 235:2, 234:2, 241:2, 236:2, 239:2, 238:2, 237:2, 243:2, 242:2
  + drivers/gpio/gpio-wm831x.c: warning: assignment makes pointer from integer without a cast [enabled by default]:  => 157:9
  + drivers/gpio/gpio-wm831x.c: warning: excess elements in struct initializer [enabled by default]:  => 240:2, 235:2, 234:2, 241:2, 236:2, 239:2, 238:2, 237:2, 243:2, 242:2
  + drivers/gpio/gpio-wm831x.c: warning: initialization from incompatible pointer type [enabled by default]:  => 35:75
  + drivers/gpio/gpiolib.c: warning: 'gpio_desc' defined but not used [-Wunused-variable]:  => 73:25
  + drivers/gpio/gpiolib.c: warning: control reaches end of non-void function [-Wreturn-type]:  => 1382:1, 580:1, 1695:1, 571:1, 122:1, 589:1, 1713:1
  + drivers/gpu/drm/drm_info.c: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]:  => 241:19
  + drivers/gpu/vga/vgaarb.c: warning: 'devfn' may be used uninitialized in this function [-Wuninitialized]:  => 1096:9
  + drivers/i2c/busses/i2c-bfin-twi.c: warning: 'i2c_bfin_twi_resume' defined but not used [-Wunused-function]:  => 593:12
  + drivers/i2c/busses/i2c-bfin-twi.c: warning: 'i2c_bfin_twi_suspend' defined but not used [-Wunused-function]:  => 578:12
  + drivers/i2c/busses/i2c-i801.c: warning: assignment makes pointer from integer without a cast [enabled by default]:  => 1028:7
  + drivers/i2c/busses/i2c-i801.c: warning: control reaches end of non-void function [-Wreturn-type]:  => 1012:1
  + drivers/i2c/busses/i2c-mpc.c: warning: 'mpc_i2c_resume' defined but not used [-Wunused-function]:  => 720:12
  + drivers/i2c/busses/i2c-mpc.c: warning: 'mpc_i2c_suspend' defined but not used [-Wunused-function]:  => 710:12
  + drivers/infiniband/hw/cxgb4/device.c: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]:  => 413:2
  + drivers/infiniband/hw/mlx4/qp.c: warning: 'vlan' may be used uninitialized in this function [-Wuninitialized]: 1498:31, 1498:30 => 1498:31, 1498:30, 1498:62
  + drivers/input/keyboard/adp5588-keys.c: warning: (near initialization for 'kpad') [enabled by default]:  => 87:90, 77:90, 106:90, 124:90
  + drivers/input/keyboard/adp5588-keys.c: warning: initialization from incompatible pointer type [enabled by default]:  => 87:90, 77:90, 106:90, 124:90
  + drivers/input/keyboard/adp5589-keys.c: warning: (near initialization for 'kpad') [enabled by default]:  => 403:90, 442:90, 391:90, 422:90
  + drivers/input/keyboard/adp5589-keys.c: warning: initialization from incompatible pointer type [enabled by default]:  => 403:90, 442:90, 391:90, 422:90
  + drivers/input/keyboard/gpio_keys_polled.c: warning: 'flags' may be used uninitialized in this function [-Wuninitialized]:  => 149:22
  + drivers/input/misc/rotary_encoder.c: warning: 'flags' may be used uninitialized in this function [-Wuninitialized]:  => 173:28
  + drivers/input/touchscreen/ad7879.c: warning: (near initialization for 'ts') [enabled by default]:  => 431:76, 385:76, 418:76, 399:76
  + drivers/input/touchscreen/ad7879.c: warning: initialization from incompatible pointer type [enabled by default]:  => 431:76, 385:76, 418:76, 399:76
  + drivers/isdn/sc/init.c: warning: return from incompatible pointer type [enabled by default]: 37:111, 36:111 => 37:111, 36:1, 37:1, 36:111
  + drivers/leds/leds-ot200.c: warning: 'val' may be used uninitialized in this function [-Wuninitialized]: 112:8 => 112:8, 114:7
  + drivers/leds/leds-pca9532.c: warning: (near initialization for 'data') [enabled by default]:  => 259:92, 272:92, 248:92
  + drivers/leds/leds-pca9532.c: warning: initialization from incompatible pointer type [enabled by default]:  => 259:92, 272:92, 248:92
  + drivers/leds/leds-tca6507.c: warning: (near initialization for 'tca') [enabled by default]:  => 591:91
  + drivers/leds/leds-tca6507.c: warning: initialization from incompatible pointer type [enabled by default]:  => 591:91
  + drivers/media/dvb-frontends/drxk_hard.c: warning: 'status' may be used uninitialized in this function [-Wuninitialized]:  => 5467:5
  + drivers/media/dvb-frontends/mb86a20s.h: warning: 'mb86a20s_get_tuner_i2c_adapter' defined but not used [-Wunused-function]:  => 45:2
  + drivers/media/pci/bt8xx/bt878.c: warning: passing argument 1 of 'iounmap' discards 'volatile' qualifier from pointer target type [enabled by default]:  => 556:3
  + drivers/media/pci/ivtv/ivtv-driver.c: warning: passing argument 1 of 'iounmap' discards 'volatile' qualifier from pointer target type [enabled by default]:  => 368:3, 361:3, 355:3
  + drivers/media/radio/wl128x/fmdrv_common.c: warning: large integer implicitly truncated to unsigned type [-Woverflow]:  => 1512:3
  + drivers/media/rc/rc-main.c: warning: 'mask' may be used uninitialized in this function [-Wuninitialized]:  => 891:9
  + drivers/media/rc/rc-main.c: warning: 'type' may be used uninitialized in this function [-Wuninitialized]:  => 891:9
  + drivers/media/usb/dvb-usb-v2/dvb_usb_core.c: warning: 'ret' may be used uninitialized in this function [-Wuninitialized]:  => 290:12
  + drivers/media/usb/uvc/uvc_video.c: warning: format '%lu' expects argument of type 'long unsigned int', but argument 9 has type '__kernel_suseconds_t' [-Wformat]:  => 678:2
  + drivers/message/fusion/mptbase.c: warning: 'seq_mpt_print_ioc_summary' defined but not used [-Wunused-function]:  => 6880:13
  + drivers/message/i2o/i2o_config.c: warning: the frame size of 1036 bytes is larger than 1024 bytes [-Wframe-larger-than=]:  => 982:1
  + drivers/mfd/sm501.c: warning: (near initialization for 'gpio_chip_template') [enabled by default]:  => 1013:2, 1012:2, 1011:2, 1014:2, 1010:2
  + drivers/mfd/sm501.c: warning: excess elements in struct initializer [enabled by default]:  => 1013:2, 1012:2, 1011:2, 1014:2, 1010:2
  + drivers/mfd/sm501.c: warning: initialization from incompatible pointer type [enabled by default]:  => 884:74
  + drivers/mfd/tps65010.c: warning: initialization from incompatible pointer type [enabled by default]:  => 496:66, 479:67
  + drivers/mfd/tps65217.c: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]:  => 169:13
  + drivers/mmc/host/bfin_sdh.c: warning: format '%lx' expects argument of type 'long unsigned int', but argument 5 has type 'int' [-Wformat]:  => 466:2
  + drivers/mmc/host/bfin_sdh.c: warning: format '%lx' expects argument of type 'long unsigned int', but argument 6 has type 'int' [-Wformat]:  => 174:4
  + drivers/mmc/host/bfin_sdh.c: warning: format '%lx' expects argument of type 'long unsigned int', but argument 7 has type 'int' [-Wformat]:  => 174:4
  + drivers/mmc/host/bfin_sdh.c: warning: format '%lx' expects argument of type 'long unsigned int', but argument 8 has type 'int' [-Wformat]:  => 174:4
  + drivers/mtd/chips/cfi_cmdset_0020.c: warning: the frame size of 1028 bytes is larger than 1024 bytes [-Wframe-larger-than=]:  => 606:1
  + drivers/mtd/devices/doc2000.c: warning: value computed is not used [-Wunused-value]:  => 1023:5, 1123:5, 854:5, 1048:4
  + drivers/mtd/devices/doc2001plus.c: warning: value computed is not used [-Wunused-value]:  => 622:3, 623:3, 875:4, 874:4
  + drivers/mtd/devices/docprobe.c: warning: value computed is not used [-Wunused-value]:  => 139:4, 138:4, 158:5
  + drivers/mtd/maps/bfin-async-flash.c: warning: unused variable 'ret' [-Wunused-variable]:  => 128:6
  + drivers/mtd/nand/bf5xx_nand.c: warning: unused variable 'info' [-Wunused-variable]:  => 848:26, 855:26
  + drivers/mtd/nand/diskonchip.c: warning: value computed is not used [-Wunused-value]:  => 594:3, 494:3, 1454:3, 520:3, 318:3, 625:3, 537:3, 557:3, 1456:3, 629:5, 593:3, 624:3, 556:3, 541:5, 1547:5, 630:5, 1455:3
  + drivers/mtd/nand/s3c2410.c: warning: 's3c2410_nand_calculate_ecc' defined but not used [-Wunused-function]:  => 556:12
  + drivers/mtd/nand/s3c2410.c: warning: 's3c2410_nand_correct_data' defined but not used [-Wunused-function]:  => 447:12
  + drivers/mtd/nand/s3c2410.c: warning: 's3c2410_nand_enable_hwecc' defined but not used [-Wunused-function]:  => 527:13
  + drivers/mtd/nand/s3c2410.c: warning: 's3c2412_nand_calculate_ecc' defined but not used [-Wunused-function]:  => 571:12
  + drivers/mtd/nand/s3c2410.c: warning: 's3c2412_nand_enable_hwecc' defined but not used [-Wunused-function]:  => 537:13
  + drivers/mtd/nand/s3c2410.c: warning: 's3c2440_nand_calculate_ecc' defined but not used [-Wunused-function]:  => 587:12
  + drivers/mtd/nand/s3c2410.c: warning: 's3c2440_nand_enable_hwecc' defined but not used [-Wunused-function]:  => 547:13
  + drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c: warning: 'err' may be used uninitialized in this function [-Wuninitialized]:  => 1375:308, 1416:6
  + drivers/net/ethernet/dec/ewrk3.c: warning: return from incompatible pointer type [enabled by default]: 1915:111 => 1915:111, 1915:1
  + drivers/net/ethernet/neterion/s2io.c: warning: 'ip' may be used uninitialized in this function [-Wuninitialized]:  => 8488:48
  + drivers/net/ethernet/neterion/s2io.c: warning: 'tcp' may be used uninitialized in this function [-Wuninitialized]:  => 8488:48
  + drivers/net/ethernet/neterion/vxge/vxge-config.c: warning: 'val32' may be used uninitialized in this function [-Wuninitialized]:  => 4594:18
  + drivers/net/irda/w83977af_ir.c: warning: 'bus_to_virt' is deprecated (declared at /scratch/kisskb/src/arch/arm/include/asm/memory.h:250) [-Wdeprecated-declarations]:  => 748:2
  + drivers/net/sb1000.c: warning: 'frequency' may be used uninitialized in this function [-Wuninitialized]:  => 1034:3008
  + drivers/nfc/nfcwilink.c: warning: overflow in implicit constant conversion [-Woverflow]:  => 415:2
  + drivers/parport/parport_pc.c: warning: 'bus_to_virt' is deprecated (declared at /scratch/kisskb/src/arch/arm/include/asm/memory.h:250) [-Wdeprecated-declarations]:  => 622:3
  + drivers/pci/quirks.c: warning: 'host_bridge' may be used uninitialized in this function [-Wuninitialized]:  => 2393:6
  + drivers/platform/x86/samsung-laptop.c: warning: 'loca' may be used uninitialized in this function [-Wuninitialized]:  => 1357:26
  + drivers/platform/x86/thinkpad_acpi.c: warning: 'speed' may be used uninitialized in this function [-Wuninitialized]:  => 7896:2
  + drivers/power/ds2782_battery.c: warning: 'raw' may be used uninitialized in this function [-Wuninitialized]:  => 164:12, 205:17
  + drivers/power/ds2782_battery.c: warning: 'sense_res_raw' may be used uninitialized in this function [-Wuninitialized]:  => 125:2
  + drivers/regulator/core.c: warning: 'val' may be used uninitialized in this function [-Wuninitialized]:  => 1758:14, 1988:6
  + drivers/scsi/advansys.c: warning: 'adv_scsiqp' may be used uninitialized in this function [-Wuninitialized]:  => 9319:34
  + drivers/scsi/advansys.c: warning: 'next_qp' may be used uninitialized in this function [-Wuninitialized]:  => 9037:19
  + drivers/scsi/advansys.c: warning: label 'err_unmap' defined but not used [-Wunused-label]:  => 12378:2
  + drivers/scsi/arm/../NCR5380.c: warning: 'oakscsi_intr' defined but not used [-Wunused-function]:  => 1160:20
  + drivers/scsi/arm/fas216.c: warning: 'fas216_dumpinfo' defined but not used [-Wunused-function]:  => 182:13
  + drivers/scsi/fcoe/fcoe.c: warning: 'ctlr' may be used uninitialized in this function [-Wuninitialized]:  => 2028:359
  + drivers/scsi/libsas/sas_host_smp.c: warning: 'bit' may be used uninitialized in this function [-Wuninitialized]:  => 112:16
  + drivers/scsi/lpfc/lpfc_els.c: warning: 'cmd' may be used uninitialized in this function [-Wuninitialized]:  => 4763:21
  + drivers/scsi/lpfc/lpfc_els.c: warning: 'ha_copy' may be used uninitialized in this function [-Wuninitialized]:  => 95:39
  + drivers/scsi/lpfc/lpfc_els.c: warning: 'length' may be used uninitialized in this function [-Wuninitialized]:  => 4762:44
  + drivers/scsi/mvsas/mv_sas.c: warning: 'tag' may be used uninitialized in this function [-Wuninitialized]:  => 1606:41, 1551:41
  + drivers/scsi/mvsas/mv_sas.c: warning: comparison between 'enum sas_device_type' and 'enum sas_dev_type' [-Wenum-compare]: 1159:39, 1156:34 => 1159:39, 1156:57, 1156:34, 1156:396, 1159:62, 1159:110, 1159:397, 1156:107
  + drivers/scsi/mvumi.c: warning: 'ib_entry' may be used uninitialized in this function [-Wuninitialized]:  => 1370:18
  + drivers/scsi/osst.c: warning: 'STp' may be used uninitialized in this function [-Wuninitialized]:  => 4612:33
  + drivers/scsi/qlogicpti.c: warning: assignment discards 'const' qualifier from pointer target type [enabled by default]:  => 1308:7
  + drivers/scsi/scsi_debug.c: warning: 'csum' may be used uninitialized in this function [-Wuninitialized]: 1755:6 => 1755:6, 1755:27
  + drivers/scsi/sg.c: warning: 'sdp' may be used uninitialized in this function [-Wuninitialized]:  => 429:35, 840:307
  + drivers/spi/spi-s3c64xx.c: warning: comparison between 'enum dma_data_direction' and 'enum dma_transfer_direction' [-Wenum-compare]:  => 263:21, 272:21, 292:21
  + drivers/staging/comedi/drivers/pcmmio.c: warning: 'irq[1]' may be used uninitialized in this function [-Wuninitialized]:  => 1205:33
  + drivers/staging/csr/csr_wifi_hip_udi.c: warning: format '%ld' expects argument of type 'long int', but argument 5 has type 'int' [-Wformat]:  => 151:27
  + drivers/staging/slicoss/slicoss.c: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]:  => 2478:25
  + drivers/staging/slicoss/slicoss.c: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]:  => 3498:12, 1797:12, 1101:12, 3074:12, 1951:10, 2450:11
  + drivers/staging/vme/devices/vme_pio2_gpio.c: warning: initialization from incompatible pointer type [enabled by default]:  => 31:66
  + drivers/staging/vt6655/device_main.c: warning: the frame size of 1300 bytes is larger than 1024 bytes [-Wframe-larger-than=]:  => 3531:1
  + drivers/staging/vt6655/iwctl.c: warning: the frame size of 1292 bytes is larger than 1024 bytes [-Wframe-larger-than=]:  => 787:1
  + drivers/staging/vt6656/main_usb.c: warning: the frame size of 1284 bytes is larger than 1024 bytes [-Wframe-larger-than=]:  => 2016:1
  + drivers/staging/vt6656/main_usb.c: warning: the frame size of 1296 bytes is larger than 1024 bytes [-Wframe-larger-than=]:  => 2016:1
  + drivers/tty/n_gsm.c: warning: unused variable 'buf' [-Wunused-variable]:  => 2264:7
  + drivers/tty/serial/8250/8250.c: warning: 'i' may be used uninitialized in this function [-Wuninitialized]: 1661:28, 1661:32, 1663:18, 1666:18, 1661:2 => 1661:28, 1625:306, 1663:18, 1661:32, 1666:18, 1661:2, 1661:35
  + drivers/tty/serial/8250/8250_early.c: warning: comparison of distinct pointer types lacks a cast [enabled by default]:  => 196:160
  + drivers/tty/serial/max310x.c: warning: (near initialization for 's') [enabled by default]:  => 952:89, 941:89, 976:89, 962:89
  + drivers/tty/serial/max310x.c: warning: ignoring return value of 'gpiochip_remove', declared with attribute warn_unused_result [-Wunused-result]:  => 1223:18
  + drivers/tty/serial/max310x.c: warning: initialization from incompatible pointer type [enabled by default]:  => 952:89, 941:89, 976:89, 962:89
  + drivers/tty/vt/consolemap.c: warning: 'h' may be used uninitialized in this function [-Wuninitialized]:  => 794:6
  + drivers/uio/uio.c: warning: 'ret' may be used uninitialized in this function [-Wuninitialized]:  => 838:277
  + drivers/usb/musb/musb_gadget.c: warning: comparison of distinct pointer types lacks a cast [enabled by default]:  => 778:181
  + drivers/video/arkfb.c: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]:  => 1019:23
  + drivers/video/bf54x-lq043fb.c: warning: unused variable 'fbinfo' [-Wunused-variable]:  => 720:18
  + drivers/video/gbefb.c: warning: assignment makes pointer from integer without a cast [enabled by default]:  => 1179:11
  + drivers/video/gbefb.c: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]:  => 1159:8
  + drivers/video/mbx/mbxfb.c: warning: assignment makes pointer from integer without a cast [enabled by default]:  => 952:21, 942:22
  + drivers/video/s3fb.c: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]:  => 1186:23
  + drivers/video/via/viafbdev.c: warning: unused variable 'iga1_entry' [-Wunused-variable]:  => 1634:4
  + drivers/video/via/viafbdev.c: warning: unused variable 'iga2_entry' [-Wunused-variable]:  => 1635:4
  + drivers/video/vt8623fb.c: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]:  => 732:23
  + drivers/vme/bridges/vme_ca91cx42.c: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]:  => 469:14
  + drivers/vme/bridges/vme_tsi148.c: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]:  => 740:14
  + fs/9p/acl.c: warning: 'full_name' may be used uninitialized in this function [-Wuninitialized]: 229:2, 276:2 => 229:2, 276:2, 229:23
  + fs/9p/fid.c: warning: 'wnames' may be used uninitialized in this function [-Wuninitialized]:  => 215:7
  + fs/autofs4/waitq.c: warning: 'wq' may be used uninitialized in this function [-Wuninitialized]:  => 457:5
  + fs/btrfs/backref.c: warning: 'type' may be used uninitialized in this function [-Wuninitialized]:  => 1317:18
  + fs/btrfs/ctree.c: warning: 'pslot' may be used uninitialized in this function [-Wuninitialized]:  => 1765:24, 1969:24
  + fs/btrfs/file-item.c: warning: comparison of distinct pointer types lacks a cast [enabled by default]: 718:7, 768:316, 718:306, 809:703, 768:21, 809:9, 768:320, 718:302, 809:346, 809:350, 809:711 => 768:316, 809:703, 717:356, 768:21, 766:851, 768:320, 809:346, 809:350, 717:738, 718:7, 718:306, 809:9, 766:404, 717:348, 718:302, 809:711, 766:412
  + fs/btrfs/free-space-cache.c: warning: 'next_zero' may be used uninitialized in this function [-Wuninitialized]:  => 2336:5
  + fs/btrfs/free-space-cache.c: warning: 'start' may be used uninitialized in this function [-Wuninitialized]:  => 967:7
  + fs/btrfs/free-space-cache.c: warning: 'type' may be used uninitialized in this function [-Wuninitialized]:  => 720:27
  + fs/btrfs/inode.c: warning: 'extent_end' may be used uninitialized in this function [-Wuninitialized]: 1274:6 => 1274:27, 1274:6
  + fs/btrfs/qgroup.c: warning: 'ref_root' may be used uninitialized in this function [-Wuninitialized]:  => 1082:328
  + fs/btrfs/tree-log.c: warning: 'dst_di' may be used uninitialized in this function [-Wuninitialized]:  => 1243:338
  + fs/cifs/cifssmb.c: warning: 'pSMB' may be used uninitialized in this function [-Wuninitialized]:  => 3726:26
  + fs/cifs/cifssmb.c: warning: 'parm' may be used uninitialized in this function [-Wuninitialized]:  => 3766:11
  + fs/cifs/cifssmb.c: warning: 'pdata' may be used uninitialized in this function [-Wuninitialized]:  => 3787:20
  + fs/cifs/connect.c: warning: 'ses' may be used uninitialized in this function [-Wuninitialized]:  => 3598:20
  + fs/cifs/connect.c: warning: 'tcon' may be used uninitialized in this function [-Wuninitialized]:  => 3596:17
  + fs/cifs/connect.c: warning: 'xid' may be used uninitialized in this function [-Wuninitialized]:  => 3600:17
  + fs/compat_binfmt_elf.c: warning: 'cputime_to_compat_timeval' defined but not used [-Wunused-function]:  => 51:13
  + fs/fat/namei_vfat.c: warning: 'lcase' may be used uninitialized in this function [-Wuninitialized]:  => 649:12
  + fs/fat/namei_vfat.c: warning: 'ulen' may be used uninitialized in this function [-Wuninitialized]:  => 218:2
  + fs/isofs/namei.c: warning: 'i' may be used uninitialized in this function [-Wuninitialized]:  => 26:26
  + fs/jffs2/erase.c: warning: format '%zd' expects argument of type 'signed size_t', but argument 4 has type 'size_t' [-Wformat]:  => 402:4, 471:5
  + fs/jffs2/erase.c: warning: format '%zx' expects argument of type 'size_t', but argument 2 has type 'unsigned int' [-Wformat]:  => 357:4
  + fs/jffs2/gc.c: warning: format '%zd' expects argument of type 'signed size_t', but argument 3 has type 'size_t' [-Wformat]:  => 1015:4, 934:5
  + fs/jffs2/gc.c: warning: format '%zd' expects argument of type 'signed size_t', but argument 5 has type 'size_t' [-Wformat]:  => 683:3
  + fs/jffs2/nodemgmt.c: warning: format '%zd' expects argument of type 'signed size_t', but argument 3 has type 'size_t' [-Wformat]:  => 780:3, 757:3
  + fs/jffs2/read.c: warning: format '%zx' expects argument of type 'size_t', but argument 4 has type 'unsigned int' [-Wformat]:  => 47:3
  + fs/jffs2/readinode.c: warning: format '%zd' expects argument of type 'signed size_t', but argument 5 has type 'size_t' [-Wformat]:  => 92:4, 1223:3
  + fs/jffs2/readinode.c: warning: format '%zu' expects argument of type 'size_t', but argument 4 has type 'unsigned int' [-Wformat]:  => 69:3
  + fs/jffs2/readinode.c: warning: format '%zu' expects argument of type 'size_t', but argument 5 has type 'unsigned int' [-Wformat]:  => 967:3, 1052:4
  + fs/jffs2/scan.c: warning: format '%zu' expects argument of type 'size_t', but argument 2 has type 'unsigned int' [-Wformat]:  => 121:3, 128:3
  + fs/jffs2/scan.c: warning: format '%zx' expects argument of type 'size_t', but argument 2 has type 'unsigned int' [-Wformat]:  => 105:3
  + fs/jffs2/scan.c: warning: format '%zx' expects argument of type 'size_t', but argument 3 has type 'unsigned int' [-Wformat]:  => 300:3
  + fs/jffs2/wbuf.c: warning: format '%zd' expects argument of type 'signed size_t', but argument 2 has type 'size_t' [-Wformat]:  => 645:3
  + fs/jffs2/wbuf.c: warning: format '%zd' expects argument of type 'signed size_t', but argument 3 has type 'size_t' [-Wformat]:  => 1048:3, 1115:3, 1090:3
  + fs/jffs2/wbuf.c: warning: format '%zd' expects argument of type 'signed size_t', but argument 4 has type 'size_t' [-Wformat]:  => 1048:3, 1115:3, 1090:3
  + fs/jffs2/wbuf.c: warning: format '%zx' expects argument of type 'size_t', but argument 2 has type 'unsigned int' [-Wformat]:  => 971:4
  + fs/jffs2/write.c: warning: format '%zd' expects argument of type 'signed size_t', but argument 5 has type 'size_t' [-Wformat]:  => 271:3, 113:3
  + fs/lockd/svc.c: warning: label 'err_sysctl' defined but not used [-Wunused-label]:  => 637:1
  + fs/locks.c: warning: 'lock' may be used uninitialized in this function [-Wuninitialized]:  => 1665:17
  + fs/nfs/callback_xdr.c: warning: 'op_nr' may be used uninitialized in this function [-Wuninitialized]:  => 794:7
  + fs/notify/fanotify/fanotify.c: warning: 'marks_ignored_mask' may be used uninitialized in this function [-Wuninitialized]: 207:32 => 209:2, 213:55, 213:32
  + fs/notify/fanotify/fanotify.c: warning: 'marks_mask' may be used uninitialized in this function [-Wuninitialized]: 207:17 => 213:40, 213:17, 213:2
  + fs/quota/quota.c: warning: 'quotactl_cmd_write' defined but not used [-Wunused-function]:  => 295:12
  + fs/read_write.c: warning: unused variable 'buf' [-Wunused-variable]:  => 685:9
  + fs/udf/super.c: warning: 'map' may be used uninitialized in this function [-Wuninitialized]: 1251:9 => 1256:32, 1256:9
  + include/asm-generic/xor.h: warning: 'xor_block_32regs_p' defined but not used [-Wunused-variable]:  => 704:34
  + include/asm-generic/xor.h: warning: 'xor_block_8regs_p' defined but not used [-Wunused-variable]:  => 696:34
  + include/linux/basic_mmio_gpio.h: warning: initialization from incompatible pointer type [enabled by default]:  => 63:67
  + include/linux/list.h: warning: 'idev' may be used uninitialized in this function [-Wuninitialized]:  => 188:13
  + include/linux/list_nulls.h: warning: 'node' may be used uninitialized in this function [-Wuninitialized]:  => 35:2
  + include/linux/netfilter.h: warning: 'ret' may be used uninitialized in this function [-Wuninitialized]:  => 249:6
  + include/linux/spinlock.h: warning: 'dst_ptl' may be used uninitialized in this function [-Wuninitialized]:  => 325:19
  + include/linux/spinlock.h: warning: 'ptl' may be used uninitialized in this function [-Wuninitialized]:  => 325:19
  + include/net/ipv6.h: warning: '*((void *)&addr+8)' may be used uninitialized in this function [-Wuninitialized]:  => 357:38
  + ipc/mqueue.c: warning: 'msg_ptr' may be used uninitialized in this function [-Wuninitialized]:  => 1153:896
  + kernel/cgroup.c: warning: 'l' may be used uninitialized in this function [-Wuninitialized]:  => 3586:51
  + kernel/cgroup.c: warning: array subscript is below array bounds [-Warray-bounds]:  => 4326:38
  + kernel/profile.c: warning: 'profile_cpu_callback' defined but not used [-Wunused-function]:  => 355:125
  + kernel/profile.c: warning: 'profile_discard_flip_buffers' defined but not used [-Wunused-function]:  => 291:13
  + kernel/profile.c: warning: 'profile_flip_buffers' defined but not used [-Wunused-function]:  => 268:13
  + kernel/relay.c: warning: format '%Zd' expects argument of type 'signed size_t', but argument 2 has type 'size_t' [-Wformat]:  => 833:10
  + kernel/relay.c: warning: format '%Zd' expects argument of type 'signed size_t', but argument 3 has type 'size_t' [-Wformat]:  => 833:10
  + kernel/seccomp.c: warning: 'value' may be used uninitialized in this function [-Wuninitialized]:  => 100:17, 104:17
  + kernel/seccomp.c: warning: control reaches end of non-void function [-Wreturn-type]:  => 112:1
  + lib/rbtree_test.c: warning: 'blacks' may be used uninitialized in this function [-Wuninitialized]:  => 76:99, 76:4
  + mm/dmapool.c: warning: format '%Zu' expects argument of type 'size_t', but argument 6 has type 'unsigned int' [-Wformat]:  => 101:6
  + mm/dmapool.c: warning: format '%Zu' expects argument of type 'size_t', but argument 7 has type 'unsigned int' [-Wformat]:  => 101:6
  + mm/memblock.c: warning: 'r' may be used uninitialized in this function [-Wuninitialized]:  => 732:15
  + mm/percpu.c: warning: format '%zu' expects argument of type 'size_t', but argument 2 has type 'unsigned int' [-Wformat]: 816:3 => 1697:2, 816:3
  + mm/percpu.c: warning: format '%zu' expects argument of type 'size_t', but argument 4 has type 'unsigned int' [-Wformat]: 1125:9, 717:3 => 1697:2, 1125:9, 717:3
  + mm/percpu.c: warning: format '%zu' expects argument of type 'size_t', but argument 5 has type 'unsigned int' [-Wformat]: 1125:9, 717:3 => 1697:2, 1125:9, 717:3
  + mm/percpu.c: warning: format '%zu' expects argument of type 'size_t', but argument 6 has type 'unsigned int' [-Wformat]: 1125:9 => 1697:2, 1125:9
  + mm/percpu.c: warning: format '%zu' expects argument of type 'size_t', but argument 7 has type 'unsigned int' [-Wformat]: 1125:9 => 1697:2, 1125:9
  + mm/percpu.c: warning: format '%zx' expects argument of type 'size_t', but argument 2 has type 'unsigned int' [-Wformat]:  => 1687:3
  + mm/slub.c: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]:  => 1979:1472, 1979:2236, 1979:1441, 1979:2969, 1979:3000, 1979:677, 1979:2205, 1979:708
  + mm/slub.c: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]:  => 1979:2161, 1979:633, 1979:2925, 1979:1397
  + mm/swapfile.c: warning: 'nr_extents' may be used uninitialized in this function [-Wuninitialized]:  => 2030:1083
  + modpost: WARNING: modpost: Found 5 section mismatch(es).:  => N/A
  + net/bridge/br_multicast.c: warning: 'max_delay' may be used uninitialized in this function [-Wuninitialized]:  => 1185:12
  + net/ceph/messenger.c: warning: 'total_max_write' may be used uninitialized in this function [-Wuninitialized]:  => 1064:122
  + net/core/dev.c: warning: comparison of distinct pointer types lacks a cast [enabled by default]:  => 4979:194, 4910:195
  + net/core/skbuff.c: warning: 'err' may be used uninitialized in this function [-Wuninitialized]:  => 1338:6
  + net/ipv4/inet_connection_sock.c: warning: 'head' may be used uninitialized in this function [-Wuninitialized]:  => 207:17
  + net/ipv4/ip_options.c: warning: 'faddr' may be used uninitialized in this function [-Wuninitialized]:  => 183:16
  + net/ipv4/ip_options.c: warning: 'nexthop' may be used uninitialized in this function [-Wuninitialized]:  => 659:16
  + net/ipv4/ip_output.c: warning: 'ret' may be used uninitialized in this function [-Wuninitialized]:  => 307:2
  + net/ipv4/raw.c: warning: 'node' may be used uninitialized in this function [-Wuninitialized]:  => 119:178
  + net/ipv4/route.c: warning: 'ip_rt_gc_elasticity' defined but not used [-Wunused-variable]:  => 128:12
  + net/ipv4/route.c: warning: 'ip_rt_gc_interval' defined but not used [-Wunused-variable]:  => 121:12
  + net/ipv4/route.c: warning: 'ip_rt_gc_min_interval' defined but not used [-Wunused-variable]:  => 122:12
  + net/ipv4/route.c: warning: 'ip_rt_gc_timeout' defined but not used [-Wunused-variable]:  => 120:12
  + net/ipv4/tcp.c: warning: 'copy' may be used uninitialized in this function [-Wuninitialized]:  => 878:27
  + net/ipv4/xfrm4_output.c: warning: 'ret' may be used uninitialized in this function [-Wuninitialized]:  => 97:2
  + net/ipv6/raw.c: warning: 'node' may be used uninitialized in this function [-Wuninitialized]:  => 78:341
  + net/irda/irda_device.c: warning: 'bus_to_virt' is deprecated (declared at /scratch/kisskb/src/arch/arm/include/asm/memory.h:250) [-Wdeprecated-declarations]:  => 318:2
  + net/netfilter/ipvs/ip_vs_ctl.c: warning: 't.tcp_fin_timeout' may be used uninitialized in this function [-Wuninitialized]:  => 2244:47
  + net/netfilter/ipvs/ip_vs_ctl.c: warning: 't.tcp_timeout' may be used uninitialized in this function [-Wuninitialized]:  => 2244:47
  + net/netfilter/ipvs/ip_vs_ctl.c: warning: 't.udp_timeout' may be used uninitialized in this function [-Wuninitialized]:  => 2244:47
  + net/rds/iw_rdma.c: warning: the frame size of 1028 bytes is larger than 1024 bytes [-Wframe-larger-than=]:  => 200:1
  + net/rds/rdma.c: warning: 'iov_size' may be used uninitialized in this function [-Wuninitialized]:  => 697:15
  + net/sched/sch_drr.c: warning: 'err' may be used uninitialized in this function [-Wuninitialized]:  => 359:27, 359:3
  + net/sched/sch_qfq.c: warning: 'err' may be used uninitialized in this function [-Wuninitialized]:  => 885:27, 885:3
  + net/sched/sch_sfb.c: warning: 'salt' may be used uninitialized in this function [-Wuninitialized]:  => 313:12
  + net/sunrpc/svc.c: warning: format '%Zd' expects argument of type 'signed size_t', but argument 3 has type 'size_t' [-Wformat]:  => 1231:4
  + net/sunrpc/xprtrdma/verbs.c: warning: the frame size of 1044 bytes is larger than 1024 bytes [-Wframe-larger-than=]:  => 1774:1
  + sound/oss/dmabuf.c: warning: 'bus_to_virt' is deprecated (declared at /scratch/kisskb/src/arch/arm/include/asm/memory.h:250) [-Wdeprecated-declarations]:  => 160:2
  + sound/oss/dmabuf.c: warning: 'virt_to_bus' is deprecated (declared at /scratch/kisskb/src/arch/arm/include/asm/memory.h:245) [-Wdeprecated-declarations]:  => 117:2
  + sound/oss/waveartist.c: warning: passing argument 1 of 'spin_unlock_irqrestore' from incompatible pointer type [enabled by default]:  => 1487:2
  + sound/oss/waveartist.c: warning: passing argument 1 of 'spinlock_check' from incompatible pointer type [enabled by default]:  => 1485:2
  + sound/pci/lx6464es/lx6464es.c: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]: 456:80 => 456:3, 456:80
  + sound/pci/lx6464es/lx_core.c: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]: 1194:85 => 1194:85, 1194:2
  + sound/soc/codecs/wm5100.c: warning: (near initialization for 'wm5100_template_chip') [enabled by default]:  => 2277:2, 2278:2, 2282:2, 2276:2, 2280:2, 2279:2, 2281:2
  + sound/soc/codecs/wm5100.c: warning: excess elements in struct initializer [enabled by default]:  => 2277:2, 2278:2, 2282:2, 2276:2, 2280:2, 2279:2, 2281:2
  + sound/soc/codecs/wm5100.c: warning: initialization from incompatible pointer type [enabled by default]:  => 2224:75
  + sound/soc/codecs/wm8903.c: warning: (near initialization for 'wm8903_template_chip') [enabled by default]:  => 1852:2, 1851:2, 1850:2, 1849:2, 1848:2, 1855:2, 1854:2, 1853:2
  + sound/soc/codecs/wm8903.c: warning: excess elements in struct initializer [enabled by default]:  => 1852:2, 1851:2, 1850:2, 1849:2, 1848:2, 1855:2, 1854:2, 1853:2
  + sound/soc/codecs/wm8903.c: warning: initialization from incompatible pointer type [enabled by default]:  => 1780:75
  + sound/soc/codecs/wm8962.c: warning: (near initialization for 'wm8962_template_chip') [enabled by default]:  => 3332:2, 3334:2, 3330:2, 3329:2, 3333:2, 3331:2
  + sound/soc/codecs/wm8962.c: warning: excess elements in struct initializer [enabled by default]:  => 3332:2, 3334:2, 3330:2, 3329:2, 3333:2, 3331:2
  + sound/soc/codecs/wm8962.c: warning: initialization from incompatible pointer type [enabled by default]:  => 3274:75
  + sound/soc/codecs/wm8983.c: warning: 'pll_div.k' may be used uninitialized in this function [-Wuninitialized]: 872:15 => 872:15, 873:40
  + sound/soc/codecs/wm8985.c: warning: 'pll_div.k' may be used uninitialized in this function [-Wuninitialized]: 851:15 => 852:40, 851:15
  + sound/soc/codecs/wm8996.c: warning: (near initialization for 'wm8996_template_chip') [enabled by default]:  => 2193:2, 2197:2, 2196:2, 2192:2, 2194:2, 2198:2, 2195:2
  + sound/soc/codecs/wm8996.c: warning: excess elements in struct initializer [enabled by default]:  => 2193:2, 2197:2, 2196:2, 2192:2, 2194:2, 2198:2, 2195:2
  + sound/soc/codecs/wm8996.c: warning: initialization from incompatible pointer type [enabled by default]:  => 2144:75
  + sound/soc/codecs/wm_hubs.c: warning: 'reg_l' may be used uninitialized in this function [-Wuninitialized]:  => 322:11
  + sound/soc/codecs/wm_hubs.c: warning: 'reg_r' may be used uninitialized in this function [-Wuninitialized]:  => 321:11
  + sound/soc/omap/mcbsp.c: warning: control reaches end of non-void function [-Wreturn-type]:  => 794:1
  + sound/soc/soc-dapm.c: warning: 'ret' may be used uninitialized in this function [-Wuninitialized]:  => 3125:6
  + warning:   CC      net/ipv4/igmp.o:  => N/A
  + warning:   CC [M]  drivers/ide/ide-disk_proc.o:  => N/A
  + warning:   CC [M]  drivers/net/wireless/ath/ath6kl/txrx.o:  => N/A
  + warning:   CC [M]  drivers/video/aty/radeon_accel.o:  => N/A
  + warning:   CC [M]  fs/jfs/jfs_metapage.o:  => N/A
  + warning:   CC [M]  net/sctp/command.o:  => N/A
  + warning:   LD [M]  drivers/staging/bcm/bcm_wimax.o:  => N/A
  + warning: (ARCH_REQUIRE_GPIOLIB && I2C_I801 && MFD_TC6393XB && FB_VIA) selects GPIOLIB which has unmet direct dependencies (ARCH_WANT_OPTIONAL_GPIOLIB || ARCH_REQUIRE_GPIOLIB):  => N/A
  + warning: (DVB_USB_PCTV452E) selects TTPCI_EEPROM which has unmet direct dependencies (MEDIA_SUPPORT && MEDIA_PCI_SUPPORT && MEDIA_DIGITAL_TV_SUPPORT && I2C):  => N/A
  + warning: (MOUSE_APPLETOUCH && MOUSE_BCM5974 && MOUSE_SYNAPTICS_USB && JOYSTICK_XPAD && TABLET_USB_ACECAD && TABLET_USB_AIPTEK && TABLET_USB_HANWANG && TABLET_USB_KBTAB && TABLET_USB_WACOM && TOUCHSCREEN_USB_COMPOSITE && INPUT_ATI_REMOTE2 && INPUT_KEYSPAN_REMOTE && INPUT_POWERMATE && INPUT_YEALINK && INPUT_CM109 && RC_ATI_REMOTE && IR_IMON && IR_MCEUSB && IR_REDRAT3 && IR_STREAMZAP && IR_IGUANA && IR_TTUSBIR && DRM_USB) selects USB which has unmet direct dependencies (USB_SUPPORT && USB_ARCH_HAS_HCD):  => N/A
  + warning: (PPC_PS3 && PPC_CELLEB && USB_EHCI_HCD_PMC_MSP && XPS_USB_HCD_XILINX && USB_OCTEON_EHCI) selects USB_EHCI_BIG_ENDIAN_MMIO which has unmet direct dependencies (USB_SUPPORT && USB_EHCI_HCD && (PPC_CELLEB || PPC_PS3 || 440EPX || ARCH_IXP4XX || XPS_USB_HCD_XILINX || PPC_MPC512x || CPU_CAVIUM_OCTEON || PMC_MSP || SPARC_LEON || MIPS_SEAD3)):  => N/A
  + warning: arch/powerpc/sysdev/built-in.o(.text+0xe11c): Section mismatch in reference from the function .ics_rtas_init() to the function .init.text:.xics_register_ics():  => N/A
  + warning: arch/powerpc/sysdev/built-in.o(.text+0xf6c8): Section mismatch in reference from the function .ics_rtas_init() to the function .init.text:.xics_register_ics():  => N/A
  + warning: drivers/built-in.o(.data+0x235b00): Section mismatch in reference from the variable tpci200_pci_drv to the variable .devinit.rodata:tpci200_idtable:  => N/A
  + warning: drivers/net/ethernet/3com/3c509.o(.data+0x190): Section mismatch in reference from the variable el3_eisa_driver to the function .init.text:el3_eisa_probe():  => N/A
  + warning: drivers/net/ethernet/3com/3c59x.o(.data+0xd8): Section mismatch in reference from the variable vortex_eisa_driver to the function .init.text:vortex_eisa_probe():  => N/A
  + warning: drivers/net/ethernet/8390/ne3210.o(.data+0x40): Section mismatch in reference from the variable ne3210_eisa_driver to the function .init.text:ne3210_eisa_probe():  => N/A
  + warning: drivers/net/ethernet/amd/depca.o(.data+0x34): Section mismatch in reference from the variable depca_eisa_driver to the function .init.text:depca_eisa_probe():  => N/A
  + warning: drivers/net/ethernet/amd/depca.o(.devinit.text+0x2c): Section mismatch in reference from the function depca_isa_probe() to the function .init.text:depca_common_init():  => N/A
  + warning: drivers/net/ethernet/amd/depca.o(.devinit.text+0x5f): Section mismatch in reference from the function depca_isa_probe() to the function .init.text:depca_shmem_probe():  => N/A
  + warning: drivers/net/ethernet/amd/depca.o(.devinit.text+0xb2): Section mismatch in reference from the function depca_isa_probe() to the function .init.text:depca_hw_init():  => N/A
  + warning: drivers/net/ethernet/dec/tulip/de4x5.o(.data+0xcc): Section mismatch in reference from the variable de4x5_eisa_driver to the function .init.text:de4x5_eisa_probe():  => N/A
  + warning: drivers/net/ethernet/hp/hp100.o(.data+0x70): Section mismatch in reference from the variable hp100_eisa_driver to the function .init.text:hp100_eisa_probe():  => N/A
  + warning: drivers/scsi/sim710.o(.data+0x4c): Section mismatch in reference from the variable sim710_eisa_driver to the function .init.text:sim710_eisa_probe():  => N/A
  + warning: drivers/staging/built-in.o(.data+0x9550): Section mismatch in reference from the variable tpci200_pci_drv to the variable .devinit.rodata:tpci200_idtable:  => N/A
  + warning: drivers/staging/ipack/bridges/tpci200.o(.data+0x14): Section mismatch in reference from the variable tpci200_pci_drv to the function .devexit.text:tpci200_pci_remove():  => N/A
  + warning: drivers/staging/ipack/bridges/tpci200.o(.data+0xc): Section mismatch in reference from the variable tpci200_pci_drv to the variable .devinit.rodata:tpci200_idtable:  => N/A
  + warning: vmlinux.o(.data+0x2a9610): Section mismatch in reference from the variable tpci200_pci_drv to the variable .devinit.rodata:tpci200_idtable:  => N/A
  + warning: vmlinux.o(.devinit.text+0x5b7): Section mismatch in reference from the function intel_scu_devices_create() to the function .init.text:i2c_register_board_info():  => N/A
  + warning: vmlinux.o(.text+0x2bdc8): Section mismatch in reference from the function .early_setup_secondary() to the function .cpuinit.text:.early_init_mmu_secondary():  => N/A
  + warning: vmlinux.o(.text+0x4f498): Section mismatch in reference from the function .wake_offline_cpus() to the function .cpuinit.text:.cpu_up():  => N/A
  + warning: vmlinux.o(.text+0x5f8d45): Section mismatch in reference from the function ipc_probe() to the function .devinit.text:intel_scu_devices_create():  => N/A
  + warning: vmlinux.o(.text+0x75960): Section mismatch in reference from the function .ics_rtas_init() to the function .init.text:.xics_register_ics():  => N/A
  + warning: vmlinux.o(.text+0x8981c): Section mismatch in reference from the function .pnv_pci_ioda_msi_setup() to the function .devinit.text:.__pnv_ioda_get_one_pe():  => N/A
  + warning: vmlinux.o(.text+0x89838): Section mismatch in reference from the function .pnv_pci_ioda_msi_setup() to the function .devinit.text:.__pnv_ioda_get_one_pe():  => N/A
  + warning: vmlinux.o(.text+0x8df1c): Section mismatch in reference from the function .pci_dn_reconfig_notifier() to the function .devinit.text:.update_dn_pci_info():  => N/A
  + warning: vmlinux.o(.text+0x8df38): Section mismatch in reference from the function .pci_dn_reconfig_notifier() to the function .devinit.text:.eeh_dev_init():  => N/A
  + warning: vmlinux.o(.text+0x933d0): Section mismatch in reference from the function .dlpar_online_cpu() to the function .cpuinit.text:.cpu_up():  => N/A
  + warning: vmlinux.o(.text+0x9b4e0): Section mismatch in reference from the function .pcibios_add_pci_devices() to the function .devinit.text:.of_rescan_bus():  => N/A
  + warning: vmlinux.o(.text+0x9b56c): Section mismatch in reference from the function .pcibios_add_pci_devices() to the function .devinit.text:.pcibios_setup_bus_devices():  => N/A
  + warning: vmlinux.o(.text+0x9b5d0): Section mismatch in reference from the function .pcibios_add_pci_devices() to the function .devinit.text:.pci_scan_bridge():  => N/A

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
