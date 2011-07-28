Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754768Ab1G1FRi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 01:17:38 -0400
Received: from mail.windriver.com ([147.11.1.11]:51310 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754678Ab1G1FQh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 01:16:37 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: mingo@elte.hu, torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        linux-arch@vger.kernel.org
Subject: [PATCH 08/11] uwb.h: fix implicit use of asm/page.h for PAGE_SIZE
Date: Thu, 28 Jul 2011 01:16:15 -0400
Message-Id: <1311830178-30314-9-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1311830178-30314-1-git-send-email-paul.gortmaker@windriver.com>
References: <1311830178-30314-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Once we clean up the implicit presence of module.h (and all its
sub-includes), we'll see an implicit dependency on page.h for
the PAGE_SIZE define.  So fix it in advance.

Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 include/linux/uwb.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/linux/uwb.h b/include/linux/uwb.h
index b0c564e..7dbbee9 100644
--- a/include/linux/uwb.h
+++ b/include/linux/uwb.h
@@ -33,6 +33,7 @@
 #include <linux/wait.h>
 #include <linux/workqueue.h>
 #include <linux/uwb/spec.h>
+#include <asm/page.h>
 
 struct uwb_dev;
 struct uwb_beca_e;
-- 
1.7.6

