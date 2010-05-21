Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934266Ab0EURCa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 13:02:30 -0400
Received: from kroah.org ([198.145.64.141]:39078 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934139Ab0EUQyN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 12:54:13 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 04/38] Driver core: Reduce the level of request_firmware() messages
Date: Fri, 21 May 2010 09:53:34 -0700
Message-Id: <1274460848-11377-4-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.0.3
In-Reply-To: <20100521165106.GA11216@kroah.com>
References: <20100521165106.GA11216@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

The messages from _request_firmware() informing that firmware is
being requested or built-in firmware is going to be used are printed
at KERN_INFO, which produces lots of noise on systems with huge
numbers of AMD CPUs.  Reduce the level of these messages to
KERN_DEBUG to get rid of that noise.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/firmware_class.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index 4c70b91..8e6c62b 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -507,15 +507,14 @@ _request_firmware(const struct firmware **firmware_p, const char *name,
 	     builtin++) {
 		if (strcmp(name, builtin->name))
 			continue;
-		dev_info(device, "firmware: using built-in firmware %s\n",
-			 name);
+		dev_dbg(device, "firmware: using built-in firmware %s\n", name);
 		firmware->size = builtin->size;
 		firmware->data = builtin->data;
 		return 0;
 	}
 
 	if (uevent)
-		dev_info(device, "firmware: requesting %s\n", name);
+		dev_dbg(device, "firmware: requesting %s\n", name);
 
 	retval = fw_setup_device(firmware, &f_dev, name, device, uevent);
 	if (retval)
-- 
1.7.0.3

