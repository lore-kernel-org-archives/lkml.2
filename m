Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753605Ab0IJMmV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 08:42:21 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:39571 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753524Ab0IJMmT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 08:42:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:content-type:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=sdMNTavgme0SRhEzA5MNUTagZs45CQKCztiXDqfCm0YnaOtgqmowKa3BaRKbPyYPNe
         t1TiWDSnnVBgGfQeIioWgkNXlTbTMVaOKNzvKQGJ9XvTqGFvEpUWBVpfdHjCiPux2spT
         fyHyCgEvUe8jp5xZWQWmN/y32AhyEpDo0nmP4=
Subject: [PATCH] USB: r8a66597-udc: Initialize uninitialized variable, fix
 compile warning
From: Javier Martinez Canillas <martinez.javier@gmail.com>
To: David Brownell <dbrownell@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@suse.de>, Paul Mundt <lethal@linux-sh.org>,
        Magnus Damm <damm@opensource.se>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 10 Sep 2010 08:42:08 -0400
Message-ID: <1284122528.6726.4.camel@lenovo>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In today linux-next I got a compile warning due a possible uninitialized variable

This patch solves the issue initializing the variable

Thanks a lot

Signed-off-by: Javier Martinez Canillas <martinez.javier@gmail.com>
---
 drivers/usb/gadget/r8a66597-udc.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/gadget/r8a66597-udc.h b/drivers/usb/gadget/r8a66597-udc.h
index f763b51..5fc22e0 100644
--- a/drivers/usb/gadget/r8a66597-udc.h
+++ b/drivers/usb/gadget/r8a66597-udc.h
@@ -136,7 +136,7 @@ static inline void r8a66597_read_fifo(struct r8a66597 *r8a66597,
 				      int len)
 {
 	void __iomem *fifoaddr = r8a66597->reg + offset;
-	unsigned int data;
+	unsigned int data = 0;
 	int i;
 
 	if (r8a66597->pdata->on_chip) {
-- 
1.7.0.4



