Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753502Ab1EVBqB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 May 2011 21:46:01 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:61446 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753127Ab1EVBp4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 May 2011 21:45:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=wLWsAEauvhe3Ydui3YiWp725kHGnMq9ZkQMzBxI8IvdRSDKw9qsdDr+6hUcgc1j3Y1
         ycDgAUx529UG4bNybi0N3IAOTeUxGm+fBPHwZlPZGzFu9hbzCLeGJKViwyd0W6buqITZ
         ubNYGTgAaD7Ir03o7Hkz5b2vT08Ct4wJmLmjw=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 1/6] perf tools: Check we are able to read the event size on mmap
Date: Sun, 22 May 2011 03:45:39 +0200
Message-Id: <1306028744-10603-2-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <1306028744-10603-1-git-send-email-fweisbec@gmail.com>
References: <1306028744-10603-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Check we have enough mmaped space to read the current event
size from its headers, otherwise we may dereference some
hell there.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Stephane Eranian <eranian@google.com>
---
 tools/perf/util/session.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index fff6674..61746b5 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -1007,6 +1007,13 @@ remap:
 	file_pos = file_offset + head;
 
 more:
+	/*
+	 * Ensure we have enough space remaining to read
+	 * the size of the event in the headers.
+	 */
+	if (head + sizeof(event->header) > mmap_size)
+		goto remap;
+
 	event = (union perf_event *)(buf + head);
 
 	if (session->header.needs_swap)
-- 
1.7.3.2

