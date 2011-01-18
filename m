Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753339Ab1ARVSJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 16:18:09 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:65220 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752128Ab1ARVSF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 16:18:05 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Dave Airlie <airlied@linux.ie>
Subject: [PATCH 0/4] Phasing out the BKL
Date: Tue, 18 Jan 2011 22:16:58 +0100
Message-Id: <1295385422-3592-1-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.1
X-Provags-ID: V02:K0:9bQZ4zlvPpSndDVIH1UcvKAXNBTXU40hkvnC4zDx2eW
 Keb6ge68hZrZsEDhPN8+04FZdcx45iTshil0pgbPSt0KegZfeC
 651V1qh4zUjW/CyyaupmO78SnXSuam6Y5/MFDdWAWtqDxJpk/u
 Jg+h2mMdbAT88GMi5I8VRRa16ZQIMLmd4m1tvkshOJBClMSEvB
 493bft6XqJhq6LmbLdtdw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

These are the remaining patches I have for moving
the big kernel lock further out of the view of
developers. I had originally made them for 2.6.37
and they have been in linux-next since.

None of them has any real significance at this point,
since there are few people using the remaining modules
that require the BKL (ipx, appletalk, x.25, ufs,
adfs, hpfs, i830-drm, and a few bits in staging).
I expect to see patches for the first four in that
list at some point in the near future, after that
I suppose we can remove the option along with the
remaining dependencies completely.

For now, please pick any patches you like out of
these four.

Cc: Dave Airlie <airlied@linux.ie>

Arnd Bergmann (4):
  drm/i810: remove the BKL
  BKL: disable by default
  BKL: mark lock_kernel as deprecated
  BKL: move CONFIG_BKL to staging

 drivers/gpu/drm/Kconfig         |    4 ++--
 drivers/gpu/drm/i810/i810_dma.c |   18 +-----------------
 drivers/gpu/drm/i810/i810_drv.c |    6 +++++-
 drivers/staging/Kconfig         |   10 ++++++++++
 include/linux/smp_lock.h        |   23 ++++++-----------------
 lib/Kconfig.debug               |    9 ---------
 6 files changed, 24 insertions(+), 46 deletions(-)

