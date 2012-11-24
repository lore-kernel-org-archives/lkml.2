Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932483Ab2KXAV0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 19:21:26 -0500
Received: from merlin.infradead.org ([205.233.59.134]:44315 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932403Ab2KXAVW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 19:21:22 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Anton Blanchard <anton@au1.ibm.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Borislav Petkov <bp@alien8.de>, David Ahern <dsahern@gmail.com>,
        David Howells <dhowells@redhat.com>,
        Dong Hao <haodong@linux.vnet.ibm.com>, Josh Boyer <jwboyer@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-arch@vger.kernel.org, linuxppc-dev@ozlabs.org,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Robert Richter <robert.richter@amd.com>,
        Runzhen Wang <runzhen@linux.vnet.ibm.com>,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        acme@ghostprotocols.net
Subject: [GIT PULL 0/8] perf/urgent fixes
Date: Fri, 23 Nov 2012 21:20:45 -0300
Message-Id: <1353716453-9693-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

	Tested using a cross-compiler and directly on a Raspberry pi (ARM) with
raspbian.

	Please consider pulling.

- Arnaldo

The following changes since commit 18423d3562f396206e0928a71177eeb2edfed077:

  Merge tag 'perf-urgent-for-mingo' of git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux into perf/urgent (2012-11-13 18:51:51 +0100)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux tags/perf-urgent-for-mingo

for you to fetch changes up to 7321090f6751c9987c26a8c81c63680d16a614d7:

  perf kvm: Fix building perf kvm on non x86 arches (2012-11-23 20:40:17 -0300)

----------------------------------------------------------------
perf/urgent fixes

. Don't build 'perf kvm stat" on non-x86 arches, fix from Xiao Guangrong.

. UAPI fixes to get perf building again in non-x86 arches, from David Howells.

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>

----------------------------------------------------------------
Arnaldo Carvalho de Melo (1):
      Merge tag 'perf-uapi-20121119' of git://git.infradead.org/users/dhowells/linux-headers into perf/urgent

David Howells (6):
      x86: Export asm/{svm.h,vmx.h,perf_regs.h}
      Merge branch 'x86-pre-uapi' into perf-uapi
      tools: Define a Makefile function to do subdir processing
      tools: Honour the O= flag when tool build called from a higher Makefile
      tools: Pass the target in descend
      perf: Make perf build for x86 with UAPI disintegration applied

Sukadev Bhattiprolu (1):
      perf powerpc: Use uapi/unistd.h to fix build error

Xiao Guangrong (2):
      perf kvm: Rename perf_kvm to perf_kvm_stat
      perf kvm: Fix building perf kvm on non x86 arches

 Makefile                                |    6 +-
 arch/x86/include/asm/Kbuild             |    3 +
 include/linux/hw_breakpoint.h           |   31 +-------
 include/uapi/linux/Kbuild               |    1 +
 include/uapi/linux/hw_breakpoint.h      |   30 ++++++++
 tools/Makefile                          |   24 +++---
 tools/perf/Makefile                     |   29 +++++++-
 tools/perf/arch/x86/include/perf_regs.h |    2 +-
 tools/perf/builtin-kvm.c                |  121 +++++++++++++++++--------------
 tools/perf/builtin-test.c               |    2 +-
 tools/perf/perf.h                       |   16 +---
 tools/perf/util/evsel.c                 |    4 +-
 tools/perf/util/evsel.h                 |    3 +-
 tools/perf/util/header.h                |    2 +-
 tools/perf/util/parse-events-test.c     |    2 +-
 tools/perf/util/parse-events.c          |    2 +-
 tools/perf/util/parse-events.h          |    2 +-
 tools/perf/util/pmu.h                   |    2 +-
 tools/perf/util/session.h               |    2 +-
 tools/scripts/Makefile.include          |   23 +++++-
 20 files changed, 181 insertions(+), 126 deletions(-)
 create mode 100644 include/uapi/linux/hw_breakpoint.h
