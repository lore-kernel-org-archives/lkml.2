Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760167Ab2HJWX3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2012 18:23:29 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:59228 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755186Ab2HJWX2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2012 18:23:28 -0400
From: Cody P Schafer <cody@linux.vnet.ibm.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
        Matt Hellsley <matthltc@us.ibm.com>,
        David Hansen <dave@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: [PATCH v2 00/16] perf: various symbol resolution fixes, including .opd section use.
Date: Fri, 10 Aug 2012 15:22:46 -0700
Message-Id: <1344637382-22789-1-git-send-email-cody@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.11.3
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12081022-7606-0000-0000-000002B61B30
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1-4,6,7 are small cleanups.

5 fixes a potential segfault.

8 fixes a use after free for dso->long_name

9 avoids a segfault in elfutils when a truncated elf is loaded.

10 properly tracks that a dso had symbols loaded from a vmlinux image

11-16 fix handling of the '.opd' section in the presence of debuginfo. They
      should also fix plt symbol synthesis (haven't seen the plt issues in
      practice).

--

Changes from v1:
 - rebased on top of
   git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux.git  perf/core
 - In #2, make the symbols have size 0 instead of 1.

--

 tools/perf/util/event.c          |   2 +-
 tools/perf/util/map.c            |   8 --
 tools/perf/util/map.h            |   1 -
 tools/perf/util/symbol-elf.c     | 182 ++++++++++++++++++++++++++-------------
 tools/perf/util/symbol-minimal.c |  48 +++++++++--
 tools/perf/util/symbol.c         | 136 +++++++++++++++++------------
 tools/perf/util/symbol.h         |  49 +++++++++--
 7 files changed, 290 insertions(+), 136 deletions(-)

