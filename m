Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754051Ab2KZPyl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 10:54:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:19618 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753650Ab2KZPyj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 10:54:39 -0500
Date: Mon, 26 Nov 2012 17:57:27 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: netdev@vger.kernel.org, David Miller <davem@davemloft.net>
Cc: Jason Wang <jasowang@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] vhost: fix length for cross region descriptor
Message-ID: <20121126155727.GA21716@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a single descriptor crosses a region, the
second chunk length should be decremented
by size translated so far, instead it includes
the full descriptor length.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/vhost/vhost.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index ef8f598..5a3d0f1 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -1049,7 +1049,7 @@ static int translate_desc(struct vhost_dev *dev, u64 addr, u32 len,
 		}
 		_iov = iov + ret;
 		size = reg->memory_size - addr + reg->guest_phys_addr;
-		_iov->iov_len = min((u64)len, size);
+		_iov->iov_len = min((u64)len - s, size);
 		_iov->iov_base = (void __user *)(unsigned long)
 			(reg->userspace_addr + addr - reg->guest_phys_addr);
 		s += size;
-- 
MST
