Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756913Ab1KRJpX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 04:45:23 -0500
Received: from mx5.pku.edu.cn ([162.105.129.59]:49531 "EHLO mail.pku.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751607Ab1KRJpV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 04:45:21 -0500
X-Greylist: delayed 2008 seconds by postgrey-1.27 at vger.kernel.org; Fri, 18 Nov 2011 04:45:21 EST
X-Spam-Flag: NO
X-Spam-Score: -311.356
Subject: Please pull unicore32 bugfix  patches
From: Guan Xuetao <gxt@pku.edu.cn>
Reply-To: gxt@pku.edu.cn
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
Organization: Peking University
Date: Fri, 18 Nov 2011 17:13:45 +0800
Message-ID: <1321607625.1867.97.camel@epip-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Linus,
Could you please pull unicore32 bugfix patches from my repo:
	git://github.com/gxt/linux.git unicore32

There are six patches in unicore32 branch with their logs listed below.

Thanks & Regards,
Guan Xuetao

---
commit ed96dfbcfea92233d27db9d3c77fc91a58c959bf
Author: Mathias Krause <minipli@googlemail.com>
Date:   Tue Nov 15 14:54:51 2011 -0800

    unicore32, exec: remove redundant set_fs(USER_DS)
    
    The address limit is already set in flush_old_exec() so this
    set_fs(USER_DS) is redundant.
    
    Signed-off-by: Mathias Krause <minipli@googlemail.com>
    Cc: Guan Xuetao <gxt@mprc.pku.edu.cn>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Acked-by: Guan Xuetao <gxt@mprc.pku.edu.cn>

 arch/unicore32/include/asm/processor.h |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

commit 8889023a4ab5f32325b568e7626fd2233cf64fa5
Author: Paul Bolle <pebolle@tiscali.nl>
Date:   Sun Nov 13 01:43:23 2011 +0100

    unicore32: Fix typo 'PUV3_I2C'
    
    Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
    Acked-by: Guan Xuetao <gxt@mprc.pku.edu.cn>

 arch/unicore32/Kconfig |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

commit d159e571cb81a75d50f84fc4b716edee636f6858
Author: Paul Bolle <pebolle@tiscali.nl>
Date:   Fri Oct 14 14:28:11 2011 +0200

    unicore32: drop unused Kconfig symbols
    
    Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
    Acked-by: Guan Xuetao <gxt@mprc.pku.edu.cn>

 arch/unicore32/Kconfig.debug |   14 --------------
 1 files changed, 0 insertions(+), 14 deletions(-)

commit 66ae45604c90f25397294099cdb214f642471327
Author: Axel Lin <axel.lin@gmail.com>
Date:   Wed Oct 5 22:29:47 2011 +0800

    rtc: rtc-puv3: Add __devinit and __devexit markers for probe and
remove
    
    Signed-off-by: Axel Lin <axel.lin@gmail.com>
    Acked-by: Guan Xuetao <gxt@mprc.pku.edu.cn>

 drivers/rtc/rtc-puv3.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

commit 63c95fa414032adb56194d026c9ed054488b0783
Author: Arnaud Lacombe <lacombar@gmail.com>
Date:   Mon Aug 15 01:07:06 2011 -0400

    arch/unicore32: do not use EXTRA_AFLAGS or EXTRA_CFLAGS
    
    Usage of these flags has been deprecated for nearly 4 years by:
    
        commit f77bf01425b11947eeb3b5b54685212c302741b8
        Author: Sam Ravnborg <sam@neptun.(none)>
        Date:   Mon Oct 15 22:25:06 2007 +0200
    
            kbuild: introduce ccflags-y, asflags-y and ldflags-y
    
    Moreover, these flags (at least EXTRA_CFLAGS) have been documented
for command
    line use. By default, gmake(1) do not override command line setting,
so this is
    likely to result in build failure or unexpected behavior.
    
    Replace their usage by Kbuild's `{as,cc,ld}flags-y'.
    
    Cc: Sam Ravnborg <sam@ravnborg.org>
    Cc: Guan Xuetao <gxt@mprc.pku.edu.cn>
    Signed-off-by: Arnaud Lacombe <lacombar@gmail.com>
    Acked-by: Guan Xuetao <gxt@mprc.pku.edu.cn>

 arch/unicore32/boot/compressed/Makefile |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

commit e13b91c1c47e7be178d2d7914452040ee82c0bd2
Author: Guan Xuetao <gxt@mprc.pku.edu.cn>
Date:   Mon Jun 13 11:44:49 2011 +0800

    unicore32: fix build error for find bitops
    
    Remove the __uc32_ prefix in find bitops functions.
    Move find_* macros behind asm-generic/bitops.h inclusion.
    see commit <19de85ef574c3a2182e3ccad9581805052f14946>
      bitops: add #ifndef for each of find bitops
    also see commit <63e424c84429903c92a0f1e9654c31ccaf6694d0>
      arch: remove CONFIG_GENERIC_FIND_{NEXT_BIT,BIT_LE,LAST_BIT}
    
    Signed-off-by: Guan Xuetao <gxt@mprc.pku.edu.cn>
    Cc: Akinobu Mita <akinobu.mita@gmail.com>
    Acked-by: Akinobu Mita <akinobu.mita@gmail.com>
    Cc: Arnd Bergmann <arnd@arndb.de>

 arch/unicore32/include/asm/bitops.h |   12 ++++++------
 arch/unicore32/kernel/ksyms.c       |    4 ++--
 arch/unicore32/lib/findbit.S        |   14 ++++++++------
 3 files changed, 16 insertions(+), 14 deletions(-)

