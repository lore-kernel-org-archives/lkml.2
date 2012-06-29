Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932343Ab2F2P4Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 11:56:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61983 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752881Ab2F2P4W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 11:56:22 -0400
From: Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH v3 2/3] kvm: Add missing KVM_IRQFD API documentation
To: avi@redhat.com, mst@redhat.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, jan.kiszka@siemens.com,
        cornelia.huck@de.ibm.com
Date: Fri, 29 Jun 2012 09:56:16 -0600
Message-ID: <20120629155614.30535.20777.stgit@bling.home>
In-Reply-To: <20120629154940.30535.17132.stgit@bling.home>
References: <20120629154940.30535.17132.stgit@bling.home>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
---

 Documentation/virtual/kvm/api.txt |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
index 310fe50..100acde 100644
--- a/Documentation/virtual/kvm/api.txt
+++ b/Documentation/virtual/kvm/api.txt
@@ -1965,6 +1965,22 @@ return the hash table order in the parameter.  (If the guest is using
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
+Allows setting an eventfd to directly trigger a guest interrupt.
+kvm_irqfd.fd specifies the file descriptor to use as the eventfd and
+kvm_irqfd.gsi specifies the irqchip pin toggled by this event.  When
+an event is triggered on the eventfd, an interrupt is injected into
+the guest using the specified gsi pin.  The irqfd is removed using
+the KVM_IRQFD_FLAG_DEASSIGN flag, specifying both kvm_irqfd.fd
+and kvm_irqfd.gsi.
+
 
 5. The kvm_run structure
 ------------------------

