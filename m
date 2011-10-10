Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753363Ab1JJKNP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 06:13:15 -0400
Received: from www.0x90.at ([78.46.59.21]:22640 "EHLO mail.0x90.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753097Ab1JJKNO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 06:13:14 -0400
X-Greylist: delayed 662 seconds by postgrey-1.27 at vger.kernel.org; Mon, 10 Oct 2011 06:13:14 EDT
Date: Mon, 10 Oct 2011 12:05:55 +0200
From: Daniel Walter <d.walter@0x90.at>
To: rui.zhang@intel.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH][TRIVIAL] [thermal] fix unused variable warning
Message-ID: <20111010100555.GA33394@0x90.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[thermal] fix unused variable warning 

thermal_event_seqnum is only used if CONFIG_NET is defined.

Signed-off-by: Daniel Walter <d.walter@0x90.at>
---
 drivers/thermal/thermal_sys.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)
---
diff --git a/drivers/thermal/thermal_sys.c b/drivers/thermal/thermal_sys.c
index 708f8e9..def02da 100644
--- a/drivers/thermal/thermal_sys.c
+++ b/drivers/thermal/thermal_sys.c
@@ -60,7 +60,9 @@ static LIST_HEAD(thermal_tz_list);
 static LIST_HEAD(thermal_cdev_list);
 static DEFINE_MUTEX(thermal_list_lock);
 
+#ifdef CONFIG_NET
 static unsigned int thermal_event_seqnum;
+#endif /* CONFIG_NET */
 
 static int get_idr(struct idr *idr, struct mutex *lock, int *id)
 {
