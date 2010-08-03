Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757023Ab0HCVds (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 17:33:48 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:41570 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756306Ab0HCVdq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 17:33:46 -0400
Date: Tue, 3 Aug 2010 23:33:43 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Grant Likely <grant.likely@secretlab.ca>, linuxppc-dev@ozlabs.org,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH 4/9] arch/powerpc/platforms/powermac: Drop unnecessary null
 test
Message-ID: <Pine.LNX.4.64.1008032333250.20393@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

for_each_node_by_name binds its first argument to a non-null value, and
thus any null test on the value of that argument is superfluous.

The semantic patch that makes this change is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
iterator I;
expression x,E;
@@

I(x,...) { <...
(
- (x != NULL) &&
  E
  ...> }
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 arch/powerpc/platforms/powermac/feature.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/platforms/powermac/feature.c b/arch/powerpc/platforms/powermac/feature.c
index 9e1b9fd..537957b 100644
--- a/arch/powerpc/platforms/powermac/feature.c
+++ b/arch/powerpc/platforms/powermac/feature.c
@@ -2867,7 +2867,7 @@ set_initial_features(void)
 
 		/* Switch airport off */
 		for_each_node_by_name(np, "radio") {
-			if (np && np->parent == macio_chips[0].of_node) {
+			if (np->parent == macio_chips[0].of_node) {
 				macio_chips[0].flags |= MACIO_FLAG_AIRPORT_ON;
 				core99_airport_enable(np, 0, 0);
 			}
