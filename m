Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760824Ab0HLTQo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 15:16:44 -0400
Received: from mga01.intel.com ([192.55.52.88]:20635 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754177Ab0HLTQo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 15:16:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,360,1278313200"; 
   d="scan'208";a="595700864"
From: "Luck, Tony" <tony.luck@intel.com>
To: "Greg KH" <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org,
        "Samium Gromoff" <_deepfire@feelingofgreen.ru>,
        "Randy Dunlap" <randy.dunlap@oracle.com>,
        "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>,
        "Andrew Morton" <akpm@linux-foundation.org>
Subject: [PATCH] print early console device address in hex
In-Reply-To: <20100812184653.GA29197@suse.de>
Date: Thu, 12 Aug 2010 12:16:43 -0700
Message-Id: <4c64489b11469c2a9e@agluck-desktop.sc.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Device addresses are usually printed in hex.

Signed-off-by: Tony Luck <tony.luck@intel.com>

---

diff --git a/drivers/serial/8250_early.c b/drivers/serial/8250_early.c
index b745792..eaafb98 100644
--- a/drivers/serial/8250_early.c
+++ b/drivers/serial/8250_early.c
@@ -203,13 +203,13 @@ static int __init parse_options(struct early_serial8250_device *device,
 
 	if (mmio || mmio32)
 		printk(KERN_INFO
-		       "Early serial console at MMIO%s 0x%llu (options '%s')\n",
+		       "Early serial console at MMIO%s 0x%llx (options '%s')\n",
 			mmio32 ? "32" : "",
 			(unsigned long long)port->mapbase,
 			device->options);
 	else
 		printk(KERN_INFO
-		      "Early serial console at I/O port 0x%lu (options '%s')\n",
+		      "Early serial console at I/O port 0x%lx (options '%s')\n",
 			port->iobase,
 			device->options);
 
