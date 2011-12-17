Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750987Ab1LQHwW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Dec 2011 02:52:22 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:58644 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750704Ab1LQHwP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Dec 2011 02:52:15 -0500
Date: Fri, 16 Dec 2011 23:51:55 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Andrew Morton <akpm@linux-foundation.org>
cc: Randy Dunlap <rdunlap@xenotime.net>, Naveen Yadav <yad.naveen@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/5] rtth: Radix Tree Test Harness fixes
Message-ID: <alpine.LSU.2.00.1112162347440.1981@eggly.anvils>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Several months ago I promised Randy that I would update the
Radix Tree Test Harness rtth, to reflect recent kernel changes.
That fell off my radar for a while, but I've another little
change coming up (taking the radix_tree_path off the stack),
and really needed a working rtth to validate that change.
Here's a set of fixes to rtth; then when I've written that up
(hopefully tomorrow), I'll send a kernel patch and a matching
rtth patch.

Hugh

 Makefile                  |    2 
 linux.c                   |    5 -
 linux/bitops.h            |  122 ++++++++++++++++++++++++++++----
 linux/bitops/__ffs.h      |   43 -----------
 linux/bitops/ffs.h        |   41 ----------
 linux/bitops/ffz.h        |   12 ---
 linux/bitops/find.h       |   13 ---
 linux/bitops/fls.h        |   41 ----------
 linux/bitops/fls64.h      |   14 ---
 linux/bitops/hweight.h    |   11 --
 linux/bitops/le.h         |   53 -------------
 linux/bitops/non-atomic.h |  111 -----------------------------
 linux/notifier.h          |    4 +
 linux/radix-tree.h        |   58 +++++++++++++--
 linux/rcupdate.h          |   15 ---
 linux/types.h             |    9 +-
 main.c                    |    7 +
 radix-tree.c              |  137 ++++++++++++++++++++++++++++++------
 rcupdate.c                |   86 ----------------------
 regression1.c             |   24 ++++--
 test.c                    |    2 
 test.h                    |   26 ++++--
 22 files changed, 329 insertions(+), 507 deletions(-)
