Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753164Ab1KGTMK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 14:12:10 -0500
Received: from mail.windriver.com ([147.11.1.11]:46806 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752645Ab1KGTMI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 14:12:08 -0500
Date: Mon, 7 Nov 2011 14:12:00 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
        Linus <torvalds@linux-foundation.org>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] Left overs from the module.h split merge
Message-ID: <20111107191200.GH30282@windriver.com>
References: <20111107173318.12d4a5ce67a522b000d4a78c@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20111107173318.12d4a5ce67a522b000d4a78c@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Left overs from the module.h slpit merge] On 07/11/2011 (Mon 17:33) Stephen Rothwell wrote:

> Hi Linus,
> 
> Now that you have merged th module.h split, there are a few patches that
> are needed.  They are caused by interactions with other trees that you
> have now merged in the past couple of days.  Paul has all these patches
> (as *patches*) in a git tree at
> git://openlinux.windriver.com/people/paulg/modsplit-post-merge .  You

I'm assuming an actual pull makes life easier for you, so here it is.

> could just fetch them form there and apply them to your tree.  They are
> reasonably urgent as there are some build failures in your tree at the
> moment that these fix.
> 
> [PATCH] arm: Add export.h to recently added files for EXPORT_SYMBOL
> [PATCH] device-mapper: dm-bufio.c needs to include module.h
> [PATCH] device-mapper: using EXPORT_SYBOL in dm-space-map-checker.c needs export.h
> [PATCH] drivers/md: change module.h -> export.h in persistent-data/dm-*
> [PATCH] powerpc/powernv: include export.h in hvc_opal.h for THIS_MODULE

The hvc_opal one I see you already grabbed independently.  The other
four are below, along with the mtd/mfd ones that just appeared overnight.

Thanks,
Paul.

> 
> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> http://www.canb.auug.org.au/~sfr/


The following changes since commit 31555213f03bca37d2c02e10946296052f4ecfcd:

  Revert "hvc_console: display printk messages on console." (2011-11-06 22:22:16 -0800)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/paulg/linux.git for-linus

Jonas Gorski (1):
      MTD: MAPS: bcm963xx-flash.c: explicitly include module.h

Paul Gortmaker (3):
      drivers/md: change module.h -> export.h in persistent-data/dm-*
      arm: Add export.h to recently added files for EXPORT_SYMBOL
      mfd: fix build failures in recently added ab5500 code

Stephen Rothwell (2):
      device-mapper: dm-bufio.c needs to include module.h
      device-mapper: using EXPORT_SYMBOL in dm-space-map-checker.c needs export.h

 arch/arm/plat-omap/omap_device.c                   |    1 +
 arch/arm/plat-samsung/dma-ops.c                    |    1 +
 arch/arm/plat-samsung/s3c-dma-ops.c                |    1 +
 drivers/md/dm-bufio.c                              |    1 +
 drivers/md/persistent-data/dm-btree-remove.c       |    2 +-
 drivers/md/persistent-data/dm-btree.c              |    2 +-
 drivers/md/persistent-data/dm-space-map-checker.c  |    1 +
 drivers/md/persistent-data/dm-space-map-disk.c     |    2 +-
 .../md/persistent-data/dm-transaction-manager.c    |    2 +-
 drivers/mfd/ab5500-core.c                          |    1 +
 drivers/mfd/ab5500-debugfs.c                       |    1 +
 drivers/mtd/maps/bcm963xx-flash.c                  |    1 +
 12 files changed, 12 insertions(+), 4 deletions(-)
