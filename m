Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759061Ab2CHWsN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 17:48:13 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:52031 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759022Ab2CHWsI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 17:48:08 -0500
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, acme@redhat.com, asharma@fb.com,
        ravitillo@lbl.gov, vweaver1@eecs.utk.edu, khandual@linux.vnet.ibm.com,
        dsahern@gmail.com
Subject: [PATCH 0/4] perf tools: improve branch stack sampling
Date: Thu,  8 Mar 2012 23:47:44 +0100
Message-Id: <1331246868-19905-1-git-send-email-eranian@google.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set improves upon my LBR v6 patch series posted on
LKML several weeks ago. It needs to be applied on top of it.

This series improves perf report and perf record when used
with taken branch stack sampling.

For perf record, and based on users' feedback, it is possible
to omit the branch type with the -b option. In that case,
the filter is set to the default value of any branch type.
The branch-filter option is now used to specify more precise
branch types and privilege levels:

   $ perf record -b foo
   equivalent to:
   $ perf record --branch-filter any foo

   To filter on specific branch types:
   $ perf record --branch-filter any_call foo

For perf report, it is now possible to omit the -b option
and yet get branch view mode. Perf report is able to auto-detect
if the perf.data file contains samples with branch stack and
to switch to the branch mode. It is possible to override this
by passing --no-branch-stack.

Furthermore, perf report now supports TUI in branch mode.
It is possible to naviguate to both the source and destination
functions of branches.

Signed-off-by: Stephane Eranian <eranian@google.com>

Stephane Eranian (4):
  perf record: provide default branch stack sampling mode option
  perf record: add HEADER_BRANCH_STACK tag
  perf report: auto-detect branch stack sampling mode
  perf report: enable TUI in branch view mode

 tools/perf/Documentation/perf-record.txt |   23 ++++--
 tools/perf/Documentation/perf-report.txt |    7 +-
 tools/perf/builtin-record.c              |   71 +++++++++++------
 tools/perf/builtin-report.c              |  121 ++++++++++++++++++++---------
 tools/perf/util/header.c                 |   13 +++
 tools/perf/util/header.h                 |    2 +-
 tools/perf/util/session.c                |    1 +
 tools/perf/util/sort.c                   |    2 +-
 tools/perf/util/sort.h                   |    8 +-
 tools/perf/util/symbol.h                 |    7 ++-
 tools/perf/util/ui/browsers/hists.c      |   62 ++++++++++++---
 11 files changed, 225 insertions(+), 92 deletions(-)

-- 
1.7.4.1

