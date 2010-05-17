Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753861Ab0EQFg1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 01:36:27 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:48370 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753388Ab0EQFgY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 01:36:24 -0400
From: Nitin Gupta <ngupta@vflare.org>
To: Greg KH <greg@kroah.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Nigel Cunningham <nigel@tuxonice.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Minchan Kim <minchan.kim@gmail.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, Cyp <cyp561@gmail.com>,
       driverdev <devel@driverdev.osuosl.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/3] ramzswap: Eliminate stale data from compressed memory (v2 resend)
Date: Mon, 17 May 2010 11:02:41 +0530
Message-Id: <1274074364-8838-1-git-send-email-ngupta@vflare.org>
X-Mailer: git-send-email 1.6.6.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Resending as Greg wanted.

(tested on mainline but should apply to linux-next cleanly)


 * Changelog: v2 vs initial patches
   - directly add swap free callback to block_device_operations
     instead of using 'notifiers' for various swap events.

ramzswap driver creates RAM based block devices which can be
used (only) as swap disks. Pages swapped to these disks are
compressed and stored in memory itself.

However, these devices do not get any notification when a swap
slot is freed (swap_map[i] reaches 0). So, we cannot free memory
allocated corresponding to this swap slot. Such stale data can
quickly accumulate in (compressed) memory defeating the whole
purpose of such devices.

To overcome this problem, we now add a callback in struct
block_device_operations which is called as soon as a swap
slot is freed.

Nitin Gupta (3):
  Add flag to identify block swap devices
  Add swap slot free callback to block_device_operations
  ramzswap: Handler for swap slot free callback

 drivers/staging/ramzswap/TODO           |    5 -----
 drivers/staging/ramzswap/ramzswap_drv.c |   22 +++++++++++++---------
 include/linux/blkdev.h                  |    2 ++
 include/linux/swap.h                    |    1 +
 mm/swapfile.c                           |    5 +++++
 5 files changed, 21 insertions(+), 14 deletions(-)
 delete mode 100644 drivers/staging/ramzswap/TODO

