Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754528Ab1KTAgd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Nov 2011 19:36:33 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:54137 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752075Ab1KTAgc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Nov 2011 19:36:32 -0500
From: "Ken O'Brien" <kernel@kenobrien.org>
To: d@teklibre.com, gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        "Ken O'Brien" <kernel@kenobrien.org>
Subject: [PATCH] Staging: frontier: Removed use of obsolete function
Date: Sun, 20 Nov 2011 00:36:11 +0000
Message-Id: <1321749371-7143-1-git-send-email-kernel@kenobrien.org>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replaced one reference to strict_strtoul() to kstrtoul().

Signed-off-by: Ken O'Brien <kernel@kenobrien.org>
---
 drivers/staging/frontier/tranzport.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/frontier/tranzport.c b/drivers/staging/frontier/tranzport.c
index 8894ab1..0e7b4d6 100644
--- a/drivers/staging/frontier/tranzport.c
+++ b/drivers/staging/frontier/tranzport.c
@@ -199,7 +199,7 @@ static void usb_tranzport_abort_transfers(struct usb_tranzport *dev)
 		struct usb_interface *intf = to_usb_interface(dev);	\
 		struct usb_tranzport *t = usb_get_intfdata(intf);	\
 		unsigned long temp;	\
-		if (strict_strtoul(buf, 10, &temp))	\
+		if (kstrtoul(buf, 10, &temp))	\
 			return -EINVAL;	\
 		t->value = temp;	\
 		return count;	\
-- 
1.7.5.4

