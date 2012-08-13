Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755862Ab2HMWXB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 18:23:01 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:36947 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755797Ab2HMWSd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 18:18:33 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM list <linux-pm@vger.kernel.org>
Subject: [PATCH 2/3] PM / cpuidle: Make ladder governor use the "disabled" state flag
Date: Tue, 14 Aug 2012 00:22:11 +0200
User-Agent: KMail/1.13.6 (Linux/3.5.0+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
        "Linux-sh list" <linux-sh@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>
References: <201208140019.19288.rjw@sisk.pl>
In-Reply-To: <201208140019.19288.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201208140022.12197.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


For the mechanism introduced by commit cbc9ef0 (PM / Domains: Add
preliminary support for cpuidle, v2) to work with the ladder
governor, that governor should respect the "disabled" state flag
added by that commit.  Change the ladder governor accordingly.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/cpuidle/governors/ladder.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

Index: linux/drivers/cpuidle/governors/ladder.c
===================================================================
--- linux.orig/drivers/cpuidle/governors/ladder.c
+++ linux/drivers/cpuidle/governors/ladder.c
@@ -88,6 +88,7 @@ static int ladder_select_state(struct cp
 
 	/* consider promotion */
 	if (last_idx < drv->state_count - 1 &&
+	    !drv->states[last_idx + 1].disabled &&
 	    !dev->states_usage[last_idx + 1].disable &&
 	    last_residency > last_state->threshold.promotion_time &&
 	    drv->states[last_idx + 1].exit_latency <= latency_req) {
@@ -101,7 +102,8 @@ static int ladder_select_state(struct cp
 
 	/* consider demotion */
 	if (last_idx > CPUIDLE_DRIVER_STATE_START &&
-	    (dev->states_usage[last_idx].disable ||
+	    (drv->states[last_idx].disabled ||
+	    dev->states_usage[last_idx].disable ||
 	    drv->states[last_idx].exit_latency > latency_req)) {
 		int i;
 

