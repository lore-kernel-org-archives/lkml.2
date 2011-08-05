Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756736Ab1HEOUd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 10:20:33 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:59055 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753867Ab1HEOUc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 10:20:32 -0400
Date: Fri, 5 Aug 2011 17:18:21 +0300
From: Dan Carpenter <error27@gmail.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Laszlo Ersek <lersek@redhat.com>, Joe Jin <joe.jin@oracle.com>,
        open list <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
Subject: [patch] xen-blkback: add missing return on error in
 xen_update_blkif_status()
Message-ID: <20110805141821.GK7659@shale.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We should return here after reporting the error.  Otherwise we'd hit
a NULL deref of blkif->xenblkd on the next line.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/block/xen-blkback/xenbus.c b/drivers/block/xen-blkback/xenbus.c
index 32d4c3c..b750299 100644
--- a/drivers/block/xen-blkback/xenbus.c
+++ b/drivers/block/xen-blkback/xenbus.c
@@ -107,6 +107,7 @@ static void xen_update_blkif_status(struct xen_blkif *blkif)
 		err = PTR_ERR(blkif->xenblkd);
 		blkif->xenblkd = NULL;
 		xenbus_dev_error(blkif->be->dev, err, "start xenblkd");
+		return;
 	}
 
 	blkif->be->kthread_pid = blkif->xenblkd->pid;
