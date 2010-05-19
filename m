Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758079Ab0ESMyA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 08:54:00 -0400
Received: from ozlabs.org ([203.10.76.45]:54597 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757978Ab0ESMx7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 08:53:59 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PULL] virtio
Date: Wed, 19 May 2010 22:23:56 +0930
User-Agent: KMail/1.13.2 (Linux/2.6.32-21-generic; KDE/4.4.2; i686; ; )
Cc: virtualization@lists.linux-foundation.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201005192223.56991.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 537b60d17894b7c19a6060feae40299d7109d6e7:
  Linus Torvalds (1):
        Merge branch 'x86-uv-for-linus' of git://git.kernel.org/.../tip/linux-2.6-tip

are available in the git repository at:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/rusty/linux-2.6-for-linus.git virtio

Amit Shah (14):
      virtio: Revert "virtio: disable multiport console support."
      virtio: console: Add a __send_control_msg() that can send messages without a valid port
      virtio: console: Let host know of port or device add failures
      virtio: console: Return -EPIPE to hvc_console if we lost the connection
      virtio: console: Don't call hvc_remove() on unplugging console ports
      virtio: console: Remove config work handler
      virtio: console: Move code around for future patches
      virtio: console: Use a control message to add ports
      virtio: console: Don't always create a port 0 if using multiport
      virtio: console: Rename wait_is_over() to will_read_block()
      virtio: console: Add support for nonblocking write()s
      virtio: console: Resize console port 0 on config intr only if multiport is off
      virtio: console: Store each console's size in the console structure
      virtio: console: Accept console size along with resize control message

Julia Lawall (1):
      drivers/char: Eliminate use after free

Michael S. Tsirkin (9):
      virtio: add virtqueue_ vq_ops wrappers
      virtio_balloon: use virtqueue_xxx wrappers
      virtio_console: use virtqueue_xxx wrappers
      virtio_blk: use virtqueue_xxx wrappers
      virtio_net: use virtqueue_xxx wrappers
      virtio_ring: remove a level of indirection
      virtio-rng: use virtqueue_xxx wrappers
      trans_virtio: use virtqueue_xxx wrappers
      virtio: add_buf_gfp

Rusty Russell (1):
      virtio_blk: remove multichar constant.

john cooper (2):
      Add virtio disk identification support
      Add virtio disk identification ioctl

 drivers/block/virtio_blk.c          |   46 +++-
 drivers/char/hw_random/virtio-rng.c |    6 +-
 drivers/char/virtio_console.c       |  700 +++++++++++++++++++----------------
 drivers/net/virtio_net.c            |   46 ++--
 drivers/virtio/virtio_balloon.c     |   17 +-
 drivers/virtio/virtio_ring.c        |   44 +--
 include/linux/virtio.h              |   55 ++--
 include/linux/virtio_blk.h          |    5 +
 include/linux/virtio_console.h      |   25 ++
 net/9p/trans_virtio.c               |    6 +-
 10 files changed, 541 insertions(+), 409 deletions(-)
