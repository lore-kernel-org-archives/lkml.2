Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755839Ab2HGQVv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 12:21:51 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:51364 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755739Ab2HGQVs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 12:21:48 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>, Don Dutile <ddutile@redhat.com>,
        Yinghai Lu <yinghai@kernel.org>, Greg KH <gregkh@linuxfoundation.org>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Cc: Jiang Liu <jiang.liu@huawei.com>, Taku Izumi <izumi.taku@jp.fujitsu.com>,
        "Rafael J . Wysocki" <rjw@sisk.pl>,
        Yijing Wang <wangyijing@huawei.com>, Xinwei Hu <huxinwei@huawei.com>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        Jiang Liu <liuj97@gmail.com>
Subject: [RFC PATCH v1 22/22] PCI: unexport pci_root_buses
Date: Wed,  8 Aug 2012 00:11:02 +0800
Message-Id: <1344355862-2726-23-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1344355862-2726-1-git-send-email-jiang.liu@huawei.com>
References: <1344355862-2726-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now no module refers to pci_root_buses any more, unexport it.

Signed-off-by: Jiang Liu <liuj97@gmail.com>
---
 drivers/pci/probe.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 09517c3..dd48d7f 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -24,11 +24,9 @@ struct resource busn_resource = {
 };
 
 /*
- * Ugh.  Need to stop exporting this to modules.
  * Protected by pci_host_bridge_hotplug_{lock|unlock}().
  */
 LIST_HEAD(pci_root_buses);
-EXPORT_SYMBOL(pci_root_buses);
 
 static LIST_HEAD(pci_domain_busn_res_list);
 
-- 
1.7.9.5

