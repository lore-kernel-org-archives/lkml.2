Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755653Ab2GYKZS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 06:25:18 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:62025 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753817Ab2GYKZP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 06:25:15 -0400
MIME-Version: 1.0
X-Originating-IP: [89.139.38.29]
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Wed, 25 Jul 2012 13:24:52 +0300
Message-ID: <CAK=Wgbb0ch+z7YKou7hqgFF45mGiYd6TD_XUaHgr3b26Fbp1Sg@mail.gmail.com>
Subject: [GIT PULL] remoteproc for 3.6
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: =?ISO-8859-1?Q?Sjur_Br=E6ndeland?= <sjur.brandeland@stericsson.com>,
        Fernando Guzman Lugo <fernando.lugo@ti.com>,
        Stephen Boyd <sboyd@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm <linux-arm-kernel@lists.infradead.org>,
        linux-omap@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

There are a few merge conflicts which are mostly trivial, but there's
also a sneaky one which is easy to miss (I missed it when I reviewed
the merge in linux-next) so I also pushed a 3.6-merge-reference branch
(for reference).

(in short, e981f6d "remoteproc: fix print format warnings" fixed a
line in rproc_load_segments(), but that function was relocated to
remoteproc_elf_loader.c by 72854fb "remoteproc: Move Elf related
functions to separate file", and since 72854fb is based on the
pre-fixed version of the function, it does not carry the 1-liner fix
to remoteproc_elf_loader.c, so the merge commit should. Thanks a
lot!).

Without further ado,

The following changes since commit 485802a6c524e62b5924849dd727ddbb1497cc71:

  Linux 3.5-rc3 (2012-06-16 17:25:17 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/ohad/remoteproc.git
tags/remoteproc-for-3.6

for you to fetch changes up to 6bb697b6b06041d2d0affc862b17b4b443a107e0:

  MAINTAINERS: add remoteproc's git (2012-07-15 11:39:02 +0300)

----------------------------------------------------------------
A batch of remoteproc patches for 3.6:
- custom binary format support from Sjur Brændeland
- groundwork for recovery and runtime pm support
- some cleanups and API simplifications

----------------------------------------------------------------
Ohad Ben-Cohen (8):
      remoteproc: allocate vrings on demand, free when not needed
      remoteproc: maintain a generic child device for each rproc
      remoteproc: remove the now-redundant kref
      remoteproc: simplify unregister/free interfaces
      remoteproc: support non-iommu carveout assignment
      remoteproc: remove the get_by_name/put API
      remoteproc: adopt the driver core's alloc/add/del/put naming
      MAINTAINERS: add remoteproc's git

Sjur Brændeland (4):
      remoteproc: Pass struct fw to load_segments and find_rsc_table.
      remoteproc: Add function rproc_get_boot_addr
      remoteproc: Move Elf related functions to separate file
      remoteproc: Support custom firmware handlers

 Documentation/remoteproc.txt               |  58 +--
 MAINTAINERS                                |   1 +
 drivers/remoteproc/Makefile                |   1 +
 drivers/remoteproc/omap_remoteproc.c       |  26 +-
 drivers/remoteproc/remoteproc_core.c       | 726 ++++++++---------------------
 drivers/remoteproc/remoteproc_debugfs.c    |   4 +-
 drivers/remoteproc/remoteproc_elf_loader.c | 295 ++++++++++++
 drivers/remoteproc/remoteproc_internal.h   |  62 +++
 drivers/remoteproc/remoteproc_virtio.c     |  34 +-
 drivers/rpmsg/virtio_rpmsg_bus.c           |   3 +-
 include/linux/remoteproc.h                 |  20 +-
 11 files changed, 613 insertions(+), 617 deletions(-)
 create mode 100644 drivers/remoteproc/remoteproc_elf_loader.c
