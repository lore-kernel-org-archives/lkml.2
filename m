Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966041Ab2FAXjB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 19:39:01 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:35062 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966015Ab2FAXjA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 19:39:00 -0400
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
        Jan Kara <jack@suse.cz>, KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Subject: [PATCH 0/3] [RFC] Fallocate Volatile Ranges v3
Date: Fri,  1 Jun 2012 16:38:43 -0700
Message-Id: <1338593926-17344-1-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.3.2.146.gca209
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12060123-7408-0000-0000-000005833049
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just another quick iteration on the fallocate volatile ranges.

This version utilizes Dave Hansen's suggestion to use the
shmem_writepage code to trigger the volatile range purging.
This avoids using a shrinker as requested by KOSAKI Motohiro
and makes unnecessary some of the page counting logic.

Also caught an off by one bug in the page purging.

Let me know if you have any further feedback or thoughts!

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
CC: KOSAKI Motohiro <kosaki.motohiro@gmail.com>

John Stultz (3):
  [RFC] Interval tree implementation
  [RFC] Add volatile range management code
  [RFC] tmpfs: Add FALLOC_FL_MARK_VOLATILE/UNMARK_VOLATILE handlers

 fs/open.c                    |    3 +-
 include/linux/falloc.h       |    7 +-
 include/linux/intervaltree.h |   55 +++++
 include/linux/volatile.h     |   41 ++++
 lib/Makefile                 |    2 +-
 lib/intervaltree.c           |  119 ++++++++++
 mm/Makefile                  |    2 +-
 mm/shmem.c                   |   84 ++++++++
 mm/volatile.c                |  486 ++++++++++++++++++++++++++++++++++++++++++
 9 files changed, 793 insertions(+), 6 deletions(-)
 create mode 100644 include/linux/intervaltree.h
 create mode 100644 include/linux/volatile.h
 create mode 100644 lib/intervaltree.c
 create mode 100644 mm/volatile.c

-- 
1.7.3.2.146.gca209

