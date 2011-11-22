Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757077Ab1KVSO6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 13:14:58 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:54938 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755518Ab1KVSOz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 13:14:55 -0500
From: David Daney <ddaney.cavm@gmail.com>
To: ralf@linux-mips.org, Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>, DM <dm.n9107@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        David Daney <david.daney@cavium.com>
Subject: [PATCH v2 0/2] Stop some of the abuse of BUG() where compile time checks should be used.
Date: Tue, 22 Nov 2011 10:14:44 -0800
Message-Id: <1321985686-798-1-git-send-email-ddaney.cavm@gmail.com>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Daney <david.daney@cavium.com>

New for v2:

As suggested by 'DM', call the macro BUILD_BUG() instead of
BUILD_BUG_ON_USED().  Linus seemed satisfied with this, so if it still
looks good, can we put it in some linux-next tree (Perhaps Andrew
Morton's) to cook for a while?

The second patch now covers linux/huge_mm.h too.

>From v1:

   After some, perhaps justified, reluctance to merge dummy
   symbol definitions containing BUG() into header files, I propose
   these patches instead.

   We define a new compile time assertion BUILD_BUG_ON_USED() that can
   be used in places were we expect the compiler's dead code
   elimination to get rid of code.  This happens mostly in code
   dealing with huge pages, but in other places as well.

   The first patch adds BUILD_BUG_ON_USED(), the second gets rid of
   one of the main abusers of BUG().

David Daney (2):
  kernel.h: Add BUILD_BUG() macro.
  hugetlb: Replace BUG() with BUILD_BUG() for dummy definitions.

 include/linux/compiler-gcc4.h |    1 +
 include/linux/compiler.h      |    4 +++-
 include/linux/huge_mm.h       |    8 ++++----
 include/linux/hugetlb.h       |   14 +++++++-------
 include/linux/kernel.h        |   16 ++++++++++++++++
 5 files changed, 31 insertions(+), 12 deletions(-)

-- 
1.7.2.3

