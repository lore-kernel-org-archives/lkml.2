Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752729Ab2GZPz6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 11:55:58 -0400
Received: from smtp.citrix.com ([66.165.176.89]:47806 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752639Ab2GZPzw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 11:55:52 -0400
X-IronPort-AV: E=Sophos;i="4.77,659,1336363200"; 
   d="scan'208";a="32691093"
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
To: <linux-kernel@vger.kernel.org>
CC: <xen-devel@lists.xensource.com>, <Stefano.Stabellini@eu.citrix.com>,
        <konrad.wilk@oracle.com>, <Ian.Campbell@citrix.com>, <tim@xen.org>,
        <linux-arm-kernel@lists.infradead.org>, <linaro-dev@lists.linaro.org>,
        <catalin.marinas@arm.com>, <arnd@arndb.de>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH 23/24] hvc_xen: allow dom0_write_console for HVM guests
Date: Thu, 26 Jul 2012 16:34:05 +0100
Message-ID: <1343316846-25860-23-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <alpine.DEB.2.02.1207251741470.26163@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1207251741470.26163@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On ARM all guests are HVM guests, including Dom0.
Allow dom0_write_console to be called by an HVM domain.

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
---
 drivers/tty/hvc/hvc_xen.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/drivers/tty/hvc/hvc_xen.c b/drivers/tty/hvc/hvc_xen.c
index 3c04fb8..949edc2 100644
--- a/drivers/tty/hvc/hvc_xen.c
+++ b/drivers/tty/hvc/hvc_xen.c
@@ -616,12 +616,9 @@ static void xenboot_write_console(struct console *console, const char *string,
 	unsigned int linelen, off = 0;
 	const char *pos;
 
-	if (!xen_pv_domain())
-		return;
-
 	dom0_write_console(0, string, len);
 
-	if (xen_initial_domain())
+	if (!xen_pv_domain())
 		return;
 
 	domU_write_console(0, "(early) ", 8);
-- 
1.7.2.5

