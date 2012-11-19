Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752941Ab2KSF3K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 00:29:10 -0500
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:52543 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752914Ab2KSF3H convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 00:29:07 -0500
X-Originating-IP: 217.70.178.149
X-Originating-IP: 50.43.39.152
From: Josh Triplett <josh@joshtriplett.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Josh Triplett <josh@joshtriplett.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 07/58] lib/iommu-helper.c: Include <linux/iommu-helper.h> for function prototypes
Date: Sun, 18 Nov 2012 21:27:46 -0800
Message-Id: <1353302917-13995-8-git-send-email-josh@joshtriplett.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1353302917-13995-1-git-send-email-josh@joshtriplett.org>
References: <1353302917-13995-1-git-send-email-josh@joshtriplett.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

C files should include the header files that prototype their functions.
This keeps the types in sync, and eliminates warnings from GCC
(-Wmissing-prototypes) and Sparse (-Wdecl).

lib/iommu-helper.c:9:5: warning: no previous prototype for ‘iommu_is_span_boundary’ [-Wmissing-prototypes]
lib/iommu-helper.c:19:15: warning: no previous prototype for ‘iommu_area_alloc’ [-Wmissing-prototypes]

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
---
 lib/iommu-helper.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/lib/iommu-helper.c b/lib/iommu-helper.c
index c27e269..41d35fb 100644
--- a/lib/iommu-helper.c
+++ b/lib/iommu-helper.c
@@ -5,6 +5,7 @@
 #include <linux/export.h>
 #include <linux/bitmap.h>
 #include <linux/bug.h>
+#include <linux/iommu-helper.h>
 
 int iommu_is_span_boundary(unsigned int index, unsigned int nr,
 			   unsigned long shift,
-- 
1.7.10.4

