Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758142Ab0EKC5P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 22:57:15 -0400
Received: from sh.osrg.net ([192.16.179.4]:46177 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757769Ab0EKC5K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 22:57:10 -0400
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp
Subject: [PATCH -mm 2/3] Documentation: update scatterlist struct description in DMA-API-HOWTO
Date: Tue, 11 May 2010 11:55:28 +0900
Message-Id: <1273546529-16846-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.6.5
In-Reply-To: <1273546529-16846-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1273546529-16846-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Tue, 11 May 2010 11:56:34 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now we have <asm-generic/scatterlist.h>. Architectures should use it
instead of inventing the own scatterlist struct. Let's update the
description.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 Documentation/DMA-API-HOWTO.txt |   17 ++++-------------
 1 files changed, 4 insertions(+), 13 deletions(-)

diff --git a/Documentation/DMA-API-HOWTO.txt b/Documentation/DMA-API-HOWTO.txt
index a38ddad..c3ab456 100644
--- a/Documentation/DMA-API-HOWTO.txt
+++ b/Documentation/DMA-API-HOWTO.txt
@@ -703,19 +703,10 @@ to "Closing".
 
 1) Struct scatterlist requirements.
 
-   Struct scatterlist must contain, at a minimum, the following
-   members:
-
-	struct page *page;
-	unsigned int offset;
-	unsigned int length;
-
-   The base address is specified by a "page+offset" pair.
-
-   Previous versions of struct scatterlist contained a "void *address"
-   field that was sometimes used instead of page+offset.  As of Linux
-   2.5., page+offset is always used, and the "address" field has been
-   deleted.
+   Don't invent the architecture specific struct scatterlist; just use
+   <asm-generic/scatterlist.h>. You need to enable
+   CONFIG_NEED_SG_DMA_LENGTH if the architecture supports IOMMUs
+   (including software IOMMU).
 
 2) More to come...
 
-- 
1.6.5

