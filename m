Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754000Ab2HZSYx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Aug 2012 14:24:53 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:43834 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752117Ab2HZSYw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Aug 2012 14:24:52 -0400
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: David Ahern <dsahern@gmail.com>
Subject: [PATCH 0/7] perf: cleanups related to die/exit and error handling
Date: Sun, 26 Aug 2012 12:24:40 -0600
Message-Id: <1346005487-62961-1-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.10.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Round 1 removing the use of die() and exit(). It's rather slow and tedious
to check all the error paths and make sure error propogation is properly
done and handled, so submitting patches in phases as I have time to work
on it.

David Ahern (7):
  perf tool: flush_sample_queue needs to handle errors from handlers
  perf tool: handle errors in synthesized event functions
  perf lock: remove use of die and handle errors
  perf stat: remove use of die/exit and handle errors
  perf help: remove remove use of die and handle errors
  perf script: remove use of die/exit
  perf record: remove use of die/exit

 tools/perf/builtin-help.c   |   48 ++++++++----
 tools/perf/builtin-lock.c   |  181 +++++++++++++++++++++++++++++--------------
 tools/perf/builtin-record.c |  158 +++++++++++++++++++++++++------------
 tools/perf/builtin-script.c |   60 +++++++++-----
 tools/perf/builtin-stat.c   |    7 +-
 tools/perf/util/event.c     |   35 ++++++---
 tools/perf/util/session.c   |   24 +++---
 7 files changed, 353 insertions(+), 160 deletions(-)

-- 
1.7.10.1

