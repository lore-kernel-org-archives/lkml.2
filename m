Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758919Ab0DAUml (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 16:42:41 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:57918 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755358Ab0DAUmh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 16:42:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=Jdx/pqoSvPaxhOrFOU3y6T23FYjlZY8llY0Gz7qOrSrna1MArJiKkEy2cSJK3QeJ6q
         s1ksNwR6pws5arG+cgwjBOApk7KIeyoTvJmN+uRzvYV6RJ3ZpvhwmNx+tPwRPF5nI2lp
         fecK6LkgrTxiMJ+OJ7Sbj/laPdnzFqJ/dV91M=
From: Matt Reimer <mreimer@sdgsystems.com>
To: linux-kernel@vger.kernel.org
Cc: Matt Reimer <mreimer@sdgsystems.com>
Subject: [PATCH] USB: pxa27x_udc: use four bits to store endpoint addresses
Date: Thu,  1 Apr 2010 13:42:12 -0700
Message-Id: <1270154532-12980-1-git-send-email-mreimer@sdgsystems.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Endpoint addresses on pxa27x can be programmed as 1-15, but since
only three bits were being used to store the endpoint number it
was possible to overflow.

Signed-off-by: Matt Reimer <mreimer@sdgsystems.com>
---
 drivers/usb/gadget/pxa27x_udc.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/gadget/pxa27x_udc.h b/drivers/usb/gadget/pxa27x_udc.h
index ff61e48..cd16231 100644
--- a/drivers/usb/gadget/pxa27x_udc.h
+++ b/drivers/usb/gadget/pxa27x_udc.h
@@ -360,7 +360,7 @@ struct pxa_ep {
 	 * Specific pxa endpoint data, needed for hardware initialization
 	 */
 	unsigned		dir_in:1;
-	unsigned		addr:3;
+	unsigned		addr:4;
 	unsigned		config:2;
 	unsigned		interface:3;
 	unsigned		alternate:3;
-- 
1.6.3.3

