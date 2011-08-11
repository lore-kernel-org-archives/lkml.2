Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752006Ab1HKO0E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 10:26:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23157 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750741Ab1HKO0B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 10:26:01 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: rostedt@goodmis.org, fweisbec@gmail.com, mingo@redhat.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCHv2 0/10] ftrace/filter: Trace events filtering related fixies
Date: Thu, 11 Aug 2011 16:25:44 +0200
Message-Id: <1313072754-4620-1-git-send-email-jolsa@redhat.com>
In-Reply-To: <1313011535.18583.280.camel@gandalf.stny.rr.com>
References: <1313011535.18583.280.camel@gandalf.stny.rr.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,

on the way to perf/ftrace filtering changes, I made some changes
to the current events filtering code. It could be divided into 3
parts roughly:

- remove unnecessary dynamic allocations (patches 1 - 4)
- unify the predicate tree walking (patches 5 - 9)
- added startup test for event filtering (patch 10)

attached patches:
- 01/10 tracing/filter: Use static allocation for filter predicates
- 02/10 tracing/filter: Separate predicate init and filter addition
- 03/10 tracing/filter: Remove field_name from filter_pred struct
- 04/10 tracing/filter: Simplify tracepoint event lookup
- 05/10 tracing/filter: Unify predicate tree walking, change check_pred_tree function to use it
- 06/10 tracing/filter: Change count_leafs function to use walk_pred_tree
- 07/10 tracing/filter: Change fold_pred_tree function to use walk_pred_tree
- 08/10 tracing/filter: Change fold_pred function to use walk_pred_tree
- 09/10 tracing/filter: Change filter_match_preds function to use walk_pred_tree
- 10/10 tracing/filter: Add startup tests for events filter

v2 changes:
- 02/10 - changed patch change log
- 06/10 - putting functionality out of WARN_ON
- 09/10 - using WARN_ON_ONCE instead of BUG_ON
        - putting functionality out of WARN_ON
- 10/10 - moved/renamed test.h into kernel/trace/trace_events_filter_test.h

wbr,
jirka
---
 kernel/trace/Makefile                   |    2 +
 kernel/trace/trace.h                    |   14 +-
 kernel/trace/trace_events_filter.c      |  786 ++++++++++++++++++-------------
 kernel/trace/trace_events_filter_test.h |   50 ++
 4 files changed, 510 insertions(+), 342 deletions(-)
