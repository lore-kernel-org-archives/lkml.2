Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754520Ab0K2PXh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 10:23:37 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:36544 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751651Ab0K2PXg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 10:23:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=ZuRKEa2+982kCNGLEH4wRwlsUvT9qs29HRTI7ww0S+Y4BIGqpw/NvVVwqPpYEWPKv2
         sxyvuB6c+krjSTwstFGTUaSWEdQyLoXi/zMR5q6X1jZLRBYHMBiNSnPXvwAssi3anv5i
         DBm0N9ZXCEOxPB+lUwVNj6MF+h4oWUU9CStaA=
From: Minchan Kim <minchan.kim@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Ben Gamari <bgamari.foss@gmail.com>,
        Minchan Kim <minchan.kim@gmail.com>
Subject: [PATCH v3 0/3] f/madivse(DONTNEED) support
Date: Tue, 30 Nov 2010 00:23:18 +0900
Message-Id: <cover.1291043273.git.minchan.kim@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Recently there is a report about working set page eviction due to rsync
workload. application programmers want to use fadvise but it's not easy.
You could see detailed description on [1/3].

 - [1/3] is to move invalidated page which is dirty/writeback on active list
   into inactive list's head.
 - [2/3] is for moving invalidated page into inactive list's tail when the
   page's writeout is completed.
 - [3/3] is to not calling mark_page_accessed in case of madvise(DONTNEED).

Minchan Kim (3):
  deactivate invalidated pages
  Reclaim invalidated page ASAP
  Prevent activation of page in madvise_dontneed

 include/linux/mm.h   |    4 +-
 include/linux/swap.h |    1 +
 mm/madvise.c         |    4 +-
 mm/memory.c          |   38 +++++++++++-------
 mm/mmap.c            |    4 +-
 mm/page-writeback.c  |   12 +++++-
 mm/swap.c            |  102 ++++++++++++++++++++++++++++++++++++++++++++++++++
 mm/truncate.c        |   16 ++++++--
 8 files changed, 155 insertions(+), 26 deletions(-)

