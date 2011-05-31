Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758437Ab1EaIyO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 04:54:14 -0400
Received: from eu1sys200aog115.obsmtp.com ([207.126.144.139]:33023 "EHLO
	eu1sys200aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758382Ab1EaIyM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 04:54:12 -0400
From: Viresh Kumar <viresh.kumar@st.com>
To: <linux-arm-kernel@lists.infradead.org>, <arnd@arndb.de>
Cc: <armando.visconti@st.com>, <shiraz.hashim@st.com>, <vipin.kumar@st.com>,
        <rajeev-dlh.kumar@st.com>, <deepak.sikri@st.com>,
        <vipulkumar.samar@st.com>, <amit.virdi@st.com>, <viresh.kumar@st.com>,
        <pratyush.anand@st.com>, <bhupesh.sharma@st.com>,
        <viresh.linux@gmail.com>, <akpm@linux-foundation.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH V2 2/3] SPEAr3xx: Add machine support for ST's PWM IP
Date: Tue, 31 May 2011 14:21:52 +0530
Message-ID: <cf12edf01f3518fea06140aa1335bb24f3a4a636.1306831238.git.viresh.kumar@st.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <cover.1306831238.git.viresh.kumar@st.com>
References: <cover.1306831238.git.viresh.kumar@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reviewed-by: Stanley Miao <stanley.miao@windriver.com>
Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
---
 arch/arm/mach-spear3xx/include/mach/generic.h |    1 +
 arch/arm/mach-spear3xx/spear320.c             |   16 ++++++++++++++++
 arch/arm/mach-spear3xx/spear320_evb.c         |    1 +
 3 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-spear3xx/include/mach/generic.h b/arch/arm/mach-spear3xx/include/mach/generic.h
index 8cc3a73..a88e359 100644
--- a/arch/arm/mach-spear3xx/include/mach/generic.h
+++ b/arch/arm/mach-spear3xx/include/mach/generic.h
@@ -162,6 +162,7 @@ void __init spear310_init(struct pmx_mode *pmx_mode, struct pmx_dev **pmx_devs,
 #ifdef CONFIG_MACH_SPEAR320
 /* Add spear320 machine device structure declarations here */
 extern struct platform_device spear320_plgpio_device;
+extern struct platform_device spear320_pwm_device;
 
 /* pad mux modes */
 extern struct pmx_mode spear320_auto_net_smii_mode;
diff --git a/arch/arm/mach-spear3xx/spear320.c b/arch/arm/mach-spear3xx/spear320.c
index 575493a..d84e986 100644
--- a/arch/arm/mach-spear3xx/spear320.c
+++ b/arch/arm/mach-spear3xx/spear320.c
@@ -548,6 +548,22 @@ struct platform_device spear320_plgpio_device = {
 	.resource = plgpio_resources,
 };
 
+/* pwm device registeration */
+static struct resource pwm_resources[] = {
+	{
+		.start = SPEAR320_PWM_BASE,
+		.end = SPEAR320_PWM_BASE + SZ_4K - 1,
+		.flags = IORESOURCE_MEM,
+	},
+};
+
+struct platform_device spear320_pwm_device = {
+	.name = "st_pwm",
+	.id = -1,
+	.num_resources = ARRAY_SIZE(pwm_resources),
+	.resource = pwm_resources,
+};
+
 /* spear320 routines */
 void __init spear320_init(struct pmx_mode *pmx_mode, struct pmx_dev **pmx_devs,
 		u8 pmx_dev_count)
diff --git a/arch/arm/mach-spear3xx/spear320_evb.c b/arch/arm/mach-spear3xx/spear320_evb.c
index 4d747db..6190660 100644
--- a/arch/arm/mach-spear3xx/spear320_evb.c
+++ b/arch/arm/mach-spear3xx/spear320_evb.c
@@ -50,6 +50,7 @@ static struct platform_device *plat_devs[] __initdata = {
 
 	/* spear320 specific devices */
 	&spear320_plgpio_device,
+	&spear320_pwm_device,
 };
 
 static void __init spear320_evb_init(void)
-- 
1.7.2.2

