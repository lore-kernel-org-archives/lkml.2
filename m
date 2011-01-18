Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751530Ab1ARNEV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 08:04:21 -0500
Received: from mail.sysgo.com ([195.145.229.155]:43958 "EHLO mail.sysgo.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751021Ab1ARNEU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 08:04:20 -0500
Message-ID: <4D358E31.4080700@sysgo.com>
Date: Tue, 18 Jan 2011 13:57:21 +0100
From: David Engraf <david.engraf@sysgo.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] serio: allow registered drivers to get status flag
Content-Type: multipart/mixed;
 boundary="------------070306030407000808000604"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070306030407000808000604
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

Parse the status byte information to the registered serio drivers as 
well as the character bytes.

Signed-off-by: David Engraf <david.engraf@sysgo.com>


--------------070306030407000808000604
Content-Type: text/x-diff;
 name="serport_parse_flags.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="serport_parse_flags.diff"

--- linux-2.6.37/drivers/input/serio/serport.c.orig	2011-01-18 12:33:41.421709232 +0100
+++ linux-2.6.37/drivers/input/serio/serport.c	2011-01-18 13:33:24.521711214 +0100
@@ -116,8 +116,8 @@ static void serport_ldisc_close(struct t
 
 /*
  * serport_ldisc_receive() is called by the low level tty driver when characters
- * are ready for us. We forward the characters, one by one to the 'interrupt'
- * routine.
+ * are ready for us. We forward the characters and flags, one by one to the 
+ * 'interrupt' routine.
  */
 
 static void serport_ldisc_receive(struct tty_struct *tty, const unsigned char *cp, char *fp, int count)
@@ -132,7 +132,7 @@ static void serport_ldisc_receive(struct
 		goto out;
 
 	for (i = 0; i < count; i++)
-		serio_interrupt(serport->serio, cp[i], 0);
+		serio_interrupt(serport->serio, cp[i], fp[i]);
 
 out:
 	spin_unlock_irqrestore(&serport->lock, flags);

--------------070306030407000808000604--
