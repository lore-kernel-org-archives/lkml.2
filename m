Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933811Ab0HLPcv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 11:32:51 -0400
Received: from trinity.develer.com ([83.149.158.210]:32926 "EHLO
	trinity.develer.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933710Ab0HLPcq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 11:32:46 -0400
From: Andrea Righi <arighi@develer.com>
To: Stefani Seibold <stefani@seibold.net>
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Andi Kleen <ak@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] kfifo: implement missing __kfifo_skip_r()
Date: Thu, 12 Aug 2010 17:32:37 +0200
Message-Id: <1281627158-9461-1-git-send-email-arighi@develer.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kfifo_skip() is currently broken, due to the missing of the internal
helper function. Add it.

Signed-off-by: Andrea Righi <arighi@develer.com>
---
 include/linux/kfifo.h |    2 ++
 kernel/kfifo.c        |    9 +++++++++
 2 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/include/linux/kfifo.h b/include/linux/kfifo.h
index 311f875..4aa95f2 100644
--- a/include/linux/kfifo.h
+++ b/include/linux/kfifo.h
@@ -836,6 +836,8 @@ extern void __kfifo_dma_out_finish_r(struct __kfifo *fifo, size_t recsize);
 
 extern unsigned int __kfifo_len_r(struct __kfifo *fifo, size_t recsize);
 
+extern void __kfifo_skip_r(struct __kfifo *fifo, size_t recsize);
+
 extern unsigned int __kfifo_out_peek_r(struct __kfifo *fifo,
 	void *buf, unsigned int len, size_t recsize);
 
diff --git a/kernel/kfifo.c b/kernel/kfifo.c
index 02192dd..06d6eee 100644
--- a/kernel/kfifo.c
+++ b/kernel/kfifo.c
@@ -504,6 +504,15 @@ unsigned int __kfifo_out_r(struct __kfifo *fifo, void *buf,
 }
 EXPORT_SYMBOL(__kfifo_out_r);
 
+void __kfifo_skip_r(struct __kfifo *fifo, size_t recsize)
+{
+	unsigned int n;
+
+	n = __kfifo_peek_n(fifo, recsize);
+	fifo->out += n + recsize;
+}
+EXPORT_SYMBOL(__kfifo_skip_r);
+
 int __kfifo_from_user_r(struct __kfifo *fifo, const void __user *from,
 	unsigned long len, unsigned int *copied, size_t recsize)
 {
-- 
1.7.0.4

