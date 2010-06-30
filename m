Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932205Ab0F3QCA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 12:02:00 -0400
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:40056 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756868Ab0F3QB6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 12:01:58 -0400
Date: Wed, 30 Jun 2010 18:01:56 +0200
From: Christoph Egger <siccegge@cs.fau.de>
To: Eric Miao <eric.y.miao@gmail.com>, Russell King <linux@arm.linux.org.uk>,
       Pavel Machek <pavel@ucw.cz>, Arnaud Patard <arnaud.patard@rtp-net.org>,
       Uwe Kleine-K??nig <u.kleine-koenig@pengutronix.de>,
       Kristoffer Ericson <kristoffer.ericson@gmail.com>,
       linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: vamos@i4.informatik.uni-erlangen.de
Subject: [PATCH 25/33] Removing dead CORGI_SSP_DEPRECATED
Message-ID: <80c10751fb5b7d9be55656ac35827a403a5d6b2b.1277911346.git.siccegge@cs.fau.de>
References: <cover.1277911345.git.siccegge@cs.fau.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1277911345.git.siccegge@cs.fau.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CORGI_SSP_DEPRECATED doesn't exist in Kconfig, therefore removing all
references for it from the source code.

Signed-off-by: Christoph Egger <siccegge@cs.fau.de>
---
 arch/arm/mach-pxa/sharpsl_pm.c |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/arch/arm/mach-pxa/sharpsl_pm.c b/arch/arm/mach-pxa/sharpsl_pm.c
index 582701e..d8c5301 100644
--- a/arch/arm/mach-pxa/sharpsl_pm.c
+++ b/arch/arm/mach-pxa/sharpsl_pm.c
@@ -180,17 +180,12 @@ int sharpsl_pm_pxa_read_max1111(int channel)
 	if (machine_is_tosa())
 	    return 0;
 
-#ifdef CONFIG_CORGI_SSP_DEPRECATED
-	return corgi_ssp_max1111_get((channel << MAXCTRL_SEL_SH) | MAXCTRL_PD0 | MAXCTRL_PD1
-			| MAXCTRL_SGL | MAXCTRL_UNI | MAXCTRL_STR);
-#else
 	extern int max1111_read_channel(int);
 
 	/* max1111 accepts channels from 0-3, however,
 	 * it is encoded from 0-7 here in the code.
 	 */
 	return max1111_read_channel(channel >> 1);
-#endif
 }
 
 static int get_percentage(int voltage)
-- 
1.7.0.4

