Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756573Ab2HQOHl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 10:07:41 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:59522 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756443Ab2HQOHa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 10:07:30 -0400
From: Ming Lei <ming.lei@canonical.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Borislav Petkov <borislav.petkov@amd.com>,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        Ming Lei <ming.lei@canonical.com>
Subject: [PATCH v1 1/3] firmware loader: fix compile failure if !PM
Date: Fri, 17 Aug 2012 22:06:58 +0800
Message-Id: <1345212420-1707-2-git-send-email-ming.lei@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1345212420-1707-1-git-send-email-ming.lei@canonical.com>
References: <1345212420-1707-1-git-send-email-ming.lei@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

'return 0' should be added to fw_pm_notify if !PM because
return value of the funcion is defined as 'int'.

Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Ming Lei <ming.lei@canonical.com>
---
 drivers/base/firmware_class.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index 5bd2100..4c8d8ef 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -1242,7 +1242,9 @@ static int fw_pm_notify(struct notifier_block *notify_block,
 #else
 static int fw_pm_notify(struct notifier_block *notify_block,
 			unsigned long mode, void *unused)
-{}
+{
+	return 0;
+}
 #endif
 
 static void __init fw_cache_init(void)
-- 
1.7.9.5

