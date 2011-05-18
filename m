Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933726Ab1ERTVD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 15:21:03 -0400
Received: from mail-px0-f173.google.com ([209.85.212.173]:51444 "EHLO
	mail-px0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933641Ab1ERTU6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 15:20:58 -0400
Subject: [git pull][PATCH 0/2] Fix regression caused by addition of 'of_match'
To: devicetree-discuss@lists.ozlabs.org, gregkh@suse.de,
        linux-kernel@vger.kernel.org, Milton Miller <miltonm@bga.com>,
        sparclinux@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        David Miller <davem@davemloft.net>, Josip Rodin <joy@entuzijast.net>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Wed, 18 May 2011 13:20:55 -0600
Message-ID: <20110518185751.28986.69446.stgit@ponder>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Here is Milton's patch to fix up the race condition on devicetree
driver matching observed on SPARC, plus a follow up patch to remove
the whole of_match thing entirely, which I've tested on my platforms,
but has not yet been verified by anyone else.

I'll leave it up to you whether to take both commits, or just the
first one.  The second does eventually need to be committed to 2.6.39,
whether by you or in -stable, but it is a much bigger commit and it
hasn't had any testing beyond what I've done here (a handful of
powerpc, sparc, x86, and mips defconfigs, plus boot testing on
powerpc and making sure each driver was compiled in at least one
config).

I've pushed it all out to my git server as show below...

---
The following changes since commit 2e9521fd656f05a716b5294a7dbebd37ced05e43:

Merge branch 'v4l_for_linus' of git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6 (2011-05-18 03:16:38 -0700)

are available in the git repository at:

  git://git.secretlab.ca/git/linux-2.6 devicetree/merge

Grant Likely (1):
      drivercore: revert addition of of_match to struct device

Milton Miller (1):
      of: fix race when matching drivers


 arch/powerpc/platforms/83xx/suspend.c      |    7 +++++--
 arch/powerpc/sysdev/fsl_msi.c              |    7 +++++--
 arch/sparc/kernel/pci_sabre.c              |    5 ++++-
 arch/sparc/kernel/pci_schizo.c             |    8 ++++++--
 drivers/atm/fore200e.c                     |    7 +++++--
 drivers/char/hw_random/n2-drv.c            |    7 +++++--
 drivers/char/ipmi/ipmi_si_intf.c           |    7 +++++--
 drivers/char/xilinx_hwicap/xilinx_hwicap.c |   14 +++++++++-----
 drivers/edac/ppc4xx_edac.c                 |    2 +-
 drivers/i2c/busses/i2c-mpc.c               |    9 ++++++---
 drivers/mmc/host/sdhci-of-core.c           |    7 +++++--
 drivers/mtd/maps/physmap_of.c              |    7 +++++--
 drivers/net/can/mscan/mpc5xxx_can.c        |    7 +++++--
 drivers/net/fs_enet/fs_enet-main.c         |    9 ++++++---
 drivers/net/fs_enet/mii-fec.c              |    7 +++++--
 drivers/net/sunhme.c                       |    7 +++++--
 drivers/scsi/qlogicpti.c                   |    7 +++++--
 drivers/tty/serial/of_serial.c             |    7 +++++--
 drivers/usb/gadget/fsl_qe_udc.c            |    7 +++++--
 drivers/watchdog/mpc8xxx_wdt.c             |    7 +++++--
 include/linux/device.h                     |    1 -
 include/linux/of_device.h                  |    8 ++++++--
 22 files changed, 108 insertions(+), 46 deletions(-)

-- 
Signature
