Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757984Ab2HQOax (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 10:30:53 -0400
Received: from mail.x86-64.org ([217.9.48.20]:57062 "EHLO mail.x86-64.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756930Ab2HQOao (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 10:30:44 -0400
Date: Fri, 17 Aug 2012 16:30:35 +0200
From: Borislav Petkov <bp@amd64.org>
To: Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>
Cc: Andreas Herrmann <andreas.herrmann3@amd.com>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>, x86 <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] x86, microcode, AMD: Per-family patches cache
Message-ID: <20120817143035.GA25700@aftab.osrc.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys,

please pull, thanks.

The following changes since commit d9875690d9b89a866022ff49e3fcea892345ad92:

  Linux 3.6-rc2 (2012-08-16 14:51:24 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bp/bp.git tags/microcode-updates-for-3.7

for you to fetch changes up to cd692919bed1d59a440ffaed585ebc3c9d8c3406:

  x86, microcode, AMD: Rewrite patch application procedure (2012-08-17 14:17:42 +0200)

----------------------------------------------------------------
Per-family patches cache

This patch set adds code for caching all microcode patches which belong
to the current family on which we're running. We look up the patch
needed for each core from the cache at application time instead of
holding a single patch per-system.

Also, a bunch of fixes/cleanups precede the meat in the last 3.

Patchset has been tested on all families which are supported by the
microcode loader ( >= 0x10).

----------------------------------------------------------------
Andreas Herrmann (1):
      x86, microcode, AMD: Fix broken ucode patch size check

Borislav Petkov (11):
      x86, microcode: Save an indentation level in reload_for_cpu
      x86, microcode: Drop uci->mc check on resume path
      x86, microcode: Cleanup cpu hotplug notifier callback
      x86, microcode: Straighten out Kconfig text
      x86, microcode, AMD: Remove useless get_ucode_data wrapper
      x86, microcode, AMD: Check before applying a patch
      x86, microcode, AMD: Read CPUID(1).EAX on the correct cpu
      x86, microcode: Add a refresh firmware flag to ->request_microcode_fw
      x86, microcode, AMD: Add reverse equiv table search
      x86, microcode, AMD: Add a small, per-family patches cache
      x86, microcode, AMD: Rewrite patch application procedure

 arch/x86/Kconfig                  |  20 +--
 arch/x86/include/asm/microcode.h  |  10 +-
 arch/x86/kernel/microcode_amd.c   | 356 ++++++++++++++++++++++++--------------
 arch/x86/kernel/microcode_core.c  |  67 +++----
 arch/x86/kernel/microcode_intel.c |   3 +-
 5 files changed, 273 insertions(+), 183 deletions(-)



-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
