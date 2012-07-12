Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161964Ab2GLX3F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 19:29:05 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:60450 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161914Ab2GLWle (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 18:41:34 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Shawn Guo <shawn.guo@linaro.org>, Hui Wang <jason77.wang@gmail.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [ 105/187] can: flexcan: use be32_to_cpup to handle the value of dt entry
Date: Thu, 12 Jul 2012 15:34:21 -0700
Message-Id: <20120712191532.119637657@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120712191522.742634173@linuxfoundation.org>
References: <20120712192421.GA28926@kroah.com>
 <20120712191522.742634173@linuxfoundation.org>
User-Agent: quilt/0.60-20.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/can/flexcan.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/can/flexcan.c
+++ b/drivers/net/can/flexcan.c
@@ -933,12 +933,12 @@ static int __devinit flexcan_probe(struc
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


