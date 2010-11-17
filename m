Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753415Ab0KQM6D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 07:58:03 -0500
Received: from hera.kernel.org ([140.211.167.34]:51948 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750722Ab0KQM6B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 07:58:01 -0500
Date: Wed, 17 Nov 2010 12:57:44 GMT
From: tip-bot for Feng Tang <feng.tang@intel.com>
Cc: linux-kernel@vger.kernel.org, alan@linux.intel.com, hpa@zytor.com,
        mingo@redhat.com, tglx@linutronix.de, feng.tang@intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, alan@linux.intel.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, feng.tang@intel.com
In-Reply-To: <20101117121050.9998.89348.stgit@localhost.localdomain>
References: <20101117121050.9998.89348.stgit@localhost.localdomain>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/platform] x86, mrst: Add explanation for using 1960 as the year offset for vrtc
Message-ID: <tip-d3e1884bc585a43674d2cb0d3f0aeeb0ae43bc04@git.kernel.org>
Git-Commit-ID: d3e1884bc585a43674d2cb0d3f0aeeb0ae43bc04
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 17 Nov 2010 12:57:44 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d3e1884bc585a43674d2cb0d3f0aeeb0ae43bc04
Gitweb:     http://git.kernel.org/tip/d3e1884bc585a43674d2cb0d3f0aeeb0ae43bc04
Author:     Feng Tang <feng.tang@intel.com>
AuthorDate: Wed, 17 Nov 2010 12:11:24 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 17 Nov 2010 13:53:46 +0100

x86, mrst: Add explanation for using 1960 as the year offset for vrtc

Explain the reason for the apparently odd choice of year offset so we don't
get more questions about it.

Signed-off-by: Feng Tang <feng.tang@intel.com>
Signed-off-by: Alan Cox <alan@linux.intel.com>
LKML-Reference: <20101117121050.9998.89348.stgit@localhost.localdomain>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
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
