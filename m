Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755660Ab0JNROk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 13:14:40 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:46278 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755566Ab0JNROi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 13:14:38 -0400
Date: Thu, 14 Oct 2010 10:13:13 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, Daniel Drake <dsd@laptop.org>,
        akpm <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        x86@kernel.org
Subject: [PATCH -next] x86: olpc-xo1 uses/depends on PCI
Message-Id: <20101014101313.adf7eb2a.randy.dunlap@oracle.com>
In-Reply-To: <20101014152642.ef280a33.sfr@canb.auug.org.au>
References: <20101014152642.ef280a33.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

olpc-xo1 uses pci_*() interfaces so it should depend on PCI.

arch/x86/kernel/olpc-xo1.c:65: error: implicit declaration of function 'pci_enable_device_io'
arch/x86/kernel/olpc-xo1.c:71: error: implicit declaration of function 'pci_request_region'
arch/x86/kernel/olpc-xo1.c:80: error: implicit declaration of function 'pci_release_region'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Daniel Drake <dsd@laptop.org>
---
 arch/x86/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20101014.orig/arch/x86/Kconfig
+++ linux-next-20101014/arch/x86/Kconfig
@@ -2018,7 +2018,7 @@ config OLPC
 
 config OLPC_XO1
 	tristate "OLPC XO-1 support"
-	depends on OLPC
+	depends on OLPC && PCI
 	---help---
 	  Add support for non-essential features of the OLPC XO-1 laptop.
 
