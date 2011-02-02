Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753475Ab1BBBC1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 20:02:27 -0500
Received: from mga03.intel.com ([143.182.124.21]:11107 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753220Ab1BBAoE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 19:44:04 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,412,1291622400"; 
   d="scan'208";a="382960567"
From: Andi Kleen <andi@firstfloor.org>
References: <20110201443.618138584@firstfloor.org>
In-Reply-To: <20110201443.618138584@firstfloor.org>
To: davem@davemloft.net, ak@linux.intel.com, linux-kernel@vger.kernel.org,
        stable@kernel.org
Subject: [PATCH] [58/139] net: Export cred_to_ucred to modules.
Message-Id: <20110202004414.8590A3E09BD@tassilo.jf.intel.com>
Date: Tue,  1 Feb 2011 16:44:14 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
Upstream commit 3924773a5a82622167524bdd48799dc0452c57f8

AF_UNIX references this, and can be built as a module,
so...

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

Index: linux-2.6.35.y/net/core/sock.c
===================================================================
--- linux-2.6.35.y.orig/net/core/sock.c
+++ linux-2.6.35.y/net/core/sock.c
@@ -762,6 +762,7 @@ void cred_to_ucred(struct pid *pid, cons
 		ucred->gid = user_ns_map_gid(current_ns, cred, cred->egid);
 	}
 }
+EXPORT_SYMBOL_GPL(cred_to_ucred);
 
 int sock_getsockopt(struct socket *sock, int level, int optname,
 		    char __user *optval, int __user *optlen)
