Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754533Ab1G0J6E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 05:58:04 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:48341 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754138Ab1G0J6A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 05:58:00 -0400
Date: Wed, 27 Jul 2011 12:55:57 +0300
From: Dan Carpenter <error27@gmail.com>
To: dagenaisj@sonatest.com
Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
        Andrew Morton <akpm@linux-foundation.org>,
        open list <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
Subject: [patch] w1: off by one in w1_f29_remove_slave()
Message-ID: <20110727095557.GL3824@shale.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reads past the end of the w1_f29_sysfs_bin_files[] array.  I
don't have this hardware, but I assume it crashes every time the
function is called.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/w1/slaves/w1_ds2408.c b/drivers/w1/slaves/w1_ds2408.c
index c377818..0da4e97 100644
--- a/drivers/w1/slaves/w1_ds2408.c
+++ b/drivers/w1/slaves/w1_ds2408.c
@@ -373,7 +373,7 @@ static int w1_f29_add_slave(struct w1_slave *sl)
 static void w1_f29_remove_slave(struct w1_slave *sl)
 {
 	int i;
-	for (i = NB_SYSFS_BIN_FILES; i <= 0; --i)
+	for (i = NB_SYSFS_BIN_FILES - 1; i <= 0; --i)
 		sysfs_remove_bin_file(&sl->dev.kobj,
 			&(w1_f29_sysfs_bin_files[i]));
 }
