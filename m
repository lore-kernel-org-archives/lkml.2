Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753954Ab2FTUyW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 16:54:22 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:59215 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753527Ab2FTUyV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 16:54:21 -0400
Date: Wed, 20 Jun 2012 13:54:17 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PATCH] driver core fixes for 3.5-rc4
Message-ID: <20120620205417.GA19228@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit cfaf025112d3856637ff34a767ef785ef5cf2ca9:

  Linux 3.5-rc2 (2012-06-08 18:40:09 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/driver-core.git/ tags/driver-core-3.5-rc4

for you to fetch changes up to 96c9f05b39a5a3239cf0588cc86a1b95cac652c4:

  extcon: max8997: Add missing kfree for info->edev in max8997_muic_remove() (2012-06-18 16:30:42 -0700)

----------------------------------------------------------------
Driver core and printk fixes for 3.5-rc4

Here are some fixes for 3.5-rc4 that resolve the kmsg problems that
people have reported showing up after the printk and kmsg changes went
into 3.5-rc1.  There are also a smattering of other tiny fixes for the
extcon and hyper-v drivers that people have reported.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Andrew Lunn (1):
      printk: Fix alignment of buf causing crash on ARM EABI

Axel Lin (3):
      extcon: Fix wrong index in max8997_extcon_cable[]
      extcon: Set platform drvdata in gpio_extcon_probe() and fix irq leak
      extcon: max8997: Add missing kfree for info->edev in max8997_muic_remove()

Kay Sievers (2):
      kmsg - kmsg_dump() use iterator to receive log buffer content
      kmsg - kmsg_dump() fix CONFIG_PRINTK=n compilation

Kuninori Morimoto (1):
      driver core: fixup reversed deferred probe order

Manohar Vanga (1):
      vme: change maintainer e-mail address

Mark Brown (1):
      Extcon: Don't try to create duplicate link names

Olaf Hering (1):
      Tools: hv: verify origin of netlink connector message

Yuanhan Liu (2):
      printk: use mutex lock to stop syslog_seq from going wild
      printk: return -EINVAL if the message len is bigger than the buf size

 MAINTAINERS                                |    2 +-
 arch/powerpc/platforms/pseries/nvram.c     |   61 +------
 arch/x86/platform/mrst/early_printk_mrst.c |   13 +-
 drivers/base/dd.c                          |    2 +-
 drivers/extcon/extcon-max8997.c            |    5 +-
 drivers/extcon/extcon_class.c              |    2 +-
 drivers/extcon/extcon_gpio.c               |    2 +
 drivers/mtd/mtdoops.c                      |   22 +--
 fs/pstore/platform.c                       |   34 ++--
 include/linux/kmsg_dump.h                  |   45 +++++-
 kernel/printk.c                            |  241 ++++++++++++++++++++++++----
 tools/hv/hv_kvp_daemon.c                   |   10 +-
 12 files changed, 289 insertions(+), 150 deletions(-)
