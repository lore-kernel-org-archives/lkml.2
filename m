Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754793Ab1GVPnw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 11:43:52 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:47551 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754169Ab1GVPnu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 11:43:50 -0400
MIME-Version: 1.0
From: Grant Likely <grant.likely@secretlab.ca>
Date: Fri, 22 Jul 2011 09:43:30 -0600
X-Google-Sender-Auth: 3Yt68Lkd0zRwybHsEfV536Dqo1o
Message-ID: <CACxGe6t4=oU4kSQn2QX8MxsqYXdSNp8zZjV1wb7+xXUMFOPaHg@mail.gmail.com>
Subject: [GIT PULL] Devicetree updates for v3.1
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Here are the device tree updates for v3.1.  Pretty boring changes
here, and all contained within Documentation/, drivers/of, and
include/linux/of*.h, other than a systemace driver bugfix that was
introduced when of_platform_bus_type was removed and a of_serial
change acked by Greg.  The interesting stuff will be the ARM board
support changes that depend on this branch.  Arnd will send you the
pull req for that.

g.

The following changes since commit 02f8c6aee8df3cdc935e9bdd4f2d020306035dbe:

  Linux 3.0 (2011-07-21 19:17:23 -0700)

are available in the git repository at:
  git://git.secretlab.ca/git/linux-2.6 devicetree/next

Grant Likely (10):
      dt: Add default match table for bus ids
      dt: add of_platform_populate() for creating device from the device tree
      drivers/amba: create devices from device tree
      dt/platform: allow device name to be overridden
      tty/serial: change of_serial to use new of_property_read_u32() api
      tty/serial: Add devicetree support for nVidia Tegra serial ports
      dt: remove extra xsysace platform_driver registration
      Merge commit 'v3.0-rc7' into devicetree/next
      of/address: Add of_find_matching_node_by_address helper
      dt: include linux/errno.h in linux/of_address.h

Jamie Iles (2):
      dt: document the of_serial bindings
      tty: of_serial: support for 32 bit accesses

Kim Phillips (1):
      dt: bindings: move SEC node under new crypto/

Rob Herring (1):
      dt: add helper function to read u32 arrays

Shawn Guo (2):
      dt: add 'const' for of_property_read_string parameter **out_string
      dt: add empty of_property_read_u32[_array] for non-dt

Thomas Abraham (1):
      dt: add helper functions to read u32 and string property values

 .../devicetree/bindings/arm/primecell.txt          |   21 ++
 .../{powerpc/fsl/sec.txt => crypto/fsl-sec2.txt}   |    2 +-
 .../devicetree/bindings/tty/serial/of-serial.txt   |   36 ++++
 drivers/block/xsysace.c                            |   98 ++--------
 drivers/of/address.c                               |   18 ++
 drivers/of/base.c                                  |   65 +++++++
 drivers/of/platform.c                              |  196 +++++++++++++++++++-
 drivers/tty/serial/of_serial.c                     |   43 +++--
 include/linux/of.h                                 |   29 +++-
 include/linux/of_address.h                         |    5 +
 include/linux/of_platform.h                        |   40 ++++
 11 files changed, 444 insertions(+), 109 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/arm/primecell.txt
 rename Documentation/devicetree/bindings/{powerpc/fsl/sec.txt =>
crypto/fsl-sec2.txt} (98%)
 create mode 100644 Documentation/devicetree/bindings/tty/serial/of-serial.txt


-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
