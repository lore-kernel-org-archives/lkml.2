Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965605Ab2B1CLj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 21:11:39 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:48955 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965490Ab2B1CLb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 21:11:31 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Tony Luck <tony.luck@intel.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>,
        Kyle McMartin <kyle@mcmartin.ca>, Helge Deller <deller@gmx.de>,
        linux-parisc@vger.kernel.org
Subject: [PATCH 09/18] PCI, parisc: Register busn_res for root buses
Date: Mon, 27 Feb 2012 18:10:00 -0800
Message-Id: <1330395009-29260-10-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1330395009-29260-1-git-send-email-yinghai@kernel.org>
References: <1330395009-29260-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4F4C37C3.009C,ss=1,re=0.000,fgs=0
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
index 0610e91..ea3f483 100644
--- a/drivers/parisc/dino.c
+++ b/drivers/parisc/dino.c
@@ -999,7 +999,9 @@ static int __init dino_probe(struct parisc_device *dev)
 		return 0;
 	}
 
+	pci_bus_insert_busn_res(bus, dino_current_bus, 255);
 	bus->subordinate = pci_scan_child_bus(bus);
+	pci_bus_update_busn_res_end(bus, bus->subordinate);
 
 	/* This code *depends* on scanning being single threaded
 	 * if it isn't, this global bus number count will fail
diff --git a/drivers/parisc/lba_pci.c b/drivers/parisc/lba_pci.c
index e885764..84fa239 100644
--- a/drivers/parisc/lba_pci.c
+++ b/drivers/parisc/lba_pci.c
@@ -1512,6 +1512,9 @@ lba_driver_probe(struct parisc_device *dev)
 		return 0;
 	}
 
+	pci_bus_insert_busn_res(lba_bus, lba_dev->hba.bus_num.start,
+				lba_dev->hba.bus_num.end);
+
 	lba_bus->subordinate = pci_scan_child_bus(lba_bus);
 
 	/* This is in lieu of calling pci_assign_unassigned_resources() */
-- 
1.7.7

