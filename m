Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761139Ab2BJXfN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 18:35:13 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:27168 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760496Ab2BJXeT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 18:34:19 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Ram Pai <linuxram@us.ibm.com>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 6/7] PCI: print out suggestion about using pci=realloc
Date: Fri, 10 Feb 2012 15:33:51 -0800
Message-Id: <1328916832-6588-7-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1328916832-6588-1-git-send-email-yinghai@kernel.org>
References: <1328916832-6588-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-CT-RefId: str=0001.0A090201.4F35A975.006B,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

let user know they could try if pci=realloc could help.

-v2: update suggestion text.

Suggested-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/pci/setup-bus.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
index 22454c5..c73244a 100644
--- a/drivers/pci/setup-bus.c
+++ b/drivers/pci/setup-bus.c
@@ -1346,6 +1346,9 @@ again:
 		goto enable_and_dump;
 
 	if (tried_times >= pci_try_num) {
+		if (pci_realloc_enable == enable_not_set)
+			printk(KERN_INFO "Some PCI device resources are unassigned, try booting with pci=realloc\n");
+
 		free_list(&fail_head);
 		goto enable_and_dump;
 	}
-- 
1.7.7

