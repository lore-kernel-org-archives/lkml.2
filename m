Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755381Ab2ACWgF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 17:36:05 -0500
Received: from cantor2.suse.de ([195.135.220.15]:39462 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754373Ab2ACWf7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 17:35:59 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Jan  3 14:30:34 2012
Message-Id: <20120103223034.139196922@clark.kroah.org>
User-Agent: quilt/0.50-25.1
Date: Tue, 03 Jan 2012 14:29:51 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Jason Chen <jason.chen@linaro.org>,
        Sascha Hauer <s.hauer@pengutronix.de>
Subject: [33/67] ARM:imx:fix pwm period value
In-Reply-To: <20120103223043.GA26738@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason Chen <jason.chen@linaro.org>

commit 5776ac2eb33164c77cdb4d2b48feee15616eaba3 upstream.

According to imx pwm RM, the real period value should be
PERIOD value in PWMPR plus 2.

PWMO (Hz) = PCLK(Hz) / (period +2)

Signed-off-by: Jason Chen <jason.chen@linaro.org>
Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/arm/plat-mxc/pwm.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/arch/arm/plat-mxc/pwm.c
+++ b/arch/arm/plat-mxc/pwm.c
@@ -77,6 +77,15 @@ int pwm_config(struct pwm_device *pwm, i
 		do_div(c, period_ns);
 		duty_cycles = c;
 
+		/*
+		 * according to imx pwm RM, the real period value should be
+		 * PERIOD value in PWMPR plus 2.
+		 */
+		if (period_cycles > 2)
+			period_cycles -= 2;
+		else
+			period_cycles = 0;
+
 		writel(duty_cycles, pwm->mmio_base + MX3_PWMSAR);
 		writel(period_cycles, pwm->mmio_base + MX3_PWMPR);
 


