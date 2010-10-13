Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754127Ab0JMM0F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 08:26:05 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:50298 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754094Ab0JMM0D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 08:26:03 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Wed, 13 Oct 2010 14:25:44 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] firewire: nosy: char device is not seekable
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Message-ID: <tkrat.42de7ec9907e63aa@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Amend .open handler accordingly and add .llseek = no_llseek handler.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
Arnd, is your mega-patch which adds legions of .llseek handlers done and
to be merged soon as-is, or do you regenerate it regularly?  (linux-next
commit 9711569d "llseek: automatically add .llseek fop")

 drivers/firewire/nosy.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: b/drivers/firewire/nosy.c
===================================================================
--- a/drivers/firewire/nosy.c
+++ b/drivers/firewire/nosy.c
@@ -302,7 +302,7 @@ nosy_open(struct inode *inode, struct fi
 
 	file->private_data = client;
 
-	return 0;
+	return nonseekable_open(inode, file);
 fail:
 	kfree(client);
 	lynx_put(lynx);
@@ -400,6 +400,7 @@ nosy_ioctl(struct file *file, unsigned i
 
 static const struct file_operations nosy_ops = {
 	.owner =		THIS_MODULE,
+	.llseek =		no_llseek,
 	.read =			nosy_read,
 	.unlocked_ioctl =	nosy_ioctl,
 	.poll =			nosy_poll,

-- 
Stefan Richter
-=====-==-=- =-=- -==-=
http://arcgraph.de/sr/

