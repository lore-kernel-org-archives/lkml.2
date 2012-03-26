Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932478Ab2CZN1H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 09:27:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54981 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754070Ab2CZN1G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 09:27:06 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] SELinux: selinux/xfrm.h needs net/flow.h
To: james.l.morris@oracle.com
Cc: akpm@linux-foundation.org, selinux@tycho.nsa.gov,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 26 Mar 2012 14:26:55 +0100
Message-ID: <20120326132655.24476.66795.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

selinux/xfrm.h needs to #include net/flow.h or else suffer:

In file included from security/selinux/ss/services.c:69:0:
security/selinux/include/xfrm.h: In function 'selinux_xfrm_notify_policyload':
security/selinux/include/xfrm.h:53:14: error: 'flow_cache_genid' undeclared (first use in this function)
security/selinux/include/xfrm.h:53:14: note: each undeclared identifier is reported only once for each function it appears in

Signed-off-by: David Howells <dhowells@redhat.com>
---

 security/selinux/include/xfrm.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/security/selinux/include/xfrm.h b/security/selinux/include/xfrm.h
index b43813c..c220f31 100644
--- a/security/selinux/include/xfrm.h
+++ b/security/selinux/include/xfrm.h
@@ -7,6 +7,8 @@
 #ifndef _SELINUX_XFRM_H_
 #define _SELINUX_XFRM_H_
 
+#include <net/flow.h>
+
 int selinux_xfrm_policy_alloc(struct xfrm_sec_ctx **ctxp,
 			      struct xfrm_user_sec_ctx *sec_ctx);
 int selinux_xfrm_policy_clone(struct xfrm_sec_ctx *old_ctx,

