Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754913Ab2KMXP4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 18:15:56 -0500
Received: from mail.eecsit.tu-berlin.de ([130.149.17.13]:63585 "EHLO
	mail.cs.tu-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754544Ab2KMXPz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 18:15:55 -0500
From: =?UTF-8?q?Jan=20H=2E=20Sch=C3=B6nherr?= <schnhrr@cs.tu-berlin.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Kay Sievers <kay@vrfy.org>,
        =?UTF-8?q?Jan=20H=2E=20Sch=C3=B6nherr?= <schnhrr@cs.tu-berlin.de>
Subject: [PATCH 02/12] printk: use saved timestamp for temporarily buffered message
Date: Wed, 14 Nov 2012 00:12:59 +0100
Message-Id: <1352848389-23114-3-git-send-email-schnhrr@cs.tu-berlin.de>
X-Mailer: git-send-email 1.8.0.316.g291341c.dirty
In-Reply-To: <1352848389-23114-1-git-send-email-schnhrr@cs.tu-berlin.de>
References: <1352848389-23114-1-git-send-email-schnhrr@cs.tu-berlin.de>
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
1.8.0.316.g291341c.dirty

