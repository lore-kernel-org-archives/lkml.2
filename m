Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031149Ab2COPpM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 11:45:12 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:65173 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030466Ab2COPpK convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:2:1>);
	Thu, 15 Mar 2012 11:45:10 -0400
Message-Id: <4F621C930200007800078B9E@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Thu, 15 Mar 2012 15:45:07 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: <lasse.collin@tukaani.org>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] xz: make use of BCJ filter also for 32-bit x86 kernel
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ARCH value for 32-bit x86 is not x86, but i?86.

This reduces the image sizes of the kernels I routinely build by almost
100k (surprisingly much, to me at least).

Signed-off-by: Jan Beulich <jbeulich@suse.com>

---
 scripts/xz_wrap.sh |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- 3.3-rc7/scripts/xz_wrap.sh
+++ 3.3-rc7-xz-bcj-ix86/scripts/xz_wrap.sh
@@ -13,7 +13,7 @@ BCJ=
 LZMA2OPTS=
 
 case $ARCH in
-	x86|x86_64)     BCJ=--x86 ;;
+	i?86|x86_64)    BCJ=--x86 ;;
 	powerpc)        BCJ=--powerpc ;;
 	ia64)           BCJ=--ia64; LZMA2OPTS=pb=4 ;;
 	arm)            BCJ=--arm ;;



