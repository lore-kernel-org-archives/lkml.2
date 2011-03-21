Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932443Ab1CUXYO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 19:24:14 -0400
Received: from kroah.org ([198.145.64.141]:52754 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932286Ab1CUXSY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 19:18:24 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Mar 21 16:03:27 2011
Message-Id: <20110321230327.896908914@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Mon, 21 Mar 2011 16:02:16 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@elte.hu>
Subject: [60/78] perf: Fix the software events state check
In-Reply-To: <20110321230346.GA14681@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

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
@@ -4567,7 +4567,7 @@ static int perf_exclude_event(struct per
 			      struct pt_regs *regs)
 {
 	if (event->hw.state & PERF_HES_STOPPED)
-		return 0;
+		return 1;
 
 	if (regs) {
 		if (event->attr.exclude_user && user_mode(regs))


