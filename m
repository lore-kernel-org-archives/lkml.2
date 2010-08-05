Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933963Ab0HERV0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 13:21:26 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:58329 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757439Ab0HERVX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 13:21:23 -0400
From: Kevin Hilman <khilman@deeprootsystems.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Cc: davinci-linux-open-source@linux.davincidsp.com
Subject: [GIT PULL] davinci updates for 2.6.36
Organization: Deep Root Systems, LLC
Date: Thu, 05 Aug 2010 10:21:20 -0700
Message-ID: <87ocdhvuun.fsf@deeprootsystems.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Here are the updates for the DaVinci family of ARM-based SoCs for 2.6.36.

The bulk of this is the addition of the core support for a new SoC in
the family: the tnetv107x.

Also, This was recently rebased to drop the addition of another ARM
defconfig from the original tnetv series as well as to address a
conflict discovered in linux-next.

Kevin


The following changes since commit 7e27d6e778cd87b6f2415515d7127eba53fe5d02:

  Linux 2.6.35-rc3 (2010-06-11 19:14:04 -0700)

are available in the git repository at:
  ssh://master.kernel.org/pub/scm/linux/kernel/git/khilman/linux-davinci.git davinci-for-linus

Cyril Chemparathy (5):
      Davinci: generalized debug macros
      Davinci: tnetv107x decompresser uart definitions
      Davinci: tnetv107x soc support
      Davinci: tnetv107x initial gpio support
      Davinci: tnetv107x evm board initial support

Rajashekhara, Sudhakar (3):
      davinci: support for EDMA resource sharing
      davinci: da8xx/omapl EVM: Specify reserved channels/slots
      davinci: dm646x EVM: Specify reserved EDMA channel/slots

Sekhar Nori (2):
      davinci: da8xx: sparse cleanup: remove duplicate entries in irq priorities
      davinci: edma: provide ability to detect insufficient CC info data

Thomas Koeller (1):
      davinci: DM365: fixed second serial port

 arch/arm/mach-davinci/Kconfig                    |   12 +
 arch/arm/mach-davinci/Makefile                   |    3 +
 arch/arm/mach-davinci/board-da830-evm.c          |   32 +-
 arch/arm/mach-davinci/board-da850-evm.c          |   52 ++-
 arch/arm/mach-davinci/board-dm646x-evm.c         |   35 +
 arch/arm/mach-davinci/board-tnetv107x-evm.c      |  174 +++++
 arch/arm/mach-davinci/da830.c                    |    5 -
 arch/arm/mach-davinci/da850.c                    |   25 -
 arch/arm/mach-davinci/devices-da8xx.c            |   50 +-
 arch/arm/mach-davinci/devices-tnetv107x.c        |  320 +++++++++
 arch/arm/mach-davinci/dm355.c                    |   22 +-
 arch/arm/mach-davinci/dm365.c                    |   28 +-
 arch/arm/mach-davinci/dm644x.c                   |   22 +-
 arch/arm/mach-davinci/dm646x.c                   |   30 +-
 arch/arm/mach-davinci/dma.c                      |   62 ++-
 arch/arm/mach-davinci/gpio-tnetv107x.c           |  205 ++++++
 arch/arm/mach-davinci/include/mach/da8xx.h       |    3 +-
 arch/arm/mach-davinci/include/mach/debug-macro.S |   50 ++-
 arch/arm/mach-davinci/include/mach/dm646x.h      |    1 +
 arch/arm/mach-davinci/include/mach/edma.h        |   11 +
 arch/arm/mach-davinci/include/mach/gpio.h        |   22 +-
 arch/arm/mach-davinci/include/mach/serial.h      |   21 +
 arch/arm/mach-davinci/include/mach/tnetv107x.h   |   55 ++
 arch/arm/mach-davinci/include/mach/uncompress.h  |   87 ++-
 arch/arm/mach-davinci/tnetv107x.c                |  753 ++++++++++++++++++++++
 25 files changed, 1933 insertions(+), 147 deletions(-)
 create mode 100644 arch/arm/mach-davinci/board-tnetv107x-evm.c
 create mode 100644 arch/arm/mach-davinci/devices-tnetv107x.c
 create mode 100644 arch/arm/mach-davinci/gpio-tnetv107x.c
 create mode 100644 arch/arm/mach-davinci/include/mach/tnetv107x.h
 create mode 100644 arch/arm/mach-davinci/tnetv107x.c
