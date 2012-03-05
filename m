Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965024Ab2CENzm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 08:55:42 -0500
Received: from mail.pripojeni.net ([178.22.112.14]:34857 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964859Ab2CENx2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 08:53:28 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, jirislaby@gmail.com
Subject: [PATCH 22/68] TTY: serial, include pci.h in m32r_sio
Date: Mon,  5 Mar 2012 14:52:09 +0100
Message-Id: <1330955575-26641-23-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1330955575-26641-1-git-send-email-jslaby@suse.cz>
References: <1330955575-26641-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It uses pointers to pci_dev, but compiler complains it doesn't know
it:
In file included from .../m32r_sio.c:53:
.../m32r_sio.h:21: warning: "struct pci_dev" declared inside parameter list
.../m32r_sio.h:21: warning: its scope is only this definition or declaration, which is probably not what you want
.../m32r_sio.h:22: warning: "struct pci_dev" declared inside parameter list

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/tty/serial/m32r_sio.h |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/tty/serial/m32r_sio.h b/drivers/tty/serial/m32r_sio.h
index e9b7e11..8129824 100644
--- a/drivers/tty/serial/m32r_sio.h
+++ b/drivers/tty/serial/m32r_sio.h
@@ -15,6 +15,7 @@
  * (at your option) any later version.
  */
 
+#include <linux/pci.h>
 
 struct m32r_sio_probe {
 	struct module	*owner;
-- 
1.7.9.2


