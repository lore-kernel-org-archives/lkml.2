Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753752Ab2LRFe4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 00:34:56 -0500
Received: from ozlabs.org ([203.10.76.45]:46964 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751028Ab2LRFez convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 00:34:55 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Cc: "LKML" <linux-kernel@vger.kernel.org>
Cc: Alex Russell <giles.alex@hotmail.com>
Cc: Amit Shah <amit.shah@redhat.com>
Cc: Bryan Venteicher <bryanv@daemoninthecloset.org>
Cc: Joe Perches <joe@perches.com>
Cc: Lee Jones <lee.jones@linaro.org>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Pawel Moll <pawel.moll@arm.com>
Cc: Sasha Levin <levinsasha928@gmail.com>
Cc: Sjur =?utf-8?Q?Br=C3=A6ndeland?= <sjur.brandeland@stericsson.com>
Cc: Wanlong Gao <gaowanlong@cn.fujitsu.com>
Cc: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Cc: Will Deacon <will.deacon@arm.com>
Subject: [PULL] virtio-next
User-Agent: Notmuch/0.14 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Tue, 18 Dec 2012 15:46:35 +1030
Message-ID: <87zk1c0wjw.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  git://git.kernel.org/pub/scm/linux/kernel/git/rusty/linux.git tags/virtio-next-for-linus

for you to fetch changes up to 1b6370463e88b0c1c317de16d7b962acc1dab4f2:

  virtio_console: Add support for remoteproc serial (2012-12-18 15:20:44 +1030)

----------------------------------------------------------------
Some nice cleanups, and even a patch my wife did as a "live" demo for
Latinoware 2012.

There's a slightly non-trivial merge in virtio-net, as we cleaned up the
virtio add_buf interface while DaveM accepted the mq virtio-net patches.

You can see my solution in my pending-rebases branch, if that helps, but I
know you love merging:

https://git.kernel.org/?p=linux/kernel/git/rusty/linux.git;a=commit;h=12e4e64fa66a4c812e4855de32abdb4d819526fe

Cheers,
Rusty.

----------------------------------------------------------------
Alex Russell (1):
      lguest: fix typo

Amit Shah (1):
      virtio: console: don't rely on virtqueue_add_buf() returning capacity.

Bryan Venteicher (1):
      virtio-scsi: Add real 2-clause BSD license to header

Joe Perches (1):
      virtio: Convert dev_printk(KERN_<LEVEL> to dev_<level>(

Michael S. Tsirkin (2):
      virtio-net: correct capacity math on ring full
      virtio-net: remove unused skb_vnet_hdr->num_sg field

Pawel Moll (1):
      virtio-mmio: Fix irq parsing in command line parameter

Rusty Russell (9):
      lguest: fix block request handling in example launcher.
      virtio: move queue_index and num_free fields into core struct virtqueue.
      virtio_net: don't rely on virtqueue_add_buf() returning capacity.
      virtio: make virtqueue_add_buf() returning 0 on success, not capacity.
      virtio: console: make it clear that virtqueue_add_buf() no longer returns > 0
      virtio: net: make it clear that virtqueue_add_buf() no longer returns > 0
      virtio: rpmsg: make it clear that virtqueue_add_buf() no longer returns > 0
      virtio: scsi: make it clear that virtqueue_add_buf() no longer returns > 0
      virtio: tools: make it clear that virtqueue_add_buf() no longer returns > 0

Sjur Brændeland (4):
      virtio_console: Free buffer if splice fails
      virtio_console: Use kmalloc instead of kzalloc
      virtio_console: Merge struct buffer_token into struct port_buffer
      virtio_console: Add support for remoteproc serial

Wanlong Gao (2):
      virtio: use dev_to_virtio wrapper in virtio
      virtio: add drv_to_virtio to make code clearly

Wei Yongjun (1):
      virtio-pci: use module_pci_driver to simplify the code

Will Deacon (3):
      mm: highmem: export kmap_to_page for modules
      virtio: 9p: correctly pass physical address to userspace for high pages
      virtio: force vring descriptors to be allocated from lowmem

sjur.brandeland@stericsson.com (1):
      virtio_console: Free buffers from out-queue upon close

 drivers/char/virtio_console.c    |  329 ++++++++++++++++++++++++++------------
 drivers/lguest/core.c            |    2 +-
 drivers/net/virtio_net.c         |   46 +++---
 drivers/rpmsg/virtio_rpmsg_bus.c |    6 +-
 drivers/scsi/virtio_scsi.c       |   24 +--
 drivers/virtio/virtio.c          |   30 ++--
 drivers/virtio/virtio_balloon.c  |    7 +-
 drivers/virtio/virtio_mmio.c     |   30 ++--
 drivers/virtio/virtio_pci.c      |   20 +--
 drivers/virtio/virtio_ring.c     |   46 +++---
 include/linux/virtio.h           |   25 ++-
 include/linux/virtio_scsi.h      |   28 +++-
 include/uapi/linux/virtio_ids.h  |    1 +
 mm/highmem.c                     |    1 +
 net/9p/trans_virtio.c            |    3 +-
 tools/lguest/lguest.c            |   84 ++++------
 tools/virtio/virtio_test.c       |    4 +-
 17 files changed, 412 insertions(+), 274 deletions(-)
