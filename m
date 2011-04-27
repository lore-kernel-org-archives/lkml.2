Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759582Ab1D0RAO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 13:00:14 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:57034 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756009Ab1D0RAM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 13:00:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=dZ+/o7GPkbvoN2NX2VuwIW6eiMzm/DrrJwKeMf5U7AbGTZdKwFoLW4wAGgh9NQFOjP
         JWa1JuVhMZsdRGTI/9kSDj8tAn741jLYrwP8N30ixfjRPt8us+uon7n3O6EvR7sBMaIv
         tCtQyS5docXUfTtr1fvPuKZN+eU+xcUtPAGsc=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Will Deacon <will.deacon@arm.com>, Prasad <prasad@linux.vnet.ibm.com>,
        Paul Mundt <lethal@linux-sh.org>,
        Jason Wessel <jason.wessel@windriver.com>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 0/6] hw_breakpoint: Let the user choose not to build it (and perf too)
Date: Wed, 27 Apr 2011 18:59:56 +0200
Message-Id: <1303923602-2923-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Until now, x86 and superh32 had to always build hw_breakpoint and perf.
And powerpc and arm were always building hw_breakpoints when perf
was enabled.

After this patchset, one can simply disable hw_breakpoints if he
selected CONFIG_EXPERT. Afterward the user is free to select perf
or not. Except on SH unfortunately because that would require a
bit of change in ptrace to support singlestep failures.

Frederic Weisbecker (6):
  hw_breakpoints: Split hardware breakpoints config
  hw_breakpoints: Migrate breakpoint conditional build under new config
  x86: Allow the user not to build hw_breakpoints
  hw_breakpoints: Breakpoints arch ability don't need perf events
  hw_breakpoints: Only force perf events if breakpoints are selected
  hw_breakpoints: Drop remaining misplaced dependency on perf

 arch/Kconfig                             |    1 -
 arch/arm/Kconfig                         |    2 +-
 arch/arm/include/asm/hw_breakpoint.h     |    4 +-
 arch/arm/include/asm/processor.h         |    2 +-
 arch/arm/kernel/Makefile                 |    2 +-
 arch/arm/kernel/entry-header.S           |    2 +-
 arch/arm/kernel/ptrace.c                 |    4 +-
 arch/powerpc/Kconfig                     |    2 +-
 arch/powerpc/include/asm/cputable.h      |    4 +-
 arch/powerpc/include/asm/hw_breakpoint.h |    6 ++--
 arch/powerpc/include/asm/processor.h     |    4 +-
 arch/powerpc/kernel/Makefile             |    2 +-
 arch/powerpc/kernel/process.c            |   18 ++++++++--------
 arch/powerpc/kernel/ptrace.c             |   12 +++++-----
 arch/powerpc/lib/Makefile                |    2 +-
 arch/sh/Kconfig                          |    2 +-
 arch/sh/kernel/Makefile                  |    2 +-
 arch/sh/kernel/cpu/sh4a/Makefile         |    2 +-
 arch/x86/Kconfig                         |    3 +-
 arch/x86/include/asm/debugreg.h          |   33 ++++++++++++++++++++++++++++-
 arch/x86/kernel/Makefile                 |    3 +-
 arch/x86/kernel/process.c                |    1 +
 arch/x86/kernel/ptrace.c                 |   17 +++++++++++++++
 include/linux/hw_breakpoint.h            |    6 ++--
 include/linux/perf_event.h               |    4 +-
 init/Kconfig                             |   11 ++++++++++
 kernel/Makefile                          |    2 +-
 kernel/perf_event.c                      |    4 +-
 samples/Kconfig                          |    2 +-
 29 files changed, 108 insertions(+), 51 deletions(-)

-- 
1.7.3.2

