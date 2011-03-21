Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755941Ab1CUX5s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 19:57:48 -0400
Received: from kroah.org ([198.145.64.141]:49080 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755086Ab1CUXOA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 19:14:00 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Mar 21 16:10:53 2011
Message-Id: <20110321231053.660790916@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Mon, 21 Mar 2011 16:10:09 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Subject: [29/44] perf: Handle stopped state with tracepoints
In-Reply-To: <20110321231105.GA1744@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Frederic Weisbecker <fweisbec@gmail.com>

commit a0f7d0f7fc02465bb9758501f611f63381792996 upstream.

We toggle the state from start and stop callbacks but actually
don't check it when the event triggers. Do it so that
these callbacks actually work.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Stephane Eranian <eranian@google.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1299529629-18280-2-git-send-email-fweisbec@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/perf_event.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -4167,6 +4167,8 @@ static void tp_perf_event_destroy(struct
 
 static const struct pmu *tp_perf_event_init(struct perf_event *event)
 {
+	if (event->hw.state & PERF_HES_STOPPED)
+		return 0;
 	/*
 	 * Raw tracepoint data is a severe data leak, only allow root to
 	 * have these.


