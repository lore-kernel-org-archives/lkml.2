Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754008Ab0H2Swm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Aug 2010 14:52:42 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:35470 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753785Ab0H2Swk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Aug 2010 14:52:40 -0400
From: Will Deacon <will.deacon@arm.com>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, Will Deacon <will.deacon@arm.com>,
        Robert Richter <robert.richter@amd.com>,
        Matt Fleming <matt@console-pimps.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 0/3] stop OProfile calling arch_exit when arch_init fails
Date: Sun, 29 Aug 2010 19:51:58 +0100
Message-Id: <1283107921-21464-1-git-send-email-will.deacon@arm.com>
X-Mailer: git-send-email 1.6.3.3
X-OriginalArrivalTime: 29 Aug 2010 18:52:17.0282 (UTC) FILETIME=[4D588E20:01CB47AB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches remove the oprofile_arch_exit call from oprofile_init,
allowing architectures that perform memory allocation in their init
functions to be simplified. This requires some changes to the ARM and
x86 OProfile backends to ensure that their init functions clean up
after themselves if they fail.

This is required for Matt's combined OProfile/Perf driver which will
be shared between all architectures.

Patches taken against tip/master.

Cc: Robert Richter <robert.richter@amd.com>
Cc: Matt Fleming <matt@console-pimps.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>

Will Deacon (3):
  oprofile: don't call arch exit code from init code on failure
  ARM: oprofile: fix and simplify init/exit functions
  x86: oprofile: fix oprofile_arch_init behaviour on failure

 arch/arm/oprofile/common.c |   47 +++++++++++++++++++++++--------------------
 arch/x86/oprofile/init.c   |   26 ++++++++++++++----------
 drivers/oprofile/oprof.c   |   11 +--------
 3 files changed, 42 insertions(+), 42 deletions(-)

