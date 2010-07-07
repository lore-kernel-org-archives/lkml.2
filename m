Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757886Ab0GGVmA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jul 2010 17:42:00 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:61123 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757798Ab0GGVkv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jul 2010 17:40:51 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: John Kacur <jkacur@redhat.com>, Frederic Weisbecker <fweisbec@gmail.com>,
       Arnd Bergmann <arnd@arndb.de>, Christoph Hellwig <hch@lst.de>
Subject: [PATCH 15/18] viotape: use noop_llseek
Date: Wed,  7 Jul 2010 23:40:17 +0200
Message-Id: <1278538820-1392-16-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1278538820-1392-1-git-send-email-arnd@arndb.de>
References: <1278538820-1392-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:fnyBTf5CxGorDkqfnQH5nPgqRh5EvDKqiQOjwGyiagb
 LGkyxMboanSGxBVaI+L6JFU1OWKTWrFN1rub3D4p4RUWGSTuqJ
 Y68hLrsdbxmNKO5hsekt5L8mzJuxGJauTndo5Km5oLySbwSdhB
 jxn7o2UJcjdvQJypXTT7jLFLY9rLnETZ2dmXrm3veWsgBoQAQE
 zYqjy99cbznP6Ze9kVSpA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some applications try to seek on tape devices
and fail if they return an error. Since we
want to change the default llseek action to
no_llseek, viotape needs to be changed to use
noop_llseek explicitly.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/char/viotape.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/char/viotape.c b/drivers/char/viotape.c
index 42f7fa4..442c3f5 100644
--- a/drivers/char/viotape.c
+++ b/drivers/char/viotape.c
@@ -804,6 +804,7 @@ const struct file_operations viotap_fops = {
 	.unlocked_ioctl =	viotap_unlocked_ioctl,
 	.open =			viotap_open,
 	.release =		viotap_release,
+	.llseek = 		noop_llseek,
 };
 
 /* Handle interrupt events for tape */
-- 
1.7.1

