Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755460Ab1JaVM6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 17:12:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28895 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932117Ab1JaVMz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 17:12:55 -0400
Date: Mon, 31 Oct 2011 21:12:40 +0000
From: Alasdair G Kergon <agk@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org,
        Mike Snitzer <snitzer@redhat.com>, Milan Broz <mbroz@redhat.com>,
        Zdenek Kabelac <zkabelac@redhat.com>,
        Joe Thornber <thornber@redhat.com>,
        Jonathan Brassow <jbrassow@redhat.com>,
        Mandeep Singh Baines <msb@chromium.org>,
        Mikulas Patocka <mpatocka@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Jens Axboe <jaxboe@fusionio.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Neil Brown <neilb@suse.de>
Subject: [git pull] device-mapper enhancements for 3.2
Message-ID: <20111031211240.GK2840@agk-dp.fab.redhat.com>
Mail-Followup-To: Linus Torvalds <torvalds@linux-foundation.org>,
	dm-devel@redhat.com, linux-kernel@vger.kernel.org,
	Mike Snitzer <snitzer@redhat.com>, Milan Broz <mbroz@redhat.com>,
	Zdenek Kabelac <zkabelac@redhat.com>,
	Joe Thornber <thornber@redhat.com>,
	Jonathan Brassow <jbrassow@redhat.com>,
	Mandeep Singh Baines <msb@chromium.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Namhyung Kim <namhyung@gmail.com>, Jens Axboe <jaxboe@fusionio.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Neil Brown <neilb@suse.de>
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

  http://people.redhat.com/agk/git/linux-dm for-linus

to get the following device-mapper enhancements for inclusion in 3.2.

The highlight here is thin provisioning.  This includes a new snapshot
implementation that, unlike the existing implementation, performs well with
multiple snapshots of the same device (e.g. for backups).
More-detailed documentation is included in-tree.

The development of userspace LVM support is progressing well and and we
expect to have the first release of this out in the next month or so.
(To try this, people should check out git://sources.redhat.com/git/lvm2 and
follow lvm-devel@redhat.com.)

Thanks,
Alasdair

Alasdair G Kergon (4):
      dm table: add singleton feature
      dm table: add always writeable feature
      dm table: add immutable feature
      dm: export dm get md

Joe Thornber (2):
      dm: add persistent data library
      dm: add thin provisioning target

Jonathan Brassow (1):
      dm log userspace: fix comment hyphens

Jonathan E Brassow (2):
      dm log userspace: add log device dependency
      dm: raid fix device status indicator when array initializing

Mandeep Singh Baines (1):
      dm table: propagate non rotational flag

Mikulas Patocka (2):
      dm kcopyd: add dm_kcopyd_zero to zero an area
      dm: add bufio

Namhyung Kim (2):
      dm: use local printk ratelimit
      dm: remove superfluous smp_mb

 Documentation/device-mapper/dm-log.txt             |    2 +-
 Documentation/device-mapper/persistent-data.txt    |   84 +
 Documentation/device-mapper/thin-provisioning.txt  |  285 +++
 drivers/md/Kconfig                                 |   36 +
 drivers/md/Makefile                                |    4 +
 drivers/md/dm-bufio.c                              | 1699 ++++++++++++++
 drivers/md/dm-bufio.h                              |  112 +
 drivers/md/dm-ioctl.c                              |   11 +
 drivers/md/dm-kcopyd.c                             |   31 +-
 drivers/md/dm-log-userspace-base.c                 |   37 +-
 drivers/md/dm-raid.c                               |   48 +-
 drivers/md/dm-table.c                              |   73 +
 drivers/md/dm-thin-metadata.c                      | 1391 +++++++++++
 drivers/md/dm-thin-metadata.h                      |  156 ++
 drivers/md/dm-thin.c                               | 2428 ++++++++++++++++++++
 drivers/md/dm.c                                    |   21 +-
 drivers/md/dm.h                                    |    2 +
 drivers/md/persistent-data/Kconfig                 |    8 +
 drivers/md/persistent-data/Makefile                |   11 +
 drivers/md/persistent-data/dm-block-manager.c      |  620 +++++
 drivers/md/persistent-data/dm-block-manager.h      |  123 +
 drivers/md/persistent-data/dm-btree-internal.h     |  137 ++
 drivers/md/persistent-data/dm-btree-remove.c       |  566 +++++
 drivers/md/persistent-data/dm-btree-spine.c        |  244 ++
 drivers/md/persistent-data/dm-btree.c              |  805 +++++++
 drivers/md/persistent-data/dm-btree.h              |  145 ++
 .../persistent-data/dm-persistent-data-internal.h  |   19 +
 drivers/md/persistent-data/dm-space-map-checker.c  |  437 ++++
 drivers/md/persistent-data/dm-space-map-checker.h  |   26 +
 drivers/md/persistent-data/dm-space-map-common.c   |  705 ++++++
 drivers/md/persistent-data/dm-space-map-common.h   |  126 +
 drivers/md/persistent-data/dm-space-map-disk.c     |  335 +++
 drivers/md/persistent-data/dm-space-map-disk.h     |   25 +
 drivers/md/persistent-data/dm-space-map-metadata.c |  596 +++++
 drivers/md/persistent-data/dm-space-map-metadata.h |   33 +
 drivers/md/persistent-data/dm-space-map.h          |  134 ++
 .../md/persistent-data/dm-transaction-manager.c    |  400 ++++
 .../md/persistent-data/dm-transaction-manager.h    |  130 ++
 include/linux/device-mapper.h                      |   45 +-
 include/linux/dm-ioctl.h                           |    4 +-
 include/linux/dm-kcopyd.h                          |    4 +
 include/linux/dm-log-userspace.h                   |   18 +-
 42 files changed, 12079 insertions(+), 37 deletions(-)
 create mode 100644 Documentation/device-mapper/persistent-data.txt
 create mode 100644 Documentation/device-mapper/thin-provisioning.txt
 create mode 100644 drivers/md/dm-bufio.c
 create mode 100644 drivers/md/dm-bufio.h
 create mode 100644 drivers/md/dm-thin-metadata.c
 create mode 100644 drivers/md/dm-thin-metadata.h
 create mode 100644 drivers/md/dm-thin.c
 create mode 100644 drivers/md/persistent-data/Kconfig
 create mode 100644 drivers/md/persistent-data/Makefile
 create mode 100644 drivers/md/persistent-data/dm-block-manager.c
 create mode 100644 drivers/md/persistent-data/dm-block-manager.h
 create mode 100644 drivers/md/persistent-data/dm-btree-internal.h
 create mode 100644 drivers/md/persistent-data/dm-btree-remove.c
 create mode 100644 drivers/md/persistent-data/dm-btree-spine.c
 create mode 100644 drivers/md/persistent-data/dm-btree.c
 create mode 100644 drivers/md/persistent-data/dm-btree.h
 create mode 100644 drivers/md/persistent-data/dm-persistent-data-internal.h
 create mode 100644 drivers/md/persistent-data/dm-space-map-checker.c
 create mode 100644 drivers/md/persistent-data/dm-space-map-checker.h
 create mode 100644 drivers/md/persistent-data/dm-space-map-common.c
 create mode 100644 drivers/md/persistent-data/dm-space-map-common.h
 create mode 100644 drivers/md/persistent-data/dm-space-map-disk.c
 create mode 100644 drivers/md/persistent-data/dm-space-map-disk.h
 create mode 100644 drivers/md/persistent-data/dm-space-map-metadata.c
 create mode 100644 drivers/md/persistent-data/dm-space-map-metadata.h
 create mode 100644 drivers/md/persistent-data/dm-space-map.h
 create mode 100644 drivers/md/persistent-data/dm-transaction-manager.c
 create mode 100644 drivers/md/persistent-data/dm-transaction-manager.h

