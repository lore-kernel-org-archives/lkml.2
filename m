Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946170Ab2LFRId (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 12:08:33 -0500
Received: from mail.eecsit.tu-berlin.de ([130.149.17.13]:64949 "EHLO
	mail.cs.tu-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1424578Ab2LFRIb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 12:08:31 -0500
From: =?UTF-8?q?Jan=20H=2E=20Sch=C3=B6nherr?= <schnhrr@cs.tu-berlin.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kay Sievers <kay@vrfy.org>
Cc: linux-kernel@vger.kernel.org, Joe Perches <joe@perches.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        =?UTF-8?q?Jan=20H=2E=20Sch=C3=B6nherr?= <schnhrr@cs.tu-berlin.de>
Subject: [PATCH v2 02/14] printk: use saved timestamp for temporarily buffered message
Date: Thu,  6 Dec 2012 18:05:59 +0100
Message-Id: <1354813571-11253-3-git-send-email-schnhrr@cs.tu-berlin.de>
X-Mailer: git-send-email 1.8.0.1.20.g7c65b2e.dirty
In-Reply-To: <1354813571-11253-1-git-send-email-schnhrr@cs.tu-berlin.de>
References: <1354813571-11253-1-git-send-email-schnhrr@cs.tu-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a message has been buffered, always use the saved timestamp reflecting
the actual occurrence of the message. (There is no reason to use a
possibly later timestamp.)

Signed-off-by: Jan H. Schönherr <schnhrr@cs.tu-berlin.de>
---
This is a rather small change that could be folded into the next patch
which changes cont_flush() a bit more. However, this way we have one
patch per logical change.
---
 kernel/printk.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/printk.c b/kernel/printk.c
index 857ff7c..0927068 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -1414,7 +1414,7 @@ static void cont_flush(enum log_flags flags)
 		 * If no fragment of this line ever reached the console,
 		 * just submit it to the store and free the buffer.
 		 */
-		log_store(cont.facility, cont.level, cont.flags, 0,
+		log_store(cont.facility, cont.level, cont.flags, cont.ts_nsec,
 			  NULL, 0, cont.buf, cont.len);
 		cont.len = 0;
 	}
-- 
1.8.0.1.20.g7c65b2e.dirty

