Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945925Ab2LNXF4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 18:05:56 -0500
Received: from mail.kernel.org ([198.145.19.201]:41153 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1945911Ab2LNXFw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 18:05:52 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Lee Jones <lee.jones@linaro.org>, Ulf Hansson <ulf.hansson@linaro.org>,
        Philippe Begnic <philippe.begnic@st.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Mike Turquette <mturquette@linaro.org>
Subject: [ 02/27] clk: ux500: fix bit error
Date: Fri, 14 Dec 2012 15:01:15 -0800
Message-Id: <20121214222251.691036864@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20121214222251.229078963@linuxfoundation.org>
References: <20121214222251.229078963@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Walleij <linus.walleij@linaro.org>

commit 2630b17b6ee47ac79b4f5120ac49105027f644ea upstream.

This fixes a bit error in the U8500 clock implementation: the
unused p2_pclk12 registered at bit 12 in periphereral group 6
was defined as using bit 11 rather than bit 12.

When walking over and disabling the unused clocks in the tree
at late init time, p2_pclk12 was disabled, by effectively
clearing the but for p2_pclk11 instead of bit 12 as it should
have, thus disabling gpio block 6 and 7.

Reported-by: Lee Jones <lee.jones@linaro.org>
Acked-by: Ulf Hansson <ulf.hansson@linaro.org>
Cc: Philippe Begnic <philippe.begnic@st.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Mike Turquette <mturquette@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/clk/ux500/u8500_clk.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/clk/ux500/u8500_clk.c
+++ b/drivers/clk/ux500/u8500_clk.c
@@ -323,7 +323,7 @@ void u8500_clk_init(void)
 	clk_register_clkdev(clk, NULL, "gpioblock1");
 
 	clk = clk_reg_prcc_pclk("p2_pclk12", "per2clk", U8500_CLKRST2_BASE,
-				BIT(11), 0);
+				BIT(12), 0);
 
 	clk = clk_reg_prcc_pclk("p3_pclk0", "per3clk", U8500_CLKRST3_BASE,
 				BIT(0), 0);


