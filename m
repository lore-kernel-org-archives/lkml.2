Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935575Ab1KJDd0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 22:33:26 -0500
Received: from cantor2.suse.de ([195.135.220.15]:43157 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934794Ab1KJDdX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:33:23 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:27:25 2011
Message-Id: <20111109212725.136979477@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:29:26 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Daniel Mack <zonque@gmail.com>,
        Lei Wen <leiwen@marvell.com>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        David Woodhouse <David.Woodhouse@intel.com>,
        Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Subject: [244/262] mtd: pxa3xx_nand: Fix blank page ECC mismatch
In-Reply-To: <20111109212847.GA20838@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Mack <zonque@gmail.com>

commit 543e32d5ff165d0d68deedb0e3557478c7c36a4a upstream.

This bug was introduced in f8155a40 ("mtd: pxa3xx_nand: rework irq
logic") and causes the PXA3xx NAND controller fail to operate with NAND
flash that has empty pages. According to the comment in this block, the
hardware controller will report a double-bit error for empty pages,
which can and must be ignored.

This patch restores the original behaviour of the driver.

Signed-off-by: Daniel Mack <zonque@gmail.com>
Acked-by: Lei Wen <leiwen@marvell.com>
Cc: Haojian Zhuang <haojian.zhuang@marvell.com>
Cc: David Woodhouse <David.Woodhouse@intel.com>
Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/mtd/nand/pxa3xx_nand.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/mtd/nand/pxa3xx_nand.c
+++ b/drivers/mtd/nand/pxa3xx_nand.c
@@ -685,6 +685,8 @@ static int pxa3xx_nand_read_page_hwecc(s
 		 * OOB, ignore such double bit errors
 		 */
 		if (is_buf_blank(buf, mtd->writesize))
+			info->retcode = ERR_NONE;
+		else
 			mtd->ecc_stats.failed++;
 	}
 


