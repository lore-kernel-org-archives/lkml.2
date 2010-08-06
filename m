Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965592Ab0HFTuy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 15:50:54 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:64519 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935050Ab0HFTus (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 15:50:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=ifb95Gvmq/BpDB6RDuGPIh9BbWgi5nCJFRP6vgXl2tsLjuNf+/7lzXPpRDofEkshKO
         yYtwhOOdY0nNHP+nspeVPrnQ9mFoOZ6ohH00aIONocHTbJzbcC1P1DdS8IILwZoGfdC7
         ebK49KM57zmtTwPSsTDo8eFvS4j4MNPK5GPA0=
From: Kulikov Vasiliy <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
        Stephen Hemminger <shemminger@vyatta.com>, Jiri Slaby <jslaby@suse.cz>,
        "David S. Miller" <davem@davemloft.net>, Arnd Bergmann <arnd@arndb.de>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 05/18] char: synclink: call disable_pci_device() if pci_probe() failed
Date: Fri,  6 Aug 2010 23:50:39 +0400
Message-Id: <1281124241-13198-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Driver should call disable_pci_device() if it returns from pci_probe()
with error.

Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
---
 drivers/char/synclink.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/char/synclink.c b/drivers/char/synclink.c
index a2a5800..14e45c5 100644
--- a/drivers/char/synclink.c
+++ b/drivers/char/synclink.c
@@ -8079,6 +8079,7 @@ static int __devinit synclink_init_one (struct pci_dev *dev,
 
 	if (!(info = mgsl_allocate_device())) {
 		printk("can't allocate device instance data.\n");
+		pci_disable_device(dev);
 		return -EIO;
 	}
 
-- 
1.7.0.4

