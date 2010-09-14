Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755386Ab0INUZz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 16:25:55 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:64828 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755260Ab0INUXT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 16:23:19 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 07/15] raw: use explicit llseek file operations
Date: Tue, 14 Sep 2010 22:22:35 +0200
Message-Id: <1284495763-7506-8-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1284495763-7506-1-git-send-email-arnd@arndb.de>
References: <1284495763-7506-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:J9UWLvU4HjqoAu8MqKBEubCX//zJI8NZsWiI4Kw03Es
 vLUvsx25KPlggDYSkJpR0DFPUz/2+PKcUy1RTlHtRrfhAZ34uD
 RseQbNcyiKiP43Lgf0vXHzxybHkI34SzAeEhx4NewR/4D4GERC
 xIDEMbpERGzaxdV1AYM6WVbz4dfslncpkXVhad64AeyDbmub3R
 U77WpXWdyXmFsfJM5CKZA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The raw_fops may need to seek, so there should
be an explicit reference to default_llseek.
raw_ctl_fops does not contain a read or write
method, so we use noop_llseek to ignore seeking
requests without an error.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/char/raw.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/char/raw.c b/drivers/char/raw.c
index b38942f..28c0169 100644
--- a/drivers/char/raw.c
+++ b/drivers/char/raw.c
@@ -258,6 +258,7 @@ static const struct file_operations raw_fops = {
 	.open		= raw_open,
 	.release	= raw_release,
 	.unlocked_ioctl = raw_ioctl,
+	.llseek		= default_llseek,
 	.owner		= THIS_MODULE,
 };
 
@@ -265,6 +266,7 @@ static const struct file_operations raw_ctl_fops = {
 	.unlocked_ioctl = raw_ctl_ioctl,
 	.open		= raw_open,
 	.owner		= THIS_MODULE,
+	.llseek		= noop_llseek,
 };
 
 static struct cdev raw_cdev;
-- 
1.7.1

