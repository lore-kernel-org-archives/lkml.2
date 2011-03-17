Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932069Ab1CQXfo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 19:35:44 -0400
Received: from mga02.intel.com ([134.134.136.20]:16188 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755816Ab1CQXfm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 19:35:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,202,1299484800"; 
   d="scan'208";a="614397544"
From: "Hefty, Sean" <sean.hefty@intel.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, Roland Dreier <roland@kernel.org>
CC: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Hal Rosenstock <hal.rosenstock@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>, Tejun Heo <tj@kernel.org>,
        Changli Gao <xiaosuo@gmail.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Date: Thu, 17 Mar 2011 16:35:39 -0700
Subject: [PATCH] rdma/addr: Initialize ret to fix build warning
Thread-Topic: [PATCH] rdma/addr: Initialize ret to fix build warning
Thread-Index: Acvk98IjBDuhv7TdS6mcFzXI6vJBqgAAbKBw
Message-ID: <CF9C39F99A89134C9CF9C4CCB68B8DDF25CCC10249@orsmsx501.amr.corp.intel.com>
References: <20110318100418.6556c92c.sfr@canb.auug.org.au>
In-Reply-To: <20110318100418.6556c92c.sfr@canb.auug.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit b23dd4fe42b455af5c6e20966b7d6959fa8352ea (ipv4: Make output
route lookup return rtable directly) resulted in leaving
ret uninitialized, where it may later be returned.

Signed-off-by: Sean Hefty <sean.hefty@intel.com>
---
I didn't actually test this, but it looks correct.

 drivers/infiniband/core/addr.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/core/addr.c b/drivers/infiniband/core/addr.c
index e0ef5fd..4ffc224 100644
--- a/drivers/infiniband/core/addr.c
+++ b/drivers/infiniband/core/addr.c
@@ -204,7 +204,7 @@ static int addr4_resolve(struct sockaddr_in *src_in,
 
 	/* If the device does ARP internally, return 'done' */
 	if (rt->dst.dev->flags & IFF_NOARP) {
-		rdma_copy_addr(addr, rt->dst.dev, NULL);
+		ret = rdma_copy_addr(addr, rt->dst.dev, NULL);
 		goto put;
 	}
 


