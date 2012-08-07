Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757540Ab2HGXVv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 19:21:51 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:64363 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030392Ab2HGWcn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 18:32:43 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Colin Ian King <colin.king@canonical.com>,
        Jason Wessel <jason.wessel@windriver.com>
Subject: [ 109/122] USB: echi-dbgp: increase the controller wait time to come out of halt.
Date: Tue,  7 Aug 2012 15:26:37 -0700
Message-Id: <20120807221959.688040696@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120807221948.220495155@linuxfoundation.org>
References: <20120807221948.220495155@linuxfoundation.org>
User-Agent: quilt/0.60-20.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Colin Ian King <colin.king@canonical.com>

commit f96a4216e85050c0a9d41a41ecb0ae9d8e39b509 upstream.

The default 10 microsecond delay for the controller to come out of
halt in dbgp_ehci_startup is too short, so increase it to 1 millisecond.

This is based on emperical testing on various USB debug ports on
modern machines such as a Lenovo X220i and an Ivybridge development
platform that needed to wait ~450-950 microseconds.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/early/ehci-dbgp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/early/ehci-dbgp.c
+++ b/drivers/usb/early/ehci-dbgp.c
@@ -450,7 +450,7 @@ static int dbgp_ehci_startup(void)
 	writel(FLAG_CF, &ehci_regs->configured_flag);
 
 	/* Wait until the controller is no longer halted */
-	loop = 10;
+	loop = 1000;
 	do {
 		status = readl(&ehci_regs->status);
 		if (!(status & STS_HALT))


