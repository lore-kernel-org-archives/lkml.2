Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760310Ab0HLPmn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 11:42:43 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:62137 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933806Ab0HLPm1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 11:42:27 -0400
MIME-version: 1.0
Content-transfer-encoding: 8BIT
Content-type: text/plain; charset=UTF-8
Date: Thu, 12 Aug 2010 17:43:56 +0200
From: Michal Nazarewicz <m.nazarewicz@samsung.com>
Subject: [PATCHv8 13/13] init.h: add some more documentation to __ref* tags
In-reply-to: <c4e57f3ae9153e524e7422527ef5e7351c1cf10c.1281625724.git.m.nazarewicz@samsung.com>
To: linux-usb@vger.kernel.org, Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Sam Ravnborg <sam@ravnborg.org>
Message-id: <596c51e49e129c14531a6367ea7b321ee541bdb5.1281625724.git.m.nazarewicz@samsung.com>
X-Mailer: git-send-email 1.7.1
iPlanet-SMTP-Warning: Lines longer than SMTP allows found and truncated.
References: <cover.1281625724.git.m.nazarewicz@samsung.com>
 <76f0f5732bfbbb36d50baf05ecdd12bec3396275.1281625724.git.m.nazarewicz@samsung.com>
 <313ee18ecf53fb8f1c040656b697de869f0c0856.1281625724.git.m.nazarewicz@samsung.com>
 <48e2d6507f004252a012cf25bc0a06e5cb69808f.1281625724.git.m.nazarewicz@samsung.com>
 <f2f6babb8b593d5c6f6141604bd647658d59f124.1281625724.git.m.nazarewicz@samsung.com>
 <4addd8199cfd6a2aa582904cd6efa01bc77a5290.1281625724.git.m.nazarewicz@samsung.com>
 <9737a711d395932c8803511ba581722d46be5292.1281625724.git.m.nazarewicz@samsung.com>
 <f07e8ff5f36d5893e62764b9e372da0cc305a2b5.1281625724.git.m.nazarewicz@samsung.com>
 <550ddf8273d87cb418dd5716cbec906e74aa03d4.1281625724.git.m.nazarewicz@samsung.com>
 <ad117de19af4733f113c8631e53556cc308dbf06.1281625724.git.m.nazarewicz@samsung.com>
 <340f780f91de1b3ca17d0c29d87963205d172f4e.1281625724.git.m.nazarewicz@samsung.com>
 <cfb1102e8bd59822b76475d58f5e4f1ceadade50.1281625724.git.m.nazarewicz@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The __ref* tags may have been confusing for new kernel
developers (I was confused by them for sure) so adding a few
more sentences to comment to clear things up for people who
see those for the first time.

Signed-off-by: Michal Nazarewicz <m.nazarewicz@samsung.com>
Acked-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Cc: Sam Ravnborg <sam@ravnborg.org>
---
 include/linux/init.h |   13 ++++++++++---
 1 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/include/linux/init.h b/include/linux/init.h
index de99430..577671c 100644
--- a/include/linux/init.h
+++ b/include/linux/init.h
@@ -46,16 +46,23 @@
 #define __exitdata	__section(.exit.data)
 #define __exit_call	__used __section(.exitcall.exit)
 
-/* modpost check for section mismatches during the kernel build.
+/*
+ * modpost check for section mismatches during the kernel build.
  * A section mismatch happens when there are references from a
  * code or data section to an init section (both code or data).
  * The init sections are (for most archs) discarded by the kernel
  * when early init has completed so all such references are potential bugs.
  * For exit sections the same issue exists.
+ *
  * The following markers are used for the cases where the reference to
  * the *init / *exit section (code or data) is valid and will teach
- * modpost not to issue a warning.
- * The markers follow same syntax rules as __init / __initdata. */
+ * modpost not to issue a warning.  Intended semantics is that a code or
+ * data tagged __ref* can reference code or data from init section without
+ * producing a warning (of course, no warning does not mean code is
+ * correct, so optimally document why the __ref is needed and why it's OK).
+ *
+ * The markers follow same syntax rules as __init / __initdata.
+ */
 #define __ref            __section(.ref.text) noinline
 #define __refdata        __section(.ref.data)
 #define __refconst       __section(.ref.rodata)
-- 
1.7.1

