Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757599Ab1FGXzn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 19:55:43 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:35799 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755879Ab1FGXzk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 19:55:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=Exzh34gg+0qvItOvmNnu6szBoaJx5TU1AMVJHly1v64CB/LzOeNzUflX28NQM++9Ng
         JHgOK6LOYxRl9ZKisLPanFsaLrLo2DJ72iFiOJ6TBUk60O274xoC15SLtdV+MUSikm3z
         NNMnpJ0e5TNbeXpvxqtCYTFWlXmEElyhD/N2I=
From: David Ahern <dsahern@gmail.com>
To: linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: acme@ghostprotocols.net, mingo@elte.hu, peterz@infradead.org,
        fweisbec@gmail.com, paulus@samba.org, tglx@linutronix.de,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH 0/6] Add time-of-day option to perf events
Date: Tue,  7 Jun 2011 17:53:26 -0600
Message-Id: <1307490806-24548-1-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.5.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Another attempt at printing time-of-day strings on perf events - this
time with tracepoints in the timekeeping code to catch updates to
xtime.

David Ahern (6):
  trace: add tracepoints to timekeeping code - xtime changes
  perf utils: export parse_single_tracepoint_event
  perf: add reference time event
  perf record: add time-of-day option
  perf script: pass trace event to print_trace_event
  perf script: add time-of-day option for displaying events

 include/trace/events/timekeeping.h       |   43 ++++++++
 kernel/time/timekeeping.c                |    8 ++
 tools/perf/Documentation/perf-record.txt |    3 +
 tools/perf/Documentation/perf-script.txt |    8 ++-
 tools/perf/builtin-record.c              |  102 +++++++++++++++++++-
 tools/perf/builtin-script.c              |  157 +++++++++++++++++++++++++++++-
 tools/perf/util/event.c                  |    1 +
 tools/perf/util/event.h                  |    8 ++
 tools/perf/util/parse-events.c           |   13 +--
 tools/perf/util/parse-events.h           |   12 +++
 tools/perf/util/session.c                |    4 +
 tools/perf/util/session.h                |    3 +-
 tools/perf/util/trace-event-parse.c      |   12 +--
 tools/perf/util/trace-event.h            |    2 +-
 14 files changed, 350 insertions(+), 26 deletions(-)
 create mode 100644 include/trace/events/timekeeping.h

-- 
1.7.5.2

