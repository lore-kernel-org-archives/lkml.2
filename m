Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754537Ab1JMKDF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 06:03:05 -0400
Received: from smtp.citrix.com ([66.165.176.89]:36945 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754425Ab1JMKDD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 06:03:03 -0400
X-IronPort-AV: E=Sophos;i="4.69,339,1315195200"; 
   d="scan'208";a="18184690"
From: Ian Campbell <ian.campbell@citrix.com>
To: linux-kernel@vger.kernel.org
CC: Ian Campbell <ian.campbell@citrix.com>,
        Christoph Hellwig <hch@infradead.org>,
        Jens Axboe <jaxboe@fusionio.com>, linux-mm@kvack.org
Subject: [PATCH] mm: add a "struct page_frag" type containing a page, offset and length
Date: Thu, 13 Oct 2011 11:02:56 +0100
Message-ID: <1318500176-10728-1-git-send-email-ian.campbell@citrix.com>
X-Mailer: git-send-email 1.7.2.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A few network drivers currently use skb_frag_struct for this purpose but I have
patches which add additional fields and semantics there which these other uses
do not want.

A structure for reference sub-page regions seems like a generally useful thing
so do so instead of adding a network subsystem specific structure.

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Jens Axboe <jaxboe@fusionio.com>
Cc: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
[since v1: s/struct subpage/struct page_frag/ on advice from Christoph]
---
 include/linux/mm_types.h |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 774b895..575faaf 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -135,6 +135,17 @@ struct page {
 #endif
 ;
 
+struct page_frag {
+	struct page *page;
+#if (BITS_PER_LONG > 32) || (PAGE_SIZE >= 65536)
+	__u32 page_offset;
+	__u32 size;
+#else
+	__u16 page_offset;
+	__u16 size;
+#endif
+};
+
 typedef unsigned long __nocast vm_flags_t;
 
 /*
-- 
1.7.2.5

