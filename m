Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754355Ab0DWAdE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 20:33:04 -0400
Received: from ozlabs.org ([203.10.76.45]:57275 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753186Ab0DWAdB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 20:33:01 -0400
Date: Fri, 23 Apr 2010 10:32:51 +1000
From: Paul Mackerras <paulus@samba.org>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Ian Munsie <imunsie@au1.ibm.com>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org
Subject: [GIT PULL] Perf probe support for PowerPC, from Ian Munsie
Message-ID: <20100423003251.GA2420@brick.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

Please pull my perf.git master branch:

  git://git.kernel.org/pub/scm/linux/kernel/git/paulus/perf.git master

It has two commits from Ian Munsie that allow us to access local
variables with perf probe on PowerPC.  We also need a commit in Ben's
powerpc-next branch for it to function, but it compiles without that.

Thanks,
Paul.

---

The following changes since commit 6eca8cc35b50af1037bc919106dd6dd332c959c2:
  Frederic Weisbecker (1):
        perf: Fix perf probe build error

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/paulus/perf.git master

Ian Munsie (2):
      perf: Move arch specific code into separate arch directory
      perf probe: Add PowerPC DWARF register number mappings

 tools/perf/Makefile                       |   36 ++++++++++--
 tools/perf/arch/powerpc/Makefile          |    4 +
 tools/perf/arch/powerpc/util/dwarf-regs.c |   88 +++++++++++++++++++++++++++++
 tools/perf/arch/x86/Makefile              |    4 +
 tools/perf/arch/x86/util/dwarf-regs.c     |   75 ++++++++++++++++++++++++
 tools/perf/util/include/dwarf-regs.h      |    8 +++
 tools/perf/util/probe-finder.c            |   55 +-----------------
 7 files changed, 211 insertions(+), 59 deletions(-)
 create mode 100644 tools/perf/arch/powerpc/Makefile
 create mode 100644 tools/perf/arch/powerpc/util/dwarf-regs.c
 create mode 100644 tools/perf/arch/x86/Makefile
 create mode 100644 tools/perf/arch/x86/util/dwarf-regs.c
 create mode 100644 tools/perf/util/include/dwarf-regs.h
