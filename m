Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752038Ab2AVADs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jan 2012 19:03:48 -0500
Received: from utopia.booyaka.com ([72.9.107.138]:37087 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751211Ab2AVACO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jan 2012 19:02:14 -0500
MBOX-Line: From nobody Sat Jan 21 16:59:28 2012
Subject: [PATCH 0/8] ARM: OMAP: HDQ/1-wire: update driver to use runtime PM
To: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
From: Paul Walmsley <paul@pwsan.com>
Cc: NeilBrown <neilb@suse.de>, Evgeniy Polyakov <zbr@ioremap.net>,
        Kevin Hilman <khilman@ti.com>
Date: Sat, 21 Jan 2012 16:59:28 -0700
Message-ID: <20120121235333.17619.56725.stgit@dusk>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ This series intended for the 3.4 merge window ]

Update the OMAP HDQ/1-wire driver to use runtime PM.  This includes
integration with the rest of the OMAP power management and device
enumeration code.  And there was a bug/undocumented feature in the HDQ reset
process that needed a workaround.

Evgeniy, could you ack the change to the 1-wire driver?  Otherwise, if you
would like to merge it, we'd probably need to split this series across two
merge windows.

The series has been boot-tested on an OMAP35xx Beagleboard, but more
testing would certainly be welcome.  Before merging it, I intend to
boot-test it on OMAP2 and OMAP4 boards at least, but I don't think I
have any boards with a 1-wire chip on-board.  So if someone has an OMAP
board with 1-wire devices, (hint hint Neil ;-) a quick test would be
much appreciated.

This series is also available via git at

git://git.pwsan.com/linux-2.6

in the branch

hdq_hwmod_runtime_pm_devel_3.4


- Paul

---

hdq_hwmod_runtime_pm_devel_3.4
   text	   data	    bss	    dec	    hex	filename
6596693	 679492	5590716	12866901	 c45555	vmlinux.orig
6600917	 679740	5590716	12871373	 c466cd	vmlinux.patched

Paul Walmsley (8):
      ARM: OMAP3: clock data: add clockdomain for HDQ functional clock
      ARM: OMAP2+: HDQ1W: add custom reset function
      ARM: OMAP2+: hwmod data: add HDQ/1-wire hwmod shared data
      ARM: OMAP3: hwmod data: add HDQ/1-wire hwmod
      ARM: OMAP2xxx: hwmod data: add HDQ/1-wire hwmod
      ARM: OMAP4: hwmod data: add HDQ/1-wire hwmod
      ARM: OMAP2+: HDQ1W: use omap_device
      W1: OMAP HDQ1W: use runtime PM


 arch/arm/mach-omap2/Makefile                       |    2 
 arch/arm/mach-omap2/clock3xxx_data.c               |    3 -
 arch/arm/mach-omap2/devices.c                      |   37 --------
 arch/arm/mach-omap2/hdq1w.c                        |   98 ++++++++++++++++++++
 arch/arm/mach-omap2/omap_hwmod_2420_data.c         |   41 ++++++++
 arch/arm/mach-omap2/omap_hwmod_2430_data.c         |   38 ++++++++
 .../omap_hwmod_2xxx_3xxx_interconnect_data.c       |    9 ++
 .../mach-omap2/omap_hwmod_2xxx_3xxx_ipblock_data.c |   22 ++++
 arch/arm/mach-omap2/omap_hwmod_3xxx_data.c         |   39 ++++++++
 arch/arm/mach-omap2/omap_hwmod_44xx_data.c         |   74 +++++++++++++++
 arch/arm/mach-omap2/omap_hwmod_common_data.h       |    4 +
 arch/arm/plat-omap/include/plat/hdq1w.h            |   36 +++++++
 drivers/w1/masters/omap_hdq.c                      |   78 +++-------------
 13 files changed, 376 insertions(+), 105 deletions(-)
 create mode 100644 arch/arm/mach-omap2/hdq1w.c
 create mode 100644 arch/arm/plat-omap/include/plat/hdq1w.h

