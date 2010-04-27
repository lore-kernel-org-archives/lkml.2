Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755997Ab0D0OYm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 10:24:42 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:49407 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753950Ab0D0OYl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 10:24:41 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: John Kacur <jkacur@redhat.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Jan Blunck <jblunck@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
       Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 0/6] BKL pushdown into ioctl, continued
Date: Tue, 27 Apr 2010 16:24:18 +0200
Message-Id: <1272378265-10909-1-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <alpine.LFD.2.00.1004271359180.3318@localhost>
References: <alpine.LFD.2.00.1004271359180.3318@localhost>
X-Provags-ID: V01U2FsdGVkX1+MtOWW7TQP1/XhZh5OiHd5Vh6UPnGKILemZ6L
 0mNzf4pS7GIY7elWDgT+sV2rvA5uFBr/J3uLYtA+WEFM6xDe2E
 2CmcGT2c3ppNZDFiVCuTQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here comes my share of the remaining code.

> Arnd
> ----
> arch/cris/arch-v10/drivers/ds1302.c
> arch/cris/arch-v10/drivers/pcf8563.c
> arch/cris/arch-v32/drivers/i2c.c
> arch/cris/arch-v32/drivers/pcf8563.c
> arch/ia64/sn/kernel/sn2/sn_hwperf.c

done

> arch/m68k/mvme16x/rtc.c

dropped, as suggested by Geert

> arch/um/drivers/mmapper_kern.c
> fs/coda/psdev.c
> fs/hfsplus/dir.c
> fs/logfs/file.c

done

> fs/ntfs/dir.c

Nothing to see here

> fs/smbfs/file.c

done


Arnd Bergmann (6):
  logfs: push down BKL into ioctl function
  hfsplus: push down BKL into ioctl function
  cris: push down BKL into some device drivers
  sn_hwperf: kill BKL usage
  um/mmapper: remove BKL usage
  coda/psdev: remove BKL from ioctl function

 arch/cris/arch-v10/drivers/ds1302.c  |   20 +++++++++++++++-----
 arch/cris/arch-v10/drivers/pcf8563.c |   19 +++++++++++++++----
 arch/cris/arch-v32/drivers/i2c.c     |   22 ++++++++++++++--------
 arch/cris/arch-v32/drivers/pcf8563.c |   21 ++++++++++++++++-----
 arch/ia64/sn/kernel/sn2/sn_hwperf.c  |    9 ++-------
 arch/um/drivers/mmapper_kern.c       |    5 ++---
 fs/coda/psdev.c                      |    5 ++---
 fs/hfsplus/dir.c                     |    2 +-
 fs/hfsplus/hfsplus_fs.h              |    3 +--
 fs/hfsplus/ioctl.c                   |   11 ++++++++---
 fs/logfs/dir.c                       |    2 +-
 fs/logfs/file.c                      |   19 +++++++++++++++----
 fs/logfs/logfs.h                     |    4 ++--
 13 files changed, 94 insertions(+), 48 deletions(-)

