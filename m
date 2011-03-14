Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755818Ab1CNJZv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 05:25:51 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:62491 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752935Ab1CNJZs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 05:25:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=HIDnPWcnm92yPTGZVaDE+WTBLZEJdKom25ulJ5VNcpvTmSacOVbapwUaGoVvOUwOC/
         8hnHaiTl6ohcyJPROYHEMM8YEWIzyBsgNliuiSehvAjZ9jIMkvmWNLRSp8aKYxxw0gme
         Snos3yJUQl2zs8RnV0YPX0Pr+UA002zs+wD8U=
Date: Mon, 14 Mar 2011 12:25:11 +0300
From: Dan Carpenter <error27@gmail.com>
To: Lars Ellenberg <drbd-dev@lists.linbit.com>
Cc: drbd-user@lists.linbit.com, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [patch] drbd: change int to unsigned int
Message-ID: <20110314092511.GK2008@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Lars Ellenberg <drbd-dev@lists.linbit.com>,
	drbd-user@lists.linbit.com, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These are changes to make my static checker happy.  I don't know the
code well enough to say if it makes a difference at run-time but it
doesn't hurt to fix these up.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index fe1564c..f33575c 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -1383,7 +1383,7 @@ static int recv_dless_read(struct drbd_conf *mdev, struct drbd_request *req,
 	D_ASSERT(sector == bio->bi_sector);
 
 	bio_for_each_segment(bvec, bio, i) {
-		expect = min_t(int, data_size, bvec->bv_len);
+		expect = min_t(unsigned int, data_size, bvec->bv_len);
 		rr = drbd_recv(mdev,
 			     kmap(bvec->bv_page)+bvec->bv_offset,
 			     expect);
@@ -3996,7 +3996,7 @@ static int drbd_do_handshake(struct drbd_conf *mdev)
 	    PRO_VERSION_MIN > p->protocol_max)
 		goto incompat;
 
-	mdev->agreed_pro_version = min_t(int, PRO_VERSION_MAX, p->protocol_max);
+	mdev->agreed_pro_version = min_t(unsigned int, PRO_VERSION_MAX, p->protocol_max);
 
 	dev_info(DEV, "Handshake successful: "
 	     "Agreed network protocol version %d\n", mdev->agreed_pro_version);
@@ -4515,7 +4515,7 @@ struct asender_cmd {
 	int (*process)(struct drbd_conf *mdev, struct p_header80 *h);
 };
 
-static struct asender_cmd *get_asender_cmd(int cmd)
+static struct asender_cmd *get_asender_cmd(unsigned int cmd)
 {
 	static struct asender_cmd asender_tbl[] = {
 		/* anything missing from this table is in
