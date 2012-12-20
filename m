Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752506Ab2LTD4x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 22:56:53 -0500
Received: from ozlabs.org ([203.10.76.45]:49211 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751581Ab2LTD4q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 22:56:46 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PULL] virtio-next
In-Reply-To: <87zk1c0wjw.fsf@rustcorp.com.au>
References: <87zk1c0wjw.fsf@rustcorp.com.au>
User-Agent: Notmuch/0.14 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Thu, 20 Dec 2012 14:26:05 +1030
Message-ID: <87fw311ine.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell <rusty@rustcorp.com.au> writes:
>   git://git.kernel.org/pub/scm/linux/kernel/git/rusty/linux.git tags/virtio-next-for-linus
>
> for you to fetch changes up to 1b6370463e88b0c1c317de16d7b962acc1dab4f2:
>
>   virtio_console: Add support for remoteproc serial (2012-12-18 15:20:44 +1030)

Nothing?  OK, well here's the merged version.

Yeah it's gitolite@, but the delay for git://git.kernel.org updates
makes pull requests a real PITA; that's how I sent out a previous pull
request without the damn branchname.

The following changes since commit 2f0bf92513be58d2d65c0a4cc05c5779a7cd81e1:

  Merge tag 'xtensa-20121218' of git://github.com/czankel/xtensa-linux (2012-12-19 13:05:22 -0800)

are available in the git repository at:


  gitolite@ra.kernel.org:/pub/scm/linux/kernel/git/rusty/linux.git virtio-next

for you to fetch changes up to ec2894e1ef881217da9af314261a6ae598709737:

  Merge branch 'master' into virtio-next (2012-12-20 14:13:48 +1030)

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

Rusty Russell (10):
      lguest: fix block request handling in example launcher.
      virtio: move queue_index and num_free fields into core struct virtqueue.
      virtio_net: don't rely on virtqueue_add_buf() returning capacity.
      virtio: make virtqueue_add_buf() returning 0 on success, not capacity.
      virtio: console: make it clear that virtqueue_add_buf() no longer returns > 0
      virtio: net: make it clear that virtqueue_add_buf() no longer returns > 0
      virtio: rpmsg: make it clear that virtqueue_add_buf() no longer returns > 0
      virtio: scsi: make it clear that virtqueue_add_buf() no longer returns > 0
      virtio: tools: make it clear that virtqueue_add_buf() no longer returns > 0
      Merge branch 'master' into virtio-next

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
 drivers/net/virtio_net.c         |   49 +++---
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
 17 files changed, 413 insertions(+), 276 deletions(-)
