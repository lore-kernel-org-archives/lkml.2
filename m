Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756896Ab2BYVzr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Feb 2012 16:55:47 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:41815 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756124Ab2BYVyy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Feb 2012 16:54:54 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 4/4] PCI: acpihp user __pci_remove_bus_device instead
Date: Sat, 25 Feb 2012 13:54:23 -0800
Message-Id: <1330206863-31381-5-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1330206863-31381-1-git-send-email-yinghai@kernel.org>
References: <1330206863-31381-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4F4958A9.003F,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pci_stop_bus_device get called before in the same loop.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 drivers/pci/hotplug/acpiphp_glue.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/drivers/pci/hotplug/acpiphp_glue.c
===================================================================
--- linux-2.6.orig/drivers/pci/hotplug/acpiphp_glue.c
+++ linux-2.6/drivers/pci/hotplug/acpiphp_glue.c
@@ -910,7 +910,7 @@ static int disable_device(struct acpiphp
 				disable_bridges(pdev->subordinate);
 				pci_disable_device(pdev);
 			}
-			pci_stop_and_remove_bus_device(pdev);
+			__pci_remove_bus_device(pdev);
 			pci_dev_put(pdev);
 		}
 	}
