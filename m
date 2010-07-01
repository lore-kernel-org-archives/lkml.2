Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758216Ab0GAS0F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 14:26:05 -0400
Received: from kroah.org ([198.145.64.141]:40884 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758183Ab0GASYg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 14:24:36 -0400
X-Mailbox-Line: From gregkh@clark.site Thu Jul  1 10:32:19 2010
Message-Id: <20100701173219.075761079@clark.site>
User-Agent: quilt/0.48-10.1
Date: Thu, 01 Jul 2010 10:32:51 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Mikulas Patocka <mpatocka@redhat.com>,
       Alasdair G Kergon <agk@redhat.com>
Subject: [patch 145/149] dm snapshot: simplify sector_to_chunk expression
In-Reply-To: <20100701175144.GA2116@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

commit 102c6ddb1d081a6a1fede38c43a42c9811313ec7 upstream.

Removed unnecessary 'and' masking: The right shift discards the lower
bits so there is no need to clear them.

(A later patch needs this change to support a 32-bit chunk_mask.)

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Reviewed-by: Mike Snitzer <snitzer@redhat.com>
Reviewed-by: Jonathan Brassow <jbrassow@redhat.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/md/dm-exception-store.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/md/dm-exception-store.h
+++ b/drivers/md/dm-exception-store.h
@@ -162,7 +162,7 @@ static inline sector_t get_dev_size(stru
 static inline chunk_t sector_to_chunk(struct dm_exception_store *store,
 				      sector_t sector)
 {
-	return (sector & ~store->chunk_mask) >> store->chunk_shift;
+	return sector >> store->chunk_shift;
 }
 
 int dm_exception_store_type_register(struct dm_exception_store_type *type);


