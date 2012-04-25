Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753755Ab2DYOzp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 10:55:45 -0400
Received: from gerard.telenet-ops.be ([195.130.132.48]:47587 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752062Ab2DYOzn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 10:55:43 -0400
Date: Wed, 25 Apr 2012 16:55:39 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Build regressions/improvements in v3.4-rc4
Message-ID: <alpine.DEB.2.00.1204251654560.14603@ayla.of.borg>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Below is the list of build error/warning regressions/improvements in
v3.4-rc4[1] compared to v3.3[2].

Too make this mail fit in the lkml limit, I deleted

  - 2232 lines about tracepoints on sh4, like:

    drivers/mtd/devices/./docg3.h: error: (near initialization for '__tracepoint_docg3_io'):  => 346:1

  - 122 lines about __mcount_loc on sparc64

  - all warning improvements

Summarized:
  - build errors: +2356/-82
  - build warnings: +323/-501

JFYI, when comparing v3.4-rc4 to v3.4-rc3[3], the summaries are:
  - build errors: +36/-3
  - build warnings: +1594/-142

Note that there may be false regressions, as some logs are incomplete.
Still, they're build errors/warnings.

In addition, I've put the verbose summary at
http://www.kernel.org/pub/linux/kernel/people/geert/linux-log/v3.4-rc4.summary.gz
so you can easily find out for which configs and architectures the
errors/warnings you're interested in are happening.

Happy fixing! ;-)

Thanks to the linux-next team for providing the build service.

[1] http://kisskb.ellerman.id.au/kisskb/head/4973/ (115 out of 116 configs)
[2] http://kisskb.ellerman.id.au/kisskb/head/4840/ (all 116 configs)
[3] http://kisskb.ellerman.id.au/kisskb/head/4954/ (115 out of 116 configs)


*** ERRORS ***

2356 regressions:
  + arch/parisc/include/asm/atomic.h: error: '__atomic_hash' undeclared (first use in this function):  => 66:2, 77:2, 172:2, 160:2
  + arch/parisc/include/asm/atomic.h: error: expected '=', ',', ';', 'asm' or '__attribute__' before '__lock_aligned':  => 30:56
  + arch/parisc/include/asm/bitops.h: error: '__atomic_hash' undeclared (first use in this function):  => 37:2, 107:2, 48:2, 59:2, 90:2, 72:2
  + arch/parisc/include/asm/bitops.h: error: static declaration of 'fls' follows non-static declaration:  => 186:23
  + arch/parisc/include/asm/spinlock.h: error: implicit declaration of function '__ldcw' [-Werror=implicit-function-declaration]:  => 24:2
  + arch/parisc/include/asm/spinlock.h: error: implicit declaration of function '__ldcw_align' [-Werror=implicit-function-declaration]:  => 9:2
  + arch/parisc/include/asm/spinlock.h: error: implicit declaration of function 'mb' [-Werror=implicit-function-declaration]:  => 22:2
  + arch/um/drivers/cow_user.c: error: implicit declaration of function 'be32toh':  => 303
  + arch/um/drivers/cow_user.c: error: implicit declaration of function 'be64toh':  => 330
  + arch/um/drivers/cow_user.c: error: implicit declaration of function 'htobe32':  => 216
  + arch/um/drivers/cow_user.c: error: implicit declaration of function 'htobe64':  => 249
  + arch/xtensa/include/asm/io.h: error: implicit declaration of function 'BUG' [-Werror=implicit-function-declaration]:  => 77:3
  + arch/xtensa/kernel/signal.c: error: 'ret' undeclared (first use in this function):  => 532:3
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
  + drivers/media/video/uvc/uvc_queue.c: error: 'struct uvc_video_queue' has no member named 'count': 259:16, 254:23 => 259:39, 259:339, 259:16, 259:66, 254:23
  + drivers/media/video/uvc/uvc_queue.c: error: 'struct vb2_buffer' has no member named 'm': 256:19 => 256:19, 256:382, 256:89, 256:42
  + drivers/mmc/core/cd-gpio.c: error: implicit declaration of function 'gpio_to_irq' [-Werror=implicit-function-declaration]:  => 36:2
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
  + drivers/staging/xgifb/../../video/sis/vstruct.h: error: expected identifier or '(' before numeric constant:  => 135:16
  + drivers/usb/gadget/pch_udc.c: error: implicit declaration of function 'gpio_direction_input' [-Werror=implicit-function-declaration]:  => 1401:2
  + drivers/usb/gadget/pch_udc.c: error: implicit declaration of function 'gpio_free' [-Werror=implicit-function-declaration]:  => 1432:3
  + drivers/usb/gadget/pch_udc.c: error: implicit declaration of function 'gpio_get_value' [-Werror=implicit-function-declaration]:  => 1267:3
  + drivers/usb/gadget/pch_udc.c: error: implicit declaration of function 'gpio_request' [-Werror=implicit-function-declaration]:  => 1393:2
  + drivers/usb/gadget/pch_udc.c: error: implicit declaration of function 'gpio_to_irq' [-Werror=implicit-function-declaration]:  => 1404:2
  + drivers/video/i740fb.c: error: implicit declaration of function 'pci_iounmap' [-Werror=implicit-function-declaration]:  => 1165:2
  + error: of_platform.c: undefined reference to `.pcibios_claim_one_bus':  => .devinit.text+0xb4)
  + error: pci.c: undefined reference to `pci_realloc_get_opt':  => .init.text+0x1a0), .init.text+0x174)
  + fs/gfs2/./trace_gfs2.h: error: initializer element is not constant:  => 242:1, 148:1, 418:1, 77:1, 212:1, 362:1, 337:1, 306:1, 383:1, 116:1, 182:1, 458:1
  + fs/ocfs2/./ocfs2_trace.h: error: initializer element is not constant:  => 1849:1, 2370:1, 875:1, 2199:1, 2493:1, 769:1, 1401:1, 2741:1, 1502:1, 1799:1, 968:1, 2590:1, 652:1, 2655:1, 1841:1, 2659:1, 1711:1, 761:1, 2374:1, 2032:1, 1038:1, 2439:1, 1833:1, 501:1, 1835:1, 1317:1, 2036:1, 2568:1, 656:1, 712:1, 964:1, 1843:1, 1315:1, 410:1, 660:1, 1847:1, 997:1, 1887:1, 2261:1, 1566:1, 2653:1, 999:1, 970:1, 1092:1, 1819:1, 1544:1, 1536:1, 1323:1, 2677:1, 2473:1, 883:1, 2683:1, 785:1, 2191:1, 1853:1, 1829:1, 1542:1, 2150:1, 2049:1, 1500:1, 2011:1, 2578:1, 2257:1, 1859:1, 1574:1, 2661:1, 877:1, 2201:1, 1797:1, 1629:1, 412:1, 2745:1, 728:1, 2727:1, 793:1, 2592:1, 893:1, 1949:1, 2647:1, 2622:1, 779:1, 738:1, 974:1, 759:1, 1568:1, 873:1, 1030:1, 722:1, 2047:1, 1641:1, 929:1, 2353:1, 777:1, 1149:1, 1977:1, 714:1, 1817:1, 2675:1, 2753:1, 1631:1, 1570:1, 1447:1, 831:1, 767:1, 548:1, 1647:1, 2588:1, 829:1, 2673:1, 2038:1, 1403:1, 1538:1, 479:1, 666:1, 2309:1, 734:1, 1739:1, 602:1, 2747:1, 1321:1, 2574:1, 408:1, 2620:1, 2295:1, 1813:1, 1987:1, 789:1, 1915:1, 732:1, 1351:1, 1159:1, 1863:1, 2743:1, 1825:1, 1823:1, 1917:1, 1477:1, 1040:1, 1405:1, 2395:1, 1578:1, 2749:1, 668:1, 1975:1, 1090:1, 1311:1, 1034:1, 2043:1, 1801:1, 650:1, 2372:1, 1837:1, 2594:1, 1064:1, 654:1, 1576:1, 420:1, 2681:1, 1889:1, 2075:1, 2329:1, 2721:1, 833:1, 962:1, 2154:1, 2148:1, 781:1, 730:1, 2584:1, 2453:1, 1445:1, 585:1, 821:1, 2101:1, 1695:1, 1979:1, 2203:1, 1697:1, 1036:1, 1811:1, 2077:1, 1865:1, 422:1, 976:1, 2255:1, 2197:1, 972:1, 2649:1, 2537:1, 418:1, 1595:1, 560:1, 2193:1, 2566:1, 1681:1, 1827:1, 1449:1, 1181:1, 2431:1, 1325:1, 817:1, 2120:1, 1151:1, 1246:1, 2437:1, 966:1, 791:1, 1805:1, 2679:1, 2651:1, 2586:1, 1161:1, 2411:1, 2582:1, 720:1, 1218:1, 736:1, 2725:1, 2435:1, 2663:1, 2580:1, 2433:1, 2152:1, 783:1, 891:1, 853:1, 1309:1, 885:1, 527:1, 2657:1, 1713:1, 1633:1, 2034:1, 771:1, 1821:1, 416:1, 724:1, 825:1, 1374:1, 2259:1, 1564:1, 1307:1, 2751:1, 2509:1, 1572:1, 787:1, 1601:1, 2081:1, 2331:1, 889:1, 1851:1, 1861:1, 2665:1, 1443:1, 414:1, 1985:1, 897:1, 823:1, 658:1, 2232:1, 1153:1, 895:1, 1313:1, 2755:1, 1157:1, 2618:1, 2513:1, 960:1, 1441:1, 726:1, 1815:1, 1635:1, 1741:1, 1155:1, 1540:1, 2564:1, 2723:1, 1516:1, 1803:1, 931:1, 691:1, 1795:1, 2511:1, 2122:1, 2598:1, 2079:1, 2118:1, 1891:1, 2645:1, 2195:1, 664:1, 1319:1, 454:1, 1831:1, 827:1, 1451:1, 2517:1, 2539:1, 887:1, 1893:1, 2576:1, 1845:1, 2667:1, 662:1, 1001:1, 436:1, 2596:1, 1483:1, 2205:1, 2311:1, 1807:1, 819:1, 2697:1, 2045:1, 1032:1, 1809:1, 1664:1, 1743:1, 1839:1, 2515:1, 815:1
  + fs/xfs/./xfs_trace.h: error: initializer element is not constant:  => 1466:1, 1481:1, 1398:1, 127:1, 1531:1, 1514:1, 495:1, 323:1, 327:1, 925:1, 484:1, 1401:1, 1492:1, 1470:1, 1463:1, 971:1, 574:1, 319:1, 850:1, 324:1, 1502:1, 330:1, 926:1, 846:1, 847:1, 652:1, 761:1, 497:1, 1505:1, 502:1, 501:1, 571:1, 1404:1, 621:1, 656:1, 1409:1, 1056:1, 750:1, 1089:1, 486:1, 1480:1, 321:1, 274:1, 970:1, 1396:1, 339:1, 1650:1, 1536:1, 1513:1, 883:1, 1399:1, 1058:1, 185:1, 1493:1, 1500:1, 325:1, 483:1, 488:1, 1784:1, 331:1, 1574:1, 392:1, 751:1, 346:1, 1783:1, 849:1, 345:1, 561:1, 494:1, 1407:1, 1497:1, 336:1, 133:1, 487:1, 1476:1, 1469:1, 752:1, 329:1, 749:1, 759:1, 924:1, 1478:1, 1491:1, 838:1, 94:1, 131:1, 1019:1, 326:1, 852:1, 1472:1, 492:1, 1211:1, 1506:1, 485:1, 1816:1, 504:1, 318:1, 539:1, 745:1, 1494:1, 1817:1, 1732:1, 1570:1, 332:1, 851:1, 1400:1, 1818:1, 1410:1, 338:1, 1736:1, 748:1, 1473:1, 496:1, 843:1, 273:1, 1734:1, 317:1, 563:1, 1403:1, 1538:1, 743:1, 1471:1, 1230:1, 1508:1, 388:1, 1020:1, 1519:1, 93:1, 1739:1, 583:1, 1467:1, 568:1, 572:1, 1178:1, 758:1, 567:1, 1418:1, 1569:1, 762:1, 1525:1, 1509:1, 1475:1, 1461:1, 1696:1, 95:1, 91:1, 506:1, 747:1, 1018:1, 1530:1, 1417:1, 1477:1, 1405:1, 1176:1, 569:1, 1651:1, 335:1, 1733:1, 562:1, 650:1, 840:1, 503:1, 96:1, 322:1, 337:1, 500:1, 654:1, 1479:1, 845:1, 582:1, 618:1, 577:1, 333:1, 839:1, 763:1, 842:1, 1503:1, 651:1, 1460:1, 753:1, 1114:1, 1539:1, 505:1, 756:1, 587:1, 491:1, 1526:1, 1695:1, 1499:1, 1179:1, 619:1, 1465:1, 537:1, 1087:1, 1535:1, 493:1, 744:1, 927:1, 1414:1, 1177:1, 1468:1, 570:1, 1055:1, 320:1, 1416:1, 1181:1, 1412:1, 1693:1, 1017:1, 746:1, 344:1, 1462:1, 498:1, 841:1, 1413:1, 1498:1, 622:1, 1738:1, 1532:1, 576:1, 1785:1, 128:1, 1402:1, 1511:1, 1529:1, 885:1, 340:1, 1735:1, 755:1, 538:1, 129:1, 579:1, 1406:1, 130:1, 334:1, 886:1, 1572:1, 837:1, 1411:1, 1510:1, 580:1, 565:1, 1528:1, 276:1, 1537:1, 536:1, 275:1, 1419:1, 1495:1, 1737:1, 1175:1, 581:1, 1057:1, 757:1, 1397:1, 564:1, 1527:1, 489:1, 389:1, 1464:1, 1518:1, 1459:1, 1815:1, 1540:1, 1571:1, 390:1, 1694:1, 499:1, 1541:1, 90:1, 328:1, 1516:1, 343:1, 1474:1, 584:1, 764:1, 848:1, 1287:1, 1408:1, 1490:1, 1507:1, 969:1, 754:1, 578:1, 1533:1, 1489:1, 653:1, 887:1, 92:1, 620:1, 586:1, 1517:1, 1482:1, 97:1, 760:1, 1483:1, 1512:1, 923:1, 1501:1, 844:1, 1692:1, 482:1, 1086:1, 884:1, 1395:1, 1534:1, 1504:1, 490:1, 1415:1
  + include/asm-generic/bitops/fls64.h: error: static declaration of 'fls64' follows non-static declaration:  => 26:28, 18:28
  + include/linux/bitops.h: error: conflicting types for 'fls_long':  => 160:24
  + include/linux/log2.h: error: implicit declaration of function 'fls' [-Werror=implicit-function-declaration]:  => 34:2
  + include/linux/log2.h: error: implicit declaration of function 'fls64' [-Werror=implicit-function-declaration]:  => 42:2
  + include/linux/log2.h: error: implicit declaration of function 'fls_long' [-Werror=implicit-function-declaration]:  => 63:2
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
  + include/trace/events/9p.h: error: initializer element is not constant:  => 128:1, 102:1, 80:1
  + include/trace/events/asoc.h: error: initializer element is not constant:  => 302:1, 98:1, 89:1, 203:1, 45:1, 283:1, 134:1, 195:1, 219:1, 126:1, 167:1, 244:1, 54:1, 211:1, 159:1, 261:1
  + include/trace/events/asoc.h: error: initializer element is not constantmake[3]: *** [drivers/bluetooth/bt3c_cs.o] Error 1:  => 261:1
  + include/trace/events/block.h: error: initializer element is not constant:  => 432:13, 91:13, 450:13, 450:1, 160:13, 534:13, 295:13, 309:13, 432:1, 295:1, 387:13, 372:1, 354:1, 216:13, 372:13, 178:13, 280:1, 91:1, 490:13, 534:1, 57:1, 387:1, 178:1, 145:13, 57:13, 160:1, 145:1, 73:13, 280:13, 73:1, 216:1, 309:1, 354:13, 490:1
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
  + include/trace/events/power.h: error: initializer element is not constant:  => 232:13, 96:13, 51:13, 44:1, 193:1, 193:13, 110:13, 110:1, 30:1, 51:1, 200:13, 200:1, 96:1, 103:1, 186:13, 103:13, 186:1, 232:1, 44:13, 30:13
  + include/trace/events/printk.h: error: initializer element is not constant:  => 9:1, 9:13
  + include/trace/events/rcu.h: error: initializer element is not constant:  => 79:13, 450:13, 450:1, 483:13, 142:13, 115:13, 296:13, 20:13, 421:1, 356:1, 356:13, 391:13, 320:13, 255:1, 255:13, 521:13, 421:13, 483:1, 391:1, 50:13, 171:13, 20:1, 296:1, 215:13, 521:1, 320:1
  + include/trace/events/regmap.h: error: initializer element is not constant:  => 162:1, 104:13, 40:13, 90:13, 58:1, 170:13, 58:13, 118:1, 162:13, 49:13, 111:13, 90:1, 97:1, 40:1, 118:13, 97:13, 111:1, 49:1, 170:1, 104:1
  + include/trace/events/regulator.h: error: initializer element is not constant:  => 40:1, 32:1, 48:1, 64:1, 130:1, 98:1, 56:1
  + include/trace/events/rpm.h: error: initializer element is not constant:  => 77:1, 64:1, 77:13, 70:1, 58:1, 58:13, 64:13, 70:13
  + include/trace/events/sched.h: error: initializer element is not constant:  => 83:13, 348:1, 14:1, 114:13, 83:1, 282:1, 363:13, 254:13, 404:1, 36:1, 371:13, 229:13, 36:13, 356:1, 356:13, 340:13, 155:13, 207:1, 404:13, 254:1, 215:1, 215:13, 229:1, 114:1, 340:1, 90:13, 363:1, 222:13, 282:13, 155:1, 348:13, 90:1, 207:13, 14:13, 222:1, 371:1
  + include/trace/events/scsi.h: error: initializer element is not constant:  => 201:13, 201:1, 341:1, 243:13, 243:1, 345:13, 345:1, 341:13, 337:1, 337:13
  + include/trace/events/signal.h: error: initializer element is not constant:  => 96:13, 50:13, 96:1, 50:1
  + include/trace/events/skb.h: error: initializer element is not constant:  => 36:1, 14:13, 53:1, 14:1, 36:13, 53:13
  + include/trace/events/sock.h: error: initializer element is not constant:  => 32:1, 32:13, 10:13, 10:1
  + include/trace/events/sunrpc.h: error: initializer element is not constant:  => 114:1, 98:1, 38:1, 114:13, 106:13, 32:1, 44:1, 167:13, 159:13, 98:13, 106:1, 167:1, 38:13, 32:13, 44:13, 159:1
  + include/trace/events/syscalls.h: error: initializer element is not constant:  => 19:1, 45:1, 45:13, 19:13
  + include/trace/events/task.h: error: initializer element is not constant:  => 33:13, 8:1, 33:1, 8:13
  + include/trace/events/timer.h: error: initializer element is not constant:  => 130:13, 160:13, 304:1, 106:13, 75:13, 32:1, 196:13, 44:1, 242:13, 253:13, 117:13, 267:13, 242:1, 160:1, 106:1, 253:1, 304:13, 267:1, 130:1, 117:1, 196:1, 75:1, 32:13, 44:13
  + include/trace/events/udp.h: error: initializer element is not constant:  => 10:13, 10:1
  + include/trace/events/vmscan.h: error: initializer element is not constant:  => 130:13, 450:13, 450:1, 439:13, 227:13, 75:13, 342:1, 182:13, 342:13, 326:1, 168:13, 168:1, 310:13, 75:1, 310:1, 123:13, 39:13, 175:1, 398:1, 365:13, 365:1, 123:1, 227:1, 398:13, 39:1, 130:1, 326:13, 175:13, 161:1, 444:1, 137:13, 56:1, 56:13, 161:13, 439:1, 137:1, 182:1, 444:13
  + include/trace/events/workqueue.h: error: initializer element is not constant:  => 111:13, 37:1, 86:1, 86:13, 73:13, 111:1, 73:1, 37:13
  + include/trace/events/writeback.h: error: initializer element is not constant:  => 460:13, 82:1, 171:1, 118:1, 77:261, 114:253, 119:1, 80:249, 453:1, 115:1, 396:1, 403:1, 403:13, 118:277, 251:13, 84:13, 173:13, 84:1, 116:1, 80:1, 117:301, 79:245, 453:13, 77:1, 396:13, 121:1, 114:1, 460:1, 251:1, 115:289, 203:1, 81:257, 78:249, 203:13, 81:1, 117:1, 78:1, 79:1, 173:1, 171:241, 294:1, 120:1, 119:285, 82:245, 294:13, 121:273, 116:273, 120:277
  + kernel/trace/./trace_events_filter_test.h: error: initializer element is not constant:  => 9:1, 9:13
  + net/mac80211/./driver-trace.h: error: initializer element is not constant:  => 446:1, 677:1, 536:1, 1190:1, 1281:1, 169:1, 1506:1, 938:1, 464:1, 311:1, 971:1, 475:1, 1169:1, 470:1, 116:1, 458:1, 159:1, 1145:1, 1257:1, 813:1, 595:1, 332:1, 1155:1, 1028:1, 834:1, 652:1, 862:1, 164:1, 384:1, 744:1, 511:1, 546:1, 1429:1, 418:1, 145:1, 750:1, 1455:1, 912:1, 1403:1, 452:1, 213:1, 1434:1, 541:1, 1213:1, 567:1, 887:1, 791:1, 943:1, 219:1, 1343:1, 1322:1, 185:1, 360:1, 480:1, 1379:1, 627:1, 1300:1, 1530:1, 1033:1, 1361:1, 755:1, 994:1, 713:1, 1424:1, 1060:1, 1262:1, 130:1, 179:1, 174:1, 719:1, 1234:1, 1479:1, 111:1, 1023:1, 1088:1, 261:1
  + sound/soc/codecs/max9768.c: error: implicit declaration of function 'gpio_free' [-Werror=implicit-function-declaration]:  => 206:3
  + sound/soc/codecs/max9768.c: error: implicit declaration of function 'gpio_request_one' [-Werror=implicit-function-declaration]:  => 175:3
  + sound/soc/codecs/wm2200.c: error: implicit declaration of function 'gpio_free' [-Werror=implicit-function-declaration]:  => 2169:3
  + sound/soc/codecs/wm2200.c: error: implicit declaration of function 'gpio_request_one' [-Werror=implicit-function-declaration]:  => 2046:3
  + sound/soc/sh/fsi.c: error: too few arguments to function 'chan->device->device_prep_slave_sg':  => 1006:9

82 improvements:
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

323 regressions:
  + arch/m32r/include/asm/ptrace.h: warning: "PTRACE_O_TRACESYSGOOD" redefined [enabled by default]:  => 117:0
  + arch/parisc/include/asm/spinlock.h: warning: assignment makes pointer from integer without a cast [enabled by default]:  => 39:4, 50:4, 23:4
  + arch/parisc/include/asm/spinlock.h: warning: initialization makes pointer from integer without a cast [enabled by default]:  => 9:29
  + arch/sh/math-emu/math.c: warning: left shift count >= width of type [enabled by default]: 146:2, 123:13306, 311:325, 311:1, 123:2620, 116:1, 116:2620, 335:2, 109:1, 123:1, 109:2620 => 334:499, 310:14686, 122:26435, 145:426, 115:2620, 145:2, 122:2620, 334:2, 310:325, 115:1, 122:56364, 108:1, 108:2620, 310:1, 115:28873, 122:13306, 310:20579, 310:16353, 122:1, 108:28503
  + arch/sh/math-emu/math.c: warning: left shift count is negative [enabled by default]: 82:1, 311:325, 93:1, 123:496, 130:2620, 123:1, 109:496, 109:2620, 82:2569, 93:2569, 82:445, 130:1, 324:2, 334:254, 116:496, 334:1, 311:1, 93:445, 123:2620, 130:496, 116:1, 109:1, 116:2620 => 333:1, 129:2620, 115:2620, 129:25148, 323:677, 310:1033, 92:445, 115:1, 92:1, 115:1574, 108:1, 108:496, 333:962, 310:1, 122:13113, 81:445, 92:1544, 81:2569, 92:90829, 81:13056, 115:13113, 81:102339, 108:1574, 92:2569, 122:2620, 81:1544, 310:325, 108:13113, 129:1, 129:1574, 92:102341, 81:1, 333:254, 108:2620, 122:496, 129:13113, 115:496, 122:1574, 81:90827, 323:2, 92:13056, 122:1, 129:496
  + arch/sh/math-emu/math.c: warning: right shift count >= width of type [enabled by default]: 297:3, 295:3 => 294:4793, 294:4372, 296:3, 294:3, 296:4779, 296:4358
  + arch/sh/math-emu/math.c: warning: right shift count is negative [enabled by default]: 146:2, 123:13306, 311:325, 130:1, 311:1, 123:2620, 116:1, 109:1, 116:2620, 130:2620, 335:2, 123:1, 109:2620, 325:2, 295:3 => 129:2620, 294:17791, 115:2620, 122:38034, 115:44886, 115:1, 310:20096, 108:1, 129:7060, 115:28873, 310:1, 334:1333, 115:51323, 108:50940, 108:28503, 334:499, 122:26435, 145:426, 122:2620, 145:2, 334:2, 324:3213, 310:325, 129:1, 122:56364, 324:9650, 108:2620, 324:2, 108:44503, 294:24228, 122:31597, 129:13497, 122:13306, 122:1, 294:3
  + arch/sh/math-emu/math.c: warning: statement with no effect [-Wunused-value]  IHEX    firmware/cis/COMpad4.cis:  => 108:1
  + arch/sh/math-emu/math.c: warning: statement with no effect [-Wunused-value]: 148:1262, 109:17894, 325:2077, 130:20578, 295:1, 123:7940, 130:11734, 109:10498, 297:1, 130:19949, 116:8821, 148:1, 325:3188, 295:5244, 109:18917, 123:9661, 116:1, 325:356, 295:2412, 325:1, 297:2995, 123:10772, 148:239, 336:1262, 123:1, 109:11609, 123:16334, 130:10013, 297:1972, 336:1, 130:12845, 297:3624, 130:1, 116:19005, 109:19546, 130:18926, 336:239, 116:10542, 123:17986, 116:19634, 116:11653, 336:1891, 109:1, 109:8777, 148:1891, 116:17982, 295:4133, 123:17357 => 335:9566, 296:15196, 108:10498, 147:9566, 147:239, 324:7851, 129:10013, 115:43112, 108:86369, 108:42729, 122:17986, 115:90379, 115:1, 335:1891, 115:87135, 108:1, 108:11609, 129:19949, 108:17894, 122:65174, 122:60170, 335:239, 122:17357, 122:16334, 122:68418, 294:4133, 294:22429, 129:15799, 324:1, 129:2989, 324:11952, 335:1318, 115:8821, 129:5286, 294:26530, 108:81365, 324:2077, 122:36235, 108:89613, 296:2995, 108:8777, 129:11698, 122:10772, 122:7940, 147:1, 129:11237, 324:356, 115:19005, 324:1439, 108:49141, 324:3188, 296:3624, 129:12845, 129:18926, 115:10542, 147:6322, 294:2412, 294:16017, 296:1, 115:53625, 296:23444, 115:11653, 115:17982, 108:19546, 122:29823, 296:1972, 335:1262, 129:1, 335:6322, 335:1, 147:1318, 294:5244, 129:11734, 129:7993, 147:1262, 115:82131, 108:18917, 296:20200, 147:1891, 122:40336, 115:19634, 294:1, 108:53242, 129:20578, 122:9661, 122:1, 115:49524
  + arch/x86/kernel/apic/io_apic.c: warning: 'io_apic_level_ack_pending' defined but not used [-Wunused-function]:  => 382:13
  + arch/x86/kernel/apm_32.c: warning: #warning deprecated CONFIG_APM_CPU_IDLE will be deleted in 2012 [-Wcpp]:  => 361:2
  + arch/x86/kernel/apm_32.c: warning: 'bx' may be used uninitialized in this function [-Wuninitialized]:  => 1806:15
  + arch/x86/kernel/apm_32.c: warning: 'cx' may be used uninitialized in this function [-Wuninitialized]:  => 1826:12
  + arch/x86/kernel/apm_32.c: warning: 'dx' may be used uninitialized in this function [-Wuninitialized]:  => 1838:27
  + arch/x86/kernel/kgdb.c: warning: unused variable 'opc' [-Wunused-variable]:  => 749:7
  + arch/xtensa/include/asm/io.h: warning: control reaches end of non-void function [-Wreturn-type]:  => 94:1, 81:1
  + drivers/ata/pata_arasan_cf.c: warning: 'arasan_cf_resume' defined but not used [-Wunused-function]:  => 936:12
  + drivers/ata/pata_arasan_cf.c: warning: 'arasan_cf_suspend' defined but not used [-Wunused-function]:  => 923:12
  + drivers/base/regmap/regmap.c: warning: 'ret' may be used uninitialized in this function [-Wuninitialized]:  => 744:2
  + drivers/char/rtc.c: warning: 'rtc_freq' defined but not used [-Wunused-variable]:  => 192:22
  + drivers/dma/fsldma.c: warning: 'cookie' may be used uninitialized in this function [-Wuninitialized]:  => 426:2
  + drivers/gpio/gpio-mcp23s08.c: warning: 'mcp23s08_probe_one' defined but not used [-Wunused-function]:  => 370:12
  + drivers/gpu/drm/i915/i915_debugfs.c: warning: array subscript is above array bounds [-Warray-bounds]:  => 712:12, 711:12, 709:12, 713:12, 710:12, 708:12
  + drivers/gpu/drm/i915/i915_gem.c: warning: 'ret' may be used uninitialized in this function [-Wuninitialized]:  => 797:38, 390:38
  + drivers/gpu/drm/nouveau/nouveau_fbcon.c: warning: passing argument 1 of 'vga_switcheroo_client_fb_set' from incompatible pointer type [enabled by default]:  => 410:2
  + drivers/hid/hid-picolcd.c: warning: 'err' may be used uninitialized in this function [-Wuninitialized]:  => 1758:10
  + drivers/hwmon/emc2103.c: warning: 'conf_reg' may be used uninitialized in this function [-Wuninitialized]:  => 463:12
  + drivers/i2c/busses/i2c-cpm.c: warning: passing argument 3 of 'dma_alloc_attrs' from incompatible pointer type [enabled by default]:  => 543:3, 534:3
  + drivers/leds/leds-ot200.c: warning: 'val' may be used uninitialized in this function [-Wuninitialized]:  => 114:6
  + drivers/media/dvb/dvb-usb/mxl111sf.c: warning: unused variable 'tmp' [-Wunused-variable]:  => 343:5
  + drivers/media/video/hdpvr/hdpvr-core.c: warning: label 'reg_fail' defined but not used [-Wunused-label]:  => 419:1
  + drivers/media/video/hdpvr/hdpvr-core.c: warning: unused variable 'client' [-Wunused-variable]:  => 298:21
  + drivers/media/video/hdpvr/hdpvr-video.c: warning: "CONFIG_I2C_MODULE" is not defined [-Wundef]:  => 1241:29
  + drivers/media/video/uvc/uvc_ctrl.c: warning: 'ctrl' may be used uninitialized in this function [-Wuninitialized]:  => 1734:6
  + drivers/media/video/uvc/uvc_v4l2.c: warning: ignoring return value of '__clear_user', declared with attribute warn_unused_result [-Wunused-result]:  => 1100:14
  + drivers/mfd/rc5t583-irq.c: warning: 'master_int' may be used uninitialized in this function [-Wuninitialized]:  => 276:20
  + drivers/mfd/rc5t583.c: warning: 'sleepseq_val' may be used uninitialized in this function [-Wuninitialized]:  => 105:15
  + drivers/mfd/s5m-core.c: warning: 'ret' may be used uninitialized in this function [-Wuninitialized]:  => 153:5
  + drivers/mfd/twl6030-irq.c: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]: 376:24, 394:9 => 398:24, 415:9, 415:81
  + drivers/mfd/wl1273-core.c: warning: 'wl1273_core_remove' defined but not used [-Wunused-function]:  => 173:12
  + drivers/mfd/wm8994-core.c: warning: 'patch_regs' may be used uninitialized in this function [-Wuninitialized]:  => 582:7
  + drivers/misc/hpilo.c: warning: 'ilo_remove' defined but not used [-Wunused-function]:  => 722:13
  + drivers/mmc/core/bus.c: warning: 'mmc_bus_resume' defined but not used [-Wunused-function]:  => 136:12
  + drivers/mmc/core/bus.c: warning: 'mmc_bus_suspend' defined but not used [-Wunused-function]:  => 125:12
  + drivers/mmc/core/sdio_bus.c: warning: 'pm_no_operation' defined but not used [-Wunused-function]:  => 197:12
  + drivers/mtd/chips/cfi_cmdset_0001.c: warning: the frame size of 1452 bytes is larger than 1024 bytes [-Wframe-larger-than=]:  => 1797:1
  + drivers/mtd/chips/cfi_cmdset_0020.c: warning: the frame size of 1064 bytes is larger than 1024 bytes [-Wframe-larger-than=]:  => 1180:1
  + drivers/mtd/chips/cfi_cmdset_0020.c: warning: the frame size of 1356 bytes is larger than 1024 bytes [-Wframe-larger-than=]:  => 975:1
  + drivers/mtd/chips/cfi_cmdset_0020.c: warning: the frame size of 1440 bytes is larger than 1024 bytes [-Wframe-larger-than=]:  => 420:1
  + drivers/mtd/chips/cfi_cmdset_0020.c: warning: the frame size of 1788 bytes is larger than 1024 bytes [-Wframe-larger-than=]:  => 975:1
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
  + drivers/tty/serial/8250/8250.c: warning: 'i' may be used uninitialized in this function [-Wuninitialized]: 1718:28, 1718:2, 1718:32, 1723:18 => 1698:18, 1696:28, 1696:32, 1696:2, 1701:18
  + drivers/tty/serial/kgdboc.c: warning: statement with no effect [-Wunused-value]:  => 278:3, 292:3
  + drivers/tty/serial/mfd.c: warning: 'serial_hsu_remove' defined but not used [-Wunused-function]:  => 1436:13
  + drivers/usb/gadget/f_fs.c: warning: 'rem_type1' may be used uninitialized in this function [-Wuninitialized]: 2002:47 => 1997:374, 1997:47
  + drivers/video/backlight/platform_lcd.c: warning: 'platform_lcd_resume' defined but not used [-Wunused-function]:  => 134:12
  + drivers/video/backlight/platform_lcd.c: warning: 'platform_lcd_suspend' defined but not used [-Wunused-function]:  => 124:12
  + fs/btrfs/extent_io.c: warning: 'ret' may be used uninitialized in this function [-Wuninitialized]:  => 3194:5
  + fs/btrfs/file-item.c: warning: comparison of distinct pointer types lacks a cast [enabled by default]:  => 808:346, 767:320, 717:306, 808:703, 808:9, 717:7, 808:711, 717:302, 767:316, 767:21, 808:350
  + fs/ext4/ext4_jbd2.h: warning: control reaches end of non-void function [-Wreturn-type]:  => 360:1
  + fs/ext4/super.c: warning: unused variable 'sbi' [-Wunused-variable]:  => 1600:23
  + fs/ext4/super.c: warning: unused variable 'sbi':  => 1600
  + fs/nfs/nfs4xdr.c: warning: the frame size of 1032 bytes is larger than 1024 bytes [-Wframe-larger-than=]:  => 1718:1
  + fs/nfsd/nfs4recover.c: warning: format '%lu' expects argument of type 'long unsigned int', but argument 3 has type 'size_t' [-Wformat]:  => 581:2, 580:3
  + fs/nfsd/nfs4recover.c: warning: format '%lu' expects argument of type 'long unsigned int', but argument 4 has type 'unsigned int' [-Wformat]:  => 581:2, 580:3
  + fs/quota/quota.c: warning: 'quotactl_cmd_write' defined but not used [-Wunused-function]:  => 295:12
  + fs/ubifs/dir.c: warning: 'saved_nlink' may be used uninitialized in this function [-Wuninitialized]:  => 1107:12
  + fs/ubifs/dir.c: warning: 'saved_nlink' may be used uninitialized in this function:  => 980
  + include/asm-generic/bitops/non-atomic.h: warning: array subscript is above array bounds [-Warray-bounds]:  => 105:20
  + include/linux/ptrace.h: warning: "PTRACE_O_TRACESYSGOOD" redefined [enabled by default]:  => 65:0
  + include/linux/rculist.h: warning: 'ulp' may be used uninitialized in this function [-Wuninitialized]:  => 60:16
  + include/linux/vga_switcheroo.h: warning: 'struct pci_dev' declared inside parameter list [enabled by default]:  => 49:91, 53:34, 28:30, 54:108
  + include/linux/vga_switcheroo.h: warning: its scope is only this definition or declaration, which is probably not what you want [enabled by default]:  => 28:30
  + include/media/v4l2-ctrls.h: warning: 'struct file' declared inside parameter list [enabled by default]:  => 505:55, 497:33
  + include/media/v4l2-ctrls.h: warning: its scope is only this definition or declaration, which is probably not what you want [enabled by default]:  => 497:33
  + ipc/sem.c: warning: 'undo_list' may be used uninitialized in this function [-Wuninitialized]:  => 1568:26
  + kernel/power/qos.c: warning: control reaches end of non-void function:  => 143
  + kernel/rcutree.c: warning: unused variable 'idle' [-Wunused-variable]:  => 349:23, 458:23
  + kernel/trace/trace_events_filter.c: warning: 'ret' may be used uninitialized in this function [-Wuninitialized]:  => 2074:8
  + kernel/watchdog.c: warning: 'watchdog_disable' defined but not used [-Wunused-function]:  => 470:13
  + lib/debugobjects.c: warning: 'obj_states' defined but not used [-Wunused-variable]:  => 73:20
  + lib/debugobjects.c: warning: unused variable 'hint' [-Wunused-variable]:  => 256:9
  + mm/hugetlb.c: warning: 'page' may be used uninitialized in this function [-Wuninitialized]:  => 1135:5
  + mm/memblock.c: warning: 'r' may be used uninitialized in this function [-Wuninitialized]:  => 696:15
  + modpost: WARNING: modpost: Found 14 section mismatch(es).:  => N/A
  + net/bridge/br_notify.c: warning: statement with no effect [-Wunused-value]:  => 42:3
  + net/netfilter/nfnetlink_cttimeout.c: warning: 'ctnl_timeout_parse_policy' uses dynamic stack allocation [enabled by default]:  => 66:1
  + warning:   CC [M]  sound/pci/emu10k1/memory.o:  => N/A
  + warning: (BRIDGE_NF_EBTABLES) selects NETFILTER_XTABLES which has unmet direct dependencies (NET && INET && NETFILTER):  => N/A
  + warning: (DRM) selects DMA_SHARED_BUFFER which has unmet direct dependencies (EXPERIMENTAL):  => N/A
  + warning: (ETRAX_USB_HOST && MOUSE_APPLETOUCH && MOUSE_BCM5974 && MOUSE_SYNAPTICS_USB && JOYSTICK_XPAD && TABLET_USB_ACECAD && TABLET_USB_AIPTEK && TABLET_USB_HANWANG && TABLET_USB_KBTAB && TABLET_USB_WACOM && TOUCHSCREEN_USB_COMPOSITE && INPUT_ATI_REMOTE2 && INPUT_KEYSPAN_REMOTE && INPUT_POWERMATE && INPUT_YEALINK && INPUT_CM109) selects USB which has unmet direct dependencies (USB_SUPPORT && USB_ARCH_HAS_HCD):  => N/A
  + warning: (MOUSE_APPLETOUCH && MOUSE_BCM5974 && MOUSE_SYNAPTICS_USB && JOYSTICK_XPAD && TABLET_USB_ACECAD && TABLET_USB_AIPTEK && TABLET_USB_HANWANG && TABLET_USB_KBTAB && TABLET_USB_WACOM && TOUCHSCREEN_USB_COMPOSITE && INPUT_ATI_REMOTE2 && INPUT_KEYSPAN_REMOTE && INPUT_POWERMATE && INPUT_YEALINK && INPUT_CM109 && RC_ATI_REMOTE && IR_IMON && IR_MCEUSB && IR_REDRAT3 && IR_STREAMZAP && DRM_USB) selects USB which has unmet direct dependencies (USB_SUPPORT && USB_ARCH_HAS_HCD):  => N/A
  + warning: (PPC_CELL_NATIVE && 440EPX && 440GRX && 440GX && 440SPe && 460EX && 460SX && APM821xx && 405EX) selects IBM_EMAC_EMAC4 which has unmet direct dependencies (NETDEVICES && ETHERNET && NET_VENDOR_IBM):  => N/A
  + warning: (PPC_CELL_NATIVE && 440GX && 460EX && 460SX && APM821xx) selects IBM_EMAC_TAH which has unmet direct dependencies (NETDEVICES && ETHERNET && NET_VENDOR_IBM):  => N/A
  + warning: (PPC_CELL_NATIVE && BLUESTONE && CANYONLANDS && GLACIER && EIGER && 440EPX && 440GRX && 440GX && 460SX && 405EX) selects IBM_EMAC_RGMII which has unmet direct dependencies (NETDEVICES && ETHERNET && NET_VENDOR_IBM):  => N/A
  + warning: (PPC_CELL_NATIVE && CANYONLANDS && GLACIER && 440EP && 440EPX && 440GRX && 440GP && 440GX && 460SX && 405GP) selects IBM_EMAC_ZMII which has unmet direct dependencies (NETDEVICES && ETHERNET && NET_VENDOR_IBM):  => N/A
  + warning: (PPC_PS3 && SPU_FS) selects MEMORY_HOTPLUG which has unmet direct dependencies ((SPARSEMEM || X86_64_ACPI_NUMA) && HOTPLUG && ARCH_ENABLE_MEMORY_HOTPLUG && (IA64 || X86 || PPC_BOOK3S_64 || SUPERH || S390)):  => N/A
  + warning: (USB_DWC3) selects USB_XHCI_PLATFORM which has unmet direct dependencies (USB_SUPPORT && USB_XHCI_HCD):  => N/A
  + warning: WARNING: drivers/scsi/mvsas/mvsas.o (.xt.lit): unexpected non-allocatable section.:  => N/A
  + warning: arch/powerpc/platforms/built-in.o(.text+0x137a4): Section mismatch in reference from the function .pnv_pci_ioda_msi_setup() to the function .devinit.text:.__pnv_ioda_get_one_pe():  => N/A
  + warning: arch/powerpc/platforms/built-in.o(.text+0x137c0): Section mismatch in reference from the function .pnv_pci_ioda_msi_setup() to the function .devinit.text:.__pnv_ioda_get_one_pe():  => N/A
  + warning: arch/powerpc/platforms/built-in.o(.text+0x137c4): Section mismatch in reference from the function .pnv_pci_ioda_msi_setup() to the function .devinit.text:.__pnv_ioda_get_one_pe():  => N/A
  + warning: arch/powerpc/platforms/built-in.o(.text+0x137e0): Section mismatch in reference from the function .pnv_pci_ioda_msi_setup() to the function .devinit.text:.__pnv_ioda_get_one_pe():  => N/A
  + warning: arch/powerpc/platforms/built-in.o(.text+0x18078): Section mismatch in reference from the function .pci_dn_reconfig_notifier() to the function .devinit.text:.eeh_dev_init():  => N/A
  + warning: arch/powerpc/platforms/built-in.o(.text+0x18098): Section mismatch in reference from the function .pci_dn_reconfig_notifier() to the function .devinit.text:.eeh_dev_init():  => N/A
  + warning: arch/powerpc/platforms/powernv/built-in.o(.text+0x3d50): Section mismatch in reference from the function .pnv_pci_ioda_msi_setup() to the function .devinit.text:.__pnv_ioda_get_one_pe():  => N/A
  + warning: arch/powerpc/platforms/powernv/built-in.o(.text+0x3d6c): Section mismatch in reference from the function .pnv_pci_ioda_msi_setup() to the function .devinit.text:.__pnv_ioda_get_one_pe():  => N/A
  + warning: arch/powerpc/platforms/pseries/built-in.o(.text+0x4514): Section mismatch in reference from the function .pci_dn_reconfig_notifier() to the function .devinit.text:.eeh_dev_init():  => N/A
  + warning: arch/powerpc/sysdev/built-in.o(.text+0xe12c): Section mismatch in reference from the function .ics_rtas_init() to the function .init.text:.xics_register_ics():  => N/A
  + warning: arch/powerpc/sysdev/built-in.o(.text+0xf6d4): Section mismatch in reference from the function .ics_rtas_init() to the function .init.text:.xics_register_ics():  => N/A
  + warning: arch/powerpc/sysdev/xics/built-in.o(.text+0x2610): Section mismatch in reference from the function .ics_rtas_init() to the function .init.text:.xics_register_ics():  => N/A
  + warning: arch/xtensa/platforms/iss/built-in.o (.xt.lit): unexpected non-allocatable section.:  => N/A
  + warning: drivers/base/built-in.o (.xt.lit): unexpected non-allocatable section.:  => N/A
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
  + warning: net/unix/unix.o (.xt.lit): unexpected non-allocatable section.:  => N/A
  + warning: security/yama/built-in.o (.xt.lit): unexpected non-allocatable section.:  => N/A
  + warning: security/yama/built-in.o (.xt.prop): unexpected non-allocatable section.:  => N/A
  + warning: security/yama/yama.o (.xt.lit): unexpected non-allocatable section.:  => N/A
  + warning: security/yama/yama.o (.xt.prop): unexpected non-allocatable section.:  => N/A
  + warning: vmlinux.o(.text+0x16700): Section mismatch in reference from the function .early_setup_secondary() to the function .cpuinit.text:.early_init_mmu_secondary():  => N/A
  + warning: vmlinux.o(.text+0x2cc34): Section mismatch in reference from the function .early_setup_secondary() to the function .cpuinit.text:.early_init_mmu_secondary():  => N/A
  + warning: vmlinux.o(.text+0x4e6e0): Section mismatch in reference from the function .wake_offline_cpus() to the function .cpuinit.text:.cpu_up():  => N/A
  + warning: vmlinux.o(.text+0x4fafc): Section mismatch in reference from the function .wake_offline_cpus() to the function .cpuinit.text:.cpu_up():  => N/A
  + warning: vmlinux.o(.text+0x7082): Section mismatch in reference from the variable generic_secondary_common_init to the variable .init.data:spinning_secondaries:  => N/A
  + warning: vmlinux.o(.text+0x72954): Section mismatch in reference from the function .ics_rtas_init() to the function .init.text:.xics_register_ics():  => N/A
  + warning: vmlinux.o(.text+0x72ec): Section mismatch in reference from the function .start_secondary_prolog() to the function .devinit.text:.start_secondary():  => N/A
  + warning: vmlinux.o(.text+0x7300): Section mismatch in reference from the function .start_secondary_resume() to the function .devinit.text:.start_secondary():  => N/A
  + warning: vmlinux.o(.text+0x752fc): Section mismatch in reference from the function .ics_rtas_init() to the function .init.text:.xics_register_ics():  => N/A
  + warning: vmlinux.o(.text+0x867e4): Section mismatch in reference from the function .pnv_pci_ioda_msi_setup() to the function .devinit.text:.__pnv_ioda_get_one_pe():  => N/A
  + warning: vmlinux.o(.text+0x86800): Section mismatch in reference from the function .pnv_pci_ioda_msi_setup() to the function .devinit.text:.__pnv_ioda_get_one_pe():  => N/A
  + warning: vmlinux.o(.text+0x891a4): Section mismatch in reference from the function .pnv_pci_ioda_msi_setup() to the function .devinit.text:.__pnv_ioda_get_one_pe():  => N/A
  + warning: vmlinux.o(.text+0x891c0): Section mismatch in reference from the function .pnv_pci_ioda_msi_setup() to the function .devinit.text:.__pnv_ioda_get_one_pe():  => N/A
  + warning: vmlinux.o(.text+0x8b09c): Section mismatch in reference from the function .pci_dn_reconfig_notifier() to the function .devinit.text:.update_dn_pci_info():  => N/A
  + warning: vmlinux.o(.text+0x8b0b8): Section mismatch in reference from the function .pci_dn_reconfig_notifier() to the function .devinit.text:.eeh_dev_init():  => N/A
  + warning: vmlinux.o(.text+0x8da5c): Section mismatch in reference from the function .pci_dn_reconfig_notifier() to the function .devinit.text:.update_dn_pci_info():  => N/A
  + warning: vmlinux.o(.text+0x8da78): Section mismatch in reference from the function .pci_dn_reconfig_notifier() to the function .devinit.text:.eeh_dev_init():  => N/A
  + warning: vmlinux.o(.text+0x901e4): Section mismatch in reference from the function .dlpar_online_cpu() to the function .cpuinit.text:.cpu_up():  => N/A
  + warning: vmlinux.o(.text+0x92ba4): Section mismatch in reference from the function .dlpar_online_cpu() to the function .cpuinit.text:.cpu_up():  => N/A
  + warning: vmlinux.o(.text+0x93ec): Section mismatch in reference from the function .start_secondary_prolog() to the function .devinit.text:.start_secondary():  => N/A
  + warning: vmlinux.o(.text+0x9400): Section mismatch in reference from the function .start_secondary_resume() to the function .devinit.text:.start_secondary():  => N/A
  + warning: vmlinux.o(.text+0x97d80): Section mismatch in reference from the function .pcibios_add_pci_devices() to the function .devinit.text:.of_rescan_bus():  => N/A
  + warning: vmlinux.o(.text+0x97e0c): Section mismatch in reference from the function .pcibios_add_pci_devices() to the function .devinit.text:.pcibios_setup_bus_devices():  => N/A
  + warning: vmlinux.o(.text+0x97e70): Section mismatch in reference from the function .pcibios_add_pci_devices() to the function .devinit.text:.pci_scan_bridge():  => N/A
  + warning: vmlinux.o(.text+0x9accc): Section mismatch in reference from the function .pcibios_add_pci_devices() to the function .devinit.text:.of_rescan_bus():  => N/A
  + warning: vmlinux.o(.text+0x9ad58): Section mismatch in reference from the function .pcibios_add_pci_devices() to the function .devinit.text:.pcibios_setup_bus_devices():  => N/A
  + warning: vmlinux.o(.text+0x9adbc): Section mismatch in reference from the function .pcibios_add_pci_devices() to the function .devinit.text:.pci_scan_bridge():  => N/A

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
