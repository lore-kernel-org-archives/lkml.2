Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754299Ab0JESqV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 14:46:21 -0400
Received: from webhosting01.bon.m2soft.com ([195.38.20.32]:47713 "EHLO
	webhosting01.bon.m2soft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752481Ab0JESqU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 14:46:20 -0400
Date: Tue, 5 Oct 2010 20:41:49 +0200
From: Nicolas Kaiser <nikai@nikai.net>
To: Jay Vosburgh <fubar@us.ibm.com>
Cc: bonding-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [PATCH] bonding: simplify conditionals
Message-ID: <20101005204149.6a43d080@absol.kitzblitz>
Organization: -
X-Face: "fF&[w2"Nws:JNH4'g|:gVhgGKLhj|X}}&w&V?]0=,7n`jy8D6e[Jh=7+ca|4~t5e[ItpL5
 N'y~Mvi-vJm`"1T5fi1^b!&EG]6nW~C!FN},=$G?^U2t~n[3;u\"5-|~H{-5]IQ2
X-Mailer: Claws Mail (Linux)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simplify conditionals:
 (a || (!a && !b)) => (a || !b)
 (!(!a && b)) => (a || !b)

Signed-off-by: Nicolas Kaiser <nikai@nikai.net>
---
 drivers/net/bonding/bond_3ad.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/bonding/bond_3ad.c b/drivers/net/bonding/bond_3ad.c
index 0ddf4c6..d0ad321 100644
--- a/drivers/net/bonding/bond_3ad.c
+++ b/drivers/net/bonding/bond_3ad.c
@@ -1541,10 +1541,9 @@ static void ad_agg_selection_logic(struct aggregator *agg)
 		 */
 		if (active && active->lag_ports &&
 		    active->lag_ports->is_enabled &&
-		    (__agg_has_partner(active) ||
-		     (!__agg_has_partner(active) && !__agg_has_partner(best)))) {
-			if (!(!active->actor_oper_aggregator_key &&
-			      best->actor_oper_aggregator_key)) {
+		    (__agg_has_partner(active) || !__agg_has_partner(best))) {
+			if (active->actor_oper_aggregator_key ||
+			    !best->actor_oper_aggregator_key) {
 				best = NULL;
 				active->is_active = 1;
 			}
-- 
1.7.2.2
