Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756808Ab2GDI0y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 04:26:54 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:38155 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755853Ab2GDI0t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 04:26:49 -0400
MIME-Version: 1.0
Date: Wed, 4 Jul 2012 16:26:48 +0800
Message-ID: <CAEvN+1i8O-GhJ1s9mpeG1WvX850AjezCHgdsjQop6syP3pJPhQ@mail.gmail.com>
Subject: How the registration of rpmsg devices should be done?
From: Tzu-Jung Lee <roylee17@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: ohad@wizery.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I working on the IPC functionality on our SoC and is looking into the
rpmsg & remoteproc framework of inux v3.4.

However, a piece of code seems to be missing in the
drivers/rpmsg/virtio_rpmsg_bus.c linux-v3.4 (compared to the
omap/linux-kernel-3.0)

@@ -898,82 +667,91 @@ static int rpmsg_probe(struct virtio_device *vdev)

+       /* look for platform-specific static channels */
+       vdev->config->get(vdev, VPROC_STATIC_CHANNELS, &ch, sizeof(ch));
+
+       for (i = 0; ch && ch[i].name[0]; i++)
+               rpmsg_create_channel(vrp, &ch[i]);

Since rpmsg_create_channel() is static and internal to rpmsg module,
I'm wondering how the registration of rpmsg device should be done?

Thanks,
Roy
