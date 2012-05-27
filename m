Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422740Ab2E0BRr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2012 21:17:47 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:36809 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422729Ab2E0BRi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2012 21:17:38 -0400
Message-Id: <20120527002517.287643178@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Sun, 27 May 2012 09:25:54 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [ 48/91] USB: ehci-platform: remove update_device
In-Reply-To: <20120527010903.GA18244@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hauke Mehrtens <hauke@hauke-m.de>

commit 8377c94f627f7943da9a7eefdb21fd2e9e7ec629 upstream.

The update_device callback is not needed and the function used here is
from the pci ehci driver. Without this patch we get a compile error if
ehci-platform is compiled without ehci-pci.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/host/ehci-platform.c |    2 --
 1 file changed, 2 deletions(-)

--- a/drivers/usb/host/ehci-platform.c
+++ b/drivers/usb/host/ehci-platform.c
@@ -75,8 +75,6 @@ static const struct hc_driver ehci_platf
 	.relinquish_port	= ehci_relinquish_port,
 	.port_handed_over	= ehci_port_handed_over,
 
-	.update_device		= ehci_update_device,
-
 	.clear_tt_buffer_complete = ehci_clear_tt_buffer_complete,
 };
 


