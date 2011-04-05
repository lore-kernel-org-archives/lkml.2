Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752619Ab1DEEux (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 00:50:53 -0400
Received: from mx3-phx2.redhat.com ([209.132.183.24]:59025 "EHLO
	mx3-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750940Ab1DEEuw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 00:50:52 -0400
Date: Tue, 5 Apr 2011 00:49:41 -0400 (EDT)
From: Takuma Umeya <tumeya@redhat.com>
To: virtualization@lists.linux-foundation.org
Cc: Rusty Russell <rusty@rustcorp.com.au>, Jens Axboe <jaxboe@fusionio.com>,
        Christoph Hellwig <hch@lst.de>, john cooper <john.cooper@redhat.com>,
        Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Message-ID: <1969774563.659835.1301978981017.JavaMail.root@zmail07.collab.prod.int.phx2.redhat.com>
In-Reply-To: <1099995365.641718.1301903899721.JavaMail.root@zmail07.collab.prod.int.phx2.redhat.com>
Subject: [PATCH] virtio_blk: decrement index when blockdevice is removed
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.5.5.72]
X-Mailer: Zimbra 6.0.9_GA_2686 (ZimbraWebClient - FF3.0 (Linux)/6.0.9_GA_2686)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When virtio block device is removed, index does not get decremented. When 
another virtio disk is attached it uses the next device letter to the 
one that is suppose to be available. 

Signed-off-by: Takuma Umeya <tumeya@redhat.com>

diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index 6ecf89c..730e7af 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -489,6 +489,7 @@ static void __devexit virtblk_remove(struct virtio_device *vdev)
        mempool_destroy(vblk->pool);
        vdev->config->del_vqs(vdev);
        kfree(vblk);
+       index--;
 }
 
 static const struct virtio_device_id id_table[] = {

-- 
Umeya, Takuma
Technical Account Manager
Red Hat GSS APAC
+81.3.5798.8584 (direct)
tumeya@redhat.com
