Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754600Ab0ISMzE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Sep 2010 08:55:04 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:58608 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754408Ab0ISMy7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Sep 2010 08:54:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=XErPkUTBBkuj3vg01BSofBvbNaIOWLAwe3iWXfobCh2AZRcHOTNgnTOKEg5gAhkfII
         RdyCXwujaBJXqnxLvzS0h4f2QuQuNBHiJI/NkDF7RVmMIdYhYUyo0kWlPJ9r+aIK4J+5
         uYXU8VJWLC/hBHs1UTTYEPwoIrU6KjY0iDvUg=
From: Vasiliy Kulikov <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: Dominik Brodowski <linux@dominikbrodowski.net>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, linux-pcmcia@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 06/14] pcmcia: cs: fix device_register() error handling
Date: Sun, 19 Sep 2010 16:54:55 +0400
Message-Id: <1284900895-24453-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If device_register() fails then call put_device().
See comment to device_register.

Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>
---
 compile tested.

 drivers/pcmcia/cs.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/pcmcia/cs.c b/drivers/pcmcia/cs.c
index d8189d4..9e8ab51 100644
--- a/drivers/pcmcia/cs.c
+++ b/drivers/pcmcia/cs.c
@@ -592,6 +592,7 @@ static int pccardd(void *__skt)
 	if (ret) {
 		dev_printk(KERN_WARNING, &skt->dev,
 			   "PCMCIA: unable to register socket\n");
+		put_device(&skt->dev);
 		skt->thread = NULL;
 		complete(&skt->thread_done);
 		return 0;
-- 
1.7.0.4

