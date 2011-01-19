Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753250Ab1ASV2Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 16:28:25 -0500
Received: from mail.ispras.ru ([83.149.199.43]:56859 "EHLO mail.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752892Ab1ASV2Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 16:28:24 -0500
X-Greylist: delayed 1062 seconds by postgrey-1.27 at vger.kernel.org; Wed, 19 Jan 2011 16:28:24 EST
Message-ID: <40908.91.79.118.36.1295471624.squirrel@mail.ispras.ru>
Date: Thu, 20 Jan 2011 00:13:44 +0300 (MSK)
Subject: [PATCH] pohmelfs/dir.c: Remove unneeded mutex_unlock() from 
     pohmelfs_rename()
From: "Alexey Khoroshilov" <khoroshilov@ispras.ru>
To: "Evgeniy Polyakov" <zbr@ioremap.net>
Cc: "Greg Kroah-Hartman" <gregkh@suse.de>, "Tejun Heo" <tj@kernel.org>,
        "Ruslan Pisarev" <ruslan@rpisarev.org.ua>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Reply-To: khoroshilov@ispras.ru
User-Agent: SquirrelMail/1.4.8-5.el5_3.7
MIME-Version: 1.0
Content-Type: text/plain;charset=utf-8
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I do not see any reason for the mutex_unlock(&inode->i_mutex); in
pohmelfs_rename().


Found by Linux Driver Verification project (linuxtesting.org).


Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
diff --git a/drivers/staging/pohmelfs/dir.c b/drivers/staging/pohmelfs/dir.c
index 059e9d2..9732a96 100644
--- a/drivers/staging/pohmelfs/dir.c
+++ b/drivers/staging/pohmelfs/dir.c
@@ -1082,7 +1082,6 @@ err_out_exit:

        clear_bit(NETFS_INODE_REMOTE_SYNCED, &pi->state);

-       mutex_unlock(&inode->i_mutex);
        return err;
 }

