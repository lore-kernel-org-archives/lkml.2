Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759043Ab1FXQ3S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jun 2011 12:29:18 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:42752 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751005Ab1FXQ3M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jun 2011 12:29:12 -0400
X-IronPort-AV: E=Sophos;i="4.65,420,1304294400"; 
   d="scan'208";a="6472875"
Date: Fri, 24 Jun 2011 17:33:16 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: <xen-devel@lists.xensource.com>
CC: <linux-kernel@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH] xen-kbdfront: enable xen-kbdfront for HVM guests
Message-ID: <alpine.DEB.2.00.1106241730220.12963@kaball-desktop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

xen-kbdfront: enable xen-kbdfront for HVM guests too

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>

diff --git a/drivers/input/misc/xen-kbdfront.c b/drivers/input/misc/xen-kbdfront.c
index 62bae99..ad2e51c 100644
--- a/drivers/input/misc/xen-kbdfront.c
+++ b/drivers/input/misc/xen-kbdfront.c
@@ -373,7 +373,7 @@ static struct xenbus_driver xenkbd_driver = {
 
 static int __init xenkbd_init(void)
 {
-	if (!xen_pv_domain())
+	if (!xen_domain())
 		return -ENODEV;
 
 	/* Nothing to do if running in dom0. */
