Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754460Ab1BUT3N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 14:29:13 -0500
Received: from juliette.telenet-ops.be ([195.130.137.74]:55368 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754260Ab1BUT3K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 14:29:10 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-m68k@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, aranym@lists.bobek.cz
Subject: [PATCH v2 0/4] m68k/atari: Add ARAnyM support
Date: Mon, 21 Feb 2011 20:28:52 +0100
Message-Id: <1298316536-23053-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series adds improved support for running under the ARAnyM emulator
(Atari Running on Any Machine - http://aranym.org/).
Without these patches, you can run a Linux/m68k kernel with Atari support
under ARAnyM (it emulates the IDE interface), but you can't have network and
console access.

This support has been in active use for several years. In fact some Debian
build daemons run under ARAnyM, as it's the fastest m68k platform around.

 [1/4] m68k/atari: Initial ARAnyM support
 [2/4] m68k/atari: ARAnyM - Add support for block access
 [3/4] m68k/atari: ARAnyM - Add support for console access
 [4/4] m68k/atari: ARAnyM - Add support for network access

v2 of this series
  - updates attributions, based on feedback for the previous round,
  - incorporates review comments for nfeth.

 arch/m68k/Kconfig               |   31 +++++
 arch/m68k/Makefile              |    1 +
 arch/m68k/emu/Makefile          |    9 ++
 arch/m68k/emu/natfeat.c         |   78 +++++++++++
 arch/m68k/emu/nfblock.c         |  195 ++++++++++++++++++++++++++++
 arch/m68k/emu/nfcon.c           |  162 +++++++++++++++++++++++
 arch/m68k/emu/nfeth.c           |  270 +++++++++++++++++++++++++++++++++++++++
 arch/m68k/include/asm/natfeat.h |   22 +++
 arch/m68k/kernel/setup.c        |    5 +
 9 files changed, 773 insertions(+), 0 deletions(-)

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds

