Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965217Ab2CGWAd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 17:00:33 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:51138 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758518Ab2CGV6m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 16:58:42 -0500
From: John Stultz <john.stultz@linaro.org>
To: lkml <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Greg KH <gregkh@linuxfoundation.org>,
        Android Kernel Team <kernel-team@android.com>
Subject: [PATCH 01/13] android: lowmemorykiller: Fix warning on 64bit
Date: Wed,  7 Mar 2012 13:58:11 -0800
Message-Id: <1331157503-3413-2-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.3.2.146.gca209
In-Reply-To: <1331157503-3413-1-git-send-email-john.stultz@linaro.org>
References: <1331157503-3413-1-git-send-email-john.stultz@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12030721-7182-0000-0000-000000FDF945
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes the following warning on 64bit:
drivers/staging/android/lowmemorykiller.c: In function ‘__check_minfree’:
drivers/staging/android/lowmemorykiller.c:215: warning: return from incompatible pointer type

CC: Greg KH <gregkh@linuxfoundation.org>
CC: Android Kernel Team <kernel-team@android.com>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/staging/android/lowmemorykiller.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/android/lowmemorykiller.c b/drivers/staging/android/lowmemorykiller.c
index 052b43e..15a59c1 100644
--- a/drivers/staging/android/lowmemorykiller.c
+++ b/drivers/staging/android/lowmemorykiller.c
@@ -212,7 +212,7 @@ static void __exit lowmem_exit(void)
 module_param_named(cost, lowmem_shrinker.seeks, int, S_IRUGO | S_IWUSR);
 module_param_array_named(adj, lowmem_adj, int, &lowmem_adj_size,
 			 S_IRUGO | S_IWUSR);
-module_param_array_named(minfree, lowmem_minfree, uint, &lowmem_minfree_size,
+module_param_array_named(minfree, lowmem_minfree, ulong, &lowmem_minfree_size,
 			 S_IRUGO | S_IWUSR);
 module_param_named(debug_level, lowmem_debug_level, uint, S_IRUGO | S_IWUSR);
 
-- 
1.7.3.2.146.gca209

