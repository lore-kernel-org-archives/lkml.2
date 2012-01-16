Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756108Ab2APSsL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 13:48:11 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42733 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755801Ab2APSsI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 13:48:08 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Jan 16 10:45:16 2012
Message-Id: <20120116184515.982076917@clark.kroah.org>
User-Agent: quilt/0.50-25.1
Date: Mon, 16 Jan 2012 10:44:29 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Roman Tereshonkov <roman.tereshonkov@nokia.com>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        David Woodhouse <David.Woodhouse@intel.com>
Subject: [02/48] mtd: mtdoops: skip reading initially bad blocks
In-Reply-To: <20120116184527.GA11972@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Roman Tereshonkov <roman.tereshonkov@nokia.com>

commit 3538c56329936c78f7d356889908790006d0124c upstream.

Use block_isbad to check and skip the bad blocks reading.
This will allow to get rid of the read errors if bad blocks
are present initially.

Signed-off-by: Roman Tereshonkov <roman.tereshonkov@nokia.com>
Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/mtd/mtdoops.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/mtd/mtdoops.c
+++ b/drivers/mtd/mtdoops.c
@@ -253,6 +253,9 @@ static void find_next_position(struct mt
 	size_t retlen;
 
 	for (page = 0; page < cxt->oops_pages; page++) {
+		if (mtd->block_isbad &&
+		    mtd->block_isbad(mtd, page * record_size))
+			continue;
 		/* Assume the page is used */
 		mark_page_used(cxt, page);
 		ret = mtd->read(mtd, page * record_size, MTDOOPS_HEADER_SIZE,


