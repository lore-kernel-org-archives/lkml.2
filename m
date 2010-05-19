Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756137Ab0ESUlP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 16:41:15 -0400
Received: from mail-in-05.arcor-online.net ([151.189.21.45]:33318 "EHLO
	mail-in-05.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752978Ab0ESUlN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 16:41:13 -0400
X-DKIM: Sendmail DKIM Filter v2.8.2 mail-in-17.arcor-online.net 0CFA5CC2A4
Subject: [PATCH] HID: Removed unused variable from hidraw_read
From: Stefan Achatz <erazor_de@users.sourceforge.net>
Reply-To: erazor_de@users.sourceforge.net
To: Jiri Kosina <jkosina@suse.cz>,
       Stefan Achatz <erazor_de@users.sourceforge.net>,
       iceberg <iceberg@ispras.ru>, Alexey Dobriyan <adobriyan@gmail.com>,
       Tejun Heo <tj@kernel.org>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 19 May 2010 22:41:10 +0200
Message-ID: <1274301670.22226.4.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed unused variable from hidraw_read.

Signed-off-by: Stefan Achatz <erazor_de@users.sourceforge.net>
---
 drivers/hid/hidraw.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/hid/hidraw.c b/drivers/hid/hidraw.c
index 6eadf1a..bfe1e26 100644
--- a/drivers/hid/hidraw.c
+++ b/drivers/hid/hidraw.c
@@ -46,7 +46,6 @@ static ssize_t hidraw_read(struct file *file, char __user *buffer, size_t count,
 {
 	struct hidraw_list *list = file->private_data;
 	int ret = 0, len;
-	char *report;
 	DECLARE_WAITQUEUE(wait, current);
 
 	mutex_lock(&list->read_mutex);
@@ -84,7 +83,6 @@ static ssize_t hidraw_read(struct file *file, char __user *buffer, size_t count,
 		if (ret)
 			goto out;
 
-		report = list->buffer[list->tail].value;
 		len = list->buffer[list->tail].len > count ?
 			count : list->buffer[list->tail].len;
 
-- 
1.6.6.1



