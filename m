Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754649Ab1A0LyL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 06:54:11 -0500
Received: from [114.251.86.0] ([114.251.86.0]:25970 "EHLO enigma.site"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754637Ab1A0LyI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 06:54:08 -0500
From: Coly Li <bosong.ly@taobao.com>
To: linux-kernel@vger.kernel.org
Cc: Coly Li <bosong.ly@taobao.com>, Andrew Morton <akpm@linux-foundation.org>,
        Greg KH <gregkh@suse.de>
Subject: [PATCH 0/6] use BUG_ON correctly, v2
Date: Thu, 27 Jan 2011 20:12:29 +0800
Message-Id: <1296130356-29896-1-git-send-email-bosong.ly@taobao.com>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Most of BUG_ON() implementations use unlikely() internally for better
branch prediction results. The following method to use BUG_ON() with
an explicit unlikely() doesn't make things better and is unwelcome:
	BUG_ON(unlikely(condition));
Source code should use BUG_ON() just with condition code.

For arch dependent BUG_ON() implementations, they should use unlikely()
internally if they are able to.

This patch set does two things,
1) Remove all explicit unlikey() where kernel code uses BUG_ON().
2) Fix arch dependent BUG_ON() implementations if they don't use
   unlikely() internally.

The difference between v2 and v1 patch set are,
1) Remove the fix of mm/nommu.c, because it's in mm-tree already.
2) Add unlikely() inside the BUG_ON() implementations of MIPS and PPC.

Signed-off-by: Coly Li <bosong.ly@taobao.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Greg KH <gregkh@suse.de>
---
 arch/mips/include/asm/bug.h                      |    2 +-
 arch/powerpc/include/asm/bug.h                   |    4 +++-
 drivers/dma/iop-adma.c                           |    6 +++---
 drivers/dma/mv_xor.c                             |    6 +++---
 drivers/dma/ppc4xx/adma.c                        |    8 ++++----
 drivers/scsi/scsi_lib.c                          |    4 ++--
 drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c |   14 +++++++-------
 7 files changed, 23 insertions(+), 21 deletions(-)
