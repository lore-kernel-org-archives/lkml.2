Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751704Ab0DJOR5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Apr 2010 10:17:57 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:60986 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751403Ab0DJORx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Apr 2010 10:17:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=f07AgS5t86YnVoh4RWZ6f+bFuH1yQnIWacIZme/RgqOxJKYBFQScj/o7h1oQhAzVLX
         nQbp8GN4HgUPvGBXbUmB8JDrEhOymErK9L1Mdz3ooEH7aPHb2HlUlQAUfv+gnABomwv6
         5+RktkYtstrAl67fNPQfHgdSeUGhAK53i0yqg=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>,
       Matt Mackall <mpm@selenic.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH] random: Forbid llseek on random chardev
Date: Sat, 10 Apr 2010 16:17:44 +0200
Message-Id: <1270909064-7845-1-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

Seeking on /dev/random and /dev/urandom is pointless.
Using generic_file_llseek means we no longer need to
take the BKL if anyone tries to seek on these.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Matt Mackall <mpm@selenic.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 drivers/char/random.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 2fd3d39..513c685 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -1169,6 +1169,7 @@ const struct file_operations random_fops = {
 	.poll  = random_poll,
 	.unlocked_ioctl = random_ioctl,
 	.fasync = random_fasync,
+	.open = nonseekable_open,
 };
 
 const struct file_operations urandom_fops = {
@@ -1176,6 +1177,7 @@ const struct file_operations urandom_fops = {
 	.write = random_write,
 	.unlocked_ioctl = random_ioctl,
 	.fasync = random_fasync,
+	.open = nonseekable_open,
 };
 
 /***************************************************************
-- 
1.6.2.3

