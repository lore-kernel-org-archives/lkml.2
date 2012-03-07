Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965181Ab2CGWAA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 17:00:00 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:34731 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030251Ab2CGV6p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 16:58:45 -0500
From: John Stultz <john.stultz@linaro.org>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Colin Cross <ccross@android.com>, Greg KH <gregkh@linuxfoundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 12/13] android: staging: ram_console: fix crash in ram_console_late_init
Date: Wed,  7 Mar 2012 13:58:22 -0800
Message-Id: <1331157503-3413-13-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.3.2.146.gca209
In-Reply-To: <1331157503-3413-1-git-send-email-john.stultz@linaro.org>
References: <1331157503-3413-1-git-send-email-john.stultz@linaro.org>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12030721-9360-0000-0000-00000455D5EC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Colin Cross <ccross@android.com>

If the persistent ram buffer is not available, ram_console_late_init
would crash when dereferencing ram_console_zone.  Return early if
ram console was not initialized.

CC: Greg KH <gregkh@linuxfoundation.org>
CC: Android Kernel Team <kernel-team@android.com>
Change-Id: Idff0f690406cdb2fe977bab64a39dc8b40dd4566
Signed-off-by: Colin Cross <ccross@android.com>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/staging/android/ram_console.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/android/ram_console.c b/drivers/staging/android/ram_console.c
index 29d347e..d956b84 100644
--- a/drivers/staging/android/ram_console.c
+++ b/drivers/staging/android/ram_console.c
@@ -150,6 +150,9 @@ static int __init ram_console_late_init(void)
 	struct proc_dir_entry *entry;
 	struct persistent_ram_zone *prz = ram_console_zone;
 
+	if (!prz)
+		return 0;
+
 	if (persistent_ram_old_size(prz) == 0)
 		return 0;
 
-- 
1.7.3.2.146.gca209

