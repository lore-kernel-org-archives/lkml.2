Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752049Ab2JIEtj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 00:49:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46020 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751060Ab2JIEth (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 00:49:37 -0400
From: Alex Williamson <alex.williamson@redhat.com>
Subject: [RFC PATCH 0/5] amd_iommu: Refactor IOMMU group and support virtual
 aliases
To: Joerg.Roedel@amd.com, florian@dazinger.net
Cc: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Date: Mon, 08 Oct 2012 22:49:28 -0600
Message-ID: <20121009044057.16302.44577.stgit@bling.home>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series is meant to refactor IOMMU group support in amd_iommu
to properly support virtual aliases.  If multiple devices alias to
the same virtual alias, they should be grouped together.  This code
also verifies whether the alias should be the root of the group vs
devices above the alias.

This seems to do the right thing on my system, but that's not saying
a lot since it doesn't do anything interesting with aliases.  I'd
appreciate if Joerg and Florian could test this on their systems.
Thanks,

Alex

---

Alex Williamson (5):
      amd_iommu: Properly account for virtual aliases in IOMMU groups
      amd_iommu: Split IOMMU group allocation and attach
      amd_iommu: Split upstream bus device lookup
      amd_iommu: Split IOMMU Group topology walk
      amd_iommu: Split IOMMU group initialization


 drivers/iommu/amd_iommu.c       |  184 ++++++++++++++++++++++++++++++---------
 drivers/iommu/amd_iommu_types.h |    1 
 2 files changed, 142 insertions(+), 43 deletions(-)
