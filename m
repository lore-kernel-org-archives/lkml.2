Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753364Ab1CQOFI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 10:05:08 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:38609 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753172Ab1CQOFF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 10:05:05 -0400
Date: Thu, 17 Mar 2011 15:04:56 +0100
From: Borislav Petkov <bp@amd64.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: edac-devel <linux-edac@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] amd64_edac pile for 39
Message-ID: <20110317140456.GA17574@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from the branch below to receive my latest pile. This
patchset adds support for the memory controller on a new CPU family.
Also, it removes and cleans up a bunch of crap resulting in a diffstat
which gives me a warm and fuzzy feeling:

 8 files changed, 842 insertions(+), 1043 deletions(-)

Thanks.

The following changes since commit 521cb40b0c44418a4fd36dc633f575813d59a43d:

  Linux 2.6.38 (2011-03-14 18:20:32 -0700)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/bp/bp.git for-linus

Borislav Petkov (38):
      EDAC: Shut up sysfs registration debug code
      amd64_edac: Add support for F15h DCT PCI config accesses
      amd64_edac: Remove DRAM base/limit subfields caching
      amd64_edac: Cleanup DHAR handling
      amd64_edac: Cleanup chipselect handling
      amd64_edac: Sanitize channel extraction
      amd64_edac: Sanitize f10_get_base_addr_offset
      amd64_edac: Replace huge bitmasks with a macro
      amd64_edac: Cleanup DBAM handling
      amd64_edac: Cleanup Dram Configuration registers handling
      amd64_edac: Cleanup DCT Select Low/High code
      amd64_edac: Cleanup NBCTL code
      amd64_edac: Cleanup NBCFG handling
      amd64_edac: Cleanup NBSH cruft
      amd64_edac: Cleanup old defines cruft
      amd64_edac: Adjust channel counting to F15h
      amd64_edac: Simplify decoding path
      amd64_edac: Unify get_error_address
      amd64_edac: Add support for interleaved region swapping
      amd64_edac: Correct node interleaving removal
      amd64_edac: Fix channel interleave removal
      amd64_edac: Revamp online spare handling
      amd64_edac: Beef up early exit reporting
      amd64_edac: Adjust sys_addr to chip select conversion routine to F15h
      amd64_edac: Sanitize ->read_dram_ctl_register
      amd64_edac: Improve DRAM address mapping
      PCI: Rename CPU PCI id define
      amd64_edac: Simplify scrubrate setting
      amd64_edac: Adjust ECC symbol size to F15h
      amd64_edac: Enable driver on F15h
      amd64_edac: Drop redundant declarations
      amd64_edac: Fix node id signedness
      amd64_edac: Fix DRAM base macros
      amd64_edac: Fix PCI config addressing types
      amd64_edac: Drop local variable
      amd64_edac: Fix ranges signedness
      amd64_edac: Fix DCT argument type
      amd64_edac: Fix decode_syndrome types

 arch/x86/kernel/amd_nb.c      |    2 +-
 drivers/edac/amd64_edac.c     | 1442 +++++++++++++++++++----------------------
 drivers/edac/amd64_edac.h     |  369 ++++-------
 drivers/edac/amd64_edac_inj.c |    8 +-
 drivers/edac/edac_mc_sysfs.c  |   26 +-
 drivers/edac/mce_amd.c        |    8 +-
 drivers/edac/mce_amd.h        |   28 +-
 include/linux/pci_ids.h       |    2 +-
 8 files changed, 842 insertions(+), 1043 deletions(-)

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632
