Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932486Ab2C1SRU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 14:17:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60043 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932302Ab2C1SRT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 14:17:19 -0400
Date: Wed, 28 Mar 2012 19:16:55 +0100
From: Alasdair G Kergon <agk@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrei Warkentin <andrey.warkentin@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Wysochanski <dwysocha@redhat.com>, dm-devel@redhat.com,
        linux-kernel@vger.kernel.org, Elly Jones <ellyjones@chromium.org>,
        Hannes Reinecke <hare@suse.de>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Joe Thornber <ejt@redhat.com>, Jonathan Brassow <jbrassow@redhat.com>,
        "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>,
        Mandeep Singh Baines <msb@chromium.org>,
        Mike Snitzer <snitzer@redhat.com>,
        Mikulas Patocka <mpatocka@redhat.com>, Milan Broz <mbroz@redhat.com>,
        Olof Johansson <olofj@chromium.org>, stable@kernel.org,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Will Drewry <wad@chromium.org>
Subject: [git pull] device-mapper updates for 3.4
Message-ID: <20120328181655.GB16767@agk-dp.fab.redhat.com>
Mail-Followup-To: Linus Torvalds <torvalds@linux-foundation.org>,
	Andrei Warkentin <andrey.warkentin@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Dave Wysochanski <dwysocha@redhat.com>, dm-devel@redhat.com,
	linux-kernel@vger.kernel.org, Elly Jones <ellyjones@chromium.org>,
	Hannes Reinecke <hare@suse.de>,
	Heiko Carstens <heiko.carstens@de.ibm.com>,
	Joe Thornber <ejt@redhat.com>,
	Jonathan Brassow <jbrassow@redhat.com>,
	Jun'ichi Nomura <j-nomura@ce.jp.nec.com>,
	Mandeep Singh Baines <msb@chromium.org>,
	Mike Snitzer <snitzer@redhat.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Milan Broz <mbroz@redhat.com>, Olof Johansson <olofj@chromium.org>,
	stable@kernel.org, Steffen Klassert <steffen.klassert@secunet.com>,
	Will Drewry <wad@chromium.org>
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

  git://git.kernel.org/pub/scm/linux/kernel/git/agk/linux-dm tags/dm-3.4-changes

to get the following device-mapper updates for 3.4.

Thanks,
Alasdair

----------------------------------------------------------------
Device-mapper changes for 3.4.

- Update thin provisioning to support read-only external snapshot origins and
discards.
- A new target, dm verity, for device content validation.
- Mark dm uevent and dm raid as no-longer-experimental.
- Miscellaneous other fixes and clean-ups.

----------------------------------------------------------------
Alasdair G Kergon (4):
      dm: add persistent data to MAINTAINERS
      dm uevent: no longer experimental
      dm raid: no longer experimental
      dm thin: use dm_target_offset

Andrei Warkentin (1):
      dm exception store: fix init error path

Hannes Reinecke (2):
      dm table: simplify call to free_devices
      dm: clear bi_end_io on remapping failure

Joe Thornber (11):
      dm thin: fix stacked bi_next usage
      dm persistent data: fix btree rebalancing after remove
      dm thin: correct comments
      dm persistent data: remove redundant value_size arg from value_ptr
      dm thin metadata: pass correct space map to dm_sm_root_size
      dm thin: commit outstanding data every second
      dm persistent data: remove space map ref_count entries if redundant
      dm thin: support read only external snapshot origins
      dm thin: prepare to support discard
      dm thin: support discards
      dm thin: add pool target flags to control discard

Jonathan E Brassow (1):
      dm raid: handle failed devices during start up

Jun'ichi Nomura (1):
      dm mpath: detect invalid map_context

Mike Snitzer (1):
      dm thin: relax hard limit on the maximum size of a metadata device

Mikulas Patocka (5):
      dm crypt: fix mempool deadlock
      dm crypt: add missing error handling
      dm: reject trailing characters in sccanf input
      dm bufio: prefetch
      dm: add verity target

Milan Broz (1):
      dm: document sysfs entries

 Documentation/ABI/testing/sysfs-block-dm          |   25 +
 Documentation/device-mapper/thin-provisioning.txt |   65 +-
 Documentation/device-mapper/verity.txt            |  194 +++++
 MAINTAINERS                                       |    5 +-
 drivers/md/Kconfig                                |   28 +-
 drivers/md/Makefile                               |    1 +
 drivers/md/dm-bufio.c                             |  108 ++-
 drivers/md/dm-bufio.h                             |    8 +
 drivers/md/dm-crypt.c                             |   46 +-
 drivers/md/dm-delay.c                             |    9 +-
 drivers/md/dm-exception-store.c                   |    2 +-
 drivers/md/dm-flakey.c                            |    3 +-
 drivers/md/dm-ioctl.c                             |    5 +-
 drivers/md/dm-linear.c                            |    3 +-
 drivers/md/dm-log.c                               |    3 +-
 drivers/md/dm-mpath.c                             |   52 +-
 drivers/md/dm-queue-length.c                      |    3 +-
 drivers/md/dm-raid.c                              |   53 +-
 drivers/md/dm-raid1.c                             |   12 +-
 drivers/md/dm-round-robin.c                       |    3 +-
 drivers/md/dm-service-time.c                      |    5 +-
 drivers/md/dm-stripe.c                            |    3 +-
 drivers/md/dm-table.c                             |    9 +-
 drivers/md/dm-thin-metadata.c                     |    5 +-
 drivers/md/dm-thin-metadata.h                     |   13 +
 drivers/md/dm-thin.c                              |  680 +++++++++++----
 drivers/md/dm-verity.c                            |  913 +++++++++++++++++++++
 drivers/md/dm.c                                   |    1 +
 drivers/md/persistent-data/dm-btree-internal.h    |    7 +-
 drivers/md/persistent-data/dm-btree-remove.c      |  202 +++--
 drivers/md/persistent-data/dm-btree.c             |   27 +-
 drivers/md/persistent-data/dm-space-map-common.c  |    3 -
 32 files changed, 2104 insertions(+), 392 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-block-dm
 create mode 100644 Documentation/device-mapper/verity.txt
 create mode 100644 drivers/md/dm-verity.c
