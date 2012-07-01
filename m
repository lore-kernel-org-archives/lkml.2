Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932567Ab2GASQu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2012 14:16:50 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:47021 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756006Ab2GASQp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2012 14:16:45 -0400
Message-Id: <20120701172013.190181226@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 01 Jul 2012 18:20:52 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Hui Wang <jason77.wang@gmail.com>,
        Shawn Guo <shawn.guo@linaro.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [ 46/48] can: flexcan: use be32_to_cpup to handle the value of dt entry
In-Reply-To: <20120701172006.535271340@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hui Wang <jason77.wang@gmail.com>

commit 85f2f834e85517307f13e30e630a5fc86f757cb5 upstream.

The freescale arm i.MX series platform can support this driver, and
usually the arm cpu works in the little endian mode by default, while
device tree entry value is stored in big endian format, we should use
be32_to_cpup() to handle them, after modification, it can work well
both on the le cpu and be cpu.

Cc: Shawn Guo <shawn.guo@linaro.org>
Signed-off-by: Hui Wang <jason77.wang@gmail.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/can/flexcan.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/can/flexcan.c
+++ b/drivers/net/can/flexcan.c
@@ -933,12 +933,12 @@
 	u32 clock_freq = 0;
 
 	if (pdev->dev.of_node) {
-		const u32 *clock_freq_p;
+		const __be32 *clock_freq_p;
 
 		clock_freq_p = of_get_property(pdev->dev.of_node,
 						"clock-frequency", NULL);
 		if (clock_freq_p)
-			clock_freq = *clock_freq_p;
+			clock_freq = be32_to_cpup(clock_freq_p);
 	}
 
 	if (!clock_freq) {


