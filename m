Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755596Ab0JONah (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 09:30:37 -0400
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:20042 "EHLO
	TX2EHSOBE009.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754545Ab0JONag (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 09:30:36 -0400
X-SpamScore: 1
X-BigFish: VS1(zzzz1202hzz8275bhz32i87h2a8h43h65h)
X-Spam-TCS-SCL: 4:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0LAC2UD-02-FS8-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: oprofile-list <oprofile-list@lists.sf.net>,
        lkml <linux-kernel@vger.kernel.org>,
        Matt Fleming <matt@console-pimps.org>,
        Will Deacon <will.deacon@arm.com>,
        Robert Richter <robert.richter@amd.com>
Subject: [PATCH] oprofile: make !CONFIG_PM function stubs static inline
Date: Fri, 15 Oct 2010 15:27:25 +0200
Message-ID: <1287149245-31169-1-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.3.1
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make !CONFIG_PM function stubs static inline and remove section
attribute.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 drivers/oprofile/oprofile_perf.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/oprofile/oprofile_perf.c b/drivers/oprofile/oprofile_perf.c
index 36ec67e..9046f7b 100644
--- a/drivers/oprofile/oprofile_perf.c
+++ b/drivers/oprofile/oprofile_perf.c
@@ -190,6 +190,7 @@ static void oprofile_perf_stop(void)
 }
 
 #ifdef CONFIG_PM
+
 static int oprofile_perf_suspend(struct platform_device *dev, pm_message_t state)
 {
 	mutex_lock(&oprofile_perf_mutex);
@@ -241,9 +242,12 @@ static void exit_driverfs(void)
 	platform_device_unregister(oprofile_pdev);
 	platform_driver_unregister(&oprofile_driver);
 }
+
 #else
-static int __init init_driverfs(void) { return 0; }
-#define exit_driverfs() do { } while (0)
+
+static inline int  init_driverfs(void) { return 0; }
+static inline void exit_driverfs(void) { }
+
 #endif /* CONFIG_PM */
 
 void oprofile_perf_exit(void)
-- 
1.7.3.1


