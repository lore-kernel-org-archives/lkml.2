Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934780Ab0KQMb1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 07:31:27 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:35513 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934050Ab0KQMb0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 07:31:26 -0500
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH] x86,
 mrst: add explalation for using 1960 as the year offset for vrtc
 device
To: linux-kernel@vger.kernel.org, x86@kernel.org
Date: Wed, 17 Nov 2010 12:11:24 +0000
Message-ID: <20101117121050.9998.89348.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Feng Tang <feng.tang@intel.com>

Explain the reason for the apparently odd choice of year offset so we don't
get more questions about it.

Signed-off-by: Feng Tang <feng.tang@intel.com>
Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/rtc/rtc-mrst.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)


diff --git a/drivers/rtc/rtc-mrst.c b/drivers/rtc/rtc-mrst.c
index 67b6be2..bcd0cf6 100644
--- a/drivers/rtc/rtc-mrst.c
+++ b/drivers/rtc/rtc-mrst.c
@@ -66,7 +66,11 @@ static inline int is_intr(u8 rtc_intr)
  * rtc_time's year contains the increment over 1900, but vRTC's YEAR
  * register can't be programmed to value larger than 0x64, so vRTC
  * driver chose to use 1960 (1970 is UNIX time start point) as the base,
- * and does the translation at read/write time
+ * and does the translation at read/write time.
+ *
+ * Why not just use 1970 as the offset? it's because using 1960 will
+ * make it consistent in leap year setting for both vrtc and low-level
+ * physical rtc devices.
  */
 static int mrst_read_time(struct device *dev, struct rtc_time *time)
 {

