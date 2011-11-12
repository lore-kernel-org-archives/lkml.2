Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754189Ab1H2Qmf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 12:42:35 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:37265 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753873Ab1H2Qmb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 12:42:31 -0400
From: Minchan Kim <minchan.kim@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Mel Gorman <mgorman@suse.de>, Johannes Weiner <jweiner@redhat.com>,
        Rik van Riel <riel@redhat.com>, Minchan Kim <minchan.kim@gmail.com>
Subject: [PATCH 0/3] Fix compaction about mlocked pages
Date: Sun, 13 Nov 2011 01:37:40 +0900
Message-Id: <cover.1321112552.git.minchan.kim@gmail.com>
X-Mailer: git-send-email 1.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch's goal is to enable mlocked page migration.
The compaction can migrate mlocked page to get a contiguous memory unlike lumpy.

During making this patch, I found my silly bug which
[1/3] which fixes it.
[2/3] enables compaction of mlocked.
[3/3] enhance the accouting of compaction.

Frankly speaking, each patch is orthogonal but I send it by thread as I found them during
making patch on mlocked page compaction.

Minchan Kim (3):
  Correct isolate_mode_t bitwise type
  compaction: compact unevictable page
  compaction accouting fix

 include/linux/mmzone.h |   10 ++++++----
 mm/compaction.c        |   13 +++++++++----
 mm/vmscan.c            |    7 +------
 3 files changed, 16 insertions(+), 14 deletions(-)

--
1.7.6
