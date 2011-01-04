Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751355Ab1ADEzU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 23:55:20 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:41984 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751099Ab1ADEzT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 23:55:19 -0500
Date: Tue, 4 Jan 2011 15:55:13 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mac Lin <mkl0301@gmail.com>, Anton Vorontsov <cbouatmailru@gmail.com>,
        Russell King <rmk@arm.linux.org.uk>,
        Deepak Sikri <deepak.sikri@st.com>, Viresh Kumar <viresh.kumar@st.com>,
        Pavankumar Kondeti <pkondeti@codeaurora.org>
Subject: linux-next: manual merge of the usb tree with the arm tree
Message-Id: <20110104155513.e8c36240.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

Today's linux-next merge of the usb tree got a conflict in
drivers/usb/Kconfig between commit
760efe6910d5743084b586d3d0a3b65aea96fb2f ("USB: cns3xxx: Add EHCI and
OHCI bus glue for cns3xxx SOCs") from the arm tree and commits
c8c38de9d8002578599222296b90696745ac0fe3 ("USB host: Adding USB ehci &
ohci support for spear platform") and
b0848aea10da186372582f33152efdda43944f26 ("USB: EHCI: Add MSM Host
Controller driver") from the usb tree.

I fixed it up (see below) and can carry the fix as necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/usb/Kconfig
index 5a7c8f1,b8e70a9..0000000
--- a/drivers/usb/Kconfig
+++ b/drivers/usb/Kconfig
@@@ -41,7 -41,7 +41,8 @@@ config USB_ARCH_HAS_OHC
  	default y if MFD_TC6393XB
  	default y if ARCH_W90X900
  	default y if ARCH_DAVINCI_DA8XX
 +	default y if ARCH_CNS3XXX
+ 	default y if PLAT_SPEAR
  	# PPC:
  	default y if STB03xxx
  	default y if PPC_MPC52xx
@@@ -67,7 -62,9 +63,10 @@@ config USB_ARCH_HAS_EHC
  	default y if ARCH_AT91SAM9G45
  	default y if ARCH_MXC
  	default y if ARCH_OMAP3
 +	default y if ARCH_CNS3XXX
+ 	default y if ARCH_VT8500
+ 	default y if PLAT_SPEAR
+ 	default y if ARCH_MSM
  	default PCI
  
  # ARM SA1111 chips have a non-PCI based "OHCI-compatible" USB host interface.
