Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030475Ab2HIWXY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 18:23:24 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:44368 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030198Ab2HIWXR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 18:23:17 -0400
From: Cody P Schafer <cody@linux.vnet.ibm.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
        Matt Hellsley <matthltc@us.ibm.com>,
        David Hansen <dave@linux.vnet.ibm.com>
Subject: [PATCH 0/16] perf: various symbol resolution fixes, including .opd section use.
Date: Thu,  9 Aug 2012 15:18:25 -0700
Message-Id: <1344550721-21024-1-git-send-email-cody@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.11.3
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12080922-6148-0000-0000-0000087B87F5
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

 tools/perf/util/event.c  |   2 +-
 tools/perf/util/map.c    |   8 -
 tools/perf/util/map.h    |   1 -
 tools/perf/util/symbol.c | 416 +++++++++++++++++++++++++++++------------------
 tools/perf/util/symbol.h |   4 +-
 5 files changed, 260 insertions(+), 171 deletions(-)

