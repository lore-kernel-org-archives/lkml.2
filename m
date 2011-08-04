Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753400Ab1HDKIh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 06:08:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15419 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752760Ab1HDKIb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 06:08:31 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: rostedt@goodmis.org, fweisbec@gmail.com, mingo@redhat.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 0/10] ftrace/filter: Trace events filtering related fixies
Date: Thu,  4 Aug 2011 12:08:16 +0200
Message-Id: <1312452506-5100-1-git-send-email-jolsa@redhat.com>
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

wbr,
jirka
---
 include/trace/events/test.h        |   45 ++
 kernel/trace/trace.h               |   14 +-
 kernel/trace/trace_events_filter.c |  778 +++++++++++++++++++++---------------
 3 files changed, 497 insertions(+), 340 deletions(-)
