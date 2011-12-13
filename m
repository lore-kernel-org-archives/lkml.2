Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754906Ab1LMN6r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 08:58:47 -0500
Received: from zene.cmpxchg.org ([85.214.230.12]:58144 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754861Ab1LMN6m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 08:58:42 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [patch 0/4] mm: bootmem / page allocator bootstrap fixlets
Date: Tue, 13 Dec 2011 14:58:27 +0100
Message-Id: <1323784711-1937-1-git-send-email-hannes@cmpxchg.org>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Uwe,

here is a follow-up to your bootmem micro optimizations.  3 and 4
directly relate to the discussion, 1 and 2 are cleanups I had sitting
around anyway.

Unfortunately, I can't test them as x86 kernels no longer build with
CONFIG_NO_BOOTMEM=n, but I suspect that you might have access to
non-x86 machines ;-) so if you can, please give this a spin - I don't
want this stuff to go in untested.

[ Fun fact: nobootmem.c is 400 lines of bootmem API emulation that is
  just incompatible enough that one can not switch between bootmem and
  nobootmem without touching callsites. ]

 mm/bootmem.c    |   22 ++++++++++------------
 mm/page_alloc.c |   33 ++++++++++++---------------------
 2 files changed, 22 insertions(+), 33 deletions(-)

