Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757350Ab2HGDvd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 23:51:33 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:59722 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757343Ab2HGDic (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 23:38:32 -0400
Message-Id: <20120807032803.636510085@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Tue, 07 Aug 2012 04:28:47 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Colin Ian King <colin.king@canonical.com>,
        Jason Wessel <jason.wessel@windriver.com>
Subject: [ 52/70] USB: echi-dbgp: increase the controller wait time to come out of
 halt.
In-Reply-To: <20120807032755.803571133@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/early/ehci-dbgp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/early/ehci-dbgp.c b/drivers/usb/early/ehci-dbgp.c
index 1fc8f12..347bb05 100644
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


