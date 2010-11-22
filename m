Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754117Ab0KVK3g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 05:29:36 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:49466 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753606Ab0KVK3f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 05:29:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=gdiSXx9+ZlHSvnYGGnlPc964YfJ03tZOudeZ2agTOzjBsNuRYx16qQ+Wtu1mpi+jEf
         iPFd/BaVGBnMDbSbks8+BhfN2KNLbnk8QXDUbVj12pX0vPYmDDX3w/6FDPAKupqibz07
         U3q3dPmLdsQdfeEnHumtuoDsSRn11ierP3xbg=
From: tomoki.sekiyama@gmail.com
To: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Cc: gregkh@suse.de, arnd@arndb.de, Tomoki Sekiyama <tomoki.sekiyama@gmail.com>
Subject: [PATCH] USB: yurex: add .llseek fop to file_operations
Date: Mon, 22 Nov 2010 19:29:23 +0900
Message-Id: <1290421763-44562-1-git-send-email-tomoki.sekiyama@gmail.com>
X-Mailer: git-send-email 1.7.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tomoki Sekiyama <tomoki.sekiyama@gmail.com>

Default llseek operation behavior was changed by the patch named
"vfs: make no_llseek the default" after the yurex driver had been merged,
so the llseek to yurex is now ignored.

This patch add llseek fop with default_llseek to yurex driver
to catch up to the change.

Signed-off-by: Tomoki Sekiyama <tomoki.sekiyama@gmail.com>

 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/misc/yurex.c b/drivers/usb/misc/yurex.c
index 719c618..ac5bfd6 100644
--- a/drivers/usb/misc/yurex.c
+++ b/drivers/usb/misc/yurex.c
@@ -536,6 +536,7 @@ static const struct file_operations yurex_fops = {
 	.open =		yurex_open,
 	.release =	yurex_release,
 	.fasync	=	yurex_fasync,
+	.llseek =	default_llseek,
 };
 
 
-- 
1.7.0

