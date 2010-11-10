Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755878Ab0KJSKd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 13:10:33 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:33622 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755701Ab0KJSK3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 13:10:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=jLXNmQcuKLdNb2K+xsdR1WAQXsqbDAko+IfL8axfG53E6WrKy8bneXo1wTeU1mjIMi
         2BZ6zXJ24f4wuSsmc6oEyC9GazsojpV8lbSe/jkrVj7gtQFSA/JV4PFvOZ8WLB+eNKH5
         xBss/yaA7B63ce2tEBzXzyXt7UXbJuUj8MD4k=
From: tzanussi@gmail.com
To: linux-kernel@vger.kernel.org
Cc: acme@ghostprotocols.net, mingo@elte.hu, fweisbec@gmail.com
Subject: [PATCH 0/7] perf trace command-line cleanup, v2
Date: Wed, 10 Nov 2010 12:10:17 -0600
Message-Id: <1289412624-4772-1-git-send-email-tzanussi@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tom Zanussi <tom.zanussi@linux.intel.com>

There are currently some inconsistencies in perf trace command-line
handling - for example, the system-wide param is hard-coded into the
canned scripts, and the user doesn't have any option to avoid it.
This patchset removes that limitation and cleans up some related
complications introduced by live-mode.  It also more clearly documents
usage, and fixes up a couple other minor problems.

This patchset can also be pulled from here:

git://github.com/zanussi/linux-2.6.git perf-trace-updates-urgent

v2 changes:

- rebased to perf/urgent
- added Arnaldo's Acked-by to patches

Tom Zanussi (7):
  perf trace scripting: fix some small memory leaks and missing error
    checks
  perf trace scripting: remove system-wide param from shell scripts
  perf record: make the record options available outside perf record
  perf trace record: handle commands correctly
  perf trace: live-mode command-line cleanup
  perf trace: update Documentation with new perf trace variants
  perf trace: update usage

 tools/perf/Documentation/perf-trace.txt            |   57 +++++-
 tools/perf/builtin-record.c                        |   10 +-
 tools/perf/builtin-trace.c                         |  209 ++++++++++++++------
 tools/perf/scripts/perl/bin/failed-syscalls-record |    2 +-
 tools/perf/scripts/perl/bin/rw-by-file-record      |    2 +-
 tools/perf/scripts/perl/bin/rw-by-pid-record       |    2 +-
 tools/perf/scripts/perl/bin/rwtop-record           |    2 +-
 tools/perf/scripts/perl/bin/wakeup-latency-record  |    2 +-
 tools/perf/scripts/perl/bin/workqueue-stats-record |    2 +-
 .../python/bin/failed-syscalls-by-pid-record       |    2 +-
 .../scripts/python/bin/futex-contention-record     |    2 +-
 tools/perf/scripts/python/bin/netdev-times-record  |    2 +-
 .../perf/scripts/python/bin/sched-migration-record |    2 +-
 tools/perf/scripts/python/bin/sctop-record         |    2 +-
 .../python/bin/syscall-counts-by-pid-record        |    2 +-
 .../perf/scripts/python/bin/syscall-counts-record  |    2 +-
 16 files changed, 217 insertions(+), 85 deletions(-)

-- 
Tom Zanussi, Intel Open Source Technology Center
