Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754873Ab0FCVgK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 17:36:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31041 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753998Ab0FCVgI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 17:36:08 -0400
Date: Thu, 3 Jun 2010 23:34:09 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Jason Baron <jbaron@redhat.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
       stable@kernel.org
Subject: [PATCH 2.6.35/stable] TP_STORE_SIGINFO(SEND_SIG_FORCED) == OOPS
Message-ID: <20100603213409.GA8307@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

BUG: unable to handle kernel NULL pointer dereference at 0000000000000006
IP: [<ffffffff8107bd37>] ftrace_raw_event_signal_generate+0x87/0x140

TP_STORE_SIGINFO() forgets about SEND_SIG_FORCED, fix.

We should probably export is_si_special() and change TP_STORE_SIGINFO()
to use it.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 include/trace/events/signal.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- 34-rc1/include/trace/events/signal.h~TP_STORE_SIGINFO	2009-12-18 19:05:38.000000000 +0100
+++ 34-rc1/include/trace/events/signal.h	2010-06-03 23:24:07.000000000 +0200
@@ -10,7 +10,8 @@
 
 #define TP_STORE_SIGINFO(__entry, info)				\
 	do {							\
-		if (info == SEND_SIG_NOINFO) {			\
+		if (info == SEND_SIG_NOINFO ||			\
+		    info == SEND_SIG_FORCED) {			\
 			__entry->errno	= 0;			\
 			__entry->code	= SI_USER;		\
 		} else if (info == SEND_SIG_PRIV) {		\

