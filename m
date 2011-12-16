Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932798Ab1LPUWj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 15:22:39 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:58285 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932590Ab1LPUWb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 15:22:31 -0500
Date: Fri, 16 Dec 2011 15:22:29 -0500 (EST)
Message-Id: <20111216.152229.161655308008211539.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] Sparc
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Fri, 16 Dec 2011 12:22:30 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


1) Bootup on 32-bit fails because gcc started to emit tail calls more
   aggressively, so we need to accept 13-bit signed immediation
   relocations into 'restore' instructions.

2) Kill unused variable in bbc_i2c and module_platform_driver()
conversion from Axel Lin.

3) Use kmemdup(), from Thomas Meyer.

Please pull, thanks a lot!

The following changes since commit 2cfab8d74ebfbe06ce2947117945c4f45a5915ec:

  Merge branch 'drm-intel-fixes' of git://people.freedesktop.org/~keithp/linux (2011-12-16 11:27:56 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/davem/sparc.git master

Axel Lin (2):
      bbc_i2c: Remove unneeded err variable
      sbus: convert drivers/sbus/char/* to use module_platform_driver()

David S. Miller (1):
      sparc32: Be less strict in matching %lo part of relocation.

Thomas Meyer (1):
      sparc: Use kmemdup rather than duplicating its implementation

 arch/sparc/kernel/ds.c          |    6 ++----
 arch/sparc/kernel/prom_common.c |    4 +---
 arch/sparc/mm/btfixup.c         |    3 +--
 drivers/sbus/char/bbc_i2c.c     |   27 +++++----------------------
 drivers/sbus/char/display7seg.c |   13 +------------
 drivers/sbus/char/envctrl.c     |   12 +-----------
 drivers/sbus/char/flash.c       |   12 +-----------
 drivers/sbus/char/uctrl.c       |   12 +-----------
 8 files changed, 13 insertions(+), 76 deletions(-)
