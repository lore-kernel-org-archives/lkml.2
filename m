Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758200Ab1LGQtK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 11:49:10 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33690 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757584Ab1LGQUo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 11:20:44 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Dec  7 08:12:16 2011
Message-Id: <20111207161216.087244886@clark.kroah.org>
User-Agent: quilt/0.50-23.1
Date: Wed, 07 Dec 2011 08:11:18 -0800
From: Greg KH <gregkh@suse.de>
To: <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
Cc: <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <alan@lxorguk.ukuu.org.uk>, Wolfram Sang <w.sang@pengutronix.de>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Shawn Guo <shawn.guo@freescale.com>, Shawn Guo <shawn.guo@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [016/104] arm: mx28: fix bit operation in clock setting
In-Reply-To: <20111207161246.GA10995@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wolfram Sang <w.sang@pengutronix.de>

commit c2735391fbc68feae10d6d14e60956c8106e725f upstream.

reg | (1 << clk->enable_shift) always evaluates to true. Switch it
to & which makes much more sense. Same fix as 13be9f00 (ARM i.MX28: fix
bit operation) at a different location.

Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
Cc: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Shawn Guo <shawn.guo@freescale.com>
Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/arm/mach-mxs/clock-mx28.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm/mach-mxs/clock-mx28.c
+++ b/arch/arm/mach-mxs/clock-mx28.c
@@ -404,7 +404,7 @@ static int name##_set_rate(struct clk *c
 	reg = __raw_readl(CLKCTRL_BASE_ADDR + HW_CLKCTRL_##dr);		\
 	reg &= ~BM_CLKCTRL_##dr##_DIV;					\
 	reg |= div << BP_CLKCTRL_##dr##_DIV;				\
-	if (reg | (1 << clk->enable_shift)) {				\
+	if (reg & (1 << clk->enable_shift)) {				\
 		pr_err("%s: clock is gated\n", __func__);		\
 		return -EINVAL;						\
 	}								\


