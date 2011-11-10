Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934760Ab1KJOFk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 09:05:40 -0500
Received: from mtagate7.uk.ibm.com ([194.196.100.167]:55571 "EHLO
	mtagate7.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934688Ab1KJOFi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 09:05:38 -0500
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Pekka Enberg <penberg@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Jeff Dike <jdike@addtoit.com>, Ingo Molnar <mingo@elte.hu>,
        Christoph Lameter <cl@linux.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [PATCH 0/3] CMPXCHG config options changes
Date: Thu, 10 Nov 2011 15:04:17 +0100
Message-Id: <1320933860-15588-1-git-send-email-heiko.carstens@de.ibm.com>
X-Mailer: git-send-email 1.7.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While implementing cmpxchg_double() on s390 I realized that we don't
set CONFIG_CMPXCHG_LOCAL besides the fact that we have support for it.
However setting that option will increase the size of struct page by
eight bytes on 64 bit, which we certainly do not want.
Also, it doesn't make sense that a present cpu feature should increase
the size of struct page.
Besides that it looks like the dependency to CMPXCHG_LOCAL is wrong
and that it should depend on CMPXCHG_DOUBLE instead.

Heiko Carstens (3):
  mm,slub,x86: decouple size of struct page from CONFIG_CMPXCHG_LOCAL
  mm,x86,um: move CMPXCHG_LOCAL config option
  mm,x86,um: move CMPXCHG_DOUBLE config option

 arch/Kconfig             |   14 ++++++++++++++
 arch/x86/Kconfig         |    3 +++
 arch/x86/Kconfig.cpu     |    6 ------
 arch/x86/um/Kconfig      |    8 --------
 include/linux/mm_types.h |    9 ++++-----
 mm/slub.c                |    9 ++++++---
 mm/vmstat.c              |    2 +-
 7 files changed, 28 insertions(+), 23 deletions(-)

-- 
1.7.7.1

