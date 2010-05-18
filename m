Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755552Ab0ERFRZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 01:17:25 -0400
Received: from mail-pz0-f194.google.com ([209.85.222.194]:60339 "EHLO
	mail-pz0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754633Ab0ERFRX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 01:17:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=XUvwLOocUdpqn41ji6p7H85EdFZuRmDJWEXaKvmn2Txn944FZevlEiMwLhPo+18j7B
         6eF9azsgZ16siEqD30IPcKjkSbY/Tf/PEOfZISwxZBvWSPHmEIP5fVyg9PdTyDd234yN
         F0puyAZeKJGa0aZRbk9uIX0cjkwCgf1GUb4jk=
MIME-Version: 1.0
Date: Tue, 18 May 2010 13:17:22 +0800
Message-ID: <AANLkTilW8zZxCOrdiefZ4ZtixprI58LzDZ6Cz03z4lFk@mail.gmail.com>
Subject: [PATCH] fix a code style in drivers/char/virtio_console.c
From: Steven Liu <lingjiujianke@gmail.com>
To: amit.shah@redhat.com, linux-kernel@vger.kernel.org,
       virtualization@lists.linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fix a code style in drivers/char/virtio_console.c

Signed-off-by: Liu Qi <lingjiujianke@gmail.com>
---
 drivers/char/virtio_console.c |    7 +------
 1 files changed, 1 insertions(+), 6 deletions(-)

diff --git a/drivers/char/virtio_console.c b/drivers/char/virtio_console.c
index 196428c..61dad7e 100644
--- a/drivers/char/virtio_console.c
+++ b/drivers/char/virtio_console.c
@@ -1299,36 +1299,31 @@ static int init_vqs(struct ports_device *portdev)
        char **io_names;
        struct virtqueue **vqs;
        u32 i, j, nr_ports, nr_queues;
-       int err;
+       int err = -ENOMEM;

        nr_ports = portdev->config.max_nr_ports;
        nr_queues = use_multiport(portdev) ? (nr_ports + 1) * 2 : 2;

        vqs = kmalloc(nr_queues * sizeof(struct virtqueue *), GFP_KERNEL);
        if (!vqs) {
-               err = -ENOMEM;
                goto fail;
        }
        io_callbacks = kmalloc(nr_queues * sizeof(vq_callback_t *), GFP_KERNEL);
        if (!io_callbacks) {
-               err = -ENOMEM;
                goto free_vqs;
        }
        io_names = kmalloc(nr_queues * sizeof(char *), GFP_KERNEL);
        if (!io_names) {
-               err = -ENOMEM;
                goto free_callbacks;
        }
        portdev->in_vqs = kmalloc(nr_ports * sizeof(struct virtqueue *),
                                  GFP_KERNEL);
        if (!portdev->in_vqs) {
-               err = -ENOMEM;
                goto free_names;
        }
        portdev->out_vqs = kmalloc(nr_ports * sizeof(struct virtqueue *),
                                   GFP_KERNEL);
        if (!portdev->out_vqs) {
-               err = -ENOMEM;
                goto free_invqs;
        }

--
1.7.1



Best regards
