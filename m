Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753083Ab2BZUwo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Feb 2012 15:52:44 -0500
Received: from mail.windriver.com ([147.11.1.11]:52165 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753020Ab2BZUwn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Feb 2012 15:52:43 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: JBottomley@parallels.com, jejb@parisc-linux.org, kyle@mcmartin.ca,
        deller@gmx.de
Cc: linux-parisc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-next@vger.kernel.org, rientjes@google.com,
        xiyou.wangcong@gmail.com,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [PATCH] parisc: fix longstanding build failure on prefetch
Date: Sun, 26 Feb 2012 15:51:18 -0500
Message-Id: <1330289478-12603-1-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Upstream commit e66eed651fd18a961f11cda62f3b5286c8cc4f9f

    "list: remove prefetching from regular list iterators"

removed <linux/prefetch.h> from <linux/list.h> very early in the
v3.0 dev cycle (v2.6.39-2-ge66eed6), thereby causing build failures
when it exposed the implicit prefetch users in parisc.

Reported-by: David Rientjes <rientjes@google.com>
Reported-by: WANG Cong <xiyou.wangcong@gmail.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---

[ The parisc defconfig has been failing to build everywhere since
  last May!  http://kisskb.ellerman.id.au/kisskb/target/2059/   And this
  one liner fix https://lkml.org/lkml/2011/10/15/121 was reported last
  Oct, and again http://www.spinics.net/lists/linux-parisc/msg03945.html
  in early Feb.  So, now with a clear reasoning in the commit header as
  to why it fails, can we finally get this in tree please? ]

diff --git a/drivers/parisc/iommu-helpers.h b/drivers/parisc/iommu-helpers.h
index a9c46cc..8c33491 100644
--- a/drivers/parisc/iommu-helpers.h
+++ b/drivers/parisc/iommu-helpers.h
@@ -1,3 +1,5 @@
+#include <linux/prefetch.h>
+
 /**
  * iommu_fill_pdir - Insert coalesced scatter/gather chunks into the I/O Pdir.
  * @ioc: The I/O Controller.
-- 
1.7.9.1

