Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759727Ab0ENVr7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 17:47:59 -0400
Received: from mga06.intel.com ([134.134.136.21]:49795 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758079Ab0ENVr6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 17:47:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,233,1272870000"; 
   d="scan'208";a="621797610"
From: Jacob Pan <jacob.jun.pan@linux.intel.com>
To: LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Alan Cox <alan@linux.intel.com>,
       Arjan van de Ven <arjan@linux.intel.com>
Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
Subject: [PATCH 0/8] v2 Moorestown core patches for 35 merge window
Date: Fri, 14 May 2010 14:41:13 -0700
Message-Id: <1273873281-17489-1-git-send-email-jacob.jun.pan@linux.intel.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi hpa, ingo, and tglx,

We have received many comments in v1, specifically regarding the consolidation
of timer calibration and frequency detection. These two items are being worked
on and require more time for restructuring. Therefore, i have separated them
out of the patch series. This series below only inlcude the parts that have
comments been addressed.

thanks,

Jacob

*** BLURB HERE ***

Feng Tang (2):
  x86/platform: add a wallclock_init func to x86_platforms ops
  x86/mrst: add vrtc driver which serves as a wall clock device

Jacob Pan (6):
  x86/mrst/pci: return 0 for non-present pci bars
  x86/mrst: add cpu type detection for Medfield
  x86/mrst: add more timer options to include Medfield
  x86/apbt: support more timer configurations on mrst
  x86/mrst: add nop functions to x86_init mpparse functions
  input: do not select i8042 for x86 mid

 arch/x86/include/asm/apb_timer.h |    2 +-
 arch/x86/include/asm/fixmap.h    |    4 ++
 arch/x86/include/asm/mrst.h      |   20 ++++++++
 arch/x86/include/asm/vrtc.h      |   27 ++++++++++
 arch/x86/include/asm/x86_init.h  |    2 +
 arch/x86/kernel/Makefile         |    2 +-
 arch/x86/kernel/apb_timer.c      |   18 ++++---
 arch/x86/kernel/mrst.c           |   97 +++++++++++++++++++++++++++++++++---
 arch/x86/kernel/setup.c          |    2 +
 arch/x86/kernel/vrtc.c           |  100 ++++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/x86_init.c       |    2 +
 arch/x86/pci/mrst.c              |    2 +-
 drivers/input/keyboard/Kconfig   |    2 +-
 drivers/input/mouse/Kconfig      |    2 +-
 14 files changed, 260 insertions(+), 22 deletions(-)
 create mode 100644 arch/x86/include/asm/vrtc.h
 create mode 100644 arch/x86/kernel/vrtc.c

