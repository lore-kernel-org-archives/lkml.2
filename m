Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932614Ab0GOIFR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 04:05:17 -0400
Received: from mga01.intel.com ([192.55.52.88]:25465 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932648Ab0GOID7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 04:03:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,206,1278313200"; 
   d="scan'208";a="586311667"
From: feng.tang@intel.com
To: linux-kernel@vger.kernel.org
Cc: Feng Tang <feng.tang@intel.com>
Subject: [PATCH v2 0/3] adding vrtc driver for x86/mrst platform
Date: Thu, 15 Jul 2010 16:23:28 +0800
Message-Id: <1279182211-25264-1-git-send-email-feng.tang@intel.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Feng Tang <feng.tang@intel.com>

Hi all,

Moorestown platform doesn't have a m146818 RTC device like traditional
x86 PC, but a firmware emulated virtual RTC device(vrtc), which provides
some basic RTC functions like get/set time. vrtc serves as the only
wall clock device on Moorestown platform.

Currently, vrtc init func need be called before xtime's init, thus move
xtime's init into a subsys_initcall: timekeeping_late_init() as suggested
by Thomas

Please review these patches.

Thanks,
Feng

Changelog:
	v2:
	    * add IPC cmd for setting time

---------------
Feng Tang (3):
  timekeeping: moving xtime's init to a later time
  x86: unify current 3 similar ways of saving IRQ info
  x86/mrst: add vrtc driver which serves as a wall clock device

 arch/x86/include/asm/mpspec.h |    6 ++
 arch/x86/include/asm/mrst.h   |    2 -
 arch/x86/include/asm/vrtc.h   |   24 ++++++
 arch/x86/kernel/Makefile      |    2 +-
 arch/x86/kernel/acpi/boot.c   |   32 +-------
 arch/x86/kernel/mpparse.c     |   14 ++--
 arch/x86/kernel/mrst.c        |   72 +------------------
 arch/x86/kernel/vrtc.c        |  164 +++++++++++++++++++++++++++++++++++++++++
 kernel/time/timekeeping.c     |   28 +++++--
 9 files changed, 227 insertions(+), 117 deletions(-)
 create mode 100644 arch/x86/include/asm/vrtc.h
 create mode 100644 arch/x86/kernel/vrtc.c

