Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933928Ab1ESScZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 14:32:25 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:38623 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933788Ab1ESScW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 14:32:22 -0400
X-Sasl-enc: 0dm1gprzsNdeWdUT3p7oKMCwXfI9ZbdSDzwdPrdzH5KQ 1305829941
X-Mailbox-Line: From gregkh@clark.kroah.org Thu May 19 11:31:25 2011
Message-Id: <20110519183125.761919408@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 19 May 2011 11:30:34 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Timo Warns <warns@pre-sense.de>
Subject: [02/24] Validate size of EFI GUID partition entries.
In-Reply-To: <20110519182446.GA23751@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-longterm review patch.  If anyone has any objections, please let us know.

------------------
Content-Length: 822
Lines: 30

From: Timo Warns <Warns@pre-sense.de>

commit fa039d5f6b126fbd65eefa05db2f67e44df8f121 upstream.

Otherwise corrupted EFI partition tables can cause total confusion.

Signed-off-by: Timo Warns <warns@pre-sense.de>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/partitions/efi.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/fs/partitions/efi.c
+++ b/fs/partitions/efi.c
@@ -349,6 +349,12 @@ is_gpt_valid(struct block_device *bdev,
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
 


