Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759427Ab2JYLQE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 07:16:04 -0400
Received: from mailbigip.dreamhost.com ([208.97.132.5]:59392 "EHLO
	homiemail-a5.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S935566Ab2JYLP4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 07:15:56 -0400
Message-ID: <1351163753.2513.17.camel@offbook>
Subject: [PATCH RESEND 3/3] partitions: efi: check minimum header size
From: Davidlohr Bueso <dave@gnu.org>
Reply-To: dave@gnu.org
To: Jens Axboe <axboe@kernel.dk>, Matt Domsch <Matt_Domsch@dell.com>
Cc: lkml <linux-kernel@vger.kernel.org>
Date: Thu, 25 Oct 2012 13:15:53 +0200
Organization: GNU
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As per UEFI specs 2.3.1 (June 2012),
"The Header Size must be greater than 92 and must be less than
or equal to the logical block size"

Signed-off-by: Davidlohr Bueso <dave@gnu.org>
---
 block/partitions/efi.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/block/partitions/efi.c b/block/partitions/efi.c
index abf33a2..688b59c 100644
--- a/block/partitions/efi.c
+++ b/block/partitions/efi.c
@@ -25,6 +25,9 @@
  * TODO:
  *
  * Changelog:
+ * Oct 2012 Davidlohr Bueso <dave@gnu.org>
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
+	if (le32_to_cpu((*gpt)->header_size) < 92 ||
+	    le32_to_cpu((*gpt)->header_size) > bdev_logical_block_size(state->bdev)) {
 		pr_debug("GUID Partition Table Header size is wrong: %u > %u\n",
 			le32_to_cpu((*gpt)->header_size),
 			bdev_logical_block_size(state->bdev));
-- 
1.7.9.5





