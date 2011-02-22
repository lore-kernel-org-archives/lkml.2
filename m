Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751370Ab1BVUOU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 15:14:20 -0500
Received: from g1t0028.austin.hp.com ([15.216.28.35]:16388 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750813Ab1BVUOS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 15:14:18 -0500
Subject: [PATCH 1/6] cciss: host tag masking out of loop
To: axboe@kernel.dk
From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: mikem@beardog.cce.hp.com, akpm@linux-foundation.org, thenzl@redhat.com,
        linux-kernel@vger.kernel.org, smcameron@yahoo.com
Date: Tue, 22 Feb 2011 14:14:16 -0600
Message-ID: <20110222201416.21961.93838.stgit@beardog.cce.hp.com>
In-Reply-To: <20110222201025.21961.82560.stgit@beardog.cce.hp.com>
References: <20110222201025.21961.82560.stgit@beardog.cce.hp.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

In process_nonindexed_cmd, hoist figuring of masked tag out of loop since
it is the same throughout.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/block/cciss.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index 9279272..bbf82e5 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -3400,14 +3400,12 @@ static inline u32 process_indexed_cmd(ctlr_info_t *h, u32 raw_tag)
 /* process completion of a non-indexed command */
 static inline u32 process_nonindexed_cmd(ctlr_info_t *h, u32 raw_tag)
 {
-	u32 tag;
 	CommandList_struct *c = NULL;
 	__u32 busaddr_masked, tag_masked;
 
-	tag = cciss_tag_discard_error_bits(raw_tag);
+	tag_masked = cciss_tag_discard_error_bits(raw_tag);
 	list_for_each_entry(c, &h->cmpQ, list) {
 		busaddr_masked = cciss_tag_discard_error_bits(c->busaddr);
-		tag_masked = cciss_tag_discard_error_bits(tag);
 		if (busaddr_masked == tag_masked) {
 			finish_cmd(h, c, raw_tag);
 			return next_command(h);

