Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757313Ab1ERQJJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 12:09:09 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:43579 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757122Ab1ERQJH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 12:09:07 -0400
X-Authority-Analysis: v=1.1 cv=u/eXSd3k4P+OuNmbl5aZU3ellt6eTxbOnGssQLT4hSY= c=1 sm=0 a=vhdKIqpQuCYA:10 a=s4ZeTWRLaekA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=VwQbUJbxAAAA:8 a=nhOjdw9E7rv-7joWPM0A:9 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110518160809.724215604@goodmis.org>
User-Agent: quilt/0.48-1
Date: Wed, 18 May 2011 12:08:09 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 00/15] [GIT PULL] ftrace/recordmcount: cleanups and updates for recordmcount processing
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

Please pull the latest tip/perf/core-2 tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/perf/core-2


Martin Schwidefsky (3):
      ftrace/recordmcount: mcount address adjustment
      ftrace/x86: mcount offset calculation
      ftrace/s390: mcount offset calculation

Michal Marek (1):
      ftrace/kbuild: Add recordmcount files to force full build

Steven Rostedt (11):
      ftrace/trivial: Clean up recordmcount.c to use Linux style comparisons
      ftrace/trivial: Clean up record mcount to use Linux switch style
      ftrace: Add .kprobe.text section to whitelist for recordmcount.c
      ftrace/recordmcount: Modify only executable sections
      ftrace/recordmcount: Make ignored mcount calls into nops at compile time
      ftrace/recordmcount: Add warning logic to warn on mcount not recorded
      kbuild/recordmcount: Add RECORDMCOUNT_WARN to warn about mcount callers
      ftrace: Avoid recording mcount on .init sections directly
      ftrace/x86: Do not trace .discard.text section
      ftrace/recordmcount: Remove duplicate code to find mcount symbol
      ftrace/recordmcount: Add helper function get_sym_str_and_relp()

----
 Makefile                       |    1 +
 arch/s390/include/asm/ftrace.h |    4 +-
 arch/x86/include/asm/ftrace.h  |    7 +-
 arch/x86/include/asm/setup.h   |    2 +-
 include/linux/init.h           |   14 ++--
 scripts/Makefile.build         |   12 ++-
 scripts/recordmcount.c         |  168 ++++++++++++++++++++++++++------------
 scripts/recordmcount.h         |  174 +++++++++++++++++++++++++++++++--------
 scripts/recordmcount.pl        |    5 +
 9 files changed, 279 insertions(+), 108 deletions(-)
