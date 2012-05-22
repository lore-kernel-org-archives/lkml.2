Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752045Ab2EVGzJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 02:55:09 -0400
Received: from mga11.intel.com ([192.55.52.93]:3823 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751582Ab2EVGzH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 02:55:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="asc'?scan'208";a="155532670"
Message-ID: <1337669924.2483.92.camel@sauron.fi.intel.com>
Subject: [GIT PULL] UBI and UBIFS changes for v3.5-rc1
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Maling List <linux-kernel@vger.kernel.org>,
        linux-mtd <linux-mtd@lists.infradead.org>
Date: Tue, 22 May 2012 09:58:44 +0300
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-/WYI6mVCOt6VzgKEm47O"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-/WYI6mVCOt6VzgKEm47O
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Linus,

here is a pull request for UBI and UBIFS changes for v3.5-rc1. Please,
pull.


The following changes since commit 69964ea4c7b68c9399f7977aa5b9aa6539a6a98a=
:

  Linux 3.4-rc5 (2012-04-29 15:19:10 -0700)

are available in the git repository at:

  git://git.infradead.org/linux-ubifs.git tags/upstream-3.5-rc1

for you to fetch changes up to 62f384552b6756cf1ea71f8762d1e97dc77dbd90:

  UBI: modify ubi_wl_flush function to clear work queue for a lnum (2012-05=
-21 11:34:41 +0300)

----------------------------------------------------------------
UBIFS:
   * Always support xattrs    (remove the Kconfig option)
   * Always support debugging (remove the Kconfig option)
   * A fix for a memory leak on error path
   * A number of clean-ups
UBI:
   * Always support debugging (remove the Kconfig option)
   * Remove "data type" hint support
   * Huge amount of renames to prepare for the fastmap wor
   * A lot of clean-ups

----------------------------------------------------------------
Artem Bityutskiy (44):
      UBIFS: get rid of dbg_dump_stack
      UBIFS: rename dumping functions
      UBIFS: remove a couple of unused macros
      UBIFS: remove Kconfig debugging option
      UBIFS: get rid of dbg_err
      UBIFS: make ubifs_lpt_init clean-up in case of failure
      UBI: always dump the stack on error
      UBI: always dump flash contents in case of errors
      UBI: always dump VID and EC headers in case of errors
      UBI: always warn if case of I/O errors
      UBI: amend commentaries WRT dtype
      UBI: rename ubi_dbg_dump_vol_info
      UBI: rename ubi_dbg_dump_vtbl_record
      UBI: rename ubi_dbg_dump_sv
      UBI: rename ubi_dbg_dump_seb
      UBI: rename ubi_dbg_dump_mkvol_req
      UBI: remove Kconfig debugging option
      UBI: clean-up terminology for self-checks in io.c
      UBI: more of clean-up terminology for self-checks
      UBI: get rid of dbg_err
      UBI: rename few functions for consistency
      UBI: rename struct ubi_scan_leb
      UBI: rename struct ubi_scan_volume
      UBI: rename struct ubi_scan_info
      UBI: amend comments after renaming in scan.c
      UBI: rename seb to aeb
      UBI: rename si to ai
      UBI: rename sv to av
      UBI: make ubi_scan_erase_peb static and rename
      UBI: remove unused function
      UBI: rename ubi_scan_add_used
      UBI: rename ubi_scan_find_av
      UBI: rename ubi_scan_rm_volume
      UBI: rename ubi_scan_get_free_peb
      UBI: rename ubi_scan_destroy_ai
      UBI: rename ubi_scan_move_to_list
      UBI: rename ubi_scan_leb_slab
      UBI: amend comments after all the renamings
      UBI: rename _init_scan functions
      UBI: move and rename attach_by_scanning
      UBI: rename UBI_SCAN_UNKNOWN_EC
      UBI: remove scan.h
      UBI: rename scan.c to attach.c
      UBI: introduce UBI_ALL constant

Dan Carpenter (1):
      UBIFS: remove douple initialization in change_category()

Joel Reardon (4):
      UBI: add in hex the value for UBI_INTERNAL_VOL_START to comment
      UBI: add volume id struct ubi_ainf_peb
      UBI: add lnum and vol_id to struct ubi_work
      UBI: modify ubi_wl_flush function to clear work queue for a lnum

Richard Weinberger (3):
      UBI: remove superfluous "!!" operation
      UBI: Kill data type hint
      UBI: remove data type hint from ubi-user.h

Sidney Amani (1):
      UBIFS: fix memory leak on error path

Subodh Nijsure (1):
      UBIFS: remove xattr Kconnfig option

 drivers/mtd/ubi/Kconfig              |    8 --
 drivers/mtd/ubi/Makefile             |    5 +-
 drivers/mtd/ubi/{scan.c =3D> attach.c} |  970 ++++++++++++++++++++++++++++=
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++----------=
---------------------------------------------------------------------------=
----
 drivers/mtd/ubi/build.c              |   85 +++-------------
 drivers/mtd/ubi/cdev.c               |   36 +++----
 drivers/mtd/ubi/debug.c              |  137 ++++++++++++--------------
 drivers/mtd/ubi/debug.h              |   98 +++----------------
 drivers/mtd/ubi/eba.c                |   68 ++++++-------
 drivers/mtd/ubi/gluebi.c             |    2 +-
 drivers/mtd/ubi/io.c                 |  211 +++++++++++++++++++-----------=
----------
 drivers/mtd/ubi/kapi.c               |   61 +++++++-----
 drivers/mtd/ubi/scan.h               |  174 ------------------------------=
---
 drivers/mtd/ubi/ubi-media.h          |    8 +-
 drivers/mtd/ubi/ubi.h                |  179 ++++++++++++++++++++++++++++++=
+---
 drivers/mtd/ubi/upd.c                |   16 ++-
 drivers/mtd/ubi/vmt.c                |   62 +++++-------
 drivers/mtd/ubi/vtbl.c               |  228 +++++++++++++++++++++---------=
-------------
 drivers/mtd/ubi/wl.c                 |  260 ++++++++++++++++++++++--------=
-------------------
 fs/ubifs/Kconfig                     |   23 -----
 fs/ubifs/Makefile                    |    5 +-
 fs/ubifs/commit.c                    |   14 +--
 fs/ubifs/debug.c                     |  158 +++++++++++++++---------------
 fs/ubifs/debug.h                     |  217 +++++-------------------------=
-----------
 fs/ubifs/dir.c                       |   10 --
 fs/ubifs/file.c                      |    4 +-
 fs/ubifs/gc.c                        |    2 +-
 fs/ubifs/io.c                        |   74 +++++++-------
 fs/ubifs/journal.c                   |   10 +-
 fs/ubifs/log.c                       |   18 +---
 fs/ubifs/lprops.c                    |   18 ++--
 fs/ubifs/lpt.c                       |   78 ++++++++-------
 fs/ubifs/lpt_commit.c                |   86 ++++++++---------
 fs/ubifs/master.c                    |    8 +-
 fs/ubifs/orphan.c                    |   25 ++---
 fs/ubifs/recovery.c                  |   43 ++++-----
 fs/ubifs/replay.c                    |   27 +++---
 fs/ubifs/sb.c                        |   26 ++---
 fs/ubifs/scan.c                      |   14 +--
 fs/ubifs/super.c                     |   31 +++---
 fs/ubifs/tnc.c                       |   26 +++--
 fs/ubifs/tnc_commit.c                |   28 ++----
 fs/ubifs/tnc_misc.c                  |   36 +++----
 fs/ubifs/ubifs.h                     |   26 +++--
 fs/ubifs/xattr.c                     |    4 +-
 include/linux/mtd/ubi.h              |   31 ++----
 include/mtd/ubi-user.h               |   34 +++----
 46 files changed, 1587 insertions(+), 2097 deletions(-)
 rename drivers/mtd/ubi/{scan.c =3D> attach.c} (58%)
 delete mode 100644 drivers/mtd/ubi/scan.h

--=20
Best Regards,
Artem Bityutskiy

--=-/WYI6mVCOt6VzgKEm47O
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJPuzklAAoJECmIfjd9wqK0+uUP/ihiOaadvJptaoBda7np0cdZ
Cp3L4d6ax2FM0MrXP0TsPEAbD6D+zOK+hxy+ePOCr0y6CNt21iTaw3KbC9iw+nic
6ZymEa8rxXFItH/exevtEH97TC1o18WuzkYF/8gRw6Zf9l05TP8D0sXjJ0GmnXC8
CHKjF+m0869qFMs182RBNPX3t1r6Cg7H3Daiau7ftBIJD5eFBNmTYzqyDVQyu335
JdzrEx48Izv+UteUbPnN+2DC76Ld0yTnntCwXnytWFqDxqV9rt872vl9yoYtzUw7
F9hmKnqdx4XWhjOJkXE2pvHariiasrJ+GCAAuzp2aK0tSBEnkPZYxri04IIfbQFs
ujJP3lUbY2h3+FKAUWJNpV9PQLBqzV+USNRrn/JbygbIe3cjof6nxNKcUxTRkzBz
P/hLqgWXc3NBHI53DmRhZVxZ+ImAF1sK2xtlT4KAMvElaNU9pNSNjLWLPlsYMuPY
g7uZ3yBue39ns8WGonN5Unv92+1O+qUM6a+MbHvHwtPMtOb33Dh05Re7mL+l7HmF
UfwjypyWN8UD91NIZGuXs4e1xniH2rEywmvHZQMEFzauJXVwB0+64EOnE1Mm/D7U
zI/QUwo93iafg5DKH1DkSxVtzjCCNmaYc4/9fHQ5dgaBtHL/gbbVxTtaZSTfxYHD
RsIJg31MKeqb1wwkRLen
=tz3Q
-----END PGP SIGNATURE-----

--=-/WYI6mVCOt6VzgKEm47O--

