Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753595Ab2LKOBP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 09:01:15 -0500
Received: from mail.skyhub.de ([78.46.96.112]:55728 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752472Ab2LKOBN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 09:01:13 -0500
Date: Tue, 11 Dec 2012 15:01:08 +0100
From: Borislav Petkov <bp@alien8.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-edac <linux-edac@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] EDAC fixes for 3.8
Message-ID: <20121211140108.GC4303@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-edac <linux-edac@vger.kernel.org>,
	lkml <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull the 'for-linus' branch below to receive the following
changes to EDAC:

* EDAC core error path fix, from Denis Kirjanov.

* Generalization of AMD MCE bank names and some minor error reporting
improvements.

* EDAC core cleanups and simplifications, from Wei Yongjun.

* amd64_edac fixes for sysfs-reported values, from Josh Hunt.

* some heavy amd64_edac error reporting path shaving, leading to
removing a bunch of code.

* amd64_edac error injection method improvements.

* EDAC core cleanups and fixes.

Thanks.

The following changes since commit 9489e9dcae718d5fde988e4a684a0f55b5f94d17:

  Linux 3.7-rc7 (2012-11-25 17:59:19 -0800)

are available in the git repository at:

  ssh://git.kernel.org/pub/scm/linux/kernel/git/bp/bp.git for-linus

for you to fetch changes up to 3bfe5aae8edd8436d26cddfeab783492d8950821:

  EDAC, pci_sysfs: Use for_each_pci_dev to simplify the code (2012-12-04 08:27:39 +0100)

----------------------------------------------------------------
Borislav Petkov (19):
      EDAC: Respect operational state in edac_pci.c
      EDAC: Boundary-check edac_debug_level
      EDAC: Remove useless assignment of error type
      EDAC: Handle empty msg strings when reporting errors
      amd64_edac: Small fixlets and cleanups
      amd64_edac: Cleanup error injection code
      amd64_edac: Improve error injection
      amd64_edac: Do not check whether error address is valid
      amd64_edac: Reorganize error reporting path
      amd64_edac: Fix K8 chip select reporting
      amd64_edac: Use DBAM_DIMM macro
      amd64_edac: Fix csrows size and pages computation
      EDAC: Add memory controller flags
      EDAC: Pass mci parent
      EDAC: Fix csrow size reported in sysfs
      MCE, AMD: Remove functional unit references
      MCE, AMD: Dump CPU f/m/s triple with the error
      MCE, AMD: Report decoded error type first
      MCE, AMD: Dump error status

Denis Kirjanov (1):
      EDAC: Handle error path in edac_mc_sysfs_init() properly

Josh Hunt (1):
      EDAC: Fix mc size reported in sysfs

Wei Yongjun (3):
      EDAC, Calxeda highbank: Convert to use simple_open()
      EDAC: Convert to use simple_open()
      EDAC, pci_sysfs: Use for_each_pci_dev to simplify the code

 drivers/edac/Kconfig            |   8 +-
 drivers/edac/amd64_edac.c       | 297 +++++++++++++++-------------------------
 drivers/edac/amd64_edac.h       |  59 ++++++--
 drivers/edac/amd64_edac_inj.c   | 128 ++++++++---------
 drivers/edac/edac_mc.c          |  51 +++----
 drivers/edac/edac_mc_sysfs.c    |  39 ++++--
 drivers/edac/edac_module.c      |  27 +++-
 drivers/edac/edac_pci.c         |   3 +-
 drivers/edac/edac_pci_sysfs.c   |  12 +-
 drivers/edac/highbank_mc_edac.c |   8 +-
 drivers/edac/mce_amd.c          | 254 ++++++++++++++++++----------------
 drivers/edac/mce_amd.h          |  11 +-
 include/linux/edac.h            |   3 +
 13 files changed, 454 insertions(+), 446 deletions(-)

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
