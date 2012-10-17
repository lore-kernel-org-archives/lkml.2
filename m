Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757275Ab2JQOPn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 10:15:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19893 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757233Ab2JQOPk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 10:15:40 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 02/10] UAPI: Make uapi/linux/irqnr.h non-empty
To: torvalds@osdl.org
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org,
        David Howells <dhowells@redhat.com>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Alessandro Suardi <alessandro.suardi@gmail.com>
Date: Wed, 17 Oct 2012 15:15:36 +0100
Message-ID: <20121017141536.29084.8653.stgit@warthog.procyon.org.uk>
In-Reply-To: <20121017141521.29084.36722.stgit@warthog.procyon.org.uk>
References: <20121017141521.29084.36722.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

uapi/linux/irqnr.h was emitted by the UAPI disintegration script as an empty
file because the parent linux/irqnr.h had no UAPI stuff in it, despite being
marked with "header-y".

Unfortunately, the patch program deletes the empty file when applying a kernel
patch.

It's not clear why this file is part of the UAPI at all.  Looking in:

	/usr/include/linux/irqnr.h

there's nothing there but a header reinclusion guard and a comment.

So just stick a comment in there as a placeholder.

Without this, if the kernel is fabricated from, say, a tarball and a patch, you
can get this error when building x86_64 or usermode Linux (and probably
others):

include/linux/irqnr.h:4:30: fatal error: uapi/linux/irqnr.h: No such file or directory

Reported-by: Randy Dunlap <rdunlap@xenotime.net>
Reported-by: Alessandro Suardi <alessandro.suardi@gmail.com>
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Randy Dunlap <rdunlap@xenotime.net>
cc: Alessandro Suardi <alessandro.suardi@gmail.com>
---

 include/uapi/linux/irqnr.h |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/include/uapi/linux/irqnr.h b/include/uapi/linux/irqnr.h
index e69de29..ae5704f 100644
--- a/include/uapi/linux/irqnr.h
+++ b/include/uapi/linux/irqnr.h
@@ -0,0 +1,4 @@
+/*
+ * There isn't anything here anymore, but the file must not be empty or patch
+ * will delete it.
+ */

