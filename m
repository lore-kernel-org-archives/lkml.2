Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755585Ab1G1Pu7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 11:50:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35259 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753537Ab1G1Puy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 11:50:54 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 09/40] UAPI: Make linux/patchkey.h easier to parse [ver #3]
To: torvalds@osdl.org
Cc: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
        David Howells <dhowells@redhat.com>
Date: Thu, 28 Jul 2011 16:50:49 +0100
Message-ID: <20110728155049.16618.29813.stgit@warthog.procyon.org.uk>
In-Reply-To: <20110728154920.16618.89358.stgit@warthog.procyon.org.uk>
References: <20110728154920.16618.89358.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
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

