Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758844Ab0KRPSx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 10:18:53 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:57492 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751458Ab0KRPSw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 10:18:52 -0500
Date: Thu, 18 Nov 2010 16:17:33 +0100
From: Borislav Petkov <bp@amd64.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        "Rosenfeld, Hans" <Hans.Rosenfeld@amd.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Herrmann3, Andreas" <Andreas.Herrmann3@amd.com>
Subject: [GIT PULL] amd-nb facelift for .38
Message-ID: <20101118151733.GC11779@aftab>
References: <1288365272-214117-1-git-send-email-hans.rosenfeld@amd.com>
 <1288365272-214117-3-git-send-email-hans.rosenfeld@amd.com>
 <20101116173340.GA9417@kryptos.osrc.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101116173340.GA9417@kryptos.osrc.amd.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

the following basically does an initial facelift to the k8_nb stuff
which we're going to use increasingly in the future - it representing
the northbridges on a system. The patches look straight-forward to me,
I've randconfig-built them for a while with no regressions but let's not
hurry so yes, leave them for .38.

Also, I've fixed up the commit titles and rebased them ontop of 37-rc2.

Please pull,
thanks.

--
The following changes since commit e53beacd23d9cb47590da6a7a7f6d417b941a994:

  Linux 2.6.37-rc2 (2010-11-15 18:31:02 -0800)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/bp/bp.git tip-amd-nb

Hans Rosenfeld (3):
      x86, amd-nb: Complete the rename of AMD NB and related code
      x86, amd-nb: Cleanup AMD northbridge caching code
      x86, cacheinfo: Cleanup L3 cache index disable support

 arch/x86/Kconfig                                  |   12 +-
 arch/x86/include/asm/amd_nb.h                     |   49 +++++---
 arch/x86/kernel/amd_nb.c                          |  135 +++++++++++--------
 arch/x86/kernel/aperture_64.c                     |   10 +-
 arch/x86/kernel/cpu/intel_cacheinfo.c             |  147 +++++++++------------
 arch/x86/kernel/pci-gart_64.c                     |   34 +++---
 arch/x86/kernel/setup.c                           |    8 +-
 arch/x86/mm/Makefile                              |    2 +-
 arch/x86/mm/{k8topology_64.c => amdtopology_64.c} |   12 +-
 arch/x86/mm/numa_64.c                             |   22 ++--
 drivers/char/agp/amd64-agp.c                      |   33 +++---
 drivers/edac/amd64_edac.c                         |    4 +-
 12 files changed, 244 insertions(+), 224 deletions(-)
 rename arch/x86/mm/{k8topology_64.c => amdtopology_64.c} (94%)

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632
