Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932324Ab0GAUt0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 16:49:26 -0400
Received: from kroah.org ([198.145.64.141]:47088 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758189Ab0GAUtX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 16:49:23 -0400
X-Mailbox-Line: From gregkh@clark.site Thu Jul  1 10:34:27 2010
Message-Id: <20100701173427.218307807@clark.site>
User-Agent: quilt/0.48-10.1
Date: Thu, 01 Jul 2010 10:33:10 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Sebastian Andrzej Siewior <sebastian@breakpoint.cc>,
       Jeff Garzik <jgarzik@redhat.com>
Subject: [patch 004/164] libata: dont flush dcache on slab pages
In-Reply-To: <20100701175152.GA2135@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>

commit 3842e835490cdf17013b30a788f6311bdcfd0571 upstream.

page_mapping() check this via VM_BUG_ON(PageSlab(page)) so we bug here
with the according debuging turned on.

Future TODO: replace this with a flush_dcache_page_for_pio() API

Signed-off-by: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/ata/libata-sff.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/ata/libata-sff.c
+++ b/drivers/ata/libata-sff.c
@@ -893,7 +893,7 @@ static void ata_pio_sector(struct ata_qu
 				       do_write);
 	}
 
-	if (!do_write)
+	if (!do_write && !PageSlab(page))
 		flush_dcache_page(page);
 
 	qc->curbytes += qc->sect_size;


