Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758066Ab0EDRcu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 13:32:50 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:41394 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757792Ab0EDRct (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 13:32:49 -0400
X-Authority-Analysis: v=1.1 cv=Ebn0m7KaSvUJV60GCOzUqyhjUj7QmnsyUUVbVvk8w6o= c=1 sm=0 a=Ta6vJg0AaXwA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8 a=FNrQf7aUL4vgQv5CYikA:9 a=NAM7FjZZ4aZRSXfrRj_fxa8IBQoA:4 a=PUjeQqilurYA:10 a=1JvJEtVdGvUA:10 a=jeBq3FmKZ4MA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: [PATCH][GIT PULL] ring-buffer: Wrap open-coded WARN_ONCE
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       Borislav Petkov <bp@alien8.de>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Tue, 04 May 2010 13:32:46 -0400
Message-ID: <1272994366.9739.227.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

Oops, I forgot to add this one too. I just pushed it after you did your
last pull.

Please pull the latest tip/tracing/core tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/tracing/core


Borislav Petkov (1):
      ring-buffer: Wrap open-coded WARN_ONCE

----
 kernel/trace/ring_buffer.c |   14 +++++---------
 1 files changed, 5 insertions(+), 9 deletions(-)
---------------------------
commit 956097912c40a03bf22603a3be73503fd9ea9e44
Author: Borislav Petkov <bp@alien8.de>
Date:   Sun May 2 08:03:54 2010 +0200

    ring-buffer: Wrap open-coded WARN_ONCE
    
    Wrap open-coded WARN_ONCE functionality into the equivalent macro.
    
    Signed-off-by: Borislav Petkov <bp@alien8.de>
    LKML-Reference: <20100502060354.GA5281@liondog.tnic>
    Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 2a09044..7f6059c 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -2000,17 +2000,13 @@ rb_add_time_stamp(struct ring_buffer_per_cpu *cpu_buffer,
 		  u64 *ts, u64 *delta)
 {
 	struct ring_buffer_event *event;
-	static int once;
 	int ret;
 
-	if (unlikely(*delta > (1ULL << 59) && !once++)) {
-		printk(KERN_WARNING "Delta way too big! %llu"
-		       " ts=%llu write stamp = %llu\n",
-		       (unsigned long long)*delta,
-		       (unsigned long long)*ts,
-		       (unsigned long long)cpu_buffer->write_stamp);
-		WARN_ON(1);
-	}
+	WARN_ONCE(*delta > (1ULL << 59),
+		  KERN_WARNING "Delta way too big! %llu ts=%llu write stamp = %llu\n",
+		  (unsigned long long)*delta,
+		  (unsigned long long)*ts,
+		  (unsigned long long)cpu_buffer->write_stamp);
 
 	/*
 	 * The delta is too big, we to add a


