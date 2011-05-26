Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757615Ab1EZM4G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 08:56:06 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:61452 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751589Ab1EZM4E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 08:56:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=qEWQLKpJFt6CB/yCoVA1aBfxFYaLhtnNvA55zYXu7ZaD1Liz2mqVG+2CINqk2YYzLl
         CiYH7yqZmorG6ifLbmpYgpkwPOlCMc9Q50mj3c4E10FD45QxwMchSVR6NFn5hH4jxHDJ
         FyKyGp6snqyUlIgmKnQSveV3CeQjrgWxde2w8=
From: Namhyung Kim <namhyung@gmail.com>
To: Jens Axboe <axboe@kernel.dk>, Nick Piggin <npiggin@kernel.dk>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 0/5] brd: partition handling fixes
Date: Thu, 26 May 2011 21:55:52 +0900
Message-Id: <1306414557-2441-1-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.5.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

This is a patch set for fixing bugs on partition handling code which
was found when I read loop block device code as well as some cleanups.

The patch 2/5 and 3/5 are real fixes and should go to the stable tree
as Jens suggested on loop patches. Since partition managing code was
introduced by commit d7853d1f8932 ("brd: modify ramdisk device to be
able to manage partitions") all stable releases would need these fixes.

  $ git name-rev --tags d7853d1f8932
  d7853d1f8932 tags/v2.6.26-rc1~122

As always, any comments are welcomed.
Thanks.


Namhyung Kim (5):
  brd: get rid of unused members from struct brd_device
  brd: limit 'max_part' module param to DISK_MAX_PARTS
  brd: handle on-demand devices correctly
  brd: fix comment on initial device creation
  brd: export module parameters

 drivers/block/brd.c |   42 ++++++++++++++++++++++++++----------------
 1 files changed, 26 insertions(+), 16 deletions(-)

--
1.7.5.2

