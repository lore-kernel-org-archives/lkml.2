Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932475Ab1KDNvr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 09:51:47 -0400
Received: from 206.83.70.73.ptr.us.xo.net ([206.83.70.73]:23138 "EHLO
	king.tilera.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932322Ab1KDNvq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 09:51:46 -0400
Date: Fri, 4 Nov 2011 09:51:42 -0400
Message-Id: <201111041351.pA4Dpg1T031768@farm-0002.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] arch/tile update for 3.2
X-OriginalArrivalTime: 04 Nov 2011 13:51:45.0333 (UTC) FILETIME=[E3EB7E50:01CC9AF8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Could you pull the following changes for v3.2?

The exports.c change allows us to build Linux with the gcc we are now
returning to the community (a libgcc symbol name change happened as
part of stabilizing the API) and the other three changes will allow us
to use unmodified v3.2 "make headers_install" to build the glibc that
we are now also returning to the community.

Since I'm still working to get my kernel.org repository re-enabled
(any more folks out there want to sign my key?) the Tilera tree is
still hosted at github, but I've pgp-signed the pull line itself in
this email with my new 4096-bit cmetcalf@tilera.com key, so hopefully
that will do for now.

Thanks!

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

  git@github.com:cmetcalf-tilera/linux-tile.git for-linus
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iQIVAwUBTrPrC1yCCJqv9XTAAQKeCg//bJj1gsGi/bNMKXi/vv5ccbR2NCcDuje4
3Tf3dh8tvmrFAjq6GvPxm6yet3d1Cu55zrprdCQSTRy0fnd5JzcyvS5/vAlnNxCY
2z0HOImhzG3r45xvlomssRKOEG5IpiLWOL+1hbEic/yG8d5CPQ5z5WkUV9suotBY
wQMnxWGDL04g9quVh3xDyLwK2wW+LjK4Einy07veabqj2Otva9GLxtWP22zZucyf
fuVw6KARSYj28rglT5YpcaaIefthlaCjCsBP/UiUGRlJd5xtiBNYZSzSdwjx149k
+2ggDnvqlD2cwgJyzl1jRJIjUW6YisWgNosQPuPvuD4ka5CU2mb1S+WpNGogz1VT
4gRQmNlVoTig/ihynXMM6oyg9IBkw0VA/AHJ7mvxQ2tlIGJr9/AQIOJHfog9sVpd
5KZq0ujCF6paP2t20C1WhK/mSXEgz2w7LBXXlWvK5L0hrU1lpqPXH7rAiM5aSQIz
QR21AkR7ue3OrYGPEfTuWxNxS5F8BvSbYZdShxv3TxmexFUE5tGoKRkHU5DPNXgr
JdTCXYxImB8nUO/NPi+9Lz/7A6sreD34eMqIXota5pac2E7zWej1WlInko3t8m4B
zfJk4TJcPgs+fcFt3/ow4vbhYsygB/t0ErBMIcBI5mVFwg6fopCs1EoP0W6b1R4A
DpWuit5+Xo0=
=J41B
-----END PGP SIGNATURE-----

Chris Metcalf (4):
      arch/tile: avoid ISO namespace pollution with <asm/sigcontext.h>
      arch/tile: avoid exporting a symbol no longer used by gcc
      arch/tile: add the <arch> headers to the set of installed kernel headers
      arch/tile: factor out <arch/opcode.h> header

 arch/tile/include/arch/Kbuild                      |   17 +
 arch/tile/include/arch/abi.h                       |   99 +-
 .../{asm/opcode_constants.h => arch/opcode.h}      |   17 +-
 arch/tile/include/arch/opcode_tilegx.h             | 1405 ++++++++++++
 arch/tile/include/arch/opcode_tilepro.h            | 1471 +++++++++++++
 arch/tile/include/asm/Kbuild                       |    2 +
 arch/tile/include/asm/opcode-tile_32.h             | 1513 -------------
 arch/tile/include/asm/opcode-tile_64.h             | 1248 -----------
 arch/tile/include/asm/opcode_constants_32.h        |  480 -----
 arch/tile/include/asm/opcode_constants_64.h        |  609 ------
 arch/tile/include/asm/sigcontext.h                 |   18 +-
 .../include/asm/{opcode-tile.h => tile-desc.h}     |   19 +-
 arch/tile/include/asm/tile-desc_32.h               |  553 +++++
 arch/tile/include/asm/tile-desc_64.h               |  483 +++++
 arch/tile/kernel/backtrace.c                       |   19 +-
 arch/tile/kernel/module.c                          |    2 +-
 arch/tile/kernel/single_step.c                     |    9 +-
 arch/tile/kernel/tile-desc_32.c                    | 2242 ++++++++++----------
 arch/tile/kernel/tile-desc_64.c                    |   28 +-
 arch/tile/kernel/traps.c                           |    5 +-
 arch/tile/lib/exports.c                            |    2 -
 21 files changed, 5241 insertions(+), 5000 deletions(-)
 create mode 100644 arch/tile/include/arch/Kbuild
 rename arch/tile/include/{asm/opcode_constants.h => arch/opcode.h} (62%)
 create mode 100644 arch/tile/include/arch/opcode_tilegx.h
 create mode 100644 arch/tile/include/arch/opcode_tilepro.h
 delete mode 100644 arch/tile/include/asm/opcode-tile_32.h
 delete mode 100644 arch/tile/include/asm/opcode-tile_64.h
 delete mode 100644 arch/tile/include/asm/opcode_constants_32.h
 delete mode 100644 arch/tile/include/asm/opcode_constants_64.h
 rename arch/tile/include/asm/{opcode-tile.h => tile-desc.h} (56%)
 create mode 100644 arch/tile/include/asm/tile-desc_32.h
 create mode 100644 arch/tile/include/asm/tile-desc_64.h

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com
