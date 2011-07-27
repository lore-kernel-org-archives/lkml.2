Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755788Ab1G0Vth (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 17:49:37 -0400
Received: from mga03.intel.com ([143.182.124.21]:51515 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755025Ab1G0Vta (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 17:49:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,279,1309762800"; 
   d="scan'208";a="32274937"
From: Andi Kleen <andi@firstfloor.org>
References: <20110727247.325703029@firstfloor.org>
In-Reply-To: <20110727247.325703029@firstfloor.org>
To: joe@perches.com, davem@davemloft.net, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [90/99] net: filter: Use WARN_RATELIMIT
Message-Id: <20110727214929.E40172403FF@tassilo.jf.intel.com>
Date: Wed, 27 Jul 2011 14:49:29 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Joe Perches <joe@perches.com>

[ Upstream commit 6c4a5cb219520c7bc937ee186ca53f03733bd09f ]

A mis-configured filter can spam the logs with lots of stack traces.

Rate-limit the warnings and add printout of the bogus filter information.

Original-patch-by: Ben Greear <greearb@candelatech.com>
Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 net/core/filter.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

Index: linux-2.6.35.y/net/core/filter.c
===================================================================
--- linux-2.6.35.y.orig/net/core/filter.c
+++ linux-2.6.35.y/net/core/filter.c
@@ -292,7 +292,9 @@ load_b:
 			mem[f_k] = X;
 			continue;
 		default:
-			WARN_ON(1);
+			WARN_RATELIMIT(1, "Unknown code:%u jt:%u tf:%u k:%u\n",
+				       fentry->code, fentry->jt,
+				       fentry->jf, fentry->k);
 			return 0;
 		}
 
