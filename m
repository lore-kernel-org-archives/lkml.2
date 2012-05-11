Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761605Ab2EKGs6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 02:48:58 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57431 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760162Ab2EKGs5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 02:48:57 -0400
Date: Thu, 10 May 2012 23:48:46 -0700
From: tip-bot for David Ahern <dsahern@gmail.com>
Message-ID: <tip-d1cae34d6fda59391e1b06ac1642ef4a740ba3ef@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, dsahern@gmail.com, tglx@linutronix.de
In-Reply-To: <1336495811-58461-1-git-send-email-dsahern@gmail.com>
References: <1336495811-58461-1-git-send-email-dsahern@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf record:
  Reset event name when falling back to cpu-clock
Git-Commit-ID: d1cae34d6fda59391e1b06ac1642ef4a740ba3ef
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 10 May 2012 23:48:51 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d1cae34d6fda59391e1b06ac1642ef4a740ba3ef
Gitweb:     http://git.kernel.org/tip/d1cae34d6fda59391e1b06ac1642ef4a740ba3ef
Author:     David Ahern <dsahern@gmail.com>
AuthorDate: Tue, 8 May 2012 10:50:11 -0600
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 9 May 2012 12:02:10 -0300

perf record: Reset event name when falling back to cpu-clock

perf-record defaults to the H/W cycles event and if it is not supported
falls back to cpu-clock. Reset the event name as well.

Signed-off-by: David Ahern <dsahern@gmail.com>
Link: http://lkml.kernel.org/r/1336495811-58461-1-git-send-email-dsahern@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-record.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 1a9098c..d19058a 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -256,6 +256,10 @@ try_again:
 						    "trying to fall back to cpu-clock-ticks\n");
 				attr->type = PERF_TYPE_SOFTWARE;
 				attr->config = PERF_COUNT_SW_CPU_CLOCK;
+				if (pos->name) {
+					free(pos->name);
+					pos->name = NULL;
+				}
 				goto try_again;
 			}
 
