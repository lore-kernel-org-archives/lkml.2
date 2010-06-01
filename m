Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757395Ab0FAVFG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 17:05:06 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:60281 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932307Ab0FAVFD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 17:05:03 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
       linux-usb@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
       John Kacur <jkacur@redhat.com>, Andi Kleen <andi@firstfloor.org>,
       Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 1/6] USB-BKL: Remove lock_kernel in usbfs update_sb()
Date: Tue,  1 Jun 2010 23:04:40 +0200
Message-Id: <1275426285-9088-2-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1275426285-9088-1-git-send-email-arnd@arndb.de>
References: <1275426285-9088-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+kMKW8GxfRhhuIqloto6WDKd4ui8De/tJUusc
 ePmJPJmi08r7aj+8HdLhlu0IaRrq31mavrODpxWsCxqkvlTxJ5
 UvAwgDWA7M5Qwv7UBR76Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

The code this is attempting to lock against does not use the BKL,
so it's not needed.

Most likely this code is still broken/racy (Al Viro also thinks so),
but removing the BKL should not make it worse than before.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 drivers/usb/core/inode.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/core/inode.c b/drivers/usb/core/inode.c
index 1a27618..095fa53 100644
--- a/drivers/usb/core/inode.c
+++ b/drivers/usb/core/inode.c
@@ -265,13 +265,9 @@ static int remount(struct super_block *sb, int *flags, char *data)
 		return -EINVAL;
 	}
 
-	lock_kernel();
-
 	if (usbfs_mount && usbfs_mount->mnt_sb)
 		update_sb(usbfs_mount->mnt_sb);
 
-	unlock_kernel();
-
 	return 0;
 }
 
-- 
1.7.0.4

