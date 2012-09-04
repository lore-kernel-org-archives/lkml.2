Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932697Ab2IDURv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 16:17:51 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:23253 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932423Ab2IDURu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 16:17:50 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6825"; a="230512774"
From: Stephen Boyd <sboyd@codeaurora.org>
To: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH] ARM: msm: Fix sparse warnings due to incorrect type
Date: Tue,  4 Sep 2012 13:17:33 -0700
Message-Id: <1346789853-824-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.7.12.70.g851f7e6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

arch/arm/mach-msm/timer.c:153:3: warning: incorrect type in initializer (different address spaces)
arch/arm/mach-msm/timer.c:153:3:    expected void const [noderef] <asn:3>*__vpp_verify
arch/arm/mach-msm/timer.c:153:3:    got struct clock_event_device [noderef] <asn:3>**<noident>
arch/arm/mach-msm/timer.c:153:38: warning: incorrect type in assignment (different address spaces)
arch/arm/mach-msm/timer.c:153:38:    expected struct clock_event_device [noderef] <asn:3>*<noident>
arch/arm/mach-msm/timer.c:153:38:    got struct clock_event_device *evt
arch/arm/mach-msm/timer.c:191:22: warning: incorrect type in assignment (different address spaces)
arch/arm/mach-msm/timer.c:191:22:    expected struct clock_event_device [noderef] <asn:3>**static [toplevel] percpu_evt
arch/arm/mach-msm/timer.c:191:22:    got struct clock_event_device *[noderef] <asn:3>*<noident>
arch/arm/mach-msm/timer.c:196:4: warning: incorrect type in initializer (different address spaces)
arch/arm/mach-msm/timer.c:196:4:    expected void const [noderef] <asn:3>*__vpp_verify
arch/arm/mach-msm/timer.c:196:4:    got struct clock_event_device [noderef] <asn:3>**<noident>
arch/arm/mach-msm/timer.c:196:39: warning: incorrect type in assignment (different address spaces)
arch/arm/mach-msm/timer.c:196:39:    expected struct clock_event_device [noderef] <asn:3>*<noident>
arch/arm/mach-msm/timer.c:196:39:    got struct clock_event_device *ce
arch/arm/mach-msm/timer.c:198:24: warning: incorrect type in argument 4 (different address spaces)
arch/arm/mach-msm/timer.c:198:24:    expected void [noderef] <asn:3>*percpu_dev_id
arch/arm/mach-msm/timer.c:198:24:    got struct clock_event_device [noderef] <asn:3>**static [toplevel] percpu_evt

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 arch/arm/mach-msm/timer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-msm/timer.c b/arch/arm/mach-msm/timer.c
index 81280825..004f935 100644
--- a/arch/arm/mach-msm/timer.c
+++ b/arch/arm/mach-msm/timer.c
@@ -101,7 +101,7 @@ static struct clock_event_device msm_clockevent = {
 
 static union {
 	struct clock_event_device *evt;
-	struct clock_event_device __percpu **percpu_evt;
+	struct clock_event_device * __percpu *percpu_evt;
 } msm_evt;
 
 static void __iomem *source_base;
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora
Forum, hosted by The Linux Foundation

