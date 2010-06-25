Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751409Ab0FYEkz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 00:40:55 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:48258 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750949Ab0FYEky (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 00:40:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:content-type:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=M0yuS6AF+Jlv2m2UJyv4kCZ9O1yGOEvLS60Sus8pIZgHyIv678O2eCmYVVI/HdVPHO
         ZOMlw7Sny/WbDTFm/JXFNd6gU+NJ8BoyUxWvgUMSESsymzq4E7nI8iR54qy8UgG0Ndto
         HWT9Ku0klUHe+9juaU6GKxFoB3MxfFErKWM4U=
Subject: [PATCH] staging/spectra: remove non existing blk_fs_request wrapper
From: Javier Martinez Canillas <martinez.javier@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>,
       David Woodhouse <David.Woodhouse@intel.com>,
       linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
       kernel-janitors <kernel-janitors@vger.kernel.org>
Content-Type: text/plain; charset="ISO-8859-9"
Date: Fri, 25 Jun 2010 00:40:48 -0400
Message-ID: <1277440848.18981.9.camel@lenovo>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The spectra driver doesn't compile with today linux-next

The problem is that it tries to use a blk_fs_request macro. Searching for this macro I saw that it used to exist in linux/blkdev.h as

#define blk_fs_request(rq) ((rq)->cmd_type == REQ_TYPE_FS)

This patch solves the issue eliminating the unnecessary (and now inexistent) wrapper

Best regards,

>From 755f948d65ff67d5dc8dde8c2edd212cbe61bd5f Mon Sep 17 00:00:00 2001
From: Javier Martinez Canillas <martinez.javier@gmail.com>
Date: Fri, 25 Jun 2010 00:26:20 -0400
Subject: [PATCH] staging/spectra: remove non existing blk_fs_request wrapper


Signed-off-by: Javier Martinez Canillas <martinez.javier@gmail.com>
---
 drivers/staging/spectra/ffsport.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/spectra/ffsport.c b/drivers/staging/spectra/ffsport.c
index 3c3565d..d0c5c97 100644
--- a/drivers/staging/spectra/ffsport.c
+++ b/drivers/staging/spectra/ffsport.c
@@ -304,7 +304,7 @@ static int do_transfer(struct spectra_nand_dev *tr, struct request *req)
 			return 0;
 	}
 
-	if (!blk_fs_request(req))
+	if (req->cmd_type != REQ_TYPE_FS)
 		return -EIO;
 
 	if (blk_rq_pos(req) + blk_rq_cur_sectors(req) > get_capacity(tr->gd)) {
-- 
1.7.0.4





