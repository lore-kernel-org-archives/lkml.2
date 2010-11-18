Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759533Ab0KRQMg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 11:12:36 -0500
Received: from gate.lvk.cs.msu.su ([158.250.17.1]:36020 "EHLO
	mail.lvk.cs.msu.su" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754176Ab0KRQMd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 11:12:33 -0500
X-Greylist: delayed 500 seconds by postgrey-1.27 at vger.kernel.org; Thu, 18 Nov 2010 11:12:32 EST
X-Spam-ASN: 
From: Alexander Gordeev <lasaine@lvk.cs.msu.su>
To: linux-kernel@vger.kernel.org
Cc: "Nikita V\. Youshchenko" <yoush@cs.msu.su>, linuxpps@ml.enneenne.com,
        Rodolfo Giometti <giometti@enneenne.com>,
        Alexander Gordeev <lasaine@lvk.cs.msu.su>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rodolfo Giometti <giometti@linux.it>, Tilman Schmidt <tilman@imap.cc>,
        linux-doc@vger.kernel.org
Subject: [PATCHv4 12/17] pps: timestamp is always passed to dcd_change()
Date: Thu, 18 Nov 2010 19:01:05 +0300
Message-Id: <74f895fecc315f781a97b12d7feba3d6c4053195.1290087480.git.lasaine@lvk.cs.msu.su>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <cover.1290087473.git.lasaine@lvk.cs.msu.su>
References: <cover.1290087473.git.lasaine@lvk.cs.msu.su>
X-AV-Checked: ClamAV using ClamSMTP
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the code that gatheres timestamp in pps_tty_dcd_change() in case
passed ts parameter is NULL because it never happens in the current
code. Fix comments as well.

Signed-off-by: Alexander Gordeev <lasaine@lvk.cs.msu.su>
---
 Documentation/serial/tty.txt    |    2 +-
 drivers/pps/clients/pps-ldisc.c |    8 --------
 include/linux/tty_ldisc.h       |    2 +-
 3 files changed, 2 insertions(+), 10 deletions(-)

diff --git a/Documentation/serial/tty.txt b/Documentation/serial/tty.txt
index 7c90050..540db41 100644
--- a/Documentation/serial/tty.txt
+++ b/Documentation/serial/tty.txt
@@ -107,7 +107,7 @@ write_wakeup()	-	May be called at any point between open and close.
 
 dcd_change()	-	Report to the tty line the current DCD pin status
 			changes and the relative timestamp. The timestamp
-			can be NULL.
+			cannot be NULL.
 
 
 Driver Access
diff --git a/drivers/pps/clients/pps-ldisc.c b/drivers/pps/clients/pps-ldisc.c
index 7006f85..57130a5 100644
--- a/drivers/pps/clients/pps-ldisc.c
+++ b/drivers/pps/clients/pps-ldisc.c
@@ -35,16 +35,8 @@ static void pps_tty_dcd_change(struct tty_struct *tty, unsigned int status,
 				struct pps_event_time *ts)
 {
 	struct pps_device *pps;
-	struct pps_event_time __ts;
 	unsigned long flags;
 
-	/* First of all we get the time stamp... */
-	pps_get_ts(&__ts);
-
-	/* Does caller give us a timestamp? */
-	if (!ts)	/* No. Do it ourself! */
-		ts = &__ts;
-
 	spin_lock_irqsave(&pps_ldisc_lock, flags);
 
 	/* Now do the PPS event report */
diff --git a/include/linux/tty_ldisc.h b/include/linux/tty_ldisc.h
index 763e061..ff7dc08 100644
--- a/include/linux/tty_ldisc.h
+++ b/include/linux/tty_ldisc.h
@@ -104,7 +104,7 @@
  *			struct pps_event_time *ts)
  *
  *	Tells the discipline that the DCD pin has changed its status and
- *	the relative timestamp. Pointer ts can be NULL.
+ *	the relative timestamp. Pointer ts cannot be NULL.
  */
 
 #include <linux/fs.h>
-- 
1.7.2.3

