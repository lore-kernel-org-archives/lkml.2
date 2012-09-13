Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758615Ab2IMUVJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 16:21:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51500 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757215Ab2IMUVF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 16:21:05 -0400
Date: Thu, 13 Sep 2012 16:21:04 -0400
From: Rik van Riel <riel@redhat.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Mel Gorman <mel@csn.ul.ie>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH -mm] enable CONFIG_COMPACTION by default
Message-ID: <20120913162104.1458bea2@cuia.bos.redhat.com>
Organization: Red Hat, Inc
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that lumpy reclaim has been removed, compaction is the
only way left to free up contiguous memory areas. It is time
to just enable CONFIG_COMPACTION by default.
    
Signed-off-by: Rik van Riel <riel@redhat.com>

diff --git a/mm/Kconfig b/mm/Kconfig
index d5c8019..32ea0ef 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -191,6 +191,7 @@ config SPLIT_PTLOCK_CPUS
 # support for memory compaction
 config COMPACTION
 	bool "Allow for memory compaction"
+	def_bool y
 	select MIGRATION
 	depends on MMU
 	help
