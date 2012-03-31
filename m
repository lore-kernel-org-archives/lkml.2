Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756227Ab2CaC7w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 22:59:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16103 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754991Ab2CaC7t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 22:59:49 -0400
Date: Sat, 31 Mar 2012 08:29:41 +0530
From: Amit Shah <amit.shah@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Virtualization List <virtualization@lists.linux-foundation.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org
Subject: [PULL] virtio: S3 support, use PM API macro for init
Message-ID: <20120331025941.GC9769@amit.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull for virtio-s3/s4 fixes.  I'm taking the liberty to send
this to you directly since Rusty's on vacation.

The patches were posted earlier at

http://www.spinics.net/lists/linux-virtualization/msg15781.html

and have been tested to work fine, here's the message from the
original submission:

Turns out S3 is not different from S4 for virtio devices: the device
is assumed to be reset, so the host and guest state are to be assumed
to be out of sync upon resume.  We handle the S4 case with exactly the
same scenario, so just point the suspend/resume routines to the
freeze/restore ones.

Once that is done, we also use the PM API's macro to initialise the
sleep functions.

A couple of cleanups are included: there's no need for special thaw
processing in the balloon driver, so that's addressed in patches 1 and
2.

Testing: both S3 and S4 support have been tested using these patches
using a similar method used earlier during S4 patch development: a
guest is started with virtio-blk as the only disk, a virtio network
card, a virtio-serial port and a virtio balloon device.  Ping from
guest to host, dd /dev/zero to a file on the disk, and IO from the
host on the virtio-serial port, all at once, while exercising S4 and
S3 (separately) were tested.  They all continue to work fine after
resume.  virtio balloon values too were tested by inflating and
deflating the balloon.

The following changes since commit fa2a4519cb6ad94224eb56a1341fff570fd44ea1:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/sparc (2012-03-30 18:40:33 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/amit/virtio-console.git s3-for-3.4

Amit Shah (5):
      virtio: balloon: Allow stats update after restore from S4
      virtio: drop thaw PM operation
      virtio-pci: drop restore_common()
      virtio-pci: S3 support
      virtio-pci: switch to PM ops macro to initialise PM functions

 drivers/virtio/virtio_balloon.c |   14 -------
 drivers/virtio/virtio_pci.c     |   74 ++++----------------------------------
 include/linux/virtio.h          |    1 -
 3 files changed, 8 insertions(+), 81 deletions(-)

		Amit
