Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754453Ab1HBMxS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 08:53:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61540 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754004Ab1HBMxN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 08:53:13 -0400
Date: Tue, 2 Aug 2011 13:52:00 +0100
From: Alasdair G Kergon <agk@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Zdenek Kabelac <zkabelac@redhat.com>, Peter Rajnoha <prajnoha@redhat.com>,
        Akinobu Mita <akinobu.mita@gmail.com>, dm-devel@redhat.com,
        linux-kernel@vger.kernel.org, stable@kernel.org,
        Joe Perches <joe@perches.com>, Jonathan Brassow <jbrassow@redhat.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Mike Snitzer <snitzer@redhat.com>,
        Mikulas Patocka <mpatocka@redhat.com>, Milan Broz <mbroz@redhat.com>
Subject: [git pull] device-mapper patches for 3.0
Message-ID: <20110802125200.GK31980@agk-dp.fab.redhat.com>
Mail-Followup-To: Linus Torvalds <torvalds@linux-foundation.org>,
	Zdenek Kabelac <zkabelac@redhat.com>,
	Peter Rajnoha <prajnoha@redhat.com>,
	Akinobu Mita <akinobu.mita@gmail.com>, dm-devel@redhat.com,
	linux-kernel@vger.kernel.org, stable@kernel.org,
	Joe Perches <joe@perches.com>,
	Jonathan Brassow <jbrassow@redhat.com>,
	"Kirill A. Shutemov" <kirill@shutemov.name>,
	Mike Snitzer <snitzer@redhat.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Milan Broz <mbroz@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: Red Hat UK Ltd. Registered in England and Wales, number
	03798903. Registered Office: 64 Baker Street, 4th floor, London,
	W1U 7DF.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull from:

  master.kernel.org:/pub/scm/linux/kernel/git/agk/linux-2.6-dm.git master

to get the following device-mapper patches for inclusion in 3.0.

The main enhancement this time is further integration with the md code, with
raid1 now supported.  Patches making use of this will shortly go into userspace
LVM, so it'll be possible to create Logical Volumes using the md raid
implementations.

(I had hoped to include the new thin provisioning target in this pull
request, but I'm holding it back in linux-next for now because of some
unresolved reports of data corruption.)

Akinobu Mita (1):
      dm log: clean up bit little endian bitops

Alasdair G Kergon (4):
      dm: fix idr leak on module removal
      dm: suppress endian warnings
      dm ioctl: prevent empty message
      dm raid: tidy includes

Joe Perches (1):
      dm: use vzalloc

Jonathan Brassow (7):
      dm snapshot: style cleanups
      dm raid: cleanup parameter handling
      dm raid: improve table parameters documentation
      dm raid: add region_size parameter
      dm raid: add write_mostly parameter
      dm raid: support metadata devices
      dm raid: add md raid1 support

Kirill A. Shutemov (1):
      dm log: userspace use list_move

Mike Snitzer (9):
      dm mpath: fix potential NULL pointer in feature arg processing
      dm table: fix discard support
      dm table: clean dm_get_device and move exports
      dm table: share target argument parsing functions
      dm flakey: use dm_target_offset and support discards
      dm flakey: support feature args
      dm flakey: add drop_writes
      dm flakey: add corrupt_bio_byte feature
      dm table: set flush capability based on underlying devices

Mikulas Patocka (10):
      dm snapshot: flush disk cache when merging
      dm io: flush cpu cache with vmapped io
      dm kcopyd: remove offset field from job structure
      dm kcopyd: remove nr_pages field from job structure
      dm snapshot: remove unused definitions
      dm: ignore merge_bvec for snapshots when safe
      dm snapshot: skip reading origin when overwriting complete chunk
      dm ioctl: fill in device parameters in more ioctls
      dm ioctl: introduce __get_dev_cell
      dm ioctl: forbid multiple device specifiers

Milan Broz (1):
      dm crypt: optionally support discard requests

 Documentation/device-mapper/dm-crypt.txt  |   21 +-
 Documentation/device-mapper/dm-flakey.txt |   48 ++-
 Documentation/device-mapper/dm-raid.txt   |  138 ++++---
 drivers/md/Kconfig                        |    5 +-
 drivers/md/dm-crypt.c                     |   62 +++-
 drivers/md/dm-flakey.c                    |  270 +++++++++++--
 drivers/md/dm-io.c                        |   29 ++-
 drivers/md/dm-ioctl.c                     |   89 +++--
 drivers/md/dm-kcopyd.c                    |   42 ++-
 drivers/md/dm-log-userspace-base.c        |    3 +-
 drivers/md/dm-log.c                       |   32 +-
 drivers/md/dm-mpath.c                     |  147 ++-----
 drivers/md/dm-raid.c                      |  621 ++++++++++++++++++++++++++---
 drivers/md/dm-snap-persistent.c           |   80 ++--
 drivers/md/dm-snap.c                      |   84 +++-
 drivers/md/dm-table.c                     |  155 ++++++--
 drivers/md/dm.c                           |   75 ++++-
 drivers/md/dm.h                           |    2 +
 include/linux/device-mapper.h             |   43 ++
 include/linux/dm-ioctl.h                  |    4 +-
 include/linux/dm-kcopyd.h                 |   15 +
 21 files changed, 1561 insertions(+), 404 deletions(-)

Thanks,
Alasdair.
