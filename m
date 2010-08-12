Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753230Ab0HLF7z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 01:59:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31562 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752485Ab0HLF7y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 01:59:54 -0400
Date: Thu, 12 Aug 2010 06:59:26 +0100
From: Alasdair G Kergon <agk@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>, Mike Snitzer <snitzer@redhat.com>,
        Mikulas Patocka <mpatocka@redhat.com>,
        Takahiro Yasui <tyasui@redhat.com>,
        "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>,
        Milan Broz <mbroz@redhat.com>, Peter Rajnoha <prajnoha@redhat.com>,
        Arnd Bergmann <arnd@relay.de.ibm.com>, Julia Lawall <julia@diku.dk>,
        Tomohiro Kusumi <kusumi.tomohiro@jp.fujitsu.com>,
        Will Drewry <wad@chromium.org>, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com
Subject: [git pull] device-mapper patches for 2.6.36
Message-ID: <20100812055926.GF4535@agk-dp.fab.redhat.com>
Mail-Followup-To: Linus Torvalds <torvalds@linux-foundation.org>,
	Kiyoshi Ueda <k-ueda@ct.jp.nec.com>,
	Mike Snitzer <snitzer@redhat.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Takahiro Yasui <tyasui@redhat.com>,
	Jun'ichi Nomura <j-nomura@ce.jp.nec.com>,
	Milan Broz <mbroz@redhat.com>, Peter Rajnoha <prajnoha@redhat.com>,
	Arnd Bergmann <arnd@relay.de.ibm.com>, Julia Lawall <julia@diku.dk>,
	Tomohiro Kusumi <kusumi.tomohiro@jp.fujitsu.com>,
	Will Drewry <wad@chromium.org>, linux-kernel@vger.kernel.org,
	dm-devel@redhat.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Resent with mailing lists I lost from the cc - again...]

Please pull from:

  master.kernel.org:/pub/scm/linux/kernel/git/agk/linux-2.6-dm.git master

to get the following device-mapper fixes and enhancements for inclusion in
2.6.36.

The main enhancement here is discard support.  We left the dm-crypt target out
of this for now, hoping we might find some cryptographers to help us consider
this.
 
Alasdair G Kergon (3):
      dm mpath: fix NULL pointer dereference when path parameters missing
      dm ioctl: make __dev_status void
      dm: use dm_target_offset macro

Arnd Bergmann (1):
      dm ioctl: use nonseekable_open

Julia Lawall (1):
      dm crypt: use kstrdup

Kiyoshi Ueda (3):
      dm: prevent access to md being deleted
      dm ioctl: release _hash_lock between devices in remove_all
      dm: separate device deletion from dm_put

Mike Snitzer (11):
      dm ioctl: make bio or request based device type immutable
      dm: do not initialise full request queue when bio based
      dm: rename map_info flush_request to target_request_nr
      dm: linear support discard
      dm: use common __issue_target_request for flush and discard support
      dm: factor out max_io_len_target_boundary
      dm: zero silently drop discards
      dm delay: support discard
      dm: error return error for discards
      dm: split discard requests on target boundaries
      dm mpath: support discard

Mikulas Patocka (7):
      dm snapshot: iterate origin and cow devices
      dm snapshot: test chunk size against both origin and snapshot
      dm: skip second flush on bio unsupported error
      dm snapshot: implement merge
      dm stripe: move sector translation to a function
      dm stripe: optimize sector division
      dm stripe: support discards

Milan Broz (2):
      dm crypt: simplify crypt_config destruction logic
      dm crypt: simplify crypt_ctr

Peter Rajnoha (3):
      dm ioctl: remove __dev_status from geometry and target message
      dm ioctl: return uevent flag after rename
      dm: allow autoloading of dm mod

Tomohiro Kusumi (1):
      dm snapshot: persistent use define for disk header chunk size

Will Drewry (1):
      dm ioctl: refactor dm_table_complete

 Documentation/devices.txt       |    1 +
 drivers/md/dm-crypt.c           |  342 +++++++++++++++++++++------------------
 drivers/md/dm-delay.c           |    6 +-
 drivers/md/dm-exception-store.c |    4 +-
 drivers/md/dm-exception-store.h |    3 +-
 drivers/md/dm-ioctl.c           |  207 ++++++++++++------------
 drivers/md/dm-linear.c          |    3 +-
 drivers/md/dm-mpath.c           |   11 ++
 drivers/md/dm-raid1.c           |    2 +-
 drivers/md/dm-snap-persistent.c |    6 +-
 drivers/md/dm-snap.c            |   62 +++++--
 drivers/md/dm-stripe.c          |   87 +++++++++--
 drivers/md/dm-table.c           |   99 +++++++++++-
 drivers/md/dm-target.c          |    5 +
 drivers/md/dm-zero.c            |    5 +
 drivers/md/dm.c                 |  329 ++++++++++++++++++++++++++++---------
 drivers/md/dm.h                 |   14 ++-
 include/linux/device-mapper.h   |   16 ++-
 include/linux/dm-ioctl.h        |    5 +-
 include/linux/miscdevice.h      |    1 +
 20 files changed, 822 insertions(+), 386 deletions(-)

Thanks,
Alasdair.
