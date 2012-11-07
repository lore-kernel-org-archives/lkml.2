Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754340Ab2KGJxa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 04:53:30 -0500
Received: from vaxjo.synopsys.com ([198.182.60.75]:52587 "EHLO
	vaxjo.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754027Ab2KGJsV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 04:48:21 -0500
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, arnd@arndb.de,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>
Subject: [RFC PATCH v1 06/31] asm-generic headers: Allow yet more arch overrides in checksum.h
Date: Wed,  7 Nov 2012 10:47:29 +0100
Message-Id: <1352281674-2186-7-git-send-email-vgupta@synopsys.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1352281674-2186-1-git-send-email-vgupta@synopsys.com>
References: <1352281674-2186-1-git-send-email-vgupta@synopsys.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

arches can have more efficient implementation of these routines

Acked-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
---
 include/asm-generic/checksum.h |    4 ++++
 lib/checksum.c                 |    2 ++
 2 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/include/asm-generic/checksum.h b/include/asm-generic/checksum.h
index c084767..59811df 100644
--- a/include/asm-generic/checksum.h
+++ b/include/asm-generic/checksum.h
@@ -38,12 +38,15 @@ extern __wsum csum_partial_copy_from_user(const void __user *src, void *dst,
 	csum_partial_copy((src), (dst), (len), (sum))
 #endif
 
+#ifndef ip_fast_csum
 /*
  * This is a version of ip_compute_csum() optimized for IP headers,
  * which always checksum on 4 octet boundaries.
  */
 extern __sum16 ip_fast_csum(const void *iph, unsigned int ihl);
+#endif
 
+#ifndef csum_fold
 /*
  * Fold a partial checksum
  */
@@ -54,6 +57,7 @@ static inline __sum16 csum_fold(__wsum csum)
 	sum = (sum & 0xffff) + (sum >> 16);
 	return (__force __sum16)~sum;
 }
+#endif
 
 #ifndef csum_tcpudp_nofold
 /*
diff --git a/lib/checksum.c b/lib/checksum.c
index 12dceb2..129775e 100644
--- a/lib/checksum.c
+++ b/lib/checksum.c
@@ -102,6 +102,7 @@ out:
 }
 #endif
 
+#ifndef ip_fast_csum
 /*
  *	This is a version of ip_compute_csum() optimized for IP headers,
  *	which always checksum on 4 octet boundaries.
@@ -111,6 +112,7 @@ __sum16 ip_fast_csum(const void *iph, unsigned int ihl)
 	return (__force __sum16)~do_csum(iph, ihl*4);
 }
 EXPORT_SYMBOL(ip_fast_csum);
+#endif
 
 /*
  * computes the checksum of a memory block at buff, length len,
-- 
1.7.4.1

