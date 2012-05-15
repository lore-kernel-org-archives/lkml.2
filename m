Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965698Ab2EOCbd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 22:31:33 -0400
Received: from mail.windriver.com ([147.11.1.11]:49855 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965471Ab2EOCSI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 22:18:08 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [34-longterm 158/179] USB: usb-storage: unusual_devs entry for ARM V2M motherboard.
Date: Mon, 14 May 2012 22:14:14 -0400
Message-ID: <1337048075-6132-159-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.6
In-Reply-To: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
References: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nick Bowler <nbowler@elliptictech.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit a871e4f5519d8c52430052e1d340dd5710eb5ad6 upstream.

Connecting the V2M to a Linux host results in a constant stream of
errors spammed to the console, all of the form

  sd 1:0:0:0: ioctl_internal_command return code = 8070000
     : Sense Key : 0x4 [current]
     : ASC=0x0 ASCQ=0x0

The errors appear to be otherwise harmless.  Add an unusual_devs entry
which eliminates all of the error messages.

Signed-off-by: Nick Bowler <nbowler@elliptictech.com>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
[PG: 2.6.34 uses US_ prefix, not USB_ prefix, change accordingly]
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/usb/storage/unusual_devs.h |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/usb/storage/unusual_devs.h b/drivers/usb/storage/unusual_devs.h
index a33e2ba..ee5a8ba 100644
--- a/drivers/usb/storage/unusual_devs.h
+++ b/drivers/usb/storage/unusual_devs.h
@@ -1972,6 +1972,16 @@ UNUSUAL_DEV(  0x4146, 0xba01, 0x0100, 0x0100,
 		"Micro Mini 1GB",
 		US_SC_DEVICE, US_PR_DEVICE, NULL, US_FL_NOT_LOCKABLE ),
 
+/*
+ * Nick Bowler <nbowler@elliptictech.com>
+ * SCSI stack spams (otherwise harmless) error messages.
+ */
+UNUSUAL_DEV(  0xc251, 0x4003, 0x0100, 0x0100,
+		"Keil Software, Inc.",
+		"V2M MotherBoard",
+		US_SC_DEVICE, US_PR_DEVICE, NULL,
+		US_FL_NOT_LOCKABLE),
+
 /* Reported by Andrew Simmons <andrew.simmons@gmail.com> */
 UNUSUAL_DEV(  0xed06, 0x4500, 0x0001, 0x0001,
 		"DataStor",
-- 
1.7.9.6

