Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932655Ab1DZVX1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 17:23:27 -0400
Received: from mga01.intel.com ([192.55.52.88]:1301 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932437Ab1DZVOt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 17:14:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,270,1301900400"; 
   d="scan'208";a="914748830"
From: Andi Kleen <andi@firstfloor.org>
References: <20110426212.641772347@firstfloor.org>
In-Reply-To: <20110426212.641772347@firstfloor.org>
To: kees.cook@canonical.com, davem@davemloft.net, gregkh@suse.de,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org,
        tim.bird@am.sony.com
Subject: [PATCH] [79/106] net: ax25: fix information leak to userland harder
Message-Id: <20110426211400.E0BF13E1886@tassilo.jf.intel.com>
Date: Tue, 26 Apr 2011 14:14:00 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Kees Cook <kees.cook@canonical.com>

commit 5b919f833d9d60588d026ad82d17f17e8872c7a9 upstream.

Commit fe10ae53384e48c51996941b7720ee16995cbcb7 adds a memset() to clear
the structure being sent back to userspace, but accidentally used the
wrong size.

Reported-by: Brad Spengler <spender@grsecurity.net>
Signed-off-by: Kees Cook <kees.cook@canonical.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 net/ax25/af_ax25.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.35.y/net/ax25/af_ax25.c
===================================================================
--- linux-2.6.35.y.orig/net/ax25/af_ax25.c
+++ linux-2.6.35.y/net/ax25/af_ax25.c
@@ -1392,7 +1392,7 @@ static int ax25_getname(struct socket *s
 	ax25_cb *ax25;
 	int err = 0;
 
-	memset(fsa, 0, sizeof(fsa));
+	memset(fsa, 0, sizeof(*fsa));
 	lock_sock(sk);
 	ax25 = ax25_sk(sk);
 
