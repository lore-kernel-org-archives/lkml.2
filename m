Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932258Ab2F2P4J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 11:56:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36202 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932194Ab2F2P4F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 11:56:05 -0400
From: Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH v3 0/3] kvm: KVM_IRQFD cleanup, docs, sanitize flags
To: avi@redhat.com, mst@redhat.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, jan.kiszka@siemens.com,
        cornelia.huck@de.ibm.com
Date: Fri, 29 Jun 2012 09:56:00 -0600
Message-ID: <20120629154940.30535.17132.stgit@bling.home>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Before we start fiddling with what we can and can't add to KVM_IRQFD
we need to figure out if anyone has been sloppy in their use of the
ioctl flags.  This series has a minor cleanup to pass the struct
kvm_irqfd to seup functions rather than individual parameters, making
it more consistent with ioeventfd, adds API documentation for this
ioctl, and sanitizes the flags.  If anyone screams, we may have to
revert this last patch.  Thanks,

Alex

---

Alex Williamson (3):
      kvm: Sanitize KVM_IRQFD flags
      kvm: Add missing KVM_IRQFD API documentation
      kvm: Pass kvm_irqfd to functions


 Documentation/virtual/kvm/api.txt |   16 ++++++++++++++++
 include/linux/kvm_host.h          |    4 ++--
 virt/kvm/eventfd.c                |   23 +++++++++++++----------
 virt/kvm/kvm_main.c               |    2 +-
 4 files changed, 32 insertions(+), 13 deletions(-)
