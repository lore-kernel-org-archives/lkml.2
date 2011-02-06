Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751789Ab1BFAQD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Feb 2011 19:16:03 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:38033 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751572Ab1BFAQB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Feb 2011 19:16:01 -0500
MIME-Version: 1.0
Date: Sun, 6 Feb 2011 00:15:58 +0000
Message-ID: <AANLkTikj+FU8OF_-KFr2hmTSWqTHMK5JnrnTVyn-XtxQ@mail.gmail.com>
Subject: [PATCH] printk-formats.txt documentation update
From: Andrew Murray <amurray@mpcdata.com>
To: linux-embedded@vger.kernel.org
Cc: linux kernel <linux-kernel@vger.kernel.org>, trivial@kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Murray <amurray@mpc-data.co.uk>

This patch updates the incomplete documentation concerning the printk
extended format specifiers.

Signed-off-by: Andrew Murray <amurray@mpc-data.co.uk>
---
diff --git a/Documentation/printk-formats.txt b/Documentation/printk-formats.txt
index 1b5a5dd..df14336 100644
--- a/Documentation/printk-formats.txt
+++ b/Documentation/printk-formats.txt
@@ -9,7 +9,42 @@ If variable is of Type,		use printk format specifier:
 		size_t			%zu or %zx
 		ssize_t			%zd or %zx

-Raw pointer value SHOULD be printed with %p.
+Raw pointer value SHOULD be printed with %p. The kernel supports
+the following extended format specifiers for pointer types:
+
+	General:
+
+	%pF	function pointer with offset, e.g. module_start
+	%pf	function pointer without offset, e.g. module_start+0x0/0x62 [hello]
+	%pS	text symbol with offset	
+	%ps	text symbol without offset
+	%pR	struct resource with decoded flags, e.g. [mem 0x0-0x1f 64 bit pref]
+	%pr	struct resource with raw flags, e.g. [mem 0x0-0x1f flags 0x201]
+
+	MAC/FDDI addresses:
+	
+	%pM	colon-seperated 6-byte MAC address in hex notation, e.g. 00:01:02:03:04:05
+	%pm	non-colon-seperated 6-byte MAC address is hex notation, e.g. 000102030405
+	%pMF	6-byte dash-separated FDDI hex notation
+
+	IPv4 addresses:
+
+	%pI4	IPv4 dot-seperated decimal without leading 0's, e.g. 1.2.3.4
+	%pi4	IPv4 dot-seperated decimal with leading 0's, 001.002.003.004
+	%p[Ii]4[hl] IPv4 dot-seperated decimal with/without leading 0's for
+		host (h), little (l) or network/big (default) endian order
+
+	IPv6 addresses:
+	%pI6	IPv6 colon-seperated network-order 16 bit hex with leading 0's,
+		e.g. 0001:0203:...:0708
+	%pi6	IPv6 non-colon-seperated network-order 16 bit hex with leading 0's,
+		e.g. 000102...0f
+	%pI6c	IPv6 address as described by
+		http://tools.ietf.org/html/draft-ietf-6man-text-addr-representation-00,
+		e.g. 1::708
+
+	%pU[bBlL] 16 byte UUID/GUID in big or little endian using lower or upper case
+

 u64 SHOULD be printed with %llu/%llx, (unsigned long long):
