Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759441Ab0HLACm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 20:02:42 -0400
Received: from kroah.org ([198.145.64.141]:43755 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759335Ab0HKX7d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 19:59:33 -0400
X-Mailbox-Line: From gregkh@clark.site Wed Aug 11 16:55:05 2010
Message-Id: <20100811235505.348209728@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 11 Aug 2010 16:55:27 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Nikanth Karthikesan <knikanth@suse.de>,
        Jens Axboe <jens.axboe@oracle.com>
Subject: [106/111] loop: Update mtime when writing using aops
In-Reply-To: <20100811235623.GA24440@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Nikanth Karthikesan <knikanth@suse.de>

commit 02246c41171097ceab3246f6dc251ac89de6004b upstream.

Update mtime when writing to backing filesystem using the address space
operations write_begin and write_end.

Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>
Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/block/loop.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -238,6 +238,8 @@ static int do_lo_send_aops(struct loop_d
 		if (ret)
 			goto fail;
 
+		file_update_time(file);
+
 		transfer_result = lo_do_transfer(lo, WRITE, page, offset,
 				bvec->bv_page, bv_offs, size, IV);
 		copied = size;


