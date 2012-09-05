Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758338Ab2IEJSs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 05:18:48 -0400
Received: from caiajhbdcbbj.dreamhost.com ([208.97.132.119]:60546 "EHLO
	homiemail-a3.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758259Ab2IEJSq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 05:18:46 -0400
Subject: [PATCH 3/3] partitions: efi: check minimum header size
From: Davidlohr Bueso <dave@gnu.org>
Reply-To: dave@gnu.org
To: Jens Axboe <axboe@kernel.dk>, Matt Domsch <Matt_Domsch@dell.com>
Cc: lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Organization: GNU
Date: Wed, 05 Sep 2012 11:18:43 +0200
Message-ID: <1346836723.2559.6.camel@offbook>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As per UEFI specs 2.3.1 (June 2012),
"The Header Size must be greater than 92 and must be less than
or equal to the logical block size"

Signed-off-by: Davidlohr Bueso <dave@gnu.org>
---
 block/partitions/efi.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/block/partitions/efi.c b/block/partitions/efi.c
index abf33a2..3a5114e 100644
--- a/block/partitions/efi.c
+++ b/block/partitions/efi.c
@@ -25,6 +25,9 @@
  * TODO:
  *
  * Changelog:
+ * Sept. 2012 Davidlohr Bueso <dave@gnu.org>
+ * - tighten GPT header integrity verification.
+ *
  * Mon Nov 09 2004 Matt Domsch <Matt_Domsch@dell.com>
  * - test for valid PMBR and valid PGPT before ever reading
  *   AGPT, allow override with 'gpt' kernel command line option.
@@ -311,8 +314,8 @@ static int is_gpt_valid(struct parsed_partitions *state, u64 lba,
 	}
 
 	/* Check the GUID Partition Table header size */
-	if (le32_to_cpu((*gpt)->header_size) >
-			bdev_logical_block_size(state->bdev)) {
+	if (le32_to_cpu((*gpt)->header_size) <= 92 ||
+	    le32_to_cpu((*gpt)->header_size) > bdev_logical_block_size(state->bdev)) {
 		pr_debug("GUID Partition Table Header size is wrong: %u > %u\n",
 			le32_to_cpu((*gpt)->header_size),
 			bdev_logical_block_size(state->bdev));
-- 
1.7.4.1




