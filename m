Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933031Ab1IQArS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 20:47:18 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:16483 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932810Ab1IQArP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 20:47:15 -0400
Message-Id: <e97c6e$3hno2c@wolverine02.qualcomm.com>
X-IronPort-AV: E=McAfee;i="5400,1158,6471"; a="119267404"
From: Richard Kuo <rkuo@codeaurora.org>
Date: Wed, 14 Sep 2011 13:19:20 -0500
Subject: [PATCH v4 36/36] Add extra arch overrides to asm-generic/checksum.h
To: linux-arch@vger.kernel.org, linux-hexagon@vger.kernel.org,
        linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are plausible reasons for architectures to provide their own
versions of csum_partial_copy_nocheck and csum_tcpudp_magic.
By protecting these, the architecture can still re-use the
asm-generic checksum.h, instead of copying it.

Signed-off-by: Linas Vepstas <linas@codeaurora.org>
Acked-by: Arnd Bergmann <arnd@arndb.de>
---
 include/asm-generic/checksum.h |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/include/asm-generic/checksum.h b/include/asm-generic/checksum.h
index 4647c76..c084767 100644
--- a/include/asm-generic/checksum.h
+++ b/include/asm-generic/checksum.h
@@ -33,8 +33,10 @@ extern __wsum csum_partial_copy(const void *src, void *dst, int len, __wsum sum)
 extern __wsum csum_partial_copy_from_user(const void __user *src, void *dst,
 					int len, __wsum sum, int *csum_err);
 
+#ifndef csum_partial_copy_nocheck
 #define csum_partial_copy_nocheck(src, dst, len, sum)	\
 	csum_partial_copy((src), (dst), (len), (sum))
+#endif
 
 /*
  * This is a version of ip_compute_csum() optimized for IP headers,
@@ -63,12 +65,14 @@ csum_tcpudp_nofold(__be32 saddr, __be32 daddr, unsigned short len,
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
1.7.1


--

Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
