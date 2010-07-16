Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966062Ab0GPQPa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 12:15:30 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:56693 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966050Ab0GPQP1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 12:15:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=Rq7i4ypNhauOnQ2+5VS0agpBwiknE8M+xZeXcbA33E2XMnvCoblj4cLotIsEY57Awz
         aUIOgrYKblxJNnOypj5cULZR/YMrwNY/uzTrxX5vn/KqM70mYsEbaEYsTBUv6BsPz3Xl
         8UsWh1739//xZubMINgO/Bnuzty7RZMwLCowI=
From: Kulikov Vasiliy <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Mike Frysinger <vapier@gentoo.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Michael Hennerich <michael.hennerich@analog.com>,
        Bryan Wu <cooloney@kernel.org>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 09/15] usb: host: check kzalloc() result
Date: Fri, 16 Jul 2010 20:15:06 +0400
Message-Id: <1279296906-25107-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If kzalloc() fails exit with -ENOMEM.

Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
---
 drivers/usb/host/sl811-hcd.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/host/sl811-hcd.c b/drivers/usb/host/sl811-hcd.c
index bcf9f0e..990f06b 100644
--- a/drivers/usb/host/sl811-hcd.c
+++ b/drivers/usb/host/sl811-hcd.c
@@ -813,8 +813,11 @@ static int sl811h_urb_enqueue(
 #endif
 
 	/* avoid all allocations within spinlocks */
-	if (!hep->hcpriv)
+	if (!hep->hcpriv) {
 		ep = kzalloc(sizeof *ep, mem_flags);
+		if (ep == NULL)
+			return -ENOMEM;
+	}
 
 	spin_lock_irqsave(&sl811->lock, flags);
 
-- 
1.7.0.4

