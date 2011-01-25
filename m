Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753893Ab1AYR7w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 12:59:52 -0500
Received: from mail3.caviumnetworks.com ([12.108.191.235]:11955 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753846Ab1AYR7r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 12:59:47 -0500
From: David Daney <ddaney@caviumnetworks.com>
To: linux-usb@vger.kernel.org, gregkh@suse.de, dbrownell@users.sourceforge.net
Cc: linux-kernel@vger.kernel.org, David Daney <ddaney@caviumnetworks.com>
Subject: [PATCH 2/4] USB: EHCI: Cleanup and rewrite ehci_vdgb().
Date: Tue, 25 Jan 2011 09:59:35 -0800
Message-Id: <1295978377-22930-2-git-send-email-ddaney@caviumnetworks.com>
X-Mailer: git-send-email 1.7.2.3
X-OriginalArrivalTime: 25 Jan 2011 17:59:47.0165 (UTC) FILETIME=[A74798D0:01CBBCB9]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The vdbg macro is not used anywhere so it can be removed.

With pre-release GCC-4.6, there are several complaints of variables
that are 'set but not used' caused by the ehci_vdbg() macro expanding
to something that does not contain any of its arguments.  We can quiet
this warning by rewriting ehci_vdbg() as a variadic static inline that
does nothing.

Signed-off-by: David Daney <ddaney@caviumnetworks.com>
---
 drivers/usb/host/ehci-dbg.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/host/ehci-dbg.c b/drivers/usb/host/ehci-dbg.c
index 3be238a..693c29b 100644
--- a/drivers/usb/host/ehci-dbg.c
+++ b/drivers/usb/host/ehci-dbg.c
@@ -28,11 +28,9 @@
 	dev_warn (ehci_to_hcd(ehci)->self.controller , fmt , ## args )
 
 #ifdef VERBOSE_DEBUG
-#	define vdbg dbg
 #	define ehci_vdbg ehci_dbg
 #else
-#	define vdbg(fmt,args...) do { } while (0)
-#	define ehci_vdbg(ehci, fmt, args...) do { } while (0)
+	static inline void ehci_vdbg(struct ehci_hcd *ehci, ...) {}
 #endif
 
 #ifdef	DEBUG
-- 
1.7.2.3

