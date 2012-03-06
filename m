Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757036Ab2CFSKA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 13:10:00 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:59356 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755294Ab2CFSJ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 13:09:58 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of ohad@wizery.com designates 10.50.178.106 as permitted sender) smtp.mail=ohad@wizery.com
MIME-Version: 1.0
X-Originating-IP: [93.172.188.121]
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Tue, 6 Mar 2012 20:09:38 +0200
Message-ID: <CAK=WgbYsZUzTos_sXd+ZayKfPc=sxL7v0Q_==bTMh-_4XiMWiw@mail.gmail.com>
Subject: [GIT PULL] fixing and cleaning up rpmsg/remoteproc for 3.4
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm <linux-arm-kernel@lists.infradead.org>,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>,
        Tony Lindgren <tony@atomide.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Grant Likely <grant.likely@secretlab.ca>,
        Mark Asselstine <mark.asselstine@windriver.com>,
        Brian Swetland <swetland@google.com>, "Grosen, Mark" <mgrosen@ti.com>,
        Omar Ramirez Luna <omar.luna@linaro.org>, "Clark, Rob" <rob@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

Please pull:

git://git.kernel.org/pub/scm/linux/kernel/git/ohad/remoteproc.git
rpmsg-fixes-and-more-for-3.4

To get a few rpmsg/remoteproc fixes, cleanups and some generalization
work for 3.4.

Again, I should have sent the Kconfig patch earlier in a separate pull
request. Sorry about that.

Thanks!
Ohad.

The following changes since commit e12bc14b88d44e5c1456dccb59ff58103f6c6edc:

  remoteproc: s/big switch/lookup table/ (2012-02-22 18:28:49 +0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/ohad/remoteproc.git
rpmsg-fixes-and-more-for-3.4

for you to fetch changes up to 1e3e2c7c46b2e6e90f3a26ba9be6326c00ca31e4:

  remoteproc: cleanup resource table parsing paths (2012-03-06 19:14:44 +0200)

----------------------------------------------------------------
Fixing and cleaning up several remoteproc and rpmsg issues.

In addition, remoteproc's resource table is converted to a collection
of type-value members, instead of a rigid array of homogeneous structs.

This enables remoteproc to support registration of generic virtio devices,
and not only a single VIRTIO_ID_RPMSG virtio device.

But perhaps more importantly, the resource table overhaul makes it possible
to easily extend it in the future without breaking older images (simply by
defining a new member type, while continuing to support older types).

----------------------------------------------------------------
Mark Asselstine (1):
      rpmsg: fix build warning when dma_addr_t is 64-bit

Ohad Ben-Cohen (12):
      remoteproc: make sure we're parsing a 32bit firmware
      remoteproc/omap: two Kconfig fixes
      rpmsg: fix name service endpoint leak
      rpmsg: validate incoming message length before propagating
      rpmsg: fix published buffer length in rpmsg_recv_done
      remoteproc: resource table overhaul
      remoteproc: remoteproc_rpmsg -> remoteproc_virtio
      remoteproc: safer boot/shutdown order
      remoteproc: remove the single rpmsg vdev limitation
      remoteproc/omap: remove the mbox_callback limitation
      remoteproc: remove the hardcoded vring alignment
      remoteproc: cleanup resource table parsing paths

 Documentation/remoteproc.txt                       |  136 +++---
 drivers/remoteproc/Kconfig                         |    3 +-
 drivers/remoteproc/Makefile                        |    2 +-
 drivers/remoteproc/omap_remoteproc.c               |   11 +-
 drivers/remoteproc/remoteproc_core.c               |  532 ++++++++++++--------
 drivers/remoteproc/remoteproc_internal.h           |    6 +-
 .../{remoteproc_rpmsg.c => remoteproc_virtio.c}    |  162 +++----
 drivers/rpmsg/virtio_rpmsg_bus.c                   |   46 ++-
 include/linux/remoteproc.h                         |  339 ++++++++++---
 9 files changed, 793 insertions(+), 444 deletions(-)
 rename drivers/remoteproc/{remoteproc_rpmsg.c => remoteproc_virtio.c} (65%)
