Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932776Ab2JZMsg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 08:48:36 -0400
Received: from mail.x86-64.org ([217.9.48.20]:47779 "EHLO mail.x86-64.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932731Ab2JZMsd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 08:48:33 -0400
Date: Fri, 26 Oct 2012 14:48:26 +0200
From: Borislav Petkov <bp@amd64.org>
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: Tony Luck <tony.luck@intel.com>, x86 <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@alien8.de>
Subject: [GIT PULL] RAS: MCA config cleanup
Message-ID: <20121026124826.GA5762@aftab.osrc.amd.com>
Reply-To: Borislav Petkov <bp@alien8.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys,

this is 5-patch set reworking the config variables in the MCA code.
There's an out-of-tree change which Greg and I agreed to push through
the RAS tree. These changes are for the next merge window.

Please pull,
thanks.

The following changes since commit 6f0c0580b70c89094b3422ba81118c7b959c7556:

  Linux 3.7-rc2 (2012-10-20 12:11:32 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/ras/ras.git tags/mca_cfg

for you to fetch changes up to 1462594bf2866c1dc80066ed6f49f4331c551901:

  x86, MCA: Finish mca_config conversion (2012-10-26 14:37:58 +0200)

----------------------------------------------------------------
Rework all config variables used throughout the MCA code and collect
them together into a mca_config struct. This keeps them tightly and
neatly packed together instead of spilled all over the place.

Then, convert those which are used as booleans into real booleans and
save some space.

----------------------------------------------------------------
Borislav Petkov (5):
      drivers/base: Add a DEVICE_BOOL_ATTR macro
      x86, MCA: Convert dont_log_ce, banks and tolerant
      x86, MCA: Convert rip_msr, mce_bootlog, monarch_timeout
      x86, MCA: Convert the next three variables batch
      x86, MCA: Finish mca_config conversion

 arch/x86/include/asm/mce.h                |  21 ++-
 arch/x86/kernel/cpu/mcheck/mce-internal.h |   2 -
 arch/x86/kernel/cpu/mcheck/mce-severity.c |   4 +-
 arch/x86/kernel/cpu/mcheck/mce.c          | 209 +++++++++++++++---------------
 arch/x86/kernel/cpu/mcheck/mce_intel.c    |   8 +-
 arch/x86/lguest/boot.c                    |   2 +-
 drivers/base/core.c                       |  21 +++
 include/linux/device.h                    |   7 +
 8 files changed, 159 insertions(+), 115 deletions(-)

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
