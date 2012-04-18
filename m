Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753717Ab2DRQz6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 12:55:58 -0400
Received: from mailfw02.zoner.fi ([84.34.147.249]:65477 "EHLO
	mailfw02.zoner.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751102Ab2DRQz5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 12:55:57 -0400
Date: Wed, 18 Apr 2012 19:55:44 +0300
From: Lasse Collin <lasse.collin@tukaani.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jan Beulich <JBeulich@suse.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] xz: Enable BCJ filters on SPARC and 32-bit x86
Message-ID: <20120418195544.586415a6@tukaani.org>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Antivirus-Scanner: Clean mail though you should still use an Antivirus
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lasse Collin <lasse.collin@tukaani.org>

The BCJ filters were meant to be enabled already on these
archs, but the xz_wrap.sh script was buggy. Enabling the
filters should give smaller kernel images.

xz_wrap.sh will now use $SRCARCH instead of $ARCH to detect
the architecture. That way it doesn't need to care about the
subarchs (like i386 vs. x86_64) since the BCJ filters don't
care either.

Signed-off-by: Lasse Collin <lasse.collin@tukaani.org>
Acked-by: Jan Beulich <jbeulich@suse.com>
---

diff -uprN linux-3.3.orig/scripts/xz_wrap.sh linux-3.3/scripts/xz_wrap.sh
--- linux-3.3.orig/scripts/xz_wrap.sh	2012-03-19 01:15:34.000000000 +0200
+++ linux-3.3/scripts/xz_wrap.sh	2012-03-19 11:20:55.289074991 +0200
@@ -12,8 +12,8 @@
 BCJ=
 LZMA2OPTS=
 
-case $ARCH in
-	x86|x86_64)     BCJ=--x86 ;;
+case $SRCARCH in
+	x86)            BCJ=--x86 ;;
 	powerpc)        BCJ=--powerpc ;;
 	ia64)           BCJ=--ia64; LZMA2OPTS=pb=4 ;;
 	arm)            BCJ=--arm ;;
