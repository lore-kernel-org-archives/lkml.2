Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755764Ab2F0Aub (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 20:50:31 -0400
Received: from void.printf.net ([89.145.121.20]:54078 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755579Ab2F0Aua (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 20:50:30 -0400
From: Chris Ball <cjb@laptop.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org
Subject: [GIT PULL] MMC fixes for 3.5-rc5
Date: Tue, 26 Jun 2012 20:50:25 -0400
Message-ID: <87iped8tny.fsf@octavius.laptop.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.97 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/cjb/mmc.git tags/mmc-fixes-for-3.5-rc5

to receive MMC fixes for 3.5-rc5.  There are no merge conflicts, and the
patches have been tested in linux-next.  Thanks.


The following changes since commit d1346a6cbabf6d377d753f1adc16cb0b305830cc:

  Merge branch 'drm-fixes' of git://people.freedesktop.org/~airlied/linux (2012-06-26 11:26:50 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/cjb/mmc.git tags/mmc-fixes-for-3.5-rc5

for you to fetch changes up to fe85227347738eb9b871bc163e7fb0db8b6cd2a0:

  Revert "mmc: omap_hsmmc: Enable Auto CMD12" (2012-06-26 16:10:30 -0400)

----------------------------------------------------------------
MMC fixes for 3.5-rc5:
 - omap_hsmmc: Using AUTO_CMD12 (enabled by default in 3.5-rc1) has
   been found to cause data corruption on the BeagleBoard xM, but no
   other OMAP boards so far.  Revert the patch until there's a root
   cause explanation that makes sense, at which point we might
   decide to use a blacklist or whitelist.
 - mmc_block: Fix incorrect data timeouts for the case of multiblock
   (ACMD22) writes for block-addressed cards.

----------------------------------------------------------------
Ming Lei (1):
      Revert "mmc: omap_hsmmc: Enable Auto CMD12"

Subhash Jadavani (1):
      mmc: block: fix the data timeout issue with ACMD22

 drivers/mmc/card/block.c      |   14 +-------------
 drivers/mmc/host/omap_hsmmc.c |   15 +++------------
 2 files changed, 4 insertions(+), 25 deletions(-)
 
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
