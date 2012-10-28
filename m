Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757362Ab2J1XfO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 19:35:14 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:42150 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756928Ab2J1X2M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 19:28:12 -0400
Message-Id: <20121028231550.351774066@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 28 Oct 2012 23:16:19 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [ 043/105] xen/bootup: allow read_tscp call for Xen PV guests.
In-Reply-To: <20121028231536.970033833@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

commit cd0608e71e9757f4dae35bcfb4e88f4d1a03a8ab upstream.

The hypervisor will trap it. However without this patch,
we would crash as the .read_tscp is set to NULL. This patch
fixes it and sets it to the native_read_tscp call.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/x86/xen/enlighten.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index 70f1404..668bbfe 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -1164,6 +1164,8 @@ static const struct pv_cpu_ops xen_cpu_ops __initconst = {
 	.read_tsc = native_read_tsc,
 	.read_pmc = native_read_pmc,
 
+	.read_tscp = native_read_tscp,
+
 	.iret = xen_iret,
 	.irq_enable_sysexit = xen_sysexit,
 #ifdef CONFIG_X86_64


