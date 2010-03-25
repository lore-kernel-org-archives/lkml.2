Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754665Ab0CYL1j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 07:27:39 -0400
Received: from lon1-post-1.mail.demon.net ([195.173.77.148]:55927 "EHLO
	lon1-post-1.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754558Ab0CYL1i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 07:27:38 -0400
Subject: [PATCH] trace: reorder struct ring_buffer_per_cpu to remove
 padding on 64bit
From: Richard Kennedy <richard@rsk.demon.co.uk>
To: Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Ingo Molnar <mingo@redhat.com>
Cc: lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 25 Mar 2010 11:27:36 +0000
Message-ID: <1269516456.2054.8.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reorder structure to remove 8 bytes of padding on 64 bit builds.
This shrinks the size to 128 bytes so allowing allocation from a smaller
slab & needed one fewer cache lines.

Signed-off-by: Richard Kennedy <richard@rsk.demon.co.uk>
----
patch against 2.6.34-rc2
compiled & booted on x86_64

regards
Richard

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 05a9f83..421db5e 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -422,6 +422,7 @@ int ring_buffer_print_page_header(struct trace_seq
*s)
  */
 struct ring_buffer_per_cpu {
 	int				cpu;
+	atomic_t			record_disabled;
 	struct ring_buffer		*buffer;
 	spinlock_t			reader_lock;	/* serialize readers */
 	arch_spinlock_t			lock;
@@ -439,7 +440,6 @@ struct ring_buffer_per_cpu {
 	unsigned long			read;
 	u64				write_stamp;
 	u64				read_stamp;
-	atomic_t			record_disabled;
 };
 
 struct ring_buffer {


