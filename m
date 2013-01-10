Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753961Ab3AJP2Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 10:28:16 -0500
Received: from mail.skyhub.de ([78.46.96.112]:44626 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751847Ab3AJP2P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 10:28:15 -0500
Date: Thu, 10 Jan 2013 16:28:13 +0100
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: Daniel J Blueman <daniel@numascale-asia.com>,
        lkml <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] NumaScale changes
Message-ID: <20130110152813.GG23008@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Daniel J Blueman <daniel@numascale-asia.com>,
	lkml <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys,

those changes have been a bit longer in the works and were ready even
before the merge window but it was better to hold them off after it and
send them out then. They basically incorporate PCI domain numbers into
AMD northbridge IDs, thus adding support for Numascale confederated
systems.

Please pull,
thanks.

--
The following changes since commit 9931faca02c604c22335f5a935a501bb2ace6e20:

  Linux 3.8-rc3 (2013-01-09 18:59:55 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bp/bp.git tags/numascale

for you to fetch changes up to c7e5301a1b7c3f47af635a8b1b14480b81426025:

  amd64_edac: Fix type usage in NB IDs and memory ranges (2013-01-10 16:18:00 +0100)

----------------------------------------------------------------
This patchset adds support for federated systems where multiple memory
controllers can exist and see each other over multiple PCI domains. This
basically means that AMD node ids can be more than 8 now and the code
handling this is taught to incorporate PCI domain into those IDs.

----------------------------------------------------------------
Daniel J Blueman (4):
      x86, AMD, NB: Add multi-domain support
      x86, AMD, NB: Use u16 for northbridge IDs in amd_get_nb_id
      amd64_edac: Fix PCI function lookup
      amd64_edac: Fix type usage in NB IDs and memory ranges

 arch/x86/include/asm/amd_nb.h    |  17 ++++++++++++++++
 arch/x86/include/asm/processor.h |   2 +-
 arch/x86/kernel/cpu/amd.c        |   4 ++--
 drivers/edac/amd64_edac.c        | 109 ++++++++++++++++++++++++++++++++++++++++++++++++++++------------------------------------------------
 drivers/edac/amd64_edac.h        |  12 +++--------
 5 files changed, 80 insertions(+), 64 deletions(-)

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
