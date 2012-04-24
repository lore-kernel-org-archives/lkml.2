Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757085Ab2DXRuK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 13:50:10 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:45998 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755819Ab2DXRuG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 13:50:06 -0400
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Robert Love <rlove@google.com>, Mel Gorman <mel@csn.ul.ie>,
        Hugh Dickins <hughd@google.com>, Dave Hansen <dave@linux.vnet.ibm.com>,
        Rik van Riel <riel@redhat.com>,
        Dmitry Adamushko <dmitry.adamushko@gmail.com>,
        Dave Chinner <david@fromorbit.com>, Neil Brown <neilb@suse.de>,
        Andrea Righi <andrea@betterlinux.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH 0/3] Volatile Ranges
Date: Tue, 24 Apr 2012 10:49:44 -0700
Message-Id: <1335289787-11089-1-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.3.2.146.gca209
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12042417-5518-0000-0000-000003E31EDD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So the last RFC iteration of this patch set didn't get any feedback,
so I wanted to properly submit the volatile range functionality for
inclusion.  I suspect this will bring some useful critiques out of
the wood work, which I'd welcome, but maybe not and this can be
queued. Here's to optimism. :)

In addition to the two patches for volatile ranges, I've also
included an RFC patch converting the ashmem driver to use volatile
ranges.

Thoughts or feedback on it would be appreciated.

thanks
-john

CC: Andrew Morton <akpm@linux-foundation.org>
CC: Android Kernel Team <kernel-team@android.com>
CC: Robert Love <rlove@google.com>
CC: Mel Gorman <mel@csn.ul.ie>
CC: Hugh Dickins <hughd@google.com>
CC: Dave Hansen <dave@linux.vnet.ibm.com>
CC: Rik van Riel <riel@redhat.com>
CC: Dmitry Adamushko <dmitry.adamushko@gmail.com>
CC: Dave Chinner <david@fromorbit.com>
CC: Neil Brown <neilb@suse.de>
CC: Andrea Righi <andrea@betterlinux.com>
CC: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

John Stultz (3):
  Range tree implementation
  fadvise: Add _VOLATILE,_ISVOLATILE, and _NONVOLATILE flags
  [RFC] ashmem: Convert ashmem to use volatile ranges

 drivers/staging/android/ashmem.c |  327 +--------------------------
 fs/file_table.c                  |    4 +
 include/linux/fadvise.h          |    5 +
 include/linux/rangetree.h        |   56 +++++
 include/linux/volatile.h         |   12 +
 lib/Makefile                     |    2 +-
 lib/rangetree.c                  |  128 +++++++++++
 mm/Makefile                      |    2 +-
 mm/fadvise.c                     |   16 ++-
 mm/volatile.c                    |  457 ++++++++++++++++++++++++++++++++++++++
 10 files changed, 689 insertions(+), 320 deletions(-)
 create mode 100644 include/linux/rangetree.h
 create mode 100644 include/linux/volatile.h
 create mode 100644 lib/rangetree.c
 create mode 100644 mm/volatile.c

-- 
1.7.3.2.146.gca209

