Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757139Ab2BQBAs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 20:00:48 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:46781 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757104Ab2BQBAo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 20:00:44 -0500
X-Sasl-enc: WVg7k5kwgHfQovOI6pMxjqJgjsHBe24IAujDLhn4ifMd 1329440442
X-Mailbox-Line: From gregkh@linuxfoundation.org Thu Feb 16 16:55:37 2012
Message-Id: <20120217005537.739931194@linuxfoundation.org>
User-Agent: quilt/0.51-15.1
Date: Thu, 16 Feb 2012 16:56:02 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [28/28] xen pvhvm: do not remap pirqs onto evtchns if !xen_have_vector_callback
In-Reply-To: <20120217005609.GA17081@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>

commit 207d543f472c1ac9552df79838dc807cbcaa9740 upstream.

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/pci/xen.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/pci/xen.c
+++ b/arch/x86/pci/xen.c
@@ -374,7 +374,7 @@ int __init pci_xen_init(void)
 
 int __init pci_xen_hvm_init(void)
 {
-	if (!xen_feature(XENFEAT_hvm_pirqs))
+	if (!xen_have_vector_callback || !xen_feature(XENFEAT_hvm_pirqs))
 		return 0;
 
 #ifdef CONFIG_ACPI


