Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759846Ab0JHVqn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 17:46:43 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:42655 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759826Ab0JHVqm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 17:46:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=YGkCIdE0YY4FkCMXjXEJ/bvK7iVJUE6pmcbF0ATF8BSsRBWW5MIxjI8pWUiFe2APuC
         O/krNK/q3cFvmkV/WTiZbyhc371DoJ8c/X3aUxOQPA9QEp9puE4tXevWi4jUMMR781Nu
         YL3isJL0pC+d6b2EOQi/4XnRqEoHP7RoXN3VM=
From: Tracey Dent <tdent48227@gmail.com>
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org, Tracey Dent <tdent48227@gmail.com>
Subject: [PATCH] Staging: speakup: serialio: Fixed errors in file
Date: Fri,  8 Oct 2010 17:46:37 -0400
Message-Id: <1286574397-1369-1-git-send-email-tdent48227@gmail.com>
X-Mailer: git-send-email 1.7.3.1.104.gc752e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On line 40 printk() needed an KERN_* facility level, so I gave it
INFO. Also, fixed a C99 comment error.

Signed-off-by: Tracey Dent <tdent48227@gmail.com>
---
 drivers/staging/speakup/serialio.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/speakup/serialio.c b/drivers/staging/speakup/serialio.c
index f64eb36..bafd62f 100644
--- a/drivers/staging/speakup/serialio.c
+++ b/drivers/staging/speakup/serialio.c
@@ -37,7 +37,7 @@ struct serial_state *spk_serial_init(int index)
 		cval |= UART_LCR_EPAR;
 	if (synth_request_region(ser->port, 8)) {
 		/* try to take it back. */
-		printk("Ports not available, trying to steal them\n");
+		printk(KERN_INFO "Ports not available, trying to steal them\n");
 		__release_region(&ioport_resource, ser->port, 8);
 		err = synth_request_region(ser->port, 8);
 		if (err) {
@@ -155,7 +155,7 @@ int wait_for_xmitr(void)
 	while (!((inb_p(speakup_info.port_tts + UART_MSR)) & UART_MSR_CTS)) {
 		/* CTS */
 		if (--tmout == 0) {
-			// pr_warn("%s: timed out (cts)\n", synth->long_name);
+			/* pr_warn("%s: timed out (cts)\n", synth->long_name); */
 			timeouts++;
 			return 0;
 		}
-- 
1.7.3.1.104.gc752e

