Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757197Ab3AIGVT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 01:21:19 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:44917 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752187Ab3AIGVS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 01:21:18 -0500
X-AuditID: 9c930179-b7c7fae00000255c-ac-50ed0c5c6839
From: Minchan Kim <minchan@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Sonny Rao <sonnyrao@google.com>, Bryan Freed <bfreed@google.com>,
        Hugh Dickins <hughd@google.com>, Rik van Riel <riel@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Minchan Kim <minchan@kernel.org>
Subject: [PATCH 0/2] Use up free swap space before reaching OOM kill
Date: Wed,  9 Jan 2013 15:21:12 +0900
Message-Id: <1357712474-27595-1-git-send-email-minchan@kernel.org>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Recently, Luigi reported there are lots of free swap space when
OOM happens. It's easily reproduced on zram-over-swap, where
many instance of memory hogs are running and laptop_mode = 2.
http://marc.info/?l=linux-mm&m=135421750914807&w=2

This patchset fixes the problem. In fact, if we apply one of two,
we can fix the problem but I send two all because it's separate
issue although each of them solves this issues.

Andrew, Could you replace [1] with this patchset in mmotm?
I think this patchset is better than [1].

[1] mm-swap-out-anonymous-page-regardless-of-laptop_mode.patch

Minchan Kim (2):
  [1/2] mm: prevent to add a page to swap if may_writepage is unset
  [2/2] mm: forcely swapout when we are out of page cache

 mm/vmscan.c |    8 ++++++++
 1 file changed, 8 insertions(+)

-- 
1.7.9.5

