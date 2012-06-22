Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933234Ab2FVVMW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 17:12:22 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:44612 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S933210Ab2FVVMU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 17:12:20 -0400
Date: Fri, 22 Jun 2012 17:12:19 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Greg KH <greg@kroah.com>
cc: Kay Sievers <kay@vrfy.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: [PATCH] printk: fix regression in SYSLOG_ACTION_CLEAR
Message-ID: <Pine.LNX.4.44L0.1206221710030.1184-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 7ff9554bb578ba02166071d2d487b7fc7d860d62 (printk: convert
byte-buffer to variable-length record buffer) introduced a regression
by accidentally removing a "break" statement from inside the big
switch in printk's do_syslog().  The symptom of this bug is that the
"dmesg -C" command doesn't only clear the kernel's log buffer; it also
disables console logging.

This patch (as1561) fixes the regression by adding the missing
"break".

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
CC: Kay Sievers <kay@vrfy.org>

---

This is needed in 3.5-rc.  3.4 is okay.


 kernel/printk.c |    1 +
 1 file changed, 1 insertion(+)

Index: usb-3.4/kernel/printk.c
===================================================================
--- usb-3.4.orig/kernel/printk.c
+++ usb-3.4/kernel/printk.c
@@ -1027,6 +1027,7 @@ int do_syslog(int type, char __user *buf
 	/* Clear ring buffer */
 	case SYSLOG_ACTION_CLEAR:
 		syslog_print_all(NULL, 0, true);
+		break;
 	/* Disable logging to console */
 	case SYSLOG_ACTION_CONSOLE_OFF:
 		if (saved_console_loglevel == -1)

