Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756139Ab0GEOo1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jul 2010 10:44:27 -0400
Received: from mga03.intel.com ([143.182.124.21]:60744 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752951Ab0GEOo0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jul 2010 10:44:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,540,1272870000"; 
   d="scan'208";a="296676669"
From: feng.tang@intel.com
To: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu,
       hpa@zytor.com, jacob.jun.pan@intel.com, dtor@mail.ru,
       randy.dunlap@oracle.com
Cc: Feng Tang <feng.tang@intel.com>
Subject: [PATCH v2 0/5] patches to settle i8042 with Intel MID platforms
Date: Mon,  5 Jul 2010 23:03:17 +0800
Message-Id: <1278342202-10973-1-git-send-email-feng.tang@intel.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Feng Tang <feng.tang@intel.com>

Hi All,

Some x86 platforms like intel MID platforms don't have i8042 controllers,
and i8042 driver's probe to some non-exist legacy IO ports may hang
the MID processor. 

Current solution for this is add dependency of SERIO_I8042 over
!X86_MRST, then if we build a x86 kernel image with X86_MRST=y,
it won't have i8042 driver support over common x86 platforms.

So we add a i8042 pre-detect hook into x86_platforms ops, so that
i8042 driver can use it to run-time judge whether to go on with
probe process.

Please review these patches.

Thanks,
Feng

Changelog:
	v2:
	   * only call x86_platforms.i8042_detect() for x86 platforms

----------------
Feng Tang (5):
  x86: add i8042 pre-detection hook to x86_platform_ops
  x86, mrst: add i8042_detect API for Moorestwon platform
  Revert "Input: do not force selecting i8042 on Moorestown"
  Revert "Input: fixup X86_MRST selects"
  input: i8042 - add runtime check in x86's i8042_platform_init

 arch/x86/include/asm/x86_init.h       |    2 ++
 arch/x86/kernel/mrst.c                |    7 +++++++
 arch/x86/kernel/x86_init.c            |    4 +++-
 drivers/input/keyboard/Kconfig        |    4 ++--
 drivers/input/mouse/Kconfig           |    2 +-
 drivers/input/serio/Kconfig           |    2 +-
 drivers/input/serio/i8042-x86ia64io.h |    6 ++++++
 7 files changed, 22 insertions(+), 5 deletions(-)

