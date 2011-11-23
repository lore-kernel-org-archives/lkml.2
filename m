Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759380Ab1KWBBj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 20:01:39 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42213 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759042Ab1KWAeJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 19:34:09 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Nov 22 16:22:07 2011
Message-Id: <20111123002207.475008955@clark.kroah.org>
User-Agent: quilt/0.48-20.1.2
Date: Tue, 22 Nov 2011 16:20:55 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Peter Wippich <pewi@gw-instruments.de>,
        Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Subject: [05/25] mtd: mtdchar: add missing initializer on raw write
In-Reply-To: <20111123002222.GA2376@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------
Content-Length: 989
Lines: 31

From: Peter Wippich <pewi@gw-instruments.de>

commit bf5140817b2d65faac9b32fc9057a097044ac35b upstream.

On writes in MODE_RAW the mtd_oob_ops struct is not sufficiently
initialized which may cause nandwrite to fail. With this patch
it is possible to write raw nand/oob data without additional ECC
(either for testing or when some sectors need different oob layout
e.g. bootloader) like
nandwrite  -n -r -o  /dev/mtd0 <myfile>

Signed-off-by: Peter Wippich <pewi@gw-instruments.de>
Tested-by: Ricard Wanderlof <ricardw@axis.com>
Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/mtd/mtdchar.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/mtd/mtdchar.c
+++ b/drivers/mtd/mtdchar.c
@@ -290,6 +290,7 @@ static ssize_t mtd_write(struct file *fi
 			ops.mode = MTD_OOB_RAW;
 			ops.datbuf = kbuf;
 			ops.oobbuf = NULL;
+			ops.ooboffs = 0;
 			ops.len = len;
 
 			ret = mtd->write_oob(mtd, *ppos, &ops);


