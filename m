Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754476Ab1LIOzv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 09:55:51 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:44695 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752158Ab1LIOzu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 09:55:50 -0500
MIME-Version: 1.0
X-Originating-IP: [109.186.57.177]
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Fri, 9 Dec 2011 16:55:27 +0200
Message-ID: <CAK=WgbaU6vpiBGSgogYPjQNmrF-U0wk1rSXMX83DdgQa9hw5Mw@mail.gmail.com>
Subject: Adding remoteproc/rpmsg to linux-next
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-arm <linux-arm-kernel@lists.infradead.org>,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-next@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        Brian Swetland <swetland@google.com>, akpm@linux-foundation.org,
        Greg KH <greg@kroah.com>, Stephen Boyd <sboyd@codeaurora.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Russell King <linux@arm.linux.org.uk>,
        Tony Lindgren <tony@atomide.com>,
        Saravana Kannan <skannan@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

Can you please add the following remoteproc tree to linux-next ?

git://git.kernel.org/pub/scm/linux/kernel/git/ohad/remoteproc.git for-next

This branch includes the basic remoteproc/rpmsg functionality as
posted in the mailing lists, with a few minor changes that were
requested (namely, changes against virtio-spec.txt were removed and
"amp" is no longer used).

The motivation for having this in linux-next is twofold:
1. Getting prepared for a 3.3 merger (knock on wood)
2. Starting a linear development scheme, in order to make it easier
for people to collaborate (and to reduce the review load of
incremental changes)

I suspect that once this basic functionality will be merged upstream,
the development of remoteproc and rpmsg will become completely
orthogonal, and it would then make sense to start queueing patches
separately. At that point I'll send you the details for the rpmsg.git
tree.

Last note: the "ARM: OMAP: add remoteproc devices for OMAP4" patch is
omitted from this branch, since it depends on CMA (which isn't merged
yet). As soon as CMA will be added (at least to linux-next) that patch
will be queued up too.

Thanks,
Ohad.

The following changes since commit 5611cc4572e889b62a7b4c72a413536bf6a9c416:

  Linux 3.2-rc4 (2011-12-01 14:56:01 -0800)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/ohad/remoteproc.git for-next

Ohad Ben-Cohen (6):
      remoteproc: add framework for controlling remote processors
      remoteproc: add debugfs entries
      remoteproc: create rpmsg virtio device
      remoteproc/omap: add a remoteproc driver for OMAP4
      rpmsg: add virtio-based remote processor messaging bus
      samples/rpmsg: add an rpmsg driver sample

 Documentation/ABI/testing/sysfs-bus-rpmsg    |   75 ++
 Documentation/remoteproc.txt                 |  324 ++++++
 Documentation/rpmsg.txt                      |  293 ++++++
 MAINTAINERS                                  |    7 +
 arch/arm/plat-omap/include/plat/remoteproc.h |   57 +
 drivers/Kconfig                              |    4 +
 drivers/Makefile                             |    2 +
 drivers/remoteproc/Kconfig                   |   24 +
 drivers/remoteproc/Makefile                  |    9 +
 drivers/remoteproc/omap_remoteproc.c         |  249 +++++
 drivers/remoteproc/omap_remoteproc.h         |   69 ++
 drivers/remoteproc/remoteproc_core.c         | 1410 ++++++++++++++++++++++++++
 drivers/remoteproc/remoteproc_debugfs.c      |  179 ++++
 drivers/remoteproc/remoteproc_internal.h     |   44 +
 drivers/remoteproc/remoteproc_rpmsg.c        |  295 ++++++
 drivers/rpmsg/Kconfig                        |    5 +
 drivers/rpmsg/Makefile                       |    1 +
 drivers/rpmsg/virtio_rpmsg_bus.c             | 1026 +++++++++++++++++++
 include/linux/mod_devicetable.h              |    9 +
 include/linux/remoteproc.h                   |  265 +++++
 include/linux/rpmsg.h                        |  326 ++++++
 include/linux/virtio_ids.h                   |    1 +
 samples/Kconfig                              |    8 +
 samples/Makefile                             |    2 +-
 samples/rpmsg/Makefile                       |    1 +
 samples/rpmsg/rpmsg_client_sample.c          |  100 ++
 26 files changed, 4784 insertions(+), 1 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-bus-rpmsg
 create mode 100644 Documentation/remoteproc.txt
 create mode 100644 Documentation/rpmsg.txt
 create mode 100644 arch/arm/plat-omap/include/plat/remoteproc.h
 create mode 100644 drivers/remoteproc/Kconfig
 create mode 100644 drivers/remoteproc/Makefile
 create mode 100644 drivers/remoteproc/omap_remoteproc.c
 create mode 100644 drivers/remoteproc/omap_remoteproc.h
 create mode 100644 drivers/remoteproc/remoteproc_core.c
 create mode 100644 drivers/remoteproc/remoteproc_debugfs.c
 create mode 100644 drivers/remoteproc/remoteproc_internal.h
 create mode 100644 drivers/remoteproc/remoteproc_rpmsg.c
 create mode 100644 drivers/rpmsg/Kconfig
 create mode 100644 drivers/rpmsg/Makefile
 create mode 100644 drivers/rpmsg/virtio_rpmsg_bus.c
 create mode 100644 include/linux/remoteproc.h
 create mode 100644 include/linux/rpmsg.h
 create mode 100644 samples/rpmsg/Makefile
 create mode 100644 samples/rpmsg/rpmsg_client_sample.c
