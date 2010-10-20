Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752091Ab0JTIZh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 04:25:37 -0400
Received: from mga09.intel.com ([134.134.136.24]:8048 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751875Ab0JTIZc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 04:25:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,354,1283756400"; 
   d="scan'208";a="669073761"
From: Sheng Yang <sheng@linux.intel.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
Cc: kvm@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>,
        Sheng Yang <sheng@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/8] irq: Export irq_to_desc() to modules
Date: Wed, 20 Oct 2010 16:26:26 +0800
Message-Id: <1287563192-29685-3-git-send-email-sheng@linux.intel.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1287563192-29685-1-git-send-email-sheng@linux.intel.com>
References: <1287563192-29685-1-git-send-email-sheng@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KVM need to execute mask/unmask directly on MSI/MSI-X devices. The alternative
way of doing this is export mask_msi_irq(), but it lacks of checking if IRQ
type was really MSI.

Cc: linux-kernel@vger.kernel.org
Signed-off-by: Sheng Yang <sheng@linux.intel.com>
---
 kernel/irq/handle.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/kernel/irq/handle.c b/kernel/irq/handle.c
index 27e5c69..1ea2a24 100644
--- a/kernel/irq/handle.c
+++ b/kernel/irq/handle.c
@@ -139,6 +139,7 @@ struct irq_desc *irq_to_desc(unsigned int irq)
 {
 	return radix_tree_lookup(&irq_desc_tree, irq);
 }
+EXPORT_SYMBOL_GPL(irq_to_desc);
 
 void replace_irq_desc(unsigned int irq, struct irq_desc *desc)
 {
@@ -276,6 +277,7 @@ struct irq_desc *irq_to_desc(unsigned int irq)
 {
 	return (irq < NR_IRQS) ? irq_desc + irq : NULL;
 }
+EXPORT_SYMBOL_GPL(irq_to_desc);
 
 struct irq_desc *irq_to_desc_alloc_node(unsigned int irq, int node)
 {
-- 
1.7.0.1

