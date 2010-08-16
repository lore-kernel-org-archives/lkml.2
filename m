Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752646Ab0HPJMI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 05:12:08 -0400
Received: from mga09.intel.com ([134.134.136.24]:19571 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751250Ab0HPJMG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 05:12:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,375,1278313200"; 
   d="scan'208";a="648159656"
Subject: [GIT PULL] dmaengine: one more driver for 2.6.36
From: Dan Williams <dan.j.williams@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Walleij <linus.walleij@stericsson.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 16 Aug 2010 02:14:32 -0700
Message-ID: <1281950072.13679.17.camel@dwillia2-linux>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus, please consider pulling from:

  git://git.kernel.org/pub/scm/linux/kernel/git/djbw/async_tx.git next

...to receive one more driver that was originally posted well in advance
of this window.  I had some review comments that were duly resolved, but
I did not handle this updated version in a timely manner.  I would
prefer that this driver not wait for 2.6.37 as it was prepared in time
for this window.  Two other fixlets are also included.

None of this has seen a -next release, but the driver passes my build
regression and the other two are obviously correct.

Thanks,
Dan

Dan Carpenter (1):
      dma/shdma: move dereference below the NULL check

Linus Walleij (2):
      DMAENGINE: correct PL080 register header file
      DMAENGINE: driver for the ARM PL080/PL081 PrimeCells v4

Mathieu Lacage (1):
      missing inline keyword for static function in linux/dmaengine.h

 arch/arm/include/asm/hardware/pl080.h |    4 +-
 arch/arm/mach-s3c64xx/dma.c           |    2 +-
 drivers/dma/Kconfig                   |    8 +
 drivers/dma/Makefile                  |    1 +
 drivers/dma/amba-pl08x.c              | 2025 +++++++++++++++++++++++++++++++++
 drivers/dma/shdma.c                   |    3 +-
 include/linux/amba/pl08x.h            |  184 +++
 include/linux/dmaengine.h             |    2 +-
 8 files changed, 2225 insertions(+), 4 deletions(-)
 create mode 100644 drivers/dma/amba-pl08x.c
 create mode 100644 include/linux/amba/pl08x.h

commit 23054a9ce8ac8f3d0d63b21818b73f30a1cd76dc
Author: Linus Walleij <linus.walleij@stericsson.com>
Date:   Mon Aug 9 12:48:02 2010 +0200

    DMAENGINE: driver for the ARM PL080/PL081 PrimeCells v4
    
    This creates a DMAengine driver for the ARM PL080/PL081 PrimeCells
    based on the implementation earlier submitted by Peter Pearse.
    This is working like a charm for memcpy and slave DMA to the PL011
    PrimeCell on the PB11MPCore.
    
    This DMA controller is used in mostly unmodified form in the ARM
    RealView and Versatile platforms, in the ST-Ericsson Nomadik, and
    in the ST SPEAr platform.
    
    It has been converted to use the header from the Samsung PL080
    derivate instead of its own defintions. The Samsungs have a custom
    driver in their mach-* folders though, atleast we can share the
    register definitions.
    
    Cc: Peter Pearse <peter.pearse@arm.com>
    Cc: Ben Dooks <ben-linux@fluff.org>
    Cc: Kukjin Kim <kgene.kim@samsung.com>
    Cc: Alessandro Rubini <rubini@unipv.it>
    Acked-by: Viresh Kumar <viresh.kumar@st.com>
    Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 38f919e94ea408b89196c4e1ea3f9605ca9b5e8a
Author: Linus Walleij <linus.walleij@stericsson.com>
Date:   Mon Aug 9 12:47:52 2010 +0200

    DMAENGINE: correct PL080 register header file
    
    This PL008 among all other variables named PL080 doesn't seem
    right. Fix it. Also add some missing defined that I use in the
    new PL08x driver.
    
    Acked-by: Ben Dooks <ben-linux@fluff.org>
    Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 63bf2c4968c4a0214b4c2f5575362799a036dc37
Author: Mathieu Lacage <mathieu.lacage@sophia.inria.fr>
Date:   Sat Aug 14 15:02:44 2010 +0200

    missing inline keyword for static function in linux/dmaengine.h
    
    Add a missing inline keyword for static function in linux/dmaengine.h to
    avoid duplicate symbol definitions.
    
    Signed-off-by: Mathieu Lacage <mathieu.lacage@sophia.inria.fr>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit f368c9bb381bea8628314c13c1e463c409dff84d
Author: Dan Carpenter <error27@gmail.com>
Date:   Sat Aug 14 11:01:45 2010 +0200

    dma/shdma: move dereference below the NULL check
    
    "param" can be NULL here, so only dereference it after the check.
    
    Signed-off-by: Dan Carpenter <error27@gmail.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>


