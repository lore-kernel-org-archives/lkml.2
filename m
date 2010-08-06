Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965074Ab0HFSms (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 14:42:48 -0400
Received: from kroah.org ([198.145.64.141]:48603 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761792Ab0HFSfc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 14:35:32 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Aug  6 11:32:01 2010
Message-Id: <20100806183201.041244111@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 06 Aug 2010 11:30:32 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Bruce Allan <bruce.w.allan@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [11/38] e1000e: 82577/82578 PHY register access issues
In-Reply-To: <20100806183250.GA23019@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Bruce Allan <bruce.w.allan@intel.com>

commit ff847ac2d3e90edd94674c28bade25ae1e6a2e49 upstream.

The MAC-PHY interconnect on 82577/82578 uses a power management feature
(called K1) which must be disabled when in 1Gbps due to a hardware issue on
these parts.  The #define bit setting used to enable/disable K1 is
incorrect and can cause PHY register accesses to stop working altogether
until the next device reset.  This patch sets the register correctly.

This issue is present in kernels since 2.6.32.

Signed-off-by: Bruce Allan <bruce.w.allan@intel.com>
Tested-by: Jeff Pieper <jeffrey.e.pieper@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/e1000e/hw.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/e1000e/hw.h
+++ b/drivers/net/e1000e/hw.h
@@ -308,7 +308,7 @@ enum e1e_registers {
 #define E1000_KMRNCTRLSTA_INBAND_PARAM	0x9    /* Kumeran InBand Parameters */
 #define E1000_KMRNCTRLSTA_DIAG_NELPBK	0x1000 /* Nearend Loopback mode */
 #define E1000_KMRNCTRLSTA_K1_CONFIG	0x7
-#define E1000_KMRNCTRLSTA_K1_ENABLE	0x140E
+#define E1000_KMRNCTRLSTA_K1_ENABLE	0x0002
 #define E1000_KMRNCTRLSTA_K1_DISABLE	0x1400
 
 #define IFE_PHY_EXTENDED_STATUS_CONTROL	0x10


