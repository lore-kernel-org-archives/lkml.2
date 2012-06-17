Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755156Ab2FQT5B (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2012 15:57:01 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:63671 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751868Ab2FQT5A convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2012 15:57:00 -0400
MIME-Version: 1.0
In-Reply-To: <1339962373-3224-1-git-send-email-geert@linux-m68k.org>
References: <1339962373-3224-1-git-send-email-geert@linux-m68k.org>
Date: Sun, 17 Jun 2012 21:56:59 +0200
X-Google-Sender-Auth: XBKQccG-6-FRALHkZYWPrCYMBvE
Message-ID: <CAMuHMdVfLjgrtWoPpvbLf12+=ApE6W9dNcweqD-_2Benr-D7NQ@mail.gmail.com>
Subject: Re: Build regressions/improvements in v3.5-rc3
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-kernel@vger.kernel.org
Cc: Linuxppc-dev <linuxppc-dev@ozlabs.org>,
        Linux MIPS Mailing List <linux-mips@linux-mips.org>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        Chris Zankel <chris@zankel.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 17, 2012 at 9:46 PM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
> JFYI, when comparing v3.5-rc3 to v3.5-rc2[3], the summaries are:
>  - build errors: +235/-10

Truckloads of powerpc "Unrecognized opcode" breakage, and

  + arch/mips/include/asm/bitops.h: error: static declaration of 'fls'
follows non-static declaration:  => 615:50
  + include/asm-generic/bitops/fls64.h: error: static declaration of
'fls64' follows non-static declaration:  => 26:81, 18:81
  + include/linux/bitops.h: error: conflicting types for 'fls_long':  => 160:55

various mips

  + drivers/edac/mpc85xx_edac.c: error: too few arguments to function
'edac_mc_alloc':  => 983:90

powerpc-randconfig

  + drivers/net/ethernet/dlink/de600.c: error: expected expression
before 'do':  => 146:2, 301:3, 210:3, 150:2, 468:2, 404:2, 208:3,
495:3, 328:2, 138:2, 499:2, 217:3, 417:2, 136:2, 300:3, 464:2, 501:2,
493:2, 206:2, 216:3, 254:4, 350:2, 196:3, 137:2, 405:2, 463:2
  + drivers/scsi/pcmcia/sym53c500_cs.c: error: expected expression
before 'do':  => 453:4, 434:4, 574:2, 371:2
  + drivers/scsi/qlogicfas408.c: error: expected expression before
'do':  => 234:2, 221:2, 312:3, 583:2, 535:2, 324:3, 85:2, 406:2,
316:5, 569:9, 89:3, 230:2, 546:2
  + drivers/staging/wlags49_h2/hcf.c: error: expected expression
before 'do':  => 3375:4, 3592:3, 4378:3, 1135:3, 1203:3, 3593:3,
4731:3, 3653:3, 704:4, 3802:3, 1150:2, 1209:2, 3645:10, 4178:2,
3699:5, 3007:5, 4033:2, 787:3, 2646:4, 1190:2, 3797:3, 717:3, 2630:3,
4732:3, 703:4, 3582:2, 751:5, 2629:3, 755:5, 3507:3, 1153:2, 750:5,
3057:4, 781:4, 2654:4, 3700:5
  + drivers/staging/wlags49_h25/../wlags49_h2/hcf.c: error: expected
expression before 'do':  => 3375:4, 3592:3, 4378:3, 1135:3, 1203:3,
3593:3, 4731:3, 3653:3, 704:4, 3802:3, 1150:2, 1209:2, 3645:10,
3699:5, 4033:2, 787:3, 2646:4, 1190:2, 717:3, 2630:3, 4732:3, 703:4,
3582:2, 751:5, 2629:3, 755:5, 3507:3, 1153:2, 750:5, 3057:4, 781:4,
2654:4, 3700:5

sh-allyesconfig/sh-allmodconfig

  + drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c: error: implicit
declaration of function 'pci_iomap'
[-Werror=implicit-function-declaration]:  => 90:3
  + drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c: error: implicit
declaration of function 'pci_iounmap'
[-Werror=implicit-function-declaration]:  => 142:2

xtensa

  + error: "__ashrdi3" [fs/ntfs/ntfs.ko] undefined!:  => N/A
  + error: "__lshrdi3" [fs/ntfs/ntfs.ko] undefined!:  => N/A

sh4/landisk_defconfig

  + error: "__ashrdi3" [fs/xfs/xfs.ko] undefined!:  => N/A
  + error: "__lshrdi3" [drivers/mtd/mtd.ko] undefined!:  => N/A
  + error: "__lshrdi3" [fs/xfs/xfs.ko] undefined!:  => N/A

sh4/titan_defconfig

  + error: No rule to make target include/config/auto.conf:  => N/A

x86_64-randconfig

  + kernel/sys.c: error: 'mmap_min_addr' undeclared (first use in this
function):  => 1864:34, 1864:2
  + security/security.c: error: 'BDI_CAP_EXEC_MAP' undeclared (first
use in this function):  => 688:16, 688:3
  + security/security.c: error: dereferencing pointer to incomplete
type:  => 687:36

sh-allyesconfig/sh-allmodconfig/sh-randconfig

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
