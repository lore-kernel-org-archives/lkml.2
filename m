Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757058Ab0EUILQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 04:11:16 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:43176 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754105Ab0EUILN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 04:11:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version;
        b=EK4V7GiEew840F25yted11G5Tbg5WXltdCV7jC1w2kIvcB7F8jGDGAbdQttvPjkmc8
         OSBs2nVO2rWZ5Z5zHawgDQpD2DOuqQ+lpF6GvOd77UP3qSqZSWBGXTdG8b8WIrPzQIDU
         wd6jnVCsX4g3NYAPglAO51TIfGyCQIT3dXUQI=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       David Miller <davem@davemloft.net>
Subject: [PATCH 0/2] perf: perf_arch_fetch_regs_caller API change
Date: Fri, 21 May 2010 10:11:15 +0200
Message-Id: <1274429477-21531-1-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-regression
X-Mailer-version: 0.1, "The maintainer couldn't reproduce after one week full time debugging" special version.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I did some updates in this function, we don't need anymore
to skip further the first caller now. So I think it's worth
the simplification to lower the overhead in the tracing fast
path.

I took Paul updates for PowerPc and I did the changes on x86.
But I'm clearly useless about the sparc part, I'm still confused
about these window things. So all I did in this arch is to
wrap the older API with the new one, always passing the skip to 1.
I suspect David can be more useful than me to do a real change there :)

Tell me what you think,

Thanks.

Frederic Weisbecker (2):
  x86: Unify dumpstack.h and stacktrace.h
  perf: Drop the skip argument from perf_arch_fetch_regs_caller

 arch/powerpc/include/asm/perf_event.h |   12 +++++++
 arch/powerpc/kernel/misc.S            |   26 ---------------
 arch/sparc/include/asm/perf_event.h   |    4 ++
 arch/sparc/kernel/helpers.S           |    6 ++--
 arch/x86/include/asm/perf_event.h     |    9 +++++
 arch/x86/include/asm/stacktrace.h     |   49 ++++++++++++++++++++++++++++
 arch/x86/kernel/cpu/perf_event.c      |   14 --------
 arch/x86/kernel/dumpstack.c           |    1 -
 arch/x86/kernel/dumpstack.h           |   56 ---------------------------------
 arch/x86/kernel/dumpstack_32.c        |    2 -
 arch/x86/kernel/dumpstack_64.c        |    1 -
 arch/x86/kernel/stacktrace.c          |    7 ++--
 include/linux/perf_event.h            |   32 ++++--------------
 include/trace/ftrace.h                |    2 +-
 kernel/perf_event.c                   |    5 ---
 kernel/trace/trace_event_perf.c       |    2 -
 16 files changed, 89 insertions(+), 139 deletions(-)
 delete mode 100644 arch/x86/kernel/dumpstack.h

