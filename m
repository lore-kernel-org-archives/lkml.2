Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754125Ab1LUBe1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 20:34:27 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:45559 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754082Ab1LUBeZ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 20:34:25 -0500
Message-ID: <1324431260.2844.150.camel@deadeye>
Subject: [PATCH 5/8] [SCSI] tgt: Pass pointers to virt_to_page(), not
 integers
From: Ben Hutchings <ben@decadent.org.uk>
To: "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Date: Wed, 21 Dec 2011 01:34:20 +0000
In-Reply-To: <1324430940.2844.144.camel@deadeye>
References: <1324430940.2844.144.camel@deadeye>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.2-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Most architectures define virt_to_page() as a macro that casts its
argument such that an argument of type unsigned long will be accepted
without complaint.  However, the proper type is void *, and passing
unsigned long results in a warning on MIPS.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/scsi/scsi_tgt_if.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/scsi_tgt_if.c b/drivers/scsi/scsi_tgt_if.c
index 6209110..7199753 100644
--- a/drivers/scsi/scsi_tgt_if.c
+++ b/drivers/scsi/scsi_tgt_if.c
@@ -286,7 +286,7 @@ static int uspace_ring_map(struct vm_area_struct *vma, unsigned long addr,
 	int i, err;
 
 	for (i = 0; i < TGT_RING_PAGES; i++) {
-		struct page *page = virt_to_page(ring->tr_pages[i]);
+		struct page *page = virt_to_page((void *)ring->tr_pages[i]);
 		err = vm_insert_page(vma, addr, page);
 		if (err)
 			return err;
-- 
1.7.7.3



