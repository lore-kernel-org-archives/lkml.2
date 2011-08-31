Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932075Ab1HaWfc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 18:35:32 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:17909 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756971Ab1HaWfb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 18:35:31 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6455"; a="114262074"
Date: Wed, 31 Aug 2011 17:35:19 -0500
From: "Linas Vepstas (Code Aurora)" <linas@codeaurora.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] asm-generic: over-ride csum_partial_copy_nocheck, etc.
Message-ID: <20110831223519.GA14535@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


There are plausbile reasons for architectures to provide their own
versions of csum_partial_copy_nocheck and csum_tcpudp_magic. 
By protecting these, the architecture can still re-use the 
asm-generic checksum.h, instead of copying it.

Signed-off-by: Linas Vepstas <linas@codeaurora.org>

---
 include/asm-generic/checksum.h |    4 ++++
 1 file changed, 4 insertions(+)

Index: linux-hexagon-kernel/include/asm-generic/checksum.h
===================================================================
--- linux-hexagon-kernel.orig/include/asm-generic/checksum.h	2011-08-31 15:31:33.000000000 -0500
+++ linux-hexagon-kernel/include/asm-generic/checksum.h	2011-08-31 15:43:35.000000000 -0500
@@ -33,8 +33,10 @@ extern __wsum csum_partial_copy(const vo
 extern __wsum csum_partial_copy_from_user(const void __user *src, void *dst,
 					int len, __wsum sum, int *csum_err);
 
+#ifndef csum_partial_copy_nocheck
 #define csum_partial_copy_nocheck(src, dst, len, sum)	\
 	csum_partial_copy((src), (dst), (len), (sum))
+#endif
 
 /*
  * This is a version of ip_compute_csum() optimized for IP headers,
@@ -63,12 +65,14 @@ csum_tcpudp_nofold(__be32 saddr, __be32 
 		unsigned short proto, __wsum sum);
 #endif
 
+#ifndef csum_tcpudp_magic
 static inline __sum16
 csum_tcpudp_magic(__be32 saddr, __be32 daddr, unsigned short len,
 		  unsigned short proto, __wsum sum)
 {
 	return csum_fold(csum_tcpudp_nofold(saddr, daddr, len, proto, sum));
 }
+#endif
 
 /*
  * this routine is used for miscellaneous IP-like checksums, mainly
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
