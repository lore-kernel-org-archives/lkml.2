Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751929Ab0DJO66 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Apr 2010 10:58:58 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:58755 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751749Ab0DJO64 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Apr 2010 10:58:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=hNo2N65jWdV7pewfzlhYcHn1HD2qWHav8y3OSsKylPtLClZpt03dWMQx0JXX8GrL4T
         5ABKZjJ92jMl1SbaL3sDCTikPQJgrOqlSid0KkWg2Alxrk4+AHGwlygkE99xWKK3wlgC
         tJ2yPxqk6i3QmAFIAoefHdDhbRpXninvuB25M=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Alasdair G Kergon <agk@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@relay.de.ibm.com>,
       Arnd Bergmann <arnd@arndb.de>, Alasdair G Kergon <agk@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH] dm: Use nonseekable_open
Date: Sat, 10 Apr 2010 16:58:50 +0200
Message-Id: <1270911530-9455-1-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnd Bergmann <arnd@relay.de.ibm.com>

The dm control device does not implement read/write, so it has
no use for seeking. Using no_llseek prevents falling back to
default_llseek, which requires the BKL.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Alasdair G Kergon <agk@redhat.com>
[drop useless llseek = no_llseek]
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 drivers/md/dm-ioctl.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
index d7500e1..78b28eb 100644
--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -1593,6 +1593,7 @@ static long dm_compat_ctl_ioctl(struct file *file, uint command, ulong u)
 #endif
 
 static const struct file_operations _ctl_fops = {
+	.open = nonseekable_open,
 	.unlocked_ioctl	 = dm_ctl_ioctl,
 	.compat_ioctl = dm_compat_ctl_ioctl,
 	.owner	 = THIS_MODULE,
-- 
1.6.2.3

