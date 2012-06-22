Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759105Ab2FVWQD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 18:16:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22227 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755749Ab2FVWQB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 18:16:01 -0400
From: Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH 2/4] kvm: Add missing KVM_IRQFD API documentation
To: avi@redhat.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, jan.kiszka@siemens.com,
        mst@redhat.com
Date: Fri, 22 Jun 2012 16:15:50 -0600
Message-ID: <20120622221541.9858.37619.stgit@bling.home>
In-Reply-To: <20120622220040.9858.43665.stgit@bling.home>
References: <20120622220040.9858.43665.stgit@bling.home>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---

 Documentation/virtual/kvm/api.txt |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
index 310fe50..9b4cb2b 100644
--- a/Documentation/virtual/kvm/api.txt
+++ b/Documentation/virtual/kvm/api.txt
@@ -1965,6 +1965,23 @@ return the hash table order in the parameter.  (If the guest is using
 the virtualized real-mode area (VRMA) facility, the kernel will
 re-create the VMRA HPTEs on the next KVM_RUN of any vcpu.)
 
+4.76 KVM_IRQFD
+
+Capability: KVM_CAP_IRQFD
+Architectures: x86
+Type: vm ioctl
+Parameters: struct kvm_irqfd (in)
+Returns: 0 on success, -1 on error
+
+Allows setting an eventfd to directly trigger a guest interrupt
+kvm_irqfd.fd specifies the file descriptor to use as the eventfd and
+kvm_irqfd.gsi specifies the irqchip pin toggled by this event.  By
+default this interface only supports edge triggered interrupts,
+meaning the specified gsi is asserted and immediately de-asserted
+when the eventfd is triggered.  Specifying KVM_IRQFD_FLAG_DEASSIGN
+removes the previously set irqfd matching both kvm_irqfd.fd and
+kvm_irqfd.gsi.
+
 
 5. The kvm_run structure
 ------------------------

