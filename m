Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752314Ab0HBANt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Aug 2010 20:13:49 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:56235 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752206Ab0HBANb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Aug 2010 20:13:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version
         :in-reply-to:references;
        b=Kmy8Fl0o4acJaRhCJHPHQFS1qHEQNLqdFYB/cKAVPhYG7ZpS2bPkn988nJCVKlHGaL
         eWsUdt7fGOlpDDeN4t99Qdof2glc8gkt48C1IztYSgLV9/eDjUAkzwFXR599z9xID5Zo
         tmNShxTryytyhsGG5oghNisDdsYbNS0QfZN4Y=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Paul Mackerras <paulus@samba.org>, Nikhil Rao <ncrao@google.com>,
        Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH 05/12] perf, sched migration: Ignore unhandled task states
Date: Mon,  2 Aug 2010 02:13:06 +0200
Message-Id: <1280707993-6599-6-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-regression
X-Mailer-version: 0.1, "The maintainer couldn't reproduce after one week full time debugging" special version.
In-Reply-To: <1280707993-6599-1-git-send-regression-fweisbec@gmail.com>
References: <1280707993-6599-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stop printing an error message when we don't have the letter
for a given task state. All we need to know is if the task is
in the TASK_RUNNING state.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Nikhil Rao <ncrao@google.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
---
 tools/perf/scripts/python/sched-migration.py |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/tools/perf/scripts/python/sched-migration.py b/tools/perf/scripts/python/sched-migration.py
index 7304d86..e9898c5 100644
--- a/tools/perf/scripts/python/sched-migration.py
+++ b/tools/perf/scripts/python/sched-migration.py
@@ -260,8 +260,7 @@ def taskState(state):
 	}
 
 	if state not in states:
-		print "Unhandled task state %d" % state
-		return ""
+		return "Unknown"
 
 	return states[state]
 
-- 
1.6.2.3

