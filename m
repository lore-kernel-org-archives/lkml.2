Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757993Ab0JUN2o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 09:28:44 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:42357 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755941Ab0JUN2m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 09:28:42 -0400
Date: Thu, 21 Oct 2010 15:29:39 +0200
From: Borislav Petkov <bp@amd64.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: edac-devel <linux-edac@vger.kernel.org>, x86 <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] EDAC, MCE decoding additions for .37
Message-ID: <20101021132939.GB12277@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

the patchset at the repo branch below introduces MCE decoding support
for two new AMD CPU families. Also, it reworks the whole MCE decoding
code in an attempt to make it much more succinct and efficient. Also, it
cleans up a bunch of stuff in edac core.

Please pull,
thanks.

---
The following changes since commit f6f94e2ab1b33f0082ac22d71f66385a60d8157f:

  Linux 2.6.36 (2010-10-20 13:30:22 -0700)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/bp/bp.git for-linus

Borislav Petkov (21):
      EDAC: Fix error return
      EDAC, MCE: Add HW_ERR prefix
      EDAC, MCE: Remove unused function parameter
      EDAC, MCE: Sanitize error codes
      EDAC, MCE: Pass complete MCE info to decoders
      EDAC: Export edac sysfs class to users.
      EDAC, MCE: Rework MCE injection
      EDAC, MCE: Rename files
      EDAC, MCE: Adjust DC decoders to F14h
      EDAC, MCE: Adjust IC decoders to F14h
      EDAC, MCE: Warn about LS MCEs on F14h
      EDAC, MCE: Complete NB MCE decoders
      EDAC, MCE: Fix FR MCEs decoding
      EDAC, MCE: Enable MCE decoding on F14h
      EDAC, MCE: Add support for F11h MCEs
      EDAC, MCE: Add F12h DC MCE decoder
      EDAC, MCE: Add F12h IC MCE decoder
      EDAC, MCE: Add F12h NB MCE decoder
      EDAC, MCE: Enable MCE decoding on F12h
      EDAC, MCE: Add a BIT_64() macro
      EDAC, MCE: Fix shift warning on 32-bit

 drivers/edac/Kconfig                       |   14 +-
 drivers/edac/Makefile                      |    3 +
 drivers/edac/amd64_edac.c                  |   13 +-
 drivers/edac/amd64_edac.h                  |    5 +-
 drivers/edac/amd64_edac_dbg.c              |  207 +--------
 drivers/edac/edac_device_sysfs.c           |   16 +-
 drivers/edac/edac_mc_sysfs.c               |   11 +-
 drivers/edac/edac_mce_amd.c                |  452 ------------------
 drivers/edac/edac_module.c                 |   79 +----
 drivers/edac/edac_module.h                 |    1 -
 drivers/edac/edac_pci_sysfs.c              |   10 +-
 drivers/edac/edac_stub.c                   |   51 ++-
 drivers/edac/mce_amd.c                     |  680 ++++++++++++++++++++++++++++
 drivers/edac/{edac_mce_amd.h => mce_amd.h} |   59 +++-
 drivers/edac/mce_amd_inj.c                 |  171 +++++++
 include/linux/edac.h                       |    4 +
 16 files changed, 1018 insertions(+), 758 deletions(-)
 delete mode 100644 drivers/edac/edac_mce_amd.c
 create mode 100644 drivers/edac/mce_amd.c
 rename drivers/edac/{edac_mce_amd.h => mce_amd.h} (65%)
 create mode 100644 drivers/edac/mce_amd_inj.c

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632
