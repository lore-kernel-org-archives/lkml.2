Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751906Ab2DELcF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 07:32:05 -0400
Received: from jacques.telenet-ops.be ([195.130.132.50]:55825 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751772Ab2DELcA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 07:32:00 -0400
Date: Thu, 5 Apr 2012 13:31:57 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Build regressions/improvements in v3.4-rc1
Message-ID: <alpine.DEB.2.00.1204051331300.17523@ayla.of.borg>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Below is the list of build error/warning regressions/improvements in
v3.4-rc1[1] compared to v3.3[2].

Too make this mail fit in the lkml limit, I deleted

  - 2232 lines about tracepoints on sh4, like:

    drivers/mtd/devices/./docg3.h: error: (near initialization for '__tracepoint_docg3_io'):  => 346:1

  - 124 lines about __mcount_loc on sparc64

  - all warning improvements

Summarized:
  - build errors: +2426/-75
  - build warnings: +326/-573

As master.kernel.org is down, there's no verbose summary yet at
http://www.kernel.org/pub/linux/kernel/people/geert/linux-log/v3.4-rc1.summary.gz

Happy fixing! ;-)

Thanks to the linux-next team for providing the build service.

[1] http://kisskb.ellerman.id.au/kisskb/head/4899/ (all 116 configs)
[2] http://kisskb.ellerman.id.au/kisskb/head/4840/ (all 116 configs)


*** ERRORS ***

2426 regressions:
  + arch/avr32/include/asm/mmu_context.h: error: implicit declaration of function 'nop':  => 135
  + arch/avr32/mach-at32ap/at32ap700x.c: error: conflicting types for 'at32_add_device_nand':  => 1965
  + arch/avr32/mach-at32ap/at32ap700x.c: error: dereferencing pointer to incomplete type:  => 1984, 1987, 1985, 1989, 1988, 1990
  + arch/avr32/mach-at32ap/at32ap700x.c: error: invalid application of 'sizeof' to incomplete type 'struct atmel_nand_data' :  => 1980
  + arch/avr32/mach-at32ap/include/mach/board.h: error: linux/platform_data/atmel_nand.h: No such file or directory:  => 10:44
  + arch/avr32/mach-at32ap/include/mach/board.h: error: previous declaration of 'at32_add_device_nand' was here:  => 121
  + arch/m68k/include/asm/atomic.h: error: implicit declaration of function 'cmpxchg' [-Werror=implicit-function-declaration]:  => 203:3
  + arch/parisc/include/asm/atomic.h: error: '__atomic_hash' undeclared (first use in this function):  => 182:2, 265:2, 171:2, 277:2
  + arch/parisc/include/asm/atomic.h: error: expected '=', ',', ';', 'asm' or '__attribute__' before '__lock_aligned':  => 29:56
  + arch/parisc/include/asm/bitops.h: error: '__atomic_hash' undeclared (first use in this function):  => 37:2, 107:2, 48:2, 59:2, 90:2, 72:2
  + arch/parisc/include/asm/bitops.h: error: static declaration of 'fls' follows non-static declaration:  => 186:23
  + arch/parisc/include/asm/spinlock.h: error: 'PSW_SM_I' undeclared (first use in this function):  => 26:16
  + arch/parisc/include/asm/spinlock.h: error: implicit declaration of function '__ldcw' [-Werror=implicit-function-declaration]:  => 24:2
  + arch/parisc/include/asm/spinlock.h: error: implicit declaration of function '__ldcw_align' [-Werror=implicit-function-declaration]:  => 9:2
  + arch/parisc/include/asm/spinlock.h: error: implicit declaration of function 'local_irq_disable' [-Werror=implicit-function-declaration]:  => 29:5
  + arch/parisc/include/asm/spinlock.h: error: implicit declaration of function 'local_irq_enable' [-Werror=implicit-function-declaration]:  => 27:5
  + arch/parisc/include/asm/spinlock.h: error: implicit declaration of function 'local_irq_restore' [-Werror=implicit-function-declaration]:  => 78:2
  + arch/parisc/include/asm/spinlock.h: error: implicit declaration of function 'local_irq_save' [-Werror=implicit-function-declaration]:  => 74:2
  + arch/parisc/include/asm/spinlock.h: error: implicit declaration of function 'mb' [-Werror=implicit-function-declaration]:  => 22:2
  + arch/powerpc/kernel/fadump.c: error: 'memory_limit' undeclared (first use in this function):  => 226:6, 283:6
  + arch/powerpc/kernel/fadump.c: error: 'powerpc_debugfs_root' undeclared (first use in this function):  => 1266:6
  + arch/powerpc/kernel/kgdb.c: error: '__debugger' undeclared (first use in this function):  => 445:18, 466:2
  + arch/powerpc/kernel/kgdb.c: error: '__debugger_bpt' undeclared (first use in this function):  => 467:2, 446:22
  + arch/powerpc/kernel/kgdb.c: error: '__debugger_dabr_match' undeclared (first use in this function):  => 449:29, 470:2
  + arch/powerpc/kernel/kgdb.c: error: '__debugger_fault_handler' undeclared (first use in this function):  => 471:2, 450:32
  + arch/powerpc/kernel/kgdb.c: error: '__debugger_iabr_match' undeclared (first use in this function):  => 469:2, 448:29
  + arch/powerpc/kernel/kgdb.c: error: '__debugger_ipi' undeclared (first use in this function):  => 444:22, 465:2
  + arch/powerpc/kernel/kgdb.c: error: '__debugger_sstep' undeclared (first use in this function):  => 468:2, 447:24
  + arch/powerpc/mm/numa.c: error: 'dm' may be used uninitialized in this function [-Werror=uninitialized]:  => 638:13
  + arch/sh/boards/board-sh7785lcr.c: error: implicit declaration of function 'set_bl_bit' [-Werror=implicit-function-declaration]:  => 321:2
  + arch/sh/boards/mach-hp6xx/pm.c: error: implicit declaration of function 'clear_bl_bit' [-Werror=implicit-function-declaration]:  => 95:2
  + arch/sh/boards/mach-hp6xx/pm.c: error: implicit declaration of function 'set_bl_bit' [-Werror=implicit-function-declaration]:  => 45:2
  + arch/sh/kernel/cpu/fpu.c: error: 'TRAP_HANDLER_DECL' undeclared (first use in this function):  => 81:2
  + arch/sh/kernel/cpu/fpu.c: error: 'regs' undeclared (first use in this function):  => 83:20
  + arch/sh/kernel/cpu/fpu.c: error: called object 'fpu_state_restore' is not a function:  => 83:19
  + arch/sh/kernel/cpu/sh2a/fpu.c: error: 'TRAP_HANDLER_DECL' undeclared (first use in this function):  => 561:2
  + arch/sh/kernel/cpu/sh2a/fpu.c: error: 'regs' undeclared (first use in this function):  => 563:20
  + arch/sh/kernel/cpu/sh4/fpu.c: error: 'TRAP_HANDLER_DECL' undeclared (first use in this function):  => 407:2
  + arch/sh/kernel/cpu/sh4/fpu.c: error: 'regs' undeclared (first use in this function):  => 409:20
  + arch/sh/kernel/cpu/shmobile/pm.c: error: implicit declaration of function 'clear_bl_bit' [-Werror=implicit-function-declaration]:  => 140:2
  + arch/sh/kernel/cpu/shmobile/pm.c: error: implicit declaration of function 'set_bl_bit' [-Werror=implicit-function-declaration]:  => 137:2
  + arch/sh/kernel/kgdb.c: error: 'TRAP_HANDLER_DECL' undeclared (first use in this function):  => 258:2
  + arch/sh/kernel/kgdb.c: error: 'regs' undeclared (first use in this function):  => 261:2
  + arch/sh/kernel/kgdb.c: error: control reaches end of non-void function [-Werror=return-type]:  => 264:1
  + arch/sh/kernel/kgdb.c: error: function declaration isn't a prototype [-Werror=strict-prototypes]:  => 255:1
  + arch/sh/kernel/kgdb.c: error: return type defaults to 'int' [-Werror=return-type]:  => 255:1
  + arch/sh/kernel/process_32.c: error: implicit declaration of function 'is_dsp_enabled' [-Werror=implicit-function-declaration]:  => 178:2
  + arch/sh/kernel/smp.c: error: implicit declaration of function 'per_cpu_trap_init' [-Werror=implicit-function-declaration]:  => 193:2
  + arch/sh/mm/cache-sh4.c: error: implicit declaration of function '__ocbwb' [-Werror=implicit-function-declaration]:  => 70:3
  + arch/sh/mm/flush-sh4.c: error: implicit declaration of function '__ocbi' [-Werror=implicit-function-declaration]:  => 87:3
  + arch/sh/mm/flush-sh4.c: error: implicit declaration of function '__ocbp' [-Werror=implicit-function-declaration]:  => 57:3
  + arch/sh/mm/flush-sh4.c: error: implicit declaration of function '__ocbwb' [-Werror=implicit-function-declaration]:  => 23:3
  + arch/sh/mm/flush-sh4.c: error: implicit declaration of function 'register_align' [-Werror=implicit-function-declaration]:  => 16:2
  + arch/um/drivers/mconsole_kern.c: error: implicit declaration of function 'switch_to':  => 707
  + arch/xtensa/include/asm/io.h: error: implicit declaration of function 'BUG' [-Werror=implicit-function-declaration]:  => 77:3
  + arch/xtensa/kernel/signal.c: error: 'ret' undeclared (first use in this function):  => 532:3
  + drivers/acpi/processor_idle.c: error: implicit declaration of function 'halt' [-Werror=implicit-function-declaration]:  => 789:4
  + drivers/bcma/driver_pci_host.c: error: implicit declaration of function 'pcibios_enable_device' [-Werror=implicit-function-declaration]:  => 518:2
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
  + drivers/mmc/core/cd-gpio.c: error: implicit declaration of function 'gpio_to_irq' [-Werror=implicit-function-declaration]:  => 35:2
  + drivers/mtd/devices/./docg3.h: error: initializer element is not constant:  => 346:1
  + drivers/net/can/sja1000/peak_pcmcia.c: error: implicit declaration of function 'ioport_map' [-Werror=implicit-function-declaration]:  => 672:2
  + drivers/net/can/sja1000/peak_pcmcia.c: error: implicit declaration of function 'ioport_unmap' [-Werror=implicit-function-declaration]:  => 626:2
  + drivers/net/can/sja1000/peak_pcmcia.c: error: implicit declaration of function 'ioread8' [-Werror=implicit-function-declaration]:  => 187:2
  + drivers/net/can/sja1000/peak_pcmcia.c: error: implicit declaration of function 'iowrite8' [-Werror=implicit-function-declaration]:  => 214:2
  + drivers/net/ethernet/realtek/r8169.c: error: implicit declaration of function 'mmiowb' [-Werror=implicit-function-declaration]:  => 1203:2
  + drivers/net/wireless/brcm80211/brcmsmac/./brcms_trace_events.h: error: initializer element is not constant:  => 66:1, 37:1
  + drivers/net/wireless/iwlegacy/common.h: error: implicit declaration of function 'mmiowb' [-Werror=implicit-function-declaration]:  => 2034:2
  + drivers/net/wireless/iwlwifi/iwl-io.c: error: implicit declaration of function 'mmiowb' [-Werror=implicit-function-declaration]:  => 145:2
  + drivers/net/wireless/iwlwifi/iwl-testmode.c: error: implicit declaration of function 'mmiowb' [-Werror=implicit-function-declaration]:  => 839:5
  + drivers/net/wireless/iwmc3200wifi/./trace.h: error: initializer element is not constant:  => 181:1, 216:1, 101:1, 58:1, 20:1, 250:1, 154:1
  + drivers/pci/quirks.c: error: implicit declaration of function 'pci_iomap' [-Werror=implicit-function-declaration]:  => 2901:2
  + drivers/pci/quirks.c: error: implicit declaration of function 'pci_iounmap' [-Werror=implicit-function-declaration]:  => 2915:2
  + drivers/power/smb347-charger.c: error: implicit declaration of function 'gpio_free' [-Werror=implicit-function-declaration]:  => 939:2
  + drivers/power/smb347-charger.c: error: implicit declaration of function 'gpio_request_one' [-Werror=implicit-function-declaration]:  => 897:2
  + drivers/power/smb347-charger.c: error: implicit declaration of function 'gpio_to_irq' [-Werror=implicit-function-declaration]:  => 895:2
  + drivers/ptp/ptp_pch.c: error: implicit declaration of function 'ioread32' [-Werror=implicit-function-declaration]:  => 152:2
  + drivers/ptp/ptp_pch.c: error: implicit declaration of function 'iowrite32' [-Werror=implicit-function-declaration]:  => 153:2
  + drivers/regulator/tps62360-regulator.c: error: implicit declaration of function 'gpio_direction_output' [-Werror=implicit-function-declaration]:  => 336:3
  + drivers/regulator/tps62360-regulator.c: error: implicit declaration of function 'gpio_free' [-Werror=implicit-function-declaration]:  => 341:4
  + drivers/regulator/tps62360-regulator.c: error: implicit declaration of function 'gpio_request' [-Werror=implicit-function-declaration]:  => 329:3
  + drivers/staging/android/persistent_ram.c: error: 'PAGE_KERNEL' undeclared (first use in this function):  => 350:26
  + drivers/staging/android/persistent_ram.c: error: implicit declaration of function 'memblock_reserve' [-Werror=implicit-function-declaration]:  => 457:2
  + drivers/staging/android/persistent_ram.c: error: implicit declaration of function 'offset_in_page' [-Werror=implicit-function-declaration]:  => 347:2
  + drivers/staging/android/persistent_ram.c: error: implicit declaration of function 'pgprot_noncached' [-Werror=implicit-function-declaration]:  => 350:2
  + drivers/staging/android/persistent_ram.c: error: invalid use of undefined type 'struct page':  => 361:3
  + drivers/staging/xgifb/../../video/sis/vstruct.h: error: expected identifier or '(' before numeric constant:  => 135:16
  + drivers/usb/gadget/pch_udc.c: error: implicit declaration of function 'gpio_direction_input' [-Werror=implicit-function-declaration]:  => 1401:2
  + drivers/usb/gadget/pch_udc.c: error: implicit declaration of function 'gpio_free' [-Werror=implicit-function-declaration]:  => 1432:3
  + drivers/usb/gadget/pch_udc.c: error: implicit declaration of function 'gpio_get_value' [-Werror=implicit-function-declaration]:  => 1267:3
  + drivers/usb/gadget/pch_udc.c: error: implicit declaration of function 'gpio_request' [-Werror=implicit-function-declaration]:  => 1393:2
  + drivers/usb/gadget/pch_udc.c: error: implicit declaration of function 'gpio_to_irq' [-Werror=implicit-function-declaration]:  => 1404:2
  + drivers/video/i740fb.c: error: implicit declaration of function 'pci_iounmap' [-Werror=implicit-function-declaration]:  => 1165:2
  + error: pci.c: undefined reference to `pci_realloc_get_opt':  => .init.text+0x1a0), .init.text+0x174)
  + fs/binfmt_elf.c: error: implicit declaration of function 'arch_align_stack':  => 165
  + fs/exec.c: error: implicit declaration of function 'arch_align_stack':  => 686
  + fs/gfs2/./trace_gfs2.h: error: initializer element is not constant:  => 242:1, 148:1, 418:1, 77:1, 212:1, 362:1, 337:1, 306:1, 383:1, 116:1, 182:1, 458:1
  + fs/ocfs2/./ocfs2_trace.h: error: initializer element is not constant:  => 1849:1, 2370:1, 875:1, 2199:1, 2493:1, 769:1, 1401:1, 2741:1, 1502:1, 1799:1, 968:1, 2590:1, 652:1, 2655:1, 1841:1, 2659:1, 1711:1, 761:1, 2374:1, 2032:1, 1038:1, 2439:1, 1833:1, 501:1, 1835:1, 1317:1, 2036:1, 2568:1, 656:1, 712:1, 964:1, 1843:1, 1315:1, 410:1, 660:1, 1847:1, 997:1, 1887:1, 2261:1, 1566:1, 2653:1, 999:1, 970:1, 1092:1, 1819:1, 1544:1, 1536:1, 1323:1, 2677:1, 2473:1, 883:1, 2683:1, 785:1, 2191:1, 1853:1, 1829:1, 1542:1, 2150:1, 2049:1, 1500:1, 2011:1, 2578:1, 2257:1, 1859:1, 1574:1, 2661:1, 877:1, 2201:1, 1797:1, 1629:1, 412:1, 2745:1, 728:1, 2727:1, 793:1, 2592:1, 893:1, 1949:1, 2647:1, 2622:1, 779:1, 738:1, 974:1, 759:1, 1568:1, 873:1, 1030:1, 722:1, 2047:1, 1641:1, 929:1, 2353:1, 777:1, 1149:1, 1977:1, 714:1, 1817:1, 2675:1, 2753:1, 1631:1, 1570:1, 1447:1, 831:1, 767:1, 548:1, 1647:1, 2588:1, 829:1, 2673:1, 2038:1, 1403:1, 1538:1, 479:1, 666:1, 2309:1, 734:1, 1739:1, 602:1, 2747:1, 1321:1, 2574:1, 408:1, 2620:1, 2295:1, 1813:1, 1987:1, 789:1, 1915:1, 732:1, 1351:1, 1159:1, 1863:1, 2743:1, 1825:1, 1823:1, 1917:1, 1477:1, 1040:1, 1405:1, 2395:1, 1578:1, 2749:1, 668:1, 1975:1, 1090:1, 1311:1, 1034:1, 2043:1, 1801:1, 650:1, 2372:1, 1837:1, 2594:1, 1064:1, 654:1, 1576:1, 420:1, 2681:1, 1889:1, 2075:1, 2329:1, 2721:1, 833:1, 962:1, 2154:1, 2148:1, 781:1, 730:1, 2584:1, 2453:1, 1445:1, 585:1, 821:1, 2101:1, 1695:1, 1979:1, 2203:1, 1697:1, 1036:1, 1811:1, 2077:1, 1865:1, 422:1, 976:1, 2255:1, 2197:1, 972:1, 2649:1, 2537:1, 418:1, 1595:1, 560:1, 2193:1, 2566:1, 1681:1, 1827:1, 1449:1, 1181:1, 2431:1, 1325:1, 817:1, 2120:1, 1151:1, 1246:1, 2437:1, 966:1, 791:1, 1805:1, 2679:1, 2651:1, 2586:1, 1161:1, 2411:1, 2582:1, 720:1, 1218:1, 736:1, 2725:1, 2435:1, 2663:1, 2580:1, 2433:1, 2152:1, 783:1, 891:1, 853:1, 1309:1, 885:1, 527:1, 2657:1, 1713:1, 1633:1, 2034:1, 771:1, 1821:1, 416:1, 724:1, 825:1, 1374:1, 2259:1, 1564:1, 1307:1, 2751:1, 2509:1, 1572:1, 787:1, 1601:1, 2081:1, 2331:1, 889:1, 1851:1, 1861:1, 2665:1, 1443:1, 414:1, 1985:1, 897:1, 823:1, 658:1, 2232:1, 1153:1, 895:1, 1313:1, 2755:1, 1157:1, 2618:1, 2513:1, 960:1, 1441:1, 726:1, 1815:1, 1635:1, 1741:1, 1155:1, 1540:1, 2564:1, 2723:1, 1516:1, 1803:1, 931:1, 691:1, 1795:1, 2511:1, 2122:1, 2598:1, 2079:1, 2118:1, 1891:1, 2645:1, 2195:1, 664:1, 1319:1, 454:1, 1831:1, 827:1, 1451:1, 2517:1, 2539:1, 887:1, 1893:1, 2576:1, 1845:1, 2667:1, 662:1, 1001:1, 436:1, 2596:1, 1483:1, 2205:1, 2311:1, 1807:1, 819:1, 2697:1, 2045:1, 1032:1, 1809:1, 1664:1, 1743:1, 1839:1, 2515:1, 815:1
  + fs/xfs/./xfs_trace.h: error: initializer element is not constant:  => 1466:1, 1481:1, 1398:1, 127:1, 1531:1, 1514:1, 495:1, 323:1, 327:1, 925:1, 484:1, 1401:1, 1492:1, 1470:1, 1463:1, 971:1, 574:1, 319:1, 850:1, 324:1, 1502:1, 330:1, 926:1, 846:1, 847:1, 652:1, 761:1, 497:1, 1505:1, 502:1, 501:1, 571:1, 1404:1, 621:1, 656:1, 1409:1, 1056:1, 750:1, 1089:1, 486:1, 1480:1, 321:1, 274:1, 970:1, 1396:1, 339:1, 1650:1, 1536:1, 1513:1, 883:1, 1399:1, 1058:1, 185:1, 1493:1, 1500:1, 325:1, 483:1, 488:1, 1784:1, 331:1, 1574:1, 392:1, 751:1, 346:1, 1783:1, 849:1, 345:1, 561:1, 494:1, 1407:1, 1497:1, 336:1, 133:1, 487:1, 1476:1, 1469:1, 752:1, 329:1, 749:1, 759:1, 924:1, 1478:1, 1491:1, 838:1, 94:1, 131:1, 1019:1, 326:1, 852:1, 1472:1, 492:1, 1211:1, 1506:1, 485:1, 1816:1, 504:1, 318:1, 539:1, 745:1, 1494:1, 1817:1, 1732:1, 1570:1, 332:1, 851:1, 1400:1, 1818:1, 1410:1, 338:1, 1736:1, 748:1, 1473:1, 496:1, 843:1, 273:1, 1734:1, 317:1, 563:1, 1403:1, 1538:1, 743:1, 1471:1, 1230:1, 1508:1, 388:1, 1020:1, 1519:1, 93:1, 1739:1, 583:1, 1467:1, 568:1, 572:1, 1178:1, 758:1, 567:1, 1418:1, 1569:1, 762:1, 1525:1, 1509:1, 1475:1, 1461:1, 1696:1, 95:1, 91:1, 506:1, 747:1, 1018:1, 1530:1, 1417:1, 1477:1, 1405:1, 1176:1, 569:1, 1651:1, 335:1, 1733:1, 562:1, 650:1, 840:1, 503:1, 96:1, 322:1, 337:1, 500:1, 654:1, 1479:1, 845:1, 582:1, 618:1, 577:1, 333:1, 839:1, 763:1, 842:1, 1503:1, 651:1, 1460:1, 753:1, 1114:1, 1539:1, 505:1, 756:1, 587:1, 491:1, 1526:1, 1695:1, 1499:1, 1179:1, 619:1, 1465:1, 537:1, 1087:1, 1535:1, 493:1, 744:1, 927:1, 1414:1, 1177:1, 1468:1, 570:1, 1055:1, 320:1, 1416:1, 1181:1, 1412:1, 1693:1, 1017:1, 746:1, 344:1, 1462:1, 498:1, 841:1, 1413:1, 1498:1, 622:1, 1738:1, 1532:1, 576:1, 1785:1, 128:1, 1402:1, 1511:1, 1529:1, 885:1, 340:1, 1735:1, 755:1, 538:1, 129:1, 579:1, 1406:1, 130:1, 334:1, 886:1, 1572:1, 837:1, 1411:1, 1510:1, 580:1, 565:1, 1528:1, 276:1, 1537:1, 536:1, 275:1, 1419:1, 1495:1, 1737:1, 1175:1, 581:1, 1057:1, 757:1, 1397:1, 564:1, 1527:1, 489:1, 389:1, 1464:1, 1518:1, 1459:1, 1815:1, 1540:1, 1571:1, 390:1, 1694:1, 499:1, 1541:1, 90:1, 328:1, 1516:1, 343:1, 1474:1, 584:1, 764:1, 848:1, 1287:1, 1408:1, 1490:1, 1507:1, 969:1, 754:1, 578:1, 1533:1, 1489:1, 653:1, 887:1, 92:1, 620:1, 586:1, 1517:1, 1482:1, 97:1, 760:1, 1483:1, 1512:1, 923:1, 1501:1, 844:1, 1692:1, 482:1, 1086:1, 884:1, 1395:1, 1534:1, 1504:1, 490:1, 1415:1
  + include/asm-generic/bitops/fls64.h: error: static declaration of 'fls64' follows non-static declaration:  => 26:28, 18:28
  + include/asm-generic/cmpxchg.h: error: expected ')' before 'u16':  => 45:20, 46:14
  + include/asm-generic/cmpxchg.h: error: expected ')' before 'u32':  => 56:20, 57:14
  + include/asm-generic/cmpxchg.h: error: expected ')' before 'u8':  => 35:14, 34:20
  + include/asm-generic/cmpxchg.h: error: invalid type argument of unary '*' (have 'int'):  => 56:9, 46:3, 57:3, 35:3, 34:9, 45:9
  + include/asm-generic/cmpxchg.h: error: redefinition of '__xchg':  => 24:15
  + include/asm-generic/pgtable-nopud.h: error: unknown type name 'pgd_t':  => 13:16, 38:65, 25:59, 28:61, 26:58, 27:62
  + include/asm-generic/pgtable.h: error: implicit declaration of function 'pgd_bad' [-Werror=implicit-function-declaration]:  => 260:2
  + include/asm-generic/pgtable.h: error: implicit declaration of function 'pgd_none' [-Werror=implicit-function-declaration]:  => 258:2
  + include/asm-generic/pgtable.h: error: request for member 'pgd' in something not a structure or union:  => 269:22
  + include/linux/bitops.h: error: conflicting types for 'fls_long':  => 160:24
  + include/linux/debug_locks.h: error: implicit declaration of function 'xchg' [-Werror=implicit-function-declaration]:  => 16:2
  + include/linux/llist.h: error: asm/cmpxchg.h: No such file or directory:  => 59:25
  + include/linux/llist.h: error: implicit declaration of function 'BUILD_BUG_ON' [-Werror=implicit-function-declaration]:  => 178:2
  + include/linux/log2.h: error: implicit declaration of function 'fls' [-Werror=implicit-function-declaration]:  => 34:2
  + include/linux/log2.h: error: implicit declaration of function 'fls64' [-Werror=implicit-function-declaration]:  => 42:2
  + include/linux/log2.h: error: implicit declaration of function 'fls_long' [-Werror=implicit-function-declaration]:  => 63:2
  + include/linux/types.h: error: unknown type name '__kernel_caddr_t':  => 88:1
  + include/linux/types.h: error: unknown type name '__kernel_clock_t':  => 83:1
  + include/linux/types.h: error: unknown type name '__kernel_clockid_t':  => 35:1
  + include/linux/types.h: error: unknown type name '__kernel_daddr_t':  => 236:2, 31:1
  + include/linux/types.h: error: unknown type name '__kernel_gid16_t':  => 43:1
  + include/linux/types.h: error: unknown type name '__kernel_gid32_t':  => 41:1
  + include/linux/types.h: error: unknown type name '__kernel_ino_t':  => 25:1, 237:2
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
  + include/trace/events/9p.h: error: initializer element is not constant:  => 128:1, 102:1, 80:1
  + include/trace/events/asoc.h: error: initializer element is not constant:  => 302:1, 98:1, 89:1, 203:1, 45:1, 283:1, 134:1, 195:1, 219:1, 126:1, 167:1, 244:1, 54:1, 211:1, 159:1, 261:1
  + include/trace/events/block.h: error: initializer element is not constant:  => 432:13, 91:13, 450:13, 450:1, 160:13, 534:13, 295:13, 309:13, 432:1, 295:1, 387:13, 372:1, 354:1, 216:13, 372:13, 178:13, 280:1, 91:1, 490:13, 534:1, 57:1, 387:1, 178:1, 145:13, 57:13, 160:1, 145:1, 73:13, 280:13, 73:1, 216:1, 309:1, 354:13, 490:1
  + include/trace/events/block.h: error: initializer element is not constantmake[2]: :  => 178:1
  + include/trace/events/btrfs.h: error: initializer element is not constant:  => 514:1, 697:1, 690:1, 127:1, 704:1, 595:1, 889:1, 259:1, 344:1, 867:1, 432:1, 61:1, 773:1, 638:1, 407:1, 832:1, 134:1, 603:1, 158:1, 336:1, 273:1, 587:1, 764:1, 471:1, 266:1, 815:1, 120:1, 782:1, 280:1, 377:1
  + include/trace/events/ext3.h: error: initializer element is not constant:  => 130:13, 108:13, 697:1, 617:1, 782:13, 565:1, 342:13, 638:1, 271:13, 218:13, 108:1, 590:1, 292:13, 810:1, 475:1, 318:1, 397:13, 768:1, 210:1, 39:13, 841:13, 519:1, 723:13, 590:13, 278:1, 638:13, 519:13, 226:13, 292:1, 496:1, 278:13, 697:13, 617:13, 775:1, 152:1, 285:13, 61:13, 666:1, 452:1, 152:13, 342:1, 841:1, 285:1, 9:13, 318:13, 257:1, 775:13, 397:1, 425:13, 810:13, 226:1, 368:1, 257:13, 452:13, 496:13, 9:1, 218:1, 545:13, 666:13, 264:13, 61:1, 545:1, 86:13, 723:1, 271:1, 368:13, 39:1, 130:1, 425:1, 475:13, 768:13, 210:13, 86:1, 264:1, 565:13, 782:1
  + include/trace/events/ext4.h: error: initializer element is not constant:  => 333:1, 446:1, 1200:1, 1749:1, 1285:1, 373:1, 21:1, 1114:1, 753:1, 1384:1, 803:1, 722:1, 432:1, 1897:1, 119:1, 1611:1, 1514:1, 1672:1, 275:1, 283:1, 1080:1, 1682:1, 824:1, 72:1, 1591:1, 540:1, 215:1, 1179:1, 619:1, 1841:1, 1720:1, 141:1, 680:1, 1437:1, 1779:1, 267:1, 548:1, 988:1, 1010:1, 1806:1, 640:1, 916:1, 439:1, 598:1, 1258:1, 223:1, 479:1, 1507:1, 575:1, 1938:1, 1566:1, 999:1, 50:1, 1314:1, 2024:1, 453:1, 1227:1, 291:1, 1552:1, 1399:1, 1339:1, 97:1, 780:1, 163:1, 1193:1, 1559:1, 1172:1, 1662:1, 1998:1, 532:1, 259:1, 849:1, 1186:1, 1975:1, 1391:1, 1867:1, 1037:1
  + include/trace/events/gpio.h: error: initializer element is not constant:  => 31:13, 9:13
  + include/trace/events/irq.h: error: initializer element is not constant:  => 67:13, 112:13, 126:1, 140:13, 67:1, 37:1, 140:1, 112:1, 126:13, 37:13
  + include/trace/events/jbd.h: error: initializer element is not constant:  => 180:1, 61:13, 82:1, 82:13, 75:13, 68:13, 61:1, 151:1, 180:13, 129:1, 10:1, 129:13, 105:13, 75:1, 10:13, 54:13, 54:1, 105:1, 151:13, 68:1
  + include/trace/events/jbd2.h: error: initializer element is not constant:  => 77:1, 63:1, 179:1, 135:1, 70:1, 13:1, 56:1, 84:1, 239:1, 210:1, 91:1, 115:1
  + include/trace/events/kmem.h: error: initializer element is not constant:  => 108:13, 256:1, 53:1, 249:13, 143:13, 150:1, 172:13, 136:1, 45:1, 249:1, 194:1, 99:1, 53:13, 99:13, 108:1, 267:13, 172:1, 267:1, 194:13, 143:1, 136:13, 45:13, 256:13, 150:13
  + include/trace/events/lock.h: error: initializer element is not constant:  => 66:1, 57:13, 57:1, 12:13, 73:1, 12:1
  + include/trace/events/module.h: error: initializer element is not constant:  => 47:1, 47:13, 104:13, 96:13, 96:1, 28:13, 89:1, 89:13, 28:1, 104:1
  + include/trace/events/napi.h: error: initializer element is not constant:  => 13:13, 13:1
  + include/trace/events/net.h: error: initializer element is not constant:  => 61:13, 75:1, 75:13, 68:13, 61:1, 12:13, 12:1, 68:1
  + include/trace/events/oom.h: error: initializer element is not constant:  => 8:1, 8:13
  + include/trace/events/power.h: error: initializer element is not constant  CC [M]  drivers/leds/leds-dac124s085.o:  => 51:1
  + include/trace/events/power.h: error: initializer element is not constant:  => 232:13, 96:13, 51:13, 44:1, 193:1, 193:13, 110:13, 110:1, 30:1, 51:1, 200:13, 200:1, 96:1, 103:1, 186:13, 103:13, 186:1, 232:1, 44:13, 30:13
  + include/trace/events/printk.h: error: initializer element is not constant:  => 9:1, 9:13
  + include/trace/events/rcu.h: error: initializer element is not constant:  => 79:13, 450:13, 450:1, 483:13, 142:13, 115:13, 296:13, 20:13, 421:1, 356:1, 356:13, 391:13, 320:13, 255:1, 255:13, 521:13, 421:13, 483:1, 391:1, 50:13, 171:13, 20:1, 296:1, 215:13, 521:1, 320:1
  + include/trace/events/regmap.h: error: initializer element is not constant:  => 90:1, 162:1, 58:1, 118:1, 97:1, 40:1, 111:1, 170:1, 49:1, 104:1
  + include/trace/events/regulator.h: error: initializer element is not constant:  => 40:1, 32:1, 48:1, 64:1, 130:1, 98:1, 56:1
  + include/trace/events/rpm.h: error: initializer element is not constant:  => 77:1, 64:1, 70:1, 58:1
  + include/trace/events/sched.h: error: initializer element is not constant:  => 83:13, 348:1, 14:1, 114:13, 83:1, 282:1, 363:13, 254:13, 404:1, 36:1, 371:13, 229:13, 36:13, 356:1, 356:13, 340:13, 155:13, 207:1, 404:13, 254:1, 215:1, 215:13, 229:1, 114:1, 340:1, 90:13, 363:1, 222:13, 282:13, 155:1, 348:13, 90:1, 207:13, 14:13, 222:1, 371:1
  + include/trace/events/scsi.h: error: initializer element is not constant:  => 201:13, 201:1, 341:1, 243:13, 243:1, 345:13, 345:1, 341:13, 337:1, 337:13
  + include/trace/events/signal.h: error: initializer element is not constant:  => 96:13, 50:13, 96:1, 50:1
  + include/trace/events/skb.h: error: initializer element is not constant:  => 36:1, 14:13, 53:1, 14:1, 36:13, 53:13
  + include/trace/events/sock.h: error: initializer element is not constant  CC [M]  drivers/isdn/hisax/lmgr.o:  => 10:1
  + include/trace/events/sock.h: error: initializer element is not constant:  => 32:1, 32:13, 10:13, 10:1
  + include/trace/events/sunrpc.h: error: initializer element is not constant:  => 114:1, 98:1, 38:1, 114:13, 106:13, 32:1, 44:1, 167:13, 159:13, 98:13, 106:1, 167:1, 38:13, 32:13, 44:13, 159:1
  + include/trace/events/syscalls.h: error: initializer element is not constant:  => 19:1, 45:1, 45:13, 19:13
  + include/trace/events/task.h: error: initializer element is not constant:  => 33:13, 8:1, 33:1, 8:13
  + include/trace/events/timer.h: error: initializer element is not constant:  => 130:13, 160:13, 304:1, 106:13, 75:13, 32:1, 196:13, 44:1, 242:13, 253:13, 117:13, 267:13, 242:1, 160:1, 106:1, 253:1, 304:13, 267:1, 130:1, 117:1, 196:1, 75:1, 32:13, 44:13
  + include/trace/events/udp.h: error: initializer element is not constant:  => 10:13, 10:1
  + include/trace/events/vmscan.h: error: initializer element is not constant:  => 130:13, 450:13, 450:1, 439:13, 227:13, 75:13, 342:1, 182:13, 342:13, 326:1, 168:13, 168:1, 310:13, 75:1, 310:1, 123:13, 39:13, 175:1, 398:1, 365:13, 365:1, 123:1, 227:1, 398:13, 39:1, 130:1, 326:13, 175:13, 161:1, 444:1, 137:13, 56:1, 56:13, 161:13, 439:1, 137:1, 182:1, 444:13
  + include/trace/events/workqueue.h: error: initializer element is not constant:  => 111:13, 37:1, 86:1, 86:13, 73:13, 111:1, 73:1, 37:13
  + include/trace/events/writeback.h: error: initializer element is not constant:  => 460:13, 82:1, 171:1, 118:1, 77:261, 114:253, 119:1, 80:249, 453:1, 115:1, 396:1, 403:1, 403:13, 118:277, 251:13, 84:13, 173:13, 84:1, 116:1, 80:1, 117:301, 79:245, 453:13, 77:1, 396:13, 121:1, 114:1, 460:1, 251:1, 115:289, 203:1, 81:257, 78:249, 203:13, 81:1, 117:1, 78:1, 79:1, 173:1, 171:241, 294:1, 120:1, 119:285, 82:245, 294:13, 121:273, 116:273, 120:277
  + kernel/dma.c: error: implicit declaration of function 'xchg' [-Werror=implicit-function-declaration]:  => 74:2
  + kernel/sched/core.c: error: 'struct thread_struct' has no member named 'ip':  => 2086
  + kernel/sched/core.c: error: 'struct thread_struct' has no member named 'sp':  => 2086
  + kernel/sched/core.c: error: invalid lvalue in asm output 0:  => 2086
  + kernel/sched/core.c: error: invalid lvalue in asm output 1:  => 2086
  + kernel/sched/core.c: error: memory input 8 is not directly addressable:  => 2086
  + kernel/sched/core.c: error: memory input 9 is not directly addressable:  => 2086
  + kernel/trace/./trace_events_filter_test.h: error: initializer element is not constant:  => 9:1
  + net/mac80211/./driver-trace.h: error: initializer element is not constant:  => 446:1, 677:1, 536:1, 1190:1, 1281:1, 169:1, 1506:1, 938:1, 464:1, 311:1, 971:1, 475:1, 1169:1, 470:1, 116:1, 458:1, 159:1, 1145:1, 1257:1, 813:1, 595:1, 332:1, 1155:1, 1028:1, 834:1, 652:1, 862:1, 164:1, 384:1, 744:1, 511:1, 546:1, 1429:1, 418:1, 145:1, 750:1, 1455:1, 912:1, 1403:1, 452:1, 213:1, 1434:1, 541:1, 1213:1, 567:1, 887:1, 791:1, 943:1, 219:1, 1343:1, 1322:1, 185:1, 360:1, 480:1, 1379:1, 627:1, 1300:1, 1530:1, 1033:1, 1361:1, 755:1, 994:1, 713:1, 1424:1, 1060:1, 1262:1, 130:1, 179:1, 174:1, 719:1, 1234:1, 1479:1, 111:1, 1023:1, 1088:1, 261:1
  + sound/soc/codecs/max9768.c: error: implicit declaration of function 'gpio_free' [-Werror=implicit-function-declaration]:  => 206:3
  + sound/soc/codecs/max9768.c: error: implicit declaration of function 'gpio_request_one' [-Werror=implicit-function-declaration]:  => 175:3
  + sound/soc/codecs/wm2200.c: error: implicit declaration of function 'gpio_free' [-Werror=implicit-function-declaration]:  => 2169:3
  + sound/soc/codecs/wm2200.c: error: implicit declaration of function 'gpio_request_one' [-Werror=implicit-function-declaration]:  => 2046:3
  + sound/soc/sh/fsi.c: error: too few arguments to function 'chan->device->device_prep_slave_sg':  => 1006:9

75 improvements:
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
  - error: "__ashrdi3" [fs/ntfs/ntfs.ko] undefined!: N/A => 
  - error: "__ashrdi3" [fs/xfs/xfs.ko] undefined!: N/A => 
  - error: "__lshrdi3" [drivers/mtd/mtd.ko] undefined!: N/A => 
  - error: "__lshrdi3" [fs/ntfs/ntfs.ko] undefined!: N/A => 
  - error: "__lshrdi3" [fs/xfs/xfs.ko] undefined!: N/A => 
  - error: vsprintf.c: relocation truncated to fit: R_AVR32_9UW_PCREL against `.text'+9e4: (.text+0x7da) => 
  - error: vsprintf.c: relocation truncated to fit: R_AVR32_9UW_PCREL against `.text'+9e8: (.text+0x7ea) => 
  - fs/xfs/xfs_log_priv.h: error: unknown type name 'atomic64_t': 533:2, 529:2, 521:2, 580:23, 519:2, 622:24, 610:23, 592:24 => 529:2, 479:2, 580:23, 622:24, 610:23, 592:24, 531:2
  - include/linux/prefetch.h: Error: couldn't find a valid instruction format: 62 => 
  - include/linux/prefetch.h: Error: unknown opcode or format name 'static': 53 => 
  - lib/mpi/generic_mpih-mul1.c: error: inconsistent operand constraints in an 'asm': 50:70 => 
  - lib/mpi/generic_mpih-mul2.c: error: inconsistent operand constraints in an 'asm': 49:70 => 
  - lib/mpi/generic_mpih-mul3.c: error: inconsistent operand constraints in an 'asm': 49:70 => 
  - lib/mpi/mpih-div.c: error: inconsistent operand constraints in an 'asm': 135:122, 135:371, 97:122, 106:121, 106:370, 97:371 => 
  - net/mac80211/ieee80211_i.h: error: field 'trig' has incomplete type: 707:21 => 
  - net/mac80211/led.c: error: 'struct led_classdev' has no member named 'trig_list': 278:411, 278:352, 278:59, 214:352, 214:411, 214:160, 278:319, 214:223, 214:319, 278:160, 214:59, 278:223 => 
  - net/mac80211/led.c: error: dereferencing pointer to incomplete type: 74:16, 83:16, 101:19, 92:19 => 
  - net/mac80211/led.c: error: implicit declaration of function 'led_trigger_register' [-Werror=implicit-function-declaration]: 75:3 => 
  - net/mac80211/led.c: error: implicit declaration of function 'led_trigger_unregister' [-Werror=implicit-function-declaration]: 119:3 => 
  - net/mac80211/led.c: error: invalid application of 'sizeof' to incomplete type 'struct led_trigger' : 90:36, 72:33, 99:36, 81:33 => 


*** WARNINGS ***

326 regressions:
  + .config: warning: symbol value '' invalid for X86_INTERNODE_CACHE_SHIFT:  => 258
  + arch/avr32/mach-at32ap/at32ap700x.c: warning: 'struct atmel_nand_data' declared inside parameter list:  => 1964
  + arch/avr32/mach-at32ap/include/mach/board.h: warning: 'struct atmel_nand_data' declared inside parameter list:  => 121
  + arch/avr32/mach-at32ap/include/mach/board.h: warning: its scope is only this definition or declaration, which is probably not what you want  LD      sound/parisc/built-in.o:  => 121
  + arch/avr32/mach-at32ap/include/mach/board.h: warning: its scope is only this definition or declaration, which is probably not what you want:  => 121
  + arch/blackfin/include/asm/cmpxchg.h: warning: "xchg" redefined [enabled by default]:  => 129:0
  + arch/m32r/include/asm/ptrace.h: warning: "PTRACE_O_TRACESYSGOOD" redefined [enabled by default]:  => 117:0
  + arch/parisc/include/asm/spinlock.h: warning: assignment makes pointer from integer without a cast [enabled by default]:  => 39:4, 50:4, 23:4
  + arch/parisc/include/asm/spinlock.h: warning: initialization makes pointer from integer without a cast [enabled by default]:  => 9:29
  + arch/s390/kernel/perf_cpum_cf.c: warning: format '%lx' expects argument of type 'long unsigned int', but argument 2 has type 'int' [-Wformat]:  => 205:3, 180:3
  + arch/sh/kernel/cpu/fpu.c: warning: control reaches end of non-void function [-Wreturn-type]:  => 84:1
  + arch/sh/kernel/cpu/fpu.c: warning: function declaration isn't a prototype [-Wstrict-prototypes]:  => 79:1
  + arch/sh/kernel/cpu/fpu.c: warning: return type defaults to 'int' [-Wreturn-type]:  => 79:1
  + arch/sh/kernel/cpu/sh2a/fpu.c: warning: 'return' with no value, in function returning non-void [-Wreturn-type]:  => 570:3
  + arch/sh/kernel/cpu/sh2a/fpu.c: warning: control reaches end of non-void function [-Wreturn-type]:  => 574:1
  + arch/sh/kernel/cpu/sh2a/fpu.c: warning: function declaration isn't a prototype [-Wstrict-prototypes]:  => 558:1
  + arch/sh/kernel/cpu/sh2a/fpu.c: warning: return type defaults to 'int' [-Wreturn-type]:  => 558:1
  + arch/sh/kernel/cpu/sh4/fpu.c: warning: 'return' with no value, in function returning non-void [-Wreturn-type]:  => 423:4
  + arch/sh/kernel/cpu/sh4/fpu.c: warning: control reaches end of non-void function [-Wreturn-type]:  => 428:1
  + arch/sh/kernel/cpu/sh4/fpu.c: warning: function declaration isn't a prototype [-Wstrict-prototypes]:  => 404:1
  + arch/sh/kernel/cpu/sh4/fpu.c: warning: return type defaults to 'int' [-Wreturn-type]:  => 404:1
  + arch/um/kernel/skas/mmu.c: warning: unused variable 'pages':  => 106
  + arch/x86/kernel/apic/io_apic.c: warning: 'io_apic_level_ack_pending' defined but not used [-Wunused-function]:  => 382:13
  + arch/xtensa/include/asm/io.h: warning: control reaches end of non-void function [-Wreturn-type]:  => 94:1, 81:1
  + drivers/ata/pata_arasan_cf.c: warning: 'arasan_cf_resume' defined but not used [-Wunused-function]:  => 936:12
  + drivers/ata/pata_arasan_cf.c: warning: 'arasan_cf_suspend' defined but not used [-Wunused-function]:  => 923:12
  + drivers/base/regmap/regmap.c: warning: 'ret' may be used uninitialized in this function [-Wuninitialized]:  => 744:2
  + drivers/dma/fsldma.c: warning: 'cookie' may be used uninitialized in this function [-Wuninitialized]:  => 426:2
  + drivers/gpu/drm/i915/i915_debugfs.c: warning: array subscript is above array bounds [-Warray-bounds]:  => 712:12, 711:12, 709:12, 713:12, 710:12, 708:12
  + drivers/gpu/drm/i915/i915_gem.c: warning: 'ret' may be used uninitialized in this function [-Wuninitialized]:  => 797:38, 390:38
  + drivers/gpu/drm/nouveau/nouveau_fbcon.c: warning: passing argument 1 of 'vga_switcheroo_client_fb_set' from incompatible pointer type [enabled by default]:  => 410:2
  + drivers/hwmon/ad7314.c: warning: 'data' may be used uninitialized in this function [-Wuninitialized]:  => 89:8
  + drivers/hwmon/ads1015.c: warning: 'in' may be used uninitialized in this function [-Wuninitialized]:  => 134:25
  + drivers/hwmon/ntc_thermistor.c: warning: 'temp' may be used uninitialized in this function [-Wuninitialized]:  => 298:2
  + drivers/md/md.c: warning: large integer implicitly truncated to unsigned type [-Woverflow]:  => 1146:3, 1428:3
  + drivers/md/raid5.c: warning: 'target' may be used uninitialized in this function [-Wuninitialized]: 910:2 => 909:2, 913:8
  + drivers/media/dvb/dvb-usb/mxl111sf.c: warning: unused variable 'tmp' [-Wunused-variable]:  => 343:5
  + drivers/media/video/uvc/uvc_v4l2.c: warning: ignoring return value of '__clear_user', declared with attribute warn_unused_result [-Wunused-result]:  => 1100:14
  + drivers/mfd/mc13xxx-core.c: warning: 'id' may be used uninitialized in this function [-Wuninitialized]:  => 783:10
  + drivers/mfd/s5m-core.c: warning: 'ret' may be used uninitialized in this function [-Wuninitialized]:  => 153:5
  + drivers/mfd/twl6030-irq.c: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]: 376:24, 394:9 => 398:24, 415:9, 415:81
  + drivers/mfd/wm8994-core.c: warning: 'patch_regs' may be used uninitialized in this function [-Wuninitialized]:  => 582:7
  + drivers/mtd/chips/cfi_cmdset_0001.c: warning: the frame size of 1452 bytes is larger than 1024 bytes [-Wframe-larger-than=]:  => 1797:1
  + drivers/mtd/chips/cfi_cmdset_0020.c: warning: the frame size of 1064 bytes is larger than 1024 bytes [-Wframe-larger-than=]:  => 1180:1
  + drivers/mtd/chips/cfi_cmdset_0020.c: warning: the frame size of 1440 bytes is larger than 1024 bytes [-Wframe-larger-than=]:  => 420:1
  + drivers/mtd/chips/cfi_cmdset_0020.c: warning: the frame size of 1788 bytes is larger than 1024 bytes [-Wframe-larger-than=]:  => 975:1
  + drivers/mtd/lpddr/lpddr_cmds.c: warning: 'r.x[0]' may be used uninitialized in this function [-Wuninitialized]:  => 422:15, 130:11
  + drivers/mtd/lpddr/qinfo_probe.c: warning: 'r.x[0]' may be used uninitialized in this function [-Wuninitialized]:  => 147:15, 96:11, 102:2, 145:20
  + drivers/mtd/ubi/wl.c: warning: 'e' may be used uninitialized in this function [-Wuninitialized]: 346:15, 466:28 => 460:10, 346:15, 465:28
  + drivers/net/can/sja1000/peak_pcmcia.c: warning: assignment makes pointer from integer without a cast [enabled by default]:  => 672:20
  + drivers/net/ethernet/pasemi/pasemi_mac.c: warning: passing argument 1 of 'netdev_alloc_skb' discards 'const' qualifier from pointer target type [enabled by default]:  => 646:3
  + drivers/net/wireless/ath/carl9170/mac.c: warning: 'power' may be used uninitialized in this function [-Wuninitialized]:  => 509:10
  + drivers/net/wireless/iwlwifi/iwl-devtrace.h: warning: 'struct device' declared inside parameter list [enabled by default]:  => 50:16, 67:16, 309:16, 263:16, 154:16, 101:16, 84:16, 114:16, 238:16, 134:16, 369:16, 278:16
  + drivers/net/wireless/iwlwifi/iwl-devtrace.h: warning: its scope is only this definition or declaration, which is probably not what you want [enabled by default]:  => 50:16
  + drivers/net/wireless/iwlwifi/iwl-io.h: warning: passing argument 1 of 'trace_iwlwifi_dev_ioread32' from incompatible pointer type [enabled by default]:  => 51:2
  + drivers/net/wireless/iwlwifi/iwl-io.h: warning: passing argument 1 of 'trace_iwlwifi_dev_iowrite32' from incompatible pointer type [enabled by default]:  => 44:2
  + drivers/net/wireless/iwlwifi/iwl-io.h: warning: passing argument 1 of 'trace_iwlwifi_dev_iowrite8' from incompatible pointer type [enabled by default]:  => 38:2
  + drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c: warning: passing argument 1 of 'trace_iwlwifi_dev_ict_read' from incompatible pointer type [enabled by default]:  => 1383:9, 1363:2
  + drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c: warning: passing argument 1 of 'trace_iwlwifi_dev_irq' from incompatible pointer type [enabled by default]:  => 1346:2, 1256:2
  + drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c: warning: passing argument 1 of 'trace_iwlwifi_dev_rx' from incompatible pointer type [enabled by default]:  => 390:2
  + drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c: warning: passing argument 1 of 'trace_iwlwifi_dev_ucode_error' from incompatible pointer type [enabled by default]:  => 632:11
  + drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c: warning: passing argument 1 of 'trace_iwlwifi_dev_ucode_event' from incompatible pointer type [enabled by default]:  => 774:6, 760:6
  + drivers/pci/quirks.c: warning: initialization makes pointer from integer without a cast [enabled by default]:  => 2901:15
  + drivers/scsi/mvsas/mv_sas.c: warning: unused variable 'dev' [-Wunused-variable]:  => 888:24
  + drivers/scsi/scsi_debug.c: warning: comparison of distinct pointer types lacks a cast [enabled by default]:  => 1888:11, 1797:13, 2055:9, 1727:14, 2034:9, 2007:2
  + drivers/scsi/scsi_debug.c: warning: passing argument 1 of '__div64_32' from incompatible pointer type [enabled by default]:  => 1797:4, 2034:3, 2055:3, 2007:2, 1888:2, 1727:2
  + drivers/scsi/scsi_debug.c: warning: right shift count >= width of type [enabled by default]:  => 1797:4, 2034:3, 2055:3, 2007:2, 1888:2, 1727:2
  + drivers/staging/android/alarm.c: warning: format '%ld' expects argument of type 'long int', but argument 2 has type 'int' [-Wformat]:  => 367:3, 344:2, 345:2
  + drivers/staging/android/persistent_ram.c: warning: format '%ld' expects argument of type 'long int', but argument 2 has type 'size_t' [-Wformat]:  => 430:4, 426:4
  + drivers/staging/android/persistent_ram.c: warning: format '%ld' expects argument of type 'long int', but argument 3 has type 'size_t' [-Wformat]:  => 430:4, 426:4
  + drivers/staging/telephony/ixj.c: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]:  => 7535:64, 7525:63
  + drivers/staging/vme/devices/vme_pio2_core.c: warning: return from incompatible pointer type [enabled by default]: 512:1, 516:1, 516:77, 512:78 => 512:87, 512:1, 516:86, 516:1, 516:77, 512:78
  + drivers/staging/zcache/zcache-main.c: warning: 'ret' may be used uninitialized in this function [-Wuninitialized]:  => 115:2
  + drivers/tty/n_gsm.c: warning: unused variable 'buf' [-Wunused-variable]:  => 2256:7
  + drivers/tty/serial/kgdboc.c: warning: statement with no effect [-Wunused-value]:  => 278:3, 292:3
  + drivers/usb/gadget/inode.c: warning: label 'restart' defined but not used [-Wunused-label]:  => 1577:1
  + drivers/usb/gadget/inode.c: warning: label 'restart' defined but not used:  => 1577
  + drivers/usb/host/xhci-mem.c: warning: 'type' may be used uninitialized in this function [-Wuninitialized]:  => 1455:19
  + drivers/video/aty/atyfb_base.c: warning: 'ram_dram' defined but not used [-Wunused-variable]:  => 534:13
  + drivers/video/aty/atyfb_base.c: warning: 'ram_resv' defined but not used [-Wunused-variable]:  => 535:13
  + drivers/video/aty/atyfb_base.c: warning: overflow in implicit constant conversion [-Woverflow]:  => 437:72
  + drivers/video/backlight/platform_lcd.c: warning: 'platform_lcd_resume' defined but not used [-Wunused-function]:  => 134:12
  + drivers/video/backlight/platform_lcd.c: warning: 'platform_lcd_suspend' defined but not used [-Wunused-function]:  => 124:12
  + drivers/virtio/virtio_pci.c: warning: 'virtio_pci_freeze' defined but not used [-Wunused-function]:  => 723:12
  + drivers/virtio/virtio_pci.c: warning: 'virtio_pci_restore' defined but not used [-Wunused-function]:  => 743:12
  + fs/btrfs/extent_io.c: warning: 'ret' may be used uninitialized in this function [-Wuninitialized]:  => 3190:5, 1951:2
  + fs/btrfs/file-item.c: warning: comparison of distinct pointer types lacks a cast [enabled by default]:  => 808:346, 767:320, 717:306, 808:703, 808:9, 717:7, 808:711, 717:302, 767:316, 767:21, 808:350
  + fs/ext4/ext4_jbd2.h: warning: control reaches end of non-void function [-Wreturn-type]:  => 360:1
  + fs/ext4/super.c: warning: unused variable 'sbi' [-Wunused-variable]:  => 1602:23
  + fs/ext4/super.c: warning: unused variable 'sbi':  => 1602
  + fs/nfs/nfs4xdr.c: warning: the frame size of 1032 bytes is larger than 1024 bytes [-Wframe-larger-than=]:  => 1718:1
  + fs/nfsd/nfs4recover.c: warning: format '%lu' expects argument of type 'long unsigned int', but argument 3 has type 'size_t' [-Wformat]:  => 581:2, 580:3
  + fs/nfsd/nfs4recover.c: warning: format '%lu' expects argument of type 'long unsigned int', but argument 4 has type 'unsigned int' [-Wformat]:  => 581:2, 580:3
  + fs/quota/quota.c: warning: 'quotactl_cmd_write' defined but not used [-Wunused-function]:  => 295:12
  + fs/ubifs/dir.c: warning: 'saved_nlink' may be used uninitialized in this function [-Wuninitialized]:  => 1107:12
  + fs/ubifs/dir.c: warning: 'saved_nlink' may be used uninitialized in this function:  => 980
  + include/asm-generic/cmpxchg.h: warning: type defaults to 'int' in type name:  => 45:20, 35:14, 34:20, 56:20, 46:14, 57:14
  + include/linux/ptrace.h: warning: "PTRACE_O_TRACESYSGOOD" redefined [enabled by default]:  => 65:0
  + include/linux/vga_switcheroo.h: warning: 'struct pci_dev' declared inside parameter list [enabled by default]:  => 49:91, 53:34, 28:30, 54:108
  + include/linux/vga_switcheroo.h: warning: its scope is only this definition or declaration, which is probably not what you want [enabled by default]:  => 28:30
  + include/media/v4l2-ctrls.h: warning: 'struct file' declared inside parameter list [enabled by default]:  => 505:55, 497:33
  + include/media/v4l2-ctrls.h: warning: its scope is only this definition or declaration, which is probably not what you want [enabled by default]:  => 497:33
  + kernel/power/qos.c: warning: control reaches end of non-void function:  => 143
  + kernel/trace/trace_events_filter.c: warning: 'ret' may be used uninitialized in this function [-Wuninitialized]:  => 2074:8
  + lib/crc32.c: warning: unused variable 't4' [-Wunused-variable]:  => 77:13
  + lib/crc32.c: warning: unused variable 't5' [-Wunused-variable]:  => 77:27
  + lib/crc32.c: warning: unused variable 't6' [-Wunused-variable]:  => 77:41
  + lib/crc32.c: warning: unused variable 't7' [-Wunused-variable]:  => 77:55
  + lib/debugobjects.c: warning: 'obj_states' defined but not used [-Wunused-variable]:  => 73:20
  + lib/debugobjects.c: warning: unused variable 'hint' [-Wunused-variable]:  => 256:9
  + mm/hugetlb.c: warning: 'page' may be used uninitialized in this function [-Wuninitialized]:  => 1135:5
  + mm/slob.c: warning: comparison of distinct pointer types lacks a cast [enabled by default]: 482:152, 535:153, 554:153 => 482:152, 535:15, 482:14, 535:153, 554:15, 554:153
  + mm/swapfile.c: warning: 'span' may be used uninitialized in this function [-Wuninitialized]:  => 2125:15
  + modpost: WARNING: modpost: Found 14 section mismatch(es).:  => N/A
  + net/dsa/slave.c: warning: 'dsa_slave_change_rx_flags' defined but not used [-Wunused-function]:  => 116:13
  + net/dsa/slave.c: warning: 'dsa_slave_close' defined but not used [-Wunused-function]:  => 98:12
  + net/dsa/slave.c: warning: 'dsa_slave_init' defined but not used [-Wunused-function]:  => 51:12
  + net/dsa/slave.c: warning: 'dsa_slave_ioctl' defined but not used [-Wunused-function]:  => 164:12
  + net/dsa/slave.c: warning: 'dsa_slave_open' defined but not used [-Wunused-function]:  => 60:12
  + net/dsa/slave.c: warning: 'dsa_slave_set_mac_address' defined but not used [-Wunused-function]:  => 136:12
  + net/dsa/slave.c: warning: 'dsa_slave_set_rx_mode' defined but not used [-Wunused-function]:  => 127:13
  + net/ipv4/ipconfig.c: warning: 'ic_nameservers' defined but not used [-Wunused-variable]:  => 152:15
  + net/ipv4/ipconfig.c: warning: 'ic_proto_used' defined but not used [-Wunused-variable]:  => 151:12
  + net/netfilter/nfnetlink_cttimeout.c: warning: 'ctnl_timeout_parse_policy' uses dynamic stack allocation [enabled by default]:  => 66:1
  + net/nfc/core.c: warning: passing argument 2 of 'nfc_llcp_general_bytes' from incompatible pointer type [enabled by default]:  => 207:2
  + net/nfc/llcp/llcp.c: warning: 'sn_len' may be used uninitialized in this function [-Wuninitialized]:  => 563:15
  + warning:   CC [M]  fs/xfs/xfs_iget.o:  => N/A
  + warning: (BRIDGE_NF_EBTABLES) selects NETFILTER_XTABLES which has unmet direct dependencies (NET && INET && NETFILTER):  => N/A
  + warning: (ETRAX_USB_HOST && MOUSE_APPLETOUCH && MOUSE_BCM5974 && MOUSE_SYNAPTICS_USB && JOYSTICK_XPAD && TABLET_USB_ACECAD && TABLET_USB_AIPTEK && TABLET_USB_HANWANG && TABLET_USB_KBTAB && TABLET_USB_WACOM && TOUCHSCREEN_USB_COMPOSITE && INPUT_ATI_REMOTE2 && INPUT_KEYSPAN_REMOTE && INPUT_POWERMATE && INPUT_YEALINK && INPUT_CM109) selects USB which has unmet direct dependencies (USB_SUPPORT && USB_ARCH_HAS_HCD):  => N/A
  + warning: (MOUSE_APPLETOUCH && MOUSE_BCM5974 && MOUSE_SYNAPTICS_USB && JOYSTICK_XPAD && TABLET_USB_ACECAD && TABLET_USB_AIPTEK && TABLET_USB_HANWANG && TABLET_USB_KBTAB && TABLET_USB_WACOM && TOUCHSCREEN_USB_COMPOSITE && INPUT_ATI_REMOTE2 && INPUT_KEYSPAN_REMOTE && INPUT_POWERMATE && INPUT_YEALINK && INPUT_CM109 && RC_ATI_REMOTE && IR_IMON && IR_MCEUSB && IR_REDRAT3 && IR_STREAMZAP && DRM_USB) selects USB which has unmet direct dependencies (USB_SUPPORT && USB_ARCH_HAS_HCD):  => N/A
  + warning: (PPC_CELL_NATIVE && 440EPX && 440GRX && 440GX && 440SPe && 460EX && 460SX && APM821xx && 405EX) selects IBM_EMAC_EMAC4 which has unmet direct dependencies (NETDEVICES && ETHERNET && NET_VENDOR_IBM):  => N/A
  + warning: (PPC_CELL_NATIVE && 440GX && 460EX && 460SX && APM821xx) selects IBM_EMAC_TAH which has unmet direct dependencies (NETDEVICES && ETHERNET && NET_VENDOR_IBM):  => N/A
  + warning: (PPC_CELL_NATIVE && BLUESTONE && CANYONLANDS && GLACIER && EIGER && 440EPX && 440GRX && 440GX && 460SX && 405EX) selects IBM_EMAC_RGMII which has unmet direct dependencies (NETDEVICES && ETHERNET && NET_VENDOR_IBM):  => N/A
  + warning: (PPC_CELL_NATIVE && CANYONLANDS && GLACIER && 440EP && 440EPX && 440GRX && 440GP && 440GX && 460SX && 405GP) selects IBM_EMAC_ZMII which has unmet direct dependencies (NETDEVICES && ETHERNET && NET_VENDOR_IBM):  => N/A
  + warning: (PPC_PS3 && PPC_CELLEB && USB_EHCI_HCD_PMC_MSP && XPS_USB_HCD_XILINX && USB_OCTEON_EHCI) selects USB_EHCI_BIG_ENDIAN_MMIO which has unmet direct dependencies (USB_SUPPORT && USB_EHCI_HCD && (PPC_CELLEB || PPC_PS3 || 440EPX || ARCH_IXP4XX || XPS_USB_HCD_XILINX || PPC_MPC512x || CPU_CAVIUM_OCTEON || PMC_MSP || SPARC_LEON)):  => N/A
  + warning: (PPC_PS3 && PPC_CELLEB) selects USB_OHCI_BIG_ENDIAN_MMIO which has unmet direct dependencies (USB_SUPPORT && USB_OHCI_HCD):  => N/A
  + warning: (USB_DWC3) selects USB_XHCI_PLATFORM which has unmet direct dependencies (USB_SUPPORT && USB_XHCI_HCD):  => N/A
  + warning: /scratch/kisskb/src/drivers/scsi/advansys.c:71:2: warning: #warning this driver is still not properly converted to the DMA API [-Wcpp]:  => N/A
  + warning: WARNING: fs/ocfs2/ocfs2_stack_o2cb.o (.xt.prop): unexpected non-allocatable section.:  => N/A
  + warning: __mcount_loc already exists: arch/sparc/kernel/irq_64.o:  => N/A

    [ 124 lines about __mcount_loc on sparc64 deleted]

  + warning: arch/powerpc/platforms/built-in.o(.text+0x137a4): Section mismatch in reference from the function .pnv_pci_ioda_msi_setup() to the function .devinit.text:.__pnv_ioda_get_one_pe():  => N/A
  + warning: arch/powerpc/platforms/built-in.o(.text+0x137c0): Section mismatch in reference from the function .pnv_pci_ioda_msi_setup() to the function .devinit.text:.__pnv_ioda_get_one_pe():  => N/A
  + warning: arch/powerpc/platforms/built-in.o(.text+0x137c4): Section mismatch in reference from the function .pnv_pci_ioda_msi_setup() to the function .devinit.text:.__pnv_ioda_get_one_pe():  => N/A
  + warning: arch/powerpc/platforms/built-in.o(.text+0x137e0): Section mismatch in reference from the function .pnv_pci_ioda_msi_setup() to the function .devinit.text:.__pnv_ioda_get_one_pe():  => N/A
  + warning: arch/powerpc/platforms/built-in.o(.text+0x18078): Section mismatch in reference from the function .pci_dn_reconfig_notifier() to the function .devinit.text:.eeh_dev_init():  => N/A
  + warning: arch/powerpc/platforms/built-in.o(.text+0x18098): Section mismatch in reference from the function .pci_dn_reconfig_notifier() to the function .devinit.text:.eeh_dev_init():  => N/A
  + warning: arch/powerpc/platforms/powernv/built-in.o(.text+0x3d50): Section mismatch in reference from the function .pnv_pci_ioda_msi_setup() to the function .devinit.text:.__pnv_ioda_get_one_pe():  => N/A
  + warning: arch/powerpc/platforms/powernv/built-in.o(.text+0x3d6c): Section mismatch in reference from the function .pnv_pci_ioda_msi_setup() to the function .devinit.text:.__pnv_ioda_get_one_pe():  => N/A
  + warning: arch/powerpc/platforms/pseries/built-in.o(.text+0x4514): Section mismatch in reference from the function .pci_dn_reconfig_notifier() to the function .devinit.text:.eeh_dev_init():  => N/A
  + warning: arch/powerpc/sysdev/built-in.o(.text+0xe260): Section mismatch in reference from the function .ics_rtas_init() to the function .init.text:.xics_register_ics():  => N/A
  + warning: arch/powerpc/sysdev/built-in.o(.text+0xf808): Section mismatch in reference from the function .ics_rtas_init() to the function .init.text:.xics_register_ics():  => N/A
  + warning: arch/powerpc/sysdev/xics/built-in.o(.text+0x2688): Section mismatch in reference from the function .ics_rtas_init() to the function .init.text:.xics_register_ics():  => N/A
  + warning: arch/xtensa/platforms/iss/built-in.o (.xt.lit): unexpected non-allocatable section.:  => N/A
  + warning: drivers/base/built-in.o (.xt.lit): unexpected non-allocatable section.:  => N/A
  + warning: drivers/built-in.o(.init.text+0x6c000): Section mismatch in reference from the function .xhci_hcd_init() to the function .exit.text:.xhci_unregister_pci():  => N/A
  + warning: drivers/char/built-in.o (.xt.lit): unexpected non-allocatable section.:  => N/A
  + warning: drivers/char/built-in.o (.xt.prop): unexpected non-allocatable section.:  => N/A
  + warning: drivers/char/tpm/built-in.o (.xt.lit): unexpected non-allocatable section.:  => N/A
  + warning: drivers/char/tpm/built-in.o (.xt.prop): unexpected non-allocatable section.:  => N/A
  + warning: drivers/gpu/drm/udl/udl.o (.xt.lit): unexpected non-allocatable section.:  => N/A
  + warning: drivers/gpu/drm/udl/udl.o (.xt.prop): unexpected non-allocatable section.:  => N/A
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
  + warning: drivers/staging/comedi/drivers/s626.o(.text+0x26c2): Section mismatch in reference from the function s626_attach() to the variable .devinit.rodata:s626_pci_table:  => N/A
  + warning: drivers/staging/comedi/drivers/s626.o(.text+0x26c8): Section mismatch in reference from the function s626_attach() to the variable .devinit.rodata:s626_pci_table:  => N/A
  + warning: drivers/staging/comedi/drivers/s626.o(.text+0x26ce): Section mismatch in reference from the function s626_attach() to the variable .devinit.rodata:s626_pci_table:  => N/A
  + warning: drivers/staging/comedi/drivers/s626.o(.text+0x26d4): Section mismatch in reference from the function s626_attach() to the variable .devinit.rodata:s626_pci_table:  => N/A
  + warning: drivers/staging/ozwpan/ozwpan.o (.xt.lit): unexpected non-allocatable section.:  => N/A
  + warning: drivers/staging/ozwpan/ozwpan.o (.xt.prop): unexpected non-allocatable section.:  => N/A
  + warning: drivers/staging/sep/sep_driver.o (.xt.lit): unexpected non-allocatable section.:  => N/A
  + warning: drivers/staging/sep/sep_driver.o (.xt.prop): unexpected non-allocatable section.:  => N/A
  + warning: drivers/usb/built-in.o(.init.text+0x1be0): Section mismatch in reference from the function .xhci_hcd_init() to the function .exit.text:.xhci_unregister_pci():  => N/A
  + warning: drivers/usb/host/built-in.o(.init.text+0xab4): Section mismatch in reference from the function .xhci_hcd_init() to the function .exit.text:.xhci_unregister_pci():  => N/A
  + warning: drivers/usb/host/xhci-hcd.o(.init.text+0x1e): Section mismatch in reference from the function init_module() to the function .exit.text:xhci_unregister_pci():  => N/A
  + warning: drivers/usb/host/xhci-hcd.o(.init.text+0x48): Section mismatch in reference from the function init_module() to the function .exit.text:xhci_unregister_pci():  => N/A
  + warning: drivers/usb/host/xhci-hcd.o(.init.text+0x6d): Section mismatch in reference from the function init_module() to the function .exit.text:xhci_unregister_pci():  => N/A
  + warning: drivers/usb/host/xhci-hcd.o(.init.text+0xac): Section mismatch in reference from the function .init_module() to the function .exit.text:.xhci_unregister_pci():  => N/A
  + warning: drivers/usb/host/xhci-hcd.o(.init.text+0xac): Section mismatch in reference from the function .xhci_hcd_init() to the function .exit.text:.xhci_unregister_pci():  => N/A
  + warning: fs/debugfs/debugfs.o (.xt.prop): unexpected non-allocatable section.:  => N/A
  + warning: fs/qnx6/qnx6.o (.xt.lit): unexpected non-allocatable section.:  => N/A
  + warning: fs/qnx6/qnx6.o (.xt.prop): unexpected non-allocatable section.:  => N/A
  + warning: lib/reed_solomon/built-in.o (.xt.lit): unexpected non-allocatable section.:  => N/A
  + warning: lib/reed_solomon/built-in.o (.xt.prop): unexpected non-allocatable section.:  => N/A
  + warning: net/ipv6/ipv6.o (.xt.lit): unexpected non-allocatable section.:  => N/A
  + warning: net/ipv6/ipv6.o (.xt.prop): unexpected non-allocatable section.:  => N/A
  + warning: net/sunrpc/sunrpc.o (.xt.lit): unexpected non-allocatable section.:  => N/A
  + warning: net/sunrpc/sunrpc.o (.xt.prop): unexpected non-allocatable section.:  => N/A
  + warning: net/unix/unix.o (.xt.lit): unexpected non-allocatable section.:  => N/A
  + warning: security/yama/built-in.o (.xt.lit): unexpected non-allocatable section.:  => N/A
  + warning: security/yama/built-in.o (.xt.prop): unexpected non-allocatable section.:  => N/A
  + warning: security/yama/yama.o (.xt.lit): unexpected non-allocatable section.:  => N/A
  + warning: security/yama/yama.o (.xt.prop): unexpected non-allocatable section.:  => N/A

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
