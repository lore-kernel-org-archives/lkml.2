Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755937Ab1G1PyJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 11:54:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33261 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755245Ab1G1PyF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 11:54:05 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 26/40] UAPI: Fix linux/coda.h [ver #3]
To: torvalds@osdl.org
Cc: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
        David Howells <dhowells@redhat.com>
Date: Thu, 28 Jul 2011 16:53:27 +0100
Message-ID: <20110728155327.16618.87216.stgit@warthog.procyon.org.uk>
In-Reply-To: <20110728154920.16618.89358.stgit@warthog.procyon.org.uk>
References: <20110728154920.16618.89358.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix linux/coda.h to retain the #ifdef __KERNEL__ in struct coda_open_by_fd_out
in the userspace struct rather than splitting that member out into a separate
header.

This is done by placing a marker to manually control the splitter script.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 include/linux/coda.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/coda.h b/include/linux/coda.h
index 5a2c1a0..2ae9dcd 100644
--- a/include/linux/coda.h
+++ b/include/linux/coda.h
@@ -618,7 +618,7 @@ struct coda_open_by_fd_out {
     struct coda_out_hdr oh;
     int fd;
 
-#ifdef __KERNEL__
+#ifdef __KERNEL__ // DISINTEGRATE: RETAIN
     struct file *fh; /* not passed from userspace but used in-kernel only */
 #endif
 };

