Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751884Ab2KEBmw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2012 20:42:52 -0500
Received: from mail-wg0-f42.google.com ([74.125.82.42]:58929 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751035Ab2KEBmu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2012 20:42:50 -0500
MIME-Version: 1.0
Date: Mon, 5 Nov 2012 09:42:48 +0800
Message-ID: <CAFNq8R651qOYWbmEsbHsG=oJScgTZRCN9naSQ1YVp5AdAmJBXw@mail.gmail.com>
Subject: [PATCH] Fixup compile error of try_to_freeze_nowarn
From: Li Haifeng <omycle@gmail.com>
To: Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: [PATCH] Fixup compile error of try_to_freeze_nowarn

If FREEZER is not defined, the error as following will be throw
when compiled.
arch/arm/kernel/signal.c:645: error: implicit declaration of function
'try_to_freeze_nowarn'

Signed-off-by: Haifeng Li <omycle@gmail.com>
---
 include/linux/freezer.h |    1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/freezer.h b/include/linux/freezer.h
index a628084..3c0c1fb 100644
--- a/include/linux/freezer.h
+++ b/include/linux/freezer.h
@@ -188,6 +188,7 @@ static inline int freeze_kernel_threads(void) {
return -ENOSYS; }
 static inline void thaw_processes(void) {}
 static inline void thaw_kernel_threads(void) {}

+static inline bool try_to_freeze_nowarn(void) { return false; }
 static inline bool try_to_freeze(void) { return false; }

 static inline void freezer_do_not_count(void) {}
--
1.7.9.5
