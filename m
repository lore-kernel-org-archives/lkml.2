Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965075Ab2JSDY7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 23:24:59 -0400
Received: from mail.kernel.org ([198.145.19.201]:54397 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758021Ab2JSDRT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 23:17:19 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [ 11/37] xen/bootup: allow read_tscp call for Xen PV guests.
Date: Thu, 18 Oct 2012 20:16:34 -0700
Message-Id: <20121019031304.675393314@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121019031302.789593147@linuxfoundation.org>
References: <20121019031302.789593147@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

commit cd0608e71e9757f4dae35bcfb4e88f4d1a03a8ab upstream.

The hypervisor will trap it. However without this patch,
we would crash as the .read_tscp is set to NULL. This patch
fixes it and sets it to the native_read_tscp call.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/xen/enlighten.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -989,6 +989,8 @@ static const struct pv_cpu_ops xen_cpu_o
 	.read_tsc = native_read_tsc,
 	.read_pmc = native_read_pmc,
 
+	.read_tscp = native_read_tscp,
+
 	.iret = xen_iret,
 	.irq_enable_sysexit = xen_sysexit,
 #ifdef CONFIG_X86_64


