Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753361Ab2A3OaR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 09:30:17 -0500
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:2002 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753167Ab2A3OaP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 09:30:15 -0500
X-IronPort-AV: E=Sophos;i="4.71,592,1320624000"; 
   d="scan'208";a="10367633"
Date: Mon, 30 Jan 2012 14:31:46 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: <xen-devel@lists.xensource.com>
CC: <linux-kernel@vger.kernel.org>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH] xen pvhvm: do not remap pirqs onto evtchns if
 !xen_have_vector_callback
Message-ID: <alpine.DEB.2.00.1201301429530.3196@kaball-desktop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>

diff --git a/arch/x86/pci/xen.c b/arch/x86/pci/xen.c
index 492ade8..d99346e 100644
--- a/arch/x86/pci/xen.c
+++ b/arch/x86/pci/xen.c
@@ -374,7 +374,7 @@ int __init pci_xen_init(void)
 
 int __init pci_xen_hvm_init(void)
 {
-	if (!xen_feature(XENFEAT_hvm_pirqs))
+	if (!xen_have_vector_callback || !xen_feature(XENFEAT_hvm_pirqs))
 		return 0;
 
 #ifdef CONFIG_ACPI
