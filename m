Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758923Ab0GAVNb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 17:13:31 -0400
Received: from kroah.org ([198.145.64.141]:33721 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758834Ab0GAVMu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 17:12:50 -0400
X-Mailbox-Line: From gregkh@clark.site Thu Jul  1 10:42:47 2010
Message-Id: <20100701174247.367728284@clark.site>
User-Agent: quilt/0.48-10.1
Date: Thu, 01 Jul 2010 10:41:41 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Sebastian Andrzej Siewior <sebastian@breakpoint.cc>,
       Jeff Garzik <jgarzik@redhat.com>
Subject: [011/200] libata: dont flush dcache on slab pages
In-Reply-To: <20100701175201.GA2149@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let me know.

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
@@ -894,7 +894,7 @@ static void ata_pio_sector(struct ata_qu
 				       do_write);
 	}
 
-	if (!do_write)
+	if (!do_write && !PageSlab(page))
 		flush_dcache_page(page);
 
 	qc->curbytes += qc->sect_size;


