Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757440Ab0HCSid (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 14:38:33 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:49462 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756232Ab0HCSib (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 14:38:31 -0400
Date: Tue, 3 Aug 2010 20:38:49 +0200
From: Borislav Petkov <bp@amd64.org>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] amd64_edac patchqueue for .36
Message-ID: <20100803183849.GA303@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
user-agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ Forgot to add LKML to CC ]

Hi Linus,

please pull the following patchqueue of mostly cleanups and fixes.

On thing that stands out is the removal of EDAC's quirky polling
mechanism in favor of using the MCE decoder notifier chain for non-fatal
MCEs (of which CECCs are part of). Thus the out-of-tree oneliner to
<arch/x86/kernel/cpu/mcheck/mce.c> which Ingo already acked.

Thanks.

The following changes since commit 9fe6206f400646a2322096b56c59891d530e8d51:

  Linux 2.6.35 (2010-08-01 15:11:14 -0700)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/bp/bp.git for-linus

Borislav Petkov (10):
      amd64_edac: Sanitize syndrome extraction
      edac: Remove EDAC_DEBUG_VERBOSE
      amd64_edac: Remove unneeded defines
      x86, mce: Notify about corrected events too
      amd64_edac: Remove polling mechanism
      amd64_edac: Fix DCT base address selector
      amd64_edac: Correct scrub rate setting
      edac, mc: Improve scrub rate handling
      amd64_edac: Fix operator precendence error
      amd64_edac: Minor formatting fix

 arch/x86/kernel/cpu/mcheck/mce.c |    1 +
 drivers/edac/Kconfig             |    8 --
 drivers/edac/amd64_edac.c        |  213 ++++++++++----------------------------
 drivers/edac/amd64_edac.h        |   48 +++------
 drivers/edac/e752x_edac.c        |    4 +-
 drivers/edac/edac_core.h         |   17 +---
 drivers/edac/edac_mc_sysfs.c     |   86 +++++++---------
 drivers/edac/edac_mce_amd.c      |   16 ++--
 drivers/edac/i5100_edac.c        |    7 +-
 9 files changed, 121 insertions(+), 279 deletions(-)

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632
