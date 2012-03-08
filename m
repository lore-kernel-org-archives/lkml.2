Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754519Ab2CHBgk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 20:36:40 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:49148 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751001Ab2CHBew (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 20:34:52 -0500
From: John Stultz <john.stultz@linaro.org>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Dima Zavin <dima@android.com>, Greg KH <gregkh@linuxfoundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 01/11] android: ram_console: set CON_ANYTIME console flag
Date: Wed,  7 Mar 2012 17:34:28 -0800
Message-Id: <1331170478-30538-2-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.3.2.146.gca209
In-Reply-To: <1331170478-30538-1-git-send-email-john.stultz@linaro.org>
References: <1331170478-30538-1-git-send-email-john.stultz@linaro.org>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12030801-5806-0000-0000-0000133C7486
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dima Zavin <dima@android.com>

We want to ensure that we get all the console messages, even ones
that occur while the printing CPU is not yet online.

[jstultz: tweaked commit subject line]
CC: Greg KH <gregkh@linuxfoundation.org>
CC: Android Kernel Team <kernel-team@android.com>
Signed-off-by: Dima Zavin <dima@android.com>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/staging/android/ram_console.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/android/ram_console.c b/drivers/staging/android/ram_console.c
index fabd398..f01a0c4 100644
--- a/drivers/staging/android/ram_console.c
+++ b/drivers/staging/android/ram_console.c
@@ -143,7 +143,7 @@ ram_console_write(struct console *console, const char *s, unsigned int count)
 static struct console ram_console = {
 	.name	= "ram",
 	.write	= ram_console_write,
-	.flags	= CON_PRINTBUFFER | CON_ENABLED,
+	.flags	= CON_PRINTBUFFER | CON_ENABLED | CON_ANYTIME,
 	.index	= -1,
 };
 
-- 
1.7.3.2.146.gca209

