Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932529Ab2JQTYM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 15:24:12 -0400
Received: from juliette.telenet-ops.be ([195.130.137.74]:35390 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757623Ab2JQTYJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 15:24:09 -0400
Date: Wed, 17 Oct 2012 21:24:05 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Build regressions/improvements in v3.7-rc1
Message-ID: <alpine.DEB.2.00.1210172123400.27068@ayla.of.borg>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Below is the list of build error/warning regressions/improvements in
v3.7-rc1[1] compared to v3.6[2].

To make this mail fit in the lkml limit, I deleted
  - 727 lines about __mcount_loc on sparc64
  - all implicit function declaration error improvements
  - all warning improvements

Summarized:
  - build errors: +282/-945
  - build warnings: +1167/-2392

As I haven't mastered kup yet, there's no verbose summary at
http://www.kernel.org/pub/linux/kernel/people/geert/linux-log/v3.7-rc1.summary.gz

Happy fixing! ;-)

Thanks to the linux-next team for providing the build service.

[1] http://kisskb.ellerman.id.au/kisskb/head/5526/ (all 117 configs)
[2] http://kisskb.ellerman.id.au/kisskb/head/5469/ (all 117 configs)


*** ERRORS ***

282 regressions:
  + arch/frv/kernel/entry.S: Error: VLIW packing constraint violation:  => 871
  + arch/frv/kernel/process.c: error: 'chilregs' undeclared (first use in this function):  => 197:3
  + arch/frv/kernel/setup.c: error: 'clock_cmodes' undeclared (first use in this function):  => 571:6, 386:2
  + arch/frv/kernel/setup.c: error: expected '=', ',', ';', 'asm' or '__attribute__' before '*' token:  => 187:47
  + arch/frv/mm/elf-fdpic.c: error: 'ELF_FDPIC_FLAG_ARRANGEMENT' undeclared (first use in this function):  => 43:29
  + arch/frv/mm/elf-fdpic.c: error: 'ELF_FDPIC_FLAG_CONSTDISP' undeclared (first use in this function):  => 47:26
  + arch/frv/mm/elf-fdpic.c: error: 'ELF_FDPIC_FLAG_INDEPENDENT' undeclared (first use in this function):  => 44:7
  + arch/frv/mm/elf-fdpic.c: error: 'ELF_FDPIC_FLAG_PRESENT' undeclared (first use in this function):  => 33:31
  + arch/frv/mm/elf-fdpic.c: error: dereferencing pointer to incomplete type:  => 36:14, 46:15, 34:17, 41:14, 47:15, 43:19, 33:21
  + drivers/char/tpm/tpm_ibmvtpm.c: error: implicit declaration of function 'vio_disable_interrupts' [-Werror=implicit-function-declaration]:  => 391:2
  + drivers/gpio/devres.c: error: redefinition of 'devm_gpio_free':  => 113:6
  + drivers/gpio/devres.c: error: redefinition of 'devm_gpio_request':  => 51:5
  + drivers/gpio/devres.c: error: redefinition of 'devm_gpio_request_one':  => 80:5
  + drivers/gpio/gpio-74x164.c: error: field 'gpio_chip' has incomplete type:  => 26:19
  + drivers/gpio/gpio-74x164.c: error: implicit declaration of function 'gpiochip_add' [-Werror=implicit-function-declaration]:  => 172:2
  + drivers/gpio/gpio-74x164.c: error: implicit declaration of function 'gpiochip_remove' [-Werror=implicit-function-declaration]:  => 195:2
  + drivers/gpio/gpio-adnp.c: error: 'struct gpio_chip' has no member named 'of_node':  => 272:6, 484:43
  + drivers/gpio/gpio-adp5588.c: error: dereferencing pointer to incomplete type:  => 383:4, 425:42, 425:32, 380:4, 377:4, 379:4, 381:4, 384:4, 378:4, 385:4, 386:4
  + drivers/gpio/gpio-adp5588.c: error: field 'gpio_chip' has incomplete type:  => 32:19
  + drivers/gpio/gpio-adp5588.c: error: implicit declaration of function 'gpiochip_add' [-Werror=implicit-function-declaration]:  => 417:2
  + drivers/gpio/gpio-adp5588.c: error: implicit declaration of function 'gpiochip_remove' [-Werror=implicit-function-declaration]:  => 460:2
  + drivers/gpio/gpio-amd8111.c: error: (near initialization for 'gp.chip'):  => 169:3, 166:3, 165:3, 170:3, 168:3, 164:3, 173:3, 172:3, 167:3, 171:3
  + drivers/gpio/gpio-amd8111.c: error: field 'chip' has incomplete type:  => 70:19
  + drivers/gpio/gpio-amd8111.c: error: field name not in record or union initializer:  => 169:3, 166:3, 165:3, 170:3, 168:3, 164:3, 173:3, 172:3, 167:3, 171:3
  + drivers/gpio/gpio-amd8111.c: error: implicit declaration of function 'gpiochip_add' [-Werror=implicit-function-declaration]:  => 222:2
  + drivers/gpio/gpio-amd8111.c: error: implicit declaration of function 'gpiochip_remove' [-Werror=implicit-function-declaration]:  => 235:2
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
  + drivers/gpio/gpio-da9052.c: error: field 'gp' has incomplete type:  => 51:19
  + drivers/gpio/gpio-da9052.c: error: implicit declaration of function 'gpiochip_add' [-Werror=implicit-function-declaration]:  => 221:2
  + drivers/gpio/gpio-da9052.c: error: implicit declaration of function 'gpiochip_remove' [-Werror=implicit-function-declaration]:  => 236:2
  + drivers/gpio/gpio-da9052.c: error: unknown field 'base' specified in initializer:  => 201:2
  + drivers/gpio/gpio-da9052.c: error: unknown field 'can_sleep' specified in initializer:  => 199:2
  + drivers/gpio/gpio-da9052.c: error: unknown field 'direction_input' specified in initializer:  => 196:2
  + drivers/gpio/gpio-da9052.c: error: unknown field 'direction_output' specified in initializer:  => 197:2
  + drivers/gpio/gpio-da9052.c: error: unknown field 'get' specified in initializer:  => 194:2
  + drivers/gpio/gpio-da9052.c: error: unknown field 'label' specified in initializer:  => 192:2
  + drivers/gpio/gpio-da9052.c: error: unknown field 'ngpio' specified in initializer:  => 200:2
  + drivers/gpio/gpio-da9052.c: error: unknown field 'owner' specified in initializer:  => 193:2
  + drivers/gpio/gpio-da9052.c: error: unknown field 'set' specified in initializer:  => 195:2
  + drivers/gpio/gpio-da9052.c: error: unknown field 'to_irq' specified in initializer:  => 198:2
  + drivers/gpio/gpio-da9052.c: error: variable 'reference_gp' has initializer but incomplete type:  => 191:15
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
  + drivers/gpio/gpio-rdc321x.c: error: field 'chip' has incomplete type:  => 40:19
  + drivers/gpio/gpio-rdc321x.c: error: implicit declaration of function 'gpiochip_add' [-Werror=implicit-function-declaration]:  => 200:2
  + drivers/gpio/gpio-rdc321x.c: error: implicit declaration of function 'gpiochip_remove' [-Werror=implicit-function-declaration]:  => 214:2
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
  + drivers/gpio/gpio-tps65912.c: error: implicit declaration of function 'gpiochip_remove' [-Werror=implicit-function-declaration]:  => 120:2
  + drivers/gpio/gpio-tps65912.c: error: unknown field 'base' specified in initializer:  => 84:2
  + drivers/gpio/gpio-tps65912.c: error: unknown field 'can_sleep' specified in initializer:  => 82:2
  + drivers/gpio/gpio-tps65912.c: error: unknown field 'direction_input' specified in initializer:  => 78:2
  + drivers/gpio/gpio-tps65912.c: error: unknown field 'direction_output' specified in initializer:  => 79:2
  + drivers/gpio/gpio-tps65912.c: error: unknown field 'get' specified in initializer:  => 80:2
  + drivers/gpio/gpio-tps65912.c: error: unknown field 'label' specified in initializer:  => 76:2
  + drivers/gpio/gpio-tps65912.c: error: unknown field 'ngpio' specified in initializer:  => 83:2
  + drivers/gpio/gpio-tps65912.c: error: unknown field 'owner' specified in initializer:  => 77:2
  + drivers/gpio/gpio-tps65912.c: error: unknown field 'set' specified in initializer:  => 81:2
  + drivers/gpio/gpio-tps65912.c: error: variable 'template_chip' has initializer but incomplete type:  => 75:15
  + drivers/gpio/gpio-ucb1400.c: error: implicit declaration of function 'gpiochip_add' [-Werror=implicit-function-declaration]:  => 71:2
  + drivers/gpio/gpio-ucb1400.c: error: implicit declaration of function 'gpiochip_remove' [-Werror=implicit-function-declaration]:  => 94:2
  + drivers/gpio/gpio-vx855.c: error: dereferencing pointer to incomplete type:  => 213:3, 218:3, 216:3, 210:3, 214:3, 215:3, 209:3, 208:3, 211:3, 217:3, 212:3
  + drivers/gpio/gpio-vx855.c: error: field 'gpio' has incomplete type:  => 51:19
  + drivers/gpio/gpio-vx855.c: error: implicit declaration of function 'gpiochip_add' [-Werror=implicit-function-declaration]:  => 269:2
  + drivers/gpio/gpio-vx855.c: error: implicit declaration of function 'gpiochip_remove' [-Werror=implicit-function-declaration]:  => 292:2
  + drivers/gpio/gpio-wm831x.c: error: dereferencing pointer to incomplete type:  => 148:22, 147:22
  + drivers/gpio/gpio-wm831x.c: error: field 'gpio_chip' has incomplete type:  => 30:19
  + drivers/gpio/gpio-wm831x.c: error: implicit declaration of function 'gpiochip_add' [-Werror=implicit-function-declaration]:  => 267:2
  + drivers/gpio/gpio-wm831x.c: error: implicit declaration of function 'gpiochip_is_requested' [-Werror=implicit-function-declaration]:  => 157:3
  + drivers/gpio/gpio-wm831x.c: error: implicit declaration of function 'gpiochip_remove' [-Werror=implicit-function-declaration]:  => 282:2
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
  + drivers/gpu/drm/nouveau/nouveau_bo.c: error: implicit declaration of function 'ttm_agp_tt_create' [-Werror=implicit-function-declaration]:  => 463:3
  + drivers/hwmon/gpio-fan.c: error: 'of_gpio_fan_match' undeclared here (not in a function):  => 633:22
  + drivers/input/keyboard/adp5588-keys.c: error: field 'gc' has incomplete type:  => 52:19
  + drivers/input/keyboard/adp5588-keys.c: error: implicit declaration of function 'gpiochip_add' [-Werror=implicit-function-declaration]:  => 204:2
  + drivers/input/keyboard/adp5588-keys.c: error: implicit declaration of function 'gpiochip_remove' [-Werror=implicit-function-declaration]:  => 245:2
  + drivers/input/keyboard/adp5589-keys.c: error: field 'gc' has incomplete type:  => 243:19
  + drivers/input/keyboard/adp5589-keys.c: error: implicit declaration of function 'gpiochip_add' [-Werror=implicit-function-declaration]:  => 529:2
  + drivers/input/keyboard/adp5589-keys.c: error: implicit declaration of function 'gpiochip_remove' [-Werror=implicit-function-declaration]:  => 571:2
  + drivers/input/touchscreen/ad7879.c: error: field 'gc' has incomplete type:  => 115:19
  + drivers/input/touchscreen/ad7879.c: error: implicit declaration of function 'gpiochip_add' [-Werror=implicit-function-declaration]:  => 462:3
  + drivers/input/touchscreen/ad7879.c: error: implicit declaration of function 'gpiochip_remove' [-Werror=implicit-function-declaration]:  => 477:3
  + drivers/leds/leds-gpio.c: error: 'of_gpio_leds_match' undeclared here (not in a function):  => 295:22
  + drivers/leds/leds-pca9532.c: error: field 'gpio' has incomplete type:  => 46:19
  + drivers/leds/leds-pca9532.c: error: implicit declaration of function 'gpiochip_add' [-Werror=implicit-function-declaration]:  => 427:3
  + drivers/leds/leds-pca9532.c: error: implicit declaration of function 'gpiochip_remove' [-Werror=implicit-function-declaration]:  => 324:3
  + drivers/leds/leds-tca6507.c: error: field 'gpio' has incomplete type:  => 179:19
  + drivers/leds/leds-tca6507.c: error: implicit declaration of function 'gpiochip_add' [-Werror=implicit-function-declaration]:  => 640:2
  + drivers/leds/leds-tca6507.c: error: implicit declaration of function 'gpiochip_remove' [-Werror=implicit-function-declaration]:  => 653:3
  + drivers/media/dvb-frontends/cxd2820r_core.c: error: implicit declaration of function 'gpiochip_add' [-Werror=implicit-function-declaration]:  => 725:3
  + drivers/media/dvb-frontends/cxd2820r_core.c: error: implicit declaration of function 'gpiochip_remove' [-Werror=implicit-function-declaration]:  => 577:3
  + drivers/media/dvb-frontends/cxd2820r_priv.h: error: field 'gpio_chip' has incomplete type:  => 48:19
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
  + drivers/staging/dgrp/dgrp_mon_ops.c: error: implicit declaration of function 'copy_to_user' [-Werror=implicit-function-declaration]:  => 304:3
  + drivers/staging/dgrp/dgrp_specproc.c: error: implicit declaration of function 'copy_from_user' [-Werror=implicit-function-declaration]:  => 470:2
  + drivers/staging/dgrp/dgrp_tty.c: error: 'VERIFY_READ' undeclared (first use in this function):  => 2283:20
  + drivers/staging/dgrp/dgrp_tty.c: error: 'VERIFY_WRITE' undeclared (first use in this function):  => 2618:18
  + drivers/staging/dgrp/dgrp_tty.c: error: implicit declaration of function 'access_ok' [-Werror=implicit-function-declaration]:  => 2283:2
  + drivers/staging/dgrp/dgrp_tty.c: error: implicit declaration of function 'copy_from_user' [-Werror=implicit-function-declaration]:  => 1284:4
  + drivers/staging/dgrp/dgrp_tty.c: error: implicit declaration of function 'copy_to_user' [-Werror=implicit-function-declaration]:  => 2474:2
  + drivers/staging/dgrp/dgrp_tty.c: error: implicit declaration of function 'get_user' [-Werror=implicit-function-declaration]:  => 2287:2
  + drivers/staging/dgrp/dgrp_tty.c: error: implicit declaration of function 'put_user' [-Werror=implicit-function-declaration]:  => 2267:2
  + drivers/staging/ipack/devices/ipoctal.c: error: implicit declaration of function 'ioread8' [-Werror=implicit-function-declaration]:  => 141:3
  + drivers/staging/ipack/devices/ipoctal.c: error: implicit declaration of function 'iowrite8' [-Werror=implicit-function-declaration]:  => 64:2
  + drivers/staging/ipack/ipack.c: error: implicit declaration of function 'ioread16be' [-Werror=implicit-function-declaration]:  => 383:3
  + drivers/staging/ipack/ipack.c: error: implicit declaration of function 'ioread8' [-Werror=implicit-function-declaration]:  => 365:2
  + drivers/staging/vme/devices/vme_pio2.h: error: field 'gc' has incomplete type:  => 237:19
  + drivers/staging/vme/devices/vme_pio2_gpio.c: error: implicit declaration of function 'gpiochip_add' [-Werror=implicit-function-declaration]:  => 213:2
  + drivers/staging/vme/devices/vme_pio2_gpio.c: error: implicit declaration of function 'gpiochip_remove' [-Werror=implicit-function-declaration]:  => 226:2
  + drivers/tty/serial/max310x.c: error: field 'gpio' has incomplete type:  => 277:19
  + drivers/tty/serial/max310x.c: error: implicit declaration of function 'gpiochip_add' [-Werror=implicit-function-declaration]:  => 1181:3
  + drivers/tty/serial/max310x.c: error: implicit declaration of function 'gpiochip_remove' [-Werror=implicit-function-declaration]:  => 1223:3
  + error: "backlight_force_update" [drivers/gpu/drm/radeon/radeon.ko] undefined!:  => N/A
  + error: "radeon_legacy_get_backlight_level" [drivers/gpu/drm/radeon/radeon.ko] undefined!:  => N/A
  + error: "radeon_legacy_set_backlight_level" [drivers/gpu/drm/radeon/radeon.ko] undefined!:  => N/A
  + error: No rule to make target /etc/sound/trxpro.hex:  => N/A
  + error: phy_n.c: relocation truncated to fit: R_PPC64_REL24 against symbol `_restgpr0_14' defined in .text.save.restore section in arch/powerpc/lib/built-in.o:  => (.text+0x1ff9b38), (.text+0x1ff79bc)
  + error: relocation truncated to fit: R_PPC64_REL24 against symbol `._mcount' defined in .text section in arch/powerpc/kernel/entry_64.o:  => (.text+0x1ff9b64), (.text+0x1ffa854), (.text+0x1ffc030), (.text+0x1ffbf08), (.text+0x1ffbff0), (.text+0x1ff9c20)
  + error: relocation truncated to fit: R_PPC64_REL24 against symbol `_restgpr0_28' defined in .text.save.restore section in arch/powerpc/lib/built-in.o:  => (.text+0x1ffbfd4)
  + error: relocation truncated to fit: R_PPC64_REL24 against symbol `_savegpr0_28' defined in .text.save.restore section in arch/powerpc/lib/built-in.o:  => (.text+0x1ffbef4)
  + error: vsprintf.c: relocation truncated to fit: R_AVR32_9UW_PCREL against `.text'+adc:  => (.text+0x8de)
  + fs/binfmt_elf_fdpic.c: error: 'ELF_FDPIC_FLAG_ARRANGEMENT' undeclared (first use in this function):  => 1054:27, 777:26
  + fs/binfmt_elf_fdpic.c: error: 'ELF_FDPIC_FLAG_CONSTDISP' undeclared (first use in this function):  => 1065:8, 778:7, 273:24
  + fs/binfmt_elf_fdpic.c: error: 'ELF_FDPIC_FLAG_CONTIGUOUS' undeclared (first use in this function):  => 1080:8, 779:7
  + fs/binfmt_elf_fdpic.c: error: 'ELF_FDPIC_FLAG_EXECUTABLE' undeclared (first use in this function):  => 1049:23, 190:47, 950:22
  + fs/binfmt_elf_fdpic.c: error: 'ELF_FDPIC_FLAG_EXEC_STACK' undeclared (first use in this function):  => 290:26, 152:21
  + fs/binfmt_elf_fdpic.c: error: 'ELF_FDPIC_FLAG_HONOURVADDR' undeclared (first use in this function):  => 1059:8
  + fs/binfmt_elf_fdpic.c: error: 'ELF_FDPIC_FLAG_INDEPENDENT' undeclared (first use in this function):  => 1055:8
  + fs/binfmt_elf_fdpic.c: error: 'ELF_FDPIC_FLAG_NOEXEC_STACK' undeclared (first use in this function):  => 292:31, 154:21
  + fs/binfmt_elf_fdpic.c: error: 'ELF_FDPIC_FLAG_PRESENT' undeclared (first use in this function):  => 190:22
  + fs/binfmt_elf_fdpic.c: error: conflicting types for 'create_elf_fdpic_tables':  => 475:12
  + fs/binfmt_elf_fdpic.c: error: conflicting types for 'elf_fdpic_fetch_phdrs':  => 123:12
  + fs/binfmt_elf_fdpic.c: error: conflicting types for 'elf_fdpic_map_file':  => 738:12
  + fs/binfmt_elf_fdpic.c: error: conflicting types for 'elf_fdpic_map_file_by_direct_mmap':  => 1013:12
  + fs/binfmt_elf_fdpic.c: error: conflicting types for 'elf_fdpic_map_file_constdisp_on_uclinux':  => 921:12
  + fs/binfmt_elf_fdpic.c: error: dereferencing pointer to incomplete type:  => 797:14, 773:20, 559:53, 825:11, 146:15, 628:1731, 836:15, 626:1357, 777:16, 625:1731, 809:16, 800:13, 1049:13, 557:16, 625:1080, 132:12, 846:11, 623:2, 543:57, 152:10, 757:13, 939:13, 552:19, 623:1080, 810:15, 1026:14, 1022:20, 964:13, 559:46, 1112:10, 1030:30, 798:14, 555:17, 938:30, 816:30, 828:12, 136:8, 626:1733, 794:12, 135:15, 768:8, 1054:17, 950:12, 625:2, 808:15, 156:9, 963:30, 1102:14, 628:2, 628:1355, 932:20, 1029:15, 812:30, 628:1080, 937:15, 545:13, 140:35, 933:14, 625:1355, 623:1731, 547:43, 623:1355, 980:10, 756:30, 626:1082, 141:24, 147:30, 837:30, 547:50, 799:11, 130:12, 137:13, 859:16, 626:2, 154:10, 962:15
  + fs/binfmt_elf_fdpic.c: error: implicit declaration of function 'elf_fdpic_arch_lay_out_mm' [-Werror=implicit-function-declaration]:  => 339:2
  + fs/binfmt_elf_fdpic.c: error: storage size of 'exec_params' isn't known:  => 170:26
  + fs/binfmt_elf_fdpic.c: error: storage size of 'interp_params' isn't known:  => 170:39
  + include/linux/basic_mmio_gpio.h: error: field 'gc' has incomplete type:  => 29:19
  + include/linux/coredump.h: error: expected ')' before '*' token:  => 15
  + include/linux/mfd/tps65912.h: error: field 'gpio' has incomplete type:  => 301:19
  + include/linux/spi/max7301.h: error: field 'chip' has incomplete type:  => 15:19
  + include/linux/ucb1400.h: error: field 'gc' has incomplete type:  => 93:19
  + kernel/task_work.c: error: implicit declaration of function 'read_barrier_depends' [-Werror=implicit-function-declaration]:  => 38:3
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

945 improvements:
  - arch/powerpc/platforms/512x/mpc512x_shared.c: error: 'FSL_DIU_PORT_DVI' undeclared (first use in this function): 189:9 => 
  - arch/powerpc/platforms/512x/mpc512x_shared.c: error: parameter 1 ('port') has incomplete type: 187:54, 83:56, 88:57, 69:56 => 
  - arch/powerpc/platforms/512x/mpc512x_shared.c: error: return type is an incomplete type: 187:1 => 
  - arch/xtensa/kernel/pci.c: error: '_PAGE_NO_CACHE' undeclared (first use in this function): 344:11 => 
  - drivers/isdn/hisax/enternow_pci.c: error: #error "not running on big endian machines now": 398:2 => 
  - drivers/isdn/hisax/hfc_pci.c: error: #error "not running on big endian machines now": 1647:2 => 
  - drivers/isdn/hisax/nj_s.c: error: #error "not running on big endian machines now": 269:2 => 
  - drivers/isdn/hisax/nj_u.c: error: #error "not running on big endian machines now": 232:2 => 
  - drivers/isdn/hisax/telespci.c: error: #error "not running on big endian machines now": 295:2 => 
  - drivers/net/can/usb/peak_usb/pcan_usb_core.c: error: conflicting types for 'dump_mem': 56:6 => 
  - drivers/net/can/usb/peak_usb/pcan_usb_core.h: error: conflicting types for 'dump_mem': 134:6 => 
  - drivers/net/ethernet/realtek/r8169.c: error: expected identifier before numeric constant: 451:2 => 
  - drivers/staging/xgifb/../../video/sis/vstruct.h: error: expected identifier or '(' before numeric constant: 135:16 => 
  - drivers/staging/xgifb/vb_setmode.c: error: expected identifier before numeric constant: 6533:104 => 
  - drivers/usb/misc/sisusbvga/sisusb_init.c: error: expected identifier before numeric constant: 372:68 => 
  - drivers/usb/misc/sisusbvga/sisusb_struct.h: error: expected identifier or '(' before numeric constant: 72:16 => 
  - drivers/video/sis/init.c: error: expected identifier before numeric constant: 1867:56 => 
  - drivers/video/sis/vstruct.h: error: expected identifier or '(' before numeric constant: 135:16 => 
  - error: No rule to make target /scratch/kisskb/build/linus_m68k-allmodconfig_m68k/usr/include/linux/kvm_para.h: N/A => 
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
  - error: fore200e.c: relocation truncated to fit: R_PPC64_REL24 against symbol `.ktime_get_real' defined in .text section in kernel/built-in.o: (.text+0x1ff8c1c) => 
  - error: fore200e.c: relocation truncated to fit: R_PPC64_REL24 against symbol `.msecs_to_jiffies' defined in .text section in kernel/built-in.o: (.text+0x1ff935c) => 
  - error: fore200e.c: relocation truncated to fit: R_PPC64_REL24 against symbol `.panic' defined in .text.unlikely section in kernel/built-in.o: (.text+0x1ff9ed8) => 
  - error: fore200e.c: relocation truncated to fit: R_PPC64_REL24 against symbol `_restgpr0_14' defined in .text.save.restore section in arch/powerpc/lib/built-in.o: (.text+0x1ff8a60) => 
  - error: fore200e.c: relocation truncated to fit: R_PPC64_REL24 against symbol `_restgpr0_22' defined in .text.save.restore section in arch/powerpc/lib/built-in.o: (.text+0x1ff9124) => 
  - error: fore200e.c: relocation truncated to fit: R_PPC64_REL24 against symbol `_restgpr0_25' defined in .text.save.restore section in arch/powerpc/lib/built-in.o: (.text+0x1ff9644) => 
  - error: fore200e.c: relocation truncated to fit: R_PPC64_REL24 against symbol `_savegpr0_20' defined in .text.save.restore section in arch/powerpc/lib/built-in.o: (.text+0x1ff8a68) => 
  - error: fore200e.c: relocation truncated to fit: R_PPC64_REL24 against symbol `_savegpr0_23' defined in .text.save.restore section in arch/powerpc/lib/built-in.o: (.text+0x1ff964c) => 
  - error: fore200e.c: relocation truncated to fit: R_PPC64_REL24 against symbol `_savegpr0_27' defined in .text.save.restore section in arch/powerpc/lib/built-in.o: (.text+0x1ff912c) => 
  - error: fore200e.c: relocation truncated to fit: R_PPC64_REL24 against symbol `_savegpr0_29' defined in .text.save.restore section in arch/powerpc/lib/built-in.o: (.text+0x1ff91b0) => 
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
  - error: vsprintf.c: relocation truncated to fit: R_AVR32_9UW_PCREL against `.text'+b28: (.text+0x92a) => 
  - include/linux/gpio.h: error: redefinition of 'gpio_cansleep': 60:90 => 
  - net/bluetooth/rfcomm/tty.c: error: array type has incomplete element type: 838:125, 834:125 => 
  - net/bluetooth/rfcomm/tty.c: error: invalid application of 'sizeof' to incomplete type 'struct serial_struct' : 838:153, 834:86, 838:86, 834:197, 834:153, 838:197 => 


*** WARNINGS ***

1167 regressions:
  + .config: warning: override: MELAN changes choice state:  => 283
  + arch/alpha/kernel/osf_sys.c: warning: passing argument 1 of 'osf_cdfs_mount' discards qualifiers from pointer target type:  => 513
  + arch/alpha/kernel/osf_sys.c: warning: passing argument 1 of 'osf_procfs_mount' discards qualifiers from pointer target type:  => 516
  + arch/alpha/kernel/osf_sys.c: warning: passing argument 1 of 'osf_ufs_mount' discards qualifiers from pointer target type:  => 510
  + arch/avr32/include/asm/param.h: warning: "HZ" redefined:  => 6:1
  + arch/avr32/include/uapi/asm/param.h: warning: this is the location of the previous definition:  => 6:1
  + arch/cris/include/asm/atomic.h: warning: 'cli' may be used uninitialized in this function [-Wuninitialized]:  => 83:4
  + arch/frv/mm/elf-fdpic.c: warning: 'struct elf_fdpic_params' declared inside parameter list [enabled by default]:  => 26:11
  + arch/frv/mm/elf-fdpic.c: warning: its scope is only this definition or declaration, which is probably not what you want [enabled by default]:  => 26:11
  + arch/mn10300/mm/dma-alloc.c: warning: format '%zu' expects argument of type 'size_t', but argument 3 has type 'unsigned int' [-Wformat]:  => 29:2
  + arch/tile/kernel/module.c: warning: "ELF_R_SYM" redefined [enabled by default]:  => 29:0
  + arch/tile/kernel/module.c: warning: "ELF_R_TYPE" redefined [enabled by default]:  => 30:0
  + block/blk-sysfs.c: warning: 'val' may be used uninitialized in this function:  => 246, 244, 245
  + drivers/ata/libahci.c: warning: value computed is not used [-Wunused-value]:  => 831:453, 576:476, 697:478, 1446:477, 1258:507, 629:476
  + drivers/ata/pata_pdc2027x.c: warning: value computed is not used [-Wunused-value]:  => 614:491, 631:491
  + drivers/ata/sata_highbank.c: warning: 'ahci_highbank_resume' defined but not used [-Wunused-function]:  => 412:12
  + drivers/ata/sata_highbank.c: warning: 'ahci_highbank_suspend' defined but not used [-Wunused-function]:  => 382:12
  + drivers/ata/sata_promise.c: warning: value computed is not used [-Wunused-value]:  => 401:521, 1027:481, 743:506, 397:521, 754:486, 456:456, 780:506, 926:486, 760:486, 722:486, 1169:496, 1032:501
  + drivers/ata/sata_qstor.c: warning: value computed is not used [-Wunused-value]:  => 327:461
  + drivers/ata/sata_sil.c: warning: value computed is not used [-Wunused-value]:  => 388:396, 563:486
  + drivers/ata/sata_sx4.c: warning: value computed is not used [-Wunused-value]:  => 757:558, 547:421, 1336:481, 1100:492, 908:396, 578:551, 675:557, 1244:496, 1089:492, 1097:512, 884:466, 1437:491, 754:553, 1430:491, 581:506, 1252:497, 1086:512, 1121:496, 671:552, 1297:491, 1221:496, 867:466, 1073:511, 1080:491, 512:421
  + drivers/block/cciss.h: warning: value computed is not used [-Wunused-value]:  => 227:451
  + drivers/block/mtip32xx/mtip32xx.c: warning: value computed is not used [-Wunused-value]:  => 361:481, 336:481, 1723:471, 507:501, 494:501, 264:471
  + drivers/block/rbd.c: warning: 'tail' may be used uninitialized in this function [-Wuninitialized]:  => 856:18
  + drivers/block/sx8.c: warning: value computed is not used [-Wunused-value]:  => 1467:456, 502:457, 1450:456
  + drivers/bluetooth/btwilink.c: warning: overflow in implicit constant conversion [-Woverflow]:  => 179:3
  + drivers/gpio/gpio-74x164.c: warning: initialization from incompatible pointer type [enabled by default]:  => 33:79
  + drivers/gpio/gpio-adp5588.c: warning: (near initialization for 'dev') [enabled by default]:  => 80:73, 119:73, 101:73, 69:73
  + drivers/gpio/gpio-adp5588.c: warning: initialization from incompatible pointer type [enabled by default]:  => 80:73, 119:73, 101:73, 69:73
  + drivers/gpio/gpio-amd8111.c: warning: (near initialization for 'agp') [enabled by default]:  => 103:83, 82:83, 94:83, 118:83, 130:83, 147:83
  + drivers/gpio/gpio-amd8111.c: warning: initialization from incompatible pointer type [enabled by default]:  => 103:83, 82:83, 94:83, 118:83, 130:83, 147:83
  + drivers/gpio/gpio-arizona.c: warning: (near initialization for 'template_chip') [enabled by default]:  => 91:2, 89:2, 92:2, 93:2, 88:2, 90:2, 94:2
  + drivers/gpio/gpio-arizona.c: warning: control reaches end of non-void function [-Wreturn-type]:  => 149:1
  + drivers/gpio/gpio-arizona.c: warning: excess elements in struct initializer [enabled by default]:  => 91:2, 89:2, 92:2, 93:2, 88:2, 90:2, 94:2
  + drivers/gpio/gpio-arizona.c: warning: initialization from incompatible pointer type [enabled by default]:  => 33:76
  + drivers/gpio/gpio-da9052.c: warning: (near initialization for 'reference_gp') [enabled by default]:  => 193:2, 192:2, 201:2, 194:2, 195:2, 197:2, 198:2, 200:2, 199:2, 196:2
  + drivers/gpio/gpio-da9052.c: warning: control reaches end of non-void function [-Wreturn-type]:  => 237:1
  + drivers/gpio/gpio-da9052.c: warning: excess elements in struct initializer [enabled by default]:  => 193:2, 192:2, 201:2, 194:2, 195:2, 197:2, 198:2, 200:2, 199:2, 196:2
  + drivers/gpio/gpio-da9052.c: warning: initialization from incompatible pointer type [enabled by default]:  => 56:68
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
  + drivers/gpio/gpio-pcf857x.c: warning: initialization from incompatible pointer type [enabled by default]:  => 165:82, 119:82, 141:82, 132:82
  + drivers/gpio/gpio-rdc321x.c: warning: initialization from incompatible pointer type [enabled by default]:  => 50:71, 86:71, 68:71, 99:71
  + drivers/gpio/gpio-stmpe.c: warning: (near initialization for 'template_chip') [enabled by default]:  => 126:2, 128:2, 125:2, 121:2, 129:2, 122:20, 127:2, 124:2, 123:2
  + drivers/gpio/gpio-stmpe.c: warning: excess elements in struct initializer [enabled by default]:  => 126:2, 128:2, 125:2, 121:2, 129:2, 122:20, 127:2, 124:2, 123:2
  + drivers/gpio/gpio-stmpe.c: warning: initialization from incompatible pointer type [enabled by default]:  => 42:69
  + drivers/gpio/gpio-timberdale.c: warning: (near initialization for 'tgpio') [enabled by default]:  => 101:85, 80:85, 56:85
  + drivers/gpio/gpio-timberdale.c: warning: initialization from incompatible pointer type [enabled by default]:  => 101:85, 80:85, 56:85
  + drivers/gpio/gpio-tps65912.c: warning: (near initialization for 'template_chip') [enabled by default]:  => 80:2, 81:2, 84:2, 79:2, 83:2, 82:2, 77:2, 76:2, 78:2
  + drivers/gpio/gpio-tps65912.c: warning: (near initialization for 'tps65912') [enabled by default]:  => 45:88, 69:88, 58:88, 31:88
  + drivers/gpio/gpio-tps65912.c: warning: control reaches end of non-void function [-Wreturn-type]:  => 121:1
  + drivers/gpio/gpio-tps65912.c: warning: excess elements in struct initializer [enabled by default]:  => 80:2, 81:2, 84:2, 79:2, 83:2, 82:2, 77:2, 76:2, 78:2
  + drivers/gpio/gpio-tps65912.c: warning: initialization from incompatible pointer type [enabled by default]:  => 45:88, 69:88, 58:88, 31:88
  + drivers/gpio/gpio-ucb1400.c: warning: initialization from incompatible pointer type [enabled by default]:  => 37:69, 20:69, 44:69, 28:69
  + drivers/gpio/gpio-vx855.c: warning: (near initialization for 'vg') [enabled by default]:  => 125:86, 101:86, 151:86
  + drivers/gpio/gpio-vx855.c: warning: initialization from incompatible pointer type [enabled by default]:  => 125:86, 101:86, 151:86
  + drivers/gpio/gpio-wm831x.c: warning: (near initialization for 'template_chip') [enabled by default]:  => 240:2, 235:2, 234:2, 241:2, 236:2, 239:2, 238:2, 237:2, 243:2, 242:2
  + drivers/gpio/gpio-wm831x.c: warning: assignment makes pointer from integer without a cast [enabled by default]:  => 157:9
  + drivers/gpio/gpio-wm831x.c: warning: control reaches end of non-void function [-Wreturn-type]:  => 283:1
  + drivers/gpio/gpio-wm831x.c: warning: excess elements in struct initializer [enabled by default]:  => 240:2, 235:2, 234:2, 241:2, 236:2, 239:2, 238:2, 237:2, 243:2, 242:2
  + drivers/gpio/gpio-wm831x.c: warning: initialization from incompatible pointer type [enabled by default]:  => 35:75
  + drivers/gpio/gpiolib.c: warning: 'gpio_desc' defined but not used [-Wunused-variable]:  => 73:25
  + drivers/gpio/gpiolib.c: warning: control reaches end of non-void function [-Wreturn-type]:  => 1382:1, 580:1, 1695:1, 571:1, 122:1, 589:1, 1713:1
  + drivers/gpu/drm/drm_edid_load.c: warning: 'edid' may be used uninitialized in this function [-Wuninitialized]:  => 122:29
  + drivers/gpu/drm/gma500/backlight.c: warning: 'do_gma_backlight_set' defined but not used [-Wunused-function]:  => 29:13
  + drivers/gpu/drm/nouveau/core/engine/graph/ctxnv40.c: warning: the frame size of 1184 bytes is larger than 1024 bytes [-Wframe-larger-than=]:  => 689:1
  + drivers/gpu/drm/nouveau/core/subdev/bios/base.c: warning: unused variable 'i' [-Wunused-variable]:  => 66:12
  + drivers/gpu/drm/nouveau/nouveau_bo.c: warning: return makes pointer from integer without a cast [enabled by default]:  => 463:3
  + drivers/gpu/drm/r128/r128_cce.c: warning: value computed is not used [-Wunused-value]:  => 283:611, 335:611, 285:611, 234:611
  + drivers/gpu/drm/r128/r128_state.c: warning: value computed is not used [-Wunused-value]:  => 130:1314, 951:1316, 1177:1315, 46:1374, 1336:1194, 1070:1316, 659:1315, 813:1314, 1513:1194, 414:1316, 1603:1194, 614:1315, 515:1314, 1534:1194, 384:1316, 393:1316, 1286:1195, 104:1316, 146:1314, 556:1314, 89:1314, 1216:1316, 866:1314, 1388:1194, 927:1317, 753:1315, 1046:1317, 1453:1194, 1313:1194, 435:1316, 536:1314, 165:1314, 672:1315, 1481:1194, 479:1315, 207:1324, 595:1316, 1115:1314, 1248:1194, 182:1324
  + drivers/gpu/drm/radeon/r600_cp.c: warning: value computed is not used [-Wunused-value]:  => 1798:611, 585:611, 501:611, 408:611, 582:611
  + drivers/gpu/drm/radeon/radeon_cp.c: warning: value computed is not used [-Wunused-value]:  => 2253:612, 736:611, 2249:612, 727:611
  + drivers/gpu/drm/via/via_dma.c: warning: value computed is not used [-Wunused-value]:  => 460:618, 548:616
  + drivers/gpu/drm/via/via_dmablit.c: warning: value computed is not used [-Wunused-value]:  => 222:686
  + drivers/i2c/busses/i2c-eg20t.c: warning: value computed is not used [-Wunused-value]:  => 578:417
  + drivers/i2c/busses/i2c-intel-mid.c: warning: value computed is not used [-Wunused-value]:  => 889:456, 347:456, 351:456, 911:457, 595:456, 348:456, 346:456, 1043:461, 354:456, 506:456, 777:456, 345:456, 542:456, 350:456, 349:456, 353:456, 352:456
  + drivers/ide/siimage.c: warning: value computed is not used [-Wunused-value]:  => 476:443
  + drivers/infiniband/hw/nes/nes_hw.c: warning: 'nes_iwarp_state_str' defined but not used [-Wunused-variable]:  => 82:23
  + drivers/infiniband/hw/nes/nes_hw.c: warning: 'nes_tcp_state_str' defined but not used [-Wunused-variable]:  => 93:23
  + drivers/input/keyboard/adp5588-keys.c: warning: (near initialization for 'kpad') [enabled by default]:  => 87:90, 77:90, 106:90, 124:90
  + drivers/input/keyboard/adp5588-keys.c: warning: initialization from incompatible pointer type [enabled by default]:  => 87:90, 77:90, 106:90, 124:90
  + drivers/input/keyboard/adp5589-keys.c: warning: (near initialization for 'kpad') [enabled by default]:  => 403:90, 442:90, 391:90, 422:90
  + drivers/input/keyboard/adp5589-keys.c: warning: initialization from incompatible pointer type [enabled by default]:  => 403:90, 442:90, 391:90, 422:90
  + drivers/input/keyboard/gpio_keys_polled.c: warning: 'flags' may be used uninitialized in this function [-Wuninitialized]:  => 150:22
  + drivers/input/misc/rotary_encoder.c: warning: 'flags' may be used uninitialized in this function [-Wuninitialized]:  => 173:28
  + drivers/input/touchscreen/ad7879.c: warning: (near initialization for 'ts') [enabled by default]:  => 431:76, 385:76, 418:76, 399:76
  + drivers/input/touchscreen/ad7879.c: warning: initialization from incompatible pointer type [enabled by default]:  => 431:76, 385:76, 418:76, 399:76
  + drivers/leds/leds-pca9532.c: warning: (near initialization for 'data') [enabled by default]:  => 259:92, 272:92, 248:92
  + drivers/leds/leds-pca9532.c: warning: initialization from incompatible pointer type [enabled by default]:  => 259:92, 272:92, 248:92
  + drivers/leds/leds-tca6507.c: warning: (near initialization for 'tca') [enabled by default]:  => 591:91
  + drivers/leds/leds-tca6507.c: warning: initialization from incompatible pointer type [enabled by default]:  => 591:91
  + drivers/media/common/saa7146/saa7146_core.c: warning: value computed is not used [-Wunused-value]:  => 122:457, 87:457
  + drivers/media/dvb-frontends/cxd2820r_core.c: warning: (near initialization for 'priv') [enabled by default]:  => 632:72, 602:72, 616:72
  + drivers/media/dvb-frontends/cxd2820r_core.c: warning: initialization from incompatible pointer type [enabled by default]:  => 632:72, 602:72, 616:72
  + drivers/media/dvb-frontends/drxk_hard.c: warning: 'status' may be used uninitialized in this function [-Wuninitialized]:  => 5467:5
  + drivers/media/pci/bt8xx/bttv-i2c.c: warning: value computed is not used [-Wunused-value]:  => 81:491, 69:491
  + drivers/media/pci/cx88/cx88-blackbird.c: warning: value computed is not used [-Wunused-value]:  => 286:521, 244:521, 300:521, 285:521, 245:521, 259:521
  + drivers/media/pci/cx88/cx88-i2c.c: warning: value computed is not used [-Wunused-value]:  => 77:521, 65:521
  + drivers/media/pci/cx88/cx88-vp3054-i2c.c: warning: value computed is not used [-Wunused-value]:  => 71:521, 54:521
  + drivers/media/pci/ivtv/ivtv-driver.c: warning: 'flush_work_sync' is deprecated (declared at /scratch/kisskb/src/include/linux/workqueue.h:448) [-Wdeprecated-declarations]:  => 307:2
  + drivers/media/pci/ivtv/ivtv-driver.c: warning: value computed is not used [-Wunused-value]:  => 323:876, 1389:829, 317:876
  + drivers/media/pci/ivtv/ivtv-irq.c: warning: value computed is not used [-Wunused-value]:  => 195:2798, 299:873, 451:4260, 199:2720, 435:4260, 296:951
  + drivers/media/pci/ivtv/ivtv-mailbox.c: warning: value computed is not used [-Wunused-value]:  => 308:734, 197:781, 152:853, 199:864, 209:793, 324:732, 194:798, 193:732
  + drivers/media/pci/ivtv/ivtv-udma.c: warning: value computed is not used [-Wunused-value]:  => 218:4260
  + drivers/media/pci/ivtv/ivtv-yuv.c: warning: value computed is not used [-Wunused-value]:  => 948:828
  + drivers/media/pci/saa7134/saa7134-tvaudio.c: warning: value computed is not used [-Wunused-value]:  => 360:501, 347:503, 366:501
  + drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c: warning: (near initialization for 'sh_mobile_ceu_host_ops.set_livecrop') [enabled by default]:  => 2040:2
  + drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c: warning: initialization discards 'const' qualifier from pointer target type [enabled by default]:  => 1522:27, 1269:49
  + drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c: warning: initialization from incompatible pointer type [enabled by default]:  => 2040:2
  + drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c: warning: passing argument 2 of 'client_s_crop' discards 'const' qualifier from pointer target type [enabled by default]:  => 1548:2
  + drivers/media/radio/radio-shark.c: warning: 'shark_resume_leds' defined but not used [-Wunused-function]:  => 274:13
  + drivers/media/radio/radio-shark2.c: warning: 'shark_resume_leds' defined but not used [-Wunused-function]:  => 240:13
  + drivers/media/radio/wl128x/fmdrv_common.c: warning: large integer implicitly truncated to unsigned type [-Woverflow]:  => 1512:3
  + drivers/media/usb/dvb-usb-v2/dvb_usb_core.c: warning: 'ret' may be used uninitialized in this function [-Wuninitialized]:  => 291:12
  + drivers/media/usb/pwc/pwc-if.c: warning: ignoring return value of 'vb2_queue_init', declared with attribute warn_unused_result [-Wunused-result]:  => 1003:16
  + drivers/media/usb/uvc/uvc_video.c: warning: format '%lu' expects argument of type 'long unsigned int', but argument 9 has type '__kernel_suseconds_t' [-Wformat]:  => 678:2
  + drivers/memstick/host/tifm_ms.c: warning: value computed is not used [-Wunused-value]:  => 248:502
  + drivers/message/fusion/mptbase.c: warning: value computed is not used [-Wunused-value]:  => 2108:481, 2716:481
  + drivers/mfd/sm501.c: warning: (near initialization for 'gpio_chip_template') [enabled by default]:  => 1013:2, 1012:2, 1011:2, 1014:2, 1010:2
  + drivers/mfd/sm501.c: warning: excess elements in struct initializer [enabled by default]:  => 1013:2, 1012:2, 1011:2, 1014:2, 1010:2
  + drivers/mfd/sm501.c: warning: initialization from incompatible pointer type [enabled by default]:  => 884:74
  + drivers/mfd/sm501.c: warning: value computed is not used [-Wunused-value]:  => 234:416
  + drivers/mfd/syscon.c: warning: format '%x' expects argument of type 'unsigned int', but argument 3 has type 'resource_size_t' [-Wformat]:  => 135:2
  + drivers/mfd/syscon.c: warning: format '%x' expects argument of type 'unsigned int', but argument 4 has type 'resource_size_t' [-Wformat]:  => 135:2
  + drivers/mfd/tps65010.c: warning: initialization from incompatible pointer type [enabled by default]:  => 496:66, 479:67
  + drivers/misc/ics932s401.c: warning: 'x' may be used uninitialized in this function [-Wuninitialized]: 384:2 => 384:2, 384:16
  + drivers/misc/phantom.c: warning: value computed is not used [-Wunused-value]:  => 145:428, 448:461, 396:461, 74:462, 125:427, 77:462, 315:426
  + drivers/mtd/chips/cfi_cmdset_0002.c: warning: 'r.x[0]' may be used uninitialized in this function [-Wuninitialized]: 1364:7, 1787:7, 665:2, 1425:9, 1404:93 => 727:2, 1471:93, 1493:15, 1492:9, 1854:7, 1431:7
  + drivers/mtd/nand/denali.c: warning: value computed is not used [-Wunused-value]:  => 1002:501
  + drivers/net/ethernet/3com/typhoon.c: warning: value computed is not used [-Wunused-value]:  => 2238:441, 1388:474, 1429:476, 1754:495, 2228:442, 394:474, 1493:474, 1776:475, 1939:474, 1478:474, 631:494
  + drivers/net/ethernet/adaptec/starfire.c: warning: value computed is not used [-Wunused-value]:  => 1307:474, 1914:456
  + drivers/net/ethernet/alteon/acenic.c: warning: value computed is not used [-Wunused-value]:  => 2979:456, 3025:457, 3052:456, 943:452, 3020:457, 3077:456, 898:451, 915:451, 1461:446, 3072:456, 3067:456, 975:451, 3189:456, 3044:456, 3168:457, 2143:436, 921:446, 3182:456, 3152:457, 2989:456, 3014:457, 1475:447, 2984:456, 3004:456, 3157:457, 3186:456, 1490:437, 623:446, 3082:456, 2974:456, 2969:456, 3174:458, 3039:456
  + drivers/net/ethernet/amd/amd8111e.c: warning: value computed is not used [-Wunused-value]:  => 1408:451, 517:421, 639:451, 607:431, 1611:451, 1600:451, 627:451
  + drivers/net/ethernet/atheros/atl1c/atl1c_ethtool.c: warning: value computed is not used [-Wunused-value]:  => 158:539, 159:539, 155:539, 149:539, 166:539, 162:554, 151:539, 163:539, 160:554, 164:539, 147:534, 145:539, 148:534, 154:539, 146:539, 150:539, 152:539, 161:539, 165:539, 153:529, 156:539, 157:539
  + drivers/net/ethernet/atheros/atl1c/atl1c_hw.c: warning: value computed is not used [-Wunused-value]:  => 180:540, 519:539, 40:539, 349:539, 781:539, 164:539, 783:539, 181:540, 103:446, 124:536, 175:540, 782:539, 576:540, 269:540, 70:539, 119:535, 71:559, 531:443, 96:539, 36:539, 528:443
  + drivers/net/ethernet/atheros/atl1c/atl1c_main.c: warning: value computed is not used [-Wunused-value]:  => 1202:539, 1579:540, 80:539, 158:539, 1465:625, 1242:539, 1474:625, 1263:539, 1259:539, 1184:539, 1300:539, 178:494, 682:529, 103:530, 113:540, 1201:539, 96:540, 141:539, 1178:539, 1380:539, 86:540, 440:599, 109:540, 1203:539, 129:529, 191:493, 215:540, 394:539, 1246:443, 1174:539
  + drivers/net/ethernet/atheros/atl1e/atl1e_main.c: warning: value computed is not used [-Wunused-value]:  => 1320:445, 101:494, 113:493, 126:493
  + drivers/net/ethernet/atheros/atlx/atl1.c: warning: value computed is not used [-Wunused-value]:  => 368:476, 616:476, 414:471, 338:466, 280:476
  + drivers/net/ethernet/atheros/atlx/atl2.c: warning: value computed is not used [-Wunused-value]:  => 639:443, 360:495, 2707:442, 629:444, 350:492
  + drivers/net/ethernet/atheros/atlx/atlx.c: warning: value computed is not used [-Wunused-value]:  => 162:516
  + drivers/net/ethernet/broadcom/bnx2.c: warning: value computed is not used [-Wunused-value]:  => 5816:496, 539:497, 501:497, 4751:497, 5051:496, 3335:496, 607:496, 6214:496, 5790:496, 558:497, 588:497, 5969:496, 3439:497
  + drivers/net/ethernet/broadcom/bnx2x/bnx2x_ethtool.c: warning: value computed is not used [-Wunused-value]:  => 1991:593
  + drivers/net/ethernet/broadcom/bnx2x/bnx2x_init_ops.h: warning: value computed is not used [-Wunused-value]:  => 260:498
  + drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c: warning: value computed is not used [-Wunused-value]:  => 6020:512, 9225:491, 9215:491, 7324:562, 6242:506, 6719:516
  + drivers/net/ethernet/broadcom/cnic.c: warning: value computed is not used [-Wunused-value]:  => 4490:501
  + drivers/net/ethernet/broadcom/tg3.c: warning: value computed is not used [-Wunused-value]:  => 547:397, 452:446
  + drivers/net/ethernet/brocade/bna/bfa_ioc.c: warning: value computed is not used [-Wunused-value]:  => 1130:411, 1906:506, 1723:526, 1185:501
  + drivers/net/ethernet/brocade/bna/bfa_ioc_ct.c: warning: value computed is not used [-Wunused-value]:  => 895:508, 890:508, 188:481, 614:451, 189:501, 471:501
  + drivers/net/ethernet/calxeda/xgmac.c: warning: value computed is not used [-Wunused-value]:  => 1357:472
  + drivers/net/ethernet/chelsio/cxgb/espi.c: warning: value computed is not used [-Wunused-value]:  => 170:512, 136:511
  + drivers/net/ethernet/chelsio/cxgb/sge.c: warning: value computed is not used [-Wunused-value]:  => 1962:496, 1985:496, 755:472
  + drivers/net/ethernet/chelsio/cxgb/subr.c: warning: value computed is not used [-Wunused-value]:  => 866:481
  + drivers/net/ethernet/dec/tulip/de2104x.c: warning: value computed is not used [-Wunused-value]:  => 1267:481, 855:477, 1775:412, 1767:412, 1778:412, 1202:477, 1771:411, 1765:412, 878:477
  + drivers/net/ethernet/dec/tulip/eeprom.c: warning: value computed is not used [-Wunused-value]:  => 369:411, 365:412, 363:412, 373:412, 376:412
  + drivers/net/ethernet/dec/tulip/media.c: warning: value computed is not used [-Wunused-value]:  => 264:450, 291:450, 305:449, 103:422, 71:442, 84:422, 100:422, 160:422, 86:422, 70:442, 145:422, 158:422, 151:422, 153:422, 93:422, 278:449, 95:422, 143:422
  + drivers/net/ethernet/dec/tulip/tulip_core.c: warning: value computed is not used [-Wunused-value]:  => 1519:441
  + drivers/net/ethernet/dec/tulip/winbond-840.c: warning: value computed is not used [-Wunused-value]:  => 517:412, 519:412, 563:422, 594:422, 591:422, 584:422, 619:422, 565:422, 522:411, 624:422, 526:412, 586:422, 617:422, 626:422, 529:412
  + drivers/net/ethernet/dlink/dl2k.c: warning: value computed is not used [-Wunused-value]:  => 1075:501, 1055:506, 1051:481, 1050:486, 1010:511, 1049:486, 1074:501, 1054:511, 1017:501, 1021:501, 1019:511, 1056:501, 1071:511, 1057:501, 1052:481, 1069:501, 1077:521, 1076:511, 1018:501, 1008:501, 1020:521
  + drivers/net/ethernet/dlink/sundance.c: warning: value computed is not used [-Wunused-value]:  => 709:452
  + drivers/net/ethernet/fealnx.c: warning: value computed is not used [-Wunused-value]:  => 1143:437
  + drivers/net/ethernet/icplus/ipg.c: warning: value computed is not used [-Wunused-value]:  => 1035:451
  + drivers/net/ethernet/intel/e1000/e1000_ethtool.c: warning: value computed is not used [-Wunused-value]:  => 913:703, 895:704, 931:704, 1437:703, 876:702, 943:702
  + drivers/net/ethernet/intel/e1000/e1000_hw.c: warning: value computed is not used [-Wunused-value]:  => 3843:703, 1006:703, 3613:702, 2759:703, 3652:703, 4476:703, 4346:703, 4434:702, 3829:703, 614:703, 4455:703, 3849:703, 3777:703, 3805:703, 589:703, 601:703, 4432:702, 4450:703, 3097:703, 1013:703, 3789:703, 2796:702, 924:702, 449:703, 434:702, 3102:703, 3112:703, 4344:703, 3116:703, 1932:702, 3597:702, 2718:702, 496:703, 3756:703, 4452:703, 3783:703, 3795:703, 2703:702, 3801:703
  + drivers/net/ethernet/intel/e1000/e1000_main.c: warning: value computed is not used [-Wunused-value]:  => 525:702, 3805:702, 2340:702, 2324:703, 2172:702, 310:702, 324:702, 2394:704, 2188:702, 2326:703
  + drivers/net/ethernet/intel/igb/e1000_82575.c: warning: value computed is not used [-Wunused-value]:  => 1671:482, 1600:483, 1585:482, 1571:482, 1578:482, 1558:482, 1594:482, 1588:482, 1673:482, 1595:482, 2260:477, 1556:482, 1579:482, 1559:482, 1565:482, 1582:482, 1581:482, 1568:482, 1590:482, 1572:482, 1557:482, 1583:482, 1550:482, 1591:482, 1553:482, 1555:482, 1567:482, 1592:482, 1570:482, 1589:482, 1577:482, 1560:482, 1552:482, 1587:482, 1574:482, 1586:482, 1561:482, 1575:482, 2259:477, 1551:482, 1580:482, 1566:482, 1593:482, 1554:482, 1564:482, 1672:482, 1563:482
  + drivers/net/ethernet/intel/igb/e1000_mac.c: warning: value computed is not used [-Wunused-value]:  => 515:482, 501:482, 496:482, 508:482, 521:482, 494:482, 507:482, 502:482, 493:482, 512:482, 490:482, 500:482, 510:482, 509:482, 491:482, 499:482, 511:482, 514:482, 517:482, 505:482, 504:482, 486:482, 498:482, 520:482, 495:482, 488:482, 506:482, 519:482, 487:482, 503:482, 489:482, 492:482, 518:482, 497:482, 522:482, 513:482, 516:482
  + drivers/net/ethernet/intel/igb/igb_main.c: warning: value computed is not used [-Wunused-value]:  => 2541:482, 4675:482, 1500:482, 4645:482
  + drivers/net/ethernet/intel/igbvf/netdev.c: warning: value computed is not used [-Wunused-value]:  => 1334:481, 1652:481, 1253:481, 1493:481, 1459:481, 985:481
  + drivers/net/ethernet/intel/ixgb/ixgb_ee.c: warning: value computed is not used [-Wunused-value]:  => 249:493, 117:494, 224:493, 218:493, 79:493, 230:493, 60:493, 255:493, 212:493
  + drivers/net/ethernet/intel/ixgb/ixgb_hw.c: warning: value computed is not used [-Wunused-value]:  => 153:493, 1225:493
  + drivers/net/ethernet/intel/ixgb/ixgb_main.c: warning: value computed is not used [-Wunused-value]:  => 201:543, 184:543
  + drivers/net/ethernet/intel/ixgbe/ixgbe_82598.c: warning: value computed is not used [-Wunused-value]:  => 1002:501, 786:501, 980:501
  + drivers/net/ethernet/intel/ixgbe/ixgbe_82599.c: warning: value computed is not used [-Wunused-value]:  => 1086:501, 1695:501, 446:501, 1082:501, 1653:501, 1114:501, 1622:501, 465:501, 1146:501, 594:502, 1071:501, 127:503, 1112:501, 958:501, 1095:501, 1717:501, 1110:501, 1673:502, 1111:501, 541:502, 1113:501, 1092:501
  + drivers/net/ethernet/intel/ixgbe/ixgbe_common.c: warning: value computed is not used [-Wunused-value]:  => 2590:501, 2638:501, 415:588, 374:573, 422:588, 410:501, 1596:501, 405:501, 416:588, 396:501, 343:501, 2661:501, 386:501, 1543:501, 2631:502, 378:501, 1428:501, 419:588, 383:501, 357:502, 1487:501, 388:501, 365:573, 384:501, 399:501, 350:501, 407:501, 346:572, 380:501, 355:502, 1319:503, 362:572, 421:588, 381:501, 393:501, 368:573, 1483:501, 382:501, 387:501, 408:501, 418:583, 255:501, 412:587, 392:501, 398:501, 403:501, 366:573, 349:501, 286:501, 409:501, 348:501, 341:501, 732:501, 352:501, 413:587, 1631:501, 714:501, 363:572, 401:501, 375:501, 404:501, 342:501, 344:501, 676:501, 377:501, 417:583, 385:501, 400:501, 358:502, 394:501, 395:501, 1613:501, 691:501, 406:501, 402:501, 379:501, 351:501, 397:501, 369:573, 376:501, 391:573, 3562:501, 1526:502, 354:502
  + drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c: warning: value computed is not used [-Wunused-value]:  => 1422:551, 1494:551, 1482:553, 1461:552, 1443:553, 1626:501
  + drivers/net/ethernet/intel/ixgbe/ixgbe_main.c: warning: value computed is not used [-Wunused-value]:  => 5238:502, 5236:502, 5234:502, 2232:502, 5203:583, 2734:501, 2340:552, 5438:502, 2681:551, 5205:588, 4094:501
  + drivers/net/ethernet/intel/ixgbe/ixgbe_phy.c: warning: value computed is not used [-Wunused-value]:  => 1483:501, 1654:501, 1630:501, 1607:502
  + drivers/net/ethernet/intel/ixgbe/ixgbe_ptp.c: warning: value computed is not used [-Wunused-value]:  => 863:501, 748:501, 132:502, 182:501
  + drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c: warning: value computed is not used [-Wunused-value]:  => 254:501, 573:501
  + drivers/net/ethernet/intel/ixgbe/ixgbe_x540.c: warning: value computed is not used [-Wunused-value]:  => 111:501, 805:501, 742:501, 776:501
  + drivers/net/ethernet/jme.h: warning: value computed is not used [-Wunused-value]:  => 1235:451
  + drivers/net/ethernet/natsemi/natsemi.c: warning: value computed is not used [-Wunused-value]:  => 1228:472, 1180:471, 3181:461, 1275:471, 1076:451, 1018:412, 1023:411, 1073:452, 1030:412, 717:511, 3123:451, 1027:412, 1058:451, 1310:471, 1071:452, 1020:412, 711:511, 1316:471, 1720:471
  + drivers/net/ethernet/natsemi/ns83820.c: warning: value computed is not used [-Wunused-value]:  => 1203:467, 1389:456, 796:456, 1202:471, 1204:467, 1199:467
  + drivers/net/ethernet/neterion/s2io.c: warning: value computed is not used [-Wunused-value]:  => 2831:487, 4799:502, 4756:484, 4314:502
  + drivers/net/ethernet/neterion/vxge/vxge-config.c: warning: value computed is not used [-Wunused-value]:  => 4935:536
  + drivers/net/ethernet/nvidia/forcedeth.c: warning: value computed is not used [-Wunused-value]:  => 952:396
  + drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c: warning: value computed is not used [-Wunused-value]:  => 832:456, 816:456
  + drivers/net/ethernet/packetengines/hamachi.c: warning: value computed is not used [-Wunused-value]:  => 1636:447, 1637:447
  + drivers/net/ethernet/qlogic/netxen/netxen_nic_hw.c: warning: value computed is not used [-Wunused-value]:  => 2180:1051, 2079:2250, 2012:2250, 1403:496, 2017:1048, 2178:1081, 2184:601, 2313:2325, 2211:2362, 2209:1093, 1995:2292, 2265:1081, 2313:1087, 2209:2337, 2008:1048, 2003:2250, 2234:1046, 2039:1048, 2079:1048, 2215:1082, 2012:1048, 2027:1048, 2146:1045, 2222:1083, 2264:1093, 2337:2319, 2000:1048, 2264:2337, 2211:1082, 2337:1087, 2021:1048, 2178:2289, 1995:1048, 2340:1076, 2314:1075, 2021:2250, 2269:1046, 2003:1048, 2265:2367, 2057:1048
  + drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c: warning: value computed is not used [-Wunused-value]:  => 2275:476, 2276:476
  + drivers/net/ethernet/qlogic/qla3xxx.c: warning: value computed is not used [-Wunused-value]:  => 250:391, 225:391, 129:551, 274:391, 233:391, 175:571, 240:391, 262:391
  + drivers/net/ethernet/qlogic/qlcnic/qlcnic_hw.c: warning: value computed is not used [-Wunused-value]:  => 1544:938, 1517:2121, 1517:973, 1400:939, 1571:992, 1466:991, 1371:2051, 1540:2361, 1009:501, 1631:974, 1466:2169, 1380:939, 1519:937, 1410:2051, 1367:2081, 1627:973, 1380:2135, 1385:940, 1444:967, 1539:961, 1375:2135, 1569:2091, 1379:939, 1337:937, 1626:2103, 1569:961, 1539:2091, 1626:973, 1523:461, 1576:992, 1370:939, 1625:2121, 1571:2362, 1627:2151, 1371:939, 1410:939, 1367:939, 1625:973, 1375:939, 1444:2103, 1540:991, 1644:1040, 1374:939, 1593:938, 1445:997, 1469:938
  + drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c: warning: value computed is not used [-Wunused-value]:  => 2455:476, 2456:476
  + drivers/net/ethernet/realtek/8139cp.c: warning: value computed is not used [-Wunused-value]:  => 983:846, 1504:486, 982:822, 979:3954, 1575:3954, 991:960, 986:930, 1576:3954, 896:864, 990:930, 1495:486, 997:930, 893:870, 895:864, 987:960, 980:3954
  + drivers/net/ethernet/realtek/8139too.c: warning: value computed is not used [-Wunused-value]:  => 1388:3956, 2583:813, 2240:3338, 1895:866, 2587:866, 2586:866, 1394:866, 1389:2780, 2239:3338, 913:873, 1733:1892, 1419:1131
  + drivers/net/ethernet/realtek/r8169.c: warning: value computed is not used [-Wunused-value]:  => 3725:451, 3722:451
  + drivers/net/ethernet/silan/sc92031.c: warning: value computed is not used [-Wunused-value]:  => 645:486, 310:456
  + drivers/net/ethernet/sis/sis190.c: warning: value computed is not used [-Wunused-value]:  => 443:486, 875:486, 1693:486, 900:486
  + drivers/net/ethernet/sis/sis900.c: warning: value computed is not used [-Wunused-value]:  => 836:451, 987:452, 855:452, 978:452, 971:451, 877:451, 989:452, 921:452, 862:451, 853:452, 834:451, 980:452, 982:451, 967:452, 843:452, 929:452, 848:451, 857:452, 932:452, 969:452, 923:452, 891:452, 845:452, 889:452
  + drivers/net/ethernet/smsc/epic100.c: warning: value computed is not used [-Wunused-value]:  => 598:457, 595:457, 587:457, 686:461, 589:457
  + drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c: warning: value computed is not used [-Wunused-value]:  => 222:472
  + drivers/net/ethernet/sun/cassini.c: warning: value computed is not used [-Wunused-value]:  => 4154:462, 1261:461, 1265:548
  + drivers/net/ethernet/tehuti/tehuti.c: warning: value computed is not used [-Wunused-value]:  => 282:493, 281:493, 526:491, 493:493, 469:443
  + drivers/net/fddi/skfp/h/skfbi.h: warning: "PCI_IOBASE" redefined [enabled by default]:  => 151:0
  + drivers/net/hippi/rrunner.c: warning: value computed is not used [-Wunused-value]:  => 1219:451, 1354:452
  + drivers/net/wan/dscc4.c: warning: value computed is not used [-Wunused-value]:  => 1037:441, 434:581, 423:656
  + drivers/net/wan/pc300too.c: warning: value computed is not used [-Wunused-value]:  => 382:381, 386:381, 395:381, 391:381
  + drivers/net/wan/pci200syn.c: warning: value computed is not used [-Wunused-value]:  => 347:381, 343:381
  + drivers/net/wan/wanxl.c: warning: value computed is not used [-Wunused-value]:  => 506:486, 503:486
  + drivers/net/wireless/adm8211.c: warning: value computed is not used [-Wunused-value]:  => 554:7829, 553:7827, 1370:924, 555:7828, 1406:1022, 554:5855, 554:2943, 554:3913, 553:2039, 554:6800, 1374:451, 903:461, 1156:461, 1885:462, 555:1147, 555:4925, 553:4924, 755:1022, 555:3912, 554:4926, 555:8675, 552:5854, 1153:461, 553:8674, 555:6799, 553:1146, 258:456, 552:7828, 106:451, 552:3912, 553:5853, 1557:451, 555:5854, 553:3911, 1883:462, 553:2941, 1205:451, 639:1022, 553:6798, 554:1148, 555:2942, 552:2040, 552:8675, 720:461, 552:2942, 554:8676, 552:4925, 554:2041, 555:2040, 254:466, 552:1147, 552:6799
  + drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c: warning: format '%d' expects argument of type 'int', but argument 4 has type 'size_t' [-Wformat]:  => 4139:2
  + drivers/net/wireless/ipw2x00/ipw2100.c: warning: value computed is not used [-Wunused-value]:  => 8610:391, 8618:391, 8630:391, 8641:391, 8637:391, 8608:391, 8635:391, 8602:391, 8614:391, 8616:391, 8649:391, 8647:391, 8654:391, 8643:391, 8604:391
  + drivers/net/wireless/mwl8k.c: warning: value computed is not used [-Wunused-value]:  => 1455:491
  + drivers/nfc/nfcwilink.c: warning: overflow in implicit constant conversion [-Woverflow]:  => 415:2
  + drivers/pcmcia/yenta_socket.c: warning: value computed is not used [-Wunused-value]:  => 93:466
  + drivers/regulator/lp8788-buck.c: warning: array subscript is above array bounds [-Warray-bounds]:  => 500:8, 499:48
  + drivers/scsi/3w-sas.c: warning: value computed is not used [-Wunused-value]:  => 1161:591
  + drivers/scsi/aacraid/src.c: warning: value computed is not used [-Wunused-value]:  => 202:551, 98:559, 60:557, 86:558
  + drivers/scsi/arcmsr/arcmsr_hba.c: warning: value computed is not used [-Wunused-value]:  => 1616:481
  + drivers/scsi/bfa/bfa_ioc.c: warning: value computed is not used [-Wunused-value]:  => 1987:526, 1927:526, 1870:526, 2073:506
  + drivers/scsi/bfa/bfa_ioc_cb.c: warning: value computed is not used [-Wunused-value]:  => 205:501, 87:481
  + drivers/scsi/bfa/bfa_ioc_ct.c: warning: value computed is not used [-Wunused-value]:  => 99:531, 136:502, 68:532, 135:482, 121:531, 88:532, 936:508, 617:451, 941:508, 400:501, 391:531, 139:482
  + drivers/scsi/hptiop.c: warning: value computed is not used [-Wunused-value]:  => 1192:541, 68:552, 1198:541, 285:541, 278:551, 243:551
  + drivers/scsi/ips.c: warning: value computed is not used [-Wunused-value]:  => 4773:466
  + drivers/scsi/lpfc/lpfc.h: warning: value computed is not used [-Wunused-value]:  => 1014:451
  + drivers/scsi/lpfc/lpfc_attr.c: warning: value computed is not used [-Wunused-value]:  => 1472:453, 919:581, 1493:452
  + drivers/scsi/lpfc/lpfc_bsg.c: warning: value computed is not used [-Wunused-value]:  => 1388:452, 618:452, 360:452
  + drivers/scsi/lpfc/lpfc_compat.h: warning: value computed is not used [-Wunused-value]:  => 51:407
  + drivers/scsi/lpfc/lpfc_debugfs.c: warning: value computed is not used [-Wunused-value]:  => 1979:493, 3102:412, 1973:493, 2878:412, 1967:493
  + drivers/scsi/lpfc/lpfc_hbadisc.c: warning: value computed is not used [-Wunused-value]:  => 1078:451, 1054:451, 3187:452, 714:454
  + drivers/scsi/lpfc/lpfc_init.c: warning: value computed is not used [-Wunused-value]:  => 3308:451, 539:451, 705:453, 702:453, 1662:451, 785:452, 3311:451, 1681:451, 1685:451
  + drivers/scsi/lpfc/lpfc_sli.c: warning: value computed is not used [-Wunused-value]:  => 4029:411, 3692:451, 3804:451, 3905:451, 6871:452, 10162:453, 1573:452, 1768:482, 3061:452, 10727:452, 9992:452, 3760:451, 4020:411, 10460:452, 9949:452, 6862:452, 10834:451, 4201:451, 4205:451, 3903:451, 3386:452, 10544:454, 6971:452, 1548:451, 331:532, 10516:455, 10480:454, 6846:412
  + drivers/scsi/megaraid/megaraid_sas_base.c: warning: value computed is not used [-Wunused-value]:  => 674:501, 687:501, 300:511, 420:501, 433:501, 249:501, 262:501, 472:526, 600:511, 551:501, 728:511, 538:501
  + drivers/scsi/megaraid/megaraid_sas_fusion.c: warning: value computed is not used [-Wunused-value]:  => 113:501, 142:512, 108:511
  + drivers/scsi/mpt2sas/mpt2sas_base.c: warning: value computed is not used [-Wunused-value]:  => 850:521
  + drivers/scsi/mvsas/mv_64xx.c: warning: value computed is not used [-Wunused-value]:  => 191:817, 473:834, 382:774, 279:841
  + drivers/scsi/mvsas/mv_94xx.c: warning: value computed is not used [-Wunused-value]:  => 478:774, 356:841, 612:835
  + drivers/scsi/pmcraid.c: warning: value computed is not used [-Wunused-value]:  => 4739:587, 4395:588, 4466:608, 544:612, 488:601, 2023:587, 547:607, 493:612, 519:612, 2027:586
  + drivers/scsi/qla2xxx/qla_dbg.c: warning: value computed is not used [-Wunused-value]:  => 1880:461, 1564:461, 1902:461, 1898:431, 1551:471, 1869:461, 1226:461, 1235:471, 1560:431, 134:430, 980:461, 2258:427, 2264:427, 976:431, 1244:431, 1248:461, 1889:471, 246:426, 2261:427, 140:429, 1542:461
  + drivers/scsi/qla2xxx/qla_init.c: warning: value computed is not used [-Wunused-value]:  => 1083:426, 1080:426, 4603:426, 1841:436, 1077:426, 4601:426
  + drivers/scsi/qla2xxx/qla_iocb.c: warning: value computed is not used [-Wunused-value]:  => 1568:491, 491:478, 1769:491, 488:493
  + drivers/scsi/qla2xxx/qla_isr.c: warning: value computed is not used [-Wunused-value]:  => 2611:427, 2639:427, 2477:471, 2572:427, 2445:461
  + drivers/scsi/qla2xxx/qla_mbx.c: warning: value computed is not used [-Wunused-value]:  => 4249:429
  + drivers/scsi/qla2xxx/qla_nx.c: warning: value computed is not used [-Wunused-value]:  => 920:561
  + drivers/scsi/qla2xxx/qla_os.c: warning: value computed is not used [-Wunused-value]:  => 1528:431, 1513:431
  + drivers/scsi/qla2xxx/qla_sup.c: warning: value computed is not used [-Wunused-value]:  => 1154:461, 504:456, 1841:431, 1406:461, 1115:461, 1796:432, 1381:461
  + drivers/scsi/qla2xxx/qla_target.c: warning: value computed is not used [-Wunused-value]:  => 4700:487
  + drivers/scsi/qla4xxx/ql4_init.c: warning: value computed is not used [-Wunused-value]:  => 803:483, 680:483, 806:483, 683:481, 614:471, 718:482, 131:472
  + drivers/scsi/qla4xxx/ql4_inline.h: warning: value computed is not used [-Wunused-value]:  => 44:527, 47:482, 61:482, 58:527
  + drivers/scsi/qla4xxx/ql4_iocb.c: warning: value computed is not used [-Wunused-value]:  => 248:466, 198:516, 262:471, 204:521, 235:521
  + drivers/scsi/qla4xxx/ql4_isr.c: warning: value computed is not used [-Wunused-value]:  => 898:516, 1013:483, 923:482, 1026:483, 1008:484
  + drivers/scsi/qla4xxx/ql4_mbx.c: warning: value computed is not used [-Wunused-value]:  => 27:481, 25:476
  + drivers/scsi/qla4xxx/ql4_nvram.c: warning: value computed is not used [-Wunused-value]:  => 233:461, 16:441
  + drivers/scsi/qla4xxx/ql4_nx.c: warning: value computed is not used [-Wunused-value]:  => 2981:522, 3286:496, 2984:517, 3284:541
  + drivers/scsi/qla4xxx/ql4_os.c: warning: value computed is not used [-Wunused-value]:  => 3519:482, 2839:482, 2812:482, 3522:517, 2770:481, 3525:522, 2853:482
  + drivers/scsi/qlogicpti.c: warning: assignment discards 'const' qualifier from pointer target type [enabled by default]:  => 1308:7
  + drivers/scsi/stex.c: warning: value computed is not used [-Wunused-value]:  => 512:481, 853:431, 1035:431, 992:432, 1058:431, 1109:451, 1038:431, 870:432, 1257:431, 1056:431, 1040:431, 1062:431, 1190:432, 1060:431, 1033:431, 541:516, 1283:501, 543:501, 1107:466
  + drivers/spi/spi-altera.c: warning: value computed is not used [-Wunused-value]:  => 263:437
  + drivers/spi/spi-gpio.c: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]:  => 255:8
  + drivers/staging/ced1401/ced_ioc.c: warning: the frame size of 3104 bytes is larger than 1024 bytes [-Wframe-larger-than=]:  => 931:1
  + drivers/staging/ced1401/ced_ioc.c: warning: the frame size of 3108 bytes is larger than 1024 bytes [-Wframe-larger-than=]:  => 931:1
  + drivers/staging/ced1401/ced_ioc.c: warning: the frame size of 4136 bytes is larger than 1024 bytes [-Wframe-larger-than=]:  => 931:1
  + drivers/staging/ced1401/ced_ioc.c: warning: the frame size of 4144 bytes is larger than 1024 bytes [-Wframe-larger-than=]:  => 931:1
  + drivers/staging/ced1401/ced_ioc.c: warning: the frame size of 4144 bytes is larger than 2048 bytes [-Wframe-larger-than=]:  => 931:1
  + drivers/staging/dgrp/dgrp_tty.c: warning: 'arg' may be used uninitialized in this function [-Wuninitialized]:  => 2288:16
  + drivers/staging/dgrp/dgrp_tty.c: warning: 'new_rate' may be used uninitialized in this function [-Wuninitialized]:  => 2338:5
  + drivers/staging/media/dt3155v4l/dt3155v4l.c: warning: ignoring return value of 'vb2_queue_init', declared with attribute warn_unused_result [-Wunused-result]:  => 399:17
  + drivers/staging/ramster/zbud.c: warning: passing argument 4 of 'debugfs_create_size_t' from incompatible pointer type [enabled by default]:  => 326:2, 332:5, 329:2, 336:2, 333:2, 335:2, 334:2, 325:5, 327:2, 328:2, 330:2, 323:2, 337:2
  + drivers/staging/ramster/zcache-main.c: warning: passing argument 4 of 'debugfs_create_size_t' from incompatible pointer type [enabled by default]:  => 235:5, 203:2, 209:2, 237:5, 213:2, 204:2, 231:5, 219:2, 221:2, 215:2, 229:5, 202:2, 198:2, 197:2, 199:2, 210:2, 233:5, 214:2, 223:2, 222:2, 201:2, 227:5, 211:2, 218:2, 212:2, 224:2, 200:2, 220:2, 196:2, 225:2, 206:5, 207:2, 195:2, 217:5, 208:2
  + drivers/staging/silicom/bp_proc.c: warning: 'bp_procfs_dir' defined but not used [-Wunused-variable]:  => 74:31
  + drivers/staging/silicom/bp_proc.c: warning: 'proc_getdir' defined but not used [-Wunused-function]:  => 76:31
  + drivers/staging/vme/devices/vme_pio2_gpio.c: warning: initialization from incompatible pointer type [enabled by default]:  => 31:66
  + drivers/tty/n_gsm.c: warning: unused variable 'buf' [-Wunused-variable]:  => 2264:7
  + drivers/tty/serial/8250/8250_early.c: warning: comparison of distinct pointer types lacks a cast [enabled by default]:  => 196:160
  + drivers/tty/serial/8250/8250_pci.c: warning: value computed is not used [-Wunused-value]:  => 285:416, 308:417
  + drivers/tty/serial/max310x.c: warning: (near initialization for 's') [enabled by default]:  => 952:89, 941:89, 976:89, 962:89
  + drivers/tty/serial/max310x.c: warning: initialization from incompatible pointer type [enabled by default]:  => 952:89, 941:89, 976:89, 962:89
  + drivers/tty/serial/uartlite.c: warning: value computed is not used [-Wunused-value]:  => 233:3
  + drivers/tty/serial/xilinx_uartps.c: warning: value computed is not used [-Wunused-value]:  => 445:477
  + drivers/usb/gadget/amd5536udc.c: warning: value computed is not used [-Wunused-value]:  => 2649:509, 1685:451
  + drivers/usb/gadget/goku_udc.c: warning: value computed is not used [-Wunused-value]:  => 917:447, 206:462, 1318:461, 1285:461, 1277:461
  + drivers/usb/gadget/net2280.h: warning: value computed is not used [-Wunused-value]:  => 279:461
  + drivers/usb/host/ehci-fsl.c: warning: 'return' with no value, in function returning non-void [-Wreturn-type]:  => 225:3
  + drivers/usb/host/oxu210hp-hcd.c: warning: value computed is not used [-Wunused-value]:  => 2462:471, 3435:472, 3239:472, 2750:471, 2809:511
  + drivers/usb/host/pci-quirks.c: warning: value computed is not used [-Wunused-value]:  => 514:432
  + drivers/video/aty/radeon_accel.c: warning: value computed is not used [-Wunused-value]:  => 247:501, 221:502, 243:502, 234:502
  + drivers/video/savage/savagefb-i2c.c: warning: value computed is not used [-Wunused-value]:  => 56:496, 70:496
  + drivers/video/sh_mobile_meram.c: warning: 'sh_mobile_meram_resume' defined but not used [-Wunused-function]:  => 596:12
  + drivers/video/sh_mobile_meram.c: warning: 'sh_mobile_meram_suspend' defined but not used [-Wunused-function]:  => 572:12
  + drivers/video/sm501fb.c: warning: value computed is not used [-Wunused-value]:  => 141:426
  + drivers/xen/xenbus/xenbus_xs.c: warning: function declaration isn't a prototype [-Wstrict-prototypes]:  => 628:13
  + fs/binfmt_elf_fdpic.c: warning: 'create_elf_fdpic_tables' defined but not used [-Wunused-function]:  => 475:12
  + fs/binfmt_elf_fdpic.c: warning: 'create_elf_fdpic_tables' used but never defined [enabled by default]:  => 64:12
  + fs/binfmt_elf_fdpic.c: warning: 'elf_fdpic_map_file' defined but not used [-Wunused-function]:  => 738:12
  + fs/binfmt_elf_fdpic.c: warning: 'elf_fdpic_map_file' used but never defined [enabled by default]:  => 61:12
  + fs/binfmt_elf_fdpic.c: warning: 'elf_fdpic_map_file_by_direct_mmap' defined but not used [-Wunused-function]:  => 1013:12
  + fs/binfmt_elf_fdpic.c: warning: 'elf_fdpic_map_file_by_direct_mmap' used but never defined [enabled by default]:  => 76:12
  + fs/binfmt_elf_fdpic.c: warning: 'elf_fdpic_map_file_constdisp_on_uclinux' defined but not used [-Wunused-function]:  => 921:12
  + fs/binfmt_elf_fdpic.c: warning: 'elf_fdpic_map_file_constdisp_on_uclinux' used but never defined [enabled by default]:  => 71:12
  + fs/binfmt_elf_fdpic.c: warning: 'struct elf_fdpic_params' declared inside parameter list [enabled by default]:  => 1015:18, 66:15, 60:68, 62:17, 741:10, 73:17, 77:33, 124:13, 478:15, 924:9
  + fs/binfmt_elf_fdpic.c: warning: its scope is only this definition or declaration, which is probably not what you want [enabled by default]:  => 60:68
  + fs/binfmt_elf_fdpic.c: warning: passing argument 1 of 'elf_fdpic_map_file_by_direct_mmap' from incompatible pointer type [enabled by default]:  => 787:3
  + fs/binfmt_elf_fdpic.c: warning: passing argument 1 of 'elf_fdpic_map_file_constdisp_on_uclinux' from incompatible pointer type [enabled by default]:  => 781:3
  + fs/binfmt_elf_fdpic.c: warning: unused variable 'exec_params' [-Wunused-variable]:  => 170:26
  + fs/binfmt_elf_fdpic.c: warning: unused variable 'interp_params' [-Wunused-variable]:  => 170:39
  + fs/cifs/inode.c: warning: 'server' may be used uninitialized in this function [-Wuninitialized]:  => 1901:12
  + fs/compat_binfmt_elf.c: warning: 'cputime_to_compat_timeval' defined but not used [-Wunused-function]:  => 58:13
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
  + fs/pstore/ftrace.c: warning: (near initialization for 'pstore_ftrace_ops.func') [enabled by default]:  => 51:2
  + fs/pstore/ftrace.c: warning: initialization from incompatible pointer type [enabled by default]:  => 51:2
  + fs/quota/dquot.c: warning: enumeration value 'PRJQUOTA' not handled in switch [-Wswitch]:  => 1158:2
  + fs/quota/dquot.c: warning: enumeration value 'PRJQUOTA' not handled in switch:  => 1158
  + fs/quota/kqid.c: warning: control reaches end of non-void function [-Wreturn-type]:  => 131:1, 26:1, 112:1, 52:1, 79:1
  + include/asm-generic/io.h: warning: passing argument 1 of '__raw_readb' makes pointer from integer without a cast [enabled by default]:  => 110:2
  + include/asm-generic/io.h: warning: passing argument 1 of '__raw_readl' makes pointer from integer without a cast [enabled by default]:  => 120:2
  + include/asm-generic/io.h: warning: passing argument 1 of '__raw_readw' makes pointer from integer without a cast [enabled by default]:  => 115:2
  + include/asm-generic/io.h: warning: passing argument 1 of 'insb' makes integer from pointer without a cast [enabled by default]:  => 232:2
  + include/asm-generic/io.h: warning: passing argument 1 of 'insl' makes integer from pointer without a cast [enabled by default]:  => 222:2
  + include/asm-generic/io.h: warning: passing argument 1 of 'insw' makes integer from pointer without a cast [enabled by default]:  => 227:2
  + include/asm-generic/io.h: warning: passing argument 1 of 'outsb' makes integer from pointer without a cast [enabled by default]:  => 247:2
  + include/asm-generic/io.h: warning: passing argument 1 of 'outsl' makes integer from pointer without a cast [enabled by default]:  => 237:2
  + include/asm-generic/io.h: warning: passing argument 1 of 'outsw' makes integer from pointer without a cast [enabled by default]:  => 242:2
  + include/asm-generic/io.h: warning: passing argument 2 of '__raw_writeb' makes pointer from integer without a cast [enabled by default]:  => 125:2
  + include/asm-generic/io.h: warning: passing argument 2 of '__raw_writel' makes pointer from integer without a cast [enabled by default]:  => 135:2
  + include/asm-generic/io.h: warning: passing argument 2 of '__raw_writew' makes pointer from integer without a cast [enabled by default]:  => 130:2
  + include/linux/basic_mmio_gpio.h: warning: initialization from incompatible pointer type [enabled by default]:  => 63:67
  + include/linux/rbtree_augmented.h: warning: '__rb_erase_color' declared inline after being called:  => 123, 122
  + include/linux/rbtree_augmented.h: warning: previous declaration of '__rb_erase_color' was here:  => 123, 122
  + include/linux/sunrpc/svc_xprt.h: warning: control reaches end of non-void function [-Wreturn-type]:  => 170:1
  + kernel/profile.c: warning: 'profile_cpu_callback' defined but not used [-Wunused-function]:  => 355:125
  + kernel/profile.c: warning: 'profile_discard_flip_buffers' defined but not used [-Wunused-function]:  => 291:13
  + kernel/profile.c: warning: 'profile_flip_buffers' defined but not used [-Wunused-function]:  => 268:13
  + kernel/rcutree.c: warning: unused variable 'idle' [-Wunused-variable]:  => 340:23, 518:23
  + kernel/relay.c: warning: format '%Zd' expects argument of type 'signed size_t', but argument 2 has type 'size_t' [-Wformat]:  => 833:10
  + kernel/relay.c: warning: format '%Zd' expects argument of type 'signed size_t', but argument 3 has type 'size_t' [-Wformat]:  => 833:10
  + lib/crc32.c: warning: passing argument 4 of 'crc32_be_generic' from incompatible pointer type:  => 258
  + lib/crc32.c: warning: passing argument 4 of 'crc32_le_generic' from incompatible pointer type:  => 191, 196
  + lib/rbtree_test.c: warning: 'blacks' may be used uninitialized in this function [-Wuninitialized]:  => 132:4, 132:99
  + mm/dmapool.c: warning: format '%Zu' expects argument of type 'size_t', but argument 6 has type 'unsigned int' [-Wformat]:  => 101:6
  + mm/dmapool.c: warning: format '%Zu' expects argument of type 'size_t', but argument 7 has type 'unsigned int' [-Wformat]:  => 101:6
  + mm/mmap.c: warning: 'prev' may be used uninitialized in this function [-Wuninitialized]:  => 453:17
  + mm/mmap.c: warning: 'rb_link' may be used uninitialized in this function [-Wuninitialized]:  => 454:15
  + mm/mmap.c: warning: 'rb_parent' may be used uninitialized in this function [-Wuninitialized]:  => 454:15
  + mm/percpu.c: warning: format '%zu' expects argument of type 'size_t', but argument 2 has type 'unsigned int' [-Wformat]: 816:3 => 1697:2, 816:3
  + mm/percpu.c: warning: format '%zu' expects argument of type 'size_t', but argument 4 has type 'unsigned int' [-Wformat]: 1125:9, 717:3 => 1697:2, 1125:9, 717:3
  + mm/percpu.c: warning: format '%zu' expects argument of type 'size_t', but argument 5 has type 'unsigned int' [-Wformat]: 1125:9, 717:3 => 1697:2, 1125:9, 717:3
  + mm/percpu.c: warning: format '%zu' expects argument of type 'size_t', but argument 6 has type 'unsigned int' [-Wformat]: 1125:9 => 1697:2, 1125:9
  + mm/percpu.c: warning: format '%zu' expects argument of type 'size_t', but argument 7 has type 'unsigned int' [-Wformat]: 1125:9 => 1697:2, 1125:9
  + mm/percpu.c: warning: format '%zx' expects argument of type 'size_t', but argument 2 has type 'unsigned int' [-Wformat]:  => 1687:3
  + modpost: WARNING: modpost: Found 13 section mismatch(es).:  => N/A
  + modpost: WARNING: modpost: Found 5 section mismatch(es).:  => N/A
  + net/core/dev.c: warning: comparison of distinct pointer types lacks a cast [enabled by default]:  => 5025:194, 4956:195
  + net/dsa/slave.c: warning: 'dsa_slave_change_rx_flags' defined but not used [-Wunused-function]:  => 116:13
  + net/dsa/slave.c: warning: 'dsa_slave_close' defined but not used [-Wunused-function]:  => 98:12
  + net/dsa/slave.c: warning: 'dsa_slave_init' defined but not used [-Wunused-function]:  => 51:12
  + net/dsa/slave.c: warning: 'dsa_slave_ioctl' defined but not used [-Wunused-function]:  => 164:12
  + net/dsa/slave.c: warning: 'dsa_slave_open' defined but not used [-Wunused-function]:  => 60:12
  + net/dsa/slave.c: warning: 'dsa_slave_set_mac_address' defined but not used [-Wunused-function]:  => 136:12
  + net/dsa/slave.c: warning: 'dsa_slave_set_rx_mode' defined but not used [-Wunused-function]:  => 127:13
  + net/sunrpc/auth_gss/auth_gss.c: warning: format '%Zd' expects argument of type 'signed size_t', but argument 3 has type 'ssize_t' [-Wformat]:  => 684:2
  + net/sunrpc/svc.c: warning: format '%Zd' expects argument of type 'signed size_t', but argument 3 has type 'size_t' [-Wformat]:  => 1231:4
  + sound/pci/atiixp.c: warning: value computed is not used [-Wunused-value]:  => 513:491, 522:492
  + sound/pci/atiixp_modem.c: warning: value computed is not used [-Wunused-value]:  => 498:492, 489:491
  + sound/pci/au88x0/au88x0_core.c: warning: value computed is not used [-Wunused-value]:  => 967:566, 1169:576, 875:566, 1248:637, 2556:486, 2421:496, 1207:648, 2477:497, 875:561, 967:561, 1475:643, 2690:496
  + sound/soc/codecs/wm5100.c: warning: (near initialization for 'wm5100_template_chip') [enabled by default]:  => 2277:2, 2278:2, 2282:2, 2276:2, 2280:2, 2279:2, 2281:2
  + sound/soc/codecs/wm5100.c: warning: excess elements in struct initializer [enabled by default]:  => 2277:2, 2278:2, 2282:2, 2276:2, 2280:2, 2279:2, 2281:2
  + sound/soc/codecs/wm5100.c: warning: initialization from incompatible pointer type [enabled by default]:  => 2224:75
  + sound/soc/codecs/wm8903.c: warning: (near initialization for 'wm8903_template_chip') [enabled by default]:  => 1852:2, 1851:2, 1850:2, 1849:2, 1848:2, 1855:2, 1854:2, 1853:2
  + sound/soc/codecs/wm8903.c: warning: excess elements in struct initializer [enabled by default]:  => 1852:2, 1851:2, 1850:2, 1849:2, 1848:2, 1855:2, 1854:2, 1853:2
  + sound/soc/codecs/wm8903.c: warning: initialization from incompatible pointer type [enabled by default]:  => 1780:75
  + sound/soc/codecs/wm8962.c: warning: (near initialization for 'wm8962_template_chip') [enabled by default]:  => 3332:2, 3334:2, 3330:2, 3329:2, 3333:2, 3331:2
  + sound/soc/codecs/wm8962.c: warning: excess elements in struct initializer [enabled by default]:  => 3332:2, 3334:2, 3330:2, 3329:2, 3333:2, 3331:2
  + sound/soc/codecs/wm8962.c: warning: initialization from incompatible pointer type [enabled by default]:  => 3274:75
  + sound/soc/codecs/wm8996.c: warning: (near initialization for 'wm8996_template_chip') [enabled by default]:  => 2193:2, 2197:2, 2196:2, 2192:2, 2194:2, 2198:2, 2195:2
  + sound/soc/codecs/wm8996.c: warning: excess elements in struct initializer [enabled by default]:  => 2193:2, 2197:2, 2196:2, 2192:2, 2194:2, 2198:2, 2195:2
  + sound/soc/codecs/wm8996.c: warning: initialization from incompatible pointer type [enabled by default]:  => 2144:75
  + warning: (ARCH_REQUIRE_GPIOLIB && I2C_I801 && MFD_TC6393XB && FB_VIA) selects GPIOLIB which has unmet direct dependencies (ARCH_WANT_OPTIONAL_GPIOLIB || ARCH_REQUIRE_GPIOLIB):  => N/A
  + warning: (DVB_USB_PCTV452E) selects TTPCI_EEPROM which has unmet direct dependencies (MEDIA_SUPPORT && MEDIA_PCI_SUPPORT && MEDIA_DIGITAL_TV_SUPPORT && I2C):  => N/A
  + warning: (HAVE_TEXT_POKE_SMP) selects STOP_MACHINE which has unmet direct dependencies (SMP && MODULE_UNLOAD || HOTPLUG_CPU):  => N/A
  + warning: (UPROBE_EVENT) selects UPROBES which has unmet direct dependencies (UPROBE_EVENT && PERF_EVENTS):  => N/A
  + warning: arch/powerpc/platforms/built-in.o(.text+0x18064): Section mismatch in reference from the function .pci_dn_reconfig_notifier() to the function .devinit.text:.eeh_dev_init():  => N/A
  + warning: arch/powerpc/platforms/built-in.o(.text+0x18084): Section mismatch in reference from the function .pci_dn_reconfig_notifier() to the function .devinit.text:.eeh_dev_init():  => N/A
  + warning: arch/powerpc/platforms/pseries/built-in.o(.text+0x43c4): Section mismatch in reference from the function .pci_dn_reconfig_notifier() to the function .devinit.text:.eeh_dev_init():  => N/A
  + warning: arch/powerpc/sysdev/built-in.o(.text+0xe1e8): Section mismatch in reference from the function .ics_rtas_init() to the function .init.text:.xics_register_ics():  => N/A
  + warning: arch/powerpc/sysdev/built-in.o(.text+0xf794): Section mismatch in reference from the function .ics_rtas_init() to the function .init.text:.xics_register_ics():  => N/A
  + warning: drivers/ata/built-in.o(.data+0x10a0): Section mismatch in reference from the variable ahci_highbank_driver to the function .init.text:ata_parse_force_one():  => N/A
  + warning: drivers/ata/sata_highbank.o(.data+0x0): Section mismatch in reference from the variable ahci_highbank_driver to the function .init.text:ahci_highbank_probe():  => N/A
  + warning: drivers/built-in.o(.data+0x23d658): Section mismatch in reference from the variable tpci200_pci_drv to the variable .devinit.rodata:tpci200_idtable:  => N/A
  + warning: drivers/staging/built-in.o(.data+0x9698): Section mismatch in reference from the variable tpci200_pci_drv to the variable .devinit.rodata:tpci200_idtable:  => N/A
  + warning: drivers/staging/ipack/built-in.o(.data+0x270): Section mismatch in reference from the variable tpci200_pci_drv to the variable .devinit.rodata:tpci200_idtable:  => N/A
  + warning: mm/built-in.o(.meminit.text+0x1054): Section mismatch in reference from the function .free_area_init_core.isra.36() to the function .init.text:.set_pageblock_order():  => N/A
  + warning: vmlinux.o(.data+0x2b3568): Section mismatch in reference from the variable tpci200_pci_drv to the variable .devinit.rodata:tpci200_idtable:  => N/A
  + warning: vmlinux.o(.meminit.text+0x1464): Section mismatch in reference from the function .free_area_init_core.isra.36() to the function .init.text:.set_pageblock_order():  => N/A
  + warning: vmlinux.o(.text+0x10ec3c0): Section mismatch in reference from the function .dlpar_add_slot() to the function .devinit.text:.init_phb_dynamic():  => N/A
  + warning: vmlinux.o(.text+0x10ec8c8): Section mismatch in reference from the function .dlpar_remove_slot() to the function .devinit.text:.vio_unregister_device():  => N/A
  + warning: vmlinux.o(.text+0x2be9c): Section mismatch in reference from the function .early_setup_secondary() to the function .cpuinit.text:.early_init_mmu_secondary():  => N/A
  + warning: vmlinux.o(.text+0x2bf5c): Section mismatch in reference from the function .early_setup_secondary() to the function .cpuinit.text:.early_init_mmu_secondary():  => N/A
  + warning: vmlinux.o(.text+0x4e370): Section mismatch in reference from the function .wake_offline_cpus() to the function .cpuinit.text:.cpu_up():  => N/A
  + warning: vmlinux.o(.text+0x4f84c): Section mismatch in reference from the function .wake_offline_cpus() to the function .cpuinit.text:.cpu_up():  => N/A
  + warning: vmlinux.o(.text+0x732d8): Section mismatch in reference from the function .ics_rtas_init() to the function .init.text:.xics_register_ics():  => N/A
  + warning: vmlinux.o(.text+0x75d84): Section mismatch in reference from the function .ics_rtas_init() to the function .init.text:.xics_register_ics():  => N/A
  + warning: vmlinux.o(.text+0x8ba08): Section mismatch in reference from the function .pci_dn_reconfig_notifier() to the function .devinit.text:.update_dn_pci_info():  => N/A
  + warning: vmlinux.o(.text+0x8ba24): Section mismatch in reference from the function .pci_dn_reconfig_notifier() to the function .devinit.text:.eeh_dev_init():  => N/A
  + warning: vmlinux.o(.text+0x8e4c8): Section mismatch in reference from the function .pci_dn_reconfig_notifier() to the function .devinit.text:.update_dn_pci_info():  => N/A
  + warning: vmlinux.o(.text+0x8e4e4): Section mismatch in reference from the function .pci_dn_reconfig_notifier() to the function .devinit.text:.eeh_dev_init():  => N/A
  + warning: vmlinux.o(.text+0x90ebc): Section mismatch in reference from the function .dlpar_online_cpu() to the function .cpuinit.text:.cpu_up():  => N/A
  + warning: vmlinux.o(.text+0x9397c): Section mismatch in reference from the function .dlpar_online_cpu() to the function .cpuinit.text:.cpu_up():  => N/A
  + warning: vmlinux.o(.text+0x99470): Section mismatch in reference from the function .pcibios_add_pci_devices() to the function .devinit.text:.of_rescan_bus():  => N/A
  + warning: vmlinux.o(.text+0x994fc): Section mismatch in reference from the function .pcibios_add_pci_devices() to the function .devinit.text:.pcibios_setup_bus_devices():  => N/A
  + warning: vmlinux.o(.text+0x99560): Section mismatch in reference from the function .pcibios_add_pci_devices() to the function .devinit.text:.pci_scan_bridge():  => N/A
  + warning: vmlinux.o(.text+0x9c4bc): Section mismatch in reference from the function .pcibios_add_pci_devices() to the function .devinit.text:.of_rescan_bus():  => N/A
  + warning: vmlinux.o(.text+0x9c548): Section mismatch in reference from the function .pcibios_add_pci_devices() to the function .devinit.text:.pcibios_setup_bus_devices():  => N/A
  + warning: vmlinux.o(.text+0x9c5ac): Section mismatch in reference from the function .pcibios_add_pci_devices() to the function .devinit.text:.pci_scan_bridge():  => N/A

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
