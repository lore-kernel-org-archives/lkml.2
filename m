Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757322Ab2HGDsg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 23:48:36 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:59765 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757336Ab2HGDih (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 23:38:37 -0400
Message-Id: <20120807032803.060347713@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Tue, 07 Aug 2012 04:28:43 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Colin Cross <ccross@android.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [ 48/70] ARM: 7476/1: vfp: only clear vfp state for current cpu in
 vfp_pm_suspend
In-Reply-To: <20120807032755.803571133@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Colin Cross <ccross@android.com>

commit a84b895a2348f0dbff31b71ddf954f70a6cde368 upstream.

vfp_pm_suspend runs on each cpu, only clear the hardware state
pointer for the current cpu.  Prevents a possible crash if one
cpu clears the hw state pointer when another cpu has already
checked if it is valid.

Signed-off-by: Colin Cross <ccross@android.com>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/arm/vfp/vfpmodule.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/vfp/vfpmodule.c b/arch/arm/vfp/vfpmodule.c
index 58696192..9428006 100644
--- a/arch/arm/vfp/vfpmodule.c
+++ b/arch/arm/vfp/vfpmodule.c
@@ -460,7 +460,7 @@ static int vfp_pm_suspend(void)
 	}
 
 	/* clear any information we had about last context state */
-	memset(vfp_current_hw_state, 0, sizeof(vfp_current_hw_state));
+	vfp_current_hw_state[ti->cpu] = NULL;
 
 	return 0;
 }


