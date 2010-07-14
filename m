Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756775Ab0GNOEr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 10:04:47 -0400
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:47055 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756685Ab0GNOEp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 10:04:45 -0400
Date: Wed, 14 Jul 2010 16:04:43 +0200
From: Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>
To: Alessandro Zummo <a.zummo@towertech.it>,
        Paul Gortmaker <p_gortmaker@yahoo.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ralf Baechle <ralf@linux-mips.org>, Chris Wright <chrisw@sous-sol.org>,
        Arnaud Patard <apatard@mandriva.com>, rtc-linux@googlegroups.com,
        linux-kernel@vger.kernel.org
Cc: vamos-dev@i4.informatik.uni-erlangen.de
Subject: [PATCH 3/5] drivers/rtc: Remove unneeded ifdef CONFIG_PM
Message-ID: <1768dbd136598aa52607378cdc7ba7b7870ab263.1279116162.git.qy03fugy@stud.informatik.uni-erlangen.de>
References: <c3c850bed3f5714f1efcfad24ad4f8bfcb6b5b54.1279116162.git.qy03fugy@stud.informatik.uni-erlangen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c3c850bed3f5714f1efcfad24ad4f8bfcb6b5b54.1279116162.git.qy03fugy@stud.informatik.uni-erlangen.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Because CONFIG_PM is a precondition to CONFIG_ACPI, the ifdef
CONFIG_PM within ifdef CONFIG_ACPI is redundant.

Signed-off-by: Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>
---
 drivers/rtc/rtc-cmos.c |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/drivers/rtc/rtc-cmos.c b/drivers/rtc/rtc-cmos.c
index 11b8ea2..5856167 100644
--- a/drivers/rtc/rtc-cmos.c
+++ b/drivers/rtc/rtc-cmos.c
@@ -970,7 +970,6 @@ static inline int cmos_poweroff(struct device *dev)
 
 #include <linux/acpi.h>
 
-#ifdef	CONFIG_PM
 static u32 rtc_handler(void *context)
 {
 	acpi_clear_event(ACPI_EVENT_RTC);
@@ -999,11 +998,6 @@ static void rtc_wake_off(struct device *dev)
 {
 	acpi_disable_event(ACPI_EVENT_RTC, 0);
 }
-#else
-#define rtc_wake_setup()	do{}while(0)
-#define rtc_wake_on		NULL
-#define rtc_wake_off		NULL
-#endif
 
 /* Every ACPI platform has a mc146818 compatible "cmos rtc".  Here we find
  * its device node and pass extra config data.  This helps its driver use
-- 
1.7.0.4

