Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757267Ab1AMRgl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 12:36:41 -0500
Received: from hapkido.dreamhost.com ([66.33.216.122]:40336 "EHLO
	hapkido.dreamhost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756571Ab1AMRgj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 12:36:39 -0500
Subject: [PATCH] input: ct82710c: return proper error code for ct82c710_open
From: Davidlohr Bueso <dave@gnu.org>
To: Dmitry Torokhov <dtor@mail.ru>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 13 Jan 2011 14:35:50 -0300
Message-ID: <1294940150.2200.4.camel@offworld>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Davidlohr Bueso <dave@gnu.org>

If request_irq() fails we should return the proper error instead of -1.

Signed-off-by: Davidlohr Bueso <dave@gnu.org>
---
 drivers/input/serio/ct82c710.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/input/serio/ct82c710.c b/drivers/input/serio/ct82c710.c
index 448c772..ee0edd0 100644
--- a/drivers/input/serio/ct82c710.c
+++ b/drivers/input/serio/ct82c710.c
@@ -111,9 +111,11 @@ static void ct82c710_close(struct serio *serio)
 static int ct82c710_open(struct serio *serio)
 {
 	unsigned char status;
+	int err = 0;
 
-	if (request_irq(CT82C710_IRQ, ct82c710_interrupt, 0, "ct82c710", NULL))
-		return -1;
+	err = request_irq(CT82C710_IRQ, ct82c710_interrupt, 0, "ct82c710", NULL);
+	if (err)
+		goto out;
 
 	status = inb_p(CT82C710_STATUS);
 
@@ -133,8 +135,8 @@ static int ct82c710_open(struct serio *serio)
 		free_irq(CT82C710_IRQ, NULL);
 		return -1;
 	}
-
-	return 0;
+out:
+	return err;
 }
 
 /*
-- 
1.7.1



