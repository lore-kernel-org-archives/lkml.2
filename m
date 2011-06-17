Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757060Ab1FQVxI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 17:53:08 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:34388 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751519Ab1FQVxG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 17:53:06 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: Arnd Bergmann <arnd@arndb.de>, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Arun Sharma <asharma@fb.com>,
        uclinux-dist-devel@blackfin.uclinux.org
Subject: [PATCH 0/6] Merge Blackfin/SMP atomic.h support into asm-generic/atomic.h
Date: Fri, 17 Jun 2011 17:53:28 -0400
Message-Id: <1308347614-402-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.7.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I hate code in arch/blackfin/include/asm/.  The more that exists in
include/asm-generic/, the happier I get.

This fixes up the atomic mask helpers, and then makes the asm-generic
version usable for SMP systems.  Or at least Blackfin SMP; if other
peeps want in on the action, they can see what needs updating then.

The 2 Blackfin patches are just to show what's going on; I can merge
them through my tree like normal.  But the asm-generic ones will have
to be picked up by Andrew.

These shouldn't specifically conflict with Arun's work, but it will
trigger a little fuzz hate.  So I can wait for his stuff to get merged
before pushing mine through, and at this point treat the series as a
heads up.

Mike Frysinger (6):
  asm-generic/atomic.h: simplify inc/dec test helpers
  asm-generic/atomic.h: fix type used in atomic_clear_mask
  asm-generic/atomic.h: add atomic_set_mask helper
  asm-generic/atomic.h: allow SMP peeps to leverage this
  Blackfin: SMP: punt unused atomic_test_mask helper
  Blackfin: SMP: convert to common asm-generic/atomic.h

 arch/blackfin/include/asm/atomic.h |  110 +++---------------------------------
 include/asm-generic/atomic.h       |   47 ++++++++++++++--
 2 files changed, 51 insertions(+), 106 deletions(-)

-- 
1.7.5.3

