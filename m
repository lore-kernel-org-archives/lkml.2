Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755771Ab1G1PxQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 11:53:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48683 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755558Ab1G1PxN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 11:53:13 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 21/40] UAPI: Fix linux/auto_fs.h inclusion order [ver #3]
To: torvalds@osdl.org
Cc: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
        David Howells <dhowells@redhat.com>
Date: Thu, 28 Jul 2011 16:52:42 +0100
Message-ID: <20110728155242.16618.87548.stgit@warthog.procyon.org.uk>
In-Reply-To: <20110728154920.16618.89358.stgit@warthog.procyon.org.uk>
References: <20110728154920.16618.89358.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix linux/auto_fs.h inclusion order to make sure that the inclusion of the
user-specific file happens after the inclusion of the header file that
provides NAME_MAX.

To get around this problem, place a marker specifically to indicate the point
at which the UAPI header should be included in the kernel-specific file.  The
marker will be deleted later.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 include/linux/auto_fs.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/linux/auto_fs.h b/include/linux/auto_fs.h
index da64e15..f9ca4e6 100644
--- a/include/linux/auto_fs.h
+++ b/include/linux/auto_fs.h
@@ -23,6 +23,8 @@
 #include <sys/ioctl.h>
 #endif /* __KERNEL__ */
 
+// DISINTEGRATE: INCLUDE UAPI HERE
+
 /* This file describes autofs v3 */
 #define AUTOFS_PROTO_VERSION	3
 

