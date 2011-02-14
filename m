Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751719Ab1BNU2M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 15:28:12 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:27930 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750843Ab1BNU2I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 15:28:08 -0500
Date: Mon, 14 Feb 2011 12:27:50 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, netdev <netdev@vger.kernel.org>,
        linux-pci@vger.kernel.org
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        davem@davemloft.net, Jesse Barnes <jbarnes@virtuousgeek.org>,
        Sakari Ailus <sakari.ailus@iki.fi>
Subject: [PATCH -next] PCI: fix tlan build when CONFIG_PCI is not enabled
Message-Id: <20110214122750.e1e03bc8.randy.dunlap@oracle.com>
In-Reply-To: <20110214181137.ee8d4c08.sfr@canb.auug.org.au>
References: <20110214181137.ee8d4c08.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4D59904A.00D9:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

When CONFIG_PCI is not enabled, tlan.c has a build error:
drivers/net/tlan.c:503: error: implicit declaration of function 'pci_wake_from_d3'

so add an inline function stub for this function to pci.h when
PCI is not enabled, similar to other stubbed PCI functions.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Sakari Ailus <sakari.ailus@iki.fi>
---
 include/linux/pci.h |    5 +++++
 1 file changed, 5 insertions(+)

--- linux-next-20110214.orig/include/linux/pci.h
+++ linux-next-20110214/include/linux/pci.h
@@ -1191,6 +1191,11 @@ static inline int pci_set_power_state(st
 	return 0;
 }
 
+static inline int pci_wake_from_d3(struct pci_dev *dev, bool enable)
+{
+	return 0;
+}
+
 static inline pci_power_t pci_choose_state(struct pci_dev *dev,
 					   pm_message_t state)
 {
