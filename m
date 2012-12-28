Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753880Ab2L1QgP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 11:36:15 -0500
Received: from mail-qc0-f172.google.com ([209.85.216.172]:32957 "EHLO
	mail-qc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753686Ab2L1QgO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 11:36:14 -0500
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Fri, 28 Dec 2012 11:36:13 EST
From: "Lee, Chun-Yi" <joeyli.kernel@gmail.com>
To: matt.fleming@intel.com
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org,
        "Lee, Chun-Yi" <jlee@suse.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Jan Beulich <JBeulich@suse.com>
Subject: [PATCH 3/3] rtc-efi: set uie_unsupported for indicate rtc-efi doesn't support UIE mode
Date: Sat, 29 Dec 2012 00:26:41 +0800
Message-Id: <1356712001-12198-3-git-send-email-jlee@suse.com>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1356712001-12198-1-git-send-email-jlee@suse.com>
References: <1356712001-12198-1-git-send-email-jlee@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set uie_unsupported flag when driver probed because current rtc-efi
driver doesn't support UIE mode. Otherwise RTC_UIE_ON ioctl doesn't return EINVAL
and it causes userspace think the RTC_UIE supported by rtc-efi.

Set uie_unsupported then We can enable CONFIG_RTC_INTF_DEV_UIE_EMUL to emulate
RTC_UIE on rtc-efi.

Cc: Matt Fleming <matt.fleming@intel.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Matthew Garrett <matthew.garrett@nebula.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jan Beulich <JBeulich@suse.com>
Signed-off-by: Lee, Chun-Yi <jlee@suse.com>
---
 drivers/rtc/rtc-efi.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/rtc/rtc-efi.c b/drivers/rtc/rtc-efi.c
index 4e74ec0..dad1687 100644
--- a/drivers/rtc/rtc-efi.c
+++ b/drivers/rtc/rtc-efi.c
@@ -208,6 +208,8 @@ static int __init efi_rtc_probe(struct platform_device *dev)
 	if (IS_ERR(rtc))
 		return PTR_ERR(rtc);
 
+	rtc->uie_unsupported = 1;
+
 	platform_set_drvdata(dev, rtc);
 
 	return 0;
-- 
1.6.4.2

