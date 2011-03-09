Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757306Ab1CIQXN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 11:23:13 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:39949 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757248Ab1CIQXJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 11:23:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=xefrngOVq5HNt7ZHPVdPsGatUNX5+kLAamAq8urlo6BVhXQuzp22Z7cVu1GiCp0x3w
         QOYZ1xIzuxlfXnLSr4FOqjBPoNI2mqbUv8KLAnAS5mT+iAFdnHPcM5dGGnYKnkupk0WX
         iqRgPxBIjX6w8Cagbdf+qYKgyNwMnLS4/r5qY=
MIME-Version: 1.0
Date: Wed, 9 Mar 2011 17:23:08 +0100
Message-ID: <AANLkTimP6yL4WkQyCJF1xvDUO8jN_kaJp3hCP+VZ9ZTa@mail.gmail.com>
Subject: drivers/net/igbvf/ethtool.c build error with gcc 4.6.0
From: Douglas Mencken <dougmencken@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm building vanilla 2.6.37.3 with GCC 4.6.0 20110226 (experimental).
That's what I've got:

  gcc -m32 -Wp,-MD,drivers/net/igbvf/.ethtool.o.d  -nostdinc -isystem
/usr/lib/gcc/powerpc-gnu-linux-uclibc/4.6.0/include
-I/root/build-farm/linux_libre-v2.6.37.3.builddir/arch/powerpc/include
-Iinclude  -include include/generated/autoconf.h -D__KERNEL__
-Iarch/powerpc -Wall -Wundef -Wstrict-prototypes -Wno-trigraphs
-fno-strict-aliasing -fno-common -Werror-implicit-function-declaration
-Wno-format-security -fno-delete-null-pointer-checks -Os -msoft-float
-pipe -Iarch/powerpc -ffixed-r2 -mmultiple -mno-altivec -mno-spe
-mspe=no -funit-at-a-time -fno-dwarf2-cfi-asm -mno-string
-mcpu=powerpc -Wa,-maltivec -Wframe-larger-than=1024
-fno-stack-protector -fomit-frame-pointer
-Wdeclaration-after-statement -Wno-pointer-sign -fno-strict-overflow
-fconserve-stack -DCC_HAVE_ASM_GOTO  -DMODULE  -D"KBUILD_STR(s)=#s"
-D"KBUILD_BASENAME=KBUILD_STR(ethtool)"
-D"KBUILD_MODNAME=KBUILD_STR(igbvf)" -c -o
drivers/net/igbvf/.tmp_ethtool.o drivers/net/igbvf/ethtool.c
In file included from drivers/net/igbvf/ethtool.c:36:0:
drivers/net/igbvf/igbvf.h:129:15: error: duplicate member 'page'
make[3]: *** [drivers/net/igbvf/ethtool.o] Error 1
make[2]: *** [drivers/net/igbvf] Error 2
make[1]: *** [drivers/net] Error 2
make: *** [drivers] Error 2

drivers/net/igbvf/igbvf.h:129 does contain:

                /* Rx */
                struct {
                        struct page *page; /* <<---- */
                        u64 page_dma;
                        unsigned int page_offset;
                };
        };
        struct page_ptr *page; /* <<---- */

which is wrong with gcc 4.6.0.

I wish to be personally CC'ed the answers/comments posted to the list
in response.
