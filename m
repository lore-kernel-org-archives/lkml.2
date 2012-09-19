Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756972Ab2ISSz2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 14:55:28 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:47802 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753761Ab2ISSzN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 14:55:13 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>, Len Brown <lenb@kernel.org>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>,
        Jiang Liu <jiang.liu@huawei.com>, x86 <x86@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>,
        Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
        linux-ia64@vger.kernel.org
Subject: [PATCH 03/40] PCI, ia64: clear initial value for root info resources
Date: Wed, 19 Sep 2012 11:54:17 -0700
Message-Id: <1348080894-23412-4-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1348080894-23412-1-git-send-email-yinghai@kernel.org>
References: <CAE9FiQWFcVNKMnV1qaHchwCXfZuMpyxf_f7GQy3FZid9YuLD3w@mail.gmail.com>
 <1348080894-23412-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

after
	PCI, x86: clear initial value for root info resources

change ia64 code accordingly, because later ia64 will support root bus removal too.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: linux-ia64@vger.kernel.org
---
 arch/ia64/pci/pci.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/arch/ia64/pci/pci.c b/arch/ia64/pci/pci.c
index a7ebe94..5faa66c 100644
--- a/arch/ia64/pci/pci.c
+++ b/arch/ia64/pci/pci.c
@@ -295,7 +295,6 @@ static __devinit acpi_status add_window(struct acpi_resource *res, void *data)
 	window->resource.flags = flags;
 	window->resource.start = addr.minimum + offset;
 	window->resource.end = window->resource.start + addr.address_length - 1;
-	window->resource.child = NULL;
 	window->offset = offset;
 
 	if (insert_resource(root, &window->resource)) {
@@ -357,7 +356,7 @@ pci_acpi_scan_root(struct acpi_pci_root *root)
 			&windows);
 	if (windows) {
 		controller->window =
-			kmalloc_node(sizeof(*controller->window) * windows,
+			kzalloc_node(sizeof(*controller->window) * windows,
 				     GFP_KERNEL, controller->node);
 		if (!controller->window)
 			goto out2;
-- 
1.7.7

