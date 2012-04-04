Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932399Ab2DDRkS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 13:40:18 -0400
Received: from mail2.gnudd.com ([213.203.150.91]:64178 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932211Ab2DDRkR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 13:40:17 -0400
Date: Wed, 4 Apr 2012 19:39:45 +0200
From: Alessandro Rubini <rubini@gnudd.com>
To: linux-kernel@vger.kernel.org
Cc: Giancarlo Asnaghi <giancarlo.asnaghi@st.com>,
        Alan Cox <alan@linux.intel.com>, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, x86@kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>,
        Ingo Molnar <mingo@elte.hu>
Subject: [PATCH V5 0/3] STA2X11: patches for pci bridge support
Message-ID: <cover.1333560789.git.rubini@gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: GnuDD, Device Drivers, Embedded Systems, Courses
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a repost of the patch set I sent on Mar 13th.
Patch 3 is modified to accound for a change in prototype for
the swiotlb alloc method.

Patch 3 is dependent on patch 1 and 2, which are unordered. The
big patch was picked up from V2 but without its dependencies.
It seems like the set can be accepted but was probably forgotten.

Other patches (for the sub-devices in this chip) are being worked on,
but they all depend on CONFIG_STA2X11, so I'd like these to be merged.
No problems have been reported on V4 and I actually expected Ingo to
pull them.

thanks
/alessandro


Summary:

Patch 1: no functional effect (it uses an existing "#ifdef CONFIG_X86_64"
in the 32-bit world, so it's not CONFIG_X86_64 but a new name)

Patch 2: no functional effect (it allows some inline functions to not be
inline where needed, with a new config symbol).

Patch 3: it's the real content.


History:

V5: rebased on next-20120403, fixed swiotlb change.

V4: rebased on next-20120309, no changes.

V3: rebased on next-20120221. Fixed patch 3 to match new DMA
prototypes. Renamed patch 3 as Ingo and Jesse merged it. Added both of
them to explicit Cc: list in the email set.

V2: rebased, minor and less-minor changes in patch 3/3.




Alessandro Rubini (3):
  x86: introduce CONFIG_X86_DEV_DMA_OPS
  x86: introduce CONFIG_X86_DMA_REMAP
  x86/PCI: initial support for sta2x11 I/O hub

 arch/x86/Kconfig                   |   34 +++-
 arch/x86/include/asm/device.h      |    4 +-
 arch/x86/include/asm/dma-mapping.h |    9 +-
 arch/x86/pci/Makefile              |    2 +
 arch/x86/pci/sta2x11-fixup.c       |  366 ++++++++++++++++++++++++++++++++++++
 5 files changed, 408 insertions(+), 7 deletions(-)
 create mode 100644 arch/x86/pci/sta2x11-fixup.c

-- 
1.7.7.2
