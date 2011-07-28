Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755810Ab1G1PxH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 11:53:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14601 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755855Ab1G1PxF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 11:53:05 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 20/40] UAPI: Fix up linux/netfilter/xt_policy.h [ver #3]
To: torvalds@osdl.org
Cc: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
        David Howells <dhowells@redhat.com>
Date: Thu, 28 Jul 2011 16:52:32 +0100
Message-ID: <20110728155232.16618.76970.stgit@warthog.procyon.org.uk>
In-Reply-To: <20110728154920.16618.89358.stgit@warthog.procyon.org.uk>
References: <20110728154920.16618.89358.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix up linux/netfilter/xt_policy.h to make it splittable.  This requires a
mark to be placed on the #ifdef __KERNEL__ in struct xt_policy_elem to tell
the splitter to ignore it.

Would it be possible, I wonder, to rename union nf_inet_addr to xt_policy_addr
instead?

Signed-off-by: David Howells <dhowells@redhat.com>
---

 include/linux/netfilter/xt_policy.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/netfilter/xt_policy.h b/include/linux/netfilter/xt_policy.h
index be8ead0..573da52 100644
--- a/include/linux/netfilter/xt_policy.h
+++ b/include/linux/netfilter/xt_policy.h
@@ -35,7 +35,7 @@ union xt_policy_addr {
 
 struct xt_policy_elem {
 	union {
-#ifdef __KERNEL__
+#ifdef __KERNEL__ // DISINTEGRATE: RETAIN
 		struct {
 			union nf_inet_addr saddr;
 			union nf_inet_addr smask;

