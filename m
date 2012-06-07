Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932511Ab2FGESn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 00:18:43 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:62777 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932407Ab2FGESk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 00:18:40 -0400
Message-Id: <20120607040342.583430312@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Thu, 07 Jun 2012 13:04:19 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Subject: [ 43/82] mtd: nand: fix scan_read_raw_oob
In-Reply-To: <20120607041406.GA13233@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Maluka <D.Maluka@adbglobal.com>

commit 34a5704d91d6f8376a4c0a0143a1dd3eb3ccb37e upstream.

It seems there is a bug in scan_read_raw_oob() in nand_bbt.c which
should cause wrong functioning of NAND_BBT_SCANALLPAGES option.

Artem: the patch did not apply and I had to amend it a bit.

Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mtd/nand/nand_bbt.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/mtd/nand/nand_bbt.c
+++ b/drivers/mtd/nand/nand_bbt.c
@@ -324,6 +324,7 @@ static int scan_read_raw_oob(struct mtd_
 
 		buf += mtd->oobsize + mtd->writesize;
 		len -= mtd->writesize;
+		offs += mtd->writesize;
 	}
 	return 0;
 }


