Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933960Ab2JDVWs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 17:22:48 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44933 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933991Ab2JDVWn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 17:22:43 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [ 49/58] can: mscan-mpc5xxx: fix return value check in mpc512x_can_get_clock()
Date: Thu,  4 Oct 2012 14:19:56 -0700
Message-Id: <20121004210641.669752114@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.2.421.g261b511
In-Reply-To: <20121004210635.449598766@linuxfoundation.org>
References: <20121004210635.449598766@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/can/mscan/mpc5xxx_can.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/can/mscan/mpc5xxx_can.c
+++ b/drivers/net/can/mscan/mpc5xxx_can.c
@@ -181,7 +181,7 @@ static u32 __devinit mpc512x_can_get_clo
 
 		if (!clock_name || !strcmp(clock_name, "sys")) {
 			sys_clk = clk_get(&ofdev->dev, "sys_clk");
-			if (!sys_clk) {
+			if (IS_ERR(sys_clk)) {
 				dev_err(&ofdev->dev, "couldn't get sys_clk\n");
 				goto exit_unmap;
 			}
@@ -204,7 +204,7 @@ static u32 __devinit mpc512x_can_get_clo
 
 		if (clocksrc < 0) {
 			ref_clk = clk_get(&ofdev->dev, "ref_clk");
-			if (!ref_clk) {
+			if (IS_ERR(ref_clk)) {
 				dev_err(&ofdev->dev, "couldn't get ref_clk\n");
 				goto exit_unmap;
 			}


