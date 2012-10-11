Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933693Ab2JKBOp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 21:14:45 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:41821 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933672Ab2JKBOh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 21:14:37 -0400
X-Sasl-enc: chqGjPhikpR+dQ2ifzBDzMGVN742r5P2uG/fEC4kY8Dn 1349918075
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Shmulik Ladkani <shmulik.ladkani@gmail.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        David Woodhouse <David.Woodhouse@intel.com>
Subject: [ 111/120] mtd: nand: Use the mirror BBT descriptor when reading its version
Date: Thu, 11 Oct 2012 10:01:03 +0900
Message-Id: <20121011005847.752897040@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121011005825.364610894@linuxfoundation.org>
References: <20121011005825.364610894@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shmulik Ladkani <shmulik.ladkani@gmail.com>

commit 7bb9c75436212813b38700c34df4bbb6eb82debe upstream.

The code responsible for reading the version of the mirror bbt was
incorrectly using the descriptor of the main bbt.

Pass the mirror bbt descriptor to 'scan_read_raw' when reading the
version of the mirror bbt.

Signed-off-by: Shmulik Ladkani <shmulik.ladkani@gmail.com>
Acked-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mtd/nand/nand_bbt.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/mtd/nand/nand_bbt.c
+++ b/drivers/mtd/nand/nand_bbt.c
@@ -390,7 +390,7 @@ static int read_abs_bbts(struct mtd_info
 	/* Read the mirror version, if available */
 	if (md && (md->options & NAND_BBT_VERSION)) {
 		scan_read_raw(mtd, buf, (loff_t)md->pages[0] << this->page_shift,
-			      mtd->writesize, td);
+			      mtd->writesize, md);
 		md->version[0] = buf[bbt_get_ver_offs(mtd, md)];
 		pr_info("Bad block table at page %d, version 0x%02X\n",
 			 md->pages[0], md->version[0]);


