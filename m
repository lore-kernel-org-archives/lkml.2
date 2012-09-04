Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754349Ab2IDAxn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2012 20:53:43 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:42513 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754195Ab2IDAxm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2012 20:53:42 -0400
X-AuditID: b753bd60-91b5cba000007c38-9f-50455114aa83
X-AuditID: b753bd60-91b5cba000007c38-9f-50455114aa83
From: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Subject: [PATCH] tools: Fix pthread flag for Makefile of trace-agent used by
 virtio-trace
To: Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org
Cc: Amit Shah <amit.shah@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Steven Rostedt <rostedt@goodmis.org>, yrl.pp-manager.tt@hitachi.com,
        Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Date: Tue, 04 Sep 2012 09:53:39 +0900
Message-ID: <20120904005339.30804.58826.stgit@ltc189.sdl.hitachi.co.jp>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pthread flag should not be -lpthread but -pthread using gcc. The -lpthread
links the external multithread library. On the other hand, the -pthread manages
both the gcc's preprocessor and linker to be able to compile with pthread.

Signed-off-by: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
---

 tools/virtio/virtio-trace/Makefile |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/tools/virtio/virtio-trace/Makefile b/tools/virtio/virtio-trace/Makefile
index ef3adfc..0d23816 100644
--- a/tools/virtio/virtio-trace/Makefile
+++ b/tools/virtio/virtio-trace/Makefile
@@ -1,14 +1,13 @@
 CC = gcc
-CFLAGS = -O2 -Wall
-LFLAG = -lpthread
+CFLAGS = -O2 -Wall -pthread
 
 all: trace-agent
 
 .c.o:
-	$(CC) $(CFLAGS) $(LFLAG) -c $^ -o $@
+	$(CC) $(CFLAGS) -c $^ -o $@
 
 trace-agent: trace-agent.o trace-agent-ctl.o trace-agent-rw.o
-	$(CC) $(CFLAGS) $(LFLAG) -o $@ $^
+	$(CC) $(CFLAGS) -o $@ $^
 
 clean:
 	rm -f *.o trace-agent

