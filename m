Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030944Ab2I1T7P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 15:59:15 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:63190 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932269Ab2I1S4L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 14:56:11 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Igor Grinberg <grinberg@compulab.co.il>,
        Paul Walmsley <paul@pwsan.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Tony Lindgren <tony@atomide.com>
Subject: [ 050/262] ARM: OMAP: timer: obey the !CONFIG_OMAP_32K_TIMER
Date: Fri, 28 Sep 2012 11:49:39 -0700
Message-Id: <20120928183003.823027297@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120928182957.993484211@linuxfoundation.org>
References: <20120928182957.993484211@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

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
@@ -263,6 +263,7 @@ static u32 notrace dmtimer_read_sched_cl
 	return 0;
 }
 
+#ifdef CONFIG_OMAP_32K_TIMER
 /* Setup free-running counter for clocksource */
 static int __init omap2_sync32k_clocksource_init(void)
 {
@@ -302,6 +303,12 @@ static int __init omap2_sync32k_clocksou
 
 	return ret;
 }
+#else
+static inline int omap2_sync32k_clocksource_init(void)
+{
+	return -ENODEV;
+}
+#endif
 
 static void __init omap2_gptimer_clocksource_init(int gptimer_id,
 						const char *fck_source)


