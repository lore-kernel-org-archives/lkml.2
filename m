Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757707Ab2JDVRE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 17:17:04 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:44231 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757670Ab2JDVRA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 17:17:00 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Alan Stern <stern@rowland.harvard.edu>
Subject: [ 06/56] USB: EHCI: convert warning messages to debug-level
Date: Thu,  4 Oct 2012 14:15:27 -0700
Message-Id: <20121004211152.826968041@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.2.421.g261b511
In-Reply-To: <20121004211152.101901246@linuxfoundation.org>
References: <20121004211152.101901246@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alan Stern <stern@rowland.harvard.edu>

commit d16ba48774913d244c7eb894d28d8ae2c019a827 upstream.

This patch (as1606) converts two warning messages in the ehci-hcd
driver to debug messages, and adds a little extra information to each.

The log messages occur when an EHCI controller takes too long (more
than 20 ms) to turn its async or periodic schedule on or off.  If this
happens at all, it's liable to happen quite often and there's no point
spamming the system log with these warnings.  Furthermore, there's
nothing much we can do about it when the problem happens.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Reported-and-tested-by: Thomas Voegtle <tv@lio96.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/host/ehci-timer.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/usb/host/ehci-timer.c
+++ b/drivers/usb/host/ehci-timer.c
@@ -118,7 +118,8 @@ static void ehci_poll_ASS(struct ehci_hc
 			ehci_enable_event(ehci, EHCI_HRTIMER_POLL_ASS, true);
 			return;
 		}
-		ehci_warn(ehci, "Waited too long for the async schedule status, giving up\n");
+		ehci_dbg(ehci, "Waited too long for the async schedule status (%x/%x), giving up\n",
+				want, actual);
 	}
 	ehci->ASS_poll_count = 0;
 
@@ -163,7 +164,8 @@ static void ehci_poll_PSS(struct ehci_hc
 			ehci_enable_event(ehci, EHCI_HRTIMER_POLL_PSS, true);
 			return;
 		}
-		ehci_warn(ehci, "Waited too long for the periodic schedule status, giving up\n");
+		ehci_dbg(ehci, "Waited too long for the periodic schedule status (%x/%x), giving up\n",
+				want, actual);
 	}
 	ehci->PSS_poll_count = 0;
 


