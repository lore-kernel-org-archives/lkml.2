Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757301Ab0DBMGH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 08:06:07 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:59635 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756756Ab0DBMF6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 08:05:58 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Fri, 2 Apr 2010 14:05:47 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 2/3] firewire: ohci: replace empty macros by empty inline
 functions
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
In-Reply-To: <tkrat.4957c3a08e7013b1@s5r6.in-berlin.de>
Message-ID: <tkrat.32dda143dc8ebd6c@s5r6.in-berlin.de>
References: <tkrat.4957c3a08e7013b1@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

so that call parameter type checking is available in #ifndef'd builds.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/ohci.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

Index: b/drivers/firewire/ohci.c
===================================================================
--- a/drivers/firewire/ohci.c
+++ b/drivers/firewire/ohci.c
@@ -438,9 +438,9 @@ static void log_ar_at_event(char dir, in
 
 #else
 
-#define log_irqs(evt)
-#define log_selfids(node_id, generation, self_id_count, sid)
-#define log_ar_at_event(dir, speed, header, evt)
+static inline void log_irqs(u32 evt) {}
+static inline void log_selfids(int node_id, int generation, int self_id_count, u32 *s) {}
+static inline void log_ar_at_event(char dir, int speed, u32 *header, int evt) {}
 
 #endif /* CONFIG_FIREWIRE_OHCI_DEBUG */
 
@@ -2323,8 +2323,8 @@ static void pmac_ohci_off(struct pci_dev
 	}
 }
 #else
-#define pmac_ohci_on(dev)
-#define pmac_ohci_off(dev)
+static inline void pmac_ohci_on(struct pci_dev *dev) {}
+static inline void pmac_ohci_off(struct pci_dev *dev) {}
 #endif /* CONFIG_PPC_PMAC */
 
 static int __devinit pci_probe(struct pci_dev *dev,

-- 
Stefan Richter
-=====-==-=- -=-- ---=-
http://arcgraph.de/sr/

