Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752090Ab2ALFYQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 00:24:16 -0500
Received: from ozlabs.org ([203.10.76.45]:37659 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751003Ab2ALFYN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 00:24:13 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: torvalds@linux-foundation.org
Cc: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Amit Shah <amit.shah@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Davidlohr Bueso <dave@gnu.org>
Cc: Jacek Galowicz <jacek@galowicz.de>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Sasha Levin <levinsasha928@gmail.com>
Cc: Stratos Psomadakis <psomas@cslab.ece.ntua.gr>
Cc: virtualization@lists.linux-foundation.org
Subject: [PULL] virtio and lguest
User-Agent: Notmuch/0.6.1-1 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Thu, 12 Jan 2012 15:52:46 +1030
Message-ID: <87lipd4hqx.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(I called the tag to-linus.  I think it worked).

To git@github.com:rustyrussell/linux.git
 + 3ed0016...b6c96c0 master -> master (forced update)
 + 815645d...f8e8df5 to-linus -> to-linus (forced update)
+ git request-pull remotes/origin/master git://github.com/rustyrussell/linux.git
The following changes since commit e343a895a9f342f239c5e3c5ffc6c0b1707e6244:

  Merge tag 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost (2012-01-10 18:04:27 -0800)

are available in the git repository at:

  git://github.com/rustyrussell/linux.git master

Amit Shah (12):
      virtio: pci: switch to new PM API
      virtio: pci: add PM notification handlers for restore, freeze, thaw, poweroff
      virtio: console: Move vq and vq buf removal into separate functions
      virtio: console: Add freeze and restore handlers to support S4
      virtio: console: Disable callbacks for virtqueues at start of S4 freeze
      virtio: blk: Move vq initialization to separate function
      virtio: blk: Add freeze, restore handlers to support S4
      virtio: net: Move vq initialization into separate function
      virtio: net: Move vq and vq buf removal into separate function
      virtio: net: Add freeze, restore handlers to support S4
      virtio: balloon: Move vq initialization into separate function
      virtio: balloon: Add freeze, restore handlers to support S4

Davidlohr Bueso (1):
      lguest: move the lguest tool to the tools directory

Jacek Galowicz (1):
      lguest: switch segment-voodoo-numbers to readable symbols

Michael S. Tsirkin (1):
      virtio_blk: fix config handler race

Rusty Russell (7):
      virtio: harsher barriers for rpmsg.
      virtio: document functions better.
      virtio: rename virtqueue_add_buf_gfp to virtqueue_add_buf
      virtio: support unlocked queue kick
      virtio: avoid modulus operation.
      virtio: expose added descriptors immediately.
      virtio: add debugging if driver doesn't kick.

Sasha Levin (1):
      virtio-balloon: Trivial cleanups

Stratos Psomadakis (1):
      lguest: Make sure interrupt is allocated ok by lguest_setup_irq

 arch/x86/lguest/boot.c                             |   21 +-
 drivers/block/virtio_blk.c                         |   87 +++++++-
 drivers/char/hw_random/virtio-rng.c                |    2 +-
 drivers/char/virtio_console.c                      |  140 +++++++++---
 drivers/lguest/Makefile                            |    2 +-
 drivers/lguest/lguest_device.c                     |   18 +-
 drivers/lguest/segments.c                          |   28 ++-
 drivers/net/virtio_net.c                           |  125 ++++++++---
 drivers/s390/kvm/kvm_virtio.c                      |    2 +-
 drivers/virtio/virtio_balloon.c                    |  108 +++++++--
 drivers/virtio/virtio_mmio.c                       |    4 +-
 drivers/virtio/virtio_pci.c                        |  110 +++++++++-
 drivers/virtio/virtio_ring.c                       |  245 +++++++++++++++++---
 include/linux/virtio.h                             |   75 ++-----
 include/linux/virtio_ring.h                        |    1 +
 net/9p/trans_virtio.c                              |    6 +-
 {Documentation/virtual => tools}/lguest/.gitignore |    0
 {Documentation/virtual => tools}/lguest/Makefile   |    0
 {Documentation/virtual => tools}/lguest/extract    |    0
 {Documentation/virtual => tools}/lguest/lguest.c   |    2 +-
 {Documentation/virtual => tools}/lguest/lguest.txt |    0
 tools/virtio/linux/virtio.h                        |   22 +--
 tools/virtio/virtio_test.c                         |    6 +-
 23 files changed, 757 insertions(+), 247 deletions(-)
 rename {Documentation/virtual => tools}/lguest/.gitignore (100%)
 rename {Documentation/virtual => tools}/lguest/Makefile (100%)
 rename {Documentation/virtual => tools}/lguest/extract (100%)
 rename {Documentation/virtual => tools}/lguest/lguest.c (99%)
 rename {Documentation/virtual => tools}/lguest/lguest.txt (100%)

