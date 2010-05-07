Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757300Ab0EGRrI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 13:47:08 -0400
Received: from mga10.intel.com ([192.55.52.92]:41294 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757058Ab0EGRrG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 13:47:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.52,349,1270450800"; 
   d="scan'208";a="796418359"
From: Jacob Pan <jacob.jun.pan@linux.intel.com>
To: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, Alek Du <alek.du@intel.com>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Feng Tang <feng.tang@intel.com>, LKML <linux-kernel@vger.kernel.org>
Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
Subject: [PATCH 0/8] Moorestown changes in arch/x86 for 35 merge window
Date: Fri,  7 May 2010 10:41:40 -0700
Message-Id: <1273254108-3234-1-git-send-email-jacob.jun.pan@linux.intel.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi hpa, ingo, and tglx,

The following changes are based on commit:
d94e93d495514c69d4a7a553c0938cd777267e5d

Changes include addition of vitual RTC driver and many clockevent tweaks in
order to support Medfield (next generation) in the same binary kernel image.

We consolidated tsc and lapic calibration into platform specific routine
under x86_init for MRST. There will be a follow-up RFC patch does the similar
consolidation for standard PC with HPET.

*** BLURB HERE ***

Feng Tang (2):
  x86/platform: add a wallclock_init func to x86_platforms ops
  x86/mrst: add vrtc driver which serves as a wall clock device

Jacob Pan (6):
  x86: avoid check hlt if no timer interrupts
  x86/mrst/pci: return 0 for non-present pci bars
  x86/apic: allow use of lapic timer early calibration result
  x86/mrst: change clock selection logic to support medfield
  x86/apbt: support more timer configurations on mrst
  x86/mrst: Add nop functions to x86_init mpparse functions

 arch/x86/include/asm/apb_timer.h |    2 +-
 arch/x86/include/asm/bugs.h      |    1 +
 arch/x86/include/asm/fixmap.h    |    4 +
 arch/x86/include/asm/mrst.h      |   30 ++++++++
 arch/x86/include/asm/vrtc.h      |   27 +++++++
 arch/x86/include/asm/x86_init.h  |    2 +
 arch/x86/kernel/Makefile         |    2 +-
 arch/x86/kernel/apb_timer.c      |   18 +++--
 arch/x86/kernel/apic/apic.c      |   21 +++++-
 arch/x86/kernel/cpu/bugs.c       |    4 +
 arch/x86/kernel/mrst.c           |  143 ++++++++++++++++++++++++++++++++++---
 arch/x86/kernel/setup.c          |    2 +
 arch/x86/kernel/vrtc.c           |  100 ++++++++++++++++++++++++++
 arch/x86/kernel/x86_init.c       |    2 +
 arch/x86/pci/mrst.c              |    2 +-
 15 files changed, 336 insertions(+), 24 deletions(-)
 create mode 100644 arch/x86/include/asm/vrtc.h
 create mode 100644 arch/x86/kernel/vrtc.c

