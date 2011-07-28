Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755726Ab1G1Pwy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 11:52:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26468 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755738Ab1G1Pwu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 11:52:50 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 18/40] UAPI: Fix linux/netfilter.h inclusion order [ver #3]
To: torvalds@osdl.org
Cc: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
        David Howells <dhowells@redhat.com>
Date: Thu, 28 Jul 2011 16:52:15 +0100
Message-ID: <20110728155215.16618.52514.stgit@warthog.procyon.org.uk>
In-Reply-To: <20110728154920.16618.89358.stgit@warthog.procyon.org.uk>
References: <20110728154920.16618.89358.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix linux/netfilter.h inclusion order to make sure that the inclusion of the
user-specific file happens after the inclusion of the header file that
provides struct in_addr and struct in6_addr.

To get around this problem, place a marker specifically to indicate the point
at which the UAPI header should be included in the kernel-specific file.  The
marker will be deleted later.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 include/linux/netfilter.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/linux/netfilter.h b/include/linux/netfilter.h
index 857f502..4faf53d 100644
--- a/include/linux/netfilter.h
+++ b/include/linux/netfilter.h
@@ -15,6 +15,8 @@
 #include <linux/compiler.h>
 #include <linux/sysctl.h>
 
+// DISINTEGRATE: INCLUDE UAPI HERE
+
 /* Responses from hook functions. */
 #define NF_DROP 0
 #define NF_ACCEPT 1

