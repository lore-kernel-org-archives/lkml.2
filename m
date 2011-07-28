Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755957Ab1G1Pyi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 11:54:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64589 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755737Ab1G1Pye (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 11:54:34 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 29/40] UAPI: Fix linux/ncp.h [ver #3]
To: torvalds@osdl.org
Cc: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
        David Howells <dhowells@redhat.com>
Date: Thu, 28 Jul 2011 16:53:55 +0100
Message-ID: <20110728155355.16618.61095.stgit@warthog.procyon.org.uk>
In-Reply-To: <20110728154920.16618.89358.stgit@warthog.procyon.org.uk>
References: <20110728154920.16618.89358.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix linux/coda.h to retain the #ifdef __KERNEL__ in struct nw_info_struct in
the userspace struct rather than splitting that member out into a separate
header.

This is done by placing a marker to manually control the splitter script.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 include/linux/ncp.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/ncp.h b/include/linux/ncp.h
index 99f0ade..4717262 100644
--- a/include/linux/ncp.h
+++ b/include/linux/ncp.h
@@ -155,7 +155,7 @@ struct nw_info_struct {
 	__u8 nameLen;
 	__u8 entryName[256];
 	/* libncp may depend on there being nothing after entryName */
-#ifdef __KERNEL__
+#ifdef __KERNEL__ // DISINTEGRATE: RETAIN
 	struct nw_nfs_info nfs;
 #endif
 } __attribute__((packed));

