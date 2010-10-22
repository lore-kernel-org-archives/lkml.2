Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759557Ab0JVTDv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 15:03:51 -0400
Received: from kroah.org ([198.145.64.141]:34380 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759382Ab0JVS47 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 14:56:59 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Oct 22 11:52:34 2010
Message-Id: <20101022185234.628013999@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 22 Oct 2010 11:51:55 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        James Bottomley <James.Bottomley@suse.de>
Subject: [081/103] [SCSI] bsg: fix incorrect device_status value
In-Reply-To: <20101022185455.GA9114@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

commit 478971600e47cb83ff2d3c63c5c24f2b04b0d6a1 upstream.

bsg incorrectly returns sg's masked_status value for device_status.

[jejb: fix up expression logic]
Reported-by: Douglas Gilbert <dgilbert@interlog.com>
Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Signed-off-by: James Bottomley <James.Bottomley@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 block/bsg.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/block/bsg.c
+++ b/block/bsg.c
@@ -426,7 +426,7 @@ static int blk_complete_sgv4_hdr_rq(stru
 	/*
 	 * fill in all the output members
 	 */
-	hdr->device_status = status_byte(rq->errors);
+	hdr->device_status = rq->errors & 0xff;
 	hdr->transport_status = host_byte(rq->errors);
 	hdr->driver_status = driver_byte(rq->errors);
 	hdr->info = 0;


