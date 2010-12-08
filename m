Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758041Ab0LHBlx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 20:41:53 -0500
Received: from kroah.org ([198.145.64.141]:48816 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757095Ab0LHBAg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 20:00:36 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:57:31 2010
Message-Id: <20101208005731.256849979@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:57:56 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Randy Dunlap <randy.dunlap@oracle.com>,
        Stefani Seibold <stefani@seibold.net>
Subject: [099/289] kfifo: disable __kfifo_must_check_helper()
In-Reply-To: <20101208005821.GA2922@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Andrew Morton <akpm@linux-foundation.org>

commit 52c5171214ff3327961d0ce0db7e8d2ce55004fd upstream.

This helper is wrong: it coerces signed values into unsigned ones, so code
such as

	if (kfifo_alloc(...) < 0) {
		error
	}

will fail to detect the error.

So let's disable __kfifo_must_check_helper() for 2.6.36.

Cc: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stefani Seibold <stefani@seibold.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/linux/kfifo.h |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

--- a/include/linux/kfifo.h
+++ b/include/linux/kfifo.h
@@ -171,11 +171,8 @@ struct kfifo_rec_ptr_2 __STRUCT_KFIFO_PT
 	}
 
 
-static inline unsigned int __must_check
-__kfifo_must_check_helper(unsigned int val)
-{
-	return val;
-}
+/* __kfifo_must_check_helper() is temporarily disabled because it was faulty */
+#define __kfifo_must_check_helper(x) (x)
 
 /**
  * kfifo_initialized - Check if the fifo is initialized


