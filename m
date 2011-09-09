Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757955Ab1IIBMP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 21:12:15 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:31185 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757888Ab1IIBLr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 21:11:47 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6463"; a="116679310"
Message-Id: <20110909010918.150375980@codeaurora.org>
User-Agent: quilt/0.48-1
Date: Thu, 08 Sep 2011 20:09:23 -0500
From: Richard Kuo <rkuo@codeaurora.org>
To: linux-arch@vger.kernel.org, linux-hexagon@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Linas Vepstas <linas@codeaurora.org>, Arnd Bergmann <arnd@arndb.de>
Subject: [patch v3 36/36] Add extra arch overrides to asm-generic/checksum.h
References: <20110909010847.294039464@codeaurora.org>
Content-Disposition: inline; filename=generic-checksum.diff
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
 1 file changed, 4 insertions(+)

Index: linux-hexagon-kernel/include/asm-generic/checksum.h
===================================================================
--- linux-hexagon-kernel.orig/include/asm-generic/checksum.h	2011-09-03 20:14:46.214943511 -0500
+++ linux-hexagon-kernel/include/asm-generic/checksum.h	2011-09-03 20:14:59.874981811 -0500
@@ -33,8 +33,10 @@
 extern __wsum csum_partial_copy_from_user(const void __user *src, void *dst,
 					int len, __wsum sum, int *csum_err);
 
+#ifndef csum_partial_copy_nocheck
 #define csum_partial_copy_nocheck(src, dst, len, sum)	\
 	csum_partial_copy((src), (dst), (len), (sum))
+#endif
 
 /*
  * This is a version of ip_compute_csum() optimized for IP headers,
@@ -63,12 +65,14 @@
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

