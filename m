Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932574Ab2JNOqd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 10:46:33 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46779 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932449Ab2JNOoT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 10:44:19 -0400
Message-Id: <20121014143539.546741046@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 14 Oct 2012 15:36:15 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [ 042/147] can: mscan-mpc5xxx: fix return value check in
 mpc512x_can_get_clock()
In-Reply-To: <20121014143533.742627615@decadent.org.uk>
X-SA-Exim-Connect-IP: 77.75.106.1
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

commit f61bd0585dfc7d99db4936d7467de4ca8e2f7ea0 upstream.

In case of error, the function clk_get() returns ERR_PTR()
and never returns NULL pointer. The NULL test in the error
handling should be replaced with IS_ERR().

dpatch engine is used to auto generated this patch.
(https://github.com/weiyj/dpatch)

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Acked-by: Wolfgang Grandegger <wg@grandegger.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/can/mscan/mpc5xxx_can.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/can/mscan/mpc5xxx_can.c b/drivers/net/can/mscan/mpc5xxx_can.c
index 06adf88..524ef96 100644
--- a/drivers/net/can/mscan/mpc5xxx_can.c
+++ b/drivers/net/can/mscan/mpc5xxx_can.c
@@ -181,7 +181,7 @@ static u32 __devinit mpc512x_can_get_clock(struct platform_device *ofdev,
 
 		if (!clock_name || !strcmp(clock_name, "sys")) {
 			sys_clk = clk_get(&ofdev->dev, "sys_clk");
-			if (!sys_clk) {
+			if (IS_ERR(sys_clk)) {
 				dev_err(&ofdev->dev, "couldn't get sys_clk\n");
 				goto exit_unmap;
 			}
@@ -204,7 +204,7 @@ static u32 __devinit mpc512x_can_get_clock(struct platform_device *ofdev,
 
 		if (clocksrc < 0) {
 			ref_clk = clk_get(&ofdev->dev, "ref_clk");
-			if (!ref_clk) {
+			if (IS_ERR(ref_clk)) {
 				dev_err(&ofdev->dev, "couldn't get ref_clk\n");
 				goto exit_unmap;
 			}


