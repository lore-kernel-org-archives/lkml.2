Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757010Ab0JDSRL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 14:17:11 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:31420 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756422Ab0JDSN5 (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Mon, 4 Oct 2010 14:13:57 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Alex Nixon <alex.nixon@citrix.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 01/22] xen: Don't disable the I/O space
Date: Mon,  4 Oct 2010 14:13:14 -0400
Message-Id: <1286216015-9710-2-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1286216015-9710-1-git-send-email-konrad.wilk@oracle.com>
References: <1286216015-9710-1-git-send-email-konrad.wilk@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alex Nixon <alex.nixon@citrix.com>

If a guest domain wants to access PCI devices through the frontend
driver (coming later in the patch series), it will need access to the
I/O space.

[ Impact: Allow for domU IO access, preparing for pci passthrough ]

Signed-off-by: Alex Nixon <alex.nixon@citrix.com>
Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/xen/setup.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/arch/x86/xen/setup.c b/arch/x86/xen/setup.c
index 328b003..c413132 100644
--- a/arch/x86/xen/setup.c
+++ b/arch/x86/xen/setup.c
@@ -260,7 +260,5 @@ void __init xen_arch_setup(void)
 
 	pm_idle = xen_idle;
 
-	paravirt_disable_iospace();
-
 	fiddle_vdso();
 }
-- 
1.7.0.4

