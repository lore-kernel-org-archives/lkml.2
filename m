Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755381Ab2ACWEU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 17:04:20 -0500
Received: from cantor2.suse.de ([195.135.220.15]:36062 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755363Ab2ACWEQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 17:04:16 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Jan  3 14:02:41 2012
Message-Id: <20120103220241.151144238@clark.kroah.org>
User-Agent: quilt/0.50-25.1
Date: Tue, 03 Jan 2012 14:01:33 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Jason Chen <jason.chen@linaro.org>,
        Sascha Hauer <s.hauer@pengutronix.de>
Subject: [3/7] MXC PWM: should active during DOZE/WAIT/DBG mode
In-Reply-To: <20120103220302.GA28338@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Jason Chen <jason.chen@linaro.org>

commit c0d96aed8c6dd925afe9ea35491a0cd458642a86 upstream.

Signed-off-by: Jason Chen <jason.chen@linaro.org>
Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/arm/plat-mxc/pwm.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/arch/arm/plat-mxc/pwm.c
+++ b/arch/arm/plat-mxc/pwm.c
@@ -31,6 +31,9 @@
 #define MX3_PWMSAR                0x0C    /* PWM Sample Register */
 #define MX3_PWMPR                 0x10    /* PWM Period Register */
 #define MX3_PWMCR_PRESCALER(x)    (((x - 1) & 0xFFF) << 4)
+#define MX3_PWMCR_DOZEEN                (1 << 24)
+#define MX3_PWMCR_WAITEN                (1 << 23)
+#define MX3_PWMCR_DBGEN			(1 << 22)
 #define MX3_PWMCR_CLKSRC_IPG_HIGH (2 << 16)
 #define MX3_PWMCR_CLKSRC_IPG      (1 << 16)
 #define MX3_PWMCR_EN              (1 << 0)
@@ -76,7 +79,9 @@ int pwm_config(struct pwm_device *pwm, i
 		writel(duty_cycles, pwm->mmio_base + MX3_PWMSAR);
 		writel(period_cycles, pwm->mmio_base + MX3_PWMPR);
 
-		cr = MX3_PWMCR_PRESCALER(prescale) | MX3_PWMCR_EN;
+		cr = MX3_PWMCR_PRESCALER(prescale) |
+			MX3_PWMCR_DOZEEN | MX3_PWMCR_WAITEN |
+			MX3_PWMCR_DBGEN | MX3_PWMCR_EN;
 
 		if (cpu_is_mx25())
 			cr |= MX3_PWMCR_CLKSRC_IPG;


