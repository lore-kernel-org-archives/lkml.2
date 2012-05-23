Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933510Ab2EWCjB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 22:39:01 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:43911 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753279Ab2EWCi7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 22:38:59 -0400
X-AuditID: 9c93016f-b7c3cae000001954-0f-4fbc4dc12b92
From: Namhyung Kim <namhyung.kim@lge.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>, Namhyung Kim <namhyung@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 00/22] perf tools: Backport of latest changes on trace-cmd's libparseevent
Date: Wed, 23 May 2012 11:36:37 +0900
Message-Id: <1337740619-27925-1-git-send-email-namhyung.kim@lge.com>
X-Mailer: git-send-email 1.7.10.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is a patchset which attempts to sync what we have on trace-cmd
into libtraceevent. Although some patch introduced new call-sites of
die() or malloc_or_die(), it'll be removed eventually (or later work)
and this helps marking the every locations that we need to track.

Thanks,
Namhyung


Namhyung Kim (15):
  lib/traceevent: Fix printk_cmp()
  lib/traceevent: Introduce extend_token()
  lib/traceevent: Handle strdup failure cases
  lib/traceevent: Fix a possible memory leak
  lib/traceevent: Handle realloc() failure path
  lib/traceevent: Fix a possibly wrong memory dereference
  lib/traceevent: Fix freeing arg on process_dynamic_array()
  lib/traceevent: Use proper function parameter type
  lib/traceevent: Pass string type argument to args
  lib/traceevent: Do not call add_event() again if allocation failed
  lib/traceevent: Fix some comments
  lib/traceevent: Check result of malloc() during reading token
  lib/traceevent: Fix signature of create_arg_item()
  lib/traceevent: Check return value of arg_to_str()
  lib/traceevent: Cleanup realloc use

Peter Huewe (1):
  lib/traceevent: Add missing break in make_bprint_args

Stefan Hajnoczi (1):
  lib/traceevent: Allow expressions in __print_symbolic() fields

Steven Rostedt (4):
  lib/traceevent: Let filtering numbers by string use function names
  lib/traceevent: Add support for "%.*s" in bprintk events
  lib/traceevent: Add support to show migrate disable counter
  lib/traceevent: Fix %pM print format arg handling

Wolfgang Mauerer (1):
  lib/traceevent: Fix trace_printk for long integers

 tools/lib/traceevent/event-parse.c  |  309 ++++++++++++++++++++++++-----------
 tools/lib/traceevent/parse-filter.c |   91 +++++++----
 2 files changed, 271 insertions(+), 129 deletions(-)

-- 
1.7.10.1

