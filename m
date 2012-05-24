Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754014Ab2EXWti (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 18:49:38 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:55776 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751101Ab2EXWth (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 18:49:37 -0400
From: Joe Perches <joe@perches.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, Kay Sievers <kay@vrfy.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [RFC PATCH 0/3] printk: Use a non-printable ASCII SOH for KERN_<LEVEL>
Date: Thu, 24 May 2012 15:49:30 -0700
Message-Id: <cover.1337899274.git.joe@perches.com>
X-Mailer: git-send-email 1.7.8.111.gad25c.dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

printk uses "<.>" as a start of record indicator.
This can waste a bit of space and causes a bit of
contortion to get a printk emitted that happens to
starts with "<.>".

Use ASCII Start-of-Header (0x01) as the KERN_LEVEL
initiator and save ~10K in an x86 defconfig.

Joe Perches (3):
  printk: Use a non-printable ASCII KERN_<LEVEL> initiator
  treewide: Fix declaration and uses of old KERN_<LEVEL> style
  printk: Set KERN_CONT to ""

 arch/arm/lib/io-acorn.S              |    4 +++-
 arch/arm/vfp/vfphw.S                 |    8 +++++---
 arch/frv/kernel/kernel_thread.S      |    2 +-
 drivers/staging/wlags49_h2/hcf.c     |    8 ++++----
 drivers/staging/wlags49_h2/wl_main.c |    4 ++--
 fs/btrfs/super.c                     |    9 +++++----
 include/linux/printk.h               |   23 +++++++++++++----------
 kernel/printk.c                      |    6 +++---
 net/bridge/netfilter/ebt_log.c       |    2 +-
 sound/core/misc.c                    |    8 ++++----
 10 files changed, 41 insertions(+), 33 deletions(-)

-- 
1.7.8.111.gad25c.dirty

