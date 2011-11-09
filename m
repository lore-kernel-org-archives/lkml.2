Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965916Ab1KJDrQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 22:47:16 -0500
Received: from cantor2.suse.de ([195.135.220.15]:44986 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965573Ab1KJDrJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:47:09 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:32:05 2011
Message-Id: <20111109213205.257996893@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:34:33 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [226/264] xen/blkback: Report VBD_WSECT (wr_sect) properly.
In-Reply-To: <20111109213508.GA3476@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

commit 5c62cb48602dba95159c81ffeca179d3852e25be upstream.

We did not increment the amount of sectors written to disk
b/c we tested for the == WRITE which is incorrect - as the
operations are more of WRITE_FLUSH, WRITE_ODIRECT. This patch
fixes it by doing a & WRITE check.

Reported-by: Andy Burns <xen.lists@burns.me.uk>
Suggested-by: Ian Campbell <Ian.Campbell@citrix.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/block/xen-blkback/blkback.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/block/xen-blkback/blkback.c
+++ b/drivers/block/xen-blkback/blkback.c
@@ -685,7 +685,7 @@ static int dispatch_rw_block_io(struct x
 
 	if (operation == READ)
 		blkif->st_rd_sect += preq.nr_sects;
-	else if (operation == WRITE || operation == WRITE_FLUSH)
+	else if (operation & WRITE)
 		blkif->st_wr_sect += preq.nr_sects;
 
 	return 0;


