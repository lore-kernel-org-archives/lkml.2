Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754874Ab2BEWgq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Feb 2012 17:36:46 -0500
Received: from 1wt.eu ([62.212.114.60]:62079 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754489Ab2BEW04 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Feb 2012 17:26:56 -0500
Message-Id: <20120205220952.484134878@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Sun, 05 Feb 2012 23:11:00 +0100
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Richard Weinberger <richard@nod.at>,
        Artem Bityutskiy <Artem.Bityutskiy@linux.intel.com>,
        Greg KH <gregkh@linuxfoundation.org>
Subject: [PATCH 71/91] UBI: fix nameless volumes handling
In-Reply-To: <0635750f5f06ed2ca212b91fcb5c4483@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-longterm review patch.  If anyone has any objections, please let us know.

------------------

commit 4a59c797a18917a5cf3ff7ade296b46134d91e6a upstream.

Currently it's possible to create a volume without a name. E.g:
ubimkvol -n 32 -s 2MiB -t static /dev/ubi0 -N ""

After that vtbl_check() will always fail because it does not permit
empty strings.

Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/mtd/ubi/cdev.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

Index: longterm-2.6.27/drivers/mtd/ubi/cdev.c
===================================================================
--- longterm-2.6.27.orig/drivers/mtd/ubi/cdev.c	2012-02-05 22:34:32.837915400 +0100
+++ longterm-2.6.27/drivers/mtd/ubi/cdev.c	2012-02-05 22:34:44.966914934 +0100
@@ -569,6 +569,9 @@
 	if (req->alignment != 1 && n)
 		goto bad;
 
+	if (!req->name[0] || !req->name_len)
+		goto bad;
+
 	if (req->name_len > UBI_VOL_NAME_MAX) {
 		err = -ENAMETOOLONG;
 		goto bad;


