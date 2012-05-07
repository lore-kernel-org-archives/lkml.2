Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932365Ab2EGUcL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 16:32:11 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:18580 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932261Ab2EGUaj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 16:30:39 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Tony Luck <tony.luck@intel.com>, David Miller <davem@davemloft.net>,
        x86 <x86@kernel.org>
Cc: Dominik Brodowski <linux@dominikbrodowski.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 20/21] PCI: Register busn_res for iov bus
Date: Mon,  7 May 2012 13:30:05 -0700
Message-Id: <1336422606-4244-21-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1336422606-4244-1-git-send-email-yinghai@kernel.org>
References: <1336422606-4244-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Insert that to tree.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/pci/iov.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/pci/iov.c b/drivers/pci/iov.c
index e873060..74bbaf8 100644
--- a/drivers/pci/iov.c
+++ b/drivers/pci/iov.c
@@ -47,7 +47,7 @@ static struct pci_bus *virtfn_add_bus(struct pci_bus *bus, int busnr)
 	if (!child)
 		return NULL;
 
-	child->busn_res.end = busnr;
+	pci_bus_insert_busn_res(child, busnr, busnr);
 	child->dev.parent = bus->bridge;
 	rc = pci_bus_add_child(child);
 	if (rc) {
-- 
1.7.7

