Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755260Ab2BEWuw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Feb 2012 17:50:52 -0500
Received: from 1wt.eu ([62.212.114.60]:61815 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753298Ab2BEW0I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Feb 2012 17:26:08 -0500
Message-Id: <20120205220950.259230674@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Sun, 05 Feb 2012 23:10:08 +0100
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Timo Warns <warns@pre-sense.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg KH <gregkh@linuxfoundation.org>
Subject: [PATCH 19/91] Validate size of EFI GUID partition entries.
In-Reply-To: <0635750f5f06ed2ca212b91fcb5c4483@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-longterm review patch.  If anyone has any objections, please let us know.

------------------

commit fa039d5f6b126fbd65eefa05db2f67e44df8f121 upstream.

Otherwise corrupted EFI partition tables can cause total confusion.

Signed-off-by: Timo Warns <warns@pre-sense.de>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/partitions/efi.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

Index: longterm-2.6.27/fs/partitions/efi.c
===================================================================
--- longterm-2.6.27.orig/fs/partitions/efi.c	2012-02-05 22:34:34.453915054 +0100
+++ longterm-2.6.27/fs/partitions/efi.c	2012-02-05 22:34:37.590915121 +0100
@@ -343,6 +343,12 @@
 		goto fail;
 	}
 
+	/* Check that sizeof_partition_entry has the correct value */
+	if (le32_to_cpu((*gpt)->sizeof_partition_entry) != sizeof(gpt_entry)) {
+		pr_debug("GUID Partitition Entry Size check failed.\n");
+		goto fail;
+	}
+
 	if (!(*ptes = alloc_read_gpt_entries(bdev, *gpt)))
 		goto fail;
 


