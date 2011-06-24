Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757036Ab1FXNek (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jun 2011 09:34:40 -0400
Received: from mail.free-electrons.com ([88.190.12.23]:33277 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756960Ab1FXNej (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jun 2011 09:34:39 -0400
From: david.wagner@free-electrons.com
To: linux-mtd@lists.infradead.org
Cc: dedekind1@gmail.com, dwmw2@infradead.org, linux-kernel@vger.kernel.org,
        David Wagner <david.wagner@free-electrons.com>
Subject: [RFC] ubiblk: read-only block layer on top of UBI
Date: Fri, 24 Jun 2011 15:34:41 +0200
Message-Id: <1308922482-14967-1-git-send-email-david.wagner@free-electrons.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Wagner <david.wagner@free-electrons.com>

It creates one device for each UBI volume and dynamically add/remove one when a
UBI volume is created or deleted : it registers to UBI notifications.  The
devices are names "ubiblkX_Y" where X is the UBI device number and Y is the
volume ID.

I'm submitting it for review, comments (on the concept as well as on the
implementation) and advice.  It is my first kernel module - a lot of code was
taken from mtd_blkdevs and some from gluebi.

It is only known to work well with SquashFS.  Tests reported that with other
filesystems (ext2/3 and vfat), some bytes in some files (I couldn't find any
pattern), when read through ubiblk, don't match the original content (the
content of a file becomes random on several "lines" and goes back to normal).
The reason for that is still unknown.

Some other known issues are listed in the commit message.

 drivers/mtd/ubi/Kconfig  |    9 +
 drivers/mtd/ubi/Makefile |    1 +
 drivers/mtd/ubi/ubiblk.c |  462 ++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 472 insertions(+), 0 deletions(-)
 create mode 100644 drivers/mtd/ubi/ubiblk.c

--
David Wagner, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
