Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030928Ab2CSMWK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 08:22:10 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:46678 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964819Ab2CSMWI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 08:22:08 -0400
Date: Mon, 19 Mar 2012 12:22:05 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] regmap updates for 3.4
Message-ID: <20120319122204.GB3130@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="OwLcNYc0lM97+oe1"
Content-Disposition: inline
X-Cookie: Big book, big bore.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--OwLcNYc0lM97+oe1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The following changes since commit b01543dfe67bb1d191998e90d20534dc354de059:

  Linux 3.3-rc4 (2012-02-18 15:53:33 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/broonie/regmap.git tags/regmap-3.4

for you to fetch changes up to addfd8a09e1f434a73b3d87d36ef050c73511d2b:

  Merge remote-tracking branch 'regmap/topic/bulk' into regmap-next (2012-03-14 13:15:48 +0000)

----------------------------------------------------------------

Things are really quieting down with the regmap API, while we're still
seeing a trickle of new features coming in they're getting much smaller
than they were.  It's also nice to have some features which support
other subsystems building infrastructure on top of regmap.  Highlights
include:

- Support for padding between the register and the value when
  interacting with the device, sometimes needed for fast interfaces.
- Support for applying register updates to the device when restoring the
  register state.  This is intended to be used to apply updates supplied by
  manufacturers for tuning the performance of the device (many of which
  are to undocumented registers which aren't otherwise covered).
- Support for multi-register operations on cached registers.
- Support for syncing only part of the register cache.
- Stubs and parameter query functions intended to make it easier for other
  subsystems to build infrastructure on top of the regmap API.

plus a few driver updates making use of the new features which it was
easier to merge via this tree.

----------------------------------------------------------------
Axel Lin (2):
      regmap: Remove incorrect unreachable comment in regcache_set_val()
      regmap: Fix kcalloc parameters swapped

Dimitris Papastamos (2):
      regmap: Add support for writing to regmap registers via debugfs
      regmap: Expose the driver name in debugfs

Laxman Dewangan (3):
      regmap: Support for caching in reg_raw_write()
      regmap: add regmap_bulk_write() for register write
      regmap: Bypassing cache when initializing cache

Mark Brown (38):
      regmap: Add support for padding between register and address
      regmap: Support register patch sets
      regmap: Unexport regcache_write() and regcache_read()
      regmap: Skip patch application when the cache is not dirty on sync
      regmap: Bypass the cache when applying patches
      regmap: Reset device debugfs when reinitialising the cache
      regmap: Implement managed regmap_init()
      regmap: Don't use bitfields for booleans
      regmap: Add debugfs information for the cache status
      regmap: Add stub regmap calls as a build crutch for infrastructure users
      regmap: Implement support for 32 bit registers and values
      regmap: Allow users to query the size of register values
      Merge branch 'topic/devm' of git://git.kernel.org/.../broonie/regmap into regmap-drivers
      Merge branch 'topic/patch' of git://git.kernel.org/.../broonie/regmap into regmap-drivers
      regmap: Support raw reads from cached registers
      mfd: wm8994: Add __devinit and __devexit annotations for probe and remove
      mfd: Add __devinit and __devexit annotations in wm8994
      mfd/ASoC: Convert WM8994 driver to use regmap patches
      mfd: wm8994: Convert to devm_regmap_init()
      mfd: wm831x: Convert to devm_regmap_init()
      mfd: wm8400: Convert to devm_regmap_init_i2c()
      regmap: Skip hardware defaults for LZO caches
      regmap: Remove default cache sync implementation
      regmap: Mark the cache as clean after a successful sync
      regmap: Add tracepoints for cache only and cache bypass
      regmap: Supply ranges to the sync operations
      regmap: Allow drivers to sync only part of the register cache
      regmap: Fix x86_64 breakage
      mfd: Improve performance of later WM1811 revisions
      regmap: Add stub for regcache_sync_region()
      regcache: Make sure we sync register 0 in an rbtree cache
      regmap: Fix rbtree block base in sync
      regmap: Rejig struct declarations for stubbed API
      Merge remote-tracking branches 'regmap/topic/core' and 'regmap/topic/devm' into regmap-next
      Merge remote-tracking branch 'regmap/topic/drivers' into regmap-next
      Merge remote-tracking branches 'regmap/topic/patch' and 'regmap/topic/sync' into regmap-next
      Merge remote-tracking branch 'regmap/topic/introspection' into regmap-next
      Merge remote-tracking branch 'regmap/topic/bulk' into regmap-next

Paul Gortmaker (1):
      regmap: delete unused module.h from drivers/base/regmap files

Stephen Warren (1):
      regmap: Fix future missing prototype of devres_alloc() and friends

Wolfram Sang (3):
      regmap: Add support for 2/6 register formating
      regmap: Properly round reg_bytes and val_bytes
      regmap: if format_write is used, declare all registers as "unreadable"

 drivers/base/regmap/internal.h        |   14 +-
 drivers/base/regmap/regcache-lzo.c    |   16 ++-
 drivers/base/regmap/regcache-rbtree.c |   27 +++-
 drivers/base/regmap/regcache.c        |  102 +++++++++---
 drivers/base/regmap/regmap-debugfs.c  |   84 +++++++++-
 drivers/base/regmap/regmap-i2c.c      |   17 ++
 drivers/base/regmap/regmap-spi.c      |   17 ++
 drivers/base/regmap/regmap.c          |  307 ++++++++++++++++++++++++++++++---
 drivers/mfd/wm831x-core.c             |   20 +--
 drivers/mfd/wm831x-i2c.c              |    2 +-
 drivers/mfd/wm831x-spi.c              |    2 +-
 drivers/mfd/wm8400-core.c             |    7 +-
 drivers/mfd/wm8994-core.c             |   92 ++++++++--
 include/linux/regmap.h                |  132 ++++++++++++++
 include/trace/events/regmap.h         |   36 ++++
 sound/soc/codecs/wm8994.c             |   25 +---
 16 files changed, 782 insertions(+), 118 deletions(-)

--OwLcNYc0lM97+oe1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPZyR/AAoJEBus8iNuMP3dSUMP/09Or1+T3jA8VYt6lGeUFUAc
y/8Xa4bCBYA5LrOLmznBroscv/EMf0xWVzPt6HSa/FdukHtLAiMCS9N8ukyN74m0
faMOFGJpDbca/pGm0vKVyf9g5E3zd4N1pyhJgU3/hpgilSziMTxsXwbxQeGCq4sU
rMzRDYWMNt3i0V7p7kM5EbUz7YRT4XfopSfRJw5c8GUhd0YWSA9jPoI2a+swXLNJ
oOcRToPtB7so8CmadQl+0jQTrGMSWVoFXXH5l09z6ymGFN3DGY+gq394m3XtEUQD
w9IEDY9H8bviuXXlA/or3AMICPCkvs0LtW65GZMOKdo0BC2QHuBLSFqsFinHlVMw
sLuRtjnoyC+ODqci7TD7j3edPZ4xjWnSh79R5qqURpnb8QCRkb9aVnvTth6UMhgI
BvId8vw9GkoWOzsRlJXvvcjcpOYfxClLRbYtsfIX9SFbVxILskb4sp0UNGr1Xrke
fYKLFv/Xh091eQSrR8j2K1B+L9Z5sUrLGbrDRIJCRxyefqUHe47inDgwSCnHEMWm
5CT/KnSLk/g2tFD8bqOpfaaXJjhieKvL9f0Me3BYN+gIDD/uR+o2z//yTTuUrn5m
WzylKbcmHKUGIcTiEnItsplZe3xbInRcq+MpVmGDfWxSwMNgzgbxRWZ2uBFgIEA0
BHFzbOS4jSgj5Ss4DdxW
=0WHZ
-----END PGP SIGNATURE-----

--OwLcNYc0lM97+oe1--
