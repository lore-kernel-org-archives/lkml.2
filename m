Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751807Ab2LDEoq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 23:44:46 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:61976 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751260Ab2LDEop (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 23:44:45 -0500
X-AuditID: 9c930197-b7bd3ae000003f1c-fc-50bd7fbbb0b9
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Stephane Eranian <eranian@google.com>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: [PATCH 0/3] perf hists: Changes on hists__{link,match}
Date: Tue,  4 Dec 2012 13:44:22 +0900
Message-Id: <1354596265-9901-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnaldo,

This is what I talked to Jiri yesterday, and it can be a common basis
of both event group and multiple diff patchset.  The point is using
internal input or collapsed rb tree to sort hist entries rather than
output tree with unnessary resort.

Please take a look.

Thanks,
Namhyung


Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Stephane Eranian <eranian@google.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>

Namhyung Kim (3):
  perf hists: Exchange order of comparing items when collapsing hists
  perf hists: Link hist entries before inserting to an output tree
  perf diff: Use internal rb tree for compute resort

 tools/perf/builtin-diff.c | 95 +++++++++++++++++++++--------------------------
 tools/perf/util/hist.c    | 51 ++++++++++++++++++-------
 2 files changed, 80 insertions(+), 66 deletions(-)

-- 
1.7.11.7

