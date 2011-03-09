Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932655Ab1CIQck (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 11:32:40 -0500
Received: from void.printf.net ([89.145.121.20]:60269 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932099Ab1CIQci (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 11:32:38 -0500
From: Chris Ball <cjb@laptop.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org
Subject: MMC fix for 2.6.38
Date: Wed, 09 Mar 2011 11:30:17 -0500
Message-ID: <m3wrk8mf3a.fsf@pullcord.laptop.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.90 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/cjb/mmc.git for-linus

for a final MMC regression fix against -rc1.  Thanks.

The following changes since commit 214d93b02c4fe93638ad268613c9702a81ed9192:
  Linus Torvalds (1):
        Merge branch 'omap-fixes-for-linus' of git://git.kernel.org/.../tmlind/linux-omap-2.6

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/cjb/mmc.git for-linus

Ohad Ben-Cohen (1):
      mmc: fix CONFIG_MMC_UNSAFE_RESUME regression

 drivers/mmc/core/core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Tue, 8 Mar 2011 23:32:02 +0200
Subject: [PATCH] mmc: fix CONFIG_MMC_UNSAFE_RESUME regression

30201e7f3 ("mmc: skip detection of nonremovable cards on rescan")
allowed skipping detection of nonremovable cards on mmc_rescan().
The intention was to only skip detection of hardwired cards that
cannot be removed, so make sure this is indeed the case by directly
checking for (lack of) MMC_CAP_NONREMOVABLE, instead of using
mmc_card_is_removable(), which is overloaded with
CONFIG_MMC_UNSAFE_RESUME semantics.

The user-visible symptom of the bug this patch fixes is that no
"mmc: card XXXX removed" message appears in dmesg when a card is
removed and CONFIG_MMC_UNSAFE_RESUME=y.

Reported-and-tested-by: Dmitry Shmidt <dimitrysh@google.com>
Reported-and-tested-by: Maxim Levitsky <maximlevitsky@gmail.com>
Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
Signed-off-by: Chris Ball <cjb@laptop.org>
---
 drivers/mmc/core/core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
index 6625c05..150b5f3 100644
--- a/drivers/mmc/core/core.c
+++ b/drivers/mmc/core/core.c
@@ -1529,7 +1529,7 @@ void mmc_rescan(struct work_struct *work)
 	 * still present
 	 */
 	if (host->bus_ops && host->bus_ops->detect && !host->bus_dead
-	    && mmc_card_is_removable(host))
+	    && !(host->caps & MMC_CAP_NONREMOVABLE))
 		host->bus_ops->detect(host);
 
 	/*
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
