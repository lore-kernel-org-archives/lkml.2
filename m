Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754421Ab2DPNtK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 09:49:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5132 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753593Ab2DPNtI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 09:49:08 -0400
Date: Mon, 16 Apr 2012 16:49:06 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: kvm@vger.kernel.org, virtualization@lists.osdl.org,
        linux-kernel@vger.kernel.org, asias@redhat.com,
        david@gibson.dropbear.id.au, mst@redhat.com, renmx@cn.fujitsu.com,
        wuzhy@linux.vnet.ibm.com
Subject: [PULL] virtio: fixes for 3.4
Message-ID: <20120416134905.GA13301@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I know that -rc3 went out meanwhile but git handles that fine.
Please pull for 3.4, thanks!

The following changes since commit 0034102808e0dbbf3a2394b82b1bb40b5778de9e:

  Linux 3.4-rc2 (2012-04-07 18:30:41 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git for_linus

for you to fetch changes up to 3ccc9372ed0fab33d20f10be3c1efd5776ff5913:

  virtio_balloon: fix handling of PAGE_SIZE != 4k (2012-04-15 11:51:06 +0300)

----------------------------------------------------------------
virtio: fixes on top of 3.4-rc2

Here are some virtio fixes for 3.4:
a test build fix, a patch by Ren fixing naming for systems with a massive
number of virtio blk devices, and balloon fixes for powerpc
by David Gibson.

There was some discussion about Ren's patch for virtio disc naming: some people
wanted to move the legacy name mangling function to the block core.  But
there's no concensus on that yet, and we can always deduplicate later.
Added comments in the hope that this will stop people from
copying this legacy naming scheme into future drivers.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

----------------------------------------------------------------
David Gibson (1):
      virtio_balloon: Fix endian bug

Michael S. Tsirkin (1):
      virtio_balloon: fix handling of PAGE_SIZE != 4k

Ren Mingxin (1):
      virtio_blk: helper function to format disk names

Zhi Yong Wu (1):
      tools/virtio: fix up vhost/test module build

 drivers/block/virtio_blk.c      |   41 +++++++++++++++++++--------
 drivers/vhost/test.c            |    2 +-
 drivers/virtio/virtio_balloon.c |   58 +++++++++++++++++++++++++++++++--------
 3 files changed, 76 insertions(+), 25 deletions(-)
