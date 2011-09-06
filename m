Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754947Ab1IFUBo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 16:01:44 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:35002 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754812Ab1IFUBi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 16:01:38 -0400
Date: Tue, 06 Sep 2011 20:03:23 +0000
From: Ayan George <ayan@ayan.net>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, psusi@cfl.rr.com
Subject: [PATCH 1/2] Fixed loopback device to emit uevent on auto release
Message-ID: <4e667c8b.kbjARDpYtcTuZVKx%ayan.george@canonical.com>
User-Agent: Heirloom mailx 12.4 7/29/08
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At Andrew Norton's request, I've split up my API cleanup patches into two.
Below is Phillip Susi's uevent notification fix and the second part of the
patch is the API cleanup.

>From e0a49665093b7e8289e3c733f4aa0e17e11c0c10 Mon Sep 17 00:00:00 2001
From: Phillip Susi <psusi@cfl.rr.com>
Date: Tue, 6 Sep 2011 15:07:30 -0400
Subject: [PATCH 1/2] Fixed loopback device to emit uevent on auto release

The loopback driver failed to emit the change uevent
when auto releasing the device.  Fixed lo_release()
to pass the bdev to loop_clr_fd() so it can emit
the event.

Signed-off-by: Phillip Susi <psusi@cfl.rr.com>
---
 drivers/block/loop.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index 4720c7a..6d0f28d 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -1513,7 +1513,7 @@ static int lo_release(struct gendisk *disk, fmode_t mode)
 		 * In autoclear mode, stop the loop thread
 		 * and remove configuration after last close.
 		 */
-		err = loop_clr_fd(lo, NULL);
+		err = loop_clr_fd(lo, lo->lo_device);
 		if (!err)
 			goto out_unlocked;
 	} else {
-- 
1.7.4.1


