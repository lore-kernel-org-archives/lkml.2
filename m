Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965235Ab1C3VJw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:09:52 -0400
Received: from mga01.intel.com ([192.55.52.88]:24598 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965221Ab1C3VJs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:09:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="673448683"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: Trond.Myklebust@netapp.com, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [240/275] SUNRPC: Never reuse the socket port after an xs_close()
Message-Id: <20110330210806.629EC3E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:08:06 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Trond Myklebust <Trond.Myklebust@netapp.com>

commit 246408dcd5dfeef2df437ccb0ef4d6ee87805f58 upstream.

If we call xs_close(), we're in one of two situations:
 - Autoclose, which means we don't expect to resend a request
 - bind+connect failed, which probably means the port is in use

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 net/sunrpc/xprtsock.c |    2 ++
 1 file changed, 2 insertions(+)

Index: linux-2.6.35.y/net/sunrpc/xprtsock.c
===================================================================
--- linux-2.6.35.y.orig/net/sunrpc/xprtsock.c	2011-03-29 22:50:17.446811999 -0700
+++ linux-2.6.35.y/net/sunrpc/xprtsock.c	2011-03-29 23:03:03.211218003 -0700
@@ -710,6 +710,8 @@
 	if (sk == NULL)
 		return;
 
+	transport->srcport = 0;
+
 	write_lock_bh(&sk->sk_callback_lock);
 	transport->inet = NULL;
 	transport->sock = NULL;
