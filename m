Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755512Ab2BXDYs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 22:24:48 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:49519 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754362Ab2BXDYD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 22:24:03 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Ram Pai <linuxram@us.ibm.com>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 3/4] PCI: print out suggestion about using pci=realloc
Date: Thu, 23 Feb 2012 19:23:31 -0800
Message-Id: <1330053812-10316-4-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1330053812-10316-1-git-send-email-yinghai@kernel.org>
References: <1330053812-10316-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090208.4F4702CB.00CC,ss=1,re=0.000,fgs=0
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
index 219722d..e21e1c2 100644
--- a/drivers/pci/setup-bus.c
+++ b/drivers/pci/setup-bus.c
@@ -1347,6 +1347,9 @@ again:
 		goto enable_and_dump;
 
 	if (tried_times >= pci_try_num) {
+		if (pci_realloc_enable == undefined)
+			printk(KERN_INFO "Some PCI device resources are unassigned, try booting with pci=realloc\n");
+
 		free_list(&fail_head);
 		goto enable_and_dump;
 	}
-- 
1.7.7

