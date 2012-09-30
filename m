Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753145Ab2I3IeX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2012 04:34:23 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:44619 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753097Ab2I3IeO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2012 04:34:14 -0400
MIME-Version: 1.0
X-Originating-IP: [46.116.106.0]
In-Reply-To: <5060DA6B.3030806@xenotime.net>
References: <20120925005328.f748dfa3d077cebb345a4291@canb.auug.org.au> <5060DA6B.3030806@xenotime.net>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Sun, 30 Sep 2012 10:33:52 +0200
Message-ID: <CAK=WgbZTQX9rbH-rrC+st6OXSpfYjJqqN6Rj4YJosJTPdPnjHg@mail.gmail.com>
Subject: Re: linux-next: Tree for Sept 24 (remoteproc)
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 25, 2012 at 12:10 AM, Randy Dunlap <rdunlap@xenotime.net> wrote:
> on x86_64:
>
> drivers/built-in.o: In function `rproc_virtio_finalize_features':
> remoteproc_virtio.c:(.text+0x2f9a02): undefined reference to `vring_transport_features'
> drivers/built-in.o: In function `rproc_virtio_del_vqs':
> remoteproc_virtio.c:(.text+0x2f9a74): undefined reference to `vring_del_virtqueue'
> drivers/built-in.o: In function `rproc_virtio_find_vqs':
> remoteproc_virtio.c:(.text+0x2f9c44): undefined reference to `vring_new_virtqueue'
> drivers/built-in.o: In function `rproc_add_virtio_dev':
> (.text+0x2f9e2c): undefined reference to `register_virtio_device'
> drivers/built-in.o: In function `rproc_vq_interrupt':
> (.text+0x2f9db7): undefined reference to `vring_interrupt'
> drivers/built-in.o: In function `rproc_remove_virtio_dev':
> (.text+0x2f9e9f): undefined reference to `unregister_virtio_device'


Thanks, Randy, I'm applying this:


commit 8676079c6d31605268a7903a09fdf616e2ef5551
Author: Ohad Ben-Cohen <ohad@wizery.com>
Date:   Sun Sep 30 10:25:34 2012 +0200

    remoteproc: select VIRTIO to avoid build breakage

    drivers/built-in.o: In function `rproc_virtio_finalize_features':
    remoteproc_virtio.c:(.text+0x2f9a02): undefined reference to `vring_transpor
    drivers/built-in.o: In function `rproc_virtio_del_vqs':
    remoteproc_virtio.c:(.text+0x2f9a74): undefined reference to `vring_del_virt
    drivers/built-in.o: In function `rproc_virtio_find_vqs':
    remoteproc_virtio.c:(.text+0x2f9c44): undefined reference to `vring_new_virt
    drivers/built-in.o: In function `rproc_add_virtio_dev':
    (.text+0x2f9e2c): undefined reference to `register_virtio_device'
    drivers/built-in.o: In function `rproc_vq_interrupt':
    (.text+0x2f9db7): undefined reference to `vring_interrupt'
    drivers/built-in.o: In function `rproc_remove_virtio_dev':
    (.text+0x2f9e9f): undefined reference to `unregister_virtio_device'

    Reported-by: Randy Dunlap <rdunlap@xenotime.net>
    Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>

diff --git a/drivers/remoteproc/Kconfig b/drivers/remoteproc/Kconfig
index a1024d9..96ce101 100644
--- a/drivers/remoteproc/Kconfig
+++ b/drivers/remoteproc/Kconfig
@@ -6,6 +6,7 @@ config REMOTEPROC
        depends on EXPERIMENTAL
        depends on HAS_DMA
        select FW_CONFIG
+       select VIRTIO

 config OMAP_REMOTEPROC
        tristate "OMAP remoteproc support"
