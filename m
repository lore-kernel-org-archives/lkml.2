Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965646Ab2FASaJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 14:30:09 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:37196 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758770Ab2FASaG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 14:30:06 -0400
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
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Taras Glek <tgek@mozilla.com>, Mike Hommey <mh@glandium.org>,
        Jan Kara <jack@suse.cz>
Subject: [PATCH 0/3] [RFC] Fallocate Volatile Ranges v2
Date: Fri,  1 Jun 2012 11:29:44 -0700
Message-Id: <1338575387-26972-1-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.3.2.146.gca209
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12060118-7182-0000-0000-000001A6B9B8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's another update to the Fallocate Volatile Range code.

The bigish change is renaming the range-tree code to
interval-tree, as Jan Kara pointed out that term is more
accurate (although this is a naive implementation).

I also fixed a bad bug in the volatile range management,
and added an optimization so we don't run over the lru
to determine how many pages are unpurged.

Thanks to everyone for the review so far, please let me
know if you have any further thoughts or suggestions.

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
CC: Taras Glek <tgek@mozilla.com>
CC: Mike Hommey <mh@glandium.org>
CC: Jan Kara <jack@suse.cz>

John Stultz (3):
  [RFC] Interval tree implementation
  [RFC] Add volatile range management code
  [RFC] tmpfs: Add FALLOC_FL_MARK_VOLATILE/UNMARK_VOLATILE handlers

 fs/open.c                    |    3 +-
 include/linux/falloc.h       |    7 +-
 include/linux/intervaltree.h |   55 +++++
 include/linux/volatile.h     |   45 ++++
 lib/Makefile                 |    2 +-
 lib/intervaltree.c           |  119 ++++++++++
 mm/Makefile                  |    2 +-
 mm/shmem.c                   |  107 +++++++++
 mm/volatile.c                |  509 ++++++++++++++++++++++++++++++++++++++++++
 9 files changed, 843 insertions(+), 6 deletions(-)
 create mode 100644 include/linux/intervaltree.h
 create mode 100644 include/linux/volatile.h
 create mode 100644 lib/intervaltree.c
 create mode 100644 mm/volatile.c

-- 
1.7.3.2.146.gca209

