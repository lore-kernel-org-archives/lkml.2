Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752919Ab1KHHpK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 02:45:10 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:62192 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752681Ab1KHHpH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 02:45:07 -0500
MIME-Version: 1.0
X-Originating-IP: [93.172.63.171]
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Tue, 8 Nov 2011 09:44:45 +0200
Message-ID: <CAK=WgbYWeYQf2dRsD2iBf+d7Eo=HiTynifVP3DhES5CwPUzCwQ@mail.gmail.com>
Subject: [GIT PULL] hwspinlock fixes for 3.2
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-arm <linux-arm-kernel@lists.infradead.org>,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        Tony Lindgren <tony@atomide.com>, Axel Lin <axel.lin@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull:

  git://git.kernel.org/pub/scm/linux/kernel/git/ohad/hwspinlock.git fixes

To get two hwspinlock fixes from Axel.

There was a third, "module.h split merge"-related fix from Axel that I
dropped because I saw Paul picked it up in his pull request.

Thanks,
Ohad.

The following changes since commit 1ea6b8f48918282bdca0b32a34095504ee65bab5:

  Linux 3.2-rc1 (2011-11-07 16:16:02 -0800)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/ohad/hwspinlock.git fixes

Axel Lin (2):
      hwspinlock: Don't return a value in __hwspin_unlock
      hwspinlock/u8500: fix build error due to undefined label

 drivers/hwspinlock/u8500_hsem.c |    6 ++----
 include/linux/hwspinlock.h      |    1 -
 2 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/hwspinlock/u8500_hsem.c b/drivers/hwspinlock/u8500_hsem.c
index 143461a..a120f14 100644
--- a/drivers/hwspinlock/u8500_hsem.c
+++ b/drivers/hwspinlock/u8500_hsem.c
@@ -108,10 +108,8 @@ static int __devinit u8500_hsem_probe(struct
platform_device *pdev)
 		return -ENODEV;

 	io_base = ioremap(res->start, resource_size(res));
-	if (!io_base) {
-		ret = -ENOMEM;
-		goto free_state;
-	}
+	if (!io_base)
+		return -ENOMEM;

 	/* make sure protocol 1 is selected */
 	val = readl(io_base + HSEM_CTRL_REG);
diff --git a/include/linux/hwspinlock.h b/include/linux/hwspinlock.h
index 08a2fee..aad6bd4 100644
--- a/include/linux/hwspinlock.h
+++ b/include/linux/hwspinlock.h
@@ -118,7 +118,6 @@ int __hwspin_trylock(struct hwspinlock *hwlock,
int mode, unsigned long *flags)
 static inline
 void __hwspin_unlock(struct hwspinlock *hwlock, int mode, unsigned long *flags)
 {
-	return 0;
 }

 static inline int hwspin_lock_get_id(struct hwspinlock *hwlock)
