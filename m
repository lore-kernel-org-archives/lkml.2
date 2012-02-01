Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933278Ab2BAWo4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 17:44:56 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:48709 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933187Ab2BAWow (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 17:44:52 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Tony Luck <tony.luck@intel.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>,
        Kyle McMartin <kyle@mcmartin.ca>, Helge Deller <deller@gmx.de>,
        linux-parisc@vger.kernel.org
Subject: [PATCH 08/15] PCI, parisc: Register busn_res for root buses
Date: Wed,  1 Feb 2012 14:43:55 -0800
Message-Id: <1328136242-17725-9-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1328136242-17725-1-git-send-email-yinghai@kernel.org>
References: <1328136242-17725-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090205.4F29C04D.0051,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Kyle McMartin <kyle@mcmartin.ca>
Cc: Helge Deller <deller@gmx.de>
Cc: linux-parisc@vger.kernel.org
---
 drivers/parisc/dino.c    |    2 ++
 drivers/parisc/lba_pci.c |    3 +++
 2 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/parisc/dino.c b/drivers/parisc/dino.c
index 7ff10c1..3f2e203 100644
--- a/drivers/parisc/dino.c
+++ b/drivers/parisc/dino.c
@@ -1014,7 +1014,9 @@ static int __init dino_probe(struct parisc_device *dev)
 		return 0;
 	}
 
+	pci_bus_insert_busn_res(bus, dino_current_bus, 255);
 	bus->subordinate = pci_scan_child_bus(bus);
+	pci_bus_update_busn_res_end(bus, bus->subordinate);
 
 	/* This code *depends* on scanning being single threaded
 	 * if it isn't, this global bus number count will fail
diff --git a/drivers/parisc/lba_pci.c b/drivers/parisc/lba_pci.c
index d5f3d75..b58bf8b 100644
--- a/drivers/parisc/lba_pci.c
+++ b/drivers/parisc/lba_pci.c
@@ -1531,6 +1531,9 @@ lba_driver_probe(struct parisc_device *dev)
 		return 0;
 	}
 
+	pci_bus_insert_busn_res(lba_bus, lba_dev->hba.bus_num.start,
+				lba_dev->hba.bus_num.end);
+
 	lba_bus->subordinate = pci_scan_child_bus(lba_bus);
 
 	/* This is in lieu of calling pci_assign_unassigned_resources() */
-- 
1.7.7

