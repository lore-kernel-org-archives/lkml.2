Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758860Ab2FVWPU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 18:15:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60949 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752988Ab2FVWPT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 18:15:19 -0400
From: Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH 0/4] kvm: level triggered irqfd support
To: avi@redhat.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, jan.kiszka@siemens.com,
        mst@redhat.com
Date: Fri, 22 Jun 2012 16:15:09 -0600
Message-ID: <20120622220040.9858.43665.stgit@bling.home>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's a refined series based on my previous RFC.  I now have this
working through VFIO-based device assignment in Qemu.  I've split
up the patches and tried to generalize the interface as one of
potentially a couple ways we might support level irqfds.  I also
tried to document the requirements around re-asserting interrupts
and expectations for avoiding races.

The last patch in the series is just an FYI/RFC of something I
expect we're also going to need.  We want to take advantage of KVM
irqchip, but not be dependent on it.  That means we'll want to come
up with a way for Qemu to notify drivers of an EOI.  We won't want
that interface to break when when enabling the in-kernel irqchip.
The needs are just different enough that I don't see how to combine
them together.  Thanks,

Alex

---

Alex Williamson (4):
      [RFC] kvm: eoi_eventfd
      kvm: Extend irqfd to support level interrupts
      kvm: Add missing KVM_IRQFD API documentation
      kvm: Pass kvm_irqfd to functions


 Documentation/virtual/kvm/api.txt |   46 ++++++++
 arch/x86/kvm/x86.c                |    2 
 include/linux/kvm.h               |   18 +++
 include/linux/kvm_host.h          |   11 ++
 virt/kvm/eventfd.c                |  201 ++++++++++++++++++++++++++++++++++---
 virt/kvm/kvm_main.c               |   11 ++
 6 files changed, 268 insertions(+), 21 deletions(-)
