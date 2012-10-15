Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752272Ab2JOH6E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 03:58:04 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:62296 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751572Ab2JOH6A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 03:58:00 -0400
From: sjur.brandeland@stericsson.com
To: Amit Shah <amit.shah@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ohad Ben-Cohen <ohad@wizery.com>, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, sjurbren@gmail.com,
        =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjur.brandeland@stericsson.com>
Subject: [PATCHv7 2/4] virtio_console: Use kmalloc instead of kzalloc
Date: Mon, 15 Oct 2012 09:57:34 +0200
Message-Id: <1350287856-5284-3-git-send-email-sjur.brandeland@stericsson.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1350287856-5284-1-git-send-email-sjur.brandeland@stericsson.com>
References: <1350287856-5284-1-git-send-email-sjur.brandeland@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sjur Brændeland <sjur.brandeland@stericsson.com>

Avoid the more cpu expensive kzalloc when allocating buffers.
Originally kzalloc was intended for isolating the guest from
the host by not sending random guest data to the host. But device
isolation is not yet in place so kzalloc is not really needed.

Signed-off-by: Sjur Brændeland <sjur.brandeland@stericsson.com>
---
 drivers/char/virtio_console.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/char/virtio_console.c b/drivers/char/virtio_console.c
index c36b2f6..301d17e 100644
--- a/drivers/char/virtio_console.c
+++ b/drivers/char/virtio_console.c
@@ -349,7 +349,7 @@ static struct port_buffer *alloc_buf(size_t buf_size)
 	buf = kmalloc(sizeof(*buf), GFP_KERNEL);
 	if (!buf)
 		goto fail;
-	buf->buf = kzalloc(buf_size, GFP_KERNEL);
+	buf->buf = kmalloc(buf_size, GFP_KERNEL);
 	if (!buf->buf)
 		goto free_buf;
 	buf->len = 0;
-- 
1.7.5.4

