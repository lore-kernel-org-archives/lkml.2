Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752529Ab2LCU70 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 15:59:26 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:62399 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752374Ab2LCU7U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 15:59:20 -0500
From: Kent Overstreet <koverstreet@google.com>
To: linux-kernel@vger.kernel.org, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org
Cc: zab@redhat.com, bcrl@kvack.org, jmoyer@redhat.com, axboe@kernel.dk,
        viro@zeniv.linux.org.uk, Kent Overstreet <koverstreet@google.com>
Subject: [PATCH 02/26] aio: remove dead code from aio.h
Date: Mon,  3 Dec 2012 12:58:18 -0800
Message-Id: <1354568322-29029-3-git-send-email-koverstreet@google.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1354568322-29029-1-git-send-email-koverstreet@google.com>
References: <1354568322-29029-1-git-send-email-koverstreet@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zach Brown <zab@redhat.com>

Signed-off-by: Zach Brown <zab@redhat.com>
Signed-off-by: Kent Overstreet <koverstreet@google.com>
---
 include/linux/aio.h | 24 ------------------------
 1 file changed, 24 deletions(-)

diff --git a/include/linux/aio.h b/include/linux/aio.h
index 31ff6db..b46a09f 100644
--- a/include/linux/aio.h
+++ b/include/linux/aio.h
@@ -9,44 +9,22 @@
 
 #include <linux/atomic.h>
 
-#define AIO_MAXSEGS		4
-#define AIO_KIOGRP_NR_ATOMIC	8
-
 struct kioctx;
 
-/* Notes on cancelling a kiocb:
- *	If a kiocb is cancelled, aio_complete may return 0 to indicate 
- *	that cancel has not yet disposed of the kiocb.  All cancel 
- *	operations *must* call aio_put_req to dispose of the kiocb 
- *	to guard against races with the completion code.
- */
-#define KIOCB_C_CANCELLED	0x01
-#define KIOCB_C_COMPLETE	0x02
-
 #define KIOCB_SYNC_KEY		(~0U)
 
 /* ki_flags bits */
-/*
- * This may be used for cancel/retry serialization in the future, but
- * for now it's unused and we probably don't want modules to even
- * think they can use it.
- */
-/* #define KIF_LOCKED		0 */
 #define KIF_KICKED		1
 #define KIF_CANCELLED		2
 
-#define kiocbTryLock(iocb)	test_and_set_bit(KIF_LOCKED, &(iocb)->ki_flags)
 #define kiocbTryKick(iocb)	test_and_set_bit(KIF_KICKED, &(iocb)->ki_flags)
 
-#define kiocbSetLocked(iocb)	set_bit(KIF_LOCKED, &(iocb)->ki_flags)
 #define kiocbSetKicked(iocb)	set_bit(KIF_KICKED, &(iocb)->ki_flags)
 #define kiocbSetCancelled(iocb)	set_bit(KIF_CANCELLED, &(iocb)->ki_flags)
 
-#define kiocbClearLocked(iocb)	clear_bit(KIF_LOCKED, &(iocb)->ki_flags)
 #define kiocbClearKicked(iocb)	clear_bit(KIF_KICKED, &(iocb)->ki_flags)
 #define kiocbClearCancelled(iocb)	clear_bit(KIF_CANCELLED, &(iocb)->ki_flags)
 
-#define kiocbIsLocked(iocb)	test_bit(KIF_LOCKED, &(iocb)->ki_flags)
 #define kiocbIsKicked(iocb)	test_bit(KIF_KICKED, &(iocb)->ki_flags)
 #define kiocbIsCancelled(iocb)	test_bit(KIF_CANCELLED, &(iocb)->ki_flags)
 
@@ -207,8 +185,6 @@ struct kioctx {
 };
 
 /* prototypes */
-extern unsigned aio_max_size;
-
 #ifdef CONFIG_AIO
 extern ssize_t wait_on_sync_kiocb(struct kiocb *iocb);
 extern int aio_put_req(struct kiocb *iocb);
-- 
1.7.12

