Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757440Ab1CBUEb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 15:04:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:6002 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757375Ab1CBUE2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 15:04:28 -0500
Date: Wed, 2 Mar 2011 22:04:18 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] kvm: eventfd comment fixup
Message-ID: <20110302200418.GA5479@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Clarify a comment in kvm/eventfd.c: we do
rcu_assign_pointer without explicit synchronize_rcu
afterwards, and the reason this works is because we
use a spinlock to synch against another place
which does call synchronize_rcu.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

---

diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
index 2ca4535..e347b53 100644
--- a/virt/kvm/eventfd.c
+++ b/virt/kvm/eventfd.c
@@ -313,8 +313,9 @@ kvm_irqfd_deassign(struct kvm *kvm, int fd, int gsi)
 		if (irqfd->eventfd == eventfd && irqfd->gsi == gsi) {
 			/*
 			 * This rcu_assign_pointer is needed for when
-			 * another thread calls kvm_irqfd_update before
-			 * we flush workqueue below.
+			 * another thread calls kvm_irq_routing_update before
+			 * we flush workqueue below (we synchronize with
+			 * kvm_irq_routing_update using irqfds.lock).
 			 * It is paired with synchronize_rcu done by caller
 			 * of that function.
 			 */

-- 
MST
