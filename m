Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753393Ab2JOBYS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 21:24:18 -0400
Received: from oproxy11-pub.bluehost.com ([173.254.64.10]:55428 "HELO
	oproxy11-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752617Ab2JOBYR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 21:24:17 -0400
Message-ID: <507B65B9.4080603@xenotime.net>
Date: Sun, 14 Oct 2012 18:24:09 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: akpm@linux-foundation.org
CC: linux-kernel@vger.kernel.org, linux-next@vger.kernel.org,
        David Howells <dhowells@redhat.com>
Subject: [PATCH -mmotm] kernel: fix synchro-test.c printk format warrnings
References: <20121011231551.641101E0048@wpzn4.hot.corp.google.com>
In-Reply-To: <20121011231551.641101E0048@wpzn4.hot.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@xenotime.net>

Fix printk format warnings in kernel/synchro-test.c.
Fixes warnings on i386 and on x86_64.

kernel/synchro-test.c:432:4: warning: format '%u' expects type 'unsigned int', but argument 5 has type 'long unsigned int'
kernel/synchro-test.c:437:4: warning: format '%u' expects type 'unsigned int', but argument 5 has type 'long unsigned int'
kernel/synchro-test.c:442:4: warning: format '%u' expects type 'unsigned int', but argument 5 has type 'long unsigned int'
kernel/synchro-test.c:447:4: warning: format '%u' expects type 'unsigned int', but argument 5 has type 'long unsigned int'
kernel/synchro-test.c:452:4: warning: format '%u' expects type 'unsigned int', but argument 5 has type 'long unsigned int'

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
---
 kernel/synchro-test.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- mmotm-2012-1011-1614.orig/kernel/synchro-test.c
+++ mmotm-2012-1011-1614/kernel/synchro-test.c
@@ -429,27 +429,27 @@ static int __init do_tests(void)
 	for (loop = 0; loop < MAX_THREADS; loop++) {
 		if (loop < nummx) {
 			init_completion(&mx_comp[loop]);
-			kthread_run(mutexer, (void *) loop, "Mutex%u", loop);
+			kthread_run(mutexer, (void *) loop, "Mutex%lu", loop);
 		}
 
 		if (loop < numsm) {
 			init_completion(&sm_comp[loop]);
-			kthread_run(semaphorer, (void *) loop, "Sem%u", loop);
+			kthread_run(semaphorer, (void *) loop, "Sem%lu", loop);
 		}
 
 		if (loop < numrd) {
 			init_completion(&rd_comp[loop]);
-			kthread_run(reader, (void *) loop, "Read%u", loop);
+			kthread_run(reader, (void *) loop, "Read%lu", loop);
 		}
 
 		if (loop < numwr) {
 			init_completion(&wr_comp[loop]);
-			kthread_run(writer, (void *) loop, "Write%u", loop);
+			kthread_run(writer, (void *) loop, "Write%lu", loop);
 		}
 
 		if (loop < numdg) {
 			init_completion(&dg_comp[loop]);
-			kthread_run(downgrader, (void *) loop, "Down%u", loop);
+			kthread_run(downgrader, (void *) loop, "Down%lu", loop);
 		}
 	}
 
