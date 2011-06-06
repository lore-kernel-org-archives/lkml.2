Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756969Ab1FFR7A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 13:59:00 -0400
Received: from mga14.intel.com ([143.182.124.37]:9373 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751655Ab1FFR66 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 13:58:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,327,1304319600"; 
   d="scan'208";a="7962477"
From: "Luck, Tony" <tony.luck@intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: LKML <linux-kernel@vger.kernel.org>, Len Brown <lenb@kernel.org>,
        Greg KH <gregkh@suse.de>, Kay Sievers <kay.sievers@suse.de>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        Dave Jones <davej@redhat.com>, Alan Stern <stern@rowland.harvard.edu>,
        Avi Kivity <avi@redhat.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Date: Mon, 6 Jun 2011 10:58:53 -0700
Subject: RE: [PATCH 5/8] PCI / Intel IOMMU: Use syscore_ops instead of
 sysdev class and sysdev
Thread-Topic: [PATCH 5/8] PCI / Intel IOMMU: Use syscore_ops instead of
 sysdev class and sysdev
Thread-Index: Acwkcya55zrZyxgGRmGbxB9FEwMzPwAACWIw
Message-ID: <987664A83D2D224EAE907B061CE93D5301E700ED2B@orsmsx505.amr.corp.intel.com>
References: <201103100131.58206.rjw@sisk.pl>
 <201103122218.14832.rjw@sisk.pl>
 <BANLkTi=xhg7_0O-aVC8s1Uyo4Wkz5OTCdg@mail.gmail.com>
 <201106061957.35413.rjw@sisk.pl>
In-Reply-To: <201106061957.35413.rjw@sisk.pl>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I guess you mean the following?

Rafael

Exactly.

Thanks

-Tony

---
From: Rafael J. Wysocki <rjw@sisk.pl>

If CONFIG_PM is not set, init_iommu_pm_ops() introduced by commit
134fac3f457f3dd753ecdb25e6da3e5f6629f696 (PCI / Intel IOMMU: Use
syscore_ops instead of sysdev class and sysdev) is not defined
appropriately.  Fix this issue.

Reported-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/pci/intel-iommu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/drivers/pci/intel-iommu.c
===================================================================
--- linux-2.6.orig/drivers/pci/intel-iommu.c
+++ linux-2.6/drivers/pci/intel-iommu.c
@@ -3388,7 +3388,7 @@ static void __init init_iommu_pm_ops(voi
 }
 
 #else
-static inline int init_iommu_pm_ops(void) { }
+static inline void init_iommu_pm_ops(void) {}
 #endif	/* CONFIG_PM */
 
 /*
