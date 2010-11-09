Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755021Ab0KIVSa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 16:18:30 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:45811 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752122Ab0KIVS3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 16:18:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=ow3H99trVF46hWBjhEv77E96Mz7Z+Aqer1qSuZK6ePztgHko9qKaby9pHQCm/bld9l
         atPvInbbiEA5GhJsmk2uqM02moow1jBVlMfNV4vVv2Is01Ni8FMWU2+ka9yjtJ88g6Iq
         XudeMeHgmsubsP9lRjySJUGkItQNRRqa7TfCE=
From: tzanussi@gmail.com
To: linux-kernel@vger.kernel.org
Cc: acme@ghostprotocols.net, mingo@elte.hu, fweisbec@gmail.com
Subject: [PATCH 0/7] perf trace command-line cleanup
Date: Tue,  9 Nov 2010 15:18:15 -0600
Message-Id: <1289337502-2492-1-git-send-email-tzanussi@gmail.com>
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

git://github.com/zanussi/linux-2.6.git perf-trace-updates


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
