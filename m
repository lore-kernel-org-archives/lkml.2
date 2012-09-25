Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756622Ab2IYNrt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 09:47:49 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:33403 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756585Ab2IYNrq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 09:47:46 -0400
From: sjur.brandeland@stericsson.com
To: Amit Shah <amit.shah@redhat.com>
Cc: linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org,
        sjurbren@stericsson.com,
        =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjur.brandeland@stericsson.com>
Subject: [PATCH 3/3] virtio_console: Don't initialize buffers to zero
Date: Tue, 25 Sep 2012 15:47:17 +0200
Message-Id: <1348580837-10919-4-git-send-email-sjur.brandeland@stericsson.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1348580837-10919-1-git-send-email-sjur.brandeland@stericsson.com>
References: <1348580837-10919-1-git-send-email-sjur.brandeland@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sjur Brændeland <sjur.brandeland@stericsson.com>

Skip initializing the receive buffers.

Signed-off-by: Sjur Brændeland <sjur.brandeland@stericsson.com>
---
 drivers/char/virtio_console.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/char/virtio_console.c b/drivers/char/virtio_console.c
index faedd2c..e7d8787 100644
--- a/drivers/char/virtio_console.c
+++ b/drivers/char/virtio_console.c
@@ -1344,7 +1344,6 @@ static unsigned int fill_queue(struct virtqueue *vq, spinlock_t *lock)
 		if (!buf)
 			break;
 
-		memset(buf->buf, 0, PAGE_SIZE);
 		spin_lock_irq(lock);
 		ret = add_inbuf(vq, buf);
 		if (ret < 0) {
-- 
1.7.5.4

