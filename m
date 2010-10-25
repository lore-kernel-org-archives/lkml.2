Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756340Ab0JYOnZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 10:43:25 -0400
Received: from mta-2.ms.rz.RWTH-Aachen.DE ([134.130.7.73]:64987 "EHLO
	mta-2.ms.rz.rwth-aachen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756245Ab0JYOnX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 10:43:23 -0400
Content-transfer-encoding: 7BIT
X-IronPort-AV: E=Sophos;i="4.58,236,1286143200";   d="scan'208";a="78392581"
From: Arnd Hannemann <arnd@arndnet.de>
To: "David S. Miller" <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, Arnd Hannemann <arnd@arndnet.de>
Subject: [PATCH] net: b43legacy: fix compile error
Date: Mon, 25 Oct 2010 16:41:30 +0200
Message-id: <1288017690-31248-1-git-send-email-arnd@arndnet.de>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On todays linus tree the following compile error happened to me:

  CC [M]  drivers/net/wireless/b43legacy/xmit.o
In file included from include/net/dst.h:11,
                 from drivers/net/wireless/b43legacy/xmit.c:31:
include/net/dst_ops.h:28: error: expected ':', ',', ';', '}' or '__attribute__' before '____cacheline_aligned_in_smp'
include/net/dst_ops.h: In function 'dst_entries_get_fast':
include/net/dst_ops.h:33: error: 'struct dst_ops' has no member named 'pcpuc_entries'
include/net/dst_ops.h: In function 'dst_entries_get_slow':
include/net/dst_ops.h:41: error: 'struct dst_ops' has no member named 'pcpuc_entries'
include/net/dst_ops.h: In function 'dst_entries_add':
include/net/dst_ops.h:49: error: 'struct dst_ops' has no member named 'pcpuc_entries'
include/net/dst_ops.h: In function 'dst_entries_init':
include/net/dst_ops.h:55: error: 'struct dst_ops' has no member named 'pcpuc_entries'
include/net/dst_ops.h: In function 'dst_entries_destroy':
include/net/dst_ops.h:60: error: 'struct dst_ops' has no member named 'pcpuc_entries'
make[4]: *** [drivers/net/wireless/b43legacy/xmit.o] Error 1
make[3]: *** [drivers/net/wireless/b43legacy] Error 2
make[2]: *** [drivers/net/wireless] Error 2
make[1]: *** [drivers/net] Error 2
make: *** [drivers] Error 2

This patch fixes this issue by adding "linux/cache.h" as an include to
"include/net/dst_ops.h".

Signed-off-by: Arnd Hannemann <arnd@arndnet.de>
---
 include/net/dst_ops.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/net/dst_ops.h b/include/net/dst_ops.h
index 1fa5306..51665b3 100644
--- a/include/net/dst_ops.h
+++ b/include/net/dst_ops.h
@@ -2,6 +2,7 @@
 #define _NET_DST_OPS_H
 #include <linux/types.h>
 #include <linux/percpu_counter.h>
+#include <linux/cache.h>
 
 struct dst_entry;
 struct kmem_cachep;
-- 
1.7.0.4

