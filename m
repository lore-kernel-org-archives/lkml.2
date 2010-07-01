Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757211Ab0GASWw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 14:22:52 -0400
Received: from kroah.org ([198.145.64.141]:35328 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757522Ab0GASWm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 14:22:42 -0400
X-Mailbox-Line: From gregkh@clark.site Thu Jul  1 10:32:07 2010
Message-Id: <20100701173207.918659079@clark.site>
User-Agent: quilt/0.48-10.1
Date: Thu, 01 Jul 2010 10:30:39 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Sebastian Andrzej Siewior <sebastian@breakpoint.cc>,
       Jeff Garzik <jgarzik@redhat.com>
Subject: [patch 013/149] libata: dont flush dcache on slab pages
In-Reply-To: <20100701175144.GA2116@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

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


