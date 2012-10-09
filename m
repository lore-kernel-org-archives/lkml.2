Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755252Ab2JISki (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 14:40:38 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:62364 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754273Ab2JISkg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 14:40:36 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Russell King - ARM Linux" <linux@arm.linux.org.uk>
Subject: Re: [GIT PULL 0/9] ARM architecture fixes for 3.7
Date: Tue, 9 Oct 2012 18:40:24 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        bryan.wu@canonical.com, catalin.marinas@arm.com,
        dave.martin@linaro.org, jeremy@goop.org, jonathan.austin@arm.com,
        konrad.wilk@oracle.com, leif.lindholm@arm.com,
        linus.walleij@linaro.org, damm@opensource.se, mmarek@suse.cz,
        rjw@sisk.pl, stefano.stabellini@eu.citrix.com, sboyd@codeaurora.org,
        tglx@linutronix.de, will.deacon@arm.com, xen-devel@lists.xensource.com
References: <1349796183-30648-1-git-send-email-arnd@arndb.de> <20121009160814.GH4625@n2100.arm.linux.org.uk>
In-Reply-To: <20121009160814.GH4625@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201210091840.25176.arnd@arndb.de>
X-Provags-ID: V02:K0:tQdb119hD1lk6ulXNiENdiLDqdWK/FAQrWwrghUJAUO
 5NMhcRJjjTc1UdVC9C8i/FmD0RT/cdXbn1CdeultGF5EOstsmc
 r36AosL3F2tDKmwsAgJwnX6aT5Hio++SUcH5dfTSecqCNYu0lP
 kAdAyyNw/FsKv+4hLIE3pQ+FndrwyRWze9DH3UkvkALMhZoraK
 Cxcgp/y+x+RV0ogWM7GnTuhK5haGe0aTDQw3FUsGvVkne7NaXy
 sZMk4cbWevaS/dtTxCDDK/uKVtvtcoiy/mPEBGWFPXCUDwQY7c
 CeoSpgg8fdVCikihUNybIDBE2x7ckjEbtM9NPKlE49+xKJmrM1
 SM3DwFCGlNFKHx/AQLvI=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 09 October 2012, Russell King - ARM Linux wrote:
> 
> On Tue, Oct 09, 2012 at 05:22:54PM +0200, Arnd Bergmann wrote:
> > Here are some patches that belong into your domain, I hope you can
> > just send the lot to Linus the next time you send other patches.
> > 
> > These bug fixes all address problems found with automated build testing.
> > Some of them have been around for a long time, other bugs are
> > regressions since the merge window.
> 
> Apart from the sliced off comment in one commit (which XEN people need
> to confirm they're happy with the final version), I think these are
> otherwise fine... I'll hold off pulling them until that can be fixed.

Fixed that now, and I also added the Acks that I got in the meantime,
changed the dependency from Xen on (CPU_v7 && !CPU_V6), and edited the
description for patch 6 as Dave suggested.

	Arnd

8<---
The following changes since commit 0e51793e162ca432fc5f04178cf82b80a92c2659:

  Merge branch 'for-linus' of git://git.linaro.org/people/rmk/linux-arm (2012-10-07 21:20:57 +0900)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/fixes-for-rmk

for you to fetch changes up to 8e7fc18b5eacc37b6e6fcf486ec4eafbfef91738:

  ARM: warnings in arch/arm/include/asm/uaccess.h (2012-10-09 20:29:07 +0200)

----------------------------------------------------------------
These bug fixes all address problems found with automated build testing.
Some of them have been around for a long time, other bugs are
regressions since the merge window.

----------------------------------------------------------------
Arnd Bergmann (9):
      ARM: kprobes: make more tests conditional
      ARM: export set_irq_flags
      ARM: Fix another build warning in arch/arm/mm/alignment.c
      ARM: export default read_current_timer
      ARM: Xen: fix initial build problems
      ARM: pass -marm to gcc by default for both C and assembler
      ARM: be really quiet when building with 'make -s'
      ARM: binfmt_flat: unused variable 'persistent'
      ARM: warnings in arch/arm/include/asm/uaccess.h

 arch/arm/Kconfig                   |    1 +
 arch/arm/Makefile                  |   13 +++++++------
 arch/arm/boot/Makefile             |   10 +++++-----
 arch/arm/include/asm/flat.h        |    2 +-
 arch/arm/include/asm/uaccess.h     |    4 ++--
 arch/arm/kernel/irq.c              |    2 ++
 arch/arm/kernel/kprobes-test-arm.c |    4 ++++
 arch/arm/lib/delay.c               |    1 +
 arch/arm/mm/alignment.c            |    4 +++-
 arch/arm/tools/Makefile            |    2 +-
 drivers/xen/Kconfig                |    2 ++
 drivers/xen/sys-hypervisor.c       |    1 +
 12 files changed, 30 insertions(+), 16 deletions(-)
