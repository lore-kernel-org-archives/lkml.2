Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758036Ab0GGVoB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jul 2010 17:44:01 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:52335 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757687Ab0GGVkh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jul 2010 17:40:37 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: John Kacur <jkacur@redhat.com>, Frederic Weisbecker <fweisbec@gmail.com>,
       Arnd Bergmann <arnd@arndb.de>, Christoph Hellwig <hch@lst.de>
Subject: [PATCH 12/18] raw: use explicit llseek file operations
Date: Wed,  7 Jul 2010 23:40:14 +0200
Message-Id: <1278538820-1392-13-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1278538820-1392-1-git-send-email-arnd@arndb.de>
References: <1278538820-1392-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:hRBUP2rDbvNcE0hHvsOktw3QWJsqbwhJAw8Q8ARGkvk
 a34HVbGJue6vlhcOoy6Y8x0VL0z2EApmxT9exZVE8rb7OiwGVl
 WNci5NAiWAXQS4IM/fX/lMBbnh+59qNsLyNXdXYDm+sY5WXFSh
 I1zFNVUQ03hOBoBYm6wc2OtfttDBbUSCy2USyFk4xZFMiEtfnx
 F8WR5/pyOsEaRNJXJMN8A==
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

