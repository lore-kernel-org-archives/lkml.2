Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754447Ab1LMKj7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 05:39:59 -0500
Received: from warthog.procyon.org.uk ([90.155.74.18]:52116 "EHLO
	warthog.procyon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754265Ab1LMKjq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 05:39:46 -0500
From: David Howells <dhowells@redhat.com>
To: sfr@canb.auug.org.au, torvalds@linux-foundation.org
Cc: arnd@arndb.de, dhowells@redhat.com, alan@lxorguk.ukuu.org.uk,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: [PATCH 14/17] UAPI: Make linux/patchkey.h easier to parse
Date: Tue, 13 Dec 2011 10:04:10 +0000
Message-Id: <1323770653-19177-15-git-send-email-dhowells@redhat.com>
X-Mailer: git-send-email 1.7.7.4
In-Reply-To: <1323770653-19177-1-git-send-email-dhowells@redhat.com>
References: <1323770653-19177-1-git-send-email-dhowells@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make linux/patchkey.h easier to parse by:

 (1) Switching the reinclusion guard and the indirect-inclusion checks in
     linux/patchkey.h to put the guard around the outside.

 (2) Making the #elif case associated with the __KERNEL__ guard a nested #if
     in a #else of the __KERNEL__ guard.

Signed-off-by: David Howells <dhowells@redhat.com>
---
 include/linux/patchkey.h |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/include/linux/patchkey.h b/include/linux/patchkey.h
index d974a6e..aefda0e 100644
--- a/include/linux/patchkey.h
+++ b/include/linux/patchkey.h
@@ -32,7 +32,8 @@
 #  else
 #    error "could not determine byte order"
 #  endif
-#elif defined(__BYTE_ORDER)
+#else
+#if defined(__BYTE_ORDER)
 #  if __BYTE_ORDER == __BIG_ENDIAN
 #    define _PATCHKEY(id) (0xfd00|id)
 #  elif __BYTE_ORDER == __LITTLE_ENDIAN
@@ -41,5 +42,6 @@
 #    error "could not determine byte order"
 #  endif
 #endif
+#endif
 
 #endif /* _LINUX_PATCHKEY_H */
-- 
1.7.7.4

