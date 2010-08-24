Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753994Ab0HXEYT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 00:24:19 -0400
Received: from kroah.org ([198.145.64.141]:56424 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751585Ab0HXEYR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 00:24:17 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Dan Carpenter <error27@gmail.com>,
        "Michael H. Warfield" <mhw@wittsend.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 3/6] ip2: return -EFAULT on copy_to_user errors
Date: Mon, 23 Aug 2010 21:24:03 -0700
Message-Id: <1282623846-17050-3-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20100824040508.GC16749@kroah.com>
References: <20100824040508.GC16749@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dan Carpenter <error27@gmail.com>

copy_to_user() returns the number of bytes remaining but we want to return
a negative error code on errors.

Signed-off-by: Dan Carpenter <error27@gmail.com>
Cc: "Michael H. Warfield" <mhw@wittsend.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/char/ip2/ip2main.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/char/ip2/ip2main.c b/drivers/char/ip2/ip2main.c
index 8fa041e..d4b71e8 100644
--- a/drivers/char/ip2/ip2main.c
+++ b/drivers/char/ip2/ip2main.c
@@ -2930,6 +2930,8 @@ ip2_ipl_ioctl (struct file *pFile, UINT cmd, ULONG arg )
 				if ( pCh )
 				{
 					rc = copy_to_user(argp, pCh, sizeof(i2ChanStr));
+					if (rc)
+						rc = -EFAULT;
 				} else {
 					rc = -ENODEV;
 				}
-- 
1.7.2

