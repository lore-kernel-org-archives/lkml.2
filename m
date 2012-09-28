Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423085Ab2I1Vte (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 17:49:34 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:47839 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1032178Ab2I1UYS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 16:24:18 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Igor Grinberg <grinberg@compulab.co.il>,
        Paul Walmsley <paul@pwsan.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Tony Lindgren <tony@atomide.com>
Subject: [ 045/218] ARM: OMAP: timer: obey the !CONFIG_OMAP_32K_TIMER
Date: Fri, 28 Sep 2012 13:14:22 -0700
Message-Id: <20120928201506.626237283@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.1.428.g652398a
In-Reply-To: <20120928201501.208384923@linuxfoundation.org>
References: <20120928201501.208384923@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Igor Grinberg <grinberg@compulab.co.il>

commit 45caae74d238ef6583e9402cb8c550cc0b0f7dbd upstream.

Currently, omap2_sync32k_clocksource_init() function initializes the 32K
timer as the system clock source regardless of the CONFIG_OMAP_32K_TIMER
setting.
Fix this by providing a default implementation for
!CONFIG_OMAP_32K_TIMER case.

Signed-off-by: Igor Grinberg <grinberg@compulab.co.il>
Reviewed-by: Paul Walmsley <paul@pwsan.com>
Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/mach-omap2/timer.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/arch/arm/mach-omap2/timer.c
+++ b/arch/arm/mach-omap2/timer.c
@@ -275,6 +275,7 @@ static u32 notrace dmtimer_read_sched_cl
 	return 0;
 }
 
+#ifdef CONFIG_OMAP_32K_TIMER
 /* Setup free-running counter for clocksource */
 static void __init omap2_gp_clocksource_init(int gptimer_id,
 						const char *fck_source)
@@ -304,6 +305,12 @@ static void __init omap##name##_timer_in
 	omap2_gp_clockevent_init((clkev_nr), clkev_src);		\
 	omap2_gp_clocksource_init((clksrc_nr), clksrc_src);		\
 }
+#else
+static inline int omap2_sync32k_clocksource_init(void)
+{
+	return -ENODEV;
+}
+#endif
 
 #define OMAP_SYS_TIMER(name)						\
 struct sys_timer omap##name##_timer = {					\


