Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754087Ab1JZAAW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 20:00:22 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56342 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753994Ab1JZAAU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 20:00:20 -0400
Date: Wed, 26 Oct 2011 11:00:14 +1100
From: NeilBrown <neilb@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: lkml <linux-kernel@vger.kernel.org>,
        linux RAID <linux-raid@vger.kernel.org>
Subject: PULL REQUEST md updates for 3.2
Message-ID: <20111026110014.0a04aae8@notabene.brown>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.22.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/xFmqhZ9Q0GHjWr2BU.so6a+"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/xFmqhZ9Q0GHjWr2BU.so6a+
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable


Hi Linus,
 please pull following md updates for 3.2
 Most of them are just code cleanups and minor bug fixes.
 There is one fix for a RAID5 bug which could lead to data corruption
 due to reading old data from a device that is marked as faulty.  It is a
 small race as the drive is normally removed from consideration very soon
 after being marked faulty.  This patch is flagged for inclusion in -stable.
 It is commit 355840e7a7e56bb.

 This series conflicts with the patch
    block: remove support for bio remapping from ->make_request
 from  Christoph Hellwig in the block tree.
 That patch changes 'make_request' functions to return void.  I have patches
 which change the types of args to some of those functions from a typedef to
 a 'struct XXX'.
 The conflict is fairly easy to resolve ("wiggle" does it perfectly), or you
 could pull my "for-next" branch (85d7a4e56fbe09c1) instead which includes
 block-3.1 and resolves the conflict.

Thanks,
NeilBrown


The following changes since commit c3b92c8787367a8bb53d57d9789b558f1295cc96:

  Linux 3.1 (2011-10-24 09:10:05 +0200)

are available in the git repository at:
  git://neil.brown.name/md for-linus

  last commit being e5a0ad6c13bc9c02f6e8cdc6242c1c30e5b98a7a

Andrei Warkentin (1):
      MD: Allow restarting an interrupted incremental recovery.

Chris Dunlop (1):
      md.c: trivial comment fix

Dan McGee (1):
      lib/raid6: Fix filename emitted in generated code

Daniel P. Berrange (1):
      md: don't delay reboot by 1 second if no MD devices exist

Namhyung Kim (1):
      md/raid1: factor out common bio handling code

NeilBrown (28):
      md/bitmap: rename and tidy up BITMAP_PAGE_CLEAN
      md/bitmap: improve handling of 'allclean'.
      md/raid1:  add documentation to r1_private_data_s data structure.
      md/raid5: remove pointless NULL test.
      md/raid1/ avoid bio search in end_sync_read()
      md/raid5: convert to macros into inline functions.
      md: remove some old DEBUGging code.
      md: remove PRINTK and dprintk debugging and use pr_debug
      md/raid0: convert some printks to pr_debug.
      md: removing typedefs:  mdk_rdev_t -> struct md_rdev
      md: remove typedefs: mddev_t -> struct mddev
      md: remove typedefs: mdk_thread_t -> struct md_thread
      md: remove typedefs: r10bio_t -> struct r10bio and r1bio_t -> struct =
r1bio
      md: remove typedefs: mirror_info_t -> struct mirror_info
      md/linear: remove typedefs: dev_info_t -> struct dev_info
      md/faulty: remove typedef: conf_t -> struct faulty_conf
      md/linear: typedef removal: linear_conf_t -> struct linear_conf
      md/multipath: typedef removal: multipath_conf_t -> struct mpconf
      md/raid0: typedef removal: raid0_conf_t -> struct r0conf
      md/raid10: typedef removal: conf_t -> struct r10conf
      md/raid1: typedef removal: conf_t -> struct r1conf
      md/raid5: typedef removal: raid5_conf_t -> struct r5conf
      md/bitmap remove fault injection options.
      md: rename "mdk_personality" to "md_personality"
      md: add proper write-congestion reporting to RAID1 and RAID10.
      md: clear In_sync bit on devices added to an active array.
      md/raid5: fix bug that could result in reads from a failed device.
      md: Fix some bugs in recovery_disabled handling.

Wang Sheng-Hui (1):
      trival: md_k.h should be md.h in the beginning comment of file md.h

 drivers/md/bitmap.c    |  188 ++++++---------
 drivers/md/bitmap.h    |   12 +-
 drivers/md/dm-raid.c   |   28 +-
 drivers/md/faulty.c    |   38 ++--
 drivers/md/linear.c    |   46 ++--
 drivers/md/linear.h    |   12 +-
 drivers/md/md.c        |  631 ++++++++++++++++++++++++--------------------=
----
 drivers/md/md.h        |  151 ++++++------
 drivers/md/multipath.c |   64 +++---
 drivers/md/multipath.h |   10 +-
 drivers/md/raid0.c     |  191 +++++++--------
 drivers/md/raid0.h     |   10 +-
 drivers/md/raid1.c     |  335 ++++++++++++++------------
 drivers/md/raid1.h     |   85 ++++---
 drivers/md/raid10.c    |  280 ++++++++++++----------
 drivers/md/raid10.h    |   22 +-
 drivers/md/raid5.c     |  363 ++++++++++++----------------
 drivers/md/raid5.h     |   20 +-
 lib/raid6/int.uc       |    2 +-
 19 files changed, 1216 insertions(+), 1272 deletions(-)

--Sig_/xFmqhZ9Q0GHjWr2BU.so6a+
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTqdNlTnsnt1WYoG5AQI24Q/9F7xGHPDfsZ9lDXIA14q+/3bX5SgPNn0H
WSQsNExtZQbmMbawDCK69/CKX7wxeFSNpCeHPixNMgufyaMivS8nlOwzzVnTZF9O
oT6nukakiNHjQJ5ZBNbHhp5njqtj17i6By36TYv0veif1QFlcug320V5AQm+CmjA
7LoXRUjysItuag28Zn6pSW2Pp0W5ney3+jOji7l8j/QuqzdjhbkTGvG/JcLITLoo
7n1lpcMx0WUIP20C/0IoWKq0smApzAcCLPC2u7bjqgriU9uCP6+PLmkwCX3417Kc
wXgmiG3V7gGyewYiUOGB/yxtGBrDBIcX3u6+sSh7m8+IjhHLgrPl/rhKM2+yQBAx
cWC4hUCgTXdZBmnjgLO698LUaDBg/1x82xSqPY5ypJ+1/HboDV5DWWIpK02FLRDz
wxSJyrBucyVbYO7OExnQYoU7JHVtdVbtaWPBvKYwl1AwmlmJupPO5mbyqwKlGmH4
abhLPf02eCz+ddkhgahmhdQHQ7KNDLLi/4qTAygMLM8Xzi/lWxcF/XfwB3e2yevZ
0BE2pdSDLTEP8yBAfD3p5rBd7fxu2SxrZCg42MjnM1Hvxzl7xgjTAOb/r2tRoRsl
WB1SHRnrcuKjk01tuwyQKIPHR0YRji/yUABDOZfqSc/hWL+wrJy0PH/q1BVZ79Ma
G6xnPPtbyBc=
=PP42
-----END PGP SIGNATURE-----

--Sig_/xFmqhZ9Q0GHjWr2BU.so6a+--
