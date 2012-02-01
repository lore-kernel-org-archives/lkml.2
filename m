Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932627Ab2BAWnf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 17:43:35 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:32875 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932133Ab2BAWnb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 17:43:31 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Ram Pai <linuxram@us.ibm.com>,
        "Cc: Dominik Brodowski" <linux@dominikbrodowski.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>, Yinghai Lu <yinghai@kerne.org>
Subject: [PATCH 6/7] PCI: print out suggestion about using pci=realloc
Date: Wed,  1 Feb 2012 14:42:49 -0800
Message-Id: <1328136170-17613-7-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1328136170-17613-1-git-send-email-yinghai@kernel.org>
References: <1328136170-17613-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090202.4F29BFFB.0063,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

let user know they could try if pci=realloc could help.

Suggested-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Yinghai Lu <yinghai@kerne.org>
---
 drivers/pci/setup-bus.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
index 22454c5..9526038 100644
--- a/drivers/pci/setup-bus.c
+++ b/drivers/pci/setup-bus.c
@@ -1346,6 +1346,9 @@ again:
 		goto enable_and_dump;
 
 	if (tried_times >= pci_try_num) {
+		if (pci_realloc_enable == enable_not_set)
+			printk(KERN_INFO "Some pci devices resources are not assigned, please try to boot with pci=realloc\n");
+
 		free_list(&fail_head);
 		goto enable_and_dump;
 	}
-- 
1.7.7

