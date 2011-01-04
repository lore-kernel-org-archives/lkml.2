Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751423Ab1ADE6q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 23:58:46 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:44676 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751099Ab1ADE6o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 23:58:44 -0500
Date: Tue, 4 Jan 2011 15:58:43 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mac Lin <mkl0301@gmail.com>, Anton Vorontsov <cbouatmailru@gmail.com>,
        Russell King <rmk@arm.linux.org.uk>
Subject: linux-next: manual merge of the usb tree with the arm tree
Message-Id: <20110104155843.f65f0bcd.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

Today's linux-next merge of the usb tree got a conflict in
drivers/usb/host/ehci-hcd.c between commit
760efe6910d5743084b586d3d0a3b65aea96fb2f ("USB: cns3xxx: Add EHCI and
OHCI bus glue for cns3xxx SOCs") from the arm tree and various commits
from the usb tree.

I fixed it up (see below) and can carry the fix as necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/usb/host/ehci-hcd.c
index d0c8f7c,72732da..0000000
--- a/drivers/usb/host/ehci-hcd.c
+++ b/drivers/usb/host/ehci-hcd.c
@@@ -1216,9 -1229,19 +1229,23 @@@ MODULE_LICENSE ("GPL")
  #define PLATFORM_DRIVER		ehci_octeon_driver
  #endif
  
 +#ifdef CONFIG_USB_CNS3XXX_EHCI
 +#include "ehci-cns3xxx.c"
 +#define PLATFORM_DRIVER		cns3xxx_ehci_driver
++
+ #ifdef CONFIG_ARCH_VT8500
+ #include "ehci-vt8500.c"
+ #define	PLATFORM_DRIVER		vt8500_ehci_driver
+ #endif
+ 
+ #ifdef CONFIG_PLAT_SPEAR
+ #include "ehci-spear.c"
+ #define PLATFORM_DRIVER		spear_ehci_hcd_driver
+ #endif
+ 
+ #ifdef CONFIG_USB_EHCI_MSM
+ #include "ehci-msm.c"
+ #define PLATFORM_DRIVER		ehci_msm_driver
  #endif
  
  #if !defined(PCI_DRIVER) && !defined(PLATFORM_DRIVER) && \
