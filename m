Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753661Ab0JGQhN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 12:37:13 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:51607 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751525Ab0JGQhL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 12:37:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=XG/TA/5EaBK5gaOoEhAqBUAzHlZlR77AGWWOrGc0io+fAPqiE/qx/szc7JfQq2qqyO
         90UCczm0D4+IS7RW49Kt+FXXQlz1YSbZExE+W197UpbBAAZdMbVQAHMW3u5KSaQaiAsC
         /sQCWBL6bkv2Rep85u367MxOU4nnrgZAcFXcs=
Subject: [PATCH] percpu_counter: change inaccurate comment
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 07 Oct 2010 18:37:01 +0200
Message-ID: <1286469421.2912.240.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

percpu_counter used to be huge objects, they are not anymore,
thanks to fine alloc_percpu() granularity.

We now consume 4 bytes per possible cpu.

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
---
 include/linux/percpu_counter.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/linux/percpu_counter.h b/include/linux/percpu_counter.h
index 8a7d510..5e2cb5c 100644
--- a/include/linux/percpu_counter.h
+++ b/include/linux/percpu_counter.h
@@ -3,7 +3,8 @@
 /*
  * A simple "approximate counter" for use in ext2 and ext3 superblocks.
  *
- * WARNING: these things are HUGE.  4 kbytes per counter on 32-way P4.
+ * WARNING: these things are big :  4 bytes per possible cpu per counter.
+ * For a 64 cpus machine: 256 bytes + sizeof(struct percpu_counter)
  */
 
 #include <linux/spinlock.h>


