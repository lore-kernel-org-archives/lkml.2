Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755962Ab0IJQpl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 12:45:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31765 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755938Ab0IJQpj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 12:45:39 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 03/17] Blackfin: Rename DES PC2() symbol to avoid collision
To: linux-arch@vger.kernel.org
Cc: torvalds@osdl.org, linux-kernel@vger.kernel.org,
        David Howells <dhowells@redhat.com>,
        Mike Frysinger <vapier@gentoo.org>
Date: Fri, 10 Sep 2010 17:10:18 +0100
Message-ID: <20100910161017.20226.91219.stgit@warthog.procyon.org.uk>
In-Reply-To: <20100910161002.20226.27995.stgit@warthog.procyon.org.uk>
References: <20100910161002.20226.27995.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename the PC2() symbol in the generic DES crypto module to be prefixed with
DES_ to avoid collision with arch code (Blackfin in this case).

Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---

 crypto/des_generic.c |  130 +++++++++++++++++++++++++-------------------------
 1 files changed, 65 insertions(+), 65 deletions(-)

diff --git a/crypto/des_generic.c b/crypto/des_generic.c
index 249f903..873818d 100644
--- a/crypto/des_generic.c
+++ b/crypto/des_generic.c
@@ -614,7 +614,7 @@ static const u32 S8[64] = {
 #define T3(x) pt[2 * (x) + 2]
 #define T4(x) pt[2 * (x) + 3]
 
-#define PC2(a, b, c, d) (T4(d) | T3(c) | T2(b) | T1(a))
+#define DES_PC2(a, b, c, d) (T4(d) | T3(c) | T2(b) | T1(a))
 
 /*
  * Encryption key expansion
@@ -639,22 +639,22 @@ unsigned long des_ekey(u32 *pe, const u8 *k)
 	b = k[6]; b &= 0x0e; b <<= 4; b |= k[2] & 0x1e; b = pc1[b];
 	a = k[7]; a &= 0x0e; a <<= 4; a |= k[3] & 0x1e; a = pc1[a];
 
-	pe[15 * 2 + 0] = PC2(a, b, c, d); d = rs[d];
-	pe[14 * 2 + 0] = PC2(d, a, b, c); c = rs[c]; b = rs[b];
-	pe[13 * 2 + 0] = PC2(b, c, d, a); a = rs[a]; d = rs[d];
-	pe[12 * 2 + 0] = PC2(d, a, b, c); c = rs[c]; b = rs[b];
-	pe[11 * 2 + 0] = PC2(b, c, d, a); a = rs[a]; d = rs[d];
-	pe[10 * 2 + 0] = PC2(d, a, b, c); c = rs[c]; b = rs[b];
-	pe[ 9 * 2 + 0] = PC2(b, c, d, a); a = rs[a]; d = rs[d];
-	pe[ 8 * 2 + 0] = PC2(d, a, b, c); c = rs[c];
-	pe[ 7 * 2 + 0] = PC2(c, d, a, b); b = rs[b]; a = rs[a];
-	pe[ 6 * 2 + 0] = PC2(a, b, c, d); d = rs[d]; c = rs[c];
-	pe[ 5 * 2 + 0] = PC2(c, d, a, b); b = rs[b]; a = rs[a];
-	pe[ 4 * 2 + 0] = PC2(a, b, c, d); d = rs[d]; c = rs[c];
-	pe[ 3 * 2 + 0] = PC2(c, d, a, b); b = rs[b]; a = rs[a];
-	pe[ 2 * 2 + 0] = PC2(a, b, c, d); d = rs[d]; c = rs[c];
-	pe[ 1 * 2 + 0] = PC2(c, d, a, b); b = rs[b];
-	pe[ 0 * 2 + 0] = PC2(b, c, d, a);
+	pe[15 * 2 + 0] = DES_PC2(a, b, c, d); d = rs[d];
+	pe[14 * 2 + 0] = DES_PC2(d, a, b, c); c = rs[c]; b = rs[b];
+	pe[13 * 2 + 0] = DES_PC2(b, c, d, a); a = rs[a]; d = rs[d];
+	pe[12 * 2 + 0] = DES_PC2(d, a, b, c); c = rs[c]; b = rs[b];
+	pe[11 * 2 + 0] = DES_PC2(b, c, d, a); a = rs[a]; d = rs[d];
+	pe[10 * 2 + 0] = DES_PC2(d, a, b, c); c = rs[c]; b = rs[b];
+	pe[ 9 * 2 + 0] = DES_PC2(b, c, d, a); a = rs[a]; d = rs[d];
+	pe[ 8 * 2 + 0] = DES_PC2(d, a, b, c); c = rs[c];
+	pe[ 7 * 2 + 0] = DES_PC2(c, d, a, b); b = rs[b]; a = rs[a];
+	pe[ 6 * 2 + 0] = DES_PC2(a, b, c, d); d = rs[d]; c = rs[c];
+	pe[ 5 * 2 + 0] = DES_PC2(c, d, a, b); b = rs[b]; a = rs[a];
+	pe[ 4 * 2 + 0] = DES_PC2(a, b, c, d); d = rs[d]; c = rs[c];
+	pe[ 3 * 2 + 0] = DES_PC2(c, d, a, b); b = rs[b]; a = rs[a];
+	pe[ 2 * 2 + 0] = DES_PC2(a, b, c, d); d = rs[d]; c = rs[c];
+	pe[ 1 * 2 + 0] = DES_PC2(c, d, a, b); b = rs[b];
+	pe[ 0 * 2 + 0] = DES_PC2(b, c, d, a);
 
 	/* Check if first half is weak */
 	w  = (a ^ c) | (b ^ d) | (rs[a] ^ c) | (b ^ rs[d]);
@@ -670,22 +670,22 @@ unsigned long des_ekey(u32 *pe, const u8 *k)
 	/* Check if second half is weak */
 	w |= (a ^ c) | (b ^ d) | (rs[a] ^ c) | (b ^ rs[d]);
 
-	pe[15 * 2 + 1] = PC2(a, b, c, d); d = rs[d];
-	pe[14 * 2 + 1] = PC2(d, a, b, c); c = rs[c]; b = rs[b];
-	pe[13 * 2 + 1] = PC2(b, c, d, a); a = rs[a]; d = rs[d];
-	pe[12 * 2 + 1] = PC2(d, a, b, c); c = rs[c]; b = rs[b];
-	pe[11 * 2 + 1] = PC2(b, c, d, a); a = rs[a]; d = rs[d];
-	pe[10 * 2 + 1] = PC2(d, a, b, c); c = rs[c]; b = rs[b];
-	pe[ 9 * 2 + 1] = PC2(b, c, d, a); a = rs[a]; d = rs[d];
-	pe[ 8 * 2 + 1] = PC2(d, a, b, c); c = rs[c];
-	pe[ 7 * 2 + 1] = PC2(c, d, a, b); b = rs[b]; a = rs[a];
-	pe[ 6 * 2 + 1] = PC2(a, b, c, d); d = rs[d]; c = rs[c];
-	pe[ 5 * 2 + 1] = PC2(c, d, a, b); b = rs[b]; a = rs[a];
-	pe[ 4 * 2 + 1] = PC2(a, b, c, d); d = rs[d]; c = rs[c];
-	pe[ 3 * 2 + 1] = PC2(c, d, a, b); b = rs[b]; a = rs[a];
-	pe[ 2 * 2 + 1] = PC2(a, b, c, d); d = rs[d]; c = rs[c];
-	pe[ 1 * 2 + 1] = PC2(c, d, a, b); b = rs[b];
-	pe[ 0 * 2 + 1] = PC2(b, c, d, a);
+	pe[15 * 2 + 1] = DES_PC2(a, b, c, d); d = rs[d];
+	pe[14 * 2 + 1] = DES_PC2(d, a, b, c); c = rs[c]; b = rs[b];
+	pe[13 * 2 + 1] = DES_PC2(b, c, d, a); a = rs[a]; d = rs[d];
+	pe[12 * 2 + 1] = DES_PC2(d, a, b, c); c = rs[c]; b = rs[b];
+	pe[11 * 2 + 1] = DES_PC2(b, c, d, a); a = rs[a]; d = rs[d];
+	pe[10 * 2 + 1] = DES_PC2(d, a, b, c); c = rs[c]; b = rs[b];
+	pe[ 9 * 2 + 1] = DES_PC2(b, c, d, a); a = rs[a]; d = rs[d];
+	pe[ 8 * 2 + 1] = DES_PC2(d, a, b, c); c = rs[c];
+	pe[ 7 * 2 + 1] = DES_PC2(c, d, a, b); b = rs[b]; a = rs[a];
+	pe[ 6 * 2 + 1] = DES_PC2(a, b, c, d); d = rs[d]; c = rs[c];
+	pe[ 5 * 2 + 1] = DES_PC2(c, d, a, b); b = rs[b]; a = rs[a];
+	pe[ 4 * 2 + 1] = DES_PC2(a, b, c, d); d = rs[d]; c = rs[c];
+	pe[ 3 * 2 + 1] = DES_PC2(c, d, a, b); b = rs[b]; a = rs[a];
+	pe[ 2 * 2 + 1] = DES_PC2(a, b, c, d); d = rs[d]; c = rs[c];
+	pe[ 1 * 2 + 1] = DES_PC2(c, d, a, b); b = rs[b];
+	pe[ 0 * 2 + 1] = DES_PC2(b, c, d, a);
 
 	/* Fixup: 2413 5768 -> 1357 2468 */
 	for (d = 0; d < 16; ++d) {
@@ -722,22 +722,22 @@ static void dkey(u32 *pe, const u8 *k)
 	b = k[6]; b &= 0x0e; b <<= 4; b |= k[2] & 0x1e; b = pc1[b];
 	a = k[7]; a &= 0x0e; a <<= 4; a |= k[3] & 0x1e; a = pc1[a];
 
-	pe[ 0 * 2] = PC2(a, b, c, d); d = rs[d];
-	pe[ 1 * 2] = PC2(d, a, b, c); c = rs[c]; b = rs[b];
-	pe[ 2 * 2] = PC2(b, c, d, a); a = rs[a]; d = rs[d];
-	pe[ 3 * 2] = PC2(d, a, b, c); c = rs[c]; b = rs[b];
-	pe[ 4 * 2] = PC2(b, c, d, a); a = rs[a]; d = rs[d];
-	pe[ 5 * 2] = PC2(d, a, b, c); c = rs[c]; b = rs[b];
-	pe[ 6 * 2] = PC2(b, c, d, a); a = rs[a]; d = rs[d];
-	pe[ 7 * 2] = PC2(d, a, b, c); c = rs[c];
-	pe[ 8 * 2] = PC2(c, d, a, b); b = rs[b]; a = rs[a];
-	pe[ 9 * 2] = PC2(a, b, c, d); d = rs[d]; c = rs[c];
-	pe[10 * 2] = PC2(c, d, a, b); b = rs[b]; a = rs[a];
-	pe[11 * 2] = PC2(a, b, c, d); d = rs[d]; c = rs[c];
-	pe[12 * 2] = PC2(c, d, a, b); b = rs[b]; a = rs[a];
-	pe[13 * 2] = PC2(a, b, c, d); d = rs[d]; c = rs[c];
-	pe[14 * 2] = PC2(c, d, a, b); b = rs[b];
-	pe[15 * 2] = PC2(b, c, d, a);
+	pe[ 0 * 2] = DES_PC2(a, b, c, d); d = rs[d];
+	pe[ 1 * 2] = DES_PC2(d, a, b, c); c = rs[c]; b = rs[b];
+	pe[ 2 * 2] = DES_PC2(b, c, d, a); a = rs[a]; d = rs[d];
+	pe[ 3 * 2] = DES_PC2(d, a, b, c); c = rs[c]; b = rs[b];
+	pe[ 4 * 2] = DES_PC2(b, c, d, a); a = rs[a]; d = rs[d];
+	pe[ 5 * 2] = DES_PC2(d, a, b, c); c = rs[c]; b = rs[b];
+	pe[ 6 * 2] = DES_PC2(b, c, d, a); a = rs[a]; d = rs[d];
+	pe[ 7 * 2] = DES_PC2(d, a, b, c); c = rs[c];
+	pe[ 8 * 2] = DES_PC2(c, d, a, b); b = rs[b]; a = rs[a];
+	pe[ 9 * 2] = DES_PC2(a, b, c, d); d = rs[d]; c = rs[c];
+	pe[10 * 2] = DES_PC2(c, d, a, b); b = rs[b]; a = rs[a];
+	pe[11 * 2] = DES_PC2(a, b, c, d); d = rs[d]; c = rs[c];
+	pe[12 * 2] = DES_PC2(c, d, a, b); b = rs[b]; a = rs[a];
+	pe[13 * 2] = DES_PC2(a, b, c, d); d = rs[d]; c = rs[c];
+	pe[14 * 2] = DES_PC2(c, d, a, b); b = rs[b];
+	pe[15 * 2] = DES_PC2(b, c, d, a);
 
 	/* Skip to next table set */
 	pt += 512;
@@ -747,22 +747,22 @@ static void dkey(u32 *pe, const u8 *k)
 	b = k[2]; b &= 0xe0; b >>= 4; b |= k[6] & 0xf0; b = pc1[b + 1];
 	a = k[3]; a &= 0xe0; a >>= 4; a |= k[7] & 0xf0; a = pc1[a + 1];
 
-	pe[ 0 * 2 + 1] = PC2(a, b, c, d); d = rs[d];
-	pe[ 1 * 2 + 1] = PC2(d, a, b, c); c = rs[c]; b = rs[b];
-	pe[ 2 * 2 + 1] = PC2(b, c, d, a); a = rs[a]; d = rs[d];
-	pe[ 3 * 2 + 1] = PC2(d, a, b, c); c = rs[c]; b = rs[b];
-	pe[ 4 * 2 + 1] = PC2(b, c, d, a); a = rs[a]; d = rs[d];
-	pe[ 5 * 2 + 1] = PC2(d, a, b, c); c = rs[c]; b = rs[b];
-	pe[ 6 * 2 + 1] = PC2(b, c, d, a); a = rs[a]; d = rs[d];
-	pe[ 7 * 2 + 1] = PC2(d, a, b, c); c = rs[c];
-	pe[ 8 * 2 + 1] = PC2(c, d, a, b); b = rs[b]; a = rs[a];
-	pe[ 9 * 2 + 1] = PC2(a, b, c, d); d = rs[d]; c = rs[c];
-	pe[10 * 2 + 1] = PC2(c, d, a, b); b = rs[b]; a = rs[a];
-	pe[11 * 2 + 1] = PC2(a, b, c, d); d = rs[d]; c = rs[c];
-	pe[12 * 2 + 1] = PC2(c, d, a, b); b = rs[b]; a = rs[a];
-	pe[13 * 2 + 1] = PC2(a, b, c, d); d = rs[d]; c = rs[c];
-	pe[14 * 2 + 1] = PC2(c, d, a, b); b = rs[b];
-	pe[15 * 2 + 1] = PC2(b, c, d, a);
+	pe[ 0 * 2 + 1] = DES_PC2(a, b, c, d); d = rs[d];
+	pe[ 1 * 2 + 1] = DES_PC2(d, a, b, c); c = rs[c]; b = rs[b];
+	pe[ 2 * 2 + 1] = DES_PC2(b, c, d, a); a = rs[a]; d = rs[d];
+	pe[ 3 * 2 + 1] = DES_PC2(d, a, b, c); c = rs[c]; b = rs[b];
+	pe[ 4 * 2 + 1] = DES_PC2(b, c, d, a); a = rs[a]; d = rs[d];
+	pe[ 5 * 2 + 1] = DES_PC2(d, a, b, c); c = rs[c]; b = rs[b];
+	pe[ 6 * 2 + 1] = DES_PC2(b, c, d, a); a = rs[a]; d = rs[d];
+	pe[ 7 * 2 + 1] = DES_PC2(d, a, b, c); c = rs[c];
+	pe[ 8 * 2 + 1] = DES_PC2(c, d, a, b); b = rs[b]; a = rs[a];
+	pe[ 9 * 2 + 1] = DES_PC2(a, b, c, d); d = rs[d]; c = rs[c];
+	pe[10 * 2 + 1] = DES_PC2(c, d, a, b); b = rs[b]; a = rs[a];
+	pe[11 * 2 + 1] = DES_PC2(a, b, c, d); d = rs[d]; c = rs[c];
+	pe[12 * 2 + 1] = DES_PC2(c, d, a, b); b = rs[b]; a = rs[a];
+	pe[13 * 2 + 1] = DES_PC2(a, b, c, d); d = rs[d]; c = rs[c];
+	pe[14 * 2 + 1] = DES_PC2(c, d, a, b); b = rs[b];
+	pe[15 * 2 + 1] = DES_PC2(b, c, d, a);
 
 	/* Fixup: 2413 5768 -> 1357 2468 */
 	for (d = 0; d < 16; ++d) {

