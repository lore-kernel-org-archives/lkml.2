Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755760Ab1CUXid (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 19:38:33 -0400
Received: from kroah.org ([198.145.64.141]:49594 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755558Ab1CUXQL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 19:16:11 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Mar 21 16:07:16 2011
Message-Id: <20110321230716.429058703@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Mon, 21 Mar 2011 16:07:09 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@elte.hu>
Subject: [70/87] perf: Fix the software events state check
In-Reply-To: <20110321230732.GA26510@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Frederic Weisbecker <fweisbec@gmail.com>

commit 91b2f482e62ad0d444222253026a5cbca28c4ab9 upstream.

Fix the mistakenly inverted check of events state.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Stephane Eranian <eranian@google.com>
LKML-Reference: <1299529629-18280-1-git-send-email-fweisbec@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/perf_event.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -4414,7 +4414,7 @@ static int perf_exclude_event(struct per
 			      struct pt_regs *regs)
 {
 	if (event->hw.state & PERF_HES_STOPPED)
-		return 0;
+		return 1;
 
 	if (regs) {
 		if (event->attr.exclude_user && user_mode(regs))


