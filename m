Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754010Ab2HDSJV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2012 14:09:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14334 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753780Ab2HDSJT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2012 14:09:19 -0400
From: Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH 0/2] Fix ACS path checking
To: joerg.roedel@amd.com, dwmw2@infradead.org
Cc: iommu@lists.linux-foundation.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, dsahern@gmail.com
Date: Sat, 04 Aug 2012 12:08:46 -0600
Message-ID: <20120804180155.6144.83332.stgit@bling.home>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Ahern reported an oops caused by passing a NULL start device
to pci_acs_path_enabled().  This can happen when a bus is created
for sr-iov devices without an associated bridge.  To handle this,
skip over to the parent bus and look for a bridge there.  Continue
until we find something or reach the root bus.

This works on my system, but still needs to be tested by David.  I'd
like to get this in for 3.6-rc2.

Joerg, I notice that ACS isn't getting enabled on my AMD system on
3.6-rc1.  I'll investigate more, but mention it in case you get to
it first.  Thanks,

Alex

---

Alex Williamson (2):
      amd-iommu: Fix ACS path checking
      intel-iommu: Fix ACS path checking


 drivers/iommu/amd_iommu.c   |   25 ++++++++++++++++++++++---
 drivers/iommu/intel-iommu.c |   25 ++++++++++++++++++++++---
 2 files changed, 44 insertions(+), 6 deletions(-)
