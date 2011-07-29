Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754792Ab1G2GJu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 02:09:50 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:47960 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753847Ab1G2GJt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 02:09:49 -0400
Date: Fri, 29 Jul 2011 16:09:43 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build warnings after merge of the moduleh tree
Message-Id: <20110729160943.c77bc737188b0cf9dace922a@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta1 (GTK+ 2.24.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

After merging the moduleh tree, today's linux-next build (powerpc
ppc64_defconfig) produced these warnings:

drivers/of/of_pci_irq.c:92:1: warning: data definition has no type or storage class
drivers/of/of_pci_irq.c:92:1: warning: type defaults to 'int' in declaration of 'EXPORT_SYMBOL_GPL'
drivers/of/of_pci_irq.c:92:1: warning: parameter names (without types) in function declaration

This is an interaction with commit 98d9f30c820d ("pci/of: Match PCI
devices to OF nodes dynamically") which split off part of
drivers/of/of_pci.c.

I have added this patch for today:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Fri, 29 Jul 2011 16:05:38 +1000
Subject: [PATCH] pci/of: include export.h for EXPORT_SYMBOL_GPL

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/of/of_pci_irq.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/of/of_pci_irq.c b/drivers/of/of_pci_irq.c
index ac1ec54..9312516 100644
--- a/drivers/of/of_pci_irq.c
+++ b/drivers/of/of_pci_irq.c
@@ -1,6 +1,7 @@
 #include <linux/kernel.h>
 #include <linux/of_pci.h>
 #include <linux/of_irq.h>
+#include <linux/export.h>
 #include <asm/prom.h>
 
 /**
-- 
1.7.5.4

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
