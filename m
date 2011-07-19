Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752035Ab1GSD6S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 23:58:18 -0400
Received: from sand.ocn.ne.jp ([122.28.30.136]:55587 "EHLO smtp.sand.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751583Ab1GSD6R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 23:58:17 -0400
X-Greylist: delayed 1653 seconds by postgrey-1.27 at vger.kernel.org; Mon, 18 Jul 2011 23:58:16 EDT
From: Jon Povey <jon.povey@racelogic.co.uk>
To: davinci-linux-open-source@linux.davincidsp.com,
        linux-arm-kernel@lists.infradead.org, Sekhar Nori <nsekhar@ti.com>
Cc: linux-kernel@vger.kernel.org, Kevin Hilman <khilman@ti.com>,
        Jon Povey <jon.povey@racelogic.co.uk>
Subject: [PATCH] davinci: fix DM365 EVM video input mux bits
Date: Tue, 19 Jul 2011 12:30:11 +0900
Message-Id: <1311046211-2849-1-git-send-email-jon.povey@racelogic.co.uk>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Video input mux settings for tvp7002 and imager inputs were swapped.
Comment was correct.

Tested on EVM with tvp7002 input.

Signed-off-by: Jon Povey <jon.povey@racelogic.co.uk>
---
As a bugfix maybe this should try to get into 3.0?

 arch/arm/mach-davinci/board-dm365-evm.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-davinci/board-dm365-evm.c b/arch/arm/mach-davinci/board-dm365-evm.c
index c67f684..09a87e6 100644
--- a/arch/arm/mach-davinci/board-dm365-evm.c
+++ b/arch/arm/mach-davinci/board-dm365-evm.c
@@ -520,7 +520,7 @@ fail:
 	 */
 	if (have_imager()) {
 		label = "HD imager";
-		mux |= 1;
+		mux |= 2;
 
 		/* externally mux MMC1/ENET/AIC33 to imager */
 		mux |= BIT(6) | BIT(5) | BIT(3);
@@ -540,7 +540,7 @@ fail:
 		resets &= ~BIT(1);
 
 		if (have_tvp7002()) {
-			mux |= 2;
+			mux |= 1;
 			resets &= ~BIT(2);
 			label = "tvp7002 HD";
 		} else {
-- 
1.6.3.3

