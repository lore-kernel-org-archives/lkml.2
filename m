Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761553Ab2EKGsK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 02:48:10 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57419 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753048Ab2EKGsI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 02:48:08 -0400
Date: Thu, 10 May 2012 23:47:57 -0700
From: tip-bot for David Ahern <dsahern@gmail.com>
Message-ID: <tip-40491eaa46a693e8c6ef94102350a747c63e584d@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, dsahern@gmail.com, tglx@linutronix.de
In-Reply-To: <1336495789-58420-1-git-send-email-dsahern@gmail.com>
References: <1336495789-58420-1-git-send-email-dsahern@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf top:
  Update event name when falling back to cpu-clock
Git-Commit-ID: 40491eaa46a693e8c6ef94102350a747c63e584d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 10 May 2012 23:48:02 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  40491eaa46a693e8c6ef94102350a747c63e584d
Gitweb:     http://git.kernel.org/tip/40491eaa46a693e8c6ef94102350a747c63e584d
Author:     David Ahern <dsahern@gmail.com>
AuthorDate: Tue, 8 May 2012 10:49:49 -0600
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 9 May 2012 12:01:57 -0300

perf top: Update event name when falling back to cpu-clock

The 'perf top' command falls back to cpu-clock if the H/W cycles event
is not supported, but the event name is not updated leading to a
misleading header:

PerfTop: 8 irqs/sec  kernel:75.0%  exact:  0.0% [1000Hz cycles],  ...

Update the event name when the event type is changed so that the
header displays correctly:

PerfTop: 794 irqs/sec  kernel:100.0%  exact:  0.0% [1000Hz cpu-clock], ...

Signed-off-by: David Ahern <dsahern@gmail.com>
Link: http://lkml.kernel.org/r/1336495789-58420-1-git-send-email-dsahern@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-top.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index c53cdab..4eb6171 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -948,6 +948,10 @@ try_again:
 
 				attr->type = PERF_TYPE_SOFTWARE;
 				attr->config = PERF_COUNT_SW_CPU_CLOCK;
+				if (counter->name) {
+					free(counter->name);
+					counter->name = strdup(event_name(counter));
+				}
 				goto try_again;
 			}
 
