Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933661Ab2HWHvg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 03:51:36 -0400
Received: from mga09.intel.com ([134.134.136.24]:16167 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932176Ab2HWHve convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 03:51:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,299,1344236400"; 
   d="scan'208,223";a="184404905"
Date: Thu, 23 Aug 2012 15:45:47 +0800
From: Feng Tang <feng.tang@intel.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Fengguang Wu <fengguang.wu@intel.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>, Avi Kivity <avi@redhat.com>,
        Steven Rostedt <srostedt@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Yinghai Lu <yinghai@kernel.org>, <linux-pci@vger.kernel.org>,
        akpm@linux-foundation.org, gregkh@linuxfoundation.org
Subject: [PATCH 2/2] PCI: Remove the obsolete no_pci_devices() check
Message-ID: <20120823154547.40d07cd0@feng-i7>
In-Reply-To: <CAErSpo7HhdDi4EhbQZ-oZbsbGVvTfZW8MwKn7Tm+6B8jaQxLBg@mail.gmail.com>
References: <5017D19B.5080806@redhat.com>
	<1343738627.27983.30.camel@gandalf.stny.rr.com>
	<5017D4AB.3090107@redhat.com>
	<1343740419.27983.33.camel@gandalf.stny.rr.com>
	<20120731234336.GA5526@localhost>
	<1343778699.27983.70.camel@gandalf.stny.rr.com>
	<20120731235705.GW2422@linux.vnet.ibm.com>
	<1343779778.27983.73.camel@gandalf.stny.rr.com>
	<20120801001811.GX2422@linux.vnet.ibm.com>
	<20120801004319.GA7043@localhost>
	<20120822025008.GA8066@localhost>
	<20120822154908.2e6ef3c0@feng-i7>
	<CAErSpo7HhdDi4EhbQZ-oZbsbGVvTfZW8MwKn7Tm+6B8jaQxLBg@mail.gmail.com>
Organization: intel
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 9f2f3bbdf65f669e091c72b9648a4a0394ce28f5 Mon Sep 17 00:00:00 2001
From: Feng Tang <feng.tang@intel.com>
Date: Thu, 23 Aug 2012 14:55:48 +0800
Subject: [PATCH 2/2] PCI: Remove the obsolete no_pci_devices() check

In function pci_get_subsys() there is a check:

	/*
	 * pci_find_subsys() can be called on the ide_setup() path,
	 * super-early in boot.  But the down_read() will enable local
	 * interrupts, which can cause some machines to crash.  So here we
	 * detect and flag that situation and bail out early.
	 */
	if (unlikely(no_pci_devices()))
		return NULL;

But there is no ide_setup() now, and no down_read() either, which
makes the check absolete. So remove it.

Signed-off-by: Feng Tang <feng.tang@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/search.c |    9 ---------
 1 files changed, 0 insertions(+), 9 deletions(-)

diff --git a/drivers/pci/search.c b/drivers/pci/search.c
index 78a08b1..e6e604f 100644
--- a/drivers/pci/search.c
+++ b/drivers/pci/search.c
@@ -247,15 +247,6 @@ struct pci_dev *pci_get_subsys(unsigned int vendor, unsigned int device,
 {
 	struct pci_device_id id;
 
-	/*
-	 * pci_find_subsys() can be called on the ide_setup() path,
-	 * super-early in boot.  But the down_read() will enable local
-	 * interrupts, which can cause some machines to crash.  So here we
-	 * detect and flag that situation and bail out early.
-	 */
-	if (unlikely(no_pci_devices()))
-		return NULL;
-
 	id.vendor = vendor;
 	id.device = device;
 	id.subvendor = ss_vendor;
-- 
1.7.1
