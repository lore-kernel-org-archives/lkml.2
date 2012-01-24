Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756034Ab2AXDNI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 22:13:08 -0500
Received: from cantor2.suse.de ([195.135.220.15]:49944 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755909Ab2AXCmb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 21:42:31 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Jan 23 18:39:24 2012
Message-Id: <20120124023924.022692391@clark.kroah.org>
User-Agent: quilt/0.50-11.1
Date: Mon, 23 Jan 2012 18:33:41 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Roman Tereshonkov <roman.tereshonkov@nokia.com>,
        Artem Bityutskiy <Artem.Bityutskiy@linux.intel.com>,
        David Woodhouse <David.Woodhouse@intel.com>
Subject: [001/129] mtdoops: fix the oops_page_used array size
In-Reply-To: <20120124024041.GA18422@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------
Content-Length: 1181
Lines: 33

From: Roman Tereshonkov <roman.tereshonkov@nokia.com>

commit 556f063580db2953a7e53cd46b47724246320f60 upstream.

The array of unsigned long pointed by oops_page_used is allocated
by vmalloc which requires the size to be in bytes.

BITS_PER_LONG is equal to 32.
If we want to allocate memory for 32 pages with one bit per page then
32 / BITS_PER_LONG  is equal to 1 byte that is 8 bits.
To fix it we need to multiply the result by sizeof(unsigned long) equal to 4.

Signed-off-by: Roman Tereshonkov <roman.tereshonkov@nokia.com>
Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@linux.intel.com>
Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/mtd/mtdoops.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/mtd/mtdoops.c
+++ b/drivers/mtd/mtdoops.c
@@ -369,7 +369,7 @@ static void mtdoops_notify_add(struct mt
 
 	/* oops_page_used is a bit field */
 	cxt->oops_page_used = vmalloc(DIV_ROUND_UP(mtdoops_pages,
-			BITS_PER_LONG));
+			BITS_PER_LONG) * sizeof(unsigned long));
 	if (!cxt->oops_page_used) {
 		printk(KERN_ERR "mtdoops: could not allocate page array\n");
 		return;


