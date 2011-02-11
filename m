Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932231Ab1BKVYk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 16:24:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:20780 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756829Ab1BKVYj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 16:24:39 -0500
From: Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH 0/2] intel-iommu: Fix domain_ids exhaustion
To: dwmw2@infradead.org, iommu@lists.linux-foundation.org
Cc: alex.williamson@redhat.com, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, ddutile@redhat.com, chrisw@redhat.com
Date: Fri, 11 Feb 2011 14:24:29 -0700
Message-ID: <20110211211314.21983.83660.stgit@s20.home>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When we unbind a device from a driver, we don't properly unlink
the domain from the iommu, so we never free the domain id it
was using.  We're typically limited to something like 256 domain
ids, so a loop of unbinding and rebinding a device can exhaust
this pretty quickly.  If we're assigning the device to a KVM
guest, libvirt does exactly this each time the device is removed
from the host driver or added back.  When we do run out, we oops
the kernel.  Fix these.  Thanks,

Alex

---

Alex Williamson (2):
      intel-iommu: Fix get_domain_for_dev() error path
      intel-iommu: Unlink domain from iommu


 drivers/pci/intel-iommu.c |   12 ++++++++++--
 1 files changed, 10 insertions(+), 2 deletions(-)
