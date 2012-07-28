Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751709Ab2G1Gml (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jul 2012 02:42:41 -0400
Received: from mx3-phx2.redhat.com ([209.132.183.24]:53258 "EHLO
	mx3-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750785Ab2G1Gmk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jul 2012 02:42:40 -0400
Date: Sat, 28 Jul 2012 02:42:33 -0400 (EDT)
From: Paolo Bonzini <pbonzini@redhat.com>
To: Asias He <asias@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        "Michael S. Tsirkin" <mst@redhat.com>, Christoph Hellwig <hch@lst.de>,
        Minchan Kim <minchan.kim@gmail.com>,
        Rusty Russell <rusty@rustcorp.com.au>
Message-ID: <971756309.4742543.1343457753475.JavaMail.root@redhat.com>
In-Reply-To: <501350B1.7080908@redhat.com>
Subject: Re: [PATCH V3 3/3] virtio-blk: Add bio-based IO path for virtio-blk
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [93.34.189.113]
X-Mailer: Zimbra 7.2.0_GA_2669 (ZimbraWebClient - FF3.0 (Linux)/7.2.0_GA_2669)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > I'm not sure what the correct behavior for bio & cacheflush is, if
> > any.
> 
> REQ_FLUSH is not supported in the bio path.

Ouch, that's correct:

@@ -414,7 +529,7 @@ static void virtblk_update_cache_mode(struct virtio_device *vdev)
 	u8 writeback = virtblk_get_cache_mode(vdev);
 	struct virtio_blk *vblk = vdev->priv;
 
-	if (writeback)
+	if (writeback && !use_bio)
 		blk_queue_flush(vblk->disk->queue, REQ_FLUSH);
 	else
 		blk_queue_flush(vblk->disk->queue, 0);

then it is not safe against power losses.

Paolo
