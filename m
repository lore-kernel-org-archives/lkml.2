Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753871Ab0CZNsG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 09:48:06 -0400
Received: from mail-fx0-f223.google.com ([209.85.220.223]:48987 "EHLO
	mail-fx0-f223.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753509Ab0CZNr7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 09:47:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references:mime-version:content-type:content-transfer-encoding;
        b=S5wcO+w0x74gM9UoBiE0LmdriGaCi64G0VzbyWSlys9aADfF+g2N5qzaSQKKaIWkEL
         zqDYXLOfbj75bW8N7DTG6DqKuBYsuCQOvhcAfQCHmScC8Ky7Iz9gQNL+dAu6mNI7YEZp
         hDYaFGwf5dEN1bCv6SxiRUjFumU/vzKK8T/QM=
From: Andrea Gelmini <andrea.gelmini@gelma.net>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, Andrea Gelmini <andrea.gelmini@gelma.net>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Tom Zanussi <tzanussi@gmail.com>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 2/2] Tools perf builtin-trace.c: %Ld -> %lld
Date: Fri, 26 Mar 2010 14:47:51 +0100
Message-Id: <1269611272-29406-2-git-send-email-andrea.gelmini@gelma.net>
X-Mailer: git-send-email 1.7.0.3.296.g9776a
In-Reply-To: <20100326080226.GC27394@elte.hu>
References: <20100326080226.GC27394@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chackpatch.pl cleanup:
WARNING: %Ld/%Lu are not-standard C, use %lld/%llu
+·⁖⁖dump_printf("(IP, %d): %d/%d: %#Lx period: %Ld\n", event->header.misc,

Signed-off-by: Andrea Gelmini <andrea.gelmini@gelma.net>
---
 tools/perf/builtin-trace.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index c743c86..49b772f 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -71,7 +71,7 @@ static int process_sample_event(event_t *event, struct perf_session *session)
 
 	event__parse_sample(event, session->sample_type, &data);
 
-	dump_printf("(IP, %d): %d/%d: %#Lx period: %Ld\n", event->header.misc,
+	dump_printf("(IP, %d): %d/%d: %#Lx period: %lld\n", event->header.misc,
 		    data.pid, data.tid, data.ip, data.period);
 
 	thread = perf_session__findnew(session, event->ip.pid);
-- 
1.7.0.3.296.g9776a

