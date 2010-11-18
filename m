Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760290Ab0KRUdG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 15:33:06 -0500
Received: from xenotime.net ([72.52.115.56]:51041 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1760247Ab0KRUdD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 15:33:03 -0500
Date: Thu, 18 Nov 2010 12:27:34 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
To: linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org
Cc: Bernhard Walle <walle@corscience.de>
Subject: [PATCH 3/7] Documentation/gpio.txt: explain poll/select usage
Message-ID: <12901120543034@xenotime.net>
In-Reply-To: <12901120542939@xenotime.net>
X-Mailer: gregkh_patchbomb
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bernhard Walle <walle@corscience.de>

Add a bit more information how to use poll(2) on GPIO value files
correctly. For me it was not clear that I need to poll(2) for
POLLPRI|POLLERR or select(2) for exceptfds.

Signed-off-by: Bernhard Walle <walle@corscience.de>
Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 Documentation/gpio.txt |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- linux-2.6.37-rc2-git4.orig/Documentation/gpio.txt
+++ linux-2.6.37-rc2-git4/Documentation/gpio.txt
@@ -617,6 +617,16 @@ and have the following read/write attrib
 		is configured as an output, this value may be written;
 		any nonzero value is treated as high.
 
+		If the pin can be configured as interrupt-generating interrupt
+		and if it has been configured to generate interrupts (see the
+		description of "edge"), you can poll(2) on that file and
+		poll(2) will return whenever the interrupt was triggered. If
+		you use poll(2), set the events POLLPRI and POLLERR. If you
+		use select(2), set the file descriptor in exceptfds. After
+		poll(2) returns, either lseek(2) to the beginning of the sysfs
+		file and read the new value or close the file and re-open it
+		to read the value.
+
 	"edge" ... reads as either "none", "rising", "falling", or
 		"both". Write these strings to select the signal edge(s)
 		that will make poll(2) on the "value" file return.


-- 

