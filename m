Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756482Ab1G2NM0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 09:12:26 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:47792 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756061Ab1G2NMZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 09:12:25 -0400
Subject: ramoops: fix compile failure on parisc
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Marco Stornelli <marco.stornelli@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Parisc List <linux-parisc@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 29 Jul 2011 17:11:32 +0400
Message-ID: <1311945092.8190.34.camel@mulgrave>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/char/ramoops.c: In function 'ramoops_init':
drivers/char/ramoops.c:221: error: implicit declaration of function 'IS_ERR'
drivers/char/ramoops.c:222: error: implicit declaration of function 'PTR_ERR'

If it actually builds on other platforms, it's probably getting
linux/err.h via some other #include.

Signed-off-by: James Bottomley <JBottomley@Parallels.com>

---

diff --git a/drivers/char/ramoops.c b/drivers/char/ramoops.c
index bd9b94b..fca0c51 100644
--- a/drivers/char/ramoops.c
+++ b/drivers/char/ramoops.c
@@ -22,6 +22,7 @@
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <linux/kernel.h>
+#include <linux/err.h>
 #include <linux/module.h>
 #include <linux/kmsg_dump.h>
 #include <linux/time.h>


