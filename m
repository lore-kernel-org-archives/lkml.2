Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754395Ab1H2RCp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 13:02:45 -0400
Received: from na3sys009aog116.obsmtp.com ([74.125.149.240]:49608 "EHLO
	na3sys009aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754325Ab1H2RCn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 13:02:43 -0400
Subject: Kconfig unmet dependency with RADIO_WL1273
From: Luciano Coelho <coelho@ti.com>
To: matti.j.aaltonen@nokia.com
Cc: johannes@sipsolutions.net, linux-kernel@vger.kernel.org,
        sameo@linux.intel.com, mchehab@infradead.org,
        linux-media@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 29 Aug 2011 20:02:38 +0300
Message-ID: <1314637358.2296.395.camel@cumari>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Matti,

Johannes has just reported a problem in the Kconfig of radio-wl1273.  It
seems to select MFD_CORE, but if the platform doesn't support MFD, then
MFD_SUPPORT won't be selected and this kind of warning will come out:

warning: (OLPC_XO1_PM && OLPC_XO1_SCI && I2C_ISCH && GPIO_SCH && GPIO_RDC321X && RADIO_WL1273) 
                selects MFD_CORE which has unmet direct dependencies (MFD_SUPPORT)

I guess it must depend on MFD_SUPPORT, right? If that's the correct
solution, the following patch should fix the problem:

diff --git a/drivers/media/radio/Kconfig b/drivers/media/radio/Kconfig
index 52798a1..e87f544 100644
--- a/drivers/media/radio/Kconfig
+++ b/drivers/media/radio/Kconfig
@@ -425,7 +425,7 @@ config RADIO_TIMBERDALE
 
 config RADIO_WL1273
        tristate "Texas Instruments WL1273 I2C FM Radio"
-       depends on I2C && VIDEO_V4L2
+       depends on I2C && VIDEO_V4L2 && MFD_SUPPORT
        select MFD_CORE
        select MFD_WL1273_CORE
        select FW_LOADER

The same problem is happening with other drivers too, so maybe there is
a better solution to fix all problems at once. ;)

Reported-by: Johannes Berg <johannes@sipsolutions.net>


-- 
Cheers,
Luca.

